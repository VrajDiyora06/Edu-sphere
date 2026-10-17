import React, { useState, useEffect, useCallback } from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../context/useAuth';
import { getStudentEnrollments } from '../lib/enrollments';
import { getCourseQuizzes } from '../lib/quizzes';
import { getCourseAssignments } from '../lib/assignments';
import { getCourseCoverDisplayUrl } from '../lib/media';
import type { EnrolledCourseItem, QuizWithStudentStatus, AssignmentWithSubmission } from '../types';
import { CertificateModal } from '../components/CertificateModal';
import { RecommendedCoursesSection } from '../components/RecommendedCoursesSection';
import {
  GraduationCap,
  BookOpen,
  Clock,
  ArrowRight,
  CheckCircle2,
  AlertCircle,
  RefreshCw,
  Loader2,
  BarChart2,
  Award,
  PlayCircle,
  FileText,
  HelpCircle,
  Calendar,
  CheckSquare,
} from 'lucide-react';

export interface EnrolledQuizItem extends QuizWithStudentStatus {
  courseTitle: string;
  courseCategory: string;
}

export interface EnrolledAssignmentItem extends AssignmentWithSubmission {
  courseTitle: string;
  courseCategory: string;
}

const FALLBACK_THUMBNAIL =
  'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=800&auto=format&fit=crop';
const FALLBACK_AVATAR =
  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=120&auto=format&fit=crop';

