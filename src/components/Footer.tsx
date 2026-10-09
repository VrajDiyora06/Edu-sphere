import React from 'react';
import { GraduationCap, BookOpen, ShieldCheck, Award } from 'lucide-react';
import { Link } from 'react-router-dom';

export const Footer: React.FC = () => {
  return (
    <footer className="border-t border-[#E5E2D9] bg-[#F4F1EA] text-[#4A524D] py-14 text-sm mt-auto">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-10 mb-10">
          
          {/* Brand & Purpose */}
          <div className="space-y-3.5 md:col-span-1">
            <div className="flex items-center gap-2.5">
              <div className="w-8 h-8 rounded bg-[#1B3B2B] flex items-center justify-center text-[#FAF9F5]">
                <GraduationCap className="w-4 h-4" />
              </div>
              <span className="font-editorial text-xl font-semibold text-[#1F2421] tracking-tight">EduSphere</span>
            </div>
            <p className="text-xs text-[#6C756F] leading-relaxed">
              An open-access academic learning platform providing university-caliber computer science, software architecture, and artificial intelligence courseware.
            </p>
          </div>

          {/* Academic Curriculum Links */}
          <div>
            <h4 className="text-[11px] font-semibold text-[#1F2421] uppercase tracking-wider mb-3.5">
              Coursework & Catalog
            </h4>
            <ul className="space-y-2.5 text-xs">
              <li>
                <Link to="/courses" className="hover:text-[#1B3B2B] transition-colors">
                  All Courses
                </Link>
              </li>
              <li>
                <Link to="/courses" className="hover:text-[#1B3B2B] transition-colors">
                  Computer Science & Systems
                </Link>
              </li>
              <li>
                <Link to="/courses" className="hover:text-[#1B3B2B] transition-colors">
                  Database & Cloud Architecture
                </Link>
              </li>
              <li>
                <Link to="/courses" className="hover:text-[#1B3B2B] transition-colors">
                  Artificial Intelligence
                </Link>
              </li>
            </ul>
          </div>

          {/* Academic Features */}
          <div>
            <h4 className="text-[11px] font-semibold text-[#1F2421] uppercase tracking-wider mb-3.5">
              Educational Standards
            </h4>
            <ul className="space-y-2.5 text-xs text-[#535C56]">
              <li className="flex items-center gap-2">
                <BookOpen className="w-3.5 h-3.5 text-[#1B3B2B] shrink-0" />
                <span>Peer-Reviewed Syllabi</span>
              </li>
              <li className="flex items-center gap-2">
                <Award className="w-3.5 h-3.5 text-[#1B3B2B] shrink-0" />
                <span>Verified Certificates</span>
              </li>
              <li className="flex items-center gap-2">
                <ShieldCheck className="w-3.5 h-3.5 text-[#1B3B2B] shrink-0" />
                <span>Protected Student Records</span>
              </li>
            </ul>
          </div>

          {/* Academic Mission Statement */}
          <div>
            <h4 className="text-[11px] font-semibold text-[#1F2421] uppercase tracking-wider mb-3.5">
              University Mission
            </h4>
            <p className="text-xs text-[#6C756F] leading-relaxed mb-3">
              Full syllabi, lecture series, interactive assessments, and completion credentials are provided at zero tuition cost to registered students.
            </p>
            <div className="flex items-center gap-2 text-xs">
              <Link to="/register" className="text-xs font-semibold text-[#1B3B2B] hover:underline">
                Create Free Student Account →
              </Link>
            </div>
          </div>

        </div>

        <div className="pt-6 border-t border-[#E5E2D9] flex flex-col sm:flex-row items-center justify-between gap-3 text-xs text-[#6C756F]">
          <p>© 2026 EduSphere Academic Initiative. Production-grade academic infrastructure.</p>
          <div className="flex items-center gap-4 text-xs">
            <span>Open Access Courseware</span>
            <span>•</span>
            <span>WCAG 2.1 AA Compliant</span>
          </div>
        </div>
      </div>
    </footer>
  );
};
