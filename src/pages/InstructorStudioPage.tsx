import React, { useState, useEffect, useCallback } from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../context/useAuth';
import {
  getInstructorCourses,
  createCourse,
  updateCourse,
  deleteCourse,
  getLessonsForCourse,
  createLesson,
  updateLesson,
  deleteLesson,
  getCourseEnrollmentsForInstructor,
  type InstructorCourseSummary,
} from '../lib/instructor';
import {
  getCourseAssignments,
  createAssignment,
  updateAssignment,
  deleteAssignment,
  uploadInstructionFile,
  getInstructionDownloadUrl,
  getSubmissionDownloadUrl,
  getSubmissionsForAssignment,
  gradeSubmission,
  validateInstructionFile,
} from '../lib/assignments';
import {
  getCourseQuizzes,
  createQuiz,
  updateQuiz,
  deleteQuiz,
  getQuizWithQuestionsForInstructor,
  saveQuizQuestions,
  getQuizAttemptsForInstructor,
} from '../lib/quizzes';
import type {
  DbLesson,
  InstructorEnrollmentItem,
  DbAssignment,
  DbAssignmentSubmission,
  DbQuiz,
  DbQuizAttempt,
  QuizWithStudentStatus,
} from '../types';
import { MarkdownRenderer } from '../components/MarkdownRenderer';
import { CourseCoverUpload } from '../components/CourseCoverUpload';
import { LessonVideoUpload } from '../components/LessonVideoUpload';
import {
  uploadCourseCoverImage,
  uploadLessonVideo,
  deleteCourseCoverFromStorage,
  deleteLessonVideoFromStorage,
  getCourseCoverDisplayUrl,
  DEFAULT_COURSE_THUMBNAIL,
} from '../lib/media';
import {
  Sparkles,
  BookOpen,
  Plus,
  Users,
  Clock,
  Layers,
  CheckCircle2,
  AlertCircle,
  Eye,
  EyeOff,
  Trash2,
  Loader2,
  ChevronDown,
  ChevronUp,
  X,
  ShieldCheck,
  FileText,
  Download,
  Calendar,
  FileCheck,
  CheckSquare,
  Award,
  HelpCircle,
  Edit3,
  Save,
} from 'lucide-react';

const CATEGORIES = [
  'Computer Science',
  'Web Development',
  'Database Engineering',
  'Artificial Intelligence',
  'Software Architecture',
  'Cloud & DevOps',
];

