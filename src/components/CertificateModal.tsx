import React, { useRef } from 'react';
import type { DbCourse, DbPublicProfile, DbEnrollment } from '../types';
import {
  Award,
  Download,
  Share2,
  X,
  CheckCircle,
  GraduationCap,
  Calendar,
  ShieldCheck,
} from 'lucide-react';

interface CertificateModalProps {
  course: DbCourse & { instructor?: DbPublicProfile | null };
  enrollment: DbEnrollment;
  studentName: string;
  onClose: () => void;
}

export const CertificateModal: React.FC<CertificateModalProps> = ({
  course,
  enrollment,
  studentName,
  onClose,
}) => {
  const certificateRef = useRef<HTMLDivElement>(null);
  const [copied, setCopied] = React.useState(false);

  const completedAt = enrollment.completed_at;

  const completionDate = React.useMemo(() => {
    if (completedAt) {
      return new Date(completedAt).toLocaleDateString(undefined, {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
      });
    }
    return 'Recently Awarded';
  }, [completedAt]);

  const certificateId = `EDU-${enrollment.id.substring(0, 8).toUpperCase()}-${course.id.substring(0, 4).toUpperCase()}`;

  const handlePrint = () => {
    window.print();
  };

  const handleCopyLink = () => {
    const url = `${window.location.origin}/courses/${course.id}?verify=${enrollment.id}`;
    navigator.clipboard.writeText(url).then(() => {
      setCopied(true);
      setTimeout(() => setCopied(false), 2500);
    });
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-xs overflow-y-auto print:p-0 print:bg-white print:static">
      <div className="max-w-3xl w-full my-8 space-y-4 print:my-0 print:max-w-none">
        
        {/* Actions bar above certificate (hidden during print) */}
        <div className="flex items-center justify-between print:hidden bg-white p-3 rounded-xl border border-slate-200 shadow-xs">
          <div className="flex items-center gap-2">
            <span className="px-2.5 py-1 rounded-full text-xs font-semibold bg-teal-50 text-[#0F766E] border border-teal-200 flex items-center gap-1.5">
              <CheckCircle className="w-3.5 h-3.5" />
              Verified Certificate
            </span>
            <span className="text-xs text-slate-500 font-mono">ID: {certificateId}</span>
          </div>

          <div className="flex items-center gap-2">
            <button
              onClick={handlePrint}
              className="btn-primary text-xs py-1.5 px-3"
              title="Print or Save as PDF"
            >
              <Download className="w-3.5 h-3.5" />
              <span>Print / Save PDF</span>
            </button>
            <button
              onClick={handleCopyLink}
              className="btn-secondary text-xs py-1.5 px-3"
              title="Copy verification link"
            >
              <Share2 className="w-3.5 h-3.5" />
              <span>{copied ? 'Copied!' : 'Share Link'}</span>
            </button>
            <button
              onClick={onClose}
              className="p-1.5 rounded-lg text-slate-400 hover:text-slate-700 hover:bg-slate-100 transition-colors"
              aria-label="Close modal"
            >
              <X className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Certificate Surface */}
        <div
          ref={certificateRef}
          className="relative bg-[#FFFDF9] p-8 sm:p-12 rounded-xl border-4 border-[#172B4D] shadow-xl text-center space-y-6 overflow-hidden print:shadow-none print:border-4 print:border-black print:rounded-none"
        >
          {/* Inner decorative border */}
          <div className="absolute inset-2 border border-[#CBD5E1] pointer-events-none" />

          {/* Corner flourish markers */}
          <div className="absolute top-4 left-4 w-4 h-4 border-t-2 border-l-2 border-[#172B4D]" />
          <div className="absolute top-4 right-4 w-4 h-4 border-t-2 border-r-2 border-[#172B4D]" />
          <div className="absolute bottom-4 left-4 w-4 h-4 border-b-2 border-l-2 border-[#172B4D]" />
          <div className="absolute bottom-4 right-4 w-4 h-4 border-b-2 border-r-2 border-[#172B4D]" />

          {/* Certificate Header */}
          <div className="space-y-3 relative z-10">
            <div className="w-12 h-12 rounded-lg bg-[#172B4D] flex items-center justify-center text-white mx-auto shadow-xs">
              <GraduationCap className="w-6 h-6 text-white" />
            </div>

            <div>
              <div className="text-xs uppercase tracking-[0.25em] font-bold text-[#0F766E]">
                EduSphere Academic Learning Platform
              </div>
              <h1 className="text-3xl sm:text-4xl font-bold text-[#172B4D] tracking-tight mt-1 font-serif">
                Certificate of Completion
              </h1>
            </div>

            <p className="text-xs text-slate-600 max-w-md mx-auto leading-relaxed">
              This official credential certifies that the undersigned student has fulfilled all course curriculum requirements and demonstrated mastery of the subject matter.
            </p>
          </div>

          {/* Recipient Name */}
          <div className="py-3 border-y border-slate-200 max-w-lg mx-auto space-y-1 relative z-10">
            <div className="text-[11px] uppercase tracking-wider text-slate-500 font-semibold">
              Conferred Upon
            </div>
            <div className="text-2xl sm:text-3xl font-bold text-[#172B4D] font-serif">
              {studentName}
            </div>
          </div>

          {/* Course Details */}
          <div className="space-y-1.5 max-w-xl mx-auto relative z-10">
            <div className="text-xs text-slate-600">for successful completion of:</div>
            <div className="text-xl sm:text-2xl font-bold text-[#0F766E]">
              {course.title}
            </div>
            <div className="flex items-center justify-center gap-3 text-xs text-slate-500 pt-1 font-medium">
              <span className="px-2 py-0.5 rounded bg-slate-100 text-slate-700">
                {course.category}
              </span>
              <span>•</span>
              <span className="px-2 py-0.5 rounded bg-slate-100 text-slate-700">
                {course.level} Level
              </span>
            </div>
          </div>

          {/* Signatures & Seal Row */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-6 pt-6 border-t border-slate-200 text-xs items-end relative z-10">
            
            {/* Instructor Signature */}
            <div className="space-y-1 text-center sm:text-left">
              <div className="font-serif italic text-base text-[#172B4D] pb-1 border-b border-slate-300 font-semibold">
                {course.instructor?.full_name || 'EduSphere Faculty'}
              </div>
              <div className="text-[11px] text-slate-700 font-medium">Course Instructor</div>
              <div className="text-[10px] text-slate-500">EduSphere Academic Department</div>
            </div>

            {/* Official Seal */}
            <div className="flex flex-col items-center justify-center space-y-1">
              <div className="w-12 h-12 rounded-full bg-teal-50 border-2 border-[#0F766E] flex items-center justify-center text-[#0F766E] shadow-xs">
                <Award className="w-6 h-6" />
              </div>
              <span className="text-[10px] font-bold uppercase tracking-wider text-[#0F766E]">
                Official Academic Seal
              </span>
            </div>

            {/* Date & Verification ID */}
            <div className="space-y-1 text-center sm:text-right">
              <div className="flex items-center justify-center sm:justify-end gap-1.5 text-slate-700 font-medium pb-1 border-b border-slate-300">
                <Calendar className="w-3.5 h-3.5 text-[#0F766E]" />
                <span>{completionDate}</span>
              </div>
              <div className="text-[11px] text-slate-600 flex items-center justify-center sm:justify-end gap-1">
                <ShieldCheck className="w-3.5 h-3.5 text-[#15803D]" />
                <span>Verified Credential</span>
              </div>
              <div className="text-[10px] text-slate-500 font-mono truncate" title={enrollment.id}>
                {certificateId}
              </div>
            </div>

          </div>

        </div>

      </div>
    </div>
  );
};
