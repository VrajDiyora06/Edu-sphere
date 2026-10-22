-- Migration: 20261022000013_media_storage_buckets_and_policies.sql
-- Description: Direct media uploads for course cover images (course-thumbnails) and lesson videos (lesson-videos) with secure RLS policies and cascade cleanup.

BEGIN;

-- ============================================================================
-- 1. Create or Update Storage Buckets
-- ============================================================================

-- A. Course Cover Thumbnails Bucket (Public read, max 5MB, JPG/PNG/WebP)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'course-thumbnails',
  'course-thumbnails',
  TRUE,
  5242880, -- 5 MB
  ARRAY[
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/webp'
  ]
)
ON CONFLICT (id) DO UPDATE SET
  public = TRUE,
  file_size_limit = 5242880,
  allowed_mime_types = ARRAY[
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/webp'
  ];

-- B. Lesson Videos Bucket (Private, max 200MB, MP4/WebM)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'lesson-videos',
  'lesson-videos',
  FALSE,
  209715200, -- 200 MB
  ARRAY[
    'video/mp4',
    'video/webm'
  ]
)
ON CONFLICT (id) DO UPDATE SET
  public = FALSE,
  file_size_limit = 209715200,
  allowed_mime_types = ARRAY[
    'video/mp4',
    'video/webm'
  ];

-- ============================================================================
-- 2. Storage Policies for Course Thumbnails (course-thumbnails)
-- ============================================================================

-- Public read access: Anyone (including unauthenticated guests) can view course covers in catalog
DROP POLICY IF EXISTS "Public can view course thumbnails" ON storage.objects;
CREATE POLICY "Public can view course thumbnails"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'course-thumbnails');

-- Instructors and admins can upload course cover images
-- Permitted if caller is admin OR verified instructor uploading under their user ID or owned course ID
DROP POLICY IF EXISTS "Instructors and admins upload course thumbnails" ON storage.objects;
CREATE POLICY "Instructors and admins upload course thumbnails"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'course-thumbnails' AND (
      public.is_admin() OR
      (
        EXISTS (
          SELECT 1 FROM public.profiles
          WHERE id = auth.uid() AND role IN ('instructor', 'admin', 'system_admin')
        ) AND (
          split_part(name, '/', 1) = auth.uid()::text OR
          EXISTS (
            SELECT 1 FROM public.courses c
            WHERE c.id::text = split_part(name, '/', 1)
              AND c.instructor_id = auth.uid()
          )
        )
      )
    )
  );

-- Instructors and admins can update course cover images
DROP POLICY IF EXISTS "Instructors and admins update course thumbnails" ON storage.objects;
CREATE POLICY "Instructors and admins update course thumbnails"
  ON storage.objects FOR UPDATE
  USING (
    bucket_id = 'course-thumbnails' AND (
      public.is_admin() OR
      (
        EXISTS (
          SELECT 1 FROM public.profiles
          WHERE id = auth.uid() AND role IN ('instructor', 'admin', 'system_admin')
        ) AND (
          split_part(name, '/', 1) = auth.uid()::text OR
          EXISTS (
            SELECT 1 FROM public.courses c
            WHERE c.id::text = split_part(name, '/', 1)
              AND c.instructor_id = auth.uid()
          )
        )
      )
    )
  );

-- Instructors and admins can delete course cover images
DROP POLICY IF EXISTS "Instructors and admins delete course thumbnails" ON storage.objects;
CREATE POLICY "Instructors and admins delete course thumbnails"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'course-thumbnails' AND (
      public.is_admin() OR
      (
        EXISTS (
          SELECT 1 FROM public.profiles
          WHERE id = auth.uid() AND role IN ('instructor', 'admin', 'system_admin')
        ) AND (
          split_part(name, '/', 1) = auth.uid()::text OR
          EXISTS (
            SELECT 1 FROM public.courses c
            WHERE c.id::text = split_part(name, '/', 1)
              AND c.instructor_id = auth.uid()
          )
        )
      )
    )
  );

-- ============================================================================
-- 3. Storage Policies for Lesson Videos (lesson-videos)
-- ============================================================================

-- Authorized users can read / stream lesson videos:
-- Admins, course instructors, enrolled students, or visitors viewing free preview lessons
DROP POLICY IF EXISTS "Authorized users read lesson videos" ON storage.objects;
CREATE POLICY "Authorized users read lesson videos"
  ON storage.objects FOR SELECT
  USING (
    bucket_id = 'lesson-videos' AND (
      public.is_admin() OR
      EXISTS (
        SELECT 1 FROM public.courses c
        WHERE c.id::text = split_part(name, '/', 1) AND (
          c.instructor_id = auth.uid() OR
          public.is_enrolled_in_course(c.id) OR
          EXISTS (
            SELECT 1 FROM public.lessons l
            WHERE l.course_id = c.id
              AND (
                l.id::text = split_part(name, '/', 2) OR
                l.video_url = storage.objects.name OR
                l.video_url LIKE '%' || storage.objects.name
              )
              AND l.is_free_preview = TRUE
          )
        )
      )
    )
  );

