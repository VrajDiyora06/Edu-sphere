import { createClient } from "@supabase/supabase-js";
const SUPABASE_URL = "https://jllqfirojqpiiinxrwgx.supabase.co";
const ANON_KEY = "sb_publishable_XIm0YasF7ByKciM5O8Ok6Q_AWJZTdtd";
const supabase = createClient(SUPABASE_URL, ANON_KEY);

const PYTHON_COURSE_ID = "d0000000-0000-0000-0000-000000000001";

async function main() {
  const { data: auth, error } = await supabase.auth.signInWithPassword({
    email: "vrajdiyora2@gmail.com",
    password: "12345678",
  });
  if (error) {
    console.log("LOGIN_ERROR:", error.message);
    return;
  }
  console.log("LOGGED_IN:", auth.user.id);

  const studentClient = createClient(SUPABASE_URL, ANON_KEY, {
    global: { headers: { Authorization: "Bearer " + auth.session.access_token } },
  });

  // Check enrollment BEFORE
  const { data: enrBefore } = await studentClient.from("enrollments").select("*").eq("course_id", PYTHON_COURSE_ID);
  console.log("ENR_BEFORE_COUNT:", enrBefore?.length);

  // Enroll in Python course
  const { data: enrollRes, error: enrErr } = await studentClient.rpc("enroll_in_course", { p_course_id: PYTHON_COURSE_ID });
  console.log("ENROLL_RPC:", enrollRes, enrErr);

  // Check enrollment AFTER
  const { data: enrAfter } = await studentClient.from("enrollments").select("*").eq("course_id", PYTHON_COURSE_ID);
  console.log("ENR_AFTER_COUNT:", enrAfter?.length);

  // Lessons AFTER enrollment
  const { data: lAfter, error: lErr } = await studentClient.from("lessons").select("id, title, is_free_preview, duration_minutes").eq("course_id", PYTHON_COURSE_ID).order("order_index");
  console.log("LESSONS_AFTER_COUNT:", lAfter?.length, lErr?.message || "");
  lAfter?.forEach(l => console.log("  LESSON: " + l.title + " (preview: " + l.is_free_preview + ", duration: " + l.duration_minutes + ")"));

  // Quizzes AFTER enrollment
  const { data: qAfter, error: qErr } = await studentClient.from("quizzes").select("id, title, is_published").eq("course_id", PYTHON_COURSE_ID);
  console.log("QUIZZES_AFTER_COUNT:", qAfter?.length, qErr?.message || "");
  qAfter?.forEach(q => console.log("  QUIZ: " + q.title));

  // Assignments AFTER enrollment
  const { data: aAfter, error: aErr } = await studentClient.from("assignments").select("id, title, is_published").eq("course_id", PYTHON_COURSE_ID);
  console.log("ASSIGNMENTS_AFTER_COUNT:", aAfter?.length, aErr?.message || "");
  aAfter?.forEach(a => console.log("  ASSIGNMENT: " + a.title));
}

main().catch(err => console.error("FATAL:", err));
