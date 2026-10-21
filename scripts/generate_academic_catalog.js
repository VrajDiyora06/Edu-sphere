// scripts/generate_academic_catalog.js
// Generates idempotent, production-grade SQL seed for EduSphere academic catalog
// Strictly matching live PostgreSQL table schemas.

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Import catalog definitions
import { coursesData } from './catalog_courses.js';

console.log(`Loaded ${coursesData.length} course definitions.`);

let totalLessons = 0;
let totalQuizzes = 0;
let totalQuestions = 0;
let totalAssignments = 0;

coursesData.forEach((c) => {
  totalLessons += c.lessons.length;
  totalQuizzes += c.quizzes.length;
  c.quizzes.forEach((q) => {
    totalQuestions += q.questions.length;
  });
  totalAssignments += c.assignments.length;
});

console.log(`Summary of Catalog Data:
- Courses: ${coursesData.length}
- Lessons: ${totalLessons}
- Quizzes: ${totalQuizzes}
- Quiz Questions: ${totalQuestions}
- Assignments: ${totalAssignments}
`);

// Build SQL helpers
function escapeSql(str) {
  if (str === null || str === undefined) return 'NULL';
  return `'${String(str).replace(/'/g, "''")}'`;
}

function escapeJson(obj) {
  return `'${JSON.stringify(obj).replace(/'/g, "''")}'::jsonb`;
}

// ---------------------------------------------------------------------------
// 1. Unified SQL Seed Construction
// ---------------------------------------------------------------------------
let sql = `-- ============================================================================
-- EduSphere Migration 20261021000010: Comprehensive Academic Catalog Seed
-- ============================================================================
-- Populates 15 full B.Tech level academic courses, 105 lessons, 60 quizzes,
-- 416 questions, and 30 assignments.
--
-- Safety & Idempotency:
-- - Uses fixed deterministic UUIDs and ON CONFLICT DO UPDATE.
-- - Preserves existing course (Distributed Systems Engineering) and all existing
--   user accounts, progress, enrollments, certificates, and submissions.
-- - Reuses genuine verified instructor: Dr. Elena Rostova (c6086584-6cf7-43a4-ae1b-6bd3bb3f7293).
-- - Zero fake users, zero fake reviews, zero RLS weakening.
-- - Strictly conforms to live database column schemas:
--   * public.lessons: NO updated_at
--   * public.quizzes: NO order_index
--   * public.quiz_questions: NO updated_at
-- ============================================================================

DO $$
DECLARE
  v_instructor_id CONSTANT UUID := 'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID;
  v_instructor_role TEXT;
BEGIN
  -- 1. Verify instructor account exists and holds instructor role
  SELECT role INTO v_instructor_role
  FROM public.profiles
  WHERE id = v_instructor_id;

  IF v_instructor_role IS NULL THEN
    RAISE EXCEPTION 'Prerequisite failed: Instructor % was not found in public.profiles.', v_instructor_id;
  END IF;

  IF v_instructor_role NOT IN ('instructor', 'admin', 'system_admin') THEN
    RAISE EXCEPTION 'Prerequisite failed: Account % has role "%", must be instructor.', v_instructor_id, v_instructor_role;
  END IF;

  RAISE NOTICE 'Instructor verification passed for % (Dr. Elena Rostova)', v_instructor_id;
END $$;

BEGIN;

`;

// Courses SQL
sql += `-- ============================================================================\n`;
sql += `-- 1. INSERT / UPSERT COURSES (15 Academic Courses)\n`;
sql += `-- ============================================================================\n\n`;

coursesData.forEach((course) => {
  sql += `INSERT INTO public.courses (
  id,
  title,
  slug,
  description,
  category,
  level,
  thumbnail_url,
  instructor_id,
  is_published,
  created_at,
  updated_at
) VALUES (
  ${escapeSql(course.id)}::UUID,
  ${escapeSql(course.title)},
  ${escapeSql(course.slug)},
  ${escapeSql(course.description)},
  ${escapeSql(course.category)},
  ${escapeSql(course.level)},
  ${escapeSql(course.thumbnail_url)},
  'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  level = EXCLUDED.level,
  thumbnail_url = EXCLUDED.thumbnail_url,
  instructor_id = EXCLUDED.instructor_id,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();\n\n`;
});

// Lessons SQL (Strict schema: NO updated_at)
sql += `-- ============================================================================\n`;
sql += `-- 2. INSERT / UPSERT LESSONS (105 Structured Curriculum Lessons)\n`;
sql += `-- ============================================================================\n\n`;

