import React, { useState, useEffect } from 'react';
import { getLessonVideoPlaybackUrl } from '../lib/media';
import { Video, AlertCircle, RefreshCw, ExternalLink, Loader2, PlayCircle } from 'lucide-react';

interface LessonVideoPlayerProps {
  videoUrl: string | null | undefined;
  title?: string;
  isFreePreview?: boolean;
}

export const LessonVideoPlayer: React.FC<LessonVideoPlayerProps> = ({
  videoUrl,
  title,
  isFreePreview = false,
}) => {
  const [loading, setLoading] = useState(false);
  const [playbackUrl, setPlaybackUrl] = useState<string | null>(null);
  const [isEmbeddable, setIsEmbeddable] = useState(false);
  const [embedUrl, setEmbedUrl] = useState<string | null>(null);
  const [isExternal, setIsExternal] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [playbackFailed, setPlaybackFailed] = useState(false);

  const resolveStream = React.useCallback(async () => {
    if (!videoUrl || !videoUrl.trim()) {
      setPlaybackUrl(null);
      setEmbedUrl(null);
      setError(null);
      return;
    }

    setLoading(true);
    setError(null);
    setPlaybackFailed(false);

    const result = await getLessonVideoPlaybackUrl(videoUrl);
    setLoading(false);

    if (result.error) {
      setError(result.error.message || 'Unable to authorize or load video stream.');
      setPlaybackUrl(null);
      setEmbedUrl(null);
    } else {
      setPlaybackUrl(result.url);
      setIsEmbeddable(result.isEmbeddable);
      setEmbedUrl(result.embedUrl);
      setIsExternal(result.isExternal);
    }
  }, [videoUrl]);

  useEffect(() => {
    resolveStream();
  }, [resolveStream]);

  if (!videoUrl || !videoUrl.trim()) {
    return null;
  }

  return (
    <div className="rounded-xl overflow-hidden bg-slate-900 border border-slate-800 shadow-md">
      {/* Header bar */}
      <div className="px-4 py-2.5 bg-slate-950/80 border-b border-slate-800 flex items-center justify-between text-xs">
        <div className="flex items-center gap-2 text-slate-200 font-semibold truncate">
          <Video className="w-4 h-4 text-teal-400 shrink-0" />
          <span className="truncate">{title ? `Lecture: ${title}` : 'Lecture Video Stream'}</span>
          {isFreePreview && (
            <span className="px-2 py-0.5 rounded text-[10px] bg-teal-900/60 text-teal-300 border border-teal-700/50 font-mono font-medium">
              Free Preview
            </span>
          )}
        </div>

        {playbackUrl && isExternal && (
          <a
            href={playbackUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-1 text-[11px] text-teal-400 hover:text-teal-300 font-mono"
            title="Open in new window"
          >
            <span>External Source</span>
            <ExternalLink className="w-3 h-3" />
          </a>
        )}
      </div>

      {/* Video Content / Player Body */}
      <div className="relative aspect-video w-full bg-black flex items-center justify-center overflow-hidden">
        {loading && (
          <div className="text-center space-y-2 text-slate-400 p-6">
            <Loader2 className="w-8 h-8 animate-spin text-teal-500 mx-auto" />
            <p className="text-xs font-mono">Authorizing video stream...</p>
          </div>
        )}

        {!loading && error && (
          <div className="text-center space-y-3 p-6 max-w-md">
            <AlertCircle className="w-8 h-8 text-rose-400 mx-auto" />
            <div className="space-y-1">
              <p className="text-xs font-bold text-rose-300">Video Playback Error</p>
              <p className="text-[11px] text-slate-400">{error}</p>
            </div>
            <button
              onClick={resolveStream}
              className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-semibold transition-colors"
            >
              <RefreshCw className="w-3.5 h-3.5" />
              <span>Retry Playback</span>
            </button>
          </div>
        )}

        {!loading && !error && isEmbeddable && embedUrl && (
          <iframe
            src={embedUrl}
            title={title || 'Lecture Video'}
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            allowFullScreen
            className="w-full h-full border-0"
          />
        )}

        {!loading && !error && !isEmbeddable && playbackUrl && !playbackFailed && (
          <video
            controls
            playsInline
            controlsList="nodownload"
            preload="metadata"
            className="w-full h-full object-contain"
            onError={() => setPlaybackFailed(true)}
          >
            <source src={playbackUrl} type="video/mp4" />
            <source src={playbackUrl} type="video/webm" />
            Your browser does not support the video tag.
          </video>
        )}

        {!loading && !error && !isEmbeddable && playbackFailed && (
          <div className="text-center space-y-3 p-6 max-w-md">
            <PlayCircle className="w-8 h-8 text-amber-400 mx-auto" />
            <div className="space-y-1">
              <p className="text-xs font-bold text-amber-300">Playback Failed in HTML5 Player</p>
              <p className="text-[11px] text-slate-400">
                The video stream could not be decoded directly in this browser.
              </p>
            </div>
            <div className="flex items-center justify-center gap-3">
              <button
                onClick={resolveStream}
                className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-semibold transition-colors"
              >
                <RefreshCw className="w-3.5 h-3.5" />
                <span>Retry</span>
              </button>
              {playbackUrl && (
                <a
                  href={playbackUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-teal-700 hover:bg-teal-600 text-white text-xs font-semibold transition-colors"
                >
                  <ExternalLink className="w-3.5 h-3.5" />
                  <span>Open Stream</span>
                </a>
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
