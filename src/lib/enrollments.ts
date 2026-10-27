import { supabase, isSupabaseConfigured } from './supabaseClient';
import type { DbEnrollment, EnrolledCourseItem, DbCourse, DbPublicProfile } from '../types';

/**
 * Check whether a student is already enrolled in a specific course.
 * Enforces role restriction: only 'student' accounts can have learning enrollments.
 */
export async function checkEnrollment(
  courseId: string,
  studentId: string,
  userRole?: string
): Promise<{
  isEnrolled: boolean;
  enrollment: DbEnrollment | null;
  error: Error | null;
}> {
  if (userRole && userRole !== 'student') {
    return { isEnrolled: false, enrollment: null, error: null };
  }

  if (!courseId || !studentId) {
    return { isEnrolled: false, enrollment: null, error: null };
  }

  if (!isSupabaseConfigured) {
    return { isEnrolled: false, enrollment: null, error: new Error('Supabase client is not configured.') };
  }

  try {
    const { data, error } = await supabase
      .from('enrollments')
      .select('id, student_id, course_id, enrolled_at, progress_percent, is_completed, completed_at')
      .eq('course_id', courseId)
      .eq('student_id', studentId)
      .maybeSingle();

    if (error) {
      return { isEnrolled: false, enrollment: null, error };
    }

    if (data) {
      return {
        isEnrolled: true,
        enrollment: data as DbEnrollment,
        error: null,
      };
    }
  } catch (err) {
    return { isEnrolled: false, enrollment: null, error: err instanceof Error ? err : new Error(String(err)) };
  }

  return {
    isEnrolled: false,
    enrollment: null,
    error: null,
  };
}

/**
 * Enroll a student in a course, handling duplicate enrollment constraint gracefully.
 * Enforces role restriction (only 'student' accounts permitted).
 */
export async function enrollInCourse(
  courseId: string,
  studentId: string,
  userRole?: string
): Promise<{
  success: boolean;
  alreadyEnrolled: boolean;
  data: DbEnrollment | null;
  error: Error | null;
}> {
  if (!isSupabaseConfigured) {
    return {
      success: false,
      alreadyEnrolled: false,
      data: null,
      error: new Error('Supabase client is not configured.'),
    };
  }

  // Pre-validate role if provided: only 'student' role is permitted to enroll
  if (userRole && userRole !== 'student') {
    return {
      success: false,
      alreadyEnrolled: false,
      data: null,
      error: new Error(`Enrollment is restricted to student accounts (current role: ${userRole}).`),
    };
  }

  try {
    // 1. Try atomic database procedure enroll_in_course
    const { data: rpcData, error: rpcError } = await supabase.rpc('enroll_in_course', {
      p_course_id: courseId,
    });

    if (!rpcError && rpcData) {
      const enr = rpcData.enrollment as DbEnrollment;
      return {
        success: true,
        alreadyEnrolled: !!rpcData.already_enrolled,
        data: enr,
        error: null,
      };
    }

    // If RPC returned an explicit authorization exception, reject immediately
    if (rpcError && (rpcError.code === '42501' || rpcError.message.includes('student role') || rpcError.message.includes('Access denied'))) {
      return {
        success: false,
        alreadyEnrolled: false,
        data: null,
        error: rpcError,
      };
    }

    // 2. Direct table insert fallback (enforced by RLS policy)
    const { data, error } = await supabase
      .from('enrollments')
      .insert({
        course_id: courseId,
        student_id: studentId,
        progress_percent: 0,
        is_completed: false,
      })
      .select('id, student_id, course_id, enrolled_at, progress_percent, is_completed, completed_at')
      .single();

    if (error) {
      const isUniqueViolation =
        error.code === '23505' ||
        error.message.includes('unique_student_course_enrollment') ||
        error.message.toLowerCase().includes('duplicate key');

      if (isUniqueViolation) {
        const { data: existing } = await supabase
          .from('enrollments')
          .select('id, student_id, course_id, enrolled_at, progress_percent, is_completed, completed_at')
          .eq('course_id', courseId)
          .eq('student_id', studentId)
          .maybeSingle();

        return {
          success: true,
          alreadyEnrolled: true,
          data: (existing as DbEnrollment) || null,
          error: null,
        };
      }

      return {
        success: false,
        alreadyEnrolled: false,
        data: null,
        error,
      };
    }

    if (data) {
      return {
        success: true,
        alreadyEnrolled: false,
        data: data as DbEnrollment,
        error: null,
      };
    }

    return {
      success: false,
      alreadyEnrolled: false,
      data: null,
      error: rpcError || new Error('Failed to enroll in course.'),
    };
  } catch (err) {
    return {
      success: false,
      alreadyEnrolled: false,
      data: null,
      error: err instanceof Error ? err : new Error(String(err)),
    };
  }
}

