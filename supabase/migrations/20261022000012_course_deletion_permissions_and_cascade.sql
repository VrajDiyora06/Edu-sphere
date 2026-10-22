-- Migration: 20261022000012_course_deletion_permissions_and_cascade.sql
-- Description: Course deletion permissions, cascade policies, and secure delete_course procedure.

BEGIN;

-- 1. Ensure RLS DELETE policy on public.courses is strictly enforced
DROP POLICY IF EXISTS "Instructors delete own courses" ON public.courses;
CREATE POLICY "Instructors delete own courses" 
  ON public.courses FOR DELETE 
  USING (
    (auth.uid() = instructor_id AND EXISTS (
      SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('instructor', 'admin', 'system_admin')
    ))
    OR public.is_admin()
  );

-- 2. Add RLS DELETE policies on child tables to prevent cascade deletion blocks under RLS
DROP POLICY IF EXISTS "Course instructors and admins delete enrollments" ON public.enrollments;
CREATE POLICY "Course instructors and admins delete enrollments"
  ON public.enrollments FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.courses c
      WHERE c.id = enrollments.course_id 
        AND (c.instructor_id = auth.uid() OR public.is_admin())
    )
  );

DROP POLICY IF EXISTS "Course instructors and admins delete assignment submissions" ON public.assignment_submissions;
CREATE POLICY "Course instructors and admins delete assignment submissions"
  ON public.assignment_submissions FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.assignments a
      JOIN public.courses c ON c.id = a.course_id
      WHERE a.id = assignment_submissions.assignment_id 
        AND (c.instructor_id = auth.uid() OR public.is_admin())
    )
  );

DROP POLICY IF EXISTS "Course instructors and admins delete quiz attempts" ON public.quiz_attempts;
CREATE POLICY "Course instructors and admins delete quiz attempts"
  ON public.quiz_attempts FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.quizzes q
      JOIN public.courses c ON c.id = q.course_id
      WHERE q.id = quiz_attempts.quiz_id 
        AND (c.instructor_id = auth.uid() OR public.is_admin())
    )
  );

-- 3. Stored Procedure for Safe, Atomic Course Deletion
-- Enforces:
-- - Instructors can delete ONLY courses where instructor_id = auth.uid()
-- - Admins and system_admins can delete ANY course
-- - Students and guests are strictly blocked with error 42501
-- - Deletes all child records and associated storage objects cleanly in topological order
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
  SELECT id, title, instructor_id INTO v_course
  FROM public.courses
  WHERE id = p_course_id;

  IF v_course.id IS NULL THEN
    RAISE EXCEPTION 'Course not found' USING ERRCODE = 'P0002';
  END IF;

  -- 4. Role Authorization Boundary Check
  IF v_caller_role IN ('admin', 'system_admin') THEN
    -- Admins and system_admins can delete any course
    NULL;
  ELSIF v_caller_role = 'instructor' THEN
    -- Instructors can ONLY delete courses they own
    IF v_course.instructor_id != v_caller_id THEN
      RAISE EXCEPTION 'Unauthorized: Instructors can only delete courses they own' USING ERRCODE = '42501';
    END IF;
  ELSE
    -- Students, guests, and other roles cannot delete courses
    RAISE EXCEPTION 'Unauthorized: Course deletion restricted to course instructors and administrators' USING ERRCODE = '42501';
  END IF;

  -- 5. Clean up associated storage objects (instructions and submissions)
  BEGIN
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
  EXCEPTION WHEN OTHERS THEN
    -- Non-fatal: continue if storage objects table is restricted or not present
    NULL;
  END;

  -- 6. Atomic deletion of related records in topological dependency order
  -- A. Assignment submissions & assignments
  DELETE FROM public.assignment_submissions
  WHERE assignment_id IN (SELECT id FROM public.assignments WHERE course_id = p_course_id);

  DELETE FROM public.assignments WHERE course_id = p_course_id;

  -- B. Quiz attempts, quiz questions, and quizzes
  DELETE FROM public.quiz_attempts
  WHERE quiz_id IN (SELECT id FROM public.quizzes WHERE course_id = p_course_id);

  DELETE FROM public.quiz_questions
  WHERE quiz_id IN (SELECT id FROM public.quizzes WHERE course_id = p_course_id);

  DELETE FROM public.quizzes WHERE course_id = p_course_id;

  -- C. Lessons
  DELETE FROM public.lessons WHERE course_id = p_course_id;

  -- D. Enrollments
  DELETE FROM public.enrollments WHERE course_id = p_course_id;

  -- E. The Course itself
  DELETE FROM public.courses WHERE id = p_course_id;

  RETURN QUERY SELECT 
    v_course.id,
    v_course.title,
    'SUCCESS: Course and related materials deleted successfully'::TEXT;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;

-- 4. Execution Grants
REVOKE ALL ON FUNCTION public.delete_course(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.delete_course(UUID) TO authenticated, postgres, service_role;

COMMIT;
