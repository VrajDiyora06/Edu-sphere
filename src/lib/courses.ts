import { supabase, isSupabaseConfigured } from './supabaseClient';
import type { DbCourse, DbLesson, DbPublicProfile, CourseWithDetails } from '../types';

export interface CourseListItem extends DbCourse {
  instructor?: DbPublicProfile | null;
  lessons_count?: number;
  total_duration_minutes?: number;
}

/**
 * Fetch all published courses from Supabase with instructor info and lesson counts.
 */
export async function getPublishedCourses(): Promise<{
  data: CourseListItem[] | null;
  error: Error | null;
}> {
  if (!isSupabaseConfigured) {
    return { data: [], error: new Error('Supabase client is not configured.') };
  }

  try {
    const { data: coursesData, error: coursesError } = await supabase
      .from('courses')
      .select('id, title, slug, description, category, level, thumbnail_url, instructor_id, is_published, created_at, updated_at')
      .eq('is_published', true)
      .order('created_at', { ascending: false });

    if (coursesError) {
      return { data: null, error: coursesError };
    }

    if (!coursesData || coursesData.length === 0) {
      return { data: [], error: null };
    }

    // Fetch instructor details from public.public_profiles view
    const instructorIds = Array.from(new Set(coursesData.map((c) => c.instructor_id).filter(Boolean)));
    const instructorsMap: Record<string, DbPublicProfile> = {};

    if (instructorIds.length > 0) {
      const { data: profilesData } = await supabase
        .from('public_profiles')
        .select('id, full_name, avatar_url, role, bio, created_at')
        .in('id', instructorIds);

      if (profilesData) {
        profilesData.forEach((p) => {
          instructorsMap[p.id] = p;
        });
      }
    }

    // Fetch lesson summaries (count and duration)
    const courseIds = coursesData.map((c) => c.id);
    const { data: lessonsData } = await supabase
      .from('lessons')
      .select('id, course_id, duration_minutes')
      .in('course_id', courseIds);

    const lessonsStatsMap: Record<string, { count: number; durationMinutes: number }> = {};
    if (lessonsData) {
      lessonsData.forEach((l) => {
        if (!lessonsStatsMap[l.course_id]) {
          lessonsStatsMap[l.course_id] = { count: 0, durationMinutes: 0 };
        }
        lessonsStatsMap[l.course_id].count += 1;
        lessonsStatsMap[l.course_id].durationMinutes += l.duration_minutes || 0;
      });
    }

    const enriched: CourseListItem[] = coursesData.map((course) => ({
      ...course,
      instructor: instructorsMap[course.instructor_id] || null,
      lessons_count: lessonsStatsMap[course.id]?.count || 0,
      total_duration_minutes: lessonsStatsMap[course.id]?.durationMinutes || 0,
    }));

    return { data: enriched, error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Fetch a single course by its ID (UUID) or slug, along with its instructor and lessons.
 */
export async function getCourseByIdOrSlug(idOrSlug: string): Promise<{
  data: CourseWithDetails | null;
  error: Error | null;
}> {
  if (!isSupabaseConfigured) {
    return { data: null, error: new Error('Supabase client is not configured.') };
  }

  try {
    const isUuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(idOrSlug);
    let courseQuery = supabase
      .from('courses')
      .select('id, title, slug, description, category, level, thumbnail_url, instructor_id, is_published, created_at, updated_at');

    if (isUuid) {
      courseQuery = courseQuery.eq('id', idOrSlug);
    } else {
      courseQuery = courseQuery.eq('slug', idOrSlug);
    }

    const { data: course, error: courseError } = await courseQuery.maybeSingle();

    if (courseError) {
      return { data: null, error: courseError };
    }

    if (!course) {
      return { data: null, error: null };
    }

    // Fetch instructor public profile
    let instructor: DbPublicProfile | null = null;
    if (course.instructor_id) {
      const { data: profile } = await supabase
        .from('public_profiles')
        .select('id, full_name, avatar_url, role, bio, created_at')
        .eq('id', course.instructor_id)
        .maybeSingle();
      instructor = profile || null;
    }

    // Fetch lessons for this course ordered by order_index
    const { data: lessons, error: lessonsError } = await supabase
      .from('lessons')
      .select('id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at')
      .eq('course_id', course.id)
      .order('order_index', { ascending: true });

    if (lessonsError) {
      return {
        data: {
          ...course,
          instructor,
          lessons: [],
        },
        error: lessonsError,
      };
    }

    return {
      data: {
        ...course,
        instructor,
        lessons: (lessons as DbLesson[]) || [],
      },
      error: null,
    };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}
