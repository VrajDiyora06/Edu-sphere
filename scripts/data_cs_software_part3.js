// scripts/data_cs_software_part3.js
// Courses 5-6: DBMS & SQL, Operating Systems Fundamentals

export const coursesPart3 = [
  // -------------------------------------------------------------------------
  // 5. Database Management Systems and SQL
  // -------------------------------------------------------------------------
  {
    id: 'd0000000-0000-0000-0000-000000000005',
    title: 'Database Management Systems and SQL',
    slug: 'database-management-systems-sql',
    description: 'Master relational database theory and modern SQL engineering: ER modeling, relational algebra, schema normalization (1NF to BCNF), complex multi-table joins, window functions, B-tree indexing, ACID transactions, and MVCC concurrency.',
    category: 'Database Engineering',
    level: 'Intermediate',
    thumbnail_url: 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?q=80&w=800&auto=format&fit=crop',
    lessons: [
      {
        id: 'd0000000-0000-0000-0105-000000000001',
        title: 'Relational Database Architecture, Data Models & Relational Algebra',
        duration_minutes: 40,
        is_free_preview: true,
        order_index: 1,
        content: `### Learning Objectives
- Master the ANSI-SPARC Three-Level Architecture: Internal, Conceptual, and External schemas.
- Understand relational data modeling: relations, tuples, attributes, cardinality, and degree.
- Formulate queries using Relational Algebra operators: Selection ($\sigma$), Projection ($\pi$), Cartesian Product ($\times$), Join ($\bowtie$), and Set operations.

### Relational Algebra Fundamental Operators
1. **Selection ($\sigma_{\\text{condition}}(R)$)**: Filters horizontal subsets of tuples satisfying a predicate.
2. **Projection ($\\pi_{A_1, A_2}(R)$)**: Extracts vertical subsets of specified attributes, eliminating duplicate tuples.
3. **Natural Join ($R \\bowtie S$)**: Matches tuples on common attribute names, projecting out duplicates.

$$\\pi_{\\text{name}, \\text{gpa}}(\\sigma_{\\text{gpa} \\ge 3.5}(\\text{Students}))$$

### Key Takeaways
- Relational algebra is a formal procedural query language that provides the mathematical foundation for SQL query planning and optimization.
- Physical data independence shields application code from changes in disk storage, indexing, or physical block allocation.`
      },
      {
        id: 'd0000000-0000-0000-0105-000000000002',
        title: 'Functional Dependencies & Schema Normalization: 1NF to BCNF',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 2,
        content: `### Learning Objectives
- Formally identify Functional Dependencies ($X \\rightarrow Y$) and compute attribute closures ($X^+$).
- Eliminate insertion, update, and deletion anomalies through schema decomposition.
- Understand the criteria for First (1NF), Second (2NF), Third (3NF), and Boyce-Codd Normal Form (BCNF).

### Normalization Ladder
1. **1NF**: All column values must be atomic (no repeating groups, arrays, or composite attributes).
2. **2NF**: In 1NF and no non-prime attribute is partially dependent on any candidate key (eliminates partial dependency).
3. **3NF**: In 2NF and no non-prime attribute is transitively dependent on any candidate key ($X \\rightarrow Y$ where neither $X$ is superkey nor $Y$ is prime).
4. **BCNF**: For every non-trivial functional dependency $X \\rightarrow Y$, $X$ must be a superkey.

### Key Takeaways
- Higher normal forms eliminate data redundancy and prevent update anomalies, but may require additional joins for retrieval.
- 3NF always guarantees dependency preservation and lossless join decomposition; BCNF guarantees lossless join but may not preserve all functional dependencies.`
      },
      {
        id: 'd0000000-0000-0000-0105-000000000003',
        title: 'Declarative SQL Mastery: DDL, DML, Joins & Subqueries',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 3,
        content: `### Learning Objectives
- Write robust DDL statements with primary, foreign key, check, and unique constraints.
- Differentiate between INNER, LEFT OUTER, RIGHT OUTER, FULL OUTER, and CROSS joins.
- Formulate correlated and non-correlated subqueries with \`EXISTS\`, \`IN\`, and \`ANY\`.

### Advanced Join Query Example
\`\`\`sql
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
\`\`\`

### Key Takeaways
- \`WHERE\` filters individual rows before aggregation; \`HAVING\` filters grouped buckets after aggregation.
- Prefer \`EXISTS\` over \`IN\` when evaluating subqueries against large tables with possible NULLs to optimize planner performance.`
      },
      {
        id: 'd0000000-0000-0000-0105-000000000004',
        title: 'Analytical SQL: Aggregations, Grouping Sets & Window Functions',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 4,
        content: `### Learning Objectives
- Compute running totals, rankings, and moving averages using SQL Window Functions.
- Understand the syntax: \`FUNCTION() OVER (PARTITION BY ... ORDER BY ... ROWS BETWEEN ...)\`.
- Apply \`ROW_NUMBER()\`, \`RANK()\`, \`DENSE_RANK()\`, \`LEAD()\`, and \`LAG()\`.

### Window Functions in Practice
Unlike \`GROUP BY\`, which collapses multiple rows into a single summary row, window functions compute aggregate values while retaining individual row identities.

\`\`\`sql
SELECT 
    student_id,
    course_id,
    score,
    DENSE_RANK() OVER (PARTITION BY course_id ORDER BY score DESC) AS course_rank,
    ROUND(AVG(score) OVER (PARTITION BY course_id), 2) AS class_average,
    score - ROUND(AVG(score) OVER (PARTITION BY course_id), 2) AS diff_from_mean
FROM exam_submissions;
\`\`\`

### Key Takeaways
- \`RANK()\` leaves gaps after tied ranks (e.g. 1, 2, 2, 4); \`DENSE_RANK()\` produces contiguous numbering (1, 2, 2, 3).
- \`LEAD()\` and \`LAG()\` access subsequent and preceding rows without self-joins.`
      },
      {
        id: 'd0000000-0000-0000-0105-000000000005',
        title: 'Database Storage Internals: B-Tree Indexing & Query Execution Plans',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 5,
        content: `### Learning Objectives
- Understand disk storage organization: Pages, Slotted Pages, and Buffer Pools.
- Analyze B+ Tree index structures: Root, Internal nodes, Leaf nodes, and Doubly-linked leaf chains.
- Interpret \`EXPLAIN ANALYZE\` execution plans: Sequential Scan vs Index Scan vs Index Only Scan vs Bitmap Scan.

### B+ Tree Index Mechanics
In a B+ Tree index:
- Internal nodes contain only routing search keys and child pointers, maximizing fan-out.
- Leaf nodes contain all actual data pointers/tuples and are linked bidirectionally for $O(\\log n)$ search and $O(k)$ range scans.

\`\`\`
Root:           [ 50 ]
              /        \\
Internal: [ 20, 35 ]   [ 70, 85 ]
Leaves:  [10..19] <-> [20..34] <-> [50..69] <-> [70..84] <-> [85..99]
\`\`\`

### Key Takeaways
- Indexes accelerate search queries but impose write overhead on INSERT, UPDATE, and DELETE operations.
- An **Index Only Scan** fulfills the query entirely from the B+ Tree index without fetching heap pages.`
      },
      {
        id: 'd0000000-0000-0000-0105-000000000006',
        title: 'ACID Transaction Properties, Write-Ahead Logging & Crash Recovery',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 6,
        content: `### Learning Objectives
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
- Checkpoints shorten recovery times by flushing dirty buffers and bounding the required WAL replay window.`
      },
      {
        id: 'd0000000-0000-0000-0105-000000000007',
        title: 'Concurrency Control: Isolation Levels, 2PL & Multi-Version Concurrency (MVCC)',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 7,
        content: `### Learning Objectives
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
Rather than locking rows on read, MVCC stores multiple immutable versions of each row with transaction visibility tags (\`xmin\`, \`xmax\`).
- **Readers never block Writers**.
- **Writers never block Readers**.

### Key Takeaways
- MVCC provides snapshot isolation without heavy read locks, dramatically improving concurrency.
- VACUUM processes reclaim dead tuple versions created by updates and deletes in MVCC engines.`
      }
    ],
    quizzes: [
      {
        id: 'd0000000-0000-0000-0205-000000000001',
        title: 'Relational Modeling & Schema Normalization Quiz',
        description: 'Covers relational algebra, functional dependencies, 1NF, 2NF, 3NF, and BCNF conditions.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0305-000000000001',
            order_index: 1,
            marks: 10,
            question_text: 'What condition must hold for a relation to satisfy Third Normal Form (3NF)?',
            options: [
              'It must be in 2NF and have no transitive functional dependencies of non-prime attributes on candidate keys.',
              'All attributes must be candidate keys.',
              'Every functional dependency must be trivial.',
              'No foreign keys are permitted.'
            ],
            correct_option_index: 0,
            explanation: '3NF requires that the relation is in 2NF and for every non-trivial functional dependency X -> Y, X is a superkey OR Y is a prime attribute (eliminating transitive dependencies).'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000002',
            order_index: 2,
            marks: 10,
            question_text: 'What is a partial dependency in database normalization?',
            options: [
              'A functional dependency where a non-prime attribute depends on only a proper subset of a composite candidate key.',
              'A dependency that holds only for certain rows in the table.',
              'A foreign key reference to another database.',
              'An incomplete transaction.'
            ],
            correct_option_index: 0,
            explanation: 'A partial dependency occurs when a non-prime attribute depends on a part of a composite primary key, which violates Second Normal Form (2NF).'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000003',
            order_index: 3,
            marks: 10,
            question_text: 'What relational algebra operator performs horizontal filtering of tuples matching a conditional predicate?',
            options: ['Selection (σ)', 'Projection (π)', 'Cartesian Product (×)', 'Intersection (∩)'],
            correct_option_index: 0,
            explanation: 'Selection (sigma) selects horizontal rows/tuples satisfying a boolean condition; projection (pi) selects vertical columns/attributes.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000004',
            order_index: 4,
            marks: 10,
            question_text: 'How does Boyce-Codd Normal Form (BCNF) differ from 3NF?',
            options: [
              'In BCNF, for every non-trivial functional dependency X -> Y, X must strictly be a superkey (eliminating the 3NF allowance where Y is a prime attribute).',
              'BCNF allows multi-valued attributes.',
              'BCNF does not require 1NF.',
              'BCNF is weaker than 2NF.'
            ],
            correct_option_index: 0,
            explanation: 'BCNF is strictly stronger than 3NF: it removes the exception that allows Y to be a prime attribute, demanding that the determinant X must always be a superkey.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000005',
            order_index: 5,
            marks: 10,
            question_text: 'What is an insertion anomaly in an un-normalized database table?',
            options: [
              'Inability to record certain information without artificially inserting unrelated dummy data due to excessive attribute coupling.',
              'Hardware disk failure during write operations.',
              'A syntax error in an INSERT statement.',
              'Inserting duplicate primary keys.'
            ],
            correct_option_index: 0,
            explanation: 'An insertion anomaly occurs when facts about an entity cannot be recorded without also recording unrelated attributes of another entity (e.g. adding a new course without any enrolled students).'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000006',
            order_index: 6,
            marks: 10,
            question_text: 'What property guarantees that decomposing relation R into R1 and R2 allows reconstructing R via natural join without creating false spurious tuples?',
            options: ['Lossless Join Decomposition', 'Dependency Preservation', 'Atomic Integrity', 'Referential Cascading'],
            correct_option_index: 0,
            explanation: 'A decomposition is lossless if and only if the intersection of attributes R1 ∩ R2 forms a superkey for at least one of the decomposed relations (R1 or R2).'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000007',
            order_index: 7,
            marks: 10,
            question_text: 'What is a candidate key in relational modeling?',
            options: [
              'A minimal superkey whose proper subsets cannot uniquely identify a tuple.',
              'Any column that contains non-null values.',
              'The primary key of a foreign table.',
              'An index created for query optimization.'
            ],
            correct_option_index: 0,
            explanation: 'A candidate key is a minimal superkey: it uniquely identifies every tuple in the relation and contains no extraneous attributes.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0205-000000000002',
        title: 'Complex SQL Queries, Joins & Window Functions Quiz',
        description: 'Evaluates expertise in SQL joins, aggregation filtering, grouping sets, and windowing clauses.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0305-000000000008',
            order_index: 1,
            marks: 10,
            question_text: 'What is the key difference between RANK() and DENSE_RANK() window functions when handling ties?',
            options: [
              'RANK() skips rank numbers after a tie (e.g. 1, 2, 2, 4), while DENSE_RANK() produces continuous rank numbers without gaps (e.g. 1, 2, 2, 3).',
              'DENSE_RANK() only works on integer columns.',
              'RANK() cannot be partitioned.',
              'DENSE_RANK() requires an unbounded preceding frame.'
            ],
            correct_option_index: 0,
            explanation: 'RANK() generates gaps in ranking order corresponding to the number of tied elements; DENSE_RANK() leaves no numerical gaps.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000009',
            order_index: 2,
            marks: 10,
            question_text: 'Which join type returns all rows from the left table, plus matched rows from the right table, filling missing right columns with NULL?',
            options: ['INNER JOIN', 'LEFT OUTER JOIN', 'FULL OUTER JOIN', 'CROSS JOIN'],
            correct_option_index: 1,
            explanation: 'LEFT OUTER JOIN retains every record from the left table regardless of whether a matching record exists in the right table.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000010',
            order_index: 3,
            marks: 10,
            question_text: 'What clause in a window function defines the subset of rows over which the window calculation is partitioned?',
            options: ['GROUP BY', 'PARTITION BY', 'ORDER BY', 'WINDOW BY'],
            correct_option_index: 1,
            explanation: 'PARTITION BY divides query results into partitions to which the window function is applied independently.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000011',
            order_index: 4,
            marks: 10,
            question_text: 'Why can window functions NOT be used directly inside the WHERE clause of the same query block?',
            options: [
              'Because the WHERE clause is evaluated before window functions in the SQL logical query processing order.',
              'Because SQL prohibits window functions on numeric data.',
              'Because window functions require disk writes.',
              'Because WHERE clauses only accept primary keys.'
            ],
            correct_option_index: 0,
            explanation: 'Logical query evaluation order is: FROM -> WHERE -> GROUP BY -> HAVING -> SELECT (Window Functions) -> ORDER BY. Filtering by a window result requires a CTE or subquery.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000012',
            order_index: 5,
            marks: 10,
            question_text: 'Which SQL function accesses data from the immediately preceding row within a window partition without a self-join?',
            options: ['LAG()', 'LEAD()', 'PREV()', 'FIRST_VALUE()'],
            correct_option_index: 0,
            explanation: 'LAG(column, offset) provides access to a row at a given physical offset prior to the current row within the window partition.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000013',
            order_index: 6,
            marks: 10,
            question_text: 'What is the result of a CROSS JOIN between a table with 10 rows and a table with 20 rows?',
            options: ['30 rows', '200 rows (Cartesian Product)', '20 rows', '0 rows unless a join condition is specified'],
            correct_option_index: 1,
            explanation: 'A CROSS JOIN produces the Cartesian product of both tables: 10 * 20 = 200 total rows.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000014',
            order_index: 7,
            marks: 10,
            question_text: 'What is the purpose of the COALESCE() SQL function?',
            options: [
              'Returns the first non-null expression among its arguments.',
              'Converts strings to lowercase.',
              'Combines two tables into a view.',
              'Counts non-null rows.'
            ],
            correct_option_index: 0,
            explanation: 'COALESCE(val1, val2, ...) evaluates arguments in order and returns the first non-NULL expression.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0205-000000000003',
        title: 'Database Indexing, Query Optimization & Execution Plans Quiz',
        description: 'Covers B+ Tree index structures, hash indexes, EXPLAIN ANALYZE interpretation, and cost models.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0305-000000000015',
            order_index: 1,
            marks: 10,
            question_text: 'Why do relational database engines use B+ Trees rather than standard binary search trees for disk-based indexing?',
            options: [
              'B+ Trees have high fan-out, resulting in shallow trees that minimize expensive disk I/O seek operations, with linked leaves for efficient range scans.',
              'Binary trees cannot store numeric keys.',
              'B+ Trees eliminate the need for primary keys.',
              'Binary trees do not support concurrent reads.'
            ],
            correct_option_index: 0,
            explanation: 'Disk reads fetch pages of 4KB-16KB. High fan-out nodes ensure a B+ Tree index with millions of keys has a height of only 3 to 4, requiring very few disk seeks.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000016',
            order_index: 2,
            marks: 10,
            question_text: 'What execution plan node indicates that the query planner retrieved all required data directly from the index without reading table heap blocks?',
            options: ['Sequential Scan', 'Index Scan', 'Index Only Scan', 'Bitmap Heap Scan'],
            correct_option_index: 2,
            explanation: 'An Index Only Scan satisfies the query solely from the index tree (covering index) without visiting heap pages, maximizing performance.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000017',
            order_index: 3,
            marks: 10,
            question_text: 'On a compound index CREATE INDEX idx_emp ON employees(department_id, salary), which query CANNOT use the index efficiently?',
            options: [
              'WHERE department_id = 10 AND salary > 50000',
              'WHERE department_id = 10',
              'WHERE salary > 50000 (without department_id in predicate)',
              'WHERE department_id = 10 ORDER BY salary'
            ],
            correct_option_index: 2,
            explanation: 'Compound indexes follow the leftmost prefix rule: queries that omit the leading column (department_id) cannot traverse the B-tree efficiently.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000018',
            order_index: 4,
            marks: 10,
            question_text: 'What is the primary drawback of adding excessive indexes to a database table?',
            options: [
              'Every INSERT, UPDATE, and DELETE operation must update all associated indexes, degrading write throughput.',
              'The query planner will fail to execute SELECT queries.',
              'Data corruption occurs when indexes exceed 3.',
              'Foreign key constraints stop functioning.'
            ],
            correct_option_index: 0,
            explanation: 'Every index requires real-time tree rebalancing and page splitting during writes, substantially slowing down data mutation throughput.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000019',
            order_index: 5,
            marks: 10,
            question_text: 'What is a clustered index in database storage?',
            options: [
              'An index that dictates the actual physical order of data rows on the storage disk/pages.',
              'An index that connects multiple database clusters over a network.',
              'An index stored in volatile RAM.',
              'A composite index containing more than 5 columns.'
            ],
            correct_option_index: 0,
            explanation: 'A clustered index determines the physical storage arrangement of data rows in the table; hence a table can have only one clustered index.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000020',
            order_index: 6,
            marks: 10,
            question_text: 'What does the ANALYZE command do in PostgreSQL and relational database systems?',
            options: [
              'It gathers distribution statistics about table contents used by the query planner to calculate execution plan costs.',
              'It deletes fragmented tables.',
              'It decrypts database passwords.',
              'It forces all queries to use sequential scans.'
            ],
            correct_option_index: 0,
            explanation: 'ANALYZE updates planner statistics (histograms, distinct value counts), enabling the query optimizer to make informed plan choices.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000021',
            order_index: 7,
            marks: 10,
            question_text: 'Why does applying a function to an indexed column (e.g. WHERE LOWER(email) = \'user@test.com\') typically prevent standard B-tree index usage?',
            options: [
              'The B-tree index is sorted on the raw email values, not on the transformed output of LOWER(email), forcing a full table scan unless an expression index is created.',
              'LOWER() cannot be executed in SQL.',
              'B-trees only index uppercase characters.',
              'PostgreSQL disables indexes on string columns.'
            ],
            correct_option_index: 0,
            explanation: 'Standard indexes cannot evaluate function results on the fly; an explicit expression index (e.g. CREATE INDEX ON users(LOWER(email))) is required.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0205-000000000004',
        title: 'ACID Transactions & Concurrency Control Mechanisms Quiz',
        description: 'Examines transaction isolation levels, write-ahead logging (WAL), 2PL, and multi-version concurrency control (MVCC).',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0305-000000000022',
            order_index: 1,
            marks: 10,
            question_text: 'What concurrency phenomenon is permitted under the Read Committed isolation level but prohibited under Repeatable Read?',
            options: [
              'Non-Repeatable Read (re-reading the same row within a transaction returns altered data committed by another transaction).',
              'Dirty Read',
              'Deadlock',
              'Write Skew'
            ],
            correct_option_index: 0,
            explanation: 'Under Read Committed, re-reading a row after a concurrent transaction commits updates will see the new values (Non-Repeatable Read). Repeatable Read prevents this anomaly.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000023',
            order_index: 2,
            marks: 10,
            question_text: 'What fundamental rule does Write-Ahead Logging (WAL) enforce to guarantee Durability and Atomicity?',
            options: [
              'Log records describing a database state change must be flushed to non-volatile storage BEFORE the corresponding modified data page is written to disk.',
              'Data pages are written to disk before log records.',
              'All queries must be logged in plain text.',
              'Transactions must commit every 50 milliseconds.'
            ],
            correct_option_index: 0,
            explanation: 'WAL guarantees that if a crash occurs while flushing dirty data pages to disk, the database can reconstruct committed updates (Redo) and rollback uncommitted updates (Undo).'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000024',
            order_index: 3,
            marks: 10,
            question_text: 'How does Multi-Version Concurrency Control (MVCC) eliminate read-write contention?',
            options: [
              'By creating immutable row versions tagged with transaction visibility bounds, allowing readers to read consistent snapshots without acquiring read locks.',
              'By queueing all write operations to run after business hours.',
              'By disallowing simultaneous client connections.',
              'By caching the entire database in CPU L1 cache.'
            ],
            correct_option_index: 0,
            explanation: 'In MVCC, writers create new versions of rows rather than overwriting existing rows in place. Readers view a consistent snapshot, meaning readers never block writers and writers never block readers.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000025',
            order_index: 4,
            marks: 10,
            question_text: 'What is a Dirty Read concurrency anomaly?',
            options: [
              'A transaction reads uncommitted data modifications made by another concurrent transaction that subsequently rolls back.',
              'A query reading corrupted disk sectors.',
              'A read operation that takes longer than 10 seconds.',
              'Reading from an outdated secondary replica.'
            ],
            correct_option_index: 0,
            explanation: 'Dirty reads occur when transaction A views changes made by transaction B before B commits; if B rolls back, transaction A acted on phantom invalid state.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000026',
            order_index: 5,
            marks: 10,
            question_text: 'What does Strict Two-Phase Locking (Strict 2PL) require regarding exclusive locks?',
            options: [
              'All exclusive locks acquired during the growing phase must be held until the transaction fully commits or aborts.',
              'Locks can be released at any time during execution.',
              'Only shared locks are permitted.',
              'Locks expire after 100 milliseconds.'
            ],
            correct_option_index: 0,
            explanation: 'Strict 2PL requires holding all exclusive locks until end-of-transaction (commit/abort), preventing cascading aborts and ensuring strict serializability.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000027',
            order_index: 6,
            marks: 10,
            question_text: 'What is the function of the VACUUM process in PostgreSQL\'s MVCC implementation?',
            options: [
              'It identifies and reclaims physical space occupied by dead row versions (tuples) created by updates and deletes.',
              'It resets all primary key sequence numbers to zero.',
              'It removes table indexes to save RAM.',
              'It drops tables that have had no queries for 30 days.'
            ],
            correct_option_index: 0,
            explanation: 'In PostgreSQL MVCC, UPDATES and DELETES leave old tuple versions on disk; VACUUM sweeps and frees dead tuples so the space can be reused for new rows.'
          },
          {
            id: 'd0000000-0000-0000-0305-000000000028',
            order_index: 7,
            marks: 10,
            question_text: 'Which SQL statement explicitly discards all modifications made within the active transaction block?',
            options: ['ROLLBACK', 'COMMIT', 'DISCARD ALL', 'ABORT SILENT'],
            correct_option_index: 0,
            explanation: 'ROLLBACK terminates the active transaction and undoes all changes made since the transaction began.'
          }
        ]
      }
    ],
    assignments: [
      {
        id: 'd0000000-0000-0000-0405-000000000001',
        title: 'Project 1: Normalized Relational Schema Design & DDL Implementation for Hospital Management',
        description: `### Assignment Overview
Design a comprehensive, normalized relational database schema for an academic hospital management system. Transform domain requirements into an Entity-Relationship (ER) model, normalize through 3NF and BCNF, and author production DDL scripts with referential integrity.

### Deliverables
1. \`schema_design.pdf\`: ER diagram and formal normalization proofs showing functional dependencies and candidate keys for every table.
2. \`schema.sql\`: Production-ready PostgreSQL DDL script with tables, primary keys, foreign keys with ON DELETE rules, and domain CHECK constraints.
3. \`seed_data.sql\`: Initial seed data populating at least 10 records per entity table.

### Domain Requirements
- Entities: \`Patients\`, \`Physicians\`, \`Departments\`, \`Appointments\`, \`MedicalRecords\`, and \`Prescriptions\`.
- Constraints: Patients cannot be scheduled for two simultaneous appointments; appointment dates cannot be in the past; prescription dosages must be positive.
- Schema Normalization: Demonstrate that all tables satisfy Third Normal Form (3NF) without partial or transitive dependencies.

### Evaluation Rubric (Total: 100 Marks)
- **ER Modeling & Conceptual Design (25 Marks)**: Accurate representation of entities, attributes, primary keys, and cardinality ratios.
- **Normalization Proofs (25 Marks)**: Formal mathematical derivation of functional dependencies and rigorous 3NF/BCNF proofs.
- **DDL Implementation & Integrity Constraints (30 Marks)**: Flawless SQL DDL execution, primary/foreign keys, and check constraints.
- **Seed Scripts & Sample Queries (20 Marks)**: Realistic test records and query validation demonstrations.`,
        due_date: '2026-11-30T23:59:59Z',
        max_marks: 100,
        allow_resubmission: true,
        is_published: true
      },
      {
        id: 'd0000000-0000-0000-0405-000000000002',
        title: 'Project 2: Advanced Analytical SQL Reporting Suite with Window Functions & Query Tuning',
        description: `### Assignment Overview
Author a multi-query analytical reporting suite for an e-commerce platform dataset. Implement multi-table joins, window functions, ranking logic, and optimize slow execution plans using B-tree indexes and EXPLAIN ANALYZE.

### Deliverables
1. \`analytics_queries.sql\`: Contains 8 advanced SQL queries answering complex business intelligence questions.
2. \`performance_tuning.md\`: Before-and-after query optimization documentation analyzing \`EXPLAIN (ANALYZE, BUFFERS)\` execution plans.
3. \`indexes.sql\`: Script creating targeted B-tree and composite indexes that accelerate query execution times.

### Analytical Query Specifications
- Query 1: Monthly rolling sales totals and month-over-month growth rates using \`LAG()\` window functions.
- Query 2: Dense ranking of top 3 performing sales representatives per geographic region.
- Query 3: Cohort retention analysis computing customer repeat purchase rates within 30, 60, and 90-day intervals.
- Query 4: Customer lifetime value (CLV) percentiles using \`NTILE(10)\`.

### Evaluation Rubric (Total: 100 Marks)
- **Analytical Query Correctness & Complexity (35 Marks)**: Accurate window functions, framing clauses, and aggregation grouping.
- **EXPLAIN Plan Interpretation & Diagnostic Depth (30 Marks)**: Detailed analysis of buffer hits, sequential scans vs index scans, and plan costs.
- **Index Optimization Effectiveness (20 Marks)**: Measurable latency reduction ($>70\\%$) demonstrated through before/after metrics.
- **SQL Formatting & Documentation (15 Marks)**: Clean indentation, meaningful aliases, and thorough query commentary.`,
        due_date: '2026-12-15T23:59:59Z',
        max_marks: 100,
        allow_resubmission: true,
        is_published: true
      }
    ]
  },

  // -------------------------------------------------------------------------
  // 6. Operating Systems Fundamentals
  // -------------------------------------------------------------------------
  {
    id: 'd0000000-0000-0000-0000-000000000006',
    title: 'Operating Systems Fundamentals',
    slug: 'operating-systems-fundamentals',
    description: 'Undergraduate operating systems engineering: kernel architecture, dual-mode operation, process lifecycles, CPU scheduling algorithms, synchronization primitives (semaphores, mutexes), deadlock characterization, virtual memory paging, and page replacement.',
    category: 'Computer Science',
    level: 'Intermediate',
    thumbnail_url: 'https://images.unsplash.com/photo-1629654297299-c8506221ca97?q=80&w=800&auto=format&fit=crop',
    lessons: [
      {
        id: 'd0000000-0000-0000-0106-000000000001',
        title: 'Kernel Architecture, Dual-Mode CPU Operation & System Calls',
        duration_minutes: 40,
        is_free_preview: true,
        order_index: 1,
        content: `### Learning Objectives
- Understand the hardware-enforced separation between User Mode and Kernel (Privileged) Mode.
- Trace how trap instructions transition CPU execution from user space to kernel interrupt handlers.
- Compare Monolithic Kernels (Linux) with Microkernel architectures (Mach, QNX).

### Dual-Mode Operation & Hardware Protection
To prevent user applications from corrupting hardware or other processes, CPUs implement a mode bit:
- **User Mode (Ring 3)**: CPU restricts privileged instructions (direct I/O, disabling interrupts, memory page table manipulation).
- **Kernel Mode (Ring 0)**: Unrestricted access to all CPU instructions and physical memory.

\`\`\`
User Space:    App executes read()  --->  Syscall Library wrapper
----------------------------------------------------------------------- [Trap / Syscall Instruction]
Kernel Space:  Interrupt Vector Table ---> sys_read() Handler ---> File System Driver ---> Hardware
\`\`\`

### Key Takeaways
- The timer interrupt prevents infinite loops in user applications by preemptively yielding CPU control back to the operating system scheduler.
- System calls execute software interrupts (traps) that switch CPU mode from user to kernel.`
      },
      {
        id: 'd0000000-0000-0000-0106-000000000002',
        title: 'Process Management: Process Control Block (PCB) & Context Switching',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 2,
        content: `### Learning Objectives
- Formulate the 5-state process model: New, Ready, Running, Waiting, and Terminated.
- Analyze the contents of the Process Control Block (PCB): PID, CPU registers, Program Counter, and open file descriptors.
- Compute the computational overhead of context switches.

### Process State Transitions
\`\`\`
[ New ] ---> [ Ready ] <===== Scheduler Dispatch ===== [ Running ] ---> [ Terminated ]
                 ^                                            |
                 |-------- I/O Completion <--- [ Waiting ] <--| (I/O or Event Wait)
\`\`\`

### Context Switch Lifecycle
When the OS switches execution from Process $P_1$ to Process $P_2$:
1. Save the hardware state (registers, program counter, stack pointer) of $P_1$ into $PCB_1$.
2. Update $P_1$'s state (to Ready or Waiting).
3. Select $P_2$ via the CPU scheduler.
4. Switch memory address space (reload CR3 page table register on x86, invalidating TLB entries).
5. Restore hardware registers from $PCB_2$ and set Program Counter to resume $P_2$.

### Key Takeaways
- Context switching is pure computational overhead; the CPU performs no productive application work during a context switch.
- Threads within the same process share heap memory, global variables, and open files, making thread context switches significantly faster than process context switches.`
      },
      {
        id: 'd0000000-0000-0000-0106-000000000003',
        title: 'CPU Scheduling Algorithms: FCFS, SJF, Priority & Round Robin',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 3,
        content: `### Learning Objectives
- Calculate scheduling metrics: Turnaround Time, Waiting Time, Response Time, and CPU Throughput.
- Evaluate non-preemptive algorithms: First-Come First-Served (FCFS) and Shortest Job First (SJF).
- Evaluate preemptive algorithms: Shortest Remaining Time First (SRTF) and Round Robin (RR) with time quantum $q$.

### Scheduling Formulas
$$\\text{Turnaround Time} = \\text{Completion Time} - \\text{Arrival Time}$$
$$\\text{Waiting Time} = \\text{Turnaround Time} - \\text{Burst Time}$$

### Algorithm Trade-offs
- **FCFS**: Simple FIFO queue; suffers from the **Convoy Effect** where short processes wait behind a massive CPU-bound process.
- **SJF / SRTF**: Mathematically provable minimum average waiting time; impossible to implement perfectly in general OS kernels because future CPU burst lengths cannot be known in advance.
- **Round Robin**: Time-sliced preemptive scheduling; small quantum $q$ increases context switch overhead, while infinite $q$ degenerates to FCFS.

### Key Takeaways
- The optimal Round Robin quantum $q$ should be large enough that 80% of CPU bursts are shorter than $q$, minimizing context switch penalties while maintaining responsiveness.`
      },
      {
        id: 'd0000000-0000-0000-0106-000000000004',
        title: 'Process Synchronization: Critical Section Problem, Semaphores & Mutexes',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 4,
        content: `### Learning Objectives
- Formulate the Critical Section Problem and its three mandatory criteria: Mutual Exclusion, Progress, and Bounded Waiting.
- Contrast software solutions (Peterson\'s Algorithm) with hardware atomic instructions (Test-and-Set, Compare-and-Swap).
- Implement counting semaphores and binary semaphores (mutexes) to eliminate race conditions.

### The Semaphore Primitives (Dijkstra)
A semaphore $S$ is an integer variable accessed only through two atomic operations: \`wait()\` (or $P$) and \`signal()\` (or $V$).

\`\`\`c
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
\`\`\`

### Key Takeaways
- Spinlocks (busy-waiting) are acceptable in multi-core kernels for very short durations, but wasteful on single-core systems where yielding the CPU is required.
- Mutexes have ownership (only the thread that locked the mutex can unlock it); semaphores have no ownership and can be signaled by any thread.`
      },
      {
        id: 'd0000000-0000-0000-0106-000000000005',
        title: 'Deadlock Characterization, Prevention, Detection & Banker\'s Algorithm',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 5,
        content: `### Learning Objectives
- Identify Coffman\'s four necessary and sufficient conditions for deadlock: Mutual Exclusion, Hold and Wait, No Preemption, and Circular Wait.
- Implement deadlock avoidance using Dijkstra\'s Banker\'s Algorithm on multi-instance resource systems.
- Construct Resource Allocation Graphs (RAG) and evaluate cycle detection algorithms.

### Banker\'s Safety Algorithm
Given vectors: Available $[m]$, Allocation $[n \\times m]$, Max $[n \\times m]$, and Need $[n \\times m]$ where $\\text{Need}[i][j] = \\text{Max}[i][j] - \\text{Allocation}[i][j]$.
A state is **safe** if there exists a sequence $\\langle P_1, P_2, ..., P_n \\rangle$ such that for each $P_i$, the resources that $P_i$ can still request can be satisfied by currently available resources plus resources held by all preceding $P_j$ ($j < i$).

\`\`\`
1. Work = Available; Finish[i] = false for all i
2. Find index i such that: Finish[i] == false and Need[i] <= Work
   If no such i exists, go to step 4.
3. Work = Work + Allocation[i]; Finish[i] = true; go to step 2.
4. If Finish[i] == true for all i, system is in a SAFE state.
\`\`\`

### Key Takeaways
- Eliminating Circular Wait by imposing a strict global ordering on all resource acquisitions ($R_1 < R_2 < ... < R_m$) is the most practical deadlock prevention technique in real systems.`
      },
      {
        id: 'd0000000-0000-0000-0106-000000000006',
        title: 'Memory Management: Contiguous Allocation, Paging & Translation Lookaside Buffers (TLB)',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 6,
        content: `### Learning Objectives
- Differentiate logical (virtual) addresses from physical hardware memory addresses.
- Calculate address translation offsets using Page Tables: Page Number ($p$) and Offset ($d$).
- Measure Effective Memory Access Time (EMAT) incorporating TLB hit ratios.

### Paging Architecture & Hardware Address Translation
Logical address is divided into:
- Page number $p$: index into the process page table containing the base physical frame number $f$.
- Offset $d$: Displacement within the physical frame ($f \\cdot \\text{page\\_size} + d$).

### Effective Memory Access Time (EMAT)
If memory access time is $T$, TLB search time is $\\epsilon$, and TLB hit ratio is $\\alpha$:
$$\\text{EMAT} = (\\epsilon + T) \\cdot \\alpha + (\\epsilon + 2T) \\cdot (1 - \\alpha)$$

### Key Takeaways
- Paging eliminates external fragmentation completely, although internal fragmentation may occur on the final page of an allocation.
- Multi-level page tables conserve physical memory by allocating sub-page tables only for populated virtual address regions.`
      },
      {
        id: 'd0000000-0000-0000-0106-000000000007',
        title: 'Virtual Memory: Demand Paging, Page Fault Handling & Replacement Algorithms',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 7,
        content: `### Learning Objectives
- Trace the complete 6-step Page Fault handling sequence executed by the OS kernel.
- Implement page replacement algorithms: FIFO, Optimal (MIN), Least Recently Used (LRU), and Second-Chance Clock.
- Understand thrashing, working set models, and page fault frequency controls.

### Page Fault Handling Sequence
1. The CPU checks page table; valid-invalid bit is marked \`0\` (Invalid/Absent).
2. Hardware triggers a page fault trap to the OS kernel.
3. The OS checks internal process tables to verify legal memory reference.
4. Locate a free physical frame (or invoke page replacement to evict a victim page, writing it to swap if dirty).
5. Issue disk I/O to read desired page from swap space into the allocated physical frame.
6. Update page table bit to valid (\`1\`), restore process state, and restart the instruction that caused the fault.

### Page Replacement Algorithms Comparison
- **FIFO**: May suffer from **Bélády\'s Anomaly** (allocating more physical frames increases the total number of page faults).
- **Optimal (MIN)**: Replaces the page that will not be used for the longest period; theoretical benchmark.
- **LRU**: Replaces the page that has not been used for the longest period of time; immune to Bélády\'s anomaly.

### Key Takeaways
- **Thrashing** occurs when a process spends more time swapping pages in and out than executing instructions because its working set exceeds available physical memory.`
      }
    ],
    quizzes: [
      {
        id: 'd0000000-0000-0000-0206-000000000001',
        title: 'OS Architecture, System Calls & Process Lifecycle Quiz',
        description: 'Covers user/kernel mode, trap instructions, process states, and PCB context switching.',
        time_limit_minutes: 15,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0306-000000000001',
            order_index: 1,
            marks: 10,
            question_text: 'What mechanism prevents a user program from monopolizing the CPU indefinitely in a preemptive operating system?',
            options: [
              'Hardware Timer Interrupt',
              'Software while loop checking',
              'Automatic compiler code insertion',
              'Manual keyboard interrupt'
            ],
            correct_option_index: 0,
            explanation: 'The hardware timer generates periodic interrupts that invoke the kernel interrupt handler, ensuring the OS regains CPU control to schedule other tasks.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000002',
            order_index: 2,
            marks: 10,
            question_text: 'What is the primary difference between a program and a process in operating systems theory?',
            options: [
              'A program is a passive entity stored on disk (executable file), whereas a process is an active program in execution with allocated memory and program counter.',
              'A program is written in C; a process is written in assembly.',
              'A program requires a GPU; a process requires a CPU.',
              'There is no difference.'
            ],
            correct_option_index: 0,
            explanation: 'A program is passive code stored on secondary storage; a process is dynamic, holding active runtime state in memory.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000003',
            order_index: 3,
            marks: 10,
            question_text: 'What hardware transition occurs when a user application executes a system call such as read() or write()?',
            options: [
              'The CPU executes a software interrupt (trap) switching the hardware mode bit from User Mode to Kernel Mode.',
              'The CPU reboots.',
              'The operating system deletes the process PCB.',
              'The CPU increases clock frequency.'
            ],
            correct_option_index: 0,
            explanation: 'System calls trigger a trap instruction that switches the processor into privileged Kernel Mode to execute trusted kernel service routines.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000004',
            order_index: 4,
            marks: 10,
            question_text: 'Which data structure does the operating system maintain for every active process to preserve its execution state during context switching?',
            options: ['Process Control Block (PCB)', 'Inode Table', 'Virtual Memory Buffer', 'Interrupt Vector Table'],
            correct_option_index: 0,
            explanation: 'The PCB stores the process ID, state, program counter, registers, scheduling priority, memory limits, and open file descriptors.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000005',
            order_index: 5,
            marks: 10,
            question_text: 'Why does switching between two threads in the same process have lower overhead than switching between two distinct processes?',
            options: [
              'Threads share the same virtual address space and open file table, avoiding the need to flush and reload memory page tables and TLBs.',
              'Threads do not use CPU registers.',
              'Threads bypass the operating system scheduler.',
              'Threads do not have stack memory.'
            ],
            correct_option_index: 0,
            explanation: 'Because threads within a process share memory mapping, a thread context switch preserves the virtual memory mapping and TLB cache lines.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000006',
            order_index: 6,
            marks: 10,
            question_text: 'When a process is waiting for disk I/O to complete, which state does it occupy in the 5-state process model?',
            options: ['Ready', 'Waiting (Blocked)', 'Running', 'New'],
            correct_option_index: 1,
            explanation: 'A process waiting for an external event (such as disk I/O or network packet) resides in the Waiting (Blocked) state until the event completes.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000007',
            order_index: 7,
            marks: 10,
            question_text: 'What type of kernel architecture moves device drivers, file systems, and virtual memory into user space, keeping only minimal IPC and scheduling in kernel mode?',
            options: ['Monolithic Kernel', 'Microkernel', 'Hybrid Kernel', 'Exokernel'],
            correct_option_index: 1,
            explanation: 'Microkernels (e.g. Mach, QNX) minimize kernel code by running system services as unprivileged user-space servers communicating via IPC.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0206-000000000002',
        title: 'CPU Scheduling Algorithms & Preemption Metrics Quiz',
        description: 'Tests calculation of turnaround/waiting times across FCFS, SJF, Priority, and Round Robin scheduling.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0306-000000000008',
            order_index: 1,
            marks: 10,
            question_text: 'What algorithm provably minimizes the average waiting time for a given set of stationary processes?',
            options: [
              'First-Come, First-Served (FCFS)',
              'Shortest Job First (SJF)',
              'Round Robin with quantum = 1ms',
              'Priority Scheduling with aging'
            ],
            correct_option_index: 1,
            explanation: 'Shortest Job First (SJF) is mathematically optimal because scheduling shorter jobs earlier reduces the cumulative waiting time for all subsequent processes.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000009',
            order_index: 2,
            marks: 10,
            question_text: 'What is the Convoy Effect in First-Come, First-Served (FCFS) scheduling?',
            options: [
              'A scenario where short CPU/IO-bound processes wait behind a single long CPU-bound process, degrading device utilization.',
              'A network routing bottleneck.',
              'Multiple CPU cores running identical tasks.',
              'Deadlock caused by circular dependency.'
            ],
            correct_option_index: 0,
            explanation: 'The Convoy Effect occurs in FCFS when a long CPU-intensive process holds the processor, forcing all subsequent short I/O-bound processes to wait.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000010',
            order_index: 3,
            marks: 10,
            question_text: 'What happens to the Round Robin scheduling algorithm as the time quantum approaches infinity (q -> ∞)?',
            options: [
              'It degenerates into First-Come, First-Served (FCFS).',
              'It becomes Shortest Job First.',
              'It causes a kernel panic.',
              'Context switch overhead increases exponentially.'
            ],
            correct_option_index: 0,
            explanation: 'If the time quantum exceeds the longest CPU burst, every process completes in its first slice, rendering Round Robin identical to FCFS.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000011',
            order_index: 4,
            marks: 10,
            question_text: 'What technique prevents starvation of low-priority processes in priority scheduling systems?',
            options: ['Aging (gradually increasing process priority the longer it waits in the ready queue)', 'Preemption disablement', 'Memory paging', 'Spinlocking'],
            correct_option_index: 0,
            explanation: 'Aging gradually boosts the priority of long-waiting processes, guaranteeing they will eventually become the highest-priority task and execute.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000012',
            order_index: 5,
            marks: 10,
            question_text: 'How is the Turnaround Time of a process defined?',
            options: [
              'Completion Time minus Arrival Time',
              'Burst Time minus Waiting Time',
              'Waiting Time plus Arrival Time',
              'Completion Time minus Burst Time'
            ],
            correct_option_index: 0,
            explanation: 'Turnaround Time represents the entire elapsed duration from process submission to process termination: Turnaround Time = Completion Time - Arrival Time.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000013',
            order_index: 6,
            marks: 10,
            question_text: 'What is the preemptive version of the Shortest Job First (SJF) algorithm called?',
            options: [
              'Shortest Remaining Time First (SRTF)',
              'Multilevel Feedback Queue',
              'Earliest Deadline First',
              'Round Robin'
            ],
            correct_option_index: 0,
            explanation: 'Shortest Remaining Time First (SRTF) preempts the currently running process if a new process arrives with a shorter remaining CPU burst.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000014',
            order_index: 7,
            marks: 10,
            question_text: 'Why is setting the Round Robin time quantum extremely small (e.g. 1 microsecond) impractical in real operating systems?',
            options: [
              'The CPU would spend a disproportionate percentage of its cycles performing context switches rather than executing application code.',
              'Processes cannot execute for less than 1 millisecond.',
              'Timers cannot measure microseconds.',
              'It violates mutual exclusion.'
            ],
            correct_option_index: 0,
            explanation: 'If quantum is too small, context switch overhead dominates CPU time, drastically reducing throughput and overall system performance.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0206-000000000003',
        title: 'Synchronization, Race Conditions & Deadlock Avoidance Quiz',
        description: 'Covers semaphores, critical section criteria, Coffman conditions, and Banker\'s algorithm.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0306-000000000015',
            order_index: 1,
            marks: 10,
            question_text: 'Which of the following is NOT one of the three requirements for a valid solution to the Critical Section Problem?',
            options: ['Mutual Exclusion', 'Progress', 'Bounded Waiting', 'Equal Execution Speed'],
            correct_option_index: 3,
            explanation: 'The three required criteria are Mutual Exclusion, Progress, and Bounded Waiting; no assumptions may be made about relative process execution speeds.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000016',
            order_index: 2,
            marks: 10,
            question_text: 'What are Coffman\'s four necessary and sufficient conditions for a system deadlock to occur?',
            options: [
              'Mutual Exclusion, Hold and Wait, No Preemption, and Circular Wait.',
              'Paging, Segmentation, Swapping, and Thrashing.',
              'Starvation, Aging, Context Switching, and Preemption.',
              'First In, First Out, Priority, and Quantum.'
            ],
            correct_option_index: 0,
            explanation: 'Deadlock can arise if and only if all four conditions hold simultaneously: Mutual Exclusion, Hold & Wait, No Preemption, and Circular Wait.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000017',
            order_index: 3,
            marks: 10,
            question_text: 'What algorithm is used for deadlock avoidance in a system with multiple instances of each resource type?',
            options: ['Banker\'s Algorithm', 'Peterson\'s Algorithm', 'Dijkstra\'s Shortest Path', 'Kruskal\'s Algorithm'],
            correct_option_index: 0,
            explanation: 'Dijkstra\'s Banker\'s Algorithm evaluates whether granting a resource request leaves the system in a safe state with a valid execution sequence.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000018',
            order_index: 4,
            marks: 10,
            question_text: 'What does a negative value of a counting semaphore S (S < 0) represent in its implementation with a wait queue?',
            options: [
              'The absolute value |S| equals the number of processes currently blocked in the semaphore\'s waiting queue.',
              'An arithmetic overflow error.',
              'The number of available free resources.',
              'The number of active CPU cores.'
            ],
            correct_option_index: 0,
            explanation: 'In queue-based semaphore implementations, when S < 0, the magnitude |S| represents the exact count of processes currently suspended waiting for that semaphore.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000019',
            order_index: 5,
            marks: 10,
            question_text: 'What practical deadlock prevention strategy breaks the Circular Wait condition?',
            options: [
              'Imposing a strict global linear ordering on all resource types and requiring processes to request resources in strictly ascending order.',
              'Terminating all processes periodically.',
              'Doubling available RAM.',
              'Using only un-synchronized variables.'
            ],
            correct_option_index: 0,
            explanation: 'Enforcing a total ordering on resources (F: R -> N) and requiring processes to request resources in strictly increasing order mathematically prevents circular dependency cycles.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000020',
            order_index: 6,
            marks: 10,
            question_text: 'What is Priority Inversion in concurrent systems?',
            options: [
              'A high-priority task is indirectly preempted by a medium-priority task while waiting for a shared resource held by a low-priority task.',
              'Low priority tasks executing faster than high priority tasks.',
              'Reversing scheduling queues.',
              'A deadlock between CPU registers.'
            ],
            correct_option_index: 0,
            explanation: 'Priority inversion occurs when a low-priority process holding a lock is preempted by medium-priority processes, causing a high-priority process waiting on that lock to be blocked indefinitely.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000021',
            order_index: 7,
            marks: 10,
            question_text: 'What protocol resolves Priority Inversion by temporarily elevating the lock holder\'s priority to match the highest-priority waiting process?',
            options: ['Priority Inheritance Protocol', 'Round Robin Rotation', 'Banker\'s Escalation', 'Aging Protocol'],
            correct_option_index: 0,
            explanation: 'The Priority Inheritance Protocol elevates the priority of the lock-holding task to the highest priority among all tasks waiting for that lock until it releases the resource.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0206-000000000004',
        title: 'Virtual Memory, Paging & Page Replacement Algorithms Quiz',
        description: 'Examines page tables, TLB hits, Bélády\'s anomaly, LRU, and working set thrashing.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0306-000000000022',
            order_index: 1,
            marks: 10,
            question_text: 'What is Bélády\'s Anomaly in virtual memory page replacement?',
            options: [
              'A phenomenon where increasing the number of physical page frames results in an INCREASE in the total number of page faults under the FIFO algorithm.',
              'A hardware bug causing memory corruption.',
              'Thrashing caused by recursive functions.',
              'TLB misses exceeding 90%.'
            ],
            correct_option_index: 0,
            explanation: 'Bélády\'s Anomaly demonstrates that for non-stack algorithms like FIFO, giving a process more memory frames can paradoxically increase total page faults for certain reference strings.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000023',
            order_index: 2,
            marks: 10,
            question_text: 'What is the purpose of the Translation Lookaside Buffer (TLB) in the CPU memory management unit (MMU)?',
            options: [
              'A fast hardware associative cache that stores recent virtual-to-physical page translation entries to avoid extra memory accesses.',
              'A disk partition dedicated to virtual swap.',
              'An array storing CPU instruction opcodes.',
              'A secondary heap memory.'
            ],
            correct_option_index: 0,
            explanation: 'The TLB caches active virtual-to-physical address translations in hardware; a TLB hit translates addresses in a fraction of a nanosecond without reading page tables from RAM.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000024',
            order_index: 3,
            marks: 10,
            question_text: 'What condition causes a system to experience Thrashing in virtual memory?',
            options: [
              'The sum of the working set sizes of all active processes exceeds the total available physical RAM, causing the system to spend virtually all its time swapping pages to and from disk.',
              'The CPU clock speed is too high for memory bus bandwidth.',
              'A program with infinite loop executes.',
              'A page replacement algorithm runs out of disk swap space.'
            ],
            correct_option_index: 0,
            explanation: 'Thrashing occurs when active processes lack sufficient frames to hold their working sets, causing continuous back-to-back page faults and disk I/O queuing.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000025',
            order_index: 4,
            marks: 10,
            question_text: 'Which page replacement algorithm evicts the page that will not be referenced for the longest duration in the future (serving as the theoretical gold standard)?',
            options: [
              'Optimal Page Replacement (OPT / MIN)',
              'Least Recently Used (LRU)',
              'First-In First-Out (FIFO)',
              'Least Frequently Used (LFU)'
            ],
            correct_option_index: 0,
            explanation: 'The Optimal algorithm (MIN) achieves the lowest possible page fault rate by evicting the page with the farthest future reference, though it cannot be implemented without future knowledge.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000026',
            order_index: 5,
            marks: 10,
            question_text: 'What type of memory fragmentation is completely eliminated by paging?',
            options: ['External Fragmentation', 'Internal Fragmentation', 'Page Table Fragmentation', 'Cache Fragmentation'],
            correct_option_index: 0,
            explanation: 'Because any physical frame can be allocated to any process regardless of contiguity, paging completely eliminates external fragmentation.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000027',
            order_index: 6,
            marks: 10,
            question_text: 'In a 32-bit virtual address architecture with a 4 KB page size (4096 = 2^12 bytes), how many bits are used for the page offset?',
            options: ['12 bits', '20 bits', '32 bits', '16 bits'],
            correct_option_index: 0,
            explanation: 'Since 4096 = 2^12, the lowest 12 bits represent the page offset d, leaving the upper 20 bits (32 - 12) for the page number p.'
          },
          {
            id: 'd0000000-0000-0000-0306-000000000028',
            order_index: 7,
            marks: 10,
            question_text: 'What algorithm approximates Least Recently Used (LRU) using a circular queue and a reference bit?',
            options: ['Second-Chance (Clock) Algorithm', 'Bélády\'s Counter', 'Peterson\'s Loop', 'Banker\'s Sieve'],
            correct_option_index: 0,
            explanation: 'The Clock (Second-Chance) algorithm inspects the reference bit of pages circularly: if the bit is 0, the page is evicted; if 1, the bit is cleared to 0 and the hand advances.'
          }
        ]
      }
    ],
    assignments: [
      {
        id: 'd0000000-0000-0000-0406-000000000001',
        title: 'Project 1: CPU Scheduling Simulator & Comparative Performance Analysis',
        description: `### Assignment Overview
Implement a comprehensive, modular CPU scheduling simulator in C, C++, or Python. Simulate the execution of synthetic workloads across multiple scheduling algorithms, calculating detailed metrics and analyzing performance trade-offs.

### Deliverables
1. \`scheduler_sim.py\` (or \`.c\`): Complete simulator source code implementing FCFS, non-preemptive SJF, Preemptive SRTF, and Round Robin (with configurable quantum $q$).
2. \`workload_generator.py\`: Generates randomized job arrival streams with configurable burst distributions (uniform, exponential).
3. \`analysis_report.pdf\`: Comparative study plotting Average Waiting Time, Turnaround Time, and Context Switch Counts across varying quanta $q$.

### Functional Specifications
- **Input Format**: Parse text/CSV process tables with columns: \`ProcessID\`, \`ArrivalTime\`, \`BurstTime\`, and \`Priority\`.
- **Output Metrics**: Produce a formatted execution Gantt chart timeline and compute exact Average Waiting Time, Average Turnaround Time, and CPU Utilization percentage.
- **Parametric Study**: Empirically demonstrate the Convoy Effect under FCFS and identify the optimal Round Robin quantum $q$ for mixed I/O-CPU workloads.

### Evaluation Rubric (Total: 100 Marks)
- **Algorithm Correctness (40 Marks)**: Flawless execution and tie-breaking for FCFS, SJF, SRTF, and Round Robin.
- **Metric Computation & Gantt Visualization (25 Marks)**: Accurate mathematical calculation of turnaround/waiting times and clear timeline visualization.
- **Parametric Benchmarking & Analysis (20 Marks)**: Thorough evaluation of quantum trade-offs and insightful comparative analysis.
- **Code Modularity & Documentation (15 Marks)**: Clean separation of scheduler algorithms, CLI arguments, and well-commented code.`,
        due_date: '2026-11-30T23:59:59Z',
        max_marks: 100,
        allow_resubmission: true,
        is_published: true
      },
      {
        id: 'd0000000-0000-0000-0406-000000000002',
        title: 'Project 2: Deadlock Avoidance Engine & Banker\'s Safety Verification',
        description: `### Assignment Overview
Develop an interactive deadlock avoidance simulator implementing Dijkstra's Banker's Algorithm. The engine will evaluate multi-instance resource allocation requests, determine system safety states, and identify safe execution sequences.

### Deliverables
1. \`bankers_engine.py\`: Core algorithmic library verifying safe states and processing dynamic resource request vectors.
2. \`cli_runner.py\`: Interactive CLI allowing users to load system resource matrices from JSON, make requests, and inspect safety sequences.
3. \`test_cases.json\`: Set of at least 5 verification scenarios testing safe states, unsafe rejections, and multi-resource allocations.

### Technical Specifications
- **State Representation**: Maintain Allocation $[n \\times m]$, Max $[n \\times m]$, Available $[m]$, and Need $[n \\times m]$ matrices for $n$ processes and $m$ resource types.
- **Safety Algorithm**: Determine if the system is in a safe state; if safe, output the complete valid safe sequence $\\langle P_{i_1}, P_{i_2}, ..., P_{i_n} \\rangle$.
- **Resource-Request Algorithm**: Verify requests: $\\text{Request} \\le \\text{Need}$ and $\\text{Request} \\le \\text{Available}$. If valid, simulate allocation and test safety; grant only if the resulting state is safe, otherwise roll back.

### Evaluation Rubric (Total: 100 Marks)
- **Banker\'s Safety Algorithm Implementation (35 Marks)**: Accurate matrix subtraction, vector comparison, and correct safe sequence discovery.
- **Resource-Request Safety Evaluation (30 Marks)**: Proper bounds verification, hypothetical state transition, and safe granting/rejection.
- **Edge Case & Unsafe Detection Verification (20 Marks)**: Flawless rejection of unsafe requests and detection of cyclic deadlocks.
- **Code Quality & Documentation (15 Marks)**: Modular design, type safety, and clean interactive demonstration.`,
        due_date: '2026-12-15T23:59:59Z',
        max_marks: 100,
        allow_resubmission: true,
        is_published: true
      }
    ]
  }
];
