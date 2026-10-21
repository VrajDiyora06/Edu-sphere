import React, { useRef, useState } from 'react';
import {
  Upload,
  Image as ImageIcon,
  Trash2,
  RefreshCw,
  AlertCircle,
  Link as LinkIcon,
  CheckCircle2,
} from 'lucide-react';
import {
  validateCourseCoverFile,
  getCourseCoverDisplayUrl,
  COURSE_COVER_MAX_SIZE_BYTES,
} from '../lib/media';

interface CourseCoverUploadProps {
  currentImageUrl?: string | null;
  selectedFile: File | null;
  onFileSelect: (file: File | null) => void;
  externalUrl: string;
  onExternalUrlChange: (url: string) => void;
  isExternalMode: boolean;
  onModeToggle: (isExternal: boolean) => void;
  disabled?: boolean;
  error?: string | null;
}

export const CourseCoverUpload: React.FC<CourseCoverUploadProps> = ({
  currentImageUrl,
  selectedFile,
  onFileSelect,
  externalUrl,
  onExternalUrlChange,
  isExternalMode,
  onModeToggle,
  disabled = false,
  error: externalError,
}) => {
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [localError, setLocalError] = useState<string | null>(null);
  const [dragOver, setDragOver] = useState(false);

  // Compute live preview
  let previewUrl: string | null = null;
  if (isExternalMode) {
    previewUrl = externalUrl.trim() ? externalUrl.trim() : null;
  } else if (selectedFile) {
    previewUrl = URL.createObjectURL(selectedFile);
  } else if (currentImageUrl) {
    previewUrl = getCourseCoverDisplayUrl(currentImageUrl);
  }

  const handleFileChange = (file: File | null) => {
    setLocalError(null);
    if (!file) {
      onFileSelect(null);
      return;
    }

    const validation = validateCourseCoverFile(file);
    if (!validation.valid) {
      setLocalError(validation.error);
      if (fileInputRef.current) fileInputRef.current.value = '';
      return;
    }

    onFileSelect(file);
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setDragOver(false);
    if (disabled || isExternalMode) return;
    const file = e.dataTransfer.files?.[0];
    if (file) handleFileChange(file);
  };

  const errorMessage = localError || externalError;

  return (
    <div className="space-y-3">
      <div className="flex items-center justify-between">
        <label className="text-xs font-semibold text-slate-700 flex items-center gap-1.5">
          <ImageIcon className="w-4 h-4 text-teal-700" />
          <span>Course Cover Image</span>
        </label>

        {/* Mode Toggle: Direct Upload vs External URL */}
        <button
          type="button"
          onClick={() => {
            setLocalError(null);
            onModeToggle(!isExternalMode);
          }}
          disabled={disabled}
          className="text-[11px] font-medium text-teal-700 hover:text-teal-900 flex items-center gap-1 underline transition-colors"
        >
          {isExternalMode ? (
            <>
              <Upload className="w-3 h-3" />
              <span>Switch to Direct Upload</span>
            </>
          ) : (
            <>
              <LinkIcon className="w-3 h-3" />
              <span>Or use image URL</span>
            </>
          )}
        </button>
      </div>

      {/* Hidden system file picker */}
      <input
        ref={fileInputRef}
        type="file"
        accept="image/jpeg,image/jpg,image/png,image/webp"
        onChange={(e) => {
          const file = e.target.files?.[0] || null;
          handleFileChange(file);
        }}
        disabled={disabled}
        className="hidden"
        id="course-cover-file-input"
      />

      {isExternalMode ? (
        <div className="space-y-2">
          <input
            type="url"
            placeholder="https://images.unsplash.com/photo-..."
            value={externalUrl}
            onChange={(e) => {
              setLocalError(null);
              onExternalUrlChange(e.target.value);
            }}
            disabled={disabled}
            className="w-full px-3.5 py-2.5 rounded-lg bg-white border border-slate-300 text-xs text-slate-900 focus:outline-none focus:border-teal-700"
          />
          <p className="text-[11px] text-slate-500">
            Provide a direct public HTTPS URL to an image.
          </p>
        </div>
      ) : (
        /* Upload Area */
        <div
          onDragOver={(e) => {
            e.preventDefault();
            if (!disabled) setDragOver(true);
          }}
          onDragLeave={() => setDragOver(false)}
          onDrop={handleDrop}
          className={`p-4 rounded-xl border-2 border-dashed transition-all ${
            dragOver
              ? 'border-teal-600 bg-teal-50/50'
              : 'border-slate-300 bg-slate-50/60 hover:border-slate-400'
          }`}
        >
          {previewUrl ? (
            <div className="space-y-3">
              <div className="relative aspect-video max-h-48 w-full rounded-lg overflow-hidden border border-slate-200 bg-slate-100 flex items-center justify-center">
                <img
                  src={previewUrl}
                  alt="Course cover preview"
                  className="w-full h-full object-cover"
                />
                {selectedFile && (
                  <span className="absolute bottom-2 left-2 px-2 py-0.5 rounded bg-slate-900/80 backdrop-blur-xs text-white text-[10px] font-mono flex items-center gap-1">
                    <CheckCircle2 className="w-3 h-3 text-emerald-400" />
                    <span>Ready to upload ({(selectedFile.size / 1024).toFixed(0)} KB)</span>
                  </span>
                )}
              </div>

              <div className="flex flex-wrap items-center justify-between gap-2 pt-1">
                <div className="text-[11px] text-slate-600 font-mono truncate max-w-xs">
                  {selectedFile ? selectedFile.name : 'Current cover image'}
                </div>

                <div className="flex items-center gap-2">
                  <button
                    type="button"
                    onClick={() => fileInputRef.current?.click()}
                    disabled={disabled}
                    className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-white border border-slate-300 hover:bg-slate-50 text-slate-700 text-xs font-semibold shadow-2xs transition-colors"
                  >
                    <RefreshCw className="w-3 h-3 text-teal-700" />
                    <span>Replace Image</span>
                  </button>

                  {(selectedFile || currentImageUrl) && (
                    <button
                      type="button"
                      onClick={() => {
                        handleFileChange(null);
                        onExternalUrlChange('');
                        if (fileInputRef.current) fileInputRef.current.value = '';
                      }}
                      disabled={disabled}
                      className="inline-flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg border border-rose-200 bg-white hover:bg-rose-50 text-rose-700 text-xs font-semibold transition-colors"
                      title="Remove image"
                    >
                      <Trash2 className="w-3 h-3" />
                      <span>Remove</span>
                    </button>
                  )}
                </div>
              </div>
            </div>
          ) : (
            <div className="text-center py-4 space-y-3">
              <div className="w-12 h-12 rounded-full bg-teal-50 border border-teal-200 text-teal-700 flex items-center justify-center mx-auto">
                <Upload className="w-5 h-5" />
              </div>

              <div className="space-y-1">
                <p className="text-xs font-semibold text-slate-800">
                  Drag and drop your course cover image, or{' '}
                  <button
                    type="button"
                    onClick={() => fileInputRef.current?.click()}
                    disabled={disabled}
                    className="text-teal-700 hover:underline font-bold"
                  >
                    browse computer
                  </button>
                </p>
                <p className="text-[11px] text-slate-500">
                  Accepted formats: JPG, JPEG, PNG, WebP (Max {COURSE_COVER_MAX_SIZE_BYTES / (1024 * 1024)} MB)
                </p>
              </div>

              <div>
                <button
                  type="button"
                  onClick={() => fileInputRef.current?.click()}
                  disabled={disabled}
                  className="inline-flex items-center gap-2 px-4 py-2 rounded-lg bg-teal-700 hover:bg-teal-800 text-white text-xs font-semibold shadow-2xs transition-colors"
                >
                  <Upload className="w-3.5 h-3.5" />
                  <span>Upload Image</span>
                </button>
              </div>
            </div>
          )}
        </div>
      )}

      {errorMessage && (
        <div className="p-3 rounded-lg bg-rose-50 border border-rose-200 text-rose-800 text-xs flex items-center gap-2">
          <AlertCircle className="w-4 h-4 shrink-0 text-rose-600" />
          <span>{errorMessage}</span>
        </div>
      )}
    </div>
  );
};
