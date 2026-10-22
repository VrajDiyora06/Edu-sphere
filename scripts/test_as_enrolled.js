import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = 'https://jllqfirojqpiiinxrwgx.supabase.co';
const ANON_KEY = 'sb_publishable_XIm0YasF7ByKciM5O8Ok6Q_AWJZTdtd';
const supabase = createClient(SUPABASE_URL, ANON_KEY);

async function testSignIn() {
  const email = `test_probe_1792599199041@gmail.com`;
  const password = 'TestPassword123!';

  console.log('Attempting signInWithPassword for', email);
  const { data, error } = await supabase.auth.signInWithPassword({ email, password });
  console.log('Sign in result:', data?.user?.id, error?.message || 'SUCCESS');

  if (data?.session) {
    console.log('Session obtained! Access token valid.');
    const studentClient = createClient(SUPABASE_URL, ANON_KEY, {
      global: {
        headers: {
          Authorization: `Bearer ${data.session.access_token}`
        }
      }
    });

    const PYTHON_COURSE_ID = 'd0000000-0000-0000-0000-000000000001';

    // 1. Enroll
    console.log('Enrolling in Python course...');
    const enrollRes = await studentClient.rpc('enroll_in_course', { p_course_id: PYTHON_COURSE_ID });
    console.log('Enroll result:', enrollRes);

    // 2. Query lessons
    const { data: lessons, error: lErr } = await studentClient
      .from('lessons')
      .select('id, title, is_free_preview, order_index')
      .eq('course_id', PYTHON_COURSE_ID)
      .order('order_index');
    console.log(`Lessons returned for enrolled student: ${lessons?.length}`, lErr || '');
    lessons?.forEach(l => console.log(`  - [Lesson ${l.order_index}] ${l.title}`));

    // 3. Query quizzes
    const { data: quizzes, error: qErr } = await studentClient
      .from('quizzes')
      .select('id, title, is_published')
      .eq('course_id', PYTHON_COURSE_ID);
    console.log(`Quizzes returned for enrolled student: ${quizzes?.length}`, qErr || '');
    quizzes?.forEach(q => console.log(`  - ${q.title}`));

    // 4. Query assignments
    const { data: assignments, error: aErr } = await studentClient
      .from('assignments')
      .select('id, title, is_published')
      .eq('course_id', PYTHON_COURSE_ID);
    console.log(`Assignments returned for enrolled student: ${assignments?.length}`, aErr || '');
    assignments?.forEach(a => console.log(`  - ${a.title}`));
  }
}

testSignIn().catch(console.error);
