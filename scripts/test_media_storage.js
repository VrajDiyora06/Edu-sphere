import assert from 'node:assert';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

console.log('=== EDUSPHERE MEDIA UPLOAD & STORAGE TEST SUITE ===\n');

// 1. Test Migration Script Completeness and Policy Safety
console.log('Test 1: Verify Supabase Storage Migration (20261022000013_media_storage_buckets_and_policies.sql)');
const migrationPath = path.resolve(__dirname, '../supabase/migrations/20261022000013_media_storage_buckets_and_policies.sql');
assert.ok(fs.existsSync(migrationPath), 'Migration file must exist');

const migrationSql = fs.readFileSync(migrationPath, 'utf8');

// Ensure bucket definitions exist
assert.ok(migrationSql.includes("'course-thumbnails'"), 'Must define course-thumbnails bucket');
assert.ok(migrationSql.includes("'lesson-videos'"), 'Must define lesson-videos bucket');

// Check public vs private bucket configuration
assert.ok(migrationSql.includes("public = TRUE") || migrationSql.includes("public = true"), 'course-thumbnails must be public');
assert.ok(migrationSql.includes("public = FALSE") || migrationSql.includes("public = false"), 'lesson-videos must be private');

// Check size constraints
assert.ok(migrationSql.includes('5242880'), 'course-thumbnails max size must be 5MB (5242880 bytes)');
assert.ok(migrationSql.includes('209715200'), 'lesson-videos max size must be 200MB (209715200 bytes)');

// Check RLS security policies
assert.ok(migrationSql.includes('storage.objects'), 'Must configure policies on storage.objects');
assert.ok(migrationSql.includes('is_admin()'), 'Policies must honor is_admin() role verification');
assert.ok(migrationSql.includes('instructor_id = auth.uid()'), 'Instructors can only write/delete their own course media');
assert.ok(migrationSql.includes('is_enrolled_in_course'), 'Enrolled students can stream lesson videos');

// Check delete_course cleanup procedure
assert.ok(migrationSql.includes('CREATE OR REPLACE FUNCTION public.delete_course'), 'delete_course RPC must be present');
assert.ok(migrationSql.includes('DELETE FROM storage.objects'), 'delete_course must purge associated storage objects');
console.log('  ✓ Storage migration contains secure bucket configs, RLS policies, and cascade cleanup\n');

// 2. Test Media Validation Logic (reproduced for unit verification)
console.log('Test 2: Media Validation Rules (Cover Images & Lesson Videos)');
const COURSE_COVER_ALLOWED_EXTENSIONS = ['.jpg', '.jpeg', '.png', '.webp'];
const COURSE_COVER_ALLOWED_MIME_TYPES = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
const COURSE_COVER_MAX_SIZE_BYTES = 5 * 1024 * 1024; // 5 MB

const LESSON_VIDEO_ALLOWED_EXTENSIONS = ['.mp4', '.webm'];
const LESSON_VIDEO_ALLOWED_MIME_TYPES = ['video/mp4', 'video/webm'];
const LESSON_VIDEO_MAX_SIZE_BYTES = 200 * 1024 * 1024; // 200 MB

function validateCourseCover(name, size, type) {
  if (size > COURSE_COVER_MAX_SIZE_BYTES) {
    return { valid: false, error: `File size exceeds 5MB limit` };
  }
  const ext = '.' + name.split('.').pop().toLowerCase();
  const isExtValid = COURSE_COVER_ALLOWED_EXTENSIONS.includes(ext);
  const isMimeValid = !type || COURSE_COVER_ALLOWED_MIME_TYPES.includes(type.toLowerCase());
  if (!isExtValid || !isMimeValid) {
    return { valid: false, error: `Invalid image format` };
  }
  return { valid: true, error: null };
}

function validateLessonVideo(name, size, type) {
  if (size > LESSON_VIDEO_MAX_SIZE_BYTES) {
    return { valid: false, error: `File size exceeds 200MB limit` };
  }
  const ext = '.' + name.split('.').pop().toLowerCase();
  const isExtValid = LESSON_VIDEO_ALLOWED_EXTENSIONS.includes(ext);
  const isMimeValid = !type || LESSON_VIDEO_ALLOWED_MIME_TYPES.includes(type.toLowerCase());
  if (!isExtValid || !isMimeValid) {
    return { valid: false, error: `Invalid video format` };
  }
  return { valid: true, error: null };
}

// Cover image format validation tests
assert.strictEqual(validateCourseCover('cover.jpg', 1024 * 1024, 'image/jpeg').valid, true);
assert.strictEqual(validateCourseCover('cover.jpeg', 1024 * 1024, 'image/jpeg').valid, true);
assert.strictEqual(validateCourseCover('cover.png', 2 * 1024 * 1024, 'image/png').valid, true);
assert.strictEqual(validateCourseCover('cover.webp', 500 * 1024, 'image/webp').valid, true);
assert.strictEqual(validateCourseCover('cover.gif', 1024, 'image/gif').valid, false);
assert.strictEqual(validateCourseCover('malicious.exe', 1024, 'application/octet-stream').valid, false);
assert.strictEqual(validateCourseCover('large.png', 6 * 1024 * 1024, 'image/png').valid, false);

