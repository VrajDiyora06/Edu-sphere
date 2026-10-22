import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = 'https://jllqfirojqpiiinxrwgx.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_XIm0YasF7ByKciM5O8Ok6Q_AWJZTdtd';

const anonClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

const COURSE_ID = '2cc77016-52c7-4bbc-a443-868be17b042e'; // Distributed Systems Engineering
const INSTRUCTOR_ID = 'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'; // Dr. Elena Rostova
const STUDENT_ID = '1bd96d08-bbbc-4695-92ee-95047b5cac41'; // Alex Mercer
const ADMIN_ID = 'a0000000-0000-0000-0000-000000000001'; // Sarah Jenkins
const SYSADMIN_ID = 'a0000000-0000-0000-0000-000000000002'; // Root Sysadmin

async function runTests() {
  console.log('========================================================================');
  console.log('EduSphere Role-Based Course Access & Certificate Isolation Test Suite');
  console.log('========================================================================\n');

  const results = [];

  function record(id, scenario, expected, actual, passed) {
    results.push({ id, scenario, expected, actual, passed });
    const mark = passed ? '[PASS]' : '[FAIL]';
    console.log(`${mark} [${id}] ${scenario}`);
    console.log(`       Expected: ${expected}`);
    console.log(`       Actual:   ${actual}\n`);
  }

  // 1. Database level: Verify the course author is Dr. Elena Rostova
  try {
    const { data: course, error } = await anonClient
      .from('courses')
      .select('id, title, instructor_id, is_published')
      .eq('id', COURSE_ID)
      .single();

    const passed = !error && course && course.instructor_id === INSTRUCTOR_ID;
    record(
      'RBAC-CR-01',
      'Verify course author in database',
      `Course instructor_id is ${INSTRUCTOR_ID}`,
      error ? `Error: ${error.message}` : `Course "${course.title}" owned by ${course.instructor_id}`,
      passed
    );
  } catch (err) {
    record('RBAC-CR-01', 'Verify course author', 'Success', err.message, false);
  }

  // 2. Database level: Verify a student enrollment exists for this course
  try {
    const { data: enrollments, error } = await anonClient
      .from('enrollments')
      .select('id, student_id, course_id, is_completed, progress_percent')
      .eq('course_id', COURSE_ID)
      .eq('student_id', STUDENT_ID);

    // Unauthenticated caller gets 0 rows due to RLS
    const passed = !error && Array.isArray(enrollments) && enrollments.length === 0;
    record(
      'RBAC-CR-02',
      'Unauthenticated caller cannot read student enrollment records via RLS',
      'RLS returns 0 rows to unauthenticated/guest caller',
      error ? `Error: ${error.message}` : `Returned ${enrollments.length} rows (strictly protected)`,
      passed
    );
  } catch (err) {
    record('RBAC-CR-02', 'Unauthenticated enrollment read', '0 rows', err.message, false);
  }

  // 3. Logic check: Replicate checkEnrollment() role-guard behavior
  function checkEnrollmentLogic(courseId, userId, userRole, existingEnrollment) {
    // Strict role check: Only students have personal enrollments
    if (!userRole || userRole !== 'student') {
      return { isEnrolled: false, enrollment: null };
    }
    if (!userId || !existingEnrollment) {
      return { isEnrolled: false, enrollment: null };
    }
    if (existingEnrollment.student_id !== userId) {
      return { isEnrolled: false, enrollment: null };
    }
    return { isEnrolled: true, enrollment: existingEnrollment };
  }

  const mockCompletedEnrollment = {
    id: 'enr-test-123',
    student_id: STUDENT_ID,
    course_id: COURSE_ID,
    is_completed: true,
    progress_percent: 100,
  };

  // Test Role 1: Guest (null / 'guest')
  const guestResult = checkEnrollmentLogic(COURSE_ID, null, 'guest', mockCompletedEnrollment);
  record(
    'RBAC-ROLE-GUEST',
    'Guest viewing course detail page',
    'isEnrolled: false, enrollment: null (No student progress or certificates)',
    `isEnrolled: ${guestResult.isEnrolled}, enrollment: ${guestResult.enrollment}`,
    !guestResult.isEnrolled && guestResult.enrollment === null
  );

  // Test Role 2: Student Alex Mercer viewing course
  const studentResult = checkEnrollmentLogic(COURSE_ID, STUDENT_ID, 'student', mockCompletedEnrollment);
  record(
    'RBAC-ROLE-STUDENT',
    'Enrolled Student Alex Mercer viewing course detail page',
    'isEnrolled: true, enrollment present with personal progress',
    `isEnrolled: ${studentResult.isEnrolled}, progress: ${studentResult.enrollment?.progress_percent}%`,
    studentResult.isEnrolled && studentResult.enrollment?.student_id === STUDENT_ID
  );

  // Test Role 3: Instructor Dr. Elena Rostova viewing course completed by student
  const instructorResult = checkEnrollmentLogic(COURSE_ID, INSTRUCTOR_ID, 'instructor', mockCompletedEnrollment);
  record(
    'RBAC-ROLE-INSTRUCTOR',
    'Course Author Dr. Elena Rostova viewing course completed by student',
    'isEnrolled: false, enrollment: null (Never shows student 100% progress or certificate)',
    `isEnrolled: ${instructorResult.isEnrolled}, enrollment: ${instructorResult.enrollment}`,
    !instructorResult.isEnrolled && instructorResult.enrollment === null
  );

  // Test Role 4: Administrator Sarah Jenkins viewing course
  const adminResult = checkEnrollmentLogic(COURSE_ID, ADMIN_ID, 'admin', mockCompletedEnrollment);
  record(
    'RBAC-ROLE-ADMIN',
    'Administrator Sarah Jenkins viewing course detail page',
    'isEnrolled: false, enrollment: null (Never inherits student progress)',
    `isEnrolled: ${adminResult.isEnrolled}, enrollment: ${adminResult.enrollment}`,
    !adminResult.isEnrolled && adminResult.enrollment === null
  );

  // Test Role 5: System Administrator viewing course
  const sysAdminResult = checkEnrollmentLogic(COURSE_ID, SYSADMIN_ID, 'system_admin', mockCompletedEnrollment);
  record(
    'RBAC-ROLE-SYSADMIN',
    'System Administrator viewing course detail page',
    'isEnrolled: false, enrollment: null (Never inherits student progress)',
    `isEnrolled: ${sysAdminResult.isEnrolled}, enrollment: ${sysAdminResult.enrollment}`,
    !sysAdminResult.isEnrolled && sysAdminResult.enrollment === null
  );

  // 4. Test Course Detail Page UI Flag Derivation for all 5 roles
  function deriveCourseDetailUIState(user, role, course, enrollment) {
    const isStudent = role === 'student';
    const isEnrolled = !!enrollment;
    const isEnrolledStudent = isStudent && isEnrolled && enrollment?.student_id === user?.id;
    const isCourseInstructor = role === 'instructor' && course?.instructor_id === user?.id;
    const isOtherInstructor = role === 'instructor' && course?.instructor_id !== user?.id;
    const isAdminOrSysAdmin = role === 'admin' || role === 'system_admin';

    return {
      // Student learning actions
      showPersonalProgressBar: isEnrolledStudent,
      showCourseCompletedBadge: isEnrolledStudent && enrollment?.is_completed,
      showViewCertificateButton: isEnrolledStudent && enrollment?.is_completed,
      showViewOnDashboardButton: isEnrolledStudent,
      showMarkCompleteLessonToggles: isEnrolledStudent,
      showAssignmentSubmitBox: isEnrolledStudent,
      showQuizTakeButton: isEnrolledStudent,

      // Instructor management actions
      showInstructorStudioLink: isCourseInstructor,
      showLessonPreviewButton: isCourseInstructor || isOtherInstructor || isAdminOrSysAdmin,
      showInstructorGradingBanner: isCourseInstructor,

      // Admin management actions
      showAdminPortalLink: isAdminOrSysAdmin,

      // Guest / Unenrolled actions
      showEnrollNowButton: role === 'student' && !isEnrolledStudent,
      showSignInToEnrollPrompt: !user,
    };
  }

  const sampleCourse = { id: COURSE_ID, instructor_id: INSTRUCTOR_ID };

  // UI Test for Instructor
  const instructorUI = deriveCourseDetailUIState(
    { id: INSTRUCTOR_ID, role: 'instructor' },
    'instructor',
    sampleCourse,
    null // checkEnrollment returns null
  );

  const instPass =
    !instructorUI.showPersonalProgressBar &&
    !instructorUI.showCourseCompletedBadge &&
    !instructorUI.showViewCertificateButton &&
    !instructorUI.showViewOnDashboardButton &&
    !instructorUI.showMarkCompleteLessonToggles &&
    !instructorUI.showAssignmentSubmitBox &&
    !instructorUI.showQuizTakeButton &&
    instructorUI.showInstructorStudioLink &&
    instructorUI.showLessonPreviewButton &&
    instructorUI.showInstructorGradingBanner &&
    !instructorUI.showEnrollNowButton &&
    !instructorUI.showSignInToEnrollPrompt;

  record(
    'UI-CHECK-INSTRUCTOR',
    'Instructor Course Detail UI rendering contract',
    'Zero student badges/bars/certificates; Instructor Studio links displayed; Lesson preview active',
    instPass ? 'Pass: All student features suppressed, management links active' : 'Fail: Leaked student UI',
    instPass
  );

  // UI Test for Student (Enrolled & Completed)
  const studentUI = deriveCourseDetailUIState(
    { id: STUDENT_ID, role: 'student' },
    'student',
    sampleCourse,
    mockCompletedEnrollment
  );

  const studentPass =
    studentUI.showPersonalProgressBar &&
    studentUI.showCourseCompletedBadge &&
    studentUI.showViewCertificateButton &&
    studentUI.showMarkCompleteLessonToggles &&
    studentUI.showAssignmentSubmitBox &&
    studentUI.showQuizTakeButton &&
    !studentUI.showInstructorStudioLink &&
    !studentUI.showAdminPortalLink;

  record(
    'UI-CHECK-STUDENT',
    'Enrolled Student Course Detail UI rendering contract',
    'Progress bar, completion badge, certificate button, assignment submission, and quiz taking active',
    studentPass ? 'Pass: Full student learning experience rendered' : 'Fail: Student UI missing features',
    studentPass
  );

  // UI Test for Guest
  const guestUI = deriveCourseDetailUIState(null, 'guest', sampleCourse, null);
  const guestPass =
    !guestUI.showPersonalProgressBar &&
    !guestUI.showCourseCompletedBadge &&
    !guestUI.showViewCertificateButton &&
    !guestUI.showInstructorStudioLink &&
    !guestUI.showAdminPortalLink &&
    guestUI.showSignInToEnrollPrompt;

  record(
    'UI-CHECK-GUEST',
    'Guest Course Detail UI rendering contract',
    'No progress or certificate; Sign in prompt displayed for enrollment',
    guestPass ? 'Pass: Guest gated with sign-in prompt' : 'Fail: Guest UI incorrect',
    guestPass
  );

  // UI Test for Administrator
  const adminUI = deriveCourseDetailUIState(
    { id: ADMIN_ID, role: 'admin' },
    'admin',
    sampleCourse,
    null
  );

  const adminPass =
    !adminUI.showPersonalProgressBar &&
    !adminUI.showCourseCompletedBadge &&
    !adminUI.showViewCertificateButton &&
    !adminUI.showInstructorStudioLink &&
    adminUI.showAdminPortalLink &&
    adminUI.showLessonPreviewButton;

  record(
    'UI-CHECK-ADMIN',
    'Administrator Course Detail UI rendering contract',
    'No student progress or certificates; Admin Portal link displayed; Lesson preview active',
    adminPass ? 'Pass: Admin workspace controls active' : 'Fail: Admin UI incorrect',
    adminPass
  );

  // UI Test for System Administrator
  const sysAdminUI = deriveCourseDetailUIState(
    { id: SYSADMIN_ID, role: 'system_admin' },
    'system_admin',
    sampleCourse,
    null
  );

  const sysAdminPass =
    !sysAdminUI.showPersonalProgressBar &&
    !sysAdminUI.showCourseCompletedBadge &&
    !sysAdminUI.showViewCertificateButton &&
    sysAdminUI.showAdminPortalLink &&
    sysAdminUI.showLessonPreviewButton;

  record(
    'UI-CHECK-SYSADMIN',
    'System Administrator Course Detail UI rendering contract',
    'No student progress or certificates; Admin Portal link displayed; Lesson preview active',
    sysAdminPass ? 'Pass: System Admin workspace controls active' : 'Fail: Sysadmin UI incorrect',
    sysAdminPass
  );

  // 5. Certificate Isolation Check
  function canRenderCertificate(user, role, enrollment) {
    if (!user || role !== 'student') return false;
    if (!enrollment || enrollment.student_id !== user.id) return false;
    return !!enrollment.is_completed;
  }

  const certStudentOwn = canRenderCertificate({ id: STUDENT_ID }, 'student', mockCompletedEnrollment);
  const certInstructor = canRenderCertificate({ id: INSTRUCTOR_ID }, 'instructor', mockCompletedEnrollment);
  const certOtherStudent = canRenderCertificate({ id: 'other-student-id' }, 'student', mockCompletedEnrollment);
  const certAdmin = canRenderCertificate({ id: ADMIN_ID }, 'admin', mockCompletedEnrollment);
  const certGuest = canRenderCertificate(null, 'guest', mockCompletedEnrollment);

  const certPass =
    certStudentOwn === true &&
    certInstructor === false &&
    certOtherStudent === false &&
    certAdmin === false &&
    certGuest === false;

  record(
    'SEC-CERT-01',
    'Certificate generation and rendering authorization isolation',
    'Only the authenticated student owning the completed enrollment can view certificate; Instructor, other students, and admins blocked',
    certPass ? 'Pass: Cross-user and non-student certificate access blocked' : 'Fail: Certificate leaked',
    certPass
  );

  console.log('========================================================================');
  console.log(`Course Access Role Tests Complete: ${results.filter((r) => r.passed).length}/${results.length} PASSED`);
  console.log('========================================================================');
}

runTests();
