import fs from 'fs';

const SCHEMAS = {
  courses: [
    'id', 'title', 'slug', 'description', 'category', 'level',
    'thumbnail_url', 'instructor_id', 'is_published', 'created_at', 'updated_at'
  ],
  lessons: [
    'id', 'course_id', 'title', 'content', 'video_url',
    'duration_minutes', 'is_free_preview', 'order_index', 'created_at'
  ],
  quizzes: [
    'id', 'course_id', 'title', 'description', 'time_limit_minutes',
    'passing_score', 'is_published', 'created_at', 'updated_at'
  ],
  quiz_questions: [
    'id', 'quiz_id', 'question_text', 'options', 'correct_option_index',
    'marks', 'explanation', 'order_index', 'created_at'
  ],
  assignments: [
    'id', 'course_id', 'title', 'description', 'instructions_file_path',
    'instructions_file_name', 'due_date', 'max_marks', 'allow_resubmission',
    'is_published', 'created_at', 'updated_at'
  ]
};

function validateSqlFile(filePath) {
  console.log(`\nValidating ${filePath}...`);
  if (!fs.existsSync(filePath)) {
    console.error(`File ${filePath} does not exist!`);
    return false;
  }

  const content = fs.readFileSync(filePath, 'utf-8');

  // Regex to match: INSERT INTO public.<table> (<cols>) VALUES ... [ON CONFLICT ... DO UPDATE SET <updates>]
  const insertRegex = /INSERT\s+INTO\s+public\.([a-z_]+)\s*\(([^)]+)\)\s*VALUES/gi;
  let match;
  let count = 0;
  let errors = 0;

  while ((match = insertRegex.exec(content)) !== null) {
    count++;
    const table = match[1].toLowerCase();
    const cols = match[2].split(',').map(c => c.trim().replace(/[\r\n\t]+/g, ''));

    const expected = SCHEMAS[table];
    if (!expected) {
      console.error(`Statement ${count}: Unknown table "${table}"`);
      errors++;
      continue;
    }

    for (const col of cols) {
      if (!expected.includes(col)) {
        console.error(`Statement ${count} (table ${table}): Column "${col}" does not exist in schema!`);
        errors++;
      }
    }
  }

  // Check ON CONFLICT clauses
  const conflictRegex = /ON\s+CONFLICT[^(]*\([^)]+\)\s*DO\s+UPDATE\s+SET\s+([^;]+);/gi;
  let conflictMatch;
  let conflictCount = 0;
  while ((conflictMatch = conflictRegex.exec(content)) !== null) {
    conflictCount++;
    const setClause = conflictMatch[1];
    const assignments = setClause.split(',').map(a => a.trim());
    for (const assign of assignments) {
      const m = assign.match(/^([a-z_]+)\s*=/i);
      if (m) {
        const col = m[1].toLowerCase();
        // Check if this column belongs to any table that doesn't have it
        // Specifically check if 'updated_at' appears in a table that lacks it (e.g. lessons or quiz_questions)
        const precedingText = content.substring(Math.max(0, conflictMatch.index - 500), conflictMatch.index);
        let table = 'unknown';
        if (precedingText.includes('public.lessons')) table = 'lessons';
        else if (precedingText.includes('public.quizzes')) table = 'quizzes';
        else if (precedingText.includes('public.quiz_questions')) table = 'quiz_questions';
        else if (precedingText.includes('public.assignments')) table = 'assignments';
        else if (precedingText.includes('public.courses')) table = 'courses';

        if (table !== 'unknown' && SCHEMAS[table] && !SCHEMAS[table].includes(col)) {
          console.error(`Conflict SET ${conflictCount} on ${table}: Column "${col}" does not exist in ${table}!`);
          errors++;
        }
      }
    }
  }

  console.log(`Inspected ${count} INSERT statements & ${conflictCount} ON CONFLICT clauses. Errors: ${errors}`);
  return errors === 0;
}

const files = [
  'supabase/seed_parts/01_courses.sql',
  'supabase/seed_parts/02_lessons.sql',
  'supabase/seed_parts/03_quizzes_and_questions.sql',
  'supabase/seed_parts/04_assignments.sql',
  'supabase/seed_academic_catalog.sql',
  'supabase/migrations/20261021000010_academic_catalog_seed.sql'
];

let allValid = true;
for (const f of files) {
  const ok = validateSqlFile(f);
  if (!ok) allValid = false;
}

if (allValid) {
  console.log('\n>>> SUCCESS: All SQL files are 100% compliant with PostgreSQL schema! <<<');
} else {
  console.log('\n>>> FAILURE: Review errors above! <<<');
  process.exit(1);
}
