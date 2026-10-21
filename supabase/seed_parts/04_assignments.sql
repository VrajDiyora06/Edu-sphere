-- Part 4: Assignments (30 Assignments)
BEGIN;
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0401-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000001'::UUID, 'Project 1: Command-Line Personal Expense Tracker with File Persistence', '### Assignment Overview
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
- **Documentation & Testing (15 Marks)**: Clear README instructions, edge-case coverage, and valid sample data.', NULL, NULL, '2026-11-30T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0401-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000001'::UUID, 'Project 2: Object-Oriented Inventory Management System with Custom Exceptions', '### Assignment Overview
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
- **Test Suite & Verification (20 Marks)**: Automated test cases verifying normal and exceptional paths.', NULL, NULL, '2026-12-15T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0402-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000002'::UUID, 'Project 1: University Course Registration System Using OOP & Interfaces', '### Assignment Overview
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
- **Collections & Documentation (20 Marks)**: Proper collection choices, encapsulation, and code comments.', NULL, NULL, '2026-11-30T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0402-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000002'::UUID, 'Project 2: Thread-Safe Banking Transaction Engine with Concurrent Collections', '### Assignment Overview
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
- **Code Organization & Cleanliness (15 Marks)**: Proper use of Java concurrency utilities and documentation.', NULL, NULL, '2026-12-15T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0403-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000003'::UUID, 'Project 1: Custom High-Performance Dynamic Array & Self-Balancing BST Implementation', '### Assignment Overview
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
- **Code Cleanliness & Documentation (15 Marks)**: Clean comments, memory deallocation, and modular organization.', NULL, NULL, '2026-11-30T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0403-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000003'::UUID, 'Project 2: Campus Route Navigator Using Dijkstra & A* Graph Search', '### Assignment Overview
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
- **Code Architecture & Documentation (15 Marks)**: Clear modularity, type hints, and usage documentation.', NULL, NULL, '2026-12-15T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0404-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000004'::UUID, 'Project 1: Responsive E-Commerce Product Catalog with State Filtering & Cart', '### Assignment Overview
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
- **Code Quality & Accessibility (20 Marks)**: Proper ARIA labels, semantic markup, and clean code formatting.', NULL, NULL, '2026-11-30T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0404-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000004'::UUID, 'Project 2: Full-Stack Task Management Service with RESTful API & JWT Auth', '### Assignment Overview
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
- **Documentation & Test Coverage (20 Marks)**: Complete API markdown reference and sample curl/Postman requests.', NULL, NULL, '2026-12-15T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0405-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000005'::UUID, 'Project 1: Normalized Relational Schema Design & DDL Implementation for Hospital Management', '### Assignment Overview
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
- **Seed Scripts & Sample Queries (20 Marks)**: Realistic test records and query validation demonstrations.', NULL, NULL, '2026-11-30T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0405-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000005'::UUID, 'Project 2: Advanced Analytical SQL Reporting Suite with Window Functions & Query Tuning', '### Assignment Overview
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
- **SQL Formatting & Documentation (15 Marks)**: Clean indentation, meaningful aliases, and thorough query commentary.', NULL, NULL, '2026-12-15T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0406-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000006'::UUID, 'Project 1: CPU Scheduling Simulator & Comparative Performance Analysis', '### Assignment Overview
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
- **Code Modularity & Documentation (15 Marks)**: Clean separation of scheduler algorithms, CLI arguments, and well-commented code.', NULL, NULL, '2026-11-30T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0406-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000006'::UUID, 'Project 2: Deadlock Avoidance Engine & Banker''s Safety Verification', '### Assignment Overview
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
- **Code Quality & Documentation (15 Marks)**: Modular design, type safety, and clean interactive demonstration.', NULL, NULL, '2026-12-15T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0407-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000007'::UUID, 'Project 1: Enterprise Campus Network Subnetting & CIDR Topology Design', '### Assignment Overview
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
- **Configuration Syntax & Documentation (15 Marks)**: Valid configuration commands and thorough engineering justification.', NULL, NULL, '2026-11-30T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0407-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000007'::UUID, 'Project 2: Python Socket Programming: Custom Reliable File Transfer Protocol over UDP', '### Assignment Overview
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
- **Code Cleanliness & Documentation (15 Marks)**: Well-structured Python code, CLI argument parsing, and test logs.', NULL, NULL, '2026-12-15T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0408-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000008'::UUID, 'Project 1: IEEE 830 Software Requirements Specification (SRS) for Campus Food Service', '### Assignment Overview
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
- **UML Modeling & Traceability (20 Marks)**: Cohesive use case diagrams and complete requirements traceability matrix.', NULL, NULL, '2026-11-30T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0408-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000008'::UUID, 'Project 2: Automated Unit Testing Suite with Test-Driven Development (TDD) & CI Workflow', '### Assignment Overview
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
- **CI Workflow Configuration & Documentation (20 Marks)**: Working CI pipeline configuration and clear setup instructions.', NULL, NULL, '2026-12-15T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0409-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000009'::UUID, 'Assignment 1: Classical State-Space Search & A* 8-Puzzle Solver', 'Implement and evaluate search algorithms to solve the 8-puzzle sliding tile problem:
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
5. Provide a technical report documenting proof of admissibility and consistency for $h_2$, along with comparative performance tables.', NULL, NULL, '2026-11-20T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0409-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000009'::UUID, 'Assignment 2: Adversarial Minimax with Alpha-Beta Pruning for Connect-Four', 'Build an adversarial game-playing engine for Connect-Four (6 rows x 7 columns grid):
1. Represent the game board using bitboards or 2D arrays, with fast move execution and horizontal, vertical, and diagonal win detection.
2. Implement recursive Minimax search with variable depth limits.
3. Implement Alpha-Beta pruning with move ordering heuristics (e.g. evaluating center column moves before outer columns).
4. Construct an evaluation heuristic function for non-terminal leaf positions that rewards:
   - Three-in-a-row with open ends.
   - Center column control.
   - Threat configurations (forcing opponent defensive moves).
