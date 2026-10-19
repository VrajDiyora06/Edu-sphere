import React, { useState, useEffect, useCallback } from 'react';
import { useAuth } from '../context/useAuth';
import {
  getAllUserProfiles,
  updateUserRole,
  getAllCoursesAdmin,
  toggleCoursePublishAdmin,
  deleteCourseAdmin,
  getAdminAnnouncements,
  createAnnouncement,
  deleteAnnouncement,
  getSystemDiagnostics,
  getPlatformMetrics,
  type AdminCourseSummary,
  type PlatformMetrics,
} from '../lib/admin';
import type { DbProfile, DbAnnouncement, SystemDiagnosticItem, UserRole } from '../types';
import {
  Shield,
  Users,
  BookOpen,
  Megaphone,
  BarChart3,
  Terminal,
  Search,
  CheckCircle2,
  AlertCircle,
  Eye,
  EyeOff,
  Trash2,
  Loader2,
  Plus,
  X,
  RefreshCw,
  Server,
  Lock,
} from 'lucide-react';

type AdminTab = 'users' | 'courses' | 'announcements' | 'reports' | 'system_diagnostics';

export const AdminPortalPage: React.FC = () => {
  const { user, role } = useAuth();
  const [activeTab, setActiveTab] = useState<AdminTab>('users');
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  const [successMsg, setSuccessMsg] = useState<string | null>(null);

  // Users tab state
  const [users, setUsers] = useState<DbProfile[]>([]);
  const [searchUser, setSearchUser] = useState<string>('');
  const [updatingUserId, setUpdatingUserId] = useState<string | null>(null);

  // Courses tab state
  const [courses, setCourses] = useState<AdminCourseSummary[]>([]);
  const [searchCourse, setSearchCourse] = useState<string>('');
  const [courseToDelete, setCourseToDelete] = useState<AdminCourseSummary | null>(null);
  const [deletingCourse, setDeletingCourse] = useState<boolean>(false);

  // Announcements tab state
  const [announcements, setAnnouncements] = useState<DbAnnouncement[]>([]);
  const [showAnnouncementModal, setShowAnnouncementModal] = useState<boolean>(false);
  const [announcementTitle, setAnnouncementTitle] = useState<string>('');
  const [announcementContent, setAnnouncementContent] = useState<string>('');
  const [announcementPriority, setAnnouncementPriority] = useState<'low' | 'normal' | 'high' | 'urgent'>('normal');
  const [announcementPublished, setAnnouncementPublished] = useState<boolean>(true);
  const [submittingAnnouncement, setSubmittingAnnouncement] = useState<boolean>(false);

  // Reports tab state
  const [metrics, setMetrics] = useState<PlatformMetrics | null>(null);

  // Diagnostics tab state (system_admin only)
  const [diagnostics, setDiagnostics] = useState<SystemDiagnosticItem[]>([]);
  const [loadingDiagnostics, setLoadingDiagnostics] = useState<boolean>(false);

  const isSystemAdmin = role === 'system_admin';

  // Fetch initial data based on active tab
  const refreshTabData = useCallback(async (tab: AdminTab) => {
    setLoading(true);
    setError(null);

    if (tab === 'users') {
      const { data, error: err } = await getAllUserProfiles();
      if (err) setError(err.message);
      else setUsers(data || []);
    } else if (tab === 'courses') {
      const { data, error: err } = await getAllCoursesAdmin();
      if (err) setError(err.message);
      else setCourses(data || []);
    } else if (tab === 'announcements') {
      const { data, error: err } = await getAdminAnnouncements();
      if (err) setError(err.message);
      else setAnnouncements(data || []);
    } else if (tab === 'reports') {
      const { data, error: err } = await getPlatformMetrics();
      if (err) setError(err.message);
      else setMetrics(data);
    } else if (tab === 'system_diagnostics' && isSystemAdmin) {
      setLoadingDiagnostics(true);
      const { data, error: err } = await getSystemDiagnostics();
      if (err) setError(err.message);
      else setDiagnostics(data || []);
      setLoadingDiagnostics(false);
    }

    setLoading(false);
  }, [isSystemAdmin]);

  useEffect(() => {
    let ignore = false;

    async function load() {
      if (activeTab === 'users') {
        const { data, error: err } = await getAllUserProfiles();
        if (ignore) return;
        if (err) setError(err.message);
        else setUsers(data || []);
      } else if (activeTab === 'courses') {
        const { data, error: err } = await getAllCoursesAdmin();
        if (ignore) return;
        if (err) setError(err.message);
        else setCourses(data || []);
      } else if (activeTab === 'announcements') {
        const { data, error: err } = await getAdminAnnouncements();
        if (ignore) return;
        if (err) setError(err.message);
        else setAnnouncements(data || []);
      } else if (activeTab === 'reports') {
        const { data, error: err } = await getPlatformMetrics();
        if (ignore) return;
        if (err) setError(err.message);
        else setMetrics(data);
      } else if (activeTab === 'system_diagnostics' && isSystemAdmin) {
        setLoadingDiagnostics(true);
        const { data, error: err } = await getSystemDiagnostics();
        if (ignore) return;
        if (err) setError(err.message);
        else setDiagnostics(data || []);
        setLoadingDiagnostics(false);
      }
      setLoading(false);
    }

    load();

    return () => {
      ignore = true;
    };
  }, [activeTab, isSystemAdmin]);

  // Handle Role Change
  const handleRoleChange = async (targetUserId: string, newRole: UserRole) => {
    setUpdatingUserId(targetUserId);
    setError(null);

    const { success, error: roleErr } = await updateUserRole(targetUserId, newRole);
    setUpdatingUserId(null);

    if (!success) {
      setError(`Role assignment failed: ${roleErr?.message || 'Database rejected operation'}`);
    } else {
      setUsers((prev) =>
        prev.map((u) => (u.id === targetUserId ? { ...u, role: newRole } : u))
      );
      setSuccessMsg(`User role updated to "${newRole.toUpperCase()}".`);
      setTimeout(() => setSuccessMsg(null), 3500);
    }
  };

  // Handle Course Publish Toggle
  const handleCoursePublishToggle = async (courseId: string, currentPublished: boolean) => {
    const { success, error: pubErr } = await toggleCoursePublishAdmin(courseId, !currentPublished);
    if (!success) {
      setError(`Course update failed: ${pubErr?.message || 'Error updating course'}`);
    } else {
      setCourses((prev) =>
        prev.map((c) => (c.id === courseId ? { ...c, is_published: !currentPublished } : c))
      );
      setSuccessMsg(`Course publication status set to ${!currentPublished ? 'PUBLISHED' : 'DRAFT'}.`);
      setTimeout(() => setSuccessMsg(null), 3500);
    }
  };

  // Handle Delete Course Admin
  const handleConfirmDeleteCourseAdmin = async () => {
    if (!courseToDelete) return;
    setDeletingCourse(true);
    setError(null);

    const { success, error: delErr } = await deleteCourseAdmin(courseToDelete.id);
    setDeletingCourse(false);

    if (!success) {
      setError(`Failed to delete course: ${delErr?.message || 'Database rejected operation'}`);
    } else {
      const deletedTitle = courseToDelete.title;
      setCourses((prev) => prev.filter((c) => c.id !== courseToDelete.id));
      setCourseToDelete(null);
      setSuccessMsg(`Course "${deletedTitle}" and all related materials were permanently deleted.`);
      setTimeout(() => setSuccessMsg(null), 4000);
      refreshTabData('courses');
      if (activeTab === 'reports') {
        refreshTabData('reports');
      }
    }
  };

  // Handle Create Announcement
  const handleCreateAnnouncementSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user?.id || !announcementTitle.trim()) return;
    setSubmittingAnnouncement(true);

    const { data, error: annErr } = await createAnnouncement({
      title: announcementTitle,
      content: announcementContent,
      priority: announcementPriority,
      author_id: user.id,
      is_published: announcementPublished,
    });

    setSubmittingAnnouncement(false);

    if (annErr) {
      setError(`Failed to create announcement: ${annErr.message}`);
    } else if (data) {
      setAnnouncements((prev) => [data, ...prev]);
      setShowAnnouncementModal(false);
      setAnnouncementTitle('');
      setAnnouncementContent('');
      setSuccessMsg('Announcement successfully broadcasted!');
      setTimeout(() => setSuccessMsg(null), 3500);
    }
  };

  // Handle Delete Announcement
  const handleDeleteAnnouncement = async (id: string) => {
    const { success, error: delErr } = await deleteAnnouncement(id);
    if (!success) {
      setError(`Failed to delete announcement: ${delErr?.message}`);
    } else {
      setAnnouncements((prev) => prev.filter((a) => a.id !== id));
      setSuccessMsg('Announcement deleted.');
      setTimeout(() => setSuccessMsg(null), 3000);
    }
  };

  // Filtered users
  const filteredUsers = users.filter((u) => {
    const matchName = u.full_name?.toLowerCase().includes(searchUser.toLowerCase());
    const matchEmail = u.email?.toLowerCase().includes(searchUser.toLowerCase());
    const matchRole = u.role?.toLowerCase().includes(searchUser.toLowerCase());
    return matchName || matchEmail || matchRole;
  });

  // Filtered courses
  const filteredCourses = courses.filter((c) => {
    const matchTitle = c.title?.toLowerCase().includes(searchCourse.toLowerCase());
    const matchInstructor = c.instructor_name?.toLowerCase().includes(searchCourse.toLowerCase());
    return matchTitle || matchInstructor;
  });

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-8">
      
      {/* Top Banner & Security Header */}
      <div className="academic-card p-6 sm:p-8 space-y-6">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div className="space-y-1.5">
            <div className="flex items-center gap-2">
              <span className={`px-3 py-1 rounded-full text-xs font-mono font-semibold border flex items-center gap-1.5 ${
                isSystemAdmin
                  ? 'bg-[#FDF1EE] text-[#9E3D2B] border-[#F5C2BA]'
                  : 'bg-[#F4F1EA] text-[#1B3B2B] border-[#E5E2D9]'
              }`}>
                <Shield className="w-3.5 h-3.5" />
                <span>Verified Database Role: {role.toUpperCase()}</span>
              </span>
              <span className="text-[11px] text-[#535C56] font-mono">
                PostgreSQL Role-Based Access Control
              </span>
            </div>
            <h1 className="font-editorial text-2xl sm:text-3xl text-[#1F2421]">
              Administrator Portal
            </h1>
            <p className="text-xs sm:text-sm text-[#535C56] max-w-2xl leading-relaxed">
              User directory administration, database role elevation, course oversight, platform announcements, and technical diagnostics.
            </p>
          </div>

          <div className="flex items-center gap-2">
            <button
              onClick={() => refreshTabData(activeTab)}
              className="btn-secondary inline-flex items-center gap-2 px-3.5 py-2 text-xs font-semibold cursor-pointer"
              title="Refresh Tab"
            >
              <RefreshCw className="w-3.5 h-3.5 text-[#1B3B2B]" />
              <span>Refresh</span>
            </button>
          </div>
        </div>

        {/* Tab Navigation */}
        <div className="flex items-center gap-2 pt-4 border-t border-[#E5E2D9] overflow-x-auto">
          <button
            onClick={() => setActiveTab('users')}
            className={`px-4 py-2 rounded text-xs font-semibold transition-all flex items-center gap-2 whitespace-nowrap cursor-pointer ${
              activeTab === 'users'
                ? 'bg-[#1B3B2B] text-[#FAF9F5]'
                : 'text-[#535C56] hover:text-[#1F2421] hover:bg-[#F4F1EA]'
            }`}
          >
            <Users className="w-3.5 h-3.5" />
            <span>User Management</span>
          </button>

          <button
            onClick={() => setActiveTab('courses')}
            className={`px-4 py-2 rounded text-xs font-semibold transition-all flex items-center gap-2 whitespace-nowrap cursor-pointer ${
              activeTab === 'courses'
                ? 'bg-[#1B3B2B] text-[#FAF9F5]'
                : 'text-[#535C56] hover:text-[#1F2421] hover:bg-[#F4F1EA]'
            }`}
          >
            <BookOpen className="w-3.5 h-3.5" />
            <span>Course Oversight</span>
          </button>

          <button
            onClick={() => setActiveTab('announcements')}
            className={`px-4 py-2 rounded text-xs font-semibold transition-all flex items-center gap-2 whitespace-nowrap cursor-pointer ${
              activeTab === 'announcements'
                ? 'bg-[#1B3B2B] text-[#FAF9F5]'
                : 'text-[#535C56] hover:text-[#1F2421] hover:bg-[#F4F1EA]'
            }`}
          >
            <Megaphone className="w-3.5 h-3.5" />
            <span>Announcements</span>
          </button>

          <button
            onClick={() => setActiveTab('reports')}
            className={`px-4 py-2 rounded text-xs font-semibold transition-all flex items-center gap-2 whitespace-nowrap cursor-pointer ${
              activeTab === 'reports'
                ? 'bg-[#1B3B2B] text-[#FAF9F5]'
                : 'text-[#535C56] hover:text-[#1F2421] hover:bg-[#F4F1EA]'
            }`}
          >
            <BarChart3 className="w-3.5 h-3.5" />
            <span>Platform Reports</span>
          </button>

          {isSystemAdmin && (
            <button
              onClick={() => setActiveTab('system_diagnostics')}
              className={`px-4 py-2 rounded text-xs font-semibold transition-all flex items-center gap-2 whitespace-nowrap cursor-pointer ${
                activeTab === 'system_diagnostics'
                  ? 'bg-[#1B3B2B] text-[#FAF9F5]'
                  : 'text-[#535C56] hover:text-[#1F2421] hover:bg-[#F4F1EA]'
              }`}
            >
              <Terminal className="w-3.5 h-3.5" />
              <span>System Diagnostics</span>
            </button>
          )}
        </div>
      </div>

      {/* Notifications */}
      {error && (
        <div className="p-4 rounded bg-[#FDF1EE] border border-[#F5C2BA] text-[#9E3D2B] text-xs flex items-center justify-between gap-3">
          <div className="flex items-center gap-2">
            <AlertCircle className="w-4 h-4 shrink-0 text-[#9E3D2B]" />
            <span>{error}</span>
          </div>
          <button onClick={() => setError(null)} className="text-[#9E3D2B] hover:opacity-75 cursor-pointer">
            <X className="w-4 h-4" />
          </button>
        </div>
      )}

      {successMsg && (
        <div className="p-4 rounded bg-[#F4F1EA] border border-[#E5E2D9] text-[#1B3B2B] text-xs flex items-center justify-between gap-3">
          <div className="flex items-center gap-2">
            <CheckCircle2 className="w-4 h-4 shrink-0 text-[#1B3B2B]" />
            <span>{successMsg}</span>
          </div>
          <button onClick={() => setSuccessMsg(null)} className="text-[#1B3B2B] hover:opacity-75 cursor-pointer">
            <X className="w-4 h-4" />
          </button>
        </div>
      )}

      {/* TAB 1: USER MANAGEMENT */}
      {activeTab === 'users' && (
        <div className="space-y-6">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div className="space-y-0.5">
              <h2 className="font-editorial text-xl sm:text-2xl text-[#1F2421] flex items-center gap-2">
                <Users className="w-5 h-5 text-[#1B3B2B]" />
                <span>User Directory & Role Assignment</span>
              </h2>
              <p className="text-xs text-[#535C56]">
                Directly queries <code className="text-[#1B3B2B] font-mono">public.profiles</code>. Role changes are validated and enforced via <code className="text-[#1B3B2B] font-mono">admin_set_user_role</code> RPC.
              </p>
            </div>

            <div className="relative w-full sm:w-72">
              <Search className="w-4 h-4 text-[#7A857E] absolute left-3 top-1/2 -translate-y-1/2" />
              <input
                type="text"
                placeholder="Search user by name or email..."
                value={searchUser}
                onChange={(e) => setSearchUser(e.target.value)}
                className="w-full pl-9 pr-3 py-2 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] placeholder-[#7A857E] focus:outline-none focus:border-[#1B3B2B]"
              />
            </div>
          </div>

          {loading ? (
            <div className="academic-card p-16 text-center">
              <Loader2 className="w-6 h-6 text-[#1B3B2B] animate-spin mx-auto" />
            </div>
          ) : (
            <div className="bg-[#FAF9F5] rounded border border-[#E5E2D9] overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full text-left text-xs">
                  <thead className="bg-[#F4F1EA] text-[#535C56] border-b border-[#E5E2D9] uppercase tracking-wider font-mono text-[10px]">
                    <tr>
                      <th className="py-3 px-4">User</th>
                      <th className="py-3 px-4">Email</th>
                      <th className="py-3 px-4">Current Role</th>
                      <th className="py-3 px-4">Assign Role (DB RPC)</th>
                      <th className="py-3 px-4">Registered</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-[#E5E2D9]">
                    {filteredUsers.length === 0 ? (
                      <tr>
                        <td colSpan={5} className="py-8 text-center text-[#535C56] italic">
                          No users matching search query.
                        </td>
                      </tr>
                    ) : (
                      filteredUsers.map((u) => {
                        const isCaller = u.id === user?.id;
                        const isUpdating = updatingUserId === u.id;

                        return (
                          <tr key={u.id} className="hover:bg-[#F4F1EA]/50 transition-colors">
                            <td className="py-3.5 px-4">
                              <div className="flex items-center gap-3">
                                <img
                                  src={u.avatar_url || 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=120&auto=format&fit=crop'}
                                  alt={u.full_name}
                                  className="w-8 h-8 rounded-full object-cover border border-[#E5E2D9] shrink-0"
                                />
                                <div>
                                  <div className="font-semibold text-[#1F2421] flex items-center gap-1.5">
                                    <span>{u.full_name}</span>
                                    {isCaller && (
                                      <span className="text-[10px] px-1.5 py-0.2 rounded bg-[#F4F1EA] text-[#1B3B2B] border border-[#E5E2D9] font-mono font-semibold">
                                        You
                                      </span>
                                    )}
                                  </div>
                                  <div className="text-[10px] text-[#535C56] font-mono">
                                    UUID: {u.id.substring(0, 8)}...
                                  </div>
                                </div>
                              </div>
                            </td>

                            <td className="py-3.5 px-4 font-mono text-[#535C56]">
                              {u.email || 'Protected/Hidden'}
                            </td>

                            <td className="py-3.5 px-4">
                              <span
                                className={`inline-block px-2.5 py-1 rounded-full text-[11px] font-semibold border capitalize ${
                                  u.role === 'system_admin'
                                    ? 'bg-[#FDF1EE] text-[#9E3D2B] border-[#F5C2BA]'
                                    : u.role === 'admin'
                                    ? 'bg-[#F4F1EA] text-[#B57424] border-[#E5E2D9]'
                                    : u.role === 'instructor'
                                    ? 'bg-[#F4F1EA] text-[#1B3B2B] border-[#E5E2D9]'
                                    : 'bg-[#FAF9F5] text-[#535C56] border-[#E5E2D9]'
                                }`}
                              >
                                {u.role.replace('_', ' ')}
                              </span>
                            </td>

                            <td className="py-3.5 px-4">
                              <div className="flex items-center gap-2">
                                <select
                                  disabled={isUpdating}
                                  value={u.role}
                                  onChange={(e) => handleRoleChange(u.id, e.target.value as UserRole)}
                                  className="px-2.5 py-1.5 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B] disabled:opacity-50"
                                >
                                  <option value="student">Student</option>
                                  <option value="instructor">Instructor</option>
                                  <option value="admin">Administrator</option>
                                  <option value="system_admin" disabled={!isSystemAdmin}>
                                    System Admin {!isSystemAdmin ? '(Restricted)' : ''}
                                  </option>
                                </select>
                                {isUpdating && <Loader2 className="w-3.5 h-3.5 text-[#1B3B2B] animate-spin" />}
                              </div>
                            </td>

                            <td className="py-3.5 px-4 text-[#535C56] font-mono text-[11px]">
                              {u.created_at ? new Date(u.created_at).toLocaleDateString() : 'N/A'}
                            </td>
                          </tr>
                        );
                      })
                    )}
                  </tbody>
                </table>
              </div>
            </div>
          )}
        </div>
      )}

      {/* TAB 2: COURSE OVERSIGHT */}
      {activeTab === 'courses' && (
        <div className="space-y-6">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div className="space-y-0.5">
              <h2 className="font-editorial text-xl sm:text-2xl text-[#1F2421] flex items-center gap-2">
                <BookOpen className="w-5 h-5 text-[#1B3B2B]" />
                <span>Platform Course Oversight</span>
              </h2>
              <p className="text-xs text-[#535C56]">
                Inspect, review, and toggle public availability for courses across all instructors.
              </p>
            </div>

            <div className="relative w-full sm:w-72">
              <Search className="w-4 h-4 text-[#7A857E] absolute left-3 top-1/2 -translate-y-1/2" />
              <input
                type="text"
                placeholder="Search course title or instructor..."
                value={searchCourse}
                onChange={(e) => setSearchCourse(e.target.value)}
                className="w-full pl-9 pr-3 py-2 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] placeholder-[#7A857E] focus:outline-none focus:border-[#1B3B2B]"
              />
            </div>
          </div>

          {loading ? (
            <div className="academic-card p-16 text-center">
              <Loader2 className="w-6 h-6 text-[#1B3B2B] animate-spin mx-auto" />
            </div>
          ) : (
            <div className="bg-[#FAF9F5] rounded border border-[#E5E2D9] overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full text-left text-xs">
                  <thead className="bg-[#F4F1EA] text-[#535C56] border-b border-[#E5E2D9] uppercase tracking-wider font-mono text-[10px]">
                    <tr>
                      <th className="py-3 px-4">Course</th>
                      <th className="py-3 px-4">Instructor</th>
                      <th className="py-3 px-4">Category</th>
                      <th className="py-3 px-4">Lessons / Enrolled</th>
                      <th className="py-3 px-4">Status</th>
                      <th className="py-3 px-4">Actions</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-[#E5E2D9]">
                    {filteredCourses.length === 0 ? (
                      <tr>
                        <td colSpan={6} className="py-8 text-center text-[#535C56] italic">
                          No courses found.
                        </td>
                      </tr>
                    ) : (
                      filteredCourses.map((c) => (
                        <tr key={c.id} className="hover:bg-[#F4F1EA]/50 transition-colors">
                          <td className="py-3.5 px-4">
                            <div className="font-semibold text-[#1F2421]">{c.title}</div>
                            <div className="text-[10px] text-[#535C56] font-mono">{c.slug}</div>
                          </td>

                          <td className="py-3.5 px-4 text-[#1F2421] font-medium">
                            {c.instructor_name}
                          </td>

                          <td className="py-3.5 px-4 text-[#535C56]">
                            {c.category}
                          </td>

                          <td className="py-3.5 px-4 font-mono text-[#535C56]">
                            {c.lessons_count || 0} lessons • {c.enrollments_count || 0} students
                          </td>

                          <td className="py-3.5 px-4">
                            <span
                              className={`px-2 py-0.5 rounded-full text-[10px] font-semibold border ${
                                c.is_published
                                  ? 'bg-[#F4F1EA] text-[#1B3B2B] border-[#E5E2D9]'
                                  : 'bg-[#FAF9F5] text-[#535C56] border-[#E5E2D9]'
                              }`}
                            >
                              {c.is_published ? 'Published' : 'Draft'}
                            </span>
                          </td>

                          <td className="py-3.5 px-4">
                            <div className="flex items-center gap-2">
                              <button
                                onClick={() => handleCoursePublishToggle(c.id, c.is_published)}
                                className={`px-2.5 py-1.5 rounded text-xs font-semibold border transition-all flex items-center gap-1.5 cursor-pointer ${
                                  c.is_published
                                    ? 'bg-[#FAF9F5] hover:bg-[#F4F1EA] text-[#535C56] border-[#E5E2D9]'
                                    : 'btn-forest'
                                }`}
                                title={c.is_published ? 'Unpublish from public catalog' : 'Publish to public catalog'}
                              >
                                {c.is_published ? <EyeOff className="w-3 h-3" /> : <Eye className="w-3 h-3" />}
                                <span>{c.is_published ? 'Unpublish' : 'Publish'}</span>
                              </button>

                              <button
                                onClick={() => setCourseToDelete(c)}
                                className="p-1.5 rounded border border-[#E5E2D9] bg-[#FAF9F5] hover:bg-[#FDF1EE] text-[#7A857E] hover:text-[#9E3D2B] transition-colors cursor-pointer"
                                title="Permanently delete course"
                              >
                                <Trash2 className="w-3.5 h-3.5" />
                              </button>
                            </div>
                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </div>
            </div>
          )}
        </div>
      )}

      {/* TAB 3: ANNOUNCEMENTS */}
      {activeTab === 'announcements' && (
        <div className="space-y-6">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div className="space-y-0.5">
              <h2 className="font-editorial text-xl sm:text-2xl text-[#1F2421] flex items-center gap-2">
                <Megaphone className="w-5 h-5 text-[#1B3B2B]" />
                <span>Platform Announcements</span>
              </h2>
              <p className="text-xs text-[#535C56]">
                Broadcast official platform notices to students and instructors via <code className="text-[#1B3B2B] font-mono">public.announcements</code>.
              </p>
            </div>

            <button
              onClick={() => setShowAnnouncementModal(true)}
              className="btn-forest inline-flex items-center gap-2 px-4 py-2 text-xs font-semibold cursor-pointer"
            >
              <Plus className="w-4 h-4" />
              <span>New Announcement</span>
            </button>
          </div>

          {loading ? (
            <div className="academic-card p-16 text-center">
              <Loader2 className="w-6 h-6 text-[#1B3B2B] animate-spin mx-auto" />
            </div>
          ) : (
            <div className="space-y-3">
              {announcements.length === 0 ? (
                <div className="academic-card p-12 text-center space-y-2">
                  <Megaphone className="w-8 h-8 text-[#7A857E] mx-auto" />
                  <p className="text-xs text-[#535C56]">No platform announcements created yet.</p>
                </div>
              ) : (
                announcements.map((ann) => (
                  <div
                    key={ann.id}
                    className="p-5 rounded bg-[#FAF9F5] border border-[#E5E2D9] flex items-start justify-between gap-4"
                  >
                    <div className="space-y-1.5">
                      <div className="flex items-center gap-2">
                        <span
                          className={`px-2 py-0.5 rounded text-[10px] font-mono font-bold uppercase border ${
                            ann.priority === 'urgent'
                              ? 'bg-[#FDF1EE] text-[#9E3D2B] border-[#F5C2BA]'
                              : ann.priority === 'high'
                              ? 'bg-[#F4F1EA] text-[#B57424] border-[#E5E2D9]'
                              : 'bg-[#F4F1EA] text-[#1B3B2B] border-[#E5E2D9]'
                          }`}
                        >
                          {ann.priority}
                        </span>
                        <h4 className="text-sm font-semibold text-[#1F2421]">{ann.title}</h4>
                        <span className="text-[10px] text-[#535C56] font-mono">
                          {new Date(ann.created_at).toLocaleDateString()}
                        </span>
                      </div>
                      <p className="text-xs text-[#535C56] leading-relaxed max-w-3xl">
                        {ann.content}
                      </p>
                    </div>

                    <button
                      onClick={() => handleDeleteAnnouncement(ann.id)}
                      className="p-2 rounded border border-[#E5E2D9] bg-[#FAF9F5] text-[#7A857E] hover:text-[#9E3D2B] hover:bg-[#FDF1EE] transition-colors cursor-pointer"
                      title="Delete Announcement"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                ))
              )}
            </div>
          )}
        </div>
      )}

      {/* TAB 4: PLATFORM REPORTS */}
      {activeTab === 'reports' && (
        <div className="space-y-6">
          <div className="space-y-0.5">
            <h2 className="font-editorial text-xl sm:text-2xl text-[#1F2421] flex items-center gap-2">
              <BarChart3 className="w-5 h-5 text-[#1B3B2B]" />
              <span>Platform Statistics & Reports</span>
            </h2>
            <p className="text-xs text-[#535C56]">
              Aggregated platform metrics across registered users, course publications, and enrollment completions.
            </p>
          </div>

          {loading || !metrics ? (
            <div className="academic-card p-16 text-center">
              <Loader2 className="w-6 h-6 text-[#1B3B2B] animate-spin mx-auto" />
            </div>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
              <div className="p-5 rounded border border-[#E5E2D9] bg-[#FAF9F5] space-y-1">
                <span className="text-xs text-[#535C56]">Total Registered Users</span>
                <div className="font-editorial text-2xl text-[#1F2421] font-mono">{metrics.totalUsers}</div>
                <div className="text-[10px] text-[#535C56]">Students: {metrics.totalStudents} • Instructors: {metrics.totalInstructors}</div>
              </div>

              <div className="p-5 rounded border border-[#E5E2D9] bg-[#FAF9F5] space-y-1">
                <span className="text-xs text-[#535C56]">Platform Courses</span>
                <div className="font-editorial text-2xl text-[#1B3B2B] font-mono">{metrics.totalCourses}</div>
                <div className="text-[10px] text-[#535C56]">{metrics.publishedCourses} published in catalog</div>
              </div>

              <div className="p-5 rounded border border-[#E5E2D9] bg-[#FAF9F5] space-y-1">
                <span className="text-xs text-[#535C56]">Total Enrollments</span>
                <div className="font-editorial text-2xl text-[#1F2421] font-mono">{metrics.totalEnrollments}</div>
                <div className="text-[10px] text-[#535C56]">{metrics.completedEnrollments} completed milestones</div>
              </div>

              <div className="p-5 rounded border border-[#E5E2D9] bg-[#FAF9F5] space-y-1">
                <span className="text-xs text-[#535C56]">Completion Rate</span>
                <div className="font-editorial text-2xl text-[#1B3B2B] font-mono">
                  {metrics.totalEnrollments > 0
                    ? Math.round((metrics.completedEnrollments / metrics.totalEnrollments) * 100)
                    : 0}
                  %
                </div>
                <div className="text-[10px] text-[#535C56]">Milestone achievements</div>
              </div>
            </div>
          )}
        </div>
      )}

      {/* TAB 5: SYSTEM DIAGNOSTICS (system_admin only) */}
      {activeTab === 'system_diagnostics' && isSystemAdmin && (
        <div className="space-y-6">
          <div className="space-y-0.5">
            <h2 className="font-editorial text-xl sm:text-2xl text-[#1F2421] flex items-center gap-2">
              <Terminal className="w-5 h-5 text-[#1B3B2B]" />
              <span>System Administrator Technical RBAC Diagnostics</span>
            </h2>
            <p className="text-xs text-[#535C56]">
              Live server-side execution of database procedure <code className="text-[#1B3B2B] font-mono">get_system_rbac_diagnostics()</code>.
            </p>
          </div>

          {loadingDiagnostics ? (
            <div className="academic-card p-16 text-center">
              <Loader2 className="w-6 h-6 text-[#1B3B2B] animate-spin mx-auto" />
              <p className="text-xs text-[#535C56] mt-2 font-mono">Executing database security assertions...</p>
            </div>
          ) : (
            <div className="space-y-4">
              <div className="bg-[#FAF9F5] rounded border border-[#E5E2D9] overflow-hidden">
                <table className="w-full text-left text-xs">
                  <thead className="bg-[#F4F1EA] text-[#535C56] border-b border-[#E5E2D9] uppercase tracking-wider font-mono text-[10px]">
                    <tr>
                      <th className="py-3 px-4">Diagnostic Metric</th>
                      <th className="py-3 px-4">Metric Value</th>
                      <th className="py-3 px-4">Status Assertion</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-[#E5E2D9] font-mono">
                    {diagnostics.length === 0 ? (
                      <tr>
                        <td colSpan={3} className="py-8 text-center text-[#535C56] italic">
                          No diagnostics returned or RPC procedure unavailable.
                        </td>
                      </tr>
                    ) : (
                      diagnostics.map((d, idx) => (
                        <tr key={idx} className="hover:bg-[#F4F1EA]/50">
                          <td className="py-3.5 px-4 text-[#1F2421] font-semibold flex items-center gap-2">
                            <Server className="w-3.5 h-3.5 text-[#1B3B2B]" />
                            <span>{d.metric_name}</span>
                          </td>
                          <td className="py-3.5 px-4 text-[#535C56]">
                            {d.metric_value}
                          </td>
                          <td className="py-3.5 px-4">
                            <span
                              className={`px-2.5 py-0.5 rounded-full text-[10px] font-bold border ${
                                d.status === 'OPTIMAL' || d.status === 'ENFORCED' || d.status === 'SECURE' || d.status === 'ACTIVE'
                                  ? 'bg-[#F4F1EA] text-[#1B3B2B] border-[#E5E2D9]'
                                  : 'bg-[#FDF1EE] text-[#9E3D2B] border-[#F5C2BA]'
                              }`}
                            >
                              {d.status}
                            </span>
                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </div>

              <div className="bg-[#F4F1EA] p-5 rounded border border-[#E5E2D9] space-y-2">
                <h4 className="text-xs font-semibold text-[#1F2421] flex items-center gap-2">
                  <Lock className="w-4 h-4 text-[#1B3B2B]" />
                  <span>Security Compliance Summary</span>
                </h4>
                <p className="text-[11px] text-[#535C56] leading-relaxed">
                  PostgreSQL Row Level Security (RLS) is active on all core tables (<code className="text-[#1B3B2B]">profiles</code>, <code className="text-[#1B3B2B]">courses</code>, <code className="text-[#1B3B2B]">lessons</code>, <code className="text-[#1B3B2B]">enrollments</code>, <code className="text-[#1B3B2B]">announcements</code>). Role immutability trigger <code className="text-[#1B3B2B]">trg_protect_profile_role</code> prevents non-admin role mutation.
                </p>
              </div>
            </div>
          )}
        </div>
      )}

      {/* Create Announcement Modal */}
      {showAnnouncementModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-[#1F2421]/60 backdrop-blur-xs animate-in fade-in">
          <div className="w-full max-w-lg bg-[#FAF9F5] rounded border border-[#E5E2D9] p-6 sm:p-8 space-y-5 shadow-xl">
            <div className="flex items-center justify-between pb-3 border-b border-[#E5E2D9]">
              <h3 className="font-editorial text-lg text-[#1F2421] flex items-center gap-2">
                <Megaphone className="w-4 h-4 text-[#1B3B2B]" />
                <span>Broadcast Platform Announcement</span>
              </h3>
              <button
                onClick={() => setShowAnnouncementModal(false)}
                className="p-1.5 text-[#535C56] hover:text-[#1F2421] rounded hover:bg-[#F4F1EA] transition-colors cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <form onSubmit={handleCreateAnnouncementSubmit} className="space-y-4">
              <div className="space-y-1">
                <label className="text-xs font-semibold text-[#1F2421]">Title</label>
                <input
                  type="text"
                  required
                  placeholder="e.g., Scheduled Maintenance or New Curriculum Release"
                  value={announcementTitle}
                  onChange={(e) => setAnnouncementTitle(e.target.value)}
                  className="w-full px-3 py-2 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B]"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div className="space-y-1">
                  <label className="text-xs font-semibold text-[#1F2421]">Priority</label>
                  <select
                    value={announcementPriority}
                    onChange={(e) => setAnnouncementPriority(e.target.value as 'low' | 'normal' | 'high' | 'urgent')}
                    className="w-full px-3 py-2 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B]"
                  >
                    <option value="low">Low</option>
                    <option value="normal">Normal</option>
                    <option value="high">High</option>
                    <option value="urgent">Urgent</option>
                  </select>
                </div>
                <div className="space-y-1">
                  <label className="text-xs font-semibold text-[#1F2421]">Status</label>
                  <select
                    value={announcementPublished ? 'published' : 'draft'}
                    onChange={(e) => setAnnouncementPublished(e.target.value === 'published')}
                    className="w-full px-3 py-2 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B]"
                  >
                    <option value="published">Published</option>
                    <option value="draft">Draft</option>
                  </select>
                </div>
              </div>

              <div className="space-y-1">
                <label className="text-xs font-semibold text-[#1F2421]">Content</label>
                <textarea
                  required
                  rows={4}
                  placeholder="Full text of the announcement message..."
                  value={announcementContent}
                  onChange={(e) => setAnnouncementContent(e.target.value)}
                  className="w-full px-3 py-2 rounded bg-[#FAF9F5] border border-[#E5E2D9] text-xs text-[#1F2421] focus:outline-none focus:border-[#1B3B2B] resize-none"
                />
              </div>

              <div className="pt-3 flex items-center justify-end gap-3 border-t border-[#E5E2D9]">
                <button
                  type="button"
                  onClick={() => setShowAnnouncementModal(false)}
                  className="btn-secondary px-4 py-2 text-xs font-semibold cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={submittingAnnouncement || !announcementTitle.trim()}
                  className="btn-forest inline-flex items-center gap-2 px-5 py-2 text-xs font-semibold cursor-pointer disabled:opacity-50"
                >
                  {submittingAnnouncement ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : <Megaphone className="w-3.5 h-3.5" />}
                  <span>Publish</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Admin Course Deletion Confirmation Modal */}
      {courseToDelete && (
        <div className="fixed inset-0 bg-[#1F2421]/60 backdrop-blur-xs z-50 flex items-center justify-center p-4">
          <div className="bg-[#FAF9F5] rounded max-w-md w-full p-6 shadow-xl border border-[#E5E2D9] space-y-5 animate-in fade-in duration-200">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded bg-[#FDF1EE] border border-[#F5C2BA] flex items-center justify-center text-[#9E3D2B] shrink-0">
                <Trash2 className="w-5 h-5" />
              </div>
              <div>
                <h3 className="font-editorial text-lg text-[#1F2421]">
                  Delete Course (Admin Oversight)
                </h3>
                <p className="text-xs text-[#535C56]">
                  Administrative deletion removes the course and all associated records.
                </p>
              </div>
            </div>

            <div className="p-4 rounded bg-[#F4F1EA] border border-[#E5E2D9] space-y-2 text-xs text-[#1F2421]">
              <p>
                Are you sure you want to permanently delete:
              </p>
              <p className="font-semibold text-[#1F2421] text-sm break-words">
                "{courseToDelete.title}"
              </p>
              <p className="text-[#535C56] text-[11px]">
                Authored by: <strong className="text-[#1F2421]">{courseToDelete.instructor_name}</strong>
              </p>
              <div className="pt-2 text-[11px] text-[#9E3D2B] space-y-1 border-t border-[#E5E2D9]">
                <p className="font-semibold">Associated data that will be deleted:</p>
                <ul className="list-disc list-inside space-y-0.5 text-[#535C56]">
                  <li>{courseToDelete.lessons_count || 0} lessons</li>
                  <li>All quizzes, questions, and attempts</li>
                  <li>All assignments, submissions, and storage files</li>
                  <li>{courseToDelete.enrollments_count || 0} student enrollments</li>
                </ul>
              </div>
            </div>

            <div className="flex items-center justify-end gap-3 pt-2">
              <button
                type="button"
                onClick={() => setCourseToDelete(null)}
                disabled={deletingCourse}
                className="btn-secondary px-4 py-2.5 text-xs font-semibold cursor-pointer disabled:opacity-50"
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={handleConfirmDeleteCourseAdmin}
                disabled={deletingCourse}
                className="inline-flex items-center gap-2 px-5 py-2.5 rounded bg-[#9E3D2B] hover:bg-[#833223] text-[#FAF9F5] text-xs font-semibold shadow-xs transition-colors cursor-pointer disabled:opacity-50"
              >
                {deletingCourse ? (
                  <>
                    <Loader2 className="w-4 h-4 animate-spin" />
                    <span>Deleting Course...</span>
                  </>
                ) : (
                  <>
                    <Trash2 className="w-4 h-4" />
                    <span>Confirm & Delete Course</span>
                  </>
                )}
              </button>
            </div>
          </div>
        </div>
      )}

    </div>
  );
};
