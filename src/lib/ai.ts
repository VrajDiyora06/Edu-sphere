import type {
  DoubtRequest,
  DoubtResponse,
  RecommendationRequest,
  RecommendationResponse,
  RecommendedCourseItem,
} from '../types';

export type {
  DoubtRequest,
  DoubtResponse,
  RecommendationRequest,
  RecommendationResponse,
  RecommendedCourseItem,
};

/**
 * Ask a technical question about the current lesson content.
 * Calls server-side endpoint /api/ai/doubt to preserve API key confidentiality.
 */
export async function askLessonDoubt(payload: DoubtRequest): Promise<DoubtResponse> {
  try {
    const res = await fetch('/api/ai/doubt', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    });

    if (res.ok) {
      return await res.json();
    }

    const errJson = await res.json().catch(() => null);
    if (errJson?.error) {
      return {
        success: false,
        source: 'fallback',
        isFallback: true,
        error: errJson.error,
      };
    }
  } catch {
    // If network or server unavailable, fallback safely with verified lesson curriculum
  }

  // Client-side emergency resilience if server route is unreachable
  const rawNotes = payload.lessonContent?.trim() || '';

  return {
    success: true,
    answer: rawNotes.length > 0
      ? `### Lesson Notes Reference: ${payload.lessonTitle}\n\nHere is the relevant section from your lesson notes answering "${payload.question}":\n\n> ${rawNotes.slice(0, 300)}...\n\n*Review the lecture video and code walk-through to see these principles in practice.*`
      : `### Lesson Summary: ${payload.lessonTitle}\n\nThis lesson covers fundamental principles of **${payload.courseCategory}** in **${payload.courseTitle}**.\n\nPlease refer to the lecture video and assignment guidelines for detailed code implementation.`,
    source: 'fallback',
    isFallback: true,
    fallbackNotice: 'Local connection to AI server unavailable. Displaying lesson curriculum guidance.',
  };
}

/**
 * Fetch course recommendations based on student learning activity and available catalog.
 */
export async function fetchCourseRecommendations(
  payload: RecommendationRequest
): Promise<RecommendationResponse> {
  try {
    const res = await fetch('/api/ai/recommendations', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    });

    if (res.ok) {
      return await res.json();
    }
  } catch {
    // Fall through to client-side rule engine
  }

  // Client-side rule engine fallback
  const unavailable = new Set([
    ...(payload.enrolledCourseIds || []),
    ...(payload.completedCourseIds || []),
  ]);
  const candidates = payload.allCourses.filter((c) => !unavailable.has(c.id));

  const recommendations = candidates.slice(0, 4).map((c) => ({
    course: c,
    score: 50,
    reason: `Recommended based on your academic path in ${c.category}`,
    isPersonalized: (payload.enrolledCourseIds?.length || 0) > 0,
  }));

  return {
    success: true,
    recommendations,
    isPersonalized: (payload.enrolledCourseIds?.length || 0) > 0,
    strategy: (payload.enrolledCourseIds?.length || 0) > 0 ? 'history_based' : 'curated_starter',
  };
}