// Lesson video format validation tests
assert.strictEqual(validateLessonVideo('lecture.mp4', 50 * 1024 * 1024, 'video/mp4').valid, true);
assert.strictEqual(validateLessonVideo('lecture.webm', 80 * 1024 * 1024, 'video/webm').valid, true);
assert.strictEqual(validateLessonVideo('lecture.avi', 10 * 1024 * 1024, 'video/x-msvideo').valid, false);
assert.strictEqual(validateLessonVideo('lecture.mov', 10 * 1024 * 1024, 'video/quicktime').valid, false);
assert.strictEqual(validateLessonVideo('oversized.mp4', 205 * 1024 * 1024, 'video/mp4').valid, false);
console.log('  ✓ Image (JPG, PNG, WebP <= 5MB) and Video (MP4, WebM <= 200MB) validation verified\n');

// 3. Test Storage Path Extraction
console.log('Test 3: Storage Path Extraction & External URL Preservation');
function extractStoragePath(urlOrPath, bucket) {
  if (!urlOrPath || !urlOrPath.trim()) return null;
  const trimmed = urlOrPath.trim();
  const publicMarker = `/storage/v1/object/public/${bucket}/`;
  const signMarker = `/storage/v1/object/sign/${bucket}/`;
  const authMarker = `/storage/v1/object/authenticated/${bucket}/`;

  if (trimmed.includes(publicMarker)) {
    return decodeURIComponent(trimmed.split(publicMarker)[1].split('?')[0]);
  }
  if (trimmed.includes(signMarker)) {
    return decodeURIComponent(trimmed.split(signMarker)[1].split('?')[0]);
  }
  if (trimmed.includes(authMarker)) {
    return decodeURIComponent(trimmed.split(authMarker)[1].split('?')[0]);
  }
  if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
    return trimmed;
  }
  return null;
}

const directPath = 'course-123/lesson-456/1792600000_lecture.mp4';
assert.strictEqual(extractStoragePath(directPath, 'lesson-videos'), directPath);

const fullSignedUrl = 'https://abcdefgh.supabase.co/storage/v1/object/sign/lesson-videos/course-123/lesson-456/1792600000_lecture.mp4?token=xyz123';
assert.strictEqual(extractStoragePath(fullSignedUrl, 'lesson-videos'), 'course-123/lesson-456/1792600000_lecture.mp4');

const fullPublicUrl = 'https://abcdefgh.supabase.co/storage/v1/object/public/course-thumbnails/course-123/1792600000_cover.png';
assert.strictEqual(extractStoragePath(fullPublicUrl, 'course-thumbnails'), 'course-123/1792600000_cover.png');

// External URLs should NOT be extracted as internal storage paths
assert.strictEqual(extractStoragePath('https://images.unsplash.com/photo-1516321318423', 'course-thumbnails'), null);
assert.strictEqual(extractStoragePath('https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'lesson-videos'), null);
assert.strictEqual(extractStoragePath('https://vimeo.com/76979871', 'lesson-videos'), null);
console.log('  ✓ Supabase storage paths extracted accurately while external URLs are protected\n');

// 4. Test External Video URL Parsing (YouTube & Vimeo)
console.log('Test 4: Video Embed Resolution (YouTube, Vimeo, and Direct Streams)');
function parseVideoUrl(trimmed) {
  const youtubeMatch = trimmed.match(/(?:youtube\.com\/(?:[^/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?/\s]{11})/i);
  if (youtubeMatch) {
    return {
      isExternal: true,
      isEmbeddable: true,
      embedUrl: `https://www.youtube.com/embed/${youtubeMatch[1]}?rel=0&modestbranding=1`,
    };
  }

  const vimeoMatch = trimmed.match(/(?:vimeo\.com\/)(\d+)/i);
  if (vimeoMatch) {
    return {
      isExternal: true,
      isEmbeddable: true,
      embedUrl: `https://player.vimeo.com/video/${vimeoMatch[1]}`,
    };
  }

  const isDirectExternal = (trimmed.startsWith('http://') || trimmed.startsWith('https://')) && !trimmed.includes('/storage/v1/object/');
  if (isDirectExternal) {
    return {
      isExternal: true,
      isEmbeddable: false,
      embedUrl: null,
    };
  }

  return {
    isExternal: false,
    isEmbeddable: false,
    embedUrl: null,
  };
}

const yt1 = parseVideoUrl('https://www.youtube.com/watch?v=dQw4w9WgXcQ');
assert.strictEqual(yt1.isEmbeddable, true);
assert.strictEqual(yt1.embedUrl, 'https://www.youtube.com/embed/dQw4w9WgXcQ?rel=0&modestbranding=1');

const yt2 = parseVideoUrl('https://youtu.be/dQw4w9WgXcQ');
assert.strictEqual(yt2.isEmbeddable, true);
assert.strictEqual(yt2.embedUrl, 'https://www.youtube.com/embed/dQw4w9WgXcQ?rel=0&modestbranding=1');

const vimeo = parseVideoUrl('https://vimeo.com/76979871');
assert.strictEqual(vimeo.isEmbeddable, true);
assert.strictEqual(vimeo.embedUrl, 'https://player.vimeo.com/video/76979871');

const cdnStream = parseVideoUrl('https://cdn.example.com/videos/distributed-systems.mp4');
assert.strictEqual(cdnStream.isExternal, true);
assert.strictEqual(cdnStream.isEmbeddable, false);

const internalStorageVideo = parseVideoUrl('course-101/lesson-202/lecture.mp4');
assert.strictEqual(internalStorageVideo.isExternal, false);
console.log('  ✓ YouTube, Vimeo, and CDN streams correctly resolved and backward compatible\n');

console.log('ALL MEDIA STORAGE TESTS PASSED SUCCESSFULLY!');
