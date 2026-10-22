-- Migration: 20261022000011_bootstrap_initial_admin.sql
-- Description: Secure, owner-controlled initial administrator bootstrap without custom settings.

BEGIN;

-- 1. Upgrade Role Protection Trigger Function
-- Rules enforced:
-- - Authenticated administrators manage roles via public.is_admin()
-- - Direct trusted database administrator sessions (session_user IN ('postgres', 'supabase_admin') AND auth.uid() IS NULL) can update roles directly
-- - PostgREST clients and ordinary authenticated users (session_user = 'authenticator') cannot modify roles
-- - No custom configuration settings (GUCs) are used or trusted
CREATE OR REPLACE FUNCTION public.protect_profile_role_changes()
RETURNS TRIGGER AS $$
BEGIN
  -- If role column is being changed:
  -- Only permit if caller is an authenticated administrator OR a direct database owner session without JWT
  IF NEW.role IS DISTINCT FROM OLD.role THEN
    IF NOT (
      public.is_admin() 
      OR (session_user IN ('postgres', 'supabase_admin') AND auth.uid() IS NULL)
    ) THEN
      NEW.role := OLD.role;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;

-- 2. Stored Procedure for Owner-Controlled Initial Admin Bootstrap
CREATE OR REPLACE FUNCTION public.bootstrap_initial_admin(
  p_target_email TEXT DEFAULT 'diyoravraj@gmail.com'
)
RETURNS TABLE (
  profile_id UUID,
  email TEXT,
  previous_role TEXT,
  new_role TEXT,
  status TEXT
) AS $$
DECLARE
  v_user_id UUID;
  v_current_role TEXT;
  v_existing_admin_count INT;
  v_auth_exists BOOLEAN;
BEGIN
  -- Strict Check 0: Must be executed directly by database owner (not via PostgREST)
  IF session_user NOT IN ('postgres', 'supabase_admin') OR auth.uid() IS NOT NULL THEN
    RAISE EXCEPTION 'Access denied: Bootstrap can only be executed directly by database administrators in Supabase SQL Editor.'
      USING ERRCODE = '42501';
  END IF;

  -- Strict Restriction 1: Target account MUST match the designated initial administrator
  IF p_target_email IS DISTINCT FROM 'diyoravraj@gmail.com' THEN
    RAISE EXCEPTION 'Access denied: Initial admin bootstrap is strictly restricted to the platform owner (diyoravraj@gmail.com).'
      USING ERRCODE = '42501';
  END IF;

  -- Strict Restriction 2: Verify user exists in auth.users
  SELECT EXISTS (
    SELECT 1 FROM auth.users WHERE auth.users.email = p_target_email
  ) INTO v_auth_exists;

  IF NOT v_auth_exists THEN
    RAISE EXCEPTION 'Prerequisite missing: User "%" does not exist in auth.users. The account must be registered in Supabase Auth first.', p_target_email
      USING ERRCODE = 'P0002';
  END IF;

  -- Locate target profile in public.profiles
  SELECT id, role INTO v_user_id, v_current_role
  FROM public.profiles
  WHERE public.profiles.email = p_target_email;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Prerequisite missing: Profile for "%" does not exist in public.profiles.', p_target_email
      USING ERRCODE = 'P0002';
  END IF;

  -- Idempotency Check: If already admin or system_admin, return status cleanly
  IF v_current_role IN ('admin', 'system_admin') THEN
    RETURN QUERY SELECT 
      v_user_id,
      p_target_email,
      v_current_role,
      v_current_role,
      'ALREADY_ADMIN: Account already holds administrative privileges'::TEXT;
    RETURN;
  END IF;

  -- One-time bootstrap constraint: Verify no OTHER active admins already exist
  SELECT COUNT(*) INTO v_existing_admin_count
  FROM public.profiles
  WHERE public.profiles.role IN ('admin', 'system_admin') AND public.profiles.id != v_user_id;

  IF v_existing_admin_count > 0 THEN
    RAISE EXCEPTION 'Bootstrap rejected: The platform already has % active administrator(s). Use admin_set_user_role to manage roles.', v_existing_admin_count
      USING ERRCODE = '42501';
  END IF;

  -- Perform the role update (preserves all foreign keys, enrollments, certificates, and progress)
  UPDATE public.profiles
  SET role = 'admin',
      updated_at = NOW()
  WHERE public.profiles.id = v_user_id;

  RETURN QUERY SELECT 
    v_user_id,
    p_target_email,
    v_current_role,
    'admin'::TEXT,
    'SUCCESS: Account promoted to initial platform administrator'::TEXT;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;

-- Revoke all execution grants from PUBLIC, anon, and authenticated users.
-- Only trusted database superusers / service roles can execute this function.
REVOKE ALL ON FUNCTION public.bootstrap_initial_admin(TEXT) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.bootstrap_initial_admin(TEXT) TO postgres, service_role;

-- 3. Execute the initial bootstrap atomically
SELECT * FROM public.bootstrap_initial_admin('diyoravraj@gmail.com');

COMMIT;

-- 4. Verification Query
SELECT id, email, full_name, role, updated_at
FROM public.profiles
WHERE email = 'diyoravraj@gmail.com';
