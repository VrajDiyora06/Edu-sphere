import React, { useState, useEffect, useCallback } from 'react';
import { Link, useSearchParams } from 'react-router-dom';
import { useAuth } from '../context/useAuth';
import { getPublishedCourses, type CourseListItem } from '../lib/courses';
import { supabase } from '../lib/supabaseClient';
import { getCourseCoverDisplayUrl } from '../lib/media';
import type { DbAnnouncement } from '../types';
import {
  Search,
  Filter,
  BookOpen,
  Clock,
  BarChart,
  CheckCircle,
  AlertCircle,
  RefreshCw,
  Loader2,
  Megaphone,
} from 'lucide-react';

const FALLBACK_THUMBNAIL =
  'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=800&auto=format&fit=crop';
const FALLBACK_AVATAR =
  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=120&auto=format&fit=crop';

const DEFAULT_CATEGORIES = [
  'All Categories',
  'Computer Science',
  'Web Development',
  'Database Engineering',
  'Artificial Intelligence',
  'Software Architecture',
];

export const CatalogPage: React.FC = () => {
  const { user, role, loading: authLoading } = useAuth();
  const [searchParams, setSearchParams] = useSearchParams();
  const initialSearch = searchParams.get('search') || '';

  const [courses, setCourses] = useState<CourseListItem[]>([]);
  const [announcements, setAnnouncements] = useState<DbAnnouncement[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const [searchQuery, setSearchQuery] = useState(initialSearch);
  const [selectedCategory, setSelectedCategory] = useState('All Categories');
  const [selectedLevel, setSelectedLevel] = useState('All');

  const fetchCoursesData = useCallback(async () => {
    const { data, error: fetchErr } = await getPublishedCourses();
    if (fetchErr) {
      setError(fetchErr.message || 'Failed to load courses from Supabase.');
      setCourses([]);
    } else {
      setCourses(data || []);
    }
    setLoading(false);
  }, []);

  const handleRetry = useCallback(() => {
    setLoading(true);
    setError(null);
    fetchCoursesData();
  }, [fetchCoursesData]);

  useEffect(() => {
    if (authLoading) return;
    let ignore = false;
    setLoading(true);
    getPublishedCourses().then(({ data, error: fetchErr }) => {
      if (ignore) return;
      if (fetchErr) {
        setError(fetchErr.message || 'Failed to load courses from Supabase.');
        setCourses([]);
      } else {
        setCourses(data || []);
      }
      setLoading(false);
    });

    supabase
      .from('announcements')
      .select('id, title, content, priority, created_at')
      .eq('is_published', true)
      .order('created_at', { ascending: false })
      .limit(2)
      .then(({ data }) => {
        if (!ignore && data) {
          setAnnouncements(data as DbAnnouncement[]);
        }
      });

    return () => {
      ignore = true;
    };
  }, [authLoading, user?.id, role]);

  // Update query params when search changes
  const handleSearchChange = (value: string) => {
    setSearchQuery(value);
    if (value.trim()) {
      setSearchParams({ search: value.trim() });
    } else {
      setSearchParams({});
    }
  };

  // Derive available categories dynamically from fetched courses, falling back to defaults
  const categories = React.useMemo(() => {
    if (courses.length === 0) return DEFAULT_CATEGORIES;
    const distinct = Array.from(new Set(courses.map((c) => c.category).filter(Boolean)));
    return ['All Categories', ...distinct];
  }, [courses]);

  const filteredCourses = courses.filter((course) => {
    const matchesSearch =
      course.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      course.description.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesCategory =
      selectedCategory === 'All Categories' || course.category === selectedCategory;
    const matchesLevel = selectedLevel === 'All' || course.level === selectedLevel;

    return matchesSearch && matchesCategory && matchesLevel;
  });

  return (
    <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-12 space-y-10">
      {/* Editorial Page Header */}
      <div className="space-y-3 border-b border-[#E5E2D9] pb-8">
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#F4F1EA] border border-[#E5E2D9] text-xs font-medium text-[#1B3B2B]">
          <BookOpen className="w-3.5 h-3.5 text-[#1B3B2B]" />
          <span>Curriculum Registry</span>
          <span className="text-[#8FA896]">•</span>
          <span className="text-[#535C56]">Full Access</span>
        </div>
        <h1 className="font-editorial text-3xl sm:text-4xl text-[#1F2421] font-normal tracking-tight">
          Course Catalog
        </h1>
        <p className="text-sm text-[#535C56] max-w-2xl leading-relaxed">
          Explore complete technical syllabi across computer systems, database engineering, and artificial intelligence. Every course includes structured lessons, assignments, and verifiable certificates.
        </p>
      </div>

      {/* Announcements Banner */}
      {announcements.length > 0 && (
        <div className="space-y-3">
          {announcements.map((ann) => (
            <div
              key={ann.id}
              className="p-4 rounded-lg bg-[#FAF9F5] border border-[#E5E2D9] flex items-start gap-3.5"
            >
              <div className="w-7 h-7 rounded bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9] flex items-center justify-center shrink-0 mt-0.5">
                <Megaphone className="w-3.5 h-3.5" />
              </div>
              <div className="space-y-1 min-w-0 flex-1">
                <div className="flex items-center gap-2">
                  <span
                    className={`text-[10px] uppercase font-semibold px-2 py-0.5 rounded ${
                      ann.priority === 'urgent' || ann.priority === 'high'
                        ? 'bg-[#FDF1EE] text-[#9E3D2B] border border-[#F5C2BA]'
                        : 'bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9]'
                    }`}
                  >
                    {ann.priority}
                  </span>
                  <h4 className="text-xs sm:text-sm font-semibold text-[#1F2421] truncate">
                    {ann.title}
                  </h4>
                </div>
                <p className="text-xs text-[#535C56] leading-relaxed">{ann.content}</p>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Filter and Search Bar */}
      <div className="academic-card p-5 space-y-4">
        <div className="flex flex-col md:flex-row gap-3">
          {/* Search Field */}
          <div className="relative flex-1">
            <Search className="w-4 h-4 text-[#7A857E] absolute left-3.5 top-3.5" />
            <input
              type="text"
              placeholder="Search by course title, topic, or technology..."
              value={searchQuery}
              onChange={(e) => handleSearchChange(e.target.value)}
              className="academic-input pl-10 text-xs sm:text-sm"
            />
          </div>

          {/* Difficulty Level Dropdown */}
          <div className="flex items-center gap-2">
            <Filter className="w-4 h-4 text-[#7A857E] shrink-0" />
            <select
              value={selectedLevel}
              onChange={(e) => setSelectedLevel(e.target.value)}
              className="academic-input py-2 text-xs font-medium cursor-pointer"
            >
              <option value="All">All Difficulty Levels</option>
              <option value="Beginner">Beginner</option>
              <option value="Intermediate">Intermediate</option>
              <option value="Advanced">Advanced</option>
            </select>
          </div>
        </div>

        {/* Category Pills */}
        <div className="flex flex-wrap items-center gap-2 pt-3 border-t border-[#E5E2D9]">
          {categories.map((cat) => (
            <button
              key={cat}
              onClick={() => setSelectedCategory(cat)}
              className={`px-3 py-1.5 rounded-md text-xs transition-colors cursor-pointer ${
                selectedCategory === cat
                  ? 'bg-[#1B3B2B] text-white font-semibold'
                  : 'bg-[#F4F1EA] text-[#535C56] hover:text-[#1F2421] hover:bg-[#EAE6DD] border border-[#E5E2D9]'
              }`}
            >
              {cat}
            </button>
          ))}
        </div>
      </div>

      {/* Loading State */}
      {loading && (
        <div className="academic-card p-16 text-center space-y-3">
          <Loader2 className="w-6 h-6 text-[#1B3B2B] animate-spin mx-auto" />
          <h3 className="font-editorial text-lg text-[#1F2421]">Loading Course Catalog</h3>
          <p className="text-xs text-[#535C56]">Fetching published curricula from database...</p>
        </div>
      )}

      {/* Error State */}
      {!loading && error && (
        <div className="academic-card p-10 text-center border-[#F5C2BA] bg-[#FDF1EE]/40 space-y-4">
          <AlertCircle className="w-8 h-8 text-[#9E3D2B] mx-auto" />
          <div className="space-y-1">
            <h3 className="font-editorial text-lg text-[#1F2421]">Unable to Load Courses</h3>
            <p className="text-xs text-[#9E3D2B] max-w-md mx-auto">{error}</p>
          </div>
          <button onClick={handleRetry} className="btn-forest text-xs">
            <RefreshCw className="w-3.5 h-3.5 mr-1" />
            <span>Try Again</span>
          </button>
        </div>
      )}

      {/* Empty Database State */}
      {!loading && !error && courses.length === 0 && (
        <div className="academic-card p-14 text-center space-y-4">
          <BookOpen className="w-10 h-10 text-[#7A857E] mx-auto" />
          <div className="space-y-1">
            <h3 className="font-editorial text-xl text-[#1F2421]">No Published Courses</h3>
            <p className="text-xs text-[#535C56] max-w-md mx-auto">
              There are currently no published courses available in the system. When faculty members publish approved coursework, it will automatically appear here.
            </p>
          </div>
          <button onClick={handleRetry} className="btn-secondary text-xs">
            <RefreshCw className="w-3.5 h-3.5 mr-1" />
            <span>Refresh Catalog</span>
          </button>
        </div>
      )}

      {/* Filtered Results */}
      {!loading && !error && courses.length > 0 && (
        <>
          <div className="flex items-center justify-between text-xs text-[#535C56] font-medium px-1">
            <span>
              Showing {filteredCourses.length} of {courses.length} courses
            </span>
            <span className="text-[#1B3B2B] font-semibold">100% Free Tuition</span>
          </div>

          {filteredCourses.length > 0 ? (
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              {filteredCourses.map((course) => {
                const durationHours = Math.max(
                  1,
                  Math.round(((course.total_duration_minutes || 0) / 60) * 10) / 10
                );
                const instructorName = course.instructor?.full_name || 'EduSphere Faculty';
                const instructorAvatar = course.instructor?.avatar_url || FALLBACK_AVATAR;

                return (
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
                      <div className="absolute top-3 right-3 px-2 py-0.5 rounded text-[11px] font-semibold bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9] flex items-center gap-1">
                        <CheckCircle className="w-3 h-3 text-[#1B3B2B]" />
                        Free
                      </div>
                    </div>

                    <div className="p-5 flex-1 flex flex-col justify-between space-y-4">
                      <div>
                        <div className="flex items-center gap-2 text-xs text-[#535C56] mb-2 font-medium">
                          <span className="flex items-center gap-1">
                            <BarChart className="w-3.5 h-3.5 text-[#7A857E]" />
                            {course.level}
                          </span>
                          <span>•</span>
                          <span className="flex items-center gap-1">
                            <Clock className="w-3.5 h-3.5 text-[#7A857E]" />
                            {durationHours} Hours
                          </span>
                          {course.lessons_count !== undefined && course.lessons_count > 0 && (
                            <>
                              <span>•</span>
                              <span className="flex items-center gap-1">
                                <BookOpen className="w-3.5 h-3.5 text-[#7A857E]" />
                                {course.lessons_count} Lessons
                              </span>
                            </>
                          )}
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
                            src={instructorAvatar}
                            alt={instructorName}
                            className="w-6 h-6 rounded-full object-cover border border-[#E5E2D9]"
                            onError={(e) => {
                              (e.target as HTMLImageElement).src = FALLBACK_AVATAR;
                            }}
                          />
                          <span className="text-xs text-[#1F2421] font-medium truncate max-w-[130px]">
                            {instructorName}
                          </span>
                        </div>
                        <Link
                          to={`/courses/${course.id}`}
                          className="btn-forest text-xs py-1.5 px-3 shrink-0"
                        >
                          View Details
                        </Link>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          ) : (
            <div className="academic-card p-12 text-center space-y-3">
              <BookOpen className="w-10 h-10 text-[#7A857E] mx-auto" />
              <h3 className="font-editorial text-lg text-[#1F2421]">No courses match your filter criteria</h3>
              <p className="text-xs text-[#535C56]">
                Try adjusting your search query or selecting a different category.
              </p>
              <button
                onClick={() => {
                  handleSearchChange('');
                  setSelectedCategory('All Categories');
                  setSelectedLevel('All');
                }}
                className="text-xs font-semibold text-[#1B3B2B] hover:underline pt-2 cursor-pointer"
              >
                Reset All Filters
              </button>
            </div>
          )}
        </>
      )}
    </div>
  );
};
