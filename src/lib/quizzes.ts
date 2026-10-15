import { supabase } from './supabaseClient';
import type {
  DbQuiz,
  DbQuizQuestion,
  StudentQuizQuestion,
  DbQuizAttempt,
  QuizWithStudentStatus,
} from '../types';

/**
 * Fetch quizzes for a course.
 */
export async function getCourseQuizzes(
  courseId: string,
  isInstructor: boolean = false,
  studentId?: string
): Promise<{ data: QuizWithStudentStatus[]; error: Error | null }> {
  try {
    let query = supabase
      .from('quizzes')
      .select('id, course_id, title, description, time_limit_minutes, passing_score, is_published, created_at, updated_at')
      .eq('course_id', courseId)
      .order('created_at', { ascending: true });

    if (!isInstructor) {
      query = query.eq('is_published', true);
    }

    const { data: quizzes, error } = await query;
    if (error) {
      return { data: [], error };
    }

    const list = (quizzes || []) as DbQuiz[];
    const attemptsMap: Record<string, DbQuizAttempt> = {};

    if (studentId && list.length > 0) {
      const { data: dbAttempts } = await supabase
        .from('quiz_attempts')
        .select('*')
        .in('quiz_id', list.map((q) => q.id))
        .eq('student_id', studentId)
        .order('submitted_at', { ascending: false });

      if (dbAttempts) {
        for (const att of dbAttempts) {
          if (!attemptsMap[att.quiz_id]) {
            attemptsMap[att.quiz_id] = att as DbQuizAttempt;
          }
        }
      }
    }

    const result: QuizWithStudentStatus[] = list.map((q) => ({
      ...q,
      latest_attempt: attemptsMap[q.id] || null,
    }));

    return { data: result, error: null };
  } catch (err) {
    return { data: [], error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Fetch a quiz along with all questions (Instructors only, includes answer keys).
 */
export async function getQuizWithQuestionsForInstructor(
  quizId: string
): Promise<{ quiz: DbQuiz | null; questions: DbQuizQuestion[]; error: Error | null }> {
  try {
    const { data: quiz, error: qErr } = await supabase
      .from('quizzes')
      .select('*')
      .eq('id', quizId)
      .single();

    if (qErr || !quiz) {
      return { quiz: null, questions: [], error: qErr || new Error('Quiz not found') };
    }

    const { data: questions, error: qstErr } = await supabase
      .from('quiz_questions')
      .select('*')
      .eq('quiz_id', quizId)
      .order('order_index', { ascending: true });

    if (qstErr) {
      return { quiz: quiz as DbQuiz, questions: [], error: qstErr };
    }

    return {
      quiz: quiz as DbQuiz,
      questions: (questions || []) as DbQuizQuestion[],
      error: null,
    };
  } catch (err) {
    return { quiz: null, questions: [], error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Fetch a quiz for an enrolled student.
 * Guarantees correct_option_index and explanation are stripped by server-side RPC.
 */
export async function getQuizForStudent(
  quizId: string
): Promise<{
  quiz: DbQuiz | null;
  questions: StudentQuizQuestion[];
  latestAttempt: DbQuizAttempt | null;
  error: Error | null;
}> {
  try {
    const { data: quiz, error: quizError } = await supabase
      .from('quizzes')
      .select('*')
      .eq('id', quizId)
      .eq('is_published', true)
      .single();

    if (quizError || !quiz) {
      return { quiz: null, questions: [], latestAttempt: null, error: quizError || new Error('Quiz not found') };
    }

    const { data: questionsData, error: questionsError } = await supabase.rpc('get_student_quiz_questions', {
      p_quiz_id: quizId,
    });

    if (questionsError) {
      return { quiz: quiz as DbQuiz, questions: [], latestAttempt: null, error: questionsError };
    }

    // Fetch student's latest attempt if any
    const { data: attemptsData } = await supabase
      .from('quiz_attempts')
      .select('*')
      .eq('quiz_id', quizId)
      .order('submitted_at', { ascending: false })
      .limit(1);

    const latestAttempt = attemptsData && attemptsData.length > 0 ? (attemptsData[0] as DbQuizAttempt) : null;

    return {
      quiz: quiz as DbQuiz,
      questions: (questionsData || []) as StudentQuizQuestion[],
      latestAttempt,
      error: null,
    };
  } catch (err) {
    return { quiz: null, questions: [], latestAttempt: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Create a new quiz.
 */
export async function createQuiz(
  courseId: string,
  title: string,
  description?: string,
  timeLimitMinutes: number = 0,
  passingScore: number = 0,
  isPublished: boolean = false
): Promise<{ data: DbQuiz | null; error: Error | null }> {
  try {
    const { data, error } = await supabase
      .from('quizzes')
      .insert({
        course_id: courseId,
        title: title.trim(),
        description: description?.trim() || null,
        time_limit_minutes: timeLimitMinutes,
        passing_score: passingScore,
        is_published: isPublished,
      })
      .select()
      .single();

    if (error) {
      return { data: null, error };
    }

    return { data: data as DbQuiz, error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Update a quiz.
 */
export async function updateQuiz(
  quizId: string,
  updates: Partial<Pick<DbQuiz, 'title' | 'description' | 'time_limit_minutes' | 'passing_score' | 'is_published'>>
): Promise<{ data: DbQuiz | null; error: Error | null }> {
  try {
    const { data, error } = await supabase
      .from('quizzes')
      .update({
        ...updates,
        updated_at: new Date().toISOString(),
      })
      .eq('id', quizId)
      .select()
      .single();

    if (error) {
      return { data: null, error };
    }

    return { data: data as DbQuiz, error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Delete a quiz.
 */
export async function deleteQuiz(quizId: string): Promise<{ success: boolean; error: Error | null }> {
  try {
    const { error } = await supabase.from('quizzes').delete().eq('id', quizId);
    if (error) {
      return { success: false, error };
    }
    return { success: true, error: null };
  } catch (err) {
    return { success: false, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Save questions for a quiz (Instructor only).
 */
export async function saveQuizQuestions(
  quizId: string,
  questions: Array<{
    id?: string;
    question_text: string;
    options: string[];
    correct_option_index: number;
    marks: number;
    explanation?: string;
    order_index?: number;
  }>
): Promise<{ success: boolean; data: DbQuizQuestion[]; error: Error | null }> {
  const prepared: DbQuizQuestion[] = questions.map((q, idx) => ({
    id: q.id || crypto.randomUUID(),
    quiz_id: quizId,
    question_text: q.question_text.trim(),
    options: q.options,
    correct_option_index: q.correct_option_index,
    marks: Number(q.marks) || 1,
    explanation: q.explanation?.trim() || null,
    order_index: q.order_index ?? idx,
    created_at: new Date().toISOString(),
  }));

  try {
    const { error: delError } = await supabase.from('quiz_questions').delete().eq('quiz_id', quizId);
    if (delError) {
      return { success: false, data: [], error: delError };
    }

    const { data, error: insertError } = await supabase
      .from('quiz_questions')
      .insert(prepared)
      .select();

    if (insertError) {
      return { success: false, data: [], error: insertError };
    }

    return { success: true, data: (data || []) as DbQuizQuestion[], error: null };
  } catch (err) {
    return { success: false, data: [], error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Submit answers for a quiz.
 * Scores answers on server via RPC and returns attempt with detailed review.
 */
export async function submitQuizAnswers(
  quizId: string,
  answers: Record<string, number>
): Promise<{ data: DbQuizAttempt | null; error: Error | null }> {
  try {
    const { data, error } = await supabase.rpc('submit_quiz_attempt', {
      p_quiz_id: quizId,
      p_answers: answers,
    });

    if (error) {
      return { data: null, error };
    }

    let payload = (data?.attempt || data) as Record<string, any> | null;
    if (typeof payload === 'string') {
      try {
        payload = JSON.parse(payload);
      } catch {
        // keep as is
      }
    }

    if (payload && (payload.attempt_id || payload.id)) {
      const attempt: DbQuizAttempt = {
        id: (payload.id || payload.attempt_id) as string,
        quiz_id: (payload.quiz_id || quizId) as string,
        student_id: (payload.student_id || '') as string,
        score: Number(payload.score ?? 0),
        max_score: Number(payload.max_score ?? 0),
        percentage: Number(payload.percentage ?? 0),
        submitted_answers: payload.submitted_answers || answers,
        detailed_results: payload.detailed_results || [],
        submitted_at: payload.submitted_at || new Date().toISOString(),
      };
      return { data: attempt, error: null };
    }

    return { data: null, error: new Error('Failed to score quiz attempt') };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Fetch all attempts for a quiz (Instructor only).
 */
export async function getQuizAttemptsForInstructor(
  quizId: string
): Promise<{ data: DbQuizAttempt[]; error: Error | null }> {
  try {
    const { data, error } = await supabase
      .from('quiz_attempts')
      .select('*')
      .eq('quiz_id', quizId)
      .order('submitted_at', { ascending: false });

    if (error) {
      return { data: [], error };
    }

    return { data: (data || []) as DbQuizAttempt[], error: null };
  } catch (err) {
    return { data: [], error: err instanceof Error ? err : new Error(String(err)) };
  }
}
