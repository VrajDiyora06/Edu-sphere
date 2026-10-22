import { createClient } from '@supabase/supabase-js';
const SUPABASE_URL = 'https://jllqfirojqpiiinxrwgx.supabase.co';
const ANON_KEY = 'sb_publishable_XIm0YasF7ByKciM5O8Ok6Q_AWJZTdtd';
const supabase = createClient(SUPABASE_URL, ANON_KEY);

async function checkSchema() {
  const { data: adminAuth } = await supabase.auth.signInWithPassword({
    email: 'diyoravraj@gmail.com',
    password: '12345678',
  });
  const adminClient = createClient(SUPABASE_URL, ANON_KEY, {
    global: { headers: { Authorization: 'Bearer ' + adminAuth.session.access_token } }
  });

  const { data: rpcDiag, error: diagErr } = await adminClient.rpc('get_system_rbac_diagnostics');
  console.log('RBAC Diag:', rpcDiag, diagErr);

  // Check public_profiles view
  const { data: viewP } = await adminClient.from('public_profiles').select('*').limit(1);
  console.log('public_profiles view works:', !!viewP);
}
checkSchema().catch(console.error);
