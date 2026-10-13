-- Migration: 20261010000008_assignments_schema_and_storage.sql
-- Description: Assignments management, private Supabase Storage buckets, and RLS policies

-- ============================================================================
-- 1. Create Private Storage Buckets
-- ============================================================================
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'assignment-instructions',
  'assignment-instructions',
  FALSE,
  10485760, -- 10 MB
  ARRAY[
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  ]
)
ON CONFLICT (id) DO UPDATE SET
  public = FALSE,
  file_size_limit = 10485760,
  allowed_mime_types = ARRAY[
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  ];

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'assignment-submissions',
  'assignment-submissions',
  FALSE,
  26214400, -- 25 MB
  ARRAY[
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/zip',
    'application/x-zip-compressed'
  ]
)
ON CONFLICT (id) DO UPDATE SET
  public = FALSE,
  file_size_limit = 26214400,
  allowed_mime_types = ARRAY[
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/zip',
    'application/x-zip-compressed'
  ];

-- ============================================================================
-- 2. Assignments Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    instructions_file_path TEXT,
    instructions_file_name TEXT,
    due_date TIMESTAMPTZ NOT NULL,
    max_marks INT NOT NULL DEFAULT 100 CHECK (max_marks > 0),
    allow_resubmission BOOLEAN NOT NULL DEFAULT TRUE,
    is_published BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_assignments_course ON public.assignments(course_id, is_published);
CREATE INDEX IF NOT EXISTS idx_assignments_due_date ON public.assignments(due_date);

-- ============================================================================
-- 3. Assignment Submissions Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.assignment_submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assignment_id UUID NOT NULL REFERENCES public.assignments(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    file_path TEXT NOT NULL,
    file_name TEXT NOT NULL,
    file_size_bytes BIGINT NOT NULL,
    submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    status TEXT NOT NULL DEFAULT 'submitted' CHECK (status IN ('submitted', 'graded', 'resubmitted', 'late')),
    marks_obtained NUMERIC(5, 2) CHECK (marks_obtained >= 0),
    feedback TEXT,
    graded_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    graded_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_assignment_student_submission UNIQUE (assignment_id, student_id)
);

CREATE INDEX IF NOT EXISTS idx_submissions_assignment ON public.assignment_submissions(assignment_id);
CREATE INDEX IF NOT EXISTS idx_submissions_student ON public.assignment_submissions(student_id);

-- Enable Row Level Security
ALTER TABLE public.assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.assignment_submissions ENABLE ROW LEVEL SECURITY;

-- Revoke default public access
REVOKE ALL ON public.assignments FROM PUBLIC, anon;
REVOKE ALL ON public.assignment_submissions FROM PUBLIC, anon;

GRANT SELECT ON public.assignments TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON public.assignments TO authenticated;

GRANT SELECT, INSERT, UPDATE, DELETE ON public.assignment_submissions TO authenticated;

-- ============================================================================
-- 4. Row Level Security Policies for Assignments
-- ============================================================================

-- SELECT: Enrolled students view published assignments; instructors view own course assignments; admins view all
DROP POLICY IF EXISTS "Assignments viewable by enrolled students, instructors, or admins" ON public.assignments;
CREATE POLICY "Assignments viewable by enrolled students, instructors, or admins"
  ON public.assignments FOR SELECT
  USING (
    (is_published = TRUE AND public.is_enrolled_in_course(course_id)) OR
    EXISTS (SELECT 1 FROM public.courses WHERE id = assignments.course_id AND instructor_id = auth.uid()) OR
    public.is_admin()
  );

-- INSERT: Instructors can only insert assignments for courses they author; admins can insert
DROP POLICY IF EXISTS "Instructors insert assignments for own courses" ON public.assignments;
CREATE POLICY "Instructors insert assignments for own courses"
  ON public.assignments FOR INSERT
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.courses WHERE id = course_id AND instructor_id = auth.uid()) OR
    public.is_admin()
  );

-- UPDATE: Instructors can only update assignments for courses they author; admins can update
DROP POLICY IF EXISTS "Instructors update assignments for own courses" ON public.assignments;
CREATE POLICY "Instructors update assignments for own courses"
  ON public.assignments FOR UPDATE
  USING (
    EXISTS (SELECT 1 FROM public.courses WHERE id = course_id AND instructor_id = auth.uid()) OR
    public.is_admin()
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.courses WHERE id = course_id AND instructor_id = auth.uid()) OR
    public.is_admin()
  );

-- DELETE: Instructors can only delete assignments for courses they author; admins can delete
DROP POLICY IF EXISTS "Instructors delete assignments for own courses" ON public.assignments;
CREATE POLICY "Instructors delete assignments for own courses"
  ON public.assignments FOR DELETE
  USING (
    EXISTS (SELECT 1 FROM public.courses WHERE id = course_id AND instructor_id = auth.uid()) OR
    public.is_admin()
  );

-- ============================================================================
-- 5. Row Level Security Policies for Assignment Submissions
-- ============================================================================

