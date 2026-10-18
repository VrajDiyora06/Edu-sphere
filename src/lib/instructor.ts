import { supabase, isSupabaseConfigured } from './supabaseClient';
import type { DbCourse, DbLesson, InstructorEnrollmentItem } from '../types';
import { deleteCourseCoverFromStorage, deleteLessonVideoFromStorage } from './media';

export interface InstructorCourseSummary extends DbCourse {
  lessonsCount: number;
  enrollmentsCount: number;
}

/**
 * Fetch all courses authored by the instructor (or all courses if admin/sysadmin).
 */
export async function getInstructorCourses(instructorId: string, isAdmin: boolean = false): Promise<{
  data: InstructorCourseSummary[] | null;
  error: Error | null;
}> {
  if (!isSupabaseConfigured) {
    return { data: [], error: new Error('Supabase client is not configured.') };
  }

  try {
    let query = supabase
      .from('courses')
      .select('id, title, slug, description, category, level, thumbnail_url, instructor_id, is_published, created_at, updated_at')
      .order('created_at', { ascending: false });

    if (!isAdmin) {
      query = query.eq('instructor_id', instructorId);
    }

    const { data: coursesData, error: coursesError } = await query;

    if (coursesError) {
      return { data: null, error: coursesError };
    }

    if (!coursesData || coursesData.length === 0) {
      return { data: [], error: null };
    }

    const courseIds = coursesData.map((c) => c.id);

    // Fetch lessons count per course
    const { data: lessonsData } = await supabase
      .from('lessons')
      .select('id, course_id')
      .in('course_id', courseIds);

    const lessonCounts: Record<string, number> = {};
    if (lessonsData) {
      lessonsData.forEach((l) => {
        lessonCounts[l.course_id] = (lessonCounts[l.course_id] || 0) + 1;
      });
    }

    // Fetch enrollment count per course (permitted by migration 006 for course owner)
    const { data: enrollmentsData } = await supabase
      .from('enrollments')
      .select('id, course_id')
      .in('course_id', courseIds);

    const enrollmentCounts: Record<string, number> = {};
    if (enrollmentsData) {
      enrollmentsData.forEach((e) => {
        enrollmentCounts[e.course_id] = (enrollmentCounts[e.course_id] || 0) + 1;
      });
    }

    const enriched: InstructorCourseSummary[] = coursesData.map((c) => ({
      ...c,
      lessonsCount: lessonCounts[c.id] || 0,
      enrollmentsCount: enrollmentCounts[c.id] || 0,
    }));

    return { data: enriched, error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Create a new course authored by the instructor.
 * Protected by PostgreSQL RLS (auth.uid() = instructor_id AND role IN ('instructor', 'admin', 'system_admin')).
 */
export async function createCourse(courseData: {
  title: string;
  slug: string;
  description: string;
  category: string;
  level: 'Beginner' | 'Intermediate' | 'Advanced';
  thumbnail_url?: string;
  instructor_id: string;
  is_published?: boolean;
}): Promise<{ data: DbCourse | null; error: Error | null }> {
  if (!isSupabaseConfigured) {
    return { data: null, error: new Error('Supabase client is not configured.') };
  }

  try {
    const { data, error } = await supabase
      .from('courses')
      .insert({
        title: courseData.title,
        slug: courseData.slug,
        description: courseData.description,
        category: courseData.category,
        level: courseData.level,
        thumbnail_url: courseData.thumbnail_url || null,
        instructor_id: courseData.instructor_id,
        is_published: courseData.is_published ?? true,
      })
      .select()
      .single();

    if (error) {
      return { data: null, error };
    }
    return { data, error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Update course metadata. Enforced by PostgreSQL RLS: instructor_id = auth.uid() OR is_admin().
 */
export async function updateCourse(
  courseId: string,
  updates: Partial<DbCourse>
): Promise<{ data: DbCourse | null; error: Error | null }> {
  if (!isSupabaseConfigured) {
    return { data: null, error: new Error('Supabase client is not configured.') };
  }

  try {
    const { data, error } = await supabase
      .from('courses')
      .update({
        ...updates,
        updated_at: new Date().toISOString(),
      })
      .eq('id', courseId)
      .select()
      .single();

    if (error) {
      return { data: null, error };
    }
    return { data, error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Delete a course.
 * Enforced by PostgreSQL delete_course database function / RLS:
 * - Instructors can delete ONLY courses they own (instructor_id = auth.uid())
 * - Administrators and system_administrators can delete any course
 * - Students and guests are strictly blocked
 * Safely removes child lessons, quizzes, questions, attempts, assignments, submissions, enrollments, and storage files.
 */
export async function deleteCourse(courseId: string): Promise<{ success: boolean; error: Error | null }> {
  if (!isSupabaseConfigured) {
    return { success: false, error: new Error('Supabase client is not configured.') };
  }

  try {
    const { data: course } = await supabase
      .from('courses')
      .select('thumbnail_url')
      .eq('id', courseId)
      .maybeSingle();

    // Call atomic stored procedure delete_course
    const { error: rpcError } = await supabase.rpc('delete_course', {
      p_course_id: courseId,
    });

    if (!rpcError) {
      if (course?.thumbnail_url) {
        await deleteCourseCoverFromStorage(course.thumbnail_url);
      }
      return { success: true, error: null };
    }

    // If RPC failed due to permission denial, return the error directly
    if (rpcError.code === '42501' || rpcError.message?.toLowerCase().includes('unauthorized')) {
      return { success: false, error: rpcError };
    }

    // Fallback: If RPC does not exist (PGRST202), attempt direct DELETE on courses table (protected by RLS)
    const { error: delError } = await supabase.from('courses').delete().eq('id', courseId);
    if (delError) {
      return { success: false, error: delError };
    }
    if (course?.thumbnail_url) {
      await deleteCourseCoverFromStorage(course.thumbnail_url);
    }
    return { success: true, error: null };
  } catch (err) {
    return { success: false, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Fetch all lessons for a specific course.
 */
export async function getLessonsForCourse(courseId: string): Promise<{
  data: DbLesson[] | null;
  error: Error | null;
}> {
  if (!isSupabaseConfigured) {
    return { data: [], error: new Error('Supabase client is not configured.') };
  }

  try {
    const { data, error } = await supabase
      .from('lessons')
      .select('id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at')
      .eq('course_id', courseId)
      .order('order_index', { ascending: true });

    if (error) {
      return { data: null, error };
    }
    return { data: data || [], error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Add a lesson to a course.
 * Protected by PostgreSQL RLS: course instructor_id = auth.uid() OR is_admin().
 */
export async function createLesson(lessonData: {
  course_id: string;
  title: string;
  content?: string;
  video_url?: string;
  duration_minutes: number;
  is_free_preview: boolean;
  order_index: number;
}): Promise<{ data: DbLesson | null; error: Error | null }> {
  if (!isSupabaseConfigured) {
    return { data: null, error: new Error('Supabase client is not configured.') };
  }

  try {
    const { data, error } = await supabase
      .from('lessons')
      .insert({
        course_id: lessonData.course_id,
        title: lessonData.title,
        content: lessonData.content || '',
        video_url: lessonData.video_url || null,
        duration_minutes: lessonData.duration_minutes,
        is_free_preview: lessonData.is_free_preview,
        order_index: lessonData.order_index,
      })
      .select()
      .single();

    if (error) {
      return { data: null, error };
    }
    return { data, error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Update a lesson. Protected by PostgreSQL RLS.
 */
export async function updateLesson(
  lessonId: string,
  updates: Partial<DbLesson>
): Promise<{ data: DbLesson | null; error: Error | null }> {
  if (!isSupabaseConfigured) {
    return { data: null, error: new Error('Supabase client is not configured.') };
  }

  try {
    const { data, error } = await supabase
      .from('lessons')
      .update(updates)
      .eq('id', lessonId)
      .select()
      .single();

    if (error) {
      return { data: null, error };
    }
    return { data, error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Delete a lesson. Protected by PostgreSQL RLS.
 */
export async function deleteLesson(lessonId: string): Promise<{ success: boolean; error: Error | null }> {
  if (!isSupabaseConfigured) {
    return { success: false, error: new Error('Supabase client is not configured.') };
  }

  try {
    const { data: lesson } = await supabase
      .from('lessons')
      .select('video_url')
      .eq('id', lessonId)
      .maybeSingle();

    const { error } = await supabase.from('lessons').delete().eq('id', lessonId);
    if (error) {
      return { success: false, error };
    }

    if (lesson?.video_url) {
      await deleteLessonVideoFromStorage(lesson.video_url);
    }

    return { success: true, error: null };
  } catch (err) {
    return { success: false, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Fetch enrollments for an instructor's course.
 * Protected by PostgreSQL RLS: course instructor_id = auth.uid() OR is_admin().
 */
export async function getCourseEnrollmentsForInstructor(courseId: string): Promise<{
  data: InstructorEnrollmentItem[] | null;
  error: Error | null;
}> {
  if (!isSupabaseConfigured) {
    return { data: [], error: new Error('Supabase client is not configured.') };
  }

  try {
    const { data: enrollments, error } = await supabase
      .from('enrollments')
      .select('id, student_id, course_id, enrolled_at, progress_percent, is_completed, completed_at')
      .eq('course_id', courseId)
      .order('enrolled_at', { ascending: false });

    if (error) {
      return { data: null, error };
    }

    if (!enrollments || enrollments.length === 0) {
      return { data: [], error: null };
    }

    // Fetch student profile names
    const studentIds = Array.from(new Set(enrollments.map((e) => e.student_id)));
    const { data: profiles } = await supabase
      .from('public_profiles')
      .select('id, full_name, avatar_url')
      .in('id', studentIds);

    const profilesMap: Record<string, { full_name: string; avatar_url: string | null }> = {};
    if (profiles) {
      profiles.forEach((p) => {
        profilesMap[p.id] = { full_name: p.full_name, avatar_url: p.avatar_url };
      });
    }

    const items: InstructorEnrollmentItem[] = enrollments.map((e) => ({
      ...e,
      student: profilesMap[e.student_id] || { full_name: 'Student Learner', avatar_url: null },
    }));

    return { data: items, error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}
