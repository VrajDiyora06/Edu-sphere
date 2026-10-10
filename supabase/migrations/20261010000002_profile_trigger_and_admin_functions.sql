-- Migration: 20261010000002_profile_trigger_and_admin_functions.sql
-- Description: Profile creation trigger, role protection trigger, admin helpers, privacy view, and role elevation RPC

-- 1. Automatic Profile Creation Trigger
-- Non-recursive safety check: Trigger fires AFTER INSERT ON auth.users and inserts into public.profiles.
-- There is no corresponding trigger on public.profiles targeting auth.users, preventing cyclic recursion.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, role, avatar_url)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', SPLIT_PART(NEW.email, '@', 1)),
    'student', -- Always forces student role on registration
    NEW.raw_user_meta_data->>'avatar_url'
  )
  ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    full_name = COALESCE(public.profiles.full_name, EXCLUDED.full_name);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;

-- Re-create Trigger safely
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 2. Role Change Protection Trigger (Prevents RLS self-query recursion while ensuring role immutability)
CREATE OR REPLACE FUNCTION public.protect_profile_role_changes()
RETURNS TRIGGER AS $$
BEGIN
  -- If role column is being changed and caller is not an administrator, revert role change
  IF NEW.role IS DISTINCT FROM OLD.role AND NOT public.is_admin() THEN
    NEW.role := OLD.role;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;

DROP TRIGGER IF EXISTS trg_protect_profile_role ON public.profiles;
CREATE TRIGGER trg_protect_profile_role
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.protect_profile_role_changes();

-- 3. Database-Side Admin Authorization Helper
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role IN ('admin', 'system_admin')
  );
$$ LANGUAGE sql SECURITY DEFINER SET search_path = public, pg_temp;

-- 4. Public Profile View (Omits email for privacy, uses security_invoker = true)
CREATE OR REPLACE VIEW public.public_profiles 
WITH (security_invoker = true) AS
SELECT id, full_name, avatar_url, role, bio, created_at
FROM public.profiles;

GRANT SELECT ON public.public_profiles TO authenticated, anon;

-- 5. Administrative Role Elevation Procedure (Database Authorized)
CREATE OR REPLACE FUNCTION public.admin_set_user_role(
  p_target_user_id UUID,
  p_new_role TEXT
)
RETURNS VOID AS $$
DECLARE
  v_caller_id UUID := auth.uid();
  v_caller_role TEXT;
BEGIN
  IF v_caller_id IS NULL THEN
    RAISE EXCEPTION 'Authentication required' USING ERRCODE = '42501';
  END IF;

  SELECT role INTO v_caller_role
  FROM public.profiles
  WHERE id = v_caller_id;

  IF v_caller_role NOT IN ('admin', 'system_admin') THEN
    RAISE EXCEPTION 'Unauthorized: Administrator privileges required' USING ERRCODE = '42501';
  END IF;

  IF p_new_role NOT IN ('student', 'instructor', 'admin', 'system_admin') THEN
    RAISE EXCEPTION 'Invalid role specified' USING ERRCODE = '22023';
  END IF;

  -- Ordinary admins cannot assign the system_admin role
  IF p_new_role = 'system_admin' AND v_caller_role != 'system_admin' THEN
    RAISE EXCEPTION 'Unauthorized: Only system_admin can assign the system_admin role' USING ERRCODE = '42501';
  END IF;

  UPDATE public.profiles
  SET role = p_new_role,
      updated_at = NOW()
  WHERE id = p_target_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;
