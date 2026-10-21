import { supabase, isSupabaseConfigured } from './supabaseClient';

export const COURSE_COVER_ALLOWED_EXTENSIONS = ['.jpg', '.jpeg', '.png', '.webp'];
export const COURSE_COVER_ALLOWED_MIME_TYPES = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
export const COURSE_COVER_MAX_SIZE_BYTES = 5 * 1024 * 1024; // 5 MB

export const LESSON_VIDEO_ALLOWED_EXTENSIONS = ['.mp4', '.webm'];
export const LESSON_VIDEO_ALLOWED_MIME_TYPES = ['video/mp4', 'video/webm'];
export const LESSON_VIDEO_MAX_SIZE_BYTES = 200 * 1024 * 1024; // 200 MB

export const DEFAULT_COURSE_THUMBNAIL =
  'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=800&auto=format&fit=crop';

/**
 * Validate a course cover image file.
 */
export function validateCourseCoverFile(file: File): { valid: boolean; error: string | null } {
  if (file.size > COURSE_COVER_MAX_SIZE_BYTES) {
    return {
      valid: false,
      error: `File size (${(file.size / (1024 * 1024)).toFixed(1)} MB) exceeds the 5 MB limit for course cover images.`,
    };
  }

  const ext = '.' + file.name.split('.').pop()?.toLowerCase();
  const mimeType = file.type?.toLowerCase();

  const isExtValid = COURSE_COVER_ALLOWED_EXTENSIONS.includes(ext);
  const isMimeValid = !mimeType || COURSE_COVER_ALLOWED_MIME_TYPES.includes(mimeType);

  if (!isExtValid || !isMimeValid) {
    return {
      valid: false,
      error: `Invalid image format (${ext || 'unknown'}). Accepted formats: JPG, JPEG, PNG, WebP.`,
    };
  }

  return { valid: true, error: null };
}

/**
 * Validate a lesson video file.
 */
export function validateLessonVideoFile(file: File): { valid: boolean; error: string | null } {
  if (file.size > LESSON_VIDEO_MAX_SIZE_BYTES) {
    return {
      valid: false,
      error: `File size (${(file.size / (1024 * 1024)).toFixed(1)} MB) exceeds the 200 MB limit for lesson videos.`,
    };
  }

  const ext = '.' + file.name.split('.').pop()?.toLowerCase();
  const mimeType = file.type?.toLowerCase();

  const isExtValid = LESSON_VIDEO_ALLOWED_EXTENSIONS.includes(ext);
  const isMimeValid = !mimeType || LESSON_VIDEO_ALLOWED_MIME_TYPES.includes(mimeType);

  if (!isExtValid || !isMimeValid) {
    return {
      valid: false,
      error: `Invalid video format (${ext || 'unknown'}). Accepted formats: MP4, WebM.`,
    };
  }

  return { valid: true, error: null };
}

/**
 * Sanitize a file name for safe storage path creation.
 */
function sanitizeFileName(name: string): string {
  return name.replace(/[^a-zA-Z0-9.-]/g, '_');
}

/**
 * Upload a course cover image to the public course-thumbnails bucket.
 * Returns both the storage path and public URL.
 */