-- SELECT: Students view their own submissions; course instructors view course submissions; admins view all
DROP POLICY IF EXISTS "Submissions viewable by student, course instructor, or admin" ON public.assignment_submissions;
CREATE POLICY "Submissions viewable by student, course instructor, or admin"
  ON public.assignment_submissions FOR SELECT
  USING (
    auth.uid() = student_id OR
    EXISTS (
      SELECT 1 FROM public.assignments a
      JOIN public.courses c ON c.id = a.course_id
      WHERE a.id = assignment_submissions.assignment_id AND c.instructor_id = auth.uid()
    ) OR
    public.is_admin()
  );

-- INSERT: Only enrolled students can submit for published assignments
DROP POLICY IF EXISTS "Enrolled students submit assignments" ON public.assignment_submissions;
CREATE POLICY "Enrolled students submit assignments"
  ON public.assignment_submissions FOR INSERT
  WITH CHECK (
    auth.uid() = student_id AND
    public.is_student() AND
    EXISTS (
      SELECT 1 FROM public.assignments a
      WHERE a.id = assignment_id AND a.is_published = TRUE AND public.is_enrolled_in_course(a.course_id)
    )
  );

-- UPDATE: Students can resubmit if allowed; Instructors can grade
DROP POLICY IF EXISTS "Students resubmit or instructors grade submissions" ON public.assignment_submissions;
CREATE POLICY "Students resubmit or instructors grade submissions"
  ON public.assignment_submissions FOR UPDATE
  USING (
    (
      auth.uid() = student_id AND
      EXISTS (
        SELECT 1 FROM public.assignments a
        WHERE a.id = assignment_submissions.assignment_id AND a.is_published = TRUE AND a.allow_resubmission = TRUE
      )
    ) OR
    EXISTS (
      SELECT 1 FROM public.assignments a
      JOIN public.courses c ON c.id = a.course_id
      WHERE a.id = assignment_submissions.assignment_id AND c.instructor_id = auth.uid()
    ) OR
    public.is_admin()
  );

-- ============================================================================
-- 6. Storage Policies for Assignment Instructions & Submissions
-- ============================================================================

-- Instruction files: Select permitted for course instructors, enrolled students, or admins
DROP POLICY IF EXISTS "Instructions read by enrolled students or instructors" ON storage.objects;
CREATE POLICY "Instructions read by enrolled students or instructors"
  ON storage.objects FOR SELECT
  USING (
    bucket_id = 'assignment-instructions' AND
    (
      EXISTS (
        SELECT 1 FROM public.courses c
        WHERE (c.instructor_id = auth.uid() OR public.is_enrolled_in_course(c.id))
          AND storage.objects.name LIKE c.id::text || '/%'
      ) OR
      public.is_admin()
    )
  );

-- Instruction files: Insert/Update/Delete only by course instructor or admin
DROP POLICY IF EXISTS "Instructors upload assignment instructions" ON storage.objects;
CREATE POLICY "Instructors upload assignment instructions"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'assignment-instructions' AND
    (
      EXISTS (
        SELECT 1 FROM public.courses c
        WHERE c.instructor_id = auth.uid()
          AND storage.objects.name LIKE c.id::text || '/%'
      ) OR
      public.is_admin()
    )
  );

DROP POLICY IF EXISTS "Instructors delete assignment instructions" ON storage.objects;
CREATE POLICY "Instructors delete assignment instructions"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'assignment-instructions' AND
    (
      EXISTS (
        SELECT 1 FROM public.courses c
        WHERE c.instructor_id = auth.uid()
          AND storage.objects.name LIKE c.id::text || '/%'
      ) OR
      public.is_admin()
    )
  );

-- Submissions: Select permitted for student who submitted, course instructor, or admin
DROP POLICY IF EXISTS "Submissions read by author student or instructor" ON storage.objects;
CREATE POLICY "Submissions read by author student or instructor"
  ON storage.objects FOR SELECT
  USING (
    bucket_id = 'assignment-submissions' AND
    (
      storage.objects.name LIKE '%/' || auth.uid()::text || '/%' OR
      EXISTS (
        SELECT 1 FROM public.courses c
        WHERE c.instructor_id = auth.uid()
          AND storage.objects.name LIKE c.id::text || '/%'
      ) OR
      public.is_admin()
    )
  );

-- Submissions: Insert permitted for enrolled student
DROP POLICY IF EXISTS "Students upload assignment submissions" ON storage.objects;
CREATE POLICY "Students upload assignment submissions"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'assignment-submissions' AND
    public.is_student() AND
    storage.objects.name LIKE '%/' || auth.uid()::text || '/%'
  );

-- ============================================================================
-- 7. Atomic Procedures: Submit Assignment & Grade Assignment
-- ============================================================================

CREATE OR REPLACE FUNCTION public.submit_student_assignment(
  p_assignment_id UUID,
  p_file_path TEXT,
  p_file_name TEXT,
  p_file_size_bytes BIGINT
)
RETURNS JSONB AS $$
DECLARE
  v_student_id UUID := auth.uid();
  v_course_id UUID;
  v_due_date TIMESTAMPTZ;
  v_allow_resubmission BOOLEAN;
  v_is_published BOOLEAN;
  v_status TEXT := 'submitted';
  v_submission RECORD;
