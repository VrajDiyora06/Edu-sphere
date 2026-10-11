import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/useAuth';
import { ShieldAlert, CheckCircle2, AlertCircle, GraduationCap } from 'lucide-react';

export const RegisterPage: React.FC = () => {
  const navigate = useNavigate();
  const { signUpWithEmail } = useAuth();
  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isSuccess, setIsSuccess] = useState(false);

  const handleRegisterSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage(null);
    setIsSubmitting(true);

    const { error } = await signUpWithEmail(email, password, fullName);

    setIsSubmitting(false);

    if (error) {
      setErrorMessage(error.message || 'Registration failed. Please check your information.');
    } else {
      setIsSuccess(true);
    }
  };

  return (
    <div className="min-h-[75vh] flex items-center justify-center px-4 sm:px-6 lg:px-8 py-14">
      <div className="max-w-md w-full academic-card p-8 sm:p-10 space-y-6">
        <div className="text-center space-y-2">
          <div className="w-12 h-12 rounded-lg bg-[#1B3B2B] text-white flex items-center justify-center mx-auto mb-3 shadow-xs">
            <GraduationCap className="w-6 h-6" />
          </div>
          <h1 className="font-editorial text-2xl sm:text-3xl text-[#1F2421]">
            Create Free Student Account
          </h1>
          <p className="text-xs text-[#535C56]">
            Register to access open courseware, submissions, and verified certificates.
          </p>
        </div>

        {/* Security / Role Notice */}
        <div className="p-3.5 rounded-md bg-[#F4F1EA] border border-[#E5E2D9] flex items-start gap-2.5 text-xs text-[#1F2421]">
          <ShieldAlert className="w-4 h-4 text-[#1B3B2B] shrink-0 mt-0.5" />
          <div className="leading-relaxed">
            <strong className="text-[#1B3B2B] font-semibold block">Academic Role Policy:</strong>
            Public registrations receive the <strong>Student</strong> role. Instructor and Administrator privileges require institutional authorization.
          </div>
        </div>

        {/* Error Alert */}
        {errorMessage && (
          <div className="p-3.5 rounded-md bg-[#FDF1EE] border border-[#F5C2BA] flex items-start gap-2.5 text-xs text-[#9E3D2B]">
            <AlertCircle className="w-4 h-4 shrink-0 mt-0.5 text-[#9E3D2B]" />
            <div className="leading-relaxed font-medium">{errorMessage}</div>
          </div>
        )}

        {/* Success Alert */}
        {isSuccess ? (
          <div className="p-6 rounded-lg bg-[#FAF9F5] border border-[#E5E2D9] text-center space-y-3">
            <CheckCircle2 className="w-8 h-8 text-[#1B3B2B] mx-auto" />
            <h3 className="font-editorial text-lg text-[#1F2421]">Account Created</h3>
            <p className="text-xs text-[#535C56] leading-relaxed">
              Your student account has been registered. You can now sign in and begin your studies.
            </p>
            <button
              onClick={() => navigate('/login')}
              className="btn-forest w-full py-2 text-xs font-semibold"
            >
              Proceed to Sign In
            </button>
          </div>
        ) : (
          /* Registration Form */
          <form onSubmit={handleRegisterSubmit} className="space-y-4">
            <div>
              <label className="block text-xs font-semibold text-[#1F2421] mb-1.5">
                Full Name
              </label>
              <input
                type="text"
                required
                value={fullName}
                onChange={(e) => setFullName(e.target.value)}
                placeholder="Alex Mercer"
                className="academic-input text-xs sm:text-sm"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-[#1F2421] mb-1.5">
                Email Address
              </label>
              <input
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="alex@example.com"
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
                placeholder="Minimum 8 characters"
                className="academic-input text-xs sm:text-sm"
              />
            </div>

            <button
              type="submit"
              disabled={isSubmitting}
              className="btn-forest w-full py-2.5 text-xs font-semibold cursor-pointer"
            >
              {isSubmitting ? 'Creating Student Account...' : 'Complete Registration'}
            </button>
          </form>
        )}

        <div className="text-center text-xs text-[#535C56] pt-3 border-t border-[#E5E2D9]">
          Already registered?{' '}
          <Link to="/login" className="text-[#1B3B2B] hover:underline font-semibold">
            Sign In to Account
          </Link>
        </div>
      </div>
    </div>
  );
};
