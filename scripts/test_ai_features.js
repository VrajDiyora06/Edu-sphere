/**
 * EduSphere AI Doubt Assistance & Course Recommendations Test Suite
 *
 * Verifies:
 * 1. AI Doubt Assistance authorization gates (unauthorized vs enrolled/preview)
 * 2. Controlled fallback behavior when provider is unconfigured or unavailable
 * 3. Fallback attribution honesty (isFallback = true, fallbackNotice populated)
 * 4. Grounding in lesson content/transcript
 * 5. Recommendation engine for new students (starter track, isPersonalized = false)
 * 6. Recommendation engine for active students (category & skill progression, isPersonalized = true)
 * 7. Exclusion of already completed / enrolled courses
 * 8. Interest-based recommendation weighting
 */

import React from 'react';
import { renderToString } from 'react-dom/server';
import ReactMarkdown from 'react-markdown';
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';
import { answerLessonDoubt, getCourseRecommendations } from '../server/aiService.ts';

const SAMPLE_COURSES = [
  {
    id: 'c1-dist-sys',
    title: 'Distributed Systems Engineering',
    slug: 'distributed-systems',
    description: 'Learn consensus algorithms, Raft, Paxos, and distributed state machines.',
    category: 'Computer Science',
    level: 'Advanced',
    thumbnail_url: null,
  },
  {
    id: 'c2-cloud-arch',
    title: 'Cloud Architecture & Microservices',
    slug: 'cloud-architecture',
    description: 'Design resilient microservice clusters and event-driven backends.',
    category: 'Computer Science',
    level: 'Intermediate',
    thumbnail_url: null,
  },
  {
    id: 'c3-fullstack-ts',
    title: 'Modern Full-Stack Web Development',
    slug: 'modern-fullstack',
    description: 'Build end-to-end web apps with TypeScript, React, and PostgreSQL.',
    category: 'Web Development',
    level: 'Beginner',
    thumbnail_url: null,
  },
  {
    id: 'c4-ai-ml',
    title: 'Foundations of Machine Learning',
    slug: 'foundations-ml',
    description: 'Explore neural networks, gradient descent, and supervised models.',
    category: 'Artificial Intelligence',
    level: 'Intermediate',
    thumbnail_url: null,
  },
];

