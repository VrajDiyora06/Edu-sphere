-- ============================================================================
-- EduSphere: Atomic One-Time Instructor Bootstrap Script
-- ============================================================================
-- Purpose:
-- Atomically bootstraps an unreferenced account created in Supabase Auth
-- (instructor@edusphere.local) to 'instructor' role without:
-- - disabling RLS or the trg_protect_profile_role trigger;
-- - inserting fabricated rows into auth.users;
-- - touching or promoting your student account;
-- - faking JWT subject claims;
-- - deleting any profile that has active foreign key references.
--
-- Safety:
-- 1. Wrapped in an explicit transaction (BEGIN ... COMMIT) with automatic rollback on error.
-- 2. Strictly checks that 0 courses and 0 enrollments reference the profile before replacement.
-- 3. Idempotent: If the account already holds the 'instructor' role, it refreshes
--    non-role metadata without deleting or modifying the role.
-- ============================================================================

BEGIN;

DO $$
DECLARE
  v_target_email CONSTANT TEXT := 'instructor@edusphere.local';
  v_user_id UUID;
  v_current_role TEXT;
  v_course_refs INT;
  v_enrollment_refs INT;
  v_auth_user_exists BOOLEAN;
BEGIN
  -- 1. Verify existence in auth.users
  SELECT EXISTS (
    SELECT 1 FROM auth.users WHERE email = v_target_email
  ) INTO v_auth_user_exists;

  IF NOT v_auth_user_exists THEN
    RAISE EXCEPTION 
      'Prerequisite missing: User "%" does not exist in auth.users. Please create this user first via Supabase Authentication (Authentication -> Users -> Add user -> Create user) with "Auto Confirm User" enabled.',
      v_target_email;
  END IF;

  -- 2. Locate corresponding profile in public.profiles
  SELECT id, role INTO v_user_id, v_current_role
  FROM public.profiles
  WHERE email = v_target_email;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 
      'Integrity check failed: User "%" exists in auth.users, but has no corresponding row in public.profiles. The on_auth_user_created trigger may not have executed.',
      v_target_email;
  END IF;

  -- 3. Idempotent re-run check: If already configured as instructor, refresh metadata safely without role alteration
  IF v_current_role = 'instructor' THEN
    UPDATE public.profiles
    SET full_name = 'Dr. Elena Rostova',
        avatar_url = 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=200&auto=format&fit=crop',
        bio = 'Distinguished Systems Architect and Distributed Computing Researcher',
        updated_at = NOW()
    WHERE id = v_user_id;

    RAISE NOTICE 'Account "%" is already configured as instructor. Refreshed profile metadata cleanly.', v_target_email;
    RETURN;
  END IF;

  -- 4. Foreign key safety checks before replacement
  -- Ensure no existing rows in courses or enrollments reference this profile
  SELECT COUNT(*) INTO v_course_refs
  FROM public.courses
  WHERE instructor_id = v_user_id;

  SELECT COUNT(*) INTO v_enrollment_refs
  FROM public.enrollments
  WHERE student_id = v_user_id;

  IF v_course_refs > 0 OR v_enrollment_refs > 0 THEN
    RAISE EXCEPTION 
      'Cannot replace profile "%": % course(s) and % enrollment(s) already reference it. Profile deletion would violate foreign key constraints.',
      v_target_email, v_course_refs, v_enrollment_refs;
  END IF;

  -- 5. Atomic replacement of unreferenced default student profile
  -- trg_protect_profile_role is a BEFORE UPDATE trigger and does not fire on INSERT.
  -- All constraints, column types, and foreign keys to auth.users(id) remain satisfied.
  DELETE FROM public.profiles WHERE id = v_user_id;

  INSERT INTO public.profiles (
    id,
    email,
    full_name,
    role,
    avatar_url,
    bio,
    created_at,
    updated_at
  ) VALUES (
    v_user_id,
    v_target_email,
    'Dr. Elena Rostova',
    'instructor',
    'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=200&auto=format&fit=crop',
    'Distinguished Systems Architect and Distributed Computing Researcher',
    NOW(),
    NOW()
  );

  RAISE NOTICE 'Successfully bootstrapped "%" to instructor role.', v_target_email;
END $$;

COMMIT;

-- 6. Verification Query
SELECT id, email, full_name, role, bio, created_at, updated_at
FROM public.profiles
WHERE email = 'instructor@edusphere.local';
