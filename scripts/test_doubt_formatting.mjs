import { answerLessonDoubt } from '../server/aiService.ts';
import { preprocessMarkdown } from '../src/lib/markdown.ts';

async function testDoubtFormatting() {
  console.log('=== TESTING AI DOUBT ASSISTANT FORMATTING & FALLBACK ===\n');

  const lessonContent = `### Writing Guidelines
1. **Bottom-Line Upfront (BLUF):** State the decision or finding in the very first sentence. Do not bury recommendations at the conclusion of a chronological narrative.
2. **Active Voice and Direct Ownership:**
   - *Weak:* "It was determined that latency degradation was experienced."
   - *Strong:* "The database connection pool saturated, increasing 99th percentile API latency from 45ms to 1,200ms."
3. **Specific Quantified Metrics:** Avoid words like "fast", "scalable", or "large". Use concrete numbers ($p99 < 50\\text{ ms}$, throughput $> 15,000\\text{ RPS}$).

### Latency Budget & Capacity Planning
- Peak target: $p_{99} < 50\\,\\text{ms}$ across all edge endpoints.
- Total system scale:
  $$\\text{Throughput} = 15{,}000\\ \\text{RPS}$$`;

  // Test 1: Technical query matching specific concepts
  console.log('--- TEST 1: Technical Metric Query ---');
  const res1 = await answerLessonDoubt({
    lessonId: 'test-lesson-1',
    lessonTitle: 'Executive Summaries and The Minto Pyramid Principle',
    lessonContent,
    courseTitle: 'Technical Leadership and Engineering Communication',
    courseCategory: 'Professional Skills',
    question: 'What are the specific quantified metrics and throughput requirements?',
    userRole: 'student',
    isEnrolled: true,
  });

  console.log('Success:', res1.success);
  console.log('Source:', res1.source);
  console.log('isFallback:', res1.isFallback);
  console.log('Fallback Notice:', res1.fallbackNotice);
  console.log('Raw Answer:\n', res1.answer);

  // Verify that the answer does not contain butchered fragmented lists (like "- **3**" or severed numbers)
  if (res1.answer.includes('- **3**') || res1.answer.includes('throughput $> 15\n') || res1.answer.includes('\n000\\text{ RPS}$')) {
    console.error('FAIL: Output contains fragmented comma-split lines!');
    process.exit(1);
  } else {
    console.log('PASS: No fragmented comma splits detected.');
  }

  // Preprocess markdown
  const preprocessed = preprocessMarkdown(res1.answer);
  console.log('\nPreprocessed Answer:\n', preprocessed);

  // Test 2: Lesson Overview Query
  console.log('\n--- TEST 2: General Lesson Overview Query ---');
  const res2 = await answerLessonDoubt({
    lessonId: 'test-lesson-1',
    lessonTitle: 'Executive Summaries and The Minto Pyramid Principle',
    lessonContent,
    courseTitle: 'Technical Leadership and Engineering Communication',
    courseCategory: 'Professional Skills',
    question: 'Can you summarize what is covered in this lesson?',
    userRole: 'student',
    isEnrolled: true,
  });

  console.log('Success:', res2.success);
  console.log('Raw Answer:\n', res2.answer);

  if (res2.answer.includes('- **3**') || res2.answer.includes('\n000\\text{ RPS}$')) {
    console.error('FAIL: Overview contains fragmented lines!');
    process.exit(1);
  } else {
    console.log('PASS: Overview formatting is clean and structured.');
  }

  console.log('\nALL DOUBT FORMATTING TESTS PASSED!');
}

testDoubtFormatting().catch((err) => {
  console.error('Test execution failed:', err);
  process.exit(1);
});