coursesData.forEach((course) => {
  course.lessons.forEach((lesson) => {
    sql += `INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  ${escapeSql(lesson.id)}::UUID,
  ${escapeSql(course.id)}::UUID,
  ${escapeSql(lesson.title)},
  ${escapeSql(lesson.content)},
  NULL,
  ${lesson.duration_minutes || 45},
  ${lesson.is_free_preview ? 'true' : 'false'},
  ${lesson.order_index || 1},
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;\n\n`;
  });
});

// Quizzes SQL (Strict schema: NO order_index)
sql += `-- ============================================================================\n`;
sql += `-- 3. INSERT / UPSERT QUIZZES (60 Comprehensive Quizzes)\n`;
sql += `-- ============================================================================\n\n`;

coursesData.forEach((course) => {
  course.quizzes.forEach((quiz) => {
    const quizDesc = quiz.description || `${quiz.title} assessment for ${course.title}.`;
    sql += `INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  ${escapeSql(quiz.id)}::UUID,
  ${escapeSql(course.id)}::UUID,
  ${escapeSql(quiz.title)},
  ${escapeSql(quizDesc)},
  ${quiz.time_limit_minutes || 30},
  ${quiz.passing_score || 75},
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();\n\n`;
  });
});

// Quiz Questions SQL (Strict schema: NO updated_at)
sql += `-- ============================================================================\n`;
sql += `-- 4. INSERT / UPSERT QUIZ QUESTIONS (416 MCQ Questions with Explanations)\n`;
sql += `-- ============================================================================\n\n`;

coursesData.forEach((course) => {
  course.quizzes.forEach((quiz) => {
    quiz.questions.forEach((q, i) => {
      sql += `INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  ${escapeSql(q.id)}::UUID,
  ${escapeSql(quiz.id)}::UUID,
  ${escapeSql(q.question_text)},
  ${escapeJson(q.options)},
  ${q.correct_option_index},
  ${q.marks || 1},
  ${escapeSql(q.explanation)},
  ${i + 1},
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;\n\n`;
    });
  });
});

// Assignments SQL
sql += `-- ============================================================================\n`;
sql += `-- 5. INSERT / UPSERT ASSIGNMENTS (30 Project & Theory Assignments)\n`;
sql += `-- ============================================================================\n\n`;

coursesData.forEach((course) => {
  course.assignments.forEach((assignment) => {
    sql += `INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  ${escapeSql(assignment.id)}::UUID,
  ${escapeSql(course.id)}::UUID,
  ${escapeSql(assignment.title)},
  ${escapeSql(assignment.description)},
  NULL,
  NULL,
  ${escapeSql(assignment.due_date)}::TIMESTAMPTZ,
  ${assignment.max_marks || 100},
  ${assignment.allow_resubmission !== false ? 'true' : 'false'},
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();\n\n`;
  });
});

sql += `COMMIT;\n\n`;

sql += `-- ============================================================================\n`;
sql += `-- Verification Summary Query\n`;
sql += `-- ============================================================================\n`;
sql += `SELECT 
  (SELECT count(*) FROM public.courses WHERE is_published = true) AS published_courses_count,
  (SELECT count(*) FROM public.lessons) AS lessons_count,
  (SELECT count(*) FROM public.quizzes WHERE is_published = true) AS published_quizzes_count,
  (SELECT count(*) FROM public.quiz_questions) AS quiz_questions_count,
  (SELECT count(*) FROM public.assignments WHERE is_published = true) AS published_assignments_count;
`;

const migrationPath = path.join(__dirname, '..', 'supabase', 'migrations', '20261021000010_academic_catalog_seed.sql');
const seedPath = path.join(__dirname, '..', 'supabase', 'seed_academic_catalog.sql');

fs.writeFileSync(migrationPath, sql, 'utf8');
fs.writeFileSync(seedPath, sql, 'utf8');

// ---------------------------------------------------------------------------
// 2. Partitioned SQL Files for Browser SQL Editor Convenience
// ---------------------------------------------------------------------------
const partsDir = path.join(__dirname, '..', 'supabase', 'seed_parts');
if (!fs.existsSync(partsDir)) {
  fs.mkdirSync(partsDir, { recursive: true });
}

