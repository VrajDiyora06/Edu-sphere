-- ============================================================================
-- EduSphere Migration 20261021000010: Comprehensive Academic Catalog Seed
-- ============================================================================
-- Populates 15 full B.Tech level academic courses, 105 lessons, 60 quizzes,
-- 416 questions, and 30 assignments.
--
-- Safety & Idempotency:
-- - Uses fixed deterministic UUIDs and ON CONFLICT DO UPDATE.
-- - Preserves existing course (Distributed Systems Engineering) and all existing
--   user accounts, progress, enrollments, certificates, and submissions.
-- - Reuses genuine verified instructor: Dr. Elena Rostova (c6086584-6cf7-43a4-ae1b-6bd3bb3f7293).
-- - Zero fake users, zero fake reviews, zero RLS weakening.
-- - Strictly conforms to live database column schemas:
--   * public.lessons: NO updated_at
--   * public.quizzes: NO order_index
--   * public.quiz_questions: NO updated_at
-- ============================================================================

DO $$
DECLARE
  v_instructor_id CONSTANT UUID := 'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID;
  v_instructor_role TEXT;
BEGIN
  -- 1. Verify instructor account exists and holds instructor role
  SELECT role INTO v_instructor_role
  FROM public.profiles
  WHERE id = v_instructor_id;

  IF v_instructor_role IS NULL THEN
    RAISE EXCEPTION 'Prerequisite failed: Instructor % was not found in public.profiles.', v_instructor_id;
  END IF;

  IF v_instructor_role NOT IN ('instructor', 'admin', 'system_admin') THEN
    RAISE EXCEPTION 'Prerequisite failed: Account % has role "%", must be instructor.', v_instructor_id, v_instructor_role;
  END IF;

  RAISE NOTICE 'Instructor verification passed for % (Dr. Elena Rostova)', v_instructor_id;
END $$;

BEGIN;

-- ============================================================================
-- 1. INSERT / UPSERT COURSES (15 Academic Courses)
-- ============================================================================

INSERT INTO public.courses (
  id,
  title,
  slug,
  description,
  category,
  level,
  thumbnail_url,
  instructor_id,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0000-000000000001'::UUID,
  'Python Programming: Beginner to Intermediate',
  'python-programming-beginner-to-intermediate',
  'Master foundational to intermediate Python programming: dynamic typing, control flow, functions, compound data structures, object-oriented design, error handling, and file I/O.',
  'Computer Science',
  'Beginner',
  'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?q=80&w=800&auto=format&fit=crop',
  'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  level = EXCLUDED.level,
  thumbnail_url = EXCLUDED.thumbnail_url,
  instructor_id = EXCLUDED.instructor_id,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.courses (
  id,
  title,
  slug,
  description,
  category,
  level,
  thumbnail_url,
  instructor_id,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0000-000000000002'::UUID,
  'Java Programming and Object-Oriented Design',
  'java-programming-object-oriented-design',
  'Master enterprise Java: JVM architecture, object-oriented design patterns, inheritance, abstract classes, interfaces, checked exception architecture, generic collections, and multi-threading.',
  'Computer Science',
  'Intermediate',
  'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=800&auto=format&fit=crop',
  'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  level = EXCLUDED.level,
  thumbnail_url = EXCLUDED.thumbnail_url,
  instructor_id = EXCLUDED.instructor_id,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.courses (
  id,
  title,
  slug,
  description,
  category,
  level,
  thumbnail_url,
  instructor_id,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0000-000000000003'::UUID,
  'Data Structures and Algorithms',
  'data-structures-and-algorithms',
  'Comprehensive undergraduate algorithms curriculum: asymptotic complexity, linear structures, trees, priority heaps, graph traversal, shortest path algorithms, dynamic programming, and greedy optimization.',
  'Computer Science',
  'Intermediate',
  'https://images.unsplash.com/photo-1509228468518-180dd4864904?q=80&w=800&auto=format&fit=crop',
  'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  level = EXCLUDED.level,
  thumbnail_url = EXCLUDED.thumbnail_url,
  instructor_id = EXCLUDED.instructor_id,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.courses (
  id,
  title,
  slug,
  description,
  category,
  level,
  thumbnail_url,
  instructor_id,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0000-000000000004'::UUID,
  'Full-Stack Web Development',
  'full-stack-web-development',
  'Modern full-stack web engineering: HTTP/1.1 to HTTP/3 protocols, semantic HTML5, responsive CSS Grid/Flexbox, ES6+ asynchronous JavaScript, React component hierarchies, state management, REST API architecture, and token security.',
  'Web Development',
  'Intermediate',
  'https://images.unsplash.com/photo-1547658719-da2b51169166?q=80&w=800&auto=format&fit=crop',
  'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  level = EXCLUDED.level,
  thumbnail_url = EXCLUDED.thumbnail_url,
  instructor_id = EXCLUDED.instructor_id,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.courses (
  id,
  title,
  slug,
  description,
  category,
  level,
  thumbnail_url,
  instructor_id,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0000-000000000005'::UUID,
  'Database Management Systems and SQL',
  'database-management-systems-sql',
  'Master relational database theory and modern SQL engineering: ER modeling, relational algebra, schema normalization (1NF to BCNF), complex multi-table joins, window functions, B-tree indexing, ACID transactions, and MVCC concurrency.',
  'Database Engineering',
  'Intermediate',
  'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?q=80&w=800&auto=format&fit=crop',
  'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  level = EXCLUDED.level,
  thumbnail_url = EXCLUDED.thumbnail_url,
  instructor_id = EXCLUDED.instructor_id,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.courses (
  id,
  title,
  slug,
  description,
  category,
  level,
  thumbnail_url,
  instructor_id,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0000-000000000006'::UUID,
  'Operating Systems Fundamentals',
  'operating-systems-fundamentals',
  'Undergraduate operating systems engineering: kernel architecture, dual-mode operation, process lifecycles, CPU scheduling algorithms, synchronization primitives (semaphores, mutexes), deadlock characterization, virtual memory paging, and page replacement.',
  'Computer Science',
  'Intermediate',
  'https://images.unsplash.com/photo-1629654297299-c8506221ca97?q=80&w=800&auto=format&fit=crop',
  'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  level = EXCLUDED.level,
  thumbnail_url = EXCLUDED.thumbnail_url,
  instructor_id = EXCLUDED.instructor_id,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.courses (
  id,
  title,
  slug,
  description,
  category,
  level,
  thumbnail_url,
  instructor_id,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0000-000000000007'::UUID,
  'Computer Networks',
  'computer-networks-principles',
  'Comprehensive undergraduate computer networks curriculum: OSI 7-layer vs TCP/IP models, application protocols (HTTP/DNS), TCP reliability, sliding window, AIMD congestion control, IPv4/IPv6 CIDR subnetting, link-state routing, and network security.',
  'Computer Science',
  'Intermediate',
  'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?q=80&w=800&auto=format&fit=crop',
  'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  level = EXCLUDED.level,
  thumbnail_url = EXCLUDED.thumbnail_url,
  instructor_id = EXCLUDED.instructor_id,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.courses (
  id,
  title,
  slug,
  description,
  category,
  level,
  thumbnail_url,
  instructor_id,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0000-000000000008'::UUID,
  'Software Engineering and Testing',
  'software-engineering-and-testing',
  'Undergraduate software engineering methodologies: SDLC models (Agile, Scrum, Waterfall), requirements engineering (SRS, IEEE 830), SOLID architectural design principles, black-box and white-box test design, TDD, CI/CD automation pipelines, and code review practices.',
  'Software Architecture',
  'Intermediate',
  'https://images.unsplash.com/photo-1516116211227-bbc04c979bf7?q=80&w=800&auto=format&fit=crop',
  'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  level = EXCLUDED.level,
  thumbnail_url = EXCLUDED.thumbnail_url,
  instructor_id = EXCLUDED.instructor_id,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.courses (
  id,
  title,
  slug,
  description,
  category,
  level,
  thumbnail_url,
  instructor_id,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0000-000000000009'::UUID,
  'Artificial Intelligence Fundamentals',
  'artificial-intelligence-fundamentals',
  'Foundational study of classical artificial intelligence: intelligent agents, state-space formulation, uninformed vs informed heuristic search (A*, IDA*), adversarial game playing (Minimax, Alpha-Beta pruning), constraint satisfaction problems (CSP), and propositional logic knowledge bases.',
  'AI & Data Science',
  'Intermediate',
  'https://images.unsplash.com/photo-1677442136019-21780ecad995?q=80&w=800&auto=format&fit=crop',
  'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  level = EXCLUDED.level,
  thumbnail_url = EXCLUDED.thumbnail_url,
  instructor_id = EXCLUDED.instructor_id,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.courses (
  id,
  title,
  slug,
  description,
  category,
  level,
  thumbnail_url,
  instructor_id,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0000-000000000010'::UUID,
  'Machine Learning Foundations',
  'machine-learning-foundations',
  'Rigorous introduction to statistical machine learning: supervised learning, linear and logistic regression, gradient descent optimization, bias-variance tradeoff, regularization (L1/L2), decision trees, ensemble methods (Random Forests, Gradient Boosting), SVMs, unsupervised clustering (K-Means, GMM), and PCA dimensionality reduction.',
  'AI & Data Science',
  'Intermediate',
  'https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?q=80&w=800&auto=format&fit=crop',
  'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  level = EXCLUDED.level,
  thumbnail_url = EXCLUDED.thumbnail_url,
  instructor_id = EXCLUDED.instructor_id,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.courses (
  id,
  title,
  slug,
  description,
  category,
  level,
  thumbnail_url,
  instructor_id,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0000-000000000011'::UUID,
  'Generative AI and Large Language Models',
  'generative-ai-large-language-models',
  'Comprehensive study of modern generative architectures: self-attention mechanisms, Transformer encoders and decoders, pretraining objectives (Causal LM, Masked LM), scaling laws, instruction fine-tuning, RLHF, Parameter-Efficient Fine-Tuning (LoRA, QLoRA), Retrieval-Augmented Generation (RAG), and hallucination mitigation.',
  'AI & Data Science',
  'Advanced',
  'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?q=80&w=800&auto=format&fit=crop',
  'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  level = EXCLUDED.level,
  thumbnail_url = EXCLUDED.thumbnail_url,
  instructor_id = EXCLUDED.instructor_id,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.courses (
  id,
  title,
  slug,
  description,
  category,
  level,
  thumbnail_url,
  instructor_id,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0000-000000000012'::UUID,
  'Engineering Mathematics and Linear Algebra',
  'engineering-mathematics-linear-algebra',
  'Undergraduate engineering mathematics foundation: vector spaces, subspaces, linear independence, matrix factorizations (LU, QR, SVD), eigenvalues and eigenvectors, multivariable calculus, Taylor approximations, and ordinary differential equations.',
  'Engineering & Math',
  'Intermediate',
  'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?q=80&w=800&auto=format&fit=crop',
  'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  level = EXCLUDED.level,
  thumbnail_url = EXCLUDED.thumbnail_url,
  instructor_id = EXCLUDED.instructor_id,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.courses (
  id,
  title,
  slug,
  description,
  category,
  level,
  thumbnail_url,
  instructor_id,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0000-000000000013'::UUID,
  'Digital Logic and Computer Organization',
  'digital-logic-computer-organization',
  'Hardware engineering from boolean gates to microarchitecture: Boolean algebra, Karnaugh maps, combinational logic (Adders, Multiplexers, ALUs), sequential circuits (Flip-Flops, FSMs), RISC-V instruction set architecture, 5-stage classic pipeline, hazard mitigation, and cache memory hierarchy.',
  'Engineering & Math',
  'Intermediate',
  'https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=800&auto=format&fit=crop',
  'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  level = EXCLUDED.level,
  thumbnail_url = EXCLUDED.thumbnail_url,
  instructor_id = EXCLUDED.instructor_id,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.courses (
  id,
  title,
  slug,
  description,
  category,
  level,
  thumbnail_url,
  instructor_id,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0000-000000000014'::UUID,
  'Data Analytics with Python',
  'data-analytics-with-python',
  'Practical data science and analytics engineering: NumPy vectorized computations, Pandas data wrangling and aggregation, exploratory data analysis (EDA), data visualization with Matplotlib and Seaborn, hypothesis testing, A/B testing statistical methodology, and interactive dashboards.',
  'Data Science',
  'Beginner',
  'https://images.unsplash.com/photo-1551288049-bebda4e38f71?q=80&w=800&auto=format&fit=crop',
  'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  level = EXCLUDED.level,
  thumbnail_url = EXCLUDED.thumbnail_url,
  instructor_id = EXCLUDED.instructor_id,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.courses (
  id,
  title,
  slug,
  description,
  category,
  level,
  thumbnail_url,
  instructor_id,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0000-000000000015'::UUID,
  'Technical Communication and Problem Solving',
  'technical-communication-problem-solving',
  'Essential professional engineering capabilities: structured technical writing (RFCs, design documents, postmortems), API documentation, root cause analysis (5 Whys, Ishikawa diagrams), cognitive bias mitigation, engineering trade-off frameworks, and collaborative technical presentation.',
  'Professional Development',
  'Beginner',
  'https://images.unsplash.com/photo-1522071820081-009f0129c71c?q=80&w=800&auto=format&fit=crop',
  'c6086584-6cf7-43a4-ae1b-6bd3bb3f7293'::UUID,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  level = EXCLUDED.level,
  thumbnail_url = EXCLUDED.thumbnail_url,
  instructor_id = EXCLUDED.instructor_id,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

-- ============================================================================
-- 2. INSERT / UPSERT LESSONS (105 Structured Curriculum Lessons)
-- ============================================================================

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0101-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000001'::UUID,
  'Python Architecture, Dynamic Typing & Primitive Data Types',
  '### Learning Objectives
- Understand the CPython execution pipeline: source code to bytecode compilation and PVM execution.
- Master dynamic typing, reference semantics, and garbage collection mechanisms.
- Work effectively with primitive types: `int`, `float`, `bool`, and `str`.

### CPython Architecture
Python is an interpreted, dynamically typed language. When you execute a script `python main.py`, CPython compiles the source into bytecode (`.pyc` files) stored in memory or `__pycache__`. The Python Virtual Machine (PVM) reads and executes these bytecode instructions sequentially.

```python
# Variable names are references to heap objects
a = 42
b = a
print(id(a) == id(b))  # True: both reference the same integer object
a = a + 1
print(id(a) == id(b))  # False: integers are immutable; new object allocated
```

### Primitive Types and Operations
- **Integers**: Arbitrary precision in Python 3; no integer overflow limit.
- **Floats**: Implemented as C IEEE 754 double-precision floats (64-bit).
- **Strings**: Immutable sequences of Unicode code points.

```python
temperature = 98.6
status = "Optimal"
reading_count = 1000

formatted = f"Status: {status} | Temp: {temperature:.1f}F | Total: {reading_count:,}"
print(formatted)
```

### Key Takeaways
- Variables in Python are pointers/references to heap objects, not typed memory buckets.
- Immutable primitives (`int`, `float`, `str`, `tuple`) cannot be modified in place; reassignments create new objects.',
  NULL,
  35,
  true,
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0101-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000001'::UUID,
  'Control Flow, Loops, and Iteration Protocols',
  '### Learning Objectives
- Implement conditional branching using `if`, `elif`, `else`, and ternary expressions.
- Master bounded iteration with `for` loops and unbounded iteration with `while` loops.
- Understand the iterator protocol: `__iter__()` and `__next__()`.

### Conditional Logic
Python evaluates truthiness according to standard rules: empty collections, zero values, and `None` evaluate to `False`; non-empty collections evaluate to `True`.

```python
threshold = 85.0
current_load = 92.4

alert_level = "CRITICAL" if current_load > 90.0 else ("WARNING" if current_load > threshold else "NORMAL")
print(f"Server Alert Level: {alert_level}")
```

### Looping Constructs & Iterator Protocol
```python
# Enumerate provides index-value tuples
metrics = [12.4, 14.8, 19.2, 11.0]
for idx, val in enumerate(metrics, start=1):
    if val > 15.0:
        print(f"Sample #{idx} breached safety limit: {val}")
        break
else:
    # Executes only if loop terminates without hitting break
    print("All samples within normal parameters.")
```

### Key Takeaways
- The `for...else` construct runs the `else` block only if the loop ran to completion without encountering a `break` statement.
- `zip()` and `enumerate()` provide memory-efficient generator iterators over sequences.',
  NULL,
  40,
  false,
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0101-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000001'::UUID,
  'Functions, Scoping Rules (LEGB), and Lambda Expressions',
  '### Learning Objectives
- Define functions with positional, default, `*args`, and `**kwargs` parameters.
- Master variable resolution through the LEGB rule (Local, Enclosing, Global, Built-in).
- Apply higher-order functional tools: `map()`, `filter()`, and anonymous `lambda` functions.

### Parameter Passing & Default Value Pitfalls
In Python, arguments are passed by **assignment** (object reference). Mutable default arguments retain state across invocations.

```python
# Correct pattern for mutable defaults:
def append_event(event_name: str, event_log: list = None) -> list:
    if event_log is None:
        event_log = []
    event_log.append(event_name)
    return event_log
```

### The LEGB Scoping Rule
1. **Local**: Names assigned inside a function body.
2. **Enclosing**: Names in outer enclosing functions (closures).
3. **Global**: Names assigned at the top level of a module.
4. **Built-in**: Pre-assigned names in the Python runtime (`len`, `range`, `int`).

```python
# Demonstrating closures with nonlocal state
def make_counter(start: int = 0):
    count = start
    def increment():
        nonlocal count
        count += 1
        return count
    return increment

counter = make_counter(10)
print(counter()) # 11
print(counter()) # 12
```

### Key Takeaways
- Never use mutable objects (e.g. `[]` or `{}`) as default parameter values.
- Closures capture outer function variables through lexical scoping; use `nonlocal` to rebind enclosing variables.',
  NULL,
  45,
  false,
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0101-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000001'::UUID,
  'Compound Data Structures: Lists, Tuples, Dictionaries & Sets',
  '### Learning Objectives
- Differentiate between ordered mutable sequences (`list`), immutable records (`tuple`), hash tables (`dict`), and uniqueness sets (`set`).
- Write concise, readable list, dictionary, and set comprehensions.
- Understand hashability requirements for dictionary keys and set members.

### Data Structure Complexity Comparison
| Structure | Indexing | Search | Insertion | Deletion |
| :--- | :--- | :--- | :--- | :--- |
| **List** | $O(1)$ | $O(n)$ | $O(1)$ append / $O(n)$ insert | $O(n)$ |
| **Tuple** | $O(1)$ | $O(n)$ | Immutable ($N/A$) | Immutable ($N/A$) |
| **Dict** | $N/A$ | $O(1)$ avg | $O(1)$ avg | $O(1)$ avg |
| **Set** | $N/A$ | $O(1)$ avg | $O(1)$ avg | $O(1)$ avg |

```python
# Comprehensions and dictionary filtering
raw_scores = {"Alice": 92, "Bob": 67, "Charlie": 88, "Dana": 54}
passing_students = {k: v for k, v in raw_scores.items() if v >= 70}
print("Passing students:", passing_students)

# Set operations for membership and difference
required_modules = {"auth", "db", "api", "monitoring"}
completed_modules = {"auth", "db"}
missing_modules = required_modules - completed_modules
print("Missing modules:", missing_modules)
```

### Key Takeaways
- Dictionary keys and set elements must be **hashable** (immutable objects implementing `__hash__` and `__eq__`).
- List comprehensions execute faster than explicit `for` loops due to optimized bytecode iteration.',
  NULL,
  50,
  false,
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0101-000000000005'::UUID,
  'd0000000-0000-0000-0000-000000000001'::UUID,
  'Object-Oriented Python: Classes, Encapsulation & Dunder Methods',
  '### Learning Objectives
- Design custom classes using `__init__`, encapsulation conventions, and properties.
- Implement special methods (dunder methods): `__str__`, `__repr__`, `__eq__`, and `__len__`.
- Apply inheritance, `super()`, and Method Resolution Order (MRO).

### Class Implementation with Properties
```python
class BankAccount:
    """Demonstrates encapsulation using properties."""
    def __init__(self, account_holder: str, initial_balance: float = 0.0):
        self.account_holder = account_holder
        self._balance = max(0.0, initial_balance)

    @property
    def balance(self) -> float:
        return self._balance

    def deposit(self, amount: float) -> None:
        if amount <= 0:
            raise ValueError("Deposit amount must be strictly positive.")
        self._balance += amount

    def withdraw(self, amount: float) -> None:
        if amount > self._balance:
            raise ValueError("Insufficient funds for requested withdrawal.")
        self._balance -= amount

    def __repr__(self) -> str:
        return f"BankAccount(holder={self.account_holder!r}, balance={self._balance:.2f})"
```

### Key Takeaways
- Python uses conventions (leading underscore `_field`) for protected attributes and double underscore for name mangling.
- Use `@property` decorators to implement computed fields and validation without breaking attribute-access APIs.',
  NULL,
  50,
  false,
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0101-000000000006'::UUID,
  'd0000000-0000-0000-0000-000000000001'::UUID,
  'Exception Handling Architecture & Custom Error Classes',
  '### Learning Objectives
- Construct resilient exception handling pipelines using `try`, `except`, `else`, and `finally`.
- Design custom exception hierarchies inheriting from `Exception`.
- Manage resources cleanly using the context manager protocol (`with` statement).

### Custom Exception Hierarchy
```python
class ApplicationError(Exception):
    """Base application exception."""
    pass

class ResourceNotFoundError(ApplicationError):
    def __init__(self, resource_type: str, resource_id: str):
        super().__init__(f"{resource_type} with ID ''{resource_id}'' was not found.")
        self.resource_id = resource_id

def fetch_user_record(user_id: str) -> dict:
    database = {"usr_101": {"name": "Alex", "active": True}}
    if user_id not in database:
        raise ResourceNotFoundError("UserProfile", user_id)
    return database[user_id]
```

### Resource Management with Context Managers
```python
class DatabaseConnection:
    def __enter__(self):
        print("Acquiring connection resource...")
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        print("Releasing connection resource safely.")
        return False # propagate exceptions if any occurred
```

### Key Takeaways
- The `else` block in exception handling executes only if no exception was raised in the `try` block.
- Always catch specific exceptions; avoid bare `except:` clauses that swallow system interrupts like `KeyboardInterrupt`.',
  NULL,
  40,
  false,
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0101-000000000007'::UUID,
  'd0000000-0000-0000-0000-000000000001'::UUID,
  'File I/O, JSON Serialization, and Standard Library Modules',
  '### Learning Objectives
- Read and write text and binary files using secure context managers.
- Serialize and deserialize structured data using Python''s `json` module.
- Utilize standard library utilities: `pathlib`, `datetime`, and `collections.defaultdict`.

### Safe File Handling & JSON Workflows
```python
import json
from pathlib import Path

data_payload = {
    "system_name": "EduSphere Kernel",
    "version": "2.4.0",
    "active_services": ["auth", "catalog", "grading"],
    "metrics": {"uptime_hours": 720, "error_rate": 0.001}
}

file_path = Path("system_config.json")

# Writing JSON safely
with open(file_path, mode="w", encoding="utf-8") as f:
    json.dump(data_payload, f, indent=2)

# Reading JSON safely
with open(file_path, mode="r", encoding="utf-8") as f:
    loaded_data = json.load(f)

print(f"Loaded config for {loaded_data[''system_name'']} v{loaded_data[''version'']}")
```

### Key Takeaways
- Always specify `encoding="utf-8"` when reading or writing text files to avoid platform-dependent encoding mismatches.
- Use `pathlib.Path` for cross-platform file path resolution instead of brittle string concatenation.',
  NULL,
  45,
  false,
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0102-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000002'::UUID,
  'Java Platform Architecture: JVM, JRE, JDK & Memory Model',
  '### Learning Objectives
- Differentiate between the Java Development Kit (JDK), Java Runtime Environment (JRE), and Java Virtual Machine (JVM).
- Understand the Java memory model: Stack memory, Heap memory, Metaspace, and Garbage Collection.
- Trace the lifecycle from Java source code compilation to classloading and JIT execution.

### Java Architecture Pipeline
Java achieves platform independence ("Write Once, Run Anywhere") through bytecode. `javac` compiles source code into `.class` bytecode files, which the JVM ClassLoader loads into memory. The JVM interpreter executes bytecode while the Just-In-Time (JIT) compiler compiles frequently executed "hot" code paths directly into native machine code.

```
Source (.java)  ---javac--->  Bytecode (.class)  --->  JVM (ClassLoader -> Execution Engine [JIT])
```

### Memory Organization
- **Stack Memory**: Stores thread-specific primitive values and reference pointers to heap objects. Deallocated immediately as frames exit.
- **Heap Memory**: Stores all instantiated objects and arrays. Managed globally by the Garbage Collector (Young and Old generations).
- **Metaspace**: Stores class metadata, bytecode definitions, and static fields.

### Key Takeaways
- Primitives are stored on the stack (when local); all objects are allocated on the heap.
- Java is strictly **pass-by-value**: for object references, a copy of the reference pointer is passed.',
  NULL,
  40,
  true,
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0102-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000002'::UUID,
  'Classes, Objects, and Encapsulation Principles',
  '### Learning Objectives
- Design cohesive classes adhering to encapsulation principles.
- Apply access modifiers (`private`, `package-private`, `protected`, `public`) appropriately.
- Utilize constructors, the `this` keyword, and constructor chaining.

### Encapsulation Pattern
Encapsulation bundles data with the methods that operate on that data and hides internal state from unauthorized external mutation.

```java
public class StudentRecord {
    private final String studentId;
    private String fullName;
    private double gpa;

    public StudentRecord(String studentId, String fullName, double gpa) {
        if (studentId == null || studentId.isBlank()) {
            throw new IllegalArgumentException("Student ID cannot be empty.");
        }
        this.studentId = studentId;
        this.fullName = fullName;
        setGpa(gpa);
    }

    public void setGpa(double gpa) {
        if (gpa < 0.0 || gpa > 4.0) {
            throw new IllegalArgumentException("GPA must be between 0.0 and 4.0.");
        }
        this.gpa = gpa;
    }

    public double getGpa() { return gpa; }
    public String getStudentId() { return studentId; }
    public String getFullName() { return fullName; }
}
```

### Key Takeaways
- Declare fields as `private` and provide controlled accessor/mutator methods to maintain class invariants.
- Use the `final` modifier for immutable fields that cannot change after constructor initialization.',
  NULL,
  45,
  false,
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0102-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000002'::UUID,
  'Inheritance, Method Overriding, and Dynamic Polymorphism',
  '### Learning Objectives
- Build class hierarchies using the `extends` keyword.
- Override parent methods cleanly using the `@Override` annotation.
- Understand dynamic method dispatch and run-time polymorphism.

### Dynamic Polymorphism Demonstration
Dynamic polymorphism allows a parent class reference to point to any subclass instance, resolving method invocations at runtime according to the actual object type.

```java
public class Account {
    protected double balance;

    public Account(double balance) { this.balance = balance; }

    public double calculateMonthlyFee() {
        return 5.0; // Standard base fee
    }
}

public class PremiumAccount extends Account {
    public PremiumAccount(double balance) { super(balance); }

    @Override
    public double calculateMonthlyFee() {
        return balance > 5000.0 ? 0.0 : 2.5; // Discounted fee
    }
}

// Polymorphic invocation:
Account acc = new PremiumAccount(8000.0);
System.out.println(acc.calculateMonthlyFee()); // Outputs: 0.0 (dynamically dispatched)
```

### Key Takeaways
- The `super` keyword accesses parent constructors and overridden parent methods.
- Methods marked `final` or `private` cannot be overridden, enabling compile-time static binding.',
  NULL,
  50,
  false,
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0102-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000002'::UUID,
  'Abstract Classes and Interfaces: Contracts and Multiple Inheritance',
  '### Learning Objectives
- Compare abstract classes (`is-a` relationship) with interfaces (`can-do` contract).
- Implement multiple interfaces in a single class.
- Utilize default and static methods in modern Java interfaces (Java 8+).

### Architectural Interface Design
```java
public interface PaymentGateway {
    boolean processPayment(double amount);
    
    // Default method providing fallback behavior
    default void logTransaction(String transactionId, double amount) {
        System.out.println("LOG [" + transactionId + "]: Transacted $" + amount);
    }
}

public interface Refundable {
    boolean refundPayment(String transactionId, double amount);
}

public class StripeService implements PaymentGateway, Refundable {
    @Override
    public boolean processPayment(double amount) {
        System.out.println("Charging $" + amount + " via Stripe API.");
        return true;
    }

    @Override
    public boolean refundPayment(String transactionId, double amount) {
        System.out.println("Refunding transaction " + transactionId);
        return true;
    }
}
```

### Key Takeaways
- A Java class can extend only one superclass, but can implement unlimited interfaces.
- Prefer interfaces to define API contracts, maximizing modularity and mockability during testing.',
  NULL,
  45,
  false,
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0102-000000000005'::UUID,
  'd0000000-0000-0000-0000-000000000002'::UUID,
  'Checked vs Unchecked Exception Architecture & Try-With-Resources',
  '### Learning Objectives
- Differentiate between `Throwable`, `Error`, `Exception` (checked), and `RuntimeException` (unchecked).
- Implement automatic resource closure using `try-with-resources` and the `AutoCloseable` interface.
- Create custom domain exceptions for enterprise applications.

### Exception Hierarchy
```
Throwable
 ├── Error (Out of memory, stack overflow - unrecoverable)
 └── Exception
      ├── RuntimeException (Unchecked: NullPointerException, IllegalArgumentException)
      └── IOException, SQLException (Checked: must be caught or declared via throws)
```

### Try-With-Resources Pattern
```java
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class LogReader {
    public static void readFirstLine(String filePath) throws IOException {
        // Automatically invokes close() on br, even if an exception occurs
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line = br.readLine();
            System.out.println("First line: " + line);
        }
    }
}
```

### Key Takeaways
- Checked exceptions force compile-time handling for expected recoverable failures.
- Unchecked exceptions (`RuntimeException`) typically signal programming bugs and logic flaws.',
  NULL,
  45,
  false,
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0102-000000000006'::UUID,
  'd0000000-0000-0000-0000-000000000002'::UUID,
  'Java Collections Framework: Lists, Sets, Maps & Iterators',
  '### Learning Objectives
- Select appropriate collection implementations based on asymptotic complexity requirements.
- Contrast `ArrayList` vs `LinkedList`, `HashSet` vs `TreeSet`, and `HashMap` vs `TreeMap`.
- Implement `equals()` and `hashCode()` contract to ensure correct hashing semantics.

### The equals() and hashCode() Contract
If two objects are equal according to `equals(Object)`, their `hashCode()` values **must** be identical. If this contract is violated, hash-based collections (`HashMap`, `HashSet`) fail to find existing keys.

```java
import java.util.Objects;

public class CourseKey {
    private final String department;
    private final int courseCode;

    public CourseKey(String department, int courseCode) {
        this.department = department;
        this.courseCode = courseCode;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CourseKey that = (CourseKey) o;
        return courseCode == that.courseCode && Objects.equals(department, that.department);
    }

    @Override
    public int hashCode() {
        return Objects.hash(department, courseCode);
    }
}
```

### Key Takeaways
- Always override `hashCode()` whenever overriding `equals()`.
- `ArrayList` provides $O(1)$ random access; `HashMap` provides average $O(1)$ key lookups.',
  NULL,
  50,
  false,
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0102-000000000007'::UUID,
  'd0000000-0000-0000-0000-000000000002'::UUID,
  'Generics, Type Bounds, and Multithreading Fundamentals',
  '### Learning Objectives
- Write type-safe generic classes and methods with bounded type parameters (`<T extends Comparable<T>>`).
- Understand Java''s type erasure and wildcard variance (`? extends T`, `? super T`).
- Spawn concurrent threads using `Runnable` and synchronize shared state using the `synchronized` keyword.

### Generic Stack Implementation
```java
import java.util.ArrayList;
import java.util.List;

public class GenericBox<T> {
    private final List<T> items = new ArrayList<>();

    public void add(T item) { items.add(item); }
    public T get(int index) { return items.get(index); }
    public int size() { return items.size(); }
}
```

### Basic Thread Synchronization
```java
public class SynchronizedCounter {
    private int count = 0;

    public synchronized void increment() {
        count++;
    }

    public synchronized int getCount() {
        return count;
    }
}
```

### Key Takeaways
- Generics provide compile-time type safety; the JVM compiler erases generic types at runtime for backward compatibility.
- The `synchronized` keyword enforces mutual exclusion using the object''s intrinsic monitor lock.',
  NULL,
  50,
  false,
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0103-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000003'::UUID,
  'Asymptotic Analysis & Mathematical Foundations: Big-O, Big-Omega, Big-Theta',
  '### Learning Objectives
- Formally define asymptotic bounds: $O(g(n))$, $\Omega(g(n))$, and $\Theta(g(n))$.
- Analyze worst-case, best-case, and average-case time and space complexities.
- Solve recurrence relations using the Master Theorem and recursion trees.

### Formal Asymptotic Definitions
- **Big-O (Upper Bound)**: $f(n) \in O(g(n))$ if there exist constants $c > 0$ and $n_0 \ge 0$ such that $0 \le f(n) \le c \cdot g(n)$ for all $n \ge n_0$.
- **Big-Omega (Lower Bound)**: $f(n) \in \Omega(g(n))$ if there exist constants $c > 0$ and $n_0 \ge 0$ such that $0 \le c \cdot g(n) \le f(n)$ for all $n \ge n_0$.
- **Big-Theta (Tight Bound)**: $f(n) \in \Theta(g(n))$ if $f(n) \in O(g(n))$ and $f(n) \in \Omega(g(n))$.

### Master Theorem for Divide-and-Conquer
For recurrences of the form $T(n) = a T(n/b) + f(n)$ where $a \ge 1, b > 1$:
1. If $f(n) = O(n^{\log_b a - \epsilon})$ for $\epsilon > 0$, then $T(n) = \Theta(n^{\log_b a})$.
2. If $f(n) = \Theta(n^{\log_b a} \log^k n)$ for $k \ge 0$, then $T(n) = \Theta(n^{\log_b a} \log^{k+1} n)$.
3. If $f(n) = \Omega(n^{\log_b a + \epsilon})$ for $\epsilon > 0$, and regularity holds, then $T(n) = \Theta(f(n))$.

### Key Takeaways
- Asymptotic notation abstracts away hardware constants to quantify algorithmic scaling as input size approaches infinity.
- Space complexity must account for both auxiliary heap allocation and call stack frames in recursive algorithms.',
  NULL,
  45,
  true,
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0103-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000003'::UUID,
  'Linear Data Structures: Dynamic Arrays & Linked Lists',
  '### Learning Objectives
- Analyze dynamic array geometric resizing and amortized $O(1)$ append complexity.
- Implement singly linked lists, doubly linked lists, and circular lists with pointer manipulation.
- Compare memory locality, cache friendliness, and trade-offs between arrays and linked lists.

### Amortized Analysis of Dynamic Array Growth
When a dynamic array reaches capacity $C$, it allocates a new buffer of capacity $2C$ and copies all $C$ elements. 
- Over $N$ appends, total elements copied $= 1 + 2 + 4 + ... + N/2 = N - 1$.
- Total work $= N + (N - 1) = 2N - 1 = O(N)$.
- Amortized cost per append $= O(N) / N = O(1)$.

```python
class Node:
    def __init__(self, val):
        self.val = val
        self.next = None

class SinglyLinkedList:
    def __init__(self):
        self.head = None

    def prepend(self, val):
        new_node = Node(val)
        new_node.next = self.head
        self.head = new_node  # O(1) time
```

### Key Takeaways
- Arrays provide $O(1)$ random access and cache locality due to contiguous memory allocation.
- Linked lists provide $O(1)$ insertion/deletion once the position is reached, but suffer from pointer overhead and cache misses.',
  NULL,
  45,
  false,
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0103-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000003'::UUID,
  'Stacks, Queues, and Monotonic Sequence Techniques',
  '### Learning Objectives
- Implement LIFO Stacks and FIFO Queues using arrays and linked lists.
- Solve expression parsing problems (infix to postfix, balanced parentheses).
- Master monotonic stack patterns for $O(n)$ next-greater-element queries.

### Monotonic Stack Algorithm
```python
def next_greater_elements(arr: list[int]) -> list[int]:
    """Finds next greater element for each index in O(n) time."""
    n = len(arr)
    result = [-1] * n
    stack = [] # stores indices in monotonically decreasing value order

    for i in range(n):
        while stack and arr[i] > arr[stack[-1]]:
            idx = stack.pop()
            result[idx] = arr[i]
        stack.append(i)

    return result

# Example: [2, 1, 2, 4, 3] -> [4, 2, 4, -1, -1]
print(next_greater_elements([2, 1, 2, 4, 3]))
```

### Key Takeaways
- Stacks model recursion, call stacks, and nested parsing.
- Circular queues resolve the memory waste of naive array queues using modulo pointer arithmetic: `tail = (tail + 1) % capacity`.',
  NULL,
  45,
  false,
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0103-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000003'::UUID,
  'Binary Trees, Binary Search Trees (BST) & AVL Self-Balancing',
  '### Learning Objectives
- Implement tree traversals: Pre-order, In-order, Post-order, and Level-order (BFS).
- Understand BST ordering invariant: Left Subtree $<$ Root $<$ Right Subtree.
- Maintain $O(\log n)$ search height using AVL tree rotations (LL, RR, LR, RL).

### AVL Tree Balance Factor
For any node $N$:
$$\text{Balance Factor}(N) = \text{Height}(\text{Left Subtree}) - \text{Height}(\text{Right Subtree}) \in \{-1, 0, 1\}$$

When $|\text{Balance Factor}| > 1$, self-balancing rotations restore balance:
- **Left-Left (LL)**: Single right rotation.
- **Right-Right (RR)**: Single left rotation.
- **Left-Right (LR)**: Left rotation on left child, then right rotation on parent.
- **Right-Left (RL)**: Right rotation on right child, then left rotation on parent.

### Key Takeaways
- An in-order traversal of a BST always yields keys in strictly increasing sorted order.
- Unbalanced BSTs degrade to $O(n)$ linked lists on sorted inputs; self-balancing trees guarantee $O(\log n)$ worst-case bounds.',
  NULL,
  50,
  false,
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0103-000000000005'::UUID,
  'd0000000-0000-0000-0000-000000000003'::UUID,
  'Priority Queues, Binary Heaps & Heapsort',
  '### Learning Objectives
- Formulate complete binary trees into contiguous 1D array representations.
- Implement Max-Heap and Min-Heap operations: `insert` ($O(\log n)$) and `extract_min` ($O(\log n)$).
- Build a heap in linear time $O(n)$ using bottom-up heapification.

### Heap Array Indexing Relationships (0-Indexed)
For node at index $i$:
- **Parent**: $\lfloor (i - 1) / 2 \rfloor$
- **Left Child**: $2i + 1$
- **Right Child**: $2i + 2$

### Linear-Time Heap Construction
Bottom-up heapification calls `sift_down` starting from the last non-leaf node $\lfloor n/2 \rfloor - 1$ down to root $0$:
$$\sum_{h=0}^{\lfloor \log n \rfloor} \frac{n}{2^{h+1}} O(h) = O(n)$$

### Key Takeaways
- Building a heap from an unsorted array takes $O(n)$ time, not $O(n \log n)$.
- Heapsort achieves $O(n \log n)$ worst-case sorting in-place without auxiliary memory.',
  NULL,
  45,
  false,
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0103-000000000006'::UUID,
  'd0000000-0000-0000-0000-000000000003'::UUID,
  'Graph Representations & Traversal: BFS, DFS, and Topological Sort',
  '### Learning Objectives
- Represent directed and undirected graphs via Adjacency Matrices and Adjacency Lists.
- Implement Breadth-First Search (queue) and Depth-First Search (stack/recursion).
- Detect cycles in directed graphs and compute Topological Sortings for DAGs.

### Traversal Complexities
With $V$ vertices and $E$ edges:
- **Time Complexity**: $O(V + E)$ using Adjacency Lists.
- **Space Complexity**: $O(V)$ for visited tracking and recursion/queue storage.

```python
from collections import defaultdict, deque

def kahn_topological_sort(num_courses: int, prerequisites: list[tuple[int, int]]) -> list[int]:
    """Kahn''s Algorithm for Topological Sort using In-Degrees."""
    in_degree = [0] * num_courses
    adj = defaultdict(list)
    for dest, src in prerequisites:
        adj[src].append(dest)
        in_degree[dest] += 1

    queue = deque([i for i in range(num_courses) if in_degree[i] == 0])
    order = []

    while queue:
        curr = queue.popleft()
        order.append(curr)
        for neighbor in adj[curr]:
            in_degree[neighbor] -= 1
            if in_degree[neighbor] == 0:
                queue.append(neighbor)

    return order if len(order) == num_courses else [] # Empty if cycle detected
```

### Key Takeaways
- BFS computes the shortest path in unweighted graphs.
- Topological sorting is valid only on Directed Acyclic Graphs (DAGs); a topological sort failure proves the presence of a cycle.',
  NULL,
  50,
  false,
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0103-000000000007'::UUID,
  'd0000000-0000-0000-0000-000000000003'::UUID,
  'Shortest Path Algorithms: Dijkstra and Bellman-Ford',
  '### Learning Objectives
- Formulate single-source shortest path problems.
- Implement Dijkstra''s Algorithm with a min-priority heap ($O((V + E) \log V)$).
- Apply Bellman-Ford algorithm for graphs with negative edge weights and negative cycle detection.

### Dijkstra vs Bellman-Ford
| Feature | Dijkstra | Bellman-Ford |
| :--- | :--- | :--- |
| **Edge Weights** | Non-negative only ($ge 0$) | Arbitrary real weights |
| **Time Complexity** | $O((V + E) \log V)$ | $O(V \cdot E)$ |
| **Negative Cycle Detection** | Cannot handle | Detects reachable negative cycles |
| **Strategy** | Greedy priority relaxation | Dynamic programming edge relaxation |

### Key Takeaways
- Dijkstra fails on negative weight edges because its greedy assumption (that the shortest distance to the nearest unvisited node is finalized) is violated by subsequent negative deductions.
- Bellman-Ford relaxes all $|E|$ edges $|V| - 1$ times; an extra relaxation pass that decreases any distance proves the existence of a negative cycle.',
  NULL,
  50,
  false,
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0103-000000000008'::UUID,
  'd0000000-0000-0000-0000-000000000003'::UUID,
  'Dynamic Programming: Memoization, Tabulation & the Knapsack Problem',
  '### Learning Objectives
- Identify optimal substructure and overlapping subproblems in computational problems.
- Master top-down dynamic programming with memoization and bottom-up DP with tabulation.
- Formulate recurrences for classic problems: 0/1 Knapsack, Longest Common Subsequence (LCS), and Coin Change.

### 0/1 Knapsack Dynamic Programming Formulation
Let $dp[i][w]$ be the maximum value achievable considering the first $i$ items with weight capacity $w$:
$$dp[i][w] = \begin{cases} dp[i-1][w] & \text{if } \text{weight}[i-1] > w \\ \max(dp[i-1][w], \text{value}[i-1] + dp[i-1][w - \text{weight}[i-1]]) & \text{otherwise} \end{cases}$$

```python
def knapsack_01(weights: list[int], values: list[int], capacity: int) -> int:
    dp = [0] * (capacity + 1)
    for w_i, v_i in zip(weights, values):
        # Iterate backwards to reuse previous subproblem values without state corruption
        for c in range(capacity, w_i - 1, -1):
            dp[c] = max(dp[c], v_i + dp[c - w_i])
    return dp[capacity]
```

### Key Takeaways
- Dynamic programming avoids exponential recomputation by caching results to overlapping subproblems.
- Iterating backwards in 1D array tabulation solves the 0/1 knapsack problem in $O(W)$ auxiliary space.',
  NULL,
  55,
  false,
  8,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0104-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000004'::UUID,
  'Modern Web Architecture: HTTP/1.1 to HTTP/3 & The Client-Server Lifecycle',
  '### Learning Objectives
- Trace the lifecycle of a web request: DNS lookup, TCP handshake, TLS negotiation, HTTP exchange, and browser DOM rendering.
- Compare HTTP/1.1 head-of-line blocking with HTTP/2 binary multiplexing and HTTP/3 QUIC UDP transport.
- Understand HTTP headers, caching directives (`Cache-Control`, `ETag`), and status codes (2xx, 3xx, 4xx, 5xx).

### Evolution of the HTTP Protocol
- **HTTP/1.1**: Persistent TCP connections with pipelining, but suffers from head-of-line (HOL) blocking when one slow response blocks subsequent requests on that TCP connection.
- **HTTP/2**: Single TCP connection per origin with binary framing and multiplexed concurrent streams, eliminating HTTP-layer HOL blocking.
- **HTTP/3**: Operates over QUIC (built on UDP), resolving transport-layer packet loss blocking and providing 0-RTT connection resumption.

### Key Takeaways
- Always enforce HTTPS via TLS 1.3 to guarantee data confidentiality and integrity in transit.
- Proper caching headers (`Cache-Control: public, max-age=31536000, immutable`) dramatically reduce round-trip latency for static assets.',
  NULL,
  40,
  true,
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0104-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000004'::UUID,
  'Semantic HTML5 & Responsive Design with CSS Grid and Flexbox',
  '### Learning Objectives
- Structure documents with semantic elements: `<header>`, `<nav>`, `<main>`, `<article>`, `<section>`, `<aside>`, and `<footer>`.
- Master 1D layouts with CSS Flexbox (`flex-direction`, `justify-content`, `align-items`).
- Architect 2D page grids with CSS Grid (`grid-template-columns`, `grid-template-areas`, `gap`).

### CSS Grid vs Flexbox Architectural Comparison
```css
/* 2D Grid Layout for Application Shell */
.app-layout {
  display: grid;
  grid-template-columns: 260px 1fr;
  grid-template-rows: 64px 1fr 48px;
  grid-template-areas:
    "sidebar header"
    "sidebar content"
    "sidebar footer";
  min-height: 100vh;
}

/* 1D Flexbox for Navigation Elements */
.header-nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 1.5rem;
}
```

### Key Takeaways
- Use **Flexbox** for one-dimensional linear distributions (rows or columns, navigation bars, button groups).
- Use **CSS Grid** for two-dimensional structural page layouts aligning both columns and rows simultaneously.',
  NULL,
  45,
  false,
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0104-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000004'::UUID,
  'Modern JavaScript (ES6+): Closures, Event Loop & Async/Await',
  '### Learning Objectives
- Understand JavaScript''s single-threaded event loop, Call Stack, Task Queue (Macrotasks), and Microtask Queue (Promises).
- Master functional closures, scope chains, and lexical `this` in arrow functions.
- Write asynchronous pipelines using Promises and `async`/`await` with robust `try`/`catch` blocks.

### The JavaScript Event Loop Execution Order
1. Execute synchronous code on the **Call Stack**.
2. Process all pending jobs in the **Microtask Queue** (Promise `.then`, `await` continuations, `queueMicrotask`) until completely empty.
3. Render DOM repaints if scheduled.
4. Dequeue and execute the next task in the **Macrotask Queue** (`setTimeout`, `setInterval`, I/O).

```javascript
async function fetchCourseMetrics(courseId) {
  try {
    const response = await fetch(`/api/courses/${courseId}/metrics`);
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: Failed to retrieve metrics`);
    }
    const data = await response.json();
    return data;
  } catch (err) {
    console.error("Network or parsing error:", err);
    throw err;
  }
}
```

### Key Takeaways
- Microtasks (Promises) always run before the next macrotask (timers/events).
- Arrow functions do not bind their own `this`, inheriting `this` lexically from the enclosing execution context.',
  NULL,
  50,
  false,
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0104-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000004'::UUID,
  'Component-Driven Frontend Architecture with React',
  '### Learning Objectives
- Build modular component trees using JSX, props, and functional components.
- Understand React''s Virtual DOM reconciliation and Fiber architecture.
- Apply immutable state updates with `useState` to guarantee predictable re-renders.

### Clean Component Decomposition
```tsx
interface CourseCardProps {
  title: string;
  category: string;
  lessonCount: number;
  onEnroll: () => void;
}

export const CourseCard: React.FC<CourseCardProps> = ({ title, category, lessonCount, onEnroll }) => {
  return (
    <div className="rounded-xl border border-slate-200 p-5 shadow-sm hover:shadow-md transition-shadow">
      <span className="text-xs font-semibold text-teal-700 bg-teal-50 px-2.5 py-1 rounded-full">
        {category}
      </span>
      <h3 className="text-lg font-bold text-slate-900 mt-3">{title}</h3>
      <p className="text-xs text-slate-500 mt-1">{lessonCount} Lectures</p>
      <button
        onClick={onEnroll}
        className="mt-4 w-full bg-teal-700 hover:bg-teal-800 text-white font-semibold py-2 rounded-lg text-sm transition-colors"
      >
        Enroll Course
      </button>
    </div>
  );
};
```

### Key Takeaways
- Components should follow the Single Responsibility Principle: decompose monolithic screens into reusable presentation and container components.
- Never mutate state directly in React (e.g. `items.push(x)`); always pass new references (`setItems([...items, x])`).',
  NULL,
  50,
  false,
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0104-000000000005'::UUID,
  'd0000000-0000-0000-0000-000000000004'::UUID,
  'Client-Side State Management: Hooks, Context & Reducers',
  '### Learning Objectives
- Master the React Hook lifecycle: `useEffect`, `useMemo`, and `useCallback`.
- Manage complex multi-field state using `useReducer` and action dispatch patterns.
- Avoid prop-drilling by providing global state through React Context.

### State Management with useReducer & Context
```tsx
type CartAction = 
  | { type: ''ADD_ITEM''; payload: { id: string; price: number } }
  | { type: ''REMOVE_ITEM''; payload: { id: string } }
  | { type: ''CLEAR_CART'' };

interface CartState {
  items: { id: string; price: number }[];
  total: number;
}

function cartReducer(state: CartState, action: CartAction): CartState {
  switch (action.type) {
    case ''ADD_ITEM'':
      return {
        items: [...state.items, action.payload],
        total: state.total + action.payload.price
      };
    case ''CLEAR_CART'':
      return { items: [], total: 0 };
    default:
      return state;
  }
}
```

### Key Takeaways
- `useEffect` with an empty dependency array `[]` runs once after the initial render; always specify all referenced values in the dependency array to avoid stale closures.
- Use `useMemo` and `useCallback` to stabilize object references passed to memoized children.',
  NULL,
  50,
  false,
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0104-000000000006'::UUID,
  'd0000000-0000-0000-0000-000000000004'::UUID,
  'Building RESTful APIs: Routes, Middleware & Request Lifecycle',
  '### Learning Objectives
- Design RESTful HTTP resource URIs adhering to HTTP method semantics (GET, POST, PUT, PATCH, DELETE).
- Structure Node.js/Express API servers with middleware pipelines.
- Implement centralized error handling, request validation, and response formatting.

### RESTful Architectural Principles
- **Idempotency**: GET, PUT, and DELETE must be idempotent (repeated identical requests yield identical server state).
- **Resource Nouns**: Use plural nouns (`/api/courses`, `/api/courses/:id/lessons`), never verbs in endpoint URIs.
- **Status Codes**: 200 (OK), 201 (Created), 204 (No Content), 400 (Bad Request), 401 (Unauthorized), 403 (Forbidden), 404 (Not Found), 500 (Server Error).

```javascript
// Express middleware example
app.use((req, res, next) => {
  req.requestTime = new Date().toISOString();
  console.log(`[${req.method}] ${req.url} at ${req.requestTime}`);
  next(); // Pass control to next handler in chain
});
```

### Key Takeaways
- Middleware functions execute sequentially and can inspect, modify, or terminate the request-response cycle.
- Centralize error-handling middleware with `(err, req, res, next)` to avoid unhandled promise rejections.',
  NULL,
  45,
  false,
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0104-000000000007'::UUID,
  'd0000000-0000-0000-0000-000000000004'::UUID,
  'Full-Stack Integration, JWT Authentication & CORS Security',
  '### Learning Objectives
- Implement secure authentication using JSON Web Tokens (JWT) and HTTP-only cookies.
- Configure Cross-Origin Resource Sharing (CORS) correctly to defend against unauthorized cross-site requests.
- Protect web applications against Cross-Site Scripting (XSS) and Cross-Site Request Forgery (CSRF).

### JWT Structure & Verification
A JWT consists of three Base64URL-encoded components: `Header.Payload.Signature`.
- **Header**: Algorithm and token type (`{"alg": "HS256", "typ": "JWT"}`).
- **Payload**: Claims (`{"sub": "usr_123", "role": "student", "exp": 1790000000}`).
- **Signature**: `HMACSHA256(header + "." + payload, secret)`.

```
Client ---POST /login---> Server (Validates credentials, signs JWT)
Client <---Set-Cookie: token; HttpOnly; Secure; SameSite=Strict--- Server
Client ---GET /protected (Cookie automatically sent)---> Server (Verifies signature)
```

### Key Takeaways
- Store authentication tokens in **HttpOnly, Secure, SameSite=Strict** cookies to prevent XSS script access to tokens.
- CORS is a browser security mechanism, not an API security firewall; server-to-server calls bypass CORS.',
  NULL,
  50,
  false,
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0105-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000005'::UUID,
  'Relational Database Architecture, Data Models & Relational Algebra',
  '### Learning Objectives
- Master the ANSI-SPARC Three-Level Architecture: Internal, Conceptual, and External schemas.
- Understand relational data modeling: relations, tuples, attributes, cardinality, and degree.
- Formulate queries using Relational Algebra operators: Selection ($sigma$), Projection ($pi$), Cartesian Product ($	imes$), Join ($owtie$), and Set operations.

### Relational Algebra Fundamental Operators
1. **Selection ($sigma_{\text{condition}}(R)$)**: Filters horizontal subsets of tuples satisfying a predicate.
2. **Projection ($\pi_{A_1, A_2}(R)$)**: Extracts vertical subsets of specified attributes, eliminating duplicate tuples.
3. **Natural Join ($R \bowtie S$)**: Matches tuples on common attribute names, projecting out duplicates.

$$\pi_{\text{name}, \text{gpa}}(\sigma_{\text{gpa} \ge 3.5}(\text{Students}))$$

### Key Takeaways
- Relational algebra is a formal procedural query language that provides the mathematical foundation for SQL query planning and optimization.
- Physical data independence shields application code from changes in disk storage, indexing, or physical block allocation.',
  NULL,
  40,
  true,
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0105-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000005'::UUID,
  'Functional Dependencies & Schema Normalization: 1NF to BCNF',
  '### Learning Objectives
- Formally identify Functional Dependencies ($X \rightarrow Y$) and compute attribute closures ($X^+$).
- Eliminate insertion, update, and deletion anomalies through schema decomposition.
- Understand the criteria for First (1NF), Second (2NF), Third (3NF), and Boyce-Codd Normal Form (BCNF).

### Normalization Ladder
1. **1NF**: All column values must be atomic (no repeating groups, arrays, or composite attributes).
2. **2NF**: In 1NF and no non-prime attribute is partially dependent on any candidate key (eliminates partial dependency).
3. **3NF**: In 2NF and no non-prime attribute is transitively dependent on any candidate key ($X \rightarrow Y$ where neither $X$ is superkey nor $Y$ is prime).
4. **BCNF**: For every non-trivial functional dependency $X \rightarrow Y$, $X$ must be a superkey.

### Key Takeaways
- Higher normal forms eliminate data redundancy and prevent update anomalies, but may require additional joins for retrieval.
- 3NF always guarantees dependency preservation and lossless join decomposition; BCNF guarantees lossless join but may not preserve all functional dependencies.',
  NULL,
  50,
  false,
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0105-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000005'::UUID,
  'Declarative SQL Mastery: DDL, DML, Joins & Subqueries',
  '### Learning Objectives
- Write robust DDL statements with primary, foreign key, check, and unique constraints.
- Differentiate between INNER, LEFT OUTER, RIGHT OUTER, FULL OUTER, and CROSS joins.
- Formulate correlated and non-correlated subqueries with `EXISTS`, `IN`, and `ANY`.

### Advanced Join Query Example
```sql
SELECT 
    d.department_name,
    c.course_title,
    COUNT(e.student_id) AS total_enrolled,
    ROUND(AVG(e.grade_points), 2) AS average_grade
FROM departments d
INNER JOIN courses c ON c.department_id = d.id
LEFT JOIN enrollments e ON e.course_id = c.id
WHERE c.is_active = TRUE
GROUP BY d.department_name, c.course_title
HAVING COUNT(e.student_id) >= 5
ORDER BY total_enrolled DESC;
```

### Key Takeaways
- `WHERE` filters individual rows before aggregation; `HAVING` filters grouped buckets after aggregation.
- Prefer `EXISTS` over `IN` when evaluating subqueries against large tables with possible NULLs to optimize planner performance.',
  NULL,
  45,
  false,
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0105-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000005'::UUID,
  'Analytical SQL: Aggregations, Grouping Sets & Window Functions',
  '### Learning Objectives
- Compute running totals, rankings, and moving averages using SQL Window Functions.
- Understand the syntax: `FUNCTION() OVER (PARTITION BY ... ORDER BY ... ROWS BETWEEN ...)`.
- Apply `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `LEAD()`, and `LAG()`.

### Window Functions in Practice
Unlike `GROUP BY`, which collapses multiple rows into a single summary row, window functions compute aggregate values while retaining individual row identities.

```sql
SELECT 
    student_id,
    course_id,
    score,
    DENSE_RANK() OVER (PARTITION BY course_id ORDER BY score DESC) AS course_rank,
    ROUND(AVG(score) OVER (PARTITION BY course_id), 2) AS class_average,
    score - ROUND(AVG(score) OVER (PARTITION BY course_id), 2) AS diff_from_mean
FROM exam_submissions;
```

### Key Takeaways
- `RANK()` leaves gaps after tied ranks (e.g. 1, 2, 2, 4); `DENSE_RANK()` produces contiguous numbering (1, 2, 2, 3).
- `LEAD()` and `LAG()` access subsequent and preceding rows without self-joins.',
  NULL,
  50,
  false,
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0105-000000000005'::UUID,
  'd0000000-0000-0000-0000-000000000005'::UUID,
  'Database Storage Internals: B-Tree Indexing & Query Execution Plans',
  '### Learning Objectives
- Understand disk storage organization: Pages, Slotted Pages, and Buffer Pools.
- Analyze B+ Tree index structures: Root, Internal nodes, Leaf nodes, and Doubly-linked leaf chains.
- Interpret `EXPLAIN ANALYZE` execution plans: Sequential Scan vs Index Scan vs Index Only Scan vs Bitmap Scan.

### B+ Tree Index Mechanics
In a B+ Tree index:
- Internal nodes contain only routing search keys and child pointers, maximizing fan-out.
- Leaf nodes contain all actual data pointers/tuples and are linked bidirectionally for $O(\log n)$ search and $O(k)$ range scans.

```
Root:           [ 50 ]
              /        \
Internal: [ 20, 35 ]   [ 70, 85 ]
Leaves:  [10..19] <-> [20..34] <-> [50..69] <-> [70..84] <-> [85..99]
```

### Key Takeaways
- Indexes accelerate search queries but impose write overhead on INSERT, UPDATE, and DELETE operations.
- An **Index Only Scan** fulfills the query entirely from the B+ Tree index without fetching heap pages.',
  NULL,
  50,
  false,
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0105-000000000006'::UUID,
  'd0000000-0000-0000-0000-000000000005'::UUID,
  'ACID Transaction Properties, Write-Ahead Logging & Crash Recovery',
  '### Learning Objectives
- Formally define ACID properties: Atomicity, Consistency, Isolation, and Durability.
- Understand the Write-Ahead Logging (WAL) protocol: log records must reach non-volatile disk before dirty pages are flushed.
- Master the ARIES crash recovery algorithm: Analysis, Redo, and Undo passes.

### ACID Architecture Summary
- **Atomicity**: All-or-nothing execution guaranteed via rollback and Undo logging.
- **Consistency**: The database transitions from one valid state satisfying all schema constraints to another.
- **Isolation**: Concurrent transactions execute without cross-interference as if run sequentially.
- **Durability**: Committed changes survive subsequent system crashes via Redo logging and WAL.

### Key Takeaways
- Write-Ahead Logging ensures that modifications are written to sequential append-only log files before random writes update physical table pages on disk.
- Checkpoints shorten recovery times by flushing dirty buffers and bounding the required WAL replay window.',
  NULL,
  45,
  false,
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0105-000000000007'::UUID,
  'd0000000-0000-0000-0000-000000000005'::UUID,
  'Concurrency Control: Isolation Levels, 2PL & Multi-Version Concurrency (MVCC)',
  '### Learning Objectives
- Differentiate concurrency phenomena: Dirty Reads, Non-Repeatable Reads, and Phantom Reads.
- Compare SQL Isolation Levels: Read Uncommitted, Read Committed, Repeatable Read, and Serializable.
- Understand Strict Two-Phase Locking (S2PL) and Multi-Version Concurrency Control (MVCC).

### Concurrency Anomalies by Isolation Level
| Isolation Level | Dirty Read | Non-Repeatable Read | Phantom Read |
| :--- | :--- | :--- | :--- |
| **Read Uncommitted** | Allowed | Allowed | Allowed |
| **Read Committed** | Prevented | Allowed | Allowed |
| **Repeatable Read** | Prevented | Prevented | Allowed (SQL standard) |
| **Serializable** | Prevented | Prevented | Prevented |

### How MVCC Works (PostgreSQL / Modern DBMS)
Rather than locking rows on read, MVCC stores multiple immutable versions of each row with transaction visibility tags (`xmin`, `xmax`).
- **Readers never block Writers**.
- **Writers never block Readers**.

### Key Takeaways
- MVCC provides snapshot isolation without heavy read locks, dramatically improving concurrency.
- VACUUM processes reclaim dead tuple versions created by updates and deletes in MVCC engines.',
  NULL,
  50,
  false,
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0106-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000006'::UUID,
  'Kernel Architecture, Dual-Mode CPU Operation & System Calls',
  '### Learning Objectives
- Understand the hardware-enforced separation between User Mode and Kernel (Privileged) Mode.
- Trace how trap instructions transition CPU execution from user space to kernel interrupt handlers.
- Compare Monolithic Kernels (Linux) with Microkernel architectures (Mach, QNX).

### Dual-Mode Operation & Hardware Protection
To prevent user applications from corrupting hardware or other processes, CPUs implement a mode bit:
- **User Mode (Ring 3)**: CPU restricts privileged instructions (direct I/O, disabling interrupts, memory page table manipulation).
- **Kernel Mode (Ring 0)**: Unrestricted access to all CPU instructions and physical memory.

```
User Space:    App executes read()  --->  Syscall Library wrapper
----------------------------------------------------------------------- [Trap / Syscall Instruction]
Kernel Space:  Interrupt Vector Table ---> sys_read() Handler ---> File System Driver ---> Hardware
```

### Key Takeaways
- The timer interrupt prevents infinite loops in user applications by preemptively yielding CPU control back to the operating system scheduler.
- System calls execute software interrupts (traps) that switch CPU mode from user to kernel.',
  NULL,
  40,
  true,
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0106-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000006'::UUID,
  'Process Management: Process Control Block (PCB) & Context Switching',
  '### Learning Objectives
- Formulate the 5-state process model: New, Ready, Running, Waiting, and Terminated.
- Analyze the contents of the Process Control Block (PCB): PID, CPU registers, Program Counter, and open file descriptors.
- Compute the computational overhead of context switches.

### Process State Transitions
```
[ New ] ---> [ Ready ] <===== Scheduler Dispatch ===== [ Running ] ---> [ Terminated ]
                 ^                                            |
                 |-------- I/O Completion <--- [ Waiting ] <--| (I/O or Event Wait)
```

### Context Switch Lifecycle
When the OS switches execution from Process $P_1$ to Process $P_2$:
1. Save the hardware state (registers, program counter, stack pointer) of $P_1$ into $PCB_1$.
2. Update $P_1$''s state (to Ready or Waiting).
3. Select $P_2$ via the CPU scheduler.
4. Switch memory address space (reload CR3 page table register on x86, invalidating TLB entries).
5. Restore hardware registers from $PCB_2$ and set Program Counter to resume $P_2$.

### Key Takeaways
- Context switching is pure computational overhead; the CPU performs no productive application work during a context switch.
- Threads within the same process share heap memory, global variables, and open files, making thread context switches significantly faster than process context switches.',
  NULL,
  45,
  false,
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0106-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000006'::UUID,
  'CPU Scheduling Algorithms: FCFS, SJF, Priority & Round Robin',
  '### Learning Objectives
- Calculate scheduling metrics: Turnaround Time, Waiting Time, Response Time, and CPU Throughput.
- Evaluate non-preemptive algorithms: First-Come First-Served (FCFS) and Shortest Job First (SJF).
- Evaluate preemptive algorithms: Shortest Remaining Time First (SRTF) and Round Robin (RR) with time quantum $q$.

### Scheduling Formulas
$$\text{Turnaround Time} = \text{Completion Time} - \text{Arrival Time}$$
$$\text{Waiting Time} = \text{Turnaround Time} - \text{Burst Time}$$

### Algorithm Trade-offs
- **FCFS**: Simple FIFO queue; suffers from the **Convoy Effect** where short processes wait behind a massive CPU-bound process.
- **SJF / SRTF**: Mathematically provable minimum average waiting time; impossible to implement perfectly in general OS kernels because future CPU burst lengths cannot be known in advance.
- **Round Robin**: Time-sliced preemptive scheduling; small quantum $q$ increases context switch overhead, while infinite $q$ degenerates to FCFS.

### Key Takeaways
- The optimal Round Robin quantum $q$ should be large enough that 80% of CPU bursts are shorter than $q$, minimizing context switch penalties while maintaining responsiveness.',
  NULL,
  50,
  false,
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0106-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000006'::UUID,
  'Process Synchronization: Critical Section Problem, Semaphores & Mutexes',
  '### Learning Objectives
- Formulate the Critical Section Problem and its three mandatory criteria: Mutual Exclusion, Progress, and Bounded Waiting.
- Contrast software solutions (Peterson''s Algorithm) with hardware atomic instructions (Test-and-Set, Compare-and-Swap).
- Implement counting semaphores and binary semaphores (mutexes) to eliminate race conditions.

### The Semaphore Primitives (Dijkstra)
A semaphore $S$ is an integer variable accessed only through two atomic operations: `wait()` (or $P$) and `signal()` (or $V$).

```c
void wait(Semaphore *S) {
    S->value--;
    if (S->value < 0) {
        add_process_to_queue(S->queue, current_process);
        block(); // suspend calling process
    }
}

void signal(Semaphore *S) {
    S->value++;
    if (S->value <= 0) {
        Process *P = remove_process_from_queue(S->queue);
        wakeup(P); // resume waiting process
    }
}
```

### Key Takeaways
- Spinlocks (busy-waiting) are acceptable in multi-core kernels for very short durations, but wasteful on single-core systems where yielding the CPU is required.
- Mutexes have ownership (only the thread that locked the mutex can unlock it); semaphores have no ownership and can be signaled by any thread.',
  NULL,
  50,
  false,
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0106-000000000005'::UUID,
  'd0000000-0000-0000-0000-000000000006'::UUID,
  'Deadlock Characterization, Prevention, Detection & Banker''s Algorithm',
  '### Learning Objectives
- Identify Coffman''s four necessary and sufficient conditions for deadlock: Mutual Exclusion, Hold and Wait, No Preemption, and Circular Wait.
- Implement deadlock avoidance using Dijkstra''s Banker''s Algorithm on multi-instance resource systems.
- Construct Resource Allocation Graphs (RAG) and evaluate cycle detection algorithms.

### Banker''s Safety Algorithm
Given vectors: Available $[m]$, Allocation $[n \times m]$, Max $[n \times m]$, and Need $[n \times m]$ where $\text{Need}[i][j] = \text{Max}[i][j] - \text{Allocation}[i][j]$.
A state is **safe** if there exists a sequence $\langle P_1, P_2, ..., P_n \rangle$ such that for each $P_i$, the resources that $P_i$ can still request can be satisfied by currently available resources plus resources held by all preceding $P_j$ ($j < i$).

```
1. Work = Available; Finish[i] = false for all i
2. Find index i such that: Finish[i] == false and Need[i] <= Work
   If no such i exists, go to step 4.
3. Work = Work + Allocation[i]; Finish[i] = true; go to step 2.
4. If Finish[i] == true for all i, system is in a SAFE state.
```

### Key Takeaways
- Eliminating Circular Wait by imposing a strict global ordering on all resource acquisitions ($R_1 < R_2 < ... < R_m$) is the most practical deadlock prevention technique in real systems.',
  NULL,
  50,
  false,
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0106-000000000006'::UUID,
  'd0000000-0000-0000-0000-000000000006'::UUID,
  'Memory Management: Contiguous Allocation, Paging & Translation Lookaside Buffers (TLB)',
  '### Learning Objectives
- Differentiate logical (virtual) addresses from physical hardware memory addresses.
- Calculate address translation offsets using Page Tables: Page Number ($p$) and Offset ($d$).
- Measure Effective Memory Access Time (EMAT) incorporating TLB hit ratios.

### Paging Architecture & Hardware Address Translation
Logical address is divided into:
- Page number $p$: index into the process page table containing the base physical frame number $f$.
- Offset $d$: Displacement within the physical frame ($f \cdot \text{page\_size} + d$).

### Effective Memory Access Time (EMAT)
If memory access time is $T$, TLB search time is $\epsilon$, and TLB hit ratio is $\alpha$:
$$\text{EMAT} = (\epsilon + T) \cdot \alpha + (\epsilon + 2T) \cdot (1 - \alpha)$$

### Key Takeaways
- Paging eliminates external fragmentation completely, although internal fragmentation may occur on the final page of an allocation.
- Multi-level page tables conserve physical memory by allocating sub-page tables only for populated virtual address regions.',
  NULL,
  45,
  false,
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0106-000000000007'::UUID,
  'd0000000-0000-0000-0000-000000000006'::UUID,
  'Virtual Memory: Demand Paging, Page Fault Handling & Replacement Algorithms',
  '### Learning Objectives
- Trace the complete 6-step Page Fault handling sequence executed by the OS kernel.
- Implement page replacement algorithms: FIFO, Optimal (MIN), Least Recently Used (LRU), and Second-Chance Clock.
- Understand thrashing, working set models, and page fault frequency controls.

### Page Fault Handling Sequence
1. The CPU checks page table; valid-invalid bit is marked `0` (Invalid/Absent).
2. Hardware triggers a page fault trap to the OS kernel.
3. The OS checks internal process tables to verify legal memory reference.
4. Locate a free physical frame (or invoke page replacement to evict a victim page, writing it to swap if dirty).
5. Issue disk I/O to read desired page from swap space into the allocated physical frame.
6. Update page table bit to valid (`1`), restore process state, and restart the instruction that caused the fault.

### Page Replacement Algorithms Comparison
- **FIFO**: May suffer from **Bélády''s Anomaly** (allocating more physical frames increases the total number of page faults).
- **Optimal (MIN)**: Replaces the page that will not be used for the longest period; theoretical benchmark.
- **LRU**: Replaces the page that has not been used for the longest period of time; immune to Bélády''s anomaly.

### Key Takeaways
- **Thrashing** occurs when a process spends more time swapping pages in and out than executing instructions because its working set exceeds available physical memory.',
  NULL,
  50,
  false,
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0107-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000007'::UUID,
  'Layered Network Architectures: OSI 7-Layer vs TCP/IP 4-Layer Stacks',
  '### Learning Objectives
- Master the OSI 7-layer reference model and the practical TCP/IP 4-layer internet model.
- Trace packet encapsulation and decapsulation across layers: Data -> Segment -> Packet -> Frame -> Bits.
- Understand Protocol Data Units (PDUs), addressing schemes (Port, IP, MAC), and multiplexing.

### Layer Comparison Matrix
| OSI Layer | TCP/IP Layer | PDU Name | Addressing | Primary Protocols / Hardware |
| :--- | :--- | :--- | :--- | :--- |
| Application / Pres / Sess | Application | Message / Data | Process / Port | HTTP, DNS, SSH, TLS |
| Transport | Transport | Segment (TCP) / Datagram (UDP) | Port (16-bit) | TCP, UDP |
| Network | Internet | Packet / Datagram | IP Address (32/128-bit) | IPv4, IPv6, ICMP, Routers |
| Data Link | Link / Network Interface | Frame | MAC Address (48-bit) | Ethernet, 802.11 Wi-Fi, Switches |
| Physical | Link / Physical | Bit Stream | Signals / Voltage | Cables, Fiber, Hubs |

### Key Takeaways
- Encapsulation prepends layer-specific headers as data flows down the protocol stack; decapsulation strips headers as data ascends on the receiving host.
- Routers inspect headers up to Layer 3 (Network); Layer 2 switches inspect frames up to Layer 2 (Data Link).',
  NULL,
  40,
  true,
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0107-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000007'::UUID,
  'Application Layer Protocols: DNS Resolution, HTTP/HTTPS & Sockets',
  '### Learning Objectives
- Trace recursive and iterative DNS resolution hierarchies: Root, TLD, and Authoritative Nameservers.
- Understand DNS record types: `A`, `AAAA`, `CNAME`, `MX`, and `TXT`.
- Implement basic client-server socket communication over TCP and UDP.

### DNS Hierarchical Resolution Pipeline
```
Browser Cache ---> OS Resolver ---> Local DNS Server (Recursive)
                                           |
    +--------------------------------------+------------------------------------+
    | (Iterative query)                    | (Iterative query)                  | (Iterative query)
    v                                      v                                    v
Root Nameserver (.)                TLD Nameserver (.com)              Authoritative Nameserver
(Returns TLD server IP)            (Returns Authoritative server IP)  (Returns final A record IP)
```

### Key Takeaways
- DNS primarily utilizes UDP on Port 53 for low latency; zone transfers utilize TCP on Port 53 for reliability.
- Berkeley Sockets provide the universal OS abstraction for network programming using `socket()`, `bind()`, `listen()`, `accept()`, and `connect()`.',
  NULL,
  45,
  false,
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0107-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000007'::UUID,
  'Transport Layer Mechanics: UDP vs TCP & Connection Management',
  '### Learning Objectives
- Compare connectionless, unreliable UDP with connection-oriented, reliable TCP.
- Trace the TCP 3-Way Handshake (SYN -> SYN-ACK -> ACK) and 4-Way Connection Teardown (FIN -> ACK -> FIN -> ACK).
- Understand TCP header fields: Sequence numbers, Acknowledgment numbers, Flags, Window size, and Checksum.

### TCP 3-Way Handshake
```
Client                                          Server
  | ----- SYN (seq = x) -------------------------> |  (Server allocates TCB buffer)
  | <---- SYN-ACK (seq = y, ack = x + 1) -------- |  (Client receives sequence verification)
  | ----- ACK (seq = x + 1, ack = y + 1) --------> |  (Connection ESTABLISHED)
```

### The TIME_WAIT State
The host initiating a passive closure remains in `TIME_WAIT` for $2 \cdot \text{MSL}$ (Maximum Segment Lifetime, typically 2 minutes) to ensure the final ACK was received by the remote peer and prevent delayed duplicate packets from corrupting new connections.

### Key Takeaways
- TCP guarantees in-order byte stream delivery, error detection, flow control, and congestion control.
- UDP provides lightweight datagram transport with zero connection setup latency, ideal for real-time gaming, DNS, and live streaming.',
  NULL,
  50,
  false,
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0107-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000007'::UUID,
  'Flow Control & TCP Congestion Control: AIMD, Slow Start & Fast Recovery',
  '### Learning Objectives
- Differentiate Flow Control (preventing receiver buffer overflow) from Congestion Control (preventing network bottleneck collapse).
- Master TCP sliding window mechanics and Receiver Advertised Window (rwnd).
- Analyze the 4 phases of TCP Tahoe and Reno: Slow Start, Congestion Avoidance, Fast Retransmit, and Fast Recovery.

### Congestion Control State Machine (TCP Reno)
1. **Slow Start**: Congestion Window ($cwnd$) starts at 1 MSS and doubles exponentially every RTT ($cwnd = cwnd \times 2$) until reaching $ssthresh$.
2. **Congestion Avoidance**: $cwnd$ grows linearly by 1 MSS per RTT (Additive Increase: $cwnd = cwnd + 1$).
3. **Triple Duplicate ACKs**: Indicates single packet loss without full timeout. Fast Retransmit triggers immediately; $ssthresh = cwnd / 2$, and $cwnd = ssthresh$ (Multiplicative Decrease).
4. **Timeout**: Catastrophic packet drop; $ssthresh = cwnd / 2$, and $cwnd$ resets to 1 MSS.

### Key Takeaways
- **AIMD** (Additive Increase Multiplicative Decrease) is mathematically stable and drives competing flows toward fair bandwidth sharing.
- Flow control uses `rwnd` feedback in TCP headers; congestion control dynamically estimates network capacity via `cwnd`.',
  NULL,
  50,
  false,
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0107-000000000005'::UUID,
  'd0000000-0000-0000-0000-000000000007'::UUID,
  'Network Layer: IPv4 Addressing, Subnetting, CIDR & NAT',
  '### Learning Objectives
- Deconstruct 32-bit IPv4 addresses into Network ID, Subnet ID, and Host ID.
- Calculate subnet masks, usable host ranges, and broadcast addresses using Classless Inter-Domain Routing (CIDR) notation.
- Understand Network Address Translation (NAT) and Private IP address ranges (RFC 1918).

### Subnetting Mathematical Formulas
For a subnet mask with $/n$ prefix length:
- **Host Bits**: $h = 32 - n$.
- **Total IP Addresses**: $2^h$.
- **Usable Host Addresses**: $2^h - 2$ (subtracting Network Address and Directed Broadcast Address).

```
Address: 192.168.10.65 / 26
Prefix length: 26 bits -> 6 host bits (2^6 = 64 addresses per subnet)
Subnet Mask:   255.255.255.192
Network ID:    192.168.10.64
First Usable:  192.168.10.65
Last Usable:   192.168.10.126
Broadcast:     192.168.10.127
```

### Key Takeaways
- CIDR replaced rigid Class A/B/C addressing with arbitrary prefix masking, preventing global routing table explosion.
- NAT allows thousands of private local IP addresses to share a single public IPv4 address using port translation (NAPT/PAT).',
  NULL,
  50,
  false,
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0107-000000000006'::UUID,
  'd0000000-0000-0000-0000-000000000007'::UUID,
  'Routing Protocols: Distance Vector, Link State (OSPF) & BGP',
  '### Learning Objectives
- Compare Interior Gateway Protocols (IGP) with Exterior Gateway Protocols (EGP).
- Contrast Distance Vector routing (Bellman-Ford, RIP) with Link State routing (Dijkstra, OSPF).
- Understand Border Gateway Protocol (BGP) autonomous system routing and path vector logic.

### Routing Algorithm Comparison
| Feature | Distance Vector (RIP) | Link State (OSPF) | Path Vector (BGP) |
| :--- | :--- | :--- | :--- |
| **Algorithm** | Bellman-Ford | Dijkstra''s Shortest Path | Path Vector policy routing |
| **Knowledge** | Neighbors only ("routing by rumor") | Complete topology graph | AS-path attribute sequences |
| **Convergence** | Slow; count-to-infinity problem | Fast via Link State Advertisements (LSA) | Policy-governed |
| **Metric** | Hop count (max 15 hops) | Cost based on bandwidth | Business policies, AS hops |

### Key Takeaways
- OSPF routers flood LSAs so every router builds an identical topology database, running Dijkstra locally to find the shortest tree.
- BGP routes between Autonomous Systems (AS) across the global Internet backbone using policy rules rather than pure shortest-path metrics.',
  NULL,
  45,
  false,
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0107-000000000007'::UUID,
  'd0000000-0000-0000-0000-000000000007'::UUID,
  'Data Link Layer: Framing, Error Detection (CRC), MAC Addressing & ARP',
  '### Learning Objectives
- Formulate framing techniques: Byte stuffing and Bit stuffing.
- Calculate Cyclic Redundancy Checks (CRC) using polynomial modulo-2 arithmetic.
- Trace Address Resolution Protocol (ARP) mapping 32-bit IP addresses to 48-bit MAC addresses.

### Cyclic Redundancy Check (CRC) Polynomial Division
To compute an $r$-bit CRC checksum for a bit string $M$ using generator polynomial $G$:
1. Append $r$ zero bits to $M$.
2. Perform modulo-2 binary division (using XOR instead of subtraction) by $G$.
3. The remainder $R$ is the CRC checksum appended to the transmitted frame.
4. The receiver divides the received frame by $G$; a non-zero remainder proves transmission bit error.

### Key Takeaways
- Switches operate at Layer 2, maintaining dynamic MAC address tables via source MAC learning and frame flooding.
- ARP resolves local IP addresses to physical MAC hardware addresses via broadcast requests and unicast replies.',
  NULL,
  45,
  false,
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0108-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000008'::UUID,
  'Software Development Lifecycles: Waterfall, Spiral & Agile/Scrum Frameworks',
  '### Learning Objectives
- Compare predictive SDLC models (Waterfall, V-Model) with adaptive iterative models (Spiral, Agile/Scrum).
- Understand the Agile Manifesto principles: individuals and interactions over processes and tools; working software over comprehensive documentation.
- Master Scrum rituals: Sprint Planning, Daily Standup, Sprint Review, and Retrospectives.

### SDLC Model Comparison
| Attribute | Waterfall | Spiral | Agile / Scrum |
| :--- | :--- | :--- | :--- |
| **Requirements** | Fixed upfront | Explored iteratively with risk analysis | Evolving, prioritized in product backlog |
| **Delivery** | Single final release | Iterative prototypes | Working increments every 1-4 weeks |
| **Risk Management** | High late-stage risk | Explicit formal risk assessment cycles | Continuous empirical feedback |
| **Best Suited For** | High-assurance stable projects | Mission-critical aerospace/defense | Rapidly evolving web & software products |

### Key Takeaways
- Scrum roles comprise Product Owner (prioritizes backlog), Scrum Master (removes blockers and coaches process), and Development Team (cross-functional builders).
- Velocity measures the average story points completed per sprint, guiding realistic capacity planning.',
  NULL,
  40,
  true,
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0108-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000008'::UUID,
  'Requirements Engineering: Functional/Non-Functional Specs & IEEE 830 SRS',
  '### Learning Objectives
- Distinguish Functional Requirements (what the system does) from Non-Functional Requirements (quality attributes: performance, security, availability).
- Author requirements adhering to INVEST criteria (Independent, Negotiable, Valuable, Estimable, Small, Testable).
- Structure an industry-standard Software Requirements Specification (SRS) following IEEE 830 standards.

### The FURPS+ Quality Model for Non-Functional Requirements
- **Functionality**: Capabilities, security, feature sets.
- **Usability**: Human factors, aesthetics, documentation, responsiveness.
- **Reliability**: Frequency of failure (MTBF), recoverability, predictability.
- **Performance**: Response time, throughput, memory consumption, latency limits.
- **Supportability**: Maintainability, testability, configurability, modularity.

### Writing Testable User Stories with Acceptance Criteria
```
Feature: Student Course Enrollment
  As an authenticated student
  I want to enroll in an active course
  So that I can access lesson materials and quizzes

  Acceptance Criteria (Gherkin):
  Given the student is logged in and holds role "student"
  And the target course is published and has available capacity
  When the student clicks "Enroll Course"
  Then the system records the enrollment in the database
  And updates the course access status to "Enrolled"
```

### Key Takeaways
- Ambiguous requirements cause $>50\%$ of software defects; write quantifiable criteria (e.g. "99th percentile API latency $<200\text{ms}$ under 1,000 req/s") rather than subjective terms like "fast".',
  NULL,
  45,
  false,
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0108-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000008'::UUID,
  'Software Architecture Patterns: Monolithic, Microservices & Event-Driven',
  '### Learning Objectives
- Evaluate trade-offs between Monolithic architectures, Microservices, and Event-Driven systems.
- Understand Conway''s Law and domain-driven design (DDD) Bounded Contexts.
- Apply synchronous REST/gRPC vs asynchronous message queues (Kafka, RabbitMQ) in distributed architectures.

### Architecture Trade-Off Analysis
- **Monolith**: Single unified deployable unit. Extremely fast to develop initially; simple debugging; difficult to scale team boundaries or independent services horizontally.
- **Microservices**: Loosely coupled services organized around business domains. Independent deployments and localized scaling; introduces network latency, distributed transactions, and partial failure complexity.
- **Event-Driven**: Producers publish domain events to an event bus; asynchronous consumers process events independently, maximizing decoupling.

### Key Takeaways
- Premature decomposition into microservices is an anti-pattern; start with a modular monolith and carve out microservices only when organizational or scaling boundaries demand it.',
  NULL,
  50,
  false,
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0108-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000008'::UUID,
  'SOLID Object-Oriented Design Principles & Clean Code',
  '### Learning Objectives
- Apply Robert C. Martin''s SOLID principles to eliminate software rot and code smells.
- Master Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, and Dependency Inversion.
- Refactor monolithic functions into clean, testable, decoupled classes.

### The SOLID Principles Defined
1. **Single Responsibility (SRP)**: A class should have only one reason to change.
2. **Open/Closed (OCP)**: Software entities should be open for extension, but closed for modification (using polymorphism and strategy patterns).
3. **Liskov Substitution (LSP)**: Subtypes must be substitutable for their base types without altering program correctness.
4. **Interface Segregation (ISP)**: Clients should not be forced to depend upon interfaces they do not use.
5. **Dependency Inversion (DIP)**: High-level modules should not depend on low-level modules; both should depend on abstractions (interfaces).

```typescript
// Violating DIP: high-level order service depends directly on concrete MySQL database
// Applying DIP: OrderService depends on generic IOrderRepository interface
interface IOrderRepository {
  save(order: Order): Promise<void>;
}

class OrderService {
  constructor(private repository: IOrderRepository) {} // Injected abstraction

  async placeOrder(order: Order) {
    await this.repository.save(order);
  }
}
```

### Key Takeaways
- High cohesion and loose coupling are the foundational hallmarks of sustainable software architecture.',
  NULL,
  50,
  false,
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0108-000000000005'::UUID,
  'd0000000-0000-0000-0000-000000000008'::UUID,
  'Black-Box & White-Box Testing Strategies: Equivalence, Boundary Values & Coverage',
  '### Learning Objectives
- Design functional black-box test suites using Equivalence Partitioning (EP) and Boundary Value Analysis (BVA).
- Measure structural white-box test coverage: Statement Coverage, Branch/Decision Coverage, and Path Coverage.
- Understand Cyclomatic Complexity $V(G) = E - N + 2P$ and its relation to linearly independent execution paths.

### Black-Box Techniques: Boundary Value Analysis
For an input field accepting integers $10 \le x \le 50$:
- **Equivalence Partitions**: Valid $[10, 50]$, Invalid $(<10)$, Invalid $(>50)$.
- **Boundary Test Values**: $9$ (just below), $10$ (boundary min), $11$ (just above), $49$ (just below), $50$ (boundary max), $51$ (just above).

### White-Box Coverage Hierarchy
$$\text{Statement Coverage} \subset \text{Branch Coverage} \subset \text{Path Coverage}$$
- **Statement Coverage**: Percentage of executable source code statements executed at least once.
- **Branch Coverage**: Percentage of boolean branch outcomes (both True and False) evaluated during testing.

### Key Takeaways
- The vast majority of input validation errors cluster at boundaries; Boundary Value Analysis catches off-by-one errors efficiently.',
  NULL,
  45,
  false,
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0108-000000000006'::UUID,
  'd0000000-0000-0000-0000-000000000008'::UUID,
  'Test-Driven Development (TDD), Unit Testing & Mocking Frameworks',
  '### Learning Objectives
- Practice the Test-Driven Development (TDD) Red-Green-Refactor cycle.
- Differentiate test doubles: Dummies, Stubs, Spies, and Mocks.
- Structure unit tests using the Arrange-Act-Assert (AAA) pattern.

### The Red-Green-Refactor Cycle
1. **Red**: Write a failing unit test defining the desired behavior before writing production code.
2. **Green**: Write the minimal production code necessary to make the test pass.
3. **Refactor**: Clean up the implementation, eliminate duplication, and improve design while keeping tests green.

```javascript
describe("GradingCalculator", () => {
  it("should calculate grade A for scores >= 90", () => {
    // Arrange
    const calculator = new GradingCalculator();
    // Act
    const grade = calculator.computeGrade(94.5);
    // Assert
    expect(grade).toBe("A");
  });
});
```

### Key Takeaways
- Unit tests test isolated functions in memory without hitting real databases or network sockets.
- Stubs return canned responses to incoming calls; Mocks verify that specific method calls and parameters occurred.',
  NULL,
  50,
  false,
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0108-000000000007'::UUID,
  'd0000000-0000-0000-0000-000000000008'::UUID,
  'Continuous Integration / Continuous Delivery (CI/CD) & Quality Gates',
  '### Learning Objectives
- Architect automated CI/CD pipelines: Lint -> Static Analysis -> Test -> Build -> Deploy.
- Enforce pull request quality gates: Automated branch protection, test thresholds, and code coverage minimums.
- Manage modern deployment patterns: Blue-Green deployments, Canary releases, and Feature Flags.

### CI/CD Pipeline Stages
```
Git Push ---> [ Linting (oxlint) ] ---> [ Type Check (tsc) ] ---> [ Unit Tests ] ---> [ Build Bundle ] ---> [ Deploy ]
                    |                          |                         |                     |
                  (Fail)                     (Fail)                    (Fail)                (Fail)
```

### Deployment Strategies
- **Blue-Green**: Two identical production environments. Deploy new version to Green; run smoke tests; switch router to Green. Near zero downtime rollback.
- **Canary**: Route a small percentage ($5\%$) of live traffic to the new version; monitor error metrics before rolling out to $100\%$ of users.

### Key Takeaways
- Continuous Integration requires developers to merge code to the main branch frequently, validated by automated build and test runs on every pull request.',
  NULL,
  45,
  false,
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0109-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000009'::UUID,
  'Intelligent Agents: PEAS Characterization and State-Space Formulation',
  '### Learning Objectives
- Define an intelligent agent through the PEAS framework (Performance measure, Environment, Actuators, Sensors).
- Classify task environments according to observability, determinism, dynamism, discreteness, and agent multiplicity.
- Formulate real-world problems as formal state-space models: initial state, action schema, transition model, goal test, and path cost.

### PEAS Environment Taxonomy
Agents interact with environments through percept sequences and actuators:

```
Sensors (Cameras, LIDAR, API inputs) -> Agent Function [Percept -> Action] -> Actuators (Motors, API calls)
```

| Dimension | Discrete / Static Example (Chess) | Continuous / Dynamic Example (Autonomous Vehicle) |
| :--- | :--- | :--- |
| Observability | Fully Observable | Partially Observable (occluded sensors, blind spots) |
| Determinism | Deterministic | Stochastic (weather, pedestrian behavior) |
| Episodic vs Sequential | Sequential | Sequential |
| Static vs Dynamic | Static (board does not change during turn) | Dynamic (environment evolves while computing action) |
| Discrete vs Continuous | Discrete (finite board positions and turns) | Continuous (velocity, steering angle, steering torques) |
| Single vs Multi-agent | Multi-agent (adversarial) | Multi-agent (competitive and cooperative traffic) |

### State-Space Search Problem Formulation
A formally defined search problem consists of a 5-tuple:
1. $S_0 \in S$: Initial state.
2. $Actions(s)$: Set of legal actions executable in state $s$.
3. $Result(s, a)$: Transition model returning successor state $s''$.
4. $GoalTest(s)$: Boolean function determining if state $s$ satisfies termination criteria.
5. $c(s, a, s'')$: Step cost of transitioning from state $s$ to $s''$ via action $a$.

### Key Takeaways
- Well-formulated state spaces abstract away irrelevant real-world complexities into discrete transitions.
- The nature of the environment dictates whether classical search, probabilistic planning, or reinforcement learning is the optimal agent architecture.',
  NULL,
  40,
  true,
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0109-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000009'::UUID,
  'Uninformed Search Strategies: BFS, DFS, and Uniform Cost Search',
  '### Learning Objectives
- Compare Breadth-First Search (BFS), Depth-First Search (DFS), Depth-Limited Search (DLS), and Iterative Deepening Search (IDS).
- Implement Uniform Cost Search (Dijkstra''s search) for graphs with non-negative arbitrary edge costs.
- Analyze time complexity, space complexity, completeness, and optimality across branching factor $b$ and solution depth $d$.

### Search Algorithm Comparison Matrix
Let $b$ be branching factor, $d$ be depth of shallowest goal, $m$ be maximum search depth, and $C^*$ be optimal cost:

| Algorithm | Complete? | Optimal? | Time Complexity | Space Complexity | Frontier Data Structure |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **BFS** | Yes (if $b$ is finite) | Yes (if uniform step cost) | $O(b^d)$ | $O(b^d)$ (Memory bottleneck) | FIFO Queue |
| **DFS** | No (infinite spaces) | No | $O(b^m)$ | $O(b \cdot m)$ (Linear memory) | LIFO Stack |
| **IDS** | Yes (if $b$ is finite) | Yes (if uniform step cost) | $O(b^d)$ | $O(b \cdot d)$ (Best of BFS & DFS) | Call Stack |
| **UCS** | Yes (if $\epsilon > 0$) | Yes | $O(b^{1 + \lfloor C^* / \epsilon \rfloor})$ | $O(b^{1 + \lfloor C^* / \epsilon \rfloor})$ | Min-Priority Queue |

### Uniform Cost Search Implementation
```python
import heapq

def uniform_cost_search(start_state, goal_test, get_successors):
    frontier = [] # Priority queue of (cumulative_cost, state, path)
    heapq.heappush(frontier, (0, start_state, [start_state]))
    explored = {} # state -> lowest cost seen so far

    while frontier:
        cost, current, path = heapq.heappop(frontier)

        if goal_test(current):
            return path, cost

        if current in explored and explored[current] <= cost:
            continue
        explored[current] = cost

        for next_state, step_cost in get_successors(current):
            new_cost = cost + step_cost
            if next_state not in explored or new_cost < explored[next_state]:
                heapq.heappush(frontier, (new_cost, next_state, path + [next_state]))

    return None, float(''inf'')
```

### Key Takeaways
- BFS guarantees shortest path in unweighted graphs but runs out of memory for $d > 10$.
- Iterative Deepening Search (IDS) combines BFS''s completeness and optimality with DFS''s $O(bd)$ space efficiency.',
  NULL,
  45,
  false,
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0109-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000009'::UUID,
  'Heuristic Search and the A* Algorithm: Admissibility and Consistency',
  '### Learning Objectives
- Formulate evaluation functions $f(n) = g(n) + h(n)$ balancing path cost and estimated future cost.
- Prove the optimality of A* under tree search (admissibility) and graph search (consistency / monotonicity).
- Develop domain heuristics for 8-puzzle and grid navigation: Manhattan distance, Euclidean distance, and Pattern Databases.

### Heuristic Mathematical Properties
For A* to guarantee finding an optimal solution:
1. **Admissibility ($h(n)$ never overestimates):**
   $$0 \le h(n) \le h^*(n) \quad \forall n$$
   where $h^*(n)$ is the true shortest cost from $n$ to the nearest goal state.
2. **Consistency / Triangle Inequality:**
   $$h(n) \le c(n, a, n'') + h(n'')$$
   If $h$ is consistent, $f(n)$ is non-decreasing along any path, ensuring that when node $n$ is expanded from the priority queue, the shortest path to $n$ has already been found.

```
       n
      / \
 c(n,n'')  h(n)
    /     \
   n'' ----> Goal
     h(n'')
```

### Dominance of Heuristics
If $h_2(n) \ge h_1(n)$ for all non-goal nodes $n$, and both are admissible, $h_2$ strictly **dominates** $h_1$. A* guided by $h_2$ expands a subset of the nodes expanded by $h_1$, saving computation.

### Key Takeaways
- Graph-search A* requires consistency to prevent re-opening closed nodes or degrading to exponential worst-case steps.
- Relaxing problem constraints (e.g., allowing tiles to slide through each other in 15-puzzle) systematically yields admissible heuristics.',
  NULL,
  50,
  false,
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0109-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000009'::UUID,
  'Adversarial Search: Minimax Algorithm and Alpha-Beta Pruning',
  '### Learning Objectives
- Model deterministic, zero-sum two-player games with perfect information (Chess, Tic-Tac-Toe, Checkers).
- Implement the recursive Minimax decision rule for maximizing and minimizing players.
- Derive Alpha-Beta pruning conditions and demonstrate order-dependent branch pruning.

### Minimax Formulation
Let $\text{MAX}$ seek to maximize payoff and $\text{MIN}$ seek to minimize it:
$$
\text{Minimax}(s) = \begin{cases}
\text{Utility}(s) & \text{if } \text{Terminal}(s) \\
\max_{a} \text{Minimax}(\text{Result}(s, a)) & \text{if Player}(s) = \text{MAX} \\
\min_{a} \text{Minimax}(\text{Result}(s, a)) & \text{if Player}(s) = \text{MIN}
\end{cases}
$$

### Alpha-Beta Pruning Invariants
- $\alpha$: Highest value found so far at any choice point along the path for MAX (initially $-\infty$).
- $\beta$: Lowest value found so far at any choice point along the path for MIN (initially $+\infty$).
- Prune branch whenever $\alpha \ge \beta$.

```python
def alphabeta(state, depth, alpha, beta, is_max_player):
    if depth == 0 or state.is_terminal():
        return state.evaluate_heuristic()

    if is_max_player:
        max_eval = float(''-inf'')
        for child in state.get_children():
            eval_score = alphabeta(child, depth - 1, alpha, beta, False)
            max_eval = max(max_eval, eval_score)
            alpha = max(alpha, eval_score)
            if beta <= alpha:
                break # Beta cutoff (prune remaining siblings)
        return max_eval
    else:
        min_eval = float(''inf'')
        for child in state.get_children():
            eval_score = alphabeta(child, depth - 1, alpha, beta, True)
            min_eval = min(min_eval, eval_score)
            beta = min(beta, eval_score)
            if beta <= alpha:
                break # Alpha cutoff
        return min_eval
```

### Pruning Efficiency
- Worst-case node evaluations: $O(b^m)$ (sub-optimal move ordering).
- Ideal move ordering (best moves evaluated first): $O(b^{m/2})$, doubling the effective search depth in identical compute time.',
  NULL,
  45,
  false,
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0109-000000000005'::UUID,
  'd0000000-0000-0000-0000-000000000009'::UUID,
  'Constraint Satisfaction Problems (CSP): Arc Consistency and Backtracking',
  '### Learning Objectives
- Formalize problems as CSPs: variables $X$, domains $D$, and constraints $C$.
- Implement Backtracking search enhanced with MRV (Minimum Remaining Values) and Degree heuristics.
- Enforce inference via Arc Consistency algorithm AC-3 to prune variable domains before and during search.

### Arc Consistency (AC-3)
A directed arc $(X_i, X_j)$ is **arc-consistent** if for every value $x \in D_i$, there exists some value $y \in D_j$ satisfying the constraint between $X_i$ and $X_j$.

```python
from collections import deque

def ac3(csp):
    queue = deque(csp.all_binary_arcs())
    while queue:
        Xi, Xj = queue.popleft()
        if revise(csp, Xi, Xj):
            if len(csp.domains[Xi]) == 0:
                return False # Problem is unsolvable under current assignments
            for Xk in csp.neighbors[Xi] - {Xj}:
                queue.append((Xk, Xi))
    return True

def revise(csp, Xi, Xj):
    revised = False
    for x in list(csp.domains[Xi]):
        if not any(csp.satisfies_constraint(x, y, Xi, Xj) for y in csp.domains[Xj]):
            csp.domains[Xi].remove(x)
            revised = True
    return revised
```

### Variable and Value Ordering Heuristics
1. **MRV (Fail-First):** Select variable with fewest legal domain values remaining.
2. **Degree Heuristic:** Tie-breaker selecting variable involved in most constraints with unassigned variables.
3. **Least Constraining Value (LCV):** Order values to leave the maximal choices open for remaining unassigned variables.',
  NULL,
  45,
  false,
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0109-000000000006'::UUID,
  'd0000000-0000-0000-0000-000000000009'::UUID,
  'Knowledge Representation and Propositional Logic Inference',
  '### Learning Objectives
- Construct knowledge bases using propositional logic syntax and semantics.
- Transform logical sentences into Conjunctive Normal Form (CNF).
- Execute the Resolution Refutation algorithm to prove entailment ($KB \models \alpha \iff KB \land \neg \alpha \vdash \Box$).
- Implement DPLL (Davis-Putnam-Logemann-Loveland) for boolean satisfiability (SAT).

### Conjunctive Normal Form (CNF) Conversion Steps
1. Eliminate biconditionals: $\alpha \leftrightarrow \beta \equiv (\alpha \to \beta) \land (\beta \to \alpha)$.
2. Eliminate implications: $\alpha \to \beta \equiv \neg \alpha \lor \beta$.
3. Move negations inwards via De Morgan''s laws: $\neg (\alpha \land \beta) \equiv \neg \alpha \lor \neg \beta$.
4. Distribute $\lor$ over $\land$: $\alpha \lor (\beta \land \gamma) \equiv (\alpha \lor \beta) \land (\alpha \lor \gamma)$.

### Resolution Rule
Given two clauses containing complementary literals:
$$
\frac{l_1 \lor \dots \lor l_i \lor \dots \lor l_k, \quad m_1 \lor \dots \lor \neg l_i \lor \dots \lor m_n}{l_1 \lor \dots \lor l_{i-1} \lor l_{i+1} \lor \dots \lor l_k \lor m_1 \lor \dots \lor m_{j-1} \lor m_{j+1} \lor \dots \lor m_n}
$$

### Key Takeaways
- Entailment testing via resolution refutation is complete for propositional logic.
- DPLL improves over naive truth tables by utilizing early termination, pure symbol heuristics, and unit clause propagation.',
  NULL,
  40,
  false,
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0109-000000000007'::UUID,
  'd0000000-0000-0000-0000-000000000009'::UUID,
  'Probabilistic Reasoning and Bayesian Networks',
  '### Learning Objectives
- Model uncertainty in multi-variable systems using Directed Acyclic Graphs (Bayesian Networks).
- Compute joint probability distributions using the conditional independence factorization chain rule.
- Calculate exact posterior probabilities using Variable Elimination and examine approximate sampling methods (Gibbs sampling).

### Bayesian Network Semantics
A Bayesian Network factorizes the full joint probability distribution:
$$
P(X_1, X_2, \dots, X_n) = \prod_{i=1}^n P(X_i \mid \text{Parents}(X_i))
$$

### Conditional Independence & d-Separation
Two nodes $X$ and $Y$ are conditionally independent given evidence set $E$ if all undirected paths between them are blocked:
1. **Linear / Cascade ($X \to Z \to Y$):** Blocked if $Z \in E$.
2. **Divergent ($X \leftarrow Z \to Y$):** Blocked if $Z \in E$.
3. **Convergent / Collider ($X \to Z \leftarrow Y$):** Blocked if neither $Z$ nor any of its descendants are in $E$. (Observing $Z$ activates explaining-away effect).

### Key Takeaways
- Bayesian Networks reduce exponential joint probability storage $O(2^n)$ to linear/polynomial space when node in-degrees are bounded.
- Exact inference is NP-hard in general graphs, motivating MCMC and belief propagation algorithms.',
  NULL,
  50,
  false,
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0110-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000010'::UUID,
  'Supervised Learning Setup: Loss Functions, Empirical Risk, and Optimization',
  '### Learning Objectives
- Formulate supervised learning tasks as Empirical Risk Minimization (ERM) problems.
- Distinguish convex from non-convex loss functions for regression (MSE, MAE, Huber) and classification (Cross-Entropy, Hinge).
- Derive Batch Gradient Descent (BGD), Stochastic Gradient Descent (SGD), and Mini-batch Gradient Descent update rules.

### Mathematical Framework
Given dataset $\mathcal{D} = \{(x_i, y_i)\}_{i=1}^N$ with $x_i \in \mathbb{R}^D$ and $y_i \in \mathcal{Y}$:
$$
\min_{\theta} \mathcal{R}_{emp}(\theta) = \frac{1}{N} \sum_{i=1}^N \mathcal{L}(f(x_i; \theta), y_i)
$$

### Gradient Descent Variants
```
Batch GD:      \theta_{t+1} = \theta_t - \eta \cdot \frac{1}{N} \sum_{i=1}^N \nabla_\theta \mathcal{L}(f(x_i; \theta_t), y_i)
Stochastic GD: \theta_{t+1} = \theta_t - \eta \cdot \nabla_\theta \mathcal{L}(f(x_i; \theta_t), y_i) \quad (i \sim \text{Uniform}(1, N))
Mini-batch:    \theta_{t+1} = \theta_t - \eta \cdot \frac{1}{|B|} \sum_{i \in B} \nabla_\theta \mathcal{L}(f(x_i; \theta_t), y_i)
```

### Common Loss Functions
1. **Mean Squared Error (L2 Loss):** $\mathcal{L}(\hat{y}, y) = \frac{1}{2}(\hat{y} - y)^2$. Penalizes large outliers heavily.
2. **Mean Absolute Error (L1 Loss):** $\mathcal{L}(\hat{y}, y) = |\hat{y} - y|$. Robust to outliers, non-differentiable at $\hat{y} = y$.
3. **Binary Cross-Entropy (Logistic Loss):** $\mathcal{L}(\hat{y}, y) = - [y \log \hat{y} + (1 - y) \log(1 - \hat{y})]$. Convex for linear models.',
  NULL,
  45,
  true,
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0110-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000010'::UUID,
  'Linear and Logistic Regression: Closed-Form Normal Equation vs Iterative Solvers',
  '### Learning Objectives
- Derive the Ordinary Least Squares (OLS) closed-form Normal Equation: $\theta^* = (X^T X)^{-1} X^T y$.
- Formulate binary classification via the sigmoid logistic link function: $\sigma(z) = \frac{1}{1 + e^{-z}}$.
- Compute gradients of the negative log-likelihood loss for logistic regression.

### OLS Normal Equation Derivation
Let design matrix $X \in \mathbb{R}^{N \times D}$ and target vector $y \in \mathbb{R}^N$.
$$
J(\theta) = \frac{1}{2N} \|X\theta - y\|^2 = \frac{1}{2N} (X\theta - y)^T (X\theta - y)
$$
Setting the gradient with respect to $\theta$ to zero:
$$
\nabla_\theta J(\theta) = \frac{1}{N} X^T (X\theta - y) = 0 \implies X^T X \theta = X^T y
$$
$$
\theta^* = (X^T X)^{-1} X^T y
$$

### Logistic Regression Update Rule
Predict probability $P(y=1 \mid x) = \sigma(\theta^T x) = \frac{1}{1 + e^{-\theta^T x}}$.
The gradient of the cross-entropy cost has the identical mathematical form to linear regression:
$$
\nabla_\theta J(\theta) = \frac{1}{N} \sum_{i=1}^N (\sigma(\theta^T x_i) - y_i) x_i
$$

### Key Takeaways
- The Normal Equation computes exact solutions in $O(D^3)$ time without learning rate tuning, but becomes computationally prohibitive when $D > 10^4$.
- Gradient descent scales to arbitrary feature dimensions and non-linear extensions.',
  NULL,
  50,
  false,
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0110-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000010'::UUID,
  'Generalization, Bias-Variance Tradeoff, and Regularization (L1 / L2)',
  '### Learning Objectives
- Decompose expected prediction error into irreducible noise, bias squared, and variance.
- Diagnose underfitting (high bias) vs overfitting (high variance) using training and validation learning curves.
- Implement Ridge ($L_2$) and Lasso ($L_1$) regularization to constrain parameter complexity.

### Bias-Variance Decomposition
For true data generating process $y = f(x) + \epsilon$ with noise $\mathbb{E}[\epsilon] = 0, \text{Var}(\epsilon) = \sigma^2$:
$$
\mathbb{E}\left[(y - \hat{f}(x))^2\right] = \underbrace{\left(\mathbb{E}[\hat{f}(x)] - f(x)\right)^2}_{\text{Bias}^2} + \underbrace{\mathbb{E}\left[(\hat{f}(x) - \mathbb{E}[\hat{f}(x)])^2\right]}_{\text{Variance}} + \underbrace{\sigma^2}_{\text{Irreducible Noise}}
$$

### Regularization Formulations
1. **Ridge Regression ($L_2$ Penalty):**
   $$J_{Ridge}(\theta) = \text{MSE}(\theta) + \lambda \sum_{j=1}^D \theta_j^2$$
   - Analytical solution: $\theta^* = (X^T X + \lambda I)^{-1} X^T y$.
   - Shrinks weights continuously toward zero; guarantees invertibility of $X^T X$.
2. **Lasso Regression ($L_1$ Penalty):**
   $$J_{Lasso}(\theta) = \text{MSE}(\theta) + \lambda \sum_{j=1}^D |\theta_j|$$
   - Produces sparse weight vectors by driving non-informative coefficients exactly to zero (automated feature selection).',
  NULL,
  45,
  false,
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0110-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000010'::UUID,
  'Decision Trees and Splitting Criteria: ID3, C4.5, and CART',
  '### Learning Objectives
- Construct decision trees recursively using greedy top-down induction.
- Compute Information Gain using Shannon Entropy vs Gini Impurity for node splitting.
- Apply pre-pruning (max depth, min samples split) and cost-complexity post-pruning to mitigate overfitting.

### Splitting Impurity Metrics
Given a node with $K$ classes and class proportions $p_k$:
1. **Shannon Entropy:**
   $$H(S) = - \sum_{k=1}^K p_k \log_2(p_k)$$
2. **Gini Impurity (CART default):**
   $$\text{Gini}(S) = 1 - \sum_{k=1}^K p_k^2$$
3. **Information Gain (IG):**
   $$\text{IG}(S, A) = H(S) - \sum_{v \in \text{Values}(A)} \frac{|S_v|}{|S|} H(S_v)$$

```python
import numpy as np

def gini_impurity(y):
    classes, counts = np.unique(y, return_counts=True)
    probabilities = counts / len(y)
    return 1.0 - np.sum(probabilities ** 2)

def information_gain(y_parent, y_left, y_right):
    p_left = len(y_left) / len(y_parent)
    p_right = len(y_right) / len(y_parent)
    return gini_impurity(y_parent) - (p_left * gini_impurity(y_left) + p_right * gini_impurity(y_right))
```

### Key Takeaways
- Decision trees are non-parametric, scale-invariant to feature monotonic transformations, and naturally interpretable.
- Unpruned trees have high variance and memorize noisy training samples.',
  NULL,
  45,
  false,
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0110-000000000005'::UUID,
  'd0000000-0000-0000-0000-000000000010'::UUID,
  'Ensemble Learning: Bagging, Random Forests, and Gradient Boosting (XGBoost)',
  '### Learning Objectives
- Contrast variance-reduction via Bootstrap Aggregating (Bagging) with bias-reduction via Boosting.
- Analyze Random Forests: feature subspace sampling and out-of-bag (OOB) error estimation.
- Trace Gradient Boosted Decision Trees (GBDT): fitting pseudo-residuals sequentially.

### Bagging vs Boosting
| Dimension | Random Forests (Bagging) | Gradient Boosting (Boosting) |
| :--- | :--- | :--- |
| Primary Goal | Reduce Variance | Reduce Bias |
| Base Learners | Deep, fully grown, unpruned trees | Shallow, weak learners (stumps, depth 3-6) |
| Model Training | Parallel independent bootstrap samples | Sequential (each tree corrects residual errors of prior sum) |
| Feature Sampling | $\sqrt{D}$ random features considered at each split | Feature and instance subsampling per boosting round |

### Gradient Boosting Mathematical Principle
Let $F_0(x) = \arg\min_c \sum_{i=1}^N \mathcal{L}(y_i, c)$. At iteration $m$:
1. Compute negative gradient (pseudo-residuals):
   $$r_{im} = -\left[ \frac{\partial \mathcal{L}(y_i, F(x_i))}{\partial F(x_i)} \right]_{F(x) = F_{m-1}(x)}$$
2. Train regression tree $h_m(x)$ to predict targets $r_{im}$.
3. Update ensemble with shrinkage learning rate $\eta \in (0, 1]$:
   $$F_m(x) = F_{m-1}(x) + \eta \cdot h_m(x)$$',
  NULL,
  50,
  false,
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0110-000000000006'::UUID,
  'd0000000-0000-0000-0000-000000000010'::UUID,
  'Support Vector Machines: Maximum Margin Hyperplanes and Kernel Trick',
  '### Learning Objectives
- Derive the hard-margin and soft-margin Support Vector Machine quadratic programming formulations.
- Interpret slack variables $\xi_i$ and the regularization tradeoff parameter $C$.
- Apply the Kernel Trick to project non-linearly separable inputs into high-dimensional Hilbert spaces.

### Primal Soft-Margin SVM Formulation
Find weight vector $w \in \mathbb{R}^D$ and bias $b \in \mathbb{R}$:
$$
\min_{w, b, \xi} \frac{1}{2} \|w\|^2 + C \sum_{i=1}^N \xi_i \quad \text{s.t.} \quad y_i(w^T x_i + b) \ge 1 - \xi_i, \quad \xi_i \ge 0
$$

### The Kernel Trick
Mercer''s Theorem allows computing inner products $\langle \phi(x), \phi(z) \rangle$ in high-dimensional feature space directly via kernel function $K(x, z)$ without explicitly mapping coordinates:
1. **Radial Basis Function (RBF / Gaussian):**
   $$K(x, z) = \exp\left( -\gamma \|x - z\|^2 \right)$$
2. **Polynomial Kernel:**
   $$K(x, z) = (x^T z + c)^d$$

### Key Takeaways
- SVM predictions depend exclusively on the subset of training data points lying on or inside the margin boundary (support vectors).
- High $C$ penalizes misclassifications strictly (lower bias, higher variance); low $C$ allows larger margins with more slack violations.',
  NULL,
  45,
  false,
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0110-000000000007'::UUID,
  'd0000000-0000-0000-0000-000000000010'::UUID,
  'Unsupervised Learning: K-Means, Gaussian Mixture Models, and PCA',
  '### Learning Objectives
- Implement K-Means clustering and evaluate cluster inertia using the Elbow method and Silhouette score.
- Formulate soft clustering with Gaussian Mixture Models (GMM) via Expectation-Maximization (EM).
- Derive Principal Component Analysis (PCA) via eigendecomposition of the empirical covariance matrix.

### K-Means Clustering Algorithm
1. Initialize $K$ cluster centroids $\{\mu_1, \dots, \mu_K\}$ (using K-Means++ to maximize initial spread).
2. **Assignment Step:** Assign each sample to the nearest centroid:
   $$c_i = \arg\min_k \|x_i - \mu_k\|^2$$
3. **Update Step:** Recalculate centroids as the mean of assigned vectors:
   $$\mu_k = \frac{1}{|S_k|} \sum_{i \in S_k} x_i$$
4. Repeat until centroid convergence $\|\Delta \mu\| < \epsilon$.

### Principal Component Analysis (PCA)
To project data from dimension $D$ to $k < D$ while maximizing preserved variance:
1. Mean-center data matrix $\tilde{X} = X - \bar{X}$.
2. Compute sample covariance matrix $\Sigma = \frac{1}{N} \tilde{X}^T \tilde{X}$.
3. Calculate eigenvalues and eigenvectors: $\Sigma v_i = \lambda_i v_i$.
4. Sort eigenvectors in descending order of eigenvalues $\lambda_1 \ge \lambda_2 \dots \ge \lambda_D$.
5. Construct projection matrix $W = [v_1, v_2, \dots, v_k]$ and transform: $Z = \tilde{X} W$.',
  NULL,
  50,
  false,
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0111-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000011'::UUID,
  'From Recurrent Models to Self-Attention: Limitations of RNNs and LSTMs',
  '### Learning Objectives
- Identify sequential bottlenecks and vanishing/exploding gradients in vanilla RNNs and LSTMs.
- Contrast sequential recurrence $O(N)$ runtime with parallelizable self-attention $O(1)$ sequential operations.
- Formulate the fundamental Scaled Dot-Product Attention equation: $\text{Attention}(Q, K, V) = \text{softmax}\left(\frac{QK^T}{\sqrt{d_k}}\right)V$.

### The Attention Mechanism
In recurrent networks, information flows sequentially through hidden vectors $h_t = f(h_{t-1}, x_t)$, making GPU parallelization impossible during training and causing catastrophic forgetting over long sequences.

Attention computes direct pairwise affinity between all token pairs simultaneously:
```
Inputs: Queries Q in R^{N x d_k}, Keys K in R^{M x d_k}, Values V in R^{M x d_v}

                  Q      K^T
                  \    /
               Matrix Multiply
                     |
               Scale (1 / sqrt(d_k))
                     |
                Mask (Optional)
                     |
                  Softmax
                     \   /
                 Matrix Multiply (V)
                     |
                   Output
```

### Why Scale by $\sqrt{d_k}$?
For large projection dimension $d_k$, the dot products $q_i \cdot k_j = \sum_{m=1}^{d_k} q_{im} k_{jm}$ grow large in magnitude (variance $\approx d_k$ under unit variance assumptions). Large dot products push the softmax function into regions with near-zero gradients. Dividing by $\sqrt{d_k}$ preserves unit variance and prevents vanishing gradients.',
  NULL,
  45,
  true,
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0111-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000011'::UUID,
  'The Transformer Architecture: Multi-Head Attention, Residuals, and LayerNorm',
  '### Learning Objectives
- Dissect the multi-head attention mechanism and its linear projection matrices $W_i^Q, W_i^K, W_i^V, W^O$.
- Understand positional encodings (sinusoidal vs learned embeddings vs RoPE - Rotary Position Embedding).
- Compare Pre-LN vs Post-LN architectures and analyze LayerNorm vs RMSNorm.

### Multi-Head Attention Formulation
$$
\text{MultiHead}(Q, K, V) = \text{Concat}(\text{head}_1, \dots, \text{head}_h) W^O
$$
$$
\text{where} \quad \text{head}_i = \text{Attention}(Q W_i^Q, K W_i^K, V W_i^V)
$$

### Transformer Block Dataflow (Pre-LN)
```python
import torch
import torch.nn as nn

class TransformerBlock(nn.Module):
    def __init__(self, d_model, n_heads, d_ff):
        super().__init__()
        self.ln1 = nn.LayerNorm(d_model)
        self.attn = nn.MultiheadAttention(d_model, n_heads, batch_first=True)
        self.ln2 = nn.LayerNorm(d_model)
        self.ffn = nn.Sequential(
            nn.Linear(d_model, d_ff),
            nn.GELU(),
            nn.Linear(d_ff, d_model)
        )

    def forward(self, x, mask=None):
        # Pre-LN with residual connections
        norm_x = self.ln1(x)
        attn_out, _ = self.attn(norm_x, norm_x, norm_x, attn_mask=mask)
        x = x + attn_out
        x = x + self.ffn(self.ln2(x))
        return x
```

### Rotary Position Embedding (RoPE)
RoPE encodes relative position by rotating query and key representations in 2D complex feature planes:
$$R_{\Theta, m}^d = \text{diag}(R_{\theta_1, m}, \dots, R_{\theta_{d/2}, m})$$
This allows the dot product $\langle R_m q, R_n k \rangle$ to depend purely on relative token distance $(m - n)$, enabling length extrapolation.',
  NULL,
  50,
  false,
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0111-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000011'::UUID,
  'Pretraining Paradigms: Causal LM vs Masked LM, Tokenization, and Scaling Laws',
  '### Learning Objectives
- Compare Autoregressive Causal Language Modeling (GPT family) with Bidirectional Masked Language Modeling (BERT).
- Examine subword tokenization algorithms: Byte-Pair Encoding (BPE), WordPiece, and SentencePiece.
- Analyze Chinchilla scaling laws balancing compute budget, parameter count, and training token volume.

### Pretraining Objective Comparison
1. **Masked Language Modeling (Encoder-only):**
   $$\mathcal{L}_{MLM}(\theta) = - \sum_{i \in \text{Masked}} \log P(x_i \mid x_{\setminus i}; \theta)$$
   Bidirectional context enables deep text representation, ideal for classification and extraction.
2. **Causal Autoregressive Language Modeling (Decoder-only):**
   $$\mathcal{L}_{CLM}(\theta) = - \sum_{t=1}^T \log P(x_t \mid x_{<t}; \theta)$$
   Enforced via lower-triangular causal attention masking, making decoders natural generative engines.

### Chinchilla Scaling Laws (Hoffmann et al., 2022)
For optimal compute efficiency given compute budget $C \approx 6 N D$:
- Model parameter count $N$ and token count $D$ should scale in **equal proportion**:
  $$N \propto C^{0.5}, \quad D \propto C^{0.5}$$
- To train a model compute-optimally, train with approximately $20$ tokens per model parameter.',
  NULL,
  45,
  false,
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0111-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000011'::UUID,
  'Instruction Tuning and Alignment: SFT, RLHF, and Direct Preference Optimization (DPO)',
  '### Learning Objectives
- Trace the three-stage post-training pipeline: Pretraining -> Supervised Fine-Tuning (SFT) -> Alignment.
- Implement Reinforcement Learning from Human Feedback (RLHF) with reward modeling and PPO.
- Formulate Direct Preference Optimization (DPO) to optimize policy directly from preference pairs without training a separate reward model.

### Alignment Paradigm
```
Raw Base LLM -> SFT (Instruction-Response Pairs) -> Preference Dataset (y_w > y_l) -> RLHF / DPO -> Aligned Chat Model
```

### Direct Preference Optimization (DPO)
Standard RLHF trains a reward model $r_\psi(x, y)$ and uses PPO with a KL divergence penalty to keep the policy close to reference model $\pi_{ref}$.

Rafailov et al. (2023) derived that the optimal policy $\pi_\theta$ can be expressed analytically in terms of the reward:
$$
r(x, y) = \beta \log \frac{\pi_\theta(y \mid x)}{\pi_{ref}(y \mid x)} + \beta \log Z(x)
$$
Substituting this into the Bradley-Terry preference model yields the direct DPO loss function:
$$
\mathcal{L}_{DPO}(\theta) = - \mathbb{E}_{(x, y_w, y_l)} \left[ \log \sigma \left( \beta \log \frac{\pi_\theta(y_w \mid x)}{\pi_{ref}(y_w \mid x)} - \beta \log \frac{\pi_\theta(y_l \mid x)}{\pi_{ref}(y_l \mid x)} \right) \right]
$$
This eliminates reinforcement learning instability, value networks, and reward model training.',
  NULL,
  50,
  false,
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0111-000000000005'::UUID,
  'd0000000-0000-0000-0000-000000000011'::UUID,
  'Parameter-Efficient Fine-Tuning (PEFT): LoRA, QLoRA, and Prefix Tuning',
  '### Learning Objectives
- Analyze the memory bottleneck of full-parameter fine-tuning (optimizer states, gradients, activations).
- Implement Low-Rank Adaptation (LoRA): decomposing weight updates into low-rank matrices $W = W_0 + \frac{\alpha}{r} B A$.
- Apply QLoRA: 4-bit NormalFloat (NF4) quantization, Double Quantization, and Paged Optimizers.

### Low-Rank Adaptation (LoRA)
Given pre-trained weight matrix $W_0 \in \mathbb{R}^{d \times k}$, freeze $W_0$ and decompose the update $\Delta W$ into two low-rank matrices:
$$
h = W_0 x + \Delta W x = W_0 x + \frac{\alpha}{r} B A x
$$
where $B \in \mathbb{R}^{d \times r}$ (initialized to 0) and $A \in \mathbb{R}^{r \times k}$ (initialized from $\mathcal{N}(0, \sigma^2)$) with rank $r \ll \min(d, k)$.

```
       x (k-dim)
       /       \
   W_0 (frozen) A (r x k)
     |          |
     |          B (d x r)
     \         /
      + (d-dim output)
```

### Memory Savings with QLoRA
- Full 16-bit 7B model: $\approx 14$ GB weights $+ 28$ GB Adam optimizer states $+ 14$ GB gradients $\approx 56$ GB VRAM.
- QLoRA 4-bit 7B model: $\approx 3.5$ GB weights $+ \approx 1$ GB LoRA adapter parameters and optimizer $\approx 6$ GB VRAM (fits on single consumer GPU).',
  NULL,
  45,
  false,
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0111-000000000006'::UUID,
  'd0000000-0000-0000-0000-000000000011'::UUID,
  'Retrieval-Augmented Generation (RAG): Vector Databases and Dense Embeddings',
  '### Learning Objectives
- Construct end-to-end RAG architectures: ingestion, chunking, dense embeddings, vector indexing, and generation.
- Compare approximate nearest neighbor (ANN) vector indexing algorithms: HNSW vs IVF-PQ.
- Implement advanced retrieval strategies: hybrid search (dense + BM25 sparse) and cross-encoder re-ranking.

### RAG Pipeline Architecture
```
Documents -> Recursive Chunking -> Embedding Model (e.g. bge-large) -> Vector DB (HNSW Index)
                                                                             |
User Query ---------------------> Query Embedding -----------------> Vector Search (Top-K)
                                                                             |
User Query + Retrieved Context Chunks -----------------------------> Re-Ranker (Cross-Encoder)
                                                                             |
Refined Context + System Prompt + Query ---------------------------> LLM Generator -> Grounded Answer
```

### Chunking Strategies & Tradeoffs
1. **Fixed Token Windows with Overlap:** e.g., 512 tokens with 64-token overlap. Simple but splits semantic boundaries.
2. **Recursive Character Chunking:** Splits hierarchy: paragraph (''\n\n'') -> sentence (''\n'') -> space.
3. **Semantic Chunking:** Computes embedding distance between consecutive sentences and cuts chunks at semantic inflection points.',
  NULL,
  50,
  false,
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0111-000000000007'::UUID,
  'd0000000-0000-0000-0000-000000000011'::UUID,
  'Decoding Strategies, Hallucination Mitigation, and Evaluation',
  '### Learning Objectives
- Analyze token sampling methods: Greedy search, Beam search, Temperature scaling, Top-$k$, and Top-$p$ (Nucleus sampling).
- Classify types of LLM hallucinations: factual contradiction, ungrounded extrapolation, and sycophancy.
- Evaluate generative systems using automated benchmarks (MMLU, GSM8K, HumanEval) and RAG triaging (Faithfulness, Answer Relevance).

### Decoding Algorithm Formulations
Given next-token logits $z_i$:
1. **Temperature Scaling:**
   $$P(x_i) = \frac{\exp(z_i / T)}{\sum_j \exp(z_j / T)}$$
   $T \to 0$ approaches greedy argmax; $T > 1$ flattens probability distribution toward uniform randomness.
2. **Top-$p$ (Nucleus) Sampling:**
   Filter tokens to the smallest candidate set $V^{(p)}$ whose cumulative probability exceeds threshold $p \in (0, 1]$:
   $$\sum_{i \in V^{(p)}} P(x_i) \ge p$$
   Dynamically adjusts vocabulary width based on model certainty.',
  NULL,
  45,
  false,
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0112-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000012'::UUID,
  'Vector Spaces, Subspaces, and Linear Independence',
  '### Learning Objectives
- Define a real vector space $V$ over field $\mathbb{R}$ and verify the 8 vector space axioms.
- Test whether a subset $W \subseteq V$ is a valid subspace using closure under vector addition and scalar multiplication.
- Determine linear independence of vector sets and compute the basis and dimension of spans.

### Subspace Test Criterion
A non-empty subset $W \subseteq V$ is a subspace of $V$ if and only if:
1. The zero vector $\mathbf{0} \in W$.
2. For all $u, v \in W$, $u + v \in W$ (closed under addition).
3. For all $c \in \mathbb{R}$ and $u \in W$, $c \cdot u \in W$ (closed under scalar multiplication).

### Linear Independence and Span
Vectors $\{v_1, v_2, \dots, v_k\}$ are linearly independent if:
$$
c_1 v_1 + c_2 v_2 + \dots + c_k v_k = \mathbf{0} \implies c_1 = c_2 = \dots = c_k = 0
$$
If any non-trivial linear combination yields $\mathbf{0}$, at least one vector lies in the span of the others, making the set linearly dependent.

### Matrix Rank and Basis Computation
```python
import numpy as np

A = np.array([
    [1, 2, 3],
    [2, 4, 6],
    [1, 1, 1]
])

# Compute rank and singular values
rank = np.linalg.matrix_rank(A)
print(f"Matrix Rank: {rank}") # Outputs 2 (rows 1 and 2 are linearly dependent)
```

### Key Takeaways
- The dimension of a subspace is the number of vectors in any of its bases.
- Any set of $k > n$ vectors in $\mathbb{R}^n$ must be linearly dependent.',
  NULL,
  45,
  true,
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0112-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000012'::UUID,
  'Systems of Linear Equations: Gaussian Elimination and LU Factorization',
  '### Learning Objectives
- Solve systems $A x = b$ using Gaussian elimination with partial pivoting.
- Factor invertible matrix $A$ into lower triangular $L$ and upper triangular $U$ matrices ($P A = L U$).
- Analyze computational complexity and numerical stability in floating-point operations.

### Gaussian Elimination with Partial Pivoting
To solve $A x = b$, row operations transform augmented matrix $[A \mid b]$ to row echelon form:
1. Row swap ($R_i \leftrightarrow R_j$).
2. Row scaling ($R_i \leftarrow c R_i, c \neq 0$).
3. Row addition ($R_i \leftarrow R_i + c R_j$).

### LU Decomposition
When elimination requires no row swaps ($A = L U$):
$$
L = \begin{bmatrix} 1 & 0 & 0 \\ l_{21} & 1 & 0 \\ l_{31} & l_{32} & 1 \end{bmatrix}, \quad
U = \begin{bmatrix} u_{11} & u_{12} & u_{13} \\ 0 & u_{22} & u_{23} \\ 0 & 0 & u_{33} \end{bmatrix}
$$
Solving $A x = b$ becomes two $O(n^2)$ triangular back-substitutions:
1. Solve $L y = b$ (Forward substitution).
2. Solve $U x = y$ (Backward substitution).

### Key Takeaways
- LU decomposition requires $O(\frac{2}{3} n^3)$ operations once, allowing solving multiple right-hand sides $b$ in only $O(n^2)$ per solve.
- Partial pivoting ($P A = L U$) prevents division by small pivot numbers, maintaining numerical stability against round-off errors.',
  NULL,
  50,
  false,
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0112-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000012'::UUID,
  'The Four Fundamental Subspaces and the Rank-Nullity Theorem',
  '### Learning Objectives
- Identify the four fundamental subspaces of an $m \times n$ matrix $A$: Column Space $C(A)$, Nullspace $N(A)$, Row Space $C(A^T)$, and Left Nullspace $N(A^T)$.
- State and prove the Rank-Nullity Theorem: $\text{rank}(A) + \text{nullity}(A) = n$.
- Establish the fundamental orthogonal complement relations: $C(A^T) \perp N(A)$ and $C(A) \perp N(A^T)$.

### Fundamental Subspace Properties
For matrix $A \in \mathbb{R}^{m \times n}$ with rank $r$:
| Subspace | Notation | Ambient Space | Dimension | Orthogonal Complement |
| :--- | :--- | :--- | :--- | :--- |
| Column Space | $C(A)$ | $\mathbb{R}^m$ | $r$ | $N(A^T)$ in $\mathbb{R}^m$ |
| Nullspace (Kernel) | $N(A)$ | $\mathbb{R}^n$ | $n - r$ | $C(A^T)$ in $\mathbb{R}^n$ |
| Row Space | $C(A^T)$ | $\mathbb{R}^n$ | $r$ | $N(A)$ in $\mathbb{R}^n$ |
| Left Nullspace | $N(A^T)$ | $\mathbb{R}^m$ | $m - r$ | $C(A)$ in $\mathbb{R}^m$ |

### The Rank-Nullity Theorem
Every vector $x \in \mathbb{R}^n$ can be uniquely decomposed into an orthogonal sum:
$$x = x_{\text{row}} + x_{\text{null}} \quad \text{where} \quad x_{\text{row}} \in C(A^T), \, x_{\text{null}} \in N(A)$$
Applying $A$ maps $x_{\text{null}}$ to $\mathbf{0}$ and gives an isomorphism between $C(A^T)$ and $C(A)$.',
  NULL,
  45,
  false,
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0112-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000012'::UUID,
  'Eigenvalues, Eigenvectors, and Matrix Diagonalization',
  '### Learning Objectives
- Solve the characteristic polynomial $\det(A - \lambda I) = 0$ to determine eigenvalues.
- Find bases for eigenspaces $N(A - \lambda I)$.
- Diagonalize square matrices $A = P D P^{-1}$ and compute matrix powers $A^k = P D^k P^{-1}$.
- State the Spectral Theorem for symmetric real matrices ($A = Q \Lambda Q^T$).

### Characteristic Equation and Eigenspaces
A non-zero vector $v$ is an eigenvector of $A$ with eigenvalue $\lambda$ if:
$$
A v = \lambda v \iff (A - \lambda I) v = \mathbf{0}
$$
Nontrivial solutions exist if and only if:
$$
\det(A - \lambda I) = 0
$$

### Diagonalizability Condition
An $n \times n$ matrix $A$ is diagonalizable if and only if it possesses $n$ linearly independent eigenvectors.
If all $n$ eigenvalues are distinct, $A$ is guaranteed diagonalizable.
If algebraic multiplicity exceeds geometric multiplicity for any eigenvalue, $A$ is defective and requires Jordan canonical form.

### The Spectral Theorem
If $A = A^T$ (real symmetric matrix):
1. All eigenvalues $\lambda_i$ are purely real.
2. Eigenvectors corresponding to distinct eigenvalues are mutually orthogonal.
3. $A$ has an orthonormal basis of eigenvectors: $A = Q \Lambda Q^T$ with $Q^T Q = I$.',
  NULL,
  50,
  false,
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0112-000000000005'::UUID,
  'd0000000-0000-0000-0000-000000000012'::UUID,
  'Orthogonality, Gram-Schmidt Process, and QR Decomposition',
  '### Learning Objectives
- Compute inner products, norms, angles, and orthogonal projections.
- Apply the Gram-Schmidt orthogonalization process to convert an arbitrary basis into an orthonormal basis.
- Factor matrix $A = Q R$ where $Q$ has orthonormal columns and $R$ is upper triangular.

### Gram-Schmidt Algorithm
Given independent vectors $\{v_1, v_2, \dots, v_k\}$:
1. $u_1 = v_1, \quad e_1 = \frac{u_1}{\|u_1\|}$.
2. $u_2 = v_2 - \text{proj}_{u_1}(v_2) = v_2 - (v_2 \cdot e_1) e_1, \quad e_2 = \frac{u_2}{\|u_2\|}$.
3. In general for step $j$:
   $$u_j = v_j - \sum_{i=1}^{j-1} (v_j \cdot e_i) e_i, \quad e_j = \frac{u_j}{\|u_j\|}$$

### QR Factorization in Least Squares
In overdetermined systems $A x = b$ where $A = Q R$:
$$
A^T A x = A^T b \implies (R^T Q^T)(Q R) x = R^T Q^T b \implies R^T R x = R^T Q^T b
$$
Since $R^T$ is invertible:
$$
R x = Q^T b
$$
This solves least squares via backward substitution on $R$ without computing $A^T A$, preserving numerical condition number $\kappa(R) = \kappa(A)$.',
  NULL,
  45,
  false,
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0112-000000000006'::UUID,
  'd0000000-0000-0000-0000-000000000012'::UUID,
  'Singular Value Decomposition (SVD) and Principal Component Analysis',
  '### Learning Objectives
- Formulate the Singular Value Decomposition $A = U \Sigma V^T$ for arbitrary rectangular matrices.
- Interpret singular values $\sigma_i = \sqrt{\lambda_i(A^T A)}$ and left/right singular vectors.
- Apply the Eckart-Young-Mirsky Theorem for optimal low-rank matrix approximation.

### Full and Compact SVD Formulation
For any real matrix $A \in \mathbb{R}^{m \times n}$ of rank $r$:
$$
A = U \Sigma V^T = \sum_{i=1}^r \sigma_i u_i v_i^T
$$
- $U \in \mathbb{R}^{m \times m}$: Orthonormal eigenvectors of $A A^T$ (left singular vectors).
- $V \in \mathbb{R}^{n \times n}$: Orthonormal eigenvectors of $A^T A$ (right singular vectors).
- $\Sigma \in \mathbb{R}^{m \times n}$: Diagonal matrix of non-negative singular values $\sigma_1 \ge \sigma_2 \ge \dots \ge \sigma_r > 0$.

### Low-Rank Approximation
By Eckart-Young Theorem, the best rank-$k$ approximation ($k < r$) in Frobenius norm is obtained by truncating to the top $k$ singular values:
$$
A_k = \sum_{i=1}^k \sigma_i u_i v_i^T, \quad \|A - A_k\|_F = \sqrt{\sum_{i=k+1}^r \sigma_i^2}
$$
This forms the foundational backbone of data compression, latent semantic indexing, and image denoising.',
  NULL,
  50,
  false,
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0112-000000000007'::UUID,
  'd0000000-0000-0000-0000-000000000012'::UUID,
  'Multivariable Calculus: Gradients, Jacobians, Hessians, and Optimization',
  '### Learning Objectives
- Calculate directional derivatives and gradient vectors $\nabla f(x)$.
- Assemble the Jacobian matrix $J \in \mathbb{R}^{m \times n}$ for vector-valued functions and apply the multivariable Chain Rule.
- Compute the Hessian matrix $H \in \mathbb{R}^{n \times n}$ and classify critical points using eigenvalues of $H$.

### Gradient and Directional Derivative
For scalar field $f: \mathbb{R}^n \to \mathbb{R}$, the gradient is the vector of partial derivatives:
$$\nabla f(x) = \begin{bmatrix} \frac{\partial f}{\partial x_1} & \frac{\partial f}{\partial x_2} & \dots & \frac{\partial f}{\partial x_n} \end{bmatrix}^T$$
The directional derivative along unit vector $u$ is $D_u f(x) = \nabla f(x) \cdot u$. The gradient points in the direction of steepest ascent.

### Hessian Matrix and Second Derivative Test
The Hessian matrix contains all second-order partial derivatives:
$$H_{ij} = \frac{\partial^2 f}{\partial x_i \partial x_j}$$
At a critical point $x^*$ where $\nabla f(x^*) = \mathbf{0}$:
1. If $H(x^*)$ is **positive definite** (all $\lambda_i > 0$): strict local minimum.
2. If $H(x^*)$ is **negative definite** (all $\lambda_i < 0$): strict local maximum.
3. If $H(x^*)$ has both positive and negative eigenvalues: **saddle point**.',
  NULL,
  50,
  false,
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0113-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000013'::UUID,
  'Boolean Algebra, Logic Gates, and Karnaugh Map Minimization',
  '### Learning Objectives
- Apply Boolean algebraic identities and De Morgan''s laws: $\overline{A \cdot B} = \bar{A} + \bar{B}$ and $\overline{A + B} = \bar{A} \cdot \bar{B}$.
- Synthesize Sum-of-Products (SOP) and Product-of-Sums (POS) canonical expressions from truth tables.
- Minimize 3-variable and 4-variable boolean functions using Karnaugh Maps (K-Maps) and identify prime implicants.

### Universal Gates
NAND and NOR gates are **universal**: any boolean function can be realized using solely NAND gates or solely NOR gates.
For example, inverter via NAND: $\bar{A} = A \text{ NAND } A$. AND gate via NAND: $A \cdot B = (A \text{ NAND } B) \text{ NAND } (A \text{ NAND } B)$.

### 4-Variable K-Map Structure
Adjacency is preserved using Gray code ordering (only one bit changes per cell):

```
       CD
  AB   00   01   11   10
  00 [ m0 | m1 | m3 | m2 ]
  01 [ m4 | m5 | m7 | m6 ]
  11 [ m12| m13| m15| m14]
  10 [ m8 | m9 | m11| m10]
```

Grouping rules:
- Groups must contain $2^k$ cells (1, 2, 4, 8, or 16).
- Groups must be rectangular and wrap around edges/corners (toroidal topology).
- Don''t Care conditions ($d$) can be treated as 1 if they enlarge groups, or 0 otherwise.',
  NULL,
  45,
  true,
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0113-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000013'::UUID,
  'Combinational Logic: Adders, Decoders, Multiplexers, and Arithmetic Logic Units',
  '### Learning Objectives
- Design Half Adders and Full Adders, and contrast Ripple-Carry Adders with Carry-Lookahead Adders (CLA).
- Construct Decoders ($n$-to-$2^n$) and Multiplexers ($2^n$-to-1) as universal logic modules.
- Assemble a modular 32-bit Arithmetic Logic Unit (ALU) supporting ADD, SUB, AND, OR, SLT, and zero-detection.

### Ripple-Carry Adder vs Carry-Lookahead Adder (CLA)
In an $N$-bit Ripple-Carry Adder, carry bits ripple sequentially from LSB to MSB, resulting in $O(N)$ propagation delay.

Carry-Lookahead Adders compute carries in $O(\log N)$ time using generate ($G_i$) and propagate ($P_i$) terms:
$$G_i = A_i \cdot B_i, \quad P_i = A_i \oplus B_i$$
$$C_1 = G_0 + P_0 C_0$$
$$C_2 = G_1 + P_1 G_0 + P_1 P_0 C_0$$
$$C_3 = G_2 + P_2 G_1 + P_2 P_1 G_0 + P_2 P_1 P_0 C_0$$
$$C_4 = G_3 + P_3 G_2 + P_3 P_2 G_1 + P_3 P_2 P_1 G_0 + P_3 P_2 P_1 P_0 C_0$$

### Multiplexer Implementation
An 8-to-1 MUX selects one of 8 input lines $I_0 \dots I_7$ based on 3 select lines $S_2 S_1 S_0$:
$$Y = \sum_{k=0}^7 I_k \cdot m_k(S_2, S_1, S_0)$$',
  NULL,
  50,
  false,
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0113-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000013'::UUID,
  'Sequential Circuits: Latches, Flip-Flops, Registers, and Counters',
  '### Learning Objectives
- Compare level-sensitive SR / D latches with edge-triggered D flip-flops and JK flip-flops.
- Analyze timing constraints: setup time ($t_{setup}$), hold time ($t_{hold}$), and propagation delay ($t_{clk-q}$).
- Design synchronous sequential counters, shift registers, and ring counters.

### Edge-Triggered D Flip-Flop
```
          +-----------------+
    D --->| D             Q |---> Q
          |                 |
  CLK --->|>           Q_bar|---> Q_bar
          +-----------------+
```

### Timing Parameters & Maximum Clock Frequency
For reliable operation without metastability:
1. **Setup time ($t_{su}$):** Minimum duration data input $D$ must remain stable before the active clock edge.
2. **Hold time ($t_h$):** Minimum duration data input $D$ must remain stable after the active clock edge.
3. **Maximum Clock Frequency:**
   $$T_{clk} \ge t_{clk-q} + t_{comb} + t_{su}$$
   $$f_{max} = \frac{1}{T_{clk}} = \frac{1}{t_{clk-q} + t_{comb} + t_{su}}$$',
  NULL,
  45,
  false,
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0113-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000013'::UUID,
  'Finite State Machines (FSM): Moore vs Mealy Machine Synthesis',
  '### Learning Objectives
- Model sequential behavior using state transition diagrams and state tables.
- Distinguish Moore machines (outputs depend solely on current state) from Mealy machines (outputs depend on current state and current inputs).
- Execute state reduction using partition equivalence and implement excitation equations for D flip-flops.

### Moore vs Mealy Architecture
```
Moore: Next State Logic -> State Register -> Output Logic -> Output
                           (Flip-Flops)

Mealy: Inputs --------------------------------------------+
         |                                                v
       Next State Logic -> State Register -------------> Output Logic -> Output
```

### Comparison
| Feature | Moore Machine | Mealy Machine |
| :--- | :--- | :--- |
| Output Dependency | Current state only | Current state AND current input |
| Glitch Susceptibility | Resistant to input glitches (synchronized to clock) | Susceptible to asynchronous input glitches |
| State Count | Generally requires more states | Often requires fewer states for identical sequence detection |
| Timing Response | Output changes one clock cycle later | Output changes immediately when input transitions |',
  NULL,
  45,
  false,
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0113-000000000005'::UUID,
  'd0000000-0000-0000-0000-000000000013'::UUID,
  'Instruction Set Architecture (ISA): RISC-V 32-Bit Integer Core (RV32I)',
  '### Learning Objectives
- Master the RISC design philosophy vs CISC (fixed-length instructions, load-store architecture).
- Dissect the RISC-V 32-bit (RV32I) instruction formats: R-type, I-type, S-type, B-type, U-type, and J-type.
- Trace assembly instruction encoding, register conventions (x0=zero, ra, sp, a0-a7, t0-t6), and immediate sign-extension.

### RV32I Instruction Formats (32 bits)
```
R-type: [ funct7 (7) | rs2 (5) | rs1 (5) | funct3 (3) | rd (5) | opcode (7) ] -> add, sub, and
I-type: [      imm[11:0] (12)  | rs1 (5) | funct3 (3) | rd (5) | opcode (7) ] -> addi, lw, jalr
S-type: [ imm[11:5]  | rs2 (5) | rs1 (5) | funct3 (3) | imm[4:0]| opcode (7) ] -> sw, sb
B-type: [ imm[12|10:5]| rs2 (5)| rs1 (5) | funct3 (3) | imm[4:1|11]| op (7) ] -> beq, bne
U-type: [             imm[31:12] (20)                 | rd (5) | opcode (7) ] -> lui, auipc
J-type: [         imm[20|10:1|11|19:12] (20)          | rd (5) | opcode (7) ] -> jal
```

### Key Architecture Invariants
- Fixed 32-bit instruction length simplifies instruction fetch and alignment.
- Register $x0$ is hardwired to constant zero ($0$). Writes to $x0$ are discarded.
- Only dedicated load and store instructions access main memory.',
  NULL,
  50,
  false,
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0113-000000000006'::UUID,
  'd0000000-0000-0000-0000-000000000013'::UUID,
  'Pipelined Processor Architecture: 5 Stages, Hazards, and Forwarding',
  '### Learning Objectives
- Trace the classic 5-stage RISC processor pipeline: IF (Instruction Fetch), ID (Decode), EX (Execute), MEM (Memory), WB (Writeback).
- Classify and resolve Structural, Data (RAW, WAR, WAW), and Control hazards.
- Implement Data Forwarding (bypassing) and pipeline stalling (bubbles) for Load-Use hazards.

### The 5 Classic Pipeline Stages
```
Clock:     1     2     3     4     5     6     7
Inst 1:  [IF]  [ID]  [EX]  [MEM] [WB]
Inst 2:        [IF]  [ID]  [EX]  [MEM] [WB]
Inst 3:              [IF]  [ID]  [EX]  [MEM] [WB]
```

### Hazard Categories & Mitigations
1. **Structural Hazards:** Resource conflict (e.g. unified memory accessed simultaneously for instruction fetch and data read/write). Resolved via separate Harvard L1 I-Cache and D-Cache.
2. **Data Hazards (Read-After-Write - RAW):** An instruction depends on the result of a prior instruction still in the pipeline. Resolved via **Forwarding** from EX/MEM or MEM/WB pipeline registers directly to ALU inputs.
3. **Load-Use Data Hazard:** Forwarding cannot travel backward in time when a load is immediately followed by a dependent instruction. Requires inserting 1 cycle **Stall** (bubble).
4. **Control Hazards (Branching):** Branch decision computed in EX stage causes 2 stalled cycles. Resolved via Dynamic Branch Prediction (2-bit saturating counters, Branch Target Buffers).',
  NULL,
  50,
  false,
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0113-000000000007'::UUID,
  'd0000000-0000-0000-0000-000000000013'::UUID,
  'Memory Hierarchy: Direct-Mapped, Set-Associative Caches, and Virtual Memory',
  '### Learning Objectives
- Analyze temporal and spatial locality principles governing cache memory design.
- Map memory addresses into Tag, Index, and Block Offset fields for Direct-Mapped and Set-Associative caches.
- Evaluate cache write policies (Write-Through vs Write-Back, Write-Allocate vs No-Write-Allocate).
- Compute Average Memory Access Time (AMAT) and trace Virtual Memory page table address translation.

### Address Decomposition for Set-Associative Cache
Let address be 32 bits, cache capacity $C = 32\text{ KB}$, block size $B = 64\text{ bytes}$, and associativity $N = 4$-way:
- Number of blocks: $\frac{32 \times 1024}{64} = 512$ blocks.
- Number of sets: $S = \frac{512}{4} = 128$ sets.
- Block Offset bits: $\log_2(64) = 6$ bits.
- Index bits: $\log_2(128) = 7$ bits.
- Tag bits: $32 - 7 - 6 = 19$ bits.

```
Address: [ Tag: 19 bits | Set Index: 7 bits | Block Offset: 6 bits ]
```

### Average Memory Access Time (AMAT)
$$
\text{AMAT} = \text{Hit Time} + (\text{Miss Rate} \times \text{Miss Penalty})
$$
Multi-level caches reduce miss penalty:
$$\text{AMAT} = H_1 + M_1 \times (H_2 + M_2 \times \text{Memory Penalty})$$',
  NULL,
  45,
  false,
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0114-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000014'::UUID,
  'NumPy Foundations: N-Dimensional Arrays, Broadcasting, and Vectorization',
  '### Learning Objectives
- Construct and manipulate contiguous $N$-dimensional arrays (`ndarray`) with specific data types.
- Master NumPy broadcasting rules across varying tensor shapes.
- Eliminate explicit Python loops using vectorized universal functions (`ufunc`).

### NumPy Broadcasting Semantics
Two dimensions are compatible when:
1. They are equal, or
2. One of them is 1.

```python
import numpy as np

# A has shape (4, 1, 6)
# B has shape    (3, 1)
# Resulting broadcast shape: (4, 3, 6)
A = np.ones((4, 1, 6))
B = np.zeros((3, 1))
result = A + B
print(f"Broadcast shape: {result.shape}") # (4, 3, 6)
```

### Vectorized Performance Comparison
Computing Euclidean distance on $10^6$ vectors:
```python
# Python loop: ~850 ms
# NumPy vectorized: ~3.2 ms (>250x speedup via SIMD and contiguous C memory)
distances = np.linalg.norm(points_a - points_b, axis=1)
```

### Key Takeaways
- NumPy arrays store contiguous blocks of homogeneous memory, bypassing Python object pointer indirection.
- Always prefer `axis`-based reduction (`sum`, `mean`, `std`) over iterative accumulation.',
  NULL,
  40,
  true,
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0114-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000014'::UUID,
  'Pandas Data Wrangling: Series, DataFrames, Indexing, and Cleaning',
  '### Learning Objectives
- Differentiate between label-based indexing (`.loc`) and integer position-based indexing (`.iloc`).
- Clean noisy real-world data: handling null values (`dropna`, `fillna`, interpolation), duplicate removal, and type coercion.
- Apply boolean masking and multi-condition filtering on large datasets.

### Indexing Taxonomy
```python
import pandas as pd

df = pd.DataFrame({
    ''ticker'': [''AAPL'', ''MSFT'', ''GOOGL'', ''AMZN''],
    ''price'': [182.5, 415.0, 175.2, 178.9],
    ''volume'': [54000000, 22000000, 19000000, 31000000]
}, index=[''a'', ''b'', ''c'', ''d''])

# Label-based slice (includes end index)
tech_subset = df.loc[''a'':''c'', [''ticker'', ''price'']]

# Position-based slice (excludes end index)
first_two = df.iloc[0:2, 0:2]

# Boolean filtering
high_volume = df[df[''volume''] > 20000000]
```

### Handling Missing Data
1. Detection: `df.isna().sum()` gives missing value counts per column.
2. Imputation: Continuous features can be imputed using median or group-wise means to prevent data leakage.
3. Drop: `df.dropna(subset=[''critical_id''])` removes rows with unrecoverable identifiers.',
  NULL,
  45,
  false,
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0114-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000014'::UUID,
  'Aggregations and Relational Operations: GroupBy, Merge, and Pivot Tables',
  '### Learning Objectives
- Execute Split-Apply-Combine workflows using `groupby` with custom and multiple aggregations.
- Combine datasets using relational algebra operations (`merge` with inner, outer, left, right joins).
- Reshape tabular structures with `pivot_table`, `melt`, and `stack/unstack`.

### Split-Apply-Combine Workflow
```python
# Aggregating sales metrics by region and product category
summary = df.groupby([''region'', ''category'']).agg(
    total_revenue=(''sale_amount'', ''sum''),
    avg_order_value=(''sale_amount'', ''mean''),
    transaction_count=(''order_id'', ''count''),
    p95_revenue=(''sale_amount'', lambda x: np.percentile(x, 95))
).reset_index()
```

### Relational Joins in Pandas
```python
# Merging transactions with customer demographics
merged_df = pd.merge(
    orders,
    customers,
    on=''customer_id'',
    how=''left'',
    suffixes=(''_order'', ''_customer'')
)
```

### Reshaping Data
- `pivot_table`: Converts long data to wide format, applying aggregations across intersections.
- `melt`: Unpivots wide columns into key-value pair rows for tidy data modeling.',
  NULL,
  50,
  false,
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0114-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000014'::UUID,
  'Exploratory Data Analysis (EDA): Distributions, Outliers, and Correlation',
  '### Learning Objectives
- Compute summary statistics: mean, median, variance, skewness, and kurtosis.
- Identify outliers using Interquartile Range (IQR) bounds and Z-score thresholds.
- Measure bivariate dependencies using Pearson linear correlation vs Spearman monotonic rank correlation.

### Outlier Detection Mathematical Rules
1. **Interquartile Range (IQR):**
   $$IQR = Q_3 - Q_1$$
   $$\text{Mild Outliers:} \quad x < Q_1 - 1.5 \cdot IQR \quad \lor \quad x > Q_3 + 1.5 \cdot IQR$$
   $$\text{Extreme Outliers:} \quad x < Q_1 - 3.0 \cdot IQR \quad \lor \quad x > Q_3 + 3.0 \cdot IQR$$
2. **Z-Score Rule (for Gaussian distributions):**
   $$z = \frac{x - \mu}{\sigma}, \quad |z| > 3 \implies \text{Outlier candidate}$$

### Pearson vs Spearman Correlation
- **Pearson $r$:** Measures strict linear correlation $\frac{\text{Cov}(X, Y)}{\sigma_X \sigma_Y} \in [-1, +1]$. Highly sensitive to extreme outliers.
- **Spearman $\rho$:** Pearson correlation applied to variable ranks; captures any monotonic non-linear relationship.',
  NULL,
  45,
  false,
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0114-000000000005'::UUID,
  'd0000000-0000-0000-0000-000000000014'::UUID,
  'Statistical Visualization: Matplotlib and Seaborn Grammar of Graphics',
  '### Learning Objectives
- Apply the object-oriented Matplotlib interface (`fig, ax = plt.subplots()`) over stateful `pyplot`.
- Select chart types matching data types: KDE plots, Violin plots, Box plots, Pair plots, and Heatmaps.
- Design accessible, publication-grade figures with clear color palettes, annotations, and labels.

### Visual Taxonomy
| Data Types | Recommended Chart Type | Matplotlib / Seaborn Method |
| :--- | :--- | :--- |
| Single Continuous Variable | Histogram with KDE overlay | `sns.histplot(x, kde=True)` |
| Continuous vs Categorical | Box plot / Split Violin plot | `sns.violinplot(x=''cat'', y=''val'', data=df)` |
| Two Continuous Variables | Scatter plot with marginal dists | `sns.jointplot(x=''v1'', y=''v2'', kind=''reg'')` |
| Correlation Matrix | Heatmap with diverging palette | `sns.heatmap(corr, annot=True, cmap=''vlag'')` |
| High-Dimensional Overview | Pairplot with hue grouping | `sns.pairplot(df, hue=''target'')` |

### Publication-Grade Figure Generation
```python
import matplotlib.pyplot as plt
import seaborn as sns

fig, ax = plt.subplots(figsize=(8, 5), dpi=150)
sns.boxplot(data=df, x=''category'', y=''revenue'', palette=''Blues_r'', ax=ax)
ax.set_title(''Revenue Distribution by Category'', fontsize=14, fontweight=''bold'', pad=12)
ax.set_xlabel(''Product Category'', fontsize=11)
ax.set_ylabel(''Revenue ($)'', fontsize=11)
ax.spines[''top''].set_visible(False)
ax.spines[''right''].set_visible(False)
plt.tight_layout()
```',
  NULL,
  45,
  false,
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0114-000000000006'::UUID,
  'd0000000-0000-0000-0000-000000000014'::UUID,
  'Hypothesis Testing and A/B Experimentation Methodology',
  '### Learning Objectives
- Formulate Null ($H_0$) and Alternative ($H_1$) hypotheses and select appropriate statistical tests.
- Interpret p-values, Type I errors (False Positive $\alpha$), and Type II errors (False Negative $\beta$).
- Execute Student''s Two-Sample t-test, Welch''s t-test (unequal variance), and Chi-Square test of independence.
- Calculate Sample Size requirements via statistical power analysis.

### Statistical Test Selection Tree
```
Continuous Dependent Variable:
├── Comparing 2 Independent Groups:
│   ├── Normal distribution & equal variance: Student''s t-test
│   ├── Normal distribution & unequal variance: Welch''s t-test
│   └── Non-normal distribution: Mann-Whitney U test
└── Comparing >2 Groups: One-Way ANOVA (Post-hoc Tukey HSD)

Categorical Dependent Variable:
└── Contingency Tables (e.g. Conversion A vs B): Pearson Chi-Square test (or Fisher''s Exact test)
```

### A/B Testing Pitfalls to Avoid
1. **Peeking Problem:** Checking p-values continuously and stopping as soon as $p < 0.05$ severely inflates Type I error. Fix via sequential testing or fixed-sample execution.
2. **Novelty Effect:** Users initially engage with UI changes out of curiosity, followed by reversion to baseline.',
  NULL,
  50,
  false,
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0114-000000000007'::UUID,
  'd0000000-0000-0000-0000-000000000014'::UUID,
  'Time Series Analytics: Resampling, Moving Averages, and Seasonality',
  '### Learning Objectives
- Parse and set datetime indices in Pandas and handle irregular sampling intervals.
- Resample time series at varying frequencies (`D`, `W`, `M`, `Q`) using downsampling and upsampling.
- Compute rolling window statistics, exponential moving averages (EMA), and decompose seasonal components.

### Pandas Resampling and Rolling Calculations
```python
# Daily to weekly resampling with multiple metrics
weekly_metrics = df[''sales''].resample(''W-MON'').agg([''sum'', ''mean''])

# 7-day and 30-day simple moving average (SMA)
df[''sma_7''] = df[''sales''].rolling(window=7, min_periods=1).mean()
df[''sma_30''] = df[''sales''].rolling(window=30, min_periods=1).mean()

# Exponential Moving Average (EMA) with span=14
df[''ema_14''] = df[''sales''].ewm(span=14, adjust=False).mean()
```

### Seasonal Decomposition
Decompose time series $Y_t$ into:
$$Y_t = T_t + S_t + I_t \quad (\text{Additive}) \quad \lor \quad Y_t = T_t \times S_t \times I_t \quad (\text{Multiplicative})$$
- $T_t$: Long-term trend.
- $S_t$: Periodic seasonal cycle.
- $I_t$: Irregular residual noise.',
  NULL,
  45,
  false,
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0115-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000015'::UUID,
  'Structured Technical Writing: The Minto Pyramid and Clear Engineering Prose',
  '### Learning Objectives
- Structure documents using the Minto Pyramid Principle: Bottom-line upfront (BLUF).
- Eliminate vague attributions, passive voice ambiguities, and jargon-dense fluff.
- Draft concise technical executive summaries that communicate decisions and tradeoffs.

### The Minto Pyramid Structure
```
                     [ Core Recommendation / BLUF ]
                                   |
           +-----------------------+-----------------------+
           |                                               |
   [ Supporting Key Line 1 ]                       [ Supporting Key Line 2 ]
           |                                               |
     +-----+-----+                                   +-----+-----+
     |           |                                   |           |
  [ Data A ]  [ Data B ]                          [ Data C ]  [ Data D ]
```

### Writing Guidelines
1. **Bottom-Line Upfront (BLUF):** State the decision or finding in the very first sentence. Do not bury recommendations at the conclusion of a chronological narrative.
2. **Active Voice and Direct Ownership:**
   - *Weak:* "It was determined that latency degradation was experienced."
   - *Strong:* "The database connection pool saturated, increasing 99th percentile API latency from 45ms to 1,200ms."
3. **Specific Quantified Metrics:** Avoid words like "fast", "scalable", or "large". Use concrete numbers ($p99 < 50\text{ ms}$, throughput $> 15,000\text{ RPS}$).',
  NULL,
  40,
  true,
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0115-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000015'::UUID,
  'Software Design Documents (RFCs) and Architecture Decision Records (ADRs)',
  '### Learning Objectives
- Formulate Request for Comments (RFC) documents for complex software proposals.
- Document irreversible technical choices using Architecture Decision Records (ADRs).
- Evaluate alternatives using weighted decision matrices and trade-off analyses.

### Standard Architecture Decision Record (ADR) Schema
```markdown
# ADR-007: Migration from Polling to Webhook Event Notifications

## Status
Accepted (2026-10-15)

## Context
Third-party clients poll our REST API every 15 seconds to detect payment status changes.
This accounts for 68% of incoming traffic and stresses PostgreSQL read replicas.
Client developers report up to 15 seconds latency for critical order fulfillment.

## Decision
We will implement an event-driven webhook notification system powered by Amazon SNS and SQS.
Clients register HTTPS callback URLs with HMAC-SHA256 signature verification.

## Consequences
### Positive
- API server load decreases by an estimated 60%.
- Event delivery latency reduces from 15s to < 800ms.
### Negative / Tradeoffs
- Requires developing a robust retry engine with exponential backoff and dead-letter queues.
- Security surface expands, requiring strict outbound egress IP filtering.
```',
  NULL,
  45,
  false,
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0115-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000015'::UUID,
  'Incident Management and Blameless Postmortems',
  '### Learning Objectives
- Lead incident response using clear Incident Commander (IC) operational protocols.
- Author blameless postmortems focusing on systemic defense-in-depth rather than individual error.
- Establish precise incident timelines and derive actionable, prioritized corrective items.

### The Blameless Postmortem Culture
Human error is a **symptom** of a broken or fragile system, never the root cause. If a single human keystroke can take down production, the design lacked safeguards, automated validations, and fault isolation.

### Postmortem Anatomy
1. **Summary:** Severity level (e.g. SEV-1), user impact percentage, total downtime duration.
2. **Timeline:** Exact UTC timestamps from trigger event, first alert firing, triage, mitigation, to full recovery.
3. **Root Cause Analysis:** Technical mechanism of failure.
4. **Detection & Response:** How long before alerts fired? Did runbooks accurately describe the remediation?
5. **Action Items:** Preventive and corrective tasks assigned with owners and strict SLA deadlines.',
  NULL,
  45,
  false,
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0115-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000015'::UUID,
  'Root Cause Analysis Frameworks: 5 Whys, Ishikawa, and Fault Trees',
  '### Learning Objectives
- Execute the 5 Whys iterative interrogation technique to drill down to fundamental systemic vulnerabilities.
- Construct Ishikawa (Fishbone / Cause-and-Effect) diagrams categorizing contributing vectors.
- Build quantitative Fault Tree Analysis (FTA) models using boolean logic gates.

### The 5 Whys in Software Engineering
```
Problem: Production payment checkout returned HTTP 500 errors for 22 minutes.
1. Why? The payment service ran out of memory and was killed by Linux OOM killer.
2. Why? A memory leak occurred during transaction receipt generation.
3. Why? A newly deployed library held unclosed file descriptors in memory.
4. Why? The deployment lacked integration regression tests for resource leaks.
5. Why? The CI/CD pipeline does not run automated load and leak tests before staging rollout.
Action: Add automated 10-minute soaking memory leak tests into the staging deployment gate.
```

### Ishikawa (Fishbone) Diagram Dimensions
- **People:** Training, shifts, alert fatigue, handover communication.
- **Process:** Code review standards, rollback procedures, change management.
- **Tools / Technology:** Monitoring coverage, CI/CD validation gates, staging fidelity.
- **Environment:** Cloud infrastructure limits, network latency, external vendor dependencies.',
  NULL,
  45,
  false,
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0115-000000000005'::UUID,
  'd0000000-0000-0000-0000-000000000015'::UUID,
  'API Documentation and Technical Specifications: OpenAPI and Developer Portals',
  '### Learning Objectives
- Author comprehensive API contracts using the OpenAPI 3.1 specification.
- Document error schemas, rate limits, pagination conventions, and idempotency keys.
- Write actionable quickstarts, interactive code examples, and troubleshooting guides.

### Best Practices for API Documentation
1. **Show Complete Payloads:** Always provide realistic JSON request and response payloads, not just abstract type names.
2. **Explicit Error Catalogs:** Document every HTTP status code (400, 401, 403, 404, 409, 422, 429, 500) with specific error codes and remediation advice.
3. **Authentication & Security:** Clearly detail token formats (e.g. `Bearer <jwt>`), scoping requirements, and header signatures.
4. **Idempotency Standards:** Explain how clients can safely retry network timeouts by attaching `Idempotency-Key` headers.',
  NULL,
  40,
  false,
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

INSERT INTO public.lessons (
  id,
  course_id,
  title,
  content,
  video_url,
  duration_minutes,
  is_free_preview,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0115-000000000006'::UUID,
  'd0000000-0000-0000-0000-000000000015'::UUID,
  'Cognitive Biases in Engineering Decision Making and Trade-off Frameworks',
  '### Learning Objectives
- Recognize cognitive biases in software projects: Sunk Cost Fallacy, Confirmation Bias, bikeshedding (Law of Triviality), and Not-Invented-Here (NIH) syndrome.
- Evaluate build vs buy tradeoffs using Total Cost of Ownership (TCO) models.
- Apply weighted scoring matrices to make objective architectural selections.

### Cognitive Traps in Technology
1. **Sunk Cost Fallacy:** Continuing to invest engineering hours into a failing legacy framework simply because two years were already spent building it.
2. **Law of Triviality (Parkinson''s Bikeshedding):** Teams spend 5 minutes debating a complex database migration strategy, but spend 45 minutes arguing over code formatting or button color.
3. **Not-Invented-Here (NIH):** Rejecting robust, battle-tested open-source libraries to build internal custom solutions with hidden maintenance burdens.

### Weighted Decision Matrix Template
| Evaluation Criteria | Weight (%) | Solution A (Custom Build) | Solution B (Managed SaaS) | Solution C (OSS Library) |
| :--- | :--- | :--- | :--- | :--- |
| Time to Market | 30% | 4/10 (1.2) | 9/10 (2.7) | 8/10 (2.4) |
| Maintenance Overhead | 25% | 3/10 (0.75) | 9/10 (2.25) | 6/10 (1.5) |
| Direct Financial Cost | 20% | 8/10 (1.6) | 4/10 (0.8) | 9/10 (1.8) |
| Flexibility / Extensibility | 25% | 9/10 (2.25) | 6/10 (1.5) | 8/10 (2.0) |
| **Weighted Total** | **100%** | **5.80** | **7.25** | **7.70** |',
  NULL,
  45,
  false,
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  video_url = EXCLUDED.video_url,
  duration_minutes = EXCLUDED.duration_minutes,
  is_free_preview = EXCLUDED.is_free_preview,
  order_index = EXCLUDED.order_index;

-- ============================================================================
-- 3. INSERT / UPSERT QUIZZES (60 Comprehensive Quizzes)
-- ============================================================================

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0201-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000001'::UUID,
  'Python Syntax, Types & Dynamic Binding Quiz',
  'Assessment covering CPython runtime mechanics, object identity, reference binding, and primitive data types.',
  15,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0201-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000001'::UUID,
  'Functions, Scoping & Comprehensions Quiz',
  'Covers LEGB scoping rules, parameter unpacking, mutable defaults, and list/dictionary comprehensions.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0201-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000001'::UUID,
  'Object-Oriented Python & Special Methods Quiz',
  'Tests class definitions, property decorators, method resolution order (MRO), and magic dunder methods.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0201-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000001'::UUID,
  'Error Handling, File Operations & Modules Quiz',
  'Examines exception propagation, custom exceptions, context managers, and pathlib/json file handling.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0202-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000002'::UUID,
  'JVM Mechanics, Data Types & Control Flow Quiz',
  'Covers JVM memory architecture, stack vs heap, primitive data types, and method invocation.',
  15,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0202-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000002'::UUID,
  'Inheritance, Interfaces & Polymorphism Quiz',
  'Tests dynamic dispatch, interface contracts, default methods, and constructor hierarchies.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0202-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000002'::UUID,
  'Exception Architecture & Resource Management Quiz',
  'Examines checked vs unchecked exceptions, try-with-resources, and exception propagation.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0202-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000002'::UUID,
  'Collections Framework & Generics Quiz',
  'Evaluates knowledge of ArrayList vs LinkedList, HashMap internals, equals/hashCode contract, and generics.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0203-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000003'::UUID,
  'Asymptotic Complexity & Linear Structures Quiz',
  'Covers Big-O analysis, recurrence relations, array amortized bounds, and linked list pointers.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0203-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000003'::UUID,
  'Trees, Binary Heaps & Priority Queues Quiz',
  'Tests BST invariant properties, tree traversal orders, AVL balance factors, and heapification complexity.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0203-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000003'::UUID,
  'Graph Algorithms & Shortest Path Traversal Quiz',
  'Examines BFS, DFS, Topological Sorting, Dijkstra, and Bellman-Ford algorithms.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0203-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000003'::UUID,
  'Dynamic Programming & Advanced Algorithmic Paradigms Quiz',
  'Tests memoization vs tabulation, knapsack problems, LCS recurrence, and greedy choice properties.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0204-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000004'::UUID,
  'HTTP Protocol, Semantic HTML & CSS Architecture Quiz',
  'Covers HTTP versioning, request lifecycle, semantic HTML5 tags, and CSS Grid/Flexbox mechanics.',
  15,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0204-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000004'::UUID,
  'Modern JavaScript, Event Loop & Asynchronous Flow Quiz',
  'Tests understanding of microtasks vs macrotasks, closures, Promises, and async/await mechanics.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0204-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000004'::UUID,
  'React Component Lifecycle, Hooks & Reconciliation Quiz',
  'Examines JSX, useState, useEffect dependencies, virtual DOM reconciliation, and context.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0204-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000004'::UUID,
  'REST APIs, Authentication & Web Security Standards Quiz',
  'Examines REST resource conventions, JWT mechanics, HttpOnly cookie security, CORS, and XSS defense.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0205-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000005'::UUID,
  'Relational Modeling & Schema Normalization Quiz',
  'Covers relational algebra, functional dependencies, 1NF, 2NF, 3NF, and BCNF conditions.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0205-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000005'::UUID,
  'Complex SQL Queries, Joins & Window Functions Quiz',
  'Evaluates expertise in SQL joins, aggregation filtering, grouping sets, and windowing clauses.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0205-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000005'::UUID,
  'Database Indexing, Query Optimization & Execution Plans Quiz',
  'Covers B+ Tree index structures, hash indexes, EXPLAIN ANALYZE interpretation, and cost models.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0205-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000005'::UUID,
  'ACID Transactions & Concurrency Control Mechanisms Quiz',
  'Examines transaction isolation levels, write-ahead logging (WAL), 2PL, and multi-version concurrency control (MVCC).',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0206-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000006'::UUID,
  'OS Architecture, System Calls & Process Lifecycle Quiz',
  'Covers user/kernel mode, trap instructions, process states, and PCB context switching.',
  15,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0206-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000006'::UUID,
  'CPU Scheduling Algorithms & Preemption Metrics Quiz',
  'Tests calculation of turnaround/waiting times across FCFS, SJF, Priority, and Round Robin scheduling.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0206-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000006'::UUID,
  'Synchronization, Race Conditions & Deadlock Avoidance Quiz',
  'Covers semaphores, critical section criteria, Coffman conditions, and Banker''s algorithm.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0206-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000006'::UUID,
  'Virtual Memory, Paging & Page Replacement Algorithms Quiz',
  'Examines page tables, TLB hits, Bélády''s anomaly, LRU, and working set thrashing.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0207-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000007'::UUID,
  'OSI & TCP/IP Architecture & Layer Responsibilities Quiz',
  'Tests knowledge of layer functions, protocol data units (PDUs), encapsulation, and port/IP/MAC addressing.',
  15,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0207-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000007'::UUID,
  'Application Protocols (DNS, HTTP) & Socket Programming Quiz',
  'Examines recursive DNS lookup chains, DNS record types, HTTP caching headers, and socket calls.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0207-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000007'::UUID,
  'TCP Reliability, Flow Control & Congestion Algorithms Quiz',
  'Examines 3-way handshakes, sequence tracking, sliding window flow control, and AIMD congestion control.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0207-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000007'::UUID,
  'IP Addressing, Subnetting, CIDR & Routing Protocols Quiz',
  'Tests subnet mask calculations, CIDR prefixes, host capacity, OSPF link-state, and BGP concepts.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0208-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000008'::UUID,
  'Software Development Lifecycles & Agile Methodologies Quiz',
  'Covers Waterfall, Spiral risk cycles, Agile principles, Scrum roles, and sprint rituals.',
  15,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0208-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000008'::UUID,
  'Requirements Engineering & Architectural Patterns Quiz',
  'Examines functional vs non-functional requirements, IEEE 830 standards, and monolith vs microservices trade-offs.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0208-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000008'::UUID,
  'SOLID Design Principles & Refactoring Patterns Quiz',
  'Evaluates practical application of SRP, OCP, LSP, ISP, and DIP in object-oriented software engineering.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0208-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000008'::UUID,
  'Verification, Validation & Test Automation Frameworks Quiz',
  'Tests black-box boundary analysis, test doubles, TDD cycles, statement/branch coverage, and CI/CD pipelines.',
  20,
  70,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0209-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000009'::UUID,
  'Quiz 1: Intelligent Agents and Uninformed Search',
  'Quiz 1: Intelligent Agents and Uninformed Search assessment for Artificial Intelligence Fundamentals.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0209-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000009'::UUID,
  'Quiz 2: Informed Search and A* Algorithm',
  'Quiz 2: Informed Search and A* Algorithm assessment for Artificial Intelligence Fundamentals.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0209-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000009'::UUID,
  'Quiz 3: Game Playing and Adversarial Search',
  'Quiz 3: Game Playing and Adversarial Search assessment for Artificial Intelligence Fundamentals.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0209-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000009'::UUID,
  'Quiz 4: CSPs, Logic, and Bayesian Networks',
  'Quiz 4: CSPs, Logic, and Bayesian Networks assessment for Artificial Intelligence Fundamentals.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0210-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000010'::UUID,
  'Quiz 1: Supervised Learning, Loss Functions, and Optimization',
  'Quiz 1: Supervised Learning, Loss Functions, and Optimization assessment for Machine Learning Foundations.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0210-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000010'::UUID,
  'Quiz 2: Bias-Variance Tradeoff and Regularization',
  'Quiz 2: Bias-Variance Tradeoff and Regularization assessment for Machine Learning Foundations.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0210-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000010'::UUID,
  'Quiz 3: Decision Trees, Ensembles, and SVMs',
  'Quiz 3: Decision Trees, Ensembles, and SVMs assessment for Machine Learning Foundations.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0210-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000010'::UUID,
  'Quiz 4: Unsupervised Learning, Clustering, and PCA',
  'Quiz 4: Unsupervised Learning, Clustering, and PCA assessment for Machine Learning Foundations.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0211-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000011'::UUID,
  'Quiz 1: Attention Mechanisms and the Transformer Architecture',
  'Quiz 1: Attention Mechanisms and the Transformer Architecture assessment for Generative AI and Large Language Models.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0211-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000011'::UUID,
  'Quiz 2: Pretraining, Tokenization, and Scaling Laws',
  'Quiz 2: Pretraining, Tokenization, and Scaling Laws assessment for Generative AI and Large Language Models.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0211-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000011'::UUID,
  'Quiz 3: Alignment, Instruction Tuning, and PEFT',
  'Quiz 3: Alignment, Instruction Tuning, and PEFT assessment for Generative AI and Large Language Models.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0211-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000011'::UUID,
  'Quiz 4: RAG, Decoding, and Evaluation',
  'Quiz 4: RAG, Decoding, and Evaluation assessment for Generative AI and Large Language Models.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0212-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000012'::UUID,
  'Quiz 1: Vector Spaces, Independence, and Elimination',
  'Quiz 1: Vector Spaces, Independence, and Elimination assessment for Engineering Mathematics and Linear Algebra.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0212-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000012'::UUID,
  'Quiz 2: Fundamental Subspaces and the Rank-Nullity Theorem',
  'Quiz 2: Fundamental Subspaces and the Rank-Nullity Theorem assessment for Engineering Mathematics and Linear Algebra.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0212-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000012'::UUID,
  'Quiz 3: Eigenvalues, Diagonalization, and QR Factorization',
  'Quiz 3: Eigenvalues, Diagonalization, and QR Factorization assessment for Engineering Mathematics and Linear Algebra.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0212-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000012'::UUID,
  'Quiz 4: SVD, Multivariable Optimization, and Calculus',
  'Quiz 4: SVD, Multivariable Optimization, and Calculus assessment for Engineering Mathematics and Linear Algebra.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0213-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000013'::UUID,
  'Quiz 1: Boolean Algebra, Gates, and K-Maps',
  'Quiz 1: Boolean Algebra, Gates, and K-Maps assessment for Digital Logic and Computer Organization.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0213-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000013'::UUID,
  'Quiz 2: Combinational Logic and Arithmetic Circuits',
  'Quiz 2: Combinational Logic and Arithmetic Circuits assessment for Digital Logic and Computer Organization.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0213-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000013'::UUID,
  'Quiz 3: Sequential Logic and Finite State Machines',
  'Quiz 3: Sequential Logic and Finite State Machines assessment for Digital Logic and Computer Organization.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0213-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000013'::UUID,
  'Quiz 4: Computer Architecture, RISC-V, Pipelining, and Caches',
  'Quiz 4: Computer Architecture, RISC-V, Pipelining, and Caches assessment for Digital Logic and Computer Organization.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0214-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000014'::UUID,
  'Quiz 1: NumPy Arrays, Vectorization, and Broadcasting',
  'Quiz 1: NumPy Arrays, Vectorization, and Broadcasting assessment for Data Analytics with Python.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0214-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000014'::UUID,
  'Quiz 2: Pandas Data Wrangling, Merging, and Grouping',
  'Quiz 2: Pandas Data Wrangling, Merging, and Grouping assessment for Data Analytics with Python.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0214-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000014'::UUID,
  'Quiz 3: Exploratory Data Analysis and Statistical Visualization',
  'Quiz 3: Exploratory Data Analysis and Statistical Visualization assessment for Data Analytics with Python.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0214-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000014'::UUID,
  'Quiz 4: Hypothesis Testing and Experimentation',
  'Quiz 4: Hypothesis Testing and Experimentation assessment for Data Analytics with Python.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0215-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000015'::UUID,
  'Quiz 1: Structured Writing and Communication Principles',
  'Quiz 1: Structured Writing and Communication Principles assessment for Technical Communication and Problem Solving.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0215-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000015'::UUID,
  'Quiz 2: Technical Specifications, RFCs, and ADRs',
  'Quiz 2: Technical Specifications, RFCs, and ADRs assessment for Technical Communication and Problem Solving.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0215-000000000003'::UUID,
  'd0000000-0000-0000-0000-000000000015'::UUID,
  'Quiz 3: Incident Management and Blameless Postmortems',
  'Quiz 3: Incident Management and Blameless Postmortems assessment for Technical Communication and Problem Solving.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.quizzes (
  id,
  course_id,
  title,
  description,
  time_limit_minutes,
  passing_score,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0215-000000000004'::UUID,
  'd0000000-0000-0000-0000-000000000015'::UUID,
  'Quiz 4: Root Cause Analysis and Engineering Tradeoffs',
  'Quiz 4: Root Cause Analysis and Engineering Tradeoffs assessment for Technical Communication and Problem Solving.',
  30,
  75,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  time_limit_minutes = EXCLUDED.time_limit_minutes,
  passing_score = EXCLUDED.passing_score,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

-- ============================================================================
-- 4. INSERT / UPSERT QUIZ QUESTIONS (416 MCQ Questions with Explanations)
-- ============================================================================

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000001'::UUID,
  'd0000000-0000-0000-0201-000000000001'::UUID,
  'In Python, what is the output of checking identity between two small integer assignments: a = 256; b = 256; print(a is b)?',
  '["False, because distinct assignments always allocate distinct heap objects.","True, because CPython pre-allocates and caches an array of small integer objects in the range -5 to 256.","SyntaxError, because \"is\" can only compare boolean flags.","TypeError, because identity comparison requires explicit casting."]'::jsonb,
  1,
  10,
  'CPython optimizes memory by interning small integers between -5 and 256 inclusive, so both variables reference the exact same cached object in memory.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000002'::UUID,
  'd0000000-0000-0000-0201-000000000001'::UUID,
  'What happens when you attempt to modify a character in a Python string: s = "hello"; s[0] = "H"?',
  '["The string is modified in-place to \"Hello\".","A TypeError is raised because strings are immutable sequences in Python.","A copy of the string is implicitly generated and assigned back.","A warning is printed, but the character is updated."]'::jsonb,
  1,
  10,
  'Strings in Python are immutable; attempting item assignment on a string raises a TypeError: ''str'' object does not support item assignment.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000003'::UUID,
  'd0000000-0000-0000-0201-000000000001'::UUID,
  'Which operator produces integer division without a fractional component in Python 3?',
  '["/","//","%","div()"]'::jsonb,
  1,
  10,
  'The // operator performs floor division, rounding down to the nearest integer.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000004'::UUID,
  'd0000000-0000-0000-0201-000000000001'::UUID,
  'What is the boolean evaluation of the expression bool([]) and bool("False")?',
  '["False and True","True and True","False and False","True and False"]'::jsonb,
  0,
  10,
  'An empty list [] is falsy (evaluates to False), while any non-empty string, including "False", is truthy (evaluates to True).',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000005'::UUID,
  'd0000000-0000-0000-0201-000000000001'::UUID,
  'How does Python represent arbitrary-precision integers in memory?',
  '["Fixed 32-bit words that wrap around on overflow.","Dynamic variable-length arrays of 30-bit digits managed by CPython, expanding as needed.","Automatic conversion to IEEE 754 double precision floats when exceeding 64 bits.","Hardware registers allocated directly from kernel pages."]'::jsonb,
  1,
  10,
  'In Python 3, integers have arbitrary precision and are represented as variable-length structs with arrays of digits, avoiding numerical overflow.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000006'::UUID,
  'd0000000-0000-0000-0201-000000000001'::UUID,
  'What function returns the unique internal integer address of an object in CPython?',
  '["addr()","id()","memory()","ptr()"]'::jsonb,
  1,
  10,
  'The id() built-in function returns an integer guaranteed to be unique and constant for this object during its lifetime (in CPython, its memory address).',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000007'::UUID,
  'd0000000-0000-0000-0201-000000000001'::UUID,
  'Which statement accurately describes reference counting in Python garbage collection?',
  '["An object is deallocated immediately when its reference count drops to zero, supplemented by a cyclic detector for circular references.","Garbage collection only executes when system memory reaches 100% capacity.","Python does not use reference counting and relies exclusively on mark-and-sweep.","Variables are deallocated only when the process exits."]'::jsonb,
  0,
  10,
  'CPython relies primarily on immediate reference counting, supported by a generational cyclic garbage collector to detect and break reference cycles.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000008'::UUID,
  'd0000000-0000-0000-0201-000000000002'::UUID,
  'Why is defining "def add_item(val, container=[])" considered dangerous in Python?',
  '["Python raises a SyntaxError upon encountering mutable default arguments.","The default list object is created once when the function is defined, sharing the same list across subsequent calls.","The list is re-initialized to empty on each call, losing previous additions.","Mutable defaults prevent the function from accepting keyword arguments."]'::jsonb,
  1,
  10,
  'Default parameter values are evaluated once at definition time, meaning a mutable default object will accumulate state across multiple calls.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000009'::UUID,
  'd0000000-0000-0000-0201-000000000002'::UUID,
  'What keyword allows an inner nested function to rebind a variable located in an enclosing outer function?',
  '["global","nonlocal","outer","super"]'::jsonb,
  1,
  10,
  'The nonlocal keyword causes the variable to refer to the nearest enclosing scope (excluding global).',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000010'::UUID,
  'd0000000-0000-0000-0201-000000000002'::UUID,
  'What does the *args syntax represent in a function definition?',
  '["A dictionary of arbitrary keyword arguments.","A tuple capturing arbitrary positional arguments.","A pointer to heap memory.","An assertion that at least one argument must be provided."]'::jsonb,
  1,
  10,
  '*args bundles any extra positional arguments passed to the function into a tuple.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000011'::UUID,
  'd0000000-0000-0000-0201-000000000002'::UUID,
  'What is the output of [x**2 for x in range(5) if x % 2 == 1]?',
  '["[1, 9]","[0, 4, 16]","[1, 4, 9, 16]","[1, 9, 25]"]'::jsonb,
  0,
  10,
  'range(5) produces 0, 1, 2, 3, 4. The odd numbers are 1 and 3. Their squares are 1 and 9.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000012'::UUID,
  'd0000000-0000-0000-0201-000000000002'::UUID,
  'In the LEGB rule, what is the search order Python follows to resolve variable names?',
  '["Local -> Enclosing -> Global -> Built-in","Local -> Global -> Enclosing -> Built-in","Built-in -> Global -> Enclosing -> Local","Global -> Local -> Enclosing -> Built-in"]'::jsonb,
  0,
  10,
  'Python resolves identifiers by checking Local first, then Enclosing (outer functions), then Global (module level), and finally Built-in.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000013'::UUID,
  'd0000000-0000-0000-0201-000000000002'::UUID,
  'What type of object does the built-in map() function return in Python 3?',
  '["A list of transformed elements.","A lazy map iterator that yields values on demand.","A dictionary indexed by sequential integers.","A tuple containing the mapped outputs."]'::jsonb,
  1,
  10,
  'In Python 3, map() returns a lazy iterator, conserving memory by generating mapped values as requested.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000014'::UUID,
  'd0000000-0000-0000-0201-000000000002'::UUID,
  'What is the syntax for a dictionary comprehension that squares each number from 1 to 3 with its number as key?',
  '["{x: x**2 for x in range(1, 4)}","[x: x**2 for x in range(1, 4)]","dict(x -> x**2 for x in range(1, 4))","{x, x**2 for x in range(1, 4)}"]'::jsonb,
  0,
  10,
  'Dictionary comprehensions use curly braces with key: value syntax: {x: x**2 for x in range(1, 4)}.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000015'::UUID,
  'd0000000-0000-0000-0201-000000000003'::UUID,
  'What is the primary distinction between __str__ and __repr__ in Python?',
  '["__str__ is intended to provide a readable string for end users, while __repr__ aims to provide an unambiguous representation often usable to recreate the object.","__repr__ only works in debug builds of Python.","__str__ is deprecated in Python 3.","__repr__ returns an integer hash of the object."]'::jsonb,
  0,
  10,
  '__str__ is for clean, human-readable output, while __repr__ provides an explicit, unambiguous representation useful for developers and debugging.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000016'::UUID,
  'd0000000-0000-0000-0201-000000000003'::UUID,
  'What algorithm does Python 3 use to compute Method Resolution Order (MRO) in multiple inheritance?',
  '["Depth-First Search (DFS)","C3 Linearization Algorithm","Breadth-First Search (BFS)","Dijkstra''s Shortest Path"]'::jsonb,
  1,
  10,
  'Python uses the C3 Linearization algorithm to guarantee monotonicity and respect local precedence order in multiple inheritance hierarchies.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000017'::UUID,
  'd0000000-0000-0000-0201-000000000003'::UUID,
  'What does prefixing an attribute with double underscores (e.g. self.__salary) accomplish?',
  '["It makes the variable read-only at the C level.","It triggers name mangling by prepending _ClassName to prevent accidental subclass collisions.","It encrypts the variable data in memory.","It exposes the variable as an operating system environment variable."]'::jsonb,
  1,
  10,
  'Double leading underscores invoke name mangling, where the attribute is internally renamed to _ClassName__attr to avoid namespace clashes in subclasses.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000018'::UUID,
  'd0000000-0000-0000-0201-000000000003'::UUID,
  'Which decorator transforms a method into a read-only getter attribute?',
  '["@property","@getter","@attribute","@staticmethod"]'::jsonb,
  0,
  10,
  'The @property decorator turns a method into a descriptor getter, allowing access using attribute dot notation.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000019'::UUID,
  'd0000000-0000-0000-0201-000000000003'::UUID,
  'What special method must a class implement to support the len() built-in function?',
  '["__length__()","__len__()","__size__()","__count__()"]'::jsonb,
  1,
  10,
  'Implementing __len__(self) returns a non-negative integer representing the container length.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000020'::UUID,
  'd0000000-0000-0000-0201-000000000003'::UUID,
  'What does the super() function accomplish when called inside a subclass method?',
  '["It restarts the Python interpreter.","It returns a proxy object delegating method calls to the next class in the Method Resolution Order.","It forces an object to become immutable.","It casts all parameters to strings."]'::jsonb,
  1,
  10,
  'super() dynamically resolves and invokes methods on parent classes according to the class MRO.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000021'::UUID,
  'd0000000-0000-0000-0201-000000000003'::UUID,
  'What is the purpose of __slots__ in a Python class definition?',
  '["To restrict dynamic attribute creation and save memory by replacing the default instance __dict__.","To allow infinite inheritance levels.","To define public API endpoints for HTTP servers.","To configure multithreading concurrency slots."]'::jsonb,
  0,
  10,
  '__slots__ defines a fixed set of attributes, eliminating the per-instance __dict__ and substantially reducing memory footprint.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000022'::UUID,
  'd0000000-0000-0000-0201-000000000004'::UUID,
  'When does the "else" block of a try-except statement execute?',
  '["When an exception was raised and successfully handled.","Only when no exception was raised in the try block.","Every time the function terminates.","Only when the finally block fails."]'::jsonb,
  1,
  10,
  'The else clause runs only if the code in the try block completed without raising any exceptions.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000023'::UUID,
  'd0000000-0000-0000-0201-000000000004'::UUID,
  'Which two dunder methods define the context manager protocol used by the "with" statement?',
  '["__start__ and __stop__","__enter__ and __exit__","__open__ and __close__","__init__ and __del__"]'::jsonb,
  1,
  10,
  'Context managers implement __enter__(self) to acquire resources and __exit__(self, exc_type, exc_val, exc_tb) to ensure cleanup.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000024'::UUID,
  'd0000000-0000-0000-0201-000000000004'::UUID,
  'Why should custom exceptions inherit from Exception rather than BaseException?',
  '["BaseException cannot be inherited in user code.","Catching Exception preserves system-exiting signals like KeyboardInterrupt and SystemExit which inherit directly from BaseException.","BaseException requires writing custom C bindings.","Exception has faster lookup speed than BaseException."]'::jsonb,
  1,
  10,
  'KeyboardInterrupt and SystemExit inherit directly from BaseException, so inheriting from Exception prevents user exceptions from intercepting deliberate termination signals.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000025'::UUID,
  'd0000000-0000-0000-0201-000000000004'::UUID,
  'What is the difference between json.dump() and json.dumps() in the standard library?',
  '["json.dump() serializes data to a file-like stream, whereas json.dumps() returns a Python string.","json.dump() encrypts the output, while json.dumps() does not.","json.dumps() can only serialize integers and lists.","json.dump() is asynchronous while json.dumps() is synchronous."]'::jsonb,
  0,
  10,
  'json.dump(obj, fp) writes to a file stream; json.dumps(obj) outputs a JSON formatted str.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000026'::UUID,
  'd0000000-0000-0000-0201-000000000004'::UUID,
  'What mode flag in open() opens a file for appending text with write operations positioned at the end of the file?',
  '["\"r+\"","\"w\"","\"a\"","\"x\""]'::jsonb,
  2,
  10,
  '"a" opens a file for writing, appending to the end of the file if it exists, without truncating it.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000027'::UUID,
  'd0000000-0000-0000-0201-000000000004'::UUID,
  'Which standard library module provides object-oriented filesystem paths for cross-platform operations?',
  '["os.file","pathlib","sys.path","filepath"]'::jsonb,
  1,
  10,
  'The pathlib module offers classes representing filesystem paths with semantics appropriate for different operating systems.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0301-000000000028'::UUID,
  'd0000000-0000-0000-0201-000000000004'::UUID,
  'What is the role of the special variable __name__ when a Python file is run directly from the command line?',
  '["It evaluates to \"__main__\".","It evaluates to the file name as a string.","It evaluates to None.","It evaluates to the parent directory name."]'::jsonb,
  0,
  10,
  'When a module is run as the top-level script, its __name__ attribute is assigned the string "__main__".',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000001'::UUID,
  'd0000000-0000-0000-0202-000000000001'::UUID,
  'Where are local primitive variables stored during method execution in Java?',
  '["In the heap memory alongside instance fields.","In the thread-specific stack frame for that method.","In the permanent metaspace.","In the operating system kernel cache."]'::jsonb,
  1,
  10,
  'Method execution frames and their local primitive variables reside on the thread''s call stack, deallocating immediately upon method return.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000002'::UUID,
  'd0000000-0000-0000-0202-000000000001'::UUID,
  'What happens when an object reference is passed as an argument to a Java method?',
  '["The object itself is deep-copied onto the stack.","A copy of the reference pointer is passed by value.","The parameter is passed by reference, allowing rebinding of the caller''s original pointer.","The JVM converts the reference to an immutable integer."]'::jsonb,
  1,
  10,
  'Java is strictly pass-by-value. For objects, the value passed is a copy of the reference pointer.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000003'::UUID,
  'd0000000-0000-0000-0202-000000000001'::UUID,
  'What is the size and default value of a boolean primitive field in a Java class?',
  '["1 bit, default true","JVM implementation dependent, default false","8 bytes, default null","4 bytes, default undefined"]'::jsonb,
  1,
  10,
  'In Java class instances, boolean fields default to false; the JVM typically represents them using byte or word formats.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000004'::UUID,
  'd0000000-0000-0000-0202-000000000001'::UUID,
  'Which JVM component compiles hot bytecode segments into native machine instructions at runtime?',
  '["The ClassLoader","The JIT (Just-In-Time) Compiler","The Metaspace Resolver","The Bytecode Verifier"]'::jsonb,
  1,
  10,
  'The JIT compiler profiles running bytecode and dynamically compiles frequently executed loops and methods directly into native machine instructions.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000005'::UUID,
  'd0000000-0000-0000-0202-000000000001'::UUID,
  'What is the result of comparing two String literals using ==: String s1 = "java"; String s2 = "java"; print(s1 == s2)?',
  '["False, because == always checks distinct memory addresses.","True, because string literals are interned into the JVM String Pool, sharing the same reference.","A compile-time error occurs.","Runtime NullPointerException."]'::jsonb,
  1,
  10,
  'String literals are stored in the JVM String Constant Pool; identical string literals point to the same pooled object reference.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000006'::UUID,
  'd0000000-0000-0000-0202-000000000001'::UUID,
  'Which keyword prevents a class from being subclassed in Java?',
  '["static","final","sealed","abstract"]'::jsonb,
  1,
  10,
  'Applying the final modifier to a class definition prevents any other class from extending it.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000007'::UUID,
  'd0000000-0000-0000-0202-000000000001'::UUID,
  'What is the return type of the hashCode() method defined in java.lang.Object?',
  '["long","int","String","byte[]"]'::jsonb,
  1,
  10,
  'public int hashCode() returns a 32-bit signed integer hash value representing the object.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000008'::UUID,
  'd0000000-0000-0000-0202-000000000002'::UUID,
  'What access modifier allows class members to be accessed by subclasses and classes within the same package, but not by unrelated classes in external packages?',
  '["public","private","protected","package-private (default)"]'::jsonb,
  2,
  10,
  'protected grants visibility to subclasses in any package and all classes within the same package.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000009'::UUID,
  'd0000000-0000-0000-0202-000000000002'::UUID,
  'Can an interface in Java 8 or higher contain method implementations?',
  '["No, interfaces can only contain abstract method signatures.","Yes, using the default or static keywords on method declarations.","Only if the interface is marked private.","Only when inheriting from java.lang.Thread."]'::jsonb,
  1,
  10,
  'Java 8 introduced default and static methods in interfaces, allowing interfaces to include concrete method bodies without breaking backward compatibility.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000010'::UUID,
  'd0000000-0000-0000-0202-000000000002'::UUID,
  'What happens if a subclass constructor does not explicitly call super() or this()?',
  '["The compiler automatically inserts a call to super() with no arguments as the first statement.","The program compiles, but parent fields remain unallocated in heap.","A compile-time error is generated requiring explicit super() calls.","The subclass constructor is skipped at runtime."]'::jsonb,
  0,
  10,
  'If no explicit constructor call is provided, the Java compiler automatically inserts super() to invoke the no-argument constructor of the superclass.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000011'::UUID,
  'd0000000-0000-0000-0202-000000000002'::UUID,
  'What is the term for resolving which overridden method to execute at runtime based on the actual object instance?',
  '["Static Binding","Dynamic Method Dispatch","Early Compilation","Interface Bridging"]'::jsonb,
  1,
  10,
  'Dynamic method dispatch is the mechanism by which a call to an overridden method is resolved at runtime rather than compile time.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000012'::UUID,
  'd0000000-0000-0000-0202-000000000002'::UUID,
  'Can an abstract class in Java be instantiated directly using the new keyword?',
  '["Yes, provided it has no abstract methods.","No, abstract classes cannot be instantiated directly and must be subclassed.","Yes, but only within its declaring package.","Yes, if passed to a Thread object."]'::jsonb,
  1,
  10,
  'Abstract classes serve as incomplete base models and cannot be instantiated directly; concrete subclasses must implement any remaining abstract methods.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000013'::UUID,
  'd0000000-0000-0000-0202-000000000002'::UUID,
  'Which operator checks whether an object is an instance of a specific class or interface at runtime?',
  '["isTypeOf","instanceof","inherits","matches"]'::jsonb,
  1,
  10,
  'The instanceof binary operator evaluates whether an object reference is compatible with a given class, subclass, or interface.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000014'::UUID,
  'd0000000-0000-0000-0202-000000000002'::UUID,
  'Why does Java not support multiple class inheritance (class C extends A, B)?',
  '["Because bytecode cannot store more than one parent reference.","To avoid ambiguities such as the Diamond Problem in method and state resolution.","Because interfaces provide superior performance over classes.","To preserve compatibility with C compilers."]'::jsonb,
  1,
  10,
  'Java avoids the complexity and ambiguities of multiple class inheritance (such as resolving duplicate inherited state in the diamond problem) by allowing multiple interface inheritance instead.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000015'::UUID,
  'd0000000-0000-0000-0202-000000000003'::UUID,
  'Which class serves as the direct superclass of all unchecked exceptions in Java?',
  '["java.lang.Error","java.lang.RuntimeException","java.lang.Exception","java.lang.Throwable"]'::jsonb,
  1,
  10,
  'RuntimeException and its subclasses constitute unchecked exceptions, which do not require mandatory compile-time declaration in throws clauses.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000016'::UUID,
  'd0000000-0000-0000-0202-000000000003'::UUID,
  'What interface must a resource class implement to be declared inside a try-with-resources statement?',
  '["java.io.Serializable","java.lang.AutoCloseable","java.lang.Cloneable","java.lang.Runnable"]'::jsonb,
  1,
  10,
  'The try-with-resources statement accepts any object implementing java.lang.AutoCloseable, ensuring its close() method is invoked on block exit.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000017'::UUID,
  'd0000000-0000-0000-0202-000000000003'::UUID,
  'What happens when a finally block executes a return statement while the try block also has a return statement?',
  '["The try block''s return value is preserved; the finally block''s return is ignored.","The finally block''s return statement overrides and discards the return value or unhandled exception from the try block.","A compile-time error occurs due to conflicting returns.","The JVM terminates with a fatal exception."]'::jsonb,
  1,
  10,
  'A return statement inside a finally block will discard any pending return value or exception from the try/catch blocks, which is why returning from finally is an anti-pattern.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000018'::UUID,
  'd0000000-0000-0000-0202-000000000003'::UUID,
  'Which exception is thrown when an application attempts to access an array index outside its valid bounds?',
  '["NullPointerException","ArrayIndexOutOfBoundsException","IllegalArgumentException","ArrayStoreException"]'::jsonb,
  1,
  10,
  'ArrayIndexOutOfBoundsException is thrown to indicate that an array has been accessed with an illegal index (negative or >= array length).',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000019'::UUID,
  'd0000000-0000-0000-0202-000000000003'::UUID,
  'Can a catch block catch multiple un-related exception types using a multi-catch statement?',
  '["No, each catch block can only handle exactly one exception type.","Yes, separating exception types with a pipe symbol (|) such as catch (IOException | SQLException e).","Yes, using comma separators: catch (IOException, SQLException e).","Only if both exceptions share an abstract interface."]'::jsonb,
  1,
  10,
  'Java 7 introduced multi-catch syntax: catch (IOException | SQLException e) where e is implicitly final.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000020'::UUID,
  'd0000000-0000-0000-0202-000000000003'::UUID,
  'What keyword is used in a method declaration to indicate that the method may propagate a checked exception to its caller?',
  '["throw","throws","exception","raises"]'::jsonb,
  1,
  10,
  'The throws keyword in a method signature declares the list of checked exceptions the method can propagate.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000021'::UUID,
  'd0000000-0000-0000-0202-000000000003'::UUID,
  'What is the primary purpose of chaining exceptions via initCause() or constructor chaining (new Exception("msg", cause))?',
  '["To speed up stack trace generation.","To preserve the original root cause exception for diagnostic traceability when rethrowing a higher-level abstraction exception.","To suppress exception logging in production.","To convert checked exceptions into compile-time warnings."]'::jsonb,
  1,
  10,
  'Exception chaining retains the underlying cause of a failure across architectural boundaries, preserving root-cause stack traces.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000022'::UUID,
  'd0000000-0000-0000-0202-000000000004'::UUID,
  'What is the average time complexity of get(key) in a well-balanced Java HashMap?',
  '["O(n)","O(log n)","O(1)","O(n log n)"]'::jsonb,
  2,
  10,
  'HashMap provides O(1) average-time complexity for basic get and put operations assuming a uniform hash distribution.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000023'::UUID,
  'd0000000-0000-0000-0202-000000000004'::UUID,
  'What occurs internally in a Java 8+ HashMap when a single bucket experiences severe hash collisions exceeding 8 nodes?',
  '["The map throws an OutOfMemoryError.","The linked list chain in that bucket is converted into a balanced red-black tree (TreeNode), improving worst-case search from O(n) to O(log n).","The map automatically deletes the conflicting keys.","The map switches to linear probing."]'::jsonb,
  1,
  10,
  'In Java 8+, when bucket collisions exceed the TREEIFY_THRESHOLD (8) and the table capacity is at least 64, the linked list converts to a red-black tree.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000024'::UUID,
  'd0000000-0000-0000-0202-000000000004'::UUID,
  'If class A overrides equals() to compare field values but does not override hashCode(), what bug occurs in a HashSet<A>?',
  '["The code will fail to compile.","Equal objects will produce different hash codes and be placed into different buckets, causing contains() to return false for existing equal objects.","The HashSet will throw a NullPointerException upon adding the second item.","All items in the set will be overwritten by the last added item."]'::jsonb,
  1,
  10,
  'Violating the equals-hashCode contract causes hash lookups to search the wrong bucket, failing to find duplicate objects.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000025'::UUID,
  'd0000000-0000-0000-0202-000000000004'::UUID,
  'What is type erasure in the Java generics implementation?',
  '["The process where the compiler removes all generic type annotations during compilation, inserting casts and using Object or bounds at runtime.","The deletion of unused classes by the JVM ClassLoader.","The dynamic casting of primitives to wrapper objects.","The erasure of stack variables on thread termination."]'::jsonb,
  0,
  10,
  'Type erasure removes generic type arguments during compilation to ensure binary compatibility with legacy pre-generics Java bytecode.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000026'::UUID,
  'd0000000-0000-0000-0202-000000000004'::UUID,
  'Which collection guarantees elements remain sorted in natural ascending order or according to a custom Comparator?',
  '["HashSet","LinkedHashSet","TreeSet","Vector"]'::jsonb,
  2,
  10,
  'TreeSet is backed by a Red-Black NavigableMap, keeping elements sorted with O(log n) insertion and lookup.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000027'::UUID,
  'd0000000-0000-0000-0202-000000000004'::UUID,
  'What does the PECS rule stand for in Java generics wildcards?',
  '["Producer Extends, Consumer Super","Parameter Extends, Consumer Static","Polymorphism Extends, Collection Super","Package Encapsulation, Class Specialization"]'::jsonb,
  0,
  10,
  'PECS: Use <? extends T> when reading from a collection (Producer Extends), and <? super T> when writing to a collection (Consumer Super).',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0302-000000000028'::UUID,
  'd0000000-0000-0000-0202-000000000004'::UUID,
  'What occurs when calling add() on a list returned by Arrays.asList(arr)?',
  '["The element is appended and the underlying array expands dynamically.","An UnsupportedOperationException is thrown because the returned list has fixed size backed by the original array.","The element replaces the first element of the array.","A new copy of the array is allocated."]'::jsonb,
  1,
  10,
  'Arrays.asList() returns a fixed-size wrapper around the array; attempting structural modifications like add() or remove() throws UnsupportedOperationException.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000001'::UUID,
  'd0000000-0000-0000-0203-000000000001'::UUID,
  'What is the solution to the recurrence relation T(n) = 2T(n/2) + O(n) according to the Master Theorem?',
  '["O(n)","O(n log n)","O(n^2)","O(log n)"]'::jsonb,
  1,
  10,
  'Here a=2, b=2, so n^(log_b a) = n^1 = n. Since f(n) = Theta(n), Case 2 of the Master Theorem applies, yielding T(n) = Theta(n log n).',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000002'::UUID,
  'd0000000-0000-0000-0203-000000000001'::UUID,
  'What is the amortized time complexity of appending an element to a dynamically resizing array that doubles capacity when full?',
  '["O(1)","O(n)","O(log n)","O(n^2)"]'::jsonb,
  0,
  10,
  'While individual resizing steps cost O(n), doubling the capacity distributes the copying cost such that the amortized cost per append is O(1).',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000003'::UUID,
  'd0000000-0000-0000-0203-000000000001'::UUID,
  'What is the time complexity to delete a node in a Singly Linked List given only a pointer directly to that target node (not the tail node)?',
  '["O(1) by copying data from the next node and bypassing the next node.","O(n) because finding the preceding node is required.","O(log n)","Impossible without rewriting the entire list."]'::jsonb,
  0,
  10,
  'By copying the value of node.next into node and setting node.next = node.next.next, deletion is accomplished in O(1) time without needing the preceding node pointer.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000004'::UUID,
  'd0000000-0000-0000-0203-000000000001'::UUID,
  'Which asymptotic notation indicates that an algorithm will take AT LEAST a given amount of time in the worst case (asymptotic lower bound)?',
  '["Big-O","Big-Omega (Ω)","Little-o","Big-Theta (Θ)"]'::jsonb,
  1,
  10,
  'Big-Omega (Ω) describes an asymptotic lower bound on function growth rate.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000005'::UUID,
  'd0000000-0000-0000-0203-000000000001'::UUID,
  'What is the time complexity of reversing a singly linked list containing n nodes iteratively?',
  '["O(n) time, O(1) auxiliary space","O(n^2) time, O(n) space","O(1) time, O(1) space","O(n log n) time, O(log n) space"]'::jsonb,
  0,
  10,
  'Iterative reversal traverses each node once using three pointers (prev, curr, next), running in O(n) time and O(1) extra space.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000006'::UUID,
  'd0000000-0000-0000-0203-000000000001'::UUID,
  'Why do arrays generally outperform linked lists for sequential iteration despite having identical asymptotic O(n) time?',
  '["Arrays use CPU cache prefetching effectively due to contiguous spatial memory locality.","Arrays do not store data in RAM.","Linked lists require operating system kernel calls on every pointer traversal.","Arrays use multithreading automatically."]'::jsonb,
  0,
  10,
  'Contiguous memory layout allows hardware CPU caches to prefetch cache lines, whereas linked list nodes scattered across heap memory cause frequent cache misses.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000007'::UUID,
  'd0000000-0000-0000-0203-000000000001'::UUID,
  'What data structure is ideal for checking whether mathematical expressions contain properly balanced brackets: (([]{}))?',
  '["Queue","Stack","Heap","Graph"]'::jsonb,
  1,
  10,
  'A LIFO stack matches the most recently opened unclosed bracket with the next encountered closing bracket.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000008'::UUID,
  'd0000000-0000-0000-0203-000000000002'::UUID,
  'Which tree traversal order visits nodes in non-decreasing sorted order for any valid Binary Search Tree?',
  '["Pre-order","In-order","Post-order","Level-order"]'::jsonb,
  1,
  10,
  'In-order traversal visits left subtree, current node, then right subtree, matching the BST ordering invariant and producing sorted keys.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000009'::UUID,
  'd0000000-0000-0000-0203-000000000002'::UUID,
  'What is the time complexity to build a binary heap from an arbitrary unsorted array of n elements using bottom-up heapify?',
  '["O(n)","O(n log n)","O(n^2)","O(log n)"]'::jsonb,
  0,
  10,
  'Bottom-up heapification requires O(n) total operations because the vast majority of nodes reside near the bottom levels where height is small.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000010'::UUID,
  'd0000000-0000-0000-0203-000000000002'::UUID,
  'What is the valid range of balance factors allowed for every node in an AVL tree?',
  '["{-1, 0, 1}","{-2, -1, 0, 1, 2}","{0}","{1, 2}"]'::jsonb,
  0,
  10,
  'An AVL tree maintains height balance such that the height difference between left and right subtrees of any node is at most 1: balance factor in {-1, 0, 1}.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000011'::UUID,
  'd0000000-0000-0000-0203-000000000002'::UUID,
  'In a 0-indexed array implementation of a binary heap, where is the parent of a node at index i located?',
  '["(i - 1) / 2","2i + 1","2i + 2","i / 2"]'::jsonb,
  0,
  10,
  'In a 0-indexed binary heap array, the parent of node i is at floor((i - 1) / 2).',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000012'::UUID,
  'd0000000-0000-0000-0203-000000000002'::UUID,
  'What rotation sequence restores balance when an insertion occurs in the right subtree of the left child of an unbalanced node?',
  '["Right-Left (RL) rotation","Left-Right (LR) double rotation","Single Left rotation","Single Right rotation"]'::jsonb,
  1,
  10,
  'A Left-Right (LR) imbalance is resolved by a left rotation on the left child followed by a right rotation on the unbalanced parent.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000013'::UUID,
  'd0000000-0000-0000-0203-000000000002'::UUID,
  'What is the worst-case search time complexity in an unbalanced binary search tree with n nodes?',
  '["O(log n)","O(n)","O(1)","O(n log n)"]'::jsonb,
  1,
  10,
  'If keys are inserted in strictly ascending or descending order, an unbalanced BST degenerates into a linear linked list of height n, requiring O(n) search.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000014'::UUID,
  'd0000000-0000-0000-0203-000000000002'::UUID,
  'What is the auxiliary space complexity of heapsort when implemented in-place on an array?',
  '["O(1)","O(n)","O(log n)","O(n^2)"]'::jsonb,
  0,
  10,
  'Heapsort reorganizes the array in-place without needing extra buffers, achieving O(1) auxiliary space.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000015'::UUID,
  'd0000000-0000-0000-0203-000000000003'::UUID,
  'What graph representation consumes O(V^2) memory regardless of the number of edges?',
  '["Adjacency List","Adjacency Matrix","Edge List","Incidence List"]'::jsonb,
  1,
  10,
  'An Adjacency Matrix allocates a V x V boolean/weight matrix, requiring Θ(V^2) space even for sparse graphs.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000016'::UUID,
  'd0000000-0000-0000-0203-000000000003'::UUID,
  'Why does Dijkstra''s algorithm fail to guarantee shortest paths on graphs with negative edge weights?',
  '["Because the priority queue throws an exception on negative keys.","Because once a node is extracted from the priority queue and marked visited, its distance is assumed finalized, but a subsequent negative edge could offer a cheaper route.","Because it cannot visit nodes in BFS order.","Because it requires undirected graphs."]'::jsonb,
  1,
  10,
  'Dijkstra''s greedy design permanently fixes a vertex distance once settled from the priority queue, which is invalidated if negative edges reduce path lengths later.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000017'::UUID,
  'd0000000-0000-0000-0203-000000000003'::UUID,
  'What is the time complexity of Dijkstra''s algorithm using a binary min-heap priority queue?',
  '["O((V + E) log V)","O(V^2)","O(V * E)","O(E log E)"]'::jsonb,
  0,
  10,
  'With a binary heap, extracting min takes O(log V) for V vertices and edge relaxations decrease key in O(log V) across E edges, totaling O((V + E) log V).',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000018'::UUID,
  'd0000000-0000-0000-0203-000000000003'::UUID,
  'How many times does the Bellman-Ford algorithm relax all edges in a graph with V vertices?',
  '["V times","V - 1 times","E times","log V times"]'::jsonb,
  1,
  10,
  'In a graph with V vertices and no negative cycles, a simple shortest path contains at most V - 1 edges, requiring V - 1 relaxation rounds.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000019'::UUID,
  'd0000000-0000-0000-0203-000000000003'::UUID,
  'Which algorithm finds a topological ordering of vertices in a Directed Acyclic Graph (DAG) by tracking in-degrees?',
  '["Prim''s Algorithm","Kahn''s Algorithm","Kruskal''s Algorithm","Floyd-Warshall Algorithm"]'::jsonb,
  1,
  10,
  'Kahn''s algorithm maintains vertex in-degrees, repeatedly queueing vertices with in-degree 0 and removing their outgoing edges.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000020'::UUID,
  'd0000000-0000-0000-0203-000000000003'::UUID,
  'What algorithm is best suited for computing all-pairs shortest paths on dense graphs in O(V^3) time?',
  '["Floyd-Warshall Algorithm","Dijkstra''s Algorithm","Bellman-Ford Algorithm","BFS"]'::jsonb,
  0,
  10,
  'The Floyd-Warshall algorithm uses dynamic programming with a 3-nested loop over all vertices to find all-pairs shortest paths in O(V^3) time.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000021'::UUID,
  'd0000000-0000-0000-0203-000000000003'::UUID,
  'What is the primary condition required for a directed graph to have at least one valid topological sort?',
  '["It must be strongly connected.","It must be a Directed Acyclic Graph (DAG) with zero cycles.","It must be a complete graph.","All edge weights must be strictly positive."]'::jsonb,
  1,
  10,
  'Topological sort is only possible on DAGs; any cycle creates an impossible dependency loop (A must precede B which must precede A).',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000022'::UUID,
  'd0000000-0000-0000-0203-000000000004'::UUID,
  'What two properties must a computational problem exhibit to be solvable via Dynamic Programming?',
  '["Optimal substructure and overlapping subproblems.","Linear time complexity and greedy choice property.","Continuous differentiability and convexity.","Randomized pivots and logarithmic height."]'::jsonb,
  0,
  10,
  'Dynamic Programming requires that optimal solutions contain optimal solutions to subproblems (optimal substructure) and that subproblems recur repeatedly (overlapping subproblems).',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000023'::UUID,
  'd0000000-0000-0000-0203-000000000004'::UUID,
  'What is the time complexity of the standard dynamic programming solution to the 0/1 Knapsack problem with n items and capacity W?',
  '["O(n * W) pseudo-polynomial time","O(2^n)","O(n log W)","O(n + W)"]'::jsonb,
  0,
  10,
  'The 0/1 Knapsack DP fills an n x W table, running in O(n * W) time, which is pseudo-polynomial because W depends on the numeric magnitude of the input.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000024'::UUID,
  'd0000000-0000-0000-0203-000000000004'::UUID,
  'In the Longest Common Subsequence (LCS) problem, what is the recurrence relation when characters match (X[i] == Y[j])?',
  '["LCS(i, j) = 1 + LCS(i - 1, j - 1)","LCS(i, j) = max(LCS(i - 1, j), LCS(i, j - 1))","LCS(i, j) = 2 * LCS(i - 1, j - 1)","LCS(i, j) = LCS(i - 1, j) + 1"]'::jsonb,
  0,
  10,
  'When characters match at indices i and j, they contribute 1 to the matching sequence plus the LCS of the prefixes X[1..i-1] and Y[1..j-1].',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000025'::UUID,
  'd0000000-0000-0000-0203-000000000004'::UUID,
  'Why does the Fractional Knapsack problem succeed with a Greedy algorithm while 0/1 Knapsack fails?',
  '["Items can be divided into arbitrary fractions, ensuring that taking the item with the highest value-to-weight ratio is always globally optimal.","Fractional knapsack requires dynamic programming.","0/1 knapsack items cannot be sorted.","Greedy algorithms only work on graphs."]'::jsonb,
  0,
  10,
  'Divisibility guarantees the greedy choice property: filling available capacity with maximum value density never leaves unusable gaps.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000026'::UUID,
  'd0000000-0000-0000-0203-000000000004'::UUID,
  'How can the space complexity of the Fibonacci tabulation algorithm be reduced from O(n) to O(1)?',
  '["By storing only the previous two computed values (prev1, prev2) instead of an entire array of size n.","By using a binary heap.","By compiling to C++.","By increasing stack memory size."]'::jsonb,
  0,
  10,
  'Since computing F(n) = F(n-1) + F(n-2) only depends on the immediate previous two states, rolling variables achieve O(1) auxiliary space.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000027'::UUID,
  'd0000000-0000-0000-0203-000000000004'::UUID,
  'What approach does top-down Dynamic Programming employ?',
  '["Recursive problem formulation augmented with memoization caching.","Iterative table population starting from base cases.","Randomized tree partitioning.","Greedy local choice optimization."]'::jsonb,
  0,
  10,
  'Top-down DP preserves natural recursive call structures and caches computed subproblem results in a hash map or table (memoization).',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0303-000000000028'::UUID,
  'd0000000-0000-0000-0203-000000000004'::UUID,
  'What is the time complexity of the Floyd-Warshall algorithm for finding all-pairs shortest paths?',
  '["O(V^3)","O(V^2 log V)","O(E * V)","O(V + E)"]'::jsonb,
  0,
  10,
  'Floyd-Warshall evaluates all vertex pairs across all intermediate vertices k in 1..V, resulting in three nested loops each running V times: O(V^3).',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000001'::UUID,
  'd0000000-0000-0000-0204-000000000001'::UUID,
  'What major protocol improvement did HTTP/2 introduce over HTTP/1.1 to eliminate application-layer head-of-line blocking?',
  '["Binary framing and concurrent multiplexed streams over a single TCP connection.","Replacing TCP with UDP entirely.","Eliminating TLS encryption requirements.","Disallowing browser caching."]'::jsonb,
  0,
  10,
  'HTTP/2 breaks messages into independent binary frames multiplexed across bidirectional streams over a single TCP connection.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000002'::UUID,
  'd0000000-0000-0000-0204-000000000001'::UUID,
  'Which HTML5 semantic element is designed to represent self-contained composition intended to be independently distributable (such as a blog post)?',
  '["<section>","<article>","<div>","<aside>"]'::jsonb,
  1,
  10,
  'The <article> element specifies independent, self-contained content that could be syndicated independently.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000003'::UUID,
  'd0000000-0000-0000-0204-000000000001'::UUID,
  'In CSS Flexbox, what property aligns items along the cross axis (perpendicular to the main flex-direction)?',
  '["justify-content","align-items","flex-wrap","order"]'::jsonb,
  1,
  10,
  'justify-content aligns items along the main axis; align-items aligns items along the cross axis.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000004'::UUID,
  'd0000000-0000-0000-0204-000000000001'::UUID,
  'What HTTP status code indicates that the server has fulfilled a request and there is no additional content to send back in the response body?',
  '["200 OK","201 Created","204 No Content","304 Not Modified"]'::jsonb,
  2,
  10,
  '204 No Content indicates successful completion without returning an entity-body (common for DELETE operations).',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000005'::UUID,
  'd0000000-0000-0000-0204-000000000001'::UUID,
  'What underlying transport layer protocol does HTTP/3 operate on top of?',
  '["TCP","QUIC over UDP","SCTP","Raw Ethernet Frames"]'::jsonb,
  1,
  10,
  'HTTP/3 operates over QUIC, a transport protocol built on top of UDP that provides multiplexing without TCP head-of-line blocking.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000006'::UUID,
  'd0000000-0000-0000-0204-000000000001'::UUID,
  'What CSS Grid property allows defining explicit named layout areas corresponding to child elements?',
  '["grid-template-areas","grid-area-names","grid-columns-named","grid-layout-map"]'::jsonb,
  0,
  10,
  'grid-template-areas specifies named grid areas that children assign themselves to using grid-area.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000007'::UUID,
  'd0000000-0000-0000-0204-000000000001'::UUID,
  'What is the function of the ETag HTTP response header?',
  '["It acts as an entity tag / hash identifier of the specific version of a resource for conditional validation (If-None-Match).","It encrypts the HTML payload.","It defines the expiration timestamp in GMT.","It enables cross-origin resource sharing."]'::jsonb,
  0,
  10,
  'ETags allow clients to make conditional requests (304 Not Modified) by sending the cached ETag back in the If-None-Match header.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000008'::UUID,
  'd0000000-0000-0000-0204-000000000002'::UUID,
  'In what order will the following code log: console.log("A"); setTimeout(() => console.log("B"), 0); Promise.resolve().then(() => console.log("C")); console.log("D");?',
  '["A, D, C, B","A, B, C, D","A, D, B, C","C, A, D, B"]'::jsonb,
  0,
  10,
  'Synchronous code runs first (A, D). The microtask queue (Promise C) drains before macrotasks (setTimeout B), logging A, D, C, B.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000009'::UUID,
  'd0000000-0000-0000-0204-000000000002'::UUID,
  'What is a closure in JavaScript?',
  '["The combination of a function bundled together with references to its surrounding lexical state (lexical environment).","A syntax error caused by unclosed curly brackets.","A mechanism that terminates the browser event loop.","A method that freezes an object to make it immutable."]'::jsonb,
  0,
  10,
  'A closure gives an inner function access to an outer enclosing function''s scope even after the outer function has returned.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000010'::UUID,
  'd0000000-0000-0000-0204-000000000002'::UUID,
  'How does an arrow function determine the value of the "this" keyword?',
  '["It inherits \"this\" lexically from the enclosing scope where the arrow function was defined.","It dynamically binds \"this\" to whatever object invoked it.","It always binds \"this\" to the global window object.","It generates a new unique \"this\" instance on every call."]'::jsonb,
  0,
  10,
  'Arrow functions do not have their own this binding; they capture this lexically from the enclosing execution context.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000011'::UUID,
  'd0000000-0000-0000-0204-000000000002'::UUID,
  'What Promise combinator resolves only when ALL input promises have fulfilled, or rejects immediately as soon as ANY promise rejects?',
  '["Promise.all()","Promise.race()","Promise.allSettled()","Promise.any()"]'::jsonb,
  0,
  10,
  'Promise.all() fails fast, rejecting immediately upon the first rejected promise, and resolves only when all promises resolve.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000012'::UUID,
  'd0000000-0000-0000-0204-000000000002'::UUID,
  'What keyword can only be used inside a function declared with the async keyword?',
  '["defer","await","yield","next"]'::jsonb,
  1,
  10,
  'The await operator pauses the execution of an async function until a Promise settles.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000013'::UUID,
  'd0000000-0000-0000-0204-000000000002'::UUID,
  'What does the spread operator (...) do when applied to an object: const b = { ...a, active: true }?',
  '["It performs a shallow copy of own enumerable properties from a into the new object b.","It deep clones all nested sub-objects of a.","It deletes the original object a.","It freezes both objects."]'::jsonb,
  0,
  10,
  'Object spread copies own enumerable properties shallowly; nested objects remain referenced by reference.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000014'::UUID,
  'd0000000-0000-0000-0204-000000000002'::UUID,
  'What is the primary difference between let and var variable declarations in modern JavaScript?',
  '["let is block-scoped and cannot be redeclared in the same scope; var is function-scoped and hoisted with undefined.","var can only store numbers.","let cannot be modified once assigned.","var is block-scoped while let is global."]'::jsonb,
  0,
  10,
  'let and const are block-scoped ({ ... }), avoiding the hoisting pitfalls and leakage associated with function-scoped var.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000015'::UUID,
  'd0000000-0000-0000-0204-000000000003'::UUID,
  'Why does React require stable keys on dynamic list items rendered via .map()?',
  '["To identify which items have changed, been added, or been removed during reconciliation, preserving DOM element identity.","To sort the list alphabetically in CSS.","To encrypt the array elements in the browser.","To enforce multithreaded rendering."]'::jsonb,
  0,
  10,
  'Keys provide a permanent identity between virtual and real DOM elements, allowing the reconciliation diffing algorithm to reuse existing DOM nodes.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000016'::UUID,
  'd0000000-0000-0000-0204-000000000003'::UUID,
  'What happens when you pass a state update function to setState: setCount(prev => prev + 1)?',
  '["It queues an updater function guaranteed to receive the most up-to-date pending state value, avoiding stale closure bugs.","It skips rendering and updates the DOM immediately.","It turns the state variable into an observable stream.","It reverts state to its initial value."]'::jsonb,
  0,
  10,
  'Functional state updates guarantee access to the newest state value even during batched asynchronous updates.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000017'::UUID,
  'd0000000-0000-0000-0204-000000000003'::UUID,
  'When does the cleanup function returned from a useEffect hook execute?',
  '["Before the component unmounts, and before re-running the effect on subsequent renders when dependencies change.","Only when the browser window closes.","Immediately before the return statement of the component.","Only when an uncaught error is thrown."]'::jsonb,
  0,
  10,
  'Effect cleanup functions clean up stale side-effects (e.g. event listeners, subscriptions) before the effect re-runs and during component unmounting.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000018'::UUID,
  'd0000000-0000-0000-0204-000000000003'::UUID,
  'What hook is best suited for memoizing expensive calculations so they only recalculate when specific inputs change?',
  '["useMemo","useCallback","useRef","useLayoutEffect"]'::jsonb,
  0,
  10,
  'useMemo caches the result of a calculation between renders until one of its dependencies changes.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000019'::UUID,
  'd0000000-0000-0000-0204-000000000003'::UUID,
  'What is the primary difference between useRef and useState?',
  '["Mutating a ref.current value does NOT trigger a component re-render, whereas calling setState does.","useRef can only store HTML DOM elements, not objects.","useState values reset on every render.","useRef is deprecated in React 18."]'::jsonb,
  0,
  10,
  'useRef returns a mutable object whose .current property persists across renders without triggering a re-render when modified.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000020'::UUID,
  'd0000000-0000-0000-0204-000000000003'::UUID,
  'What problem does React Context solve in large component hierarchies?',
  '["Prop-drilling (passing props down through multiple layers of intermediate components that do not need them).","Slow network requests.","CSS styling conflicts.","Database query optimization."]'::jsonb,
  0,
  10,
  'Context lets components broadcast data to any child component in the subtree regardless of depth without manual prop-drilling.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000021'::UUID,
  'd0000000-0000-0000-0204-000000000003'::UUID,
  'What does React.memo() accomplish when wrapping a functional component?',
  '["It memoizes the rendered component output, skipping re-renders if its props have not changed (shallow comparison).","It forces the component to render on every single keystroke.","It turns the component into a server-only component.","It moves state from the browser to local storage."]'::jsonb,
  0,
  10,
  'React.memo is a higher-order component that skips re-rendering if props are shallowly equal to previous props.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000022'::UUID,
  'd0000000-0000-0000-0204-000000000004'::UUID,
  'Why should JSON Web Tokens (JWTs) used for authentication be stored in HttpOnly cookies rather than localStorage?',
  '["HttpOnly cookies cannot be accessed or stolen by malicious client-side JavaScript scripts during a Cross-Site Scripting (XSS) attack.","localStorage cannot store strings longer than 100 characters.","HttpOnly cookies are always encrypted with RSA 4096-bit keys.","Browsers block localStorage requests to backend APIs."]'::jsonb,
  0,
  10,
  'The HttpOnly flag forbids JavaScript from reading document.cookie, protecting authentication tokens from XSS exfiltration.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000023'::UUID,
  'd0000000-0000-0000-0204-000000000004'::UUID,
  'What HTTP method is considered safe and idempotent for retrieving representations of resources?',
  '["POST","GET","DELETE","PATCH"]'::jsonb,
  1,
  10,
  'GET is safe (causes no side effects on server resources) and idempotent (multiple identical calls produce the same result).',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000024'::UUID,
  'd0000000-0000-0000-0204-000000000004'::UUID,
  'What HTTP request method does a web browser send as a CORS preflight check before making a non-simple cross-origin request?',
  '["HEAD","OPTIONS","CHECK","PROPFIND"]'::jsonb,
  1,
  10,
  'Browsers automatically dispatch an HTTP OPTIONS request to verify that the target server permits the requested HTTP method and headers.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000025'::UUID,
  'd0000000-0000-0000-0204-000000000004'::UUID,
  'What are the three parts of a JSON Web Token separated by periods (.)?',
  '["Header, Payload, Signature","Username, Password, Hash","Domain, Origin, Expiry","Issuer, Subject, Nonce"]'::jsonb,
  0,
  10,
  'A JWT consists of Header (algorithm & token type), Payload (claims & data), and Signature (HMAC or RSA verification hash).',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000026'::UUID,
  'd0000000-0000-0000-0204-000000000004'::UUID,
  'What SameSite cookie attribute value guarantees that cookies are never sent in cross-site requests, providing strong CSRF protection?',
  '["SameSite=None","SameSite=Strict","SameSite=Lax","SameSite=False"]'::jsonb,
  1,
  10,
  'SameSite=Strict ensures the cookie is withheld on any cross-site request, eliminating Cross-Site Request Forgery vulnerabilities.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000027'::UUID,
  'd0000000-0000-0000-0204-000000000004'::UUID,
  'What is the standard HTTP response status code when a client makes a request lacking valid authentication credentials?',
  '["401 Unauthorized","403 Forbidden","404 Not Found","422 Unprocessable"]'::jsonb,
  0,
  10,
  '401 Unauthorized indicates that the request lacks valid authentication credentials (unlike 403 Forbidden where identity is known but access is prohibited).',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0304-000000000028'::UUID,
  'd0000000-0000-0000-0204-000000000004'::UUID,
  'What vulnerability occurs when unvalidated user input is directly inserted into a web page''s DOM, executing arbitrary JavaScript in a victim''s browser?',
  '["Cross-Site Scripting (XSS)","SQL Injection (SQLi)","Denial of Service (DoS)","Server-Side Request Forgery (SSRF)"]'::jsonb,
  0,
  10,
  'Cross-Site Scripting (XSS) enables attackers to inject malicious client-side scripts into web pages viewed by other users.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000001'::UUID,
  'd0000000-0000-0000-0205-000000000001'::UUID,
  'What condition must hold for a relation to satisfy Third Normal Form (3NF)?',
  '["It must be in 2NF and have no transitive functional dependencies of non-prime attributes on candidate keys.","All attributes must be candidate keys.","Every functional dependency must be trivial.","No foreign keys are permitted."]'::jsonb,
  0,
  10,
  '3NF requires that the relation is in 2NF and for every non-trivial functional dependency X -> Y, X is a superkey OR Y is a prime attribute (eliminating transitive dependencies).',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000002'::UUID,
  'd0000000-0000-0000-0205-000000000001'::UUID,
  'What is a partial dependency in database normalization?',
  '["A functional dependency where a non-prime attribute depends on only a proper subset of a composite candidate key.","A dependency that holds only for certain rows in the table.","A foreign key reference to another database.","An incomplete transaction."]'::jsonb,
  0,
  10,
  'A partial dependency occurs when a non-prime attribute depends on a part of a composite primary key, which violates Second Normal Form (2NF).',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000003'::UUID,
  'd0000000-0000-0000-0205-000000000001'::UUID,
  'What relational algebra operator performs horizontal filtering of tuples matching a conditional predicate?',
  '["Selection (σ)","Projection (π)","Cartesian Product (×)","Intersection (∩)"]'::jsonb,
  0,
  10,
  'Selection (sigma) selects horizontal rows/tuples satisfying a boolean condition; projection (pi) selects vertical columns/attributes.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000004'::UUID,
  'd0000000-0000-0000-0205-000000000001'::UUID,
  'How does Boyce-Codd Normal Form (BCNF) differ from 3NF?',
  '["In BCNF, for every non-trivial functional dependency X -> Y, X must strictly be a superkey (eliminating the 3NF allowance where Y is a prime attribute).","BCNF allows multi-valued attributes.","BCNF does not require 1NF.","BCNF is weaker than 2NF."]'::jsonb,
  0,
  10,
  'BCNF is strictly stronger than 3NF: it removes the exception that allows Y to be a prime attribute, demanding that the determinant X must always be a superkey.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000005'::UUID,
  'd0000000-0000-0000-0205-000000000001'::UUID,
  'What is an insertion anomaly in an un-normalized database table?',
  '["Inability to record certain information without artificially inserting unrelated dummy data due to excessive attribute coupling.","Hardware disk failure during write operations.","A syntax error in an INSERT statement.","Inserting duplicate primary keys."]'::jsonb,
  0,
  10,
  'An insertion anomaly occurs when facts about an entity cannot be recorded without also recording unrelated attributes of another entity (e.g. adding a new course without any enrolled students).',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000006'::UUID,
  'd0000000-0000-0000-0205-000000000001'::UUID,
  'What property guarantees that decomposing relation R into R1 and R2 allows reconstructing R via natural join without creating false spurious tuples?',
  '["Lossless Join Decomposition","Dependency Preservation","Atomic Integrity","Referential Cascading"]'::jsonb,
  0,
  10,
  'A decomposition is lossless if and only if the intersection of attributes R1 ∩ R2 forms a superkey for at least one of the decomposed relations (R1 or R2).',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000007'::UUID,
  'd0000000-0000-0000-0205-000000000001'::UUID,
  'What is a candidate key in relational modeling?',
  '["A minimal superkey whose proper subsets cannot uniquely identify a tuple.","Any column that contains non-null values.","The primary key of a foreign table.","An index created for query optimization."]'::jsonb,
  0,
  10,
  'A candidate key is a minimal superkey: it uniquely identifies every tuple in the relation and contains no extraneous attributes.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000008'::UUID,
  'd0000000-0000-0000-0205-000000000002'::UUID,
  'What is the key difference between RANK() and DENSE_RANK() window functions when handling ties?',
  '["RANK() skips rank numbers after a tie (e.g. 1, 2, 2, 4), while DENSE_RANK() produces continuous rank numbers without gaps (e.g. 1, 2, 2, 3).","DENSE_RANK() only works on integer columns.","RANK() cannot be partitioned.","DENSE_RANK() requires an unbounded preceding frame."]'::jsonb,
  0,
  10,
  'RANK() generates gaps in ranking order corresponding to the number of tied elements; DENSE_RANK() leaves no numerical gaps.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000009'::UUID,
  'd0000000-0000-0000-0205-000000000002'::UUID,
  'Which join type returns all rows from the left table, plus matched rows from the right table, filling missing right columns with NULL?',
  '["INNER JOIN","LEFT OUTER JOIN","FULL OUTER JOIN","CROSS JOIN"]'::jsonb,
  1,
  10,
  'LEFT OUTER JOIN retains every record from the left table regardless of whether a matching record exists in the right table.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000010'::UUID,
  'd0000000-0000-0000-0205-000000000002'::UUID,
  'What clause in a window function defines the subset of rows over which the window calculation is partitioned?',
  '["GROUP BY","PARTITION BY","ORDER BY","WINDOW BY"]'::jsonb,
  1,
  10,
  'PARTITION BY divides query results into partitions to which the window function is applied independently.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000011'::UUID,
  'd0000000-0000-0000-0205-000000000002'::UUID,
  'Why can window functions NOT be used directly inside the WHERE clause of the same query block?',
  '["Because the WHERE clause is evaluated before window functions in the SQL logical query processing order.","Because SQL prohibits window functions on numeric data.","Because window functions require disk writes.","Because WHERE clauses only accept primary keys."]'::jsonb,
  0,
  10,
  'Logical query evaluation order is: FROM -> WHERE -> GROUP BY -> HAVING -> SELECT (Window Functions) -> ORDER BY. Filtering by a window result requires a CTE or subquery.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000012'::UUID,
  'd0000000-0000-0000-0205-000000000002'::UUID,
  'Which SQL function accesses data from the immediately preceding row within a window partition without a self-join?',
  '["LAG()","LEAD()","PREV()","FIRST_VALUE()"]'::jsonb,
  0,
  10,
  'LAG(column, offset) provides access to a row at a given physical offset prior to the current row within the window partition.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000013'::UUID,
  'd0000000-0000-0000-0205-000000000002'::UUID,
  'What is the result of a CROSS JOIN between a table with 10 rows and a table with 20 rows?',
  '["30 rows","200 rows (Cartesian Product)","20 rows","0 rows unless a join condition is specified"]'::jsonb,
  1,
  10,
  'A CROSS JOIN produces the Cartesian product of both tables: 10 * 20 = 200 total rows.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000014'::UUID,
  'd0000000-0000-0000-0205-000000000002'::UUID,
  'What is the purpose of the COALESCE() SQL function?',
  '["Returns the first non-null expression among its arguments.","Converts strings to lowercase.","Combines two tables into a view.","Counts non-null rows."]'::jsonb,
  0,
  10,
  'COALESCE(val1, val2, ...) evaluates arguments in order and returns the first non-NULL expression.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000015'::UUID,
  'd0000000-0000-0000-0205-000000000003'::UUID,
  'Why do relational database engines use B+ Trees rather than standard binary search trees for disk-based indexing?',
  '["B+ Trees have high fan-out, resulting in shallow trees that minimize expensive disk I/O seek operations, with linked leaves for efficient range scans.","Binary trees cannot store numeric keys.","B+ Trees eliminate the need for primary keys.","Binary trees do not support concurrent reads."]'::jsonb,
  0,
  10,
  'Disk reads fetch pages of 4KB-16KB. High fan-out nodes ensure a B+ Tree index with millions of keys has a height of only 3 to 4, requiring very few disk seeks.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000016'::UUID,
  'd0000000-0000-0000-0205-000000000003'::UUID,
  'What execution plan node indicates that the query planner retrieved all required data directly from the index without reading table heap blocks?',
  '["Sequential Scan","Index Scan","Index Only Scan","Bitmap Heap Scan"]'::jsonb,
  2,
  10,
  'An Index Only Scan satisfies the query solely from the index tree (covering index) without visiting heap pages, maximizing performance.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000017'::UUID,
  'd0000000-0000-0000-0205-000000000003'::UUID,
  'On a compound index CREATE INDEX idx_emp ON employees(department_id, salary), which query CANNOT use the index efficiently?',
  '["WHERE department_id = 10 AND salary > 50000","WHERE department_id = 10","WHERE salary > 50000 (without department_id in predicate)","WHERE department_id = 10 ORDER BY salary"]'::jsonb,
  2,
  10,
  'Compound indexes follow the leftmost prefix rule: queries that omit the leading column (department_id) cannot traverse the B-tree efficiently.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000018'::UUID,
  'd0000000-0000-0000-0205-000000000003'::UUID,
  'What is the primary drawback of adding excessive indexes to a database table?',
  '["Every INSERT, UPDATE, and DELETE operation must update all associated indexes, degrading write throughput.","The query planner will fail to execute SELECT queries.","Data corruption occurs when indexes exceed 3.","Foreign key constraints stop functioning."]'::jsonb,
  0,
  10,
  'Every index requires real-time tree rebalancing and page splitting during writes, substantially slowing down data mutation throughput.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000019'::UUID,
  'd0000000-0000-0000-0205-000000000003'::UUID,
  'What is a clustered index in database storage?',
  '["An index that dictates the actual physical order of data rows on the storage disk/pages.","An index that connects multiple database clusters over a network.","An index stored in volatile RAM.","A composite index containing more than 5 columns."]'::jsonb,
  0,
  10,
  'A clustered index determines the physical storage arrangement of data rows in the table; hence a table can have only one clustered index.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000020'::UUID,
  'd0000000-0000-0000-0205-000000000003'::UUID,
  'What does the ANALYZE command do in PostgreSQL and relational database systems?',
  '["It gathers distribution statistics about table contents used by the query planner to calculate execution plan costs.","It deletes fragmented tables.","It decrypts database passwords.","It forces all queries to use sequential scans."]'::jsonb,
  0,
  10,
  'ANALYZE updates planner statistics (histograms, distinct value counts), enabling the query optimizer to make informed plan choices.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000021'::UUID,
  'd0000000-0000-0000-0205-000000000003'::UUID,
  'Why does applying a function to an indexed column (e.g. WHERE LOWER(email) = ''user@test.com'') typically prevent standard B-tree index usage?',
  '["The B-tree index is sorted on the raw email values, not on the transformed output of LOWER(email), forcing a full table scan unless an expression index is created.","LOWER() cannot be executed in SQL.","B-trees only index uppercase characters.","PostgreSQL disables indexes on string columns."]'::jsonb,
  0,
  10,
  'Standard indexes cannot evaluate function results on the fly; an explicit expression index (e.g. CREATE INDEX ON users(LOWER(email))) is required.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000022'::UUID,
  'd0000000-0000-0000-0205-000000000004'::UUID,
  'What concurrency phenomenon is permitted under the Read Committed isolation level but prohibited under Repeatable Read?',
  '["Non-Repeatable Read (re-reading the same row within a transaction returns altered data committed by another transaction).","Dirty Read","Deadlock","Write Skew"]'::jsonb,
  0,
  10,
  'Under Read Committed, re-reading a row after a concurrent transaction commits updates will see the new values (Non-Repeatable Read). Repeatable Read prevents this anomaly.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000023'::UUID,
  'd0000000-0000-0000-0205-000000000004'::UUID,
  'What fundamental rule does Write-Ahead Logging (WAL) enforce to guarantee Durability and Atomicity?',
  '["Log records describing a database state change must be flushed to non-volatile storage BEFORE the corresponding modified data page is written to disk.","Data pages are written to disk before log records.","All queries must be logged in plain text.","Transactions must commit every 50 milliseconds."]'::jsonb,
  0,
  10,
  'WAL guarantees that if a crash occurs while flushing dirty data pages to disk, the database can reconstruct committed updates (Redo) and rollback uncommitted updates (Undo).',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000024'::UUID,
  'd0000000-0000-0000-0205-000000000004'::UUID,
  'How does Multi-Version Concurrency Control (MVCC) eliminate read-write contention?',
  '["By creating immutable row versions tagged with transaction visibility bounds, allowing readers to read consistent snapshots without acquiring read locks.","By queueing all write operations to run after business hours.","By disallowing simultaneous client connections.","By caching the entire database in CPU L1 cache."]'::jsonb,
  0,
  10,
  'In MVCC, writers create new versions of rows rather than overwriting existing rows in place. Readers view a consistent snapshot, meaning readers never block writers and writers never block readers.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000025'::UUID,
  'd0000000-0000-0000-0205-000000000004'::UUID,
  'What is a Dirty Read concurrency anomaly?',
  '["A transaction reads uncommitted data modifications made by another concurrent transaction that subsequently rolls back.","A query reading corrupted disk sectors.","A read operation that takes longer than 10 seconds.","Reading from an outdated secondary replica."]'::jsonb,
  0,
  10,
  'Dirty reads occur when transaction A views changes made by transaction B before B commits; if B rolls back, transaction A acted on phantom invalid state.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000026'::UUID,
  'd0000000-0000-0000-0205-000000000004'::UUID,
  'What does Strict Two-Phase Locking (Strict 2PL) require regarding exclusive locks?',
  '["All exclusive locks acquired during the growing phase must be held until the transaction fully commits or aborts.","Locks can be released at any time during execution.","Only shared locks are permitted.","Locks expire after 100 milliseconds."]'::jsonb,
  0,
  10,
  'Strict 2PL requires holding all exclusive locks until end-of-transaction (commit/abort), preventing cascading aborts and ensuring strict serializability.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000027'::UUID,
  'd0000000-0000-0000-0205-000000000004'::UUID,
  'What is the function of the VACUUM process in PostgreSQL''s MVCC implementation?',
  '["It identifies and reclaims physical space occupied by dead row versions (tuples) created by updates and deletes.","It resets all primary key sequence numbers to zero.","It removes table indexes to save RAM.","It drops tables that have had no queries for 30 days."]'::jsonb,
  0,
  10,
  'In PostgreSQL MVCC, UPDATES and DELETES leave old tuple versions on disk; VACUUM sweeps and frees dead tuples so the space can be reused for new rows.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0305-000000000028'::UUID,
  'd0000000-0000-0000-0205-000000000004'::UUID,
  'Which SQL statement explicitly discards all modifications made within the active transaction block?',
  '["ROLLBACK","COMMIT","DISCARD ALL","ABORT SILENT"]'::jsonb,
  0,
  10,
  'ROLLBACK terminates the active transaction and undoes all changes made since the transaction began.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000001'::UUID,
  'd0000000-0000-0000-0206-000000000001'::UUID,
  'What mechanism prevents a user program from monopolizing the CPU indefinitely in a preemptive operating system?',
  '["Hardware Timer Interrupt","Software while loop checking","Automatic compiler code insertion","Manual keyboard interrupt"]'::jsonb,
  0,
  10,
  'The hardware timer generates periodic interrupts that invoke the kernel interrupt handler, ensuring the OS regains CPU control to schedule other tasks.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000002'::UUID,
  'd0000000-0000-0000-0206-000000000001'::UUID,
  'What is the primary difference between a program and a process in operating systems theory?',
  '["A program is a passive entity stored on disk (executable file), whereas a process is an active program in execution with allocated memory and program counter.","A program is written in C; a process is written in assembly.","A program requires a GPU; a process requires a CPU.","There is no difference."]'::jsonb,
  0,
  10,
  'A program is passive code stored on secondary storage; a process is dynamic, holding active runtime state in memory.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000003'::UUID,
  'd0000000-0000-0000-0206-000000000001'::UUID,
  'What hardware transition occurs when a user application executes a system call such as read() or write()?',
  '["The CPU executes a software interrupt (trap) switching the hardware mode bit from User Mode to Kernel Mode.","The CPU reboots.","The operating system deletes the process PCB.","The CPU increases clock frequency."]'::jsonb,
  0,
  10,
  'System calls trigger a trap instruction that switches the processor into privileged Kernel Mode to execute trusted kernel service routines.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000004'::UUID,
  'd0000000-0000-0000-0206-000000000001'::UUID,
  'Which data structure does the operating system maintain for every active process to preserve its execution state during context switching?',
  '["Process Control Block (PCB)","Inode Table","Virtual Memory Buffer","Interrupt Vector Table"]'::jsonb,
  0,
  10,
  'The PCB stores the process ID, state, program counter, registers, scheduling priority, memory limits, and open file descriptors.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000005'::UUID,
  'd0000000-0000-0000-0206-000000000001'::UUID,
  'Why does switching between two threads in the same process have lower overhead than switching between two distinct processes?',
  '["Threads share the same virtual address space and open file table, avoiding the need to flush and reload memory page tables and TLBs.","Threads do not use CPU registers.","Threads bypass the operating system scheduler.","Threads do not have stack memory."]'::jsonb,
  0,
  10,
  'Because threads within a process share memory mapping, a thread context switch preserves the virtual memory mapping and TLB cache lines.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000006'::UUID,
  'd0000000-0000-0000-0206-000000000001'::UUID,
  'When a process is waiting for disk I/O to complete, which state does it occupy in the 5-state process model?',
  '["Ready","Waiting (Blocked)","Running","New"]'::jsonb,
  1,
  10,
  'A process waiting for an external event (such as disk I/O or network packet) resides in the Waiting (Blocked) state until the event completes.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000007'::UUID,
  'd0000000-0000-0000-0206-000000000001'::UUID,
  'What type of kernel architecture moves device drivers, file systems, and virtual memory into user space, keeping only minimal IPC and scheduling in kernel mode?',
  '["Monolithic Kernel","Microkernel","Hybrid Kernel","Exokernel"]'::jsonb,
  1,
  10,
  'Microkernels (e.g. Mach, QNX) minimize kernel code by running system services as unprivileged user-space servers communicating via IPC.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000008'::UUID,
  'd0000000-0000-0000-0206-000000000002'::UUID,
  'What algorithm provably minimizes the average waiting time for a given set of stationary processes?',
  '["First-Come, First-Served (FCFS)","Shortest Job First (SJF)","Round Robin with quantum = 1ms","Priority Scheduling with aging"]'::jsonb,
  1,
  10,
  'Shortest Job First (SJF) is mathematically optimal because scheduling shorter jobs earlier reduces the cumulative waiting time for all subsequent processes.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000009'::UUID,
  'd0000000-0000-0000-0206-000000000002'::UUID,
  'What is the Convoy Effect in First-Come, First-Served (FCFS) scheduling?',
  '["A scenario where short CPU/IO-bound processes wait behind a single long CPU-bound process, degrading device utilization.","A network routing bottleneck.","Multiple CPU cores running identical tasks.","Deadlock caused by circular dependency."]'::jsonb,
  0,
  10,
  'The Convoy Effect occurs in FCFS when a long CPU-intensive process holds the processor, forcing all subsequent short I/O-bound processes to wait.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000010'::UUID,
  'd0000000-0000-0000-0206-000000000002'::UUID,
  'What happens to the Round Robin scheduling algorithm as the time quantum approaches infinity (q -> ∞)?',
  '["It degenerates into First-Come, First-Served (FCFS).","It becomes Shortest Job First.","It causes a kernel panic.","Context switch overhead increases exponentially."]'::jsonb,
  0,
  10,
  'If the time quantum exceeds the longest CPU burst, every process completes in its first slice, rendering Round Robin identical to FCFS.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000011'::UUID,
  'd0000000-0000-0000-0206-000000000002'::UUID,
  'What technique prevents starvation of low-priority processes in priority scheduling systems?',
  '["Aging (gradually increasing process priority the longer it waits in the ready queue)","Preemption disablement","Memory paging","Spinlocking"]'::jsonb,
  0,
  10,
  'Aging gradually boosts the priority of long-waiting processes, guaranteeing they will eventually become the highest-priority task and execute.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000012'::UUID,
  'd0000000-0000-0000-0206-000000000002'::UUID,
  'How is the Turnaround Time of a process defined?',
  '["Completion Time minus Arrival Time","Burst Time minus Waiting Time","Waiting Time plus Arrival Time","Completion Time minus Burst Time"]'::jsonb,
  0,
  10,
  'Turnaround Time represents the entire elapsed duration from process submission to process termination: Turnaround Time = Completion Time - Arrival Time.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000013'::UUID,
  'd0000000-0000-0000-0206-000000000002'::UUID,
  'What is the preemptive version of the Shortest Job First (SJF) algorithm called?',
  '["Shortest Remaining Time First (SRTF)","Multilevel Feedback Queue","Earliest Deadline First","Round Robin"]'::jsonb,
  0,
  10,
  'Shortest Remaining Time First (SRTF) preempts the currently running process if a new process arrives with a shorter remaining CPU burst.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000014'::UUID,
  'd0000000-0000-0000-0206-000000000002'::UUID,
  'Why is setting the Round Robin time quantum extremely small (e.g. 1 microsecond) impractical in real operating systems?',
  '["The CPU would spend a disproportionate percentage of its cycles performing context switches rather than executing application code.","Processes cannot execute for less than 1 millisecond.","Timers cannot measure microseconds.","It violates mutual exclusion."]'::jsonb,
  0,
  10,
  'If quantum is too small, context switch overhead dominates CPU time, drastically reducing throughput and overall system performance.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000015'::UUID,
  'd0000000-0000-0000-0206-000000000003'::UUID,
  'Which of the following is NOT one of the three requirements for a valid solution to the Critical Section Problem?',
  '["Mutual Exclusion","Progress","Bounded Waiting","Equal Execution Speed"]'::jsonb,
  3,
  10,
  'The three required criteria are Mutual Exclusion, Progress, and Bounded Waiting; no assumptions may be made about relative process execution speeds.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000016'::UUID,
  'd0000000-0000-0000-0206-000000000003'::UUID,
  'What are Coffman''s four necessary and sufficient conditions for a system deadlock to occur?',
  '["Mutual Exclusion, Hold and Wait, No Preemption, and Circular Wait.","Paging, Segmentation, Swapping, and Thrashing.","Starvation, Aging, Context Switching, and Preemption.","First In, First Out, Priority, and Quantum."]'::jsonb,
  0,
  10,
  'Deadlock can arise if and only if all four conditions hold simultaneously: Mutual Exclusion, Hold & Wait, No Preemption, and Circular Wait.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000017'::UUID,
  'd0000000-0000-0000-0206-000000000003'::UUID,
  'What algorithm is used for deadlock avoidance in a system with multiple instances of each resource type?',
  '["Banker''s Algorithm","Peterson''s Algorithm","Dijkstra''s Shortest Path","Kruskal''s Algorithm"]'::jsonb,
  0,
  10,
  'Dijkstra''s Banker''s Algorithm evaluates whether granting a resource request leaves the system in a safe state with a valid execution sequence.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000018'::UUID,
  'd0000000-0000-0000-0206-000000000003'::UUID,
  'What does a negative value of a counting semaphore S (S < 0) represent in its implementation with a wait queue?',
  '["The absolute value |S| equals the number of processes currently blocked in the semaphore''s waiting queue.","An arithmetic overflow error.","The number of available free resources.","The number of active CPU cores."]'::jsonb,
  0,
  10,
  'In queue-based semaphore implementations, when S < 0, the magnitude |S| represents the exact count of processes currently suspended waiting for that semaphore.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000019'::UUID,
  'd0000000-0000-0000-0206-000000000003'::UUID,
  'What practical deadlock prevention strategy breaks the Circular Wait condition?',
  '["Imposing a strict global linear ordering on all resource types and requiring processes to request resources in strictly ascending order.","Terminating all processes periodically.","Doubling available RAM.","Using only un-synchronized variables."]'::jsonb,
  0,
  10,
  'Enforcing a total ordering on resources (F: R -> N) and requiring processes to request resources in strictly increasing order mathematically prevents circular dependency cycles.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000020'::UUID,
  'd0000000-0000-0000-0206-000000000003'::UUID,
  'What is Priority Inversion in concurrent systems?',
  '["A high-priority task is indirectly preempted by a medium-priority task while waiting for a shared resource held by a low-priority task.","Low priority tasks executing faster than high priority tasks.","Reversing scheduling queues.","A deadlock between CPU registers."]'::jsonb,
  0,
  10,
  'Priority inversion occurs when a low-priority process holding a lock is preempted by medium-priority processes, causing a high-priority process waiting on that lock to be blocked indefinitely.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000021'::UUID,
  'd0000000-0000-0000-0206-000000000003'::UUID,
  'What protocol resolves Priority Inversion by temporarily elevating the lock holder''s priority to match the highest-priority waiting process?',
  '["Priority Inheritance Protocol","Round Robin Rotation","Banker''s Escalation","Aging Protocol"]'::jsonb,
  0,
  10,
  'The Priority Inheritance Protocol elevates the priority of the lock-holding task to the highest priority among all tasks waiting for that lock until it releases the resource.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000022'::UUID,
  'd0000000-0000-0000-0206-000000000004'::UUID,
  'What is Bélády''s Anomaly in virtual memory page replacement?',
  '["A phenomenon where increasing the number of physical page frames results in an INCREASE in the total number of page faults under the FIFO algorithm.","A hardware bug causing memory corruption.","Thrashing caused by recursive functions.","TLB misses exceeding 90%."]'::jsonb,
  0,
  10,
  'Bélády''s Anomaly demonstrates that for non-stack algorithms like FIFO, giving a process more memory frames can paradoxically increase total page faults for certain reference strings.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000023'::UUID,
  'd0000000-0000-0000-0206-000000000004'::UUID,
  'What is the purpose of the Translation Lookaside Buffer (TLB) in the CPU memory management unit (MMU)?',
  '["A fast hardware associative cache that stores recent virtual-to-physical page translation entries to avoid extra memory accesses.","A disk partition dedicated to virtual swap.","An array storing CPU instruction opcodes.","A secondary heap memory."]'::jsonb,
  0,
  10,
  'The TLB caches active virtual-to-physical address translations in hardware; a TLB hit translates addresses in a fraction of a nanosecond without reading page tables from RAM.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000024'::UUID,
  'd0000000-0000-0000-0206-000000000004'::UUID,
  'What condition causes a system to experience Thrashing in virtual memory?',
  '["The sum of the working set sizes of all active processes exceeds the total available physical RAM, causing the system to spend virtually all its time swapping pages to and from disk.","The CPU clock speed is too high for memory bus bandwidth.","A program with infinite loop executes.","A page replacement algorithm runs out of disk swap space."]'::jsonb,
  0,
  10,
  'Thrashing occurs when active processes lack sufficient frames to hold their working sets, causing continuous back-to-back page faults and disk I/O queuing.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000025'::UUID,
  'd0000000-0000-0000-0206-000000000004'::UUID,
  'Which page replacement algorithm evicts the page that will not be referenced for the longest duration in the future (serving as the theoretical gold standard)?',
  '["Optimal Page Replacement (OPT / MIN)","Least Recently Used (LRU)","First-In First-Out (FIFO)","Least Frequently Used (LFU)"]'::jsonb,
  0,
  10,
  'The Optimal algorithm (MIN) achieves the lowest possible page fault rate by evicting the page with the farthest future reference, though it cannot be implemented without future knowledge.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000026'::UUID,
  'd0000000-0000-0000-0206-000000000004'::UUID,
  'What type of memory fragmentation is completely eliminated by paging?',
  '["External Fragmentation","Internal Fragmentation","Page Table Fragmentation","Cache Fragmentation"]'::jsonb,
  0,
  10,
  'Because any physical frame can be allocated to any process regardless of contiguity, paging completely eliminates external fragmentation.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000027'::UUID,
  'd0000000-0000-0000-0206-000000000004'::UUID,
  'In a 32-bit virtual address architecture with a 4 KB page size (4096 = 2^12 bytes), how many bits are used for the page offset?',
  '["12 bits","20 bits","32 bits","16 bits"]'::jsonb,
  0,
  10,
  'Since 4096 = 2^12, the lowest 12 bits represent the page offset d, leaving the upper 20 bits (32 - 12) for the page number p.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0306-000000000028'::UUID,
  'd0000000-0000-0000-0206-000000000004'::UUID,
  'What algorithm approximates Least Recently Used (LRU) using a circular queue and a reference bit?',
  '["Second-Chance (Clock) Algorithm","Bélády''s Counter","Peterson''s Loop","Banker''s Sieve"]'::jsonb,
  0,
  10,
  'The Clock (Second-Chance) algorithm inspects the reference bit of pages circularly: if the bit is 0, the page is evicted; if 1, the bit is cleared to 0 and the hand advances.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000001'::UUID,
  'd0000000-0000-0000-0207-000000000001'::UUID,
  'What is the correct Protocol Data Unit (PDU) name at the Transport Layer of the OSI model?',
  '["Packet","Segment","Frame","Bit"]'::jsonb,
  1,
  10,
  'Layer 4 (Transport) PDUs are called Segments (in TCP) or Datagrams (in UDP); Layer 3 has Packets; Layer 2 has Frames.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000002'::UUID,
  'd0000000-0000-0000-0207-000000000001'::UUID,
  'Which layer of the OSI model is responsible for end-to-end process-to-process communication and port multiplexing?',
  '["Network Layer","Transport Layer","Data Link Layer","Session Layer"]'::jsonb,
  1,
  10,
  'The Transport Layer provides process-to-process communication using 16-bit port numbers to distinguish concurrent applications.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000003'::UUID,
  'd0000000-0000-0000-0207-000000000001'::UUID,
  'At what layer of the network stack does a standard Layer 2 Ethernet switch make forwarding decisions?',
  '["Physical Layer","Data Link Layer","Network Layer","Transport Layer"]'::jsonb,
  1,
  10,
  'Layer 2 switches inspect incoming frames, learn source MAC addresses, and forward frames based on destination MAC addresses.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000004'::UUID,
  'd0000000-0000-0000-0207-000000000001'::UUID,
  'What is the size of a standard hardware Media Access Control (MAC) address?',
  '["32 bits","48 bits (6 bytes)","64 bits","128 bits"]'::jsonb,
  1,
  10,
  'Standard Ethernet/Wi-Fi MAC addresses are 48 bits (6 bytes) long, represented in hexadecimal notation (e.g. 00:1A:2B:3C:4D:5E).',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000005'::UUID,
  'd0000000-0000-0000-0207-000000000001'::UUID,
  'What process prepends layer-specific headers as data moves downward through the network stack?',
  '["Decapsulation","Encapsulation","Demultiplexing","Fragmentation"]'::jsonb,
  1,
  10,
  'Encapsulation is the process where each descending layer wraps data from the layer above with its own protocol header.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000006'::UUID,
  'd0000000-0000-0000-0207-000000000001'::UUID,
  'What protocol translates a known 32-bit IPv4 address into a 48-bit physical MAC address on a local area network?',
  '["DNS","ARP (Address Resolution Protocol)","DHCP","ICMP"]'::jsonb,
  1,
  10,
  'ARP broadcasts an inquiry on the local network segment to find the hardware MAC address associated with a given target IP.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000007'::UUID,
  'd0000000-0000-0000-0207-000000000001'::UUID,
  'Which OSI layer handles data encryption, compression, and character code translation?',
  '["Presentation Layer","Session Layer","Application Layer","Transport Layer"]'::jsonb,
  0,
  10,
  'The Presentation Layer (Layer 6) transforms data into formats the application can accept, handling encryption, syntax translation, and compression.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000008'::UUID,
  'd0000000-0000-0000-0207-000000000002'::UUID,
  'What DNS record type maps a domain hostname directly to an IPv6 address?',
  '["A Record","AAAA Record","CNAME Record","MX Record"]'::jsonb,
  1,
  10,
  'An A record maps a hostname to a 32-bit IPv4 address; a quad-A (AAAA) record maps to a 128-bit IPv6 address.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000009'::UUID,
  'd0000000-0000-0000-0207-000000000002'::UUID,
  'What transport protocol and port number does DNS standard name resolution utilize by default?',
  '["UDP Port 53","TCP Port 80","UDP Port 67","TCP Port 443"]'::jsonb,
  0,
  10,
  'Standard DNS queries use UDP port 53 for speed and minimal setup overhead.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000010'::UUID,
  'd0000000-0000-0000-0207-000000000002'::UUID,
  'In BSD Socket programming, which system call binds a socket descriptor to a specific local IP address and port number on the server?',
  '["connect()","bind()","listen()","accept()"]'::jsonb,
  1,
  10,
  'bind() assigns a local protocol address (IP + port) to an unnamed socket.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000011'::UUID,
  'd0000000-0000-0000-0207-000000000002'::UUID,
  'What does a DNS CNAME record specify?',
  '["An alias mapping one domain name to another canonical domain name.","The mail exchange server for the domain.","The authoritative name server.","A cryptographic public key."]'::jsonb,
  0,
  10,
  'A Canonical Name (CNAME) record maps an alias hostname to its true canonical domain name.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000012'::UUID,
  'd0000000-0000-0000-0207-000000000002'::UUID,
  'What system call blocks a server thread until an incoming client connection request arrives on a listening socket?',
  '["accept()","listen()","bind()","select()"]'::jsonb,
  0,
  10,
  'accept() extracts the first connection request on the queue of pending connections and creates a new connected socket.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000013'::UUID,
  'd0000000-0000-0000-0207-000000000002'::UUID,
  'What HTTP request header allows a browser to conditionally revalidate cached assets based on modification date?',
  '["If-Modified-Since","Cache-Control","Set-Cookie","Upgrade-Insecure-Requests"]'::jsonb,
  0,
  10,
  'If-Modified-Since sends the cached last-modified timestamp; the server responds with 304 Not Modified if unchanged.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000014'::UUID,
  'd0000000-0000-0000-0207-000000000002'::UUID,
  'Why does a client query an Authoritative Nameserver rather than a Root Nameserver for the final IP mapping?',
  '["Root servers only maintain delegations to Top-Level Domain (TLD) servers; only the domain''s Authoritative nameserver holds the actual resource records.","Root servers do not speak IP.","Authoritative servers have faster fiber lines.","Root servers only run during maintenance windows."]'::jsonb,
  0,
  10,
  'The DNS hierarchy distributes records: root servers direct queries to TLD servers (.com), which direct queries to the authoritative server hosting the final record.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000015'::UUID,
  'd0000000-0000-0000-0207-000000000003'::UUID,
  'What is the exact sequence of TCP flag packets exchanged during the 3-Way Handshake to establish a connection?',
  '["SYN -> SYN-ACK -> ACK","ACK -> SYN -> SYN-ACK","SYN -> ACK -> DATA","FIN -> ACK -> FIN-ACK"]'::jsonb,
  0,
  10,
  'Client sends SYN; server responds with SYN-ACK; client acknowledges with ACK, synchronizing initial sequence numbers.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000016'::UUID,
  'd0000000-0000-0000-0207-000000000003'::UUID,
  'What does the Acknowledgment Number in a TCP header indicate?',
  '["The next sequence number byte the receiver expects to receive.","The number of packets dropped so far.","The checksum of the payload.","The size of the receiver buffer."]'::jsonb,
  0,
  10,
  'TCP utilizes cumulative acknowledgments: ack number X indicates that all bytes up to X - 1 have been received, and the receiver expects byte X next.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000017'::UUID,
  'd0000000-0000-0000-0207-000000000003'::UUID,
  'How does the TCP Congestion Window (cwnd) grow during the Slow Start phase?',
  '["Exponentially: doubles every Round Trip Time (RTT).","Linearly: increases by 1 MSS per RTT.","Logarithmically.","It remains constant."]'::jsonb,
  0,
  10,
  'During Slow Start, cwnd increases by 1 MSS for every acknowledged packet, effectively doubling the window every round trip time.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000018'::UUID,
  'd0000000-0000-0000-0207-000000000003'::UUID,
  'What event triggers the Fast Retransmit algorithm in modern TCP without waiting for a retransmission timer timeout?',
  '["Receipt of 3 Duplicate ACKs for the same sequence number.","A ping command from the user.","Receipt of an ICMP redirect message.","A checksum error in the header."]'::jsonb,
  0,
  10,
  'Three duplicate ACKs indicate that subsequent out-of-order packets reached the receiver, proving a specific packet was lost and triggering immediate retransmission.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000019'::UUID,
  'd0000000-0000-0000-0207-000000000003'::UUID,
  'What is the purpose of the TIME_WAIT state in the TCP connection teardown protocol?',
  '["To allow lingering duplicate segments to expire in the network and ensure the final ACK was received by the remote endpoint.","To download pending file updates.","To renegotiate encryption keys.","To save power in the NIC card."]'::jsonb,
  0,
  10,
  'TIME_WAIT holds the socket for 2 MSL to prevent delayed duplicate packets from being misdelivered to a subsequent connection reusing the same port pair.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000020'::UUID,
  'd0000000-0000-0000-0207-000000000003'::UUID,
  'How does Flow Control differ fundamentally from Congestion Control in TCP?',
  '["Flow control prevents the sender from overwhelming the receiver buffer; congestion control prevents all senders from overwhelming intermediate network links and routers.","Flow control is in UDP; congestion control is in TCP.","Flow control manages IP routing; congestion control manages MAC addresses.","There is no difference."]'::jsonb,
  0,
  10,
  'Flow control is an end-to-end mechanism based on receiver advertised window (rwnd); congestion control dynamically adjusts to network bottleneck capacity.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000021'::UUID,
  'd0000000-0000-0000-0207-000000000003'::UUID,
  'What is the Additive Increase Multiplicative Decrease (AIMD) algorithm''s response when packet loss occurs in Congestion Avoidance?',
  '["Halve the congestion window (Multiplicative Decrease).","Reset the congestion window to 0.","Double the congestion window.","Increase the time quantum by 10ms."]'::jsonb,
  0,
  10,
  'AIMD cuts the congestion window in half upon packet loss (multiplicative decrease) and increases it by 1 MSS per RTT when successful (additive increase).',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000022'::UUID,
  'd0000000-0000-0000-0207-000000000004'::UUID,
  'How many usable host IP addresses are available in a subnet with prefix length /28?',
  '["14","16","30","6"]'::jsonb,
  0,
  10,
  'Host bits = 32 - 28 = 4. Total IPs = 2^4 = 16. Usable host addresses = 16 - 2 (network ID & broadcast) = 14.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000023'::UUID,
  'd0000000-0000-0000-0207-000000000004'::UUID,
  'What is the directed broadcast address for the subnet containing IP 192.168.1.100 with mask 255.255.255.192 (/26)?',
  '["192.168.1.127","192.168.1.255","192.168.1.63","192.168.1.128"]'::jsonb,
  0,
  10,
  'Block size is 64. Subnet ranges are 0-63, 64-127. IP 192.168.1.100 belongs to the 192.168.1.64 network; its broadcast address is 192.168.1.127.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000024'::UUID,
  'd0000000-0000-0000-0207-000000000004'::UUID,
  'Which routing protocol uses Dijkstra''s algorithm to compute shortest path trees over a full topology link-state database?',
  '["OSPF (Open Shortest Path First)","RIP (Routing Information Protocol)","BGP (Border Gateway Protocol)","EGP"]'::jsonb,
  0,
  10,
  'OSPF routers exchange link-state advertisements (LSAs) and run Dijkstra''s algorithm independently to find the shortest path tree.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000025'::UUID,
  'd0000000-0000-0000-0207-000000000004'::UUID,
  'Which IP address range is designated as private and unroutable on the public Internet under RFC 1918?',
  '["10.0.0.0/8","11.0.0.0/8","128.0.0.0/16","200.1.1.0/24"]'::jsonb,
  0,
  10,
  'RFC 1918 defines private address blocks: 10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000026'::UUID,
  'd0000000-0000-0000-0207-000000000004'::UUID,
  'What routing metric limitation in the Routing Information Protocol (RIP) causes it to be unsuitable for large networks?',
  '["Maximum hop count limit of 15 (16 represents infinity/unreachable).","Inability to run over Ethernet.","Requirement for dedicated fiber lines.","Lack of UDP support."]'::jsonb,
  0,
  10,
  'RIP uses hop count as its sole metric and caps path lengths at 15 hops to prevent infinite loops, restricting its use to small networks.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000027'::UUID,
  'd0000000-0000-0000-0207-000000000004'::UUID,
  'What protocol acts as the primary de facto exterior gateway routing protocol connecting Autonomous Systems across the Internet?',
  '["BGP (Border Gateway Protocol)","OSPF","RIP","IS-IS"]'::jsonb,
  0,
  10,
  'BGP is the standardized Exterior Gateway Protocol that exchanges routing and reachability information among Autonomous Systems globally.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0307-000000000028'::UUID,
  'd0000000-0000-0000-0207-000000000004'::UUID,
  'What does a router decrement in the IPv4 header before forwarding a packet, dropping the packet if it reaches zero?',
  '["Time to Live (TTL)","Checksum","Fragment Offset","Header Length"]'::jsonb,
  0,
  10,
  'Every router decrements the 8-bit TTL field by at least 1; if TTL reaches 0, the router discards the packet and sends an ICMP Time Exceeded message, preventing routing loops.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000001'::UUID,
  'd0000000-0000-0000-0208-000000000001'::UUID,
  'What Scrum role is responsible for maximizing product value and managing the prioritized Product Backlog?',
  '["Scrum Master","Product Owner","Lead Developer","Agile Coach"]'::jsonb,
  1,
  10,
  'The Product Owner is solely responsible for defining user stories, ordering the product backlog, and optimizing business value delivered by the Scrum team.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000002'::UUID,
  'd0000000-0000-0000-0208-000000000001'::UUID,
  'Which software development process model places formal, iterative risk analysis at the core of each developmental cycle?',
  '["Waterfall Model","Spiral Model (Boehm)","V-Model","Extreme Programming"]'::jsonb,
  1,
  10,
  'Barry Boehm''s Spiral Model combines iterative prototyping with formal risk evaluation phases before committing to major engineering phases.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000003'::UUID,
  'd0000000-0000-0000-0208-000000000001'::UUID,
  'What is the primary objective of the Sprint Retrospective ceremony in Scrum?',
  '["To inspect team processes, collaboration, and tools, and identify actionable improvements for future sprints.","To demo completed features to stakeholders.","To assign daily tasks to engineers.","To renegotiate team member salaries."]'::jsonb,
  0,
  10,
  'The Sprint Retrospective occurs at the end of every sprint for the Scrum team to inspect how the sprint went and create a plan for continuous improvement.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000004'::UUID,
  'd0000000-0000-0000-0208-000000000001'::UUID,
  'What does the Agile Manifesto declare as more valuable than "comprehensive documentation"?',
  '["Processes and tools","Working software","Contract negotiation","Following a plan"]'::jsonb,
  1,
  10,
  'The Agile Manifesto values "Working software over comprehensive documentation" while still acknowledging the value of documentation.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000005'::UUID,
  'd0000000-0000-0000-0208-000000000001'::UUID,
  'In Scrum, what metric represents the amount of work (in story points) a development team completes during a typical sprint?',
  '["Burnup Rate","Velocity","Lead Time","Cycle Interval"]'::jsonb,
  1,
  10,
  'Velocity is the measure of the quantity of work completed per sprint, used by teams to estimate how much backlog can be committed in future sprints.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000006'::UUID,
  'd0000000-0000-0000-0208-000000000001'::UUID,
  'What is a key risk of the traditional Waterfall model when applied to projects with ambiguous, rapidly shifting requirements?',
  '["Defects and fundamental design flaws may remain undetected until late integration and testing phases, making remediation extremely costly.","It requires too many daily meetings.","It does not allow writing documentation.","It forces developers to deploy multiple times per day."]'::jsonb,
  0,
  10,
  'Waterfall delays verification and client validation until the final stages, creating catastrophic risk if requirements were misunderstood at the beginning.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000007'::UUID,
  'd0000000-0000-0000-0208-000000000001'::UUID,
  'What is the time-boxed duration of a standard Daily Scrum (Standup) meeting?',
  '["15 minutes","1 hour","45 minutes","5 minutes"]'::jsonb,
  0,
  10,
  'The Daily Scrum is time-boxed to 15 minutes to synchronize daily activities and identify impediments without devolving into architectural debates.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000008'::UUID,
  'd0000000-0000-0000-0208-000000000002'::UUID,
  'Which of the following is a Non-Functional Requirement (NFR)?',
  '["The system shall compute student final percentages.","The database API response time shall not exceed 250 milliseconds under 2,000 concurrent requests.","The application shall allow users to upload PDF assignments.","The system shall email password reset tokens."]'::jsonb,
  1,
  10,
  'Performance, response time, and concurrency constraints describe system quality attributes (Non-Functional Requirements) rather than specific feature behavior.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000009'::UUID,
  'd0000000-0000-0000-0208-000000000002'::UUID,
  'What does the "T" stand for in the INVEST user story evaluation framework?',
  '["Time-boxed","Testable","Technical","Traceable"]'::jsonb,
  1,
  10,
  'INVEST stands for Independent, Negotiable, Valuable, Estimable, Small, and Testable.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000010'::UUID,
  'd0000000-0000-0000-0208-000000000002'::UUID,
  'What observation does Conway''s Law express regarding software architecture?',
  '["Organizations design systems that mirror their own communication and organizational structures.","Software code doubles in size every two years.","Testing always finds defects.","Databases always become the bottleneck."]'::jsonb,
  0,
  10,
  'Conway''s Law states: "Organizations which design systems are constrained to produce designs which are copies of the communication structures of these organizations."',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000011'::UUID,
  'd0000000-0000-0000-0208-000000000002'::UUID,
  'What is a major architectural disadvantage of migrating from a monolith to microservices?',
  '["Increased operational complexity, network latency, distributed data consistency challenges, and complex cross-service debugging.","Microservices prevent horizontal scaling.","Microservices do not support databases.","Microservices cannot be written in modern languages."]'::jsonb,
  0,
  10,
  'Microservices introduce distributed systems challenges: partial failures, network latency, tracing across services, and eventual consistency.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000012'::UUID,
  'd0000000-0000-0000-0208-000000000002'::UUID,
  'What is the purpose of an API Gateway in a microservices architecture?',
  '["Acts as a single entry point that routes client requests, terminates TLS, enforces authentication, and aggregates responses.","Replaces the relational database.","Compiles frontend TypeScript code into binary.","Monitors physical CPU temperature."]'::jsonb,
  0,
  10,
  'An API Gateway shields internal microservices from external clients, managing cross-cutting concerns like SSL termination, rate limiting, and routing.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000013'::UUID,
  'd0000000-0000-0000-0208-000000000002'::UUID,
  'What standard format is widely used for specifying behavioral acceptance criteria in BDD (Behavior-Driven Development)?',
  '["Given-When-Then (Gherkin syntax)","Try-Catch-Finally","If-Else-Endif","Class-Method-Property"]'::jsonb,
  0,
  10,
  'Gherkin uses Given (context), When (action), and Then (expected outcome) to define unambiguous executable requirements.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000014'::UUID,
  'd0000000-0000-0000-0208-000000000002'::UUID,
  'What IEEE standard document provides guidelines for authoring Software Requirements Specifications (SRS)?',
  '["IEEE 830","IEEE 754","IEEE 802.11","IEEE 1003.1"]'::jsonb,
  0,
  10,
  'IEEE 830 is the established standard recommended practice for software requirements specifications.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000015'::UUID,
  'd0000000-0000-0000-0208-000000000003'::UUID,
  'What does the Open/Closed Principle (OCP) mandate for software entities?',
  '["Classes should be open for extension, but closed for modification.","All source code must be open source.","Files should be closed after writing.","Methods should accept an open number of arguments."]'::jsonb,
  0,
  10,
  'The Open/Closed Principle states that software entities (classes, modules) should be extensible without modifying their existing tested source code.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000016'::UUID,
  'd0000000-0000-0000-0208-000000000003'::UUID,
  'What violation of the Liskov Substitution Principle (LSP) is famously illustrated by the Rectangle-Square problem?',
  '["A Square subclass alters the behavior of setWidth/setHeight in a way that breaks invariants expected of a Rectangle superclass.","Square inherits too many methods.","Rectangle cannot be instantiated.","A Square has four sides while a Rectangle has two."]'::jsonb,
  0,
  10,
  'Making Square extend Rectangle violates LSP because setting width on a Square modifies height as a side-effect, violating the Rectangle invariant.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000017'::UUID,
  'd0000000-0000-0000-0208-000000000003'::UUID,
  'What does the Dependency Inversion Principle (DIP) state regarding high-level and low-level modules?',
  '["High-level modules should not depend on low-level modules; both should depend on abstractions (interfaces).","Subclasses must invert parent methods.","Database tables should not reference foreign keys.","Frontend modules should directly invoke database drivers."]'::jsonb,
  0,
  10,
  'DIP decouples high-level business policy from low-level implementation details by introducing interfaces that both layers depend upon.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000018'::UUID,
  'd0000000-0000-0000-0208-000000000003'::UUID,
  'What is the primary indicator that a class violates the Single Responsibility Principle (SRP)?',
  '["The class has multiple distinct actors or stakeholders who could request changes for different business reasons.","The class contains more than 10 lines of code.","The class implements an interface.","The class contains unit tests."]'::jsonb,
  0,
  10,
  'SRP states that a class should have one, and only one, reason to change (meaning it is responsible to only one actor).',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000019'::UUID,
  'd0000000-0000-0000-0208-000000000003'::UUID,
  'What does the Interface Segregation Principle (ISP) advise against?',
  '["Creating \"fat\" monolithic interfaces that force implementing classes to provide dummy implementations for methods they do not need.","Using multiple interfaces in one class.","Using TypeScript.","Documenting interface contracts."]'::jsonb,
  0,
  10,
  'ISP states that many client-specific interfaces are better than one general-purpose interface, preventing clients from depending on unused methods.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000020'::UUID,
  'd0000000-0000-0000-0208-000000000003'::UUID,
  'What design pattern injects concrete dependencies into a class via its constructor rather than having the class instantiate them directly?',
  '["Dependency Injection (DI)","Singleton Pattern","Prototype Pattern","Adapter Pattern"]'::jsonb,
  0,
  10,
  'Dependency Injection passes required dependencies through constructors or setters, fulfilling the Dependency Inversion Principle.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000021'::UUID,
  'd0000000-0000-0000-0208-000000000003'::UUID,
  'What code smell occurs when a change to a single class forces cascading edits across dozens of unrelated classes?',
  '["Shotgun Surgery","Long Method","Feature Envy","Data Clumps"]'::jsonb,
  0,
  10,
  'Shotgun Surgery is the code smell where a single conceptual modification requires making small changes to many different classes across the codebase.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000022'::UUID,
  'd0000000-0000-0000-0208-000000000004'::UUID,
  'What test double provides pre-programmed canned answers to method calls during a test, but does not verify whether the calls occurred?',
  '["Stub","Mock","Spy","Dummy"]'::jsonb,
  0,
  10,
  'A Stub provides canned answers to calls made during the test; a Mock sets expectations on the calls themselves and verifies interactions.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000023'::UUID,
  'd0000000-0000-0000-0208-000000000004'::UUID,
  'What is the correct sequence of phases in the Test-Driven Development (TDD) cycle?',
  '["Red (failing test) -> Green (passing code) -> Refactor (clean code)","Green -> Red -> Refactor","Refactor -> Green -> Red","Code -> Test -> Deploy"]'::jsonb,
  0,
  10,
  'TDD follows Red-Green-Refactor: write a failing test first, write minimal code to pass the test, then refactor.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000024'::UUID,
  'd0000000-0000-0000-0208-000000000004'::UUID,
  'If a conditional statement "if (A && B)" is executed in code, what test coverage metric ensures that both the True and False outcomes of the decision were evaluated?',
  '["Branch / Decision Coverage","Statement Coverage","Line Coverage","Feature Coverage"]'::jsonb,
  0,
  10,
  'Branch coverage requires every decision point (e.g. if statement) to evaluate to both True and False at least once.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000025'::UUID,
  'd0000000-0000-0000-0208-000000000004'::UUID,
  'How does Boundary Value Analysis (BVA) test a field that accepts a percentage integer between 0 and 100 inclusive?',
  '["Tests values at and immediately surrounding the bounds: -1, 0, 1, 99, 100, 101.","Tests only 0 and 100.","Tests any 3 random numbers like 42, 57, 88.","Tests only negative numbers."]'::jsonb,
  0,
  10,
  'BVA evaluates exact boundary values plus their immediate neighbors on either side of the valid range: -1, 0, 1 and 99, 100, 101.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000026'::UUID,
  'd0000000-0000-0000-0208-000000000004'::UUID,
  'What is a Blue-Green deployment strategy in continuous delivery?',
  '["Maintaining two identical production environments, deploying the new release to the inactive environment, validating, and cutting traffic over with near-zero downtime.","Deploying only to users with blue screen monitors.","Deploying on alternate days of the week.","Running code without compiling."]'::jsonb,
  0,
  10,
  'Blue-Green deployments maintain two identical production stacks, switching traffic instantly via load balancer to eliminate deployment downtime.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000027'::UUID,
  'd0000000-0000-0000-0208-000000000004'::UUID,
  'What formula expresses McCabe''s Cyclomatic Complexity V(G) for a control flow graph with E edges, N nodes, and P connected components?',
  '["V(G) = E - N + 2P","V(G) = N - E + P","V(G) = E * N / 2","V(G) = E + N - P"]'::jsonb,
  0,
  10,
  'McCabe''s Cyclomatic Complexity is computed as V(G) = E - N + 2P, defining the number of linearly independent paths through the program.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0308-000000000028'::UUID,
  'd0000000-0000-0000-0208-000000000004'::UUID,
  'What testing pattern organizes unit tests into three distinct sections?',
  '["Arrange, Act, Assert (AAA)","Initialize, Execute, Terminate","Given, When, If","Compile, Link, Run"]'::jsonb,
  0,
  10,
  'The AAA pattern structures unit tests cleanly: Arrange (set up inputs and mocks), Act (call the target function), Assert (verify results).',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000001'::UUID,
  'd0000000-0000-0000-0209-000000000001'::UUID,
  'Which environment classification best characterizes automated stock trading?',
  '["Partially observable, stochastic, dynamic, continuous","Fully observable, deterministic, static, discrete","Partially observable, deterministic, static, discrete","Fully observable, stochastic, dynamic, episodic"]'::jsonb,
  0,
  1,
  'Financial markets involve hidden insider states (partially observable), unpredictable external events (stochastic), time-dependent price changes while deciding (dynamic), and real-valued capital/pricing states (continuous).',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000002'::UUID,
  'd0000000-0000-0000-0209-000000000001'::UUID,
  'What is the principal disadvantage of Breadth-First Search (BFS) compared to Depth-First Search (DFS)?',
  '["BFS cannot find the optimal solution in unweighted graphs","BFS memory requirement scales exponentially as O(b^d)","BFS gets trapped in infinite depth loops","BFS has higher asymptotic time complexity than DFS in finite trees"]'::jsonb,
  1,
  1,
  'BFS retains the entire frontier at depth d in memory, requiring O(b^d) space. In contrast, DFS requires only O(bm) linear space.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000003'::UUID,
  'd0000000-0000-0000-0209-000000000001'::UUID,
  'When is Uniform Cost Search (UCS) mathematically guaranteed to be complete and optimal?',
  '["Only if all edge costs are strictly equal to 1","When all edge costs are non-negative and bounded below by a positive epsilon","When the graph contains no cycles","Only when guided by an admissible heuristic function"]'::jsonb,
  1,
  1,
  'UCS requires step costs to satisfy c(s, a, s'') >= eps > 0 to guarantee that paths with infinite steps cannot accumulate finite total costs.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000004'::UUID,
  'd0000000-0000-0000-0209-000000000001'::UUID,
  'What makes Iterative Deepening Search (IDS) desirable for large state spaces with unknown goal depth?',
  '["It computes heuristic estimates automatically","It uses O(1) constant working memory","It combines BFS completeness and shallow-path optimality with DFS linear space O(bd)","It eliminates the need to visit intermediate states more than once"]'::jsonb,
  2,
  1,
  'IDS runs successive depth-limited searches. It achieves optimal path discovery in uniform step cost graphs while keeping memory bounded to O(bd).',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000005'::UUID,
  'd0000000-0000-0000-0209-000000000001'::UUID,
  'In a search tree with branching factor b=4 and goal at depth d=3, how many nodes does BFS store in the frontier at maximum in the worst case?',
  '["12","16","64","256"]'::jsonb,
  2,
  1,
  'At depth d=3, the number of leaf nodes in the frontier is b^d = 4^3 = 64 nodes.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000006'::UUID,
  'd0000000-0000-0000-0209-000000000001'::UUID,
  'Which node in the frontier does Uniform Cost Search expand next?',
  '["The node with the smallest cumulative cost g(n) from the start state","The node with the largest number of children","The most recently inserted node into the queue","The node with the lowest estimated remaining cost h(n)"]'::jsonb,
  0,
  1,
  'UCS selects the frontier node with minimum cumulative path cost g(n) using a min-priority queue.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000007'::UUID,
  'd0000000-0000-0000-0209-000000000001'::UUID,
  'Why does Depth-First Graph Search maintain an explored set?',
  '["To guarantee finding the optimal cost path","To prevent infinite loops caused by cyclic paths in graphs","To sort nodes by heuristic value","To eliminate the need for a recursion stack"]'::jsonb,
  1,
  1,
  'In cyclic graphs, DFS can cycle indefinitely between previously visited states unless an explored set or cycle-checking filter is applied.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000008'::UUID,
  'd0000000-0000-0000-0209-000000000002'::UUID,
  'What condition defines an admissible heuristic h(n)?',
  '["h(n) >= h*(n) for all nodes n","0 <= h(n) <= h*(n) where h*(n) is the true optimal cost to goal","h(n) is strictly monotonically increasing along every edge","h(n) equals 0 for all non-goal states"]'::jsonb,
  1,
  1,
  'An admissible heuristic never overestimates the true remaining distance or cost to reach the nearest goal.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000009'::UUID,
  'd0000000-0000-0000-0209-000000000002'::UUID,
  'What mathematical property ensures A* graph search finds the optimal path without re-expanding closed nodes?',
  '["Completeness","Admissibility alone","Consistency (Monotonicity): h(n) <= c(n, a, n'') + h(n'')","Strict convexity of the evaluation function f(n)"]'::jsonb,
  2,
  1,
  'Consistency enforces the triangle inequality on heuristics. It guarantees that f(n) is non-decreasing along paths, so the first time a node is popped from the frontier, its optimal g(n) is finalized.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000010'::UUID,
  'd0000000-0000-0000-0209-000000000002'::UUID,
  'If heuristic h2 dominates h1 (both are admissible and h2(n) >= h1(n) for all n), what is true?',
  '["A* with h1 will expand fewer or equal nodes compared to h2","A* with h2 will expand a subset of the nodes expanded by A* with h1","h2 is inadmissible because its values are larger","h2 requires exponential memory compared to h1"]'::jsonb,
  1,
  1,
  'A higher admissible estimate is closer to the true cost h*(n), pruning more search space and never expanding more nodes than the weaker heuristic.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000011'::UUID,
  'd0000000-0000-0000-0209-000000000002'::UUID,
  'What does A* evaluation function f(n) represent?',
  '["The total cost from the start node to the current node g(n)","The heuristic estimate to the nearest obstacle","The estimated total cost of the cheapest solution path through node n: f(n) = g(n) + h(n)","The probability that node n leads to a terminal failure"]'::jsonb,
  2,
  1,
  'f(n) estimates the total cost of the full path from start to goal passing through node n: f(n) = g(n) + h(n).',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000012'::UUID,
  'd0000000-0000-0000-0209-000000000002'::UUID,
  'For 2D grid navigation with 4-directional movement (up, down, left, right), which heuristic is standard and admissible?',
  '["Euclidean distance","Manhattan distance","Chebyshev distance","Squared Euclidean distance"]'::jsonb,
  1,
  1,
  'In 4-connected grid navigation, Manhattan distance |x1-x2| + |y1-y2| represents the exact shortest distance without obstacles, making it admissible and consistent.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000013'::UUID,
  'd0000000-0000-0000-0209-000000000002'::UUID,
  'If an A* heuristic is defined as h(n) = 0 for all nodes, what standard algorithm does A* reduce to?',
  '["Depth-First Search","Greedy Best-First Search","Uniform Cost Search (Dijkstra''s algorithm)","Iterative Deepening Search"]'::jsonb,
  2,
  1,
  'When h(n) = 0, f(n) = g(n) + 0 = g(n), meaning nodes are ordered strictly by cumulative path cost g(n), which is Uniform Cost Search.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000014'::UUID,
  'd0000000-0000-0000-0209-000000000002'::UUID,
  'What occurs if Greedy Best-First Search is used (f(n) = h(n))?',
  '["It guarantees the shortest cost path to the goal","It is incomplete in cyclic graphs and can be led astray by misleading heuristic values","It behaves identically to Breadth-First Search","It always explores fewer nodes than optimal A*"]'::jsonb,
  1,
  1,
  'Greedy Best-First Search ignores cumulative cost g(n), evaluating only h(n). It can chase deep false paths and is neither optimal nor complete on graphs without cycle checking.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000015'::UUID,
  'd0000000-0000-0000-0209-000000000003'::UUID,
  'In the Minimax algorithm with Alpha-Beta pruning, when does a beta cutoff occur during MAX node evaluation?',
  '["When alpha exceeds beta (alpha >= beta)","When beta reaches positive infinity","When utility is zero","When the search depth is an even number"]'::jsonb,
  0,
  1,
  'A cutoff occurs whenever alpha >= beta because the MIN player at a higher parent choice has already secured a path resulting in <= beta, and MAX will never permit a score >= alpha to be chosen.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000016'::UUID,
  'd0000000-0000-0000-0209-000000000003'::UUID,
  'With perfect move ordering, what is the effective time complexity of Alpha-Beta pruning to depth m with branching factor b?',
  '["O(b^m)","O(b^(m/2))","O(m * log(b))","O(b * m)"]'::jsonb,
  1,
  1,
  'Under optimal move ordering (best moves inspected first), Alpha-Beta evaluates O(b^(m/2)) leaf nodes, effectively doubling the search depth compared to basic Minimax.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000017'::UUID,
  'd0000000-0000-0000-0209-000000000003'::UUID,
  'What is the horizon effect in heuristic game tree search?',
  '["The game board dimensions changing dynamically","An unavoidable catastrophic move being delayed just beyond the fixed search depth limit","The evaluation function assigning identical scores to all leaves","Alpha and beta values becoming equal at the root"]'::jsonb,
  1,
  1,
  'The horizon effect occurs when a fixed-depth search pushes a serious negative event just beyond the search horizon through stalling moves, giving a false impression of safety.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000018'::UUID,
  'd0000000-0000-0000-0209-000000000003'::UUID,
  'How does Quiescence Search address tactical instability at leaf nodes?',
  '["By restarting the game from the initial state","By continuing search beyond depth limit only for non-quiet positions (e.g. captures/checks)","By randomly sampling terminal rollouts","By pruning branches where evaluation changes sign"]'::jsonb,
  1,
  1,
  'Quiescence search expands captures and volatile moves until a quiet position is reached, avoiding misleading evaluations in the middle of piece exchanges.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000019'::UUID,
  'd0000000-0000-0000-0209-000000000003'::UUID,
  'What mathematical property characterizes a zero-sum two-player game?',
  '["Both players receive equal positive rewards at the end","Utility(Player1) + Utility(Player2) = 0 (or a constant)","No player can ever lose points","The game cannot terminate in a draw"]'::jsonb,
  1,
  1,
  'In zero-sum games, any advantage or payoff gained by one player represents an equal loss for the opposing player.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000020'::UUID,
  'd0000000-0000-0000-0209-000000000003'::UUID,
  'What are the initial values passed to alpha and beta at the root of a Minimax search?',
  '["alpha = 0, beta = 0","alpha = +infinity, beta = -infinity","alpha = -infinity, beta = +infinity","alpha = -1, beta = 1"]'::jsonb,
  2,
  1,
  'At the root, MAX has guaranteed at least -infinity (alpha), and MIN has guaranteed at most +infinity (beta).',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000021'::UUID,
  'd0000000-0000-0000-0209-000000000003'::UUID,
  'Why does Transposition Table caching significantly improve game tree search performance?',
  '["It changes the game rules to reduce branching factor","Different sequences of moves often reach identical board configurations (transpositions)","It eliminates the need for terminal state checks","It replaces Minimax with linear programming"]'::jsonb,
  1,
  1,
  'Transposition tables store evaluations of previously visited board states reached via different permutations of move orders, preventing duplicate subtree searches.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000022'::UUID,
  'd0000000-0000-0000-0209-000000000004'::UUID,
  'What does the Minimum Remaining Values (MRV) heuristic choose in backtracking CSP search?',
  '["The value that constrains the fewest neighbors","The unassigned variable with the fewest allowable values in its domain","The variable with the highest degree in the constraint graph","The variable that was most recently backtracked"]'::jsonb,
  1,
  1,
  'MRV picks the most constrained variable (fewest remaining legal values), failing early if no valid assignment is possible.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000023'::UUID,
  'd0000000-0000-0000-0209-000000000004'::UUID,
  'In the AC-3 arc consistency algorithm, when is an arc (Xi, Xj) revised?',
  '["By removing values from Xi''s domain that have no supporting value in Xj","By setting Xi equal to Xj","By sorting domains in lexicographical order","By pruning all variables connected to Xj"]'::jsonb,
  0,
  1,
  'Revise(Xi, Xj) eliminates any value x in Di for which no value y in Dj satisfies the binary constraint between Xi and Xj.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000024'::UUID,
  'd0000000-0000-0000-0209-000000000004'::UUID,
  'What is the logical resolution rule equivalent to in refutation proofs?',
  '["Proving KB |= alpha by demonstrating that KB and not(alpha) derives a contradiction (empty clause)","Checking if truth table has all true values","Factoring sentences into disjunctive normal form","Converting first-order logic into Horn clauses"]'::jsonb,
  0,
  1,
  'Resolution refutation assumes the negation of the query sentence and repeatedly applies resolution until an empty clause (contradiction) is derived.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000025'::UUID,
  'd0000000-0000-0000-0209-000000000004'::UUID,
  'In a Bayesian Network, how is the joint probability distribution P(X1, ..., Xn) factorized?',
  '["Sum of all marginal probabilities","Product of P(Xi | Parents(Xi)) for all i from 1 to n","Product of all unconditional independent probabilities","Ratio of evidence over prior priors"]'::jsonb,
  1,
  1,
  'By applying conditional independence assertions of the DAG, P(X1, ..., Xn) = product_{i=1}^n P(Xi | Parents(Xi)).',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000026'::UUID,
  'd0000000-0000-0000-0209-000000000004'::UUID,
  'In a collider network structure (X -> Z <- Y), what happens to the relationship between X and Y when Z (or a descendant of Z) is observed?',
  '["X and Y become conditionally independent","X and Y become dependent (explaining away phenomenon)","The conditional probability of Z becomes 0","The direction of the arrows reverses"]'::jsonb,
  1,
  1,
  'Unlike chain or fork structures, in a collider (v-structure), observing the common effect Z renders the previously independent causes X and Y conditionally dependent.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000027'::UUID,
  'd0000000-0000-0000-0209-000000000004'::UUID,
  'What is a Horn clause in propositional logic?',
  '["A clause with at most one positive (unnegated) literal","A sentence with exactly two biconditionals","A clause where all literals are negated","A formula containing existential quantifiers"]'::jsonb,
  0,
  1,
  'A Horn clause contains at most one positive literal (e.g. not(A) or not(B) or C, equivalent to A and B -> C), permitting linear-time forward and backward chaining inference.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0309-000000000028'::UUID,
  'd0000000-0000-0000-0209-000000000004'::UUID,
  'Which heuristic helps choose the order of values to assign to a variable in CSP search?',
  '["Minimum Remaining Values (MRV)","Degree Heuristic","Least Constraining Value (LCV)","Depth-First Heuristic"]'::jsonb,
  2,
  1,
  'Once a variable is selected, Least Constraining Value orders its domain values by which value rules out the fewest choices for neighboring variables.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000001'::UUID,
  'd0000000-0000-0000-0210-000000000001'::UUID,
  'What is the primary computational disadvantage of Batch Gradient Descent compared to Mini-batch SGD on large datasets?',
  '["Batch GD gradients have high stochastic variance","Batch GD requires processing the entire dataset to compute a single parameter update","Batch GD cannot be used with convex loss functions","Batch GD requires a different learning rate for every single feature"]'::jsonb,
  1,
  1,
  'Batch Gradient Descent computes gradients across all N training samples per step, making each parameter update slow and memory-intensive for large datasets.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000002'::UUID,
  'd0000000-0000-0000-0210-000000000001'::UUID,
  'Which loss function is most robust to extreme outliers in regression tasks?',
  '["Mean Squared Error (L2 Loss)","Mean Absolute Error (L1 Loss)","Categorical Cross-Entropy","Hinge Loss"]'::jsonb,
  1,
  1,
  'L1 loss grows linearly with error magnitude |y - y_hat|, whereas L2 error squares the difference, heavily magnifying the influence of large outliers on the gradient.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000003'::UUID,
  'd0000000-0000-0000-0210-000000000001'::UUID,
  'What occurs if the learning rate eta in gradient descent is chosen excessively large?',
  '["The model converges instantaneously to the global minimum","Parameter updates oscillate wildly and may diverge to infinity","The model behaves identically to stochastic gradient descent","Weights automatically shrink to zero"]'::jsonb,
  1,
  1,
  'An overly large learning rate causes step sizes to overshoot the valleys of the loss surface, oscillating and diverging.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000004'::UUID,
  'd0000000-0000-0000-0210-000000000001'::UUID,
  'What is the range of output values produced by the logistic sigmoid activation function sigma(z)?',
  '["[-1, 1]","[0, 1]","(-infinity, +infinity)","[0, +infinity)"]'::jsonb,
  1,
  1,
  'The sigmoid function sigma(z) = 1 / (1 + exp(-z)) maps any real input to the open interval (0, 1), representing valid probabilities.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000005'::UUID,
  'd0000000-0000-0000-0210-000000000001'::UUID,
  'In linear regression, what mathematical condition prevents computing the Normal Equation solution theta = (X^T X)^(-1) X^T y?',
  '["When N > D","When feature columns in X are linearly dependent (causing X^T X to be non-invertible / singular)","When all targets y are strictly positive","When the loss function is convex"]'::jsonb,
  1,
  1,
  'If features are collinear or D > N, matrix X^T X is rank-deficient and singular, meaning its determinant is zero and its inverse does not exist.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000006'::UUID,
  'd0000000-0000-0000-0210-000000000001'::UUID,
  'What optimization technique adaptively maintains exponentially decaying moving averages of past gradients and squared gradients?',
  '["Standard SGD","Newton-Raphson Method","Adam (Adaptive Moment Estimation)","Coordinate Descent"]'::jsonb,
  2,
  1,
  'Adam computes individual adaptive learning rates for different parameters from estimates of first and second raw moments of gradients.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000007'::UUID,
  'd0000000-0000-0000-0210-000000000001'::UUID,
  'What happens when features are not scaled before running gradient descent on linear regression?',
  '["The loss surface becomes highly elongated (elliptical), slowing convergence due to zig-zagging gradients","The loss function becomes non-convex","The model cannot make predictions on test data","The Normal Equation becomes inaccurate"]'::jsonb,
  0,
  1,
  'Unscaled features produce distorted, eccentric loss contours where gradients point perpendicular to the direction of the minimum, requiring smaller learning rates and more iterations.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000008'::UUID,
  'd0000000-0000-0000-0210-000000000002'::UUID,
  'A model has very low training error (0.5%) but high test error (24.0%). What problem does this indicate?',
  '["High bias (underfitting)","High variance (overfitting)","High irreducible noise","Zero generalization gap"]'::jsonb,
  1,
  1,
  'A large disparity between excellent training performance and poor test performance characterizes high variance (overfitting), where the model memorizes sample-specific noise.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000009'::UUID,
  'd0000000-0000-0000-0210-000000000002'::UUID,
  'What is the distinguishing property of Lasso (L1) regularization compared to Ridge (L2)?',
  '["Lasso induces exact sparsity in the weight vector by driving non-informative coefficients to 0","Lasso is differentiable everywhere including at 0","Lasso always produces smaller training error than unregularized models","Lasso preserves all feature coefficients equally"]'::jsonb,
  0,
  1,
  'The diamond-shaped L1 norm constraint contours intersect the loss ellipses at the coordinate axes, forcing less important feature weights to exactly zero.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000010'::UUID,
  'd0000000-0000-0000-0210-000000000002'::UUID,
  'How does increasing the regularization penalty lambda affect model bias and variance?',
  '["Increases variance, decreases bias","Decreases variance, increases bias","Decreases both bias and variance simultaneously","Has no effect on either bias or variance"]'::jsonb,
  1,
  1,
  'Increasing lambda restricts parameter flexibility, reducing model variance (overfitting) at the expense of introducing higher bias (underfitting).',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000011'::UUID,
  'd0000000-0000-0000-0210-000000000002'::UUID,
  'Which technique provides the most reliable estimate of generalization performance on modest datasets?',
  '["Evaluating solely on the training set","K-Fold Cross-Validation","Setting test size to 99% of data","Zero-shot heuristic scoring"]'::jsonb,
  1,
  1,
  'K-Fold Cross-Validation trains and validates across K distinct partitions, ensuring every data point is tested out-of-fold and reducing evaluation variance.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000012'::UUID,
  'd0000000-0000-0000-0210-000000000002'::UUID,
  'What is the closed-form solution for Ridge regression parameter estimation?',
  '["theta = (X^T X)^(-1) X^T y","theta = (X^T X + lambda * I)^(-1) X^T y","theta = (X + lambda * I)^(-1) y","theta = X^T (X X^T + lambda * I)^(-1) y"]'::jsonb,
  1,
  1,
  'Adding lambda * I to X^T X shifts all eigenvalues positively, ensuring invertibility even when features are collinear.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000013'::UUID,
  'd0000000-0000-0000-0210-000000000002'::UUID,
  'Which method can directly help mitigate high bias in an underfitting machine learning model?',
  '["Adding more training examples without changing the model architecture","Increasing L2 regularization weight lambda","Adding polynomial feature combinations or increasing model capacity","Pruning the top levels of decision trees"]'::jsonb,
  2,
  1,
  'High bias stems from an overly simplistic hypothesis class. Expanding feature representations or using more expressive models directly relieves underfitting.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000014'::UUID,
  'd0000000-0000-0000-0210-000000000002'::UUID,
  'What does the irreducible error term sigma^2 represent in the bias-variance decomposition?',
  '["The variance introduced by suboptimal learning rates","The inherent stochastic noise in the data generating process that cannot be eliminated by any model","The error caused by missing regularization parameters","The difference between train and test loss"]'::jsonb,
  1,
  1,
  'Irreducible error is the lower bound on expected error arising from unobserved variables or fundamental randomness in the underlying system.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000015'::UUID,
  'd0000000-0000-0000-0210-000000000003'::UUID,
  'What metric does the CART algorithm use by default to determine feature splits in classification trees?',
  '["Gini Impurity","Shannon Entropy","Mean Squared Error","Adjusted R-squared"]'::jsonb,
  0,
  1,
  'The CART (Classification and Regression Trees) algorithm uses Gini Impurity for categorical splits and Mean Squared Error for continuous regression splits.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000016'::UUID,
  'd0000000-0000-0000-0210-000000000003'::UUID,
  'Why do Random Forests choose random subsets of features at each node split rather than considering all features?',
  '["To speed up computation only","To decorrelate individual trees in the ensemble, maximizing variance reduction when averaging","To make trees deeper and more prone to memorization","To enforce sparsity in tree weights"]'::jsonb,
  1,
  1,
  'If one or two dominant features exist, standard bagging produces correlated trees that make identical splits. Subspace sampling decorrelates trees, improving ensemble variance reduction.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000017'::UUID,
  'd0000000-0000-0000-0210-000000000003'::UUID,
  'How does Gradient Boosting train new trees at each iteration?',
  '["By training each tree independently on random subsets of the data in parallel","By fitting the new tree to the negative gradient (pseudo-residuals) of the cumulative ensemble loss","By taking the majority vote of previously trained trees","By training an SVM on the tree leaves"]'::jsonb,
  1,
  1,
  'Gradient boosting sequentially optimizes an arbitrary differentiable loss function by training base learners to predict the negative gradient of the current ensemble.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000018'::UUID,
  'd0000000-0000-0000-0210-000000000003'::UUID,
  'What points in the dataset determine the decision boundary in a Support Vector Machine?',
  '["All points in the training set equally","Only the support vectors that lie on or violate the margin boundaries","The mean centroid of each class","The points furthest away from the hyperplane"]'::jsonb,
  1,
  1,
  'Only data points satisfying y_i(w^T x_i + b) <= 1 have non-zero Lagrange multipliers (support vectors); removing any other training sample leaves the boundary unchanged.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000019'::UUID,
  'd0000000-0000-0000-0210-000000000003'::UUID,
  'What does the Kernel Trick accomplish in SVMs?',
  '["It eliminates the need for training labels","It calculates inner products in high-dimensional feature spaces implicitly without explicitly computing the coordinates","It converts non-convex optimization problems into linear systems","It compresses data into low-dimensional PCA space"]'::jsonb,
  1,
  1,
  'The Kernel Trick computes K(x, z) = <phi(x), phi(z)> directly, enabling non-linear classification in infinite-dimensional Hilbert spaces without mapping cost.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000020'::UUID,
  'd0000000-0000-0000-0210-000000000003'::UUID,
  'In an SVM with an RBF kernel, what does an excessively large gamma parameter cause?',
  '["A nearly linear decision boundary with high bias","High variance and overfitting, where each training instance creates an isolated island of decision boundary","The margin to widen indefinitely","Slack variables to drop to zero"]'::jsonb,
  1,
  1,
  'Gamma governs the radius of influence of individual support vectors. A very large gamma makes the Gaussian bell curve extremely narrow, leading to severe overfitting.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000021'::UUID,
  'd0000000-0000-0000-0210-000000000003'::UUID,
  'What is the purpose of the shrinkage parameter (learning rate) in Gradient Boosted Decision Trees?',
  '["It scales down each tree''s contribution to slow learning and prevent overfitting","It limits the maximum depth of each tree","It forces all leaf values to be integers","It normalizes output predictions between 0 and 1"]'::jsonb,
  0,
  1,
  'Shrinkage eta in (0, 1] scales the step taken along the gradient direction, reducing the impact of individual trees and improving out-of-sample generalization.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000022'::UUID,
  'd0000000-0000-0000-0210-000000000004'::UUID,
  'How does K-Means++ improve over standard random centroid initialization?',
  '["It initializes all centroids at the global dataset mean","It chooses initial centroids iteratively with probability proportional to squared distance from the closest existing centroid","It uses hierarchical agglomeration to find centers","It computes eigenvalues to place centroids along principal components"]'::jsonb,
  1,
  1,
  'K-Means++ spaces initial centroids as far apart as possible, substantially reducing convergence time and avoiding poor local minima.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000023'::UUID,
  'd0000000-0000-0000-0210-000000000004'::UUID,
  'What does the Silhouette Coefficient measure for a clustered sample point?',
  '["The computational runtime of the clustering algorithm","How close the sample is to points in its own cluster relative to points in neighboring clusters","The total number of iterations before convergence","The probability that the sample was generated by a uniform distribution"]'::jsonb,
  1,
  1,
  'The silhouette value s = (b - a) / max(a, b) ranges from -1 to +1, scoring intra-cluster cohesion (a) versus nearest-cluster separation (b).',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000024'::UUID,
  'd0000000-0000-0000-0210-000000000004'::UUID,
  'In Principal Component Analysis (PCA), what direction does the first principal component vector point in?',
  '["The direction of minimal variance in the data","The direction of maximum variance in the centered data","Along the feature with the highest mean value","Orthogonal to all eigenvectors with non-zero eigenvalues"]'::jsonb,
  1,
  1,
  'The first principal component corresponds to the eigenvector of the sample covariance matrix with the largest eigenvalue, capturing maximum variance.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000025'::UUID,
  'd0000000-0000-0000-0210-000000000004'::UUID,
  'Why is standardizing features (zero mean, unit variance) essential before performing PCA?',
  '["PCA cannot compute square roots on negative numbers","Without scaling, features with large numeric scales artificially dominate variance and dictate the principal axes","Standardization ensures all eigenvalues become exactly 1.0","PCA requires all data values to lie strictly between 0 and 1"]'::jsonb,
  1,
  1,
  'PCA variance maximization is sensitive to measurement units. A feature measured in millimeters will dominate variance over a feature measured in meters unless scaled.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000026'::UUID,
  'd0000000-0000-0000-0210-000000000004'::UUID,
  'What key advantage do Gaussian Mixture Models (GMM) offer over K-Means?',
  '["GMMs provide soft probabilistic cluster assignments and can model elliptical clusters with arbitrary covariance","GMMs do not require selecting the number of clusters K","GMMs guarantee finding global optimal parameters in polynomial time","GMMs do not require numerical optimization"]'::jsonb,
  0,
  1,
  'K-Means assumes spherical clusters with equal variance. GMMs learn covariance matrices per component and assign posterior responsibilities gamma_ik in [0, 1].',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000027'::UUID,
  'd0000000-0000-0000-0210-000000000004'::UUID,
  'In the Expectation-Maximization (EM) algorithm for GMMs, what occurs during the M-step (Maximization)?',
  '["Posterior responsibilities are computed given current parameters","Model parameters (means, covariances, mixing weights) are updated using the estimated responsibilities","The number of clusters K is increased by one","Outlier points are removed from the dataset"]'::jsonb,
  1,
  1,
  'The E-step calculates posterior responsibilities given current parameters; the M-step re-estimates cluster means, covariance matrices, and mixture priors to maximize expected log-likelihood.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0310-000000000028'::UUID,
  'd0000000-0000-0000-0210-000000000004'::UUID,
  'How can you determine the number of principal components to retain in PCA for dimensionality reduction?',
  '["Always retain exactly 50% of the features","Plot cumulative explained variance ratio vs number of components and select threshold (e.g. 95%)","Retain only components whose eigenvalues are strictly negative","Choose the component count that maximizes training loss"]'::jsonb,
  1,
  1,
  'A scree plot or cumulative explained variance curve shows the fraction of total dataset variance preserved by the top k components, guiding an informed cutoff.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000001'::UUID,
  'd0000000-0000-0000-0211-000000000001'::UUID,
  'In the scaled dot-product attention equation Attention(Q, K, V) = softmax(Q K^T / sqrt(d_k)) V, what is the mathematical purpose of dividing by sqrt(d_k)?',
  '["To guarantee the output values sum to 1","To prevent large dot products from pushing softmax into regions with vanishingly small gradients","To project vectors into complex frequency space","To enforce causal masking across sequence steps"]'::jsonb,
  1,
  1,
  'For high dimensions d_k, variance of the inner product scales with d_k. Scaling by 1/sqrt(d_k) preserves unit variance, preventing softmax saturation.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000002'::UUID,
  'd0000000-0000-0000-0211-000000000001'::UUID,
  'What is the computational complexity of standard full self-attention with respect to sequence length N?',
  '["O(N) linear time and space","O(N * log N)","O(N^2) quadratic time and memory footprint","O(2^N) exponential complexity"]'::jsonb,
  2,
  1,
  'Computing the pairwise attention score matrix between N queries and N keys requires N x N operations and memory storage, yielding O(N^2) complexity.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000003'::UUID,
  'd0000000-0000-0000-0211-000000000001'::UUID,
  'How does Multi-Head Attention enhance model expressiveness over single-head attention?',
  '["It increases the sequence length by a factor of h","It allows the model to jointly attend to information from different representation subspaces at different positions","It eliminates the need for feed-forward layers","It removes all linear projection weight matrices"]'::jsonb,
  1,
  1,
  'Multiple attention heads project inputs into distinct subspaces, allowing individual heads to specialize in syntactic relations, coreference, semantic binding, etc.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000004'::UUID,
  'd0000000-0000-0000-0211-000000000001'::UUID,
  'Why do modern LLM architectures (like LLaMA and Mistral) utilize Pre-LayerNorm rather than the original Post-LayerNorm?',
  '["Pre-LN stabilizes gradient flow through residual connections, enabling training of very deep networks without warmup instability","Pre-LN removes the need for residual connections entirely","Pre-LN reduces the parameter count of the model by 50%","Post-LN cannot be executed on GPUs"]'::jsonb,
  0,
  1,
  'Pre-LN applies normalization to the inputs of the sub-layers before self-attention and FFN, keeping the clean residual identity path unobstructed and avoiding vanishing/exploding gradients.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000005'::UUID,
  'd0000000-0000-0000-0211-000000000001'::UUID,
  'What distinguishes Rotary Position Embeddings (RoPE) from traditional absolute sinusoidal positional encodings?',
  '["RoPE requires no floating point operations","RoPE incorporates positional information by rotating query and key representations in the complex plane, naturally preserving relative distances","RoPE assigns identical position vectors to all tokens","RoPE only works on text with fewer than 128 tokens"]'::jsonb,
  1,
  1,
  'RoPE applies an orthogonal rotation matrix to queries and keys such that their dot product depends solely on relative token offset (m - n), enabling superior length generalization.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000006'::UUID,
  'd0000000-0000-0000-0211-000000000001'::UUID,
  'What mask is applied in autoregressive decoder-only Transformers during self-attention?',
  '["A random dropout mask","A lower-triangular causal attention mask setting future token affinities to -infinity before softmax","An upper-triangular mask hiding past tokens","A bidirectional encoder mask"]'::jsonb,
  1,
  1,
  'Causal masking ensures token t can only attend to tokens at indices <= t, preventing future token leakage during autoregressive language modeling.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000007'::UUID,
  'd0000000-0000-0000-0211-000000000001'::UUID,
  'What activation function has largely replaced ReLU in modern Transformer Feed-Forward Networks?',
  '["Sigmoid","GELU / SwiGLU","Step function","Tanh"]'::jsonb,
  1,
  1,
  'Smooth non-linearities like GELU and gated variants like SwiGLU provide non-zero gradients for small negative inputs, substantially improving training dynamics in deep LLMs.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000008'::UUID,
  'd0000000-0000-0000-0211-000000000002'::UUID,
  'According to the Chinchilla scaling laws (Hoffmann et al., 2022), how should model parameters N and training tokens D scale for compute-optimal pretraining?',
  '["Increase model parameters 4x faster than training tokens","Scale model parameters N and training tokens D in approximately equal proportions (1:1)","Hold tokens constant and scale parameters quadratically","Scale tokens exponentially while keeping model size under 1 billion parameters"]'::jsonb,
  1,
  1,
  'Chinchilla demonstrated that both parameters N and tokens D should scale proportionally with compute budget (N proportional to C^0.5, D proportional to C^0.5), requiring ~20 tokens per parameter.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000009'::UUID,
  'd0000000-0000-0000-0211-000000000002'::UUID,
  'How does Byte-Pair Encoding (BPE) construct its vocabulary during training?',
  '["By randomly selecting 50,000 dictionary words","By iteratively merging the most frequently occurring pair of adjacent bytes or characters in the training corpus","By clustering sentence embeddings using K-Means","By computing the Fourier transform of the character frequency histogram"]'::jsonb,
  1,
  1,
  'BPE starts with base characters and repeatedly merges the most frequent adjacent token pairs until the target vocabulary size is reached.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000010'::UUID,
  'd0000000-0000-0000-0211-000000000002'::UUID,
  'What pretraining objective is used in models like BERT?',
  '["Causal Next-Token Prediction","Masked Language Modeling (MLM) and Next Sentence Prediction","Direct Preference Optimization","Reinforcement Learning from Human Feedback"]'::jsonb,
  1,
  1,
  'BERT was trained using Masked Language Modeling (predicting 15% masked tokens using bidirectional context) and Next Sentence Prediction.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000011'::UUID,
  'd0000000-0000-0000-0211-000000000002'::UUID,
  'What problem occurs when tokenizers encounter rare words or code identifiers?',
  '["The model crashes immediately","Subword tokenization breaks the unfamiliar term into multiple known subwords or individual bytes without losing information","The entire sentence is discarded","The tokens are replaced with zero embeddings"]'::jsonb,
  1,
  1,
  'Subword tokenizers (like BPE or SentencePiece) gracefully decompose unseen or rare words into familiar constituent character sequences or byte fallback tokens.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000012'::UUID,
  'd0000000-0000-0000-0211-000000000002'::UUID,
  'What is the relationship between training compute FLOPs C, parameter count N, and token count D for a standard dense Transformer?',
  '["C approximately equals 6 * N * D","C approximately equals N + D","C approximately equals N^2 * D","C approximately equals 2 * N * log(D)"]'::jsonb,
  0,
  1,
  'Each token requires approximately 2 FLOPs per parameter on the forward pass and 4 FLOPs on the backward pass, totaling approximately 6 * N * D FLOPs during training.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000013'::UUID,
  'd0000000-0000-0000-0211-000000000002'::UUID,
  'Why are decoder-only causal models preferred over encoder-decoder architectures for general conversational generation?',
  '["Decoder-only models cannot perform translation","Decoder-only models share parameters across prefix and generation, maximizing KV-cache reuse and autoregressive efficiency","Encoder-decoder models require 100x more compute per token","Decoder-only models do not use attention"]'::jsonb,
  1,
  1,
  'Decoder-only architectures handle unified prompting, task specification, few-shot conditioning, and free-form generation under a single autoregressive framework.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000014'::UUID,
  'd0000000-0000-0000-0211-000000000002'::UUID,
  'What is the phenomenon where pre-trained LLMs gain unexpected qualitative capabilities (e.g. arithmetic, translation) when scaled past critical compute thresholds?',
  '["Catastrophic forgetting","Emergent abilities","Gradient explosion","Mode collapse"]'::jsonb,
  1,
  1,
  'Emergent abilities refer to sharp performance improvements observed on complex reasoning benchmarks once models cross critical scale in parameters and compute.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000015'::UUID,
  'd0000000-0000-0000-0211-000000000003'::UUID,
  'What major advantage does Direct Preference Optimization (DPO) have over traditional RLHF with PPO?',
  '["DPO does not require any human preference data","DPO optimizes the policy directly from pairwise preferences without training a separate reward model or using complex RL algorithms","DPO works only on encoder models","DPO updates only 1% of parameters"]'::jsonb,
  1,
  1,
  'DPO reparameterizes the reward function analytically using the closed-form optimal policy, formulating alignment as a clean classification loss without PPO instability.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000016'::UUID,
  'd0000000-0000-0000-0211-000000000003'::UUID,
  'In Low-Rank Adaptation (LoRA), how is a pre-trained weight matrix W0 of size d x k adapted?',
  '["W0 is fully retrained with a small learning rate","W0 is frozen and an additive low-rank decomposition Delta W = B * A is learned, where B is d x r and A is r x k with r << min(d, k)","W0 is pruned to retain only diagonal entries","W0 is converted into 8-bit integers"]'::jsonb,
  1,
  1,
  'LoRA freezes W0 and adds product B * A of rank r. This reduces trainable parameters by >99% and allows merging adapters directly back into W0 at inference time with zero latency penalty.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000017'::UUID,
  'd0000000-0000-0000-0211-000000000003'::UUID,
  'What key innovation allows QLoRA to fine-tune a 65B parameter model on a single 48GB GPU?',
  '["Eliminating the self-attention layers","Quantizing frozen base weights to 4-bit NormalFloat (NF4), double quantization, and paged optimizers","Running gradient descent on CPU memory exclusively","Training only on the last 2 token positions"]'::jsonb,
  1,
  1,
  'QLoRA quantizes base weights to information-theoretically optimal 4-bit NF4 format while computing high-precision 16-bit gradients solely through low-rank LoRA adapter matrices.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000018'::UUID,
  'd0000000-0000-0000-0211-000000000003'::UUID,
  'What is the role of the KL-divergence penalty in RLHF reward optimization?',
  '["To maximize the length of the generated response","To prevent the policy model from drifting too far from the initial reference model (reward hacking / mode collapse)","To force the model to generate random words","To eliminate the need for value networks"]'::jsonb,
  1,
  1,
  'The KL penalty D_KL(pi_theta || pi_ref) constrains the policy from exploiting loopholes or vulnerabilities in the reward model that produce incoherent or unnatural outputs.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000019'::UUID,
  'd0000000-0000-0000-0211-000000000003'::UUID,
  'How can LoRA weights be deployed in production without adding latency to model forward passes?',
  '["By running the adapter on a separate auxiliary server","By mathematically adding the adapter weights directly to the base weights: W_final = W_0 + (alpha / r) * B * A","By disabling attention caching","By converting all weights into strings"]'::jsonb,
  1,
  1,
  'Because Delta W = (alpha/r) B A has the exact same dimensions as W_0, it can be fused directly into the pre-trained weights prior to serving.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000020'::UUID,
  'd0000000-0000-0000-0211-000000000003'::UUID,
  'What distinguishes Supervised Fine-Tuning (SFT) from raw pretraining?',
  '["SFT is performed on uncurated internet text","SFT trains specifically on curated prompt-response pairs to teach the model how to follow conversational instructions","SFT uses unsupervised clustering","SFT changes the tokenizer vocabulary"]'::jsonb,
  1,
  1,
  'While pretraining teaches general world knowledge and language fluency, SFT trains the model on structured instruction-following datasets to align output format with user requests.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000021'::UUID,
  'd0000000-0000-0000-0211-000000000003'::UUID,
  'In LoRA, what is the initial value of matrix B in Delta W = B * A?',
  '["Identity matrix","All zeros, ensuring Delta W = 0 at the start of training so behavior matches the base model exactly","Gaussian random noise","Uniform distribution between -1 and 1"]'::jsonb,
  1,
  1,
  'Initializing B to 0 (and A to Gaussian noise) guarantees Delta W = 0 initially, meaning fine-tuning begins strictly from the pre-trained model state without disruption.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000022'::UUID,
  'd0000000-0000-0000-0211-000000000004'::UUID,
  'What is the primary architectural purpose of Retrieval-Augmented Generation (RAG)?',
  '["To eliminate the need for an LLM generator","To ground model generations in external authoritative knowledge bases, reducing factual hallucinations and enabling real-time data access","To increase token generation speed by 10x","To quantize embeddings into 1-bit representations"]'::jsonb,
  1,
  1,
  'RAG retrieves relevant external document chunks dynamically based on query similarity, conditioning generation on factual context to prevent knowledge staleness and hallucinations.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000023'::UUID,
  'd0000000-0000-0000-0211-000000000004'::UUID,
  'What vector indexing structure builds a multi-layer graph of vectors to enable fast Approximate Nearest Neighbor (ANN) search?',
  '["B-Tree","Hierarchical Navigable Small World (HNSW)","Red-Black Tree","Inverted Index"]'::jsonb,
  1,
  1,
  'HNSW constructs hierarchical proximity graphs where upper layers enable fast long-range navigation and bottom layers refine local nearest-neighbor search in logarithmic time.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000024'::UUID,
  'd0000000-0000-0000-0211-000000000004'::UUID,
  'In token sampling, what does Nucleus (Top-p) sampling do?',
  '["Selects the single most likely token deterministically","Restricts the candidate pool to the smallest set of tokens whose cumulative probability reaches threshold p","Samples only from the top k tokens regardless of their probabilities","Sets temperature to zero"]'::jsonb,
  1,
  1,
  'Top-p sampling dynamically sizes the candidate token set according to model confidence: narrow when confident, wide when uncertain.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000025'::UUID,
  'd0000000-0000-0000-0211-000000000004'::UUID,
  'Why is a Cross-Encoder re-ranker often applied after initial bi-encoder vector retrieval in advanced RAG?',
  '["Cross-encoders are much faster than vector dot products","Cross-encoders process query and document simultaneously through full cross-attention, providing significantly higher relevance scoring accuracy on candidate chunks","Cross-encoders generate the final summary text","Cross-encoders perform recursive document chunking"]'::jsonb,
  1,
  1,
  'Bi-encoders embed query and document independently (allowing fast indexing), but lack cross-token interaction. Cross-encoders score query-document pairs jointly with full attention.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000026'::UUID,
  'd0000000-0000-0000-0211-000000000004'::UUID,
  'What metric in the RAG Triad evaluates whether the generated answer is strictly supported by the retrieved context without ungrounded assertions?',
  '["Context Relevance","Faithfulness (Groundedness)","Answer Relevance","BLEU Score"]'::jsonb,
  1,
  1,
  'Faithfulness verifies that every claim made in the generated output can be directly inferred from the retrieved context, guarding against hallucinations.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000027'::UUID,
  'd0000000-0000-0000-0211-000000000004'::UUID,
  'What is KV-Caching in autoregressive LLM inference?',
  '["Caching user session cookies in browser storage","Storing previously computed Key and Value attention matrices for prior tokens so they do not need to be recomputed at each generation step","Storing raw prompt text in Redis","Compressing weights using gzip"]'::jsonb,
  1,
  1,
  'During token-by-token generation, earlier tokens do not change. Caching past Keys and Values reduces the per-step computation from O(N^2) to O(N).',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0311-000000000028'::UUID,
  'd0000000-0000-0000-0211-000000000004'::UUID,
  'What happens when sampling temperature T is set to 0.0?',
  '["The model outputs uniform random gibberish","The sampling distribution becomes deterministic greedy decoding (argmax)","The model produces infinitely long sequences","The vocabulary size is restricted to 1 token"]'::jsonb,
  1,
  1,
  'As T -> 0, the softmax function sharpens until the single token with the highest logit receives probability 1.0, yielding deterministic greedy decoding.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000001'::UUID,
  'd0000000-0000-0000-0212-000000000001'::UUID,
  'Which of the following subsets of R^3 is a valid vector subspace?',
  '["The set of all vectors (x, y, z) such that x + y + z = 1","The set of all vectors (x, y, z) such that 2x - 3y + z = 0","The set of all vectors (x, y, z) such that x >= 0","The set of all vectors (x, y, z) such that x^2 + y^2 = z^2"]'::jsonb,
  1,
  1,
  'The plane 2x - 3y + z = 0 passes through the origin (0, 0, 0) and is closed under addition and scalar multiplication, making it a 2D subspace.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000002'::UUID,
  'd0000000-0000-0000-0212-000000000001'::UUID,
  'If a set contains 4 vectors in R^3, what can be concluded about their linear independence?',
  '["They must be linearly independent","They must be linearly dependent because the number of vectors exceeds the dimension of the space","They form an orthonormal basis for R^3","Their span is at most 2-dimensional"]'::jsonb,
  1,
  1,
  'In any vector space of dimension n, any collection of k > n vectors is guaranteed to be linearly dependent.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000003'::UUID,
  'd0000000-0000-0000-0212-000000000001'::UUID,
  'What is the computational complexity of Gaussian elimination on an n x n dense matrix?',
  '["O(n)","O(n * log n)","O(n^2)","O(n^3)"]'::jsonb,
  3,
  1,
  'Gaussian elimination performs approximately (2/3) n^3 floating point additions and multiplications to reduce an n x n matrix to upper triangular form.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000004'::UUID,
  'd0000000-0000-0000-0212-000000000001'::UUID,
  'In LU decomposition A = L U, what type of matrix is L?',
  '["Unit lower triangular matrix (ones on diagonal, zeros above)","Symmetric positive definite matrix","Orthogonal matrix","Diagonal matrix"]'::jsonb,
  0,
  1,
  'L is a unit lower triangular matrix where diagonal entries are 1 and entries above the main diagonal are strictly 0.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000005'::UUID,
  'd0000000-0000-0000-0212-000000000001'::UUID,
  'Why is partial pivoting used during Gaussian elimination?',
  '["To ensure the resulting matrix is diagonal","To avoid division by zero or very small numbers, minimizing floating-point round-off error","To reduce the time complexity from O(n^3) to O(n^2)","To eliminate the need for back-substitution"]'::jsonb,
  1,
  1,
  'Partial pivoting swaps rows to place the largest available magnitude element on the pivot diagonal, preventing catastrophic cancellation and error magnification.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000006'::UUID,
  'd0000000-0000-0000-0212-000000000001'::UUID,
  'What does it mean if det(A) = 0 for an n x n square matrix A?',
  '["The matrix is invertible","The matrix has full rank n","The columns of A are linearly dependent and the matrix is singular","All eigenvalues of A must equal zero"]'::jsonb,
  2,
  1,
  'A determinant of zero indicates that the matrix has rank < n, its rows/columns are linearly dependent, and it has no multiplicative inverse.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000007'::UUID,
  'd0000000-0000-0000-0212-000000000001'::UUID,
  'Once an n x n matrix A is decomposed into L and U, how many operations are required to solve A x = b for a new vector b?',
  '["O(n^3)","O(n^2) via forward and back substitution","O(n)","O(1)"]'::jsonb,
  1,
  1,
  'Solving L y = b takes n^2 / 2 operations and U x = y takes n^2 / 2 operations, totaling O(n^2) back-substitution steps.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000008'::UUID,
  'd0000000-0000-0000-0212-000000000002'::UUID,
  'For an m x n matrix A with rank r, what is the dimension of the nullspace N(A)?',
  '["r","m - r","n - r","n"]'::jsonb,
  2,
  1,
  'By the Rank-Nullity Theorem, rank(A) + nullity(A) = n (number of columns), so dim(N(A)) = n - r.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000009'::UUID,
  'd0000000-0000-0000-0212-000000000002'::UUID,
  'What is the orthogonal complement of the row space C(A^T) in R^n?',
  '["Column space C(A)","Nullspace N(A)","Left nullspace N(A^T)","Span of all eigenvectors"]'::jsonb,
  1,
  1,
  'Every vector in the nullspace satisfies A x = 0, meaning x is orthogonal to every row vector of A. Thus C(A^T) and N(A) are orthogonal complements.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000010'::UUID,
  'd0000000-0000-0000-0212-000000000002'::UUID,
  'If a 5 x 7 matrix has rank 4, what is the dimension of its left nullspace N(A^T)?',
  '["1","3","4","7"]'::jsonb,
  0,
  1,
  'Left nullspace lies in R^m (where m=5). Its dimension is m - r = 5 - 4 = 1.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000011'::UUID,
  'd0000000-0000-0000-0212-000000000002'::UUID,
  'When does a linear system A x = b have at least one solution?',
  '["When b lies in the nullspace N(A)","When b lies in the column space C(A)","When the rank of A is 0","When m > n strictly"]'::jsonb,
  1,
  1,
  'A x is a linear combination of the columns of A. Therefore, A x = b is solvable if and only if b belongs to the column space C(A).',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000012'::UUID,
  'd0000000-0000-0000-0212-000000000002'::UUID,
  'If matrix A has full column rank (rank = n), what is the nullspace N(A)?',
  '["R^n","Only the zero vector {0}","A line passing through the origin","The row space"]'::jsonb,
  1,
  1,
  'When rank = n, nullity = n - r = 0, meaning the only solution to A x = 0 is the trivial solution x = 0.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000013'::UUID,
  'd0000000-0000-0000-0212-000000000002'::UUID,
  'What is always true regarding the dimension of the row space and column space of any m x n matrix?',
  '["dim(C(A)) > dim(C(A^T)) if m > n","dim(C(A)) = dim(C(A^T)) = rank(A)","dim(C(A)) + dim(C(A^T)) = m + n","dim(C(A)) is independent of row operations"]'::jsonb,
  1,
  1,
  'Row rank always equals column rank for any real matrix, both being identical to rank(A).',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000014'::UUID,
  'd0000000-0000-0000-0212-000000000002'::UUID,
  'What does the Fredholm Alternative state regarding linear systems A x = b?',
  '["Either A x = b has a solution, or there exists y such that A^T y = 0 and y^T b != 0","Every matrix has at least one real eigenvalue","All symmetric matrices are invertible","Nullspaces always have higher dimension than column spaces"]'::jsonb,
  0,
  1,
  'The Fredholm Alternative states that exactly one of the two holds: either b in C(A), or b is not orthogonal to N(A^T).',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000015'::UUID,
  'd0000000-0000-0000-0212-000000000003'::UUID,
  'If A is a real symmetric matrix (A = A^T), what guarantees does the Spectral Theorem provide?',
  '["All eigenvalues are strictly complex numbers","All eigenvalues are real, and there exists an orthonormal basis of eigenvectors","The determinant of A is always 1","The matrix has no inverse"]'::jsonb,
  1,
  1,
  'The Spectral Theorem states that any real symmetric matrix can be orthogonally diagonalized as A = Q Lambda Q^T with purely real eigenvalues and orthonormal eigenvectors Q.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000016'::UUID,
  'd0000000-0000-0000-0212-000000000003'::UUID,
  'If matrix A is diagonalized as A = P D P^(-1), what is the formula for matrix power A^k?',
  '["A^k = P^k * D * P^(-k)","A^k = P * D^k * P^(-1)","A^k = k * P * D * P^(-1)","A^k = D^k"]'::jsonb,
  1,
  1,
  'A^k = (P D P^(-1))(P D P^(-1))...(P D P^(-1)) = P D^k P^(-1), where D^k simply raises each diagonal eigenvalue to the power k.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000017'::UUID,
  'd0000000-0000-0000-0212-000000000003'::UUID,
  'What property characterizes an orthogonal matrix Q?',
  '["Q^T = Q^(-1) and Q^T Q = I","det(Q) = 0","All diagonal entries of Q must be 0","Q has only positive eigenvalues"]'::jsonb,
  0,
  1,
  'An orthogonal matrix has mutually orthonormal columns, satisfying Q^T Q = I, which implies Q^(-1) = Q^T.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000018'::UUID,
  'd0000000-0000-0000-0212-000000000003'::UUID,
  'In the QR decomposition A = Q R, what are the properties of matrices Q and R?',
  '["Q is lower triangular, R is diagonal","Q has orthonormal columns (Q^T Q = I) and R is an upper triangular invertible matrix","Q and R are both symmetric matrices","Q is a permutation matrix and R is a scalar"]'::jsonb,
  1,
  1,
  'QR decomposition factors matrix A into orthogonal matrix Q (preserving norms and angles) and upper-triangular matrix R.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000019'::UUID,
  'd0000000-0000-0000-0212-000000000003'::UUID,
  'What is the sum of all eigenvalues of an n x n matrix A equal to?',
  '["Determinant det(A)","Trace tr(A) (sum of diagonal elements)","Matrix rank","Condition number"]'::jsonb,
  1,
  1,
  'The trace of any square matrix equals the sum of its eigenvalues: sum(lambda_i) = tr(A).',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000020'::UUID,
  'd0000000-0000-0000-0212-000000000003'::UUID,
  'What is the product of all eigenvalues of an n x n matrix A equal to?',
  '["Determinant det(A)","Trace tr(A)","Frobenius norm","Spectral radius"]'::jsonb,
  0,
  1,
  'The product of all eigenvalues of a matrix is equal to its determinant: prod(lambda_i) = det(A).',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000021'::UUID,
  'd0000000-0000-0000-0212-000000000003'::UUID,
  'What occurs during the Gram-Schmidt process if a candidate vector vk is a linear combination of the preceding vectors?',
  '["The algorithm crashes","The orthogonalized vector uk evaluates to the zero vector 0","The resulting vector has infinite length","The previous vectors are inverted"]'::jsonb,
  1,
  1,
  'Subtracting all orthogonal projections leaves zero if the vector lies entirely within the span of earlier vectors.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000022'::UUID,
  'd0000000-0000-0000-0212-000000000004'::UUID,
  'In Singular Value Decomposition A = U Sigma V^T, what are the singular values sigma_i?',
  '["The diagonal entries of A","The square roots of the eigenvalues of A^T A (or A A^T)","The complex roots of det(A - lambda I)","The row sums of matrix V"]'::jsonb,
  1,
  1,
  'Singular values are the non-negative square roots of the eigenvalues of A^T A, sorted in descending order: sigma_i = sqrt(lambda_i(A^T A)).',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000023'::UUID,
  'd0000000-0000-0000-0212-000000000004'::UUID,
  'According to the Eckart-Young-Mirsky Theorem, what provides the optimal rank-k approximation of a matrix A under Frobenius norm?',
  '["Setting the last k rows of A to 0","Truncating the SVD expansion to the first k largest singular values: sum_{i=1}^k sigma_i u_i v_i^T","Running k steps of Gram-Schmidt","The LU factorization"]'::jsonb,
  1,
  1,
  'Retaining the top k singular components minimizes reconstruction error in both Frobenius norm and spectral norm.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000024'::UUID,
  'd0000000-0000-0000-0212-000000000004'::UUID,
  'At a critical point x* where grad f(x*) = 0, what does it mean if the Hessian matrix H(x*) has both strictly positive and strictly negative eigenvalues?',
  '["x* is a local minimum","x* is a local maximum","x* is a saddle point","f is constant everywhere"]'::jsonb,
  2,
  1,
  'If the Hessian is indefinite (possessing eigenvalues of conflicting signs), moving along some directions increases f while others decrease f, identifying a saddle point.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000025'::UUID,
  'd0000000-0000-0000-0212-000000000004'::UUID,
  'In which direction does the gradient vector grad f(x) point at any point x?',
  '["Tangent to the level surface f(x) = c","In the direction of steepest rate of increase of f(x)","Towards the origin (0, 0)","Perpendicular to the normal vector of the tangent plane"]'::jsonb,
  1,
  1,
  'By the Cauchy-Schwarz inequality, the directional derivative D_u f = grad f . u is maximized when u points in the exact direction of grad f.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000026'::UUID,
  'd0000000-0000-0000-0212-000000000004'::UUID,
  'What is the condition number kappa(A) of an invertible matrix in the 2-norm in terms of singular values?',
  '["sigma_1 + sigma_n","sigma_1 / sigma_n (ratio of largest to smallest singular value)","sigma_1 * sigma_n","det(Sigma)"]'::jsonb,
  1,
  1,
  'The 2-norm condition number is kappa(A) = ||A||_2 ||A^(-1)||_2 = sigma_max / sigma_min, measuring sensitivity of linear solutions to input perturbations.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000027'::UUID,
  'd0000000-0000-0000-0212-000000000004'::UUID,
  'What matrix contains all first-order partial derivatives of a vector-valued function f: R^n -> R^m?',
  '["The Hessian matrix","The Jacobian matrix J in R^(m x n)","The Gram matrix","The Covariance matrix"]'::jsonb,
  1,
  1,
  'The Jacobian matrix J has entries J_ij = d f_i / d x_j, representing the best linear approximation of multivariable map f near x.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0312-000000000028'::UUID,
  'd0000000-0000-0000-0212-000000000004'::UUID,
  'How does the Moore-Penrose pseudoinverse A^+ relate to SVD A = U Sigma V^T?',
  '["A^+ = U Sigma V^T","A^+ = V Sigma^+ U^T where Sigma^+ contains reciprocals 1/sigma_i of non-zero singular values","A^+ = (A^T A)^(-1)","A^+ = U^T V"]'::jsonb,
  1,
  1,
  'A^+ = V Sigma^+ U^T computes the minimal-norm least-squares solution x = A^+ b for any rectangular or rank-deficient matrix.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000001'::UUID,
  'd0000000-0000-0000-0213-000000000001'::UUID,
  'According to De Morgan''s Laws, what is the boolean complement of (A + B * C)?',
  '["A_bar * (B_bar + C_bar)","A_bar + B_bar * C_bar","A_bar * B_bar * C_bar","(A_bar + B_bar) * C_bar"]'::jsonb,
  0,
  1,
  'Complement of (A + X) is A_bar * X_bar. Here X = B * C, so X_bar = B_bar + C_bar, yielding A_bar * (B_bar + C_bar).',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000002'::UUID,
  'd0000000-0000-0000-0213-000000000001'::UUID,
  'Why are NAND and NOR gates classified as universal logic gates?',
  '["They operate at higher clock speeds than other gates","Any arbitrary Boolean function can be implemented using exclusively NAND or exclusively NOR gates","They have zero propagation delay","They do not require power or ground connections"]'::jsonb,
  1,
  1,
  'NAND and NOR gates can implement INVERTER, AND, and OR operations, making them sufficient to realize any possible truth table.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000003'::UUID,
  'd0000000-0000-0000-0213-000000000001'::UUID,
  'In a 4-variable Karnaugh Map, how many cells must a valid grouping contain?',
  '["Any multiple of 3","A power of two: 1, 2, 4, 8, or 16 cells","Exactly 4 cells only","Any number of adjacent square cells"]'::jsonb,
  1,
  1,
  'K-map grouping eliminates variables based on boolean theorem x + x_bar = 1. Combining 2^k adjacent cells eliminates k boolean variables.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000004'::UUID,
  'd0000000-0000-0000-0213-000000000001'::UUID,
  'What code ordering is utilized on the axes of Karnaugh maps to guarantee that adjacent cells differ by only one variable?',
  '["Standard Binary Code","Gray Code","BCD (Binary Coded Decimal)","Two''s Complement"]'::jsonb,
  1,
  1,
  'Gray code (00, 01, 11, 10) ensures that horizontally or vertically adjacent cells differ by exactly one bit, enabling algebraic simplification.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000005'::UUID,
  'd0000000-0000-0000-0213-000000000001'::UUID,
  'What is an essential prime implicant in a Karnaugh map?',
  '["A prime implicant that covers at least one minterm that is not covered by any other prime implicant","A group that contains all 16 cells","A group that covers only Don''t Care conditions","The group with the smallest number of cells"]'::jsonb,
  0,
  1,
  'An essential prime implicant covers a 1-cell that cannot be included in any alternative prime implicant grouping, requiring its inclusion in the minimal SOP expression.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000006'::UUID,
  'd0000000-0000-0000-0213-000000000001'::UUID,
  'What is the canonical Sum-of-Products (SOP) form composed of?',
  '["OR of maxterms","OR of minterms (AND terms containing every variable in complemented or uncomplemented form)","AND of maxterms","Exclusive-OR of product terms"]'::jsonb,
  1,
  1,
  'Canonical SOP sums all minterms for which the boolean function evaluates to logic 1.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000007'::UUID,
  'd0000000-0000-0000-0213-000000000001'::UUID,
  'What simplification does the consensus theorem A B + A_bar C + B C yield?',
  '["A B + A_bar C","B C","A + B + C","A B C"]'::jsonb,
  0,
  1,
  'By the consensus theorem, the third term B C is redundant because if B and C are 1, either A=1 (making AB=1) or A=0 (making A_bar C=1).',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000008'::UUID,
  'd0000000-0000-0000-0213-000000000002'::UUID,
  'What are the outputs of a 1-bit Full Adder with inputs A, B, and Carry-in Cin?',
  '["Sum = A + B + Cin; Carry = A * B * Cin","Sum = A xor B xor Cin; Carry = (A * B) + (Cin * (A xor B))","Sum = A xor B; Carry = A * B","Sum = A * B * Cin; Carry = A + B + Cin"]'::jsonb,
  1,
  1,
  'The sum bit evaluates odd parity (A xor B xor Cin) and the carry-out is generated if at least two of the three inputs are 1: AB + Cin(A xor B).',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000009'::UUID,
  'd0000000-0000-0000-0213-000000000002'::UUID,
  'Why does a Carry-Lookahead Adder (CLA) compute additions much faster than a Ripple-Carry Adder for 64-bit operands?',
  '["CLA eliminates full adder logic","CLA generates all stage carries simultaneously in O(log N) depth using propagate and generate equations rather than waiting for serial rippling","CLA uses analog operational amplifiers","CLA operates in the frequency domain"]'::jsonb,
  1,
  1,
  'In ripple adders, worst-case latency scales as O(N) due to carry propagation. CLA calculates all carries in parallel using Gi = Ai Bi and Pi = Ai xor Bi.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000010'::UUID,
  'd0000000-0000-0000-0213-000000000002'::UUID,
  'How many select input lines are required for a 32-to-1 Multiplexer?',
  '["4","5","8","32"]'::jsonb,
  1,
  1,
  'A 2^n to 1 multiplexer requires n select lines. Since 2^5 = 32, exactly 5 select lines are required.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000011'::UUID,
  'd0000000-0000-0000-0213-000000000002'::UUID,
  'What is the function of an n-to-2^n binary decoder with an active-high enable input?',
  '["It converts 2^n analog inputs into n digital outputs","It asserts exactly one of 2^n output lines corresponding to the binary value represented by the n input lines","It adds n binary numbers together","It stores n bits of data on the clock edge"]'::jsonb,
  1,
  1,
  'An n-to-2^n decoder activates the specific output line corresponding to the decimal value of the n-bit input code.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000012'::UUID,
  'd0000000-0000-0000-0213-000000000002'::UUID,
  'How can an adder circuit perform subtraction A - B using two''s complement arithmetic?',
  '["By swapping inputs A and B","By inverting all bits of B (one''s complement) and asserting Carry-In Cin = 1","By shifting bits of B left by 1 position","By dividing B by 2"]'::jsonb,
  1,
  1,
  'In two''s complement, -B = ~B + 1. Feeding ~B into the adder with Cin=1 computes A + (~B + 1) = A - B.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000013'::UUID,
  'd0000000-0000-0000-0213-000000000002'::UUID,
  'What logic circuit detects if an ALU output vector of 32 bits is exactly equal to zero?',
  '["A 32-input AND gate","A NOR gate combining all 32 output bits","An XOR tree","A 32-bit register"]'::jsonb,
  1,
  1,
  'If any output bit is 1, an OR gate outputs 1. Inverting this via a NOR gate yields 1 if and only if all 32 output bits are 0.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000014'::UUID,
  'd0000000-0000-0000-0213-000000000002'::UUID,
  'What is a tri-state buffer?',
  '["A gate with three outputs","A digital buffer with an enable control that can output Logic 0, Logic 1, or High-Impedance (Hi-Z)","A gate that operates on ternary base-3 numbers","A storage register with three clock inputs"]'::jsonb,
  1,
  1,
  'When disabled, a tri-state buffer enters High-Impedance (Hi-Z), electrically disconnecting its output from shared buses to avoid bus contention.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000015'::UUID,
  'd0000000-0000-0000-0213-000000000003'::UUID,
  'What is the setup time (t_setup) of an edge-triggered flip-flop?',
  '["The time required for output Q to become valid after the clock edge","The minimum time the data input must remain stable before the active clock edge","The minimum duration the clock pulse must remain high","The delay between power-on and the first clock pulse"]'::jsonb,
  1,
  1,
  'Setup time is the critical window immediately preceding the active clock edge during which the data input D must not change.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000016'::UUID,
  'd0000000-0000-0000-0213-000000000003'::UUID,
  'What happens if the setup or hold time constraints of a flip-flop are violated?',
  '["The circuit burns out immediately","The flip-flop may enter a metastable state where the output hovers between logic levels for an unpredictable duration","The clock frequency automatically doubles","The output is guaranteed to latch to 0"]'::jsonb,
  1,
  1,
  'Timing violations cause metastability, where internal feedback loops fail to resolve cleanly to 0 or 1, corrupting synchronous operation.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000017'::UUID,
  'd0000000-0000-0000-0213-000000000003'::UUID,
  'What distinguishes a Moore machine from a Mealy machine?',
  '["Moore machine outputs depend only on the current state, whereas Mealy machine outputs depend on both current state and current inputs","Moore machines do not use flip-flops","Mealy machines can only have 2 states","Moore machines change state without a clock signal"]'::jsonb,
  0,
  1,
  'In Moore FSMs, output is a pure function of state registers. In Mealy FSMs, outputs react combinationally to external inputs within the clock period.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000018'::UUID,
  'd0000000-0000-0000-0213-000000000003'::UUID,
  'What is the characteristic equation of a JK flip-flop?',
  '["Q_next = D","Q_next = J * Q_bar + K_bar * Q","Q_next = J xor K","Q_next = J * K"]'::jsonb,
  1,
  1,
  'When J=1, K=0 (set), Q_next=1; when J=0, K=1 (reset), Q_next=0; when J=1, K=1 (toggle), Q_next=Q_bar. This matches J Q_bar + K_bar Q.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000019'::UUID,
  'd0000000-0000-0000-0213-000000000003'::UUID,
  'How many flip-flops are required to construct a modulo-16 synchronous binary counter?',
  '["2","4","8","16"]'::jsonb,
  1,
  1,
  'A modulo-N counter requires ceil(log2(N)) flip-flops. Since log2(16) = 4, exactly 4 flip-flops are needed.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000020'::UUID,
  'd0000000-0000-0000-0213-000000000003'::UUID,
  'What is the maximum operating clock frequency f_max for a synchronous sequential circuit with t_clk-q = 2ns, combinational logic delay t_comb = 5ns, and setup time t_su = 1ns?',
  '["100 MHz","125 MHz","200 MHz","500 MHz"]'::jsonb,
  1,
  1,
  'Minimum clock period T_clk = t_clk-q + t_comb + t_su = 2ns + 5ns + 1ns = 8ns. Max frequency f_max = 1 / 8ns = 125 MHz.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000021'::UUID,
  'd0000000-0000-0000-0213-000000000003'::UUID,
  'What is a Johnson counter (twisted ring counter) with 4 flip-flops capable of counting?',
  '["4 states","8 states (2 * n)","16 states","32 states"]'::jsonb,
  1,
  1,
  'By feeding the inverted output of the last flip-flop back into the first, an n-stage Johnson counter cycles through 2n = 8 distinct states.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000022'::UUID,
  'd0000000-0000-0000-0213-000000000004'::UUID,
  'What special property does register x0 possess in the RISC-V ISA?',
  '["It stores the program counter (PC)","It is hardwired to constant value 0, and writes to it are silently ignored","It is the stack pointer","It stores floating point status flags"]'::jsonb,
  1,
  1,
  'In RISC-V, register x0 always reads as zero, providing a convenient constant for move operations (addi rd, rs1, 0) and zero comparisons.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000023'::UUID,
  'd0000000-0000-0000-0213-000000000004'::UUID,
  'In a classic 5-stage RISC pipeline, what type of hazard occurs when an instruction requires data that has been loaded by a preceding instruction but not yet written back?',
  '["Structural hazard","Read-After-Write (RAW) data hazard","Write-After-Read (WAR) hazard","Control hazard"]'::jsonb,
  1,
  1,
  'A RAW data hazard happens when an instruction attempts to read a register before a previous instruction writes its result.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000024'::UUID,
  'd0000000-0000-0000-0213-000000000004'::UUID,
  'Why cannot data forwarding eliminate the stall cycle for a Load-Use hazard (e.g., lw x1, 0(x2) followed immediately by add x3, x1, x4)?',
  '["The ALU is turned off during load instructions","The loaded data is only available from data memory at the end of the MEM stage, whereas the ADD instruction needs it at the beginning of the EX stage","RISC-V registers cannot be forwarded","Forwarding only works for branch instructions"]'::jsonb,
  1,
  1,
  'The load data is produced at the end of stage 4 (MEM), while the dependent instruction needs operands at stage 3 (EX). This backward time requirement mandates 1 pipeline bubble.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000025'::UUID,
  'd0000000-0000-0000-0213-000000000004'::UUID,
  'In a 4-way set-associative cache with 32-bit addresses, 64-byte blocks, and 128 sets, how many bits are used for the tag field?',
  '["6 bits","7 bits","19 bits","25 bits"]'::jsonb,
  2,
  1,
  'Block offset = log2(64) = 6 bits. Set index = log2(128) = 7 bits. Tag bits = 32 - 7 - 6 = 19 bits.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000026'::UUID,
  'd0000000-0000-0000-0213-000000000004'::UUID,
  'What cache write policy updates both the cache block and main memory simultaneously on every write hit?',
  '["Write-Back","Write-Through","No-Write-Allocate","Lazy Invalidation"]'::jsonb,
  1,
  1,
  'Write-Through writes data to both cache and memory immediately, ensuring memory is always consistent at the cost of higher bus traffic.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000027'::UUID,
  'd0000000-0000-0000-0213-000000000004'::UUID,
  'What is the Average Memory Access Time (AMAT) if Hit Time is 1 ns, Miss Rate is 5%, and Miss Penalty is 80 ns?',
  '["1.05 ns","4.00 ns","5.00 ns","81.00 ns"]'::jsonb,
  2,
  1,
  'AMAT = Hit Time + (Miss Rate * Miss Penalty) = 1 ns + (0.05 * 80 ns) = 1 ns + 4 ns = 5.0 ns.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0313-000000000028'::UUID,
  'd0000000-0000-0000-0213-000000000004'::UUID,
  'What hardware structure translates virtual page numbers (VPN) to physical page numbers (PPN) quickly without accessing memory page tables?',
  '["Branch Target Buffer (BTB)","Translation Lookaside Buffer (TLB)","Return Address Stack (RAS)","Instruction Register (IR)"]'::jsonb,
  1,
  1,
  'The TLB is a dedicated, fully associative or set-associative hardware cache storing recent page translations to accelerate virtual memory address mapping.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000001'::UUID,
  'd0000000-0000-0000-0214-000000000001'::UUID,
  'What are the dimensions of the broadcast result when adding an array of shape (5, 1, 4) to an array of shape (3, 4)?',
  '["(5, 3, 4)","(5, 4, 3)","(15, 4)","Broadcasting fails because dimensions do not match"]'::jsonb,
  0,
  1,
  'Aligning shapes from the right: (5, 1, 4) and (1, 3, 4). Dimension 4 matches 4; dimension 1 broadcasts to 3; leading dimension 5 prepends. Output shape is (5, 3, 4).',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000002'::UUID,
  'd0000000-0000-0000-0214-000000000001'::UUID,
  'Why does a vectorized NumPy operation execute orders of magnitude faster than a standard Python for-loop?',
  '["NumPy automatically translates code into assembly and skips memory checks","NumPy operates on contiguous blocks of homogeneous data types using compiled C loops and CPU SIMD instructions","NumPy runs exclusively on GPU graphics hardware","NumPy rounds all floating point numbers to integers"]'::jsonb,
  1,
  1,
  'NumPy arrays store fixed-size contiguous memory blocks, eliminating dynamic typing overhead, pointer indirection, and leveraging CPU vectorization.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000003'::UUID,
  'd0000000-0000-0000-0214-000000000001'::UUID,
  'What is the effect of arr.reshape(-1, 1) on a 1D NumPy array of length N?',
  '["Flattens the array into a scalar","Transforms the array into a 2D column vector with shape (N, 1)","Reverses the order of elements","Deletes all negative values"]'::jsonb,
  1,
  1,
  'Passing -1 allows NumPy to infer the dimension automatically. For length N, (-1, 1) converts the vector into an (N, 1) 2D column matrix.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000004'::UUID,
  'd0000000-0000-0000-0214-000000000001'::UUID,
  'What does np.dot(A, B) compute when A and B are 2-dimensional matrices?',
  '["Element-wise multiplication","Standard matrix multiplication (equivalent to A @ B)","Vector cross product","Outer product of row sums"]'::jsonb,
  1,
  1,
  'For 2D arrays, np.dot performs standard matrix multiplication, identical to the @ operator.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000005'::UUID,
  'd0000000-0000-0000-0214-000000000001'::UUID,
  'Which function creates an array of 50 evenly spaced numbers between 0 and 10 inclusive?',
  '["np.arange(0, 10, 50)","np.linspace(0, 10, 50)","np.random.uniform(0, 10, 50)","np.zeros((10, 50))"]'::jsonb,
  1,
  1,
  'np.linspace(start, stop, num) generates num evenly spaced points over the specified closed interval [start, stop].',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000006'::UUID,
  'd0000000-0000-0000-0214-000000000001'::UUID,
  'In a 2D array arr of shape (10, 20), what does arr.sum(axis=0) return?',
  '["A single total scalar sum","A 1D array of 20 elements containing the sum of each column","A 1D array of 10 elements containing the sum of each row","A 2D array of cumulative sums"]'::jsonb,
  1,
  1,
  'Collapsing axis=0 computes sums along the vertical column direction, leaving length 20.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000007'::UUID,
  'd0000000-0000-0000-0214-000000000001'::UUID,
  'What is the distinction between a view and a copy in NumPy slicing?',
  '["Views use more memory than copies","A slice of an array returns a view sharing the same underlying memory buffer; modifying the view modifies the original array","Copies are updated automatically when the original array changes","NumPy never creates views"]'::jsonb,
  1,
  1,
  'Basic indexing and slicing return memory views without copying data. To modify a slice safely without mutating the source, call .copy().',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000008'::UUID,
  'd0000000-0000-0000-0214-000000000002'::UUID,
  'What is the fundamental difference between df.loc and df.iloc in Pandas?',
  '["df.loc is purely integer-based, while df.iloc is label-based","df.loc is label-based and includes the endpoint of slices, while df.iloc is integer-based and excludes the endpoint","df.loc only works on columns, df.iloc only works on rows","df.loc is deprecated in modern Pandas versions"]'::jsonb,
  1,
  1,
  '.loc accesses rows and columns by their index/column names (inclusive of stop bounds), while .iloc accesses by 0-indexed integer positions (half-open range [start, stop)).',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000009'::UUID,
  'd0000000-0000-0000-0214-000000000002'::UUID,
  'Which method should you use to convert a wide-format DataFrame with monthly columns (Jan, Feb, Mar) into a long-format DataFrame with a single Month column?',
  '["pd.pivot_table()","df.melt()","df.groupby()","df.unstack()"]'::jsonb,
  1,
  1,
  'pd.melt() unpivots DataFrames from wide format to long format, gathering identifier and measurement variables.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000010'::UUID,
  'd0000000-0000-0000-0214-000000000002'::UUID,
  'In a SQL-style join performed via pd.merge(df1, df2, how=''left''), what happens to rows in df1 that have no matching key in df2?',
  '["They are excluded from the output DataFrame","They are retained, and the columns from df2 are populated with NaN","The operation raises a KeyError","They are duplicated for every row in df2"]'::jsonb,
  1,
  1,
  'A left outer join preserves every row from the left DataFrame, filling unmatched columns from the right DataFrame with NaN (missing values).',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000011'::UUID,
  'd0000000-0000-0000-0214-000000000002'::UUID,
  'How does the transform method in df.groupby(''category'')[''sales''].transform(''mean'') differ from the agg method?',
  '["transform calculates median instead of mean","transform returns a Series with the exact same index and length as the original DataFrame, broadcasting group statistics across individual rows","transform only works on text columns","transform drops all duplicate values"]'::jsonb,
  1,
  1,
  'While .agg() reduces each group to a single summary row, .transform() broadcasts the calculated group statistic back to align with every original row.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000012'::UUID,
  'd0000000-0000-0000-0214-000000000002'::UUID,
  'Which expression correctly filters a DataFrame df for transactions where category is ''Electronics'' and price is greater than 100?',
  '["df[df[''category''] == ''Electronics'' and df[''price''] > 100]","df[(df[''category''] == ''Electronics'') & (df[''price''] > 100)]","df[df[''category''].isin(''Electronics'') or df[''price''] > 100]","df.filter(''category == Electronics & price > 100'')"]'::jsonb,
  1,
  1,
  'Pandas requires bitwise operators (& for AND, | for OR) with parenthesized boolean conditions due to operator precedence.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000013'::UUID,
  'd0000000-0000-0000-0214-000000000002'::UUID,
  'What is the purpose of df.drop_duplicates(subset=[''email''], keep=''last'')?',
  '["Deletes the email column","Removes all duplicate records sharing an email, keeping only the final occurrence encountered in the DataFrame","Sorts emails in alphabetical order","Replaces duplicate emails with empty strings"]'::jsonb,
  1,
  1,
  'The subset parameter identifies duplicate rows by specific key columns, and keep=''last'' retains the final record while dropping earlier duplicates.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000014'::UUID,
  'd0000000-0000-0000-0214-000000000002'::UUID,
  'Why should you avoid using iterative for-loops like for index, row in df.iterrows() to perform calculations on large DataFrames?',
  '["iterrows() creates Python tuple objects for every row, making it hundreds of times slower than vectorized column expressions or apply()","iterrows() deletes rows after reading them","iterrows() cannot process integer values","iterrows() only reads the first 100 rows"]'::jsonb,
  0,
  1,
  'iterrows() converts each row into a Python Series object on every iteration, destroying NumPy vectorized performance and introducing significant overhead.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000015'::UUID,
  'd0000000-0000-0000-0214-000000000003'::UUID,
  'In an Interquartile Range (IQR) outlier analysis, what are the standard cutoff boundaries for mild outliers?',
  '["Mean +/- 2 Standard Deviations","[Q1 - 1.5 * IQR, Q3 + 1.5 * IQR]","[Q1 - 0.5 * IQR, Q3 + 0.5 * IQR]","[Minimum value, Maximum value]"]'::jsonb,
  1,
  1,
  'Tukey''s boxplot rule identifies values below Q1 - 1.5 * IQR or above Q3 + 1.5 * IQR as outliers.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000016'::UUID,
  'd0000000-0000-0000-0214-000000000003'::UUID,
  'When should Spearman rank correlation be preferred over Pearson correlation coefficient?',
  '["When data has a strictly linear relationship and is normally distributed","When data exhibits non-linear monotonic relationships or contains extreme outliers that distort linear covariance","When the dataset has fewer than 10 samples","Only when working with categorical binary data"]'::jsonb,
  1,
  1,
  'Spearman correlation evaluates monotonic rank order rather than raw linear values, making it robust against non-linear scaling and heavy-tailed outliers.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000017'::UUID,
  'd0000000-0000-0000-0214-000000000003'::UUID,
  'What visualization is best suited for comparing the full probability distribution and density of a continuous metric across multiple categories?',
  '["Pie chart","Violin plot or Box plot","Stacked bar chart","Simple line chart"]'::jsonb,
  1,
  1,
  'Violin plots combine box plots with kernel density estimation (KDE), showing median, quartiles, and distribution shape (e.g. bimodal distributions).',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000018'::UUID,
  'd0000000-0000-0000-0214-000000000003'::UUID,
  'What does a positive skewness value indicate about a feature distribution?',
  '["The distribution is symmetrical","The right tail is elongated and the majority of observations are concentrated to the left of the mean","The left tail is elongated","The variance is negative"]'::jsonb,
  1,
  1,
  'Positive (right) skewness means the tail extends toward larger positive values, pulling the mean to the right of the median.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000019'::UUID,
  'd0000000-0000-0000-0214-000000000003'::UUID,
  'In Matplotlib, why is the object-oriented API (fig, ax = plt.subplots()) preferred for production applications over the pyplot state-machine?',
  '["It runs without Python installed","It provides explicit, modular control over multiple axes, subplots, and figure elements without relying on global implicit state","It prevents users from changing line colors","It only works in Jupyter notebooks"]'::jsonb,
  1,
  1,
  'Explicitly manipulating Figure and Axes objects makes plotting code reusable, testable, and prevents unintended interference across multiple figures.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000020'::UUID,
  'd0000000-0000-0000-0214-000000000003'::UUID,
  'What does a correlation matrix heatmap with diverging colormap (e.g. coolwarm) display along its main diagonal?',
  '["Zero values","Value 1.0 (each feature has a perfect correlation of 1.0 with itself)","Mean values of the features","P-values of the hypothesis test"]'::jsonb,
  1,
  1,
  'The correlation of any variable with itself is by definition 1.0, so the diagonal entries of a correlation matrix are always 1.0.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000021'::UUID,
  'd0000000-0000-0000-0214-000000000003'::UUID,
  'What is the purpose of a Q-Q (Quantile-Quantile) plot in exploratory analysis?',
  '["To compare two independent regression lines","To visually assess whether a sample distribution follows a theoretical distribution (such as Gaussian normal distribution)","To detect missing values across time steps","To calculate the sample variance"]'::jsonb,
  1,
  1,
  'A normal Q-Q plot compares sample quantiles against standard normal theoretical quantiles; data adhering to the 45-degree diagonal line is normally distributed.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000022'::UUID,
  'd0000000-0000-0000-0214-000000000004'::UUID,
  'What does a p-value of 0.03 indicate in a hypothesis test where significance level alpha is set to 0.05?',
  '["There is a 3% probability that the alternative hypothesis is true","Assuming the null hypothesis is true, there is a 3% probability of observing test results at least as extreme as those measured; we reject H0","The experiment has failed and must be restarted","The effect size is exactly 0.03"]'::jsonb,
  1,
  1,
  'A p-value is P(observed data | H0). Because p = 0.03 < alpha (0.05), we reject the null hypothesis in favor of the alternative.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000023'::UUID,
  'd0000000-0000-0000-0214-000000000004'::UUID,
  'What is a Type I error in statistical hypothesis testing?',
  '["Failing to reject the null hypothesis when it is false (False Negative)","Rejecting the null hypothesis when it is actually true (False Positive)","Using the wrong sample size formula","Measuring variables with incorrect units"]'::jsonb,
  1,
  1,
  'A Type I error (probability alpha) occurs when an experiment falsely claims a statistically significant effect when none actually exists.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000024'::UUID,
  'd0000000-0000-0000-0214-000000000004'::UUID,
  'Why is Welch''s t-test generally preferred over Student''s traditional two-sample t-test?',
  '["It does not require normal distributions","It does not assume equal variances between the two comparison groups, making it robust against heteroscedasticity","It works on datasets with zero observations","It gives higher p-values in all experiments"]'::jsonb,
  1,
  1,
  'Welch''s t-test relaxes the homoscedasticity assumption (equal variances) while retaining near-identical power when variances happen to be equal.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000025'::UUID,
  'd0000000-0000-0000-0214-000000000004'::UUID,
  'What is the statistical testing consequence of repeated peeking at conversion data during an active A/B test and stopping early?',
  '["It improves statistical power","It severely inflates the false positive rate (Type I error) far beyond the nominal alpha level of 0.05","It makes the p-value completely constant","It eliminates sampling variance"]'::jsonb,
  1,
  1,
  'Continuous peeking creates multiple testing opportunities for random noise fluctuations to dip below p=0.05, artificially driving false positive rates up to 20-30%.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000026'::UUID,
  'd0000000-0000-0000-0214-000000000004'::UUID,
  'Which statistical test is appropriate for evaluating whether click-through conversion rates (conversions vs non-conversions) differ significantly between variant A and variant B?',
  '["Paired t-test","Pearson Chi-Square test of independence (or Two-proportion Z-test)","One-way ANOVA","Principal Component Analysis"]'::jsonb,
  1,
  1,
  'Comparing counts of categorical outcomes (converted vs not converted) across two independent groups uses a 2x2 contingency table evaluated with Chi-Square or two-proportion Z-test.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000027'::UUID,
  'd0000000-0000-0000-0214-000000000004'::UUID,
  'What does statistical power (1 - beta) represent in an experimentation study?',
  '["The probability of rejecting the null hypothesis when an actual true effect exists (True Positive rate)","The probability of making a Type I error","The ratio of treatment group size to control group size","The maximum allowable execution runtime of the test"]'::jsonb,
  0,
  1,
  'Power is the probability that a test correctly detects an effect of a given minimum detectable size when that effect is truly present (typically targeted at 80% or 90%).',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0314-000000000028'::UUID,
  'd0000000-0000-0000-0214-000000000004'::UUID,
  'In time series analysis, what does an Exponential Moving Average (EMA) do differently than a Simple Moving Average (SMA)?',
  '["EMA assigns equal weight to all past time periods","EMA assigns exponentially decreasing weights to older data points, prioritizing more recent observations","EMA eliminates all trend lines","EMA requires weekly data only"]'::jsonb,
  1,
  1,
  'EMA applies weights that decline exponentially over past time steps, making it respond faster to recent price or volume changes than an SMA.',
  7,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000001'::UUID,
  'd0000000-0000-0000-0215-000000000001'::UUID,
  'What is the core principle of the Minto Pyramid (BLUF - Bottom-Line Upfront)?',
  '["Start with chronological background history before introducing decisions","Present the primary recommendation or conclusion first, followed by structured supporting rationales and data","Avoid using numbers or metrics in document titles","Write documents using poetic metaphors"]'::jsonb,
  1,
  1,
  'BLUF communicates the critical takeaway immediately, respecting busy stakeholders'' time and allowing readers to grasp the core decision before evaluating supporting details.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000002'::UUID,
  'd0000000-0000-0000-0215-000000000001'::UUID,
  'Which sentence demonstrates effective, direct technical prose?',
  '["It was noticed that perhaps the server was running somewhat slowly.","Due to the fact that traffic was high, errors were encountered by users.","High database connection pool saturation increased p99 API latency from 45ms to 1,200ms.","Things did not go as planned during the deployment."]'::jsonb,
  2,
  1,
  'The sentence uses active voice, identifies the exact technical mechanism (connection pool saturation), and provides concrete quantified metrics (p99 latency from 45ms to 1200ms).',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000003'::UUID,
  'd0000000-0000-0000-0215-000000000001'::UUID,
  'Why should passive voice generally be avoided in technical documentation?',
  '["Passive voice makes documents too short","Passive voice often obscures who or what performed the action, creating ambiguity in responsibilities and root causes","Compilers cannot parse passive voice","Passive voice is always grammatically incorrect"]'::jsonb,
  1,
  1,
  'Passive constructions like "the configuration was changed" omit the actor and mechanism, which can cause confusion during incident postmortems.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000004'::UUID,
  'd0000000-0000-0000-0215-000000000001'::UUID,
  'What is the role of an Executive Summary in a 20-page engineering proposal?',
  '["To list all bibliography citations","To provide a self-contained 1-page overview containing problem statement, recommended solution, cost, and expected impact","To copy the table of contents","To provide code listings of all functions"]'::jsonb,
  1,
  1,
  'An executive summary enables technical directors and leadership to evaluate the proposal''s viability and business justification without reading all 20 pages.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000005'::UUID,
  'd0000000-0000-0000-0215-000000000001'::UUID,
  'What is the best way to describe performance requirements in a technical specification?',
  '["\"The system must be blazing fast.\"","\"The API must handle many concurrent users.\"","\"99.9% of read requests must return in under 100ms at loads up to 5,000 requests per second.\"","\"Performance should be optimized as much as possible.\""]'::jsonb,
  2,
  1,
  'Effective engineering requirements are specific, measurable, achievable, and verifiable with clear percentiles and traffic boundaries.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000006'::UUID,
  'd0000000-0000-0000-0215-000000000001'::UUID,
  'In technical communication, what does the term "bikeshedding" (Parkinson''s Law of Triviality) describe?',
  '["Building physical sheds for servers","The tendency of groups to spend disproportionate time debating trivial, easily understood topics while neglecting complex, critical issues","Documenting bike route APIs","Writing code comments in markdown"]'::jsonb,
  1,
  1,
  'Parkinson''s Law of Triviality demonstrates that discussions expand on trivial matters (because everyone has an opinion on them) while complex matters receive little scrutiny.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000007'::UUID,
  'd0000000-0000-0000-0215-000000000002'::UUID,
  'What is the primary purpose of an Architecture Decision Record (ADR)?',
  '["To track employee vacation days","To capture an important architectural decision, its context, chosen alternatives, and positive/negative consequences for future maintainers","To store passwords and API keys","To replace unit tests"]'::jsonb,
  1,
  1,
  'An ADR records the rationale and tradeoffs behind architectural decisions, preventing future engineers from re-debating settled questions without knowing the historical context.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000008'::UUID,
  'd0000000-0000-0000-0215-000000000002'::UUID,
  'What section of an RFC document addresses why alternative approaches were not chosen?',
  '["Glossary","Considered Alternatives / Non-Goals","License","Author Acknowledgements"]'::jsonb,
  1,
  1,
  'Documenting considered alternatives explicitly demonstrates thorough engineering evaluation and explains why alternative tools or architectures were rejected.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000009'::UUID,
  'd0000000-0000-0000-0215-000000000002'::UUID,
  'Why is defining explicit "Non-Goals" crucial in software design specifications?',
  '["To make the document look longer","To protect the project from scope creep by establishing clear boundaries on what the system will NOT attempt to solve","To list bugs that will never be fixed","To prevent other teams from writing code"]'::jsonb,
  1,
  1,
  'Non-goals establish scope boundaries, align stakeholder expectations, and prevent feature creep from delaying deliveries.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000010'::UUID,
  'd0000000-0000-0000-0215-000000000002'::UUID,
  'What standard HTTP header allows clients to safely retry POST requests after network timeouts without risking duplicate processing?',
  '["Authorization","Idempotency-Key","Accept-Encoding","User-Agent"]'::jsonb,
  1,
  1,
  'An Idempotency-Key header enables servers to identify duplicate requests and return the cached original response without reprocessing transactions.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000011'::UUID,
  'd0000000-0000-0000-0215-000000000002'::UUID,
  'What is the benefit of using OpenAPI (formerly Swagger) specifications for REST APIs?',
  '["It eliminates the need for databases","It provides a machine-readable schema that automatically generates interactive documentation, mock servers, and client SDKs","It compiles Python code into C++","It prevents all network errors"]'::jsonb,
  1,
  1,
  'OpenAPI definitions provide a standard contract that synchronizes frontend and backend development while automating documentation generation and SDK production.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000012'::UUID,
  'd0000000-0000-0000-0215-000000000002'::UUID,
  'In an ADR, what must be documented under the "Consequences" section?',
  '["Only the positive benefits expected","Both positive outcomes and negative trade-offs, technical debts, or operational burdens introduced by the decision","A list of employees who disagreed with the decision","A link to download the software"]'::jsonb,
  1,
  1,
  'Every engineering decision involves trade-offs. An honest ADR clearly outlines the costs, maintenance overhead, and new constraints along with the benefits.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000013'::UUID,
  'd0000000-0000-0000-0215-000000000003'::UUID,
  'What is the guiding tenet of a blameless postmortem culture?',
  '["Never document when an outage occurs","View human error as a symptom of fragile systemic designs, and focus investigation on improving guardrails, tools, and processes rather than assigning blame","Blame external third-party cloud providers exclusively","Punish the engineer who made the commit"]'::jsonb,
  1,
  1,
  'Blameless cultures encourage open reporting of mistakes so organizations can engineer systemic safeguards that prevent any single human action from causing catastrophe.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000014'::UUID,
  'd0000000-0000-0000-0215-000000000003'::UUID,
  'What is the primary responsibility of the Incident Commander (IC) during a high-severity production outage?',
  '["Writing code to patch the bug directly","Coordinating response efforts, assigning investigative roles, facilitating communication, and protecting responders from external interruptions","Answering customer support tickets","Updating marketing banners on social media"]'::jsonb,
  1,
  1,
  'The Incident Commander orchestrates the response team, prevents duplication of work, delegates tasks, and maintains clear status communications without getting bogged down in individual debugging.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000015'::UUID,
  'd0000000-0000-0000-0215-000000000003'::UUID,
  'What is Mean Time to Detect (MTTD)?',
  '["The time between the start of an incident and when the engineering team becomes aware of it","The time between alert firing and full resolution","The duration of the postmortem meeting","The time required to roll back code"]'::jsonb,
  0,
  1,
  'MTTD measures the latency between the moment an operational failure or bug is introduced and the moment monitoring or customer reports bring it to engineering attention.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000016'::UUID,
  'd0000000-0000-0000-0215-000000000003'::UUID,
  'What makes an incident action item effective in preventing recurring failures?',
  '["Telling developers to \"be more careful next time\"","Assigning a single owner, a clear delivery deadline, and an automated technical safeguard (e.g. CI validation or circuit breaker)","Archiving the ticket immediately","Scheduling weekly meetings indefinitely"]'::jsonb,
  1,
  1,
  'Action items must address systemic vulnerabilities with automated technical defenses, specific ownership, and tracked delivery timelines.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000017'::UUID,
  'd0000000-0000-0000-0215-000000000003'::UUID,
  'Why are UTC timestamps strictly required when assembling an incident timeline?',
  '["UTC is required by law for all databases","UTC provides an unambiguous, universal standard that prevents confusion when coordinating across distributed teams and global cloud regions","UTC runs faster than local time","UTC eliminates daylight savings adjustments in code only"]'::jsonb,
  1,
  1,
  'Distributed teams and cloud infrastructure operate across different time zones. Standardizing on UTC eliminates ambiguity during chronological incident reconstruction.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000018'::UUID,
  'd0000000-0000-0000-0215-000000000003'::UUID,
  'What is a "dark launch" in progressive delivery?',
  '["Deploying code at midnight","Deploying a feature to production with its user interface disabled or hidden behind a feature flag, allowing backend verification under live production traffic","Launching an unencrypted website","Deleting all monitoring logs"]'::jsonb,
  1,
  1,
  'Dark launches test backend performance, database queries, and system stability under real production load before exposing the new functionality to end users.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000019'::UUID,
  'd0000000-0000-0000-0215-000000000004'::UUID,
  'How does the 5 Whys technique uncover systemic root causes?',
  '["By asking five different engineers who caused the problem","By repeatedly asking \"Why?\" to traverse layers of direct symptoms down to underlying procedural, architectural, or organizational deficiencies","By limiting the investigation to five minutes","By checking five lines of code"]'::jsonb,
  1,
  1,
  'The 5 Whys drills past surface-level symptoms to discover the deeper systemic vulnerabilities that allowed the failure to occur in the first place.',
  1,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000020'::UUID,
  'd0000000-0000-0000-0215-000000000004'::UUID,
  'What are the main branches of an Ishikawa (Fishbone) diagram used for software quality analysis?',
  '["HTML, CSS, JavaScript, SQL","People, Process, Technology/Tools, Environment, and Management","Cost, Revenue, Profit, Margin","Input, Processing, Output, Storage"]'::jsonb,
  1,
  1,
  'Fishbone diagrams categorize causal factors into structured dimensions (People, Process, Tools, Environment), ensuring that analysis is not narrowly restricted to code alone.',
  2,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000021'::UUID,
  'd0000000-0000-0000-0215-000000000004'::UUID,
  'What is the Sunk Cost Fallacy in software project management?',
  '["Underestimating cloud computing costs","Continuing to pour resources into an ineffective or failing approach solely because significant time, money, or effort has already been invested in it","Failing to pay open-source maintainers","Purchasing discounted hardware"]'::jsonb,
  1,
  1,
  'The Sunk Cost Fallacy leads teams to persist with sub-optimal technical choices to justify past expenditures, rather than evaluating future utility objectively.',
  3,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000022'::UUID,
  'd0000000-0000-0000-0215-000000000004'::UUID,
  'What is Not-Invented-Here (NIH) syndrome?',
  '["An aversion to adopting external, existing, and proven solutions, leading teams to build unnecessary in-house custom tools with high maintenance overhead","A licensing issue with proprietary software","Refusing to hire external contractors","Deploying software in foreign cloud regions"]'::jsonb,
  0,
  1,
  'NIH syndrome manifests when engineers reject established industry solutions in favor of custom home-grown alternatives, diverting focus from core business value.',
  4,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000023'::UUID,
  'd0000000-0000-0000-0215-000000000004'::UUID,
  'What does Total Cost of Ownership (TCO) include when evaluating a "Build vs. Buy" architectural decision?',
  '["Only the initial software license fee","Initial development costs, ongoing maintenance, bug fixing, on-call operational overhead, hosting, security updates, and opportunity costs","Only the developer''s hourly wage","The cost of laptop computers"]'::jsonb,
  1,
  1,
  'TCO considers the full lifecycle expenses of building and operating software, demonstrating that "free" internal code often incurs high long-term maintenance costs.',
  5,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

INSERT INTO public.quiz_questions (
  id,
  quiz_id,
  question_text,
  options,
  correct_option_index,
  marks,
  explanation,
  order_index,
  created_at
) VALUES (
  'd0000000-0000-0000-0315-000000000024'::UUID,
  'd0000000-0000-0000-0215-000000000004'::UUID,
  'What is Confirmation Bias in engineering problem diagnosis?',
  '["Requiring two engineers to approve a pull request","The tendency to search for, interpret, and favor information that validates pre-existing hypotheses while ignoring contradicting telemetry data","Sending email confirmations to customers","Verifying database transactions with commit tokens"]'::jsonb,
  1,
  1,
  'Confirmation bias leads responders to focus on logs that support their pet theory about an outage, causing them to overlook contradictory evidence that points to the true cause.',
  6,
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  quiz_id = EXCLUDED.quiz_id,
  question_text = EXCLUDED.question_text,
  options = EXCLUDED.options,
  correct_option_index = EXCLUDED.correct_option_index,
  marks = EXCLUDED.marks,
  explanation = EXCLUDED.explanation,
  order_index = EXCLUDED.order_index;

-- ============================================================================
-- 5. INSERT / UPSERT ASSIGNMENTS (30 Project & Theory Assignments)
-- ============================================================================

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0401-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000001'::UUID,
  'Project 1: Command-Line Personal Expense Tracker with File Persistence',
  '### Assignment Overview
Design and implement a robust, modular Python command-line utility for tracking student expenses. The application must enforce strict input validation, calculate category aggregates, and persist transaction records across sessions.

### Deliverables
1. `expense_tracker.py`: Complete Python script containing clean functions, error handling, and file operations.
2. `sample_expenses.json`: Sample dataset demonstrating at least 8 transactions across 4 categories.
3. `README.md`: Documentation describing installation, CLI usage instructions, and sample input/output logs.

### Requirements & Functional Specifications
- **Data Model**: Store expenses with fields: `id` (UUID or incremental int), `title` (str), `amount` (positive float), `category` (str), and `timestamp` (ISO 8601 string).
- **Core Operations**:
  - Add expense with validation (reject non-numeric, negative, or blank inputs).
  - List all expenses in a clean tabular CLI view.
  - Compute total spending and spending grouped by category.
  - Delete an expense by ID with confirmation.
- **Persistence**: Save records automatically to JSON or CSV format on exit and reload automatically on launch.
- **Error Handling**: Gracefully catch invalid command inputs, corrupted data files, and file permission errors without crashing.

### Evaluation Rubric (Total: 100 Marks)
- **Functional Requirements (40 Marks)**: Correct CRUD implementation, accurate category aggregation, and reliable file persistence.
- **Input Validation & Error Handling (25 Marks)**: Graceful handling of invalid floats, missing files, and non-existent IDs.
- **Code Quality & Architecture (20 Marks)**: Proper modular design, functions with type hints, and PEP 8 style adherence.
- **Documentation & Testing (15 Marks)**: Clear README instructions, edge-case coverage, and valid sample data.',
  NULL,
  NULL,
  '2026-11-30T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0401-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000001'::UUID,
  'Project 2: Object-Oriented Inventory Management System with Custom Exceptions',
  '### Assignment Overview
Develop an object-oriented Python application modeling an academic laboratory equipment inventory. The system must showcase inheritance, custom exception hierarchies, and encapsulated class attributes.

### Deliverables
1. `inventory.py`: Contains `Item`, `PerishableItem`, `EquipmentItem`, and `Inventory` class definitions.
2. `exceptions.py`: Custom exception hierarchy (`InventoryError`, `InsufficientStockError`, `ItemNotFoundError`).
3. `test_inventory.py`: Unit test script verifying operations and exception assertions using `unittest` or `pytest`.

### Requirements & Functional Specifications
- **Class Hierarchy**:
  - Base class `Item` with encapsulated `_name`, `_unit_price`, and `_stock_quantity`.
  - Subclasses `PerishableItem` (adding expiry date and spoilage checks) and `EquipmentItem` (adding maintenance schedules and serial numbers).
- **Custom Exceptions**: Implement explicit error classes raised when attempting to withdraw more stock than available or querying unknown items.
- **Special Methods**: Implement `__str__`, `__repr__`, and `__len__` on the `Inventory` container class.

### Evaluation Rubric (Total: 100 Marks)
- **Object-Oriented Design & Inheritance (35 Marks)**: Proper use of classes, inheritance, encapsulation with `@property`, and `super()`.
- **Custom Exception Handling (25 Marks)**: Accurate hierarchy, meaningful error messages, and proper raising/handling.
- **Special Methods & Protocols (20 Marks)**: Functional implementation of `__str__`, `__repr__`, and container iteration.
- **Test Suite & Verification (20 Marks)**: Automated test cases verifying normal and exceptional paths.',
  NULL,
  NULL,
  '2026-12-15T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0402-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000002'::UUID,
  'Project 1: University Course Registration System Using OOP & Interfaces',
  '### Assignment Overview
Architect an enterprise-style university course registration system in Java. Apply object-oriented principles, interface contracts, custom exceptions, and the Java Collections Framework to model students, professors, courses, and department prerequisites.

### Deliverables
1. `src/` directory containing all Java classes (`Person`, `Student`, `Instructor`, `Course`, `RegistrationService`).
2. `exceptions/` package containing custom checked and unchecked domain exceptions (`CourseFullException`, `PrerequisiteNotMetException`).
3. `Main.java`: Driver demonstration simulating multi-student registration scenarios, prerequisite validations, and error handling.

### Technical Specifications
- **Class Hierarchy**:
  - Abstract base class `Person` with common state (`id`, `name`, `email`).
  - `Student` and `Instructor` extending `Person`.
- **Interface Contract**:
  - `Registrable` interface defining `enrollStudent(Student s)` and `dropStudent(Student s)`.
- **Collections & Constraints**:
  - Enforce maximum course enrollment limits using appropriate collections.
  - Check prerequisite course completions before allowing student enrollment.
- **Robust Exception Handling**:
  - Throw custom checked exceptions when enrollment limits or prerequisite checks are violated.

### Evaluation Rubric (Total: 100 Marks)
- **Object-Oriented Design & Hierarchy (30 Marks)**: Cohesive classes, proper abstraction, and clean inheritance.
- **Interface Implementation & Contracts (25 Marks)**: Consistent use of `Registrable` and decoupling of registration logic.
- **Validation & Custom Exception Architecture (25 Marks)**: Enforcing business invariants and clean exception handling.
- **Collections & Documentation (20 Marks)**: Proper collection choices, encapsulation, and code comments.',
  NULL,
  NULL,
  '2026-11-30T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0402-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000002'::UUID,
  'Project 2: Thread-Safe Banking Transaction Engine with Concurrent Collections',
  '### Assignment Overview
Design and implement a multi-threaded banking transaction simulator in Java. Ensure thread safety, prevent race conditions, and avoid deadlocks when processing concurrent fund transfers between bank accounts.

### Deliverables
1. `BankAccount.java`: Represents an individual account with atomic or synchronized balance operations.
2. `TransactionWorker.java`: Implements `Runnable` to execute randomized credit/debit transfers between accounts.
3. `BankSimulation.java`: Driver program managing thread pools via `ExecutorService`, tracking global invariants, and asserting consistency.

### Requirements & Functional Specifications
- **Thread Safety**: Implement mutual exclusion using explicit locks (`ReentrantLock`) or `synchronized` blocks.
- **Deadlock Avoidance**: Order lock acquisition (e.g., sort account IDs before locking) to guarantee lock hierarchy consistency during transfers.
- **Audit & Invariant Verification**: Verify that the sum of all account balances before and after 1,000 concurrent transfers remains exactly invariant.

### Evaluation Rubric (Total: 100 Marks)
- **Thread Safety & Race Condition Prevention (35 Marks)**: Safe balance mutations under high concurrency.
- **Deadlock Avoidance Architecture (30 Marks)**: Systematic lock ordering preventing cyclic dependencies.
- **Invariant Testing & Correctness (20 Marks)**: Strict preservation of global monetary balance.
- **Code Organization & Cleanliness (15 Marks)**: Proper use of Java concurrency utilities and documentation.',
  NULL,
  NULL,
  '2026-12-15T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0403-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000003'::UUID,
  'Project 1: Custom High-Performance Dynamic Array & Self-Balancing BST Implementation',
  '### Assignment Overview
Implement and evaluate fundamental data structures from scratch in Python, C++, or Java without using high-level built-in collection classes. You will construct a geometrically expanding dynamic array and an AVL self-balancing binary search tree.

### Deliverables
1. `dynamic_array`: Source code implementing `append`, `insert(index, val)`, `delete(index)`, and automatic geometric resizing ($2\times$).
2. `avl_tree`: Source code implementing node insertion, deletion, height calculations, and tree rotations (LL, RR, LR, RL).
3. `benchmark_report.pdf`: Performance graphs comparing insertion times across 10,000 to 1,000,000 elements against raw standard library collections.

### Requirements & Functional Specifications
- **Dynamic Array**:
  - Enforce bounds checking and amortized $O(1)$ appends.
  - Shrink capacity by half when elements drop below 25% capacity to prevent memory thrashing.
- **AVL Tree**:
  - Maintain balance factor in $\{-1, 0, 1\}$ for all nodes after every insert and delete operation.
  - Implement an in-order generator/iterator returning keys in sorted order.

### Evaluation Rubric (Total: 100 Marks)
- **Dynamic Array Correctness & Amortization (30 Marks)**: Correct bounds handling, growth factor implementation, and resizing logic.
- **AVL Balancing & Rotations (35 Marks)**: Accurate balance factor updates and flawless execution of single and double rotations.
- **Asymptotic Benchmark Analysis (20 Marks)**: Thorough empirical timing tests plotted against theoretical Big-O curves.
- **Code Cleanliness & Documentation (15 Marks)**: Clean comments, memory deallocation, and modular organization.',
  NULL,
  NULL,
  '2026-11-30T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0403-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000003'::UUID,
  'Project 2: Campus Route Navigator Using Dijkstra & A* Graph Search',
  '### Assignment Overview
Construct an engineering campus navigation system modeling buildings and pathways as a weighted graph. Implement Dijkstra''s algorithm and the A* heuristic search algorithm to compute optimal walking paths between academic buildings.

### Deliverables
1. `campus_graph.py`: Graph data structure parsing a campus coordinates and pathway distance dataset.
2. `pathfinder.py`: Implementations of Dijkstra and A* search using Euclidean distance heuristics.
3. `benchmark_comparison.md`: Empirical report comparing total nodes visited and execution times between Dijkstra and A*.

### Technical Specifications
- **Graph Modeling**: Represent at least 15 campus locations (vertices) and 30 bidirectional walkways (edges) with positive distance weights and 2D geographic coordinates $(x, y)$.
- **Algorithms**:
  - Dijkstra''s algorithm using a binary min-heap priority queue.
  - A* search using admissible Euclidean straight-line distance $h(n) = \sqrt{(x_2 - x_1)^2 + (y_2 - y_1)^2}$.
- **Validation**: Verify that A* returns an identically optimal distance while expanding fewer nodes than Dijkstra.

### Evaluation Rubric (Total: 100 Marks)
- **Graph Implementation & Min-Heap Priority Queue (30 Marks)**: Efficient adjacency list representation and heap-based priority queue.
- **Dijkstra & A* Algorithm Implementation (35 Marks)**: Correct shortest path discovery, path reconstruction, and heuristic evaluation.
- **Comparative Search Efficiency Benchmark (20 Marks)**: Demonstrated node expansion reduction with A* vs Dijkstra.
- **Code Architecture & Documentation (15 Marks)**: Clear modularity, type hints, and usage documentation.',
  NULL,
  NULL,
  '2026-12-15T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0404-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000004'::UUID,
  'Project 1: Responsive E-Commerce Product Catalog with State Filtering & Cart',
  '### Assignment Overview
Build a high-performance, responsive e-commerce product catalog frontend in React and TypeScript. Implement dynamic category filtering, price range sorting, responsive CSS Grid layout, and cart state persistence using React Context or useReducer.

### Deliverables
1. `src/components/`: Modular React components (`ProductCard`, `FilterSidebar`, `CartDrawer`, `Navbar`).
2. `src/context/CartContext.tsx`: Cart state manager handling item additions, quantity updates, removals, and total price calculation.
3. `src/types/index.ts`: Type-safe interfaces for `Product`, `CartItem`, and `FilterCriteria`.

### Requirements & Functional Specifications
- **Responsive Layout**: Provide a mobile drawer filter and desktop multi-column CSS Grid displaying product cards.
- **Dynamic Search & Filtering**: Instant client-side filtering by category, search text, and price range sliders.
- **Cart State Machine**: Compute taxes and totals accurately; persist state across browser page refreshes via `localStorage`.

### Evaluation Rubric (Total: 100 Marks)
- **Component Architecture & TypeScript Typing (30 Marks)**: Clean props, reusable atomic components, and zero TypeScript `any` types.
- **Responsive UI/UX & CSS Grid Styling (25 Marks)**: Seamless layout adaptation across mobile (375px), tablet (768px), and desktop (1280px).
- **Cart State Management & Persistence (25 Marks)**: Accurate cart math, quantity modifications, and reliable localStorage synchronization.
- **Code Quality & Accessibility (20 Marks)**: Proper ARIA labels, semantic markup, and clean code formatting.',
  NULL,
  NULL,
  '2026-11-30T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0404-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000004'::UUID,
  'Project 2: Full-Stack Task Management Service with RESTful API & JWT Auth',
  '### Assignment Overview
Architect an end-to-end task management web application. Build a RESTful backend API using Node.js/Express, implement JWT token authentication, and connect a React frontend for full task lifecycle management.

### Deliverables
1. `server/`: Backend API implementing `/api/auth/register`, `/api/auth/login`, and protected `/api/tasks` endpoints.
2. `client/`: Frontend React application featuring protected routes, task dashboard, filter tabs, and status updating.
3. `API_DOCUMENTATION.md`: API reference detailing HTTP endpoints, expected JSON payloads, and error status codes.

### Technical Specifications
- **API Design**:
  - Enforce REST conventions: GET (list/filter), POST (create), PATCH (toggle status), DELETE (remove).
  - Password hashing with bcrypt (minimum 10 salt rounds).
  - Middleware verifying JWT Bearer token on all task operations.
- **Frontend Integration**:
  - Store token securely in state/cookies.
  - Implement optimistic UI updates when toggling task completion.

### Evaluation Rubric (Total: 100 Marks)
- **REST API Architecture & HTTP Standards (30 Marks)**: Semantic routes, proper status codes, and input payload validation.
- **Authentication & Security Best Practices (25 Marks)**: Password hashing with bcrypt, JWT verification middleware, and CORS configuration.
- **Frontend Integration & State Flow (25 Marks)**: Clean fetch integration, protected routes, and responsive UI.
- **Documentation & Test Coverage (20 Marks)**: Complete API markdown reference and sample curl/Postman requests.',
  NULL,
  NULL,
  '2026-12-15T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0405-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000005'::UUID,
  'Project 1: Normalized Relational Schema Design & DDL Implementation for Hospital Management',
  '### Assignment Overview
Design a comprehensive, normalized relational database schema for an academic hospital management system. Transform domain requirements into an Entity-Relationship (ER) model, normalize through 3NF and BCNF, and author production DDL scripts with referential integrity.

### Deliverables
1. `schema_design.pdf`: ER diagram and formal normalization proofs showing functional dependencies and candidate keys for every table.
2. `schema.sql`: Production-ready PostgreSQL DDL script with tables, primary keys, foreign keys with ON DELETE rules, and domain CHECK constraints.
3. `seed_data.sql`: Initial seed data populating at least 10 records per entity table.

### Domain Requirements
- Entities: `Patients`, `Physicians`, `Departments`, `Appointments`, `MedicalRecords`, and `Prescriptions`.
- Constraints: Patients cannot be scheduled for two simultaneous appointments; appointment dates cannot be in the past; prescription dosages must be positive.
- Schema Normalization: Demonstrate that all tables satisfy Third Normal Form (3NF) without partial or transitive dependencies.

### Evaluation Rubric (Total: 100 Marks)
- **ER Modeling & Conceptual Design (25 Marks)**: Accurate representation of entities, attributes, primary keys, and cardinality ratios.
- **Normalization Proofs (25 Marks)**: Formal mathematical derivation of functional dependencies and rigorous 3NF/BCNF proofs.
- **DDL Implementation & Integrity Constraints (30 Marks)**: Flawless SQL DDL execution, primary/foreign keys, and check constraints.
- **Seed Scripts & Sample Queries (20 Marks)**: Realistic test records and query validation demonstrations.',
  NULL,
  NULL,
  '2026-11-30T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0405-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000005'::UUID,
  'Project 2: Advanced Analytical SQL Reporting Suite with Window Functions & Query Tuning',
  '### Assignment Overview
Author a multi-query analytical reporting suite for an e-commerce platform dataset. Implement multi-table joins, window functions, ranking logic, and optimize slow execution plans using B-tree indexes and EXPLAIN ANALYZE.

### Deliverables
1. `analytics_queries.sql`: Contains 8 advanced SQL queries answering complex business intelligence questions.
2. `performance_tuning.md`: Before-and-after query optimization documentation analyzing `EXPLAIN (ANALYZE, BUFFERS)` execution plans.
3. `indexes.sql`: Script creating targeted B-tree and composite indexes that accelerate query execution times.

### Analytical Query Specifications
- Query 1: Monthly rolling sales totals and month-over-month growth rates using `LAG()` window functions.
- Query 2: Dense ranking of top 3 performing sales representatives per geographic region.
- Query 3: Cohort retention analysis computing customer repeat purchase rates within 30, 60, and 90-day intervals.
- Query 4: Customer lifetime value (CLV) percentiles using `NTILE(10)`.

### Evaluation Rubric (Total: 100 Marks)
- **Analytical Query Correctness & Complexity (35 Marks)**: Accurate window functions, framing clauses, and aggregation grouping.
- **EXPLAIN Plan Interpretation & Diagnostic Depth (30 Marks)**: Detailed analysis of buffer hits, sequential scans vs index scans, and plan costs.
- **Index Optimization Effectiveness (20 Marks)**: Measurable latency reduction ($>70\%$) demonstrated through before/after metrics.
- **SQL Formatting & Documentation (15 Marks)**: Clean indentation, meaningful aliases, and thorough query commentary.',
  NULL,
  NULL,
  '2026-12-15T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0406-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000006'::UUID,
  'Project 1: CPU Scheduling Simulator & Comparative Performance Analysis',
  '### Assignment Overview
Implement a comprehensive, modular CPU scheduling simulator in C, C++, or Python. Simulate the execution of synthetic workloads across multiple scheduling algorithms, calculating detailed metrics and analyzing performance trade-offs.

### Deliverables
1. `scheduler_sim.py` (or `.c`): Complete simulator source code implementing FCFS, non-preemptive SJF, Preemptive SRTF, and Round Robin (with configurable quantum $q$).
2. `workload_generator.py`: Generates randomized job arrival streams with configurable burst distributions (uniform, exponential).
3. `analysis_report.pdf`: Comparative study plotting Average Waiting Time, Turnaround Time, and Context Switch Counts across varying quanta $q$.

### Functional Specifications
- **Input Format**: Parse text/CSV process tables with columns: `ProcessID`, `ArrivalTime`, `BurstTime`, and `Priority`.
- **Output Metrics**: Produce a formatted execution Gantt chart timeline and compute exact Average Waiting Time, Average Turnaround Time, and CPU Utilization percentage.
- **Parametric Study**: Empirically demonstrate the Convoy Effect under FCFS and identify the optimal Round Robin quantum $q$ for mixed I/O-CPU workloads.

### Evaluation Rubric (Total: 100 Marks)
- **Algorithm Correctness (40 Marks)**: Flawless execution and tie-breaking for FCFS, SJF, SRTF, and Round Robin.
- **Metric Computation & Gantt Visualization (25 Marks)**: Accurate mathematical calculation of turnaround/waiting times and clear timeline visualization.
- **Parametric Benchmarking & Analysis (20 Marks)**: Thorough evaluation of quantum trade-offs and insightful comparative analysis.
- **Code Modularity & Documentation (15 Marks)**: Clean separation of scheduler algorithms, CLI arguments, and well-commented code.',
  NULL,
  NULL,
  '2026-11-30T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0406-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000006'::UUID,
  'Project 2: Deadlock Avoidance Engine & Banker''s Safety Verification',
  '### Assignment Overview
Develop an interactive deadlock avoidance simulator implementing Dijkstra''s Banker''s Algorithm. The engine will evaluate multi-instance resource allocation requests, determine system safety states, and identify safe execution sequences.

### Deliverables
1. `bankers_engine.py`: Core algorithmic library verifying safe states and processing dynamic resource request vectors.
2. `cli_runner.py`: Interactive CLI allowing users to load system resource matrices from JSON, make requests, and inspect safety sequences.
3. `test_cases.json`: Set of at least 5 verification scenarios testing safe states, unsafe rejections, and multi-resource allocations.

### Technical Specifications
- **State Representation**: Maintain Allocation $[n \times m]$, Max $[n \times m]$, Available $[m]$, and Need $[n \times m]$ matrices for $n$ processes and $m$ resource types.
- **Safety Algorithm**: Determine if the system is in a safe state; if safe, output the complete valid safe sequence $\langle P_{i_1}, P_{i_2}, ..., P_{i_n} \rangle$.
- **Resource-Request Algorithm**: Verify requests: $\text{Request} \le \text{Need}$ and $\text{Request} \le \text{Available}$. If valid, simulate allocation and test safety; grant only if the resulting state is safe, otherwise roll back.

### Evaluation Rubric (Total: 100 Marks)
- **Banker''s Safety Algorithm Implementation (35 Marks)**: Accurate matrix subtraction, vector comparison, and correct safe sequence discovery.
- **Resource-Request Safety Evaluation (30 Marks)**: Proper bounds verification, hypothetical state transition, and safe granting/rejection.
- **Edge Case & Unsafe Detection Verification (20 Marks)**: Flawless rejection of unsafe requests and detection of cyclic deadlocks.
- **Code Quality & Documentation (15 Marks)**: Modular design, type safety, and clean interactive demonstration.',
  NULL,
  NULL,
  '2026-12-15T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0407-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000007'::UUID,
  'Project 1: Enterprise Campus Network Subnetting & CIDR Topology Design',
  '### Assignment Overview
Design a comprehensive hierarchical IPv4 addressing and subnetting architecture for a multi-building engineering campus. Allocate variable-length subnets (VLSM) from a single /16 block, minimize IP address waste, and configure routing tables.

### Deliverables
1. `subnetting_plan.pdf`: Complete VLSM addressing table detailing Department, Required Hosts, Allocated CIDR Prefix, Subnet Mask, Network ID, First/Last Usable IP, and Directed Broadcast.
2. `network_topology.png` (or diagram): Visual architectural diagram detailing router interfaces, subnets, and gateway assignments.
3. `router_configs.txt`: Cisco-style or Linux iproute2 configuration commands defining interface IP assignments and static default routes.

### Campus Department Requirements
- Faculty & Research Labs: 1,200 hosts.
- Student Computer Center: 600 hosts.
- Administrative Services: 250 hosts.
- Library & Digital Commons: 120 hosts.
- Data Center Infrastructure: 60 hosts.
- 6 Point-to-Point Router-to-Router Links: 2 hosts each (/30 or /31).

### Evaluation Rubric (Total: 100 Marks)
- **VLSM Calculations & Address Conservation (40 Marks)**: Mathematically flawless allocation with zero address overlap and minimal waste.
- **Subnet Table Completeness (25 Marks)**: Accurate network IDs, masks, usable host boundaries, and broadcast addresses.
- **Topology Diagram & Gateway Architecture (20 Marks)**: Clear visual representation with logical router placement.
- **Configuration Syntax & Documentation (15 Marks)**: Valid configuration commands and thorough engineering justification.',
  NULL,
  NULL,
  '2026-11-30T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0407-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000007'::UUID,
  'Project 2: Python Socket Programming: Custom Reliable File Transfer Protocol over UDP',
  '### Assignment Overview
Implement a reliable file transfer application in Python using raw UDP sockets. Construct a custom Stop-and-Wait or Sliding Window transport protocol on top of unreliable UDP, incorporating sequence numbers, ACKs, timeouts, and checksum verification.

### Deliverables
1. `reliable_sender.py`: Application reading a file, packaging data into custom binary packets, transmitting over UDP, and handling timeouts and retransmissions.
2. `reliable_receiver.py`: Listens on a UDP port, verifies checksums, writes received data in sequence, and transmits acknowledgments.
3. `test_simulation.md`: Verification log testing transmission under synthetic simulated packet loss (10%, 25%) and artificial delay.

### Protocol Specifications
- **Packet Header Format**: 8-byte header containing `SequenceNumber` (32-bit int), `AckNumber` (32-bit int), and `Checksum` (16-bit CRC or Fletcher checksum).
- **Reliability Mechanisms**:
  - Implement dynamic retransmission timeout (RTO) or fixed timer.
  - Detect bit corruption using checksum; discard corrupted packets.
  - Handle duplicate packets caused by delayed retransmissions.

### Evaluation Rubric (Total: 100 Marks)
- **Protocol Packet Architecture & Socket Implementation (35 Marks)**: Clean binary packing/unpacking and correct UDP socket handling.
- **Reliability, Retransmission & Flow Control (35 Marks)**: Successful file transfer under synthetic 20% packet drop without data corruption.
- **Checksum Verification & Integrity Assertions (15 Marks)**: MD5/SHA-256 hash match between source and received files.
- **Code Cleanliness & Documentation (15 Marks)**: Well-structured Python code, CLI argument parsing, and test logs.',
  NULL,
  NULL,
  '2026-12-15T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0408-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000008'::UUID,
  'Project 1: IEEE 830 Software Requirements Specification (SRS) for Campus Food Service',
  '### Assignment Overview
Author an industry-grade Software Requirements Specification (SRS) for a digital campus food ordering and delivery platform following the IEEE 830-1998 standard. Define comprehensive functional requirements, non-functional constraints, and visual UML use-case models.

### Deliverables
1. `SRS_Document.pdf`: Professional SRS document spanning 8–15 pages containing all IEEE 830 sections.
2. `use_case_diagrams/`: UML Use Case diagrams and sequence diagrams detailing student ordering, vendor fulfillment, and payment flows.
3. `traceability_matrix.xlsx`: Requirements Traceability Matrix (RTM) linking business goals to user stories and acceptance test cases.

### Document Sections Required
- Section 1: Introduction, Purpose, Scope, Definitions, and Overview.
- Section 2: Overall Description (Product Perspective, User Classes, Operating Environment, Assumptions).
- Section 3: Specific Requirements:
  - At least 12 detailed Functional Requirements with clear inputs, processing logic, and outputs.
  - At least 8 quantified Non-Functional Requirements covering FURPS+ categories (latency, availability, security, concurrent users).

### Evaluation Rubric (Total: 100 Marks)
- **IEEE 830 Structural Completeness & Professionalism (25 Marks)**: Adherence to standard sections, formal engineering tone, and thoroughness.
- **Functional Requirements Clarity & Testability (30 Marks)**: Unambiguous requirements free of subjective buzzwords, with verifiable criteria.
- **Non-Functional Requirements Quantification (25 Marks)**: Rigorous metrics (e.g. 99.9% uptime, <150ms p95 latency, PCI-DSS compliance).
- **UML Modeling & Traceability (20 Marks)**: Cohesive use case diagrams and complete requirements traceability matrix.',
  NULL,
  NULL,
  '2026-11-30T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0408-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000008'::UUID,
  'Project 2: Automated Unit Testing Suite with Test-Driven Development (TDD) & CI Workflow',
  '### Assignment Overview
Construct a comprehensive automated unit and integration test suite for an e-commerce shopping cart and coupon engine. Apply Test-Driven Development (TDD), achieve $>90\%$ branch coverage, and configure a continuous integration workflow.

### Deliverables
1. `src/`: Business logic classes (`ShoppingCart`, `CouponEngine`, `TaxCalculator`).
2. `tests/`: Test suite written in Jest, Vitest, or pytest implementing unit tests, boundary tests, and mock objects.
3. `coverage_report.html`: HTML test coverage report demonstrating $>90\%$ statement and branch coverage.
4. `.github/workflows/ci.yml`: CI workflow configuration running linter, typecheck, and test commands on pull requests.

### Technical Requirements
- **Test Scenarios**:
  - Test discount code combinations (percentage off, flat discount, minimum order threshold).
  - Test boundary conditions (empty cart, zero quantities, negative values, expired coupons).
  - Use mock objects to isolate tax calculation dependencies and payment gateways.
- **Coverage**: Must achieve at least 90% branch coverage across all business logic modules.

### Evaluation Rubric (Total: 100 Marks)
- **TDD Test Suite Breadth & Assertions (35 Marks)**: Thorough test coverage of normal, boundary, and exceptional scenarios using AAA pattern.
- **Test Doubles & Mocking (25 Marks)**: Proper isolation of external dependencies using stubs and spies.
- **Code Coverage Metrics (20 Marks)**: Verified $>90\%$ statement and branch coverage without artificial test inflation.
- **CI Workflow Configuration & Documentation (20 Marks)**: Working CI pipeline configuration and clear setup instructions.',
  NULL,
  NULL,
  '2026-12-15T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0409-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000009'::UUID,
  'Assignment 1: Classical State-Space Search & A* 8-Puzzle Solver',
  'Implement and evaluate search algorithms to solve the 8-puzzle sliding tile problem:
1. Formulate the 8-puzzle as a state-space search problem: define state representation (tuple of 9 integers), action set {UP, DOWN, LEFT, RIGHT}, transition function, and goal test.
2. Implement Breadth-First Search (BFS) and Uniform Cost Search (UCS) with an explored set to detect and avoid duplicate states.
3. Implement A* search with two distinct heuristics:
   - Heuristic 1: Misplaced Tiles count $h_1(s)$.
   - Heuristic 2: Manhattan Distance sum $h_2(s) = \sum |x_i - x_i^*| + |y_i - y_i^*|$.
4. Benchmark across 50 randomly generated solvable initial states categorized by optimal solution depth ($d = 5, 10, 15, 20$). Compare:
   - Total nodes expanded.
   - Maximum frontier size stored in memory.
   - Wall-clock execution time.
   - Optimality of solution path length.
5. Provide a technical report documenting proof of admissibility and consistency for $h_2$, along with comparative performance tables.',
  NULL,
  NULL,
  '2026-11-20T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0409-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000009'::UUID,
  'Assignment 2: Adversarial Minimax with Alpha-Beta Pruning for Connect-Four',
  'Build an adversarial game-playing engine for Connect-Four (6 rows x 7 columns grid):
1. Represent the game board using bitboards or 2D arrays, with fast move execution and horizontal, vertical, and diagonal win detection.
2. Implement recursive Minimax search with variable depth limits.
3. Implement Alpha-Beta pruning with move ordering heuristics (e.g. evaluating center column moves before outer columns).
4. Construct an evaluation heuristic function for non-terminal leaf positions that rewards:
   - Three-in-a-row with open ends.
   - Center column control.
   - Threat configurations (forcing opponent defensive moves).
5. Add a Transposition Table using Zobrist hashing to cache previously evaluated board configurations with depth, score, and flag (EXACT, LOWERBOUND, UPPERBOUND).
6. Implement an automated tournament pitting depth-4 basic Minimax against depth-6 Alpha-Beta with move ordering, measuring search nodes evaluated and win rates.',
  NULL,
  NULL,
  '2026-11-28T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0410-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000010'::UUID,
  'Assignment 1: Regularized Regression and Optimization from Scratch',
  'Implement and evaluate linear and logistic regression models using NumPy without relying on scikit-learn estimators:
1. Implement standard feature scaling (Z-score normalization).
2. Code Batch Gradient Descent and Mini-batch SGD with momentum for Ordinary Least Squares (OLS) regression.
3. Add L1 (Lasso) and L2 (Ridge) regularization penalties to the cost function and gradient equations.
4. Implement the closed-form Normal Equation with L2 regularization $\theta = (X^T X + \lambda I)^{-1} X^T y$ and verify that gradient descent converges to the same weights.
5. Extend the framework to binary Logistic Regression using the cross-entropy loss function, vectorizing forward predictions and backward gradient calculations.
6. Benchmark on the California Housing dataset (regression) and Breast Cancer Wisconsin dataset (classification):
   - Plot cost vs iterations for varying learning rates $\eta \in \{0.001, 0.01, 0.1, 0.5\}$.
   - Demonstrate the sparsity effect of L1 vs L2 regularization across varying penalty strengths $\lambda$.',
  NULL,
  NULL,
  '2026-11-22T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0410-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000010'::UUID,
  'Assignment 2: End-to-End Ensemble Pipeline & Unsupervised Customer Segmentation',
  'Build a comparative classification and clustering pipeline on tabular financial credit data:
1. **Data Preprocessing:** Handle missing values, encode categorical variables with target/one-hot encoding, and handle class imbalance using SMOTE or class weights.
2. **Supervised Modeling:** Train and cross-validate:
   - Tuned Decision Tree with cost-complexity pruning.
   - Random Forest with out-of-bag (OOB) error estimation.
   - Gradient Boosted Decision Tree (XGBoost or LightGBM).
   - Support Vector Classifier with RBF kernel and grid-searched $(C, \gamma)$.
3. **Model Evaluation:** Report ROC-AUC, Precision-Recall curves, Brier score calibration, and compute SHAP (SHapley Additive exPlanations) values to interpret top risk factors.
4. **Unsupervised Segmentation:**
   - Standardize behavioral features and perform PCA, analyzing eigenvalues and scree plots.
   - Apply K-Means clustering with K-Means++ initialization, validating optimal $K$ via Elbow and Silhouette methods.
   - Fit Gaussian Mixture Models (GMM) with full vs diagonal covariance matrices and analyze cluster assignments.',
  NULL,
  NULL,
  '2026-11-30T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0411-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000011'::UUID,
  'Assignment 1: Mini-Transformer Decoder and Self-Attention from Scratch',
  'Implement a complete autoregressive causal Transformer decoder from scratch using PyTorch:
1. **Multi-Head Self-Attention:** Implement multi-head attention with causal lower-triangular masking, projection matrices ($W_q, W_k, W_v, W_o$), and scaled dot-product attention without using `nn.MultiheadAttention`.
2. **Positional Encoding:** Implement both Sinusoidal positional embeddings and Rotary Position Embeddings (RoPE).
3. **Transformer Block:** Assemble Pre-LN Transformer decoder blocks with RMSNorm/LayerNorm, GELU Feed-Forward Networks, and residual additions.
4. **Causal Language Model:** Build the language model head with tied input/output embedding weights.
5. **Inference Engine:** Implement autoregressive text generation supporting:
   - KV-cache storage for efficient $O(1)$ sequential token generation.
   - Temperature scaling, Top-$k$ filtering, and Top-$p$ (nucleus) sampling.
6. Train the model on the TinyStories or Shakespeare character-level dataset, plotting cross-entropy loss over training steps and showcasing sample completions.',
  NULL,
  NULL,
  '2026-11-25T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0411-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000011'::UUID,
  'Assignment 2: Production-Grade RAG Pipeline with Hybrid Search and Evaluation',
  'Build an enterprise-grade Retrieval-Augmented Generation (RAG) system with hybrid search and automated evaluation:
1. **Document Ingestion & Chunking:** Ingest technical documentation (e.g. documentation markdown or PDF manuals). Implement recursive chunking with configurable chunk sizes (256, 512 tokens) and token overlap.
2. **Dense Vector Indexing:** Generate dense embeddings using Hugging Face transformers and index into a vector store (e.g. FAISS or ChromaDB) using HNSW indexing.
3. **Sparse Keyword Search:** Build a BM25 index on the raw text chunks to handle exact keyword matching, code identifiers, and acronyms.
4. **Hybrid Search & Re-ranking:** Implement Reciprocal Rank Fusion (RRF) combining dense and BM25 candidate ranks. Apply a cross-encoder model to re-score the top 20 candidates and select the top 5 for generation.
5. **Grounded Generation:** Engineer robust system prompts enforcing strict citation grounding (e.g. "[Doc 2, paragraph 1]") and explicit refusal when context is insufficient.
6. **RAG Triad Evaluation:** Implement automated evaluation measuring:
   - Context Relevance (fraction of retrieved context pertinent to query).
   - Groundedness / Faithfulness (verifying claims against retrieved source).
   - Answer Relevance (evaluating if generated answer addresses user prompt).',
  NULL,
  NULL,
  '2026-12-05T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0412-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000012'::UUID,
  'Assignment 1: Matrix Factorization & Numerical Linear Solvers',
  'Implement and analyze foundational linear algebra factorizations in Python using NumPy:
1. **LU Factorization with Partial Pivoting:**
   - Implement $P A = L U$ from scratch without calling scipy.linalg.lu.
   - Implement forward substitution ($L y = P b$) and back substitution ($U x = y$).
   - Test on ill-conditioned Hilbert matrices $H_{ij} = \frac{1}{i + j - 1}$ for $n = 4, 8, 12$, reporting residual norm $\|A x - b\|$ and backward error.
2. **QR Factorization:**
   - Implement Modified Gram-Schmidt (MGS) to produce orthonormal $Q$ and upper-triangular $R$.
   - Implement Householder reflections for QR decomposition and compare numerical orthogonality error $\|Q^T Q - I\|_F$ against MGS.
3. **Application to Overdetermined Linear Systems:**
   - Fit high-degree polynomials ($d = 1$ to $8$) to noisy sensor data using both Normal Equations $(A^T A x = A^T b)$ and QR factorization ($R x = Q^T b$).
   - Demonstrate the condition number squaring effect $\kappa(A^T A) = \kappa(A)^2$ and explain why QR is numerically superior.',
  NULL,
  NULL,
  '2026-11-20T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0412-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000012'::UUID,
  'Assignment 2: SVD Image Compression and Eigenface Face Recognition',
  'Build an image analysis and recognition engine powered by Singular Value Decomposition and Eigendecomposition:
1. **Low-Rank Image Compression via SVD:**
   - Load high-resolution grayscale and RGB photographs.
   - Compute full SVD $A = U \Sigma V^T$.
   - Reconstruct images using rank $k \in \{5, 20, 50, 100\}$.
   - Plot energy retention ratio $\frac{\sum_{i=1}^k \sigma_i^2}{\sum_{i=1}^r \sigma_i^2}$ and Structural Similarity Index (SSIM) versus compression ratio.
2. **Eigenfaces Implementation:**
   - Load the Olivetti or LFW face dataset ($N$ images of size $h \times w$).
   - Flatten images to vectors in $\mathbb{R}^D$ and compute mean face $\Psi$ and centered matrix $\Phi$.
   - Calculate eigenvectors of covariance matrix using the snapshot trick (eigendecomposition of $\Phi^T \Phi$ in $O(N^3)$ rather than $\Phi \Phi^T$ in $O(D^3)$).
   - Display top 10 eigenfaces (principal directions).
   - Project faces onto $K$ eigenface components and build a K-Nearest Neighbor (KNN) classifier, evaluating classification accuracy vs number of retained components.',
  NULL,
  NULL,
  '2026-11-29T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0413-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000013'::UUID,
  'Assignment 1: 32-Bit ALU and Finite State Machine Controller in Verilog/HDL',
  'Design and simulate digital hardware modules using Verilog HDL (or Python digital simulation frameworks):
1. **Arithmetic Logic Unit (ALU):**
   - Implement a modular 32-bit ALU supporting 8 operations: ADD, SUB, AND, OR, XOR, SLT (Set Less Than signed), SLL (Shift Left Logical), and SRL (Shift Right Logical).
   - Generate condition status flags: Zero ($Z$), Negative ($N$), Carry-Out ($C$), and Overflow ($V$).
   - Implement two''s complement subtraction and verify signed overflow detection logic: $V = (A_{31} \cdot \bar{B}_{31} \cdot \bar{S}_{31}) + (\bar{A}_{31} \cdot B_{31} \cdot S_{31})$.
2. **Sequential Traffic Light Controller (FSM):**
   - Implement a synchronous Finite State Machine for an intersection with Main Street, Side Street, and pedestrian crosswalks.
   - Specify Moore machine state transitions: GREEN_MAIN, YELLOW_MAIN, GREEN_SIDE, YELLOW_SIDE, PEDESTRIAN_WALK.
   - Code a testbench applying clock pulses, emergency vehicle priority overrides, and pedestrian sensor inputs.
   - Verify waveform timing, setup/hold constraints, and output hazard freedom.',
  NULL,
  NULL,
  '2026-11-22T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0413-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000013'::UUID,
  'Assignment 2: 5-Stage Pipelined RISC-V Processor Simulator',
  'Develop a cycle-accurate software simulator in Python or C++ modeling a 5-stage pipelined RISC-V processor:
1. **Instruction Fetch & Decode (IF/ID):**
   - Decode RV32I instructions: R-type (`add`, `sub`, `and`, `or`, `slt`), I-type (`addi`, `lw`), S-type (`sw`), B-type (`beq`, `bne`), and J-type (`jal`).
   - Maintain 32 general-purpose registers (with `x0` locked to 0) and Program Counter (`PC`).
2. **Hazard Detection & Forwarding Unit:**
   - Detect Read-After-Write (RAW) data hazards and forward results from EX/MEM and MEM/WB stages directly to ALU inputs.
   - Detect Load-Use hazards and inject a 1-cycle pipeline bubble (stalling IF and ID stages).
   - Handle branch mispredictions by flushing the pipeline (inserting NOPs).
3. **Execution & Memory Simulation:**
   - Simulate a unified 64 KB memory space and measure instructions executed, total clock cycles, Cycles Per Instruction (CPI), and stall breakdown.
   - Execute benchmark programs (e.g. recursive Fibonacci, Array QuickSort) and compare execution cycles with forwarding enabled vs disabled.',
  NULL,
  NULL,
  '2026-12-02T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0414-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000014'::UUID,
  'Assignment 1: E-Commerce Multi-Table Wrangling & Comprehensive EDA Report',
  'Analyze real-world transactional e-commerce data across multiple relational tables:
1. **Relational Data Wrangling:**
   - Ingest 3 datasets: `orders.csv` (order id, customer id, date, status), `order_items.csv` (order id, product id, quantity, price), and `products.csv` (product id, category, cost).
   - Perform inner and outer joins to create an analytics master view.
   - Clean data: impute missing categorical categories, parse ISO datetime strings, and eliminate cancelled/fraudulent transactions.
2. **Feature Engineering & Aggregation:**
   - Compute Customer Lifetime Value (CLV), Average Order Value (AOV), and 30-day repurchase retention rate.
   - Reshape data using `pivot_table` to display quarterly revenue by category and geographical region.
3. **Exploratory Visualizations:**
   - Construct Matplotlib/Seaborn figures: monthly revenue trend with rolling 7-day moving average, boxplots of order value distributions across categories, and a correlation heatmap.
4. **Outlier & Distribution Analysis:**
   - Run IQR and Z-score outlier detection on order values and document how filtering high-value wholesale transactions impacts variance and skewness.',
  NULL,
  NULL,
  '2026-11-24T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0414-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000014'::UUID,
  'Assignment 2: End-to-End A/B Testing Analysis and Hypothesis Evaluation',
  'Design, analyze, and report on a simulated digital product A/B experiment:
1. **Sample Size & Power Calculation:**
   - Pre-experiment power analysis: calculate required sample size per variant for baseline conversion rate of 5.0%, Minimum Detectable Effect (MDE) of 0.5% (relative 10% lift), significance level $\alpha = 0.05$, and power $1 - \beta = 0.80$.
2. **Sanity Checks & Data Validation:**
   - Perform Sample Ratio Mismatch (SRM) test using a Chi-Square goodness-of-fit test to verify that the 50/50 traffic split was not compromised.
3. **Hypothesis Testing:**
   - Test conversion rate differences using Pearson''s Chi-Square test of independence and Two-proportion Z-test, reporting test statistic, p-value, and 95% confidence interval for absolute lift.
   - Test Average Revenue Per User (ARPU) using both Student''s t-test and Welch''s t-test, and run a non-parametric Mann-Whitney U test to handle revenue skewness.
4. **Business Decision Recommendation:**
   - Synthesize results into an executive summary addressing statistical significance, practical economic significance, risks of novelty bias, and launch/no-launch decision.',
  NULL,
  NULL,
  '2026-12-04T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0415-000000000001'::UUID,
  'd0000000-0000-0000-0000-000000000015'::UUID,
  'Assignment 1: Comprehensive Software Architecture RFC & Decision Record',
  'Author a formal Request for Comments (RFC) and an accompanying Architecture Decision Record (ADR) for a complex software migration:
1. **Scenario Selection:**
   Choose one engineering scenario:
   - Migrating a monolithic user authentication service to OAuth2/OIDC with decentralized JWT session validation.
   - Migrating a batch ETL pipeline to real-time event streaming using Apache Kafka and Apache Flink.
   - Replacing synchronous HTTP inter-service communication with gRPC and Protocol Buffers.
2. **RFC Document Structure:**
   - Abstract & Bottom-Line Upfront (BLUF).
   - Problem Statement & Current Architectural Limitations (with quantified throughput/latency pain points).
   - Proposed Architecture (component diagrams, data flows, and failure modes).
   - Detailed Non-Goals and Considered Alternatives (with a weighted decision matrix).
   - Security, Observability, and Rollout Strategy (canary releases, feature flags, rollback triggers).
3. **Architecture Decision Record (ADR):**
   - Write a formal ADR following standard markdown conventions: Status, Context, Decision, and Consequences (positive and negative).',
  NULL,
  NULL,
  '2026-11-26T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

INSERT INTO public.assignments (
  id,
  course_id,
  title,
  description,
  instructions_file_path,
  instructions_file_name,
  due_date,
  max_marks,
  allow_resubmission,
  is_published,
  created_at,
  updated_at
) VALUES (
  'd0000000-0000-0000-0415-000000000002'::UUID,
  'd0000000-0000-0000-0000-000000000015'::UUID,
  'Assignment 2: Production Incident Blameless Postmortem and RCA Investigation',
  'Investigate and document a simulated high-severity production outage using structured Root Cause Analysis frameworks:
1. **Incident Case Study:**
   Analyze a provided multi-system failure: A primary database failover triggered connection storms across 40 backend microservice instances, saturating connection limits and causing cascading cascading 504 Gateway Timeouts across consumer checkout for 48 minutes.
2. **Incident Reconstruction & Timeline:**
   - Compile a minute-by-minute timeline using UTC timestamps covering trigger, initial alerting, triage steps, mitigation, and recovery.
   - Calculate Mean Time to Detect (MTTD), Mean Time to Acknowledge (MTTA), and Mean Time to Recover (MTTR).
3. **Structured Root Cause Analysis:**
   - Perform a full 5 Whys analysis drilling down from direct error symptoms to organizational CI/CD and capacity testing gaps.
   - Construct an Ishikawa (Fishbone) diagram categorizing contributing factors across People, Process, Tools, and Environment.
4. **Preventive Action Plan & Action Items:**
   - Formulate 4 prioritized corrective action items (preventive, detective, and mitigative) following SMART criteria (Specific, Measurable, Achievable, Relevant, Time-bound), specifying owners and automated architectural defenses (e.g. exponential jittered backoff, circuit breakers, and connection poolers).',
  NULL,
  NULL,
  '2026-12-06T23:59:59Z'::TIMESTAMPTZ,
  100,
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  due_date = EXCLUDED.due_date,
  max_marks = EXCLUDED.max_marks,
  allow_resubmission = EXCLUDED.allow_resubmission,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

COMMIT;

-- ============================================================================
-- Verification Summary Query
-- ============================================================================
SELECT 
  (SELECT count(*) FROM public.courses WHERE is_published = true) AS published_courses_count,
  (SELECT count(*) FROM public.lessons) AS lessons_count,
  (SELECT count(*) FROM public.quizzes WHERE is_published = true) AS published_quizzes_count,
  (SELECT count(*) FROM public.quiz_questions) AS quiz_questions_count,
  (SELECT count(*) FROM public.assignments WHERE is_published = true) AS published_assignments_count;
