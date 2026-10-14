import React, { useState, useEffect, useCallback } from 'react';
import { useParams, Link, useNavigate, useLocation, useSearchParams } from 'react-router-dom';
import { useAuth } from '../context/useAuth';
import { getCourseByIdOrSlug } from '../lib/courses';
import {
  checkEnrollment,
  enrollInCourse,
  updateEnrollmentProgress,
} from '../lib/enrollments';
import {
  getCourseAssignments,
  submitAssignment,
  getInstructionDownloadUrl,
  getSubmissionDownloadUrl,
  validateSubmissionFile,
} from '../lib/assignments';
import {
  getCourseQuizzes,
  getQuizForStudent,
  submitQuizAnswers,
} from '../lib/quizzes';
import type {
  CourseWithDetails,
  DbLesson,
  DbEnrollment,
  AssignmentWithSubmission,
  QuizWithStudentStatus,
  DbQuiz,
  StudentQuizQuestion,
  DbQuizAttempt,
} from '../types';
import { CertificateModal } from '../components/CertificateModal';
import { LessonDoubtPanel } from '../components/LessonDoubtPanel';
import { MarkdownRenderer } from '../components/MarkdownRenderer';
import { LessonVideoPlayer } from '../components/LessonVideoPlayer';
import { getCourseCoverDisplayUrl } from '../lib/media';
import {
  BookOpen,
  PlayCircle,
  FileText,
  CheckCircle,
  CheckCircle2,
  Circle,
  Clock,
  Award,
  Shield,
  ArrowLeft,
  Lock,
  AlertTriangle,
  Loader2,
  RefreshCw,
  AlertCircle,
  Video,
  ExternalLink,
  X,
  ChevronRight,
  ChevronLeft,
  LogIn,
  Sparkles,
  Upload,
  Download,
  Calendar,
  HelpCircle,
  CheckSquare,
} from 'lucide-react';

