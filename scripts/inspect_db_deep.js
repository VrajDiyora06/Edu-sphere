import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = 'https://jllqfirojqpiiinxrwgx.supabase.co';
const ANON_KEY = 'sb_publishable_XIm0YasF7ByKciM5O8Ok6Q_AWJZTdtd';
const supabase = createClient(SUPABASE_URL, ANON_KEY);

async function inspect() {
  console.log('=== Supabase Database Inspection ===\n');

  // 1. Profiles
  const { data: profiles, error: profErr } = await supabase
    .from('public_profiles')
    .select('id, full_name, role');
  console.log('Profiles in public_profiles:', profiles?.length, profErr?.message || '');
  if (profiles) {
    profiles.forEach(p => console.log(`  - [${p.role}] ${p.full_name} (${p.id})`));
  }

  // 2. Courses
  const { data: courses, error: courseErr } = await supabase
    .from('courses')
    .select('id, title, slug, is_published, instructor_id');
  console.log('\nCourses in courses table:', courses?.length, courseErr?.message || '');
  if (courses) {
    courses.forEach((c, i) => console.log(`  ${i+1}. [${c.is_published ? 'PUBLISHED' : 'DRAFT'}] ${c.title} (${c.id})`));
  }

  // 3. Lessons
  const { data: lessons, error: lessonErr } = await supabase
    .from('lessons')
    .select('id, course_id, title, is_free_preview, order_index');
  console.log('\nLessons returned to anon:', lessons?.length, lessonErr?.message || '');
  if (lessons) {
    const byCourse = {};
    lessons.forEach(l => {
      byCourse[l.course_id] = (byCourse[l.course_id] || 0) + 1;
    });
    console.log('Lesson counts per course:');
    for (const [cid, count] of Object.entries(byCourse)) {
      const c = courses?.find(x => x.id === cid);
      console.log(`  - ${c?.title || cid}: ${count} lessons`);
    }
  }

  // 4. Quizzes
  const { data: quizzes, error: quizErr } = await supabase
    .from('quizzes')
    .select('id, course_id, title, is_published');
  console.log('\nQuizzes returned to anon:', quizzes?.length, quizErr?.message || '');

  // 5. Quiz Questions
  const { data: questions, error: qErr } = await supabase
    .from('quiz_questions')
    .select('id, quiz_id, question_text');
  console.log('\nQuiz Questions returned to anon:', questions?.length, qErr?.message || '');

  // 6. Assignments
  const { data: assignments, error: assErr } = await supabase
    .from('assignments')
    .select('id, course_id, title, is_published');
  console.log('\nAssignments returned to anon:', assignments?.length, assErr?.message || '');
  if (assignments && assignments.length > 0) {
    const byCourse = {};
    assignments.forEach(a => {
      byCourse[a.course_id] = (byCourse[a.course_id] || 0) + 1;
    });
    for (const [cid, count] of Object.entries(byCourse)) {
      const c = courses?.find(x => x.id === cid);
      console.log(`  - ${c?.title || cid}: ${count} assignments`);
    }
  }

  // 7. Check enrollments
  const { data: enrollments, error: enrollErr } = await supabase
    .from('enrollments')
    .select('id, course_id, student_id');
  console.log('\nEnrollments returned to anon:', enrollments?.length, enrollErr?.message || '');
}

inspect().catch(console.error);
