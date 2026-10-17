import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { getPublishedCourses } from '../lib/courses';
import { fetchCourseRecommendations, type RecommendedCourseItem } from '../lib/ai';
import { getCourseCoverDisplayUrl } from '../lib/media';
import {
  Sparkles,
  ArrowRight,
  Loader2,
  CheckCircle2,
  TrendingUp,
} from 'lucide-react';

const FALLBACK_THUMBNAIL = 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=800&auto=format&fit=crop';

interface RecommendedCoursesSectionProps {
  enrolledCourseIds: string[];
  completedCourseIds: string[];
  studentId?: string;
}

const AVAILABLE_INTERESTS = [
  'All Recommendations',
  'Computer Science',
  'Artificial Intelligence',
  'Web Development',
  'Cloud Architecture',
];

export const RecommendedCoursesSection: React.FC<RecommendedCoursesSectionProps> = ({
  enrolledCourseIds,
  completedCourseIds,
  studentId,
}) => {
  const [recommendations, setRecommendations] = useState<RecommendedCourseItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedInterest, setSelectedInterest] = useState('All Recommendations');
  const [isPersonalized, setIsPersonalized] = useState(false);

  useEffect(() => {
    let ignore = false;

    getPublishedCourses().then(async ({ data: allCourses }) => {
      if (ignore) return;
      if (!allCourses || allCourses.length === 0) {
        setRecommendations([]);
        setLoading(false);
        return;
      }

      const interests =
        selectedInterest !== 'All Recommendations' ? [selectedInterest] : [];

      const res = await fetchCourseRecommendations({
        studentId,
        enrolledCourseIds,
        completedCourseIds,
        interests,
        allCourses: allCourses.map((c) => ({
          id: c.id,
          title: c.title,
          slug: c.slug,
          description: c.description,
          category: c.category,
          level: c.level,
          thumbnail_url: c.thumbnail_url,
        })),
      });

      if (!ignore) {
        setRecommendations(res.recommendations || []);
        setIsPersonalized(res.isPersonalized);
        setLoading(false);
      }
    });

    return () => {
      ignore = true;
    };
  }, [enrolledCourseIds, completedCourseIds, studentId, selectedInterest]);

  return (
    <div className="space-y-6 pt-8 border-t border-[#E5E2D9]">
      {/* Section Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div className="space-y-1">
          <div className="flex items-center gap-2">
            <div className="w-6 h-6 rounded bg-[#F4F1EA] border border-[#E5E2D9] flex items-center justify-center text-[#1B3B2B]">
              <Sparkles className="w-3.5 h-3.5" />
            </div>
            <h2 className="font-editorial text-2xl text-[#1F2421] tracking-tight">
              Curriculum Recommendations
            </h2>
            <span
              className={`px-2.5 py-0.5 rounded-full text-[10px] font-semibold border ${
                isPersonalized
                  ? 'bg-[#F4F1EA] text-[#1B3B2B] border-[#E5E2D9]'
                  : 'bg-[#F4F1EA] text-[#535C56] border-[#E5E2D9]'
              }`}
            >
              {isPersonalized ? 'Personalized for You' : 'Foundational Topics'}
            </span>
          </div>
          <p className="text-xs text-[#535C56]">
            {isPersonalized
              ? 'Suggested courses based on your active coursework, completed milestones, and category prerequisites.'
              : 'Recommended subjects to develop core software engineering competency.'}
          </p>
        </div>

        {/* Interest Filter Chips */}
        <div className="flex flex-wrap items-center gap-1.5">
          {AVAILABLE_INTERESTS.map((interest) => (
            <button
              key={interest}
              onClick={() => setSelectedInterest(interest)}
              className={`px-2.5 py-1 rounded-md text-xs font-medium transition-colors cursor-pointer ${
                selectedInterest === interest
                  ? 'bg-[#1B3B2B] text-white font-semibold'
                  : 'bg-[#F4F1EA] text-[#535C56] hover:bg-[#EAE6DD] hover:text-[#1F2421] border border-[#E5E2D9]'
              }`}
            >
              {interest}
            </button>
          ))}
        </div>
      </div>

      {/* Recommendations Cards Grid */}
      {loading ? (
        <div className="p-12 text-center text-[#535C56] space-y-3 academic-card">
          <Loader2 className="w-5 h-5 animate-spin text-[#1B3B2B] mx-auto" />
          <p className="text-xs">Analyzing learning progress and ranking recommended curricula...</p>
        </div>
      ) : recommendations.length === 0 ? (
        <div className="p-8 text-center text-[#535C56] space-y-2 academic-card">
          <CheckCircle2 className="w-7 h-7 text-[#1B3B2B] mx-auto" />
          <h4 className="font-editorial text-base text-[#1F2421]">All Courses Explored</h4>
          <p className="text-xs text-[#535C56] max-w-sm mx-auto">
            You are enrolled in all available courses in this category. Check back soon as new topics are authored.
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {recommendations.map((item) => {
            const course = item.course;
            const thumbnail = getCourseCoverDisplayUrl(course.thumbnail_url);

            return (
              <div
                key={course.id}
                className="academic-card overflow-hidden flex flex-col justify-between group hover:border-[#1B3B2B]/40 transition-colors"
              >
                <div>
                  {/* Thumbnail Banner */}
                  <div className="relative aspect-[16/10] w-full overflow-hidden bg-[#F4F1EA]">
                    <img
                      src={thumbnail}
                      alt={course.title}
                      className="w-full h-full object-cover group-hover:scale-102 transition-transform duration-300"
                      onError={(e) => {
                        (e.target as HTMLImageElement).src = FALLBACK_THUMBNAIL;
                      }}
                    />
                    <div className="absolute top-2.5 left-2.5 flex items-center gap-1.5">
                      <span className="px-2 py-0.5 rounded text-[10px] font-semibold bg-white/95 text-[#1F2421] border border-[#E5E2D9]">
                        {course.category}
                      </span>
                      <span className="px-2 py-0.5 rounded text-[10px] font-semibold bg-[#F4F1EA] text-[#535C56] border border-[#E5E2D9]">
                        {course.level}
                      </span>
                    </div>
                  </div>

                  {/* Course Info */}
                  <div className="p-4 space-y-2.5">
                    <h3 className="font-editorial text-base text-[#1F2421] group-hover:text-[#1B3B2B] transition-colors line-clamp-2">
                      {course.title}
                    </h3>
                    <p className="text-xs text-[#535C56] line-clamp-2 leading-relaxed">
                      {course.description}
                    </p>

                    {/* Recommendation Reason */}
                    <div className="p-2 rounded bg-[#F4F1EA] border border-[#E5E2D9] text-[11px] text-[#1B3B2B] flex items-start gap-1.5">
                      <TrendingUp className="w-3.5 h-3.5 text-[#1B3B2B] shrink-0 mt-0.5" />
                      <span className="line-clamp-2 font-medium">{item.reason}</span>
                    </div>
                  </div>
                </div>

                {/* Footer Action */}
                <div className="p-4 pt-0">
                  <Link
                    to={`/courses/${course.id}`}
                    className="btn-secondary w-full text-xs py-1.5 justify-center flex items-center gap-1.5"
                  >
                    <span>View Curriculum</span>
                    <ArrowRight className="w-3.5 h-3.5" />
                  </Link>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
};
