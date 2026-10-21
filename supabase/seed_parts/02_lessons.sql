-- Part 2: Lessons (105 Lessons)
BEGIN;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0101-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000001'::UUID, 'Python Architecture, Dynamic Typing & Primitive Data Types', '### Learning Objectives
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
- Immutable primitives (`int`, `float`, `str`, `tuple`) cannot be modified in place; reassignments create new objects.', NULL, 35, true, 1, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0101-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000001'::UUID, 'Control Flow, Loops, and Iteration Protocols', '### Learning Objectives
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
- `zip()` and `enumerate()` provide memory-efficient generator iterators over sequences.', NULL, 40, false, 2, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0101-000000000003'::UUID, 'd0000000-0000-0000-0000-000000000001'::UUID, 'Functions, Scoping Rules (LEGB), and Lambda Expressions', '### Learning Objectives
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
- Closures capture outer function variables through lexical scoping; use `nonlocal` to rebind enclosing variables.', NULL, 45, false, 3, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0101-000000000004'::UUID, 'd0000000-0000-0000-0000-000000000001'::UUID, 'Compound Data Structures: Lists, Tuples, Dictionaries & Sets', '### Learning Objectives
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
- List comprehensions execute faster than explicit `for` loops due to optimized bytecode iteration.', NULL, 50, false, 4, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0101-000000000005'::UUID, 'd0000000-0000-0000-0000-000000000001'::UUID, 'Object-Oriented Python: Classes, Encapsulation & Dunder Methods', '### Learning Objectives
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
- Use `@property` decorators to implement computed fields and validation without breaking attribute-access APIs.', NULL, 50, false, 5, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0101-000000000006'::UUID, 'd0000000-0000-0000-0000-000000000001'::UUID, 'Exception Handling Architecture & Custom Error Classes', '### Learning Objectives
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
- Always catch specific exceptions; avoid bare `except:` clauses that swallow system interrupts like `KeyboardInterrupt`.', NULL, 40, false, 6, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0101-000000000007'::UUID, 'd0000000-0000-0000-0000-000000000001'::UUID, 'File I/O, JSON Serialization, and Standard Library Modules', '### Learning Objectives
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
- Use `pathlib.Path` for cross-platform file path resolution instead of brittle string concatenation.', NULL, 45, false, 7, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0102-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000002'::UUID, 'Java Platform Architecture: JVM, JRE, JDK & Memory Model', '### Learning Objectives
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
- Java is strictly **pass-by-value**: for object references, a copy of the reference pointer is passed.', NULL, 40, true, 1, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0102-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000002'::UUID, 'Classes, Objects, and Encapsulation Principles', '### Learning Objectives
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
- Use the `final` modifier for immutable fields that cannot change after constructor initialization.', NULL, 45, false, 2, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0102-000000000003'::UUID, 'd0000000-0000-0000-0000-000000000002'::UUID, 'Inheritance, Method Overriding, and Dynamic Polymorphism', '### Learning Objectives
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
- Methods marked `final` or `private` cannot be overridden, enabling compile-time static binding.', NULL, 50, false, 3, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0102-000000000004'::UUID, 'd0000000-0000-0000-0000-000000000002'::UUID, 'Abstract Classes and Interfaces: Contracts and Multiple Inheritance', '### Learning Objectives
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
- Prefer interfaces to define API contracts, maximizing modularity and mockability during testing.', NULL, 45, false, 4, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0102-000000000005'::UUID, 'd0000000-0000-0000-0000-000000000002'::UUID, 'Checked vs Unchecked Exception Architecture & Try-With-Resources', '### Learning Objectives
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
- Unchecked exceptions (`RuntimeException`) typically signal programming bugs and logic flaws.', NULL, 45, false, 5, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0102-000000000006'::UUID, 'd0000000-0000-0000-0000-000000000002'::UUID, 'Java Collections Framework: Lists, Sets, Maps & Iterators', '### Learning Objectives
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
- `ArrayList` provides $O(1)$ random access; `HashMap` provides average $O(1)$ key lookups.', NULL, 50, false, 6, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0102-000000000007'::UUID, 'd0000000-0000-0000-0000-000000000002'::UUID, 'Generics, Type Bounds, and Multithreading Fundamentals', '### Learning Objectives
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
- The `synchronized` keyword enforces mutual exclusion using the object''s intrinsic monitor lock.', NULL, 50, false, 7, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0103-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000003'::UUID, 'Asymptotic Analysis & Mathematical Foundations: Big-O, Big-Omega, Big-Theta', '### Learning Objectives
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
- Space complexity must account for both auxiliary heap allocation and call stack frames in recursive algorithms.', NULL, 45, true, 1, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0103-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000003'::UUID, 'Linear Data Structures: Dynamic Arrays & Linked Lists', '### Learning Objectives
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
- Linked lists provide $O(1)$ insertion/deletion once the position is reached, but suffer from pointer overhead and cache misses.', NULL, 45, false, 2, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0103-000000000003'::UUID, 'd0000000-0000-0000-0000-000000000003'::UUID, 'Stacks, Queues, and Monotonic Sequence Techniques', '### Learning Objectives
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
- Circular queues resolve the memory waste of naive array queues using modulo pointer arithmetic: `tail = (tail + 1) % capacity`.', NULL, 45, false, 3, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0103-000000000004'::UUID, 'd0000000-0000-0000-0000-000000000003'::UUID, 'Binary Trees, Binary Search Trees (BST) & AVL Self-Balancing', '### Learning Objectives
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
- Unbalanced BSTs degrade to $O(n)$ linked lists on sorted inputs; self-balancing trees guarantee $O(\log n)$ worst-case bounds.', NULL, 50, false, 4, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0103-000000000005'::UUID, 'd0000000-0000-0000-0000-000000000003'::UUID, 'Priority Queues, Binary Heaps & Heapsort', '### Learning Objectives
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
- Heapsort achieves $O(n \log n)$ worst-case sorting in-place without auxiliary memory.', NULL, 45, false, 5, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0103-000000000006'::UUID, 'd0000000-0000-0000-0000-000000000003'::UUID, 'Graph Representations & Traversal: BFS, DFS, and Topological Sort', '### Learning Objectives
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
- Topological sorting is valid only on Directed Acyclic Graphs (DAGs); a topological sort failure proves the presence of a cycle.', NULL, 50, false, 6, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0103-000000000007'::UUID, 'd0000000-0000-0000-0000-000000000003'::UUID, 'Shortest Path Algorithms: Dijkstra and Bellman-Ford', '### Learning Objectives
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
- Bellman-Ford relaxes all $|E|$ edges $|V| - 1$ times; an extra relaxation pass that decreases any distance proves the existence of a negative cycle.', NULL, 50, false, 7, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0103-000000000008'::UUID, 'd0000000-0000-0000-0000-000000000003'::UUID, 'Dynamic Programming: Memoization, Tabulation & the Knapsack Problem', '### Learning Objectives
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
- Iterating backwards in 1D array tabulation solves the 0/1 knapsack problem in $O(W)$ auxiliary space.', NULL, 55, false, 8, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0104-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000004'::UUID, 'Modern Web Architecture: HTTP/1.1 to HTTP/3 & The Client-Server Lifecycle', '### Learning Objectives
- Trace the lifecycle of a web request: DNS lookup, TCP handshake, TLS negotiation, HTTP exchange, and browser DOM rendering.
- Compare HTTP/1.1 head-of-line blocking with HTTP/2 binary multiplexing and HTTP/3 QUIC UDP transport.
- Understand HTTP headers, caching directives (`Cache-Control`, `ETag`), and status codes (2xx, 3xx, 4xx, 5xx).