export const InstructorStudioPage: React.FC = () => {
  const { user, role } = useAuth();
  const [courses, setCourses] = useState<InstructorCourseSummary[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [successMsg, setSuccessMsg] = useState<string | null>(null);

  // Modal / Expansion states
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [courseToDelete, setCourseToDelete] = useState<InstructorCourseSummary | null>(null);
  const [deletingCourse, setDeletingCourse] = useState(false);
  const [selectedCourseForLessons, setSelectedCourseForLessons] = useState<string | null>(null);
  const [lessonsMap, setLessonsMap] = useState<Record<string, DbLesson[]>>({});
  const [loadingLessons, setLoadingLessons] = useState<boolean>(false);

  const [selectedCourseForEnrollments, setSelectedCourseForEnrollments] = useState<string | null>(null);
  const [enrollmentsMap, setEnrollmentsMap] = useState<Record<string, InstructorEnrollmentItem[]>>({});
  const [loadingEnrollments, setLoadingEnrollments] = useState<boolean>(false);

  // Assignment states
  const [selectedCourseForAssignments, setSelectedCourseForAssignments] = useState<string | null>(null);
  const [assignmentsMap, setAssignmentsMap] = useState<Record<string, DbAssignment[]>>({});
  const [loadingAssignments, setLoadingAssignments] = useState<boolean>(false);
  const [showCreateAssignmentModal, setShowCreateAssignmentModal] = useState<boolean>(false);
  const [assignmentCourseId, setAssignmentCourseId] = useState<string | null>(null);

  // New Assignment form state
  const [assignmentTitle, setAssignmentTitle] = useState('');
  const [assignmentDesc, setAssignmentDesc] = useState('');
  const [assignmentDueDate, setAssignmentDueDate] = useState('');
  const [assignmentMaxMarks, setAssignmentMaxMarks] = useState<string>('100');
  const [assignmentAllowResubmission, setAssignmentAllowResubmission] = useState(true);
  const [assignmentIsPublished, setAssignmentIsPublished] = useState(true);
  const [instructionFile, setInstructionFile] = useState<File | null>(null);
  const [submittingAssignment, setSubmittingAssignment] = useState(false);

  // Submissions modal state
  const [selectedAssignmentForSubmissions, setSelectedAssignmentForSubmissions] = useState<DbAssignment | null>(null);
  const [submissionsList, setSubmissionsList] = useState<DbAssignmentSubmission[]>([]);
  const [loadingSubmissions, setLoadingSubmissions] = useState(false);
  const [gradingSubmissionId, setGradingSubmissionId] = useState<string | null>(null);
  const [gradeMarks, setGradeMarks] = useState<string>('0');
  const [gradeFeedback, setGradeFeedback] = useState<string>('');
  const [savingGrade, setSavingGrade] = useState(false);

  // Quiz states
  const [selectedCourseForQuizzes, setSelectedCourseForQuizzes] = useState<string | null>(null);
  const [quizzesMap, setQuizzesMap] = useState<Record<string, QuizWithStudentStatus[]>>({});
  const [loadingQuizzes, setLoadingQuizzes] = useState<boolean>(false);
  const [showCreateQuizModal, setShowCreateQuizModal] = useState<boolean>(false);
  const [quizCourseId, setQuizCourseId] = useState<string | null>(null);

  // New Quiz form state
  const [quizTitle, setQuizTitle] = useState('');
  const [quizDesc, setQuizDesc] = useState('');
  const [quizTimeLimit, setQuizTimeLimit] = useState<string>('0');
  const [quizPassingScore, setQuizPassingScore] = useState<string>('70');
  const [quizIsPublished, setQuizIsPublished] = useState(true);
  const [submittingQuiz, setSubmittingQuiz] = useState(false);

  // Questions Editor Modal state
  const [editingQuizForQuestions, setEditingQuizForQuestions] = useState<DbQuiz | null>(null);
  const [editingQuestions, setEditingQuestions] = useState<Array<{
    id?: string;
    question_text: string;
    options: string[];
    correct_option_index: number;
    marks: number | string;
    explanation?: string;
  }>>([]);
  const [loadingQuestions, setLoadingQuestions] = useState(false);
  const [savingQuestions, setSavingQuestions] = useState(false);

  // Quiz Attempts Modal state
  const [selectedQuizForAttempts, setSelectedQuizForAttempts] = useState<DbQuiz | null>(null);
  const [quizAttemptsList, setQuizAttemptsList] = useState<DbQuizAttempt[]>([]);
  const [loadingQuizAttempts, setLoadingQuizAttempts] = useState(false);

  // New Course Form state
  const [newTitle, setNewTitle] = useState('');
  const [newSlug, setNewSlug] = useState('');
  const [newCategory, setNewCategory] = useState(CATEGORIES[0]);
  const [newLevel, setNewLevel] = useState<'Beginner' | 'Intermediate' | 'Advanced'>('Beginner');
  const [newDescription, setNewDescription] = useState('');
  const [newThumbnail, setNewThumbnail] = useState(DEFAULT_COURSE_THUMBNAIL);
  const [newCoverFile, setNewCoverFile] = useState<File | null>(null);
  const [newCoverIsExternal, setNewCoverIsExternal] = useState(false);
  const [newCoverUploadError, setNewCoverUploadError] = useState<string | null>(null);
  const [newIsPublished, setNewIsPublished] = useState(true);
  const [submittingCourse, setSubmittingCourse] = useState(false);

  // Edit Course Form state
  const [editingCourse, setEditingCourse] = useState<InstructorCourseSummary | null>(null);
  const [editTitle, setEditTitle] = useState('');
  const [editSlug, setEditSlug] = useState('');
  const [editCategory, setEditCategory] = useState(CATEGORIES[0]);
  const [editLevel, setEditLevel] = useState<'Beginner' | 'Intermediate' | 'Advanced'>('Beginner');
  const [editDescription, setEditDescription] = useState('');
  const [editThumbnail, setEditThumbnail] = useState('');
  const [editCoverFile, setEditCoverFile] = useState<File | null>(null);
  const [editCoverIsExternal, setEditCoverIsExternal] = useState(false);
  const [editCoverUploadError, setEditCoverUploadError] = useState<string | null>(null);
  const [editIsPublished, setEditIsPublished] = useState(true);
  const [submittingEditCourse, setSubmittingEditCourse] = useState(false);

  // New Lesson Form state
  const [lessonTitle, setLessonTitle] = useState('');
  const [lessonDuration, setLessonDuration] = useState<string>('15');
  const [lessonIsPreview, setLessonIsPreview] = useState(false);
  const [lessonContent, setLessonContent] = useState('');
  const [lessonVideoMode, setLessonVideoMode] = useState<'upload' | 'url'>('upload');
  const [lessonVideoFile, setLessonVideoFile] = useState<File | null>(null);
  const [lessonVideoUrl, setLessonVideoUrl] = useState('');
  const [lessonVideoUploadError, setLessonVideoUploadError] = useState<string | null>(null);
  const [submittingLesson, setSubmittingLesson] = useState(false);

  // Edit Lesson Form state
  const [editingLesson, setEditingLesson] = useState<DbLesson | null>(null);
  const [editingLessonCourseId, setEditingLessonCourseId] = useState<string | null>(null);
  const [editLessonTitle, setEditLessonTitle] = useState('');
  const [editLessonDuration, setEditLessonDuration] = useState<string>('15');
  const [editLessonContent, setEditLessonContent] = useState('');
  const [editLessonIsPreview, setEditLessonIsPreview] = useState(false);
  const [editLessonVideoMode, setEditLessonVideoMode] = useState<'upload' | 'url'>('upload');
  const [editLessonVideoFile, setEditLessonVideoFile] = useState<File | null>(null);
  const [editLessonVideoUrl, setEditLessonVideoUrl] = useState('');
  const [editLessonUploadError, setEditLessonUploadError] = useState<string | null>(null);
  const [submittingEditLesson, setSubmittingEditLesson] = useState(false);

  const userId = user?.id;
  const isAdminOrSysAdmin = role === 'admin' || role === 'system_admin';

  const fetchCourses = useCallback(async () => {
    if (!userId) return;
    setLoading(true);
    setError(null);

    const { data, error: err } = await getInstructorCourses(userId, isAdminOrSysAdmin);
    if (err) {
      setError(err.message || 'Failed to fetch instructor courses.');
      setCourses([]);
    } else {
      setCourses(data || []);
    }
    setLoading(false);
  }, [userId, isAdminOrSysAdmin]);

  useEffect(() => {
    if (!userId) return;
    let ignore = false;

    getInstructorCourses(userId, isAdminOrSysAdmin).then(({ data, error: err }) => {
      if (ignore) return;
      if (err) {
        setError(err.message || 'Failed to fetch instructor courses.');
        setCourses([]);
      } else {
        setCourses(data || []);
      }
      setLoading(false);
    });

    return () => {
      ignore = true;
    };
  }, [userId, isAdminOrSysAdmin]);

  // Handle title change and auto slug
  const handleTitleChange = (val: string) => {
    setNewTitle(val);
    const slugified = val
      .toLowerCase()
      .trim()
      .replace(/[^a-z0-9\s-]/g, '')
      .replace(/\s+/g, '-');
    setNewSlug(slugified);
  };

  // Toggle course publish status
  const handleTogglePublish = async (courseId: string, currentStatus: boolean) => {
    const { error: updateErr } = await updateCourse(courseId, { is_published: !currentStatus });
    if (updateErr) {
      setError(`Failed to update publication: ${updateErr.message}`);
    } else {
      setCourses((prev) =>
        prev.map((c) => (c.id === courseId ? { ...c, is_published: !currentStatus } : c))
      );
      setSuccessMsg(`Course ${!currentStatus ? 'published to catalog' : 'moved to draft mode'}.`);
      setTimeout(() => setSuccessMsg(null), 4000);
    }
  };

  // Create course submit
  const handleCreateCourseSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!userId) return;
    setSubmittingCourse(true);
    setError(null);
    setNewCoverUploadError(null);

    let finalThumbnailUrl = newThumbnail.trim() || DEFAULT_COURSE_THUMBNAIL;
    let uploadedCoverPath: string | null = null;

    if (newCoverFile) {
      const uploadRes = await uploadCourseCoverImage(newCoverFile, undefined, userId);
      if (uploadRes.error) {
        setNewCoverUploadError(uploadRes.error.message);
        setSubmittingCourse(false);
        return;
      }
      uploadedCoverPath = uploadRes.path;
      finalThumbnailUrl = uploadRes.publicUrl || uploadRes.path || DEFAULT_COURSE_THUMBNAIL;
    }

    const { data, error: createErr } = await createCourse({
      title: newTitle.trim(),
      slug: newSlug.trim() || `course-${Date.now()}`,
      description: newDescription.trim(),
      category: newCategory,
      level: newLevel,
      thumbnail_url: finalThumbnailUrl,
      instructor_id: userId,
      is_published: newIsPublished,
    });

    if (createErr) {
      if (uploadedCoverPath) {
        await deleteCourseCoverFromStorage(uploadedCoverPath);
      }
      setError(`Course creation failed: ${createErr.message}`);
      setSubmittingCourse(false);
      return;
    }

    setSubmittingCourse(false);
    if (data) {
      setShowCreateModal(false);
      setNewTitle('');
      setNewSlug('');
      setNewDescription('');
      setNewThumbnail(DEFAULT_COURSE_THUMBNAIL);
      setNewCoverFile(null);
      setNewCoverIsExternal(false);
      setNewCoverUploadError(null);
      setSuccessMsg(`Course "${data.title}" successfully created.`);
      setTimeout(() => setSuccessMsg(null), 4000);
      fetchCourses();
    }
  };

  // Open Edit Course
  const handleOpenEditCourse = (course: InstructorCourseSummary) => {
    setEditingCourse(course);
    setEditTitle(course.title);
    setEditSlug(course.slug);
    setEditCategory(course.category);
    setEditLevel(course.level as 'Beginner' | 'Intermediate' | 'Advanced');
    setEditDescription(course.description);
    setEditThumbnail(course.thumbnail_url || '');
    setEditCoverFile(null);
    setEditCoverIsExternal(false);
    setEditCoverUploadError(null);
    setEditIsPublished(course.is_published);
  };

  // Edit course submit
  const handleEditCourseSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingCourse) return;
    setSubmittingEditCourse(true);
    setError(null);
    setEditCoverUploadError(null);

    let finalThumbnailUrl = editThumbnail.trim();
    let uploadedCoverPath: string | null = null;

    if (editCoverFile) {
      const uploadRes = await uploadCourseCoverImage(editCoverFile, editingCourse.id, userId);
      if (uploadRes.error) {
        setEditCoverUploadError(uploadRes.error.message);
        setSubmittingEditCourse(false);
        return;
      }
      uploadedCoverPath = uploadRes.path;
      finalThumbnailUrl = uploadRes.publicUrl || uploadRes.path || '';
    }

    const { data, error: updateErr } = await updateCourse(editingCourse.id, {
      title: editTitle.trim(),
      slug: editSlug.trim(),
      description: editDescription.trim(),
      category: editCategory,
      level: editLevel,
      thumbnail_url: finalThumbnailUrl || DEFAULT_COURSE_THUMBNAIL,
      is_published: editIsPublished,
    });

    if (updateErr) {
      if (uploadedCoverPath) {
        await deleteCourseCoverFromStorage(uploadedCoverPath);
      }
      setError(`Course update failed: ${updateErr.message}`);
      setSubmittingEditCourse(false);
      return;
    }

    if (uploadedCoverPath && editingCourse.thumbnail_url && editingCourse.thumbnail_url !== finalThumbnailUrl) {
      await deleteCourseCoverFromStorage(editingCourse.thumbnail_url);
    }

    setSubmittingEditCourse(false);
    setEditingCourse(null);
    setSuccessMsg(`Course "${data?.title || editTitle}" updated.`);
    setTimeout(() => setSuccessMsg(null), 4000);
    fetchCourses();
  };

  // Delete course submit
  const handleConfirmDeleteCourse = async () => {
    if (!courseToDelete) return;
    setDeletingCourse(true);
    setError(null);

    const { success, error: delErr } = await deleteCourse(courseToDelete.id);
    setDeletingCourse(false);

    if (!success) {
      setError(delErr?.message || 'Failed to delete course.');
    } else {
      const deletedTitle = courseToDelete.title;
      setCourses((prev) => prev.filter((c) => c.id !== courseToDelete.id));
      setCourseToDelete(null);
      setSuccessMsg(`Course "${deletedTitle}" and all related materials were permanently deleted.`);
      setTimeout(() => setSuccessMsg(null), 4000);
      fetchCourses();
    }
  };

  // Expand and load lessons
  const handleToggleLessons = async (courseId: string) => {
    if (selectedCourseForLessons === courseId) {
      setSelectedCourseForLessons(null);
      return;
    }

    setSelectedCourseForLessons(courseId);
    if (!lessonsMap[courseId]) {
      setLoadingLessons(true);
      const { data } = await getLessonsForCourse(courseId);
      if (data) {
        setLessonsMap((prev) => ({ ...prev, [courseId]: data }));
      }
      setLoadingLessons(false);
    }
  };

  // Add lesson submit
  const handleAddLessonSubmit = async (courseId: string, e: React.FormEvent) => {
    e.preventDefault();
    if (!lessonTitle.trim()) return;

    const parsedDuration = Number(lessonDuration);
    if (!lessonDuration.trim() || isNaN(parsedDuration) || parsedDuration <= 0) {
      setError('Lesson duration must be a valid positive number (minimum 1 minute).');
      return;
    }

    setSubmittingLesson(true);
    setLessonVideoUploadError(null);

    let finalVideoUrl = '';
    let uploadedVideoPath: string | null = null;

    if (lessonVideoMode === 'upload' && lessonVideoFile) {
      const uploadRes = await uploadLessonVideo(lessonVideoFile, courseId);
      if (uploadRes.error) {
        setLessonVideoUploadError(uploadRes.error.message);
        setSubmittingLesson(false);
        return;
      }
      uploadedVideoPath = uploadRes.path;
      finalVideoUrl = uploadRes.path || '';
    } else if (lessonVideoMode === 'url') {
      finalVideoUrl = lessonVideoUrl.trim();
    }

    const currentLessons = lessonsMap[courseId] || [];
    const nextOrder = currentLessons.length + 1;

    const { data, error: lessonErr } = await createLesson({
      course_id: courseId,
      title: lessonTitle.trim(),
      duration_minutes: Math.round(parsedDuration),
      is_free_preview: lessonIsPreview,
      content: lessonContent,
      video_url: finalVideoUrl,
      order_index: nextOrder,
    });

    if (lessonErr) {
      if (uploadedVideoPath) {
        await deleteLessonVideoFromStorage(uploadedVideoPath);
      }
      setError(`Failed to create lesson: ${lessonErr.message}`);
      setSubmittingLesson(false);
      return;
    }

    setSubmittingLesson(false);
    if (data) {
      setLessonsMap((prev) => ({
        ...prev,
        [courseId]: [...(prev[courseId] || []), data],
      }));
      setLessonTitle('');
      setLessonDuration('15');
      setLessonContent('');
      setLessonVideoUrl('');
      setLessonVideoFile(null);
      setLessonVideoMode('upload');
      setLessonVideoUploadError(null);
      setLessonIsPreview(false);
      setCourses((prev) =>
        prev.map((c) => (c.id === courseId ? { ...c, lessonsCount: c.lessonsCount + 1 } : c))
      );
      setSuccessMsg('Lesson added to curriculum.');
      setTimeout(() => setSuccessMsg(null), 3000);
    }
  };

  // Open Edit Lesson
  const handleOpenEditLesson = (courseId: string, lesson: DbLesson) => {
    setEditingLesson(lesson);
    setEditingLessonCourseId(courseId);
    setEditLessonTitle(lesson.title);
    setEditLessonDuration(String(lesson.duration_minutes || 15));
    setEditLessonContent(lesson.content || '');
    setEditLessonIsPreview(lesson.is_free_preview || false);
    setEditLessonVideoUrl(lesson.video_url || '');
    setEditLessonVideoFile(null);
    setEditLessonUploadError(null);
    const isExtUrl = !!lesson.video_url?.startsWith('http') && !lesson.video_url?.includes('/storage/v1/object/');
    setEditLessonVideoMode(isExtUrl ? 'url' : 'upload');
  };

  // Edit lesson submit
  const handleEditLessonSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingLesson || !editingLessonCourseId) return;

    const parsedDuration = Number(editLessonDuration);
    if (!editLessonDuration.trim() || isNaN(parsedDuration) || parsedDuration <= 0) {
      setError('Lesson duration must be a valid positive number.');
      return;
    }

    setSubmittingEditLesson(true);
    setEditLessonUploadError(null);

    let finalVideoUrl = editLessonVideoUrl.trim();
    let uploadedVideoPath: string | null = null;

    if (editLessonVideoMode === 'upload' && editLessonVideoFile) {
      const uploadRes = await uploadLessonVideo(editLessonVideoFile, editingLessonCourseId, editingLesson.id);
      if (uploadRes.error) {
        setEditLessonUploadError(uploadRes.error.message);
        setSubmittingEditLesson(false);
        return;
      }
      uploadedVideoPath = uploadRes.path;
      finalVideoUrl = uploadRes.path || '';
    } else if (editLessonVideoMode === 'upload' && !editLessonVideoFile) {
      finalVideoUrl = editLessonVideoUrl;
    }

    const { data, error: updateErr } = await updateLesson(editingLesson.id, {
      title: editLessonTitle.trim(),
      duration_minutes: Math.round(parsedDuration),
      content: editLessonContent,
      is_free_preview: editLessonIsPreview,
      video_url: finalVideoUrl,
    });

    if (updateErr) {
      if (uploadedVideoPath) {
        await deleteLessonVideoFromStorage(uploadedVideoPath);
      }
      setError(`Failed to update lesson: ${updateErr.message}`);
      setSubmittingEditLesson(false);
      return;
    }

    if (uploadedVideoPath && editingLesson.video_url && editingLesson.video_url !== finalVideoUrl) {
      await deleteLessonVideoFromStorage(editingLesson.video_url);
    }

    setSubmittingEditLesson(false);
    if (data) {
      setLessonsMap((prev) => ({
        ...prev,
        [editingLessonCourseId]: (prev[editingLessonCourseId] || []).map((l) =>
          l.id === editingLesson.id ? { ...l, ...data } : l
        ),
      }));
      setEditingLesson(null);
      setEditingLessonCourseId(null);
      setSuccessMsg('Lesson updated.');
      setTimeout(() => setSuccessMsg(null), 3000);
    }
  };

  // Delete lesson
  const handleDeleteLesson = async (courseId: string, lessonId: string) => {
    const { success, error: delErr } = await deleteLesson(lessonId);
    if (!success) {
      setError(delErr?.message || 'Failed to delete lesson.');
    } else {
      setLessonsMap((prev) => ({
        ...prev,
        [courseId]: (prev[courseId] || []).filter((l) => l.id !== lessonId),
      }));
      setCourses((prev) =>
        prev.map((c) => (c.id === courseId ? { ...c, lessonsCount: Math.max(0, c.lessonsCount - 1) } : c))
      );
      setSuccessMsg('Lesson removed.');
      setTimeout(() => setSuccessMsg(null), 3000);
    }
  };

  // Expand and load enrollments
  const handleToggleEnrollments = async (courseId: string) => {
    if (selectedCourseForEnrollments === courseId) {
      setSelectedCourseForEnrollments(null);
      return;
    }

    setSelectedCourseForEnrollments(courseId);
    if (!enrollmentsMap[courseId]) {
      setLoadingEnrollments(true);
      const { data } = await getCourseEnrollmentsForInstructor(courseId);
      if (data) {
        setEnrollmentsMap((prev) => ({ ...prev, [courseId]: data }));
      }
      setLoadingEnrollments(false);
    }
  };

  // Expand and load assignments
  const handleToggleAssignments = async (courseId: string) => {
    if (selectedCourseForAssignments === courseId) {
      setSelectedCourseForAssignments(null);
      return;
    }

    setSelectedCourseForAssignments(courseId);
    if (!assignmentsMap[courseId]) {
      setLoadingAssignments(true);
      const { data, error: aErr } = await getCourseAssignments(courseId, undefined, true);
      if (aErr) {
        setError(`Failed to load assignments: ${aErr.message}`);
      } else {
        setAssignmentsMap((prev) => ({ ...prev, [courseId]: data }));
      }
      setLoadingAssignments(false);
    }
  };

  // Open create assignment modal
  const handleOpenCreateAssignment = (courseId: string) => {
    setAssignmentCourseId(courseId);
    setAssignmentTitle('');
    setAssignmentDesc('');
    const nextWeek = new Date();
    nextWeek.setDate(nextWeek.getDate() + 7);
    setAssignmentDueDate(nextWeek.toISOString().slice(0, 16));
    setAssignmentMaxMarks('100');
    setAssignmentAllowResubmission(true);
    setAssignmentIsPublished(true);
    setInstructionFile(null);
    setShowCreateAssignmentModal(true);
  };

  // Handle create assignment submit
  const handleCreateAssignmentSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!assignmentCourseId || !assignmentTitle.trim() || !assignmentDueDate) return;

    const parsedMaxMarks = Number(assignmentMaxMarks);
    if (!assignmentMaxMarks.trim() || isNaN(parsedMaxMarks) || parsedMaxMarks <= 0 || parsedMaxMarks > 1000) {
      setError('Maximum marks must be a valid number between 1 and 1000.');
      return;
    }

    setSubmittingAssignment(true);
    setError(null);

    let instructionPath: string | null = null;
    let instructionName: string | null = null;

    if (instructionFile) {
      const uploadRes = await uploadInstructionFile(instructionFile, assignmentCourseId);
      if (uploadRes.error) {
        setError(`Instruction file upload failed: ${uploadRes.error.message}`);
        setSubmittingAssignment(false);
        return;
      }
      instructionPath = uploadRes.path;
      instructionName = instructionFile.name;
    }

    const { data, error: createErr } = await createAssignment({
      course_id: assignmentCourseId,
      title: assignmentTitle.trim(),
      description: assignmentDesc.trim(),
      instructions_file_path: instructionPath,
      instructions_file_name: instructionName,
      due_date: new Date(assignmentDueDate).toISOString(),
      max_marks: parsedMaxMarks,
      allow_resubmission: assignmentAllowResubmission,
      is_published: assignmentIsPublished,
    });

    setSubmittingAssignment(false);

    if (createErr) {
      setError(`Failed to create assignment: ${createErr.message}`);
    } else if (data) {
      setAssignmentsMap((prev) => ({
        ...prev,
        [assignmentCourseId]: [...(prev[assignmentCourseId] || []), data],
      }));
      setShowCreateAssignmentModal(false);
      setSuccessMsg('Assignment created successfully.');
      setTimeout(() => setSuccessMsg(null), 3000);
    }
  };

  // Toggle publish assignment
  const handleTogglePublishAssignment = async (courseId: string, assignmentId: string, currentStatus: boolean) => {
    const { error: updErr } = await updateAssignment(assignmentId, { is_published: !currentStatus });
    if (updErr) {
      setError(`Failed to update assignment status: ${updErr.message}`);
    } else {
      setAssignmentsMap((prev) => ({
        ...prev,
        [courseId]: (prev[courseId] || []).map((a) => (a.id === assignmentId ? { ...a, is_published: !currentStatus } : a)),
      }));
      setSuccessMsg(`Assignment ${!currentStatus ? 'published' : 'moved to draft'}.`);
      setTimeout(() => setSuccessMsg(null), 3000);
    }
  };

  // Delete assignment
  const handleDeleteAssignment = async (courseId: string, assignmentId: string) => {
    if (!confirm('Are you sure you want to delete this assignment and all associated submissions?')) return;
    const { success, error: delErr } = await deleteAssignment(assignmentId);
    if (!success) {
      setError(delErr?.message || 'Failed to delete assignment.');
    } else {
      setAssignmentsMap((prev) => ({
        ...prev,
        [courseId]: (prev[courseId] || []).filter((a) => a.id !== assignmentId),
      }));
      setSuccessMsg('Assignment deleted.');
      setTimeout(() => setSuccessMsg(null), 3000);
    }
  };

  // Open Submissions modal
  const handleOpenSubmissions = async (assignment: DbAssignment) => {
    setSelectedAssignmentForSubmissions(assignment);
    setLoadingSubmissions(true);
    setGradingSubmissionId(null);
    const { data, error: subErr } = await getSubmissionsForAssignment(assignment.id);
    if (subErr) {
      setError(`Failed to load student submissions: ${subErr.message}`);
      setSubmissionsList([]);
    } else {
      setSubmissionsList(data);
    }
    setLoadingSubmissions(false);
  };

  // Grade submission submit
  const handleGradeSubmissionSubmit = async (e: React.FormEvent, submissionId: string) => {
    e.preventDefault();
    if (!selectedAssignmentForSubmissions) return;

    const parsedMarks = Number(gradeMarks);
    if (
      !gradeMarks.trim() ||
      isNaN(parsedMarks) ||
      parsedMarks < 0 ||
      parsedMarks > selectedAssignmentForSubmissions.max_marks
    ) {
      setError(`Marks obtained must be a valid number between 0 and ${selectedAssignmentForSubmissions.max_marks}.`);
      return;
    }

    setSavingGrade(true);
    const { data, error: gradeErr } = await gradeSubmission(submissionId, parsedMarks, gradeFeedback);
    setSavingGrade(false);

    if (gradeErr) {
      setError(`Failed to save grade: ${gradeErr.message}`);
    } else if (data) {
      setSubmissionsList((prev) =>
        prev.map((s) => (s.id === submissionId ? { ...s, ...data } : s))
      );
      setGradingSubmissionId(null);
      setSuccessMsg('Grade and feedback saved.');
      setTimeout(() => setSuccessMsg(null), 3000);
    }
  };

  // Download instruction file
  const handleDownloadInstruction = async (filePath: string) => {
    const { url, error: dlErr } = await getInstructionDownloadUrl(filePath);
    if (dlErr || !url) {
      setError(dlErr?.message || 'Could not generate download link.');
    } else {
      window.open(url, '_blank');
    }
  };

  // Download submission file
  const handleDownloadSubmission = async (filePath: string) => {
    const { url, error: dlErr } = await getSubmissionDownloadUrl(filePath);
    if (dlErr || !url) {
      setError(dlErr?.message || 'Could not generate download link.');
    } else {
      window.open(url, '_blank');
    }
  };

  // Toggle quizzes accordion
  const handleToggleQuizzes = async (courseId: string) => {
    if (selectedCourseForQuizzes === courseId) {
      setSelectedCourseForQuizzes(null);
      return;
    }

    setSelectedCourseForQuizzes(courseId);
    if (!quizzesMap[courseId]) {
      setLoadingQuizzes(true);
      const { data, error: qErr } = await getCourseQuizzes(courseId, true);
      if (qErr) {
        setError(`Failed to load quizzes: ${qErr.message}`);
      } else {
        setQuizzesMap((prev) => ({ ...prev, [courseId]: data }));
      }
      setLoadingQuizzes(false);
    }
  };

  // Open create quiz modal
  const handleOpenCreateQuiz = (courseId: string) => {
    setQuizCourseId(courseId);
    setQuizTitle('');
    setQuizDesc('');
    setQuizTimeLimit('0');
    setQuizPassingScore('70');
    setQuizIsPublished(true);
    setShowCreateQuizModal(true);
  };

  // Create quiz submit
  const handleCreateQuizSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!quizCourseId || !quizTitle.trim()) return;

    const parsedTimeLimit = Number(quizTimeLimit);
    if (!quizTimeLimit.trim() || isNaN(parsedTimeLimit) || parsedTimeLimit < 0 || parsedTimeLimit > 300) {
      setError('Time limit must be between 0 (for untimed) and 300 minutes.');
      return;
    }

    const parsedPassingScore = Number(quizPassingScore);
    if (!quizPassingScore.trim() || isNaN(parsedPassingScore) || parsedPassingScore < 0 || parsedPassingScore > 100) {
      setError('Passing score must be a valid percentage between 0 and 100.');
      return;
    }

    setSubmittingQuiz(true);
    setError(null);

    const { data, error: createErr } = await createQuiz(
      quizCourseId,
      quizTitle,
      quizDesc,
      parsedTimeLimit,
      parsedPassingScore,
      quizIsPublished
    );

    setSubmittingQuiz(false);

    if (createErr) {
      setError(`Failed to create quiz: ${createErr.message}`);
    } else if (data) {
      setQuizzesMap((prev) => ({
        ...prev,
        [quizCourseId]: [...(prev[quizCourseId] || []), data],
      }));
      setShowCreateQuizModal(false);
      setSuccessMsg('Quiz created successfully.');
      setTimeout(() => setSuccessMsg(null), 3000);
    }
  };

  // Toggle publish quiz
  const handleTogglePublishQuiz = async (courseId: string, quizId: string, currentStatus: boolean) => {
    const { error: updErr } = await updateQuiz(quizId, { is_published: !currentStatus });
    if (updErr) {
      setError(`Failed to update quiz status: ${updErr.message}`);
    } else {
      setQuizzesMap((prev) => ({
        ...prev,
        [courseId]: (prev[courseId] || []).map((q) => (q.id === quizId ? { ...q, is_published: !currentStatus } : q)),
      }));
      setSuccessMsg(`Quiz ${!currentStatus ? 'published' : 'moved to draft'}.`);
      setTimeout(() => setSuccessMsg(null), 3000);
    }
  };

  // Delete quiz
  const handleDeleteQuiz = async (courseId: string, quizId: string) => {
    if (!confirm('Are you sure you want to delete this quiz, its questions, and all student attempts?')) return;
    const { success, error: delErr } = await deleteQuiz(quizId);
    if (!success) {
      setError(delErr?.message || 'Failed to delete quiz.');
    } else {
      setQuizzesMap((prev) => ({
        ...prev,
        [courseId]: (prev[courseId] || []).filter((q) => q.id !== quizId),
      }));
      setSuccessMsg('Quiz deleted.');
      setTimeout(() => setSuccessMsg(null), 3000);
    }
  };

  // Open questions editor modal
  const handleOpenQuestionsEditor = async (quiz: DbQuiz) => {
    setEditingQuizForQuestions(quiz);
    setLoadingQuestions(true);
    const { questions, error: qErr } = await getQuizWithQuestionsForInstructor(quiz.id);
    if (qErr) {
      setError(`Failed to load quiz questions: ${qErr.message}`);
      setEditingQuestions([]);
    } else {
      setEditingQuestions(
        questions.map((q) => ({
          id: q.id,
          question_text: q.question_text,
          options: q.options && q.options.length > 0 ? q.options : ['', '', '', ''],
          correct_option_index: q.correct_option_index ?? 0,
          marks: q.marks !== undefined && q.marks !== null ? String(q.marks) : '1',
          explanation: q.explanation || '',
        }))
      );
    }
    setLoadingQuestions(false);
  };

  // Add question to editor
  const handleAddQuestion = () => {
    setEditingQuestions((prev) => [
      ...prev,
      {
        question_text: '',
        options: ['Option A', 'Option B', 'Option C', 'Option D'],
        correct_option_index: 0,
        marks: '1',
        explanation: '',
      },
    ]);
  };

  // Update question in editor
  const handleUpdateQuestion = (index: number, updates: Partial<{
    question_text: string;
    options: string[];
    correct_option_index: number;
    marks: number | string;
    explanation?: string;
  }>) => {
    setEditingQuestions((prev) => {
      const copy = [...prev];
      copy[index] = { ...copy[index], ...updates };
      return copy;
    });
  };

  // Delete question from editor
  const handleDeleteQuestion = (index: number) => {
    setEditingQuestions((prev) => prev.filter((_, i) => i !== index));
  };

  // Save questions submit
  const handleSaveQuestionsSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingQuizForQuestions) return;

    for (let i = 0; i < editingQuestions.length; i++) {
      const q = editingQuestions[i];
      if (!q.question_text.trim()) {
        setError(`Question #${i + 1} requires question text.`);
        return;
      }
      if (!q.options || q.options.length < 2 || q.options.some((opt) => !opt.trim())) {
        setError(`Question #${i + 1} must have at least 2 non-empty options.`);
        return;
      }
      const rawMarks = String(q.marks).trim();
      const parsedMarks = Number(rawMarks);
      if (rawMarks === '' || isNaN(parsedMarks) || parsedMarks <= 0 || parsedMarks > 100) {
        setError(`Question #${i + 1} requires valid marks between 1 and 100.`);
        return;
      }
    }

    setSavingQuestions(true);
    setError(null);

    const questionsPayload = editingQuestions.map((q) => ({
      ...q,
      marks: Math.max(1, Math.round(Number(q.marks) || 1)),
    }));

    const { success, error: saveErr } = await saveQuizQuestions(
      editingQuizForQuestions.id,
      questionsPayload
    );

    setSavingQuestions(false);

    if (!success) {
      setError(`Failed to save questions: ${saveErr?.message}`);
    } else {
      setSuccessMsg('Quiz questions saved successfully.');
      setEditingQuizForQuestions(null);
      setTimeout(() => setSuccessMsg(null), 3000);
    }
  };

  // Open quiz attempts modal
  const handleOpenQuizAttempts = async (quiz: DbQuiz) => {
    setSelectedQuizForAttempts(quiz);
    setLoadingQuizAttempts(true);
    const { data, error: attErr } = await getQuizAttemptsForInstructor(quiz.id);
    if (attErr) {
      setError(`Failed to load quiz attempts: ${attErr.message}`);
      setQuizAttemptsList([]);
    } else {
      setQuizAttemptsList(data);
    }
    setLoadingQuizAttempts(false);
  };

  // Derived metrics
  const totalCourses = courses.length;
  const publishedCount = courses.filter((c) => c.is_published).length;
  const totalLessons = courses.reduce((acc, c) => acc + c.lessonsCount, 0);
  const totalEnrollments = courses.reduce((acc, c) => acc + c.enrollmentsCount, 0);

  return (
    <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-8">
      {/* Top Banner & Security Badge */}
      <div className="academic-card p-6 sm:p-8 space-y-6">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div className="space-y-1.5">
            <div className="flex items-center gap-2">
              <span className="px-3 py-1 rounded-full text-xs font-mono font-semibold bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9] flex items-center gap-1.5">
                <ShieldCheck className="w-3.5 h-3.5 text-[#1B3B2B]" />
                <span>Verified Faculty: {role.toUpperCase()}</span>
              </span>
              <span className="text-[11px] text-[#535C56] font-mono">
                PostgreSQL RLS Ownership Enforced
              </span>
            </div>
            <h1 className="font-editorial text-2xl sm:text-3xl text-[#1F2421]">
              Instructor Studio
            </h1>
            <p className="text-xs sm:text-sm text-[#535C56] max-w-2xl leading-relaxed">
              Author courses, manage curriculum lessons, publish learning modules, and monitor student enrollment progress.
            </p>
          </div>

          <div className="flex items-center gap-3">
            <button
              id="create-course-header-btn"
              onClick={() => setShowCreateModal(true)}
              className="btn-forest inline-flex items-center gap-2 px-4 py-2 text-xs font-semibold cursor-pointer"
            >
              <Plus className="w-4 h-4" />
              <span>Create New Course</span>
            </button>
            <Link
              to="/courses"
              className="btn-secondary inline-flex items-center gap-2 px-4 py-2 text-xs font-semibold"
            >
              <BookOpen className="w-4 h-4 text-[#1B3B2B]" />
              <span>Browse Catalog</span>
            </Link>
          </div>
        </div>

        {/* Quick Stats Grid */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 pt-4 border-t border-[#E5E2D9]">
          <div className="p-4 rounded-lg border border-[#E5E2D9] bg-[#FAF9F5] text-center">
            <div className="font-editorial text-2xl text-[#1F2421] font-mono">{totalCourses}</div>
            <div className="text-xs text-[#535C56] mt-0.5">Authored Courses</div>
          </div>
          <div className="p-4 rounded-lg border border-[#E5E2D9] bg-[#FAF9F5] text-center">
            <div className="font-editorial text-2xl text-[#1B3B2B] font-mono">{publishedCount}</div>
            <div className="text-xs text-[#535C56] mt-0.5">Published in Catalog</div>
          </div>
          <div className="p-4 rounded-lg border border-[#E5E2D9] bg-[#FAF9F5] text-center">
            <div className="font-editorial text-2xl text-[#1F2421] font-mono">{totalLessons}</div>
            <div className="text-xs text-[#535C56] mt-0.5">Curriculum Lessons</div>
          </div>
          <div className="p-4 rounded-lg border border-[#E5E2D9] bg-[#FAF9F5] text-center">
            <div className="font-editorial text-2xl text-[#1B3B2B] font-mono">{totalEnrollments}</div>
            <div className="text-xs text-[#535C56] mt-0.5">Active Enrollments</div>
          </div>
        </div>
      </div>

      {/* Notifications */}
      {error && (
        <div className="p-4 rounded bg-[#FDF1EE] border border-[#F5C2BA] text-[#9E3D2B] text-xs flex items-center justify-between gap-3">
          <div className="flex items-center gap-2">
            <AlertCircle className="w-4 h-4 shrink-0 text-[#9E3D2B]" />
            <span>{error}</span>
          </div>
          <button onClick={() => setError(null)} className="text-[#9E3D2B] hover:opacity-75 cursor-pointer">
            <X className="w-4 h-4" />
          </button>
        </div>
      )}

      {successMsg && (
        <div className="p-4 rounded bg-[#F4F1EA] border border-[#E5E2D9] text-[#1B3B2B] text-xs flex items-center justify-between gap-3">
          <div className="flex items-center gap-2">
            <CheckCircle2 className="w-4 h-4 shrink-0 text-[#1B3B2B]" />
            <span>{successMsg}</span>
          </div>
          <button onClick={() => setSuccessMsg(null)} className="text-[#1B3B2B] hover:opacity-75 cursor-pointer">
            <X className="w-4 h-4" />
          </button>
        </div>
      )}

      {/* Loading Courses */}
      {loading && (
        <div className="academic-card p-16 text-center space-y-3">
          <Loader2 className="w-6 h-6 text-[#1B3B2B] animate-spin mx-auto" />
          <p className="text-xs text-[#535C56] font-mono">Loading Instructor Studio catalog...</p>
        </div>
      )}

      {/* Empty State */}
      {!loading && courses.length === 0 && (
        <div className="academic-card p-16 text-center space-y-5">
          <div className="w-12 h-12 rounded bg-[#F4F1EA] border border-[#E5E2D9] text-[#1B3B2B] flex items-center justify-center mx-auto">
            <Sparkles className="w-6 h-6" />
          </div>
          <div className="space-y-1.5 max-w-md mx-auto">
            <h2 className="font-editorial text-xl text-[#1F2421]">No Authored Courses Found</h2>
            <p className="text-xs text-[#535C56] leading-relaxed">
              You haven't authored any courses yet. Create your first course to begin structuring modules, adding interactive lessons, and enrolling students.
            </p>
          </div>
          <div>
            <button
              onClick={() => setShowCreateModal(true)}
              className="btn-forest inline-flex items-center gap-2 px-5 py-2.5 text-xs font-semibold cursor-pointer"
            >
              <Plus className="w-4 h-4" />
              <span>Create Your First Course</span>
            </button>
          </div>
        </div>
      )}

      {/* Courses List */}
      {!loading && courses.length > 0 && (
        <div className="space-y-6">
          <div className="flex items-center justify-between">
            <h2 className="font-editorial text-xl sm:text-2xl text-[#1F2421] flex items-center gap-2">
              <BookOpen className="w-5 h-5 text-[#1B3B2B]" />
              <span>My Authored Courses ({courses.length})</span>
            </h2>
          </div>

          <div className="space-y-4">
            {courses.map((course) => {
              const isLessonsOpen = selectedCourseForLessons === course.id;
              const isEnrollmentsOpen = selectedCourseForEnrollments === course.id;
              const isAssignmentsOpen = selectedCourseForAssignments === course.id;
              const isQuizzesOpen = selectedCourseForQuizzes === course.id;
              const courseLessons = lessonsMap[course.id] || [];
              const courseEnrollments = enrollmentsMap[course.id] || [];
              const courseAssignments = assignmentsMap[course.id] || [];
              const courseQuizzes = quizzesMap[course.id] || [];

              return (
                <div
                  key={course.id}
                  className="academic-card hover:border-[#1B3B2B]/40 transition-all overflow-hidden"
                >
                  <div className="p-5 sm:p-6 flex flex-col lg:flex-row lg:items-center justify-between gap-6">
                    {/* Course Summary */}
                    <div className="flex items-start gap-4">
                      <img
                        src={getCourseCoverDisplayUrl(course.thumbnail_url)}
                        alt={course.title}
                        className="w-20 h-20 rounded-md object-cover border border-[#E5E2D9] shrink-0"
                        onError={(e) => {
                          (e.target as HTMLImageElement).src = DEFAULT_COURSE_THUMBNAIL;
                        }}
                      />
                      <div className="space-y-1.5">
                        <div className="flex flex-wrap items-center gap-2">
                          <span className="text-[11px] font-semibold px-2 py-0.5 rounded bg-[#F4F1EA] border border-[#E5E2D9] text-[#1F2421]">
                            {course.category}
                          </span>
                          <span className="text-[11px] font-semibold px-2 py-0.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-[#535C56]">
                            {course.level}
                          </span>
                          <span
                            className={`text-[11px] font-semibold px-2.5 py-0.5 rounded border flex items-center gap-1 ${
                              course.is_published
                                ? 'bg-[#F4F1EA] text-[#1B3B2B] border-[#E5E2D9]'
                                : 'bg-[#FAF9F5] text-[#535C56] border-[#E5E2D9]'
                            }`}
                          >
                            {course.is_published ? <Eye className="w-3 h-3 text-[#1B3B2B]" /> : <EyeOff className="w-3 h-3 text-[#7A857E]" />}
                            {course.is_published ? 'Published' : 'Draft'}
                          </span>
                        </div>
                        <h3 className="font-editorial text-lg text-[#1F2421] hover:text-[#1B3B2B] transition-colors">
                          {course.title}
                        </h3>
                        <p className="text-xs text-[#535C56] line-clamp-1 max-w-xl">
                          {course.description}
                        </p>
                      </div>
                    </div>

                    {/* Stats & Controls */}
                    {/* Stats & Controls */}
                    <div className="flex flex-wrap items-center gap-2.5 lg:self-center">
                      <div className="flex items-center gap-4 px-3.5 py-2 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs font-mono">
                        <div className="text-center">
                          <span className="text-[#535C56] block text-[10px]">Lessons</span>
                          <strong className="text-[#1F2421]">{course.lessonsCount}</strong>
                        </div>
                        <div className="h-6 w-px bg-[#E5E2D9]" />
                        <div className="text-center">
                          <span className="text-[#535C56] block text-[10px]">Students</span>
                          <strong className="text-[#1B3B2B]">{course.enrollmentsCount}</strong>
                        </div>
                      </div>

                      {/* Publication Toggle */}
                      <button
                        onClick={() => handleTogglePublish(course.id, course.is_published)}
                        className={`px-3 py-2 rounded text-xs font-semibold border transition-all flex items-center gap-1.5 cursor-pointer ${
                          course.is_published
                            ? 'bg-[#FAF9F5] hover:bg-[#F4F1EA] text-[#535C56] border-[#E5E2D9]'
                            : 'btn-forest'
                        }`}
                        title={course.is_published ? 'Unpublish from public catalog' : 'Publish to public catalog'}
                      >
                        {course.is_published ? <EyeOff className="w-3.5 h-3.5 text-[#535C56]" /> : <Eye className="w-3.5 h-3.5 text-[#FAF9F5]" />}
                        <span>{course.is_published ? 'Unpublish' : 'Publish'}</span>
                      </button>

                      {/* Manage Lessons Button */}
                      <button
                        id={`curriculum-toggle-btn-${course.id}`}
                        onClick={() => handleToggleLessons(course.id)}
                        className={`px-3.5 py-2 rounded text-xs font-semibold transition-colors flex items-center gap-1.5 cursor-pointer ${
                          isLessonsOpen
                            ? 'bg-[#1B3B2B] text-[#FAF9F5] border border-[#1B3B2B]'
                            : 'bg-[#FAF9F5] border border-[#E5E2D9] hover:bg-[#F4F1EA] text-[#1F2421]'
                        }`}
                      >
                        <Layers className="w-3.5 h-3.5" />
                        <span>Curriculum</span>
                        {isLessonsOpen ? <ChevronUp className="w-3 h-3" /> : <ChevronDown className="w-3 h-3" />}
                      </button>

                      {/* Enrolled Students Button */}
                      <button
                        onClick={() => handleToggleEnrollments(course.id)}
                        className={`px-3.5 py-2 rounded text-xs font-semibold transition-colors flex items-center gap-1.5 cursor-pointer ${
                          isEnrollmentsOpen
                            ? 'bg-[#1B3B2B] text-[#FAF9F5] border border-[#1B3B2B]'
                            : 'bg-[#FAF9F5] border border-[#E5E2D9] hover:bg-[#F4F1EA] text-[#1F2421]'
                        }`}
                      >
                        <Users className="w-3.5 h-3.5" />
                        <span>Enrolled ({course.enrollmentsCount})</span>
                        {isEnrollmentsOpen ? <ChevronUp className="w-3 h-3" /> : <ChevronDown className="w-3 h-3" />}
                      </button>

                      {/* Manage Assignments Button */}
                      <button
                        onClick={() => handleToggleAssignments(course.id)}
                        className={`px-3.5 py-2 rounded text-xs font-semibold transition-colors flex items-center gap-1.5 cursor-pointer ${
                          isAssignmentsOpen
                            ? 'bg-[#1B3B2B] text-[#FAF9F5] border border-[#1B3B2B]'
                            : 'bg-[#FAF9F5] border border-[#E5E2D9] hover:bg-[#F4F1EA] text-[#1F2421]'
                        }`}
                      >
                        <FileText className="w-3.5 h-3.5" />
                        <span>Assignments</span>
                        {isAssignmentsOpen ? <ChevronUp className="w-3 h-3" /> : <ChevronDown className="w-3 h-3" />}
                      </button>

                      {/* Manage Quizzes Button */}
                      <button
                        onClick={() => handleToggleQuizzes(course.id)}
                        className={`px-3.5 py-2 rounded text-xs font-semibold transition-colors flex items-center gap-1.5 cursor-pointer ${
                          isQuizzesOpen
                            ? 'bg-[#1B3B2B] text-[#FAF9F5] border border-[#1B3B2B]'
                            : 'bg-[#FAF9F5] border border-[#E5E2D9] hover:bg-[#F4F1EA] text-[#1F2421]'
                        }`}
                      >
                        <HelpCircle className="w-3.5 h-3.5" />
                        <span>Quizzes</span>
                        {isQuizzesOpen ? <ChevronUp className="w-3 h-3" /> : <ChevronDown className="w-3 h-3" />}
                      </button>

                      {/* Preview Course Link */}
                      <Link
                        to={`/courses/${course.id}`}
                        className="p-2 rounded border border-[#E5E2D9] bg-[#FAF9F5] hover:bg-[#F4F1EA] text-[#535C56] hover:text-[#1F2421] transition-colors"
                        title="View Course Page as Learner"
                      >
                        <Eye className="w-4 h-4" />
                      </Link>

                      {/* Edit Course Button */}
                      {(isAdminOrSysAdmin || course.instructor_id === userId) && (
                        <button
                          id={`edit-course-btn-${course.id}`}
                          onClick={() => handleOpenEditCourse(course)}
                          className="p-2 rounded border border-[#E5E2D9] bg-[#FAF9F5] hover:bg-[#F4F1EA] text-[#1B3B2B] transition-colors cursor-pointer"
                          title="Edit Course Details & Cover Image"
                        >
                          <Edit3 className="w-4 h-4" />
                        </button>
                      )}

                      {/* Delete Course Button */}
                      {(isAdminOrSysAdmin || course.instructor_id === userId) && (
                        <button
                          onClick={() => setCourseToDelete(course)}
                          className="p-2 rounded border border-[#E5E2D9] bg-[#FAF9F5] hover:bg-[#FDF1EE] text-[#9E3D2B] transition-colors cursor-pointer"
                          title="Delete Course and Associated Data"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      )}
                    </div>
                  </div>

                  {/* Lessons Management Panel */}
                  {isLessonsOpen && (
                    <div className="border-t border-[#E5E2D9] bg-[#F4F1EA]/60 p-5 sm:p-6 space-y-6">
                      <div className="flex items-center justify-between">
                        <div className="space-y-0.5">
                          <h4 className="text-sm font-semibold text-[#1F2421] flex items-center gap-2">
                            <Layers className="w-4 h-4 text-[#1B3B2B]" />
                            <span>Course Curriculum & Lessons</span>
                          </h4>
                          <p className="text-[11px] text-[#535C56]">
                            Lessons are protected by RLS; guest users can only stream free previews.
                          </p>
                        </div>
                      </div>

                      {loadingLessons ? (
                        <div className="py-6 text-center">
                          <Loader2 className="w-5 h-5 text-[#1B3B2B] animate-spin mx-auto" />
                        </div>
                      ) : (
                        <div className="space-y-3">
                          {courseLessons.length === 0 ? (
                            <p className="text-xs text-[#535C56] italic py-2">
                              No lessons created yet. Add your first lesson below.
                            </p>
                          ) : (
                            <div className="space-y-2">
                              {courseLessons.map((lesson, idx) => (
                                <div
                                  key={lesson.id}
                                  className="p-3.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] flex items-center justify-between gap-4"
                                >
                                  <div className="flex items-center gap-3 min-w-0">
                                    <span className="w-6 h-6 rounded bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9] text-xs font-mono font-semibold flex items-center justify-center shrink-0">
                                      {idx + 1}
                                    </span>
                                    <div className="min-w-0">
                                      <div className="text-xs font-semibold text-[#1F2421] truncate">
                                        {lesson.title}
                                      </div>
                                      <div className="flex items-center gap-2 text-[10px] text-[#535C56]">
                                        <span className="flex items-center gap-1">
                                          <Clock className="w-3 h-3 text-[#7A857E]" />
                                          {lesson.duration_minutes}m
                                        </span>
                                        {lesson.is_free_preview && (
                                          <span className="px-1.5 py-0.2 rounded bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9]">
                                            Free Preview
                                          </span>
                                        )}
                                      </div>
                                    </div>
                                  </div>

                                  <div className="flex items-center gap-1 shrink-0">
                                    <button
                                      onClick={() => handleOpenEditLesson(course.id, lesson)}
                                      className="p-1.5 rounded text-[#535C56] hover:text-[#1B3B2B] hover:bg-[#F4F1EA] transition-colors cursor-pointer"
                                      title="Edit Lesson & Video"
                                    >
                                      <Edit3 className="w-4 h-4" />
                                    </button>
                                    <button
                                      onClick={() => handleDeleteLesson(course.id, lesson.id)}
                                      className="p-1.5 rounded text-[#7A857E] hover:text-[#9E3D2B] hover:bg-[#FDF1EE] transition-colors cursor-pointer"
                                      title="Delete Lesson"
                                    >
                                      <Trash2 className="w-4 h-4" />
                                    </button>
                                  </div>
                                </div>
                              ))}
                            </div>
                          )}

                          {/* Add Lesson Form */}
                          <form
                            onSubmit={(e) => handleAddLessonSubmit(course.id, e)}
                            className="pt-4 border-t border-[#E5E2D9] space-y-3"
                          >
                            <h5 className="text-xs font-semibold text-[#1F2421]">Add New Lesson</h5>
                            <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                              <input
                                type="text"
                                placeholder="Lesson Title (e.g., Consensus Protocols)"
                                value={lessonTitle}
                                onChange={(e) => setLessonTitle(e.target.value)}
                                required
                                className="sm:col-span-2 px-3 py-2 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] placeholder-[#7A857E] focus:outline-none focus:border-[#1B3B2B]"
                              />
                              <input
                                type="number"
                                placeholder="Duration (min)"
                                value={lessonDuration}
                                onChange={(e) => setLessonDuration(e.target.value)}
                                min="1"
                                className="px-3 py-2 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] placeholder-[#7A857E] focus:outline-none focus:border-[#1B3B2B] font-mono"
                              />
                            </div>

                            {/* Lesson Video Upload Control */}
                            <LessonVideoUpload
                              videoMode={lessonVideoMode}
                              onModeChange={setLessonVideoMode}
                              selectedFile={lessonVideoFile}
                              onFileSelect={(file: File | null) => {
                                setLessonVideoFile(file);
                                setLessonVideoUploadError(null);
                              }}
                              externalUrl={lessonVideoUrl}
                              onExternalUrlChange={setLessonVideoUrl}
                              error={lessonVideoUploadError}
                              disabled={submittingLesson}
                            />

                            <div className="flex items-center gap-2 px-3 py-2 bg-[#FAF9F5] rounded border border-[#E5E2D9]">
                              <input
                                type="checkbox"
                                id={`preview-${course.id}`}
                                checked={lessonIsPreview}
                                onChange={(e) => setLessonIsPreview(e.target.checked)}
                                className="rounded border-[#E5E2D9] text-[#1B3B2B] focus:ring-0"
                              />
                              <label htmlFor={`preview-${course.id}`} className="text-xs text-[#1F2421] cursor-pointer">
                                Enable as Free Guest Preview
                              </label>
                            </div>

                            <textarea
                              rows={2}
                              placeholder="Lesson Content / Summary text..."
                              value={lessonContent}
                              onChange={(e) => setLessonContent(e.target.value)}
                              className="w-full px-3 py-2 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] placeholder-[#7A857E] focus:outline-none focus:border-[#1B3B2B] resize-none"
                            />

                            <button
                              type="submit"
                              disabled={submittingLesson || !lessonTitle.trim()}
                              className="btn-forest inline-flex items-center gap-2 px-4 py-2 text-xs font-semibold cursor-pointer disabled:opacity-50"
                            >
                              {submittingLesson ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : <Plus className="w-3.5 h-3.5" />}
                              <span>Append Lesson</span>
                            </button>
                          </form>
                        </div>
                      )}
                    </div>
                  )}

                  {/* Enrolled Students Panel */}
                  {isEnrollmentsOpen && (
                    <div className="border-t border-[#E5E2D9] bg-[#F4F1EA]/60 p-5 sm:p-6 space-y-4">
                      <div className="space-y-0.5">
                        <h4 className="text-sm font-semibold text-[#1F2421] flex items-center gap-2">
                          <Users className="w-4 h-4 text-[#1B3B2B]" />
                          <span>Enrolled Student Roster</span>
                        </h4>
                        <p className="text-[11px] text-[#535C56]">
                          Course enrollment visibility authorized under migration 006 RLS for course instructor.
                        </p>
                      </div>

                      {loadingEnrollments ? (
                        <div className="py-6 text-center">
                          <Loader2 className="w-5 h-5 text-[#1B3B2B] animate-spin mx-auto" />
                        </div>
                      ) : (
                        <div className="space-y-2">
                          {courseEnrollments.length === 0 ? (
                            <p className="text-xs text-[#535C56] italic py-2">
                              No students enrolled in this course yet.
                            </p>
                          ) : (
                            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
                              {courseEnrollments.map((enr) => (
                                <div
                                  key={enr.id}
                                  className="p-3.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] space-y-2"
                                >
                                  <div className="flex items-center justify-between">
                                    <div className="flex items-center gap-2.5">
                                      <div className="w-7 h-7 rounded-full bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9] font-bold text-xs flex items-center justify-center">
                                        {enr.student?.full_name?.charAt(0).toUpperCase() || 'S'}
                                      </div>
                                      <div>
                                        <div className="text-xs font-semibold text-[#1F2421]">
                                          {enr.student?.full_name || 'Enrolled Student'}
                                        </div>
                                        <div className="text-[10px] text-[#535C56] font-mono">
                                          {new Date(enr.enrolled_at).toLocaleDateString()}
                                        </div>
                                      </div>
                                    </div>
                                    <span
                                      className={`text-[10px] px-2 py-0.5 rounded-full font-semibold border ${
                                        enr.is_completed
                                          ? 'bg-[#F4F1EA] text-[#1B3B2B] border-[#E5E2D9]'
                                          : 'bg-[#FAF9F5] text-[#535C56] border-[#E5E2D9]'
                                      }`}
                                    >
                                      {enr.is_completed ? 'Completed' : `${enr.progress_percent || 0}%`}
                                    </span>
                                  </div>

                                  <div className="w-full h-1.5 bg-[#E5E2D9] rounded-full overflow-hidden">
                                    <div
                                      className="h-full rounded-full bg-[#1B3B2B]"
                                      style={{ width: `${Math.min(100, Math.max(0, enr.progress_percent || 0))}%` }}
                                    />
                                  </div>
                                </div>
                              ))}
                            </div>
                          )}
                        </div>
                      )}
                    </div>
                  )}

                  {/* Assignments Management Panel */}
                  {isAssignmentsOpen && (
                    <div className="border-t border-[#E5E2D9] bg-[#F4F1EA]/60 p-5 sm:p-6 space-y-6">
                      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                        <div className="space-y-0.5">
                          <h4 className="text-sm font-semibold text-[#1F2421] flex items-center gap-2">
                            <FileText className="w-4 h-4 text-[#1B3B2B]" />
                            <span>Course Assignments ({courseAssignments.length})</span>
                          </h4>
                          <p className="text-xs text-[#535C56]">
                            Create assignments, attach instruction documents (PDF, DOC, DOCX), and review student submissions.
                          </p>
                        </div>
                        <button
                          onClick={() => handleOpenCreateAssignment(course.id)}
                          className="btn-forest inline-flex items-center gap-1.5 px-3.5 py-2 text-xs font-semibold cursor-pointer self-start sm:self-auto"
                        >
                          <Plus className="w-3.5 h-3.5" />
                          <span>Add Assignment</span>
                        </button>
                      </div>

                      {loadingAssignments ? (
                        <div className="py-8 flex items-center justify-center gap-2 text-xs text-[#535C56]">
                          <Loader2 className="w-4 h-4 animate-spin text-[#1B3B2B]" />
                          <span>Loading assignments...</span>
                        </div>
                      ) : courseAssignments.length === 0 ? (
                        <div className="p-8 rounded border border-dashed border-[#E5E2D9] text-center space-y-3 bg-[#FAF9F5]">
                          <FileText className="w-8 h-8 text-[#7A857E] mx-auto" />
                          <p className="text-xs font-semibold text-[#1F2421]">No assignments created yet</p>
                          <p className="text-[11px] text-[#535C56] max-w-sm mx-auto">
                            Add practical assignments with due dates and instruction files to evaluate student understanding.
                          </p>
                          <button
                            onClick={() => handleOpenCreateAssignment(course.id)}
                            className="btn-secondary inline-flex items-center gap-1.5 px-3.5 py-1.5 text-xs font-medium cursor-pointer"
                          >
                            <Plus className="w-3.5 h-3.5" />
                            <span>Create Assignment</span>
                          </button>
                        </div>
                      ) : (
                        <div className="space-y-3">
                          {courseAssignments.map((assignment) => {
                            const isOverdue = new Date() > new Date(assignment.due_date);
                            return (
                              <div
                                key={assignment.id}
                                className="p-4 rounded border border-[#E5E2D9] bg-[#FAF9F5] hover:border-[#1B3B2B]/40 transition-all flex flex-col md:flex-row md:items-center justify-between gap-4"
                              >
                                <div className="space-y-1.5 flex-1 min-w-0">
                                  <div className="flex flex-wrap items-center gap-2">
                                    <h5 className="text-sm font-semibold text-[#1F2421] truncate">{assignment.title}</h5>
                                    <span
                                      className={`text-[10px] px-2 py-0.5 rounded-full font-semibold border ${
                                        assignment.is_published
                                          ? 'bg-[#F4F1EA] text-[#1B3B2B] border-[#E5E2D9]'
                                          : 'bg-[#FAF9F5] text-[#535C56] border-[#E5E2D9]'
                                      }`}
                                    >
                                      {assignment.is_published ? 'Published' : 'Draft'}
                                    </span>
                                    {assignment.allow_resubmission && (
                                      <span className="text-[10px] px-2 py-0.5 rounded-full font-semibold bg-[#F4F1EA] text-[#535C56] border border-[#E5E2D9]">
                                        Resubmissions Allowed
                                      </span>
                                    )}
                                  </div>
                                  <p className="text-xs text-[#535C56] line-clamp-1">{assignment.description}</p>
                                  <div className="flex flex-wrap items-center gap-4 text-[11px] text-[#535C56] font-mono pt-1">
                                    <span className="flex items-center gap-1">
                                      <Calendar className="w-3.5 h-3.5 text-[#7A857E]" />
                                      Due: {new Date(assignment.due_date).toLocaleDateString()} {new Date(assignment.due_date).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                                      {isOverdue && <span className="text-[#9E3D2B] font-bold ml-1">(Past Due)</span>}
                                    </span>
                                    <span className="flex items-center gap-1 text-[#1B3B2B] font-semibold">
                                      <Award className="w-3.5 h-3.5 text-[#1B3B2B]" />
                                      Max: {assignment.max_marks} marks
                                    </span>
                                    {assignment.instructions_file_path && (
                                      <button
                                        onClick={() => handleDownloadInstruction(assignment.instructions_file_path!)}
                                        className="text-[#1B3B2B] hover:underline flex items-center gap-1 cursor-pointer"
                                      >
                                        <Download className="w-3 h-3" />
                                        <span>Instructions: {assignment.instructions_file_name || 'Download file'}</span>
                                      </button>
                                    )}
                                  </div>
                                </div>

                                <div className="flex items-center gap-2 shrink-0">
                                  <button
                                    onClick={() => handleOpenSubmissions(assignment)}
                                    className="btn-secondary px-3 py-1.5 text-xs font-semibold flex items-center gap-1.5 cursor-pointer"
                                  >
                                    <Users className="w-3.5 h-3.5" />
                                    <span>Submissions</span>
                                  </button>
                                  <button
                                    onClick={() => handleTogglePublishAssignment(course.id, assignment.id, assignment.is_published)}
                                    className="p-2 rounded border border-[#E5E2D9] bg-[#FAF9F5] hover:bg-[#F4F1EA] text-[#535C56] hover:text-[#1F2421] transition-colors cursor-pointer"
                                    title={assignment.is_published ? 'Unpublish assignment' : 'Publish assignment'}
                                  >
                                    {assignment.is_published ? <EyeOff className="w-3.5 h-3.5" /> : <Eye className="w-3.5 h-3.5" />}
                                  </button>
                                  <button
                                    onClick={() => handleDeleteAssignment(course.id, assignment.id)}
                                    className="p-2 rounded border border-[#E5E2D9] bg-[#FAF9F5] hover:bg-[#FDF1EE] text-[#7A857E] hover:text-[#9E3D2B] transition-colors cursor-pointer"
                                    title="Delete assignment"
                                  >
                                    <Trash2 className="w-3.5 h-3.5" />
                                  </button>
                                </div>
                              </div>
                            );
                          })}
                        </div>
                      )}
                    </div>
                  )}

                  {/* Quizzes Management Panel */}
                  {isQuizzesOpen && (
                    <div className="border-t border-[#E5E2D9] bg-[#F4F1EA]/60 p-5 sm:p-6 space-y-6">
                      <div className="flex items-center justify-between">
                        <div className="space-y-0.5">
                          <h4 className="text-sm font-semibold text-[#1F2421] flex items-center gap-2">
                            <HelpCircle className="w-4 h-4 text-[#1B3B2B]" />
                            <span>Course Quizzes & Assessments</span>
                          </h4>
                          <p className="text-xs text-[#535C56]">
                            Create MCQ assessments with secure server-side grading, answer secrecy, and detailed review feedback.
                          </p>
                        </div>
                        <button
                          onClick={() => handleOpenCreateQuiz(course.id)}
                          className="btn-forest inline-flex items-center gap-1.5 px-3.5 py-1.5 text-xs font-semibold cursor-pointer"
                        >
                          <Plus className="w-3.5 h-3.5" />
                          <span>Create Quiz</span>
                        </button>
                      </div>

                      {loadingQuizzes && !quizzesMap[course.id] && (
                        <div className="p-8 text-center text-xs text-[#535C56] flex items-center justify-center gap-2">
                          <Loader2 className="w-4 h-4 animate-spin text-[#1B3B2B]" />
                          <span>Loading quizzes...</span>
                        </div>
                      )}

                      {!loadingQuizzes && courseQuizzes.length === 0 && (
                        <div className="p-8 text-center bg-[#FAF9F5] rounded border border-[#E5E2D9] space-y-2">
                          <HelpCircle className="w-8 h-8 text-[#7A857E] mx-auto" />
                          <p className="text-xs font-semibold text-[#1F2421]">No quizzes configured</p>
                          <p className="text-[11px] text-[#535C56] max-w-sm mx-auto">
                            No quizzes have been created for this course yet. Click "Create Quiz" to author questions and automated tests.
                          </p>
                        </div>
                      )}

                      {courseQuizzes.length > 0 && (
                        <div className="space-y-3">
                          {courseQuizzes.map((quiz) => (
                            <div
                              key={quiz.id}
                              className="p-4 rounded bg-[#FAF9F5] border border-[#E5E2D9] flex flex-col md:flex-row md:items-center justify-between gap-4"
                            >
                              <div className="space-y-1.5 flex-1">
                                <div className="flex flex-wrap items-center gap-2">
                                  <span
                                    className={`px-2 py-0.5 rounded-full text-[10px] font-semibold uppercase font-mono border ${
                                      quiz.is_published
                                        ? 'bg-[#F4F1EA] text-[#1B3B2B] border-[#E5E2D9]'
                                        : 'bg-[#FAF9F5] text-[#535C56] border-[#E5E2D9]'
                                    }`}
                                  >
                                    {quiz.is_published ? 'Published' : 'Draft'}
                                  </span>
                                  <span className="px-2 py-0.5 rounded-full text-[10px] font-semibold font-mono bg-[#F4F1EA] text-[#535C56] border border-[#E5E2D9]">
                                    {quiz.time_limit_minutes > 0 ? `${quiz.time_limit_minutes} min limit` : 'Untimed'}
                                  </span>
                                  <span className="px-2 py-0.5 rounded-full text-[10px] font-semibold font-mono bg-[#F4F1EA] text-[#535C56] border border-[#E5E2D9]">
                                    Pass: {quiz.passing_score}%
                                  </span>
                                </div>
                                <h5 className="text-sm font-semibold text-[#1F2421]">{quiz.title}</h5>
                                {quiz.description && (
                                  <p className="text-xs text-[#535C56] line-clamp-1">{quiz.description}</p>
                                )}
                              </div>

                              <div className="flex items-center gap-2 shrink-0">
                                <button
                                  onClick={() => handleOpenQuestionsEditor(quiz)}
                                  className="btn-secondary px-3 py-1.5 text-xs font-semibold flex items-center gap-1.5 cursor-pointer"
                                >
                                  <CheckSquare className="w-3.5 h-3.5 text-[#1B3B2B]" />
                                  <span>Questions</span>
                                </button>
                                <button
                                  onClick={() => handleOpenQuizAttempts(quiz)}
                                  className="btn-secondary px-3 py-1.5 text-xs font-semibold flex items-center gap-1.5 cursor-pointer"
                                >
                                  <Users className="w-3.5 h-3.5 text-[#535C56]" />
                                  <span>Attempts</span>
                                </button>
                                <button
                                  onClick={() => handleTogglePublishQuiz(course.id, quiz.id, quiz.is_published)}
                                  className="p-2 rounded border border-[#E5E2D9] bg-[#FAF9F5] hover:bg-[#F4F1EA] text-[#535C56] hover:text-[#1F2421] transition-colors cursor-pointer"
                                  title={quiz.is_published ? 'Unpublish quiz' : 'Publish quiz'}
                                >
                                  {quiz.is_published ? <EyeOff className="w-3.5 h-3.5" /> : <Eye className="w-3.5 h-3.5" />}
                                </button>
                                <button
                                  onClick={() => handleDeleteQuiz(course.id, quiz.id)}
                                  className="p-2 rounded border border-[#E5E2D9] bg-[#FAF9F5] hover:bg-[#FDF1EE] text-[#7A857E] hover:text-[#9E3D2B] transition-colors cursor-pointer"
                                  title="Delete quiz"
                                >
                                  <Trash2 className="w-3.5 h-3.5" />
                                </button>
                              </div>
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  )}

                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* Create Course Modal */}
      {showCreateModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-[#1F2421]/60 backdrop-blur-xs animate-in fade-in">
          <div className="w-full max-w-2xl bg-[#FAF9F5] rounded border border-[#E5E2D9] p-6 sm:p-8 space-y-6 shadow-xl overflow-y-auto max-h-[90vh]">
            <div className="flex items-center justify-between pb-4 border-b border-[#E5E2D9]">
              <div className="space-y-1">
                <h3 className="font-editorial text-xl sm:text-2xl text-[#1F2421] flex items-center gap-2">
                  <Sparkles className="w-5 h-5 text-[#1B3B2B]" />
                  <span>Create New Course</span>
                </h3>
                <p className="text-xs text-[#535C56] font-mono">
                  Course ownership is assigned to your database UUID: {userId}
                </p>
              </div>
              <button
                onClick={() => setShowCreateModal(false)}
                className="p-1.5 text-[#535C56] hover:text-[#1F2421] rounded hover:bg-[#F4F1EA] transition-colors cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleCreateCourseSubmit} className="space-y-4">
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-[#1F2421]">Course Title</label>
                <input
                  type="text"
                  required
                  placeholder="e.g., Cloud Native Microservices"
                  value={newTitle}
                  onChange={(e) => handleTitleChange(e.target.value)}
                  className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-sm text-[#1F2421] placeholder-[#7A857E] focus:outline-none focus:border-[#1B3B2B]"
                />
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-[#1F2421]">URL Slug</label>
                  <input
                    type="text"
                    required
                    placeholder="cloud-native-microservices"
                    value={newSlug}
                    onChange={(e) => setNewSlug(e.target.value)}
                    className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs font-mono text-[#1F2421] placeholder-[#7A857E] focus:outline-none focus:border-[#1B3B2B]"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-[#1F2421]">Category</label>
                  <select
                    value={newCategory}
                    onChange={(e) => setNewCategory(e.target.value)}
                    className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B]"
                  >
                    {CATEGORIES.map((cat) => (
                      <option key={cat} value={cat}>
                        {cat}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-[#1F2421]">Difficulty Level</label>
                <select
                  value={newLevel}
                  onChange={(e) => setNewLevel(e.target.value as 'Beginner' | 'Intermediate' | 'Advanced')}
                  className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B]"
                >
                  <option value="Beginner">Beginner</option>
                  <option value="Intermediate">Intermediate</option>
                  <option value="Advanced">Advanced</option>
                </select>
              </div>

              {/* Course Cover Image Upload Control */}
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-[#1F2421]">Course Cover Image</label>
                <CourseCoverUpload
                  currentImageUrl={newThumbnail}
                  selectedFile={newCoverFile}
                  onFileSelect={(file: File | null) => {
                    setNewCoverFile(file);
                    setNewCoverUploadError(null);
                  }}
                  externalUrl={newThumbnail}
                  onExternalUrlChange={setNewThumbnail}
                  isExternalMode={newCoverIsExternal}
                  onModeToggle={setNewCoverIsExternal}
                  error={newCoverUploadError}
                  disabled={submittingCourse}
                />
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-[#1F2421]">Description</label>
                <textarea
                  required
                  rows={3}
                  placeholder="Comprehensive description of the course curriculum, learning objectives, and prerequisites..."
                  value={newDescription}
                  onChange={(e) => setNewDescription(e.target.value)}
                  className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] placeholder-[#7A857E] focus:outline-none focus:border-[#1B3B2B] resize-none"
                />
              </div>

              <div className="flex items-center gap-2 pt-2">
                <input
                  type="checkbox"
                  id="new-publish-check"
                  checked={newIsPublished}
                  onChange={(e) => setNewIsPublished(e.target.checked)}
                  className="rounded border-[#E5E2D9] text-[#1B3B2B] focus:ring-0"
                />
                <label htmlFor="new-publish-check" className="text-xs text-[#1F2421] cursor-pointer">
                  Publish immediately to public catalog
                </label>
              </div>

              <div className="pt-4 flex items-center justify-end gap-3 border-t border-[#E5E2D9]">
                <button
                  type="button"
                  onClick={() => setShowCreateModal(false)}
                  className="btn-secondary px-4 py-2.5 text-xs font-semibold cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={submittingCourse || !newTitle.trim()}
                  className="btn-forest inline-flex items-center gap-2 px-6 py-2.5 text-xs font-semibold cursor-pointer disabled:opacity-50"
                >
                  {submittingCourse ? <Loader2 className="w-4 h-4 animate-spin" /> : <Plus className="w-4 h-4" />}
                  <span>Save Course</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Edit Course Modal */}
      {editingCourse && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-[#1F2421]/60 backdrop-blur-xs animate-in fade-in">
          <div className="w-full max-w-2xl bg-[#FAF9F5] rounded border border-[#E5E2D9] p-6 sm:p-8 space-y-6 shadow-xl overflow-y-auto max-h-[90vh]">
            <div className="flex items-center justify-between pb-4 border-b border-[#E5E2D9]">
              <div className="space-y-1">
                <h3 className="font-editorial text-xl sm:text-2xl text-[#1F2421] flex items-center gap-2">
                  <Edit3 className="w-5 h-5 text-[#1B3B2B]" />
                  <span>Edit Course Details</span>
                </h3>
                <p className="text-xs text-[#535C56] font-mono">
                  Course ID: {editingCourse.id}
                </p>
              </div>
              <button
                onClick={() => setEditingCourse(null)}
                className="p-1.5 text-[#535C56] hover:text-[#1F2421] rounded hover:bg-[#F4F1EA] transition-colors cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleEditCourseSubmit} className="space-y-4">
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-[#1F2421]">Course Title</label>
                <input
                  type="text"
                  required
                  value={editTitle}
                  onChange={(e) => setEditTitle(e.target.value)}
                  className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-sm text-[#1F2421] focus:outline-none focus:border-[#1B3B2B]"
                />
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-[#1F2421]">URL Slug</label>
                  <input
                    type="text"
                    required
                    value={editSlug}
                    onChange={(e) => setEditSlug(e.target.value)}
                    className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs font-mono text-[#1F2421] focus:outline-none focus:border-[#1B3B2B]"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-[#1F2421]">Category</label>
                  <select
                    value={editCategory}
                    onChange={(e) => setEditCategory(e.target.value)}
                    className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B]"
                  >
                    {CATEGORIES.map((cat) => (
                      <option key={cat} value={cat}>
                        {cat}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-[#1F2421]">Difficulty Level</label>
                <select
                  value={editLevel}
                  onChange={(e) => setEditLevel(e.target.value as 'Beginner' | 'Intermediate' | 'Advanced')}
                  className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B]"
                >
                  <option value="Beginner">Beginner</option>
                  <option value="Intermediate">Intermediate</option>
                  <option value="Advanced">Advanced</option>
                </select>
              </div>

              {/* Course Cover Image Upload Control */}
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-[#1F2421]">Course Cover Image</label>
                <CourseCoverUpload
                  currentImageUrl={editThumbnail}
                  selectedFile={editCoverFile}
                  onFileSelect={(file: File | null) => {
                    setEditCoverFile(file);
                    setEditCoverUploadError(null);
                  }}
                  externalUrl={editThumbnail}
                  onExternalUrlChange={setEditThumbnail}
                  isExternalMode={editCoverIsExternal}
                  onModeToggle={setEditCoverIsExternal}
                  error={editCoverUploadError}
                  disabled={submittingEditCourse}
                />
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-[#1F2421]">Description</label>
                <textarea
                  required
                  rows={3}
                  value={editDescription}
                  onChange={(e) => setEditDescription(e.target.value)}
                  className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B] resize-none"
                />
              </div>

              <div className="flex items-center gap-2 pt-2">
                <input
                  type="checkbox"
                  id="edit-publish-check"
                  checked={editIsPublished}
                  onChange={(e) => setEditIsPublished(e.target.checked)}
                  className="rounded border-[#E5E2D9] text-[#1B3B2B] focus:ring-0"
                />
                <label htmlFor="edit-publish-check" className="text-xs text-[#1F2421] cursor-pointer">
                  Published to public catalog
                </label>
              </div>

              <div className="pt-4 flex items-center justify-end gap-3 border-t border-[#E5E2D9]">
                <button
                  type="button"
                  onClick={() => setEditingCourse(null)}
                  className="btn-secondary px-4 py-2.5 text-xs font-semibold cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={submittingEditCourse || !editTitle.trim()}
                  className="btn-forest inline-flex items-center gap-2 px-6 py-2.5 text-xs font-semibold cursor-pointer disabled:opacity-50"
                >
                  {submittingEditCourse ? <Loader2 className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4" />}
                  <span>Save Changes</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Edit Lesson Modal */}
      {editingLesson && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-[#1F2421]/60 backdrop-blur-xs animate-in fade-in">
          <div className="w-full max-w-2xl bg-[#FAF9F5] rounded border border-[#E5E2D9] p-6 sm:p-8 space-y-6 shadow-xl overflow-y-auto max-h-[90vh]">
            <div className="flex items-center justify-between pb-4 border-b border-[#E5E2D9]">
              <div className="space-y-1">
                <h3 className="font-editorial text-xl sm:text-2xl text-[#1F2421] flex items-center gap-2">
                  <Edit3 className="w-5 h-5 text-[#1B3B2B]" />
                  <span>Edit Lesson & Video</span>
                </h3>
                <p className="text-xs text-[#535C56] font-mono">
                  Lesson ID: {editingLesson.id}
                </p>
              </div>
              <button
                onClick={() => {
                  setEditingLesson(null);
                  setEditingLessonCourseId(null);
                }}
                className="p-1.5 text-[#535C56] hover:text-[#1F2421] rounded hover:bg-[#F4F1EA] transition-colors cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleEditLessonSubmit} className="space-y-4">
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div className="sm:col-span-2 space-y-1.5">
                  <label className="text-xs font-semibold text-[#1F2421]">Lesson Title</label>
                  <input
                    type="text"
                    required
                    value={editLessonTitle}
                    onChange={(e) => setEditLessonTitle(e.target.value)}
                    className="w-full px-3 py-2 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] placeholder-[#7A857E] focus:outline-none focus:border-[#1B3B2B]"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-[#1F2421]">Duration (min)</label>
                  <input
                    type="number"
                    value={editLessonDuration}
                    onChange={(e) => setEditLessonDuration(e.target.value)}
                    min="1"
                    className="w-full px-3 py-2 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] placeholder-[#7A857E] focus:outline-none focus:border-[#1B3B2B] font-mono"
                  />
                </div>
              </div>

              {/* Lesson Video Upload Control */}
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-[#1F2421]">Lesson Video</label>
                <LessonVideoUpload
                  currentVideoUrl={editingLesson.video_url}
                  videoMode={editLessonVideoMode}
                  onModeChange={setEditLessonVideoMode}
                  selectedFile={editLessonVideoFile}
                  onFileSelect={(file: File | null) => {
                    setEditLessonVideoFile(file);
                    setEditLessonUploadError(null);
                  }}
                  externalUrl={editLessonVideoUrl}
                  onExternalUrlChange={setEditLessonVideoUrl}
                  error={editLessonUploadError}
                  disabled={submittingEditLesson}
                />
              </div>

              <div className="flex items-center gap-2 px-3 py-2 bg-[#F4F1EA] rounded border border-[#E5E2D9]">
                <input
                  type="checkbox"
                  id="edit-lesson-preview"
                  checked={editLessonIsPreview}
                  onChange={(e) => setEditLessonIsPreview(e.target.checked)}
                  className="rounded border-[#E5E2D9] text-[#1B3B2B] focus:ring-0"
                />
                <label htmlFor="edit-lesson-preview" className="text-xs text-[#1F2421] cursor-pointer">
                  Enable as Free Guest Preview
                </label>
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-[#1F2421]">Lesson Summary / Notes</label>
                <textarea
                  rows={3}
                  value={editLessonContent}
                  onChange={(e) => setEditLessonContent(e.target.value)}
                  className="w-full px-3 py-2 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] placeholder-[#7A857E] focus:outline-none focus:border-[#1B3B2B] resize-none"
                />
              </div>

              <div className="pt-4 flex items-center justify-end gap-3 border-t border-[#E5E2D9]">
                <button
                  type="button"
                  onClick={() => {
                    setEditingLesson(null);
                    setEditingLessonCourseId(null);
                  }}
                  className="btn-secondary px-4 py-2 text-xs font-semibold cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={submittingEditLesson || !editLessonTitle.trim()}
                  className="btn-forest inline-flex items-center gap-2 px-6 py-2.5 text-xs font-semibold cursor-pointer disabled:opacity-50"
                >
                  {submittingEditLesson ? <Loader2 className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4" />}
                  <span>Save Lesson</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Create Assignment Modal */}
      {showCreateAssignmentModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-[#1F2421]/60 backdrop-blur-xs animate-in fade-in">
          <div className="w-full max-w-xl bg-[#FAF9F5] rounded border border-[#E5E2D9] p-6 sm:p-8 space-y-6 shadow-xl overflow-y-auto max-h-[90vh]">
            <div className="flex items-center justify-between pb-4 border-b border-[#E5E2D9]">
              <div className="space-y-1">
                <h3 className="font-editorial text-xl sm:text-2xl text-[#1F2421] flex items-center gap-2">
                  <FileText className="w-5 h-5 text-[#1B3B2B]" />
                  <span>Create Course Assignment</span>
                </h3>
                <p className="text-xs text-[#535C56]">
                  Specify instructions, submission deadlines, and grading criteria for enrolled students.
                </p>
              </div>
              <button
                onClick={() => setShowCreateAssignmentModal(false)}
                className="p-1.5 rounded border border-[#E5E2D9] hover:bg-[#F4F1EA] text-[#535C56] hover:text-[#1F2421] transition-colors cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleCreateAssignmentSubmit} className="space-y-4">
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-[#1F2421]">Assignment Title *</label>
                <input
                  type="text"
                  required
                  id="assignment-title-input"
                  placeholder="e.g. Distributed Consensus Engine Implementation"
                  value={assignmentTitle}
                  onChange={(e) => setAssignmentTitle(e.target.value)}
                  className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B]"
                />
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-[#1F2421]">Description & Instructions *</label>
                <textarea
                  required
                  rows={3}
                  id="assignment-desc-input"
                  placeholder="Provide instructions, expected deliverables, and evaluation rubric..."
                  value={assignmentDesc}
                  onChange={(e) => setAssignmentDesc(e.target.value)}
                  className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B] resize-none"
                />
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-[#1F2421]">Submission Due Date *</label>
                  <input
                    type="datetime-local"
                    required
                    id="assignment-due-date"
                    value={assignmentDueDate}
                    onChange={(e) => setAssignmentDueDate(e.target.value)}
                    className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B] font-mono"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-[#1F2421]">Maximum Marks *</label>
                  <input
                    type="number"
                    min={1}
                    max={1000}
                    required
                    id="assignment-max-marks"
                    value={assignmentMaxMarks}
                    onChange={(e) => setAssignmentMaxMarks(e.target.value)}
                    className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B] font-mono"
                  />
                </div>
              </div>

              {/* Instruction Document Upload */}
              <div className="space-y-1.5 pt-1">
                <label className="text-xs font-semibold text-[#1F2421]">
                  Instruction File (Optional - PDF, DOC, DOCX up to 10 MB)
                </label>
                <div className="p-4 rounded border border-dashed border-[#E5E2D9] bg-[#F4F1EA]/60 text-center space-y-2">
                  <input
                    type="file"
                    id="instruction-file-input"
                    accept=".pdf,.doc,.docx,application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document"
                    onChange={(e) => {
                      const file = e.target.files?.[0];
                      if (file) {
                        const val = validateInstructionFile(file);
                        if (!val.valid) {
                          alert(val.error);
                          e.target.value = '';
                          setInstructionFile(null);
                        } else {
                          setInstructionFile(file);
                        }
                      }
                    }}
                    className="text-xs text-[#535C56] file:mr-3 file:py-1.5 file:px-3 file:rounded file:border-0 file:text-xs file:font-semibold file:bg-[#1B3B2B] file:text-[#FAF9F5] hover:file:bg-[#264E3A] file:cursor-pointer cursor-pointer"
                  />
                  {instructionFile && (
                    <div className="text-xs text-[#1B3B2B] font-mono flex items-center justify-center gap-1.5 pt-1">
                      <FileCheck className="w-4 h-4 text-[#1B3B2B]" />
                      <span>{instructionFile.name} ({(instructionFile.size / 1024).toFixed(1)} KB)</span>
                    </div>
                  )}
                </div>
              </div>

              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pt-2">
                <div className="flex items-center gap-2">
                  <input
                    type="checkbox"
                    id="allow-resubmit-check"
                    checked={assignmentAllowResubmission}
                    onChange={(e) => setAssignmentAllowResubmission(e.target.checked)}
                    className="rounded border-[#E5E2D9] text-[#1B3B2B] focus:ring-0"
                  />
                  <label htmlFor="allow-resubmit-check" className="text-xs text-[#1F2421] cursor-pointer">
                    Allow Student Resubmission
                  </label>
                </div>
                <div className="flex items-center gap-2">
                  <input
                    type="checkbox"
                    id="publish-assignment-check"
                    checked={assignmentIsPublished}
                    onChange={(e) => setAssignmentIsPublished(e.target.checked)}
                    className="rounded border-[#E5E2D9] text-[#1B3B2B] focus:ring-0"
                  />
                  <label htmlFor="publish-assignment-check" className="text-xs text-[#1F2421] cursor-pointer">
                    Publish Immediately
                  </label>
                </div>
              </div>

              <div className="pt-4 flex items-center justify-end gap-3 border-t border-[#E5E2D9]">
                <button
                  type="button"
                  onClick={() => setShowCreateAssignmentModal(false)}
                  className="btn-secondary px-4 py-2.5 text-xs font-semibold cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={submittingAssignment || !assignmentTitle.trim() || !assignmentDueDate}
                  id="submit-assignment-button"
                  className="btn-forest inline-flex items-center gap-2 px-6 py-2.5 text-xs font-semibold cursor-pointer disabled:opacity-50"
                >
                  {submittingAssignment ? <Loader2 className="w-4 h-4 animate-spin" /> : <Plus className="w-4 h-4" />}
                  <span>Save Assignment</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* View Submissions & Grading Modal */}
      {selectedAssignmentForSubmissions && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-[#1F2421]/60 backdrop-blur-xs animate-in fade-in">
          <div className="w-full max-w-3xl bg-[#FAF9F5] rounded border border-[#E5E2D9] p-6 sm:p-8 space-y-6 shadow-xl overflow-y-auto max-h-[90vh]">
            <div className="flex items-center justify-between pb-4 border-b border-[#E5E2D9]">
              <div className="space-y-1">
                <h3 className="font-editorial text-xl sm:text-2xl text-[#1F2421] flex items-center gap-2">
                  <FileText className="w-5 h-5 text-[#1B3B2B]" />
                  <span>Submissions: {selectedAssignmentForSubmissions.title}</span>
                </h3>
                <div className="flex flex-wrap items-center gap-3 text-xs text-[#535C56] font-mono">
                  <span>Max Marks: {selectedAssignmentForSubmissions.max_marks}</span>
                  <span>•</span>
                  <span>Due: {new Date(selectedAssignmentForSubmissions.due_date).toLocaleDateString()}</span>
                  <span>•</span>
                  <span>Submissions: {submissionsList.length}</span>
                </div>
              </div>
              <button
                onClick={() => setSelectedAssignmentForSubmissions(null)}
                className="p-1.5 rounded border border-[#E5E2D9] hover:bg-[#F4F1EA] text-[#535C56] hover:text-[#1F2421] transition-colors cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {loadingSubmissions ? (
              <div className="py-12 flex items-center justify-center gap-2 text-xs text-[#535C56]">
                <Loader2 className="w-5 h-5 animate-spin text-[#1B3B2B]" />
                <span>Loading submissions...</span>
              </div>
            ) : submissionsList.length === 0 ? (
              <div className="p-10 rounded border border-dashed border-[#E5E2D9] text-center space-y-3 bg-[#FAF9F5]">
                <Users className="w-8 h-8 text-[#7A857E] mx-auto" />
                <p className="text-xs font-semibold text-[#1F2421]">No student submissions yet</p>
                <p className="text-[11px] text-[#535C56] max-w-sm mx-auto">
                  Enrolled students have not submitted their work for this assignment yet. Submissions will appear here once uploaded.
                </p>
              </div>
            ) : (
              <div className="space-y-4">
                {submissionsList.map((sub) => {
                  const isGradingThis = gradingSubmissionId === sub.id;
                  const isGraded = sub.status === 'graded';

                  return (
                    <div
                      key={sub.id}
                      className="p-5 rounded border border-[#E5E2D9] bg-[#FAF9F5] space-y-4 transition-all"
                    >
                      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                        <div className="flex items-center gap-3">
                          <div className="w-9 h-9 rounded bg-[#F4F1EA] border border-[#E5E2D9] text-[#1B3B2B] font-bold text-xs flex items-center justify-center">
                            {sub.student?.full_name ? sub.student.full_name[0].toUpperCase() : 'S'}
                          </div>
                          <div>
                            <div className="text-xs font-semibold text-[#1F2421]">
                              {sub.student?.full_name || 'Enrolled Student'}
                            </div>
                            <div className="text-[11px] text-[#535C56] font-mono">
                              Submitted: {new Date(sub.submitted_at).toLocaleDateString()} at {new Date(sub.submitted_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                            </div>
                          </div>
                        </div>

                        <div className="flex items-center gap-2">
                          <span
                            className={`text-[10px] px-2.5 py-0.5 rounded-full font-semibold border ${
                              sub.status === 'graded'
                                ? 'bg-[#F4F1EA] text-[#1B3B2B] border-[#E5E2D9]'
                                : sub.status === 'late'
                                ? 'bg-[#FDF1EE] text-[#9E3D2B] border-[#F5C2BA]'
                                : sub.status === 'resubmitted'
                                ? 'bg-[#F4F1EA] text-[#535C56] border-[#E5E2D9]'
                                : 'bg-[#FAF9F5] text-[#535C56] border-[#E5E2D9]'
                            }`}
                          >
                            {sub.status.toUpperCase()}
                          </span>

                          <button
                            onClick={() => handleDownloadSubmission(sub.file_path)}
                            className="btn-secondary inline-flex items-center gap-1 px-3 py-1.5 text-xs font-medium cursor-pointer"
                          >
                            <Download className="w-3.5 h-3.5 text-[#1B3B2B]" />
                            <span>Download ({sub.file_name})</span>
                          </button>
                        </div>
                      </div>

                      {/* Grade & Feedback Section */}
                      {isGradingThis ? (
                        <form onSubmit={(e) => handleGradeSubmissionSubmit(e, sub.id)} className="p-4 rounded border border-[#1B3B2B]/40 bg-[#FAF9F5] space-y-3">
                          <div className="flex items-center justify-between">
                            <span className="text-xs font-semibold text-[#1F2421] flex items-center gap-1.5">
                              <Award className="w-4 h-4 text-[#1B3B2B]" />
                              <span>Evaluate Submission</span>
                            </span>
                            <span className="text-xs text-[#535C56] font-mono">
                              Max: {selectedAssignmentForSubmissions.max_marks} marks
                            </span>
                          </div>

                          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                            <div className="space-y-1">
                              <label className="text-[11px] font-semibold text-[#1F2421]">Marks Obtained</label>
                              <input
                                type="number"
                                min={0}
                                max={selectedAssignmentForSubmissions.max_marks}
                                required
                                value={gradeMarks}
                                onChange={(e) => setGradeMarks(e.target.value)}
                                className="w-full px-3 py-2 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B] font-mono"
                              />
                            </div>
                            <div className="sm:col-span-2 space-y-1">
                              <label className="text-[11px] font-semibold text-[#1F2421]">Written Feedback</label>
                              <input
                                type="text"
                                placeholder="Constructive feedback for the student..."
                                value={gradeFeedback}
                                onChange={(e) => setGradeFeedback(e.target.value)}
                                className="w-full px-3 py-2 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B]"
                              />
                            </div>
                          </div>

                          <div className="flex items-center justify-end gap-2 pt-2">
                            <button
                              type="button"
                              onClick={() => setGradingSubmissionId(null)}
                              className="btn-secondary px-3 py-1.5 text-xs cursor-pointer"
                            >
                              Cancel
                            </button>
                            <button
                              type="submit"
                              disabled={savingGrade}
                              className="btn-forest inline-flex items-center gap-1.5 px-4 py-1.5 text-xs font-semibold cursor-pointer"
                            >
                              {savingGrade ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : <CheckSquare className="w-3.5 h-3.5" />}
                              <span>Save Grade</span>
                            </button>
                          </div>
                        </form>
                      ) : (
                        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pt-1 border-t border-[#E5E2D9]">
                          {isGraded ? (
                            <div className="space-y-1">
                              <div className="text-xs font-bold text-[#1B3B2B] flex items-center gap-1.5 font-mono">
                                <Award className="w-4 h-4 text-[#1B3B2B]" />
                                <span>Marks: {sub.marks_obtained} / {selectedAssignmentForSubmissions.max_marks}</span>
                              </div>
                              {sub.feedback && (
                                <p className="text-xs text-[#1F2421] italic bg-[#F4F1EA] p-2 rounded border border-[#E5E2D9]">
                                  "{sub.feedback}"
                                </p>
                              )}
                            </div>
                          ) : (
                            <div className="text-xs text-[#535C56] italic">
                              Submission pending evaluation.
                            </div>
                          )}

                          <button
                            onClick={() => {
                              setGradingSubmissionId(sub.id);
                              setGradeMarks(String(sub.marks_obtained ?? selectedAssignmentForSubmissions.max_marks));
                              setGradeFeedback(sub.feedback || '');
                            }}
                            className="btn-secondary inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold cursor-pointer self-start sm:self-auto"
                          >
                            <Award className="w-3.5 h-3.5 text-[#1B3B2B]" />
                            <span>{isGraded ? 'Edit Grade' : 'Grade Submission'}</span>
                          </button>
                        </div>
                      )}
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </div>
      )}

      {/* Create Quiz Modal */}
      {showCreateQuizModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-[#1F2421]/60 backdrop-blur-xs animate-in fade-in">
          <div className="w-full max-w-xl bg-[#FAF9F5] rounded border border-[#E5E2D9] p-6 sm:p-8 space-y-6 shadow-xl overflow-y-auto max-h-[90vh]">
            <div className="flex items-center justify-between pb-4 border-b border-[#E5E2D9]">
              <div className="space-y-1">
                <h3 className="font-editorial text-xl sm:text-2xl text-[#1F2421] flex items-center gap-2">
                  <HelpCircle className="w-5 h-5 text-[#1B3B2B]" />
                  <span>Create Course Quiz</span>
                </h3>
                <p className="text-xs text-[#535C56]">
                  Configure assessment parameters, automated scoring, and passing criteria.
                </p>
              </div>
              <button
                onClick={() => setShowCreateQuizModal(false)}
                className="p-1.5 rounded border border-[#E5E2D9] hover:bg-[#F4F1EA] text-[#535C56] hover:text-[#1F2421] transition-colors cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleCreateQuizSubmit} className="space-y-4">
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-[#1F2421]">Quiz Title *</label>
                <input
                  type="text"
                  required
                  id="quiz-title-input"
                  placeholder="e.g., Module 1 Mastery: Relational Indexing & SQL"
                  value={quizTitle}
                  onChange={(e) => setQuizTitle(e.target.value)}
                  className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B]"
                />
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-[#1F2421]">Description</label>
                <textarea
                  rows={3}
                  placeholder="Overview of topics evaluated in this quiz and testing instructions..."
                  value={quizDesc}
                  onChange={(e) => setQuizDesc(e.target.value)}
                  className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B] resize-none"
                />
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-[#1F2421]">Time Limit (Minutes)</label>
                  <input
                    type="number"
                    min={0}
                    max={300}
                    placeholder="0 for untimed"
                    value={quizTimeLimit}
                    onChange={(e) => setQuizTimeLimit(e.target.value)}
                    className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B] font-mono"
                  />
                  <span className="text-[10px] text-[#535C56]">Set 0 for unlimited time.</span>
                </div>

                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-[#1F2421]">Passing Score (%)</label>
                  <input
                    type="number"
                    min={0}
                    max={100}
                    value={quizPassingScore}
                    onChange={(e) => setQuizPassingScore(e.target.value)}
                    className="w-full px-3.5 py-2.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B] font-mono"
                  />
                  <span className="text-[10px] text-[#535C56]">Benchmark score required to pass.</span>
                </div>
              </div>

              <div className="flex items-center gap-2 pt-2">
                <input
                  type="checkbox"
                  id="quiz-publish-check"
                  checked={quizIsPublished}
                  onChange={(e) => setQuizIsPublished(e.target.checked)}
                  className="rounded border-[#E5E2D9] text-[#1B3B2B] focus:ring-0"
                />
                <label htmlFor="quiz-publish-check" className="text-xs text-[#1F2421] cursor-pointer">
                  Publish quiz immediately to enrolled students
                </label>
              </div>

              <div className="pt-4 flex items-center justify-end gap-3 border-t border-[#E5E2D9]">
                <button
                  type="button"
                  onClick={() => setShowCreateQuizModal(false)}
                  className="btn-secondary px-4 py-2 text-xs font-semibold cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={submittingQuiz || !quizTitle.trim()}
                  className="btn-forest inline-flex items-center gap-2 px-6 py-2.5 text-xs font-semibold cursor-pointer disabled:opacity-50"
                >
                  {submittingQuiz ? <Loader2 className="w-4 h-4 animate-spin" /> : <Plus className="w-4 h-4" />}
                  <span>Save Quiz</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Questions Editor Modal */}
      {editingQuizForQuestions && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-[#1F2421]/60 backdrop-blur-xs animate-in fade-in">
          <div className="w-full max-w-3xl bg-[#FAF9F5] rounded border border-[#E5E2D9] p-6 sm:p-8 space-y-6 shadow-xl overflow-y-auto max-h-[90vh]">
            <div className="flex items-center justify-between pb-4 border-b border-[#E5E2D9]">
              <div className="space-y-1">
                <h3 className="font-editorial text-xl sm:text-2xl text-[#1F2421] flex items-center gap-2">
                  <CheckSquare className="w-5 h-5 text-[#1B3B2B]" />
                  <span>Edit Quiz MCQs: {editingQuizForQuestions.title}</span>
                </h3>
                <p className="text-xs text-[#535C56]">
                  Add multiple choice questions with correct answer designations, marks, and rationales.
                </p>
              </div>
              <button
                onClick={() => setEditingQuizForQuestions(null)}
                className="p-1.5 rounded border border-[#E5E2D9] hover:bg-[#F4F1EA] text-[#535C56] hover:text-[#1F2421] transition-colors cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {loadingQuestions ? (
              <div className="p-12 text-center text-xs text-[#535C56] flex items-center justify-center gap-2">
                <Loader2 className="w-4 h-4 animate-spin text-[#1B3B2B]" />
                <span>Loading questions...</span>
              </div>
            ) : (
              <form onSubmit={handleSaveQuestionsSubmit} className="space-y-6">
                <div className="flex items-center justify-between bg-[#F4F1EA] px-4 py-2.5 rounded border border-[#E5E2D9]">
                  <span className="text-xs font-semibold text-[#1F2421]">
                    Questions Count: {editingQuestions.length}
                  </span>
                  <button
                    type="button"
                    onClick={handleAddQuestion}
                    className="btn-forest inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold cursor-pointer"
                  >
                    <Plus className="w-3.5 h-3.5" />
                    <span>Add Question</span>
                  </button>
                </div>

                {editingQuestions.length === 0 ? (
                  <div className="p-8 text-center bg-[#FAF9F5] rounded border border-[#E5E2D9] space-y-2">
                    <p className="text-xs text-[#535C56]">No questions added yet.</p>
                    <button
                      type="button"
                      onClick={handleAddQuestion}
                      className="text-xs text-[#1B3B2B] hover:underline font-semibold cursor-pointer"
                    >
                      Click here to add your first question
                    </button>
                  </div>
                ) : (
                  <div className="space-y-6">
                    {editingQuestions.map((q, qIdx) => (
                      <div
                        key={qIdx}
                        className="p-5 rounded bg-[#F4F1EA]/50 border border-[#E5E2D9] space-y-4"
                      >
                        <div className="flex items-center justify-between">
                          <span className="text-xs font-bold text-[#1B3B2B] font-mono">
                            Question #{qIdx + 1}
                          </span>
                          <button
                            type="button"
                            onClick={() => handleDeleteQuestion(qIdx)}
                            className="p-1 rounded text-[#7A857E] hover:text-[#9E3D2B] transition-colors cursor-pointer"
                            title="Delete this question"
                          >
                            <Trash2 className="w-4 h-4" />
                          </button>
                        </div>

                        <div className="space-y-1.5">
                          <label className="text-[11px] font-semibold text-[#1F2421]">Question Text *</label>
                          <textarea
                            rows={2}
                            required
                            placeholder="Enter the MCQ question statement..."
                            value={q.question_text}
                            onChange={(e) => handleUpdateQuestion(qIdx, { question_text: e.target.value })}
                            className="w-full px-3 py-2 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B] resize-none"
                          />
                        </div>

                        {/* Options */}
                        <div className="space-y-2">
                          <label className="text-[11px] font-semibold text-[#1F2421]">
                            Answer Options (Select the radio next to the correct answer)
                          </label>
                          <div className="space-y-2">
                            {q.options.map((opt, optIdx) => (
                              <div key={optIdx} className="flex items-center gap-2.5">
                                <input
                                  type="radio"
                                  name={`correct-option-${qIdx}`}
                                  checked={q.correct_option_index === optIdx}
                                  onChange={() => handleUpdateQuestion(qIdx, { correct_option_index: optIdx })}
                                  className="text-[#1B3B2B] focus:ring-0 cursor-pointer"
                                  title="Mark this option as correct"
                                />
                                <span className="text-xs font-mono text-[#535C56] w-5">
                                  {String.fromCharCode(65 + optIdx)}.
                                </span>
                                <input
                                  type="text"
                                  required
                                  placeholder={`Option ${String.fromCharCode(65 + optIdx)}`}
                                  value={opt}
                                  onChange={(e) => {
                                    const nextOpts = [...q.options];
                                    nextOpts[optIdx] = e.target.value;
                                    handleUpdateQuestion(qIdx, { options: nextOpts });
                                  }}
                                  className={`flex-1 px-3 py-1.5 rounded text-xs text-[#1F2421] border focus:outline-none transition-colors ${
                                    q.correct_option_index === optIdx
                                      ? 'bg-[#F4F1EA] border-[#1B3B2B] font-semibold'
                                      : 'bg-[#FAF9F5] border-[#E5E2D9]'
                                  }`}
                                />
                              </div>
                            ))}
                          </div>
                        </div>

                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-1">
                          <div className="space-y-1">
                            <label className="text-[11px] font-semibold text-[#1F2421]">Marks for Question</label>
                            <input
                              type="number"
                              min={1}
                              max={100}
                              value={q.marks}
                              onChange={(e) => handleUpdateQuestion(qIdx, { marks: e.target.value })}
                              className="w-full px-3 py-1.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] font-mono focus:outline-none focus:border-[#1B3B2B]"
                            />
                          </div>

                          <div className="space-y-1">
                            <label className="text-[11px] font-semibold text-[#1F2421]">Explanation (Shown after submission)</label>
                            <input
                              type="text"
                              placeholder="Why is this answer correct?"
                              value={q.explanation || ''}
                              onChange={(e) => handleUpdateQuestion(qIdx, { explanation: e.target.value })}
                              className="w-full px-3 py-1.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B]"
                            />
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                )}

                <div className="pt-4 flex items-center justify-end gap-3 border-t border-[#E5E2D9]">
                  <button
                    type="button"
                    onClick={() => setEditingQuizForQuestions(null)}
                    className="btn-secondary px-4 py-2 text-xs font-semibold cursor-pointer"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    disabled={savingQuestions}
                    className="btn-forest inline-flex items-center gap-2 px-6 py-2.5 text-xs font-semibold cursor-pointer disabled:opacity-50"
                  >
                    {savingQuestions ? <Loader2 className="w-4 h-4 animate-spin" /> : <CheckSquare className="w-4 h-4" />}
                    <span>Save All Questions</span>
                  </button>
                </div>
              </form>
            )}
          </div>
        </div>
      )}

      {/* Quiz Attempts Review Modal */}
      {selectedQuizForAttempts && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-[#1F2421]/60 backdrop-blur-xs animate-in fade-in">
          <div className="w-full max-w-3xl bg-[#FAF9F5] rounded border border-[#E5E2D9] p-6 sm:p-8 space-y-6 shadow-xl overflow-y-auto max-h-[90vh]">
            <div className="flex items-center justify-between pb-4 border-b border-[#E5E2D9]">
              <div className="space-y-1">
                <h3 className="font-editorial text-xl sm:text-2xl text-[#1F2421] flex items-center gap-2">
                  <Users className="w-5 h-5 text-[#1B3B2B]" />
                  <span>Student Attempts: {selectedQuizForAttempts.title}</span>
                </h3>
                <p className="text-xs text-[#535C56]">
                  Audit auto-evaluated submissions, scores, and question performance.
                </p>
              </div>
              <button
                onClick={() => setSelectedQuizForAttempts(null)}
                className="p-1.5 rounded border border-[#E5E2D9] hover:bg-[#F4F1EA] text-[#535C56] hover:text-[#1F2421] transition-colors cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {loadingQuizAttempts ? (
              <div className="p-12 text-center text-xs text-[#535C56] flex items-center justify-center gap-2">
                <Loader2 className="w-4 h-4 animate-spin text-[#1B3B2B]" />
                <span>Loading student attempts...</span>
              </div>
            ) : quizAttemptsList.length === 0 ? (
              <div className="p-12 text-center bg-[#FAF9F5] rounded border border-[#E5E2D9] space-y-2">
                <Users className="w-8 h-8 text-[#7A857E] mx-auto" />
                <p className="text-xs font-semibold text-[#1F2421]">No attempts logged yet</p>
                <p className="text-[11px] text-[#535C56] max-w-sm mx-auto">
                  Enrolled students have not submitted answers for this quiz yet.
                </p>
              </div>
            ) : (
              <div className="space-y-4">
                {quizAttemptsList.map((att) => {
                  const passed = att.percentage >= (selectedQuizForAttempts.passing_score || 0);

                  return (
                    <div
                      key={att.id}
                      className="p-5 rounded bg-[#F4F1EA]/60 border border-[#E5E2D9] space-y-3"
                    >
                      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                        <div className="space-y-0.5">
                          <span className="text-xs font-semibold text-[#1F2421] font-mono">
                            Student ID: {att.student_id.slice(0, 8)}...
                          </span>
                          <span className="text-[11px] text-[#535C56] block font-mono">
                            Submitted: {new Date(att.submitted_at).toLocaleString()}
                          </span>
                        </div>

                        <div className="flex items-center gap-2">
                          <span
                            className={`px-2.5 py-1 rounded-full text-xs font-semibold font-mono border ${
                              passed
                                ? 'bg-[#F4F1EA] text-[#1B3B2B] border-[#E5E2D9]'
                                : 'bg-[#FDF1EE] text-[#9E3D2B] border-[#F5C2BA]'
                            }`}
                          >
                            {passed ? 'Passed' : 'Needs Review'} ({att.percentage}%)
                          </span>
                          <span className="px-3 py-1 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs font-mono font-semibold text-[#1F2421]">
                            {att.score} / {att.max_score} pts
                          </span>
                        </div>
                      </div>

                      {/* Detailed breakdown accordion or list */}
                      {att.detailed_results && att.detailed_results.length > 0 && (
                        <div className="pt-2 border-t border-[#E5E2D9] space-y-2">
                          <p className="text-[11px] font-semibold text-[#535C56] uppercase tracking-wider font-mono">
                            Question Breakdown ({att.detailed_results.filter((r) => r.is_correct).length} of {att.detailed_results.length} correct)
                          </p>
                          <div className="grid grid-cols-1 gap-2 max-h-48 overflow-y-auto pr-1">
                            {att.detailed_results.map((rev, rIdx) => (
                              <div
                                key={rIdx}
                                className={`p-2.5 rounded border text-xs space-y-1 ${
                                  rev.is_correct
                                    ? 'bg-[#FAF9F5] border-[#E5E2D9] text-[#1F2421]'
                                    : 'bg-[#FDF1EE]/70 border-[#F5C2BA] text-[#9E3D2B]'
                                }`}
                              >
                                <div className="flex items-center justify-between font-semibold">
                                  <span>Q{rIdx + 1}: {rev.question_text}</span>
                                  <span className="font-mono">
                                    {rev.marks_earned} / {rev.max_marks} pts
                                  </span>
                                </div>
                                <div className="text-[11px] opacity-90">
                                  <span>Selected: {rev.selected_option >= 0 ? rev.options[rev.selected_option] : 'Unanswered'}</span>
                                  {!rev.is_correct && (
                                    <span className="ml-2 font-bold text-[#1B3B2B]">
                                      (Correct: {rev.options[rev.correct_option]})
                                    </span>
                                  )}
                                </div>
                                {rev.explanation && (
                                  <div className="text-[11px] text-[#535C56] pt-1">
                                    <span className="font-semibold text-[#1B3B2B]">Note: </span>
                                    <MarkdownRenderer content={rev.explanation} compact />
                                  </div>
                                )}
                              </div>
                            ))}
                          </div>
                        </div>
                      )}
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </div>
      )}

      {/* Course Deletion Confirmation Modal */}
      {courseToDelete && (
        <div className="fixed inset-0 bg-[#1F2421]/60 backdrop-blur-xs z-50 flex items-center justify-center p-4">
          <div className="bg-[#FAF9F5] rounded max-w-md w-full p-6 shadow-xl border border-[#E5E2D9] space-y-5 animate-in fade-in duration-200">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded bg-[#FDF1EE] border border-[#F5C2BA] flex items-center justify-center text-[#9E3D2B] shrink-0">
                <Trash2 className="w-5 h-5" />
              </div>
              <div>
                <h3 className="font-editorial text-lg text-[#1F2421]">
                  Delete Course Confirmation
                </h3>
                <p className="text-xs text-[#535C56]">
                  This action is permanent and cannot be undone.
                </p>
              </div>
            </div>

            <div className="p-4 rounded bg-[#F4F1EA] border border-[#E5E2D9] space-y-2 text-xs text-[#1F2421]">
              <p>
                Are you sure you want to permanently delete:
              </p>
              <p className="font-semibold text-[#1F2421] text-sm break-words">
                "{courseToDelete.title}"
              </p>
              <div className="pt-2 text-[11px] text-[#9E3D2B] space-y-1 border-t border-[#E5E2D9]">
                <p className="font-semibold">All associated records will be removed:</p>
                <ul className="list-disc list-inside space-y-0.5 text-[#535C56]">
                  <li>{courseToDelete.lessonsCount} curriculum lessons</li>
                  <li>All quizzes and question banks</li>
                  <li>All assignments and student submissions</li>
                  <li>{courseToDelete.enrollmentsCount} active student enrollments</li>
                  <li>Associated instruction files and storage objects</li>
                </ul>
              </div>
            </div>

            <div className="flex items-center justify-end gap-3 pt-2">
              <button
                type="button"
                onClick={() => setCourseToDelete(null)}
                disabled={deletingCourse}
                className="btn-secondary px-4 py-2.5 text-xs font-semibold cursor-pointer disabled:opacity-50"
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={handleConfirmDeleteCourse}
                disabled={deletingCourse}
                className="inline-flex items-center gap-2 px-5 py-2.5 rounded bg-[#9E3D2B] hover:bg-[#833223] text-[#FAF9F5] text-xs font-semibold shadow-xs transition-colors cursor-pointer disabled:opacity-50"
              >
                {deletingCourse ? (
                  <>
                    <Loader2 className="w-4 h-4 animate-spin" />
                    <span>Deleting Course...</span>
                  </>
                ) : (
                  <>
                    <Trash2 className="w-4 h-4" />
                    <span>Confirm & Delete Course</span>
                  </>
                )}
              </button>
            </div>
          </div>
        </div>
      )}

    </div>
  );
};

