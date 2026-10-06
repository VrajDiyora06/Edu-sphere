export type UserRole = 'guest' | 'student' | 'instructor' | 'admin' | 'system_admin';

export interface UserProfile {
  id: string;
  email: string;
  fullName: string;
  role: UserRole;
  avatarUrl?: string;
  bio?: string;
}

export interface Resource {
  id: string;
  title: string;
  fileUrl: string;
  fileType: string;
}

export interface Lesson {
  id: string;
  title: string;
  content?: string;
  videoUrl?: string;
  durationMinutes: number;
  isFreePreview: boolean;
  orderIndex: number;
  resources?: Resource[];
}

export interface QuizOption {
  id: string;
  optionText: string;
}

export interface QuizQuestion {
  id: string;
  questionText: string;
  explanation?: string;
  options: QuizOption[];
}

export interface Quiz {
  id: string;
  title: string;
  passingScore: number;
  questions: QuizQuestion[];
}

export interface CourseModule {
  id: string;
  title: string;
  description?: string;
  orderIndex: number;
  lessons: Lesson[];
  quiz?: Quiz;
}

export interface Course {
  id: string;
  title: string;
  slug: string;
  description: string;
  category: string;
  level: 'Beginner' | 'Intermediate' | 'Advanced';
  thumbnailUrl: string;
  instructorName: string;
  instructorTitle: string;
  instructorAvatar: string;
  isPublished: boolean;
  enrolledCount: number;
  rating: number;
  modulesCount: number;
  lessonsCount: number;
  totalDurationHours: number;
  modules: CourseModule[];
}

export interface Enrollment {
  id: string;
  studentId: string;
  courseId: string;
  enrolledAt: string;
  progressPercent: number;
  isCompleted: boolean;
}

// Database schema types matching PostgreSQL tables
export interface DbCourse {
  id: string;
  title: string;
  slug: string;
  description: string;
  category: string;
  level: 'Beginner' | 'Intermediate' | 'Advanced';
  thumbnail_url: string | null;
  instructor_id: string;
  is_published: boolean;
  created_at: string;
  updated_at: string;
}

export interface DbLesson {
  id: string;
  course_id: string;
  title: string;
  content: string | null;
  video_url: string | null;
  duration_minutes: number;
  is_free_preview: boolean;
  order_index: number;
  created_at: string;
}

export interface DbPublicProfile {
  id: string;
  full_name: string;
  avatar_url: string | null;
  role: string;
  bio: string | null;
  created_at: string;
}

export interface CourseWithDetails extends DbCourse {
  instructor?: DbPublicProfile | null;
  lessons?: DbLesson[];
}

export interface DbEnrollment {
  id: string;
  student_id: string;
  course_id: string;
  enrolled_at: string;
  progress_percent: number;
  is_completed: boolean;
  completed_at: string | null;
}

export interface EnrolledCourseItem extends DbEnrollment {
  course?: DbCourse | null;
  instructor?: DbPublicProfile | null;
  lessons_count?: number;
}

export interface DbProfile {
  id: string;
  email?: string;
  full_name: string;
  role: UserRole;
  avatar_url?: string | null;
  bio?: string | null;
  created_at: string;
  updated_at?: string;
}

export interface DbAnnouncement {
  id: string;
  title: string;
  content: string;
  priority: 'low' | 'normal' | 'high' | 'urgent';
  author_id: string;
  is_published: boolean;
  created_at: string;
  updated_at: string;
}

export interface SystemDiagnosticItem {
  metric_name: string;
  metric_value: string;
  status: 'OPTIMAL' | 'ACTIVE' | 'ENFORCED' | 'SECURE' | 'WARNING' | 'MISSING' | 'VULNERABLE' | string;
}

export interface InstructorEnrollmentItem extends DbEnrollment {
  student?: {
    full_name: string;
    avatar_url?: string | null;
    email?: string;
  } | null;
}

export interface DbAssignment {
  id: string;
  course_id: string;
  title: string;
  description: string;
  instructions_file_path?: string | null;
  instructions_file_name?: string | null;
  due_date: string;
  max_marks: number;
  allow_resubmission: boolean;
  is_published: boolean;
  created_at: string;
  updated_at: string;
}

export interface DbAssignmentSubmission {
  id: string;
  assignment_id: string;
  student_id: string;
  file_path: string;
  file_name: string;
  file_size_bytes: number;
  submitted_at: string;
  status: 'submitted' | 'graded' | 'resubmitted' | 'late';
  marks_obtained?: number | null;
  feedback?: string | null;
  graded_by?: string | null;
  graded_at?: string | null;
  created_at: string;
  updated_at: string;
  student?: {
    full_name: string;
    email?: string;
    avatar_url?: string | null;
  };
}

export interface AssignmentWithSubmission extends DbAssignment {
  submission?: DbAssignmentSubmission | null;
}

export interface DbQuiz {
  id: string;
  course_id: string;
  title: string;
  description?: string | null;
  time_limit_minutes: number;
  passing_score: number;
  is_published: boolean;
  created_at: string;
  updated_at: string;
}

export interface DbQuizQuestion {
  id: string;
  quiz_id: string;
  question_text: string;
  options: string[];
  correct_option_index: number;
  marks: number;
  explanation?: string | null;
  order_index: number;
  created_at: string;
}

export interface StudentQuizQuestion {
  id: string;
  quiz_id: string;
  question_text: string;
  options: string[];
  marks: number;
  order_index: number;
}

export interface QuizQuestionReview {
  question_id: string;
  question_text: string;
  options: string[];
  selected_option: number;
  correct_option: number;
  is_correct: boolean;
  marks_earned: number;
  max_marks: number;
  explanation: string;
}

export interface DbQuizAttempt {
  id: string;
  quiz_id: string;
  student_id: string;
  score: number;
  max_score: number;
  percentage: number;
  submitted_answers: Record<string, number>;
  detailed_results: QuizQuestionReview[];
  submitted_at: string;
  student?: {
    full_name: string;
    email?: string;
  };
}

export interface QuizWithStudentStatus extends DbQuiz {
  latest_attempt?: DbQuizAttempt | null;
  questions_count?: number;
}

// AI Doubt Assistance & Course Recommendations types
export interface DoubtRequest {
  lessonId: string;
  lessonTitle: string;
  lessonContent?: string | null;
  courseTitle: string;
  courseCategory: string;
  question: string;
  userRole?: string;
  isEnrolled?: boolean;
  isFreePreview?: boolean;
}

export interface DoubtResponse {
  success: boolean;
  answer?: string;
  source: 'ai_provider' | 'fallback';
  model?: string;
  isFallback: boolean;
  fallbackNotice?: string;
  error?: string;
}

export interface RecommendationRequest {
  studentId?: string;
  enrolledCourseIds?: string[];
  completedCourseIds?: string[];
  interests?: string[];
  allCourses: Array<{
    id: string;
    title: string;
    slug: string;
    description: string;
    category: string;
    level: string;
    thumbnail_url?: string | null;
  }>;
}

export interface RecommendedCourseItem {
  course: {
    id: string;
    title: string;
    slug: string;
    description: string;
    category: string;
    level: string;
    thumbnail_url?: string | null;
  };
  score: number;
  reason: string;
  isPersonalized: boolean;
}

export interface RecommendationResponse {
  success: boolean;
  recommendations: RecommendedCourseItem[];
  isPersonalized: boolean;
  strategy: 'history_based' | 'curated_starter';
  error?: string;
}


