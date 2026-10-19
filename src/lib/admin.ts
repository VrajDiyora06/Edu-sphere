import { supabase, isSupabaseConfigured } from './supabaseClient';
import type { DbProfile, DbCourse, DbAnnouncement, SystemDiagnosticItem, UserRole } from '../types';
import { deleteCourseCoverFromStorage } from './media';

export interface AdminCourseSummary extends DbCourse {
  instructor_name?: string;
  enrollments_count?: number;
  lessons_count?: number;
}

export interface PlatformMetrics {
  totalUsers: number;
  totalStudents: number;
  totalInstructors: number;
  totalAdmins: number;
  totalCourses: number;
  publishedCourses: number;
  totalEnrollments: number;
  completedEnrollments: number;
}

/**
 * Fetch all registered user profiles.
 * Protected by PostgreSQL RLS: only accessible when public.is_admin() evaluates to true.
 */
export async function getAllUserProfiles(): Promise<{
  data: DbProfile[] | null;
  error: Error | null;
}> {
  if (!isSupabaseConfigured) {
    return { data: [], error: new Error('Supabase client is not configured.') };
  }

  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('id, email, full_name, role, avatar_url, bio, created_at, updated_at')
      .order('created_at', { ascending: false });

    if (error) {
      return { data: null, error };
    }
    return { data: (data as DbProfile[]) || [], error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Change a user's role using the database procedure admin_set_user_role.
 * Database enforces:
 * - Caller must have role admin or system_admin
 * - Ordinary admin cannot assign system_admin
 */
export async function updateUserRole(
  targetUserId: string,
  newRole: UserRole
): Promise<{ success: boolean; error: Error | null }> {
  if (!isSupabaseConfigured) {
    return { success: false, error: new Error('Supabase client is not configured.') };
  }

  try {
    const { error } = await supabase.rpc('admin_set_user_role', {
      p_target_user_id: targetUserId,
      p_new_role: newRole,
    });

    if (error) {
      return { success: false, error };
    }
    return { success: true, error: null };
  } catch (err) {
    return { success: false, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Fetch all courses across EduSphere for administrator oversight.
 */
export async function getAllCoursesAdmin(): Promise<{
  data: AdminCourseSummary[] | null;
  error: Error | null;
}> {
  if (!isSupabaseConfigured) {
    return { data: [], error: new Error('Supabase client is not configured.') };
  }

  try {
    const { data: courses, error: coursesError } = await supabase
      .from('courses')
      .select('id, title, slug, description, category, level, thumbnail_url, instructor_id, is_published, created_at, updated_at')
      .order('created_at', { ascending: false });

    if (coursesError) {
      return { data: null, error: coursesError };
    }

    if (!courses || courses.length === 0) {
      return { data: [], error: null };
    }

    const courseIds = courses.map((c) => c.id);
    const instructorIds = Array.from(new Set(courses.map((c) => c.instructor_id)));

    // Fetch instructor names
    const { data: instructors } = await supabase
      .from('public_profiles')
      .select('id, full_name')
      .in('id', instructorIds);

    const instructorsMap: Record<string, string> = {};
    if (instructors) {
      instructors.forEach((i) => {
        instructorsMap[i.id] = i.full_name;
      });
    }

    // Fetch lessons counts
    const { data: lessons } = await supabase
      .from('lessons')
      .select('id, course_id')
      .in('course_id', courseIds);

    const lessonCounts: Record<string, number> = {};
    if (lessons) {
      lessons.forEach((l) => {
        lessonCounts[l.course_id] = (lessonCounts[l.course_id] || 0) + 1;
      });
    }

    // Fetch enrollments counts (admin has global select permission)
    const { data: enrollments } = await supabase
      .from('enrollments')
      .select('id, course_id')
      .in('course_id', courseIds);

    const enrollmentCounts: Record<string, number> = {};
    if (enrollments) {
      enrollments.forEach((e) => {
        enrollmentCounts[e.course_id] = (enrollmentCounts[e.course_id] || 0) + 1;
      });
    }

    const summaries: AdminCourseSummary[] = courses.map((c) => ({
      ...c,
      instructor_name: instructorsMap[c.instructor_id] || 'Unknown Instructor',
      lessons_count: lessonCounts[c.id] || 0,
      enrollments_count: enrollmentCounts[c.id] || 0,
    }));

    return { data: summaries, error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Toggle course publication status. Protected by RLS: is_admin().
 */
export async function toggleCoursePublishAdmin(
  courseId: string,
  isPublished: boolean
): Promise<{ success: boolean; error: Error | null }> {
  if (!isSupabaseConfigured) {
    return { success: false, error: new Error('Supabase client is not configured.') };
  }

  try {
    const { error } = await supabase
      .from('courses')
      .update({ is_published: isPublished, updated_at: new Date().toISOString() })
      .eq('id', courseId);

    if (error) {
      return { success: false, error };
    }
    return { success: true, error: null };
  } catch (err) {
    return { success: false, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Delete a course as an administrator.
 * Protected by PostgreSQL delete_course database function / RLS:
 * - Administrators and system_admins can delete any course
 * - Safely cascades across child materials, submissions, and storage objects
 */
export async function deleteCourseAdmin(courseId: string): Promise<{ success: boolean; error: Error | null }> {
  if (!isSupabaseConfigured) {
    return { success: false, error: new Error('Supabase client is not configured.') };
  }

  try {
    const { data: course } = await supabase
      .from('courses')
      .select('thumbnail_url')
      .eq('id', courseId)
      .maybeSingle();

    const { error: rpcError } = await supabase.rpc('delete_course', {
      p_course_id: courseId,
    });

    if (!rpcError) {
      if (course?.thumbnail_url) {
        await deleteCourseCoverFromStorage(course.thumbnail_url);
      }
      return { success: true, error: null };
    }

    if (rpcError.code === '42501' || rpcError.message?.toLowerCase().includes('unauthorized')) {
      return { success: false, error: rpcError };
    }

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
 * Fetch announcements from public.announcements.
 */
export async function getAdminAnnouncements(): Promise<{
  data: DbAnnouncement[] | null;
  error: Error | null;
}> {
  if (!isSupabaseConfigured) {
    return { data: [], error: new Error('Supabase client is not configured.') };
  }

  try {
    const { data, error } = await supabase
      .from('announcements')
      .select('id, title, content, priority, author_id, is_published, created_at, updated_at')
      .order('created_at', { ascending: false });

    if (error) {
      return { data: null, error };
    }
    return { data: (data as DbAnnouncement[]) || [], error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Create announcement. Protected by RLS: public.is_admin() AND auth.uid() = author_id.
 */
export async function createAnnouncement(data: {
  title: string;
  content: string;
  priority: 'low' | 'normal' | 'high' | 'urgent';
  author_id: string;
  is_published: boolean;
}): Promise<{ data: DbAnnouncement | null; error: Error | null }> {
  if (!isSupabaseConfigured) {
    return { data: null, error: new Error('Supabase client is not configured.') };
  }

  try {
    const { data: result, error } = await supabase
      .from('announcements')
      .insert({
        title: data.title,
        content: data.content,
        priority: data.priority,
        author_id: data.author_id,
        is_published: data.is_published,
      })
      .select()
      .single();

    if (error) {
      return { data: null, error };
    }
    return { data: result as DbAnnouncement, error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Delete announcement. Protected by RLS: public.is_admin().
 */
export async function deleteAnnouncement(
  id: string
): Promise<{ success: boolean; error: Error | null }> {
  if (!isSupabaseConfigured) {
    return { success: false, error: new Error('Supabase client is not configured.') };
  }

  try {
    const { error } = await supabase.from('announcements').delete().eq('id', id);
    if (error) {
      return { success: false, error };
    }
    return { success: true, error: null };
  } catch (err) {
    return { success: false, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Fetch System RBAC Diagnostics using get_system_rbac_diagnostics RPC.
 * Only succeeds if caller has role 'system_admin'.
 */
export async function getSystemDiagnostics(): Promise<{
  data: SystemDiagnosticItem[] | null;
  error: Error | null;
}> {
  if (!isSupabaseConfigured) {
    return { data: null, error: new Error('Supabase client is not configured.') };
  }

  try {
    const { data, error } = await supabase.rpc('get_system_rbac_diagnostics');
    if (error) {
      return { data: null, error };
    }
    return { data: (data as SystemDiagnosticItem[]) || [], error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Platform Reports / Analytics aggregator.
 */
export async function getPlatformMetrics(): Promise<{
  data: PlatformMetrics | null;
  error: Error | null;
}> {
  if (!isSupabaseConfigured) {
    return { data: null, error: new Error('Supabase client is not configured.') };
  }

  try {
    const [profilesRes, coursesRes, enrollmentsRes] = await Promise.all([
      supabase.from('profiles').select('id, role'),
      supabase.from('courses').select('id, is_published'),
      supabase.from('enrollments').select('id, is_completed'),
    ]);

    const profiles = profilesRes.data || [];
    const courses = coursesRes.data || [];
    const enrollments = enrollmentsRes.data || [];

    const metrics: PlatformMetrics = {
      totalUsers: profiles.length,
      totalStudents: profiles.filter((p) => p.role === 'student').length,
      totalInstructors: profiles.filter((p) => p.role === 'instructor').length,
      totalAdmins: profiles.filter((p) => p.role === 'admin' || p.role === 'system_admin').length,
      totalCourses: courses.length,
      publishedCourses: courses.filter((c) => c.is_published).length,
      totalEnrollments: enrollments.length,
      completedEnrollments: enrollments.filter((e) => e.is_completed).length,
    };

    return { data: metrics, error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}
