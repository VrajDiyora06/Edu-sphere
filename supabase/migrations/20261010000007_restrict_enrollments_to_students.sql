-- Migration: 20261010000007_restrict_enrollments_to_students.sql
-- Description: Restricts course enrollment exclusively to authenticated users with the 'student' role
-- Enforces restriction in Supabase RLS and provides a secure atomic enrollment RPC.

-- ============================================================================
-- 1. Helper Function: Check if Authenticated Caller Has 'student' Role
-- ============================================================================
CREATE OR REPLACE FUNCTION public.is_student()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'student'
  );
$$ LANGUAGE sql SECURITY DEFINER SET search_path = public, pg_temp;

GRANT EXECUTE ON FUNCTION public.is_student() TO authenticated, anon;

-- ============================================================================
-- 2. Helper Function: Check if Caller is Enrolled in Course (Safe for Anon RLS)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.is_enrolled_in_course(p_course_id UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.enrollments
    WHERE course_id = p_course_id AND student_id = auth.uid()
  );
$$ LANGUAGE sql SECURITY DEFINER SET search_path = public, pg_temp;

GRANT EXECUTE ON FUNCTION public.is_enrolled_in_course(UUID) TO authenticated, anon;

-- Allow anon to evaluate enrollments RLS without table-level permission errors
GRANT SELECT ON public.enrollments TO anon;

-- ============================================================================
-- 3. Update Lessons SELECT Policy Using Helper Function
-- ============================================================================
DROP POLICY IF EXISTS "Read lessons if enrolled or preview" ON public.lessons;
CREATE POLICY "Read lessons if enrolled or preview" 
  ON public.lessons FOR SELECT 
  USING (
    is_free_preview = TRUE OR 
    public.is_enrolled_in_course(lessons.course_id) OR
    EXISTS (SELECT 1 FROM public.courses WHERE id = lessons.course_id AND instructor_id = auth.uid()) OR
    public.is_admin()
  );

-- ============================================================================
-- 4. Restrict Enrollments INSERT Policy Exclusively to Students
-- ============================================================================
DROP POLICY IF EXISTS "Students insert own enrollment" ON public.enrollments;
DROP POLICY IF EXISTS "Only students can enroll in courses" ON public.enrollments;

CREATE POLICY "Only students can enroll in courses"
  ON public.enrollments FOR INSERT
  WITH CHECK (
    auth.uid() = student_id AND
    public.is_student() AND
    EXISTS (
      SELECT 1 FROM public.courses 
      WHERE id = course_id AND (is_published = TRUE OR public.is_admin())
    )
  );

-- ============================================================================
-- 5. Atomic, Verified Enrollment Procedure (RPC)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.enroll_in_course(p_course_id UUID)
RETURNS JSONB AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_user_role TEXT;
  v_course_exists BOOLEAN;
  v_enrollment RECORD;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Authentication required to enroll in courses' USING ERRCODE = '42501';
  END IF;

  SELECT role INTO v_user_role
  FROM public.profiles
  WHERE id = v_user_id;

  IF v_user_role IS DISTINCT FROM 'student' THEN
    RAISE EXCEPTION 'Only users with the student role can enroll in courses (current role: %)', COALESCE(v_user_role, 'unknown') USING ERRCODE = '42501';
  END IF;

  SELECT (is_published = TRUE OR public.is_admin()) INTO v_course_exists
  FROM public.courses
  WHERE id = p_course_id;

  IF NOT COALESCE(v_course_exists, FALSE) THEN
    RAISE EXCEPTION 'Course not found or not published' USING ERRCODE = 'P0002';
  END IF;

  -- Check existing enrollment
  SELECT id, student_id, course_id, enrolled_at, progress_percent, is_completed, completed_at
  INTO v_enrollment
  FROM public.enrollments
  WHERE student_id = v_user_id AND course_id = p_course_id;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'success', TRUE,
      'already_enrolled', TRUE,
      'enrollment', to_jsonb(v_enrollment)
    );
  END IF;

  -- Insert new enrollment
  INSERT INTO public.enrollments (student_id, course_id, progress_percent, is_completed)
  VALUES (v_user_id, p_course_id, 0, FALSE)
  RETURNING id, student_id, course_id, enrolled_at, progress_percent, is_completed, completed_at
  INTO v_enrollment;

  RETURN jsonb_build_object(
    'success', TRUE,
    'already_enrolled', FALSE,
    'enrollment', to_jsonb(v_enrollment)
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;

GRANT EXECUTE ON FUNCTION public.enroll_in_course(UUID) TO authenticated;

-- ============================================================================
-- 6. System Diagnostics RPC Security Hardening
-- ============================================================================
CREATE OR REPLACE FUNCTION public.get_system_rbac_diagnostics()
RETURNS TABLE (
  metric_name TEXT,
  metric_value TEXT,
  status TEXT
) AS $$
DECLARE
  v_caller_id UUID := auth.uid();
  v_caller_role TEXT;
  v_rls_count INT;
BEGIN
  IF v_caller_id IS NULL THEN
    RAISE EXCEPTION 'Authentication required' USING ERRCODE = '42501';
  END IF;

  SELECT role INTO v_caller_role FROM public.profiles WHERE id = v_caller_id;
  IF v_caller_role IS DISTINCT FROM 'system_admin' THEN
    RAISE EXCEPTION 'Unauthorized: System Administrator privileges required' USING ERRCODE = '42501';
  END IF;

  SELECT COUNT(*) INTO v_rls_count
  FROM pg_tables
  WHERE schemaname = 'public' 
    AND tablename IN ('profiles', 'courses', 'lessons', 'enrollments', 'announcements')
    AND rowsecurity = TRUE;

  RETURN QUERY SELECT 
    'RLS Protected Tables'::TEXT,
    (v_rls_count || '/5 tables active')::TEXT,
    CASE WHEN v_rls_count = 5 THEN 'OPTIMAL' ELSE 'WARNING' END::TEXT;

  RETURN QUERY SELECT 
    'Registered User Profiles'::TEXT,
    (SELECT COUNT(*)::TEXT FROM public.profiles),
    'ACTIVE'::TEXT;

  RETURN QUERY SELECT 
    'Role Protection Trigger'::TEXT,
    'trg_protect_profile_role'::TEXT,
    CASE WHEN EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'trg_protect_profile_role') THEN 'ENFORCED' ELSE 'MISSING' END::TEXT;

  RETURN QUERY SELECT 
    'Profiles Direct Table Anon Grants'::TEXT,
    'Revoked'::TEXT,
    CASE WHEN NOT EXISTS (
      SELECT 1 FROM information_schema.table_privileges
      WHERE table_schema = 'public' AND table_name = 'profiles' AND grantee = 'anon' AND privilege_type = 'SELECT'
    ) THEN 'SECURE' ELSE 'VULNERABLE' END::TEXT;

END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;

REVOKE EXECUTE ON FUNCTION public.get_system_rbac_diagnostics FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_system_rbac_diagnostics TO authenticated;