export const StudentDashboardPage: React.FC = () => {
  const { user } = useAuth();
  const [enrollments, setEnrollments] = useState<EnrolledCourseItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedCertificateCourse, setSelectedCertificateCourse] =
    useState<EnrolledCourseItem | null>(null);

  // Available assessments & assignments state
  const [dashboardQuizzes, setDashboardQuizzes] = useState<EnrolledQuizItem[]>([]);
  const [dashboardAssignments, setDashboardAssignments] = useState<EnrolledAssignmentItem[]>([]);
  const [loadingAssessments, setLoadingAssessments] = useState(false);
  const [assessmentTab, setAssessmentTab] = useState<'quizzes' | 'assignments'>('quizzes');

  const userId = user?.id;

  const fetchEnrollments = useCallback(async () => {
    if (!userId) return;
    setLoading(true);
    setError(null);

    const { data, error: fetchErr } = await getStudentEnrollments(userId);

    if (fetchErr) {
      setError(fetchErr.message || 'Failed to load your enrolled courses.');
      setEnrollments([]);
    } else {
      setEnrollments(data || []);
    }
    setLoading(false);
  }, [userId]);

  useEffect(() => {
    if (!userId) return;
    let ignore = false;

    getStudentEnrollments(userId).then(({ data, error: fetchErr }) => {
      if (ignore) return;
      if (fetchErr) {
        setError(fetchErr.message || 'Failed to load your enrolled courses.');
        setEnrollments([]);
      } else {
        setEnrollments(data || []);
      }
      setLoading(false);
    });

    return () => {
      ignore = true;
    };
  }, [userId]);

  // Fetch quizzes and assignments across enrolled courses
  useEffect(() => {
    if (!userId || enrollments.length === 0) {
      setDashboardQuizzes([]);
      setDashboardAssignments([]);
      return;
    }

    let ignore = false;
    setLoadingAssessments(true);

    const fetchAllAssessments = async () => {
      try {
        const quizPromises = enrollments.map(async (enr) => {
          const { data } = await getCourseQuizzes(enr.course_id, false, userId);
          return (data || []).map((q) => ({
            ...q,
            courseTitle: enr.course?.title || 'Enrolled Course',
            courseCategory: enr.course?.category || 'Curriculum',
          }));
        });

        const assignmentPromises = enrollments.map(async (enr) => {
          const { data } = await getCourseAssignments(enr.course_id, userId, false);
          return (data || []).map((a) => ({
            ...a,
            courseTitle: enr.course?.title || 'Enrolled Course',
            courseCategory: enr.course?.category || 'Curriculum',
          }));
        });

        const [quizArrays, assignmentArrays] = await Promise.all([
          Promise.all(quizPromises),
          Promise.all(assignmentPromises),
        ]);

        if (!ignore) {
          setDashboardQuizzes(quizArrays.flat());
          setDashboardAssignments(assignmentArrays.flat());
        }
      } catch (err) {
        console.error('Error loading dashboard coursework assessments:', err);
      } finally {
        if (!ignore) {
          setLoadingAssessments(false);
        }
      }
    };

    fetchAllAssessments();

    return () => {
      ignore = true;
    };
  }, [userId, enrollments]);

  // Derived statistics
  const totalEnrolled = enrollments.length;
  const completedCount = enrollments.filter((e) => e.is_completed).length;
  const inProgressCourses = enrollments.filter((e) => !e.is_completed);
  const inProgressCount = inProgressCourses.length;
  const averageProgress =
    totalEnrolled > 0
      ? Math.round(
          enrollments.reduce((acc, curr) => acc + (curr.progress_percent || 0), 0) /
            totalEnrolled
        )
      : 0;

  // Prominent Continue Learning target: most recently active in-progress course
  const continueLearningItem = inProgressCourses[0] || null;

  return (
    <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-12 space-y-10">
      {/* Editorial Header Banner */}
      <div className="academic-card p-6 sm:p-8 space-y-6">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div className="space-y-1.5">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#F4F1EA] border border-[#E5E2D9] text-xs font-medium text-[#1B3B2B]">
              <GraduationCap className="w-4 h-4 text-[#1B3B2B]" />
              <span>Student Learning Center</span>
            </div>
            <h1 className="font-editorial text-2xl sm:text-3xl text-[#1F2421] font-normal tracking-tight">
              Welcome back, {user?.fullName || 'Student'}
            </h1>
            <p className="text-xs sm:text-sm text-[#535C56]">
              Track your coursework progression, lesson milestones, and verified certificates.
            </p>
          </div>

          <Link
            to="/courses"
            className="btn-forest self-start sm:self-auto text-xs py-2 px-4 inline-flex items-center gap-1.5"
          >
            <BookOpen className="w-3.5 h-3.5" />
            <span>Browse More Courses</span>
          </Link>
        </div>

        {/* Real Metrics Grid */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 pt-4 border-t border-[#E5E2D9]">
          <div className="bg-[#FAF9F5] p-4 rounded-lg border border-[#E5E2D9] text-center">
            <div className="text-2xl font-semibold text-[#1F2421] font-mono">{totalEnrolled}</div>
            <div className="text-xs text-[#535C56] mt-0.5">Enrolled Courses</div>
          </div>
          <div className="bg-[#FAF9F5] p-4 rounded-lg border border-[#E5E2D9] text-center">
            <div className="text-2xl font-semibold text-[#1B3B2B] font-mono">{inProgressCount}</div>
            <div className="text-xs text-[#535C56] mt-0.5">In Progress</div>
          </div>
          <div className="bg-[#FAF9F5] p-4 rounded-lg border border-[#E5E2D9] text-center">
            <div className="text-2xl font-semibold text-[#1B3B2B] font-mono">{completedCount}</div>
            <div className="text-xs text-[#535C56] mt-0.5">Completed</div>
          </div>
          <div className="bg-[#FAF9F5] p-4 rounded-lg border border-[#E5E2D9] text-center">
            <div className="text-2xl font-semibold text-[#1F2421] font-mono">{averageProgress}%</div>
            <div className="text-xs text-[#535C56] mt-0.5">Average Progress</div>
          </div>
        </div>
      </div>

      {/* Prominent Continue Learning Section */}
      {continueLearningItem && continueLearningItem.course && (
        <section className="space-y-3">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold uppercase tracking-wider text-[#1B3B2B]">
              Active Studies
            </span>
            <span className="text-xs text-[#535C56]">
              {continueLearningItem.progress_percent || 0}% Completed
            </span>
          </div>

          <div className="academic-card p-6 border-[#1B3B2B]/30 hover:border-[#1B3B2B] transition-colors">
            <div className="flex flex-col md:flex-row gap-6 items-start md:items-center justify-between">
              <div className="flex items-start sm:items-center gap-4 min-w-0">
                <img
                  src={getCourseCoverDisplayUrl(continueLearningItem.course.thumbnail_url)}
                  alt={continueLearningItem.course.title}
                  className="w-24 h-16 sm:w-32 sm:h-20 object-cover rounded border border-[#E5E2D9] shrink-0"
                  onError={(e) => {
                    (e.target as HTMLImageElement).src = FALLBACK_THUMBNAIL;
                  }}
                />
                <div className="space-y-1 min-w-0">
                  <div className="flex items-center gap-2 text-xs text-[#535C56]">
                    <span className="px-2 py-0.5 rounded text-[10px] font-semibold bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9]">
                      {continueLearningItem.course.category}
                    </span>
                    <span>•</span>
                    <span>{continueLearningItem.course.level}</span>
                  </div>
                  <h3 className="font-editorial text-lg sm:text-xl text-[#1F2421] truncate">
                    {continueLearningItem.course.title}
                  </h3>
                  <div className="flex items-center gap-3 text-xs text-[#535C56]">
                    <span>Instructor: {continueLearningItem.instructor?.full_name || 'EduSphere Faculty'}</span>
                    <span>•</span>
                    <span>{continueLearningItem.lessons_count || 0} Lessons</span>
                  </div>
                </div>
              </div>

              <div className="w-full md:w-64 space-y-3 shrink-0">
                <div className="space-y-1">
                  <div className="flex justify-between text-xs text-[#535C56]">
                    <span>Progress</span>
                    <span className="font-mono text-[#1B3B2B] font-semibold">
                      {continueLearningItem.progress_percent || 0}%
                    </span>
                  </div>
                  <div className="w-full h-1.5 bg-[#EAE6DD] rounded-full overflow-hidden">
                    <div
                      className="h-full bg-[#1B3B2B] rounded-full transition-all duration-300"
                      style={{ width: `${Math.min(100, Math.max(0, continueLearningItem.progress_percent || 0))}%` }}
                    />
                  </div>
                </div>
                <Link
                  to={`/courses/${continueLearningItem.course.id}`}
                  className="btn-forest w-full text-xs py-2 flex items-center justify-center gap-2 font-semibold"
                >
                  <PlayCircle className="w-4 h-4" />
                  <span>Resume Learning</span>
                </Link>
              </div>
            </div>
          </div>
        </section>
      )}

      {/* Loading State */}
      {loading && (
        <div className="academic-card p-16 text-center space-y-3">
          <Loader2 className="w-6 h-6 text-[#1B3B2B] animate-spin mx-auto" />
          <h3 className="font-editorial text-lg text-[#1F2421]">Loading Coursework</h3>
          <p className="text-xs text-[#535C56]">Fetching personal enrollment records from database...</p>
        </div>
      )}

      {/* Error State */}
      {!loading && error && (
        <div className="academic-card p-10 text-center border-[#F5C2BA] bg-[#FDF1EE]/40 space-y-4">
          <AlertCircle className="w-8 h-8 text-[#9E3D2B] mx-auto" />
          <div className="space-y-1">
            <h3 className="font-editorial text-lg text-[#1F2421]">Unable to Load Enrollments</h3>
            <p className="text-xs text-[#9E3D2B] max-w-md mx-auto">{error}</p>
          </div>
          <button onClick={fetchEnrollments} className="btn-forest text-xs">
            <RefreshCw className="w-3.5 h-3.5 mr-1" />
            <span>Try Again</span>
          </button>
        </div>
      )}

      {/* Empty State */}
      {!loading && !error && enrollments.length === 0 && (
        <div className="academic-card p-16 text-center space-y-5">
          <div className="w-12 h-12 rounded bg-[#F4F1EA] border border-[#E5E2D9] text-[#1B3B2B] flex items-center justify-center mx-auto">
            <BookOpen className="w-6 h-6" />
          </div>
          <div className="space-y-1.5 max-w-md mx-auto">
            <h2 className="font-editorial text-xl text-[#1F2421]">No Enrolled Courses Yet</h2>
            <p className="text-xs text-[#535C56] leading-relaxed">
              You have not enrolled in any courses yet. Browse our university catalog to begin learning at zero tuition.
            </p>
          </div>
          <div className="pt-2">
            <Link to="/courses" className="btn-forest text-xs py-2 px-5 inline-flex items-center gap-2">
              <span>Explore Course Catalog</span>
              <ArrowRight className="w-3.5 h-3.5" />
            </Link>
          </div>
        </div>
      )}

      {/* Enrolled Courses Grid */}
      {!loading && !error && enrollments.length > 0 && (
        <div className="space-y-6">
          <div className="flex items-center justify-between border-b border-[#E5E2D9] pb-3">
            <h2 className="font-editorial text-xl sm:text-2xl text-[#1F2421] flex items-center gap-2">
              <BookOpen className="w-5 h-5 text-[#1B3B2B]" />
              <span>All Enrolled Coursework ({enrollments.length})</span>
            </h2>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {enrollments.map((item) => {
              const course = item.course;
              const courseTitle = course?.title || 'Course Details Unavailable';
              const courseCategory = course?.category || 'General';
              const courseLevel = course?.level || 'All Levels';
              const thumbnail = getCourseCoverDisplayUrl(course?.thumbnail_url);
              const instructorName = item.instructor?.full_name || 'EduSphere Faculty';
              const instructorAvatar = item.instructor?.avatar_url || FALLBACK_AVATAR;
              const progress = item.progress_percent || 0;
              const enrolledDate = item.enrolled_at
                ? new Date(item.enrolled_at).toLocaleDateString(undefined, {
                    year: 'numeric',
                    month: 'short',
                    day: 'numeric',
                  })
                : 'Recently';

              return (
                <div
                  key={item.id}
                  className="academic-card overflow-hidden flex flex-col justify-between group hover:border-[#1B3B2B]/40 transition-colors"
                >
                  <div>
                    {/* Thumbnail Banner */}
                    <div className="relative aspect-[16/10] overflow-hidden bg-[#F4F1EA]">
                      <img
                        src={thumbnail}
                        alt={courseTitle}
                        className="w-full h-full object-cover group-hover:scale-102 transition-transform duration-300"
                        onError={(e) => {
                          (e.target as HTMLImageElement).src = FALLBACK_THUMBNAIL;
                        }}
                      />
                      <div className="absolute top-3 left-3 px-2 py-0.5 rounded text-[11px] font-semibold bg-white/95 text-[#1F2421] border border-[#E5E2D9]">
                        {courseCategory}
                      </div>
                      <div
                        className={`absolute top-3 right-3 px-2 py-0.5 rounded text-[11px] font-semibold border flex items-center gap-1 ${
                          item.is_completed
                            ? 'bg-[#F4F1EA] text-[#1B3B2B] border-[#E5E2D9]'
                            : 'bg-white/95 text-[#535C56] border-[#E5E2D9]'
                        }`}
                      >
                        <CheckCircle2 className="w-3.5 h-3.5 text-[#1B3B2B]" />
                        {item.is_completed ? 'Completed' : 'In Progress'}
                      </div>
                    </div>

                    {/* Course Information */}
                    <div className="p-5 space-y-4">
                      <div>
                        <div className="flex items-center gap-2 text-xs text-[#535C56] mb-2 font-medium">
                          <span className="flex items-center gap-1">
                            <BarChart2 className="w-3.5 h-3.5 text-[#7A857E]" />
                            {courseLevel}
                          </span>
                          <span>•</span>
                          <span className="flex items-center gap-1">
                            <Clock className="w-3.5 h-3.5 text-[#7A857E]" />
                            {item.lessons_count} {item.lessons_count === 1 ? 'Lesson' : 'Lessons'}
                          </span>
                        </div>
                        <h3 className="font-editorial text-lg text-[#1F2421] group-hover:text-[#1B3B2B] transition-colors line-clamp-2">
                          {courseTitle}
                        </h3>
                      </div>

                      {/* Progress Bar */}
                      <div className="space-y-1.5">
                        <div className="flex items-center justify-between text-xs font-medium">
                          <span className="text-[#535C56]">Course Progress</span>
                          <span
                            className={
                              item.is_completed
                                ? 'text-[#1B3B2B] font-bold'
                                : 'text-[#1B3B2B] font-semibold'
                            }
                          >
                            {progress}%
                          </span>
                        </div>
                        <div className="w-full h-1.5 bg-[#EAE6DD] rounded-full overflow-hidden">
                          <div
                            className="h-full rounded-full transition-all duration-300 bg-[#1B3B2B]"
                            style={{ width: `${Math.min(100, Math.max(0, progress))}%` }}
                          />
                        </div>
                      </div>

                      {/* Instructor Info */}
                      <div className="flex items-center gap-2 pt-2 border-t border-[#E5E2D9]">
                        <img
                          src={instructorAvatar}
                          alt={instructorName}
                          className="w-5 h-5 rounded-full object-cover border border-[#E5E2D9]"
                          onError={(e) => {
                            (e.target as HTMLImageElement).src = FALLBACK_AVATAR;
                          }}
                        />
                        <span className="text-xs text-[#535C56] truncate">{instructorName}</span>
                      </div>
                    </div>
                  </div>

                  {/* Actions Bar */}
                  <div className="p-5 pt-0 space-y-3">
                    <div className="text-[11px] text-[#7A857E] flex items-center justify-between border-t border-[#E5E2D9] pt-3">
                      <span>Status</span>
                      <span>
                        {item.is_completed && item.completed_at
                          ? `Finished ${new Date(item.completed_at).toLocaleDateString(undefined, {
                              year: 'numeric',
                              month: 'short',
                              day: 'numeric',
                            })}`
                          : `Enrolled ${enrolledDate}`}
                      </span>
                    </div>

                    {course?.id ? (
                      <div className="flex flex-col gap-2">
                        {item.is_completed && (
                          <button
                            onClick={() => setSelectedCertificateCourse(item)}
                            className="btn-secondary w-full text-xs py-2 flex items-center justify-center gap-1.5"
                          >
                            <Award className="w-4 h-4 text-[#1B3B2B]" />
                            <span>View Certificate</span>
                          </button>
                        )}
                        <Link
                          to={`/courses/${course.id}`}
                          className={`w-full py-2 rounded-md text-xs font-semibold transition-colors flex items-center justify-center gap-1.5 ${
                            item.is_completed ? 'btn-secondary text-xs' : 'btn-forest text-xs'
                          }`}
                        >
                          <span>
                            {item.is_completed
                              ? 'Review Lessons'
                              : progress > 0
                              ? 'Continue Learning'
                              : 'Start Learning'}
                          </span>
                          <ArrowRight className="w-3.5 h-3.5" />
                        </Link>
                      </div>
                    ) : (
                      <button
                        disabled
                        className="w-full py-2 rounded-md bg-[#F4F1EA] text-[#7A857E] text-xs font-semibold cursor-not-allowed border border-[#E5E2D9]"
                      >
                        Course Unavailable
                      </button>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* Available Assessments & Assignments Section */}
      {!loading && enrollments.length > 0 && (
        <div className="space-y-6">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-[#E5E2D9] pb-3">
            <div className="flex items-center gap-2">
              <CheckSquare className="w-5 h-5 text-[#1B3B2B]" />
              <h2 className="font-editorial text-xl sm:text-2xl text-[#1F2421]">
                Coursework Assessments ({dashboardQuizzes.length + dashboardAssignments.length})
              </h2>
            </div>

            <div className="flex items-center gap-2">
              <button
                onClick={() => setAssessmentTab('quizzes')}
                className={`px-3 py-1.5 rounded-md text-xs font-semibold transition-all flex items-center gap-1.5 cursor-pointer ${
                  assessmentTab === 'quizzes'
                    ? 'bg-[#1B3B2B] text-white shadow-2xs'
                    : 'bg-[#F4F1EA] text-[#535C56] hover:bg-[#EAE6DD] border border-[#E5E2D9]'
                }`}
              >
                <HelpCircle className="w-3.5 h-3.5" />
                <span>Quizzes ({dashboardQuizzes.length})</span>
              </button>
              <button
                onClick={() => setAssessmentTab('assignments')}
                className={`px-3 py-1.5 rounded-md text-xs font-semibold transition-all flex items-center gap-1.5 cursor-pointer ${
                  assessmentTab === 'assignments'
                    ? 'bg-[#1B3B2B] text-white shadow-2xs'
                    : 'bg-[#F4F1EA] text-[#535C56] hover:bg-[#EAE6DD] border border-[#E5E2D9]'
                }`}
              >
                <FileText className="w-3.5 h-3.5" />
                <span>Assignments ({dashboardAssignments.length})</span>
              </button>
            </div>
          </div>

          {loadingAssessments && (
            <div className="academic-card p-10 text-center space-y-2">
              <Loader2 className="w-5 h-5 text-[#1B3B2B] animate-spin mx-auto" />
              <p className="text-xs text-[#535C56]">Loading coursework assessments...</p>
            </div>
          )}

          {/* Quizzes Tab */}
          {!loadingAssessments && assessmentTab === 'quizzes' && (
            dashboardQuizzes.length === 0 ? (
              <div className="academic-card p-8 text-center space-y-2">
                <HelpCircle className="w-8 h-8 text-[#7A857E] mx-auto" />
                <h3 className="font-editorial text-base text-[#1F2421]">No Quizzes Available</h3>
                <p className="text-xs text-[#535C56]">Your enrolled courses do not have active quizzes yet.</p>
              </div>
            ) : (
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {dashboardQuizzes.map((quiz) => {
                  const latestAttempt = quiz.latest_attempt;
                  const hasAttempted = !!latestAttempt;
                  const passed = hasAttempted && latestAttempt.percentage >= (quiz.passing_score || 0);
                  const score = latestAttempt ? Math.round(latestAttempt.percentage) : null;

                  return (
                    <div
                      key={quiz.id}
                      className="academic-card p-5 flex flex-col justify-between hover:border-[#1B3B2B]/40 transition-colors space-y-4"
                    >
                      <div className="space-y-2">
                        <div className="flex items-center justify-between gap-2">
                          <span className="px-2 py-0.5 rounded text-[10px] font-semibold bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9]">
                            {quiz.courseTitle}
                          </span>
                          {hasAttempted ? (
                            <span
                              className={`px-2 py-0.5 rounded text-[10px] font-semibold flex items-center gap-1 border ${
                                passed
                                  ? 'bg-[#EAEFE9] text-[#1B3B2B] border-[#C8D6CA]'
                                  : 'bg-[#FDF1EE] text-[#9E3D2B] border-[#F5C2BA]'
                              }`}
                            >
                              {passed ? <CheckCircle2 className="w-3 h-3" /> : <AlertCircle className="w-3 h-3" />}
                              <span>{passed ? `Passed (${score}%)` : `Score: ${score}%`}</span>
                            </span>
                          ) : (
                            <span className="px-2 py-0.5 rounded text-[10px] font-semibold bg-white text-[#535C56] border border-[#E5E2D9]">
                              Not Attempted
                            </span>
                          )}
                        </div>

                        <h3 className="font-editorial text-base text-[#1F2421] font-semibold">
                          {quiz.title}
                        </h3>
                        {quiz.description && (
                          <p className="text-xs text-[#535C56] line-clamp-2">
                            {quiz.description}
                          </p>
                        )}

                        <div className="flex items-center gap-4 text-[11px] text-[#7A857E] pt-1">
                          <span className="flex items-center gap-1">
                            <Clock className="w-3.5 h-3.5" />
                            {quiz.time_limit_minutes} Mins
                          </span>
                          <span>•</span>
                          <span>Passing: {quiz.passing_score}%</span>
                        </div>
                      </div>

                      <div className="pt-2 border-t border-[#E5E2D9] flex items-center justify-between">
                        <span className="text-[11px] text-[#7A857E]">
                          {hasAttempted && latestAttempt
                            ? `Attempted on ${new Date(latestAttempt.submitted_at).toLocaleDateString()}`
                            : 'Available Now'}
                        </span>
                        <Link
                          to={`/courses/${quiz.course_id}?tab=quizzes`}
                          className="btn-secondary text-xs py-1.5 px-3 flex items-center gap-1.5"
                        >
                          <span>{hasAttempted ? 'Review Quiz' : 'Take Quiz'}</span>
                          <ArrowRight className="w-3.5 h-3.5" />
                        </Link>
                      </div>
                    </div>
                  );
                })}
              </div>
            )
          )}

          {/* Assignments Tab */}
          {!loadingAssessments && assessmentTab === 'assignments' && (
            dashboardAssignments.length === 0 ? (
              <div className="academic-card p-8 text-center space-y-2">
                <FileText className="w-8 h-8 text-[#7A857E] mx-auto" />
                <h3 className="font-editorial text-base text-[#1F2421]">No Assignments Available</h3>
                <p className="text-xs text-[#535C56]">Your enrolled courses do not have active assignments yet.</p>
              </div>
            ) : (
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {dashboardAssignments.map((assignment) => {
                  const submission = assignment.submission;
                  const hasSubmitted = !!submission;
                  const isGraded = submission ? (submission.status === 'graded' || (submission.marks_obtained !== undefined && submission.marks_obtained !== null)) : false;
                  const dueDate = assignment.due_date ? new Date(assignment.due_date) : null;
                  const isPastDue = dueDate ? dueDate.getTime() < Date.now() : false;

                  return (
                    <div
                      key={assignment.id}
                      className="academic-card p-5 flex flex-col justify-between hover:border-[#1B3B2B]/40 transition-colors space-y-4"
                    >
                      <div className="space-y-2">
                        <div className="flex items-center justify-between gap-2">
                          <span className="px-2 py-0.5 rounded text-[10px] font-semibold bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9]">
                            {assignment.courseTitle}
                          </span>
                          {hasSubmitted && submission ? (
                            <span
                              className={`px-2 py-0.5 rounded text-[10px] font-semibold flex items-center gap-1 border ${
                                isGraded
                                  ? 'bg-[#EAEFE9] text-[#1B3B2B] border-[#C8D6CA]'
                                  : 'bg-[#F4F1EA] text-[#1B3B2B] border-[#E5E2D9]'
                              }`}
                            >
                              <CheckCircle2 className="w-3 h-3" />
                              <span>{isGraded ? `Graded: ${submission.marks_obtained ?? 0}/${assignment.max_marks}` : 'Submitted'}</span>
                            </span>
                          ) : (
                            <span
                              className={`px-2 py-0.5 rounded text-[10px] font-semibold border ${
                                isPastDue
                                  ? 'bg-[#FDF1EE] text-[#9E3D2B] border-[#F5C2BA]'
                                  : 'bg-white text-[#535C56] border-[#E5E2D9]'
                              }`}
                            >
                              {isPastDue ? 'Past Due' : 'Pending Submission'}
                            </span>
                          )}
                        </div>

                        <h3 className="font-editorial text-base text-[#1F2421] font-semibold">
                          {assignment.title}
                        </h3>
                        {assignment.description && (
                          <p className="text-xs text-[#535C56] line-clamp-2">
                            {assignment.description}
                          </p>
                        )}

                        <div className="flex items-center gap-4 text-[11px] text-[#7A857E] pt-1">
                          <span className="flex items-center gap-1">
                            <Calendar className="w-3.5 h-3.5" />
                            {dueDate ? `Due ${dueDate.toLocaleDateString()}` : 'Self-paced'}
                          </span>
                          <span>•</span>
                          <span>Max Marks: {assignment.max_marks}</span>
                        </div>
                      </div>

                      <div className="pt-2 border-t border-[#E5E2D9] flex items-center justify-between">
                        <span className="text-[11px] text-[#7A857E]">
                          {hasSubmitted && submission
                            ? `Submitted ${new Date(submission.submitted_at).toLocaleDateString()}`
                            : isPastDue
                            ? 'Submission window closed'
                            : 'Open for submissions'}
                        </span>
                        <Link
                          to={`/courses/${assignment.course_id}?tab=assignments`}
                          className="btn-secondary text-xs py-1.5 px-3 flex items-center gap-1.5"
                        >
                          <span>{hasSubmitted ? 'View Submission' : 'Submit Assignment'}</span>
                          <ArrowRight className="w-3.5 h-3.5" />
                        </Link>
                      </div>
                    </div>
                  );
                })}
              </div>
            )
          )}
        </div>
      )}

      {/* Recommendations */}
      <RecommendedCoursesSection
        enrolledCourseIds={enrollments.map((e) => e.course_id)}
        completedCourseIds={enrollments.filter((e) => e.is_completed).map((e) => e.course_id)}
        studentId={userId}
      />

      {/* Verified Certificate Modal */}
      {selectedCertificateCourse && selectedCertificateCourse.course && (
        <CertificateModal
          course={{
            ...selectedCertificateCourse.course,
            instructor: selectedCertificateCourse.instructor,
          }}
          enrollment={selectedCertificateCourse}
          studentName={user?.fullName || 'Student'}
          onClose={() => setSelectedCertificateCourse(null)}
        />
      )}
    </div>
  );
};
