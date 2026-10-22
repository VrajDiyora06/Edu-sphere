import { createClient } from "@supabase/supabase-js";
const SUPABASE_URL = "https://jllqfirojqpiiinxrwgx.supabase.co";
const ANON_KEY = "sb_publishable_XIm0YasF7ByKciM5O8Ok6Q_AWJZTdtd";
const supabase = createClient(SUPABASE_URL, ANON_KEY);

async function main() {
  const { data: course, error } = await supabase.from("courses").select("*").eq("id", "d0000000-0000-0000-0000-000000000001").single();
  console.log("Course keys:", Object.keys(course || {}));
  console.log("Course row:", course);
}
main().catch(console.error);
