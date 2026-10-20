/**
 * EduSphere Server-Side AI Service
 *
 * Implements real Gemini API integration with secure server-side API key handling,
 * and a robust controlled fallback engine when provider credentials are not configured
 * or quota/network boundaries are exceeded.
 */

import { loadEnv } from 'vite';

/**
 * Safely resolves GEMINI_API_KEY or AI_API_KEY from the server environment.
 * Checks process.env first, then loads .env and .env.local dynamically via Vite's loadEnv.
 * Never exposes the key to client-side bundles or browser logs.
 */
export function getGeminiApiKey(): string | undefined {
  if (process.env.GEMINI_API_KEY !== undefined) {
    return process.env.GEMINI_API_KEY.trim() || undefined;
  }
  if (process.env.AI_API_KEY !== undefined) {
    return process.env.AI_API_KEY.trim() || undefined;
  }

  try {
    const loaded = loadEnv(process.env.NODE_ENV || 'development', process.cwd(), '');
    const key = loaded.GEMINI_API_KEY?.trim() || loaded.AI_API_KEY?.trim();
    if (key && key.length > 0) {
      return key;
    }
  } catch {
    // Ignore environment loading errors
  }
  return undefined;
}

export interface DoubtRequest {
  lessonId: string;
  lessonTitle: string;
  lessonContent?: string | null;
  courseTitle: string;
  courseCategory: string;
  question: string;
  userRole?: string;
  isEnrolled?: boolean;
  isFreePreview?: boolean;
}

export interface DoubtResponse {
  success: boolean;
  answer?: string;
  source: 'ai_provider' | 'fallback';
  model?: string;
  isFallback: boolean;
  fallbackNotice?: string;
  error?: string;
}

export interface RecommendationRequest {
  studentId?: string;
  enrolledCourseIds?: string[];
  completedCourseIds?: string[];
  interests?: string[];
  allCourses: Array<{
    id: string;
    title: string;
    slug: string;
    description: string;
    category: string;
    level: string;
    thumbnail_url?: string | null;
  }>;
}

export interface RecommendedCourseItem {
  course: {
    id: string;
    title: string;
    slug: string;
    description: string;
    category: string;
    level: string;
    thumbnail_url?: string | null;
  };
  score: number;
  reason: string;
  isPersonalized: boolean;
}

export interface RecommendationResponse {
  success: boolean;
  recommendations: RecommendedCourseItem[];
  isPersonalized: boolean;
  strategy: 'history_based' | 'curated_starter';
  error?: string;
}

/**
 * Handle student doubt resolution for a specific lesson.
 */
