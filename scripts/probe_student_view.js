import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = 'https://jllqfirojqpiiinxrwgx.supabase.co';
const ANON_KEY = 'sb_publishable_XIm0YasF7ByKciM5O8Ok6Q_AWJZTdtd';
const supabase = createClient(SUPABASE_URL, ANON_KEY);

const PYTHON_COURSE_ID = 'd0000000-0000-0000-0000-000000000001';

async function testAsStudent() {
  const email = `test_probe_${Date.now()}@gmail.com`;
  const password = 'TestPassword123!';

  console.log('1. Signing up test student:', email);
  const { data: authData, error: authErr } = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: {
        full_name: 'Test Auditor',
        role: 'student'
      }
    }
  });

  if (authErr || !authData.user) {
    console.error('Sign up failed:', authErr);
    return;
  }

  const studentClient = createClient(SUPABASE_URL, ANON_KEY, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
    }
  });

  const { error: signErr } = await studentClient.auth.setSession({
    access_token: authData.session.access_token,
    refresh_token: authData.session.refresh_token,
  });

  if (signErr) {
    console.error('Set session failed:', signErr);
    return;
  }

  console.log('Signed in as:', authData.user.id);

  // Check lessons BEFORE enrollment
  const { data: lBefore } = await studentClient
    .from('lessons')
    .select('id, title, is_free_preview')
    .eq('course_id', PYTHON_COURSE_ID);
  console.log('Lessons before enrollment:', lBefore?.length);

  // Enroll in Python course via RPC
  console.log('2. Enrolling in Python course...');
  const { data: enrollRes, error: enrollErr } = await studentClient.rpc('enroll_in_course', {
    p_course_id: PYTHON_COURSE_ID,
  });
  console.log('Enroll result:', enrollRes, enrollErr);

  // Check lessons AFTER enrollment
  const { data: lAfter, error: lErr } = await studentClient
    .from('lessons')
    .select('id, title, is_free_preview, order_index')
    .eq('course_id', PYTHON_COURSE_ID)
    .order('order_index');
  console.log('Lessons AFTER enrollment:', lAfter?.length, lErr);
  lAfter?.forEach(l => console.log(`   - [${l.order_index}] ${l.title}`));

  // Check quizzes AFTER enrollment
  const { data: qAfter, error: qErr } = await studentClient
    .from('quizzes')
    .select('id, title, is_published')
    .eq('course_id', PYTHON_COURSE_ID);
  console.log('Quizzes AFTER enrollment:', qAfter?.length, qErr);
  qAfter?.forEach(q => console.log(`   - ${q.title}`));

  // Check assignments AFTER enrollment
  const { data: aAfter, error: aErr } = await studentClient
    .from('assignments')
    .select('id, title, is_published')
    .eq('course_id', PYTHON_COURSE_ID);
  console.log('Assignments AFTER enrollment:', aAfter?.length, aErr);
  aAfter?.forEach(a => console.log(`   - ${a.title}`));
}

testAsStudent().catch(console.error);
