-- Migration: 20261010000003_rls_least_privilege_policies.sql
-- Description: Least-privilege Row Level Security (RLS) policies for core tables

-- 1. Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.enrollments ENABLE ROW LEVEL SECURITY;

-- 2. Revoke Unnecessary Public Permissions & Grant Specific Roles
REVOKE ALL ON public.profiles, public.courses, public.lessons, public.enrollments FROM PUBLIC, anon;

-- Authenticated Users: Full CRUD within RLS policy bounds
GRANT SELECT, INSERT, UPDATE, DELETE ON public.profiles, public.courses, public.lessons, public.enrollments TO authenticated;

-- Anonymous (Unauthenticated) Users: Read-only access to published courses, free preview lessons, and public profiles
GRANT SELECT ON public.profiles TO anon;
GRANT SELECT ON public.courses TO anon;
GRANT SELECT ON public.lessons TO anon;

-- Function Execution Grants
GRANT EXECUTE ON FUNCTION public.admin_set_user_role TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_admin TO authenticated;

-- ----------------------------------------------------
-- 3. PROFILES RLS POLICIES
-- ----------------------------------------------------
DROP POLICY IF EXISTS "Profiles viewable by all" ON public.profiles;
CREATE POLICY "Profiles viewable by all" 
  ON public.profiles FOR SELECT 
  USING (TRUE);

DROP POLICY IF EXISTS "Users update own profile fields" ON public.profiles;
CREATE POLICY "Users update own profile fields" 
  ON public.profiles FOR UPDATE 
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id); -- Role immutability enforced by trg_protect_profile_role trigger (no subquery recursion)

-- ----------------------------------------------------
-- 4. COURSES RLS POLICIES
-- ----------------------------------------------------
DROP POLICY IF EXISTS "Read published courses" ON public.courses;
CREATE POLICY "Read published courses" 
  ON public.courses FOR SELECT 
  USING (is_published = TRUE OR auth.uid() = instructor_id OR public.is_admin());

DROP POLICY IF EXISTS "Instructors insert courses" ON public.courses;
CREATE POLICY "Instructors insert courses" 
  ON public.courses FOR INSERT 
  WITH CHECK (
    auth.uid() = instructor_id AND
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('instructor', 'admin', 'system_admin'))
  );

DROP POLICY IF EXISTS "Instructors update own courses" ON public.courses;
CREATE POLICY "Instructors update own courses" 
  ON public.courses FOR UPDATE 
  USING (auth.uid() = instructor_id OR public.is_admin());

DROP POLICY IF EXISTS "Instructors delete own courses" ON public.courses;
CREATE POLICY "Instructors delete own courses" 
  ON public.courses FOR DELETE 
  USING (auth.uid() = instructor_id OR public.is_admin());

-- ----------------------------------------------------
-- 5. LESSONS RLS POLICIES
-- ----------------------------------------------------
DROP POLICY IF EXISTS "Read lessons if enrolled or preview" ON public.lessons;
CREATE POLICY "Read lessons if enrolled or preview" 
  ON public.lessons FOR SELECT 
  USING (
    is_free_preview = TRUE OR 
    EXISTS (SELECT 1 FROM public.enrollments WHERE student_id = auth.uid() AND course_id = lessons.course_id) OR
    EXISTS (SELECT 1 FROM public.courses WHERE id = lessons.course_id AND instructor_id = auth.uid()) OR
    public.is_admin()
  );

DROP POLICY IF EXISTS "Instructors insert lessons" ON public.lessons;
CREATE POLICY "Instructors insert lessons" 
  ON public.lessons FOR INSERT 
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.courses WHERE id = lessons.course_id AND (instructor_id = auth.uid() OR public.is_admin()))
  );

DROP POLICY IF EXISTS "Instructors update lessons" ON public.lessons;
CREATE POLICY "Instructors update lessons" 
  ON public.lessons FOR UPDATE 
  USING (
    EXISTS (SELECT 1 FROM public.courses WHERE id = lessons.course_id AND (instructor_id = auth.uid() OR public.is_admin()))
  );

DROP POLICY IF EXISTS "Instructors delete lessons" ON public.lessons;
CREATE POLICY "Instructors delete lessons" 
  ON public.lessons FOR DELETE 
  USING (
    EXISTS (SELECT 1 FROM public.courses WHERE id = lessons.course_id AND (instructor_id = auth.uid() OR public.is_admin()))
  );

-- ----------------------------------------------------
-- 6. ENROLLMENTS RLS POLICIES
-- ----------------------------------------------------
DROP POLICY IF EXISTS "Students view own enrollments" ON public.enrollments;
CREATE POLICY "Students view own enrollments" 
  ON public.enrollments FOR SELECT 
  USING (auth.uid() = student_id OR public.is_admin());

DROP POLICY IF EXISTS "Students insert own enrollment" ON public.enrollments;
CREATE POLICY "Students insert own enrollment" 
  ON public.enrollments FOR INSERT 
  WITH CHECK (
    auth.uid() = student_id AND
    EXISTS (SELECT 1 FROM public.courses WHERE id = course_id AND (is_published = TRUE OR public.is_admin()))
  );

DROP POLICY IF EXISTS "Students update own enrollment progress" ON public.enrollments;
CREATE POLICY "Students update own enrollment progress" 
  ON public.enrollments FOR UPDATE 
  USING (auth.uid() = student_id OR public.is_admin());