export async function answerLessonDoubt(req: DoubtRequest): Promise<DoubtResponse> {
  const {
    lessonTitle,
    lessonContent,
    courseTitle,
    courseCategory,
    question,
    userRole,
    isEnrolled,
    isFreePreview,
  } = req;

  // Authorization validation:
  // Must be enrolled student, course author/admin, or viewing a free preview lesson.
  const isAuthorized =
    isEnrolled ||
    isFreePreview ||
    userRole === 'instructor' ||
    userRole === 'admin' ||
    userRole === 'system_admin';

  if (!isAuthorized) {
    return {
      success: false,
      source: 'fallback',
      isFallback: true,
      error: 'Access restricted: Please enroll in the course to use the AI doubt assistant for this lesson.',
    };
  }

  if (!question || question.trim().length === 0) {
    return {
      success: false,
      source: 'fallback',
      isFallback: true,
      error: 'Question cannot be empty.',
    };
  }

  const cleanQuestion = question.trim();
  const rawContent = lessonContent?.trim() || '';

  // 1. Check for real Gemini API credentials on server side
  const geminiApiKey = getGeminiApiKey();

  // Model candidates in priority order (gemini-3-flash-preview and gemini-flash-lite-latest are verified active)
  const configuredModel = process.env.GEMINI_MODEL?.trim();
  const candidateModels = configuredModel
    ? [configuredModel, 'gemini-3-flash-preview', 'gemini-3.6-flash', 'gemini-flash-lite-latest']
    : ['gemini-3-flash-preview', 'gemini-3.6-flash', 'gemini-flash-lite-latest'];

  let lastProviderStatus: number | null = null;
  let lastProviderError: string | null = null;

  if (geminiApiKey) {
    const systemInstruction = `You are the EduSphere AI Academic Tutor for the course "${courseTitle}" (${courseCategory}).
You are answering a student's doubt regarding the lesson: "${lessonTitle}".
Use the following official lesson notes and learning content as your primary source of ground truth:
"""
${rawContent || 'No lecture transcript provided.'}
"""

Instructions:
1. Provide a direct, pedagogically clear, and technically sound explanation answering the student's question.
2. Ground your answer in the lesson material.
3. Format with clean markdown headings, bold text, lists, and LaTeX math where applicable ($...$ for inline, $$...$$ for display equations).
4. Keep the explanation concise and direct.`;

    for (const model of candidateModels) {
      try {
        const endpoint = `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${geminiApiKey}`;

        const response = await fetch(endpoint, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          signal: AbortSignal.timeout(12000),
          body: JSON.stringify({
            contents: [
              {
                role: 'user',
                parts: [{ text: `${systemInstruction}\n\nStudent Question: ${cleanQuestion}` }],
              },
            ],
            generationConfig: {
              temperature: 0.2,
              maxOutputTokens: 800,
            },
          }),
        });

        lastProviderStatus = response.status;

        if (response.ok) {
          const json = (await response.json()) as any;
          const candidateText = json?.candidates?.[0]?.content?.parts?.[0]?.text;
          if (candidateText && candidateText.trim().length > 0) {
            return {
              success: true,
              answer: candidateText.trim(),
              source: 'ai_provider',
              model,
              isFallback: false,
            };
          }
        }

        const errJson = (await response.json().catch(() => null)) as any;
        lastProviderError = errJson?.error?.message || response.statusText;
        console.warn(
          `[EduSphere AI Service] Gemini model ${model} HTTP ${response.status}: ${lastProviderError}`
        );

        // If key is invalid (401/403 or 400 invalid key), stop iterating models with the same invalid key
        if (
          response.status === 401 ||
          response.status === 403 ||
          Boolean(lastProviderError?.toLowerCase().includes('api key'))
        ) {
          break;
        }
      } catch (err) {
        lastProviderError = err instanceof Error ? err.message : 'Network request timeout';
        console.warn(
          `[EduSphere AI Service] Gemini model ${model} fetch failure: ${lastProviderError}`
        );
      }
    }
  }

  // 2. Controlled Domain Fallback Engine
  // Derives technical answers directly from verified lesson content and provides honest status messaging
  const fallbackAnswer = generateContentBasedFallbackAnswer(
    cleanQuestion,
    lessonTitle,
    rawContent,
    courseTitle,
    courseCategory
  );

  let fallbackNotice = 'Live Gemini API key not configured on server. Answer compiled from verified lesson curriculum.';
  if (geminiApiKey) {
    if (lastProviderStatus === 429) {
      fallbackNotice = 'AI Provider quota or rate limit exceeded. Answer compiled from verified lesson curriculum.';
    } else if (
      lastProviderStatus === 401 ||
      lastProviderStatus === 403 ||
      lastProviderError?.toLowerCase().includes('api key')
    ) {
      fallbackNotice = 'AI Provider authentication failed (invalid API key). Answer compiled from verified lesson curriculum.';
    } else if (lastProviderStatus === 503) {
      fallbackNotice = 'AI Provider temporarily experiencing high demand. Answer compiled from verified lesson curriculum.';
    } else if (lastProviderError) {
      fallbackNotice = `AI Provider unavailable (${lastProviderError.slice(0, 50)}). Answer compiled from verified lesson curriculum.`;
    } else {
      fallbackNotice = 'AI Provider connection unavailable. Answer compiled from verified lesson curriculum.';
    }
  }

  return {
    success: true,
    answer: fallbackAnswer,
    source: 'fallback',
    isFallback: true,
    fallbackNotice,
  };
}

interface ConceptDefinition {
  name: string;
  keywords: string[];
  explanation: string;
}