/**
 * Fetch all enrollments for a student, enriched with course details and instructor information.
 */
export async function getStudentEnrollments(studentId: string): Promise<{
  data: EnrolledCourseItem[] | null;
  error: Error | null;
}> {
  if (!isSupabaseConfigured || !studentId) {
    return { data: [], error: null };
  }

  try {
    // 1. Fetch user's enrollments ordered by enrolled_at descending
    const { data: enrollments, error: enrollmentsError } = await supabase
      .from('enrollments')
      .select('id, student_id, course_id, enrolled_at, progress_percent, is_completed, completed_at')
      .eq('student_id', studentId)
      .order('enrolled_at', { ascending: false });

    if (enrollmentsError) {
      return { data: null, error: enrollmentsError };
    }

    if (!enrollments || enrollments.length === 0) {
      return { data: [], error: null };
    }

    // 2. Fetch associated courses
    const courseIds = enrollments.map((e) => e.course_id);
    const { data: coursesData, error: coursesError } = await supabase
      .from('courses')
      .select('id, title, slug, description, category, level, thumbnail_url, instructor_id, is_published, created_at, updated_at')
      .in('id', courseIds);

    if (coursesError) {
      return { data: null, error: coursesError };
    }

    const coursesMap = new Map<string, DbCourse>();
    coursesData?.forEach((c) => coursesMap.set(c.id, c));

    // 3. Fetch instructor profiles from public_profiles view
    const instructorIds = Array.from(
      new Set(coursesData?.map((c) => c.instructor_id).filter(Boolean) || [])
    );

    const instructorsMap = new Map<string, DbPublicProfile>();
    if (instructorIds.length > 0) {
      const { data: profiles } = await supabase
        .from('public_profiles')
        .select('id, full_name, avatar_url, role, bio, created_at')
        .in('id', instructorIds);

      profiles?.forEach((p) => instructorsMap.set(p.id, p));
    }

    // 4. Fetch lessons count for enrolled courses
    const { data: lessonsData } = await supabase
      .from('lessons')
      .select('id, course_id')
      .in('course_id', courseIds);

    const lessonsCountMap = new Map<string, number>();
    lessonsData?.forEach((l) => {
      lessonsCountMap.set(l.course_id, (lessonsCountMap.get(l.course_id) || 0) + 1);
    });

    const enriched: EnrolledCourseItem[] = enrollments.map((enr) => {
      const course = coursesMap.get(enr.course_id) || null;
      const instructor = course ? instructorsMap.get(course.instructor_id) || null : null;
      const lessonsCount = lessonsCountMap.get(enr.course_id) || 0;

      return {
        ...enr,
        course,
        instructor,
        lessons_count: lessonsCount,
      };
    });

    return { data: enriched, error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Update a student's enrollment progress in public.enrollments.
 * RLS policy "Students update own enrollment progress" guarantees
 * students can only update their own record (auth.uid() = student_id).
 */
export async function updateEnrollmentProgress(
  courseId: string,
  studentId: string,
  updates: {
    progress_percent: number;
    is_completed: boolean;
    completed_at: string | null;
  }
): Promise<{
  success: boolean;
  data: DbEnrollment | null;
  error: Error | null;
}> {
  if (!isSupabaseConfigured || !courseId || !studentId) {
    return {
      success: false,
      data: null,
      error: new Error('Missing course or student identification.'),
    };
  }

  try {
    const { data, error } = await supabase
      .from('enrollments')
      .update({
        progress_percent: Math.min(100, Math.max(0, updates.progress_percent)),
        is_completed: updates.is_completed,
        completed_at: updates.completed_at,
      })
      .eq('course_id', courseId)
      .eq('student_id', studentId)
      .select('id, student_id, course_id, enrolled_at, progress_percent, is_completed, completed_at')
      .single();

    if (error) {
      return { success: false, data: null, error };
    }

    return { success: true, data: data as DbEnrollment, error: null };
  } catch (err) {
    return { success: false, data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

export function verifyActiveStudentAccess(enrollment: { status?: string; is_active?: boolean } | null): boolean {
  if (!enrollment) return false;
  if (typeof enrollment.is_active === 'boolean') {
    return enrollment.is_active;
  }
  return enrollment.status === 'active' || enrollment.status === 'enrolled' || enrollment.status === 'completed';
}
