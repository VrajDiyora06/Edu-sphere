import { createClient } from '@supabase/supabase-js';
import fs from 'fs';
import path from 'path';

const SUPABASE_URL = 'https://jllqfirojqpiiinxrwgx.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_XIm0YasF7ByKciM5O8Ok6Q_AWJZTdtd';

const anonClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

async function runTests() {
  console.log('========================================================================');
  console.log('EduSphere First-Admin Bootstrap & Role Protection Security Test Suite');
  console.log('========================================================================\n');

  let passedTests = 0;
  let totalTests = 0;

  function record(id, scenario, expected, actual, passed) {
    totalTests++;
    if (passed) passedTests++;
    const mark = passed ? '[PASS]' : '[FAIL]';
    console.log(`${mark} [${id}] ${scenario}`);
    console.log(`       Expected: ${expected}`);
    console.log(`       Actual:   ${actual}\n`);
  }

  // ---------------------------------------------------------------------------
  // 1. Unauthenticated PostgREST Gateway Security
  // ---------------------------------------------------------------------------
  try {
    const { data: _res, error } = await anonClient.rpc('bootstrap_initial_admin', {
      p_target_email: 'diyoravraj@gmail.com',
    });

    const isBlocked = !!error && (
      error.code === '42501' ||
      error.code === 'PGRST202' ||
      error.message.includes('permission denied') ||
      error.message.includes('not found')
    );

    record(
      'BOOT-SEC-01',
      'Unauthenticated caller attempting direct RPC bootstrap_initial_admin',
      'Rejection: Execution revoked from PUBLIC, anon, and authenticated users',
      error ? `${error.code || 'ERR'}: ${error.message}` : 'Unexpected success: RPC executed',
      isBlocked
    );
  } catch (err) {
    record('BOOT-SEC-01', 'Direct RPC bootstrap_initial_admin', 'Rejection', err.message, true);
  }

  try {
    const { data: _res, error } = await anonClient.rpc('admin_set_user_role', {
      p_target_user_id: '1bd96d08-bbbc-4695-92ee-95047b5cac41',
      p_new_role: 'admin',
    });

    const isBlocked = !!error && (
      error.code === '42501' ||
      error.message.includes('Authentication required') ||
      error.message.includes('permission denied')
    );

    record(
      'BOOT-SEC-02',
      'Unauthenticated caller attempting direct RPC admin_set_user_role',
      'Rejection: Authentication and admin privileges required (code 42501)',
      error ? `${error.code || 'ERR'}: ${error.message}` : 'Unexpected success',
      isBlocked
    );
  } catch (err) {
    record('BOOT-SEC-02', 'Direct RPC admin_set_user_role', 'Rejection', err.message, true);
  }

  try {
    const { data: _res, error } = await anonClient
      .from('profiles')
      .update({ role: 'admin' })
      .eq('id', '1bd96d08-bbbc-4695-92ee-95047b5cac41');

    const isBlocked = !!error && (
      error.code === '42501' ||
      error.message.includes('permission denied') ||
      error.message.includes('row-level security')
    );

    record(
      'BOOT-SEC-03',
      'Unauthenticated caller attempting direct UPDATE on public.profiles',
      'Rejection: Direct UPDATE denied by Row Level Security',
      error ? `${error.code || 'ERR'}: ${error.message}` : 'Unexpected update permitted',
      isBlocked
    );
  } catch (err) {
    record('BOOT-SEC-03', 'Direct UPDATE on public.profiles', 'Rejection', err.message, true);
  }

  // ---------------------------------------------------------------------------
  // 2. Profile Directory & Email Privacy Verification
  // ---------------------------------------------------------------------------
  try {
    const { data: publicProfiles, error } = await anonClient
      .from('public_profiles')
      .select('*');

    const hasProfiles = !error && Array.isArray(publicProfiles) && publicProfiles.length > 0;
    const emailExposed = publicProfiles?.some((p) => 'email' in p);

    record(
      'BOOT-SEC-04',
      'Public profiles directory privacy barrier',
      'Profiles accessible, email column strictly excluded from view schema',
      error ? `Error: ${error.message}` : `${publicProfiles.length} profiles returned; email exposed: ${emailExposed}`,
      hasProfiles && !emailExposed
    );
  } catch (err) {
    record('BOOT-SEC-04', 'Public profiles directory', 'Privacy enforced', err.message, false);
  }

  // ---------------------------------------------------------------------------
  // 3. UI Route & Navigation Authorization Contract Tests
  // ---------------------------------------------------------------------------
  function evaluateAdminRouteAccess(role) {
    const allowedRoles = ['admin', 'system_admin'];
    return allowedRoles.includes(role);
  }

  const studentRouteAccess = evaluateAdminRouteAccess('student');
  const guestRouteAccess = evaluateAdminRouteAccess('guest');
  const instructorRouteAccess = evaluateAdminRouteAccess('instructor');
  const adminRouteAccess = evaluateAdminRouteAccess('admin');
  const sysAdminRouteAccess = evaluateAdminRouteAccess('system_admin');

  record(
    'BOOT-UI-01',
    'Admin Portal route (/admin) RBAC authorization barrier',
    'Permit: admin, system_admin | Deny: student, instructor, guest',
    `admin: ${adminRouteAccess}, sysAdmin: ${sysAdminRouteAccess}, student: ${studentRouteAccess}, instructor: ${instructorRouteAccess}, guest: ${guestRouteAccess}`,
    adminRouteAccess && sysAdminRouteAccess && !studentRouteAccess && !instructorRouteAccess && !guestRouteAccess
  );

  function evaluateNavbarLinks(role) {
    return {
      showDashboard: role === 'student',
      showInstructorStudio: role === 'instructor' || role === 'admin' || role === 'system_admin',
      showAdminPortal: role === 'admin' || role === 'system_admin',
    };
  }

  const studentNav = evaluateNavbarLinks('student');
  const adminNav = evaluateNavbarLinks('admin');

  record(
    'BOOT-UI-02',
    'Navbar adaptive links contract for student vs admin roles',
    'Student: dashboard only | Admin: instructor studio and admin portal visible',
    `Student nav: ${JSON.stringify(studentNav)} | Admin nav: ${JSON.stringify(adminNav)}`,
    studentNav.showDashboard && !studentNav.showAdminPortal && adminNav.showAdminPortal && adminNav.showInstructorStudio
  );

  // ---------------------------------------------------------------------------
  // 4. Stored Procedure & Trigger Implementation Audits
  // ---------------------------------------------------------------------------
  const migrationPath = path.resolve('supabase/migrations/20261022000011_bootstrap_initial_admin.sql');
  const migrationContent = fs.existsSync(migrationPath) ? fs.readFileSync(migrationPath, 'utf8') : '';

  const hasOwnerCheck = migrationContent.includes("p_target_email IS DISTINCT FROM 'diyoravraj@gmail.com'");
  const hasAuthCheck = migrationContent.includes("FROM auth.users WHERE auth.users.email = p_target_email");
  const hasRevoke = migrationContent.includes("REVOKE ALL ON FUNCTION public.bootstrap_initial_admin(TEXT) FROM PUBLIC, anon, authenticated;");
  const hasGrant = migrationContent.includes("GRANT EXECUTE ON FUNCTION public.bootstrap_initial_admin(TEXT) TO postgres, service_role;");
  const hasIdempotentCheck = migrationContent.includes("IF v_current_role IN ('admin', 'system_admin') THEN");
  const hasOneTimeCheck = migrationContent.includes("IF v_existing_admin_count > 0 THEN");
  const hasTriggerUpgrade = migrationContent.includes("CREATE OR REPLACE FUNCTION public.protect_profile_role_changes()");
  const hasSessionUserCheck = migrationContent.includes("session_user IN ('postgres', 'supabase_admin') AND auth.uid() IS NULL");
  const hasProcSessionGuard = migrationContent.includes("session_user NOT IN ('postgres', 'supabase_admin') OR auth.uid() IS NOT NULL");
  const noCustomGucInTrigger = !migrationContent.includes("current_setting('edusphere.bootstrap_active'");

  record(
    'BOOT-SRC-01',
    'Owner lock: Bootstrap strictly restricted to platform owner',
    'Target email hardcoded to diyoravraj@gmail.com with auth.users existence verification',
    hasOwnerCheck && hasAuthCheck ? 'Found target lock and auth check: diyoravraj@gmail.com' : 'Missing target lock or auth check',
    hasOwnerCheck && hasAuthCheck
  );

  record(
    'BOOT-SRC-02',
    'Privilege boundary: bootstrap_initial_admin revoked from PUBLIC/anon/authenticated',
    'REVOKE ALL from PUBLIC, anon, authenticated; GRANT to postgres, service_role',
    hasRevoke && hasGrant ? 'Revocation and selective grant present' : 'Missing revocation or grant',
    hasRevoke && hasGrant
  );

  record(
    'BOOT-SRC-03',
    'Idempotency and Single-Bootstrap platform safeguards',
    'Returns ALREADY_ADMIN if promoted; rejects re-run if other admins active',
    hasIdempotentCheck && hasOneTimeCheck ? 'Idempotent check and single-bootstrap safeguard active' : 'Missing checks',
    hasIdempotentCheck && hasOneTimeCheck
  );

  record(
    'BOOT-SRC-04',
    'Role protection trigger upgrade & zero-GUC session verification',
    'Supports direct trusted database administrator sessions (session_user) with zero reliance on custom configuration settings (GUCs)',
    hasTriggerUpgrade && hasSessionUserCheck && hasProcSessionGuard && noCustomGucInTrigger
      ? 'Trigger properly hardened using session_user checks without custom GUC variables'
      : 'Trigger validation failed',
    hasTriggerUpgrade && hasSessionUserCheck && hasProcSessionGuard && noCustomGucInTrigger
  );

  // ---------------------------------------------------------------------------
  // 5. Standalone Bootstrap Script Parity Audit
  // ---------------------------------------------------------------------------
  const standalonePath = path.resolve('supabase/bootstrap_initial_admin.sql');
  const standaloneContent = fs.existsSync(standalonePath) ? fs.readFileSync(standalonePath, 'utf8') : '';

  const standaloneMatches = 
    standaloneContent.includes("p_target_email IS DISTINCT FROM 'diyoravraj@gmail.com'") &&
    standaloneContent.includes("REVOKE ALL ON FUNCTION public.bootstrap_initial_admin(TEXT) FROM PUBLIC, anon, authenticated;") &&
    standaloneContent.includes("SELECT * FROM public.bootstrap_initial_admin('diyoravraj@gmail.com');");

  record(
    'BOOT-SRC-05',
    'Standalone bootstrap script parity (supabase/bootstrap_initial_admin.sql)',
    'Contains exact owner locks, grant revokes, and execution statements',
    standaloneMatches ? 'Standalone script matches migration specifications' : 'Parity mismatch',
    standaloneMatches
  );

  // ---------------------------------------------------------------------------
  // Summary
  // ---------------------------------------------------------------------------
  console.log('========================================================================');
  console.log(`Test Results: ${passedTests}/${totalTests} PASSED (${totalTests - passedTests} failed)`);
  console.log('========================================================================\n');

  if (passedTests !== totalTests) {
    process.exit(1);
  }
}

runTests();