export async function uploadCourseCoverImage(
  file: File,
  courseId?: string,
  instructorId?: string
): Promise<{ path: string | null; publicUrl: string | null; error: Error | null }> {
  const validation = validateCourseCoverFile(file);
  if (!validation.valid) {
    return { path: null, publicUrl: null, error: new Error(validation.error || 'Invalid file') };
  }

  if (!isSupabaseConfigured) {
    return { path: null, publicUrl: null, error: new Error('Supabase client is not configured.') };
  }

  const folder = courseId || instructorId || 'covers';
  const cleanName = sanitizeFileName(file.name);
  const path = `${folder}/${Date.now()}_${cleanName}`;

  try {
    const { error: uploadError } = await supabase.storage
      .from('course-thumbnails')
      .upload(path, file, {
        cacheControl: '3600',
        upsert: false,
      });

    if (uploadError) {
      return { path: null, publicUrl: null, error: uploadError };
    }

    const { data: pubData } = supabase.storage.from('course-thumbnails').getPublicUrl(path);
    return { path, publicUrl: pubData.publicUrl, error: null };
  } catch (err) {
    return { path: null, publicUrl: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Upload a lesson video to the private lesson-videos bucket.
 */
export async function uploadLessonVideo(
  file: File,
  courseId: string,
  lessonId?: string
): Promise<{ path: string | null; error: Error | null }> {
  const validation = validateLessonVideoFile(file);
  if (!validation.valid) {
    return { path: null, error: new Error(validation.error || 'Invalid file') };
  }

  if (!isSupabaseConfigured) {
    return { path: null, error: new Error('Supabase client is not configured.') };
  }

  const cleanName = sanitizeFileName(file.name);
  const lessonSubfolder = lessonId || 'pending';
  const path = `${courseId}/${lessonSubfolder}/${Date.now()}_${cleanName}`;

  try {
    const { error: uploadError } = await supabase.storage
      .from('lesson-videos')
      .upload(path, file, {
        cacheControl: '3600',
        upsert: false,
      });

    if (uploadError) {
      return { path: null, error: uploadError };
    }

    return { path, error: null };
  } catch (err) {
    return { path: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Resolve a course cover image URL for display.
 * Works with public HTTP URLs, storage paths, or empty values (returns fallback).
 */
export function getCourseCoverDisplayUrl(thumbnailUrl: string | null | undefined): string {
  if (!thumbnailUrl || !thumbnailUrl.trim()) {
    return DEFAULT_COURSE_THUMBNAIL;
  }

  if (thumbnailUrl.startsWith('http://') || thumbnailUrl.startsWith('https://')) {
    return thumbnailUrl;
  }

  if (isSupabaseConfigured) {
    const { data } = supabase.storage.from('course-thumbnails').getPublicUrl(thumbnailUrl);
    if (data?.publicUrl) return data.publicUrl;
  }

  return DEFAULT_COURSE_THUMBNAIL;
}

/**
 * Check if a URL/path points to a managed Supabase storage object in a bucket.
 */
export function extractStoragePath(
  urlOrPath: string | null | undefined,
  bucketName: 'course-thumbnails' | 'lesson-videos'
): string | null {
  if (!urlOrPath) return null;

  // If path is stored directly (e.g. courseId/timestamp_name.png)
  if (!urlOrPath.startsWith('http://') && !urlOrPath.startsWith('https://')) {
    return urlOrPath;
  }

  // If stored as full Supabase URL: .../storage/v1/object/public/bucketName/path
  const marker = `/${bucketName}/`;
  const idx = urlOrPath.indexOf(marker);
  if (idx !== -1) {
    const extracted = urlOrPath.substring(idx + marker.length).split('?')[0];
    return decodeURIComponent(extracted);
  }

  return null;
}

/**
 * Delete a course cover from storage if it belongs to course-thumbnails.
 */
export async function deleteCourseCoverFromStorage(
  urlOrPath: string | null | undefined
): Promise<{ success: boolean; error: Error | null }> {
  const path = extractStoragePath(urlOrPath, 'course-thumbnails');
  if (!path || !isSupabaseConfigured) {
    return { success: true, error: null };
  }

  try {
    const { error } = await supabase.storage.from('course-thumbnails').remove([path]);
    if (error) {
      return { success: false, error };
    }
    return { success: true, error: null };
  } catch (err) {
    return { success: false, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Delete a lesson video from storage if it belongs to lesson-videos.
 */
export async function deleteLessonVideoFromStorage(
  urlOrPath: string | null | undefined
): Promise<{ success: boolean; error: Error | null }> {
  const path = extractStoragePath(urlOrPath, 'lesson-videos');
  if (!path || !isSupabaseConfigured) {
    return { success: true, error: null };
  }

  try {
    const { error } = await supabase.storage.from('lesson-videos').remove([path]);
    if (error) {
      return { success: false, error };
    }
    return { success: true, error: null };
  } catch (err) {
    return { success: false, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Generate a playback URL for a lesson video.
 * Handles both external streaming URLs (YouTube, Vimeo, CDN) and private Supabase storage paths.
 */
export async function getLessonVideoPlaybackUrl(
  videoUrl: string | null | undefined
): Promise<{
  url: string | null;
  isExternal: boolean;
  isEmbeddable: boolean;
  embedUrl: string | null;
  error: Error | null;
}> {
  if (!videoUrl || !videoUrl.trim()) {
    return { url: null, isExternal: false, isEmbeddable: false, embedUrl: null, error: null };
  }

  const trimmed = videoUrl.trim();

  // 1. Check for external video provider (YouTube / Vimeo)
  const youtubeMatch = trimmed.match(/(?:youtube\.com\/(?:[^/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?/\s]{11})/i);
  if (youtubeMatch) {
    return {
      url: trimmed,
      isExternal: true,
      isEmbeddable: true,
      embedUrl: `https://www.youtube.com/embed/${youtubeMatch[1]}?rel=0&modestbranding=1`,
      error: null,
    };
  }

  const vimeoMatch = trimmed.match(/(?:vimeo\.com\/)(\d+)/i);
  if (vimeoMatch) {
    return {
      url: trimmed,
      isExternal: true,
      isEmbeddable: true,
      embedUrl: `https://player.vimeo.com/video/${vimeoMatch[1]}`,
      error: null,
    };
  }

  // 2. Direct external HTTP video stream (e.g. mp4 from an external CDN)
  const storagePath = extractStoragePath(trimmed, 'lesson-videos');
  const isDirectExternal = (trimmed.startsWith('http://') || trimmed.startsWith('https://')) && !storagePath;

  if (isDirectExternal) {
    return {
      url: trimmed,
      isExternal: true,
      isEmbeddable: false,
      embedUrl: null,
      error: null,
    };
  }

  // 3. Supabase Storage managed video
  if (!isSupabaseConfigured) {
    return { url: null, isExternal: false, isEmbeddable: false, embedUrl: null, error: new Error('Supabase client not configured.') };
  }

  const targetPath = storagePath || trimmed;
  try {
    const { data, error } = await supabase.storage.from('lesson-videos').createSignedUrl(targetPath, 3600);
    if (error || !data?.signedUrl) {
      return {
        url: null,
        isExternal: false,
        isEmbeddable: false,
        embedUrl: null,
        error: error || new Error('Failed to generate video stream authorization token.'),
      };
    }

    return {
      url: data.signedUrl,
      isExternal: false,
      isEmbeddable: false,
      embedUrl: null,
      error: null,
    };
  } catch (err) {
    return {
      url: null,
      isExternal: false,
      isEmbeddable: false,
      embedUrl: null,
      error: err instanceof Error ? err : new Error(String(err)),
    };
  }
}

export interface VideoValidationResult {
  isValid: boolean;
  error?: string;
}

export function validateVideoFile(file: File): VideoValidationResult {
  const allowedMimeTypes = ['video/mp4', 'video/webm', 'video/ogg'];
  const maxSizeBytes = 500 * 1024 * 1024; // 500 MB

  if (!allowedMimeTypes.includes(file.type)) {
    return {
      isValid: false,
      error: `Unsupported format (${file.type || 'unknown'}). Allowed: MP4, WebM, OGG.`
    };
  }

  if (file.size > maxSizeBytes) {
    return {
      isValid: false,
      error: `File size exceeds 500 MB limit (current: ${(file.size / (1024 * 1024)).toFixed(1)} MB).`
    };
  }

  return { isValid: true };
}
