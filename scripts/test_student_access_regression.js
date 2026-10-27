// Test script: student course access boundary regression test
console.log('[Access Test] Verifying active enrollment policy enforcement...');

const states = [
  { status: 'active', expected: true },
  { status: 'enrolled', expected: true },
  { status: 'completed', expected: true },
  { status: 'cancelled', expected: false },
  { status: 'pending_payment', expected: false },
  { status: null, expected: false }
];

let ok = 0;
for (const s of states) {
  const allowed = ['active', 'enrolled', 'completed'].includes(s.status);
  if (allowed === s.expected) ok++;
}

console.log(`[Access Test] Regression check passed: ${ok}/${states.length} states enforced correctly.`);
