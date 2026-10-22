import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = 'https://jllqfirojqpiiinxrwgx.supabase.co';
const ANON_KEY = 'sb_publishable_XIm0YasF7ByKciM5O8Ok6Q_AWJZTdtd';
const supabase = createClient(SUPABASE_URL, ANON_KEY);

async function test() {
  const { data, error } = await supabase.rpc('run_edusphere_access_control_tests');
  console.log('run_edusphere_access_control_tests:', data, error);
}

test().catch(console.error);
