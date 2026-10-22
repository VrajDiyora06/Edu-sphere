import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = 'https://jllqfirojqpiiinxrwgx.supabase.co';
const ANON_KEY = 'sb_publishable_XIm0YasF7ByKciM5O8Ok6Q_AWJZTdtd';
const supabase = createClient(SUPABASE_URL, ANON_KEY);

const email = 'diyoravraj@gmail.com';
const passwords = ['Password123!', 'Admin123!', 'Vraj123!', '12345678', 'TestPassword123!', 'edusphere123', 'admin@123'];

async function main() {
  for (const p of passwords) {
    const { data, error } = await supabase.auth.signInWithPassword({ email, password: p });
    if (!error && data.session) {
      console.log('SUCCESS with password:', p);
      return;
    } else {
      console.log('Failed', p, ':', error?.message);
    }
  }
}

main().catch(console.error);
