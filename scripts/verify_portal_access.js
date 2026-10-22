import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = 'https://jllqfirojqpiiinxrwgx.supabase.co';
const ANON_KEY = 'sb_publishable_XIm0YasF7ByKciM5O8Ok6Q_AWJZTdtd';
const PYTHON_COURSE_ID = 'd0000000-0000-0000-0000-000000000001';

async function verifyAllScenarios() {
  console.log('========================================================================');
  console.log('EduSphere Regression Verification: 5 Course Access Scenarios');
  console.log('========================================================================\n');

  const results = [];
  function record(id, scenario, expected, actual, passed) {
    results.push({ id, scenario, expected, actual, passed });
    const mark = passed ? '[PASS]' : '[FAIL]';
    console.log(`${mark} [${id}] ${scenario}`);
    console.log(`       Expected: ${expected}`);
    console.log(`       Actual:   ${actual}\n`);
  }

  // -------------------------------------------------------------------------
  // Scenario 1: Guest (Unauthenticated)
  // -------------------------------------------------------------------------
  const guestClient = createClient(SUPABASE_URL, ANON_KEY);

  // Guest lessons
  const { data: gLessons, error: gLErr } = await guestClient
    .from('lessons')
    .select('id, title, is_free_preview')
    .eq('course_id', PYTHON_COURSE_ID);

  const guestOnlyPreview = !gLErr && gLessons?.length === 1 && gLessons[0].is_free_preview === true;
  record(
    'SCENARIO-1-GUEST-LESSONS',
    'Guest access to Python course lessons',
    'Only 1 free preview lesson returned; 6 restricted lessons inaccessible',
    `Returned ${gLessons?.length} lesson(s) (preview: ${gLessons?.[0]?.is_free_preview})`,
    guestOnlyPreview
  );

  // Guest assignments
  const { data: gAssignments, error: gAErr } = await guestClient
    .from('assignments')
    .select('id, title')
    .eq('course_id', PYTHON_COURSE_ID);
  const guestNoAssignments = !gAErr && gAssignments?.length === 0;
  record(
    'SCENARIO-1-GUEST-ASSIGNMENTS',
    'Guest access to Python course assignments',
    '0 assignments returned (RLS enforces enrollment/instructor/admin)',
    `Returned ${gAssignments?.length} assignments`,
    guestNoAssignments
  );

  // Guest quiz questions RPC
  const { data: gQst, error: gQstErr } = await guestClient.rpc('get_student_quiz_questions', {
    p_quiz_id: 'e0000000-0000-0000-0101-000000000001',
  });
  const guestBlockedRpc = !!gQstErr && (gQstErr.code === '42501' || gQstErr.message.includes('Authentication required'));
  record(
    'SCENARIO-1-GUEST-QUIZ-QUESTIONS',
    'Guest direct call to get_student_quiz_questions RPC',
    'Rejection with code 42501 (Authentication required)',
    gQstErr ? `${gQstErr.code}: ${gQstErr.message}` : 'Questions returned',
    guestBlockedRpc
  );

  // -------------------------------------------------------------------------
  // Scenario 2: Enrolled Student (vrajdiyora2@gmail.com)
  // -------------------------------------------------------------------------
  const { data: sAuth, error: sAuthErr } = await guestClient.auth.signInWithPassword({
    email: 'vrajdiyora2@gmail.com',
    password: '12345678',
  });
  if (sAuthErr || !sAuth.session) {
    console.error('Failed to sign in enrolled student:', sAuthErr);
    return;
  }

  const studentClient = createClient(SUPABASE_URL, ANON_KEY, {
    global: { headers: { Authorization: 'Bearer ' + sAuth.session.access_token } },
  });

  // Verify enrollment
  const { data: sEnrollment } = await studentClient
    .from('enrollments')
    .select('id, student_id, course_id, progress_percent, is_completed')
    .eq('course_id', PYTHON_COURSE_ID)
    .single();
  record(
    'SCENARIO-2-ENROLLMENT-STATUS',
    'Enrolled student enrollment check',
    'Active enrollment record exists in public.enrollments',
    sEnrollment ? `Enrollment ID: ${sEnrollment.id}, Progress: ${sEnrollment.progress_percent}%` : 'No enrollment',
    !!sEnrollment
  );

  // Enrolled student lessons
  const { data: sLessons, error: sLErr } = await studentClient
    .from('lessons')
    .select('id, title, is_free_preview, duration_minutes')
    .eq('course_id', PYTHON_COURSE_ID)
    .order('order_index');
  const totalDuration = (sLessons || []).reduce((acc, l) => acc + (l.duration_minutes || 0), 0);
  record(
    'SCENARIO-2-STUDENT-LESSONS',
    'Enrolled student access to Python course lessons',
    'All 7 published lessons accessible (305 mins / approx 5.1 hrs)',
    `Retrieved ${sLessons?.length} lessons, Total Duration: ${totalDuration} mins (${(totalDuration / 60).toFixed(1)} hrs)`,
    !sLErr && sLessons?.length === 7 && totalDuration === 305
  );

  // Enrolled student quizzes
  const { data: sQuizzes, error: sQErr } = await studentClient
    .from('quizzes')
    .select('id, title, is_published')
    .eq('course_id', PYTHON_COURSE_ID);
  record(
    'SCENARIO-2-STUDENT-QUIZZES',
    'Enrolled student access to Python course quizzes',
    'All 4 published quizzes accessible',
    `Retrieved ${sQuizzes?.length} quizzes`,
    !sQErr && sQuizzes?.length === 4
  );

  // Enrolled student assignments
  const { data: sAssignments, error: sAErr } = await studentClient
    .from('assignments')
    .select('id, title, is_published')
    .eq('course_id', PYTHON_COURSE_ID);
  record(
    'SCENARIO-2-STUDENT-ASSIGNMENTS',
    'Enrolled student access to Python course assignments',
    'All 2 published assignments accessible',
    `Retrieved ${sAssignments?.length} assignments`,
    !sAErr && sAssignments?.length === 2
  );

  // Enrolled student quiz question projection (answer key secrecy)
  if (sQuizzes && sQuizzes.length > 0) {
    const { data: qQuestions, error: qstErr } = await studentClient.rpc('get_student_quiz_questions', {
      p_quiz_id: sQuizzes[0].id,
    });
    const hasAnswerKeys = (qQuestions || []).some(
      (q) => 'correct_option_index' in q || 'explanation' in q
    );
    record(
      'SCENARIO-2-QUIZ-ANSWER-SECRECY',
      'Enrolled student quiz question security projection',
      'Questions loaded for examination; answer keys and explanations stripped',
      qstErr ? `Error: ${qstErr.message}` : `Loaded ${qQuestions?.length} questions (keys exposed: ${hasAnswerKeys})`,
      !qstErr && qQuestions?.length > 0 && !hasAnswerKeys
    );
  }

  // -------------------------------------------------------------------------
  // Scenario 3: Non-enrolled Student
  // -------------------------------------------------------------------------
  const NON_ENROLLED_COURSE_ID = 'd0000000-0000-0000-0000-000000000002'; // Java course
  const { data: neLessons, error: neLErr } = await studentClient
    .from('lessons')
    .select('id, title, is_free_preview')
    .eq('course_id', NON_ENROLLED_COURSE_ID);

  const nonEnrolledOnlyPreview = !neLErr && neLessons?.length === 1 && neLessons[0].is_free_preview === true;
  record(
    'SCENARIO-3-NON-ENROLLED-LESSONS',
    'Non-enrolled student viewing non-enrolled course lessons',
    'Only 1 free preview lesson returned; restricted lessons blocked by RLS',
    `Retrieved ${neLessons?.length} lesson(s) (preview: ${neLessons?.[0]?.is_free_preview})`,
    nonEnrolledOnlyPreview
  );

  const { data: neAssignments, error: neAErr } = await studentClient
    .from('assignments')
    .select('id, title')
    .eq('course_id', NON_ENROLLED_COURSE_ID);
  record(
    'SCENARIO-3-NON-ENROLLED-ASSIGNMENTS',
    'Non-enrolled student viewing non-enrolled course assignments',
    '0 assignments returned (RLS requires enrollment)',
    `Retrieved ${neAssignments?.length} assignments`,
    !neAErr && neAssignments?.length === 0
  );

  // -------------------------------------------------------------------------
  // Scenario 4: Instructor
  // -------------------------------------------------------------------------
  const { data: elenaCourses } = await guestClient
    .from('courses')
    .select('id, title, instructor_id')
    .eq('instructor_id', 'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293');

  record(
    'SCENARIO-4-INSTRUCTOR-MANAGEMENT',
    'Instructor course author verification',
    'Instructor Dr. Elena Rostova owns published course curriculum',
    elenaCourses && elenaCourses.length > 0
      ? `Author of ${elenaCourses.length} course(s), including "${elenaCourses[0].title}"`
      : 'No courses found',
    !!elenaCourses && elenaCourses.length > 0
  );

  // -------------------------------------------------------------------------
  // Scenario 5: Admin (diyoravraj@gmail.com)
  // -------------------------------------------------------------------------
  const { data: aAuth, error: aAuthErr } = await guestClient.auth.signInWithPassword({
    email: 'diyoravraj@gmail.com',
    password: '12345678',
  });
  if (aAuthErr || !aAuth.session) {
    console.error('Failed to sign in admin:', aAuthErr);
    return;
  }

  const adminClient = createClient(SUPABASE_URL, ANON_KEY, {
    global: { headers: { Authorization: 'Bearer ' + aAuth.session.access_token } },
  });

  const { data: aCourses, error: aCErr } = await adminClient
    .from('courses')
    .select('id, title, is_published');

  const { data: aAllLessons, error: aAllLErr } = await adminClient
    .from('lessons')
    .select('id, course_id, title')
    .eq('course_id', PYTHON_COURSE_ID);

  record(
    'SCENARIO-5-ADMIN-AUTHORITY',
    'Admin platform supervisory access',
    'Admin can view all courses and all lessons for any course regardless of enrollment',
    `Admin retrieved ${aCourses?.length} courses, ${aAllLessons?.length} lessons for Python course`,
    !aCErr && !aAllLErr && (aCourses?.length || 0) >= 16 && aAllLessons?.length === 7
  );

  console.log('========================================================================');
  const allPassed = results.every((r) => r.passed);
  console.log(`Verification Summary: ${results.filter((r) => r.passed).length}/${results.length} PASSED`);
  console.log('========================================================================');
}

verifyAllScenarios().catch(console.error);