5. Add a Transposition Table using Zobrist hashing to cache previously evaluated board configurations with depth, score, and flag (EXACT, LOWERBOUND, UPPERBOUND).
6. Implement an automated tournament pitting depth-4 basic Minimax against depth-6 Alpha-Beta with move ordering, measuring search nodes evaluated and win rates.', NULL, NULL, '2026-11-28T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0410-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000010'::UUID, 'Assignment 1: Regularized Regression and Optimization from Scratch', 'Implement and evaluate linear and logistic regression models using NumPy without relying on scikit-learn estimators:
1. Implement standard feature scaling (Z-score normalization).
2. Code Batch Gradient Descent and Mini-batch SGD with momentum for Ordinary Least Squares (OLS) regression.
3. Add L1 (Lasso) and L2 (Ridge) regularization penalties to the cost function and gradient equations.
4. Implement the closed-form Normal Equation with L2 regularization $\theta = (X^T X + \lambda I)^{-1} X^T y$ and verify that gradient descent converges to the same weights.
5. Extend the framework to binary Logistic Regression using the cross-entropy loss function, vectorizing forward predictions and backward gradient calculations.
6. Benchmark on the California Housing dataset (regression) and Breast Cancer Wisconsin dataset (classification):
   - Plot cost vs iterations for varying learning rates $\eta \in \{0.001, 0.01, 0.1, 0.5\}$.
   - Demonstrate the sparsity effect of L1 vs L2 regularization across varying penalty strengths $\lambda$.', NULL, NULL, '2026-11-22T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0410-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000010'::UUID, 'Assignment 2: End-to-End Ensemble Pipeline & Unsupervised Customer Segmentation', 'Build a comparative classification and clustering pipeline on tabular financial credit data:
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
   - Fit Gaussian Mixture Models (GMM) with full vs diagonal covariance matrices and analyze cluster assignments.', NULL, NULL, '2026-11-30T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0411-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000011'::UUID, 'Assignment 1: Mini-Transformer Decoder and Self-Attention from Scratch', 'Implement a complete autoregressive causal Transformer decoder from scratch using PyTorch:
1. **Multi-Head Self-Attention:** Implement multi-head attention with causal lower-triangular masking, projection matrices ($W_q, W_k, W_v, W_o$), and scaled dot-product attention without using `nn.MultiheadAttention`.
2. **Positional Encoding:** Implement both Sinusoidal positional embeddings and Rotary Position Embeddings (RoPE).
3. **Transformer Block:** Assemble Pre-LN Transformer decoder blocks with RMSNorm/LayerNorm, GELU Feed-Forward Networks, and residual additions.
4. **Causal Language Model:** Build the language model head with tied input/output embedding weights.
5. **Inference Engine:** Implement autoregressive text generation supporting:
   - KV-cache storage for efficient $O(1)$ sequential token generation.
   - Temperature scaling, Top-$k$ filtering, and Top-$p$ (nucleus) sampling.
