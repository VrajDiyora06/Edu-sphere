import React from 'react';
import { Navigate, useLocation, Link } from 'react-router-dom';
import { useAuth } from '../../context/useAuth';
import type { UserRole } from '../../types';
import { ShieldAlert, Loader2 } from 'lucide-react';

interface ProtectedRouteProps {
  children: React.ReactNode;
  allowedRoles?: UserRole[];
}

export const ProtectedRoute: React.FC<ProtectedRouteProps> = ({ children, allowedRoles }) => {
  const { user, role, loading } = useAuth();
  const location = useLocation();

  if (loading) {
    return (
      <div className="min-h-[60vh] flex flex-col items-center justify-center space-y-3">
        <Loader2 className="w-8 h-8 text-indigo-400 animate-spin" />
        <p className="text-xs text-slate-400 font-mono">Verifying Supabase Session...</p>
      </div>
    );
  }

  if (!user) {
    return <Navigate to="/login" state={{ from: location }} replace />;
  }

  if (allowedRoles && allowedRoles.length > 0 && !allowedRoles.includes(role)) {
    return (
      <div className="max-w-md mx-auto my-16 p-8 glass-panel rounded-3xl border border-rose-500/30 text-center space-y-4 shadow-2xl">
        <div className="w-12 h-12 rounded-2xl bg-rose-500/20 text-rose-400 border border-rose-500/30 flex items-center justify-center mx-auto">
          <ShieldAlert className="w-6 h-6" />
        </div>
        <h2 className="text-xl font-bold text-white">Access Unauthorized</h2>
        <p className="text-xs text-slate-300 leading-relaxed">
          Your current account role (<strong className="capitalize text-rose-300">{role.replace('_', ' ')}</strong>) does not have authorization to view this route.
        </p>
        <p className="text-[11px] text-slate-500 italic">
          Role-Based Access Control (RBAC) is enforced client-side and verified directly by PostgreSQL Row Level Security (RLS).
        </p>
        <div className="pt-2 flex items-center justify-center gap-3">
          {role === 'instructor' ? (
            <Link
              to="/instructor"
              className="px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-semibold transition-colors shadow-md shadow-indigo-600/20"
            >
              Instructor Studio
            </Link>
          ) : role === 'admin' || role === 'system_admin' ? (
            <Link
              to="/admin"
              className="px-4 py-2 rounded-xl bg-amber-600 hover:bg-amber-500 text-white text-xs font-semibold transition-colors shadow-md shadow-amber-600/20"
            >
              Admin Portal
            </Link>
          ) : (
            <Link
              to="/dashboard"
              className="px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-semibold transition-colors shadow-md shadow-indigo-600/20"
            >
              My Dashboard
            </Link>
          )}
          <Link
            to="/courses"
            className="px-4 py-2 rounded-xl glass-panel hover:bg-slate-800 text-slate-300 text-xs font-semibold transition-colors"
          >
            Course Catalog
          </Link>
        </div>
      </div>
    );
  }

  return <>{children}</>;
};
