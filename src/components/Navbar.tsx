import React, { useState } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/useAuth';
import { BookOpen, LogOut, Shield, GraduationCap, Menu, X, LayoutDashboard, Compass } from 'lucide-react';
import type { UserRole } from '../types';

export const Navbar: React.FC = () => {
  const { role, user, logout } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const roleBadgeStyles: Record<UserRole, string> = {
    guest: 'bg-[#F4F1EA] text-[#4A524D] border-[#E5E2D9]',
    student: 'bg-[#F0F4F1] text-[#1B3B2B] border-[#D1DDD5]',
    instructor: 'bg-[#EEF4FB] text-[#2B5C8F] border-[#D3E2F2]',
    admin: 'bg-[#FBF4EB] text-[#8C5311] border-[#F0DEC7]',
    system_admin: 'bg-[#FDF1EE] text-[#8B3020] border-[#F6D6CF]',
  };

  const defaultAvatar =
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=120&auto=format&fit=crop';

  const isActive = (path: string) => {
    if (path === '/' && location.pathname === '/') return true;
    if (path !== '/' && location.pathname.startsWith(path)) return true;
    return false;
  };

  return (
    <nav className="sticky top-0 z-50 bg-[#FAF9F5]/95 backdrop-blur-md border-b border-[#E5E2D9] transition-all">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16 sm:h-18">
          
          {/* Logo & Academic Brandmark */}
          <Link to="/" className="flex items-center gap-3 group focus:outline-none">
            <div className="w-9 h-9 rounded bg-[#1B3B2B] flex items-center justify-center text-[#FAF9F5] shadow-xs group-hover:bg-[#12281D] transition-colors">
              <GraduationCap className="w-5 h-5 text-[#FAF9F5]" />
            </div>
            <div className="flex flex-col">
              <span className="font-editorial text-2xl font-semibold tracking-tight text-[#1F2421] leading-none">
                EduSphere
              </span>
              <span className="text-[10px] tracking-widest uppercase text-[#6C756F] font-semibold mt-1">
                Academic Courseware
              </span>
            </div>
          </Link>

          {/* Desktop Navigation */}
          <div className="hidden md:flex items-center gap-1 lg:gap-1.5">
            <Link
              to="/courses"
              className={`px-3 py-1.5 rounded text-xs font-medium tracking-wide transition-colors flex items-center gap-1.5 ${
                isActive('/courses')
                  ? 'text-[#1B3B2B] bg-[#EBF1ED] font-semibold'
                  : 'text-[#4A524D] hover:text-[#1F2421] hover:bg-[#F4F1EA]'
              }`}
            >
              <Compass className="w-3.5 h-3.5" />
              <span>Curriculum & Catalog</span>
            </Link>

            {role === 'student' && (
              <Link
                to="/dashboard"
                className={`px-3 py-1.5 rounded text-xs font-medium tracking-wide transition-colors flex items-center gap-1.5 ${
                  isActive('/dashboard')
                    ? 'text-[#1B3B2B] bg-[#EBF1ED] font-semibold'
                    : 'text-[#4A524D] hover:text-[#1F2421] hover:bg-[#F4F1EA]'
                }`}
              >
                <LayoutDashboard className="w-3.5 h-3.5" />
                <span>My Dashboard</span>
              </Link>
            )}

            {(role === 'instructor' || role === 'admin' || role === 'system_admin') && (
              <Link
                to="/instructor"
                className={`px-3 py-1.5 rounded text-xs font-medium tracking-wide transition-colors flex items-center gap-1.5 ${
                  isActive('/instructor')
                    ? 'text-[#1B3B2B] bg-[#EBF1ED] font-semibold'
                    : 'text-[#4A524D] hover:text-[#1F2421] hover:bg-[#F4F1EA]'
                }`}
              >
                <BookOpen className="w-3.5 h-3.5" />
                <span>Instructor Studio</span>
              </Link>
            )}

            {(role === 'admin' || role === 'system_admin') && (
              <Link
                to="/admin"
                className={`px-3 py-1.5 rounded text-xs font-medium tracking-wide transition-colors flex items-center gap-1.5 ${
                  isActive('/admin')
                    ? 'text-[#8C5311] bg-[#FBF4EB] font-semibold'
                    : 'text-[#4A524D] hover:text-[#1F2421] hover:bg-[#F4F1EA]'
                }`}
              >
                <Shield className="w-3.5 h-3.5" />
                <span>Admin Oversight</span>
              </Link>
            )}
          </div>

          {/* Right Action Controls */}
          <div className="hidden md:flex items-center gap-3">
            {user ? (
              <div className="flex items-center gap-3 pl-3 border-l border-[#E5E2D9]">
                {/* Database Role Badge */}
                <div
                  className={`text-[11px] px-2.5 py-0.5 rounded border font-medium flex items-center gap-1 ${
                    roleBadgeStyles[role as UserRole] || 'bg-[#F4F1EA] text-[#4A524D] border-[#E5E2D9]'
                  }`}
                  title="Verified profile access level"
                >
                  <Shield className="w-2.5 h-2.5" />
                  <span className="capitalize">{role.replace('_', ' ')}</span>
                </div>

                <div className="flex items-center gap-2.5">
                  <img
                    src={user.avatarUrl || defaultAvatar}
                    alt={user.fullName}
                    className="w-7 h-7 rounded-full border border-[#D8D4C8] object-cover"
                  />
                  <div className="flex flex-col text-left">
                    <span className="text-xs font-semibold text-[#1F2421] max-w-[130px] truncate leading-tight">
                      {user.fullName}
                    </span>
                    <span className="text-[10px] text-[#6C756F] truncate max-w-[130px]">
                      {user.email}
                    </span>
                  </div>
                </div>

                <button
                  onClick={() => {
                    logout();
                    navigate('/');
                  }}
                  className="p-1.5 text-[#6C756F] hover:text-[#8B3020] hover:bg-[#FDF1EE] rounded transition-colors"
                  title="Sign Out"
                  aria-label="Sign Out"
                >
                  <LogOut className="w-3.5 h-3.5" />
                </button>
              </div>
            ) : (
              <div className="flex items-center gap-2">
                <Link
                  to="/login"
                  className="text-xs font-medium text-[#1F2421] hover:text-[#1B3B2B] px-3.5 py-1.5 rounded hover:bg-[#F4F1EA] transition-colors"
                >
                  Sign In
                </Link>
                <Link
                  to="/register"
                  className="btn-forest text-xs py-1.5 px-3.5"
                >
                  Enroll Free
                </Link>
              </div>
            )}
          </div>

          {/* Mobile Menu Button */}
          <div className="md:hidden flex items-center gap-2">
            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="p-2 text-[#4A524D] hover:text-[#1F2421] rounded hover:bg-[#F4F1EA] transition-colors"
              aria-label={mobileMenuOpen ? 'Close Menu' : 'Open Menu'}
            >
              {mobileMenuOpen ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
            </button>
          </div>

        </div>
      </div>

      {/* Mobile Drawer */}
      {mobileMenuOpen && (
        <div className="md:hidden border-b border-[#E5E2D9] bg-[#FAF9F5] px-4 pt-3 pb-5 space-y-3 shadow-md">
          {user && (
            <div className="p-3 bg-[#FFFFFF] rounded border border-[#E5E2D9] flex items-center justify-between mb-2">
              <div className="flex items-center gap-2.5">
                <img
                  src={user.avatarUrl || defaultAvatar}
                  alt={user.fullName}
                  className="w-8 h-8 rounded-full border border-[#D8D4C8] object-cover"
                />
                <div>
                  <div className="text-xs font-bold text-[#1F2421]">{user.fullName}</div>
                  <div className="text-[11px] text-[#6C756F]">{user.email}</div>
                </div>
              </div>
              <div
                className={`text-[11px] px-2 py-0.5 rounded border font-medium capitalize ${
                  roleBadgeStyles[role as UserRole]
                }`}
              >
                {role.replace('_', ' ')}
              </div>
            </div>
          )}

          <div className="space-y-1">
            <Link
              to="/courses"
              onClick={() => setMobileMenuOpen(false)}
              className={`block px-3 py-2 rounded text-xs font-medium ${
                isActive('/courses') ? 'text-[#1B3B2B] bg-[#EBF1ED] font-bold' : 'text-[#4A524D] hover:bg-[#F4F1EA]'
              }`}
            >
              Curriculum & Catalog
            </Link>

            {role === 'student' && (
              <Link
                to="/dashboard"
                onClick={() => setMobileMenuOpen(false)}
                className={`block px-3 py-2 rounded text-xs font-medium ${
                  isActive('/dashboard') ? 'text-[#1B3B2B] bg-[#EBF1ED] font-bold' : 'text-[#4A524D] hover:bg-[#F4F1EA]'
                }`}
              >
                My Dashboard
              </Link>
            )}

            {(role === 'instructor' || role === 'admin' || role === 'system_admin') && (
              <Link
                to="/instructor"
                onClick={() => setMobileMenuOpen(false)}
                className={`block px-3 py-2 rounded text-xs font-medium ${
                  isActive('/instructor') ? 'text-[#1B3B2B] bg-[#EBF1ED] font-bold' : 'text-[#4A524D] hover:bg-[#F4F1EA]'
                }`}
              >
                Instructor Studio
              </Link>
            )}

            {(role === 'admin' || role === 'system_admin') && (
              <Link
                to="/admin"
                onClick={() => setMobileMenuOpen(false)}
                className={`block px-3 py-2 rounded text-xs font-medium ${
                  isActive('/admin') ? 'text-[#8C5311] bg-[#FBF4EB] font-bold' : 'text-[#4A524D] hover:bg-[#F4F1EA]'
                }`}
              >
                Admin Oversight
              </Link>
            )}
          </div>

          {!user ? (
            <div className="pt-3 flex flex-col gap-2 border-t border-[#E5E2D9]">
              <Link
                to="/login"
                onClick={() => setMobileMenuOpen(false)}
                className="btn-secondary w-full text-center text-xs py-2"
              >
                Sign In
              </Link>
              <Link
                to="/register"
                onClick={() => setMobileMenuOpen(false)}
                className="btn-forest w-full text-center text-xs py-2"
              >
                Enroll Free
              </Link>
            </div>
          ) : (
            <div className="pt-2 border-t border-[#E5E2D9]">
              <button
                onClick={() => {
                  logout();
                  setMobileMenuOpen(false);
                  navigate('/');
                }}
                className="w-full text-left px-3 py-2 rounded text-xs text-[#8B3020] hover:bg-[#FDF1EE] font-medium flex items-center gap-2"
              >
                <LogOut className="w-3.5 h-3.5" />
                <span>Sign Out</span>
              </button>
            </div>
          )}
        </div>
      )}
    </nav>
  );
};