export const CourseDetailPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const location = useLocation();
  const { user, role, loading: authLoading } = useAuth();
  const [searchParams, setSearchParams] = useSearchParams();
  const tabQuery = searchParams.get('tab');
  const [course, setCourse] = useState<CourseWithDetails | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [isEnrolled, setIsEnrolled] = useState(false);
  const [enrollment, setEnrollment] = useState<DbEnrollment | null>(null);
  const [enrolling, setEnrolling] = useState(false);
  const [enrollError, setEnrollError] = useState<string | null>(null);
  const [showEnrollModal, setShowEnrollModal] = useState(false);
  const [showCertificate, setShowCertificate] = useState(false);

  // Lesson completion tracking
  const [completedLessonIds, setCompletedLessonIds] = useState<string[]>([]);
  const [updatingProgress, setUpdatingProgress] = useState(false);
  const [progressError, setProgressError] = useState<string | null>(null);

  // Active lesson viewer modal
  const [activeLesson, setActiveLesson] = useState<DbLesson | null>(null);
  const [activeLessonTab, setActiveLessonTab] = useState<'content' | 'ai_doubt'>('content');

  // Content tab & assignment states
  const [activeContentTab, setActiveContentTab] = useState<'lessons' | 'assignments' | 'quizzes'>(
    tabQuery === 'assignments' || tabQuery === 'quizzes' ? tabQuery : 'lessons'
  );

  useEffect(() => {
    if (tabQuery === 'assignments' || tabQuery === 'quizzes' || tabQuery === 'lessons') {
      setActiveContentTab(tabQuery);
    }
  }, [tabQuery]);
  const [assignments, setAssignments] = useState<AssignmentWithSubmission[]>([]);
  const [loadingAssignments, setLoadingAssignments] = useState(false);
  const [assignmentSubmittingId, setAssignmentSubmittingId] = useState<string | null>(null);
  const [submissionFilesMap, setSubmissionFilesMap] = useState<Record<string, File>>({});
  const [assignmentMessage, setAssignmentMessage] = useState<{ id: string; type: 'success' | 'error'; text: string } | null>(null);

  // Quiz states
  const [quizzes, setQuizzes] = useState<QuizWithStudentStatus[]>([]);
  const [loadingQuizzes, setLoadingQuizzes] = useState(false);
  const [takingQuiz, setTakingQuiz] = useState<DbQuiz | null>(null);
  const [takingQuestions, setTakingQuestions] = useState<StudentQuizQuestion[]>([]);
  const [loadingQuizQuestions, setLoadingQuizQuestions] = useState(false);
  const [selectedQuizAnswers, setSelectedQuizAnswers] = useState<Record<string, number>>({});
  const [submittingQuizAttempt, setSubmittingQuizAttempt] = useState(false);
  const [quizReviewAttempt, setQuizReviewAttempt] = useState<DbQuizAttempt | null>(null);
  const [reviewingQuizTitle, setReviewingQuizTitle] = useState<string>('');

  const fetchCourseData = useCallback(async (courseId: string) => {
    try {
      const { data, error: fetchErr } = await getCourseByIdOrSlug(courseId);
      if (fetchErr) {
        setError(fetchErr.message || 'Failed to load course details.');
      } else {
        setCourse(data);
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An unexpected error occurred.');
    } finally {
      setLoading(false);
    }
  }, []);

  const handleRetry = useCallback(() => {
    if (!id) return;
    setLoading(true);
    setError(null);
    fetchCourseData(id);
  }, [id, fetchCourseData]);

  // Fetch course details
  useEffect(() => {
    if (!id) return;
    // Wait until auth initialization completes to avoid race condition where
    // authenticated students receive only guest/preview data
    if (authLoading) return;

    let ignore = false;
    setLoading(true);
    getCourseByIdOrSlug(id)
      .then(({ data, error: fetchErr }) => {
        if (ignore) return;
        if (fetchErr) {
          setError(fetchErr.message || 'Failed to load course details.');
        } else {
          setCourse(data);
        }
        setLoading(false);
      })
      .catch((err) => {
        if (ignore) return;
        setError(err instanceof Error ? err.message : 'An unexpected error occurred.');
        setLoading(false);
      });

    return () => {
      ignore = true;
    };
  }, [id, authLoading, user?.id, role]);

  const userId = user?.id;
  const courseId = course?.id;

  const isStudent = !!user && role === 'student';
  const isEnrolledStudent = isStudent && isEnrolled && !!enrollment && enrollment.student_id === user?.id;
  const isCourseInstructor = !!user && role === 'instructor' && course?.instructor_id === user?.id;
  const isOtherInstructor = !!user && role === 'instructor' && course?.instructor_id !== user?.id;
  const isAdminOrSysAdmin = !!user && (role === 'admin' || role === 'system_admin');

  // Check enrollment status and load persistent progress strictly for authenticated students
  useEffect(() => {
    let ignore = false;

    // Strict role check: Only students have personal course enrollments
    if (!courseId || !userId || role !== 'student') {
      Promise.resolve().then(() => {
        if (!ignore) {
          setIsEnrolled(false);
          setEnrollment(null);
          setCompletedLessonIds([]);
        }
      });
      return;
    }

    checkEnrollment(courseId, userId, role).then(({ isEnrolled: enrolled, enrollment: enr }) => {
      if (ignore) return;
      if (role !== 'student') {
        setIsEnrolled(false);
        setEnrollment(null);
        setCompletedLessonIds([]);
        return;
      }

      // Reject any enrollment that does not strictly belong to the current authenticated student
      if (enr && enr.student_id !== userId) {
        setIsEnrolled(false);
        setEnrollment(null);
        setCompletedLessonIds([]);
        return;
      }

      setIsEnrolled(enrolled);
      setEnrollment(enr);

      // If enrolled student only has preview data loaded, re-fetch full authorized course details
      if (enrolled && id && (!course?.lessons || course.lessons.length <= 1)) {
        fetchCourseData(id);
      }

      if (enrolled && enr && course?.lessons && course.lessons.length > 0) {
        const storageKey = `edusphere_progress_${userId}_${courseId}`;
        let savedIds: string[] = [];
        try {
          const raw = localStorage.getItem(storageKey);
          if (raw) {
            const parsed = JSON.parse(raw);
            if (Array.isArray(parsed)) {
              savedIds = parsed.filter((lessonId) =>
                course.lessons?.some((l) => l.id === lessonId)
              );
            }
          }
        } catch {
          savedIds = [];
        }

        const totalLessons = course.lessons.length;
        const progressPercent = enr?.progress_percent || 0;

        // Reconcile with database enrollment if localStorage is empty or inconsistent
        if (enr?.is_completed || progressPercent === 100) {
          savedIds = course.lessons.map((l) => l.id);
          localStorage.setItem(storageKey, JSON.stringify(savedIds));
        } else if (savedIds.length === 0 && progressPercent > 0 && totalLessons > 0) {
          const count = Math.max(1, Math.round((progressPercent / 100) * totalLessons));
          savedIds = course.lessons.slice(0, count).map((l) => l.id);
          localStorage.setItem(storageKey, JSON.stringify(savedIds));
        }

        setCompletedLessonIds(savedIds);
      } else {
        setCompletedLessonIds([]);
      }
    });

    return () => {
      ignore = true;
    };
  }, [courseId, userId, role, course?.lessons]);

  const handleEnroll = async () => {
    if (!user) {
      navigate('/login', { state: { from: location } });
      return;
    }
    if (role !== 'student') {
      setEnrollError(`Course enrollment is restricted to student accounts. Your current role is "${role.replace('_', ' ')}".`);
      return;
    }
    if (!course) return;

    setEnrolling(true);
    setEnrollError(null);

    const { success, data, error: enrollErr } = await enrollInCourse(course.id, user.id, role);

    setEnrolling(false);

    if (enrollErr || !success) {
      setEnrollError(enrollErr?.message || 'Failed to enroll in course. Please try again.');
      return;
    }

    setIsEnrolled(true);
    setEnrollment(data);
    setCompletedLessonIds([]);
    setShowEnrollModal(true);

    // Re-fetch course details: with active enrollment, RLS allows reading all lessons
    if (id) {
      fetchCourseData(id);
    }
  };

  const handleToggleLesson = async (lessonId: string) => {
    if (!isEnrolledStudent || !userId || !courseId || !course?.lessons) return;

    const isCurrentlyCompleted = completedLessonIds.includes(lessonId);
    const nextCompletedIds = isCurrentlyCompleted
      ? completedLessonIds.filter((lid) => lid !== lessonId)
      : [...completedLessonIds, lessonId];

    const totalLessons = course.lessons.length;
    const nextPercent =
      totalLessons > 0 ? Math.round((nextCompletedIds.length / totalLessons) * 100) : 0;
    const isCompleted = totalLessons > 0 && nextCompletedIds.length === totalLessons;
    const completedAt = isCompleted
      ? enrollment?.completed_at || new Date().toISOString()
      : null;

    // Optimistically update UI
    const prevCompleted = completedLessonIds;
    const prevEnrollment = enrollment;

    setCompletedLessonIds(nextCompletedIds);
    setEnrollment((prev) =>
      prev
        ? {
            ...prev,
            progress_percent: nextPercent,
            is_completed: isCompleted,
            completed_at: completedAt,
          }
        : null
    );

    const storageKey = `edusphere_progress_${userId}_${courseId}`;
    try {
      localStorage.setItem(storageKey, JSON.stringify(nextCompletedIds));
    } catch {
      // Local storage fallback
    }

    setUpdatingProgress(true);
    setProgressError(null);

    const { success, error: updateErr, data } = await updateEnrollmentProgress(
      courseId,
      userId,
      {
        progress_percent: nextPercent,
        is_completed: isCompleted,
        completed_at: completedAt,
      }
    );

    setUpdatingProgress(false);

    if (!success || updateErr) {
      // Revert optimistic update
      setCompletedLessonIds(prevCompleted);
      setEnrollment(prevEnrollment);
      try {
        localStorage.setItem(storageKey, JSON.stringify(prevCompleted));
      } catch {
        // ignore
      }
      setProgressError(
        updateErr?.message || 'Failed to persist progress to database. Please try again.'
      );
    } else if (data) {
      setEnrollment(data);
    }
  };

  const handleOpenLesson = (lesson: DbLesson) => {
    const canAccess =
      isEnrolledStudent ||
      lesson.is_free_preview ||
      role === 'instructor' ||
      role === 'admin' ||
      role === 'system_admin';
    if (!canAccess) return;
    setActiveLesson(lesson);
    setActiveLessonTab('content');
  };

  // Keyboard listener to close lesson modal with Escape key
  useEffect(() => {
    if (!activeLesson) return;
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        setActiveLesson(null);
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [activeLesson]);

  // State initialized with timestamp
  const [currentTime] = useState(() => Date.now());


  // Load assignments for this course
  useEffect(() => {
    if (!courseId || authLoading) return;
    let ignore = false;
    setLoadingAssignments(true);

    // Student personal submissions should only be attached for student users
    const queryUserId = isStudent ? userId : undefined;

    getCourseAssignments(courseId, queryUserId, false).then(({ data, error: aErr }) => {
      if (ignore) return;
      if (!aErr) {
        setAssignments(data);
      }
      setLoadingAssignments(false);
    });

    return () => {
      ignore = true;
    };
  }, [courseId, userId, isStudent, isEnrolledStudent, authLoading]);

  // Load quizzes for this course
  useEffect(() => {
    if (!courseId || authLoading) return;
    let ignore = false;
    setLoadingQuizzes(true);

    // Student personal quiz attempts should only be queried for student users
    const queryUserId = isStudent ? userId : undefined;

    getCourseQuizzes(courseId, false, queryUserId).then(({ data, error: qErr }) => {
      if (ignore) return;
      if (!qErr) {
        setQuizzes(data);
      }
      setLoadingQuizzes(false);
    });

    return () => {
      ignore = true;
    };
  }, [courseId, userId, isStudent, isEnrolledStudent, authLoading]);

  // Download instruction file
  const handleDownloadInstruction = async (filePath: string) => {
    const { url, error: dlErr } = await getInstructionDownloadUrl(filePath);
    if (dlErr || !url) {
      alert(dlErr?.message || 'Failed to generate download URL.');
    } else {
      window.open(url, '_blank');
    }
  };

  // Download submission file
  const handleDownloadSubmission = async (filePath: string) => {
    const { url, error: dlErr } = await getSubmissionDownloadUrl(filePath);
    if (dlErr || !url) {
      alert(dlErr?.message || 'Failed to generate download URL.');
    } else {
      window.open(url, '_blank');
    }
  };

  // Select submission file
  const handleSelectSubmissionFile = (assignmentId: string, file: File | null) => {
    if (!file) {
      setSubmissionFilesMap((prev) => {
        const copy = { ...prev };
        delete copy[assignmentId];
        return copy;
      });
      return;
    }

    const validation = validateSubmissionFile(file);
    if (!validation.valid) {
      setAssignmentMessage({
        id: assignmentId,
        type: 'error',
        text: validation.error || 'Invalid file format.',
      });
      return;
    }

    setSubmissionFilesMap((prev) => ({ ...prev, [assignmentId]: file }));
    setAssignmentMessage(null);
  };

  // Submit student work
  const handleSubmitWork = async (assignmentId: string) => {
    if (!userId || !courseId) return;
    const file = submissionFilesMap[assignmentId];
    if (!file) {
      setAssignmentMessage({
        id: assignmentId,
        type: 'error',
        text: 'Please select a file to submit.',
      });
      return;
    }

    setAssignmentSubmittingId(assignmentId);
    setAssignmentMessage(null);

    const { data: subData, error: subErr } = await submitAssignment(
      assignmentId,
      courseId,
      userId,
      file
    );

    setAssignmentSubmittingId(null);

    if (subErr) {
      setAssignmentMessage({
        id: assignmentId,
        type: 'error',
        text: subErr.message || 'Submission failed. Please try again.',
      });
    } else if (subData) {
      setAssignments((prev) =>
        prev.map((a) => (a.id === assignmentId ? { ...a, submission: subData } : a))
      );
      setSubmissionFilesMap((prev) => {
        const copy = { ...prev };
        delete copy[assignmentId];
        return copy;
      });
      setAssignmentMessage({
        id: assignmentId,
        type: 'success',
        text: 'Work submitted successfully! Your submission has been saved.',
      });
    }
  };

  // Start taking a quiz
  const handleStartQuiz = async (quiz: DbQuiz) => {
    setTakingQuiz(quiz);
    setLoadingQuizQuestions(true);
    setSelectedQuizAnswers({});
    const { questions, error: qErr } = await getQuizForStudent(quiz.id);
    if (qErr) {
      alert(`Could not load quiz questions: ${qErr.message}`);
      setTakingQuiz(null);
    } else {
      setTakingQuestions(questions);
    }
    setLoadingQuizQuestions(false);
  };

  // Select option in quiz taking mode
  const handleSelectQuizAnswer = (questionId: string, optionIndex: number) => {
    setSelectedQuizAnswers((prev) => ({
      ...prev,
      [questionId]: optionIndex,
    }));
  };

  // Submit quiz answers to server
  const handleSubmitQuiz = async () => {
    if (!takingQuiz) return;
    if (takingQuestions.length === 0) return;

    // Check unanswered questions
    const unansweredCount = takingQuestions.filter(
      (q) => selectedQuizAnswers[q.id] === undefined
    ).length;

    if (unansweredCount > 0) {
      if (!confirm(`You have ${unansweredCount} unanswered questions. Submit anyway?`)) {
        return;
      }
    }

    setSubmittingQuizAttempt(true);
    const { data: attempt, error: subErr } = await submitQuizAnswers(
      takingQuiz.id,
      selectedQuizAnswers
    );
    setSubmittingQuizAttempt(false);

    if (subErr || !attempt) {
      alert(`Quiz submission failed: ${subErr?.message || 'Unknown error'}`);
    } else {
      // Update local state with latest attempt
      setQuizzes((prev) =>
        prev.map((q) => (q.id === takingQuiz.id ? { ...q, latest_attempt: attempt } : q))
      );
      setTakingQuiz(null);
      setReviewingQuizTitle(takingQuiz.title);
      setQuizReviewAttempt(attempt);
    }
  };

  // Open review for completed attempt
  const handleOpenReview = (quiz: QuizWithStudentStatus) => {
    if (quiz.latest_attempt) {
      setReviewingQuizTitle(quiz.title);
      setQuizReviewAttempt(quiz.latest_attempt);
    }
  };

  const handleNextLesson = () => {
    if (!activeLesson || !course?.lessons) return;
    const currentIndex = course.lessons.findIndex((l) => l.id === activeLesson.id);
    if (currentIndex >= 0 && currentIndex < course.lessons.length - 1) {
      setActiveLesson(course.lessons[currentIndex + 1]);
    }
  };

  const handlePrevLesson = () => {
    if (!activeLesson || !course?.lessons) return;
    const currentIndex = course.lessons.findIndex((l) => l.id === activeLesson.id);
    if (currentIndex > 0) {
      setActiveLesson(course.lessons[currentIndex - 1]);
    }
  };

  if (loading) {
    return (
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 flex flex-col items-center justify-center space-y-4">
        <Loader2 className="w-9 h-9 text-[#0F766E] animate-spin" />
        <p className="text-sm text-slate-600 font-medium">Loading course syllabus and resources...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="max-w-4xl mx-auto px-4 py-20 text-center space-y-6">
        <div className="w-14 h-14 rounded-xl bg-rose-50 border border-rose-200 text-[#B91C1C] flex items-center justify-center mx-auto">
          <AlertCircle className="w-7 h-7" />
        </div>
        <div className="space-y-2">
          <h1 className="text-2xl font-bold text-[#172B4D]">Error Loading Course</h1>
          <p className="text-sm text-slate-600 max-w-md mx-auto">{error}</p>
        </div>
        <div className="flex items-center justify-center gap-3 pt-2">
          <button
            onClick={handleRetry}
            className="btn-primary text-xs"
          >
            <RefreshCw className="w-3.5 h-3.5" />
            <span>Try Again</span>
          </button>
          <Link
            to="/courses"
            className="btn-secondary text-xs"
          >
            <ArrowLeft className="w-3.5 h-3.5" />
            <span>Return to Course Catalog</span>
          </Link>
        </div>
      </div>
    );
  }

  if (!course) {
    return (
      <div className="max-w-4xl mx-auto px-4 py-20 text-center space-y-6">
        <div className="w-14 h-14 rounded-xl bg-amber-50 border border-amber-200 text-amber-700 flex items-center justify-center mx-auto">
          <AlertTriangle className="w-7 h-7" />
        </div>
        <div className="space-y-2">
          <h1 className="text-2xl font-bold text-[#172B4D]">Course Not Found</h1>
          <p className="text-sm text-slate-600 max-w-md mx-auto">
            The course <code className="text-[#172B4D] bg-slate-100 border border-slate-200 px-1.5 py-0.5 rounded font-mono text-xs">{id}</code> could not be found or is not currently published.
          </p>
        </div>
        <div className="pt-2">
          <Link
            to="/courses"
            className="btn-primary text-xs"
          >
            <ArrowLeft className="w-3.5 h-3.5" />
            <span>Return to Course Catalog</span>
          </Link>
        </div>
      </div>
    );
  }

  const lessons = course.lessons || [];
  const totalMinutes = lessons.reduce((sum, l) => sum + (l.duration_minutes || 0), 0);
  const durationDisplay = totalMinutes > 0 ? `${(totalMinutes / 60).toFixed(1)} Hours` : 'Self-paced';

  const defaultAvatar = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=60';

  return (
    <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-8">
      
      {/* Back Link */}
      <Link to="/courses" className="inline-flex items-center gap-1.5 text-xs text-[#535C56] hover:text-[#1B3B2B] transition-colors font-medium">
        <ArrowLeft className="w-3.5 h-3.5" />
        <span>Back to Course Catalog</span>
      </Link>

      {/* Hero Course Header */}
      <div className="academic-card p-6 lg:p-8 grid grid-cols-1 lg:grid-cols-3 gap-8 items-center">
        
        <div className="lg:col-span-2 space-y-4">
          <div className="flex flex-wrap items-center gap-2 text-xs font-semibold">
            <span className="px-2.5 py-1 rounded bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9]">{course.category}</span>
            <span className="px-2.5 py-1 rounded bg-[#FAF9F5] text-[#535C56] border border-[#E5E2D9]">{course.level}</span>
            <span className="px-2.5 py-1 rounded bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9] flex items-center gap-1">
              <CheckCircle className="w-3 h-3 text-[#1B3B2B]" />
              100% Free Tuition
            </span>
          </div>

          <h1 className="font-editorial text-3xl sm:text-4xl text-[#1F2421] leading-tight font-normal tracking-tight">{course.title}</h1>
          <div className="text-xs sm:text-sm text-[#535C56] leading-relaxed font-normal">
            <MarkdownRenderer content={course.description} />
          </div>

          <div className="flex items-center gap-6 text-xs text-[#535C56] pt-2 font-medium">
            <div className="flex items-center gap-1.5">
              <Clock className="w-4 h-4 text-[#7A857E]" />
              <span>{durationDisplay} Content</span>
            </div>
            <div className="flex items-center gap-1.5">
              <BookOpen className="w-4 h-4 text-[#7A857E]" />
              <span>{lessons.length} {lessons.length === 1 ? 'Lesson' : 'Lessons'}</span>
            </div>
            <div className="flex items-center gap-1.5">
              <Award className="w-4 h-4 text-[#1B3B2B]" />
              <span>Verified Certificate</span>
            </div>
          </div>
        </div>

        {/* Enrollment & Action Card */}
        <div className="bg-[#FAF9F5] p-6 rounded-lg border border-[#E5E2D9] text-center space-y-4">
          <div className="aspect-[16/10] overflow-hidden rounded border border-[#E5E2D9] bg-[#F4F1EA]">
            <img
              src={getCourseCoverDisplayUrl(course.thumbnail_url)}
              alt={course.title}
              className="w-full h-full object-cover"
            />
          </div>

          <div className="space-y-0.5">
            <div className="text-2xl font-black text-[#1F2421]">FREE</div>
            <div className="text-[11px] text-[#535C56]">Zero Tuition • Instant Access</div>
          </div>

          {enrollError && (
            <div className="p-3 rounded bg-[#FDF1EE] border border-[#F5C2BA] text-[#9E3D2B] text-xs flex items-center gap-2 text-left">
              <AlertCircle className="w-4 h-4 shrink-0 text-[#9E3D2B]" />
              <span>{enrollError}</span>
            </div>
          )}

          {isEnrolledStudent ? (
            <div className="space-y-2.5">
              <div className="w-full py-2 px-3 rounded bg-[#F4F1EA] border border-[#E5E2D9] text-[#1B3B2B] text-xs font-semibold flex items-center justify-between">
                <span className="flex items-center gap-1.5">
                  <CheckCircle className="w-4 h-4 text-[#1B3B2B]" />
                  {enrollment?.is_completed ? 'Course Completed' : 'Enrolled'}
                </span>
                <span className="font-mono">{enrollment?.progress_percent || 0}%</span>
              </div>

              {enrollment?.is_completed && (
                <button
                  onClick={() => setShowCertificate(true)}
                  className="btn-secondary w-full text-xs py-2.5 flex items-center justify-center gap-2"
                >
                  <Award className="w-4 h-4 text-[#1B3B2B]" />
                  <span>View Certificate of Completion</span>
                </button>
              )}

              {lessons.length > 0 && (
                <button
                  onClick={() => {
                    const nextLesson =
                      lessons.find((l) => !completedLessonIds.includes(l.id)) || lessons[0];
                    handleOpenLesson(nextLesson);
                  }}
                  className="btn-forest w-full text-xs py-2.5 flex items-center justify-center gap-2 font-semibold"
                >
                  <PlayCircle className="w-4 h-4" />
                  <span>{enrollment?.is_completed ? 'Review Lessons' : 'Continue Learning'}</span>
                </button>
              )}

              <Link
                to="/dashboard"
                className="btn-secondary w-full text-xs py-2 flex items-center justify-center gap-1.5"
              >
                <span>View on My Dashboard</span>
                <ExternalLink className="w-3.5 h-3.5" />
              </Link>
            </div>
          ) : role === 'student' ? (
            <div className="space-y-3 pt-1">
              <button
                id="enroll-course-button"
                onClick={handleEnroll}
                disabled={enrolling}
                className="btn-forest w-full py-2.5 text-xs tracking-wider uppercase font-semibold cursor-pointer"
              >
                {enrolling ? <Loader2 className="w-4 h-4 animate-spin" /> : null}
                <span>{enrolling ? 'Enrolling...' : 'Enroll Free Now'}</span>
              </button>
              <p className="text-[11px] text-[#535C56]">
                Enroll as a student to access all curriculum lessons, submit assignments, take quizzes, and earn certificates.
              </p>
            </div>
          ) : !user ? (
            <div className="space-y-3 pt-1">
              <div className="p-3.5 rounded bg-[#F4F1EA] border border-[#E5E2D9] text-center space-y-1">
                <div className="text-xs font-semibold text-[#1F2421]">Free Course Enrollment</div>
                <p className="text-[11px] text-[#535C56]">
                  Sign in with your student account to enroll, access all lessons, track progress, and earn certificates.
                </p>
              </div>
              <Link
                to="/login"
                state={{ from: location }}
                className="btn-forest w-full text-xs py-2.5 flex items-center justify-center gap-2"
              >
                <LogIn className="w-4 h-4" />
                <span>Sign In to Enroll</span>
              </Link>
              <Link
                to="/register"
                className="btn-secondary w-full text-xs py-2 flex items-center justify-center gap-2"
              >
                <span>Create Student Account</span>
              </Link>
            </div>
          ) : role === 'instructor' ? (
            <div className="space-y-3 pt-1">
              {course.instructor_id === user?.id ? (
                <>
                  <div className="p-3.5 rounded bg-[#F4F1EA] border border-[#E5E2D9] text-center space-y-1.5">
                    <div className="inline-flex items-center gap-1.5 px-2 py-0.5 rounded bg-[#EAE6DD] text-[#1B3B2B] text-[10px] font-semibold uppercase">
                      <Sparkles className="w-3 h-3" />
                      <span>Course Instructor</span>
                    </div>
                    <div className="text-xs font-semibold text-[#1F2421]">Instructor Workspace</div>
                    <p className="text-[11px] text-[#535C56] leading-relaxed">
                      You are the designated author of this course. Manage lessons, resources, assignments, and review student rosters in Instructor Studio.
                    </p>
                  </div>
                  <Link
                    to="/instructor"
                    className="btn-forest w-full text-xs py-2.5 flex items-center justify-center gap-2"
                  >
                    <Sparkles className="w-4 h-4" />
                    <span>Manage in Instructor Studio</span>
                  </Link>
                </>
              ) : (
                <>
                  <div className="p-3.5 rounded bg-[#F4F1EA] border border-[#E5E2D9] text-center space-y-1.5">
                    <div className="inline-flex items-center gap-1.5 px-2 py-0.5 rounded bg-[#EAE6DD] text-[#535C56] text-[10px] font-semibold uppercase">
                      <Shield className="w-3 h-3" />
                      <span>Instructor Preview</span>
                    </div>
                    <div className="text-xs font-semibold text-[#1F2421]">Curriculum Review Mode</div>
                    <p className="text-[11px] text-[#535C56] leading-relaxed">
                      Enrollment and personal progress tracking are reserved for student accounts. You can inspect the curriculum and preview content.
                    </p>
                  </div>
                  <Link
                    to="/instructor"
                    className="btn-secondary w-full text-xs py-2.5 flex items-center justify-center gap-2"
                  >
                    <span>Go to My Instructor Studio</span>
                  </Link>
                </>
              )}
            </div>
          ) : (
            <div className="space-y-3 pt-1">
              <div className="p-3.5 rounded bg-[#F4F1EA] border border-[#E5E2D9] text-center space-y-1.5">
                <div className="inline-flex items-center gap-1.5 px-2 py-0.5 rounded bg-[#EAE6DD] text-[#535C56] text-[10px] font-semibold uppercase">
                  <Shield className="w-3 h-3" />
                  <span>{role.replace('_', ' ')} Workspace</span>
                </div>
                <div className="text-xs font-semibold text-[#1F2421]">Administrative Overview</div>
                <p className="text-[11px] text-[#535C56] leading-relaxed">
                  Student enrollment and progress tracking do not apply to administrator accounts.
                </p>
              </div>
              <Link
                to="/admin"
                className="btn-forest w-full text-xs py-2.5 flex items-center justify-center gap-2"
              >
                <Shield className="w-4 h-4" />
                <span>Manage in Admin Portal</span>
              </Link>
            </div>
          )}

          <div className="text-[11px] text-[#7A857E] flex items-center justify-center gap-1">
            <Shield className="w-3 h-3 text-[#7A857E]" />
            <span>Enforced via PostgreSQL Row Level Security.</span>
          </div>
        </div>

      </div>

      {/* Main Syllabus & Content Section */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        {/* Main Content Area: Lessons & Assignments */}
        <div className="lg:col-span-2 space-y-6">
          {/* Content View Tabs */}
          <div className="flex items-center gap-2 border-b border-[#E5E2D9] pb-3">
            <button
              onClick={() => { setActiveContentTab('lessons'); setSearchParams({ tab: 'lessons' }, { replace: true }); }}
              className={`px-3.5 py-1.5 rounded-md text-xs font-semibold transition-all flex items-center gap-2 cursor-pointer ${
                activeContentTab === 'lessons'
                  ? 'bg-[#1B3B2B] text-white'
                  : 'bg-[#F4F1EA] hover:bg-[#EAE6DD] text-[#535C56] border border-[#E5E2D9]'
              }`}
            >
              <BookOpen className="w-3.5 h-3.5" />
              <span>Lessons ({lessons.length})</span>
            </button>
            <button
              onClick={() => { setActiveContentTab('assignments'); setSearchParams({ tab: 'assignments' }, { replace: true }); }}
              className={`px-3.5 py-1.5 rounded-md text-xs font-semibold transition-all flex items-center gap-2 cursor-pointer ${
                activeContentTab === 'assignments'
                  ? 'bg-[#1B3B2B] text-white'
                  : 'bg-[#F4F1EA] hover:bg-[#EAE6DD] text-[#535C56] border border-[#E5E2D9]'
              }`}
            >
              <FileText className="w-3.5 h-3.5" />
              <span>Assignments ({assignments.length})</span>
            </button>
            <button
              onClick={() => { setActiveContentTab('quizzes'); setSearchParams({ tab: 'quizzes' }, { replace: true }); }}
              className={`px-3.5 py-1.5 rounded-md text-xs font-semibold transition-all flex items-center gap-2 cursor-pointer ${
                activeContentTab === 'quizzes'
                  ? 'bg-[#1B3B2B] text-white'
                  : 'bg-[#F4F1EA] hover:bg-[#EAE6DD] text-[#535C56] border border-[#E5E2D9]'
              }`}
            >
              <HelpCircle className="w-3.5 h-3.5" />
              <span>Quizzes ({quizzes.length})</span>
            </button>
          </div>

          {activeContentTab === 'lessons' && (
            <>
              <div className="flex items-center justify-between">
                <h2 className="font-editorial text-xl sm:text-2xl text-[#1F2421] flex items-center gap-2">
                  <BookOpen className="w-5 h-5 text-[#1B3B2B]" />
                  <span>Course Curriculum ({lessons.length} {lessons.length === 1 ? 'Lesson' : 'Lessons'})</span>
                </h2>
                {isEnrolledStudent && (
                  <span className="px-2.5 py-0.5 rounded text-[11px] font-semibold bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9] flex items-center gap-1">
                    <CheckCircle className="w-3 h-3" />
                    Enrolled Access
                  </span>
                )}
              </div>

              {/* Persistent Course Progress Banner - Only for enrolled students */}
              {isEnrolledStudent && lessons.length > 0 && (
                <div className="academic-card p-5 space-y-3">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <span className="text-xs font-semibold text-[#1F2421]">Your Learning Progress</span>
                      {updatingProgress && (
                        <span className="inline-flex items-center gap-1 text-[11px] text-[#1B3B2B] font-mono">
                          <Loader2 className="w-3 h-3 animate-spin" />
                          Saving...
                        </span>
                      )}
                    </div>
                    <div className="text-xs font-mono font-semibold text-[#1B3B2B]">
                      {enrollment?.progress_percent || 0}% ({completedLessonIds.length} of {lessons.length} completed)
                    </div>
                  </div>

                  {/* Progress Bar */}
                  <div className="w-full h-2 bg-[#EAE6DD] rounded-full overflow-hidden">
                    <div
                      className="h-full bg-[#1B3B2B] rounded-full transition-all duration-300"
                      style={{ width: `${Math.min(100, Math.max(0, enrollment?.progress_percent || 0))}%` }}
                    />
                  </div>

                  {enrollment?.is_completed && (
                    <div className="p-3.5 rounded bg-[#F4F1EA] border border-[#E5E2D9] text-[#1B3B2B] text-xs flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                      <div className="flex items-center gap-2">
                        <CheckCircle className="w-4 h-4 text-[#1B3B2B] shrink-0" />
                        <span className="font-medium">All course lessons completed! You are eligible for certification.</span>
                      </div>
                      <button
                        onClick={() => setShowCertificate(true)}
                        className="btn-forest text-xs py-1.5 px-3 shrink-0"
                      >
                        <Award className="w-3.5 h-3.5 mr-1" />
                        <span>View Certificate</span>
                      </button>
                    </div>
                  )}

                  {progressError && (
                    <div className="p-2.5 rounded bg-[#FDF1EE] border border-[#F5C2BA] text-[#9E3D2B] text-xs flex items-center gap-2">
                      <AlertCircle className="w-4 h-4 text-[#9E3D2B] shrink-0" />
                      <span>{progressError}</span>
                    </div>
                  )}
                </div>
              )}

              {lessons.length === 0 ? (
                <div className="academic-card p-8 text-center space-y-3">
                  <Video className="w-8 h-8 text-[#7A857E] mx-auto" />
                  <p className="font-editorial text-base text-[#1F2421]">No lessons published yet</p>
                  <p className="text-xs text-[#535C56] max-w-sm mx-auto">
                    The instructor has not added lesson lectures to this course curriculum yet.
                  </p>
                </div>
              ) : (
                <div className="academic-card p-5 space-y-3">
                  <div className="space-y-2">
                    {lessons.map((lesson, idx) => {
                      const isCompleted = isEnrolledStudent && completedLessonIds.includes(lesson.id);
                      const canAccess =
                        isEnrolledStudent ||
                        lesson.is_free_preview ||
                        role === 'instructor' ||
                        role === 'admin' ||
                        role === 'system_admin';

                      return (
                        <div
                          key={lesson.id}
                          className={`flex items-center justify-between p-3.5 rounded border transition-all ${
                            isCompleted
                              ? 'bg-[#FAF9F5] border-[#E5E2D9]'
                              : 'bg-white border-[#E5E2D9] hover:border-[#1B3B2B]/40'
                          }`}
                        >
                          <div
                            onClick={() => canAccess && handleOpenLesson(lesson)}
                            className={`flex items-center gap-3 flex-1 ${
                              canAccess ? 'cursor-pointer group' : 'cursor-default'
                            }`}
                          >
                            <span className="w-6 h-6 rounded bg-[#F4F1EA] text-[#1F2421] text-[11px] font-mono font-bold flex items-center justify-center shrink-0 border border-[#E5E2D9]">
                              {idx + 1}
                            </span>
                            <PlayCircle
                              className={`w-4 h-4 shrink-0 ${
                                isCompleted ? 'text-[#1B3B2B]' : 'text-[#7A857E] group-hover:text-[#1B3B2B]'
                              }`}
                            />
                            <div>
                              <div
                                className={`text-xs sm:text-sm font-semibold transition-colors ${
                                  isCompleted
                                    ? 'text-[#535C56]'
                                    : 'text-[#1F2421] group-hover:text-[#1B3B2B]'
                                }`}
                              >
                                {lesson.title}
                              </div>
                              <div className="text-[11px] text-[#7A857E]">
                                {lesson.duration_minutes ? `${lesson.duration_minutes} mins` : 'Self-paced'}
                              </div>
                            </div>
                          </div>

                          <div className="flex items-center gap-2">
                            {isEnrolledStudent ? (
                              <button
                                onClick={() => handleToggleLesson(lesson.id)}
                                disabled={updatingProgress}
                                className={`px-3 py-1.5 rounded text-xs font-semibold flex items-center gap-1.5 transition-colors cursor-pointer ${
                                  isCompleted
                                    ? 'bg-[#F4F1EA] text-[#1B3B2B] hover:bg-[#EAE6DD] border border-[#E5E2D9]'
                                    : 'btn-secondary text-xs py-1.5 px-3'
                                }`}
                                title={isCompleted ? 'Click to mark incomplete' : 'Click to mark complete'}
                              >
                                {isCompleted ? (
                                  <>
                                    <CheckCircle2 className="w-3.5 h-3.5 text-[#1B3B2B]" />
                                    <span>Completed</span>
                                  </>
                                ) : (
                                  <>
                                    <Circle className="w-3.5 h-3.5 text-[#7A857E]" />
                                    <span>Mark Complete</span>
                                  </>
                                )}
                              </button>
                            ) : role === 'instructor' || role === 'admin' || role === 'system_admin' ? (
                              <button
                                onClick={() => handleOpenLesson(lesson)}
                                className="btn-secondary text-xs py-1.5 px-3 flex items-center gap-1.5"
                              >
                                <PlayCircle className="w-3.5 h-3.5 text-[#1B3B2B]" />
                                <span>Preview</span>
                              </button>
                            ) : lesson.is_free_preview ? (
                              <button
                                onClick={() => handleOpenLesson(lesson)}
                                className="px-2.5 py-1 rounded text-[11px] font-semibold bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9] hover:bg-[#EAE6DD] cursor-pointer"
                              >
                                Free Preview
                              </button>
                            ) : (
                              <span title="Enrolled Access Required" className="text-[#7A857E] p-1">
                                <Lock className="w-3.5 h-3.5" />
                              </span>
                            )}
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              )}
            </>
          )}

          {/* Assignments View */}
          {activeContentTab === 'assignments' && (
            <div className="space-y-6">
              <div className="flex items-center justify-between">
                <h2 className="text-xl font-bold text-[#172B4D] flex items-center gap-2">
                  <FileText className="w-5 h-5 text-[#0F766E]" />
                  <span>Course Assignments ({assignments.length})</span>
                </h2>
                {isEnrolledStudent && (
                  <span className="px-2.5 py-1 rounded-full text-[11px] font-semibold bg-teal-50 text-[#0F766E] border border-teal-200 flex items-center gap-1">
                    <Shield className="w-3 h-3" />
                    Student Submission Access
                  </span>
                )}
                {isCourseInstructor && (
                  <Link
                    to="/instructor"
                    className="btn-primary text-xs py-1.5 px-3 flex items-center gap-1.5"
                  >
                    <Sparkles className="w-3.5 h-3.5" />
                    <span>Manage in Studio</span>
                  </Link>
                )}
                {isOtherInstructor && (
                  <span className="px-2.5 py-1 rounded-full text-[11px] font-semibold bg-amber-50 text-amber-800 border border-amber-200">
                    Instructor Preview
                  </span>
                )}
                {isAdminOrSysAdmin && (
                  <Link
                    to="/admin"
                    className="btn-secondary text-xs py-1.5 px-3 flex items-center gap-1.5"
                  >
                    <Shield className="w-3.5 h-3.5" />
                    <span>Admin Portal</span>
                  </Link>
                )}
              </div>

              {!isEnrolledStudent && role === 'student' ? (
                <div className="academic-card p-8 text-center space-y-4">
                  <div className="w-12 h-12 rounded-xl bg-amber-50 border border-amber-200 text-amber-700 flex items-center justify-center mx-auto">
                    <Lock className="w-6 h-6" />
                  </div>
                  <div className="space-y-1">
                    <h3 className="text-base font-bold text-[#172B4D]">Enroll to Access Course Assignments</h3>
                    <p className="text-xs text-slate-500 max-w-md mx-auto">
                      Course assignments, instruction downloads, and project submission grading are available exclusively to enrolled students.
                    </p>
                  </div>
                  <button
                    onClick={handleEnroll}
                    disabled={enrolling}
                    className="btn-primary text-xs py-2 px-5"
                  >
                    <Sparkles className="w-4 h-4" />
                    <span>Enroll in Course to Unlock</span>
                  </button>
                </div>
              ) : !user ? (
                <div className="academic-card p-8 text-center space-y-4">
                  <div className="w-12 h-12 rounded-xl bg-amber-50 border border-amber-200 text-amber-700 flex items-center justify-center mx-auto">
                    <Lock className="w-6 h-6" />
                  </div>
                  <div className="space-y-1">
                    <h3 className="text-base font-bold text-[#172B4D]">Sign In to Access Course Assignments</h3>
                    <p className="text-xs text-slate-500 max-w-md mx-auto">
                      Create or sign in with your student account to enroll and submit assignments.
                    </p>
                  </div>
                  <Link
                    to="/login"
                    state={{ from: location }}
                    className="btn-primary text-xs py-2 px-5 inline-flex items-center gap-2"
                  >
                    <LogIn className="w-4 h-4" />
                    <span>Sign In to Enroll</span>
                  </Link>
                </div>
              ) : loadingAssignments ? (
                <div className="py-12 flex items-center justify-center gap-2 text-xs text-slate-500 academic-card">
                  <Loader2 className="w-5 h-5 animate-spin text-[#0F766E]" />
                  <span>Loading course assignments...</span>
                </div>
              ) : assignments.length === 0 ? (
                <div className="academic-card p-8 text-center space-y-3">
                  <FileText className="w-8 h-8 text-slate-400 mx-auto" />
                  <p className="text-sm font-semibold text-[#172B4D]">No assignments published</p>
                  <p className="text-xs text-slate-500 max-w-sm mx-auto">
                    The instructor has not published any assignments for this course yet.
                  </p>
                </div>
              ) : (
                <div className="space-y-5">
                  {assignments.map((assignment) => {
                    const submission = isEnrolledStudent ? assignment.submission : null;
                    const isSubmitted = isEnrolledStudent && !!submission;
                    const isGraded = isSubmitted && submission?.status === 'graded';
                    const isOverdue = Date.parse(assignment.due_date) < currentTime;
                    const isSubmittingThis = assignmentSubmittingId === assignment.id;
                    const selectedFile = submissionFilesMap[assignment.id];
                    const msg = assignmentMessage?.id === assignment.id ? assignmentMessage : null;

                    return (
                      <div
                        key={assignment.id}
                        className="academic-card p-6 space-y-5"
                      >
                        {/* Assignment Header */}
                        <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-4 pb-4 border-b border-slate-100">
                          <div className="space-y-1.5 flex-1">
                            <div className="flex flex-wrap items-center gap-2">
                              <h3 className="text-base font-bold text-[#172B4D]">{assignment.title}</h3>
                              {isEnrolledStudent && isGraded && submission && (
                                <span className="text-[10px] px-2 py-0.5 rounded-full font-bold bg-teal-50 text-[#0F766E] border border-teal-200 flex items-center gap-1 font-mono">
                                  <Award className="w-3 h-3" />
                                  GRADED: {submission.marks_obtained} / {assignment.max_marks}
                                </span>
                              )}
                              {isEnrolledStudent && isSubmitted && !isGraded && submission && (
                                <span className="text-[10px] px-2 py-0.5 rounded-full font-bold bg-slate-100 text-slate-700 border border-slate-200 font-mono">
                                  {submission.status.toUpperCase()}
                                </span>
                              )}
                              {isEnrolledStudent && !isSubmitted && (
                                <span className="text-[10px] px-2 py-0.5 rounded-full font-bold bg-amber-50 text-amber-800 border border-amber-200 font-mono">
                                  NOT SUBMITTED
                                </span>
                              )}
                              {assignment.allow_resubmission && (
                                <span className="text-[10px] px-2 py-0.5 rounded-full text-slate-500 bg-slate-50 border border-slate-200">
                                  Resubmission Allowed
                                </span>
                              )}
                            </div>
                            <div className="text-xs text-slate-600 leading-relaxed">
                              <MarkdownRenderer content={assignment.description} />
                            </div>
                          </div>

                          <div className="text-right space-y-1 shrink-0 font-medium text-xs">
                            <div className="text-[#172B4D] font-bold">
                              Max Marks: {assignment.max_marks}
                            </div>
                            <div className="text-slate-500 text-[11px] flex items-center gap-1 sm:justify-end">
                              <Calendar className="w-3.5 h-3.5 text-slate-400" />
                              <span>Due: {new Date(assignment.due_date).toLocaleDateString()}</span>
                            </div>
                            {isOverdue && isEnrolledStudent && (
                              <div className="text-[#B91C1C] text-[10px] font-bold">
                                Deadline Passed (Late submissions flagged)
                              </div>
                            )}
                          </div>
                        </div>

                        {/* Instruction Download */}
                        {assignment.instructions_file_path && (
                          <div className="p-3.5 rounded-lg bg-slate-50 border border-slate-200 flex items-center justify-between gap-3">
                            <div className="flex items-center gap-2 text-xs text-slate-700">
                              <FileText className="w-4 h-4 text-[#0F766E] shrink-0" />
                              <span className="font-medium">
                                Assignment Instructions: {assignment.instructions_file_name || 'Instruction Document'}
                              </span>
                            </div>
                            <button
                              onClick={() => handleDownloadInstruction(assignment.instructions_file_path!)}
                              className="btn-secondary text-xs py-1.5 px-3 flex items-center gap-1.5 cursor-pointer"
                            >
                              <Download className="w-3.5 h-3.5" />
                              <span>Download Document</span>
                            </button>
                          </div>
                        )}

                        {/* Instructor Management Banner */}
                        {isCourseInstructor && (
                          <div className="p-3.5 rounded-lg bg-teal-50 border border-teal-200 flex flex-col sm:flex-row sm:items-center justify-between gap-3 text-xs text-teal-900">
                            <div className="flex items-center gap-2">
                              <Sparkles className="w-4 h-4 text-[#0F766E] shrink-0" />
                              <span>Student submissions and grading are managed in Instructor Studio.</span>
                            </div>
                            <Link
                              to="/instructor"
                              className="btn-primary text-xs py-1.5 px-3 flex items-center gap-1 shrink-0"
                            >
                              <span>Open Submissions</span>
                              <ChevronRight className="w-3.5 h-3.5" />
                            </Link>
                          </div>
                        )}

                        {/* Existing Submission Details - Enrolled Students Only */}
                        {isEnrolledStudent && isSubmitted && submission && (
                          <div className="p-4 rounded-lg border border-teal-200 bg-teal-50/40 space-y-3">
                            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                              <div className="flex items-center gap-2">
                                <CheckCircle className="w-4 h-4 text-[#15803D]" />
                                <span className="text-xs font-bold text-[#172B4D]">Your Submitted Work</span>
                                <span className="text-[11px] text-slate-500 font-mono">
                                  ({new Date(submission.submitted_at).toLocaleDateString()} at {new Date(submission.submitted_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })})
                                </span>
                              </div>
                              <button
                                onClick={() => handleDownloadSubmission(submission.file_path)}
                                className="inline-flex items-center gap-1 text-xs text-[#0F766E] hover:underline font-medium cursor-pointer"
                              >
                                <Download className="w-3.5 h-3.5" />
                                <span>{submission.file_name} ({(submission.file_size_bytes / 1024).toFixed(1)} KB)</span>
                              </button>
                            </div>

                            {/* Instructor Evaluation Feedback */}
                            {isGraded && (
                              <div className="p-3.5 rounded-lg bg-white border border-teal-200 space-y-1.5 shadow-2xs">
                                <div className="text-xs font-bold text-[#0F766E] flex items-center justify-between">
                                  <span className="flex items-center gap-1.5">
                                    <Award className="w-4 h-4 text-[#0F766E]" />
                                    <span>Instructor Evaluation</span>
                                  </span>
                                  <span className="font-mono text-sm">
                                    Score: {submission.marks_obtained} / {assignment.max_marks}
                                  </span>
                                </div>
                                {submission.feedback && (
                                  <p className="text-xs text-slate-600 italic pt-1 border-t border-slate-100">
                                    "{submission.feedback}"
                                  </p>
                                )}
                              </div>
                            )}
                          </div>
                        )}

                        {/* Submission Form (New or Resubmission) - Enrolled Students Only */}
                        {isEnrolledStudent && (!isSubmitted || (assignment.allow_resubmission && !isGraded)) && (
                          <div className="space-y-3 pt-3 border-t border-slate-100">
                            <div className="text-xs font-semibold text-[#172B4D] flex items-center gap-1.5">
                              <Upload className="w-4 h-4 text-[#0F766E]" />
                              <span>{isSubmitted ? 'Resubmit Updated Work' : 'Submit Completed Assignment'}</span>
                            </div>

                            <div className="p-4 rounded-lg border border-dashed border-slate-300 bg-slate-50 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                              <div className="space-y-1">
                                <input
                                  type="file"
                                  id={`file-input-${assignment.id}`}
                                  accept=".pdf,.doc,.docx,.zip,application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/zip,application/x-zip-compressed"
                                  onChange={(e) => handleSelectSubmissionFile(assignment.id, e.target.files?.[0] || null)}
                                  className="text-xs text-slate-600 file:mr-3 file:py-1.5 file:px-3 file:rounded-md file:border-0 file:text-xs file:font-semibold file:bg-[#0F766E] file:text-white hover:file:bg-[#115E59] file:cursor-pointer cursor-pointer"
                                />
                                <div className="text-[11px] text-slate-500">
                                  Allowed formats: ZIP, PDF, DOC, DOCX • Maximum file size: 25 MB
                                </div>
                              </div>

                              <button
                                onClick={() => handleSubmitWork(assignment.id)}
                                disabled={isSubmittingThis || !selectedFile}
                                id={`submit-btn-${assignment.id}`}
                                className="btn-primary text-xs py-2 px-4 shrink-0"
                              >
                                {isSubmittingThis ? (
                                  <>
                                    <Loader2 className="w-3.5 h-3.5 animate-spin" />
                                    <span>Uploading & Submitting...</span>
                                  </>
                                ) : (
                                  <>
                                    <Upload className="w-3.5 h-3.5" />
                                    <span>{isSubmitted ? 'Upload Resubmission' : 'Submit Assignment'}</span>
                                  </>
                                )}
                              </button>
                            </div>

                            {/* Message Banner */}
                            {msg && (
                              <div
                                className={`p-3 rounded-lg border text-xs flex items-center gap-2 ${
                                  msg.type === 'success'
                                    ? 'bg-teal-50 border-teal-200 text-[#0F766E]'
                                    : 'bg-rose-50 border-rose-200 text-[#B91C1C]'
                                }`}
                              >
                                {msg.type === 'success' ? (
                                  <CheckCircle className="w-4 h-4 text-[#15803D] shrink-0" />
                                ) : (
                                  <AlertCircle className="w-4 h-4 text-[#B91C1C] shrink-0" />
                                )}
                                <span>{msg.text}</span>
                              </div>
                            )}
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>
              )}
            </div>
          )}

          {/* Quizzes Tab Content */}
          {activeContentTab === 'quizzes' && (
            <div className="space-y-6">
              <div className="flex items-center justify-between">
                <h2 className="text-xl font-bold text-[#172B4D] flex items-center gap-2">
                  <HelpCircle className="w-5 h-5 text-[#0F766E]" />
                  <span>Course Quizzes ({quizzes.length})</span>
                </h2>
                {isEnrolledStudent && (
                  <span className="px-2.5 py-1 rounded-full text-[11px] font-semibold bg-teal-50 text-[#0F766E] border border-teal-200 flex items-center gap-1">
                    <Shield className="w-3 h-3" />
                    Automated Assessment Access
                  </span>
                )}
                {isCourseInstructor && (
                  <Link
                    to="/instructor"
                    className="btn-primary text-xs py-1.5 px-3 flex items-center gap-1.5"
                  >
                    <Sparkles className="w-3.5 h-3.5" />
                    <span>Manage in Studio</span>
                  </Link>
                )}
                {isOtherInstructor && (
                  <span className="px-2.5 py-1 rounded-full text-[11px] font-semibold bg-amber-50 text-amber-800 border border-amber-200">
                    Instructor Preview
                  </span>
                )}
                {isAdminOrSysAdmin && (
                  <Link
                    to="/admin"
                    className="btn-secondary text-xs py-1.5 px-3 flex items-center gap-1.5"
                  >
                    <Shield className="w-3.5 h-3.5" />
                    <span>Admin Portal</span>
                  </Link>
                )}
              </div>

              {!isEnrolledStudent && role === 'student' ? (
                <div className="academic-card p-8 text-center space-y-4">
                  <div className="w-12 h-12 rounded-xl bg-amber-50 border border-amber-200 text-amber-700 flex items-center justify-center mx-auto">
                    <Lock className="w-6 h-6" />
                  </div>
                  <div className="space-y-1">
                    <h3 className="text-base font-bold text-[#172B4D]">Enroll to Take Course Quizzes</h3>
                    <p className="text-xs text-slate-500 max-w-md mx-auto">
                      Multiple choice assessments, instant server grading, and comprehensive answer explanations are available exclusively to enrolled students.
                    </p>
                  </div>
                  <button
                    onClick={handleEnroll}
                    disabled={enrolling}
                    className="btn-primary text-xs py-2 px-5"
                  >
                    <Sparkles className="w-4 h-4" />
                    <span>Enroll in Course to Unlock</span>
                  </button>
                </div>
              ) : !user ? (
                <div className="academic-card p-8 text-center space-y-4">
                  <div className="w-12 h-12 rounded-xl bg-amber-50 border border-amber-200 text-amber-700 flex items-center justify-center mx-auto">
                    <Lock className="w-6 h-6" />
                  </div>
                  <div className="space-y-1">
                    <h3 className="text-base font-bold text-[#172B4D]">Sign In to Take Course Quizzes</h3>
                    <p className="text-xs text-slate-500 max-w-md mx-auto">
                      Sign in with your student account to take quizzes and track assessment performance.
                    </p>
                  </div>
                  <Link
                    to="/login"
                    state={{ from: location }}
                    className="btn-primary text-xs py-2 px-5 inline-flex items-center gap-2"
                  >
                    <LogIn className="w-4 h-4" />
                    <span>Sign In to Enroll</span>
                  </Link>
                </div>
              ) : loadingQuizzes ? (
                <div className="py-12 flex items-center justify-center gap-2 text-xs text-slate-500 academic-card">
                  <Loader2 className="w-5 h-5 animate-spin text-[#0F766E]" />
                  <span>Loading course quizzes...</span>
                </div>
              ) : quizzes.length === 0 ? (
                <div className="academic-card p-8 text-center space-y-3">
                  <HelpCircle className="w-8 h-8 text-slate-400 mx-auto" />
                  <p className="text-sm font-semibold text-[#172B4D]">No quizzes posted</p>
                  <p className="text-xs text-slate-500 max-w-sm mx-auto">
                    The instructor has not published any quizzes for this course yet.
                  </p>
                </div>
              ) : (
                <div className="space-y-5">
                  {quizzes.map((quiz) => {
                    const latestAttempt = isEnrolledStudent ? quiz.latest_attempt : null;
                    const isAttempted = isEnrolledStudent && !!latestAttempt;
                    const passed = isAttempted && latestAttempt && latestAttempt.percentage >= (quiz.passing_score || 0);

                    return (
                      <div
                        key={quiz.id}
                        className="academic-card p-6 space-y-4"
                      >
                        <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-4">
                          <div className="space-y-1.5 flex-1">
                            <div className="flex flex-wrap items-center gap-2">
                              <span className="px-2 py-0.5 rounded text-[10px] font-semibold bg-slate-100 border border-slate-200 text-slate-700">
                                {quiz.time_limit_minutes > 0 ? `${quiz.time_limit_minutes} min limit` : 'Untimed'}
                              </span>
                              <span className="px-2 py-0.5 rounded text-[10px] font-semibold bg-slate-100 border border-slate-200 text-slate-700">
                                Passing: {quiz.passing_score}%
                              </span>
                              {isEnrolledStudent && isAttempted && latestAttempt && (
                                <span
                                  className={`px-2.5 py-0.5 rounded-full text-[10px] font-bold border ${
                                    passed
                                      ? 'bg-teal-50 text-[#0F766E] border-teal-200'
                                      : 'bg-rose-50 text-[#B91C1C] border-rose-200'
                                  }`}
                                >
                                  {passed ? 'Passed' : 'Needs Review'} ({latestAttempt.percentage}%)
                                </span>
                              )}
                            </div>

                            <h3 className="text-base font-bold text-[#172B4D]">{quiz.title}</h3>
                            {quiz.description && (
                              <MarkdownRenderer content={quiz.description} compact />
                            )}
                          </div>

                          {/* Action Buttons */}
                          <div className="shrink-0 flex items-center gap-2">
                            {isEnrolledStudent ? (
                              isAttempted ? (
                                <>
                                  <button
                                    onClick={() => handleOpenReview(quiz)}
                                    className="btn-secondary text-xs py-2 px-3.5 flex items-center gap-1.5 cursor-pointer"
                                  >
                                    <FileText className="w-3.5 h-3.5" />
                                    <span>Review Answers</span>
                                  </button>
                                  <button
                                    onClick={() => handleStartQuiz(quiz)}
                                    className="btn-primary text-xs py-2 px-3.5 flex items-center gap-1.5 cursor-pointer"
                                  >
                                    <RefreshCw className="w-3.5 h-3.5" />
                                    <span>Retake Quiz</span>
                                  </button>
                                </>
                              ) : (
                                <button
                                  onClick={() => handleStartQuiz(quiz)}
                                  className="btn-primary text-xs py-2 px-4 flex items-center gap-1.5 cursor-pointer"
                                >
                                  <PlayCircle className="w-4 h-4" />
                                  <span>Start Quiz</span>
                                </button>
                              )
                            ) : isCourseInstructor ? (
                              <Link
                                to="/instructor"
                                className="btn-secondary text-xs py-2 px-3.5 flex items-center gap-1.5"
                              >
                                <Sparkles className="w-3.5 h-3.5" />
                                <span>Edit in Studio</span>
                              </Link>
                            ) : null}
                          </div>
                        </div>

                        {/* Instructor Info Banner */}
                        {isCourseInstructor && (
                          <div className="p-3.5 rounded-lg bg-slate-50 border border-slate-200 flex flex-col sm:flex-row sm:items-center justify-between gap-3 text-xs text-slate-700">
                            <div className="flex items-center gap-2">
                              <Sparkles className="w-4 h-4 text-[#0F766E] shrink-0" />
                              <span>Multiple choice questions, answer keys, and scoring thresholds are managed in Studio.</span>
                            </div>
                            <Link
                              to="/instructor"
                              className="btn-secondary text-xs py-1.5 px-3 flex items-center gap-1 shrink-0"
                            >
                              <span>Open Quiz Manager</span>
                              <ChevronRight className="w-3.5 h-3.5" />
                            </Link>
                          </div>
                        )}

                        {/* Attempt Summary - Enrolled Students Only */}
                        {isEnrolledStudent && isAttempted && latestAttempt && (
                          <div className="p-3.5 rounded-lg border border-slate-200 bg-slate-50 flex flex-col sm:flex-row sm:items-center justify-between gap-3 text-xs">
                            <div className="flex items-center gap-2 text-slate-500 font-medium">
                              <Clock className="w-3.5 h-3.5 text-slate-400" />
                              <span>Last Attempt: {new Date(latestAttempt.submitted_at).toLocaleString()}</span>
                            </div>
                            <div className="flex items-center gap-3 font-medium">
                              <span className="text-[#172B4D] font-bold">
                                Score: {latestAttempt.score} / {latestAttempt.max_score} pts
                              </span>
                              <span className={passed ? 'text-[#15803D] font-bold' : 'text-[#B91C1C] font-bold'}>
                                {latestAttempt.percentage}%
                              </span>
                            </div>
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>
              )}
            </div>
          )}
        </div>

        {/* Sidebar: Instructor Bio & Material Highlights */}
        <div className="space-y-6">
          <div className="academic-card p-6 space-y-4">
            <h3 className="text-xs font-bold text-[#172B4D] uppercase tracking-wider">Course Instructor</h3>
            <div className="flex items-center gap-3">
              <img
                src={course.instructor?.avatar_url || defaultAvatar}
                alt={course.instructor?.full_name || 'Course Instructor'}
                className="w-12 h-12 rounded-full object-cover border border-slate-200"
              />
              <div>
                <div className="text-sm font-bold text-[#172B4D]">
                  {course.instructor?.full_name || 'EduSphere Instructor'}
                </div>
                <div className="text-xs text-slate-500 capitalize">
                  {course.instructor?.role ? `${course.instructor.role.replace('_', ' ')}` : 'Instructor'}
                </div>
              </div>
            </div>
            {course.instructor?.bio && (
              <p className="text-xs text-slate-600 leading-relaxed border-t border-slate-100 pt-3">
                {course.instructor.bio}
              </p>
            )}
          </div>

          <div className="academic-card p-6 space-y-4">
            <h3 className="text-xs font-bold text-[#172B4D] uppercase tracking-wider">Curriculum Materials</h3>
            <ul className="space-y-2.5 text-xs text-slate-600">
              <li className="flex items-center gap-2">
                <FileText className="w-4 h-4 text-[#0F766E]" />
                <span>Lecture Transcripts & Notes</span>
              </li>
              <li className="flex items-center gap-2">
                <FileText className="w-4 h-4 text-[#0F766E]" />
                <span>Full Source Code & Problem Sets</span>
              </li>
              <li className="flex items-center gap-2">
                <Award className="w-4 h-4 text-[#15803D]" />
                <span>Verified Completion Credential</span>
              </li>
            </ul>
          </div>
        </div>

      </div>

      {/* Interactive Lesson Workspace */}
      {activeLesson && (
        <div
          role="dialog"
          aria-modal="true"
          aria-labelledby="lesson-modal-title"
          className="fixed inset-0 z-50 flex items-center justify-center p-2 sm:p-4 md:p-6 bg-[#1F2421]/70 backdrop-blur-xs"
        >
          <div className="bg-[#FAF9F5] rounded-xl max-w-5xl w-full border border-[#E5E2D9] shadow-2xl flex flex-col h-[94vh] sm:h-[92vh] max-h-[94dvh] overflow-hidden">
            {/* Modal Fixed Header */}
            <div className="px-5 sm:px-6 py-3.5 border-b border-[#E5E2D9] bg-[#FAF9F5] flex items-center justify-between shrink-0">
              <div className="space-y-0.5 min-w-0 pr-4">
                <div className="flex items-center gap-2 text-xs font-medium text-[#1B3B2B]">
                  <span className="font-semibold">
                    Lesson #{lessons.findIndex((l) => l.id === activeLesson.id) + 1} of {lessons.length}
                  </span>
                  <span>•</span>
                  <span className="flex items-center gap-1 text-[#535C56]">
                    <Clock className="w-3 h-3 text-[#7A857E]" />
                    {activeLesson.duration_minutes ? `${activeLesson.duration_minutes} mins` : 'Self-paced'}
                  </span>
                  {activeLesson.is_free_preview && (
                    <span className="px-1.5 py-0.5 rounded text-[10px] font-semibold bg-[#EAEFE9] text-[#1B3B2B] border border-[#C8D6CA]">
                      Free Preview
                    </span>
                  )}
                </div>
                <h2 id="lesson-modal-title" className="font-editorial text-lg sm:text-xl md:text-2xl text-[#1F2421] truncate">
                  {activeLesson.title}
                </h2>
              </div>
              <button
                onClick={() => setActiveLesson(null)}
                className="p-2 rounded-md text-[#535C56] hover:text-[#1F2421] hover:bg-[#EAE6DD] transition-colors cursor-pointer shrink-0"
                aria-label="Close lesson modal"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {/* Navigation Tabs Bar */}
            <div className="px-5 sm:px-6 py-2 border-b border-[#E5E2D9] bg-[#F4F1EA] flex items-center justify-between gap-2 shrink-0">
              <div className="flex items-center gap-2">
                <button
                  onClick={() => setActiveLessonTab('content')}
                  className={`inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-md text-xs font-semibold transition-colors cursor-pointer ${
                    activeLessonTab === 'content'
                      ? 'bg-[#1B3B2B] text-white shadow-2xs'
                      : 'text-[#535C56] hover:text-[#1F2421] hover:bg-[#EAE6DD]'
                  }`}
                >
                  <BookOpen className="w-3.5 h-3.5" />
                  <span>Lecture Notes & Video</span>
                </button>
                <button
                  onClick={() => setActiveLessonTab('ai_doubt')}
                  className={`inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-md text-xs font-semibold transition-colors cursor-pointer ${
                    activeLessonTab === 'ai_doubt'
                      ? 'bg-[#1B3B2B] text-white shadow-2xs'
                      : 'text-[#535C56] hover:text-[#1F2421] hover:bg-[#EAE6DD]'
                  }`}
                >
                  <Sparkles className="w-3.5 h-3.5" />
                  <span>AI Doubt Assistant</span>
                </button>
              </div>

              {/* Course Title Context */}
              <div className="hidden sm:flex items-center gap-2 text-xs text-[#535C56]">
                <span className="truncate max-w-[280px] text-[11px] font-medium">
                  {course.title}
                </span>
              </div>
            </div>

            {/* Primary Scrollable Workspace Content */}
            <div className="flex-1 overflow-y-auto min-h-0 bg-[#FAF9F5]">
              {activeLessonTab === 'content' && (
                <div className="p-5 sm:p-7 space-y-6 max-w-4xl mx-auto">
                  {activeLesson.video_url && (
                    <div className="rounded-lg overflow-hidden border border-[#E5E2D9] shadow-xs bg-black">
                      <LessonVideoPlayer
                        videoUrl={activeLesson.video_url}
                        title={activeLesson.title}
                        isFreePreview={activeLesson.is_free_preview}
                      />
                    </div>
                  )}

                  <div className="space-y-3">
                    <h3 className="text-xs font-bold uppercase tracking-wider text-[#535C56] flex items-center gap-2">
                      <FileText className="w-3.5 h-3.5 text-[#1B3B2B]" />
                      <span>Lesson Syllabus & Study Notes</span>
                    </h3>
                    <div className="p-6 rounded-lg bg-white border border-[#E5E2D9] shadow-xs">
                      <MarkdownRenderer content={activeLesson.content || 'No lecture notes provided for this lesson.'} />
                    </div>
                  </div>
                </div>
              )}

              {activeLessonTab === 'ai_doubt' && course && (
                <div className="h-full flex flex-col p-4 sm:p-6 max-w-4xl mx-auto w-full">
                  <LessonDoubtPanel
                    lesson={activeLesson}
                    course={course}
                    userRole={role}
                    isEnrolled={isEnrolled}
                    studentName={user?.fullName}
                  />
                </div>
              )}
            </div>

            {/* Modal Fixed Footer Navigation */}
            <div className="px-5 sm:px-6 py-3 border-t border-[#E5E2D9] bg-[#F4F1EA] flex flex-col sm:flex-row items-center justify-between gap-3 shrink-0">
              <div className="flex items-center gap-2 w-full sm:w-auto">
                <button
                  onClick={handlePrevLesson}
                  disabled={lessons.findIndex((l) => l.id === activeLesson.id) === 0}
                  className="btn-secondary flex-1 sm:flex-initial text-xs py-2 px-3.5 disabled:opacity-40"
                  aria-label="Previous lesson"
                >
                  <ChevronLeft className="w-4 h-4" />
                  <span>Previous</span>
                </button>
                <button
                  onClick={handleNextLesson}
                  disabled={lessons.findIndex((l) => l.id === activeLesson.id) === lessons.length - 1}
                  className="btn-secondary flex-1 sm:flex-initial text-xs py-2 px-3.5 disabled:opacity-40"
                  aria-label="Next lesson"
                >
                  <span>Next</span>
                  <ChevronRight className="w-4 h-4" />
                </button>
              </div>

              {isEnrolled && (
                <button
                  onClick={() => handleToggleLesson(activeLesson.id)}
                  disabled={updatingProgress}
                  className={`w-full sm:w-auto inline-flex items-center justify-center gap-2 px-5 py-2 rounded-md text-xs font-semibold transition-all cursor-pointer ${
                    completedLessonIds.includes(activeLesson.id)
                      ? 'bg-[#EAEFE9] text-[#1B3B2B] border border-[#C8D6CA] hover:bg-[#DFE7DF]'
                      : 'btn-forest text-xs'
                  }`}
                >
                  {completedLessonIds.includes(activeLesson.id) ? (
                    <>
                      <CheckCircle2 className="w-4 h-4 text-[#1B3B2B]" />
                      <span>Completed</span>
                    </>
                  ) : (
                    <>
                      <Circle className="w-4 h-4" />
                      <span>Mark Lesson Complete</span>
                    </>
                  )}
                </button>
              )}
            </div>
          </div>
        </div>
      )}

      {/* Enrollment Confirmation Modal */}
      {showEnrollModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/60 backdrop-blur-sm animate-in fade-in">
          <div className="bg-white p-6 sm:p-8 rounded-2xl max-w-md w-full border border-slate-200 text-center space-y-4 shadow-xl">
            <div className="w-12 h-12 rounded-full bg-emerald-50 text-emerald-700 flex items-center justify-center mx-auto border border-emerald-200">
              <CheckCircle className="w-6 h-6" />
            </div>
            <h3 className="text-xl font-bold text-[#172B4D]">Enrollment Confirmed</h3>
            <p className="text-sm text-slate-600 leading-relaxed">
              You are now enrolled in <strong>{course.title}</strong>. All syllabus lectures, resources, and assessments are unlocked.
            </p>
            <div className="pt-2 flex flex-col gap-2.5">
              <Link
                to="/dashboard"
                className="w-full py-2.5 rounded-lg bg-teal-700 hover:bg-teal-800 text-white font-semibold text-xs transition-colors flex items-center justify-center gap-2 shadow-sm"
              >
                <span>View on Student Dashboard</span>
                <ExternalLink className="w-3.5 h-3.5" />
              </Link>
              <button
                onClick={() => setShowEnrollModal(false)}
                className="w-full py-2.5 rounded-lg border border-slate-300 hover:bg-slate-50 text-slate-700 font-semibold text-xs transition-colors"
              >
                Continue on Course Page
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Verified Certificate Modal */}
      {showCertificate && isEnrolledStudent && enrollment && course && (
        <CertificateModal
          course={course}
          enrollment={enrollment}
          studentName={user?.fullName || 'Student'}
          onClose={() => setShowCertificate(false)}
        />
      )}

      {/* Interactive Quiz-Taking Modal */}
      {takingQuiz && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/60 backdrop-blur-sm animate-in fade-in">
          <div className="w-full max-w-3xl bg-white rounded-2xl border border-slate-200 p-6 sm:p-8 space-y-6 shadow-2xl overflow-y-auto max-h-[90vh]">
            <div className="flex items-center justify-between pb-4 border-b border-slate-200">
              <div className="space-y-1">
                <div className="flex items-center gap-2">
                  <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold font-mono uppercase bg-teal-50 text-teal-800 border border-teal-200">
                    Live Assessment
                  </span>
                  {takingQuiz.time_limit_minutes > 0 && (
                    <span className="px-2.5 py-0.5 rounded-full text-[11px] font-mono bg-slate-100 text-slate-700 border border-slate-200">
                      {takingQuiz.time_limit_minutes} Mins
                    </span>
                  )}
                </div>
                <h3 className="text-xl font-bold text-[#172B4D]">{takingQuiz.title}</h3>
                {takingQuiz.description && (
                  <MarkdownRenderer content={takingQuiz.description} compact />
                )}
              </div>
              <button
                onClick={() => {
                  if (confirm('Are you sure you want to exit? Your answers will not be saved.')) {
                    setTakingQuiz(null);
                  }
                }}
                className="p-1.5 rounded-lg border border-slate-200 hover:bg-slate-100 text-slate-500 hover:text-slate-800 transition-colors"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {loadingQuizQuestions ? (
              <div className="py-16 text-center text-xs text-slate-500 flex items-center justify-center gap-2">
                <Loader2 className="w-5 h-5 animate-spin text-teal-700" />
                <span>Loading examination questions...</span>
              </div>
            ) : takingQuestions.length === 0 ? (
              <div className="py-12 text-center space-y-2">
                <p className="text-sm font-semibold text-slate-700">No questions found</p>
                <p className="text-xs text-slate-500">The instructor has not added questions to this quiz yet.</p>
              </div>
            ) : (
              <div className="space-y-6">
                <div className="text-xs font-mono text-slate-600 flex items-center justify-between bg-slate-50 px-4 py-2.5 rounded-lg border border-slate-200">
                  <span>Questions: {takingQuestions.length}</span>
                  <span className="font-semibold text-slate-800">
                    Answered: {Object.keys(selectedQuizAnswers).length} / {takingQuestions.length}
                  </span>
                </div>

                <div className="space-y-6">
                  {takingQuestions.map((q, idx) => {
                    const selectedIdx = selectedQuizAnswers[q.id];

                    return (
                      <div
                        key={q.id}
                        className="p-5 rounded-xl bg-slate-50/70 border border-slate-200 space-y-4"
                      >
                        <div className="flex items-center justify-between">
                          <span className="text-xs font-bold text-teal-800 font-mono">
                            Question {idx + 1} of {takingQuestions.length}
                          </span>
                          <span className="text-xs font-mono text-slate-500">
                            {q.marks} {q.marks === 1 ? 'Mark' : 'Marks'}
                          </span>
                        </div>

                        <div className="text-sm font-semibold text-[#172B4D] leading-relaxed">
                          <MarkdownRenderer content={q.question_text} compact />
                        </div>

                        <div className="space-y-2.5">
                          {q.options.map((opt, optIdx) => {
                            const isChosen = selectedIdx === optIdx;

                            return (
                              <button
                                key={optIdx}
                                type="button"
                                onClick={() => handleSelectQuizAnswer(q.id, optIdx)}
                                className={`w-full text-left p-3.5 rounded-lg border text-xs font-medium transition-all flex items-center gap-3 ${
                                  isChosen
                                    ? 'bg-teal-50 border-teal-600 text-teal-950 font-semibold shadow-xs'
                                    : 'bg-white border-slate-200 text-slate-700 hover:bg-slate-50 hover:border-slate-300'
                                }`}
                              >
                                <span
                                  className={`w-6 h-6 rounded-md flex items-center justify-center font-mono text-xs font-bold shrink-0 border ${
                                    isChosen
                                      ? 'bg-teal-700 text-white border-teal-700'
                                      : 'bg-slate-100 text-slate-600 border-slate-300'
                                  }`}
                                >
                                  {String.fromCharCode(65 + optIdx)}
                                </span>
                                <span className="flex-1">{opt}</span>
                              </button>
                            );
                          })}
                        </div>
                      </div>
                    );
                  })}
                </div>

                <div className="pt-4 flex items-center justify-end gap-3 border-t border-slate-200">
                  <button
                    type="button"
                    onClick={() => {
                      if (confirm('Cancel quiz attempt?')) setTakingQuiz(null);
                    }}
                    className="px-4 py-2.5 rounded-lg border border-slate-300 hover:bg-slate-50 text-slate-700 text-xs font-semibold transition-colors"
                  >
                    Cancel
                  </button>
                  <button
                    type="button"
                    onClick={handleSubmitQuiz}
                    disabled={submittingQuizAttempt}
                    className="inline-flex items-center gap-2 px-6 py-2.5 rounded-lg bg-teal-700 hover:bg-teal-800 disabled:opacity-50 text-white text-xs font-bold transition-all shadow-sm"
                  >
                    {submittingQuizAttempt ? (
                      <Loader2 className="w-4 h-4 animate-spin" />
                    ) : (
                      <CheckSquare className="w-4 h-4" />
                    )}
                    <span>Submit Assessment</span>
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>
      )}

      {/* Question-by-Question Review Modal */}
      {quizReviewAttempt && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/60 backdrop-blur-sm animate-in fade-in">
          <div className="w-full max-w-3xl bg-white rounded-2xl border border-slate-200 p-6 sm:p-8 space-y-6 shadow-2xl overflow-y-auto max-h-[90vh]">
            <div className="flex items-center justify-between pb-4 border-b border-slate-200">
              <div className="space-y-1">
                <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold font-mono uppercase bg-slate-100 text-slate-700 border border-slate-200">
                  Results Review
                </span>
                <h3 className="text-xl font-bold text-[#172B4D]">
                  Assessment Review: {reviewingQuizTitle}
                </h3>
                <p className="text-xs text-slate-500">
                  Submitted at: {new Date(quizReviewAttempt.submitted_at).toLocaleString()}
                </p>
              </div>
              <button
                onClick={() => setQuizReviewAttempt(null)}
                className="p-1.5 rounded-lg border border-slate-200 hover:bg-slate-100 text-slate-500 hover:text-slate-800 transition-colors"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {/* Scorecard Banner */}
            <div className="p-5 rounded-xl bg-slate-50 border border-slate-200 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
              <div className="space-y-1">
                <span className="text-xs font-mono text-slate-500 block">Overall Score</span>
                <div className="text-2xl font-bold font-mono text-[#172B4D] flex items-center gap-2">
                  <span>{quizReviewAttempt.score} / {quizReviewAttempt.max_score}</span>
                  <span className="text-sm font-normal text-slate-600 font-mono">
                    ({quizReviewAttempt.percentage}%)
                  </span>
                </div>
              </div>

              <div className="flex items-center gap-2">
                <span
                  className={`px-3 py-1 rounded-full text-xs font-bold font-mono border ${
                    quizReviewAttempt.percentage >= 70
                      ? 'bg-emerald-50 text-emerald-800 border-emerald-200'
                      : 'bg-rose-50 text-rose-800 border-rose-200'
                  }`}
                >
                  {quizReviewAttempt.percentage >= 70 ? 'Passed Examination' : 'Needs Further Review'}
                </span>
              </div>
            </div>

            {/* Questions Detailed Breakdown */}
            <div className="space-y-5">
              <h4 className="text-xs font-bold uppercase tracking-wider text-slate-600 font-mono">
                Question Performance & Rationales
              </h4>

              {quizReviewAttempt.detailed_results?.map((rev, rIdx) => (
                <div
                  key={rIdx}
                  className={`p-5 rounded-xl border space-y-3.5 ${
                    rev.is_correct
                      ? 'bg-emerald-50/40 border-emerald-200'
                      : 'bg-rose-50/40 border-rose-200'
                  }`}
                >
                  <div className="flex items-center justify-between gap-2">
                    <span className="text-xs font-mono font-bold text-slate-600">
                      Question #{rIdx + 1}
                    </span>
                    <span
                      className={`px-2.5 py-0.5 rounded-full text-[11px] font-mono font-bold ${
                        rev.is_correct ? 'text-emerald-800 bg-emerald-100/70' : 'text-rose-800 bg-rose-100/70'
                      }`}
                    >
                      {rev.marks_earned} / {rev.max_marks} pts ({rev.is_correct ? 'Correct' : 'Incorrect'})
                    </span>
                  </div>

                  <div className="text-sm font-semibold text-[#172B4D] leading-relaxed">
                    <MarkdownRenderer content={rev.question_text} compact />
                  </div>

                  <div className="space-y-2">
                    {rev.options.map((opt, optIdx) => {
                      const isSelected = rev.selected_option === optIdx;
                      const isCorrect = rev.correct_option === optIdx;

                      let style = 'bg-white border-slate-200 text-slate-600';
                      if (isCorrect) {
                        style = 'bg-emerald-100/60 border-emerald-300 text-emerald-950 font-semibold';
                      } else if (isSelected && !isCorrect) {
                        style = 'bg-rose-100/60 border-rose-300 text-rose-950 line-through';
                      }

                      return (
                        <div
                          key={optIdx}
                          className={`p-3 rounded-lg border text-xs flex items-center justify-between gap-2 ${style}`}
                        >
                          <div className="flex items-center gap-2.5">
                            <span className="font-mono text-xs font-bold text-slate-700">
                              {String.fromCharCode(65 + optIdx)}.
                            </span>
                            <span>{opt}</span>
                          </div>
                          <div className="shrink-0 text-[11px] font-mono">
                            {isCorrect && (
                              <span className="text-emerald-800 font-bold flex items-center gap-1">
                                <CheckCircle2 className="w-3.5 h-3.5" />
                                <span>Correct Answer</span>
                              </span>
                            )}
                            {isSelected && !isCorrect && (
                              <span className="text-rose-800 font-bold flex items-center gap-1">
                                <X className="w-3.5 h-3.5" />
                                <span>Your Answer</span>
                              </span>
                            )}
                          </div>
                        </div>
                      );
                    })}
                  </div>

                  {rev.explanation && (
                    <div className="p-3 rounded-lg bg-white border border-slate-200 text-xs text-slate-600 space-y-1">
                      <div className="text-[11px] font-semibold text-teal-800 flex items-center gap-1">
                        <Sparkles className="w-3.5 h-3.5" />
                        <span>Instructor's Explanation</span>
                      </div>
                      <MarkdownRenderer content={rev.explanation} compact />
                    </div>
                  )}
                </div>
              ))}
            </div>

            <div className="pt-4 flex justify-end border-t border-slate-200">
              <button
                type="button"
                onClick={() => setQuizReviewAttempt(null)}
                className="px-5 py-2.5 rounded-lg bg-teal-700 hover:bg-teal-800 text-white text-xs font-bold transition-colors shadow-sm"
              >
                Close Review
              </button>
            </div>
          </div>
        </div>
      )}

    </div>
  );
};

