import React, { useRef, useState, useEffect } from 'react';
import {
  Upload,
  Video,
  Trash2,
  RefreshCw,
  AlertCircle,
  Link as LinkIcon,
  CheckCircle2,
  FileVideo,
} from 'lucide-react';
import {
  validateLessonVideoFile,
  getLessonVideoPlaybackUrl,
  LESSON_VIDEO_MAX_SIZE_BYTES,
} from '../lib/media';

interface LessonVideoUploadProps {
  currentVideoUrl?: string | null;
  selectedFile: File | null;
  onFileSelect: (file: File | null) => void;
  externalUrl: string;
  onExternalUrlChange: (url: string) => void;
  videoMode: 'upload' | 'url';
  onModeChange: (mode: 'upload' | 'url') => void;
  disabled?: boolean;
  error?: string | null;
}

export const LessonVideoUpload: React.FC<LessonVideoUploadProps> = ({
  currentVideoUrl,
  selectedFile,
  onFileSelect,
  externalUrl,
  onExternalUrlChange,
  videoMode,
  onModeChange,
  disabled = false,
  error: externalError,
}) => {
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [localError, setLocalError] = useState<string | null>(null);
  const [dragOver, setDragOver] = useState(false);
  const [currentPlaybackUrl, setCurrentPlaybackUrl] = useState<string | null>(null);

  // If there's an existing video URL and no new file selected, resolve playback for preview
  useEffect(() => {
    let ignore = false;
    if (currentVideoUrl && !selectedFile && videoMode === 'upload') {
      getLessonVideoPlaybackUrl(currentVideoUrl).then((res) => {
        if (ignore) return;
        if (res.url) {
          setCurrentPlaybackUrl(res.url);
        }
      });
    } else {
      setCurrentPlaybackUrl(null);
    }
    return () => {
      ignore = true;
    };
  }, [currentVideoUrl, selectedFile, videoMode]);

  // Compute live preview
  let localPreviewUrl: string | null = null;
  if (selectedFile) {
    localPreviewUrl = URL.createObjectURL(selectedFile);
  }

  const handleFileChange = (file: File | null) => {
    setLocalError(null);
    if (!file) {
      onFileSelect(null);
      return;
    }

    const validation = validateLessonVideoFile(file);
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
    if (disabled || videoMode !== 'upload') return;
    const file = e.dataTransfer.files?.[0];
    if (file) handleFileChange(file);
  };

  const errorMessage = localError || externalError;

  return (
    <div className="space-y-3">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
        <label className="text-xs font-semibold text-slate-700 flex items-center gap-1.5">
          <Video className="w-4 h-4 text-teal-700" />
          <span>Lesson Lecture Video (Optional)</span>
        </label>

        {/* Mode selector pills */}
        <div className="inline-flex items-center p-0.5 rounded-lg bg-slate-100 border border-slate-200 text-xs">
          <button
            type="button"
            onClick={() => {
              setLocalError(null);
              onModeChange('upload');
            }}
            disabled={disabled}
            className={`px-2.5 py-1 rounded-md font-semibold transition-all flex items-center gap-1 text-[11px] ${
              videoMode === 'upload'
                ? 'bg-white text-teal-800 shadow-2xs'
                : 'text-slate-600 hover:text-slate-900'
            }`}
          >
            <Upload className="w-3 h-3" />
            <span>Upload File</span>
          </button>
          <button
            type="button"
            onClick={() => {
              setLocalError(null);
              onModeChange('url');
            }}
            disabled={disabled}
            className={`px-2.5 py-1 rounded-md font-semibold transition-all flex items-center gap-1 text-[11px] ${
              videoMode === 'url'
                ? 'bg-white text-teal-800 shadow-2xs'
                : 'text-slate-600 hover:text-slate-900'
            }`}
          >
            <LinkIcon className="w-3 h-3" />
            <span>External Stream URL</span>
          </button>
        </div>
      </div>

      {/* Hidden system file picker */}
      <input
        ref={fileInputRef}
        type="file"
        accept="video/mp4,video/webm,.mp4,.webm"
        onChange={(e) => {
          const file = e.target.files?.[0] || null;
          handleFileChange(file);
        }}
        disabled={disabled}
        className="hidden"
        id="lesson-video-file-input"
      />

      {videoMode === 'url' ? (
        <div className="space-y-2">
          <input
            type="url"
            placeholder="https://www.youtube.com/watch?v=... or https://cdn.example.com/lecture.mp4"
            value={externalUrl}
            onChange={(e) => {
              setLocalError(null);
              onExternalUrlChange(e.target.value);
            }}
            disabled={disabled}
            className="w-full px-3.5 py-2.5 rounded-lg bg-white border border-slate-300 text-xs text-slate-900 focus:outline-none focus:border-teal-700 font-mono"
          />
          <p className="text-[11px] text-slate-500">
            Paste an external video streaming URL (YouTube, Vimeo, or direct MP4/WebM URL).
          </p>
        </div>
      ) : (
        /* Video Upload Area */
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
          {localPreviewUrl || currentPlaybackUrl ? (
            <div className="space-y-3">
              <div className="relative aspect-video max-h-56 w-full rounded-lg overflow-hidden border border-slate-800 bg-black flex items-center justify-center">
                <video
                  src={localPreviewUrl || currentPlaybackUrl!}
                  controls
                  playsInline
                  className="w-full h-full object-contain"
                >
                  Your browser does not support the video tag.
                </video>
                {selectedFile && (
                  <span className="absolute top-2 left-2 px-2 py-0.5 rounded bg-slate-900/80 backdrop-blur-xs text-white text-[10px] font-mono flex items-center gap-1">
                    <CheckCircle2 className="w-3 h-3 text-emerald-400" />
                    <span>New file selected: {(selectedFile.size / (1024 * 1024)).toFixed(1)} MB</span>
                  </span>
                )}
              </div>

              <div className="flex flex-wrap items-center justify-between gap-2 pt-1">
                <div className="text-[11px] text-slate-600 font-mono truncate max-w-xs flex items-center gap-1.5">
                  <FileVideo className="w-3.5 h-3.5 text-teal-700" />
                  <span className="truncate">
                    {selectedFile ? selectedFile.name : 'Current video attached'}
                  </span>
                </div>

                <div className="flex items-center gap-2">
                  <button
                    type="button"
                    onClick={() => fileInputRef.current?.click()}
                    disabled={disabled}
                    className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-white border border-slate-300 hover:bg-slate-50 text-slate-700 text-xs font-semibold shadow-2xs transition-colors"
                  >
                    <RefreshCw className="w-3 h-3 text-teal-700" />
                    <span>Replace Video</span>
                  </button>

                  <button
                    type="button"
                    onClick={() => {
                      handleFileChange(null);
                      onExternalUrlChange('');
                      setCurrentPlaybackUrl(null);
                      if (fileInputRef.current) fileInputRef.current.value = '';
                    }}
                    disabled={disabled}
                    className="inline-flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg border border-rose-200 bg-white hover:bg-rose-50 text-rose-700 text-xs font-semibold transition-colors"
                    title="Remove video from lesson"
                  >
                    <Trash2 className="w-3 h-3" />
                    <span>Remove</span>
                  </button>
                </div>
              </div>
            </div>
          ) : (
            <div className="text-center py-4 space-y-3">
              <div className="w-12 h-12 rounded-full bg-teal-50 border border-teal-200 text-teal-700 flex items-center justify-center mx-auto">
                <FileVideo className="w-5 h-5" />
              </div>

              <div className="space-y-1">
                <p className="text-xs font-semibold text-slate-800">
                  Drag and drop a video file, or{' '}
                  <button
                    type="button"
                    onClick={() => fileInputRef.current?.click()}
                    disabled={disabled}
                    className="text-teal-700 hover:underline font-bold"
                  >
                    browse your computer
                  </button>
                </p>
                <p className="text-[11px] text-slate-500">
                  Accepted formats: MP4, WebM (Maximum {LESSON_VIDEO_MAX_SIZE_BYTES / (1024 * 1024)} MB)
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
                  <span>Choose Video File</span>
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
