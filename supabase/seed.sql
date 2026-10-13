-- ============================================================================
-- EduSphere Seed Script: Published Course & Lessons
-- ============================================================================
-- Prerequisites:
-- 1. An instructor account (e.g. instructor@edusphere.local) must exist in
--    auth.users and public.profiles.
-- 2. That account must already hold the 'instructor' role assigned through
--    an administrator action via public.admin_set_user_role().
-- ============================================================================

DO $$
DECLARE
  v_instructor_email CONSTANT TEXT := 'instructor@edusphere.local';
  v_instructor_id UUID;
  v_instructor_role TEXT;
  v_course_id UUID;
BEGIN
  -- 1. Verify that the instructor account exists in public.profiles
  SELECT id, role INTO v_instructor_id, v_instructor_role
  FROM public.profiles
  WHERE email = v_instructor_email;

  IF v_instructor_id IS NULL THEN
    RAISE EXCEPTION 
      'Prerequisite failed: Account "%" was not found in public.profiles. Please create this user first via Supabase Authentication (Authentication -> Users -> Add user -> Create user).',
      v_instructor_email;
  END IF;

  -- 2. Verify that the instructor account already holds the 'instructor' role
  -- Under trg_protect_profile_role and course RLS policies, courses must be
  -- authored by an instructor. This script never deletes profiles or bypasses triggers.
  IF v_instructor_role IS DISTINCT FROM 'instructor' THEN
    RAISE EXCEPTION 
      'Prerequisite failed: Account "%" currently has role "%", but must have role "instructor" to author courses. Under trg_protect_profile_role, role elevation requires an administrator action using public.admin_set_user_role().',
      v_instructor_email, v_instructor_role;
  END IF;

  -- 3. Update non-role metadata safely (full_name, avatar_url, bio)
  -- Because role is not modified, trg_protect_profile_role permits this UPDATE.
  UPDATE public.profiles
  SET full_name = 'Dr. Elena Rostova',
      avatar_url = 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=200&auto=format&fit=crop',
      bio = 'Distinguished Systems Architect and Distributed Computing Researcher',
      updated_at = NOW()
  WHERE id = v_instructor_id;

  -- 4. Upsert Course (repeatable via UNIQUE slug constraint)
  INSERT INTO public.courses (
    title,
    slug,
    description,
    category,
    level,
    thumbnail_url,
    instructor_id,
    is_published
  ) VALUES (
    'Distributed Systems Engineering',
    'distributed-systems-engineering',
    'Master consensus algorithms, raft protocols, replication patterns, and fault-tolerant architecture for modern cloud backends.',
    'Software Architecture',
    'Intermediate',
    'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?q=80&w=800&auto=format&fit=crop',
    v_instructor_id,
    true
  )
  ON CONFLICT (slug) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    category = EXCLUDED.category,
    level = EXCLUDED.level,
    thumbnail_url = EXCLUDED.thumbnail_url,
    instructor_id = EXCLUDED.instructor_id,
    is_published = EXCLUDED.is_published,
    updated_at = NOW()
  RETURNING id INTO v_course_id;

  IF v_course_id IS NULL THEN
    SELECT id INTO v_course_id FROM public.courses WHERE slug = 'distributed-systems-engineering';
  END IF;

  -- 5. Upsert 3 Lessons (repeatable via fixed primary key UUIDs)
  INSERT INTO public.lessons (
    id,
    course_id,
    title,
    content,
    video_url,
    duration_minutes,
    is_free_preview,
    order_index
  ) VALUES
    (
      'c0000000-0000-0000-0000-000000000001',
      v_course_id,
      'Introduction to Consensus & CAP Theorem',
      'Foundations of distributed systems consistency, network partitions, and latency vs correctness trade-offs.',
      'https://www.youtube.com/watch?v=k-Yaq8AHlFA',
      25,
      true,
      1
    ),
    (
      'c0000000-0000-0000-0000-000000000002',
      v_course_id,
      'The Raft Consensus Protocol in Depth',
      'Leader election, log replication, safety guarantees, and split-brain prevention.',
      'https://www.youtube.com/watch?v=vYp4LYbnnW8',
      40,
      false,
      2
    ),
    (
      'c0000000-0000-0000-0000-000000000003',
      v_course_id,
      'Eventual Consistency & CRDTs',
      'Conflict-free replicated data types, state-based vs operation-based replication, and vector clocks.',
      'https://www.youtube.com/watch?v=em9zLzM8PDY',
      35,
      false,
      3
    )
  ON CONFLICT (id) DO UPDATE SET
    course_id = EXCLUDED.course_id,
    title = EXCLUDED.title,
    content = EXCLUDED.content,
    video_url = EXCLUDED.video_url,
    duration_minutes = EXCLUDED.duration_minutes,
    is_free_preview = EXCLUDED.is_free_preview,
    order_index = EXCLUDED.order_index;

  RAISE NOTICE 'Seed completed successfully for course % with instructor %', v_course_id, v_instructor_id;
END $$;

-- 6. Verification Query
SELECT 
  c.id AS course_id,
  c.title AS course_title,
  c.slug,
  c.is_published,
  p.full_name AS instructor_name,
  p.role AS instructor_role,
  p.email AS instructor_email,
  COUNT(l.id) AS lessons_count
FROM public.courses c
JOIN public.profiles p ON p.id = c.instructor_id
LEFT JOIN public.lessons l ON l.course_id = c.id
WHERE c.slug = 'distributed-systems-engineering'
GROUP BY c.id, c.title, c.slug, c.is_published, p.full_name, p.role, p.email;
