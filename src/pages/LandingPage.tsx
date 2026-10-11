import React, { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { getPublishedCourses, type CourseListItem } from '../lib/courses';
import { getCourseCoverDisplayUrl } from '../lib/media';
import {
  ArrowRight,
  CheckCircle2,
  BookOpen,
  Clock,
  Loader2,
  Award,
  FileCheck2,
  GraduationCap,
  Search,
  Sparkles,
} from 'lucide-react';

const FALLBACK_THUMBNAIL =
  'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=800&auto=format&fit=crop';
const FALLBACK_AVATAR =
  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=120&auto=format&fit=crop';

export const LandingPage: React.FC = () => {
  const [courses, setCourses] = useState<CourseListItem[]>([]);
  const [loadingCourses, setLoadingCourses] = useState(true);
  const [heroSearch, setHeroSearch] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    let ignore = false;
    getPublishedCourses().then(({ data }) => {
      if (!ignore) {
        setCourses(data?.slice(0, 3) || []);
        setLoadingCourses(false);
      }
    });
    return () => {
      ignore = true;
    };
  }, []);

  const handleHeroSearch = (e: React.FormEvent) => {
    e.preventDefault();
    if (heroSearch.trim()) {
      navigate(`/courses?search=${encodeURIComponent(heroSearch.trim())}`);
    } else {
      navigate('/courses');
    }
  };

  return (
    <div className="space-y-20 pb-24">
      {/* Editorial Hero Section */}
      <section className="pt-14 sm:pt-20 lg:pt-24 px-4 sm:px-6 lg:px-8 max-w-6xl mx-auto text-center">
        <div className="max-w-4xl mx-auto space-y-6">
          {/* Institutional Badge */}
          <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-[#F4F1EA] border border-[#E5E2D9] text-xs font-medium text-[#1B3B2B]">
            <GraduationCap className="w-4 h-4 text-[#1B3B2B]" />
            <span>Open Academic Curriculum</span>
            <span className="text-[#8FA896]">•</span>
            <span className="text-[#535C56]">Zero Tuition</span>
          </div>

          <h1 className="font-editorial text-4xl sm:text-5xl lg:text-6xl text-[#1F2421] font-normal tracking-tight leading-[1.12]">
            Rigorous technical education, open to every committed learner.
          </h1>

          <p className="text-base sm:text-lg text-[#535C56] leading-relaxed max-w-2xl mx-auto">
            EduSphere delivers university-level courseware in computer science and engineering. Complete structured syllabi, submit graded assignments, verify certificates, and receive context-grounded AI tutoring.
          </p>

          {/* Prominent Course Search Bar */}
          <form
            onSubmit={handleHeroSearch}
            className="pt-4 max-w-xl mx-auto flex items-center gap-2 bg-white border border-[#E5E2D9] rounded-lg p-1.5 shadow-xs focus-within:border-[#1B3B2B] focus-within:ring-2 focus-within:ring-[#1B3B2B]/10 transition-all"
          >
            <div className="pl-3 text-[#7A857E]">
              <Search className="w-4 h-4" />
            </div>
            <input
              type="text"
              value={heroSearch}
              onChange={(e) => setHeroSearch(e.target.value)}
              placeholder="Search courses by topic, language, or system..."
              className="w-full text-xs sm:text-sm text-[#1F2421] placeholder:text-[#7A857E] bg-transparent outline-none px-2"
            />
            <button
              type="submit"
              className="btn-forest px-4 py-2 text-xs font-semibold whitespace-nowrap cursor-pointer"
            >
              Search Catalog
            </button>
          </form>

          {/* Action Links */}
          <div className="pt-2 flex flex-wrap items-center justify-center gap-3">
            <Link
              to="/courses"
              className="btn-forest px-6 py-2.5 text-xs font-semibold inline-flex items-center gap-2"
            >
              <span>Explore All Courses</span>
              <ArrowRight className="w-3.5 h-3.5" />
            </Link>
            <Link
              to="/register"
              className="btn-secondary px-6 py-2.5 text-xs font-semibold"
            >
              <span>Create Free Student Account</span>
            </Link>
          </div>

          {/* Academic Highlights Row */}
          <div className="pt-10 max-w-4xl mx-auto">
            <div className="bg-[#F4F1EA] border border-[#E5E2D9] rounded-lg p-5 grid grid-cols-2 md:grid-cols-4 gap-4 text-left divide-y md:divide-y-0 md:divide-x divide-[#E5E2D9]">
              <div className="p-3">
                <div className="font-editorial text-2xl text-[#1F2421]">100% Free</div>
                <div className="text-xs text-[#535C56] mt-0.5">Open Access Curriculum</div>
              </div>
              <div className="p-3">
                <div className="font-editorial text-2xl text-[#1B3B2B]">AI Tutor</div>
                <div className="text-xs text-[#535C56] mt-0.5">Lesson-Grounded Queries</div>
              </div>
              <div className="p-3">
                <div className="font-editorial text-2xl text-[#1F2421]">Evaluated</div>
                <div className="text-xs text-[#535C56] mt-0.5">Quizzes & Assignments</div>
              </div>
              <div className="p-3">
                <div className="font-editorial text-2xl text-[#1B3B2B]">Verified</div>
                <div className="text-xs text-[#535C56] mt-0.5">Official Certificates</div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Course Discovery Section */}
      <section className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col sm:flex-row sm:items-end justify-between mb-8 gap-4 border-b border-[#E5E2D9] pb-4">
          <div>
            <span className="text-xs font-semibold uppercase tracking-wider text-[#1B3B2B]">
              Curriculum Showcase
            </span>
            <h2 className="font-editorial text-2xl sm:text-3xl text-[#1F2421] mt-1">
              Featured University Courses
            </h2>
          </div>
          <Link
            to="/courses"
            className="text-xs font-semibold text-[#1B3B2B] hover:text-[#12281D] inline-flex items-center gap-1.5 transition-colors"
          >
            <span>View Full Catalog</span>
            <ArrowRight className="w-3.5 h-3.5" />
          </Link>
        </div>

        {loadingCourses ? (
          <div className="py-16 text-center text-[#535C56] flex items-center justify-center gap-2 text-xs academic-card">
            <Loader2 className="w-4 h-4 animate-spin text-[#1B3B2B]" />
            <span>Loading published curricula...</span>
          </div>
        ) : courses.length === 0 ? (
          <div className="academic-card p-12 text-center space-y-3">
            <BookOpen className="w-8 h-8 text-[#7A857E] mx-auto" />
            <h3 className="font-editorial text-lg text-[#1F2421]">No published courses available yet</h3>
            <p className="text-xs text-[#535C56] max-w-sm mx-auto">
              Check back soon as faculty members publish new coursework.
            </p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {courses.map((course) => (
              <div
                key={course.id}
                className="academic-card overflow-hidden flex flex-col group hover:border-[#1B3B2B]/40 transition-colors"
              >
                <div className="relative aspect-[16/10] overflow-hidden bg-[#F4F1EA]">
                  <img
                    src={getCourseCoverDisplayUrl(course.thumbnail_url)}
                    alt={course.title}
                    className="w-full h-full object-cover group-hover:scale-102 transition-transform duration-300"
                    onError={(e) => {
                      (e.target as HTMLImageElement).src = FALLBACK_THUMBNAIL;
                    }}
                  />
                  <div className="absolute top-3 left-3 px-2 py-0.5 rounded text-[11px] font-semibold bg-white/95 text-[#1F2421] border border-[#E5E2D9]">
                    {course.category}
                  </div>
                  <div className="absolute top-3 right-3 px-2 py-0.5 rounded text-[11px] font-semibold bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9]">
                    Free
                  </div>
                </div>

                <div className="p-5 flex-1 flex flex-col justify-between space-y-4">
                  <div>
                    <div className="flex items-center gap-2 text-xs text-[#535C56] mb-2 font-medium">
                      <span>{course.level}</span>
                      <span>•</span>
                      <span className="flex items-center gap-1">
                        <Clock className="w-3.5 h-3.5 text-[#7A857E]" />
                        {course.lessons_count} Lessons
                      </span>
                    </div>
                    <h3 className="font-editorial text-lg text-[#1F2421] group-hover:text-[#1B3B2B] transition-colors line-clamp-2">
                      {course.title}
                    </h3>
                    <p className="text-xs text-[#535C56] mt-2 line-clamp-2 leading-relaxed">
                      {course.description}
                    </p>
                  </div>

                  <div className="pt-4 border-t border-[#E5E2D9] flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <img
                        src={course.instructor?.avatar_url || FALLBACK_AVATAR}
                        alt={course.instructor?.full_name || 'Instructor'}
                        className="w-6 h-6 rounded-full object-cover border border-[#E5E2D9]"
                      />
                      <span className="text-xs text-[#1F2421] font-medium truncate max-w-[130px]">
                        {course.instructor?.full_name || 'EduSphere Faculty'}
                      </span>
                    </div>
                    <Link
                      to={`/courses/${course.id}`}
                      className="btn-forest text-xs py-1.5 px-3"
                    >
                      View Details
                    </Link>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </section>

      {/* Academic Learning Methodology */}
      <section className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-2xl mx-auto mb-12 space-y-2">
          <span className="text-xs font-semibold uppercase tracking-wider text-[#1B3B2B]">
            Pedagogical Structure
          </span>
          <h2 className="font-editorial text-2xl sm:text-3xl text-[#1F2421]">
            Designed for technical depth and active retention
          </h2>
          <p className="text-xs sm:text-sm text-[#535C56]">
            Every curriculum combines structured lectures, verified assessments, and direct doubt resolution.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div className="academic-card p-6 space-y-3">
            <div className="w-9 h-9 rounded-md bg-[#F4F1EA] border border-[#E5E2D9] text-[#1B3B2B] flex items-center justify-center">
              <BookOpen className="w-4 h-4" />
            </div>
            <h3 className="font-editorial text-base text-[#1F2421]">Structured Syllabi</h3>
            <p className="text-xs text-[#535C56] leading-relaxed">
              Step-by-step modular lessons with lecture video, Markdown reading notes, and technical references.
            </p>
          </div>

          <div className="academic-card p-6 space-y-3">
            <div className="w-9 h-9 rounded-md bg-[#F4F1EA] border border-[#E5E2D9] text-[#1B3B2B] flex items-center justify-center">
              <Sparkles className="w-4 h-4" />
            </div>
            <h3 className="font-editorial text-base text-[#1F2421]">Transcript-Grounded AI</h3>
            <p className="text-xs text-[#535C56] leading-relaxed">
              A specialized AI tutor with direct access to lecture transcripts for focused question resolution.
            </p>
          </div>

          <div className="academic-card p-6 space-y-3">
            <div className="w-9 h-9 rounded-md bg-[#F4F1EA] border border-[#E5E2D9] text-[#1B3B2B] flex items-center justify-center">
              <FileCheck2 className="w-4 h-4" />
            </div>
            <h3 className="font-editorial text-base text-[#1F2421]">Evaluated Assignments</h3>
            <p className="text-xs text-[#535C56] leading-relaxed">
              Timed multiple-choice quizzes and file-upload project assignments evaluated against course rubrics.
            </p>
          </div>

          <div className="academic-card p-6 space-y-3">
            <div className="w-9 h-9 rounded-md bg-[#F4F1EA] border border-[#E5E2D9] text-[#1B3B2B] flex items-center justify-center">
              <Award className="w-4 h-4" />
            </div>
            <h3 className="font-editorial text-base text-[#1F2421]">Verified Certificates</h3>
            <p className="text-xs text-[#535C56] leading-relaxed">
              Official completion records generated upon passing all required modules, exportable to print or PDF.
            </p>
          </div>
        </div>
      </section>

      {/* AI Doubt Assistant Spotlight */}
      <section className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="academic-card p-8 lg:p-12 border-[#E5E2D9]">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-10 items-center">
            <div className="space-y-4">
              <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9] text-xs font-semibold">
                <Sparkles className="w-3.5 h-3.5" />
                <span>Integrated Pedagogical Support</span>
              </div>
              <h2 className="font-editorial text-2xl sm:text-3xl text-[#1F2421] leading-tight">
                Context-aware doubt resolution inside the learning workspace.
              </h2>
              <p className="text-xs sm:text-sm text-[#535C56] leading-relaxed">
                Rather than browsing external forums, students query the assistant while studying. The tutor extracts technical definitions, mathematical expressions, and code patterns directly from the active lesson transcript.
              </p>

              <div className="pt-2 space-y-2.5">
                <div className="flex items-center gap-2.5 text-xs text-[#1F2421]">
                  <CheckCircle2 className="w-4 h-4 text-[#1B3B2B] shrink-0" />
                  <span>Answers directly grounded in indexed lesson text and code blocks</span>
                </div>
                <div className="flex items-center gap-2.5 text-xs text-[#1F2421]">
                  <CheckCircle2 className="w-4 h-4 text-[#1B3B2B] shrink-0" />
                  <span>KaTeX mathematical formulas and syntax-highlighted code blocks</span>
                </div>
                <div className="flex items-center gap-2.5 text-xs text-[#1F2421]">
                  <CheckCircle2 className="w-4 h-4 text-[#1B3B2B] shrink-0" />
                  <span>Transparent model attribution and controlled deterministic fallbacks</span>
                </div>
              </div>
            </div>

            {/* Academic Tutor Preview */}
            <div className="bg-[#FAF9F5] rounded-lg border border-[#E5E2D9] p-5 space-y-4">
              <div className="flex items-center justify-between pb-3 border-b border-[#E5E2D9]">
                <div className="flex items-center gap-2">
                  <div className="w-2.5 h-2.5 rounded-full bg-[#1B3B2B]" />
                  <span className="text-xs font-semibold text-[#1F2421]">EduSphere AI Tutor</span>
                </div>
                <span className="text-[10px] uppercase font-semibold px-2 py-0.5 rounded bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9]">
                  Lesson Grounded
                </span>
              </div>

              <div className="space-y-3 text-xs">
                <div className="bg-white p-3.5 rounded-lg border border-[#E5E2D9] text-[#1F2421] ml-4">
                  <span className="font-semibold text-[#1B3B2B] block mb-1">Student:</span>
                  In this lesson on PostgreSQL RLS, why does the policy use auth.uid() instead of a client-passed user_id?
                </div>

                <div className="bg-[#F4F1EA] p-3.5 rounded-lg border border-[#E5E2D9] text-[#1F2421] mr-4">
                  <div className="flex items-center justify-between text-[10px] font-semibold text-[#1B3B2B] mb-1">
                    <span>AI Tutor</span>
                    <span className="text-[#7A857E] font-normal">Active Transcript Context</span>
                  </div>
                  Client-provided IDs can be forged by a malicious requester. Using <code className="bg-white px-1 py-0.5 rounded border border-[#E5E2D9] font-mono text-[11px]">auth.uid()</code> enforces the identity cryptographically verified by the JWT session at the database engine level.
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
};