// Part 1: Courses
let part1Sql = `-- Part 1: Courses (15 Courses)
DO $$
DECLARE
  v_instructor_id CONSTANT UUID := 'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID;
  v_instructor_role TEXT;
BEGIN
  SELECT role INTO v_instructor_role FROM public.profiles WHERE id = v_instructor_id;
  IF v_instructor_role IS NULL THEN
    RAISE EXCEPTION 'Instructor % not found in public.profiles.', v_instructor_id;
  END IF;
END $$;

BEGIN;
`;
coursesData.forEach((course) => {
  part1Sql += `INSERT INTO public.courses (id, title, slug, description, category, level, thumbnail_url, instructor_id, is_published, created_at, updated_at) VALUES (${escapeSql(course.id)}::UUID, ${escapeSql(course.title)}, ${escapeSql(course.slug)}, ${escapeSql(course.description)}, ${escapeSql(course.category)}, ${escapeSql(course.level)}, ${escapeSql(course.thumbnail_url)}, 'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID, true, NOW(), NOW()) ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, category = EXCLUDED.category, level = EXCLUDED.level, thumbnail_url = EXCLUDED.thumbnail_url, instructor_id = EXCLUDED.instructor_id, is_published = EXCLUDED.is_published, updated_at = NOW();\n`;
});
part1Sql += `COMMIT;\n`;
fs.writeFileSync(path.join(partsDir, '01_courses.sql'), part1Sql, 'utf8');

// Part 2: Lessons (Strict schema: NO updated_at)
let part2Sql = `-- Part 2: Lessons (105 Lessons)
BEGIN;
`;
coursesData.forEach((course) => {
  course.lessons.forEach((lesson) => {
    part2Sql += `INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES (${escapeSql(lesson.id)}::UUID, ${escapeSql(course.id)}::UUID, ${escapeSql(lesson.title)}, ${escapeSql(lesson.content)}, NULL, ${lesson.duration_minutes || 45}, ${lesson.is_free_preview ? 'true' : 'false'}, ${lesson.order_index || 1}, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;\n`;
  });
});
part2Sql += `COMMIT;\n`;
fs.writeFileSync(path.join(partsDir, '02_lessons.sql'), part2Sql, 'utf8');

// Part 3: Quizzes and Questions (Strict schema: quizzes has NO order_index; quiz_questions has NO updated_at)
let part3Sql = `-- Part 3: Quizzes (60) & Quiz Questions (416)
BEGIN;
`;
coursesData.forEach((course) => {
  course.quizzes.forEach((quiz) => {
    const quizDesc = quiz.description || `${quiz.title} assessment for ${course.title}.`;
    part3Sql += `INSERT INTO public.quizzes (id, course_id, title, description, time_limit_minutes, passing_score, is_published, created_at, updated_at) VALUES (${escapeSql(quiz.id)}::UUID, ${escapeSql(course.id)}::UUID, ${escapeSql(quiz.title)}, ${escapeSql(quizDesc)}, ${quiz.time_limit_minutes || 30}, ${quiz.passing_score || 75}, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, time_limit_minutes = EXCLUDED.time_limit_minutes, passing_score = EXCLUDED.passing_score, is_published = EXCLUDED.is_published, updated_at = NOW();\n`;
    for (let i = 0; i < quiz.questions.length; i++) {
      const q = quiz.questions[i];
      part3Sql += `INSERT INTO public.quiz_questions (id, quiz_id, question_text, options, correct_option_index, marks, explanation, order_index, created_at) VALUES (${escapeSql(q.id)}::UUID, ${escapeSql(quiz.id)}::UUID, ${escapeSql(q.question_text)}, ${escapeJson(q.options)}, ${q.correct_option_index}, ${q.marks || 1}, ${escapeSql(q.explanation)}, ${i + 1}, NOW()) ON CONFLICT (id) DO UPDATE SET quiz_id = EXCLUDED.quiz_id, question_text = EXCLUDED.question_text, options = EXCLUDED.options, correct_option_index = EXCLUDED.correct_option_index, marks = EXCLUDED.marks, explanation = EXCLUDED.explanation, order_index = EXCLUDED.order_index;\n`;
    }
  });
});
part3Sql += `COMMIT;\n`;
fs.writeFileSync(path.join(partsDir, '03_quizzes_and_questions.sql'), part3Sql, 'utf8');

// Part 4: Assignments
let part4Sql = `-- Part 4: Assignments (30 Assignments)
BEGIN;
`;
coursesData.forEach((course) => {
  course.assignments.forEach((assignment) => {
    part4Sql += `INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES (${escapeSql(assignment.id)}::UUID, ${escapeSql(course.id)}::UUID, ${escapeSql(assignment.title)}, ${escapeSql(assignment.description)}, NULL, NULL, ${escapeSql(assignment.due_date)}::TIMESTAMPTZ, ${assignment.max_marks || 100}, ${assignment.allow_resubmission !== false ? 'true' : 'false'}, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();\n`;
  });
});
part4Sql += `COMMIT;\n`;
fs.writeFileSync(path.join(partsDir, '04_assignments.sql'), part4Sql, 'utf8');

console.log(`Generated migration: ${migrationPath} (${(sql.length / 1024).toFixed(1)} KB)`);
console.log(`Generated seed: ${seedPath}`);
console.log(`Generated partitioned seed files in: ${partsDir}`);
