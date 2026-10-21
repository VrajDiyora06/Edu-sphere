// scripts/data_ai_emerging.js
// Courses 9-11: Artificial Intelligence Fundamentals, Machine Learning Foundations, Generative AI and Large Language Models

export const coursesAiEmerging = [
  // -------------------------------------------------------------------------
  // 9. Artificial Intelligence Fundamentals
  // -------------------------------------------------------------------------
  {
    id: 'd0000000-0000-0000-0000-000000000009',
    title: 'Artificial Intelligence Fundamentals',
    slug: 'artificial-intelligence-fundamentals',
    description: 'Foundational study of classical artificial intelligence: intelligent agents, state-space formulation, uninformed vs informed heuristic search (A*, IDA*), adversarial game playing (Minimax, Alpha-Beta pruning), constraint satisfaction problems (CSP), and propositional logic knowledge bases.',
    category: 'AI & Data Science',
    level: 'Intermediate',
    thumbnail_url: 'https://images.unsplash.com/photo-1677442136019-21780ecad995?q=80&w=800&auto=format&fit=crop',
    lessons: [
      {
        id: 'd0000000-0000-0000-0109-000000000001',
        title: 'Intelligent Agents: PEAS Characterization and State-Space Formulation',
        duration_minutes: 40,
        is_free_preview: true,
        order_index: 1,
        content: `### Learning Objectives
- Define an intelligent agent through the PEAS framework (Performance measure, Environment, Actuators, Sensors).
- Classify task environments according to observability, determinism, dynamism, discreteness, and agent multiplicity.
- Formulate real-world problems as formal state-space models: initial state, action schema, transition model, goal test, and path cost.

### PEAS Environment Taxonomy
Agents interact with environments through percept sequences and actuators:

\`\`\`
Sensors (Cameras, LIDAR, API inputs) -> Agent Function [Percept -> Action] -> Actuators (Motors, API calls)
\`\`\`

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
1. $S_0 \\in S$: Initial state.
2. $Actions(s)$: Set of legal actions executable in state $s$.
3. $Result(s, a)$: Transition model returning successor state $s'$.
4. $GoalTest(s)$: Boolean function determining if state $s$ satisfies termination criteria.
5. $c(s, a, s')$: Step cost of transitioning from state $s$ to $s'$ via action $a$.

### Key Takeaways
- Well-formulated state spaces abstract away irrelevant real-world complexities into discrete transitions.
- The nature of the environment dictates whether classical search, probabilistic planning, or reinforcement learning is the optimal agent architecture.`
      },
      {
        id: 'd0000000-0000-0000-0109-000000000002',
        title: 'Uninformed Search Strategies: BFS, DFS, and Uniform Cost Search',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 2,
        content: `### Learning Objectives
- Compare Breadth-First Search (BFS), Depth-First Search (DFS), Depth-Limited Search (DLS), and Iterative Deepening Search (IDS).
- Implement Uniform Cost Search (Dijkstra's search) for graphs with non-negative arbitrary edge costs.
- Analyze time complexity, space complexity, completeness, and optimality across branching factor $b$ and solution depth $d$.

### Search Algorithm Comparison Matrix
Let $b$ be branching factor, $d$ be depth of shallowest goal, $m$ be maximum search depth, and $C^*$ be optimal cost:

| Algorithm | Complete? | Optimal? | Time Complexity | Space Complexity | Frontier Data Structure |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **BFS** | Yes (if $b$ is finite) | Yes (if uniform step cost) | $O(b^d)$ | $O(b^d)$ (Memory bottleneck) | FIFO Queue |
| **DFS** | No (infinite spaces) | No | $O(b^m)$ | $O(b \\cdot m)$ (Linear memory) | LIFO Stack |
| **IDS** | Yes (if $b$ is finite) | Yes (if uniform step cost) | $O(b^d)$ | $O(b \\cdot d)$ (Best of BFS & DFS) | Call Stack |
| **UCS** | Yes (if $\\epsilon > 0$) | Yes | $O(b^{1 + \\lfloor C^* / \\epsilon \\rfloor})$ | $O(b^{1 + \\lfloor C^* / \\epsilon \\rfloor})$ | Min-Priority Queue |

### Uniform Cost Search Implementation
\`\`\`python
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

    return None, float('inf')
\`\`\`

### Key Takeaways
- BFS guarantees shortest path in unweighted graphs but runs out of memory for $d > 10$.
- Iterative Deepening Search (IDS) combines BFS's completeness and optimality with DFS's $O(bd)$ space efficiency.`
      },
      {
        id: 'd0000000-0000-0000-0109-000000000003',
        title: 'Heuristic Search and the A* Algorithm: Admissibility and Consistency',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 3,
        content: `### Learning Objectives
- Formulate evaluation functions $f(n) = g(n) + h(n)$ balancing path cost and estimated future cost.
- Prove the optimality of A* under tree search (admissibility) and graph search (consistency / monotonicity).
- Develop domain heuristics for 8-puzzle and grid navigation: Manhattan distance, Euclidean distance, and Pattern Databases.

### Heuristic Mathematical Properties
For A* to guarantee finding an optimal solution:
1. **Admissibility ($h(n)$ never overestimates):**
   $$0 \\le h(n) \\le h^*(n) \\quad \\forall n$$
   where $h^*(n)$ is the true shortest cost from $n$ to the nearest goal state.
2. **Consistency / Triangle Inequality:**
   $$h(n) \\le c(n, a, n') + h(n')$$
   If $h$ is consistent, $f(n)$ is non-decreasing along any path, ensuring that when node $n$ is expanded from the priority queue, the shortest path to $n$ has already been found.

\`\`\`
       n
      / \\
 c(n,n')  h(n)
    /     \\
   n' ----> Goal
     h(n')
\`\`\`

### Dominance of Heuristics
If $h_2(n) \\ge h_1(n)$ for all non-goal nodes $n$, and both are admissible, $h_2$ strictly **dominates** $h_1$. A* guided by $h_2$ expands a subset of the nodes expanded by $h_1$, saving computation.

### Key Takeaways
- Graph-search A* requires consistency to prevent re-opening closed nodes or degrading to exponential worst-case steps.
- Relaxing problem constraints (e.g., allowing tiles to slide through each other in 15-puzzle) systematically yields admissible heuristics.`
      },
      {
        id: 'd0000000-0000-0000-0109-000000000004',
        title: 'Adversarial Search: Minimax Algorithm and Alpha-Beta Pruning',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 4,
        content: `### Learning Objectives
- Model deterministic, zero-sum two-player games with perfect information (Chess, Tic-Tac-Toe, Checkers).
- Implement the recursive Minimax decision rule for maximizing and minimizing players.
- Derive Alpha-Beta pruning conditions and demonstrate order-dependent branch pruning.

### Minimax Formulation
Let $\\text{MAX}$ seek to maximize payoff and $\\text{MIN}$ seek to minimize it:
$$
\\text{Minimax}(s) = \\begin{cases}
\\text{Utility}(s) & \\text{if } \\text{Terminal}(s) \\\\
\\max_{a} \\text{Minimax}(\\text{Result}(s, a)) & \\text{if Player}(s) = \\text{MAX} \\\\
\\min_{a} \\text{Minimax}(\\text{Result}(s, a)) & \\text{if Player}(s) = \\text{MIN}
\\end{cases}
$$

### Alpha-Beta Pruning Invariants
- $\\alpha$: Highest value found so far at any choice point along the path for MAX (initially $-\\infty$).
- $\\beta$: Lowest value found so far at any choice point along the path for MIN (initially $+\\infty$).
- Prune branch whenever $\\alpha \\ge \\beta$.

\`\`\`python
def alphabeta(state, depth, alpha, beta, is_max_player):
    if depth == 0 or state.is_terminal():
        return state.evaluate_heuristic()

    if is_max_player:
        max_eval = float('-inf')
        for child in state.get_children():
            eval_score = alphabeta(child, depth - 1, alpha, beta, False)
            max_eval = max(max_eval, eval_score)
            alpha = max(alpha, eval_score)
            if beta <= alpha:
                break # Beta cutoff (prune remaining siblings)
        return max_eval
    else:
        min_eval = float('inf')
        for child in state.get_children():
            eval_score = alphabeta(child, depth - 1, alpha, beta, True)
            min_eval = min(min_eval, eval_score)
            beta = min(beta, eval_score)
            if beta <= alpha:
                break # Alpha cutoff
        return min_eval
\`\`\`

### Pruning Efficiency
- Worst-case node evaluations: $O(b^m)$ (sub-optimal move ordering).
- Ideal move ordering (best moves evaluated first): $O(b^{m/2})$, doubling the effective search depth in identical compute time.`
      },
      {
        id: 'd0000000-0000-0000-0109-000000000005',
        title: 'Constraint Satisfaction Problems (CSP): Arc Consistency and Backtracking',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 5,
        content: `### Learning Objectives
- Formalize problems as CSPs: variables $X$, domains $D$, and constraints $C$.
- Implement Backtracking search enhanced with MRV (Minimum Remaining Values) and Degree heuristics.
- Enforce inference via Arc Consistency algorithm AC-3 to prune variable domains before and during search.

### Arc Consistency (AC-3)
A directed arc $(X_i, X_j)$ is **arc-consistent** if for every value $x \\in D_i$, there exists some value $y \\in D_j$ satisfying the constraint between $X_i$ and $X_j$.

\`\`\`python
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
\`\`\`

### Variable and Value Ordering Heuristics
1. **MRV (Fail-First):** Select variable with fewest legal domain values remaining.
2. **Degree Heuristic:** Tie-breaker selecting variable involved in most constraints with unassigned variables.
3. **Least Constraining Value (LCV):** Order values to leave the maximal choices open for remaining unassigned variables.`
      },
      {
        id: 'd0000000-0000-0000-0109-000000000006',
        title: 'Knowledge Representation and Propositional Logic Inference',
        duration_minutes: 40,
        is_free_preview: false,
        order_index: 6,
        content: `### Learning Objectives
- Construct knowledge bases using propositional logic syntax and semantics.
- Transform logical sentences into Conjunctive Normal Form (CNF).
- Execute the Resolution Refutation algorithm to prove entailment ($KB \\models \\alpha \\iff KB \\land \\neg \\alpha \\vdash \\Box$).
- Implement DPLL (Davis-Putnam-Logemann-Loveland) for boolean satisfiability (SAT).

### Conjunctive Normal Form (CNF) Conversion Steps
1. Eliminate biconditionals: $\\alpha \\leftrightarrow \\beta \\equiv (\\alpha \\to \\beta) \\land (\\beta \\to \\alpha)$.
2. Eliminate implications: $\\alpha \\to \\beta \\equiv \\neg \\alpha \\lor \\beta$.
3. Move negations inwards via De Morgan's laws: $\\neg (\\alpha \\land \\beta) \\equiv \\neg \\alpha \\lor \\neg \\beta$.
4. Distribute $\\lor$ over $\\land$: $\\alpha \\lor (\\beta \\land \\gamma) \\equiv (\\alpha \\lor \\beta) \\land (\\alpha \\lor \\gamma)$.

### Resolution Rule
Given two clauses containing complementary literals:
$$
\\frac{l_1 \\lor \\dots \\lor l_i \\lor \\dots \\lor l_k, \\quad m_1 \\lor \\dots \\lor \\neg l_i \\lor \\dots \\lor m_n}{l_1 \\lor \\dots \\lor l_{i-1} \\lor l_{i+1} \\lor \\dots \\lor l_k \\lor m_1 \\lor \\dots \\lor m_{j-1} \\lor m_{j+1} \\lor \\dots \\lor m_n}
$$

### Key Takeaways
- Entailment testing via resolution refutation is complete for propositional logic.
- DPLL improves over naive truth tables by utilizing early termination, pure symbol heuristics, and unit clause propagation.`
      },
      {
        id: 'd0000000-0000-0000-0109-000000000007',
        title: 'Probabilistic Reasoning and Bayesian Networks',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 7,
        content: `### Learning Objectives
- Model uncertainty in multi-variable systems using Directed Acyclic Graphs (Bayesian Networks).
- Compute joint probability distributions using the conditional independence factorization chain rule.
- Calculate exact posterior probabilities using Variable Elimination and examine approximate sampling methods (Gibbs sampling).

### Bayesian Network Semantics
A Bayesian Network factorizes the full joint probability distribution:
$$
P(X_1, X_2, \\dots, X_n) = \\prod_{i=1}^n P(X_i \\mid \\text{Parents}(X_i))
$$

### Conditional Independence & d-Separation
Two nodes $X$ and $Y$ are conditionally independent given evidence set $E$ if all undirected paths between them are blocked:
1. **Linear / Cascade ($X \\to Z \\to Y$):** Blocked if $Z \\in E$.
2. **Divergent ($X \\leftarrow Z \\to Y$):** Blocked if $Z \\in E$.
3. **Convergent / Collider ($X \\to Z \\leftarrow Y$):** Blocked if neither $Z$ nor any of its descendants are in $E$. (Observing $Z$ activates explaining-away effect).

### Key Takeaways
- Bayesian Networks reduce exponential joint probability storage $O(2^n)$ to linear/polynomial space when node in-degrees are bounded.
- Exact inference is NP-hard in general graphs, motivating MCMC and belief propagation algorithms.`
      }
    ],
    quizzes: [
      {
        id: 'd0000000-0000-0000-0209-000000000001',
        title: 'Quiz 1: Intelligent Agents and Uninformed Search',
        passing_score: 75,
        order_index: 1,
        questions: [
          {
            id: 'd0000000-0000-0000-0309-000000000001',
            question_text: 'Which environment classification best characterizes automated stock trading?',
            options: ['Partially observable, stochastic, dynamic, continuous', 'Fully observable, deterministic, static, discrete', 'Partially observable, deterministic, static, discrete', 'Fully observable, stochastic, dynamic, episodic'],
            correct_option_index: 0,
            explanation: 'Financial markets involve hidden insider states (partially observable), unpredictable external events (stochastic), time-dependent price changes while deciding (dynamic), and real-valued capital/pricing states (continuous).'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000002',
            question_text: 'What is the principal disadvantage of Breadth-First Search (BFS) compared to Depth-First Search (DFS)?',
            options: ['BFS cannot find the optimal solution in unweighted graphs', 'BFS memory requirement scales exponentially as O(b^d)', 'BFS gets trapped in infinite depth loops', 'BFS has higher asymptotic time complexity than DFS in finite trees'],
            correct_option_index: 1,
            explanation: 'BFS retains the entire frontier at depth d in memory, requiring O(b^d) space. In contrast, DFS requires only O(bm) linear space.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000003',
            question_text: 'When is Uniform Cost Search (UCS) mathematically guaranteed to be complete and optimal?',
            options: ['Only if all edge costs are strictly equal to 1', 'When all edge costs are non-negative and bounded below by a positive epsilon', 'When the graph contains no cycles', 'Only when guided by an admissible heuristic function'],
            correct_option_index: 1,
            explanation: 'UCS requires step costs to satisfy c(s, a, s\') >= eps > 0 to guarantee that paths with infinite steps cannot accumulate finite total costs.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000004',
            question_text: 'What makes Iterative Deepening Search (IDS) desirable for large state spaces with unknown goal depth?',
            options: ['It computes heuristic estimates automatically', 'It uses O(1) constant working memory', 'It combines BFS completeness and shallow-path optimality with DFS linear space O(bd)', 'It eliminates the need to visit intermediate states more than once'],
            correct_option_index: 2,
            explanation: 'IDS runs successive depth-limited searches. It achieves optimal path discovery in uniform step cost graphs while keeping memory bounded to O(bd).'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000005',
            question_text: 'In a search tree with branching factor b=4 and goal at depth d=3, how many nodes does BFS store in the frontier at maximum in the worst case?',
            options: ['12', '16', '64', '256'],
            correct_option_index: 2,
            explanation: 'At depth d=3, the number of leaf nodes in the frontier is b^d = 4^3 = 64 nodes.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000006',
            question_text: 'Which node in the frontier does Uniform Cost Search expand next?',
            options: ['The node with the smallest cumulative cost g(n) from the start state', 'The node with the largest number of children', 'The most recently inserted node into the queue', 'The node with the lowest estimated remaining cost h(n)'],
            correct_option_index: 0,
            explanation: 'UCS selects the frontier node with minimum cumulative path cost g(n) using a min-priority queue.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000007',
            question_text: 'Why does Depth-First Graph Search maintain an explored set?',
            options: ['To guarantee finding the optimal cost path', 'To prevent infinite loops caused by cyclic paths in graphs', 'To sort nodes by heuristic value', 'To eliminate the need for a recursion stack'],
            correct_option_index: 1,
            explanation: 'In cyclic graphs, DFS can cycle indefinitely between previously visited states unless an explored set or cycle-checking filter is applied.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0209-000000000002',
        title: 'Quiz 2: Informed Search and A* Algorithm',
        passing_score: 75,
        order_index: 2,
        questions: [
          {
            id: 'd0000000-0000-0000-0309-000000000008',
            question_text: 'What condition defines an admissible heuristic h(n)?',
            options: ['h(n) >= h*(n) for all nodes n', '0 <= h(n) <= h*(n) where h*(n) is the true optimal cost to goal', 'h(n) is strictly monotonically increasing along every edge', 'h(n) equals 0 for all non-goal states'],
            correct_option_index: 1,
            explanation: 'An admissible heuristic never overestimates the true remaining distance or cost to reach the nearest goal.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000009',
            question_text: 'What mathematical property ensures A* graph search finds the optimal path without re-expanding closed nodes?',
            options: ['Completeness', 'Admissibility alone', 'Consistency (Monotonicity): h(n) <= c(n, a, n\') + h(n\')', 'Strict convexity of the evaluation function f(n)'],
            correct_option_index: 2,
            explanation: 'Consistency enforces the triangle inequality on heuristics. It guarantees that f(n) is non-decreasing along paths, so the first time a node is popped from the frontier, its optimal g(n) is finalized.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000010',
            question_text: 'If heuristic h2 dominates h1 (both are admissible and h2(n) >= h1(n) for all n), what is true?',
            options: ['A* with h1 will expand fewer or equal nodes compared to h2', 'A* with h2 will expand a subset of the nodes expanded by A* with h1', 'h2 is inadmissible because its values are larger', 'h2 requires exponential memory compared to h1'],
            correct_option_index: 1,
            explanation: 'A higher admissible estimate is closer to the true cost h*(n), pruning more search space and never expanding more nodes than the weaker heuristic.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000011',
            question_text: 'What does A* evaluation function f(n) represent?',
            options: ['The total cost from the start node to the current node g(n)', 'The heuristic estimate to the nearest obstacle', 'The estimated total cost of the cheapest solution path through node n: f(n) = g(n) + h(n)', 'The probability that node n leads to a terminal failure'],
            correct_option_index: 2,
            explanation: 'f(n) estimates the total cost of the full path from start to goal passing through node n: f(n) = g(n) + h(n).'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000012',
            question_text: 'For 2D grid navigation with 4-directional movement (up, down, left, right), which heuristic is standard and admissible?',
            options: ['Euclidean distance', 'Manhattan distance', 'Chebyshev distance', 'Squared Euclidean distance'],
            correct_option_index: 1,
            explanation: 'In 4-connected grid navigation, Manhattan distance |x1-x2| + |y1-y2| represents the exact shortest distance without obstacles, making it admissible and consistent.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000013',
            question_text: 'If an A* heuristic is defined as h(n) = 0 for all nodes, what standard algorithm does A* reduce to?',
            options: ['Depth-First Search', 'Greedy Best-First Search', 'Uniform Cost Search (Dijkstra\'s algorithm)', 'Iterative Deepening Search'],
            correct_option_index: 2,
            explanation: 'When h(n) = 0, f(n) = g(n) + 0 = g(n), meaning nodes are ordered strictly by cumulative path cost g(n), which is Uniform Cost Search.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000014',
            question_text: 'What occurs if Greedy Best-First Search is used (f(n) = h(n))?',
            options: ['It guarantees the shortest cost path to the goal', 'It is incomplete in cyclic graphs and can be led astray by misleading heuristic values', 'It behaves identically to Breadth-First Search', 'It always explores fewer nodes than optimal A*'],
            correct_option_index: 1,
            explanation: 'Greedy Best-First Search ignores cumulative cost g(n), evaluating only h(n). It can chase deep false paths and is neither optimal nor complete on graphs without cycle checking.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0209-000000000003',
        title: 'Quiz 3: Game Playing and Adversarial Search',
        passing_score: 75,
        order_index: 3,
        questions: [
          {
            id: 'd0000000-0000-0000-0309-000000000015',
            question_text: 'In the Minimax algorithm with Alpha-Beta pruning, when does a beta cutoff occur during MAX node evaluation?',
            options: ['When alpha exceeds beta (alpha >= beta)', 'When beta reaches positive infinity', 'When utility is zero', 'When the search depth is an even number'],
            correct_option_index: 0,
            explanation: 'A cutoff occurs whenever alpha >= beta because the MIN player at a higher parent choice has already secured a path resulting in <= beta, and MAX will never permit a score >= alpha to be chosen.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000016',
            question_text: 'With perfect move ordering, what is the effective time complexity of Alpha-Beta pruning to depth m with branching factor b?',
            options: ['O(b^m)', 'O(b^(m/2))', 'O(m * log(b))', 'O(b * m)'],
            correct_option_index: 1,
            explanation: 'Under optimal move ordering (best moves inspected first), Alpha-Beta evaluates O(b^(m/2)) leaf nodes, effectively doubling the search depth compared to basic Minimax.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000017',
            question_text: 'What is the horizon effect in heuristic game tree search?',
            options: ['The game board dimensions changing dynamically', 'An unavoidable catastrophic move being delayed just beyond the fixed search depth limit', 'The evaluation function assigning identical scores to all leaves', 'Alpha and beta values becoming equal at the root'],
            correct_option_index: 1,
            explanation: 'The horizon effect occurs when a fixed-depth search pushes a serious negative event just beyond the search horizon through stalling moves, giving a false impression of safety.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000018',
            question_text: 'How does Quiescence Search address tactical instability at leaf nodes?',
            options: ['By restarting the game from the initial state', 'By continuing search beyond depth limit only for non-quiet positions (e.g. captures/checks)', 'By randomly sampling terminal rollouts', 'By pruning branches where evaluation changes sign'],
            correct_option_index: 1,
            explanation: 'Quiescence search expands captures and volatile moves until a quiet position is reached, avoiding misleading evaluations in the middle of piece exchanges.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000019',
            question_text: 'What mathematical property characterizes a zero-sum two-player game?',
            options: ['Both players receive equal positive rewards at the end', 'Utility(Player1) + Utility(Player2) = 0 (or a constant)', 'No player can ever lose points', 'The game cannot terminate in a draw'],
            correct_option_index: 1,
            explanation: 'In zero-sum games, any advantage or payoff gained by one player represents an equal loss for the opposing player.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000020',
            question_text: 'What are the initial values passed to alpha and beta at the root of a Minimax search?',
            options: ['alpha = 0, beta = 0', 'alpha = +infinity, beta = -infinity', 'alpha = -infinity, beta = +infinity', 'alpha = -1, beta = 1'],
            correct_option_index: 2,
            explanation: 'At the root, MAX has guaranteed at least -infinity (alpha), and MIN has guaranteed at most +infinity (beta).'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000021',
            question_text: 'Why does Transposition Table caching significantly improve game tree search performance?',
            options: ['It changes the game rules to reduce branching factor', 'Different sequences of moves often reach identical board configurations (transpositions)', 'It eliminates the need for terminal state checks', 'It replaces Minimax with linear programming'],
            correct_option_index: 1,
            explanation: 'Transposition tables store evaluations of previously visited board states reached via different permutations of move orders, preventing duplicate subtree searches.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0209-000000000004',
        title: 'Quiz 4: CSPs, Logic, and Bayesian Networks',
        passing_score: 75,
        order_index: 4,
        questions: [
          {
            id: 'd0000000-0000-0000-0309-000000000022',
            question_text: 'What does the Minimum Remaining Values (MRV) heuristic choose in backtracking CSP search?',
            options: ['The value that constrains the fewest neighbors', 'The unassigned variable with the fewest allowable values in its domain', 'The variable with the highest degree in the constraint graph', 'The variable that was most recently backtracked'],
            correct_option_index: 1,
            explanation: 'MRV picks the most constrained variable (fewest remaining legal values), failing early if no valid assignment is possible.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000023',
            question_text: 'In the AC-3 arc consistency algorithm, when is an arc (Xi, Xj) revised?',
            options: ['By removing values from Xi\'s domain that have no supporting value in Xj', 'By setting Xi equal to Xj', 'By sorting domains in lexicographical order', 'By pruning all variables connected to Xj'],
            correct_option_index: 0,
            explanation: 'Revise(Xi, Xj) eliminates any value x in Di for which no value y in Dj satisfies the binary constraint between Xi and Xj.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000024',
            question_text: 'What is the logical resolution rule equivalent to in refutation proofs?',
            options: ['Proving KB |= alpha by demonstrating that KB and not(alpha) derives a contradiction (empty clause)', 'Checking if truth table has all true values', 'Factoring sentences into disjunctive normal form', 'Converting first-order logic into Horn clauses'],
            correct_option_index: 0,
            explanation: 'Resolution refutation assumes the negation of the query sentence and repeatedly applies resolution until an empty clause (contradiction) is derived.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000025',
            question_text: 'In a Bayesian Network, how is the joint probability distribution P(X1, ..., Xn) factorized?',
            options: ['Sum of all marginal probabilities', 'Product of P(Xi | Parents(Xi)) for all i from 1 to n', 'Product of all unconditional independent probabilities', 'Ratio of evidence over prior priors'],
            correct_option_index: 1,
            explanation: 'By applying conditional independence assertions of the DAG, P(X1, ..., Xn) = product_{i=1}^n P(Xi | Parents(Xi)).'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000026',
            question_text: 'In a collider network structure (X -> Z <- Y), what happens to the relationship between X and Y when Z (or a descendant of Z) is observed?',
            options: ['X and Y become conditionally independent', 'X and Y become dependent (explaining away phenomenon)', 'The conditional probability of Z becomes 0', 'The direction of the arrows reverses'],
            correct_option_index: 1,
            explanation: 'Unlike chain or fork structures, in a collider (v-structure), observing the common effect Z renders the previously independent causes X and Y conditionally dependent.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000027',
            question_text: 'What is a Horn clause in propositional logic?',
            options: ['A clause with at most one positive (unnegated) literal', 'A sentence with exactly two biconditionals', 'A clause where all literals are negated', 'A formula containing existential quantifiers'],
            correct_option_index: 0,
            explanation: 'A Horn clause contains at most one positive literal (e.g. not(A) or not(B) or C, equivalent to A and B -> C), permitting linear-time forward and backward chaining inference.'
          },
          {
            id: 'd0000000-0000-0000-0309-000000000028',
            question_text: 'Which heuristic helps choose the order of values to assign to a variable in CSP search?',
            options: ['Minimum Remaining Values (MRV)', 'Degree Heuristic', 'Least Constraining Value (LCV)', 'Depth-First Heuristic'],
            correct_option_index: 2,
            explanation: 'Once a variable is selected, Least Constraining Value orders its domain values by which value rules out the fewest choices for neighboring variables.'
          }
        ]
      }
    ],
    assignments: [
      {
        id: 'd0000000-0000-0000-0409-000000000001',
        title: 'Assignment 1: Classical State-Space Search & A* 8-Puzzle Solver',
        description: `Implement and evaluate search algorithms to solve the 8-puzzle sliding tile problem:
1. Formulate the 8-puzzle as a state-space search problem: define state representation (tuple of 9 integers), action set {UP, DOWN, LEFT, RIGHT}, transition function, and goal test.
2. Implement Breadth-First Search (BFS) and Uniform Cost Search (UCS) with an explored set to detect and avoid duplicate states.
3. Implement A* search with two distinct heuristics:
   - Heuristic 1: Misplaced Tiles count $h_1(s)$.
   - Heuristic 2: Manhattan Distance sum $h_2(s) = \\sum |x_i - x_i^*| + |y_i - y_i^*|$.
4. Benchmark across 50 randomly generated solvable initial states categorized by optimal solution depth ($d = 5, 10, 15, 20$). Compare:
   - Total nodes expanded.
   - Maximum frontier size stored in memory.
   - Wall-clock execution time.
   - Optimality of solution path length.
5. Provide a technical report documenting proof of admissibility and consistency for $h_2$, along with comparative performance tables.`,
        due_date: '2026-11-20T23:59:59Z',
        rubric: [
          { criterion: 'State Representation & Validity Checks', max_points: 20, description: 'Correct tuple representation, parity/solvability inversion checker, legal move transitions.' },
          { criterion: 'Uninformed Search Implementation', max_points: 25, description: 'Correct BFS and UCS implementations handling cycles and returning optimal paths.' },
          { criterion: 'A* & Heuristic Design', max_points: 30, description: 'Accurate implementation of misplaced tiles and Manhattan distance with proper priority queue updates.' },
          { criterion: 'Empirical Benchmark & Analysis', max_points: 25, description: 'Rigorous benchmark table comparing nodes expanded, memory footprint, runtime, and admissibility proofs.' }
        ]
      },
      {
        id: 'd0000000-0000-0000-0409-000000000002',
        title: 'Assignment 2: Adversarial Minimax with Alpha-Beta Pruning for Connect-Four',
        description: `Build an adversarial game-playing engine for Connect-Four (6 rows x 7 columns grid):
1. Represent the game board using bitboards or 2D arrays, with fast move execution and horizontal, vertical, and diagonal win detection.
2. Implement recursive Minimax search with variable depth limits.
3. Implement Alpha-Beta pruning with move ordering heuristics (e.g. evaluating center column moves before outer columns).
4. Construct an evaluation heuristic function for non-terminal leaf positions that rewards:
   - Three-in-a-row with open ends.
   - Center column control.
   - Threat configurations (forcing opponent defensive moves).
5. Add a Transposition Table using Zobrist hashing to cache previously evaluated board configurations with depth, score, and flag (EXACT, LOWERBOUND, UPPERBOUND).
6. Implement an automated tournament pitting depth-4 basic Minimax against depth-6 Alpha-Beta with move ordering, measuring search nodes evaluated and win rates.`,
        due_date: '2026-11-28T23:59:59Z',
        rubric: [
          { criterion: 'Game Engine & Win Detection', max_points: 20, description: 'Accurate rule enforcement, boundary conditions, and win/draw evaluations.' },
          { criterion: 'Minimax & Alpha-Beta Cutoffs', max_points: 30, description: 'Correct recursive implementation of alpha-beta pruning returning identical decisions to full Minimax.' },
          { criterion: 'Evaluation Heuristic Quality', max_points: 25, description: 'Domain-specific heuristic evaluating piece alignments, center control, and tactical threats.' },
          { criterion: 'Transposition Tables & Optimization', max_points: 25, description: 'Zobrist hash table implementation, move ordering impact, and empirical node-pruning evaluation.' }
        ]
      }
    ]
  },

  // -------------------------------------------------------------------------
  // 10. Machine Learning Foundations
  // -------------------------------------------------------------------------
  {
    id: 'd0000000-0000-0000-0000-000000000010',
    title: 'Machine Learning Foundations',
    slug: 'machine-learning-foundations',
    description: 'Rigorous introduction to statistical machine learning: supervised learning, linear and logistic regression, gradient descent optimization, bias-variance tradeoff, regularization (L1/L2), decision trees, ensemble methods (Random Forests, Gradient Boosting), SVMs, unsupervised clustering (K-Means, GMM), and PCA dimensionality reduction.',
    category: 'AI & Data Science',
    level: 'Intermediate',
    thumbnail_url: 'https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?q=80&w=800&auto=format&fit=crop',
    lessons: [
      {
        id: 'd0000000-0000-0000-0110-000000000001',
        title: 'Supervised Learning Setup: Loss Functions, Empirical Risk, and Optimization',
        duration_minutes: 45,
        is_free_preview: true,
        order_index: 1,
        content: `### Learning Objectives
- Formulate supervised learning tasks as Empirical Risk Minimization (ERM) problems.
- Distinguish convex from non-convex loss functions for regression (MSE, MAE, Huber) and classification (Cross-Entropy, Hinge).
- Derive Batch Gradient Descent (BGD), Stochastic Gradient Descent (SGD), and Mini-batch Gradient Descent update rules.

### Mathematical Framework
Given dataset $\\mathcal{D} = \\{(x_i, y_i)\\}_{i=1}^N$ with $x_i \\in \\mathbb{R}^D$ and $y_i \\in \\mathcal{Y}$:
$$
\\min_{\\theta} \\mathcal{R}_{emp}(\\theta) = \\frac{1}{N} \\sum_{i=1}^N \\mathcal{L}(f(x_i; \\theta), y_i)
$$

### Gradient Descent Variants
\`\`\`
Batch GD:      \\theta_{t+1} = \\theta_t - \\eta \\cdot \\frac{1}{N} \\sum_{i=1}^N \\nabla_\\theta \\mathcal{L}(f(x_i; \\theta_t), y_i)
Stochastic GD: \\theta_{t+1} = \\theta_t - \\eta \\cdot \\nabla_\\theta \\mathcal{L}(f(x_i; \\theta_t), y_i) \\quad (i \\sim \\text{Uniform}(1, N))
Mini-batch:    \\theta_{t+1} = \\theta_t - \\eta \\cdot \\frac{1}{|B|} \\sum_{i \\in B} \\nabla_\\theta \\mathcal{L}(f(x_i; \\theta_t), y_i)
\`\`\`

### Common Loss Functions
1. **Mean Squared Error (L2 Loss):** $\\mathcal{L}(\\hat{y}, y) = \\frac{1}{2}(\\hat{y} - y)^2$. Penalizes large outliers heavily.
2. **Mean Absolute Error (L1 Loss):** $\\mathcal{L}(\\hat{y}, y) = |\\hat{y} - y|$. Robust to outliers, non-differentiable at $\\hat{y} = y$.
3. **Binary Cross-Entropy (Logistic Loss):** $\\mathcal{L}(\\hat{y}, y) = - [y \\log \\hat{y} + (1 - y) \\log(1 - \\hat{y})]$. Convex for linear models.`
      },
      {
        id: 'd0000000-0000-0000-0110-000000000002',
        title: 'Linear and Logistic Regression: Closed-Form Normal Equation vs Iterative Solvers',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 2,
        content: `### Learning Objectives
- Derive the Ordinary Least Squares (OLS) closed-form Normal Equation: $\\theta^* = (X^T X)^{-1} X^T y$.
- Formulate binary classification via the sigmoid logistic link function: $\\sigma(z) = \\frac{1}{1 + e^{-z}}$.
- Compute gradients of the negative log-likelihood loss for logistic regression.

### OLS Normal Equation Derivation
Let design matrix $X \\in \\mathbb{R}^{N \\times D}$ and target vector $y \\in \\mathbb{R}^N$.
$$
J(\\theta) = \\frac{1}{2N} \\|X\\theta - y\\|^2 = \\frac{1}{2N} (X\\theta - y)^T (X\\theta - y)
$$
Setting the gradient with respect to $\\theta$ to zero:
$$
\\nabla_\\theta J(\\theta) = \\frac{1}{N} X^T (X\\theta - y) = 0 \\implies X^T X \\theta = X^T y
$$
$$
\\theta^* = (X^T X)^{-1} X^T y
$$

### Logistic Regression Update Rule
Predict probability $P(y=1 \\mid x) = \\sigma(\\theta^T x) = \\frac{1}{1 + e^{-\\theta^T x}}$.
The gradient of the cross-entropy cost has the identical mathematical form to linear regression:
$$
\\nabla_\\theta J(\\theta) = \\frac{1}{N} \\sum_{i=1}^N (\\sigma(\\theta^T x_i) - y_i) x_i
$$

### Key Takeaways
- The Normal Equation computes exact solutions in $O(D^3)$ time without learning rate tuning, but becomes computationally prohibitive when $D > 10^4$.
- Gradient descent scales to arbitrary feature dimensions and non-linear extensions.`
      },
      {
        id: 'd0000000-0000-0000-0110-000000000003',
        title: 'Generalization, Bias-Variance Tradeoff, and Regularization (L1 / L2)',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 3,
        content: `### Learning Objectives
- Decompose expected prediction error into irreducible noise, bias squared, and variance.
- Diagnose underfitting (high bias) vs overfitting (high variance) using training and validation learning curves.
- Implement Ridge ($L_2$) and Lasso ($L_1$) regularization to constrain parameter complexity.

### Bias-Variance Decomposition
For true data generating process $y = f(x) + \\epsilon$ with noise $\\mathbb{E}[\\epsilon] = 0, \\text{Var}(\\epsilon) = \\sigma^2$:
$$
\\mathbb{E}\\left[(y - \\hat{f}(x))^2\\right] = \\underbrace{\\left(\\mathbb{E}[\\hat{f}(x)] - f(x)\\right)^2}_{\\text{Bias}^2} + \\underbrace{\\mathbb{E}\\left[(\\hat{f}(x) - \\mathbb{E}[\\hat{f}(x)])^2\\right]}_{\\text{Variance}} + \\underbrace{\\sigma^2}_{\\text{Irreducible Noise}}
$$

### Regularization Formulations
1. **Ridge Regression ($L_2$ Penalty):**
   $$J_{Ridge}(\\theta) = \\text{MSE}(\\theta) + \\lambda \\sum_{j=1}^D \\theta_j^2$$
   - Analytical solution: $\\theta^* = (X^T X + \\lambda I)^{-1} X^T y$.
   - Shrinks weights continuously toward zero; guarantees invertibility of $X^T X$.
2. **Lasso Regression ($L_1$ Penalty):**
   $$J_{Lasso}(\\theta) = \\text{MSE}(\\theta) + \\lambda \\sum_{j=1}^D |\\theta_j|$$
   - Produces sparse weight vectors by driving non-informative coefficients exactly to zero (automated feature selection).`
      },
      {
        id: 'd0000000-0000-0000-0110-000000000004',
        title: 'Decision Trees and Splitting Criteria: ID3, C4.5, and CART',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 4,
        content: `### Learning Objectives
- Construct decision trees recursively using greedy top-down induction.
- Compute Information Gain using Shannon Entropy vs Gini Impurity for node splitting.
- Apply pre-pruning (max depth, min samples split) and cost-complexity post-pruning to mitigate overfitting.

### Splitting Impurity Metrics
Given a node with $K$ classes and class proportions $p_k$:
1. **Shannon Entropy:**
   $$H(S) = - \\sum_{k=1}^K p_k \\log_2(p_k)$$
2. **Gini Impurity (CART default):**
   $$\\text{Gini}(S) = 1 - \\sum_{k=1}^K p_k^2$$
3. **Information Gain (IG):**
   $$\\text{IG}(S, A) = H(S) - \\sum_{v \\in \\text{Values}(A)} \\frac{|S_v|}{|S|} H(S_v)$$

\`\`\`python
import numpy as np

def gini_impurity(y):
    classes, counts = np.unique(y, return_counts=True)
    probabilities = counts / len(y)
    return 1.0 - np.sum(probabilities ** 2)

def information_gain(y_parent, y_left, y_right):
    p_left = len(y_left) / len(y_parent)
    p_right = len(y_right) / len(y_parent)
    return gini_impurity(y_parent) - (p_left * gini_impurity(y_left) + p_right * gini_impurity(y_right))
\`\`\`

### Key Takeaways
- Decision trees are non-parametric, scale-invariant to feature monotonic transformations, and naturally interpretable.
- Unpruned trees have high variance and memorize noisy training samples.`
      },
      {
        id: 'd0000000-0000-0000-0110-000000000005',
        title: 'Ensemble Learning: Bagging, Random Forests, and Gradient Boosting (XGBoost)',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 5,
        content: `### Learning Objectives
- Contrast variance-reduction via Bootstrap Aggregating (Bagging) with bias-reduction via Boosting.
- Analyze Random Forests: feature subspace sampling and out-of-bag (OOB) error estimation.
- Trace Gradient Boosted Decision Trees (GBDT): fitting pseudo-residuals sequentially.

### Bagging vs Boosting
| Dimension | Random Forests (Bagging) | Gradient Boosting (Boosting) |
| :--- | :--- | :--- |
| Primary Goal | Reduce Variance | Reduce Bias |
| Base Learners | Deep, fully grown, unpruned trees | Shallow, weak learners (stumps, depth 3-6) |
| Model Training | Parallel independent bootstrap samples | Sequential (each tree corrects residual errors of prior sum) |
| Feature Sampling | $\\sqrt{D}$ random features considered at each split | Feature and instance subsampling per boosting round |

### Gradient Boosting Mathematical Principle
Let $F_0(x) = \\arg\\min_c \\sum_{i=1}^N \\mathcal{L}(y_i, c)$. At iteration $m$:
1. Compute negative gradient (pseudo-residuals):
   $$r_{im} = -\\left[ \\frac{\\partial \\mathcal{L}(y_i, F(x_i))}{\\partial F(x_i)} \\right]_{F(x) = F_{m-1}(x)}$$
2. Train regression tree $h_m(x)$ to predict targets $r_{im}$.
3. Update ensemble with shrinkage learning rate $\\eta \\in (0, 1]$:
   $$F_m(x) = F_{m-1}(x) + \\eta \\cdot h_m(x)$$`
      },
      {
        id: 'd0000000-0000-0000-0110-000000000006',
        title: 'Support Vector Machines: Maximum Margin Hyperplanes and Kernel Trick',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 6,
        content: `### Learning Objectives
- Derive the hard-margin and soft-margin Support Vector Machine quadratic programming formulations.
- Interpret slack variables $\\xi_i$ and the regularization tradeoff parameter $C$.
- Apply the Kernel Trick to project non-linearly separable inputs into high-dimensional Hilbert spaces.

### Primal Soft-Margin SVM Formulation
Find weight vector $w \\in \\mathbb{R}^D$ and bias $b \\in \\mathbb{R}$:
$$
\\min_{w, b, \\xi} \\frac{1}{2} \\|w\\|^2 + C \\sum_{i=1}^N \\xi_i \\quad \\text{s.t.} \\quad y_i(w^T x_i + b) \\ge 1 - \\xi_i, \\quad \\xi_i \\ge 0
$$

### The Kernel Trick
Mercer's Theorem allows computing inner products $\\langle \\phi(x), \\phi(z) \\rangle$ in high-dimensional feature space directly via kernel function $K(x, z)$ without explicitly mapping coordinates:
1. **Radial Basis Function (RBF / Gaussian):**
   $$K(x, z) = \\exp\\left( -\\gamma \\|x - z\\|^2 \\right)$$
2. **Polynomial Kernel:**
   $$K(x, z) = (x^T z + c)^d$$

### Key Takeaways
- SVM predictions depend exclusively on the subset of training data points lying on or inside the margin boundary (support vectors).
- High $C$ penalizes misclassifications strictly (lower bias, higher variance); low $C$ allows larger margins with more slack violations.`
      },
      {
        id: 'd0000000-0000-0000-0110-000000000007',
        title: 'Unsupervised Learning: K-Means, Gaussian Mixture Models, and PCA',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 7,
        content: `### Learning Objectives
- Implement K-Means clustering and evaluate cluster inertia using the Elbow method and Silhouette score.
- Formulate soft clustering with Gaussian Mixture Models (GMM) via Expectation-Maximization (EM).
- Derive Principal Component Analysis (PCA) via eigendecomposition of the empirical covariance matrix.

### K-Means Clustering Algorithm
1. Initialize $K$ cluster centroids $\\{\\mu_1, \\dots, \\mu_K\\}$ (using K-Means++ to maximize initial spread).
2. **Assignment Step:** Assign each sample to the nearest centroid:
   $$c_i = \\arg\\min_k \\|x_i - \\mu_k\\|^2$$
3. **Update Step:** Recalculate centroids as the mean of assigned vectors:
   $$\\mu_k = \\frac{1}{|S_k|} \\sum_{i \\in S_k} x_i$$
4. Repeat until centroid convergence $\\|\\Delta \\mu\\| < \\epsilon$.

### Principal Component Analysis (PCA)
To project data from dimension $D$ to $k < D$ while maximizing preserved variance:
1. Mean-center data matrix $\\tilde{X} = X - \\bar{X}$.
2. Compute sample covariance matrix $\\Sigma = \\frac{1}{N} \\tilde{X}^T \\tilde{X}$.
3. Calculate eigenvalues and eigenvectors: $\\Sigma v_i = \\lambda_i v_i$.
4. Sort eigenvectors in descending order of eigenvalues $\\lambda_1 \\ge \\lambda_2 \\dots \\ge \\lambda_D$.
5. Construct projection matrix $W = [v_1, v_2, \\dots, v_k]$ and transform: $Z = \\tilde{X} W$.`
      }
    ],
    quizzes: [
      {
        id: 'd0000000-0000-0000-0210-000000000001',
        title: 'Quiz 1: Supervised Learning, Loss Functions, and Optimization',
        passing_score: 75,
        order_index: 1,
        questions: [
          {
            id: 'd0000000-0000-0000-0310-000000000001',
            question_text: 'What is the primary computational disadvantage of Batch Gradient Descent compared to Mini-batch SGD on large datasets?',
            options: ['Batch GD gradients have high stochastic variance', 'Batch GD requires processing the entire dataset to compute a single parameter update', 'Batch GD cannot be used with convex loss functions', 'Batch GD requires a different learning rate for every single feature'],
            correct_option_index: 1,
            explanation: 'Batch Gradient Descent computes gradients across all N training samples per step, making each parameter update slow and memory-intensive for large datasets.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000002',
            question_text: 'Which loss function is most robust to extreme outliers in regression tasks?',
            options: ['Mean Squared Error (L2 Loss)', 'Mean Absolute Error (L1 Loss)', 'Categorical Cross-Entropy', 'Hinge Loss'],
            correct_option_index: 1,
            explanation: 'L1 loss grows linearly with error magnitude |y - y_hat|, whereas L2 error squares the difference, heavily magnifying the influence of large outliers on the gradient.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000003',
            question_text: 'What occurs if the learning rate eta in gradient descent is chosen excessively large?',
            options: ['The model converges instantaneously to the global minimum', 'Parameter updates oscillate wildly and may diverge to infinity', 'The model behaves identically to stochastic gradient descent', 'Weights automatically shrink to zero'],
            correct_option_index: 1,
            explanation: 'An overly large learning rate causes step sizes to overshoot the valleys of the loss surface, oscillating and diverging.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000004',
            question_text: 'What is the range of output values produced by the logistic sigmoid activation function sigma(z)?',
            options: ['[-1, 1]', '[0, 1]', '(-infinity, +infinity)', '[0, +infinity)'],
            correct_option_index: 1,
            explanation: 'The sigmoid function sigma(z) = 1 / (1 + exp(-z)) maps any real input to the open interval (0, 1), representing valid probabilities.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000005',
            question_text: 'In linear regression, what mathematical condition prevents computing the Normal Equation solution theta = (X^T X)^(-1) X^T y?',
            options: ['When N > D', 'When feature columns in X are linearly dependent (causing X^T X to be non-invertible / singular)', 'When all targets y are strictly positive', 'When the loss function is convex'],
            correct_option_index: 1,
            explanation: 'If features are collinear or D > N, matrix X^T X is rank-deficient and singular, meaning its determinant is zero and its inverse does not exist.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000006',
            question_text: 'What optimization technique adaptively maintains exponentially decaying moving averages of past gradients and squared gradients?',
            options: ['Standard SGD', 'Newton-Raphson Method', 'Adam (Adaptive Moment Estimation)', 'Coordinate Descent'],
            correct_option_index: 2,
            explanation: 'Adam computes individual adaptive learning rates for different parameters from estimates of first and second raw moments of gradients.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000007',
            question_text: 'What happens when features are not scaled before running gradient descent on linear regression?',
            options: ['The loss surface becomes highly elongated (elliptical), slowing convergence due to zig-zagging gradients', 'The loss function becomes non-convex', 'The model cannot make predictions on test data', 'The Normal Equation becomes inaccurate'],
            correct_option_index: 0,
            explanation: 'Unscaled features produce distorted, eccentric loss contours where gradients point perpendicular to the direction of the minimum, requiring smaller learning rates and more iterations.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0210-000000000002',
        title: 'Quiz 2: Bias-Variance Tradeoff and Regularization',
        passing_score: 75,
        order_index: 2,
        questions: [
          {
            id: 'd0000000-0000-0000-0310-000000000008',
            question_text: 'A model has very low training error (0.5%) but high test error (24.0%). What problem does this indicate?',
            options: ['High bias (underfitting)', 'High variance (overfitting)', 'High irreducible noise', 'Zero generalization gap'],
            correct_option_index: 1,
            explanation: 'A large disparity between excellent training performance and poor test performance characterizes high variance (overfitting), where the model memorizes sample-specific noise.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000009',
            question_text: 'What is the distinguishing property of Lasso (L1) regularization compared to Ridge (L2)?',
            options: ['Lasso induces exact sparsity in the weight vector by driving non-informative coefficients to 0', 'Lasso is differentiable everywhere including at 0', 'Lasso always produces smaller training error than unregularized models', 'Lasso preserves all feature coefficients equally'],
            correct_option_index: 0,
            explanation: 'The diamond-shaped L1 norm constraint contours intersect the loss ellipses at the coordinate axes, forcing less important feature weights to exactly zero.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000010',
            question_text: 'How does increasing the regularization penalty lambda affect model bias and variance?',
            options: ['Increases variance, decreases bias', 'Decreases variance, increases bias', 'Decreases both bias and variance simultaneously', 'Has no effect on either bias or variance'],
            correct_option_index: 1,
            explanation: 'Increasing lambda restricts parameter flexibility, reducing model variance (overfitting) at the expense of introducing higher bias (underfitting).'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000011',
            question_text: 'Which technique provides the most reliable estimate of generalization performance on modest datasets?',
            options: ['Evaluating solely on the training set', 'K-Fold Cross-Validation', 'Setting test size to 99% of data', 'Zero-shot heuristic scoring'],
            correct_option_index: 1,
            explanation: 'K-Fold Cross-Validation trains and validates across K distinct partitions, ensuring every data point is tested out-of-fold and reducing evaluation variance.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000012',
            question_text: 'What is the closed-form solution for Ridge regression parameter estimation?',
            options: ['theta = (X^T X)^(-1) X^T y', 'theta = (X^T X + lambda * I)^(-1) X^T y', 'theta = (X + lambda * I)^(-1) y', 'theta = X^T (X X^T + lambda * I)^(-1) y'],
            correct_option_index: 1,
            explanation: 'Adding lambda * I to X^T X shifts all eigenvalues positively, ensuring invertibility even when features are collinear.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000013',
            question_text: 'Which method can directly help mitigate high bias in an underfitting machine learning model?',
            options: ['Adding more training examples without changing the model architecture', 'Increasing L2 regularization weight lambda', 'Adding polynomial feature combinations or increasing model capacity', 'Pruning the top levels of decision trees'],
            correct_option_index: 2,
            explanation: 'High bias stems from an overly simplistic hypothesis class. Expanding feature representations or using more expressive models directly relieves underfitting.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000014',
            question_text: 'What does the irreducible error term sigma^2 represent in the bias-variance decomposition?',
            options: ['The variance introduced by suboptimal learning rates', 'The inherent stochastic noise in the data generating process that cannot be eliminated by any model', 'The error caused by missing regularization parameters', 'The difference between train and test loss'],
            correct_option_index: 1,
            explanation: 'Irreducible error is the lower bound on expected error arising from unobserved variables or fundamental randomness in the underlying system.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0210-000000000003',
        title: 'Quiz 3: Decision Trees, Ensembles, and SVMs',
        passing_score: 75,
        order_index: 3,
        questions: [
          {
            id: 'd0000000-0000-0000-0310-000000000015',
            question_text: 'What metric does the CART algorithm use by default to determine feature splits in classification trees?',
            options: ['Gini Impurity', 'Shannon Entropy', 'Mean Squared Error', 'Adjusted R-squared'],
            correct_option_index: 0,
            explanation: 'The CART (Classification and Regression Trees) algorithm uses Gini Impurity for categorical splits and Mean Squared Error for continuous regression splits.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000016',
            question_text: 'Why do Random Forests choose random subsets of features at each node split rather than considering all features?',
            options: ['To speed up computation only', 'To decorrelate individual trees in the ensemble, maximizing variance reduction when averaging', 'To make trees deeper and more prone to memorization', 'To enforce sparsity in tree weights'],
            correct_option_index: 1,
            explanation: 'If one or two dominant features exist, standard bagging produces correlated trees that make identical splits. Subspace sampling decorrelates trees, improving ensemble variance reduction.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000017',
            question_text: 'How does Gradient Boosting train new trees at each iteration?',
            options: ['By training each tree independently on random subsets of the data in parallel', 'By fitting the new tree to the negative gradient (pseudo-residuals) of the cumulative ensemble loss', 'By taking the majority vote of previously trained trees', 'By training an SVM on the tree leaves'],
            correct_option_index: 1,
            explanation: 'Gradient boosting sequentially optimizes an arbitrary differentiable loss function by training base learners to predict the negative gradient of the current ensemble.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000018',
            question_text: 'What points in the dataset determine the decision boundary in a Support Vector Machine?',
            options: ['All points in the training set equally', 'Only the support vectors that lie on or violate the margin boundaries', 'The mean centroid of each class', 'The points furthest away from the hyperplane'],
            correct_option_index: 1,
            explanation: 'Only data points satisfying y_i(w^T x_i + b) <= 1 have non-zero Lagrange multipliers (support vectors); removing any other training sample leaves the boundary unchanged.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000019',
            question_text: 'What does the Kernel Trick accomplish in SVMs?',
            options: ['It eliminates the need for training labels', 'It calculates inner products in high-dimensional feature spaces implicitly without explicitly computing the coordinates', 'It converts non-convex optimization problems into linear systems', 'It compresses data into low-dimensional PCA space'],
            correct_option_index: 1,
            explanation: 'The Kernel Trick computes K(x, z) = <phi(x), phi(z)> directly, enabling non-linear classification in infinite-dimensional Hilbert spaces without mapping cost.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000020',
            question_text: 'In an SVM with an RBF kernel, what does an excessively large gamma parameter cause?',
            options: ['A nearly linear decision boundary with high bias', 'High variance and overfitting, where each training instance creates an isolated island of decision boundary', 'The margin to widen indefinitely', 'Slack variables to drop to zero'],
            correct_option_index: 1,
            explanation: 'Gamma governs the radius of influence of individual support vectors. A very large gamma makes the Gaussian bell curve extremely narrow, leading to severe overfitting.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000021',
            question_text: 'What is the purpose of the shrinkage parameter (learning rate) in Gradient Boosted Decision Trees?',
            options: ['It scales down each tree\'s contribution to slow learning and prevent overfitting', 'It limits the maximum depth of each tree', 'It forces all leaf values to be integers', 'It normalizes output predictions between 0 and 1'],
            correct_option_index: 0,
            explanation: 'Shrinkage eta in (0, 1] scales the step taken along the gradient direction, reducing the impact of individual trees and improving out-of-sample generalization.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0210-000000000004',
        title: 'Quiz 4: Unsupervised Learning, Clustering, and PCA',
        passing_score: 75,
        order_index: 4,
        questions: [
          {
            id: 'd0000000-0000-0000-0310-000000000022',
            question_text: 'How does K-Means++ improve over standard random centroid initialization?',
            options: ['It initializes all centroids at the global dataset mean', 'It chooses initial centroids iteratively with probability proportional to squared distance from the closest existing centroid', 'It uses hierarchical agglomeration to find centers', 'It computes eigenvalues to place centroids along principal components'],
            correct_option_index: 1,
            explanation: 'K-Means++ spaces initial centroids as far apart as possible, substantially reducing convergence time and avoiding poor local minima.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000023',
            question_text: 'What does the Silhouette Coefficient measure for a clustered sample point?',
            options: ['The computational runtime of the clustering algorithm', 'How close the sample is to points in its own cluster relative to points in neighboring clusters', 'The total number of iterations before convergence', 'The probability that the sample was generated by a uniform distribution'],
            correct_option_index: 1,
            explanation: 'The silhouette value s = (b - a) / max(a, b) ranges from -1 to +1, scoring intra-cluster cohesion (a) versus nearest-cluster separation (b).'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000024',
            question_text: 'In Principal Component Analysis (PCA), what direction does the first principal component vector point in?',
            options: ['The direction of minimal variance in the data', 'The direction of maximum variance in the centered data', 'Along the feature with the highest mean value', 'Orthogonal to all eigenvectors with non-zero eigenvalues'],
            correct_option_index: 1,
            explanation: 'The first principal component corresponds to the eigenvector of the sample covariance matrix with the largest eigenvalue, capturing maximum variance.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000025',
            question_text: 'Why is standardizing features (zero mean, unit variance) essential before performing PCA?',
            options: ['PCA cannot compute square roots on negative numbers', 'Without scaling, features with large numeric scales artificially dominate variance and dictate the principal axes', 'Standardization ensures all eigenvalues become exactly 1.0', 'PCA requires all data values to lie strictly between 0 and 1'],
            correct_option_index: 1,
            explanation: 'PCA variance maximization is sensitive to measurement units. A feature measured in millimeters will dominate variance over a feature measured in meters unless scaled.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000026',
            question_text: 'What key advantage do Gaussian Mixture Models (GMM) offer over K-Means?',
            options: ['GMMs provide soft probabilistic cluster assignments and can model elliptical clusters with arbitrary covariance', 'GMMs do not require selecting the number of clusters K', 'GMMs guarantee finding global optimal parameters in polynomial time', 'GMMs do not require numerical optimization'],
            correct_option_index: 0,
            explanation: 'K-Means assumes spherical clusters with equal variance. GMMs learn covariance matrices per component and assign posterior responsibilities gamma_ik in [0, 1].'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000027',
            question_text: 'In the Expectation-Maximization (EM) algorithm for GMMs, what occurs during the M-step (Maximization)?',
            options: ['Posterior responsibilities are computed given current parameters', 'Model parameters (means, covariances, mixing weights) are updated using the estimated responsibilities', 'The number of clusters K is increased by one', 'Outlier points are removed from the dataset'],
            correct_option_index: 1,
            explanation: 'The E-step calculates posterior responsibilities given current parameters; the M-step re-estimates cluster means, covariance matrices, and mixture priors to maximize expected log-likelihood.'
          },
          {
            id: 'd0000000-0000-0000-0310-000000000028',
            question_text: 'How can you determine the number of principal components to retain in PCA for dimensionality reduction?',
            options: ['Always retain exactly 50% of the features', 'Plot cumulative explained variance ratio vs number of components and select threshold (e.g. 95%)', 'Retain only components whose eigenvalues are strictly negative', 'Choose the component count that maximizes training loss'],
            correct_option_index: 1,
            explanation: 'A scree plot or cumulative explained variance curve shows the fraction of total dataset variance preserved by the top k components, guiding an informed cutoff.'
          }
        ]
      }
    ],
    assignments: [
      {
        id: 'd0000000-0000-0000-0410-000000000001',
        title: 'Assignment 1: Regularized Regression and Optimization from Scratch',
        description: `Implement and evaluate linear and logistic regression models using NumPy without relying on scikit-learn estimators:
1. Implement standard feature scaling (Z-score normalization).
2. Code Batch Gradient Descent and Mini-batch SGD with momentum for Ordinary Least Squares (OLS) regression.
3. Add L1 (Lasso) and L2 (Ridge) regularization penalties to the cost function and gradient equations.
4. Implement the closed-form Normal Equation with L2 regularization $\\theta = (X^T X + \\lambda I)^{-1} X^T y$ and verify that gradient descent converges to the same weights.
5. Extend the framework to binary Logistic Regression using the cross-entropy loss function, vectorizing forward predictions and backward gradient calculations.
6. Benchmark on the California Housing dataset (regression) and Breast Cancer Wisconsin dataset (classification):
   - Plot cost vs iterations for varying learning rates $\\eta \\in \\{0.001, 0.01, 0.1, 0.5\\}$.
   - Demonstrate the sparsity effect of L1 vs L2 regularization across varying penalty strengths $\\lambda$.`,
        due_date: '2026-11-22T23:59:59Z',
        rubric: [
          { criterion: 'Vectorized NumPy Implementation', max_points: 25, description: 'Efficient matrix-vector calculations without explicit loops over samples.' },
          { criterion: 'Optimization & Normal Equation', max_points: 25, description: 'Correct gradient descent with momentum and verification against closed-form normal equation.' },
          { criterion: 'Regularization & Sparsity Proof', max_points: 25, description: 'Accurate L1 subgradient and L2 updates with empirical demonstration of zero-weight sparsity in Lasso.' },
          { criterion: 'Evaluation & Visualizations', max_points: 25, description: 'Comprehensive convergence plots, learning curves, and performance metrics (RMSE, R2, F1-Score).' }
        ]
      },
      {
        id: 'd0000000-0000-0000-0410-000000000002',
        title: 'Assignment 2: End-to-End Ensemble Pipeline & Unsupervised Customer Segmentation',
        description: `Build a comparative classification and clustering pipeline on tabular financial credit data:
1. **Data Preprocessing:** Handle missing values, encode categorical variables with target/one-hot encoding, and handle class imbalance using SMOTE or class weights.
2. **Supervised Modeling:** Train and cross-validate:
   - Tuned Decision Tree with cost-complexity pruning.
   - Random Forest with out-of-bag (OOB) error estimation.
   - Gradient Boosted Decision Tree (XGBoost or LightGBM).
   - Support Vector Classifier with RBF kernel and grid-searched $(C, \\gamma)$.
3. **Model Evaluation:** Report ROC-AUC, Precision-Recall curves, Brier score calibration, and compute SHAP (SHapley Additive exPlanations) values to interpret top risk factors.
4. **Unsupervised Segmentation:**
   - Standardize behavioral features and perform PCA, analyzing eigenvalues and scree plots.
   - Apply K-Means clustering with K-Means++ initialization, validating optimal $K$ via Elbow and Silhouette methods.
   - Fit Gaussian Mixture Models (GMM) with full vs diagonal covariance matrices and analyze cluster assignments.`,
        due_date: '2026-11-30T23:59:59Z',
        rubric: [
          { criterion: 'Data Preprocessing & Validation Setup', max_points: 20, description: 'Leak-free cross-validation pipelines with proper imputation and feature encoding.' },
          { criterion: 'Supervised Model Tuning & Metrics', max_points: 30, description: 'Systematic hyperparameter search and rigorous evaluation with ROC-AUC and PR curves.' },
          { criterion: 'Interpretability & Feature Importance', max_points: 20, description: 'Detailed feature attribution using SHAP or permutation importance with actionable insights.' },
          { criterion: 'PCA & Clustering Analysis', max_points: 30, description: 'PCA variance analysis, K-Means elbow/silhouette metrics, and GMM probabilistic interpretation.' }
        ]
      }
    ]
  },

  // -------------------------------------------------------------------------
  // 11. Generative AI and Large Language Models
  // -------------------------------------------------------------------------
  {
    id: 'd0000000-0000-0000-0000-000000000011',
    title: 'Generative AI and Large Language Models',
    slug: 'generative-ai-large-language-models',
    description: 'Comprehensive study of modern generative architectures: self-attention mechanisms, Transformer encoders and decoders, pretraining objectives (Causal LM, Masked LM), scaling laws, instruction fine-tuning, RLHF, Parameter-Efficient Fine-Tuning (LoRA, QLoRA), Retrieval-Augmented Generation (RAG), and hallucination mitigation.',
    category: 'AI & Data Science',
    level: 'Advanced',
    thumbnail_url: 'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?q=80&w=800&auto=format&fit=crop',
    lessons: [
      {
        id: 'd0000000-0000-0000-0111-000000000001',
        title: 'From Recurrent Models to Self-Attention: Limitations of RNNs and LSTMs',
        duration_minutes: 45,
        is_free_preview: true,
        order_index: 1,
        content: `### Learning Objectives
- Identify sequential bottlenecks and vanishing/exploding gradients in vanilla RNNs and LSTMs.
- Contrast sequential recurrence $O(N)$ runtime with parallelizable self-attention $O(1)$ sequential operations.
- Formulate the fundamental Scaled Dot-Product Attention equation: $\\text{Attention}(Q, K, V) = \\text{softmax}\\left(\\frac{QK^T}{\\sqrt{d_k}}\\right)V$.

### The Attention Mechanism
In recurrent networks, information flows sequentially through hidden vectors $h_t = f(h_{t-1}, x_t)$, making GPU parallelization impossible during training and causing catastrophic forgetting over long sequences.

Attention computes direct pairwise affinity between all token pairs simultaneously:
\`\`\`
Inputs: Queries Q in R^{N x d_k}, Keys K in R^{M x d_k}, Values V in R^{M x d_v}

                  Q      K^T
                  \\    /
               Matrix Multiply
                     |
               Scale (1 / sqrt(d_k))
                     |
                Mask (Optional)
                     |
                  Softmax
                     \\   /
                 Matrix Multiply (V)
                     |
                   Output
\`\`\`

### Why Scale by $\\sqrt{d_k}$?
For large projection dimension $d_k$, the dot products $q_i \\cdot k_j = \\sum_{m=1}^{d_k} q_{im} k_{jm}$ grow large in magnitude (variance $\\approx d_k$ under unit variance assumptions). Large dot products push the softmax function into regions with near-zero gradients. Dividing by $\\sqrt{d_k}$ preserves unit variance and prevents vanishing gradients.`
      },
      {
        id: 'd0000000-0000-0000-0111-000000000002',
        title: 'The Transformer Architecture: Multi-Head Attention, Residuals, and LayerNorm',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 2,
        content: `### Learning Objectives
- Dissect the multi-head attention mechanism and its linear projection matrices $W_i^Q, W_i^K, W_i^V, W^O$.
- Understand positional encodings (sinusoidal vs learned embeddings vs RoPE - Rotary Position Embedding).
- Compare Pre-LN vs Post-LN architectures and analyze LayerNorm vs RMSNorm.

### Multi-Head Attention Formulation
$$
\\text{MultiHead}(Q, K, V) = \\text{Concat}(\\text{head}_1, \\dots, \\text{head}_h) W^O
$$
$$
\\text{where} \\quad \\text{head}_i = \\text{Attention}(Q W_i^Q, K W_i^K, V W_i^V)
$$

### Transformer Block Dataflow (Pre-LN)
\`\`\`python
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
\`\`\`

### Rotary Position Embedding (RoPE)
RoPE encodes relative position by rotating query and key representations in 2D complex feature planes:
$$R_{\\Theta, m}^d = \\text{diag}(R_{\\theta_1, m}, \\dots, R_{\\theta_{d/2}, m})$$
This allows the dot product $\\langle R_m q, R_n k \\rangle$ to depend purely on relative token distance $(m - n)$, enabling length extrapolation.`
      },
      {
        id: 'd0000000-0000-0000-0111-000000000003',
        title: 'Pretraining Paradigms: Causal LM vs Masked LM, Tokenization, and Scaling Laws',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 3,
        content: `### Learning Objectives
- Compare Autoregressive Causal Language Modeling (GPT family) with Bidirectional Masked Language Modeling (BERT).
- Examine subword tokenization algorithms: Byte-Pair Encoding (BPE), WordPiece, and SentencePiece.
- Analyze Chinchilla scaling laws balancing compute budget, parameter count, and training token volume.

### Pretraining Objective Comparison
1. **Masked Language Modeling (Encoder-only):**
   $$\\mathcal{L}_{MLM}(\\theta) = - \\sum_{i \\in \\text{Masked}} \\log P(x_i \\mid x_{\\setminus i}; \\theta)$$
   Bidirectional context enables deep text representation, ideal for classification and extraction.
2. **Causal Autoregressive Language Modeling (Decoder-only):**
   $$\\mathcal{L}_{CLM}(\\theta) = - \\sum_{t=1}^T \\log P(x_t \\mid x_{<t}; \\theta)$$
   Enforced via lower-triangular causal attention masking, making decoders natural generative engines.

### Chinchilla Scaling Laws (Hoffmann et al., 2022)
For optimal compute efficiency given compute budget $C \\approx 6 N D$:
- Model parameter count $N$ and token count $D$ should scale in **equal proportion**:
  $$N \\propto C^{0.5}, \\quad D \\propto C^{0.5}$$
- To train a model compute-optimally, train with approximately $20$ tokens per model parameter.`
      },
      {
        id: 'd0000000-0000-0000-0111-000000000004',
        title: 'Instruction Tuning and Alignment: SFT, RLHF, and Direct Preference Optimization (DPO)',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 4,
        content: `### Learning Objectives
- Trace the three-stage post-training pipeline: Pretraining -> Supervised Fine-Tuning (SFT) -> Alignment.
- Implement Reinforcement Learning from Human Feedback (RLHF) with reward modeling and PPO.
- Formulate Direct Preference Optimization (DPO) to optimize policy directly from preference pairs without training a separate reward model.

### Alignment Paradigm
\`\`\`
Raw Base LLM -> SFT (Instruction-Response Pairs) -> Preference Dataset (y_w > y_l) -> RLHF / DPO -> Aligned Chat Model
\`\`\`

### Direct Preference Optimization (DPO)
Standard RLHF trains a reward model $r_\\psi(x, y)$ and uses PPO with a KL divergence penalty to keep the policy close to reference model $\\pi_{ref}$.

Rafailov et al. (2023) derived that the optimal policy $\\pi_\\theta$ can be expressed analytically in terms of the reward:
$$
r(x, y) = \\beta \\log \\frac{\\pi_\\theta(y \\mid x)}{\\pi_{ref}(y \\mid x)} + \\beta \\log Z(x)
$$
Substituting this into the Bradley-Terry preference model yields the direct DPO loss function:
$$
\\mathcal{L}_{DPO}(\\theta) = - \\mathbb{E}_{(x, y_w, y_l)} \\left[ \\log \\sigma \\left( \\beta \\log \\frac{\\pi_\\theta(y_w \\mid x)}{\\pi_{ref}(y_w \\mid x)} - \\beta \\log \\frac{\\pi_\\theta(y_l \\mid x)}{\\pi_{ref}(y_l \\mid x)} \\right) \\right]
$$
This eliminates reinforcement learning instability, value networks, and reward model training.`
      },
      {
        id: 'd0000000-0000-0000-0111-000000000005',
        title: 'Parameter-Efficient Fine-Tuning (PEFT): LoRA, QLoRA, and Prefix Tuning',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 5,
        content: `### Learning Objectives
- Analyze the memory bottleneck of full-parameter fine-tuning (optimizer states, gradients, activations).
- Implement Low-Rank Adaptation (LoRA): decomposing weight updates into low-rank matrices $W = W_0 + \\frac{\\alpha}{r} B A$.
- Apply QLoRA: 4-bit NormalFloat (NF4) quantization, Double Quantization, and Paged Optimizers.

### Low-Rank Adaptation (LoRA)
Given pre-trained weight matrix $W_0 \\in \\mathbb{R}^{d \\times k}$, freeze $W_0$ and decompose the update $\\Delta W$ into two low-rank matrices:
$$
h = W_0 x + \\Delta W x = W_0 x + \\frac{\\alpha}{r} B A x
$$
where $B \\in \\mathbb{R}^{d \\times r}$ (initialized to 0) and $A \\in \\mathbb{R}^{r \\times k}$ (initialized from $\\mathcal{N}(0, \\sigma^2)$) with rank $r \\ll \\min(d, k)$.

\`\`\`
       x (k-dim)
       /       \\
   W_0 (frozen) A (r x k)
     |          |
     |          B (d x r)
     \\         /
      + (d-dim output)
\`\`\`

### Memory Savings with QLoRA
- Full 16-bit 7B model: $\\approx 14$ GB weights $+ 28$ GB Adam optimizer states $+ 14$ GB gradients $\\approx 56$ GB VRAM.
- QLoRA 4-bit 7B model: $\\approx 3.5$ GB weights $+ \\approx 1$ GB LoRA adapter parameters and optimizer $\\approx 6$ GB VRAM (fits on single consumer GPU).`
      },
      {
        id: 'd0000000-0000-0000-0111-000000000006',
        title: 'Retrieval-Augmented Generation (RAG): Vector Databases and Dense Embeddings',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 6,
        content: `### Learning Objectives
- Construct end-to-end RAG architectures: ingestion, chunking, dense embeddings, vector indexing, and generation.
- Compare approximate nearest neighbor (ANN) vector indexing algorithms: HNSW vs IVF-PQ.
- Implement advanced retrieval strategies: hybrid search (dense + BM25 sparse) and cross-encoder re-ranking.

### RAG Pipeline Architecture
\`\`\`
Documents -> Recursive Chunking -> Embedding Model (e.g. bge-large) -> Vector DB (HNSW Index)
                                                                             |
User Query ---------------------> Query Embedding -----------------> Vector Search (Top-K)
                                                                             |
User Query + Retrieved Context Chunks -----------------------------> Re-Ranker (Cross-Encoder)
                                                                             |
Refined Context + System Prompt + Query ---------------------------> LLM Generator -> Grounded Answer
\`\`\`

### Chunking Strategies & Tradeoffs
1. **Fixed Token Windows with Overlap:** e.g., 512 tokens with 64-token overlap. Simple but splits semantic boundaries.
2. **Recursive Character Chunking:** Splits hierarchy: paragraph ('\\n\\n') -> sentence ('\\n') -> space.
3. **Semantic Chunking:** Computes embedding distance between consecutive sentences and cuts chunks at semantic inflection points.`
      },
      {
        id: 'd0000000-0000-0000-0111-000000000007',
        title: 'Decoding Strategies, Hallucination Mitigation, and Evaluation',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 7,
        content: `### Learning Objectives
- Analyze token sampling methods: Greedy search, Beam search, Temperature scaling, Top-$k$, and Top-$p$ (Nucleus sampling).
- Classify types of LLM hallucinations: factual contradiction, ungrounded extrapolation, and sycophancy.
- Evaluate generative systems using automated benchmarks (MMLU, GSM8K, HumanEval) and RAG triaging (Faithfulness, Answer Relevance).

### Decoding Algorithm Formulations
Given next-token logits $z_i$:
1. **Temperature Scaling:**
   $$P(x_i) = \\frac{\\exp(z_i / T)}{\\sum_j \\exp(z_j / T)}$$
   $T \\to 0$ approaches greedy argmax; $T > 1$ flattens probability distribution toward uniform randomness.
2. **Top-$p$ (Nucleus) Sampling:**
   Filter tokens to the smallest candidate set $V^{(p)}$ whose cumulative probability exceeds threshold $p \\in (0, 1]$:
   $$\\sum_{i \\in V^{(p)}} P(x_i) \\ge p$$
   Dynamically adjusts vocabulary width based on model certainty.`
      }
    ],
    quizzes: [
      {
        id: 'd0000000-0000-0000-0211-000000000001',
        title: 'Quiz 1: Attention Mechanisms and the Transformer Architecture',
        passing_score: 75,
        order_index: 1,
        questions: [
          {
            id: 'd0000000-0000-0000-0311-000000000001',
            question_text: 'In the scaled dot-product attention equation Attention(Q, K, V) = softmax(Q K^T / sqrt(d_k)) V, what is the mathematical purpose of dividing by sqrt(d_k)?',
            options: ['To guarantee the output values sum to 1', 'To prevent large dot products from pushing softmax into regions with vanishingly small gradients', 'To project vectors into complex frequency space', 'To enforce causal masking across sequence steps'],
            correct_option_index: 1,
            explanation: 'For high dimensions d_k, variance of the inner product scales with d_k. Scaling by 1/sqrt(d_k) preserves unit variance, preventing softmax saturation.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000002',
            question_text: 'What is the computational complexity of standard full self-attention with respect to sequence length N?',
            options: ['O(N) linear time and space', 'O(N * log N)', 'O(N^2) quadratic time and memory footprint', 'O(2^N) exponential complexity'],
            correct_option_index: 2,
            explanation: 'Computing the pairwise attention score matrix between N queries and N keys requires N x N operations and memory storage, yielding O(N^2) complexity.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000003',
            question_text: 'How does Multi-Head Attention enhance model expressiveness over single-head attention?',
            options: ['It increases the sequence length by a factor of h', 'It allows the model to jointly attend to information from different representation subspaces at different positions', 'It eliminates the need for feed-forward layers', 'It removes all linear projection weight matrices'],
            correct_option_index: 1,
            explanation: 'Multiple attention heads project inputs into distinct subspaces, allowing individual heads to specialize in syntactic relations, coreference, semantic binding, etc.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000004',
            question_text: 'Why do modern LLM architectures (like LLaMA and Mistral) utilize Pre-LayerNorm rather than the original Post-LayerNorm?',
            options: ['Pre-LN stabilizes gradient flow through residual connections, enabling training of very deep networks without warmup instability', 'Pre-LN removes the need for residual connections entirely', 'Pre-LN reduces the parameter count of the model by 50%', 'Post-LN cannot be executed on GPUs'],
            correct_option_index: 0,
            explanation: 'Pre-LN applies normalization to the inputs of the sub-layers before self-attention and FFN, keeping the clean residual identity path unobstructed and avoiding vanishing/exploding gradients.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000005',
            question_text: 'What distinguishes Rotary Position Embeddings (RoPE) from traditional absolute sinusoidal positional encodings?',
            options: ['RoPE requires no floating point operations', 'RoPE incorporates positional information by rotating query and key representations in the complex plane, naturally preserving relative distances', 'RoPE assigns identical position vectors to all tokens', 'RoPE only works on text with fewer than 128 tokens'],
            correct_option_index: 1,
            explanation: 'RoPE applies an orthogonal rotation matrix to queries and keys such that their dot product depends solely on relative token offset (m - n), enabling superior length generalization.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000006',
            question_text: 'What mask is applied in autoregressive decoder-only Transformers during self-attention?',
            options: ['A random dropout mask', 'A lower-triangular causal attention mask setting future token affinities to -infinity before softmax', 'An upper-triangular mask hiding past tokens', 'A bidirectional encoder mask'],
            correct_option_index: 1,
            explanation: 'Causal masking ensures token t can only attend to tokens at indices <= t, preventing future token leakage during autoregressive language modeling.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000007',
            question_text: 'What activation function has largely replaced ReLU in modern Transformer Feed-Forward Networks?',
            options: ['Sigmoid', 'GELU / SwiGLU', 'Step function', 'Tanh'],
            correct_option_index: 1,
            explanation: 'Smooth non-linearities like GELU and gated variants like SwiGLU provide non-zero gradients for small negative inputs, substantially improving training dynamics in deep LLMs.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0211-000000000002',
        title: 'Quiz 2: Pretraining, Tokenization, and Scaling Laws',
        passing_score: 75,
        order_index: 2,
        questions: [
          {
            id: 'd0000000-0000-0000-0311-000000000008',
            question_text: 'According to the Chinchilla scaling laws (Hoffmann et al., 2022), how should model parameters N and training tokens D scale for compute-optimal pretraining?',
            options: ['Increase model parameters 4x faster than training tokens', 'Scale model parameters N and training tokens D in approximately equal proportions (1:1)', 'Hold tokens constant and scale parameters quadratically', 'Scale tokens exponentially while keeping model size under 1 billion parameters'],
            correct_option_index: 1,
            explanation: 'Chinchilla demonstrated that both parameters N and tokens D should scale proportionally with compute budget (N proportional to C^0.5, D proportional to C^0.5), requiring ~20 tokens per parameter.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000009',
            question_text: 'How does Byte-Pair Encoding (BPE) construct its vocabulary during training?',
            options: ['By randomly selecting 50,000 dictionary words', 'By iteratively merging the most frequently occurring pair of adjacent bytes or characters in the training corpus', 'By clustering sentence embeddings using K-Means', 'By computing the Fourier transform of the character frequency histogram'],
            correct_option_index: 1,
            explanation: 'BPE starts with base characters and repeatedly merges the most frequent adjacent token pairs until the target vocabulary size is reached.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000010',
            question_text: 'What pretraining objective is used in models like BERT?',
            options: ['Causal Next-Token Prediction', 'Masked Language Modeling (MLM) and Next Sentence Prediction', 'Direct Preference Optimization', 'Reinforcement Learning from Human Feedback'],
            correct_option_index: 1,
            explanation: 'BERT was trained using Masked Language Modeling (predicting 15% masked tokens using bidirectional context) and Next Sentence Prediction.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000011',
            question_text: 'What problem occurs when tokenizers encounter rare words or code identifiers?',
            options: ['The model crashes immediately', 'Subword tokenization breaks the unfamiliar term into multiple known subwords or individual bytes without losing information', 'The entire sentence is discarded', 'The tokens are replaced with zero embeddings'],
            correct_option_index: 1,
            explanation: 'Subword tokenizers (like BPE or SentencePiece) gracefully decompose unseen or rare words into familiar constituent character sequences or byte fallback tokens.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000012',
            question_text: 'What is the relationship between training compute FLOPs C, parameter count N, and token count D for a standard dense Transformer?',
            options: ['C approximately equals 6 * N * D', 'C approximately equals N + D', 'C approximately equals N^2 * D', 'C approximately equals 2 * N * log(D)'],
            correct_option_index: 0,
            explanation: 'Each token requires approximately 2 FLOPs per parameter on the forward pass and 4 FLOPs on the backward pass, totaling approximately 6 * N * D FLOPs during training.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000013',
            question_text: 'Why are decoder-only causal models preferred over encoder-decoder architectures for general conversational generation?',
            options: ['Decoder-only models cannot perform translation', 'Decoder-only models share parameters across prefix and generation, maximizing KV-cache reuse and autoregressive efficiency', 'Encoder-decoder models require 100x more compute per token', 'Decoder-only models do not use attention'],
            correct_option_index: 1,
            explanation: 'Decoder-only architectures handle unified prompting, task specification, few-shot conditioning, and free-form generation under a single autoregressive framework.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000014',
            question_text: 'What is the phenomenon where pre-trained LLMs gain unexpected qualitative capabilities (e.g. arithmetic, translation) when scaled past critical compute thresholds?',
            options: ['Catastrophic forgetting', 'Emergent abilities', 'Gradient explosion', 'Mode collapse'],
            correct_option_index: 1,
            explanation: 'Emergent abilities refer to sharp performance improvements observed on complex reasoning benchmarks once models cross critical scale in parameters and compute.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0211-000000000003',
        title: 'Quiz 3: Alignment, Instruction Tuning, and PEFT',
        passing_score: 75,
        order_index: 3,
        questions: [
          {
            id: 'd0000000-0000-0000-0311-000000000015',
            question_text: 'What major advantage does Direct Preference Optimization (DPO) have over traditional RLHF with PPO?',
            options: ['DPO does not require any human preference data', 'DPO optimizes the policy directly from pairwise preferences without training a separate reward model or using complex RL algorithms', 'DPO works only on encoder models', 'DPO updates only 1% of parameters'],
            correct_option_index: 1,
            explanation: 'DPO reparameterizes the reward function analytically using the closed-form optimal policy, formulating alignment as a clean classification loss without PPO instability.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000016',
            question_text: 'In Low-Rank Adaptation (LoRA), how is a pre-trained weight matrix W0 of size d x k adapted?',
            options: ['W0 is fully retrained with a small learning rate', 'W0 is frozen and an additive low-rank decomposition Delta W = B * A is learned, where B is d x r and A is r x k with r << min(d, k)', 'W0 is pruned to retain only diagonal entries', 'W0 is converted into 8-bit integers'],
            correct_option_index: 1,
            explanation: 'LoRA freezes W0 and adds product B * A of rank r. This reduces trainable parameters by >99% and allows merging adapters directly back into W0 at inference time with zero latency penalty.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000017',
            question_text: 'What key innovation allows QLoRA to fine-tune a 65B parameter model on a single 48GB GPU?',
            options: ['Eliminating the self-attention layers', 'Quantizing frozen base weights to 4-bit NormalFloat (NF4), double quantization, and paged optimizers', 'Running gradient descent on CPU memory exclusively', 'Training only on the last 2 token positions'],
            correct_option_index: 1,
            explanation: 'QLoRA quantizes base weights to information-theoretically optimal 4-bit NF4 format while computing high-precision 16-bit gradients solely through low-rank LoRA adapter matrices.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000018',
            question_text: 'What is the role of the KL-divergence penalty in RLHF reward optimization?',
            options: ['To maximize the length of the generated response', 'To prevent the policy model from drifting too far from the initial reference model (reward hacking / mode collapse)', 'To force the model to generate random words', 'To eliminate the need for value networks'],
            correct_option_index: 1,
            explanation: 'The KL penalty D_KL(pi_theta || pi_ref) constrains the policy from exploiting loopholes or vulnerabilities in the reward model that produce incoherent or unnatural outputs.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000019',
            question_text: 'How can LoRA weights be deployed in production without adding latency to model forward passes?',
            options: ['By running the adapter on a separate auxiliary server', 'By mathematically adding the adapter weights directly to the base weights: W_final = W_0 + (alpha / r) * B * A', 'By disabling attention caching', 'By converting all weights into strings'],
            correct_option_index: 1,
            explanation: 'Because Delta W = (alpha/r) B A has the exact same dimensions as W_0, it can be fused directly into the pre-trained weights prior to serving.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000020',
            question_text: 'What distinguishes Supervised Fine-Tuning (SFT) from raw pretraining?',
            options: ['SFT is performed on uncurated internet text', 'SFT trains specifically on curated prompt-response pairs to teach the model how to follow conversational instructions', 'SFT uses unsupervised clustering', 'SFT changes the tokenizer vocabulary'],
            correct_option_index: 1,
            explanation: 'While pretraining teaches general world knowledge and language fluency, SFT trains the model on structured instruction-following datasets to align output format with user requests.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000021',
            question_text: 'In LoRA, what is the initial value of matrix B in Delta W = B * A?',
            options: ['Identity matrix', 'All zeros, ensuring Delta W = 0 at the start of training so behavior matches the base model exactly', 'Gaussian random noise', 'Uniform distribution between -1 and 1'],
            correct_option_index: 1,
            explanation: 'Initializing B to 0 (and A to Gaussian noise) guarantees Delta W = 0 initially, meaning fine-tuning begins strictly from the pre-trained model state without disruption.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0211-000000000004',
        title: 'Quiz 4: RAG, Decoding, and Evaluation',
        passing_score: 75,
        order_index: 4,
        questions: [
          {
            id: 'd0000000-0000-0000-0311-000000000022',
            question_text: 'What is the primary architectural purpose of Retrieval-Augmented Generation (RAG)?',
            options: ['To eliminate the need for an LLM generator', 'To ground model generations in external authoritative knowledge bases, reducing factual hallucinations and enabling real-time data access', 'To increase token generation speed by 10x', 'To quantize embeddings into 1-bit representations'],
            correct_option_index: 1,
            explanation: 'RAG retrieves relevant external document chunks dynamically based on query similarity, conditioning generation on factual context to prevent knowledge staleness and hallucinations.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000023',
            question_text: 'What vector indexing structure builds a multi-layer graph of vectors to enable fast Approximate Nearest Neighbor (ANN) search?',
            options: ['B-Tree', 'Hierarchical Navigable Small World (HNSW)', 'Red-Black Tree', 'Inverted Index'],
            correct_option_index: 1,
            explanation: 'HNSW constructs hierarchical proximity graphs where upper layers enable fast long-range navigation and bottom layers refine local nearest-neighbor search in logarithmic time.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000024',
            question_text: 'In token sampling, what does Nucleus (Top-p) sampling do?',
            options: ['Selects the single most likely token deterministically', 'Restricts the candidate pool to the smallest set of tokens whose cumulative probability reaches threshold p', 'Samples only from the top k tokens regardless of their probabilities', 'Sets temperature to zero'],
            correct_option_index: 1,
            explanation: 'Top-p sampling dynamically sizes the candidate token set according to model confidence: narrow when confident, wide when uncertain.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000025',
            question_text: 'Why is a Cross-Encoder re-ranker often applied after initial bi-encoder vector retrieval in advanced RAG?',
            options: ['Cross-encoders are much faster than vector dot products', 'Cross-encoders process query and document simultaneously through full cross-attention, providing significantly higher relevance scoring accuracy on candidate chunks', 'Cross-encoders generate the final summary text', 'Cross-encoders perform recursive document chunking'],
            correct_option_index: 1,
            explanation: 'Bi-encoders embed query and document independently (allowing fast indexing), but lack cross-token interaction. Cross-encoders score query-document pairs jointly with full attention.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000026',
            question_text: 'What metric in the RAG Triad evaluates whether the generated answer is strictly supported by the retrieved context without ungrounded assertions?',
            options: ['Context Relevance', 'Faithfulness (Groundedness)', 'Answer Relevance', 'BLEU Score'],
            correct_option_index: 1,
            explanation: 'Faithfulness verifies that every claim made in the generated output can be directly inferred from the retrieved context, guarding against hallucinations.'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000027',
            question_text: 'What is KV-Caching in autoregressive LLM inference?',
            options: ['Caching user session cookies in browser storage', 'Storing previously computed Key and Value attention matrices for prior tokens so they do not need to be recomputed at each generation step', 'Storing raw prompt text in Redis', 'Compressing weights using gzip'],
            correct_option_index: 1,
            explanation: 'During token-by-token generation, earlier tokens do not change. Caching past Keys and Values reduces the per-step computation from O(N^2) to O(N).'
          },
          {
            id: 'd0000000-0000-0000-0311-000000000028',
            question_text: 'What happens when sampling temperature T is set to 0.0?',
            options: ['The model outputs uniform random gibberish', 'The sampling distribution becomes deterministic greedy decoding (argmax)', 'The model produces infinitely long sequences', 'The vocabulary size is restricted to 1 token'],
            correct_option_index: 1,
            explanation: 'As T -> 0, the softmax function sharpens until the single token with the highest logit receives probability 1.0, yielding deterministic greedy decoding.'
          }
        ]
      }
    ],
    assignments: [
      {
        id: 'd0000000-0000-0000-0411-000000000001',
        title: 'Assignment 1: Mini-Transformer Decoder and Self-Attention from Scratch',
        description: `Implement a complete autoregressive causal Transformer decoder from scratch using PyTorch:
1. **Multi-Head Self-Attention:** Implement multi-head attention with causal lower-triangular masking, projection matrices ($W_q, W_k, W_v, W_o$), and scaled dot-product attention without using \`nn.MultiheadAttention\`.
2. **Positional Encoding:** Implement both Sinusoidal positional embeddings and Rotary Position Embeddings (RoPE).
3. **Transformer Block:** Assemble Pre-LN Transformer decoder blocks with RMSNorm/LayerNorm, GELU Feed-Forward Networks, and residual additions.
4. **Causal Language Model:** Build the language model head with tied input/output embedding weights.
5. **Inference Engine:** Implement autoregressive text generation supporting:
   - KV-cache storage for efficient $O(1)$ sequential token generation.
   - Temperature scaling, Top-$k$ filtering, and Top-$p$ (nucleus) sampling.
6. Train the model on the TinyStories or Shakespeare character-level dataset, plotting cross-entropy loss over training steps and showcasing sample completions.`,
        due_date: '2026-11-25T23:59:59Z',
        rubric: [
          { criterion: 'Custom Multi-Head Causal Attention', max_points: 30, description: 'Accurate vectorized implementation of scaled dot-product attention with causal mask.' },
          { criterion: 'Positional Embeddings & RoPE', max_points: 20, description: 'Correct mathematical implementation of sinusoidal and rotary positional encoding.' },
          { criterion: 'Transformer Architecture & KV-Cache', max_points: 25, description: 'Clean Pre-LN block assembly and working KV-cache mechanism during generation.' },
          { criterion: 'Decoding Algorithms & Empirical Training', max_points: 25, description: 'Working Top-k/Top-p sampling implementation, convergence on sample text, and generated output analysis.' }
        ]
      },
      {
        id: 'd0000000-0000-0000-0411-000000000002',
        title: 'Assignment 2: Production-Grade RAG Pipeline with Hybrid Search and Evaluation',
        description: `Build an enterprise-grade Retrieval-Augmented Generation (RAG) system with hybrid search and automated evaluation:
1. **Document Ingestion & Chunking:** Ingest technical documentation (e.g. documentation markdown or PDF manuals). Implement recursive chunking with configurable chunk sizes (256, 512 tokens) and token overlap.
2. **Dense Vector Indexing:** Generate dense embeddings using Hugging Face transformers and index into a vector store (e.g. FAISS or ChromaDB) using HNSW indexing.
3. **Sparse Keyword Search:** Build a BM25 index on the raw text chunks to handle exact keyword matching, code identifiers, and acronyms.
4. **Hybrid Search & Re-ranking:** Implement Reciprocal Rank Fusion (RRF) combining dense and BM25 candidate ranks. Apply a cross-encoder model to re-score the top 20 candidates and select the top 5 for generation.
5. **Grounded Generation:** Engineer robust system prompts enforcing strict citation grounding (e.g. "[Doc 2, paragraph 1]") and explicit refusal when context is insufficient.
6. **RAG Triad Evaluation:** Implement automated evaluation measuring:
   - Context Relevance (fraction of retrieved context pertinent to query).
   - Groundedness / Faithfulness (verifying claims against retrieved source).
   - Answer Relevance (evaluating if generated answer addresses user prompt).`,
        due_date: '2026-12-05T23:59:59Z',
        rubric: [
          { criterion: 'Ingestion, Chunking & Embeddings', max_points: 20, description: 'Robust document processing, chunking strategies, and embedding generation.' },
          { criterion: 'Hybrid Search & RRF Fusion', max_points: 25, description: 'Seamless combination of dense semantic retrieval and sparse BM25 indexing with reciprocal rank fusion.' },
          { criterion: 'Cross-Encoder Re-Ranking', max_points: 25, description: 'Effective cross-encoder re-scoring significantly improving precision of top context chunks.' },
          { criterion: 'Grounded Prompting & RAG Triad Evaluation', max_points: 30, description: 'Strict citation-backed generation and thorough evaluation of faithfulness, answer relevance, and context quality.' }
        ]
      }
    ]
  }
];
