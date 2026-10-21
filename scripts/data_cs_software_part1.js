// scripts/data_cs_software_part1.js
// Courses 1-2: Python Programming, Java Programming & OOP Design

export const coursesPart1 = [
  // -------------------------------------------------------------------------
  // 1. Python Programming: Beginner to Intermediate
  // -------------------------------------------------------------------------
  {
    id: 'd0000000-0000-0000-0000-000000000001',
    title: 'Python Programming: Beginner to Intermediate',
    slug: 'python-programming-beginner-to-intermediate',
    description: 'Master foundational to intermediate Python programming: dynamic typing, control flow, functions, compound data structures, object-oriented design, error handling, and file I/O.',
    category: 'Computer Science',
    level: 'Beginner',
    thumbnail_url: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?q=80&w=800&auto=format&fit=crop',
    lessons: [
      {
        id: 'd0000000-0000-0000-0101-000000000001',
        title: 'Python Architecture, Dynamic Typing & Primitive Data Types',
        duration_minutes: 35,
        is_free_preview: true,
        order_index: 1,
        content: `### Learning Objectives
- Understand the CPython execution pipeline: source code to bytecode compilation and PVM execution.
- Master dynamic typing, reference semantics, and garbage collection mechanisms.
- Work effectively with primitive types: \`int\`, \`float\`, \`bool\`, and \`str\`.

### CPython Architecture
Python is an interpreted, dynamically typed language. When you execute a script \`python main.py\`, CPython compiles the source into bytecode (\`.pyc\` files) stored in memory or \`__pycache__\`. The Python Virtual Machine (PVM) reads and executes these bytecode instructions sequentially.

\`\`\`python
# Variable names are references to heap objects
a = 42
b = a
print(id(a) == id(b))  # True: both reference the same integer object
a = a + 1
print(id(a) == id(b))  # False: integers are immutable; new object allocated
\`\`\`

### Primitive Types and Operations
- **Integers**: Arbitrary precision in Python 3; no integer overflow limit.
- **Floats**: Implemented as C IEEE 754 double-precision floats (64-bit).
- **Strings**: Immutable sequences of Unicode code points.

\`\`\`python
temperature = 98.6
status = "Optimal"
reading_count = 1000

formatted = f"Status: {status} | Temp: {temperature:.1f}F | Total: {reading_count:,}"
print(formatted)
\`\`\`

### Key Takeaways
- Variables in Python are pointers/references to heap objects, not typed memory buckets.
- Immutable primitives (\`int\`, \`float\`, \`str\`, \`tuple\`) cannot be modified in place; reassignments create new objects.`
      },
      {
        id: 'd0000000-0000-0000-0101-000000000002',
        title: 'Control Flow, Loops, and Iteration Protocols',
        duration_minutes: 40,
        is_free_preview: false,
        order_index: 2,
        content: `### Learning Objectives
- Implement conditional branching using \`if\`, \`elif\`, \`else\`, and ternary expressions.
- Master bounded iteration with \`for\` loops and unbounded iteration with \`while\` loops.
- Understand the iterator protocol: \`__iter__()\` and \`__next__()\`.

### Conditional Logic
Python evaluates truthiness according to standard rules: empty collections, zero values, and \`None\` evaluate to \`False\`; non-empty collections evaluate to \`True\`.

\`\`\`python
threshold = 85.0
current_load = 92.4

alert_level = "CRITICAL" if current_load > 90.0 else ("WARNING" if current_load > threshold else "NORMAL")
print(f"Server Alert Level: {alert_level}")
\`\`\`

### Looping Constructs & Iterator Protocol
\`\`\`python
# Enumerate provides index-value tuples
metrics = [12.4, 14.8, 19.2, 11.0]
for idx, val in enumerate(metrics, start=1):
    if val > 15.0:
        print(f"Sample #{idx} breached safety limit: {val}")
        break
else:
    # Executes only if loop terminates without hitting break
    print("All samples within normal parameters.")
\`\`\`

### Key Takeaways
- The \`for...else\` construct runs the \`else\` block only if the loop ran to completion without encountering a \`break\` statement.
- \`zip()\` and \`enumerate()\` provide memory-efficient generator iterators over sequences.`
      },
      {
        id: 'd0000000-0000-0000-0101-000000000003',
        title: 'Functions, Scoping Rules (LEGB), and Lambda Expressions',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 3,
        content: `### Learning Objectives
- Define functions with positional, default, \`*args\`, and \`**kwargs\` parameters.
- Master variable resolution through the LEGB rule (Local, Enclosing, Global, Built-in).
- Apply higher-order functional tools: \`map()\`, \`filter()\`, and anonymous \`lambda\` functions.

### Parameter Passing & Default Value Pitfalls
In Python, arguments are passed by **assignment** (object reference). Mutable default arguments retain state across invocations.

\`\`\`python
# Correct pattern for mutable defaults:
def append_event(event_name: str, event_log: list = None) -> list:
    if event_log is None:
        event_log = []
    event_log.append(event_name)
    return event_log
\`\`\`

### The LEGB Scoping Rule
1. **Local**: Names assigned inside a function body.
2. **Enclosing**: Names in outer enclosing functions (closures).
3. **Global**: Names assigned at the top level of a module.
4. **Built-in**: Pre-assigned names in the Python runtime (\`len\`, \`range\`, \`int\`).

\`\`\`python
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
\`\`\`

### Key Takeaways
- Never use mutable objects (e.g. \`[]\` or \`{}\`) as default parameter values.
- Closures capture outer function variables through lexical scoping; use \`nonlocal\` to rebind enclosing variables.`
      },
      {
        id: 'd0000000-0000-0000-0101-000000000004',
        title: 'Compound Data Structures: Lists, Tuples, Dictionaries & Sets',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 4,
        content: `### Learning Objectives
- Differentiate between ordered mutable sequences (\`list\`), immutable records (\`tuple\`), hash tables (\`dict\`), and uniqueness sets (\`set\`).
- Write concise, readable list, dictionary, and set comprehensions.
- Understand hashability requirements for dictionary keys and set members.

### Data Structure Complexity Comparison
| Structure | Indexing | Search | Insertion | Deletion |
| :--- | :--- | :--- | :--- | :--- |
| **List** | $O(1)$ | $O(n)$ | $O(1)$ append / $O(n)$ insert | $O(n)$ |
| **Tuple** | $O(1)$ | $O(n)$ | Immutable ($N/A$) | Immutable ($N/A$) |
| **Dict** | $N/A$ | $O(1)$ avg | $O(1)$ avg | $O(1)$ avg |
| **Set** | $N/A$ | $O(1)$ avg | $O(1)$ avg | $O(1)$ avg |

\`\`\`python
# Comprehensions and dictionary filtering
raw_scores = {"Alice": 92, "Bob": 67, "Charlie": 88, "Dana": 54}
passing_students = {k: v for k, v in raw_scores.items() if v >= 70}
print("Passing students:", passing_students)

# Set operations for membership and difference
required_modules = {"auth", "db", "api", "monitoring"}
completed_modules = {"auth", "db"}
missing_modules = required_modules - completed_modules
print("Missing modules:", missing_modules)
\`\`\`

### Key Takeaways
- Dictionary keys and set elements must be **hashable** (immutable objects implementing \`__hash__\` and \`__eq__\`).
- List comprehensions execute faster than explicit \`for\` loops due to optimized bytecode iteration.`
      },
      {
        id: 'd0000000-0000-0000-0101-000000000005',
        title: 'Object-Oriented Python: Classes, Encapsulation & Dunder Methods',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 5,
        content: `### Learning Objectives
- Design custom classes using \`__init__\`, encapsulation conventions, and properties.
- Implement special methods (dunder methods): \`__str__\`, \`__repr__\`, \`__eq__\`, and \`__len__\`.
- Apply inheritance, \`super()\`, and Method Resolution Order (MRO).

### Class Implementation with Properties
\`\`\`python
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
\`\`\`

### Key Takeaways
- Python uses conventions (leading underscore \`_field\`) for protected attributes and double underscore for name mangling.
- Use \`@property\` decorators to implement computed fields and validation without breaking attribute-access APIs.`
      },
      {
        id: 'd0000000-0000-0000-0101-000000000006',
        title: 'Exception Handling Architecture & Custom Error Classes',
        duration_minutes: 40,
        is_free_preview: false,
        order_index: 6,
        content: `### Learning Objectives
- Construct resilient exception handling pipelines using \`try\`, \`except\`, \`else\`, and \`finally\`.
- Design custom exception hierarchies inheriting from \`Exception\`.
- Manage resources cleanly using the context manager protocol (\`with\` statement).

### Custom Exception Hierarchy
\`\`\`python
class ApplicationError(Exception):
    """Base application exception."""
    pass

class ResourceNotFoundError(ApplicationError):
    def __init__(self, resource_type: str, resource_id: str):
        super().__init__(f"{resource_type} with ID '{resource_id}' was not found.")
        self.resource_id = resource_id

def fetch_user_record(user_id: str) -> dict:
    database = {"usr_101": {"name": "Alex", "active": True}}
    if user_id not in database:
        raise ResourceNotFoundError("UserProfile", user_id)
    return database[user_id]
\`\`\`

### Resource Management with Context Managers
\`\`\`python
class DatabaseConnection:
    def __enter__(self):
        print("Acquiring connection resource...")
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        print("Releasing connection resource safely.")
        return False # propagate exceptions if any occurred
\`\`\`

### Key Takeaways
- The \`else\` block in exception handling executes only if no exception was raised in the \`try\` block.
- Always catch specific exceptions; avoid bare \`except:\` clauses that swallow system interrupts like \`KeyboardInterrupt\`.`
      },
      {
        id: 'd0000000-0000-0000-0101-000000000007',
        title: 'File I/O, JSON Serialization, and Standard Library Modules',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 7,
        content: `### Learning Objectives
- Read and write text and binary files using secure context managers.
- Serialize and deserialize structured data using Python's \`json\` module.
- Utilize standard library utilities: \`pathlib\`, \`datetime\`, and \`collections.defaultdict\`.

### Safe File Handling & JSON Workflows
\`\`\`python
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

print(f"Loaded config for {loaded_data['system_name']} v{loaded_data['version']}")
\`\`\`

### Key Takeaways
- Always specify \`encoding="utf-8"\` when reading or writing text files to avoid platform-dependent encoding mismatches.
- Use \`pathlib.Path\` for cross-platform file path resolution instead of brittle string concatenation.`
      }
    ],
    quizzes: [
      {
        id: 'd0000000-0000-0000-0201-000000000001',
        title: 'Python Syntax, Types & Dynamic Binding Quiz',
        description: 'Assessment covering CPython runtime mechanics, object identity, reference binding, and primitive data types.',
        time_limit_minutes: 15,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0301-000000000001',
            order_index: 1,
            marks: 10,
            question_text: 'In Python, what is the output of checking identity between two small integer assignments: a = 256; b = 256; print(a is b)?',
            options: [
              'False, because distinct assignments always allocate distinct heap objects.',
              'True, because CPython pre-allocates and caches an array of small integer objects in the range -5 to 256.',
              'SyntaxError, because "is" can only compare boolean flags.',
              'TypeError, because identity comparison requires explicit casting.'
            ],
            correct_option_index: 1,
            explanation: 'CPython optimizes memory by interning small integers between -5 and 256 inclusive, so both variables reference the exact same cached object in memory.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000002',
            order_index: 2,
            marks: 10,
            question_text: 'What happens when you attempt to modify a character in a Python string: s = "hello"; s[0] = "H"?',
            options: [
              'The string is modified in-place to "Hello".',
              'A TypeError is raised because strings are immutable sequences in Python.',
              'A copy of the string is implicitly generated and assigned back.',
              'A warning is printed, but the character is updated.'
            ],
            correct_option_index: 1,
            explanation: 'Strings in Python are immutable; attempting item assignment on a string raises a TypeError: \'str\' object does not support item assignment.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000003',
            order_index: 3,
            marks: 10,
            question_text: 'Which operator produces integer division without a fractional component in Python 3?',
            options: ['/', '//', '%', 'div()'],
            correct_option_index: 1,
            explanation: 'The // operator performs floor division, rounding down to the nearest integer.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000004',
            order_index: 4,
            marks: 10,
            question_text: 'What is the boolean evaluation of the expression bool([]) and bool("False")?',
            options: [
              'False and True',
              'True and True',
              'False and False',
              'True and False'
            ],
            correct_option_index: 0,
            explanation: 'An empty list [] is falsy (evaluates to False), while any non-empty string, including "False", is truthy (evaluates to True).'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000005',
            order_index: 5,
            marks: 10,
            question_text: 'How does Python represent arbitrary-precision integers in memory?',
            options: [
              'Fixed 32-bit words that wrap around on overflow.',
              'Dynamic variable-length arrays of 30-bit digits managed by CPython, expanding as needed.',
              'Automatic conversion to IEEE 754 double precision floats when exceeding 64 bits.',
              'Hardware registers allocated directly from kernel pages.'
            ],
            correct_option_index: 1,
            explanation: 'In Python 3, integers have arbitrary precision and are represented as variable-length structs with arrays of digits, avoiding numerical overflow.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000006',
            order_index: 6,
            marks: 10,
            question_text: 'What function returns the unique internal integer address of an object in CPython?',
            options: ['addr()', 'id()', 'memory()', 'ptr()'],
            correct_option_index: 1,
            explanation: 'The id() built-in function returns an integer guaranteed to be unique and constant for this object during its lifetime (in CPython, its memory address).'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000007',
            order_index: 7,
            marks: 10,
            question_text: 'Which statement accurately describes reference counting in Python garbage collection?',
            options: [
              'An object is deallocated immediately when its reference count drops to zero, supplemented by a cyclic detector for circular references.',
              'Garbage collection only executes when system memory reaches 100% capacity.',
              'Python does not use reference counting and relies exclusively on mark-and-sweep.',
              'Variables are deallocated only when the process exits.'
            ],
            correct_option_index: 0,
            explanation: 'CPython relies primarily on immediate reference counting, supported by a generational cyclic garbage collector to detect and break reference cycles.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0201-000000000002',
        title: 'Functions, Scoping & Comprehensions Quiz',
        description: 'Covers LEGB scoping rules, parameter unpacking, mutable defaults, and list/dictionary comprehensions.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0301-000000000008',
            order_index: 1,
            marks: 10,
            question_text: 'Why is defining "def add_item(val, container=[])" considered dangerous in Python?',
            options: [
              'Python raises a SyntaxError upon encountering mutable default arguments.',
              'The default list object is created once when the function is defined, sharing the same list across subsequent calls.',
              'The list is re-initialized to empty on each call, losing previous additions.',
              'Mutable defaults prevent the function from accepting keyword arguments.'
            ],
            correct_option_index: 1,
            explanation: 'Default parameter values are evaluated once at definition time, meaning a mutable default object will accumulate state across multiple calls.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000009',
            order_index: 2,
            marks: 10,
            question_text: 'What keyword allows an inner nested function to rebind a variable located in an enclosing outer function?',
            options: ['global', 'nonlocal', 'outer', 'super'],
            correct_option_index: 1,
            explanation: 'The nonlocal keyword causes the variable to refer to the nearest enclosing scope (excluding global).'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000010',
            order_index: 3,
            marks: 10,
            question_text: 'What does the *args syntax represent in a function definition?',
            options: [
              'A dictionary of arbitrary keyword arguments.',
              'A tuple capturing arbitrary positional arguments.',
              'A pointer to heap memory.',
              'An assertion that at least one argument must be provided.'
            ],
            correct_option_index: 1,
            explanation: '*args bundles any extra positional arguments passed to the function into a tuple.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000011',
            order_index: 4,
            marks: 10,
            question_text: 'What is the output of [x**2 for x in range(5) if x % 2 == 1]?',
            options: ['[1, 9]', '[0, 4, 16]', '[1, 4, 9, 16]', '[1, 9, 25]'],
            correct_option_index: 0,
            explanation: 'range(5) produces 0, 1, 2, 3, 4. The odd numbers are 1 and 3. Their squares are 1 and 9.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000012',
            order_index: 5,
            marks: 10,
            question_text: 'In the LEGB rule, what is the search order Python follows to resolve variable names?',
            options: [
              'Local -> Enclosing -> Global -> Built-in',
              'Local -> Global -> Enclosing -> Built-in',
              'Built-in -> Global -> Enclosing -> Local',
              'Global -> Local -> Enclosing -> Built-in'
            ],
            correct_option_index: 0,
            explanation: 'Python resolves identifiers by checking Local first, then Enclosing (outer functions), then Global (module level), and finally Built-in.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000013',
            order_index: 6,
            marks: 10,
            question_text: 'What type of object does the built-in map() function return in Python 3?',
            options: [
              'A list of transformed elements.',
              'A lazy map iterator that yields values on demand.',
              'A dictionary indexed by sequential integers.',
              'A tuple containing the mapped outputs.'
            ],
            correct_option_index: 1,
            explanation: 'In Python 3, map() returns a lazy iterator, conserving memory by generating mapped values as requested.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000014',
            order_index: 7,
            marks: 10,
            question_text: 'What is the syntax for a dictionary comprehension that squares each number from 1 to 3 with its number as key?',
            options: [
              '{x: x**2 for x in range(1, 4)}',
              '[x: x**2 for x in range(1, 4)]',
              'dict(x -> x**2 for x in range(1, 4))',
              '{x, x**2 for x in range(1, 4)}'
            ],
            correct_option_index: 0,
            explanation: 'Dictionary comprehensions use curly braces with key: value syntax: {x: x**2 for x in range(1, 4)}.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0201-000000000003',
        title: 'Object-Oriented Python & Special Methods Quiz',
        description: 'Tests class definitions, property decorators, method resolution order (MRO), and magic dunder methods.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0301-000000000015',
            order_index: 1,
            marks: 10,
            question_text: 'What is the primary distinction between __str__ and __repr__ in Python?',
            options: [
              '__str__ is intended to provide a readable string for end users, while __repr__ aims to provide an unambiguous representation often usable to recreate the object.',
              '__repr__ only works in debug builds of Python.',
              '__str__ is deprecated in Python 3.',
              '__repr__ returns an integer hash of the object.'
            ],
            correct_option_index: 0,
            explanation: '__str__ is for clean, human-readable output, while __repr__ provides an explicit, unambiguous representation useful for developers and debugging.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000016',
            order_index: 2,
            marks: 10,
            question_text: 'What algorithm does Python 3 use to compute Method Resolution Order (MRO) in multiple inheritance?',
            options: [
              'Depth-First Search (DFS)',
              'C3 Linearization Algorithm',
              'Breadth-First Search (BFS)',
              'Dijkstra\'s Shortest Path'
            ],
            correct_option_index: 1,
            explanation: 'Python uses the C3 Linearization algorithm to guarantee monotonicity and respect local precedence order in multiple inheritance hierarchies.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000017',
            order_index: 3,
            marks: 10,
            question_text: 'What does prefixing an attribute with double underscores (e.g. self.__salary) accomplish?',
            options: [
              'It makes the variable read-only at the C level.',
              'It triggers name mangling by prepending _ClassName to prevent accidental subclass collisions.',
              'It encrypts the variable data in memory.',
              'It exposes the variable as an operating system environment variable.'
            ],
            correct_option_index: 1,
            explanation: 'Double leading underscores invoke name mangling, where the attribute is internally renamed to _ClassName__attr to avoid namespace clashes in subclasses.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000018',
            order_index: 4,
            marks: 10,
            question_text: 'Which decorator transforms a method into a read-only getter attribute?',
            options: ['@property', '@getter', '@attribute', '@staticmethod'],
            correct_option_index: 0,
            explanation: 'The @property decorator turns a method into a descriptor getter, allowing access using attribute dot notation.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000019',
            order_index: 5,
            marks: 10,
            question_text: 'What special method must a class implement to support the len() built-in function?',
            options: ['__length__()', '__len__()', '__size__()', '__count__()'],
            correct_option_index: 1,
            explanation: 'Implementing __len__(self) returns a non-negative integer representing the container length.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000020',
            order_index: 6,
            marks: 10,
            question_text: 'What does the super() function accomplish when called inside a subclass method?',
            options: [
              'It restarts the Python interpreter.',
              'It returns a proxy object delegating method calls to the next class in the Method Resolution Order.',
              'It forces an object to become immutable.',
              'It casts all parameters to strings.'
            ],
            correct_option_index: 1,
            explanation: 'super() dynamically resolves and invokes methods on parent classes according to the class MRO.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000021',
            order_index: 7,
            marks: 10,
            question_text: 'What is the purpose of __slots__ in a Python class definition?',
            options: [
              'To restrict dynamic attribute creation and save memory by replacing the default instance __dict__.',
              'To allow infinite inheritance levels.',
              'To define public API endpoints for HTTP servers.',
              'To configure multithreading concurrency slots.'
            ],
            correct_option_index: 0,
            explanation: '__slots__ defines a fixed set of attributes, eliminating the per-instance __dict__ and substantially reducing memory footprint.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0201-000000000004',
        title: 'Error Handling, File Operations & Modules Quiz',
        description: 'Examines exception propagation, custom exceptions, context managers, and pathlib/json file handling.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0301-000000000022',
            order_index: 1,
            marks: 10,
            question_text: 'When does the "else" block of a try-except statement execute?',
            options: [
              'When an exception was raised and successfully handled.',
              'Only when no exception was raised in the try block.',
              'Every time the function terminates.',
              'Only when the finally block fails.'
            ],
            correct_option_index: 1,
            explanation: 'The else clause runs only if the code in the try block completed without raising any exceptions.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000023',
            order_index: 2,
            marks: 10,
            question_text: 'Which two dunder methods define the context manager protocol used by the "with" statement?',
            options: [
              '__start__ and __stop__',
              '__enter__ and __exit__',
              '__open__ and __close__',
              '__init__ and __del__'
            ],
            correct_option_index: 1,
            explanation: 'Context managers implement __enter__(self) to acquire resources and __exit__(self, exc_type, exc_val, exc_tb) to ensure cleanup.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000024',
            order_index: 3,
            marks: 10,
            question_text: 'Why should custom exceptions inherit from Exception rather than BaseException?',
            options: [
              'BaseException cannot be inherited in user code.',
              'Catching Exception preserves system-exiting signals like KeyboardInterrupt and SystemExit which inherit directly from BaseException.',
              'BaseException requires writing custom C bindings.',
              'Exception has faster lookup speed than BaseException.'
            ],
            correct_option_index: 1,
            explanation: 'KeyboardInterrupt and SystemExit inherit directly from BaseException, so inheriting from Exception prevents user exceptions from intercepting deliberate termination signals.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000025',
            order_index: 4,
            marks: 10,
            question_text: 'What is the difference between json.dump() and json.dumps() in the standard library?',
            options: [
              'json.dump() serializes data to a file-like stream, whereas json.dumps() returns a Python string.',
              'json.dump() encrypts the output, while json.dumps() does not.',
              'json.dumps() can only serialize integers and lists.',
              'json.dump() is asynchronous while json.dumps() is synchronous.'
            ],
            correct_option_index: 0,
            explanation: 'json.dump(obj, fp) writes to a file stream; json.dumps(obj) outputs a JSON formatted str.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000026',
            order_index: 5,
            marks: 10,
            question_text: 'What mode flag in open() opens a file for appending text with write operations positioned at the end of the file?',
            options: ['"r+"', '"w"', '"a"', '"x"'],
            correct_option_index: 2,
            explanation: '"a" opens a file for writing, appending to the end of the file if it exists, without truncating it.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000027',
            order_index: 6,
            marks: 10,
            question_text: 'Which standard library module provides object-oriented filesystem paths for cross-platform operations?',
            options: ['os.file', 'pathlib', 'sys.path', 'filepath'],
            correct_option_index: 1,
            explanation: 'The pathlib module offers classes representing filesystem paths with semantics appropriate for different operating systems.'
          },
          {
            id: 'd0000000-0000-0000-0301-000000000028',
            order_index: 7,
            marks: 10,
            question_text: 'What is the role of the special variable __name__ when a Python file is run directly from the command line?',
            options: [
              'It evaluates to "__main__".',
              'It evaluates to the file name as a string.',
              'It evaluates to None.',
              'It evaluates to the parent directory name.'
            ],
            correct_option_index: 0,
            explanation: 'When a module is run as the top-level script, its __name__ attribute is assigned the string "__main__".'
          }
        ]
      }
    ],
    assignments: [
      {
        id: 'd0000000-0000-0000-0401-000000000001',
        title: 'Project 1: Command-Line Personal Expense Tracker with File Persistence',
        description: `### Assignment Overview
Design and implement a robust, modular Python command-line utility for tracking student expenses. The application must enforce strict input validation, calculate category aggregates, and persist transaction records across sessions.

### Deliverables
1. \`expense_tracker.py\`: Complete Python script containing clean functions, error handling, and file operations.
2. \`sample_expenses.json\`: Sample dataset demonstrating at least 8 transactions across 4 categories.
3. \`README.md\`: Documentation describing installation, CLI usage instructions, and sample input/output logs.

### Requirements & Functional Specifications
- **Data Model**: Store expenses with fields: \`id\` (UUID or incremental int), \`title\` (str), \`amount\` (positive float), \`category\` (str), and \`timestamp\` (ISO 8601 string).
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
- **Documentation & Testing (15 Marks)**: Clear README instructions, edge-case coverage, and valid sample data.`,
        due_date: '2026-11-30T23:59:59Z',
        max_marks: 100,
        allow_resubmission: true,
        is_published: true
      },
      {
        id: 'd0000000-0000-0000-0401-000000000002',
        title: 'Project 2: Object-Oriented Inventory Management System with Custom Exceptions',
        description: `### Assignment Overview
Develop an object-oriented Python application modeling an academic laboratory equipment inventory. The system must showcase inheritance, custom exception hierarchies, and encapsulated class attributes.

### Deliverables
1. \`inventory.py\`: Contains \`Item\`, \`PerishableItem\`, \`EquipmentItem\`, and \`Inventory\` class definitions.
2. \`exceptions.py\`: Custom exception hierarchy (\`InventoryError\`, \`InsufficientStockError\`, \`ItemNotFoundError\`).
3. \`test_inventory.py\`: Unit test script verifying operations and exception assertions using \`unittest\` or \`pytest\`.

### Requirements & Functional Specifications
- **Class Hierarchy**:
  - Base class \`Item\` with encapsulated \`_name\`, \`_unit_price\`, and \`_stock_quantity\`.
  - Subclasses \`PerishableItem\` (adding expiry date and spoilage checks) and \`EquipmentItem\` (adding maintenance schedules and serial numbers).
- **Custom Exceptions**: Implement explicit error classes raised when attempting to withdraw more stock than available or querying unknown items.
- **Special Methods**: Implement \`__str__\`, \`__repr__\`, and \`__len__\` on the \`Inventory\` container class.

### Evaluation Rubric (Total: 100 Marks)
- **Object-Oriented Design & Inheritance (35 Marks)**: Proper use of classes, inheritance, encapsulation with \`@property\`, and \`super()\`.
- **Custom Exception Handling (25 Marks)**: Accurate hierarchy, meaningful error messages, and proper raising/handling.
- **Special Methods & Protocols (20 Marks)**: Functional implementation of \`__str__\`, \`__repr__\`, and container iteration.
- **Test Suite & Verification (20 Marks)**: Automated test cases verifying normal and exceptional paths.`,
        due_date: '2026-12-15T23:59:59Z',
        max_marks: 100,
        allow_resubmission: true,
        is_published: true
      }
    ]
  },

  // -------------------------------------------------------------------------
  // 2. Java Programming and Object-Oriented Design
  // -------------------------------------------------------------------------
  {
    id: 'd0000000-0000-0000-0000-000000000002',
    title: 'Java Programming and Object-Oriented Design',
    slug: 'java-programming-object-oriented-design',
    description: 'Master enterprise Java: JVM architecture, object-oriented design patterns, inheritance, abstract classes, interfaces, checked exception architecture, generic collections, and multi-threading.',
    category: 'Computer Science',
    level: 'Intermediate',
    thumbnail_url: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=800&auto=format&fit=crop',
    lessons: [
      {
        id: 'd0000000-0000-0000-0102-000000000001',
        title: 'Java Platform Architecture: JVM, JRE, JDK & Memory Model',
        duration_minutes: 40,
        is_free_preview: true,
        order_index: 1,
        content: `### Learning Objectives
- Differentiate between the Java Development Kit (JDK), Java Runtime Environment (JRE), and Java Virtual Machine (JVM).
- Understand the Java memory model: Stack memory, Heap memory, Metaspace, and Garbage Collection.
- Trace the lifecycle from Java source code compilation to classloading and JIT execution.

### Java Architecture Pipeline
Java achieves platform independence ("Write Once, Run Anywhere") through bytecode. \`javac\` compiles source code into \`.class\` bytecode files, which the JVM ClassLoader loads into memory. The JVM interpreter executes bytecode while the Just-In-Time (JIT) compiler compiles frequently executed "hot" code paths directly into native machine code.

\`\`\`
Source (.java)  ---javac--->  Bytecode (.class)  --->  JVM (ClassLoader -> Execution Engine [JIT])
\`\`\`

### Memory Organization
- **Stack Memory**: Stores thread-specific primitive values and reference pointers to heap objects. Deallocated immediately as frames exit.
- **Heap Memory**: Stores all instantiated objects and arrays. Managed globally by the Garbage Collector (Young and Old generations).
- **Metaspace**: Stores class metadata, bytecode definitions, and static fields.

### Key Takeaways
- Primitives are stored on the stack (when local); all objects are allocated on the heap.
- Java is strictly **pass-by-value**: for object references, a copy of the reference pointer is passed.`
      },
      {
        id: 'd0000000-0000-0000-0102-000000000002',
        title: 'Classes, Objects, and Encapsulation Principles',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 2,
        content: `### Learning Objectives
- Design cohesive classes adhering to encapsulation principles.
- Apply access modifiers (\`private\`, \`package-private\`, \`protected\`, \`public\`) appropriately.
- Utilize constructors, the \`this\` keyword, and constructor chaining.

### Encapsulation Pattern
Encapsulation bundles data with the methods that operate on that data and hides internal state from unauthorized external mutation.

\`\`\`java
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
\`\`\`

### Key Takeaways
- Declare fields as \`private\` and provide controlled accessor/mutator methods to maintain class invariants.
- Use the \`final\` modifier for immutable fields that cannot change after constructor initialization.`
      },
      {
        id: 'd0000000-0000-0000-0102-000000000003',
        title: 'Inheritance, Method Overriding, and Dynamic Polymorphism',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 3,
        content: `### Learning Objectives
- Build class hierarchies using the \`extends\` keyword.
- Override parent methods cleanly using the \`@Override\` annotation.
- Understand dynamic method dispatch and run-time polymorphism.

### Dynamic Polymorphism Demonstration
Dynamic polymorphism allows a parent class reference to point to any subclass instance, resolving method invocations at runtime according to the actual object type.

\`\`\`java
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
\`\`\`

### Key Takeaways
- The \`super\` keyword accesses parent constructors and overridden parent methods.
- Methods marked \`final\` or \`private\` cannot be overridden, enabling compile-time static binding.`
      },
      {
        id: 'd0000000-0000-0000-0102-000000000004',
        title: 'Abstract Classes and Interfaces: Contracts and Multiple Inheritance',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 4,
        content: `### Learning Objectives
- Compare abstract classes (\`is-a\` relationship) with interfaces (\`can-do\` contract).
- Implement multiple interfaces in a single class.
- Utilize default and static methods in modern Java interfaces (Java 8+).

### Architectural Interface Design
\`\`\`java
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
\`\`\`

### Key Takeaways
- A Java class can extend only one superclass, but can implement unlimited interfaces.
- Prefer interfaces to define API contracts, maximizing modularity and mockability during testing.`
      },
      {
        id: 'd0000000-0000-0000-0102-000000000005',
        title: 'Checked vs Unchecked Exception Architecture & Try-With-Resources',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 5,
        content: `### Learning Objectives
- Differentiate between \`Throwable\`, \`Error\`, \`Exception\` (checked), and \`RuntimeException\` (unchecked).
- Implement automatic resource closure using \`try-with-resources\` and the \`AutoCloseable\` interface.
- Create custom domain exceptions for enterprise applications.

### Exception Hierarchy
\`\`\`
Throwable
 ├── Error (Out of memory, stack overflow - unrecoverable)
 └── Exception
      ├── RuntimeException (Unchecked: NullPointerException, IllegalArgumentException)
      └── IOException, SQLException (Checked: must be caught or declared via throws)
\`\`\`

### Try-With-Resources Pattern
\`\`\`java
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
\`\`\`

### Key Takeaways
- Checked exceptions force compile-time handling for expected recoverable failures.
- Unchecked exceptions (\`RuntimeException\`) typically signal programming bugs and logic flaws.`
      },
      {
        id: 'd0000000-0000-0000-0102-000000000006',
        title: 'Java Collections Framework: Lists, Sets, Maps & Iterators',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 6,
        content: `### Learning Objectives
- Select appropriate collection implementations based on asymptotic complexity requirements.
- Contrast \`ArrayList\` vs \`LinkedList\`, \`HashSet\` vs \`TreeSet\`, and \`HashMap\` vs \`TreeMap\`.
- Implement \`equals()\` and \`hashCode()\` contract to ensure correct hashing semantics.

### The equals() and hashCode() Contract
If two objects are equal according to \`equals(Object)\`, their \`hashCode()\` values **must** be identical. If this contract is violated, hash-based collections (\`HashMap\`, \`HashSet\`) fail to find existing keys.

\`\`\`java
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
\`\`\`

### Key Takeaways
- Always override \`hashCode()\` whenever overriding \`equals()\`.
- \`ArrayList\` provides $O(1)$ random access; \`HashMap\` provides average $O(1)$ key lookups.`
      },
      {
        id: 'd0000000-0000-0000-0102-000000000007',
        title: 'Generics, Type Bounds, and Multithreading Fundamentals',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 7,
        content: `### Learning Objectives
- Write type-safe generic classes and methods with bounded type parameters (\`<T extends Comparable<T>>\`).
- Understand Java's type erasure and wildcard variance (\`? extends T\`, \`? super T\`).
- Spawn concurrent threads using \`Runnable\` and synchronize shared state using the \`synchronized\` keyword.

### Generic Stack Implementation
\`\`\`java
import java.util.ArrayList;
import java.util.List;

public class GenericBox<T> {
    private final List<T> items = new ArrayList<>();

    public void add(T item) { items.add(item); }
    public T get(int index) { return items.get(index); }
    public int size() { return items.size(); }
}
\`\`\`

### Basic Thread Synchronization
\`\`\`java
public class SynchronizedCounter {
    private int count = 0;

    public synchronized void increment() {
        count++;
    }

    public synchronized int getCount() {
        return count;
    }
}
\`\`\`

### Key Takeaways
- Generics provide compile-time type safety; the JVM compiler erases generic types at runtime for backward compatibility.
- The \`synchronized\` keyword enforces mutual exclusion using the object's intrinsic monitor lock.`
      }
    ],
    quizzes: [
      {
        id: 'd0000000-0000-0000-0202-000000000001',
        title: 'JVM Mechanics, Data Types & Control Flow Quiz',
        description: 'Covers JVM memory architecture, stack vs heap, primitive data types, and method invocation.',
        time_limit_minutes: 15,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0302-000000000001',
            order_index: 1,
            marks: 10,
            question_text: 'Where are local primitive variables stored during method execution in Java?',
            options: [
              'In the heap memory alongside instance fields.',
              'In the thread-specific stack frame for that method.',
              'In the permanent metaspace.',
              'In the operating system kernel cache.'
            ],
            correct_option_index: 1,
            explanation: 'Method execution frames and their local primitive variables reside on the thread\'s call stack, deallocating immediately upon method return.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000002',
            order_index: 2,
            marks: 10,
            question_text: 'What happens when an object reference is passed as an argument to a Java method?',
            options: [
              'The object itself is deep-copied onto the stack.',
              'A copy of the reference pointer is passed by value.',
              'The parameter is passed by reference, allowing rebinding of the caller\'s original pointer.',
              'The JVM converts the reference to an immutable integer.'
            ],
            correct_option_index: 1,
            explanation: 'Java is strictly pass-by-value. For objects, the value passed is a copy of the reference pointer.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000003',
            order_index: 3,
            marks: 10,
            question_text: 'What is the size and default value of a boolean primitive field in a Java class?',
            options: [
              '1 bit, default true',
              'JVM implementation dependent, default false',
              '8 bytes, default null',
              '4 bytes, default undefined'
            ],
            correct_option_index: 1,
            explanation: 'In Java class instances, boolean fields default to false; the JVM typically represents them using byte or word formats.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000004',
            order_index: 4,
            marks: 10,
            question_text: 'Which JVM component compiles hot bytecode segments into native machine instructions at runtime?',
            options: ['The ClassLoader', 'The JIT (Just-In-Time) Compiler', 'The Metaspace Resolver', 'The Bytecode Verifier'],
            correct_option_index: 1,
            explanation: 'The JIT compiler profiles running bytecode and dynamically compiles frequently executed loops and methods directly into native machine instructions.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000005',
            order_index: 5,
            marks: 10,
            question_text: 'What is the result of comparing two String literals using ==: String s1 = "java"; String s2 = "java"; print(s1 == s2)?',
            options: [
              'False, because == always checks distinct memory addresses.',
              'True, because string literals are interned into the JVM String Pool, sharing the same reference.',
              'A compile-time error occurs.',
              'Runtime NullPointerException.'
            ],
            correct_option_index: 1,
            explanation: 'String literals are stored in the JVM String Constant Pool; identical string literals point to the same pooled object reference.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000006',
            order_index: 6,
            marks: 10,
            question_text: 'Which keyword prevents a class from being subclassed in Java?',
            options: ['static', 'final', 'sealed', 'abstract'],
            correct_option_index: 1,
            explanation: 'Applying the final modifier to a class definition prevents any other class from extending it.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000007',
            order_index: 7,
            marks: 10,
            question_text: 'What is the return type of the hashCode() method defined in java.lang.Object?',
            options: ['long', 'int', 'String', 'byte[]'],
            correct_option_index: 1,
            explanation: 'public int hashCode() returns a 32-bit signed integer hash value representing the object.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0202-000000000002',
        title: 'Inheritance, Interfaces & Polymorphism Quiz',
        description: 'Tests dynamic dispatch, interface contracts, default methods, and constructor hierarchies.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0302-000000000008',
            order_index: 1,
            marks: 10,
            question_text: 'What access modifier allows class members to be accessed by subclasses and classes within the same package, but not by unrelated classes in external packages?',
            options: ['public', 'private', 'protected', 'package-private (default)'],
            correct_option_index: 2,
            explanation: 'protected grants visibility to subclasses in any package and all classes within the same package.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000009',
            order_index: 2,
            marks: 10,
            question_text: 'Can an interface in Java 8 or higher contain method implementations?',
            options: [
              'No, interfaces can only contain abstract method signatures.',
              'Yes, using the default or static keywords on method declarations.',
              'Only if the interface is marked private.',
              'Only when inheriting from java.lang.Thread.'
            ],
            correct_option_index: 1,
            explanation: 'Java 8 introduced default and static methods in interfaces, allowing interfaces to include concrete method bodies without breaking backward compatibility.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000010',
            order_index: 3,
            marks: 10,
            question_text: 'What happens if a subclass constructor does not explicitly call super() or this()?',
            options: [
              'The compiler automatically inserts a call to super() with no arguments as the first statement.',
              'The program compiles, but parent fields remain unallocated in heap.',
              'A compile-time error is generated requiring explicit super() calls.',
              'The subclass constructor is skipped at runtime.'
            ],
            correct_option_index: 0,
            explanation: 'If no explicit constructor call is provided, the Java compiler automatically inserts super() to invoke the no-argument constructor of the superclass.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000011',
            order_index: 4,
            marks: 10,
            question_text: 'What is the term for resolving which overridden method to execute at runtime based on the actual object instance?',
            options: ['Static Binding', 'Dynamic Method Dispatch', 'Early Compilation', 'Interface Bridging'],
            correct_option_index: 1,
            explanation: 'Dynamic method dispatch is the mechanism by which a call to an overridden method is resolved at runtime rather than compile time.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000012',
            order_index: 5,
            marks: 10,
            question_text: 'Can an abstract class in Java be instantiated directly using the new keyword?',
            options: [
              'Yes, provided it has no abstract methods.',
              'No, abstract classes cannot be instantiated directly and must be subclassed.',
              'Yes, but only within its declaring package.',
              'Yes, if passed to a Thread object.'
            ],
            correct_option_index: 1,
            explanation: 'Abstract classes serve as incomplete base models and cannot be instantiated directly; concrete subclasses must implement any remaining abstract methods.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000013',
            order_index: 6,
            marks: 10,
            question_text: 'Which operator checks whether an object is an instance of a specific class or interface at runtime?',
            options: ['isTypeOf', 'instanceof', 'inherits', 'matches'],
            correct_option_index: 1,
            explanation: 'The instanceof binary operator evaluates whether an object reference is compatible with a given class, subclass, or interface.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000014',
            order_index: 7,
            marks: 10,
            question_text: 'Why does Java not support multiple class inheritance (class C extends A, B)?',
            options: [
              'Because bytecode cannot store more than one parent reference.',
              'To avoid ambiguities such as the Diamond Problem in method and state resolution.',
              'Because interfaces provide superior performance over classes.',
              'To preserve compatibility with C compilers.'
            ],
            correct_option_index: 1,
            explanation: 'Java avoids the complexity and ambiguities of multiple class inheritance (such as resolving duplicate inherited state in the diamond problem) by allowing multiple interface inheritance instead.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0202-000000000003',
        title: 'Exception Architecture & Resource Management Quiz',
        description: 'Examines checked vs unchecked exceptions, try-with-resources, and exception propagation.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0302-000000000015',
            order_index: 1,
            marks: 10,
            question_text: 'Which class serves as the direct superclass of all unchecked exceptions in Java?',
            options: ['java.lang.Error', 'java.lang.RuntimeException', 'java.lang.Exception', 'java.lang.Throwable'],
            correct_option_index: 1,
            explanation: 'RuntimeException and its subclasses constitute unchecked exceptions, which do not require mandatory compile-time declaration in throws clauses.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000016',
            order_index: 2,
            marks: 10,
            question_text: 'What interface must a resource class implement to be declared inside a try-with-resources statement?',
            options: ['java.io.Serializable', 'java.lang.AutoCloseable', 'java.lang.Cloneable', 'java.lang.Runnable'],
            correct_option_index: 1,
            explanation: 'The try-with-resources statement accepts any object implementing java.lang.AutoCloseable, ensuring its close() method is invoked on block exit.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000017',
            order_index: 3,
            marks: 10,
            question_text: 'What happens when a finally block executes a return statement while the try block also has a return statement?',
            options: [
              'The try block\'s return value is preserved; the finally block\'s return is ignored.',
              'The finally block\'s return statement overrides and discards the return value or unhandled exception from the try block.',
              'A compile-time error occurs due to conflicting returns.',
              'The JVM terminates with a fatal exception.'
            ],
            correct_option_index: 1,
            explanation: 'A return statement inside a finally block will discard any pending return value or exception from the try/catch blocks, which is why returning from finally is an anti-pattern.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000018',
            order_index: 4,
            marks: 10,
            question_text: 'Which exception is thrown when an application attempts to access an array index outside its valid bounds?',
            options: [
              'NullPointerException',
              'ArrayIndexOutOfBoundsException',
              'IllegalArgumentException',
              'ArrayStoreException'
            ],
            correct_option_index: 1,
            explanation: 'ArrayIndexOutOfBoundsException is thrown to indicate that an array has been accessed with an illegal index (negative or >= array length).'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000019',
            order_index: 5,
            marks: 10,
            question_text: 'Can a catch block catch multiple un-related exception types using a multi-catch statement?',
            options: [
              'No, each catch block can only handle exactly one exception type.',
              'Yes, separating exception types with a pipe symbol (|) such as catch (IOException | SQLException e).',
              'Yes, using comma separators: catch (IOException, SQLException e).',
              'Only if both exceptions share an abstract interface.'
            ],
            correct_option_index: 1,
            explanation: 'Java 7 introduced multi-catch syntax: catch (IOException | SQLException e) where e is implicitly final.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000020',
            order_index: 6,
            marks: 10,
            question_text: 'What keyword is used in a method declaration to indicate that the method may propagate a checked exception to its caller?',
            options: ['throw', 'throws', 'exception', 'raises'],
            correct_option_index: 1,
            explanation: 'The throws keyword in a method signature declares the list of checked exceptions the method can propagate.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000021',
            order_index: 7,
            marks: 10,
            question_text: 'What is the primary purpose of chaining exceptions via initCause() or constructor chaining (new Exception("msg", cause))?',
            options: [
              'To speed up stack trace generation.',
              'To preserve the original root cause exception for diagnostic traceability when rethrowing a higher-level abstraction exception.',
              'To suppress exception logging in production.',
              'To convert checked exceptions into compile-time warnings.'
            ],
            correct_option_index: 1,
            explanation: 'Exception chaining retains the underlying cause of a failure across architectural boundaries, preserving root-cause stack traces.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0202-000000000004',
        title: 'Collections Framework & Generics Quiz',
        description: 'Evaluates knowledge of ArrayList vs LinkedList, HashMap internals, equals/hashCode contract, and generics.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0302-000000000022',
            order_index: 1,
            marks: 10,
            question_text: 'What is the average time complexity of get(key) in a well-balanced Java HashMap?',
            options: ['O(n)', 'O(log n)', 'O(1)', 'O(n log n)'],
            correct_option_index: 2,
            explanation: 'HashMap provides O(1) average-time complexity for basic get and put operations assuming a uniform hash distribution.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000023',
            order_index: 2,
            marks: 10,
            question_text: 'What occurs internally in a Java 8+ HashMap when a single bucket experiences severe hash collisions exceeding 8 nodes?',
            options: [
              'The map throws an OutOfMemoryError.',
              'The linked list chain in that bucket is converted into a balanced red-black tree (TreeNode), improving worst-case search from O(n) to O(log n).',
              'The map automatically deletes the conflicting keys.',
              'The map switches to linear probing.'
            ],
            correct_option_index: 1,
            explanation: 'In Java 8+, when bucket collisions exceed the TREEIFY_THRESHOLD (8) and the table capacity is at least 64, the linked list converts to a red-black tree.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000024',
            order_index: 3,
            marks: 10,
            question_text: 'If class A overrides equals() to compare field values but does not override hashCode(), what bug occurs in a HashSet<A>?',
            options: [
              'The code will fail to compile.',
              'Equal objects will produce different hash codes and be placed into different buckets, causing contains() to return false for existing equal objects.',
              'The HashSet will throw a NullPointerException upon adding the second item.',
              'All items in the set will be overwritten by the last added item.'
            ],
            correct_option_index: 1,
            explanation: 'Violating the equals-hashCode contract causes hash lookups to search the wrong bucket, failing to find duplicate objects.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000025',
            order_index: 4,
            marks: 10,
            question_text: 'What is type erasure in the Java generics implementation?',
            options: [
              'The process where the compiler removes all generic type annotations during compilation, inserting casts and using Object or bounds at runtime.',
              'The deletion of unused classes by the JVM ClassLoader.',
              'The dynamic casting of primitives to wrapper objects.',
              'The erasure of stack variables on thread termination.'
            ],
            correct_option_index: 0,
            explanation: 'Type erasure removes generic type arguments during compilation to ensure binary compatibility with legacy pre-generics Java bytecode.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000026',
            order_index: 5,
            marks: 10,
            question_text: 'Which collection guarantees elements remain sorted in natural ascending order or according to a custom Comparator?',
            options: ['HashSet', 'LinkedHashSet', 'TreeSet', 'Vector'],
            correct_option_index: 2,
            explanation: 'TreeSet is backed by a Red-Black NavigableMap, keeping elements sorted with O(log n) insertion and lookup.'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000027',
            order_index: 6,
            marks: 10,
            question_text: 'What does the PECS rule stand for in Java generics wildcards?',
            options: [
              'Producer Extends, Consumer Super',
              'Parameter Extends, Consumer Static',
              'Polymorphism Extends, Collection Super',
              'Package Encapsulation, Class Specialization'
            ],
            correct_option_index: 0,
            explanation: 'PECS: Use <? extends T> when reading from a collection (Producer Extends), and <? super T> when writing to a collection (Consumer Super).'
          },
          {
            id: 'd0000000-0000-0000-0302-000000000028',
            order_index: 7,
            marks: 10,
            question_text: 'What occurs when calling add() on a list returned by Arrays.asList(arr)?',
            options: [
              'The element is appended and the underlying array expands dynamically.',
              'An UnsupportedOperationException is thrown because the returned list has fixed size backed by the original array.',
              'The element replaces the first element of the array.',
              'A new copy of the array is allocated.'
            ],
            correct_option_index: 1,
            explanation: 'Arrays.asList() returns a fixed-size wrapper around the array; attempting structural modifications like add() or remove() throws UnsupportedOperationException.'
          }
        ]
      }
    ],
    assignments: [
      {
        id: 'd0000000-0000-0000-0402-000000000001',
        title: 'Project 1: University Course Registration System Using OOP & Interfaces',
        description: `### Assignment Overview
Architect an enterprise-style university course registration system in Java. Apply object-oriented principles, interface contracts, custom exceptions, and the Java Collections Framework to model students, professors, courses, and department prerequisites.

### Deliverables
1. \`src/\` directory containing all Java classes (\`Person\`, \`Student\`, \`Instructor\`, \`Course\`, \`RegistrationService\`).
2. \`exceptions/\` package containing custom checked and unchecked domain exceptions (\`CourseFullException\`, \`PrerequisiteNotMetException\`).
3. \`Main.java\`: Driver demonstration simulating multi-student registration scenarios, prerequisite validations, and error handling.

### Technical Specifications
- **Class Hierarchy**:
  - Abstract base class \`Person\` with common state (\`id\`, \`name\`, \`email\`).
  - \`Student\` and \`Instructor\` extending \`Person\`.
- **Interface Contract**:
  - \`Registrable\` interface defining \`enrollStudent(Student s)\` and \`dropStudent(Student s)\`.
- **Collections & Constraints**:
  - Enforce maximum course enrollment limits using appropriate collections.
  - Check prerequisite course completions before allowing student enrollment.
- **Robust Exception Handling**:
  - Throw custom checked exceptions when enrollment limits or prerequisite checks are violated.

### Evaluation Rubric (Total: 100 Marks)
- **Object-Oriented Design & Hierarchy (30 Marks)**: Cohesive classes, proper abstraction, and clean inheritance.
- **Interface Implementation & Contracts (25 Marks)**: Consistent use of \`Registrable\` and decoupling of registration logic.
- **Validation & Custom Exception Architecture (25 Marks)**: Enforcing business invariants and clean exception handling.
- **Collections & Documentation (20 Marks)**: Proper collection choices, encapsulation, and code comments.`,
        due_date: '2026-11-30T23:59:59Z',
        max_marks: 100,
        allow_resubmission: true,
        is_published: true
      },
      {
        id: 'd0000000-0000-0000-0402-000000000002',
        title: 'Project 2: Thread-Safe Banking Transaction Engine with Concurrent Collections',
        description: `### Assignment Overview
Design and implement a multi-threaded banking transaction simulator in Java. Ensure thread safety, prevent race conditions, and avoid deadlocks when processing concurrent fund transfers between bank accounts.

### Deliverables
1. \`BankAccount.java\`: Represents an individual account with atomic or synchronized balance operations.
2. \`TransactionWorker.java\`: Implements \`Runnable\` to execute randomized credit/debit transfers between accounts.
3. \`BankSimulation.java\`: Driver program managing thread pools via \`ExecutorService\`, tracking global invariants, and asserting consistency.

### Requirements & Functional Specifications
- **Thread Safety**: Implement mutual exclusion using explicit locks (\`ReentrantLock\`) or \`synchronized\` blocks.
- **Deadlock Avoidance**: Order lock acquisition (e.g., sort account IDs before locking) to guarantee lock hierarchy consistency during transfers.
- **Audit & Invariant Verification**: Verify that the sum of all account balances before and after 1,000 concurrent transfers remains exactly invariant.

### Evaluation Rubric (Total: 100 Marks)
- **Thread Safety & Race Condition Prevention (35 Marks)**: Safe balance mutations under high concurrency.
- **Deadlock Avoidance Architecture (30 Marks)**: Systematic lock ordering preventing cyclic dependencies.
- **Invariant Testing & Correctness (20 Marks)**: Strict preservation of global monetary balance.
- **Code Organization & Cleanliness (15 Marks)**: Proper use of Java concurrency utilities and documentation.`,
        due_date: '2026-12-15T23:59:59Z',
        max_marks: 100,
        allow_resubmission: true,
        is_published: true
      }
    ]
  }
];