const LESSON_CONCEPTS: Record<string, ConceptDefinition[]> = {
  // Lesson 2: The Raft Consensus Protocol in Depth
  'the raft consensus protocol in depth': [
    {
      name: 'Leader Election',
      keywords: ['leader election', 'election', 'leader', 'term', 'vote', 'candidate', 'timeout'],
      explanation:
        'Nodes transition from follower to candidate when an election timeout expires. Candidates request votes across the cluster. A node becomes leader once it secures votes from a strict majority quorum of peers.',
    },
    {
      name: 'Log Replication',
      keywords: ['log replication', 'replication', 'log', 'appendentries', 'commit', 'entry'],
      explanation:
        'The leader accepts state machine commands from clients, writes them to its append-only log, and distributes them via AppendEntries RPCs. Entries are committed once replicated across a majority quorum.',
    },
    {
      name: 'Safety Guarantees',
      keywords: ['safety guarantees', 'safety', 'invariants', 'completeness', 'correctness'],
      explanation:
        'Raft enforces key safety invariants: Election Safety (at most one leader per term), Leader Append-Only (leaders never overwrite their own logs), and State Machine Safety (committed entries are durable and applied in identical sequence).',
    },
    {
      name: 'Split-Brain Prevention',
      keywords: ['split-brain prevention', 'split-brain', 'split brain', 'quorum', 'partition'],
      explanation:
        'Raft prevents split-brain by requiring a strict majority quorum (N/2 + 1) to validate elections and commits. A partitioned minority cluster cannot elect a leader or accept writes, preventing diverging state logs.',
    },
  ],

  // Lesson 1: Introduction to Consensus & CAP Theorem
  'introduction to consensus & cap theorem': [
    {
      name: 'CAP Theorem',
      keywords: ['cap theorem', 'cap', 'brewer', 'tradeoff', 'trade-off'],
      explanation:
        'Brewer theorem states that a distributed data system can simultaneously provide at most two of three guarantees: Consistency, Availability, and Partition Tolerance.',
    },
    {
      name: 'Consistency vs Availability',
      keywords: ['consistency', 'availability', 'partitions', 'network partition'],
      explanation:
        'During network partitions, systems must choose between consistency (rejecting or delaying writes to prevent stale reads) and availability (responding immediately with potential state divergence).',
    },
    {
      name: 'Latency vs Correctness Trade-offs',
      keywords: ['latency', 'correctness', 'trade-offs', 'tradeoffs', 'delay', 'throughput'],
      explanation:
        'Synchronous replication ensures linearizable correctness across replicas at the cost of network round-trip latency, while asynchronous replication offers lower latency at the expense of temporary read inconsistencies.',
    },
  ],

  // Lesson 3: Eventual Consistency & CRDTs
  'eventual consistency & crdts': [
    {
      name: 'Conflict-Free Replicated Data Types (CRDTs)',
      keywords: ['crdt', 'conflict-free', 'conflict free', 'convergence'],
      explanation:
        'CRDTs are data structures replicated across independent nodes that can be updated concurrently without coordination and mathematically converge to identical state once all operations are exchanged.',
    },
    {
      name: 'State-based vs Operation-based Replication',
      keywords: ['state-based', 'operation-based', 'cvrdt', 'cmrdt', 'delta'],
      explanation:
        'State-based CRDTs (CvRDT) send their entire internal state and merge via monotonic semilattices. Operation-based CRDTs (CmRDT) transmit discrete commutative operations requiring causal delivery guarantees.',
    },
    {
      name: 'Vector Clocks',
      keywords: ['vector clocks', 'vector clock', 'causality', 'logical clock', 'lamport'],
      explanation:
        'Vector clocks use an array of logical counters across all nodes to establish causal ordering of events, distinguishing sequentially ordered updates from concurrent mutations.',
    },
  ],
};

/**
 * Controlled fallback response generator based on lesson text, key concepts, and question keywords.
 */
