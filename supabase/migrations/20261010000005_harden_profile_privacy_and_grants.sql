-- Migration: 20261010000005_harden_profile_privacy_and_grants.sql
-- Description: Hardens profile email privacy by revoking broad SELECT grants on public.profiles,
-- restricting direct table SELECT to owner/admin via RLS, and exposing public directory info via public_profiles view.

-- 1. Revoke Broad Table-Level Grants on public.profiles
REVOKE ALL ON public.profiles FROM PUBLIC, anon;
REVOKE SELECT ON public.profiles FROM authenticated;

-- Grant explicit table access to authenticated users for their owned row operations
GRANT SELECT, INSERT, UPDATE, DELETE ON public.profiles TO authenticated;

-- 2. Update profiles SELECT Policy (Owner or Admin Only for Direct Table Queries)
-- Explicitly drop all legacy policies from previous migrations to ensure clean migration application
DROP POLICY IF EXISTS "Profiles viewable by all" ON public.profiles;
DROP POLICY IF EXISTS "Public profiles viewable by all" ON public.profiles;
DROP POLICY IF EXISTS "Authenticated users view profiles" ON public.profiles;
DROP POLICY IF EXISTS "Profiles table viewable by owner or admin" ON public.profiles;

CREATE POLICY "Profiles table viewable by owner or admin" 
  ON public.profiles FOR SELECT 
  USING (auth.uid() = id OR public.is_admin());

-- 3. Re-create public_profiles View with Security Barrier (Excludes Email Column)
DROP VIEW IF EXISTS public.public_profiles;

CREATE VIEW public.public_profiles 
WITH (security_barrier = true) AS
SELECT id, full_name, avatar_url, role, bio, created_at
FROM public.profiles;

-- Grant public directory read access on public_profiles view ONLY
GRANT SELECT ON public.public_profiles TO authenticated, anon;