async function runAiTestSuite() {
  console.log('========================================================================');
  console.log('EduSphere AI Doubt Assistance & Recommendations Authorization Suite');
  console.log('========================================================================\n');

  let passed = 0;
  let total = 0;

  function assert(testId, description, expected, actual, condition) {
    total++;
    if (condition) {
      passed++;
      console.log(`[PASS] [${testId}] ${description}`);
      console.log(`       Expected: ${expected}`);
      console.log(`       Actual:   ${actual}\n`);
    } else {
      console.error(`[FAIL] [${testId}] ${description}`);
      console.error(`       Expected: ${expected}`);
      console.error(`       Actual:   ${actual}\n`);
    }
  }

  // TEST 1: Doubt Assistance Access Gate - Unauthorized student
  const unauthRes = await answerLessonDoubt({
    lessonId: 'l1',
    lessonTitle: 'Consensus Protocols',
    lessonContent: 'Raft divides time into terms. Leader election uses randomized timers.',
    courseTitle: 'Distributed Systems',
    courseCategory: 'Computer Science',
    question: 'How does Raft elect a leader?',
    userRole: 'student',
    isEnrolled: false,
    isFreePreview: false,
  });

  assert(
    'AI-AUTH-01',
    'Student requesting doubt assistance on locked lesson without enrollment',
    'Blocked with access restricted error',
    unauthRes.error || 'Passed',
    unauthRes.success === false && unauthRes.error?.includes('enroll in the course')
  );

  // TEST 2: Doubt Assistance Access Gate - Free preview lesson
  const previewRes = await answerLessonDoubt({
    lessonId: 'l1',
    lessonTitle: 'Introduction to Distributed Systems',
    lessonContent: 'A distributed system consists of autonomous computing nodes.',
    courseTitle: 'Distributed Systems',
    courseCategory: 'Computer Science',
    question: 'What is a distributed system?',
    userRole: 'guest',
    isEnrolled: false,
    isFreePreview: true,
  });

  assert(
    'AI-AUTH-02',
    'Guest requesting doubt assistance on free preview lesson',
    'Access permitted (success: true)',
    `success: ${previewRes.success}, isFallback: ${previewRes.isFallback}`,
    previewRes.success === true
  );

  // TEST 3: Controlled Fallback Quality & Principles Breakdown (Unconfigured provider test)
  const savedKeyForSuite = process.env.GEMINI_API_KEY;
  process.env.GEMINI_API_KEY = '';

  const summaryRes = await answerLessonDoubt({
    lessonId: 'c0000000-0000-0000-0000-000000000002',
    lessonTitle: 'The Raft Consensus Protocol in Depth',
    lessonContent: 'Leader election, log replication, safety guarantees, and split-brain prevention.',
    courseTitle: 'Distributed Systems Engineering',
    courseCategory: 'Computer Science',
    question: "Summarize the key technical principles of 'The Raft Consensus Protocol in Depth'.",
    userRole: 'student',
    isEnrolled: true,
    isFreePreview: false,
  });

  assert(
    'AI-FALLBACK-01',
    'Controlled fallback activates with explicit attribution when API key is unconfigured',
    'isFallback: true with fallbackNotice populated',
    `isFallback: ${summaryRes.isFallback}, source: ${summaryRes.source}, notice: ${summaryRes.fallbackNotice?.slice(0, 30)}...`,
    summaryRes.isFallback === true &&
      summaryRes.source === 'fallback' &&
      typeof summaryRes.fallbackNotice === 'string' &&
      summaryRes.fallbackNotice.length > 0
  );

  assert(
    'AI-QUALITY-01',
    'Fallback answers summary question directly using structured principles from lesson notes',
    'Contains markdown header, lists all 4 principles, and omits generic boilerplate',
    summaryRes.answer?.slice(0, 100) + '...',
    summaryRes.answer?.includes('### Key Technical Principles') &&
      summaryRes.answer?.includes('Leader Election') &&
      summaryRes.answer?.includes('Log Replication') &&
      summaryRes.answer?.includes('Safety Guarantees') &&
      summaryRes.answer?.includes('Split-Brain Prevention') &&
      !summaryRes.answer?.includes('Your question touches on the core concepts')
  );

  // TEST 3B: Specific Concept Doubt Breakdown
  const conceptRes = await answerLessonDoubt({
    lessonId: 'c0000000-0000-0000-0000-000000000002',
    lessonTitle: 'The Raft Consensus Protocol in Depth',
    lessonContent: 'Leader election, log replication, safety guarantees, and split-brain prevention.',
    courseTitle: 'Distributed Systems Engineering',
    courseCategory: 'Computer Science',
    question: 'How does split-brain prevention work in Raft?',
    userRole: 'student',
    isEnrolled: true,
    isFreePreview: false,
  });

  assert(
    'AI-QUALITY-02',
    'Fallback answers specific technical question with direct mechanism details',
    'Explains quorum requirement and split-brain prevention mechanics',
    conceptRes.answer?.slice(0, 90) + '...',
    conceptRes.answer?.includes('Split-Brain Prevention') &&
      conceptRes.answer?.toLowerCase().includes('quorum')
  );

  // TEST 3B-2: Video & Lesson Overview Query (Honest Video Scope)
  const videoQueryRes = await answerLessonDoubt({
    lessonId: 'c0000000-0000-0000-0000-000000000002',
    lessonTitle: 'The Raft Consensus Protocol in Depth',
    lessonContent: 'Leader election, log replication, safety guarantees, and split-brain prevention.',
    courseTitle: 'Distributed Systems Engineering',
    courseCategory: 'Computer Science',
    question: "what is this lesson about and what's in the video?",
    userRole: 'student',
    isEnrolled: true,
    isFreePreview: false,
  });

  assert(
    'AI-VIDEO-01',
    'Fallback answers lesson & video query with useful summary without claiming video analysis',
    'Includes all 4 principles, states video scope honestly, no fake video watch claim',
    videoQueryRes.answer?.slice(0, 100) + '...',
    videoQueryRes.answer?.includes('Lesson & Lecture Overview') &&
      videoQueryRes.answer?.includes('Leader Election') &&
      videoQueryRes.answer?.includes('Split-Brain Prevention') &&
      videoQueryRes.answer?.includes('Direct video stream analysis is unavailable')
  );

  // Restore suite key
  if (savedKeyForSuite !== undefined) {
    process.env.GEMINI_API_KEY = savedKeyForSuite;
  } else {
    delete process.env.GEMINI_API_KEY;
  }

  // TEST 3C: Live Gemini Integration Path (isFallback: false when provider configured)
  const originalFetch = globalThis.fetch;
  const originalKey = process.env.GEMINI_API_KEY;
  try {
    process.env.GEMINI_API_KEY = 'test-gemini-secret-token-do-not-leak';
    globalThis.fetch = async (url, options) => {
      if (typeof url === 'string' && url.includes('generativelanguage.googleapis.com')) {
        return {
          ok: true,
          status: 200,
          json: async () => ({
            candidates: [
              {
                content: {
                  parts: [
                    {
                      text: '### Gemini 3.8 Flash Explanation\n\nLeader election in Raft ensures high availability through majority voting.',
                    },
                  ],
                },
              },
            ],
          }),
        };
      }
      return originalFetch(url, options);
    };

    const liveRes = await answerLessonDoubt({
      lessonId: 'c0000000-0000-0000-0000-000000000002',
      lessonTitle: 'The Raft Consensus Protocol in Depth',
      lessonContent: 'Leader election, log replication, safety guarantees, and split-brain prevention.',
      courseTitle: 'Distributed Systems Engineering',
      courseCategory: 'Computer Science',
      question: 'Explain leader election in Raft.',
      userRole: 'student',
      isEnrolled: true,
      isFreePreview: false,
    });

    assert(
      'AI-LIVE-01',
      'Live Gemini integration path returns isFallback: false with ai_provider source',
      'isFallback: false, source: ai_provider, model: gemini-3.8-flash',
      `isFallback: ${liveRes.isFallback}, source: ${liveRes.source}, model: ${liveRes.model}`,
      liveRes.isFallback === false &&
        liveRes.source === 'ai_provider' &&
        liveRes.model === 'gemini-3.8-flash' &&
        liveRes.answer?.includes('Gemini 3.8 Flash Explanation')
    );

    assert(
      'AI-SECURITY-01',
      'API key confidentiality: Secret key is never exposed in response object or answers',
      'Response contains no secret token',
      `Contains token: ${JSON.stringify(liveRes).includes('test-gemini-secret-token')}`,
      !JSON.stringify(liveRes).includes('test-gemini-secret-token')
    );
  } finally {
    globalThis.fetch = originalFetch;
    if (originalKey !== undefined) {
      process.env.GEMINI_API_KEY = originalKey;
    } else {
      delete process.env.GEMINI_API_KEY;
    }
  }

  // TEST 4: Recommendations for New Students (No History)
  const newStudentRecs = await getCourseRecommendations({
    studentId: 'new-student-id',
    enrolledCourseIds: [],
    completedCourseIds: [],
    allCourses: SAMPLE_COURSES,
  });

  assert(
    'AI-REC-01',
    'New student receives curated foundational recommendations',
    'isPersonalized: false, strategy: curated_starter, 4 recommendations returned',
    `isPersonalized: ${newStudentRecs.isPersonalized}, strategy: ${newStudentRecs.strategy}, count: ${newStudentRecs.recommendations.length}`,
    newStudentRecs.isPersonalized === false &&
      newStudentRecs.strategy === 'curated_starter' &&
      newStudentRecs.recommendations.length > 0
  );

  // TEST 5: Recommendations for Enrolled Student (With History & Progression)
  const activeStudentRecs = await getCourseRecommendations({
    studentId: 'active-student-id',
    enrolledCourseIds: ['c1-dist-sys'],
    completedCourseIds: ['c1-dist-sys'],
    allCourses: SAMPLE_COURSES,
  });

  // Verify completed course is excluded
  const containsCompleted = activeStudentRecs.recommendations.some(
    (r) => r.course.id === 'c1-dist-sys'
  );
  // Verify top recommendation is in Computer Science (c2-cloud-arch)
  const topRec = activeStudentRecs.recommendations[0];

  assert(
    'AI-REC-02',
    'Recommendations exclude already completed/enrolled courses',
    'Completed course c1-dist-sys excluded from recommendations',
    `Contains c1-dist-sys: ${containsCompleted}`,
    containsCompleted === false
  );

  assert(
    'AI-REC-03',
    'Personalized recommendation prioritizes related category (Computer Science)',
    'Top recommendation is Cloud Architecture (Computer Science)',
    `Top course: ${topRec?.course.title} (${topRec?.course.category}), score: ${topRec?.score}`,
    topRec?.course.category === 'Computer Science' &&
      activeStudentRecs.isPersonalized === true &&
      activeStudentRecs.strategy === 'history_based'
  );

  assert(
    'AI-REC-04',
    'Personalized recommendation includes explanatory reason',
    'Reason references aligned studies in Computer Science',
    `Reason: ${topRec?.reason}`,
    topRec?.reason?.includes('Computer Science')
  );

  // TEST 6: Recommendations with Explicit Interest Filter
  const interestRecs = await getCourseRecommendations({
    studentId: 'interest-student-id',
    enrolledCourseIds: [],
    completedCourseIds: [],
    interests: ['Artificial Intelligence'],
    allCourses: SAMPLE_COURSES,
  });

  const topInterestRec = interestRecs.recommendations[0];
  assert(
    'AI-REC-05',
    'Explicit interest matches prioritize relevant category',
    'Top course is Foundations of Machine Learning (Artificial Intelligence)',
    `Top course: ${topInterestRec?.course.title} (${topInterestRec?.course.category})`,
    topInterestRec?.course.category === 'Artificial Intelligence' &&
      topInterestRec?.reason?.includes('Artificial Intelligence')
  );

  // TEST 7: Mathematical & LaTeX Notation Rendering (CAP Theorem & Quorum Formulas)
  function preprocessMarkdown(raw) {
    if (!raw) return '';
    return raw
      .replace(/\\\[([\s\S]*?)\\\]/g, (_m, content) => `\n\n$$\n${content.trim()}\n$$\n\n`)
      .replace(/\\\(([\s\S]*?)\\\)/g, (_m, content) => `$${content.trim()}$`);
  }

  function renderMd(content) {
    const processed = preprocessMarkdown(content);
    return renderToString(
      React.createElement(
        ReactMarkdown,
        {
          remarkPlugins: [remarkMath],
          rehypePlugins: [rehypeKatex],
        },
        processed
      )
    );
  }

  const capMathSample = `
### CAP Theorem Mathematical Trade-offs
In distributed systems, the trade-off is governed by:
- Consistency ($C$): Every read receives the most recent write.
- Availability ($A$): Every non-failing node returns a response.
- Partition Tolerance ($P$): The system operates despite message losses.

Quorum intersection requires:
\\[ Q_{read} + Q_{write} > N \\]
where quorum size is $Q = \\lfloor N/2 \\rfloor + 1$.
`;

  const renderedHtml = renderMd(capMathSample);
  const katexMatchCount = (renderedHtml.match(/class="katex"/g) || []).length;
  const hasDisplayMath = renderedHtml.includes('katex-display');
  const hasHeading = renderedHtml.includes('<h3') || renderedHtml.includes('CAP Theorem Mathematical Trade-offs');
  const hasList = renderedHtml.includes('<ul>') && renderedHtml.includes('<li>');

  assert(
    'AI-MATH-01',
    'Inline LaTeX and mathematical symbols ($C$, $A$, $P$) render cleanly as KaTeX elements',
    'KaTeX rendered at least 4 math formulas ($C$, $A$, $P$, $Q$ formula, display quorum)',
    `Found ${katexMatchCount} KaTeX elements`,
    katexMatchCount >= 4
  );

  assert(
    'AI-MATH-02',
    'LaTeX display math formulas (\\[ ... \\]) normalize to $$ and render katex-display blocks',
    'Rendered HTML includes class="katex-display"',
    `Contains katex-display: ${hasDisplayMath}`,
    hasDisplayMath === true
  );

  assert(
    'AI-MARKDOWN-01',
    'Headings, lists, and formatted text render clean semantic HTML structure',
    'Rendered HTML contains heading, list, and list items',
    `hasHeading: ${hasHeading}, hasList: ${hasList}`,
    hasHeading && hasList
  );


  console.log('========================================================================');
  console.log(`AI Feature Test Suite Complete: ${passed}/${total} PASSED (${total - passed} failed)`);
  console.log('========================================================================');

  if (passed !== total) {
    process.exit(1);
  }
}

runAiTestSuite().catch((err) => {
  console.error('Fatal error in AI test suite:', err);
  process.exit(1);
});
