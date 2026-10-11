import React, { useState } from 'react';
import { Link, useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../context/useAuth';
import { AlertCircle, GraduationCap } from 'lucide-react';

export const LoginPage: React.FC = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const { signInWithEmail } = useAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleFormSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage(null);
    setIsSubmitting(true);

    const { error } = await signInWithEmail(email, password);

    setIsSubmitting(false);

    if (error) {
      setErrorMessage(error.message || 'Authentication failed. Please verify your credentials.');
    } else {
      const fromPath = (location.state as { from?: { pathname?: string } })?.from?.pathname;
      navigate(fromPath || '/courses');
    }
  };

  return (
    <div className="min-h-[75vh] flex items-center justify-center px-4 sm:px-6 lg:px-8 py-14">
      <div className="max-w-md w-full academic-card p-8 sm:p-10 space-y-6">
        <div className="text-center space-y-2">
          <div className="w-12 h-12 rounded-lg bg-[#1B3B2B] text-white flex items-center justify-center mx-auto mb-3 shadow-xs">
            <GraduationCap className="w-6 h-6" />
          </div>
          <h1 className="font-editorial text-2xl sm:text-3xl text-[#1F2421]">Sign In to EduSphere</h1>
          <p className="text-xs text-[#535C56]">
            Access your academic coursework, assessments, and verified certificates.
          </p>
        </div>

        {/* Error Alert */}
        {errorMessage && (
          <div className="p-3.5 rounded-md bg-[#FDF1EE] border border-[#F5C2BA] flex items-start gap-2.5 text-xs text-[#9E3D2B]">
            <AlertCircle className="w-4 h-4 shrink-0 mt-0.5 text-[#9E3D2B]" />
            <div className="leading-relaxed font-medium">{errorMessage}</div>
          </div>
        )}

        {/* Sign In Form */}
        <form onSubmit={handleFormSubmit} className="space-y-4">
          <div>
            <label className="block text-xs font-semibold text-[#1F2421] mb-1.5">
              Email Address
            </label>
            <input
              type="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="user@example.com"
              className="academic-input text-xs sm:text-sm"
            />
          </div>

          <div>
            <label className="block text-xs font-semibold text-[#1F2421] mb-1.5">
              Password
            </label>
            <input
              type="password"
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••••"
              className="academic-input text-xs sm:text-sm"
            />
          </div>

          <button
            type="submit"
            disabled={isSubmitting}
            className="btn-forest w-full py-2.5 text-xs font-semibold cursor-pointer"
          >
            {isSubmitting ? 'Authenticating...' : 'Sign In to EduSphere'}
          </button>
        </form>

        <div className="text-center text-xs text-[#535C56] pt-3 border-t border-[#E5E2D9]">
          New to EduSphere?{' '}
          <Link to="/register" className="text-[#1B3B2B] hover:underline font-semibold">
            Create Free Student Account
          </Link>
        </div>
      </div>
    </div>
  );
};
