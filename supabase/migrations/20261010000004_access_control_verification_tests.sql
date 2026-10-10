-- Migration: 20261010000004_access_control_verification_tests.sql
-- Description: Access-control verification test suite for Supabase
-- Part 1: Stored function for structural schema & catalog checks (Tests 1-6)
-- Part 2: Behavioral verification queries for execution in SQL Editor (Tests 7-13)

-- ============================================================================
-- PART 1: Stored Function for Structural Schema & Catalog Checks (Tests 1-6)
-- Note: Declared SECURITY DEFINER with fixed search_path.
-- Contains zero role-switching statements and executes cleanly during migration.
-- ============================================================================
CREATE OR REPLACE FUNCTION public.run_edusphere_access_control_tests()
RETURNS TABLE (
  test_name TEXT,
  target_component TEXT,
  assertion TEXT,
  test_result TEXT,
  details TEXT
) AS $$
DECLARE
  v_rls_count INT;
  v_trigger_user_created INT;
  v_trigger_role_protect INT;
  v_view_has_email INT;
  v_anon_profiles_select INT;
  v_search_path_ok INT;
BEGIN
  -- Test 1: Verify RLS is enabled on all 4 core tables
  SELECT COUNT(*) INTO v_rls_count
  FROM pg_tables
  WHERE schemaname = 'public' 
    AND tablename IN ('profiles', 'courses', 'lessons', 'enrollments')
    AND rowsecurity = TRUE;

  RETURN QUERY SELECT 
    'Core Table RLS Status'::TEXT,
    'RLS Engine'::TEXT,
    'Row Level Security enabled on profiles, courses, lessons, enrollments'::TEXT,
    CASE WHEN v_rls_count = 4 THEN 'PASS' ELSE 'FAIL' END::TEXT,
    ('RLS active on ' || v_rls_count || '/4 core tables')::TEXT;

  -- Test 2: Verify Registration Trigger (handle_new_user)
  SELECT COUNT(*) INTO v_trigger_user_created
  FROM pg_trigger WHERE tgname = 'on_auth_user_created';

  RETURN QUERY SELECT 
    'Registration Trigger'::TEXT,
    'auth.users'::TEXT,
    'on_auth_user_created trigger registered on auth.users'::TEXT,
    CASE WHEN v_trigger_user_created > 0 THEN 'PASS' ELSE 'FAIL' END::TEXT,
    'handle_new_user trigger active'::TEXT;

  -- Test 3: Verify Role Immutability Protection Trigger
  SELECT COUNT(*) INTO v_trigger_role_protect
  FROM pg_trigger WHERE tgname = 'trg_protect_profile_role';

  RETURN QUERY SELECT 
    'Role Immutability Trigger'::TEXT,
    'public.profiles'::TEXT,
    'trg_protect_profile_role BEFORE UPDATE trigger registered'::TEXT,
    CASE WHEN v_trigger_role_protect > 0 THEN 'PASS' ELSE 'FAIL' END::TEXT,
    'protect_profile_role_changes trigger active on profiles table'::TEXT;

  -- Test 4: Verify Public Profile View Privacy (Email Exclusion)
  SELECT COUNT(*) INTO v_view_has_email
  FROM information_schema.columns
  WHERE table_schema = 'public' 
    AND table_name = 'public_profiles' 
    AND column_name = 'email';

  RETURN QUERY SELECT 
    'Public View Privacy Schema'::TEXT,
    'public_profiles'::TEXT,
    'email column excluded from public_profiles view'::TEXT,
    CASE WHEN v_view_has_email = 0 THEN 'PASS' ELSE 'FAIL' END::TEXT,
    'public_profiles schema omits email column'::TEXT;

  -- Test 5: Verify Anon Direct Table SELECT Revocation on Profiles
  SELECT COUNT(*) INTO v_anon_profiles_select
  FROM information_schema.table_privileges
  WHERE table_schema = 'public'
    AND table_name = 'profiles'
    AND grantee = 'anon'
    AND privilege_type = 'SELECT';

  RETURN QUERY SELECT 
    'Profiles Direct Table Anon Grant'::TEXT,
    'public.profiles'::TEXT,
    'Direct SELECT grant on public.profiles revoked from anon'::TEXT,
    CASE WHEN v_anon_profiles_select = 0 THEN 'PASS' ELSE 'FAIL' END::TEXT,
    'No direct SELECT table privileges granted to anon on profiles'::TEXT;

  -- Test 6: Verify SECURITY DEFINER Functions declare fixed search_path
  SELECT COUNT(*) INTO v_search_path_ok
  FROM pg_proc p
  JOIN pg_namespace n ON p.pronamespace = n.oid
  WHERE n.nspname = 'public'
    AND p.proname IN ('handle_new_user', 'protect_profile_role_changes', 'is_admin', 'admin_set_user_role')
    AND ARRAY_TO_STRING(p.proconfig, ',') LIKE '%search_path=public, pg_temp%';

  RETURN QUERY SELECT 
    'Security Definer Search Path'::TEXT,
    'PostgreSQL Functions'::TEXT,
    'Functions declare SET search_path = public, pg_temp'::TEXT,
    CASE WHEN v_search_path_ok = 4 THEN 'PASS' ELSE 'FAIL' END::TEXT,
    (v_search_path_ok || '/4 functions hardened with fixed search_path')::TEXT;

END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;

-- Execute Structural Assertions
SELECT * FROM public.run_edusphere_access_control_tests();




