-- ============================================================================
-- Migration: 20261010000009_quizzes_schema_and_scoring.sql
-- Description: Quizzes schema, MCQ questions, answer secrecy, and server-side scoring
-- ============================================================================

-- 1. Create Quizzes Table
CREATE TABLE IF NOT EXISTS public.quizzes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    time_limit_minutes INTEGER DEFAULT 0,
    passing_score INTEGER DEFAULT 0,
    is_published BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Create Quiz Questions Table (MCQs)
CREATE TABLE IF NOT EXISTS public.quiz_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quiz_id UUID NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    options JSONB NOT NULL, -- Array of strings e.g. ["Option A", "Option B", "Option C", "Option D"]
    correct_option_index INTEGER NOT NULL CHECK (correct_option_index >= 0),
    marks INTEGER NOT NULL DEFAULT 1 CHECK (marks > 0),
    explanation TEXT,
    order_index INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Create Quiz Attempts Table (Stores student submissions, computed scores, and review snapshots)
CREATE TABLE IF NOT EXISTS public.quiz_attempts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quiz_id UUID NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    score INTEGER NOT NULL DEFAULT 0,
    max_score INTEGER NOT NULL DEFAULT 0,
    percentage NUMERIC(5,2) NOT NULL DEFAULT 0.00,
    submitted_answers JSONB NOT NULL, -- { "<question_id>": selected_index }
    detailed_results JSONB NOT NULL,   -- Array of question review objects
    submitted_at TIMESTAMPTZ DEFAULT now()
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_quizzes_course_id ON public.quizzes(course_id);
CREATE INDEX IF NOT EXISTS idx_quiz_questions_quiz_id ON public.quiz_questions(quiz_id);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_quiz_student ON public.quiz_attempts(quiz_id, student_id);

-- 4. Enable Row Level Security (RLS)
ALTER TABLE public.quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_attempts ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- RLS Policies for Quizzes
-- ----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Public can view published quizzes" ON public.quizzes;
DROP POLICY IF EXISTS "Instructors can view all quizzes for owned courses" ON public.quizzes;
DROP POLICY IF EXISTS "Instructors can create quizzes for owned courses" ON public.quizzes;
DROP POLICY IF EXISTS "Instructors can update quizzes for owned courses" ON public.quizzes;
DROP POLICY IF EXISTS "Instructors can delete quizzes for owned courses" ON public.quizzes;
DROP POLICY IF EXISTS "Admins have full access to quizzes" ON public.quizzes;

-- Students / Enrolled users can view published quizzes for enrolled courses
CREATE POLICY "Enrolled students can view published quizzes"
ON public.quizzes
FOR SELECT
TO authenticated
USING (
    is_published = TRUE
    AND EXISTS (
        SELECT 1 FROM public.enrollments e
        WHERE e.course_id = quizzes.course_id
        AND e.student_id = auth.uid()
    )
);

-- Course instructors can view all quizzes (drafts + published)
CREATE POLICY "Instructors can view quizzes for owned courses"
ON public.quizzes
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.courses c
        WHERE c.id = quizzes.course_id
        AND c.instructor_id = auth.uid()
    )
);

-- Instructors can create quizzes for their courses
CREATE POLICY "Instructors can insert quizzes for owned courses"
ON public.quizzes
FOR INSERT
TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.courses c
        WHERE c.id = course_id
        AND c.instructor_id = auth.uid()
    )
);

-- Instructors can update quizzes for their courses
CREATE POLICY "Instructors can update quizzes for owned courses"
ON public.quizzes
FOR UPDATE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.courses c
        WHERE c.id = quizzes.course_id
        AND c.instructor_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.courses c
        WHERE c.id = course_id
        AND c.instructor_id = auth.uid()
    )
);

-- Instructors can delete quizzes for their courses
CREATE POLICY "Instructors can delete quizzes for owned courses"
ON public.quizzes
FOR DELETE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.courses c
        WHERE c.id = quizzes.course_id
        AND c.instructor_id = auth.uid()
    )
);

-- Admins full access
CREATE POLICY "Admins have full access to quizzes"
ON public.quizzes
FOR ALL
TO authenticated
USING (public.is_admin() OR public.is_system_admin())
WITH CHECK (public.is_admin() OR public.is_system_admin());


-- ----------------------------------------------------------------------------
-- RLS Policies for Quiz Questions (PROTECTING ANSWER KEYS)
-- ----------------------------------------------------------------------------
-- Note: Direct SELECT on quiz_questions is ONLY granted to instructors and admins.
-- Students MUST retrieve questions via public.get_student_quiz_questions()
-- which excludes correct_option_index and explanation before submission.