### Evolution of the HTTP Protocol
- **HTTP/1.1**: Persistent TCP connections with pipelining, but suffers from head-of-line (HOL) blocking when one slow response blocks subsequent requests on that TCP connection.
- **HTTP/2**: Single TCP connection per origin with binary framing and multiplexed concurrent streams, eliminating HTTP-layer HOL blocking.
- **HTTP/3**: Operates over QUIC (built on UDP), resolving transport-layer packet loss blocking and providing 0-RTT connection resumption.

### Key Takeaways
- Always enforce HTTPS via TLS 1.3 to guarantee data confidentiality and integrity in transit.
- Proper caching headers (`Cache-Control: public, max-age=31536000, immutable`) dramatically reduce round-trip latency for static assets.', NULL, 40, true, 1, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0104-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000004'::UUID, 'Semantic HTML5 & Responsive Design with CSS Grid and Flexbox', '### Learning Objectives
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
- Use **CSS Grid** for two-dimensional structural page layouts aligning both columns and rows simultaneously.', NULL, 45, false, 2, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0104-000000000003'::UUID, 'd0000000-0000-0000-0000-000000000004'::UUID, 'Modern JavaScript (ES6+): Closures, Event Loop & Async/Await', '### Learning Objectives
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
- Arrow functions do not bind their own `this`, inheriting `this` lexically from the enclosing execution context.', NULL, 50, false, 3, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0104-000000000004'::UUID, 'd0000000-0000-0000-0000-000000000004'::UUID, 'Component-Driven Frontend Architecture with React', '### Learning Objectives
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
- Never mutate state directly in React (e.g. `items.push(x)`); always pass new references (`setItems([...items, x])`).', NULL, 50, false, 4, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0104-000000000005'::UUID, 'd0000000-0000-0000-0000-000000000004'::UUID, 'Client-Side State Management: Hooks, Context & Reducers', '### Learning Objectives
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
- Use `useMemo` and `useCallback` to stabilize object references passed to memoized children.', NULL, 50, false, 5, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0104-000000000006'::UUID, 'd0000000-0000-0000-0000-000000000004'::UUID, 'Building RESTful APIs: Routes, Middleware & Request Lifecycle', '### Learning Objectives
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
- Centralize error-handling middleware with `(err, req, res, next)` to avoid unhandled promise rejections.', NULL, 45, false, 6, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0104-000000000007'::UUID, 'd0000000-0000-0000-0000-000000000004'::UUID, 'Full-Stack Integration, JWT Authentication & CORS Security', '### Learning Objectives
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
- CORS is a browser security mechanism, not an API security firewall; server-to-server calls bypass CORS.', NULL, 50, false, 7, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0105-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000005'::UUID, 'Relational Database Architecture, Data Models & Relational Algebra', '### Learning Objectives
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
- Physical data independence shields application code from changes in disk storage, indexing, or physical block allocation.', NULL, 40, true, 1, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0105-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000005'::UUID, 'Functional Dependencies & Schema Normalization: 1NF to BCNF', '### Learning Objectives
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
- 3NF always guarantees dependency preservation and lossless join decomposition; BCNF guarantees lossless join but may not preserve all functional dependencies.', NULL, 50, false, 2, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0105-000000000003'::UUID, 'd0000000-0000-0000-0000-000000000005'::UUID, 'Declarative SQL Mastery: DDL, DML, Joins & Subqueries', '### Learning Objectives
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
- Prefer `EXISTS` over `IN` when evaluating subqueries against large tables with possible NULLs to optimize planner performance.', NULL, 45, false, 3, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0105-000000000004'::UUID, 'd0000000-0000-0000-0000-000000000005'::UUID, 'Analytical SQL: Aggregations, Grouping Sets & Window Functions', '### Learning Objectives
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
- `LEAD()` and `LAG()` access subsequent and preceding rows without self-joins.', NULL, 50, false, 4, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0105-000000000005'::UUID, 'd0000000-0000-0000-0000-000000000005'::UUID, 'Database Storage Internals: B-Tree Indexing & Query Execution Plans', '### Learning Objectives
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
- An **Index Only Scan** fulfills the query entirely from the B+ Tree index without fetching heap pages.', NULL, 50, false, 5, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0105-000000000006'::UUID, 'd0000000-0000-0000-0000-000000000005'::UUID, 'ACID Transaction Properties, Write-Ahead Logging & Crash Recovery', '### Learning Objectives
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
- Checkpoints shorten recovery times by flushing dirty buffers and bounding the required WAL replay window.', NULL, 45, false, 6, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0105-000000000007'::UUID, 'd0000000-0000-0000-0000-000000000005'::UUID, 'Concurrency Control: Isolation Levels, 2PL & Multi-Version Concurrency (MVCC)', '### Learning Objectives
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
- VACUUM processes reclaim dead tuple versions created by updates and deletes in MVCC engines.', NULL, 50, false, 7, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0106-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000006'::UUID, 'Kernel Architecture, Dual-Mode CPU Operation & System Calls', '### Learning Objectives
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
- System calls execute software interrupts (traps) that switch CPU mode from user to kernel.', NULL, 40, true, 1, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0106-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000006'::UUID, 'Process Management: Process Control Block (PCB) & Context Switching', '### Learning Objectives
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
- Threads within the same process share heap memory, global variables, and open files, making thread context switches significantly faster than process context switches.', NULL, 45, false, 2, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0106-000000000003'::UUID, 'd0000000-0000-0000-0000-000000000006'::UUID, 'CPU Scheduling Algorithms: FCFS, SJF, Priority & Round Robin', '### Learning Objectives
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
- The optimal Round Robin quantum $q$ should be large enough that 80% of CPU bursts are shorter than $q$, minimizing context switch penalties while maintaining responsiveness.', NULL, 50, false, 3, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0106-000000000004'::UUID, 'd0000000-0000-0000-0000-000000000006'::UUID, 'Process Synchronization: Critical Section Problem, Semaphores & Mutexes', '### Learning Objectives
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
- Mutexes have ownership (only the thread that locked the mutex can unlock it); semaphores have no ownership and can be signaled by any thread.', NULL, 50, false, 4, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0106-000000000005'::UUID, 'd0000000-0000-0000-0000-000000000006'::UUID, 'Deadlock Characterization, Prevention, Detection & Banker''s Algorithm', '### Learning Objectives
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
- Eliminating Circular Wait by imposing a strict global ordering on all resource acquisitions ($R_1 < R_2 < ... < R_m$) is the most practical deadlock prevention technique in real systems.', NULL, 50, false, 5, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0106-000000000006'::UUID, 'd0000000-0000-0000-0000-000000000006'::UUID, 'Memory Management: Contiguous Allocation, Paging & Translation Lookaside Buffers (TLB)', '### Learning Objectives
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
- Multi-level page tables conserve physical memory by allocating sub-page tables only for populated virtual address regions.', NULL, 45, false, 6, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0106-000000000007'::UUID, 'd0000000-0000-0000-0000-000000000006'::UUID, 'Virtual Memory: Demand Paging, Page Fault Handling & Replacement Algorithms', '### Learning Objectives
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
- **Thrashing** occurs when a process spends more time swapping pages in and out than executing instructions because its working set exceeds available physical memory.', NULL, 50, false, 7, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0107-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000007'::UUID, 'Layered Network Architectures: OSI 7-Layer vs TCP/IP 4-Layer Stacks', '### Learning Objectives
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
- Routers inspect headers up to Layer 3 (Network); Layer 2 switches inspect frames up to Layer 2 (Data Link).', NULL, 40, true, 1, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0107-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000007'::UUID, 'Application Layer Protocols: DNS Resolution, HTTP/HTTPS & Sockets', '### Learning Objectives
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
- Berkeley Sockets provide the universal OS abstraction for network programming using `socket()`, `bind()`, `listen()`, `accept()`, and `connect()`.', NULL, 45, false, 2, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0107-000000000003'::UUID, 'd0000000-0000-0000-0000-000000000007'::UUID, 'Transport Layer Mechanics: UDP vs TCP & Connection Management', '### Learning Objectives
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
- UDP provides lightweight datagram transport with zero connection setup latency, ideal for real-time gaming, DNS, and live streaming.', NULL, 50, false, 3, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0107-000000000004'::UUID, 'd0000000-0000-0000-0000-000000000007'::UUID, 'Flow Control & TCP Congestion Control: AIMD, Slow Start & Fast Recovery', '### Learning Objectives
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
- Flow control uses `rwnd` feedback in TCP headers; congestion control dynamically estimates network capacity via `cwnd`.', NULL, 50, false, 4, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0107-000000000005'::UUID, 'd0000000-0000-0000-0000-000000000007'::UUID, 'Network Layer: IPv4 Addressing, Subnetting, CIDR & NAT', '### Learning Objectives
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
- NAT allows thousands of private local IP addresses to share a single public IPv4 address using port translation (NAPT/PAT).', NULL, 50, false, 5, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0107-000000000006'::UUID, 'd0000000-0000-0000-0000-000000000007'::UUID, 'Routing Protocols: Distance Vector, Link State (OSPF) & BGP', '### Learning Objectives
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
- BGP routes between Autonomous Systems (AS) across the global Internet backbone using policy rules rather than pure shortest-path metrics.', NULL, 45, false, 6, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0107-000000000007'::UUID, 'd0000000-0000-0000-0000-000000000007'::UUID, 'Data Link Layer: Framing, Error Detection (CRC), MAC Addressing & ARP', '### Learning Objectives
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
- ARP resolves local IP addresses to physical MAC hardware addresses via broadcast requests and unicast replies.', NULL, 45, false, 7, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0108-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000008'::UUID, 'Software Development Lifecycles: Waterfall, Spiral & Agile/Scrum Frameworks', '### Learning Objectives
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
- Velocity measures the average story points completed per sprint, guiding realistic capacity planning.', NULL, 40, true, 1, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0108-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000008'::UUID, 'Requirements Engineering: Functional/Non-Functional Specs & IEEE 830 SRS', '### Learning Objectives
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
- Ambiguous requirements cause $>50\%$ of software defects; write quantifiable criteria (e.g. "99th percentile API latency $<200\text{ms}$ under 1,000 req/s") rather than subjective terms like "fast".', NULL, 45, false, 2, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0108-000000000003'::UUID, 'd0000000-0000-0000-0000-000000000008'::UUID, 'Software Architecture Patterns: Monolithic, Microservices & Event-Driven', '### Learning Objectives
- Evaluate trade-offs between Monolithic architectures, Microservices, and Event-Driven systems.
- Understand Conway''s Law and domain-driven design (DDD) Bounded Contexts.
- Apply synchronous REST/gRPC vs asynchronous message queues (Kafka, RabbitMQ) in distributed architectures.

