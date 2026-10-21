// scripts/data_cs_software_part2.js
// Courses 3-4: Data Structures & Algorithms, Full-Stack Web Development

export const coursesPart2 = [
  // -------------------------------------------------------------------------
  // 3. Data Structures and Algorithms
  // -------------------------------------------------------------------------
  {
    id: 'd0000000-0000-0000-0000-000000000003',
    title: 'Data Structures and Algorithms',
    slug: 'data-structures-and-algorithms',
    description: 'Comprehensive undergraduate algorithms curriculum: asymptotic complexity, linear structures, trees, priority heaps, graph traversal, shortest path algorithms, dynamic programming, and greedy optimization.',
    category: 'Computer Science',
    level: 'Intermediate',
    thumbnail_url: 'https://images.unsplash.com/photo-1509228468518-180dd4864904?q=80&w=800&auto=format&fit=crop',
    lessons: [
      {
        id: 'd0000000-0000-0000-0103-000000000001',
        title: 'Asymptotic Analysis & Mathematical Foundations: Big-O, Big-Omega, Big-Theta',
        duration_minutes: 45,
        is_free_preview: true,
        order_index: 1,
        content: `### Learning Objectives
- Formally define asymptotic bounds: $O(g(n))$, $\\Omega(g(n))$, and $\\Theta(g(n))$.
- Analyze worst-case, best-case, and average-case time and space complexities.
- Solve recurrence relations using the Master Theorem and recursion trees.

### Formal Asymptotic Definitions
- **Big-O (Upper Bound)**: $f(n) \\in O(g(n))$ if there exist constants $c > 0$ and $n_0 \\ge 0$ such that $0 \\le f(n) \\le c \\cdot g(n)$ for all $n \\ge n_0$.
- **Big-Omega (Lower Bound)**: $f(n) \\in \\Omega(g(n))$ if there exist constants $c > 0$ and $n_0 \\ge 0$ such that $0 \\le c \\cdot g(n) \\le f(n)$ for all $n \\ge n_0$.
- **Big-Theta (Tight Bound)**: $f(n) \\in \\Theta(g(n))$ if $f(n) \\in O(g(n))$ and $f(n) \\in \\Omega(g(n))$.

### Master Theorem for Divide-and-Conquer
For recurrences of the form $T(n) = a T(n/b) + f(n)$ where $a \\ge 1, b > 1$:
1. If $f(n) = O(n^{\\log_b a - \\epsilon})$ for $\\epsilon > 0$, then $T(n) = \\Theta(n^{\\log_b a})$.
2. If $f(n) = \\Theta(n^{\\log_b a} \\log^k n)$ for $k \\ge 0$, then $T(n) = \\Theta(n^{\\log_b a} \\log^{k+1} n)$.
3. If $f(n) = \\Omega(n^{\\log_b a + \\epsilon})$ for $\\epsilon > 0$, and regularity holds, then $T(n) = \\Theta(f(n))$.

### Key Takeaways
- Asymptotic notation abstracts away hardware constants to quantify algorithmic scaling as input size approaches infinity.
- Space complexity must account for both auxiliary heap allocation and call stack frames in recursive algorithms.`
      },
      {
        id: 'd0000000-0000-0000-0103-000000000002',
        title: 'Linear Data Structures: Dynamic Arrays & Linked Lists',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 2,
        content: `### Learning Objectives
- Analyze dynamic array geometric resizing and amortized $O(1)$ append complexity.
- Implement singly linked lists, doubly linked lists, and circular lists with pointer manipulation.
- Compare memory locality, cache friendliness, and trade-offs between arrays and linked lists.

### Amortized Analysis of Dynamic Array Growth
When a dynamic array reaches capacity $C$, it allocates a new buffer of capacity $2C$ and copies all $C$ elements. 
- Over $N$ appends, total elements copied $= 1 + 2 + 4 + ... + N/2 = N - 1$.
- Total work $= N + (N - 1) = 2N - 1 = O(N)$.
- Amortized cost per append $= O(N) / N = O(1)$.

\`\`\`python
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
\`\`\`

### Key Takeaways
- Arrays provide $O(1)$ random access and cache locality due to contiguous memory allocation.
- Linked lists provide $O(1)$ insertion/deletion once the position is reached, but suffer from pointer overhead and cache misses.`
      },
      {
        id: 'd0000000-0000-0000-0103-000000000003',
        title: 'Stacks, Queues, and Monotonic Sequence Techniques',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 3,
        content: `### Learning Objectives
- Implement LIFO Stacks and FIFO Queues using arrays and linked lists.
- Solve expression parsing problems (infix to postfix, balanced parentheses).
- Master monotonic stack patterns for $O(n)$ next-greater-element queries.

### Monotonic Stack Algorithm
\`\`\`python
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
\`\`\`

### Key Takeaways
- Stacks model recursion, call stacks, and nested parsing.
- Circular queues resolve the memory waste of naive array queues using modulo pointer arithmetic: \`tail = (tail + 1) % capacity\`.`
      },
      {
        id: 'd0000000-0000-0000-0103-000000000004',
        title: 'Binary Trees, Binary Search Trees (BST) & AVL Self-Balancing',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 4,
        content: `### Learning Objectives
- Implement tree traversals: Pre-order, In-order, Post-order, and Level-order (BFS).
- Understand BST ordering invariant: Left Subtree $<$ Root $<$ Right Subtree.
- Maintain $O(\\log n)$ search height using AVL tree rotations (LL, RR, LR, RL).

### AVL Tree Balance Factor
For any node $N$:
$$\\text{Balance Factor}(N) = \\text{Height}(\\text{Left Subtree}) - \\text{Height}(\\text{Right Subtree}) \\in \\{-1, 0, 1\\}$$

When $|\\text{Balance Factor}| > 1$, self-balancing rotations restore balance:
- **Left-Left (LL)**: Single right rotation.
- **Right-Right (RR)**: Single left rotation.
- **Left-Right (LR)**: Left rotation on left child, then right rotation on parent.
- **Right-Left (RL)**: Right rotation on right child, then left rotation on parent.

### Key Takeaways
- An in-order traversal of a BST always yields keys in strictly increasing sorted order.
- Unbalanced BSTs degrade to $O(n)$ linked lists on sorted inputs; self-balancing trees guarantee $O(\\log n)$ worst-case bounds.`
      },
      {
        id: 'd0000000-0000-0000-0103-000000000005',
        title: 'Priority Queues, Binary Heaps & Heapsort',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 5,
        content: `### Learning Objectives
- Formulate complete binary trees into contiguous 1D array representations.
- Implement Max-Heap and Min-Heap operations: \`insert\` ($O(\\log n)$) and \`extract_min\` ($O(\\log n)$).
- Build a heap in linear time $O(n)$ using bottom-up heapification.

### Heap Array Indexing Relationships (0-Indexed)
For node at index $i$:
- **Parent**: $\\lfloor (i - 1) / 2 \\rfloor$
- **Left Child**: $2i + 1$
- **Right Child**: $2i + 2$

### Linear-Time Heap Construction
Bottom-up heapification calls \`sift_down\` starting from the last non-leaf node $\\lfloor n/2 \\rfloor - 1$ down to root $0$:
$$\\sum_{h=0}^{\\lfloor \\log n \\rfloor} \\frac{n}{2^{h+1}} O(h) = O(n)$$

### Key Takeaways
- Building a heap from an unsorted array takes $O(n)$ time, not $O(n \\log n)$.
- Heapsort achieves $O(n \\log n)$ worst-case sorting in-place without auxiliary memory.`
      },
      {
        id: 'd0000000-0000-0000-0103-000000000006',
        title: 'Graph Representations & Traversal: BFS, DFS, and Topological Sort',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 6,
        content: `### Learning Objectives
- Represent directed and undirected graphs via Adjacency Matrices and Adjacency Lists.
- Implement Breadth-First Search (queue) and Depth-First Search (stack/recursion).
- Detect cycles in directed graphs and compute Topological Sortings for DAGs.

### Traversal Complexities
With $V$ vertices and $E$ edges:
- **Time Complexity**: $O(V + E)$ using Adjacency Lists.
- **Space Complexity**: $O(V)$ for visited tracking and recursion/queue storage.

\`\`\`python
from collections import defaultdict, deque

def kahn_topological_sort(num_courses: int, prerequisites: list[tuple[int, int]]) -> list[int]:
    """Kahn's Algorithm for Topological Sort using In-Degrees."""
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
\`\`\`

### Key Takeaways
- BFS computes the shortest path in unweighted graphs.
- Topological sorting is valid only on Directed Acyclic Graphs (DAGs); a topological sort failure proves the presence of a cycle.`
      },
      {
        id: 'd0000000-0000-0000-0103-000000000007',
        title: 'Shortest Path Algorithms: Dijkstra and Bellman-Ford',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 7,
        content: `### Learning Objectives
- Formulate single-source shortest path problems.
- Implement Dijkstra's Algorithm with a min-priority heap ($O((V + E) \\log V)$).
- Apply Bellman-Ford algorithm for graphs with negative edge weights and negative cycle detection.

### Dijkstra vs Bellman-Ford
| Feature | Dijkstra | Bellman-Ford |
| :--- | :--- | :--- |
| **Edge Weights** | Non-negative only ($\ge 0$) | Arbitrary real weights |
| **Time Complexity** | $O((V + E) \\log V)$ | $O(V \\cdot E)$ |
| **Negative Cycle Detection** | Cannot handle | Detects reachable negative cycles |
| **Strategy** | Greedy priority relaxation | Dynamic programming edge relaxation |

### Key Takeaways
- Dijkstra fails on negative weight edges because its greedy assumption (that the shortest distance to the nearest unvisited node is finalized) is violated by subsequent negative deductions.
- Bellman-Ford relaxes all $|E|$ edges $|V| - 1$ times; an extra relaxation pass that decreases any distance proves the existence of a negative cycle.`
      },
      {
        id: 'd0000000-0000-0000-0103-000000000008',
        title: 'Dynamic Programming: Memoization, Tabulation & the Knapsack Problem',
        duration_minutes: 55,
        is_free_preview: false,
        order_index: 8,
        content: `### Learning Objectives
- Identify optimal substructure and overlapping subproblems in computational problems.
- Master top-down dynamic programming with memoization and bottom-up DP with tabulation.
- Formulate recurrences for classic problems: 0/1 Knapsack, Longest Common Subsequence (LCS), and Coin Change.

### 0/1 Knapsack Dynamic Programming Formulation
Let $dp[i][w]$ be the maximum value achievable considering the first $i$ items with weight capacity $w$:
$$dp[i][w] = \\begin{cases} dp[i-1][w] & \\text{if } \\text{weight}[i-1] > w \\\\ \\max(dp[i-1][w], \\text{value}[i-1] + dp[i-1][w - \\text{weight}[i-1]]) & \\text{otherwise} \\end{cases}$$

\`\`\`python
def knapsack_01(weights: list[int], values: list[int], capacity: int) -> int:
    dp = [0] * (capacity + 1)
    for w_i, v_i in zip(weights, values):
        # Iterate backwards to reuse previous subproblem values without state corruption
        for c in range(capacity, w_i - 1, -1):
            dp[c] = max(dp[c], v_i + dp[c - w_i])
    return dp[capacity]
\`\`\`

### Key Takeaways
- Dynamic programming avoids exponential recomputation by caching results to overlapping subproblems.
- Iterating backwards in 1D array tabulation solves the 0/1 knapsack problem in $O(W)$ auxiliary space.`
      }
    ],
    quizzes: [
      {
        id: 'd0000000-0000-0000-0203-000000000001',
        title: 'Asymptotic Complexity & Linear Structures Quiz',
        description: 'Covers Big-O analysis, recurrence relations, array amortized bounds, and linked list pointers.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0303-000000000001',
            order_index: 1,
            marks: 10,
            question_text: 'What is the solution to the recurrence relation T(n) = 2T(n/2) + O(n) according to the Master Theorem?',
            options: ['O(n)', 'O(n log n)', 'O(n^2)', 'O(log n)'],
            correct_option_index: 1,
            explanation: 'Here a=2, b=2, so n^(log_b a) = n^1 = n. Since f(n) = Theta(n), Case 2 of the Master Theorem applies, yielding T(n) = Theta(n log n).'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000002',
            order_index: 2,
            marks: 10,
            question_text: 'What is the amortized time complexity of appending an element to a dynamically resizing array that doubles capacity when full?',
            options: ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'],
            correct_option_index: 0,
            explanation: 'While individual resizing steps cost O(n), doubling the capacity distributes the copying cost such that the amortized cost per append is O(1).'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000003',
            order_index: 3,
            marks: 10,
            question_text: 'What is the time complexity to delete a node in a Singly Linked List given only a pointer directly to that target node (not the tail node)?',
            options: [
              'O(1) by copying data from the next node and bypassing the next node.',
              'O(n) because finding the preceding node is required.',
              'O(log n)',
              'Impossible without rewriting the entire list.'
            ],
            correct_option_index: 0,
            explanation: 'By copying the value of node.next into node and setting node.next = node.next.next, deletion is accomplished in O(1) time without needing the preceding node pointer.'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000004',
            order_index: 4,
            marks: 10,
            question_text: 'Which asymptotic notation indicates that an algorithm will take AT LEAST a given amount of time in the worst case (asymptotic lower bound)?',
            options: ['Big-O', 'Big-Omega (Ω)', 'Little-o', 'Big-Theta (Θ)'],
            correct_option_index: 1,
            explanation: 'Big-Omega (Ω) describes an asymptotic lower bound on function growth rate.'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000005',
            order_index: 5,
            marks: 10,
            question_text: 'What is the time complexity of reversing a singly linked list containing n nodes iteratively?',
            options: ['O(n) time, O(1) auxiliary space', 'O(n^2) time, O(n) space', 'O(1) time, O(1) space', 'O(n log n) time, O(log n) space'],
            correct_option_index: 0,
            explanation: 'Iterative reversal traverses each node once using three pointers (prev, curr, next), running in O(n) time and O(1) extra space.'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000006',
            order_index: 6,
            marks: 10,
            question_text: 'Why do arrays generally outperform linked lists for sequential iteration despite having identical asymptotic O(n) time?',
            options: [
              'Arrays use CPU cache prefetching effectively due to contiguous spatial memory locality.',
              'Arrays do not store data in RAM.',
              'Linked lists require operating system kernel calls on every pointer traversal.',
              'Arrays use multithreading automatically.'
            ],
            correct_option_index: 0,
            explanation: 'Contiguous memory layout allows hardware CPU caches to prefetch cache lines, whereas linked list nodes scattered across heap memory cause frequent cache misses.'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000007',
            order_index: 7,
            marks: 10,
            question_text: 'What data structure is ideal for checking whether mathematical expressions contain properly balanced brackets: (([]{}))?',
            options: ['Queue', 'Stack', 'Heap', 'Graph'],
            correct_option_index: 1,
            explanation: 'A LIFO stack matches the most recently opened unclosed bracket with the next encountered closing bracket.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0203-000000000002',
        title: 'Trees, Binary Heaps & Priority Queues Quiz',
        description: 'Tests BST invariant properties, tree traversal orders, AVL balance factors, and heapification complexity.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0303-000000000008',
            order_index: 1,
            marks: 10,
            question_text: 'Which tree traversal order visits nodes in non-decreasing sorted order for any valid Binary Search Tree?',
            options: ['Pre-order', 'In-order', 'Post-order', 'Level-order'],
            correct_option_index: 1,
            explanation: 'In-order traversal visits left subtree, current node, then right subtree, matching the BST ordering invariant and producing sorted keys.'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000009',
            order_index: 2,
            marks: 10,
            question_text: 'What is the time complexity to build a binary heap from an arbitrary unsorted array of n elements using bottom-up heapify?',
            options: ['O(n)', 'O(n log n)', 'O(n^2)', 'O(log n)'],
            correct_option_index: 0,
            explanation: 'Bottom-up heapification requires O(n) total operations because the vast majority of nodes reside near the bottom levels where height is small.'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000010',
            order_index: 3,
            marks: 10,
            question_text: 'What is the valid range of balance factors allowed for every node in an AVL tree?',
            options: ['{-1, 0, 1}', '{-2, -1, 0, 1, 2}', '{0}', '{1, 2}'],
            correct_option_index: 0,
            explanation: 'An AVL tree maintains height balance such that the height difference between left and right subtrees of any node is at most 1: balance factor in {-1, 0, 1}.'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000011',
            order_index: 4,
            marks: 10,
            question_text: 'In a 0-indexed array implementation of a binary heap, where is the parent of a node at index i located?',
            options: ['(i - 1) / 2', '2i + 1', '2i + 2', 'i / 2'],
            correct_option_index: 0,
            explanation: 'In a 0-indexed binary heap array, the parent of node i is at floor((i - 1) / 2).'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000012',
            order_index: 5,
            marks: 10,
            question_text: 'What rotation sequence restores balance when an insertion occurs in the right subtree of the left child of an unbalanced node?',
            options: ['Right-Left (RL) rotation', 'Left-Right (LR) double rotation', 'Single Left rotation', 'Single Right rotation'],
            correct_option_index: 1,
            explanation: 'A Left-Right (LR) imbalance is resolved by a left rotation on the left child followed by a right rotation on the unbalanced parent.'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000013',
            order_index: 6,
            marks: 10,
            question_text: 'What is the worst-case search time complexity in an unbalanced binary search tree with n nodes?',
            options: ['O(log n)', 'O(n)', 'O(1)', 'O(n log n)'],
            correct_option_index: 1,
            explanation: 'If keys are inserted in strictly ascending or descending order, an unbalanced BST degenerates into a linear linked list of height n, requiring O(n) search.'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000014',
            order_index: 7,
            marks: 10,
            question_text: 'What is the auxiliary space complexity of heapsort when implemented in-place on an array?',
            options: ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'],
            correct_option_index: 0,
            explanation: 'Heapsort reorganizes the array in-place without needing extra buffers, achieving O(1) auxiliary space.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0203-000000000003',
        title: 'Graph Algorithms & Shortest Path Traversal Quiz',
        description: 'Examines BFS, DFS, Topological Sorting, Dijkstra, and Bellman-Ford algorithms.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0303-000000000015',
            order_index: 1,
            marks: 10,
            question_text: 'What graph representation consumes O(V^2) memory regardless of the number of edges?',
            options: ['Adjacency List', 'Adjacency Matrix', 'Edge List', 'Incidence List'],
            correct_option_index: 1,
            explanation: 'An Adjacency Matrix allocates a V x V boolean/weight matrix, requiring Θ(V^2) space even for sparse graphs.'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000016',
            order_index: 2,
            marks: 10,
            question_text: 'Why does Dijkstra\'s algorithm fail to guarantee shortest paths on graphs with negative edge weights?',
            options: [
              'Because the priority queue throws an exception on negative keys.',
              'Because once a node is extracted from the priority queue and marked visited, its distance is assumed finalized, but a subsequent negative edge could offer a cheaper route.',
              'Because it cannot visit nodes in BFS order.',
              'Because it requires undirected graphs.'
            ],
            correct_option_index: 1,
            explanation: 'Dijkstra\'s greedy design permanently fixes a vertex distance once settled from the priority queue, which is invalidated if negative edges reduce path lengths later.'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000017',
            order_index: 3,
            marks: 10,
            question_text: 'What is the time complexity of Dijkstra\'s algorithm using a binary min-heap priority queue?',
            options: ['O((V + E) log V)', 'O(V^2)', 'O(V * E)', 'O(E log E)'],
            correct_option_index: 0,
            explanation: 'With a binary heap, extracting min takes O(log V) for V vertices and edge relaxations decrease key in O(log V) across E edges, totaling O((V + E) log V).'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000018',
            order_index: 4,
            marks: 10,
            question_text: 'How many times does the Bellman-Ford algorithm relax all edges in a graph with V vertices?',
            options: ['V times', 'V - 1 times', 'E times', 'log V times'],
            correct_option_index: 1,
            explanation: 'In a graph with V vertices and no negative cycles, a simple shortest path contains at most V - 1 edges, requiring V - 1 relaxation rounds.'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000019',
            order_index: 5,
            marks: 10,
            question_text: 'Which algorithm finds a topological ordering of vertices in a Directed Acyclic Graph (DAG) by tracking in-degrees?',
            options: ['Prim\'s Algorithm', 'Kahn\'s Algorithm', 'Kruskal\'s Algorithm', 'Floyd-Warshall Algorithm'],
            correct_option_index: 1,
            explanation: 'Kahn\'s algorithm maintains vertex in-degrees, repeatedly queueing vertices with in-degree 0 and removing their outgoing edges.'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000020',
            order_index: 6,
            marks: 10,
            question_text: 'What algorithm is best suited for computing all-pairs shortest paths on dense graphs in O(V^3) time?',
            options: ['Floyd-Warshall Algorithm', 'Dijkstra\'s Algorithm', 'Bellman-Ford Algorithm', 'BFS'],
            correct_option_index: 0,
            explanation: 'The Floyd-Warshall algorithm uses dynamic programming with a 3-nested loop over all vertices to find all-pairs shortest paths in O(V^3) time.'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000021',
            order_index: 7,
            marks: 10,
            question_text: 'What is the primary condition required for a directed graph to have at least one valid topological sort?',
            options: [
              'It must be strongly connected.',
              'It must be a Directed Acyclic Graph (DAG) with zero cycles.',
              'It must be a complete graph.',
              'All edge weights must be strictly positive.'
            ],
            correct_option_index: 1,
            explanation: 'Topological sort is only possible on DAGs; any cycle creates an impossible dependency loop (A must precede B which must precede A).'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0203-000000000004',
        title: 'Dynamic Programming & Advanced Algorithmic Paradigms Quiz',
        description: 'Tests memoization vs tabulation, knapsack problems, LCS recurrence, and greedy choice properties.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0303-000000000022',
            order_index: 1,
            marks: 10,
            question_text: 'What two properties must a computational problem exhibit to be solvable via Dynamic Programming?',
            options: [
              'Optimal substructure and overlapping subproblems.',
              'Linear time complexity and greedy choice property.',
              'Continuous differentiability and convexity.',
              'Randomized pivots and logarithmic height.'
            ],
            correct_option_index: 0,
            explanation: 'Dynamic Programming requires that optimal solutions contain optimal solutions to subproblems (optimal substructure) and that subproblems recur repeatedly (overlapping subproblems).'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000023',
            order_index: 2,
            marks: 10,
            question_text: 'What is the time complexity of the standard dynamic programming solution to the 0/1 Knapsack problem with n items and capacity W?',
            options: ['O(n * W) pseudo-polynomial time', 'O(2^n)', 'O(n log W)', 'O(n + W)'],
            correct_option_index: 0,
            explanation: 'The 0/1 Knapsack DP fills an n x W table, running in O(n * W) time, which is pseudo-polynomial because W depends on the numeric magnitude of the input.'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000024',
            order_index: 3,
            marks: 10,
            question_text: 'In the Longest Common Subsequence (LCS) problem, what is the recurrence relation when characters match (X[i] == Y[j])?',
            options: [
              'LCS(i, j) = 1 + LCS(i - 1, j - 1)',
              'LCS(i, j) = max(LCS(i - 1, j), LCS(i, j - 1))',
              'LCS(i, j) = 2 * LCS(i - 1, j - 1)',
              'LCS(i, j) = LCS(i - 1, j) + 1'
            ],
            correct_option_index: 0,
            explanation: 'When characters match at indices i and j, they contribute 1 to the matching sequence plus the LCS of the prefixes X[1..i-1] and Y[1..j-1].'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000025',
            order_index: 4,
            marks: 10,
            question_text: 'Why does the Fractional Knapsack problem succeed with a Greedy algorithm while 0/1 Knapsack fails?',
            options: [
              'Items can be divided into arbitrary fractions, ensuring that taking the item with the highest value-to-weight ratio is always globally optimal.',
              'Fractional knapsack requires dynamic programming.',
              '0/1 knapsack items cannot be sorted.',
              'Greedy algorithms only work on graphs.'
            ],
            correct_option_index: 0,
            explanation: 'Divisibility guarantees the greedy choice property: filling available capacity with maximum value density never leaves unusable gaps.'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000026',
            order_index: 5,
            marks: 10,
            question_text: 'How can the space complexity of the Fibonacci tabulation algorithm be reduced from O(n) to O(1)?',
            options: [
              'By storing only the previous two computed values (prev1, prev2) instead of an entire array of size n.',
              'By using a binary heap.',
              'By compiling to C++.',
              'By increasing stack memory size.'
            ],
            correct_option_index: 0,
            explanation: 'Since computing F(n) = F(n-1) + F(n-2) only depends on the immediate previous two states, rolling variables achieve O(1) auxiliary space.'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000027',
            order_index: 6,
            marks: 10,
            question_text: 'What approach does top-down Dynamic Programming employ?',
            options: [
              'Recursive problem formulation augmented with memoization caching.',
              'Iterative table population starting from base cases.',
              'Randomized tree partitioning.',
              'Greedy local choice optimization.'
            ],
            correct_option_index: 0,
            explanation: 'Top-down DP preserves natural recursive call structures and caches computed subproblem results in a hash map or table (memoization).'
          },
          {
            id: 'd0000000-0000-0000-0303-000000000028',
            order_index: 7,
            marks: 10,
            question_text: 'What is the time complexity of the Floyd-Warshall algorithm for finding all-pairs shortest paths?',
            options: ['O(V^3)', 'O(V^2 log V)', 'O(E * V)', 'O(V + E)'],
            correct_option_index: 0,
            explanation: 'Floyd-Warshall evaluates all vertex pairs across all intermediate vertices k in 1..V, resulting in three nested loops each running V times: O(V^3).'
          }
        ]
      }
    ],
    assignments: [
      {
        id: 'd0000000-0000-0000-0403-000000000001',
        title: 'Project 1: Custom High-Performance Dynamic Array & Self-Balancing BST Implementation',
        description: `### Assignment Overview
Implement and evaluate fundamental data structures from scratch in Python, C++, or Java without using high-level built-in collection classes. You will construct a geometrically expanding dynamic array and an AVL self-balancing binary search tree.

### Deliverables
1. \`dynamic_array\`: Source code implementing \`append\`, \`insert(index, val)\`, \`delete(index)\`, and automatic geometric resizing ($2\\times$).
2. \`avl_tree\`: Source code implementing node insertion, deletion, height calculations, and tree rotations (LL, RR, LR, RL).
3. \`benchmark_report.pdf\`: Performance graphs comparing insertion times across 10,000 to 1,000,000 elements against raw standard library collections.

### Requirements & Functional Specifications
- **Dynamic Array**:
  - Enforce bounds checking and amortized $O(1)$ appends.
  - Shrink capacity by half when elements drop below 25% capacity to prevent memory thrashing.
- **AVL Tree**:
  - Maintain balance factor in $\\{-1, 0, 1\\}$ for all nodes after every insert and delete operation.
  - Implement an in-order generator/iterator returning keys in sorted order.

### Evaluation Rubric (Total: 100 Marks)
- **Dynamic Array Correctness & Amortization (30 Marks)**: Correct bounds handling, growth factor implementation, and resizing logic.
- **AVL Balancing & Rotations (35 Marks)**: Accurate balance factor updates and flawless execution of single and double rotations.
- **Asymptotic Benchmark Analysis (20 Marks)**: Thorough empirical timing tests plotted against theoretical Big-O curves.
- **Code Cleanliness & Documentation (15 Marks)**: Clean comments, memory deallocation, and modular organization.`,
        due_date: '2026-11-30T23:59:59Z',
        max_marks: 100,
        allow_resubmission: true,
        is_published: true
      },
      {
        id: 'd0000000-0000-0000-0403-000000000002',
        title: 'Project 2: Campus Route Navigator Using Dijkstra & A* Graph Search',
        description: `### Assignment Overview
Construct an engineering campus navigation system modeling buildings and pathways as a weighted graph. Implement Dijkstra's algorithm and the A* heuristic search algorithm to compute optimal walking paths between academic buildings.

### Deliverables
1. \`campus_graph.py\`: Graph data structure parsing a campus coordinates and pathway distance dataset.
2. \`pathfinder.py\`: Implementations of Dijkstra and A* search using Euclidean distance heuristics.
3. \`benchmark_comparison.md\`: Empirical report comparing total nodes visited and execution times between Dijkstra and A*.

### Technical Specifications
- **Graph Modeling**: Represent at least 15 campus locations (vertices) and 30 bidirectional walkways (edges) with positive distance weights and 2D geographic coordinates $(x, y)$.
- **Algorithms**:
  - Dijkstra\'s algorithm using a binary min-heap priority queue.
  - A* search using admissible Euclidean straight-line distance $h(n) = \\sqrt{(x_2 - x_1)^2 + (y_2 - y_1)^2}$.
- **Validation**: Verify that A* returns an identically optimal distance while expanding fewer nodes than Dijkstra.

### Evaluation Rubric (Total: 100 Marks)
- **Graph Implementation & Min-Heap Priority Queue (30 Marks)**: Efficient adjacency list representation and heap-based priority queue.
- **Dijkstra & A* Algorithm Implementation (35 Marks)**: Correct shortest path discovery, path reconstruction, and heuristic evaluation.
- **Comparative Search Efficiency Benchmark (20 Marks)**: Demonstrated node expansion reduction with A* vs Dijkstra.
- **Code Architecture & Documentation (15 Marks)**: Clear modularity, type hints, and usage documentation.`,
        due_date: '2026-12-15T23:59:59Z',
        max_marks: 100,
        allow_resubmission: true,
        is_published: true
      }
    ]
  },

  // -------------------------------------------------------------------------
  // 4. Full-Stack Web Development
  // -------------------------------------------------------------------------
  {
    id: 'd0000000-0000-0000-0000-000000000004',
    title: 'Full-Stack Web Development',
    slug: 'full-stack-web-development',
    description: 'Modern full-stack web engineering: HTTP/1.1 to HTTP/3 protocols, semantic HTML5, responsive CSS Grid/Flexbox, ES6+ asynchronous JavaScript, React component hierarchies, state management, REST API architecture, and token security.',
    category: 'Web Development',
    level: 'Intermediate',
    thumbnail_url: 'https://images.unsplash.com/photo-1547658719-da2b51169166?q=80&w=800&auto=format&fit=crop',
    lessons: [
      {
        id: 'd0000000-0000-0000-0104-000000000001',
        title: 'Modern Web Architecture: HTTP/1.1 to HTTP/3 & The Client-Server Lifecycle',
        duration_minutes: 40,
        is_free_preview: true,
        order_index: 1,
        content: `### Learning Objectives
- Trace the lifecycle of a web request: DNS lookup, TCP handshake, TLS negotiation, HTTP exchange, and browser DOM rendering.
- Compare HTTP/1.1 head-of-line blocking with HTTP/2 binary multiplexing and HTTP/3 QUIC UDP transport.
- Understand HTTP headers, caching directives (\`Cache-Control\`, \`ETag\`), and status codes (2xx, 3xx, 4xx, 5xx).

### Evolution of the HTTP Protocol
- **HTTP/1.1**: Persistent TCP connections with pipelining, but suffers from head-of-line (HOL) blocking when one slow response blocks subsequent requests on that TCP connection.
- **HTTP/2**: Single TCP connection per origin with binary framing and multiplexed concurrent streams, eliminating HTTP-layer HOL blocking.
- **HTTP/3**: Operates over QUIC (built on UDP), resolving transport-layer packet loss blocking and providing 0-RTT connection resumption.

### Key Takeaways
- Always enforce HTTPS via TLS 1.3 to guarantee data confidentiality and integrity in transit.
- Proper caching headers (\`Cache-Control: public, max-age=31536000, immutable\`) dramatically reduce round-trip latency for static assets.`
      },
      {
        id: 'd0000000-0000-0000-0104-000000000002',
        title: 'Semantic HTML5 & Responsive Design with CSS Grid and Flexbox',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 2,
        content: `### Learning Objectives
- Structure documents with semantic elements: \`<header>\`, \`<nav>\`, \`<main>\`, \`<article>\`, \`<section>\`, \`<aside>\`, and \`<footer>\`.
- Master 1D layouts with CSS Flexbox (\`flex-direction\`, \`justify-content\`, \`align-items\`).
- Architect 2D page grids with CSS Grid (\`grid-template-columns\`, \`grid-template-areas\`, \`gap\`).

### CSS Grid vs Flexbox Architectural Comparison
\`\`\`css
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
\`\`\`

### Key Takeaways
- Use **Flexbox** for one-dimensional linear distributions (rows or columns, navigation bars, button groups).
- Use **CSS Grid** for two-dimensional structural page layouts aligning both columns and rows simultaneously.`
      },
      {
        id: 'd0000000-0000-0000-0104-000000000003',
        title: 'Modern JavaScript (ES6+): Closures, Event Loop & Async/Await',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 3,
        content: `### Learning Objectives
- Understand JavaScript\'s single-threaded event loop, Call Stack, Task Queue (Macrotasks), and Microtask Queue (Promises).
- Master functional closures, scope chains, and lexical \`this\` in arrow functions.
- Write asynchronous pipelines using Promises and \`async\`/\`await\` with robust \`try\`/\`catch\` blocks.

### The JavaScript Event Loop Execution Order
1. Execute synchronous code on the **Call Stack**.
2. Process all pending jobs in the **Microtask Queue** (Promise \`.then\`, \`await\` continuations, \`queueMicrotask\`) until completely empty.
3. Render DOM repaints if scheduled.
4. Dequeue and execute the next task in the **Macrotask Queue** (\`setTimeout\`, \`setInterval\`, I/O).

\`\`\`javascript
async function fetchCourseMetrics(courseId) {
  try {
    const response = await fetch(\`/api/courses/\${courseId}/metrics\`);
    if (!response.ok) {
      throw new Error(\`HTTP \${response.status}: Failed to retrieve metrics\`);
    }
    const data = await response.json();
    return data;
  } catch (err) {
    console.error("Network or parsing error:", err);
    throw err;
  }
}
\`\`\`

### Key Takeaways
- Microtasks (Promises) always run before the next macrotask (timers/events).
- Arrow functions do not bind their own \`this\`, inheriting \`this\` lexically from the enclosing execution context.`
      },
      {
        id: 'd0000000-0000-0000-0104-000000000004',
        title: 'Component-Driven Frontend Architecture with React',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 4,
        content: `### Learning Objectives
- Build modular component trees using JSX, props, and functional components.
- Understand React\'s Virtual DOM reconciliation and Fiber architecture.
- Apply immutable state updates with \`useState\` to guarantee predictable re-renders.

### Clean Component Decomposition
\`\`\`tsx
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
\`\`\`

### Key Takeaways
- Components should follow the Single Responsibility Principle: decompose monolithic screens into reusable presentation and container components.
- Never mutate state directly in React (e.g. \`items.push(x)\`); always pass new references (\`setItems([...items, x])\`).`
      },
      {
        id: 'd0000000-0000-0000-0104-000000000005',
        title: 'Client-Side State Management: Hooks, Context & Reducers',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 5,
        content: `### Learning Objectives
- Master the React Hook lifecycle: \`useEffect\`, \`useMemo\`, and \`useCallback\`.
- Manage complex multi-field state using \`useReducer\` and action dispatch patterns.
- Avoid prop-drilling by providing global state through React Context.

### State Management with useReducer & Context
\`\`\`tsx
type CartAction = 
  | { type: 'ADD_ITEM'; payload: { id: string; price: number } }
  | { type: 'REMOVE_ITEM'; payload: { id: string } }
  | { type: 'CLEAR_CART' };

interface CartState {
  items: { id: string; price: number }[];
  total: number;
}

function cartReducer(state: CartState, action: CartAction): CartState {
  switch (action.type) {
    case 'ADD_ITEM':
      return {
        items: [...state.items, action.payload],
        total: state.total + action.payload.price
      };
    case 'CLEAR_CART':
      return { items: [], total: 0 };
    default:
      return state;
  }
}
\`\`\`

### Key Takeaways
- \`useEffect\` with an empty dependency array \`[]\` runs once after the initial render; always specify all referenced values in the dependency array to avoid stale closures.
- Use \`useMemo\` and \`useCallback\` to stabilize object references passed to memoized children.`
      },
      {
        id: 'd0000000-0000-0000-0104-000000000006',
        title: 'Building RESTful APIs: Routes, Middleware & Request Lifecycle',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 6,
        content: `### Learning Objectives
- Design RESTful HTTP resource URIs adhering to HTTP method semantics (GET, POST, PUT, PATCH, DELETE).
- Structure Node.js/Express API servers with middleware pipelines.
- Implement centralized error handling, request validation, and response formatting.

### RESTful Architectural Principles
- **Idempotency**: GET, PUT, and DELETE must be idempotent (repeated identical requests yield identical server state).
- **Resource Nouns**: Use plural nouns (\`/api/courses\`, \`/api/courses/:id/lessons\`), never verbs in endpoint URIs.
- **Status Codes**: 200 (OK), 201 (Created), 204 (No Content), 400 (Bad Request), 401 (Unauthorized), 403 (Forbidden), 404 (Not Found), 500 (Server Error).

\`\`\`javascript
// Express middleware example
app.use((req, res, next) => {
  req.requestTime = new Date().toISOString();
  console.log(\`[\${req.method}] \${req.url} at \${req.requestTime}\`);
  next(); // Pass control to next handler in chain
});
\`\`\`

### Key Takeaways
- Middleware functions execute sequentially and can inspect, modify, or terminate the request-response cycle.
- Centralize error-handling middleware with \`(err, req, res, next)\` to avoid unhandled promise rejections.`
      },
      {
        id: 'd0000000-0000-0000-0104-000000000007',
        title: 'Full-Stack Integration, JWT Authentication & CORS Security',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 7,
        content: `### Learning Objectives
- Implement secure authentication using JSON Web Tokens (JWT) and HTTP-only cookies.
- Configure Cross-Origin Resource Sharing (CORS) correctly to defend against unauthorized cross-site requests.
- Protect web applications against Cross-Site Scripting (XSS) and Cross-Site Request Forgery (CSRF).

### JWT Structure & Verification
A JWT consists of three Base64URL-encoded components: \`Header.Payload.Signature\`.
- **Header**: Algorithm and token type (\`{"alg": "HS256", "typ": "JWT"}\`).
- **Payload**: Claims (\`{"sub": "usr_123", "role": "student", "exp": 1790000000}\`).
- **Signature**: \`HMACSHA256(header + "." + payload, secret)\`.

\`\`\`
Client ---POST /login---> Server (Validates credentials, signs JWT)
Client <---Set-Cookie: token; HttpOnly; Secure; SameSite=Strict--- Server
Client ---GET /protected (Cookie automatically sent)---> Server (Verifies signature)
\`\`\`

### Key Takeaways
- Store authentication tokens in **HttpOnly, Secure, SameSite=Strict** cookies to prevent XSS script access to tokens.
- CORS is a browser security mechanism, not an API security firewall; server-to-server calls bypass CORS.`
      }
    ],
    quizzes: [
      {
        id: 'd0000000-0000-0000-0204-000000000001',
        title: 'HTTP Protocol, Semantic HTML & CSS Architecture Quiz',
        description: 'Covers HTTP versioning, request lifecycle, semantic HTML5 tags, and CSS Grid/Flexbox mechanics.',
        time_limit_minutes: 15,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0304-000000000001',
            order_index: 1,
            marks: 10,
            question_text: 'What major protocol improvement did HTTP/2 introduce over HTTP/1.1 to eliminate application-layer head-of-line blocking?',
            options: [
              'Binary framing and concurrent multiplexed streams over a single TCP connection.',
              'Replacing TCP with UDP entirely.',
              'Eliminating TLS encryption requirements.',
              'Disallowing browser caching.'
            ],
            correct_option_index: 0,
            explanation: 'HTTP/2 breaks messages into independent binary frames multiplexed across bidirectional streams over a single TCP connection.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000002',
            order_index: 2,
            marks: 10,
            question_text: 'Which HTML5 semantic element is designed to represent self-contained composition intended to be independently distributable (such as a blog post)?',
            options: ['<section>', '<article>', '<div>', '<aside>'],
            correct_option_index: 1,
            explanation: 'The <article> element specifies independent, self-contained content that could be syndicated independently.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000003',
            order_index: 3,
            marks: 10,
            question_text: 'In CSS Flexbox, what property aligns items along the cross axis (perpendicular to the main flex-direction)?',
            options: ['justify-content', 'align-items', 'flex-wrap', 'order'],
            correct_option_index: 1,
            explanation: 'justify-content aligns items along the main axis; align-items aligns items along the cross axis.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000004',
            order_index: 4,
            marks: 10,
            question_text: 'What HTTP status code indicates that the server has fulfilled a request and there is no additional content to send back in the response body?',
            options: ['200 OK', '201 Created', '204 No Content', '304 Not Modified'],
            correct_option_index: 2,
            explanation: '204 No Content indicates successful completion without returning an entity-body (common for DELETE operations).'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000005',
            order_index: 5,
            marks: 10,
            question_text: 'What underlying transport layer protocol does HTTP/3 operate on top of?',
            options: ['TCP', 'QUIC over UDP', 'SCTP', 'Raw Ethernet Frames'],
            correct_option_index: 1,
            explanation: 'HTTP/3 operates over QUIC, a transport protocol built on top of UDP that provides multiplexing without TCP head-of-line blocking.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000006',
            order_index: 6,
            marks: 10,
            question_text: 'What CSS Grid property allows defining explicit named layout areas corresponding to child elements?',
            options: ['grid-template-areas', 'grid-area-names', 'grid-columns-named', 'grid-layout-map'],
            correct_option_index: 0,
            explanation: 'grid-template-areas specifies named grid areas that children assign themselves to using grid-area.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000007',
            order_index: 7,
            marks: 10,
            question_text: 'What is the function of the ETag HTTP response header?',
            options: [
              'It acts as an entity tag / hash identifier of the specific version of a resource for conditional validation (If-None-Match).',
              'It encrypts the HTML payload.',
              'It defines the expiration timestamp in GMT.',
              'It enables cross-origin resource sharing.'
            ],
            correct_option_index: 0,
            explanation: 'ETags allow clients to make conditional requests (304 Not Modified) by sending the cached ETag back in the If-None-Match header.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0204-000000000002',
        title: 'Modern JavaScript, Event Loop & Asynchronous Flow Quiz',
        description: 'Tests understanding of microtasks vs macrotasks, closures, Promises, and async/await mechanics.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0304-000000000008',
            order_index: 1,
            marks: 10,
            question_text: 'In what order will the following code log: console.log("A"); setTimeout(() => console.log("B"), 0); Promise.resolve().then(() => console.log("C")); console.log("D");?',
            options: ['A, D, C, B', 'A, B, C, D', 'A, D, B, C', 'C, A, D, B'],
            correct_option_index: 0,
            explanation: 'Synchronous code runs first (A, D). The microtask queue (Promise C) drains before macrotasks (setTimeout B), logging A, D, C, B.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000009',
            order_index: 2,
            marks: 10,
            question_text: 'What is a closure in JavaScript?',
            options: [
              'The combination of a function bundled together with references to its surrounding lexical state (lexical environment).',
              'A syntax error caused by unclosed curly brackets.',
              'A mechanism that terminates the browser event loop.',
              'A method that freezes an object to make it immutable.'
            ],
            correct_option_index: 0,
            explanation: 'A closure gives an inner function access to an outer enclosing function\'s scope even after the outer function has returned.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000010',
            order_index: 3,
            marks: 10,
            question_text: 'How does an arrow function determine the value of the "this" keyword?',
            options: [
              'It inherits "this" lexically from the enclosing scope where the arrow function was defined.',
              'It dynamically binds "this" to whatever object invoked it.',
              'It always binds "this" to the global window object.',
              'It generates a new unique "this" instance on every call.'
            ],
            correct_option_index: 0,
            explanation: 'Arrow functions do not have their own this binding; they capture this lexically from the enclosing execution context.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000011',
            order_index: 4,
            marks: 10,
            question_text: 'What Promise combinator resolves only when ALL input promises have fulfilled, or rejects immediately as soon as ANY promise rejects?',
            options: ['Promise.all()', 'Promise.race()', 'Promise.allSettled()', 'Promise.any()'],
            correct_option_index: 0,
            explanation: 'Promise.all() fails fast, rejecting immediately upon the first rejected promise, and resolves only when all promises resolve.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000012',
            order_index: 5,
            marks: 10,
            question_text: 'What keyword can only be used inside a function declared with the async keyword?',
            options: ['defer', 'await', 'yield', 'next'],
            correct_option_index: 1,
            explanation: 'The await operator pauses the execution of an async function until a Promise settles.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000013',
            order_index: 6,
            marks: 10,
            question_text: 'What does the spread operator (...) do when applied to an object: const b = { ...a, active: true }?',
            options: [
              'It performs a shallow copy of own enumerable properties from a into the new object b.',
              'It deep clones all nested sub-objects of a.',
              'It deletes the original object a.',
              'It freezes both objects.'
            ],
            correct_option_index: 0,
            explanation: 'Object spread copies own enumerable properties shallowly; nested objects remain referenced by reference.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000014',
            order_index: 7,
            marks: 10,
            question_text: 'What is the primary difference between let and var variable declarations in modern JavaScript?',
            options: [
              'let is block-scoped and cannot be redeclared in the same scope; var is function-scoped and hoisted with undefined.',
              'var can only store numbers.',
              'let cannot be modified once assigned.',
              'var is block-scoped while let is global.'
            ],
            correct_option_index: 0,
            explanation: 'let and const are block-scoped ({ ... }), avoiding the hoisting pitfalls and leakage associated with function-scoped var.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0204-000000000003',
        title: 'React Component Lifecycle, Hooks & Reconciliation Quiz',
        description: 'Examines JSX, useState, useEffect dependencies, virtual DOM reconciliation, and context.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0304-000000000015',
            order_index: 1,
            marks: 10,
            question_text: 'Why does React require stable keys on dynamic list items rendered via .map()?',
            options: [
              'To identify which items have changed, been added, or been removed during reconciliation, preserving DOM element identity.',
              'To sort the list alphabetically in CSS.',
              'To encrypt the array elements in the browser.',
              'To enforce multithreaded rendering.'
            ],
            correct_option_index: 0,
            explanation: 'Keys provide a permanent identity between virtual and real DOM elements, allowing the reconciliation diffing algorithm to reuse existing DOM nodes.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000016',
            order_index: 2,
            marks: 10,
            question_text: 'What happens when you pass a state update function to setState: setCount(prev => prev + 1)?',
            options: [
              'It queues an updater function guaranteed to receive the most up-to-date pending state value, avoiding stale closure bugs.',
              'It skips rendering and updates the DOM immediately.',
              'It turns the state variable into an observable stream.',
              'It reverts state to its initial value.'
            ],
            correct_option_index: 0,
            explanation: 'Functional state updates guarantee access to the newest state value even during batched asynchronous updates.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000017',
            order_index: 3,
            marks: 10,
            question_text: 'When does the cleanup function returned from a useEffect hook execute?',
            options: [
              'Before the component unmounts, and before re-running the effect on subsequent renders when dependencies change.',
              'Only when the browser window closes.',
              'Immediately before the return statement of the component.',
              'Only when an uncaught error is thrown.'
            ],
            correct_option_index: 0,
            explanation: 'Effect cleanup functions clean up stale side-effects (e.g. event listeners, subscriptions) before the effect re-runs and during component unmounting.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000018',
            order_index: 4,
            marks: 10,
            question_text: 'What hook is best suited for memoizing expensive calculations so they only recalculate when specific inputs change?',
            options: ['useMemo', 'useCallback', 'useRef', 'useLayoutEffect'],
            correct_option_index: 0,
            explanation: 'useMemo caches the result of a calculation between renders until one of its dependencies changes.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000019',
            order_index: 5,
            marks: 10,
            question_text: 'What is the primary difference between useRef and useState?',
            options: [
              'Mutating a ref.current value does NOT trigger a component re-render, whereas calling setState does.',
              'useRef can only store HTML DOM elements, not objects.',
              'useState values reset on every render.',
              'useRef is deprecated in React 18.'
            ],
            correct_option_index: 0,
            explanation: 'useRef returns a mutable object whose .current property persists across renders without triggering a re-render when modified.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000020',
            order_index: 6,
            marks: 10,
            question_text: 'What problem does React Context solve in large component hierarchies?',
            options: [
              'Prop-drilling (passing props down through multiple layers of intermediate components that do not need them).',
              'Slow network requests.',
              'CSS styling conflicts.',
              'Database query optimization.'
            ],
            correct_option_index: 0,
            explanation: 'Context lets components broadcast data to any child component in the subtree regardless of depth without manual prop-drilling.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000021',
            order_index: 7,
            marks: 10,
            question_text: 'What does React.memo() accomplish when wrapping a functional component?',
            options: [
              'It memoizes the rendered component output, skipping re-renders if its props have not changed (shallow comparison).',
              'It forces the component to render on every single keystroke.',
              'It turns the component into a server-only component.',
              'It moves state from the browser to local storage.'
            ],
            correct_option_index: 0,
            explanation: 'React.memo is a higher-order component that skips re-rendering if props are shallowly equal to previous props.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0204-000000000004',
        title: 'REST APIs, Authentication & Web Security Standards Quiz',
        description: 'Examines REST resource conventions, JWT mechanics, HttpOnly cookie security, CORS, and XSS defense.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0304-000000000022',
            order_index: 1,
            marks: 10,
            question_text: 'Why should JSON Web Tokens (JWTs) used for authentication be stored in HttpOnly cookies rather than localStorage?',
            options: [
              'HttpOnly cookies cannot be accessed or stolen by malicious client-side JavaScript scripts during a Cross-Site Scripting (XSS) attack.',
              'localStorage cannot store strings longer than 100 characters.',
              'HttpOnly cookies are always encrypted with RSA 4096-bit keys.',
              'Browsers block localStorage requests to backend APIs.'
            ],
            correct_option_index: 0,
            explanation: 'The HttpOnly flag forbids JavaScript from reading document.cookie, protecting authentication tokens from XSS exfiltration.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000023',
            order_index: 2,
            marks: 10,
            question_text: 'What HTTP method is considered safe and idempotent for retrieving representations of resources?',
            options: ['POST', 'GET', 'DELETE', 'PATCH'],
            correct_option_index: 1,
            explanation: 'GET is safe (causes no side effects on server resources) and idempotent (multiple identical calls produce the same result).'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000024',
            order_index: 3,
            marks: 10,
            question_text: 'What HTTP request method does a web browser send as a CORS preflight check before making a non-simple cross-origin request?',
            options: ['HEAD', 'OPTIONS', 'CHECK', 'PROPFIND'],
            correct_option_index: 1,
            explanation: 'Browsers automatically dispatch an HTTP OPTIONS request to verify that the target server permits the requested HTTP method and headers.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000025',
            order_index: 4,
            marks: 10,
            question_text: 'What are the three parts of a JSON Web Token separated by periods (.)?',
            options: [
              'Header, Payload, Signature',
              'Username, Password, Hash',
              'Domain, Origin, Expiry',
              'Issuer, Subject, Nonce'
            ],
            correct_option_index: 0,
            explanation: 'A JWT consists of Header (algorithm & token type), Payload (claims & data), and Signature (HMAC or RSA verification hash).'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000026',
            order_index: 5,
            marks: 10,
            question_text: 'What SameSite cookie attribute value guarantees that cookies are never sent in cross-site requests, providing strong CSRF protection?',
            options: ['SameSite=None', 'SameSite=Strict', 'SameSite=Lax', 'SameSite=False'],
            correct_option_index: 1,
            explanation: 'SameSite=Strict ensures the cookie is withheld on any cross-site request, eliminating Cross-Site Request Forgery vulnerabilities.'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000027',
            order_index: 6,
            marks: 10,
            question_text: 'What is the standard HTTP response status code when a client makes a request lacking valid authentication credentials?',
            options: ['401 Unauthorized', '403 Forbidden', '404 Not Found', '422 Unprocessable'],
            correct_option_index: 0,
            explanation: '401 Unauthorized indicates that the request lacks valid authentication credentials (unlike 403 Forbidden where identity is known but access is prohibited).'
          },
          {
            id: 'd0000000-0000-0000-0304-000000000028',
            order_index: 7,
            marks: 10,
            question_text: 'What vulnerability occurs when unvalidated user input is directly inserted into a web page\'s DOM, executing arbitrary JavaScript in a victim\'s browser?',
            options: [
              'Cross-Site Scripting (XSS)',
              'SQL Injection (SQLi)',
              'Denial of Service (DoS)',
              'Server-Side Request Forgery (SSRF)'
            ],
            correct_option_index: 0,
            explanation: 'Cross-Site Scripting (XSS) enables attackers to inject malicious client-side scripts into web pages viewed by other users.'
          }
        ]
      }
    ],
    assignments: [
      {
        id: 'd0000000-0000-0000-0404-000000000001',
        title: 'Project 1: Responsive E-Commerce Product Catalog with State Filtering & Cart',
        description: `### Assignment Overview
Build a high-performance, responsive e-commerce product catalog frontend in React and TypeScript. Implement dynamic category filtering, price range sorting, responsive CSS Grid layout, and cart state persistence using React Context or useReducer.

### Deliverables
1. \`src/components/\`: Modular React components (\`ProductCard\`, \`FilterSidebar\`, \`CartDrawer\`, \`Navbar\`).
2. \`src/context/CartContext.tsx\`: Cart state manager handling item additions, quantity updates, removals, and total price calculation.
3. \`src/types/index.ts\`: Type-safe interfaces for \`Product\`, \`CartItem\`, and \`FilterCriteria\`.

### Requirements & Functional Specifications
- **Responsive Layout**: Provide a mobile drawer filter and desktop multi-column CSS Grid displaying product cards.
- **Dynamic Search & Filtering**: Instant client-side filtering by category, search text, and price range sliders.
- **Cart State Machine**: Compute taxes and totals accurately; persist state across browser page refreshes via \`localStorage\`.

### Evaluation Rubric (Total: 100 Marks)
- **Component Architecture & TypeScript Typing (30 Marks)**: Clean props, reusable atomic components, and zero TypeScript \`any\` types.
- **Responsive UI/UX & CSS Grid Styling (25 Marks)**: Seamless layout adaptation across mobile (375px), tablet (768px), and desktop (1280px).
- **Cart State Management & Persistence (25 Marks)**: Accurate cart math, quantity modifications, and reliable localStorage synchronization.
- **Code Quality & Accessibility (20 Marks)**: Proper ARIA labels, semantic markup, and clean code formatting.`,
        due_date: '2026-11-30T23:59:59Z',
        max_marks: 100,
        allow_resubmission: true,
        is_published: true
      },
      {
        id: 'd0000000-0000-0000-0404-000000000002',
        title: 'Project 2: Full-Stack Task Management Service with RESTful API & JWT Auth',
        description: `### Assignment Overview
Architect an end-to-end task management web application. Build a RESTful backend API using Node.js/Express, implement JWT token authentication, and connect a React frontend for full task lifecycle management.

### Deliverables
1. \`server/\`: Backend API implementing \`/api/auth/register\`, \`/api/auth/login\`, and protected \`/api/tasks\` endpoints.
2. \`client/\`: Frontend React application featuring protected routes, task dashboard, filter tabs, and status updating.
3. \`API_DOCUMENTATION.md\`: API reference detailing HTTP endpoints, expected JSON payloads, and error status codes.

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
- **Documentation & Test Coverage (20 Marks)**: Complete API markdown reference and sample curl/Postman requests.`,
        due_date: '2026-12-15T23:59:59Z',
        max_marks: 100,
        allow_resubmission: true,
        is_published: true
      }
    ]
  }
];