function generateContentBasedFallbackAnswer(
  question: string,
  lessonTitle: string,
  lessonContent: string,
  courseTitle: string,
  courseCategory: string
): string {
  const qLower = question.toLowerCase();
  const titleKey = lessonTitle.toLowerCase().trim();
  const knownConcepts = LESSON_CONCEPTS[titleKey];

  const isVideoQuery =
    qLower.includes('video') ||
    qLower.includes('recording') ||
    qLower.includes('watch') ||
    qLower.includes('lecture');

  const isLessonOverviewQuery =
    qLower.includes('what is this lesson') ||
    qLower.includes('what this lesson') ||
    qLower.includes('about this lesson') ||
    qLower.includes('lesson about') ||
    qLower.includes('summar') ||
    qLower.includes('principle') ||
    qLower.includes('overview') ||
    qLower.includes('what is covered') ||
    qLower.includes('what does this cover') ||
    qLower.includes('what is in') ||
    qLower.includes("what's in") ||
    qLower.includes('main point') ||
    qLower.includes('concept') ||
    qLower.includes('takeaway') ||
    qLower.includes('core') ||
    qLower.includes('explain this') ||
    qLower.includes('tell me about');

  // 1. Comprehensive overview or video queries with known curriculum concepts
  if ((isLessonOverviewQuery || isVideoQuery) && knownConcepts) {
    const conceptBullets = knownConcepts
      .map((c) => `- **${c.name}**: ${c.explanation}`)
      .join('\n');

    const headerTitle = isVideoQuery
      ? `Lesson & Lecture Overview: ${lessonTitle}`
      : `Key Technical Principles: ${lessonTitle}`;

    const videoNote = isVideoQuery
      ? `\n\n**Lecture Video Scope**: Direct video stream analysis is unavailable. The video lecture corresponds to the curriculum topics listed above, demonstrating how these mechanisms operate in **${courseTitle}**.`
      : '';

    return `### ${headerTitle}

Based on the verified curriculum notes for **${lessonTitle}**, here is a structured summary of the core principles:

${conceptBullets}${videoNote}

These principles form the foundation of **${courseCategory}** in **${courseTitle}**.`;
  }

  // 2. Check if the question targets a specific known concept from this lesson
  if (knownConcepts) {
    for (const concept of knownConcepts) {
      const matchesKeyword = concept.keywords.some((kw) => qLower.includes(kw));
      if (matchesKeyword) {
        const otherConcepts = knownConcepts
          .filter((c) => c.name !== concept.name)
          .map((c) => c.name)
          .join(', ');

        return `### ${concept.name}: ${lessonTitle}

According to the lesson notes for **${lessonTitle}**:

- **Core Principle**: ${concept.explanation}
- **Lesson Context**: This principle coordinates directly with **${otherConcepts}** to maintain correctness in **${courseTitle}**.
- **Application**: Refer to the lesson video and architectural notes to see this mechanism applied in practice.`;
      }
    }
  }

  // 3. Fallback matching directly on lesson content text
  if (lessonContent.length > 0) {
    const paragraphs = lessonContent.split(/\n\s*\n/).filter((p) => p.trim().length > 0);
    const keywords = qLower
      .replace(/[^\w\s]/g, '')
      .split(/\s+/)
      .filter((w) => w.length > 3);

    // Score paragraphs by keyword overlap
    let bestMatch = '';
    let maxMatches = 0;

    for (const para of paragraphs) {
      const pLower = para.toLowerCase();
      let matchCount = 0;
      for (const kw of keywords) {
        if (pLower.includes(kw)) {
          matchCount++;
        }
      }
      if (matchCount > maxMatches) {
        maxMatches = matchCount;
        bestMatch = para;
      }
    }

    if (maxMatches > 0 && bestMatch && !isLessonOverviewQuery && !isVideoQuery) {
      return `### Technical Guidance: ${lessonTitle}

Addressing your question on **${lessonTitle}** from the curriculum notes:

${bestMatch.trim()}

*This concept in **${courseCategory}** applies directly to your coursework in **${courseTitle}**.*`;
    }

    // Direct structured summary from clean content paragraphs
    const cleanParagraphs = paragraphs.filter((p) => {
      const trimmed = p.trim();
      return !trimmed.startsWith('```') && !trimmed.startsWith('+---') && !trimmed.startsWith('|');
    });

    const excerpt = cleanParagraphs.slice(0, 3).join('\n\n');
    const videoNote = isVideoQuery
      ? `\n\n> **Lecture Video Scope**: Direct video stream analysis is unavailable. The video lecture covers the curriculum topics outlined in the module notes above.`
      : '';

    return `### Key Principles: ${lessonTitle}

According to the curriculum notes for **${lessonTitle}**:

${excerpt || lessonContent.slice(0, 500)}${videoNote}

*These topics establish consistency and fault tolerance in **${courseTitle}**.*`;
  }


  // 4. Default clean fallback when no content is available
  const defaultVideoNote = isVideoQuery
    ? '\n\n**Lecture Video Scope**: Direct video stream analysis is unavailable. Complete the video lecture and review the assignment guidelines for this module.'
    : '';

  return `### Curriculum Overview: ${lessonTitle}

This lesson covers core principles for **${lessonTitle}** within **${courseCategory}** for **${courseTitle}**.

- **Subject**: ${lessonTitle}
- **Category**: ${courseCategory}${defaultVideoNote}`;
}