BEGIN
  IF v_student_id IS NULL THEN
    RAISE EXCEPTION 'Authentication required to submit assignments' USING ERRCODE = '42501';
  END IF;

  IF NOT public.is_student() THEN
    RAISE EXCEPTION 'Only students can submit assignments' USING ERRCODE = '42501';
  END IF;

  SELECT course_id, due_date, allow_resubmission, is_published
  INTO v_course_id, v_due_date, v_allow_resubmission, v_is_published
  FROM public.assignments
  WHERE id = p_assignment_id;

  IF v_course_id IS NULL OR NOT v_is_published THEN
    RAISE EXCEPTION 'Assignment not found or not published' USING ERRCODE = 'P0002';
  END IF;

  IF NOT public.is_enrolled_in_course(v_course_id) THEN
    RAISE EXCEPTION 'You must be enrolled in this course to submit assignments' USING ERRCODE = '42501';
  END IF;

  IF NOW() > v_due_date THEN
    v_status := 'late';
  END IF;

  -- Check existing submission
  SELECT id, status INTO v_submission
  FROM public.assignment_submissions
  WHERE assignment_id = p_assignment_id AND student_id = v_student_id;

  IF FOUND THEN
    IF NOT v_allow_resubmission THEN
      RAISE EXCEPTION 'Resubmission is not permitted for this assignment' USING ERRCODE = '42501';
    END IF;

    IF v_submission.status = 'graded' THEN
      RAISE EXCEPTION 'Cannot resubmit after assignment has been graded' USING ERRCODE = '42501';
    END IF;

    UPDATE public.assignment_submissions
    SET file_path = p_file_path,
        file_name = p_file_name,
        file_size_bytes = p_file_size_bytes,
        submitted_at = NOW(),
        status = CASE WHEN NOW() > v_due_date THEN 'late' ELSE 'resubmitted' END,
        updated_at = NOW()
    WHERE assignment_id = p_assignment_id AND student_id = v_student_id
    RETURNING id, assignment_id, student_id, file_path, file_name, file_size_bytes, submitted_at, status, marks_obtained, feedback
    INTO v_submission;

    RETURN jsonb_build_object(
      'success', TRUE,
      'is_resubmission', TRUE,
      'submission', to_jsonb(v_submission)
    );
  END IF;

  -- New submission
  INSERT INTO public.assignment_submissions (
    assignment_id,
    student_id,
    file_path,
    file_name,
    file_size_bytes,
    submitted_at,
    status
  ) VALUES (
    p_assignment_id,
    v_student_id,
    p_file_path,
    p_file_name,
    p_file_size_bytes,
    NOW(),
    v_status
  )
  RETURNING id, assignment_id, student_id, file_path, file_name, file_size_bytes, submitted_at, status, marks_obtained, feedback
  INTO v_submission;

  RETURN jsonb_build_object(
    'success', TRUE,
    'is_resubmission', FALSE,
    'submission', to_jsonb(v_submission)
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;

GRANT EXECUTE ON FUNCTION public.submit_student_assignment TO authenticated;

CREATE OR REPLACE FUNCTION public.grade_student_assignment(
  p_submission_id UUID,
  p_marks NUMERIC,
  p_feedback TEXT
)
RETURNS JSONB AS $$
DECLARE
  v_caller_id UUID := auth.uid();
  v_submission RECORD;
  v_course_instructor UUID;
  v_max_marks INT;
BEGIN
  IF v_caller_id IS NULL THEN
    RAISE EXCEPTION 'Authentication required' USING ERRCODE = '42501';
  END IF;

  SELECT s.id, a.max_marks, c.instructor_id
  INTO v_submission.id, v_max_marks, v_course_instructor
  FROM public.assignment_submissions s
  JOIN public.assignments a ON a.id = s.assignment_id
  JOIN public.courses c ON c.id = a.course_id
  WHERE s.id = p_submission_id;

  IF v_submission.id IS NULL THEN
    RAISE EXCEPTION 'Submission not found' USING ERRCODE = 'P0002';
  END IF;

  IF v_course_instructor != v_caller_id AND NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized: You can only grade submissions for courses you author' USING ERRCODE = '42501';
  END IF;

  IF p_marks < 0 OR p_marks > v_max_marks THEN
    RAISE EXCEPTION 'Marks must be between 0 and maximum marks (%)', v_max_marks USING ERRCODE = '22023';
  END IF;

  UPDATE public.assignment_submissions
  SET marks_obtained = p_marks,
      feedback = p_feedback,
      status = 'graded',
      graded_by = v_caller_id,
      graded_at = NOW(),
      updated_at = NOW()
  WHERE id = p_submission_id
  RETURNING id, assignment_id, student_id, file_path, file_name, file_size_bytes, submitted_at, status, marks_obtained, feedback, graded_at
  INTO v_submission;

  RETURN jsonb_build_object(
    'success', TRUE,
    'submission', to_jsonb(v_submission)
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;

GRANT EXECUTE ON FUNCTION public.grade_student_assignment TO authenticated;