6. Train the model on the TinyStories or Shakespeare character-level dataset, plotting cross-entropy loss over training steps and showcasing sample completions.', NULL, NULL, '2026-11-25T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0411-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000011'::UUID, 'Assignment 2: Production-Grade RAG Pipeline with Hybrid Search and Evaluation', 'Build an enterprise-grade Retrieval-Augmented Generation (RAG) system with hybrid search and automated evaluation:
1. **Document Ingestion & Chunking:** Ingest technical documentation (e.g. documentation markdown or PDF manuals). Implement recursive chunking with configurable chunk sizes (256, 512 tokens) and token overlap.
2. **Dense Vector Indexing:** Generate dense embeddings using Hugging Face transformers and index into a vector store (e.g. FAISS or ChromaDB) using HNSW indexing.
3. **Sparse Keyword Search:** Build a BM25 index on the raw text chunks to handle exact keyword matching, code identifiers, and acronyms.
4. **Hybrid Search & Re-ranking:** Implement Reciprocal Rank Fusion (RRF) combining dense and BM25 candidate ranks. Apply a cross-encoder model to re-score the top 20 candidates and select the top 5 for generation.
5. **Grounded Generation:** Engineer robust system prompts enforcing strict citation grounding (e.g. "[Doc 2, paragraph 1]") and explicit refusal when context is insufficient.
6. **RAG Triad Evaluation:** Implement automated evaluation measuring:
   - Context Relevance (fraction of retrieved context pertinent to query).
   - Groundedness / Faithfulness (verifying claims against retrieved source).
   - Answer Relevance (evaluating if generated answer addresses user prompt).', NULL, NULL, '2026-12-05T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0412-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000012'::UUID, 'Assignment 1: Matrix Factorization & Numerical Linear Solvers', 'Implement and analyze foundational linear algebra factorizations in Python using NumPy:
1. **LU Factorization with Partial Pivoting:**
   - Implement $P A = L U$ from scratch without calling scipy.linalg.lu.
   - Implement forward substitution ($L y = P b$) and back substitution ($U x = y$).
   - Test on ill-conditioned Hilbert matrices $H_{ij} = \frac{1}{i + j - 1}$ for $n = 4, 8, 12$, reporting residual norm $\|A x - b\|$ and backward error.
2. **QR Factorization:**
   - Implement Modified Gram-Schmidt (MGS) to produce orthonormal $Q$ and upper-triangular $R$.
   - Implement Householder reflections for QR decomposition and compare numerical orthogonality error $\|Q^T Q - I\|_F$ against MGS.
3. **Application to Overdetermined Linear Systems:**
   - Fit high-degree polynomials ($d = 1$ to $8$) to noisy sensor data using both Normal Equations $(A^T A x = A^T b)$ and QR factorization ($R x = Q^T b$).
   - Demonstrate the condition number squaring effect $\kappa(A^T A) = \kappa(A)^2$ and explain why QR is numerically superior.', NULL, NULL, '2026-11-20T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0412-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000012'::UUID, 'Assignment 2: SVD Image Compression and Eigenface Face Recognition', 'Build an image analysis and recognition engine powered by Singular Value Decomposition and Eigendecomposition:
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
   - Project faces onto $K$ eigenface components and build a K-Nearest Neighbor (KNN) classifier, evaluating classification accuracy vs number of retained components.', NULL, NULL, '2026-11-29T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0413-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000013'::UUID, 'Assignment 1: 32-Bit ALU and Finite State Machine Controller in Verilog/HDL', 'Design and simulate digital hardware modules using Verilog HDL (or Python digital simulation frameworks):
1. **Arithmetic Logic Unit (ALU):**
   - Implement a modular 32-bit ALU supporting 8 operations: ADD, SUB, AND, OR, XOR, SLT (Set Less Than signed), SLL (Shift Left Logical), and SRL (Shift Right Logical).
   - Generate condition status flags: Zero ($Z$), Negative ($N$), Carry-Out ($C$), and Overflow ($V$).
   - Implement two''s complement subtraction and verify signed overflow detection logic: $V = (A_{31} \cdot \bar{B}_{31} \cdot \bar{S}_{31}) + (\bar{A}_{31} \cdot B_{31} \cdot S_{31})$.
2. **Sequential Traffic Light Controller (FSM):**
   - Implement a synchronous Finite State Machine for an intersection with Main Street, Side Street, and pedestrian crosswalks.
   - Specify Moore machine state transitions: GREEN_MAIN, YELLOW_MAIN, GREEN_SIDE, YELLOW_SIDE, PEDESTRIAN_WALK.
   - Code a testbench applying clock pulses, emergency vehicle priority overrides, and pedestrian sensor inputs.
   - Verify waveform timing, setup/hold constraints, and output hazard freedom.', NULL, NULL, '2026-11-22T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0413-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000013'::UUID, 'Assignment 2: 5-Stage Pipelined RISC-V Processor Simulator', 'Develop a cycle-accurate software simulator in Python or C++ modeling a 5-stage pipelined RISC-V processor:
1. **Instruction Fetch & Decode (IF/ID):**
   - Decode RV32I instructions: R-type (`add`, `sub`, `and`, `or`, `slt`), I-type (`addi`, `lw`), S-type (`sw`), B-type (`beq`, `bne`), and J-type (`jal`).
   - Maintain 32 general-purpose registers (with `x0` locked to 0) and Program Counter (`PC`).