### Architecture Trade-Off Analysis
- **Monolith**: Single unified deployable unit. Extremely fast to develop initially; simple debugging; difficult to scale team boundaries or independent services horizontally.
- **Microservices**: Loosely coupled services organized around business domains. Independent deployments and localized scaling; introduces network latency, distributed transactions, and partial failure complexity.
- **Event-Driven**: Producers publish domain events to an event bus; asynchronous consumers process events independently, maximizing decoupling.

### Key Takeaways
- Premature decomposition into microservices is an anti-pattern; start with a modular monolith and carve out microservices only when organizational or scaling boundaries demand it.', NULL, 50, false, 3, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0108-000000000004'::UUID, 'd0000000-0000-0000-0000-000000000008'::UUID, 'SOLID Object-Oriented Design Principles & Clean Code', '### Learning Objectives
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
- High cohesion and loose coupling are the foundational hallmarks of sustainable software architecture.', NULL, 50, false, 4, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0108-000000000005'::UUID, 'd0000000-0000-0000-0000-000000000008'::UUID, 'Black-Box & White-Box Testing Strategies: Equivalence, Boundary Values & Coverage', '### Learning Objectives
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
- The vast majority of input validation errors cluster at boundaries; Boundary Value Analysis catches off-by-one errors efficiently.', NULL, 45, false, 5, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0108-000000000006'::UUID, 'd0000000-0000-0000-0000-000000000008'::UUID, 'Test-Driven Development (TDD), Unit Testing & Mocking Frameworks', '### Learning Objectives
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
- Stubs return canned responses to incoming calls; Mocks verify that specific method calls and parameters occurred.', NULL, 50, false, 6, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0108-000000000007'::UUID, 'd0000000-0000-0000-0000-000000000008'::UUID, 'Continuous Integration / Continuous Delivery (CI/CD) & Quality Gates', '### Learning Objectives
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
- Continuous Integration requires developers to merge code to the main branch frequently, validated by automated build and test runs on every pull request.', NULL, 45, false, 7, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0109-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000009'::UUID, 'Intelligent Agents: PEAS Characterization and State-Space Formulation', '### Learning Objectives
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
- The nature of the environment dictates whether classical search, probabilistic planning, or reinforcement learning is the optimal agent architecture.', NULL, 40, true, 1, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0109-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000009'::UUID, 'Uninformed Search Strategies: BFS, DFS, and Uniform Cost Search', '### Learning Objectives
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
- Iterative Deepening Search (IDS) combines BFS''s completeness and optimality with DFS''s $O(bd)$ space efficiency.', NULL, 45, false, 2, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0109-000000000003'::UUID, 'd0000000-0000-0000-0000-000000000009'::UUID, 'Heuristic Search and the A* Algorithm: Admissibility and Consistency', '### Learning Objectives
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
- Relaxing problem constraints (e.g., allowing tiles to slide through each other in 15-puzzle) systematically yields admissible heuristics.', NULL, 50, false, 3, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0109-000000000004'::UUID, 'd0000000-0000-0000-0000-000000000009'::UUID, 'Adversarial Search: Minimax Algorithm and Alpha-Beta Pruning', '### Learning Objectives
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
- Ideal move ordering (best moves evaluated first): $O(b^{m/2})$, doubling the effective search depth in identical compute time.', NULL, 45, false, 4, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0109-000000000005'::UUID, 'd0000000-0000-0000-0000-000000000009'::UUID, 'Constraint Satisfaction Problems (CSP): Arc Consistency and Backtracking', '### Learning Objectives
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
3. **Least Constraining Value (LCV):** Order values to leave the maximal choices open for remaining unassigned variables.', NULL, 45, false, 5, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0109-000000000006'::UUID, 'd0000000-0000-0000-0000-000000000009'::UUID, 'Knowledge Representation and Propositional Logic Inference', '### Learning Objectives
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
- DPLL improves over naive truth tables by utilizing early termination, pure symbol heuristics, and unit clause propagation.', NULL, 40, false, 6, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0109-000000000007'::UUID, 'd0000000-0000-0000-0000-000000000009'::UUID, 'Probabilistic Reasoning and Bayesian Networks', '### Learning Objectives
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
- Exact inference is NP-hard in general graphs, motivating MCMC and belief propagation algorithms.', NULL, 50, false, 7, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0110-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000010'::UUID, 'Supervised Learning Setup: Loss Functions, Empirical Risk, and Optimization', '### Learning Objectives
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
3. **Binary Cross-Entropy (Logistic Loss):** $\mathcal{L}(\hat{y}, y) = - [y \log \hat{y} + (1 - y) \log(1 - \hat{y})]$. Convex for linear models.', NULL, 45, true, 1, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0110-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000010'::UUID, 'Linear and Logistic Regression: Closed-Form Normal Equation vs Iterative Solvers', '### Learning Objectives
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
- Gradient descent scales to arbitrary feature dimensions and non-linear extensions.', NULL, 50, false, 2, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0110-000000000003'::UUID, 'd0000000-0000-0000-0000-000000000010'::UUID, 'Generalization, Bias-Variance Tradeoff, and Regularization (L1 / L2)', '### Learning Objectives
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
   - Produces sparse weight vectors by driving non-informative coefficients exactly to zero (automated feature selection).', NULL, 45, false, 3, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0110-000000000004'::UUID, 'd0000000-0000-0000-0000-000000000010'::UUID, 'Decision Trees and Splitting Criteria: ID3, C4.5, and CART', '### Learning Objectives
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
- Unpruned trees have high variance and memorize noisy training samples.', NULL, 45, false, 4, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0110-000000000005'::UUID, 'd0000000-0000-0000-0000-000000000010'::UUID, 'Ensemble Learning: Bagging, Random Forests, and Gradient Boosting (XGBoost)', '### Learning Objectives
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
   $$F_m(x) = F_{m-1}(x) + \eta \cdot h_m(x)$$', NULL, 50, false, 5, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0110-000000000006'::UUID, 'd0000000-0000-0000-0000-000000000010'::UUID, 'Support Vector Machines: Maximum Margin Hyperplanes and Kernel Trick', '### Learning Objectives
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
- High $C$ penalizes misclassifications strictly (lower bias, higher variance); low $C$ allows larger margins with more slack violations.', NULL, 45, false, 6, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0110-000000000007'::UUID, 'd0000000-0000-0000-0000-000000000010'::UUID, 'Unsupervised Learning: K-Means, Gaussian Mixture Models, and PCA', '### Learning Objectives
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
5. Construct projection matrix $W = [v_1, v_2, \dots, v_k]$ and transform: $Z = \tilde{X} W$.', NULL, 50, false, 7, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0111-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000011'::UUID, 'From Recurrent Models to Self-Attention: Limitations of RNNs and LSTMs', '### Learning Objectives
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
For large projection dimension $d_k$, the dot products $q_i \cdot k_j = \sum_{m=1}^{d_k} q_{im} k_{jm}$ grow large in magnitude (variance $\approx d_k$ under unit variance assumptions). Large dot products push the softmax function into regions with near-zero gradients. Dividing by $\sqrt{d_k}$ preserves unit variance and prevents vanishing gradients.', NULL, 45, true, 1, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0111-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000011'::UUID, 'The Transformer Architecture: Multi-Head Attention, Residuals, and LayerNorm', '### Learning Objectives
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
This allows the dot product $\langle R_m q, R_n k \rangle$ to depend purely on relative token distance $(m - n)$, enabling length extrapolation.', NULL, 50, false, 2, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0111-000000000003'::UUID, 'd0000000-0000-0000-0000-000000000011'::UUID, 'Pretraining Paradigms: Causal LM vs Masked LM, Tokenization, and Scaling Laws', '### Learning Objectives
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
- To train a model compute-optimally, train with approximately $20$ tokens per model parameter.', NULL, 45, false, 3, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0111-000000000004'::UUID, 'd0000000-0000-0000-0000-000000000011'::UUID, 'Instruction Tuning and Alignment: SFT, RLHF, and Direct Preference Optimization (DPO)', '### Learning Objectives
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
This eliminates reinforcement learning instability, value networks, and reward model training.', NULL, 50, false, 4, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0111-000000000005'::UUID, 'd0000000-0000-0000-0000-000000000011'::UUID, 'Parameter-Efficient Fine-Tuning (PEFT): LoRA, QLoRA, and Prefix Tuning', '### Learning Objectives
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
- QLoRA 4-bit 7B model: $\approx 3.5$ GB weights $+ \approx 1$ GB LoRA adapter parameters and optimizer $\approx 6$ GB VRAM (fits on single consumer GPU).', NULL, 45, false, 5, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0111-000000000006'::UUID, 'd0000000-0000-0000-0000-000000000011'::UUID, 'Retrieval-Augmented Generation (RAG): Vector Databases and Dense Embeddings', '### Learning Objectives
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
3. **Semantic Chunking:** Computes embedding distance between consecutive sentences and cuts chunks at semantic inflection points.', NULL, 50, false, 6, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0111-000000000007'::UUID, 'd0000000-0000-0000-0000-000000000011'::UUID, 'Decoding Strategies, Hallucination Mitigation, and Evaluation', '### Learning Objectives
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
   Dynamically adjusts vocabulary width based on model certainty.', NULL, 45, false, 7, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0112-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000012'::UUID, 'Vector Spaces, Subspaces, and Linear Independence', '### Learning Objectives
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
- Any set of $k > n$ vectors in $\mathbb{R}^n$ must be linearly dependent.', NULL, 45, true, 1, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0112-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000012'::UUID, 'Systems of Linear Equations: Gaussian Elimination and LU Factorization', '### Learning Objectives
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
- Partial pivoting ($P A = L U$) prevents division by small pivot numbers, maintaining numerical stability against round-off errors.', NULL, 50, false, 2, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0112-000000000003'::UUID, 'd0000000-0000-0000-0000-000000000012'::UUID, 'The Four Fundamental Subspaces and the Rank-Nullity Theorem', '### Learning Objectives
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
Applying $A$ maps $x_{\text{null}}$ to $\mathbf{0}$ and gives an isomorphism between $C(A^T)$ and $C(A)$.', NULL, 45, false, 3, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0112-000000000004'::UUID, 'd0000000-0000-0000-0000-000000000012'::UUID, 'Eigenvalues, Eigenvectors, and Matrix Diagonalization', '### Learning Objectives
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
3. $A$ has an orthonormal basis of eigenvectors: $A = Q \Lambda Q^T$ with $Q^T Q = I$.', NULL, 50, false, 4, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0112-000000000005'::UUID, 'd0000000-0000-0000-0000-000000000012'::UUID, 'Orthogonality, Gram-Schmidt Process, and QR Decomposition', '### Learning Objectives
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
This solves least squares via backward substitution on $R$ without computing $A^T A$, preserving numerical condition number $\kappa(R) = \kappa(A)$.', NULL, 45, false, 5, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0112-000000000006'::UUID, 'd0000000-0000-0000-0000-000000000012'::UUID, 'Singular Value Decomposition (SVD) and Principal Component Analysis', '### Learning Objectives
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
This forms the foundational backbone of data compression, latent semantic indexing, and image denoising.', NULL, 50, false, 6, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0112-000000000007'::UUID, 'd0000000-0000-0000-0000-000000000012'::UUID, 'Multivariable Calculus: Gradients, Jacobians, Hessians, and Optimization', '### Learning Objectives
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
3. If $H(x^*)$ has both positive and negative eigenvalues: **saddle point**.', NULL, 50, false, 7, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0113-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000013'::UUID, 'Boolean Algebra, Logic Gates, and Karnaugh Map Minimization', '### Learning Objectives
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
- Don''t Care conditions ($d$) can be treated as 1 if they enlarge groups, or 0 otherwise.', NULL, 45, true, 1, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0113-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000013'::UUID, 'Combinational Logic: Adders, Decoders, Multiplexers, and Arithmetic Logic Units', '### Learning Objectives
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
$$Y = \sum_{k=0}^7 I_k \cdot m_k(S_2, S_1, S_0)$$', NULL, 50, false, 2, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0113-000000000003'::UUID, 'd0000000-0000-0000-0000-000000000013'::UUID, 'Sequential Circuits: Latches, Flip-Flops, Registers, and Counters', '### Learning Objectives
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
   $$f_{max} = \frac{1}{T_{clk}} = \frac{1}{t_{clk-q} + t_{comb} + t_{su}}$$', NULL, 45, false, 3, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0113-000000000004'::UUID, 'd0000000-0000-0000-0000-000000000013'::UUID, 'Finite State Machines (FSM): Moore vs Mealy Machine Synthesis', '### Learning Objectives
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
| Timing Response | Output changes one clock cycle later | Output changes immediately when input transitions |', NULL, 45, false, 4, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0113-000000000005'::UUID, 'd0000000-0000-0000-0000-000000000013'::UUID, 'Instruction Set Architecture (ISA): RISC-V 32-Bit Integer Core (RV32I)', '### Learning Objectives
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
- Only dedicated load and store instructions access main memory.', NULL, 50, false, 5, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0113-000000000006'::UUID, 'd0000000-0000-0000-0000-000000000013'::UUID, 'Pipelined Processor Architecture: 5 Stages, Hazards, and Forwarding', '### Learning Objectives
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
4. **Control Hazards (Branching):** Branch decision computed in EX stage causes 2 stalled cycles. Resolved via Dynamic Branch Prediction (2-bit saturating counters, Branch Target Buffers).', NULL, 50, false, 6, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0113-000000000007'::UUID, 'd0000000-0000-0000-0000-000000000013'::UUID, 'Memory Hierarchy: Direct-Mapped, Set-Associative Caches, and Virtual Memory', '### Learning Objectives
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
$$\text{AMAT} = H_1 + M_1 \times (H_2 + M_2 \times \text{Memory Penalty})$$', NULL, 45, false, 7, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0114-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000014'::UUID, 'NumPy Foundations: N-Dimensional Arrays, Broadcasting, and Vectorization', '### Learning Objectives
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
- Always prefer `axis`-based reduction (`sum`, `mean`, `std`) over iterative accumulation.', NULL, 40, true, 1, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0114-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000014'::UUID, 'Pandas Data Wrangling: Series, DataFrames, Indexing, and Cleaning', '### Learning Objectives
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
3. Drop: `df.dropna(subset=[''critical_id''])` removes rows with unrecoverable identifiers.', NULL, 45, false, 2, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0114-000000000003'::UUID, 'd0000000-0000-0000-0000-000000000014'::UUID, 'Aggregations and Relational Operations: GroupBy, Merge, and Pivot Tables', '### Learning Objectives
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
- `melt`: Unpivots wide columns into key-value pair rows for tidy data modeling.', NULL, 50, false, 3, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0114-000000000004'::UUID, 'd0000000-0000-0000-0000-000000000014'::UUID, 'Exploratory Data Analysis (EDA): Distributions, Outliers, and Correlation', '### Learning Objectives
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
- **Spearman $\rho$:** Pearson correlation applied to variable ranks; captures any monotonic non-linear relationship.', NULL, 45, false, 4, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0114-000000000005'::UUID, 'd0000000-0000-0000-0000-000000000014'::UUID, 'Statistical Visualization: Matplotlib and Seaborn Grammar of Graphics', '### Learning Objectives
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
```', NULL, 45, false, 5, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0114-000000000006'::UUID, 'd0000000-0000-0000-0000-000000000014'::UUID, 'Hypothesis Testing and A/B Experimentation Methodology', '### Learning Objectives
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
2. **Novelty Effect:** Users initially engage with UI changes out of curiosity, followed by reversion to baseline.', NULL, 50, false, 6, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0114-000000000007'::UUID, 'd0000000-0000-0000-0000-000000000014'::UUID, 'Time Series Analytics: Resampling, Moving Averages, and Seasonality', '### Learning Objectives
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
- $I_t$: Irregular residual noise.', NULL, 45, false, 7, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0115-000000000001'::UUID, 'd0000000-0000-0000-0000-000000000015'::UUID, 'Structured Technical Writing: The Minto Pyramid and Clear Engineering Prose', '### Learning Objectives
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
3. **Specific Quantified Metrics:** Avoid words like "fast", "scalable", or "large". Use concrete numbers ($p99 < 50\text{ ms}$, throughput $> 15,000\text{ RPS}$).', NULL, 40, true, 1, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0115-000000000002'::UUID, 'd0000000-0000-0000-0000-000000000015'::UUID, 'Software Design Documents (RFCs) and Architecture Decision Records (ADRs)', '### Learning Objectives
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
```', NULL, 45, false, 2, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0115-000000000003'::UUID, 'd0000000-0000-0000-0000-000000000015'::UUID, 'Incident Management and Blameless Postmortems', '### Learning Objectives
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
5. **Action Items:** Preventive and corrective tasks assigned with owners and strict SLA deadlines.', NULL, 45, false, 3, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0115-000000000004'::UUID, 'd0000000-0000-0000-0000-000000000015'::UUID, 'Root Cause Analysis Frameworks: 5 Whys, Ishikawa, and Fault Trees', '### Learning Objectives
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
- **Environment:** Cloud infrastructure limits, network latency, external vendor dependencies.', NULL, 45, false, 4, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0115-000000000005'::UUID, 'd0000000-0000-0000-0000-000000000015'::UUID, 'API Documentation and Technical Specifications: OpenAPI and Developer Portals', '### Learning Objectives
- Author comprehensive API contracts using the OpenAPI 3.1 specification.
- Document error schemas, rate limits, pagination conventions, and idempotency keys.
- Write actionable quickstarts, interactive code examples, and troubleshooting guides.

