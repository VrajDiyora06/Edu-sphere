import { createClient } from '@supabase/supabase-js';
const SUPABASE_URL = 'https://jllqfirojqpiiinxrwgx.supabase.co';
const ANON_KEY = 'sb_publishable_XIm0YasF7ByKciM5O8Ok6Q_AWJZTdtd';
const supabase = createClient(SUPABASE_URL, ANON_KEY);

async function test() {
  const { data: auth } = await supabase.auth.signInWithPassword({
    email: 'vrajdiyora2@gmail.com',
    password: '12345678',
  });
  const client = createClient(SUPABASE_URL, ANON_KEY, {
    global: { headers: { Authorization: 'Bearer ' + auth.session.access_token } }
  });

  const { data: enrollments } = await client
    .from('enrollments')
    .select('id, student_id, course_id, enrolled_at, progress_percent, is_completed, completed_at')
    .eq('student_id', auth.user.id);

  console.log('Enrollments count:', enrollments?.length);

  const courseIds = enrollments.map(e => e.course_id);
  const { data: lessons } = await client
    .from('lessons')
    .select('id, course_id')
    .in('course_id', courseIds);

  console.log('Lessons count for enrolled courses:', lessons?.length);
  
  // Quizzes
  const { data: quizzes } = await client
    .from('quizzes')
    .select('id, course_id, title')
    .in('course_id', courseIds)
    .eq('is_published', true);
  console.log('Quizzes count:', quizzes?.length);

  // Assignments
  const { data: assignments } = await client
    .from('assignments')
    .select('id, course_id, title')
    .in('course_id', courseIds)
    .eq('is_published', true);
  console.log('Assignments count:', assignments?.length);
}
test().catch(console.error);