2. **Hazard Detection & Forwarding Unit:**
   - Detect Read-After-Write (RAW) data hazards and forward results from EX/MEM and MEM/WB stages directly to ALU inputs.
   - Detect Load-Use hazards and inject a 1-cycle pipeline bubble (stalling IF and ID stages).
   - Handle branch mispredictions by flushing the pipeline (inserting NOPs).
3. **Execution & Memory Simulation:**
   - Simulate a unified 64 KB memory space and measure instructions executed, total clock cycles, Cycles Per Instruction (CPI), and stall breakdown.
   - Execute benchmark programs (e.g. recursive Fibonacci, Array QuickSort) and compare execution cycles with forwarding enabled vs disabled.', NULL, NULL, '2026-12-02T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0414-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000014'::UUID, 'Assignment 1: E-Commerce Multi-Table Wrangling & Comprehensive EDA Report', 'Analyze real-world transactional e-commerce data across multiple relational tables:
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
   - Run IQR and Z-score outlier detection on order values and document how filtering high-value wholesale transactions impacts variance and skewness.', NULL, NULL, '2026-11-24T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0414-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000014'::UUID, 'Assignment 2: End-to-End A/B Testing Analysis and Hypothesis Evaluation', 'Design, analyze, and report on a simulated digital product A/B experiment:
1. **Sample Size & Power Calculation:**
   - Pre-experiment power analysis: calculate required sample size per variant for baseline conversion rate of 5.0%, Minimum Detectable Effect (MDE) of 0.5% (relative 10% lift), significance level $\alpha = 0.05$, and power $1 - \beta = 0.80$.
2. **Sanity Checks & Data Validation:**
   - Perform Sample Ratio Mismatch (SRM) test using a Chi-Square goodness-of-fit test to verify that the 50/50 traffic split was not compromised.
3. **Hypothesis Testing:**
   - Test conversion rate differences using Pearson''s Chi-Square test of independence and Two-proportion Z-test, reporting test statistic, p-value, and 95% confidence interval for absolute lift.
   - Test Average Revenue Per User (ARPU) using both Student''s t-test and Welch''s t-test, and run a non-parametric Mann-Whitney U test to handle revenue skewness.
4. **Business Decision Recommendation:**
   - Synthesize results into an executive summary addressing statistical significance, practical economic significance, risks of novelty bias, and launch/no-launch decision.', NULL, NULL, '2026-12-04T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0415-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000015'::UUID, 'Assignment 1: Comprehensive Software Architecture RFC & Decision Record', 'Author a formal Request for Comments (RFC) and an accompanying Architecture Decision Record (ADR) for a complex software migration:
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
   - Write a formal ADR following standard markdown conventions: Status, Context, Decision, and Consequences (positive and negative).', NULL, NULL, '2026-11-26T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
INSERT INTO public.assignments (id, course_id, title, description, instructions_file_path, instructions_file_name, due_date, max_marks, allow_resubmission, is_published, created_at, updated_at) VALUES ('d0000000-0000-0000-0415-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000015'::UUID, 'Assignment 2: Production Incident Blameless Postmortem and RCA Investigation', 'Investigate and document a simulated high-severity production outage using structured Root Cause Analysis frameworks:
1. **Incident Case Study:**
   Analyze a provided multi-system failure: A primary database failover triggered connection storms across 40 backend microservice instances, saturating connection limits and causing cascading cascading 504 Gateway Timeouts across consumer checkout for 48 minutes.
2. **Incident Reconstruction & Timeline:**
   - Compile a minute-by-minute timeline using UTC timestamps covering trigger, initial alerting, triage steps, mitigation, and recovery.
   - Calculate Mean Time to Detect (MTTD), Mean Time to Acknowledge (MTTA), and Mean Time to Recover (MTTR).
3. **Structured Root Cause Analysis:**
   - Perform a full 5 Whys analysis drilling down from direct error symptoms to organizational CI/CD and capacity testing gaps.
   - Construct an Ishikawa (Fishbone) diagram categorizing contributing factors across People, Process, Tools, and Environment.
4. **Preventive Action Plan & Action Items:**
   - Formulate 4 prioritized corrective action items (preventive, detective, and mitigative) following SMART criteria (Specific, Measurable, Achievable, Relevant, Time-bound), specifying owners and automated architectural defenses (e.g. exponential jittered backoff, circuit breakers, and connection poolers).', NULL, NULL, '2026-12-06T23:59:59Z'::TIMESTAMPTZ, 100, true, true, NOW(), NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, description = EXCLUDED.description, due_date = EXCLUDED.due_date, max_marks = EXCLUDED.max_marks, allow_resubmission = EXCLUDED.allow_resubmission, is_published = EXCLUDED.is_published, updated_at = NOW();
COMMIT;
