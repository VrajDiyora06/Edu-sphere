import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = 'https://jllqfirojqpiiinxrwgx.supabase.co';
const ANON_KEY = 'sb_publishable_XIm0YasF7ByKciM5O8Ok6Q_AWJZTdtd';
const supabase = createClient(SUPABASE_URL, ANON_KEY);

async function check() {
  console.log('=== Checking Enrollments & Roles ===');
  // Check public profiles
  const { data: profiles } = await supabase.from('public_profiles').select('*');
  console.log('Profiles:', profiles);

  // Check courses
  const { data: courses } = await supabase.from('courses').select('id, title, slug, instructor_id');
  console.log('Courses count:', courses?.length);
  courses?.forEach(c => console.log(`  - ${c.id}: ${c.title} (slug: ${c.slug})`));
}

check().catch(console.error);
