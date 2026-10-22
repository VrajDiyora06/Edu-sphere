import { answerLessonDoubt, getGeminiApiKey } from '../server/aiService.ts';

async function runComprehensiveProviderTests() {
  console.log('=== EDUSPHERE AI PROVIDER & DOUBT ASSISTANT VERIFICATION ===\n');

  const apiKey = getGeminiApiKey();
  console.log('Server GEMINI_API_KEY detected:', Boolean(apiKey));
  if (!apiKey) {
    console.error('FAIL: No API key detected on server');
    process.exit(1);
  }

  // TEST 1: Real Live Gemini Provider Question
  console.log('--- TEST 1: Real AI Question via answerLessonDoubt ---');
  const res1 = await answerLessonDoubt({
    lessonId: 'd0000000-0000-0000-0101-000000000001',
    lessonTitle: 'The Raft Consensus Protocol in Depth',
    lessonContent: 'Raft manages replicated logs via leader election, log replication, and safety guarantees. Leaders use AppendEntries RPCs and require majority quorum (N/2 + 1) to commit entries.',
    courseTitle: 'Distributed Systems Engineering',
    courseCategory: 'Computer Science',
    question: 'How does Raft prevent split-brain scenarios during network partitions?',
    userRole: 'student',
    isEnrolled: true,
  });

  console.log('Success:', res1.success);
  console.log('Source:', res1.source);
  console.log('Model:', res1.model);
  console.log('isFallback:', res1.isFallback);
  console.log('Fallback Notice:', res1.fallbackNotice || 'None (Live Provider Active)');
  console.log('\n--- ANSWER PREVIEW ---');
  console.log(res1.answer?.slice(0, 300) + '...\n');

  if (res1.source !== 'ai_provider' || res1.isFallback !== false) {
    console.error('FAIL: Expected real provider answer but received fallback!');
    console.error('Fallback Notice:', res1.fallbackNotice);
    process.exit(1);
  }
  console.log('✓ PASS: Real provider response verified successfully!');

  // TEST 2: Fallback with invalid key
  console.log('\n--- TEST 2: Verification of Honest Error Handling with Invalid Key ---');
  const origKey = process.env.GEMINI_API_KEY;
  process.env.GEMINI_API_KEY = 'invalid_dummy_key_for_testing';

  const res2 = await answerLessonDoubt({
    lessonId: 'd0000000-0000-0000-0101-000000000001',
    lessonTitle: 'The Raft Consensus Protocol in Depth',
    lessonContent: 'Raft manages replicated logs via leader election, log replication, and safety guarantees.',
    courseTitle: 'Distributed Systems Engineering',
    courseCategory: 'Computer Science',
    question: 'What is a quorum in Raft?',
    userRole: 'student',
    isEnrolled: true,
  });

  console.log('Success:', res2.success);
  console.log('Source:', res2.source);
  console.log('isFallback:', res2.isFallback);
  console.log('Fallback Notice:', res2.fallbackNotice);

  if (res2.source !== 'fallback' || !res2.isFallback || !res2.fallbackNotice?.includes('authentication')) {
    console.error('FAIL: Expected honest authentication fallback notice!');
    process.exit(1);
  }
  console.log('✓ PASS: Honest authentication fallback notice verified!');

  // Restore key
  process.env.GEMINI_API_KEY = origKey;

  console.log('\nALL PROVIDER TESTS COMPLETED SUCCESSFULLY!');
}

runComprehensiveProviderTests().catch((err) => {
  console.error('Test failed:', err);
  process.exit(1);
});