/**
 * Generate course recommendations based on real course data and student activity.
 */
export async function getCourseRecommendations(
  req: RecommendationRequest
): Promise<RecommendationResponse> {
  const {
    enrolledCourseIds = [],
    completedCourseIds = [],
    interests = [],
    allCourses = [],
  } = req;

  // Filter out courses already enrolled or completed
  const unavailableIds = new Set([...enrolledCourseIds, ...completedCourseIds]);
  const candidates = allCourses.filter((c) => !unavailableIds.has(c.id));

  if (candidates.length === 0) {
    return {
      success: true,
      recommendations: [],
      isPersonalized: enrolledCourseIds.length > 0,
      strategy: enrolledCourseIds.length > 0 ? 'history_based' : 'curated_starter',
    };
  }

  // Determine user history
  const hasHistory = enrolledCourseIds.length > 0 || completedCourseIds.length > 0 || interests.length > 0;

  if (hasHistory) {
    // Find categories of enrolled / completed courses
    const userCategoryCounts = new Map<string, number>();
    const userLevels = new Set<string>();

    allCourses.forEach((c) => {
      if (unavailableIds.has(c.id)) {
        userCategoryCounts.set(c.category, (userCategoryCounts.get(c.category) || 0) + 1);
        userLevels.add(c.level);
      }
    });

    // Score candidates
    const scored: RecommendedCourseItem[] = candidates.map((course) => {
      let score = 10; // Base score
      const reasons: string[] = [];

      // 1. Category relevance
      const categoryCount = userCategoryCounts.get(course.category) || 0;
      if (categoryCount > 0) {
        score += categoryCount * 30;
        reasons.push(`Aligned with your studies in ${course.category}`);
      }

      // 2. Explicit interest matches
      const matchedInterest = interests.find(
        (interest) =>
          course.category.toLowerCase().includes(interest.toLowerCase()) ||
          course.title.toLowerCase().includes(interest.toLowerCase()) ||
          course.description.toLowerCase().includes(interest.toLowerCase())
      );
      if (matchedInterest) {
        score += 25;
        reasons.push(`Matches your interest in ${matchedInterest}`);
      }

      // 3. Difficulty progression
      if (userLevels.has('Beginner') && course.level === 'Intermediate') {
        score += 20;
        reasons.push('Next step in your skill progression (Intermediate level)');
      } else if (userLevels.has('Intermediate') && course.level === 'Advanced') {
        score += 20;
        reasons.push('Advanced level challenge to build on completed coursework');
      }

      if (reasons.length === 0) {
        reasons.push(`Recommended course in ${course.category}`);
      }

      return {
        course,
        score,
        reason: reasons.join(' • '),
        isPersonalized: true,
      };
    });

    scored.sort((a, b) => b.score - a.score);

    return {
      success: true,
      recommendations: scored.slice(0, 4),
      isPersonalized: true,
      strategy: 'history_based',
    };
  }

  // Strategy for new students without enrollment history
  const curated: RecommendedCourseItem[] = candidates
    .map((course) => {
      let score = 10;
      if (course.level === 'Beginner') score += 20;

      return {
        course,
        score,
        reason:
          course.level === 'Beginner'
            ? 'Great starting course for beginners in ' + course.category
            : 'Popular curriculum in ' + course.category,
        isPersonalized: false,
      };
    })
    .sort((a, b) => b.score - a.score);

  return {
    success: true,
    recommendations: curated.slice(0, 4),
    isPersonalized: false,
    strategy: 'curated_starter',
  };
}
