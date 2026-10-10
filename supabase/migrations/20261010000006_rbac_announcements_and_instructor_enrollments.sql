-- Migration: 20261010000006_rbac_announcements_and_instructor_enrollments.sql
-- Description: Extends enrollments SELECT policy for course instructors, creates announcements table with RLS, and adds system_admin diagnostic helpers.

-- ============================================================================
-- 1. Enrollments SELECT Policy: Allow Instructors to View Own Course Enrollments
-- ============================================================================
DROP POLICY IF EXISTS "Students view own enrollments" ON public.enrollments;
DROP POLICY IF EXISTS "Enrollments viewable by student instructor or admin" ON public.enrollments;

CREATE POLICY "Enrollments viewable by student instructor or admin"
  ON public.enrollments FOR SELECT
  USING (
    auth.uid() = student_id OR
    EXISTS (SELECT 1 FROM public.courses WHERE id = enrollments.course_id AND instructor_id = auth.uid()) OR
    public.is_admin()
  );

-- ============================================================================
-- 2. Announcements Table for Administrator Communications
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.announcements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    priority TEXT NOT NULL DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    author_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    is_published BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE public.announcements ENABLE ROW LEVEL SECURITY;

-- Revoke default public access and grant explicit authenticated / anon access
REVOKE ALL ON public.announcements FROM PUBLIC, anon;
GRANT SELECT ON public.announcements TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON public.announcements TO authenticated;

-- Announcements Read Policy: Published announcements readable by everyone (including guests); drafts by admins
DROP POLICY IF EXISTS "Read published announcements" ON public.announcements;
CREATE POLICY "Read published announcements"
  ON public.announcements FOR SELECT
  USING (is_published = TRUE OR public.is_admin());

-- Announcements Write Policy: Only Administrators can insert announcements
DROP POLICY IF EXISTS "Admins insert announcements" ON public.announcements;
CREATE POLICY "Admins insert announcements"
  ON public.announcements FOR INSERT
  WITH CHECK (
    public.is_admin() AND
    auth.uid() = author_id
  );

-- Announcements Update Policy: Only Administrators can update announcements
DROP POLICY IF EXISTS "Admins update announcements" ON public.announcements;
CREATE POLICY "Admins update announcements"
  ON public.announcements FOR UPDATE
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- Announcements Delete Policy: Only Administrators can delete announcements
DROP POLICY IF EXISTS "Admins delete announcements" ON public.announcements;
CREATE POLICY "Admins delete announcements"
  ON public.announcements FOR DELETE
  USING (public.is_admin());

-- Performance Index
CREATE INDEX IF NOT EXISTS idx_announcements_published ON public.announcements(is_published, created_at DESC);

-- ============================================================================
-- 3. System Administrator Helper Function
-- ============================================================================
CREATE OR REPLACE FUNCTION public.is_system_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'system_admin'
  );
$$ LANGUAGE sql SECURITY DEFINER SET search_path = public, pg_temp;

GRANT EXECUTE ON FUNCTION public.is_system_admin TO authenticated;

-- ============================================================================
-- 4. Technical Diagnostics RPC for System Administrators
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

  -- Metric 1: Core Tables RLS Count
  SELECT COUNT(*) INTO v_rls_count
  FROM pg_tables
  WHERE schemaname = 'public' 
    AND tablename IN ('profiles', 'courses', 'lessons', 'enrollments', 'announcements')
    AND rowsecurity = TRUE;

  RETURN QUERY SELECT 
    'RLS Protected Tables'::TEXT,
    (v_rls_count || '/5 tables active')::TEXT,
    CASE WHEN v_rls_count = 5 THEN 'OPTIMAL' ELSE 'WARNING' END::TEXT;

  -- Metric 2: Total Registered Profiles
  RETURN QUERY SELECT 
    'Registered User Profiles'::TEXT,
    (SELECT COUNT(*)::TEXT FROM public.profiles),
    'ACTIVE'::TEXT;

  -- Metric 3: Role Immutability Trigger
  RETURN QUERY SELECT 
    'Role Protection Trigger'::TEXT,
    'trg_protect_profile_role'::TEXT,
    CASE WHEN EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'trg_protect_profile_role') THEN 'ENFORCED' ELSE 'MISSING' END::TEXT;

  -- Metric 4: Direct Table Anon Grants Status
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