DROP POLICY IF EXISTS "Instructors can manage quiz questions" ON public.quiz_questions;
DROP POLICY IF EXISTS "Admins can manage quiz questions" ON public.quiz_questions;

CREATE POLICY "Instructors can manage quiz questions"
ON public.quiz_questions
FOR ALL
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.quizzes q
        JOIN public.courses c ON c.id = q.course_id
        WHERE q.id = quiz_questions.quiz_id
        AND c.instructor_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.quizzes q
        JOIN public.courses c ON c.id = q.course_id
        WHERE q.id = quiz_id
        AND c.instructor_id = auth.uid()
    )
);

CREATE POLICY "Admins can manage quiz questions"
ON public.quiz_questions
FOR ALL
TO authenticated
USING (public.is_admin() OR public.is_system_admin())
WITH CHECK (public.is_admin() OR public.is_system_admin());


-- ----------------------------------------------------------------------------
-- RLS Policies for Quiz Attempts
-- ----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Students can view own quiz attempts" ON public.quiz_attempts;
DROP POLICY IF EXISTS "Instructors can view attempts for owned course quizzes" ON public.quiz_attempts;
DROP POLICY IF EXISTS "Admins can view all quiz attempts" ON public.quiz_attempts;

-- Students see only their own attempts
CREATE POLICY "Students can view own quiz attempts"
ON public.quiz_attempts
FOR SELECT
TO authenticated
USING (student_id = auth.uid());

-- Instructors see attempts for quizzes in their courses
CREATE POLICY "Instructors can view attempts for owned course quizzes"
ON public.quiz_attempts
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.quizzes q
        JOIN public.courses c ON c.id = q.course_id
        WHERE q.id = quiz_attempts.quiz_id
        AND c.instructor_id = auth.uid()
    )
);

-- Admins full view
CREATE POLICY "Admins can view all quiz attempts"
ON public.quiz_attempts
FOR ALL
TO authenticated
USING (public.is_admin() OR public.is_system_admin())
WITH CHECK (public.is_admin() OR public.is_system_admin());


