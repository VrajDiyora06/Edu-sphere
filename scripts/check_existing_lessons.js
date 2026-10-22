import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = 'https://jllqfirojqpiiinxrwgx.supabase.co';
const ANON_KEY = 'sb_publishable_XIm0YasF7ByKciM5O8Ok6Q_AWJZTdtd';
const supabase = createClient(SUPABASE_URL, ANON_KEY);

async function checkLessons() {
  const { data: lessons, error } = await supabase
    .from('lessons')
    .select('id, course_id, title, is_free_preview, order_index, created_at')
    .order('order_index');

  console.log('Error:', error);
  console.log('Total lessons returned:', lessons?.length);
  lessons?.forEach((l, i) => {
    console.log(`${i+1}. [${l.id}] (Course: ${l.course_id}) "${l.title}" - free: ${l.is_free_preview}, order: ${l.order_index}, created: ${l.created_at}`);
  });
}

checkLessons().catch(console.error);