### Best Practices for API Documentation
1. **Show Complete Payloads:** Always provide realistic JSON request and response payloads, not just abstract type names.
2. **Explicit Error Catalogs:** Document every HTTP status code (400, 401, 403, 404, 409, 422, 429, 500) with specific error codes and remediation advice.
3. **Authentication & Security:** Clearly detail token formats (e.g. `Bearer <jwt>`), scoping requirements, and header signatures.
4. **Idempotency Standards:** Explain how clients can safely retry network timeouts by attaching `Idempotency-Key` headers.', NULL, 40, false, 5, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
INSERT INTO public.lessons (id, course_id, title, content, video_url, duration_minutes, is_free_preview, order_index, created_at) VALUES ('d0000000-0000-0000-0115-000000000006'::UUID, 'd0000000-0000-0000-0000-000000000015'::UUID, 'Cognitive Biases in Engineering Decision Making and Trade-off Frameworks', '### Learning Objectives
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
| **Weighted Total** | **100%** | **5.80** | **7.25** | **7.70** |', NULL, 45, false, 6, NOW()) ON CONFLICT (id) DO UPDATE SET course_id = EXCLUDED.course_id, title = EXCLUDED.title, content = EXCLUDED.content, video_url = EXCLUDED.video_url, duration_minutes = EXCLUDED.duration_minutes, is_free_preview = EXCLUDED.is_free_preview, order_index = EXCLUDED.order_index;
COMMIT;