-- ----------------------------------------------------------------------------
-- Secure RPC: get_student_quiz_questions
-- Returns questions with answer keys STRIPPED for enrolled students taking a quiz
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_student_quiz_questions(p_quiz_id UUID)
RETURNS TABLE (
    id UUID,
    quiz_id UUID,
    question_text TEXT,
    options JSONB,
    marks INTEGER,
    order_index INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
    v_course_id UUID;
    v_is_published BOOLEAN;
    v_is_enrolled BOOLEAN;
    v_is_owner BOOLEAN;
    v_is_adm BOOLEAN;
BEGIN
    IF auth.uid() IS NULL THEN
        RAISE EXCEPTION 'Authentication required' USING ERRCODE = '42501';
    END IF;

    -- Fetch quiz details
    SELECT q.course_id, q.is_published
    INTO v_course_id, v_is_published
    FROM public.quizzes q
    WHERE q.id = p_quiz_id;

    IF v_course_id IS NULL THEN
        RAISE EXCEPTION 'Quiz not found' USING ERRCODE = 'P0002';
    END IF;

    -- Check course ownership or admin
    SELECT EXISTS (
        SELECT 1 FROM public.courses c
        WHERE c.id = v_course_id
        AND c.instructor_id = auth.uid()
    ) INTO v_is_owner;

    v_is_adm := public.is_admin() OR public.is_system_admin();

    -- Check student enrollment
    SELECT EXISTS (
        SELECT 1 FROM public.enrollments e
        WHERE e.course_id = v_course_id
        AND e.student_id = auth.uid()
    ) INTO v_is_enrolled;

    -- Must be published unless owner/admin
    IF NOT v_is_published AND NOT v_is_owner AND NOT v_is_adm THEN
        RAISE EXCEPTION 'Quiz is not published' USING ERRCODE = '42501';
    END IF;

    -- Must be enrolled or owner/admin
    IF NOT v_is_enrolled AND NOT v_is_owner AND NOT v_is_adm THEN
        RAISE EXCEPTION 'Enrollment required to access quiz questions' USING ERRCODE = '42501';
    END IF;

    -- Return questions WITHOUT correct_option_index or explanation
    RETURN QUERY
    SELECT
        qq.id,
        qq.quiz_id,
        qq.question_text,
        qq.options,
        qq.marks,
        qq.order_index
    FROM public.quiz_questions qq
    WHERE qq.quiz_id = p_quiz_id
    ORDER BY qq.order_index ASC, qq.created_at ASC;
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_student_quiz_questions(UUID) TO authenticated;


-- ----------------------------------------------------------------------------
-- Secure RPC: submit_quiz_attempt
-- Evaluates submitted answers on database server and computes score securely
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.submit_quiz_attempt(
    p_quiz_id UUID,
    p_answers JSONB -- Object format: { "<question_id>": selected_index }
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
    v_student_id UUID;
    v_course_id UUID;
    v_is_published BOOLEAN;
    v_is_enrolled BOOLEAN;
    v_question RECORD;
    v_user_selection INTEGER;
    v_is_correct BOOLEAN;
    v_marks_earned INTEGER;
    v_total_score INTEGER := 0;
    v_max_score INTEGER := 0;
    v_percentage NUMERIC(5,2) := 0.00;
    v_review_list JSONB := '[]'::JSONB;
    v_attempt_id UUID;
    v_result JSONB;
BEGIN
    v_student_id := auth.uid();
    IF v_student_id IS NULL THEN
        RAISE EXCEPTION 'Authentication required' USING ERRCODE = '42501';
    END IF;

    -- Verify quiz exists and is published
    SELECT q.course_id, q.is_published
    INTO v_course_id, v_is_published
    FROM public.quizzes q
    WHERE q.id = p_quiz_id;

    IF v_course_id IS NULL THEN
        RAISE EXCEPTION 'Quiz not found' USING ERRCODE = 'P0002';
    END IF;

    IF NOT v_is_published AND NOT (public.is_admin() OR public.is_system_admin()) THEN
        RAISE EXCEPTION 'Cannot take an unpublished quiz' USING ERRCODE = '42501';
    END IF;

    -- Verify student is enrolled
    SELECT EXISTS (
        SELECT 1 FROM public.enrollments e
        WHERE e.course_id = v_course_id
        AND e.student_id = v_student_id
    ) INTO v_is_enrolled;

    IF NOT v_is_enrolled AND NOT (public.is_admin() OR public.is_system_admin()) THEN
        RAISE EXCEPTION 'Student must be enrolled in the course to submit quiz answers' USING ERRCODE = '42501';
    END IF;

    -- Loop through all questions in this quiz
    FOR v_question IN
        SELECT qq.id, qq.question_text, qq.options, qq.correct_option_index, qq.marks, qq.explanation, qq.order_index
        FROM public.quiz_questions qq
        WHERE qq.quiz_id = p_quiz_id
        ORDER BY qq.order_index ASC, qq.created_at ASC
    LOOP
        v_max_score := v_max_score + v_question.marks;

        -- Extract student's submitted answer for this question
        IF p_answers ? (v_question.id::TEXT) THEN
            v_user_selection := (p_answers->>(v_question.id::TEXT))::INTEGER;
        ELSE
            v_user_selection := -1; -- unanswered
        END IF;

        IF v_user_selection = v_question.correct_option_index THEN
            v_is_correct := TRUE;
            v_marks_earned := v_question.marks;
            v_total_score := v_total_score + v_marks_earned;
        ELSE
            v_is_correct := FALSE;
            v_marks_earned := 0;
        END IF;

        -- Build review entry with full transparency now that answers have been committed
        v_review_list := v_review_list || jsonb_build_object(
            'question_id', v_question.id,
            'question_text', v_question.question_text,
            'options', v_question.options,
            'selected_option', v_user_selection,
            'correct_option', v_question.correct_option_index,
            'is_correct', v_is_correct,
            'marks_earned', v_marks_earned,
            'max_marks', v_question.marks,
            'explanation', COALESCE(v_question.explanation, '')
        );
    END LOOP;

    -- Calculate percentage
    IF v_max_score > 0 THEN
        v_percentage := ROUND((v_total_score::NUMERIC / v_max_score::NUMERIC) * 100.0, 2);
    ELSE
        v_percentage := 0.00;
    END IF;

    -- Save attempt record
    INSERT INTO public.quiz_attempts (
        quiz_id,
        student_id,
        score,
        max_score,
        percentage,
        submitted_answers,
        detailed_results
    ) VALUES (
        p_quiz_id,
        v_student_id,
        v_total_score,
        v_max_score,
        v_percentage,
        p_answers,
        v_review_list
    ) RETURNING id INTO v_attempt_id;

    -- Return comprehensive result
    v_result := jsonb_build_object(
        'attempt_id', v_attempt_id,
        'quiz_id', p_quiz_id,
        'student_id', v_student_id,
        'score', v_total_score,
        'max_score', v_max_score,
        'percentage', v_percentage,
        'detailed_results', v_review_list,
        'submitted_at', now()
    );

    RETURN v_result;
END;
$$;

GRANT EXECUTE ON FUNCTION public.submit_quiz_attempt(UUID, JSONB) TO authenticated;