-- Instructors and admins can upload lesson videos for courses they own
DROP POLICY IF EXISTS "Instructors and admins upload lesson videos" ON storage.objects;
CREATE POLICY "Instructors and admins upload lesson videos"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'lesson-videos' AND (
      public.is_admin() OR
      EXISTS (
        SELECT 1 FROM public.courses c
        WHERE c.id::text = split_part(name, '/', 1)
          AND c.instructor_id = auth.uid()
      )
    )
  );

-- Instructors and admins can update lesson videos
DROP POLICY IF EXISTS "Instructors and admins update lesson videos" ON storage.objects;
CREATE POLICY "Instructors and admins update lesson videos"
  ON storage.objects FOR UPDATE
  USING (
    bucket_id = 'lesson-videos' AND (
      public.is_admin() OR
      EXISTS (
        SELECT 1 FROM public.courses c
        WHERE c.id::text = split_part(name, '/', 1)
          AND c.instructor_id = auth.uid()
      )
    )
  );

-- Instructors and admins can delete lesson videos
DROP POLICY IF EXISTS "Instructors and admins delete lesson videos" ON storage.objects;
CREATE POLICY "Instructors and admins delete lesson videos"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'lesson-videos' AND (
      public.is_admin() OR
      EXISTS (
        SELECT 1 FROM public.courses c
        WHERE c.id::text = split_part(name, '/', 1)
          AND c.instructor_id = auth.uid()
      )
    )
  );

-- ============================================================================
-- 4. Update public.delete_course() procedure to clean up media files
-- ============================================================================

CREATE OR REPLACE FUNCTION public.delete_course(p_course_id UUID)
RETURNS TABLE (
  deleted_course_id UUID,
  title TEXT,
  status TEXT
) AS $$
DECLARE
  v_caller_id UUID := auth.uid();
  v_caller_role TEXT;
  v_course RECORD;
BEGIN
  -- 1. Authentication check
  IF v_caller_id IS NULL THEN
    RAISE EXCEPTION 'Authentication required to delete courses' USING ERRCODE = '42501';
  END IF;

  -- 2. Fetch caller role
  SELECT role INTO v_caller_role
  FROM public.profiles
  WHERE id = v_caller_id;

  -- 3. Fetch course
  SELECT id, title, instructor_id, thumbnail_url INTO v_course
  FROM public.courses
  WHERE id = p_course_id;

  IF v_course.id IS NULL THEN
    RAISE EXCEPTION 'Course not found' USING ERRCODE = 'P0002';
  END IF;

  -- 4. Role Authorization Boundary Check
  IF v_caller_role IN ('admin', 'system_admin') THEN
    NULL;
  ELSIF v_caller_role = 'instructor' THEN
    IF v_course.instructor_id != v_caller_id THEN
      RAISE EXCEPTION 'Unauthorized: Instructors can only delete courses they own' USING ERRCODE = '42501';
    END IF;
  ELSE
    RAISE EXCEPTION 'Unauthorized: Course deletion restricted to course instructors and administrators' USING ERRCODE = '42501';
  END IF;

  -- 5. Clean up associated storage objects
  BEGIN
    -- Assignment instructions and submissions
    DELETE FROM storage.objects
    WHERE bucket_id = 'assignment-instructions'
      AND name IN (
        SELECT instructions_file_path FROM public.assignments 
        WHERE course_id = p_course_id AND instructions_file_path IS NOT NULL
      );

    DELETE FROM storage.objects
    WHERE bucket_id = 'assignment-submissions'
      AND name IN (
        SELECT s.file_path FROM public.assignment_submissions s
        JOIN public.assignments a ON a.id = s.assignment_id
        WHERE a.course_id = p_course_id AND s.file_path IS NOT NULL
      );

    -- Course cover thumbnail files
    DELETE FROM storage.objects
    WHERE bucket_id = 'course-thumbnails'
      AND (
        split_part(name, '/', 1) = p_course_id::text
        OR (v_course.thumbnail_url IS NOT NULL AND name = v_course.thumbnail_url)
      );

    -- Lesson video files
    DELETE FROM storage.objects
    WHERE bucket_id = 'lesson-videos'
      AND split_part(name, '/', 1) = p_course_id::text;
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;

  -- 6. Atomic deletion of related records in topological dependency order
  DELETE FROM public.assignment_submissions
  WHERE assignment_id IN (SELECT id FROM public.assignments WHERE course_id = p_course_id);

  DELETE FROM public.assignments WHERE course_id = p_course_id;

  DELETE FROM public.quiz_attempts
  WHERE quiz_id IN (SELECT id FROM public.quizzes WHERE course_id = p_course_id);

  DELETE FROM public.quiz_questions
  WHERE quiz_id IN (SELECT id FROM public.quizzes WHERE course_id = p_course_id);

  DELETE FROM public.quizzes WHERE course_id = p_course_id;

  DELETE FROM public.lessons WHERE course_id = p_course_id;

  DELETE FROM public.enrollments WHERE course_id = p_course_id;

  DELETE FROM public.courses WHERE id = p_course_id;

  RETURN QUERY SELECT 
    v_course.id,
    v_course.title,
    'SUCCESS: Course and related materials deleted successfully'::TEXT;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;

REVOKE ALL ON FUNCTION public.delete_course(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.delete_course(UUID) TO authenticated, postgres, service_role;

COMMIT;
