// scripts/data_engineering_math.js
// Courses 12-13: Engineering Mathematics and Linear Algebra, Digital Logic and Computer Organization

export const coursesEngineeringMath = [
  // -------------------------------------------------------------------------
  // 12. Engineering Mathematics and Linear Algebra
  // -------------------------------------------------------------------------
  {
    id: 'd0000000-0000-0000-0000-000000000012',
    title: 'Engineering Mathematics and Linear Algebra',
    slug: 'engineering-mathematics-linear-algebra',
    description: 'Undergraduate engineering mathematics foundation: vector spaces, subspaces, linear independence, matrix factorizations (LU, QR, SVD), eigenvalues and eigenvectors, multivariable calculus, Taylor approximations, and ordinary differential equations.',
    category: 'Engineering & Math',
    level: 'Intermediate',
    thumbnail_url: 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?q=80&w=800&auto=format&fit=crop',
    lessons: [
      {
        id: 'd0000000-0000-0000-0112-000000000001',
        title: 'Vector Spaces, Subspaces, and Linear Independence',
        duration_minutes: 45,
        is_free_preview: true,
        order_index: 1,
        content: `### Learning Objectives
- Define a real vector space $V$ over field $\\mathbb{R}$ and verify the 8 vector space axioms.
- Test whether a subset $W \\subseteq V$ is a valid subspace using closure under vector addition and scalar multiplication.
- Determine linear independence of vector sets and compute the basis and dimension of spans.

### Subspace Test Criterion
A non-empty subset $W \\subseteq V$ is a subspace of $V$ if and only if:
1. The zero vector $\\mathbf{0} \\in W$.
2. For all $u, v \\in W$, $u + v \\in W$ (closed under addition).
3. For all $c \\in \\mathbb{R}$ and $u \\in W$, $c \\cdot u \\in W$ (closed under scalar multiplication).

### Linear Independence and Span
Vectors $\\{v_1, v_2, \\dots, v_k\\}$ are linearly independent if:
$$
c_1 v_1 + c_2 v_2 + \\dots + c_k v_k = \\mathbf{0} \\implies c_1 = c_2 = \\dots = c_k = 0
$$
If any non-trivial linear combination yields $\\mathbf{0}$, at least one vector lies in the span of the others, making the set linearly dependent.

### Matrix Rank and Basis Computation
\`\`\`python
import numpy as np

A = np.array([
    [1, 2, 3],
    [2, 4, 6],
    [1, 1, 1]
])

# Compute rank and singular values
rank = np.linalg.matrix_rank(A)
print(f"Matrix Rank: {rank}") # Outputs 2 (rows 1 and 2 are linearly dependent)
\`\`\`

### Key Takeaways
- The dimension of a subspace is the number of vectors in any of its bases.
- Any set of $k > n$ vectors in $\\mathbb{R}^n$ must be linearly dependent.`
      },
      {
        id: 'd0000000-0000-0000-0112-000000000002',
        title: 'Systems of Linear Equations: Gaussian Elimination and LU Factorization',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 2,
        content: `### Learning Objectives
- Solve systems $A x = b$ using Gaussian elimination with partial pivoting.
- Factor invertible matrix $A$ into lower triangular $L$ and upper triangular $U$ matrices ($P A = L U$).
- Analyze computational complexity and numerical stability in floating-point operations.

### Gaussian Elimination with Partial Pivoting
To solve $A x = b$, row operations transform augmented matrix $[A \\mid b]$ to row echelon form:
1. Row swap ($R_i \\leftrightarrow R_j$).
2. Row scaling ($R_i \\leftarrow c R_i, c \\neq 0$).
3. Row addition ($R_i \\leftarrow R_i + c R_j$).

### LU Decomposition
When elimination requires no row swaps ($A = L U$):
$$
L = \\begin{bmatrix} 1 & 0 & 0 \\\\ l_{21} & 1 & 0 \\\\ l_{31} & l_{32} & 1 \\end{bmatrix}, \\quad
U = \\begin{bmatrix} u_{11} & u_{12} & u_{13} \\\\ 0 & u_{22} & u_{23} \\\\ 0 & 0 & u_{33} \\end{bmatrix}
$$
Solving $A x = b$ becomes two $O(n^2)$ triangular back-substitutions:
1. Solve $L y = b$ (Forward substitution).
2. Solve $U x = y$ (Backward substitution).

### Key Takeaways
- LU decomposition requires $O(\\frac{2}{3} n^3)$ operations once, allowing solving multiple right-hand sides $b$ in only $O(n^2)$ per solve.
- Partial pivoting ($P A = L U$) prevents division by small pivot numbers, maintaining numerical stability against round-off errors.`
      },
      {
        id: 'd0000000-0000-0000-0112-000000000003',
        title: 'The Four Fundamental Subspaces and the Rank-Nullity Theorem',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 3,
        content: `### Learning Objectives
- Identify the four fundamental subspaces of an $m \\times n$ matrix $A$: Column Space $C(A)$, Nullspace $N(A)$, Row Space $C(A^T)$, and Left Nullspace $N(A^T)$.
- State and prove the Rank-Nullity Theorem: $\\text{rank}(A) + \\text{nullity}(A) = n$.
- Establish the fundamental orthogonal complement relations: $C(A^T) \\perp N(A)$ and $C(A) \\perp N(A^T)$.

### Fundamental Subspace Properties
For matrix $A \\in \\mathbb{R}^{m \\times n}$ with rank $r$:
| Subspace | Notation | Ambient Space | Dimension | Orthogonal Complement |
| :--- | :--- | :--- | :--- | :--- |
| Column Space | $C(A)$ | $\\mathbb{R}^m$ | $r$ | $N(A^T)$ in $\\mathbb{R}^m$ |
| Nullspace (Kernel) | $N(A)$ | $\\mathbb{R}^n$ | $n - r$ | $C(A^T)$ in $\\mathbb{R}^n$ |
| Row Space | $C(A^T)$ | $\\mathbb{R}^n$ | $r$ | $N(A)$ in $\\mathbb{R}^n$ |
| Left Nullspace | $N(A^T)$ | $\\mathbb{R}^m$ | $m - r$ | $C(A)$ in $\\mathbb{R}^m$ |

### The Rank-Nullity Theorem
Every vector $x \\in \\mathbb{R}^n$ can be uniquely decomposed into an orthogonal sum:
$$x = x_{\\text{row}} + x_{\\text{null}} \\quad \\text{where} \\quad x_{\\text{row}} \\in C(A^T), \\, x_{\\text{null}} \\in N(A)$$
Applying $A$ maps $x_{\\text{null}}$ to $\\mathbf{0}$ and gives an isomorphism between $C(A^T)$ and $C(A)$.`
      },
      {
        id: 'd0000000-0000-0000-0112-000000000004',
        title: 'Eigenvalues, Eigenvectors, and Matrix Diagonalization',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 4,
        content: `### Learning Objectives
- Solve the characteristic polynomial $\\det(A - \\lambda I) = 0$ to determine eigenvalues.
- Find bases for eigenspaces $N(A - \\lambda I)$.
- Diagonalize square matrices $A = P D P^{-1}$ and compute matrix powers $A^k = P D^k P^{-1}$.
- State the Spectral Theorem for symmetric real matrices ($A = Q \\Lambda Q^T$).

### Characteristic Equation and Eigenspaces
A non-zero vector $v$ is an eigenvector of $A$ with eigenvalue $\\lambda$ if:
$$
A v = \\lambda v \\iff (A - \\lambda I) v = \\mathbf{0}
$$
Nontrivial solutions exist if and only if:
$$
\\det(A - \\lambda I) = 0
$$

### Diagonalizability Condition
An $n \\times n$ matrix $A$ is diagonalizable if and only if it possesses $n$ linearly independent eigenvectors.
If all $n$ eigenvalues are distinct, $A$ is guaranteed diagonalizable.
If algebraic multiplicity exceeds geometric multiplicity for any eigenvalue, $A$ is defective and requires Jordan canonical form.

### The Spectral Theorem
If $A = A^T$ (real symmetric matrix):
1. All eigenvalues $\\lambda_i$ are purely real.
2. Eigenvectors corresponding to distinct eigenvalues are mutually orthogonal.
3. $A$ has an orthonormal basis of eigenvectors: $A = Q \\Lambda Q^T$ with $Q^T Q = I$.`
      },
      {
        id: 'd0000000-0000-0000-0112-000000000005',
        title: 'Orthogonality, Gram-Schmidt Process, and QR Decomposition',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 5,
        content: `### Learning Objectives
- Compute inner products, norms, angles, and orthogonal projections.
- Apply the Gram-Schmidt orthogonalization process to convert an arbitrary basis into an orthonormal basis.
- Factor matrix $A = Q R$ where $Q$ has orthonormal columns and $R$ is upper triangular.

### Gram-Schmidt Algorithm
Given independent vectors $\\{v_1, v_2, \\dots, v_k\\}$:
1. $u_1 = v_1, \\quad e_1 = \\frac{u_1}{\\|u_1\\|}$.
2. $u_2 = v_2 - \\text{proj}_{u_1}(v_2) = v_2 - (v_2 \\cdot e_1) e_1, \\quad e_2 = \\frac{u_2}{\\|u_2\\|}$.
3. In general for step $j$:
   $$u_j = v_j - \\sum_{i=1}^{j-1} (v_j \\cdot e_i) e_i, \\quad e_j = \\frac{u_j}{\\|u_j\\|}$$

### QR Factorization in Least Squares
In overdetermined systems $A x = b$ where $A = Q R$:
$$
A^T A x = A^T b \\implies (R^T Q^T)(Q R) x = R^T Q^T b \\implies R^T R x = R^T Q^T b
$$
Since $R^T$ is invertible:
$$
R x = Q^T b
$$
This solves least squares via backward substitution on $R$ without computing $A^T A$, preserving numerical condition number $\\kappa(R) = \\kappa(A)$.`
      },
      {
        id: 'd0000000-0000-0000-0112-000000000006',
        title: 'Singular Value Decomposition (SVD) and Principal Component Analysis',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 6,
        content: `### Learning Objectives
- Formulate the Singular Value Decomposition $A = U \\Sigma V^T$ for arbitrary rectangular matrices.
- Interpret singular values $\\sigma_i = \\sqrt{\\lambda_i(A^T A)}$ and left/right singular vectors.
- Apply the Eckart-Young-Mirsky Theorem for optimal low-rank matrix approximation.

### Full and Compact SVD Formulation
For any real matrix $A \\in \\mathbb{R}^{m \\times n}$ of rank $r$:
$$
A = U \\Sigma V^T = \\sum_{i=1}^r \\sigma_i u_i v_i^T
$$
- $U \\in \\mathbb{R}^{m \\times m}$: Orthonormal eigenvectors of $A A^T$ (left singular vectors).
- $V \\in \\mathbb{R}^{n \\times n}$: Orthonormal eigenvectors of $A^T A$ (right singular vectors).
- $\\Sigma \\in \\mathbb{R}^{m \\times n}$: Diagonal matrix of non-negative singular values $\\sigma_1 \\ge \\sigma_2 \\ge \\dots \\ge \\sigma_r > 0$.

### Low-Rank Approximation
By Eckart-Young Theorem, the best rank-$k$ approximation ($k < r$) in Frobenius norm is obtained by truncating to the top $k$ singular values:
$$
A_k = \\sum_{i=1}^k \\sigma_i u_i v_i^T, \\quad \\|A - A_k\\|_F = \\sqrt{\\sum_{i=k+1}^r \\sigma_i^2}
$$
This forms the foundational backbone of data compression, latent semantic indexing, and image denoising.`
      },
      {
        id: 'd0000000-0000-0000-0112-000000000007',
        title: 'Multivariable Calculus: Gradients, Jacobians, Hessians, and Optimization',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 7,
        content: `### Learning Objectives
- Calculate directional derivatives and gradient vectors $\\nabla f(x)$.
- Assemble the Jacobian matrix $J \\in \\mathbb{R}^{m \\times n}$ for vector-valued functions and apply the multivariable Chain Rule.
- Compute the Hessian matrix $H \\in \\mathbb{R}^{n \\times n}$ and classify critical points using eigenvalues of $H$.

### Gradient and Directional Derivative
For scalar field $f: \\mathbb{R}^n \\to \\mathbb{R}$, the gradient is the vector of partial derivatives:
$$\\nabla f(x) = \\begin{bmatrix} \\frac{\\partial f}{\\partial x_1} & \\frac{\\partial f}{\\partial x_2} & \\dots & \\frac{\\partial f}{\\partial x_n} \\end{bmatrix}^T$$
The directional derivative along unit vector $u$ is $D_u f(x) = \\nabla f(x) \\cdot u$. The gradient points in the direction of steepest ascent.

### Hessian Matrix and Second Derivative Test
The Hessian matrix contains all second-order partial derivatives:
$$H_{ij} = \\frac{\\partial^2 f}{\\partial x_i \\partial x_j}$$
At a critical point $x^*$ where $\\nabla f(x^*) = \\mathbf{0}$:
1. If $H(x^*)$ is **positive definite** (all $\\lambda_i > 0$): strict local minimum.
2. If $H(x^*)$ is **negative definite** (all $\\lambda_i < 0$): strict local maximum.
3. If $H(x^*)$ has both positive and negative eigenvalues: **saddle point**.`
      }
    ],
    quizzes: [
      {
        id: 'd0000000-0000-0000-0212-000000000001',
        title: 'Quiz 1: Vector Spaces, Independence, and Elimination',
        passing_score: 75,
        order_index: 1,
        questions: [
          {
            id: 'd0000000-0000-0000-0312-000000000001',
            question_text: 'Which of the following subsets of R^3 is a valid vector subspace?',
            options: ['The set of all vectors (x, y, z) such that x + y + z = 1', 'The set of all vectors (x, y, z) such that 2x - 3y + z = 0', 'The set of all vectors (x, y, z) such that x >= 0', 'The set of all vectors (x, y, z) such that x^2 + y^2 = z^2'],
            correct_option_index: 1,
            explanation: 'The plane 2x - 3y + z = 0 passes through the origin (0, 0, 0) and is closed under addition and scalar multiplication, making it a 2D subspace.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000002',
            question_text: 'If a set contains 4 vectors in R^3, what can be concluded about their linear independence?',
            options: ['They must be linearly independent', 'They must be linearly dependent because the number of vectors exceeds the dimension of the space', 'They form an orthonormal basis for R^3', 'Their span is at most 2-dimensional'],
            correct_option_index: 1,
            explanation: 'In any vector space of dimension n, any collection of k > n vectors is guaranteed to be linearly dependent.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000003',
            question_text: 'What is the computational complexity of Gaussian elimination on an n x n dense matrix?',
            options: ['O(n)', 'O(n * log n)', 'O(n^2)', 'O(n^3)'],
            correct_option_index: 3,
            explanation: 'Gaussian elimination performs approximately (2/3) n^3 floating point additions and multiplications to reduce an n x n matrix to upper triangular form.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000004',
            question_text: 'In LU decomposition A = L U, what type of matrix is L?',
            options: ['Unit lower triangular matrix (ones on diagonal, zeros above)', 'Symmetric positive definite matrix', 'Orthogonal matrix', 'Diagonal matrix'],
            correct_option_index: 0,
            explanation: 'L is a unit lower triangular matrix where diagonal entries are 1 and entries above the main diagonal are strictly 0.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000005',
            question_text: 'Why is partial pivoting used during Gaussian elimination?',
            options: ['To ensure the resulting matrix is diagonal', 'To avoid division by zero or very small numbers, minimizing floating-point round-off error', 'To reduce the time complexity from O(n^3) to O(n^2)', 'To eliminate the need for back-substitution'],
            correct_option_index: 1,
            explanation: 'Partial pivoting swaps rows to place the largest available magnitude element on the pivot diagonal, preventing catastrophic cancellation and error magnification.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000006',
            question_text: 'What does it mean if det(A) = 0 for an n x n square matrix A?',
            options: ['The matrix is invertible', 'The matrix has full rank n', 'The columns of A are linearly dependent and the matrix is singular', 'All eigenvalues of A must equal zero'],
            correct_option_index: 2,
            explanation: 'A determinant of zero indicates that the matrix has rank < n, its rows/columns are linearly dependent, and it has no multiplicative inverse.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000007',
            question_text: 'Once an n x n matrix A is decomposed into L and U, how many operations are required to solve A x = b for a new vector b?',
            options: ['O(n^3)', 'O(n^2) via forward and back substitution', 'O(n)', 'O(1)'],
            correct_option_index: 1,
            explanation: 'Solving L y = b takes n^2 / 2 operations and U x = y takes n^2 / 2 operations, totaling O(n^2) back-substitution steps.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0212-000000000002',
        title: 'Quiz 2: Fundamental Subspaces and the Rank-Nullity Theorem',
        passing_score: 75,
        order_index: 2,
        questions: [
          {
            id: 'd0000000-0000-0000-0312-000000000008',
            question_text: 'For an m x n matrix A with rank r, what is the dimension of the nullspace N(A)?',
            options: ['r', 'm - r', 'n - r', 'n'],
            correct_option_index: 2,
            explanation: 'By the Rank-Nullity Theorem, rank(A) + nullity(A) = n (number of columns), so dim(N(A)) = n - r.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000009',
            question_text: 'What is the orthogonal complement of the row space C(A^T) in R^n?',
            options: ['Column space C(A)', 'Nullspace N(A)', 'Left nullspace N(A^T)', 'Span of all eigenvectors'],
            correct_option_index: 1,
            explanation: 'Every vector in the nullspace satisfies A x = 0, meaning x is orthogonal to every row vector of A. Thus C(A^T) and N(A) are orthogonal complements.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000010',
            question_text: 'If a 5 x 7 matrix has rank 4, what is the dimension of its left nullspace N(A^T)?',
            options: ['1', '3', '4', '7'],
            correct_option_index: 0,
            explanation: 'Left nullspace lies in R^m (where m=5). Its dimension is m - r = 5 - 4 = 1.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000011',
            question_text: 'When does a linear system A x = b have at least one solution?',
            options: ['When b lies in the nullspace N(A)', 'When b lies in the column space C(A)', 'When the rank of A is 0', 'When m > n strictly'],
            correct_option_index: 1,
            explanation: 'A x is a linear combination of the columns of A. Therefore, A x = b is solvable if and only if b belongs to the column space C(A).'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000012',
            question_text: 'If matrix A has full column rank (rank = n), what is the nullspace N(A)?',
            options: ['R^n', 'Only the zero vector {0}', 'A line passing through the origin', 'The row space'],
            correct_option_index: 1,
            explanation: 'When rank = n, nullity = n - r = 0, meaning the only solution to A x = 0 is the trivial solution x = 0.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000013',
            question_text: 'What is always true regarding the dimension of the row space and column space of any m x n matrix?',
            options: ['dim(C(A)) > dim(C(A^T)) if m > n', 'dim(C(A)) = dim(C(A^T)) = rank(A)', 'dim(C(A)) + dim(C(A^T)) = m + n', 'dim(C(A)) is independent of row operations'],
            correct_option_index: 1,
            explanation: 'Row rank always equals column rank for any real matrix, both being identical to rank(A).'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000014',
            question_text: 'What does the Fredholm Alternative state regarding linear systems A x = b?',
            options: ['Either A x = b has a solution, or there exists y such that A^T y = 0 and y^T b != 0', 'Every matrix has at least one real eigenvalue', 'All symmetric matrices are invertible', 'Nullspaces always have higher dimension than column spaces'],
            correct_option_index: 0,
            explanation: 'The Fredholm Alternative states that exactly one of the two holds: either b in C(A), or b is not orthogonal to N(A^T).'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0212-000000000003',
        title: 'Quiz 3: Eigenvalues, Diagonalization, and QR Factorization',
        passing_score: 75,
        order_index: 3,
        questions: [
          {
            id: 'd0000000-0000-0000-0312-000000000015',
            question_text: 'If A is a real symmetric matrix (A = A^T), what guarantees does the Spectral Theorem provide?',
            options: ['All eigenvalues are strictly complex numbers', 'All eigenvalues are real, and there exists an orthonormal basis of eigenvectors', 'The determinant of A is always 1', 'The matrix has no inverse'],
            correct_option_index: 1,
            explanation: 'The Spectral Theorem states that any real symmetric matrix can be orthogonally diagonalized as A = Q Lambda Q^T with purely real eigenvalues and orthonormal eigenvectors Q.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000016',
            question_text: 'If matrix A is diagonalized as A = P D P^(-1), what is the formula for matrix power A^k?',
            options: ['A^k = P^k * D * P^(-k)', 'A^k = P * D^k * P^(-1)', 'A^k = k * P * D * P^(-1)', 'A^k = D^k'],
            correct_option_index: 1,
            explanation: 'A^k = (P D P^(-1))(P D P^(-1))...(P D P^(-1)) = P D^k P^(-1), where D^k simply raises each diagonal eigenvalue to the power k.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000017',
            question_text: 'What property characterizes an orthogonal matrix Q?',
            options: ['Q^T = Q^(-1) and Q^T Q = I', 'det(Q) = 0', 'All diagonal entries of Q must be 0', 'Q has only positive eigenvalues'],
            correct_option_index: 0,
            explanation: 'An orthogonal matrix has mutually orthonormal columns, satisfying Q^T Q = I, which implies Q^(-1) = Q^T.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000018',
            question_text: 'In the QR decomposition A = Q R, what are the properties of matrices Q and R?',
            options: ['Q is lower triangular, R is diagonal', 'Q has orthonormal columns (Q^T Q = I) and R is an upper triangular invertible matrix', 'Q and R are both symmetric matrices', 'Q is a permutation matrix and R is a scalar'],
            correct_option_index: 1,
            explanation: 'QR decomposition factors matrix A into orthogonal matrix Q (preserving norms and angles) and upper-triangular matrix R.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000019',
            question_text: 'What is the sum of all eigenvalues of an n x n matrix A equal to?',
            options: ['Determinant det(A)', 'Trace tr(A) (sum of diagonal elements)', 'Matrix rank', 'Condition number'],
            correct_option_index: 1,
            explanation: 'The trace of any square matrix equals the sum of its eigenvalues: sum(lambda_i) = tr(A).'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000020',
            question_text: 'What is the product of all eigenvalues of an n x n matrix A equal to?',
            options: ['Determinant det(A)', 'Trace tr(A)', 'Frobenius norm', 'Spectral radius'],
            correct_option_index: 0,
            explanation: 'The product of all eigenvalues of a matrix is equal to its determinant: prod(lambda_i) = det(A).'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000021',
            question_text: 'What occurs during the Gram-Schmidt process if a candidate vector vk is a linear combination of the preceding vectors?',
            options: ['The algorithm crashes', 'The orthogonalized vector uk evaluates to the zero vector 0', 'The resulting vector has infinite length', 'The previous vectors are inverted'],
            correct_option_index: 1,
            explanation: 'Subtracting all orthogonal projections leaves zero if the vector lies entirely within the span of earlier vectors.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0212-000000000004',
        title: 'Quiz 4: SVD, Multivariable Optimization, and Calculus',
        passing_score: 75,
        order_index: 4,
        questions: [
          {
            id: 'd0000000-0000-0000-0312-000000000022',
            question_text: 'In Singular Value Decomposition A = U Sigma V^T, what are the singular values sigma_i?',
            options: ['The diagonal entries of A', 'The square roots of the eigenvalues of A^T A (or A A^T)', 'The complex roots of det(A - lambda I)', 'The row sums of matrix V'],
            correct_option_index: 1,
            explanation: 'Singular values are the non-negative square roots of the eigenvalues of A^T A, sorted in descending order: sigma_i = sqrt(lambda_i(A^T A)).'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000023',
            question_text: 'According to the Eckart-Young-Mirsky Theorem, what provides the optimal rank-k approximation of a matrix A under Frobenius norm?',
            options: ['Setting the last k rows of A to 0', 'Truncating the SVD expansion to the first k largest singular values: sum_{i=1}^k sigma_i u_i v_i^T', 'Running k steps of Gram-Schmidt', 'The LU factorization'],
            correct_option_index: 1,
            explanation: 'Retaining the top k singular components minimizes reconstruction error in both Frobenius norm and spectral norm.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000024',
            question_text: 'At a critical point x* where grad f(x*) = 0, what does it mean if the Hessian matrix H(x*) has both strictly positive and strictly negative eigenvalues?',
            options: ['x* is a local minimum', 'x* is a local maximum', 'x* is a saddle point', 'f is constant everywhere'],
            correct_option_index: 2,
            explanation: 'If the Hessian is indefinite (possessing eigenvalues of conflicting signs), moving along some directions increases f while others decrease f, identifying a saddle point.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000025',
            question_text: 'In which direction does the gradient vector grad f(x) point at any point x?',
            options: ['Tangent to the level surface f(x) = c', 'In the direction of steepest rate of increase of f(x)', 'Towards the origin (0, 0)', 'Perpendicular to the normal vector of the tangent plane'],
            correct_option_index: 1,
            explanation: 'By the Cauchy-Schwarz inequality, the directional derivative D_u f = grad f . u is maximized when u points in the exact direction of grad f.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000026',
            question_text: 'What is the condition number kappa(A) of an invertible matrix in the 2-norm in terms of singular values?',
            options: ['sigma_1 + sigma_n', 'sigma_1 / sigma_n (ratio of largest to smallest singular value)', 'sigma_1 * sigma_n', 'det(Sigma)'],
            correct_option_index: 1,
            explanation: 'The 2-norm condition number is kappa(A) = ||A||_2 ||A^(-1)||_2 = sigma_max / sigma_min, measuring sensitivity of linear solutions to input perturbations.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000027',
            question_text: 'What matrix contains all first-order partial derivatives of a vector-valued function f: R^n -> R^m?',
            options: ['The Hessian matrix', 'The Jacobian matrix J in R^(m x n)', 'The Gram matrix', 'The Covariance matrix'],
            correct_option_index: 1,
            explanation: 'The Jacobian matrix J has entries J_ij = d f_i / d x_j, representing the best linear approximation of multivariable map f near x.'
          },
          {
            id: 'd0000000-0000-0000-0312-000000000028',
            question_text: 'How does the Moore-Penrose pseudoinverse A^+ relate to SVD A = U Sigma V^T?',
            options: ['A^+ = U Sigma V^T', 'A^+ = V Sigma^+ U^T where Sigma^+ contains reciprocals 1/sigma_i of non-zero singular values', 'A^+ = (A^T A)^(-1)', 'A^+ = U^T V'],
            correct_option_index: 1,
            explanation: 'A^+ = V Sigma^+ U^T computes the minimal-norm least-squares solution x = A^+ b for any rectangular or rank-deficient matrix.'
          }
        ]
      }
    ],
    assignments: [
      {
        id: 'd0000000-0000-0000-0412-000000000001',
        title: 'Assignment 1: Matrix Factorization & Numerical Linear Solvers',
        description: `Implement and analyze foundational linear algebra factorizations in Python using NumPy:
1. **LU Factorization with Partial Pivoting:**
   - Implement $P A = L U$ from scratch without calling scipy.linalg.lu.
   - Implement forward substitution ($L y = P b$) and back substitution ($U x = y$).
   - Test on ill-conditioned Hilbert matrices $H_{ij} = \\frac{1}{i + j - 1}$ for $n = 4, 8, 12$, reporting residual norm $\\|A x - b\\|$ and backward error.
2. **QR Factorization:**
   - Implement Modified Gram-Schmidt (MGS) to produce orthonormal $Q$ and upper-triangular $R$.
   - Implement Householder reflections for QR decomposition and compare numerical orthogonality error $\\|Q^T Q - I\\|_F$ against MGS.
3. **Application to Overdetermined Linear Systems:**
   - Fit high-degree polynomials ($d = 1$ to $8$) to noisy sensor data using both Normal Equations $(A^T A x = A^T b)$ and QR factorization ($R x = Q^T b$).
   - Demonstrate the condition number squaring effect $\\kappa(A^T A) = \\kappa(A)^2$ and explain why QR is numerically superior.`,
        due_date: '2026-11-20T23:59:59Z',
        rubric: [
          { criterion: 'LU with Pivoting Implementation', max_points: 25, description: 'Correct row swapping, permutation matrix tracking, and stable forward/backward solves.' },
          { criterion: 'Gram-Schmidt vs Householder QR', max_points: 30, description: 'Accurate implementation of both methods with orthogonality comparison and stability analysis.' },
          { criterion: 'Least Squares & Condition Number Study', max_points: 25, description: 'Demonstration of condition number squaring and numerical stability on polynomial fitting.' },
          { criterion: 'Code Quality & Error Analysis', max_points: 20, description: 'Clean vectorization, residual reporting, and mathematical rigor in analytical explanations.' }
        ]
      },
      {
        id: 'd0000000-0000-0000-0412-000000000002',
        title: 'Assignment 2: SVD Image Compression and Eigenface Face Recognition',
        description: `Build an image analysis and recognition engine powered by Singular Value Decomposition and Eigendecomposition:
1. **Low-Rank Image Compression via SVD:**
   - Load high-resolution grayscale and RGB photographs.
   - Compute full SVD $A = U \\Sigma V^T$.
   - Reconstruct images using rank $k \\in \\{5, 20, 50, 100\\}$.
   - Plot energy retention ratio $\\frac{\\sum_{i=1}^k \\sigma_i^2}{\\sum_{i=1}^r \\sigma_i^2}$ and Structural Similarity Index (SSIM) versus compression ratio.
2. **Eigenfaces Implementation:**
   - Load the Olivetti or LFW face dataset ($N$ images of size $h \\times w$).
   - Flatten images to vectors in $\\mathbb{R}^D$ and compute mean face $\\Psi$ and centered matrix $\\Phi$.
   - Calculate eigenvectors of covariance matrix using the snapshot trick (eigendecomposition of $\\Phi^T \\Phi$ in $O(N^3)$ rather than $\\Phi \\Phi^T$ in $O(D^3)$).
   - Display top 10 eigenfaces (principal directions).
   - Project faces onto $K$ eigenface components and build a K-Nearest Neighbor (KNN) classifier, evaluating classification accuracy vs number of retained components.`,
        due_date: '2026-11-29T23:59:59Z',
        rubric: [
          { criterion: 'SVD Compression & Energy Analysis', max_points: 25, description: 'Correct truncated SVD image reconstruction, energy preservation curves, and SSIM metrics.' },
          { criterion: 'Snapshot Trick Formulation', max_points: 25, description: 'Mathematical derivation and computational implementation of snapshot covariance trick.' },
          { criterion: 'Eigenface Visualization & Projection', max_points: 25, description: 'Accurate visualization of mean face and eigenfaces, and subspace projection coordinates.' },
          { criterion: 'Face Recognition Performance', max_points: 25, description: 'Systematic evaluation of KNN recognition accuracy across varying number of eigencomponents.' }
        ]
      }
    ]
  },

  // -------------------------------------------------------------------------
  // 13. Digital Logic and Computer Organization
  // -------------------------------------------------------------------------
  {
    id: 'd0000000-0000-0000-0000-000000000013',
    title: 'Digital Logic and Computer Organization',
    slug: 'digital-logic-computer-organization',
    description: 'Hardware engineering from boolean gates to microarchitecture: Boolean algebra, Karnaugh maps, combinational logic (Adders, Multiplexers, ALUs), sequential circuits (Flip-Flops, FSMs), RISC-V instruction set architecture, 5-stage classic pipeline, hazard mitigation, and cache memory hierarchy.',
    category: 'Engineering & Math',
    level: 'Intermediate',
    thumbnail_url: 'https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=800&auto=format&fit=crop',
    lessons: [
      {
        id: 'd0000000-0000-0000-0113-000000000001',
        title: 'Boolean Algebra, Logic Gates, and Karnaugh Map Minimization',
        duration_minutes: 45,
        is_free_preview: true,
        order_index: 1,
        content: `### Learning Objectives
- Apply Boolean algebraic identities and De Morgan's laws: $\\overline{A \\cdot B} = \\bar{A} + \\bar{B}$ and $\\overline{A + B} = \\bar{A} \\cdot \\bar{B}$.
- Synthesize Sum-of-Products (SOP) and Product-of-Sums (POS) canonical expressions from truth tables.
- Minimize 3-variable and 4-variable boolean functions using Karnaugh Maps (K-Maps) and identify prime implicants.

### Universal Gates
NAND and NOR gates are **universal**: any boolean function can be realized using solely NAND gates or solely NOR gates.
For example, inverter via NAND: $\\bar{A} = A \\text{ NAND } A$. AND gate via NAND: $A \\cdot B = (A \\text{ NAND } B) \\text{ NAND } (A \\text{ NAND } B)$.

### 4-Variable K-Map Structure
Adjacency is preserved using Gray code ordering (only one bit changes per cell):

\`\`\`
       CD
  AB   00   01   11   10
  00 [ m0 | m1 | m3 | m2 ]
  01 [ m4 | m5 | m7 | m6 ]
  11 [ m12| m13| m15| m14]
  10 [ m8 | m9 | m11| m10]
\`\`\`

Grouping rules:
- Groups must contain $2^k$ cells (1, 2, 4, 8, or 16).
- Groups must be rectangular and wrap around edges/corners (toroidal topology).
- Don't Care conditions ($d$) can be treated as 1 if they enlarge groups, or 0 otherwise.`
      },
      {
        id: 'd0000000-0000-0000-0113-000000000002',
        title: 'Combinational Logic: Adders, Decoders, Multiplexers, and Arithmetic Logic Units',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 2,
        content: `### Learning Objectives
- Design Half Adders and Full Adders, and contrast Ripple-Carry Adders with Carry-Lookahead Adders (CLA).
- Construct Decoders ($n$-to-$2^n$) and Multiplexers ($2^n$-to-1) as universal logic modules.
- Assemble a modular 32-bit Arithmetic Logic Unit (ALU) supporting ADD, SUB, AND, OR, SLT, and zero-detection.

### Ripple-Carry Adder vs Carry-Lookahead Adder (CLA)
In an $N$-bit Ripple-Carry Adder, carry bits ripple sequentially from LSB to MSB, resulting in $O(N)$ propagation delay.

Carry-Lookahead Adders compute carries in $O(\\log N)$ time using generate ($G_i$) and propagate ($P_i$) terms:
$$G_i = A_i \\cdot B_i, \\quad P_i = A_i \\oplus B_i$$
$$C_1 = G_0 + P_0 C_0$$
$$C_2 = G_1 + P_1 G_0 + P_1 P_0 C_0$$
$$C_3 = G_2 + P_2 G_1 + P_2 P_1 G_0 + P_2 P_1 P_0 C_0$$
$$C_4 = G_3 + P_3 G_2 + P_3 P_2 G_1 + P_3 P_2 P_1 G_0 + P_3 P_2 P_1 P_0 C_0$$

### Multiplexer Implementation
An 8-to-1 MUX selects one of 8 input lines $I_0 \\dots I_7$ based on 3 select lines $S_2 S_1 S_0$:
$$Y = \\sum_{k=0}^7 I_k \\cdot m_k(S_2, S_1, S_0)$$`
      },
      {
        id: 'd0000000-0000-0000-0113-000000000003',
        title: 'Sequential Circuits: Latches, Flip-Flops, Registers, and Counters',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 3,
        content: `### Learning Objectives
- Compare level-sensitive SR / D latches with edge-triggered D flip-flops and JK flip-flops.
- Analyze timing constraints: setup time ($t_{setup}$), hold time ($t_{hold}$), and propagation delay ($t_{clk-q}$).
- Design synchronous sequential counters, shift registers, and ring counters.

### Edge-Triggered D Flip-Flop
\`\`\`
          +-----------------+
    D --->| D             Q |---> Q
          |                 |
  CLK --->|>           Q_bar|---> Q_bar
          +-----------------+
\`\`\`

### Timing Parameters & Maximum Clock Frequency
For reliable operation without metastability:
1. **Setup time ($t_{su}$):** Minimum duration data input $D$ must remain stable before the active clock edge.
2. **Hold time ($t_h$):** Minimum duration data input $D$ must remain stable after the active clock edge.
3. **Maximum Clock Frequency:**
   $$T_{clk} \\ge t_{clk-q} + t_{comb} + t_{su}$$
   $$f_{max} = \\frac{1}{T_{clk}} = \\frac{1}{t_{clk-q} + t_{comb} + t_{su}}$$`
      },
      {
        id: 'd0000000-0000-0000-0113-000000000004',
        title: 'Finite State Machines (FSM): Moore vs Mealy Machine Synthesis',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 4,
        content: `### Learning Objectives
- Model sequential behavior using state transition diagrams and state tables.
- Distinguish Moore machines (outputs depend solely on current state) from Mealy machines (outputs depend on current state and current inputs).
- Execute state reduction using partition equivalence and implement excitation equations for D flip-flops.

### Moore vs Mealy Architecture
\`\`\`
Moore: Next State Logic -> State Register -> Output Logic -> Output
                           (Flip-Flops)

Mealy: Inputs --------------------------------------------+
         |                                                v
       Next State Logic -> State Register -------------> Output Logic -> Output
\`\`\`

### Comparison
| Feature | Moore Machine | Mealy Machine |
| :--- | :--- | :--- |
| Output Dependency | Current state only | Current state AND current input |
| Glitch Susceptibility | Resistant to input glitches (synchronized to clock) | Susceptible to asynchronous input glitches |
| State Count | Generally requires more states | Often requires fewer states for identical sequence detection |
| Timing Response | Output changes one clock cycle later | Output changes immediately when input transitions |`
      },
      {
        id: 'd0000000-0000-0000-0113-000000000005',
        title: 'Instruction Set Architecture (ISA): RISC-V 32-Bit Integer Core (RV32I)',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 5,
        content: `### Learning Objectives
- Master the RISC design philosophy vs CISC (fixed-length instructions, load-store architecture).
- Dissect the RISC-V 32-bit (RV32I) instruction formats: R-type, I-type, S-type, B-type, U-type, and J-type.
- Trace assembly instruction encoding, register conventions (x0=zero, ra, sp, a0-a7, t0-t6), and immediate sign-extension.

### RV32I Instruction Formats (32 bits)
\`\`\`
R-type: [ funct7 (7) | rs2 (5) | rs1 (5) | funct3 (3) | rd (5) | opcode (7) ] -> add, sub, and
I-type: [      imm[11:0] (12)  | rs1 (5) | funct3 (3) | rd (5) | opcode (7) ] -> addi, lw, jalr
S-type: [ imm[11:5]  | rs2 (5) | rs1 (5) | funct3 (3) | imm[4:0]| opcode (7) ] -> sw, sb
B-type: [ imm[12|10:5]| rs2 (5)| rs1 (5) | funct3 (3) | imm[4:1|11]| op (7) ] -> beq, bne
U-type: [             imm[31:12] (20)                 | rd (5) | opcode (7) ] -> lui, auipc
J-type: [         imm[20|10:1|11|19:12] (20)          | rd (5) | opcode (7) ] -> jal
\`\`\`

### Key Architecture Invariants
- Fixed 32-bit instruction length simplifies instruction fetch and alignment.
- Register $x0$ is hardwired to constant zero ($0$). Writes to $x0$ are discarded.
- Only dedicated load and store instructions access main memory.`
      },
      {
        id: 'd0000000-0000-0000-0113-000000000006',
        title: 'Pipelined Processor Architecture: 5 Stages, Hazards, and Forwarding',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 6,
        content: `### Learning Objectives
- Trace the classic 5-stage RISC processor pipeline: IF (Instruction Fetch), ID (Decode), EX (Execute), MEM (Memory), WB (Writeback).
- Classify and resolve Structural, Data (RAW, WAR, WAW), and Control hazards.
- Implement Data Forwarding (bypassing) and pipeline stalling (bubbles) for Load-Use hazards.

### The 5 Classic Pipeline Stages
\`\`\`
Clock:     1     2     3     4     5     6     7
Inst 1:  [IF]  [ID]  [EX]  [MEM] [WB]
Inst 2:        [IF]  [ID]  [EX]  [MEM] [WB]
Inst 3:              [IF]  [ID]  [EX]  [MEM] [WB]
\`\`\`

### Hazard Categories & Mitigations
1. **Structural Hazards:** Resource conflict (e.g. unified memory accessed simultaneously for instruction fetch and data read/write). Resolved via separate Harvard L1 I-Cache and D-Cache.
2. **Data Hazards (Read-After-Write - RAW):** An instruction depends on the result of a prior instruction still in the pipeline. Resolved via **Forwarding** from EX/MEM or MEM/WB pipeline registers directly to ALU inputs.
3. **Load-Use Data Hazard:** Forwarding cannot travel backward in time when a load is immediately followed by a dependent instruction. Requires inserting 1 cycle **Stall** (bubble).
4. **Control Hazards (Branching):** Branch decision computed in EX stage causes 2 stalled cycles. Resolved via Dynamic Branch Prediction (2-bit saturating counters, Branch Target Buffers).`
      },
      {
        id: 'd0000000-0000-0000-0113-000000000007',
        title: 'Memory Hierarchy: Direct-Mapped, Set-Associative Caches, and Virtual Memory',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 7,
        content: `### Learning Objectives
- Analyze temporal and spatial locality principles governing cache memory design.
- Map memory addresses into Tag, Index, and Block Offset fields for Direct-Mapped and Set-Associative caches.
- Evaluate cache write policies (Write-Through vs Write-Back, Write-Allocate vs No-Write-Allocate).
- Compute Average Memory Access Time (AMAT) and trace Virtual Memory page table address translation.

### Address Decomposition for Set-Associative Cache
Let address be 32 bits, cache capacity $C = 32\\text{ KB}$, block size $B = 64\\text{ bytes}$, and associativity $N = 4$-way:
- Number of blocks: $\\frac{32 \\times 1024}{64} = 512$ blocks.
- Number of sets: $S = \\frac{512}{4} = 128$ sets.
- Block Offset bits: $\\log_2(64) = 6$ bits.
- Index bits: $\\log_2(128) = 7$ bits.
- Tag bits: $32 - 7 - 6 = 19$ bits.

\`\`\`
Address: [ Tag: 19 bits | Set Index: 7 bits | Block Offset: 6 bits ]
\`\`\`

### Average Memory Access Time (AMAT)
$$
\\text{AMAT} = \\text{Hit Time} + (\\text{Miss Rate} \\times \\text{Miss Penalty})
$$
Multi-level caches reduce miss penalty:
$$\\text{AMAT} = H_1 + M_1 \\times (H_2 + M_2 \\times \\text{Memory Penalty})$$`
      }
    ],
    quizzes: [
      {
        id: 'd0000000-0000-0000-0213-000000000001',
        title: 'Quiz 1: Boolean Algebra, Gates, and K-Maps',
        passing_score: 75,
        order_index: 1,
        questions: [
          {
            id: 'd0000000-0000-0000-0313-000000000001',
            question_text: 'According to De Morgan\'s Laws, what is the boolean complement of (A + B * C)?',
            options: ['A_bar * (B_bar + C_bar)', 'A_bar + B_bar * C_bar', 'A_bar * B_bar * C_bar', '(A_bar + B_bar) * C_bar'],
            correct_option_index: 0,
            explanation: 'Complement of (A + X) is A_bar * X_bar. Here X = B * C, so X_bar = B_bar + C_bar, yielding A_bar * (B_bar + C_bar).'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000002',
            question_text: 'Why are NAND and NOR gates classified as universal logic gates?',
            options: ['They operate at higher clock speeds than other gates', 'Any arbitrary Boolean function can be implemented using exclusively NAND or exclusively NOR gates', 'They have zero propagation delay', 'They do not require power or ground connections'],
            correct_option_index: 1,
            explanation: 'NAND and NOR gates can implement INVERTER, AND, and OR operations, making them sufficient to realize any possible truth table.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000003',
            question_text: 'In a 4-variable Karnaugh Map, how many cells must a valid grouping contain?',
            options: ['Any multiple of 3', 'A power of two: 1, 2, 4, 8, or 16 cells', 'Exactly 4 cells only', 'Any number of adjacent square cells'],
            correct_option_index: 1,
            explanation: 'K-map grouping eliminates variables based on boolean theorem x + x_bar = 1. Combining 2^k adjacent cells eliminates k boolean variables.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000004',
            question_text: 'What code ordering is utilized on the axes of Karnaugh maps to guarantee that adjacent cells differ by only one variable?',
            options: ['Standard Binary Code', 'Gray Code', 'BCD (Binary Coded Decimal)', 'Two\'s Complement'],
            correct_option_index: 1,
            explanation: 'Gray code (00, 01, 11, 10) ensures that horizontally or vertically adjacent cells differ by exactly one bit, enabling algebraic simplification.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000005',
            question_text: 'What is an essential prime implicant in a Karnaugh map?',
            options: ['A prime implicant that covers at least one minterm that is not covered by any other prime implicant', 'A group that contains all 16 cells', 'A group that covers only Don\'t Care conditions', 'The group with the smallest number of cells'],
            correct_option_index: 0,
            explanation: 'An essential prime implicant covers a 1-cell that cannot be included in any alternative prime implicant grouping, requiring its inclusion in the minimal SOP expression.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000006',
            question_text: 'What is the canonical Sum-of-Products (SOP) form composed of?',
            options: ['OR of maxterms', 'OR of minterms (AND terms containing every variable in complemented or uncomplemented form)', 'AND of maxterms', 'Exclusive-OR of product terms'],
            correct_option_index: 1,
            explanation: 'Canonical SOP sums all minterms for which the boolean function evaluates to logic 1.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000007',
            question_text: 'What simplification does the consensus theorem A B + A_bar C + B C yield?',
            options: ['A B + A_bar C', 'B C', 'A + B + C', 'A B C'],
            correct_option_index: 0,
            explanation: 'By the consensus theorem, the third term B C is redundant because if B and C are 1, either A=1 (making AB=1) or A=0 (making A_bar C=1).'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0213-000000000002',
        title: 'Quiz 2: Combinational Logic and Arithmetic Circuits',
        passing_score: 75,
        order_index: 2,
        questions: [
          {
            id: 'd0000000-0000-0000-0313-000000000008',
            question_text: 'What are the outputs of a 1-bit Full Adder with inputs A, B, and Carry-in Cin?',
            options: ['Sum = A + B + Cin; Carry = A * B * Cin', 'Sum = A xor B xor Cin; Carry = (A * B) + (Cin * (A xor B))', 'Sum = A xor B; Carry = A * B', 'Sum = A * B * Cin; Carry = A + B + Cin'],
            correct_option_index: 1,
            explanation: 'The sum bit evaluates odd parity (A xor B xor Cin) and the carry-out is generated if at least two of the three inputs are 1: AB + Cin(A xor B).'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000009',
            question_text: 'Why does a Carry-Lookahead Adder (CLA) compute additions much faster than a Ripple-Carry Adder for 64-bit operands?',
            options: ['CLA eliminates full adder logic', 'CLA generates all stage carries simultaneously in O(log N) depth using propagate and generate equations rather than waiting for serial rippling', 'CLA uses analog operational amplifiers', 'CLA operates in the frequency domain'],
            correct_option_index: 1,
            explanation: 'In ripple adders, worst-case latency scales as O(N) due to carry propagation. CLA calculates all carries in parallel using Gi = Ai Bi and Pi = Ai xor Bi.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000010',
            question_text: 'How many select input lines are required for a 32-to-1 Multiplexer?',
            options: ['4', '5', '8', '32'],
            correct_option_index: 1,
            explanation: 'A 2^n to 1 multiplexer requires n select lines. Since 2^5 = 32, exactly 5 select lines are required.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000011',
            question_text: 'What is the function of an n-to-2^n binary decoder with an active-high enable input?',
            options: ['It converts 2^n analog inputs into n digital outputs', 'It asserts exactly one of 2^n output lines corresponding to the binary value represented by the n input lines', 'It adds n binary numbers together', 'It stores n bits of data on the clock edge'],
            correct_option_index: 1,
            explanation: 'An n-to-2^n decoder activates the specific output line corresponding to the decimal value of the n-bit input code.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000012',
            question_text: 'How can an adder circuit perform subtraction A - B using two\'s complement arithmetic?',
            options: ['By swapping inputs A and B', 'By inverting all bits of B (one\'s complement) and asserting Carry-In Cin = 1', 'By shifting bits of B left by 1 position', 'By dividing B by 2'],
            correct_option_index: 1,
            explanation: 'In two\'s complement, -B = ~B + 1. Feeding ~B into the adder with Cin=1 computes A + (~B + 1) = A - B.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000013',
            question_text: 'What logic circuit detects if an ALU output vector of 32 bits is exactly equal to zero?',
            options: ['A 32-input AND gate', 'A NOR gate combining all 32 output bits', 'An XOR tree', 'A 32-bit register'],
            correct_option_index: 1,
            explanation: 'If any output bit is 1, an OR gate outputs 1. Inverting this via a NOR gate yields 1 if and only if all 32 output bits are 0.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000014',
            question_text: 'What is a tri-state buffer?',
            options: ['A gate with three outputs', 'A digital buffer with an enable control that can output Logic 0, Logic 1, or High-Impedance (Hi-Z)', 'A gate that operates on ternary base-3 numbers', 'A storage register with three clock inputs'],
            correct_option_index: 1,
            explanation: 'When disabled, a tri-state buffer enters High-Impedance (Hi-Z), electrically disconnecting its output from shared buses to avoid bus contention.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0213-000000000003',
        title: 'Quiz 3: Sequential Logic and Finite State Machines',
        passing_score: 75,
        order_index: 3,
        questions: [
          {
            id: 'd0000000-0000-0000-0313-000000000015',
            question_text: 'What is the setup time (t_setup) of an edge-triggered flip-flop?',
            options: ['The time required for output Q to become valid after the clock edge', 'The minimum time the data input must remain stable before the active clock edge', 'The minimum duration the clock pulse must remain high', 'The delay between power-on and the first clock pulse'],
            correct_option_index: 1,
            explanation: 'Setup time is the critical window immediately preceding the active clock edge during which the data input D must not change.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000016',
            question_text: 'What happens if the setup or hold time constraints of a flip-flop are violated?',
            options: ['The circuit burns out immediately', 'The flip-flop may enter a metastable state where the output hovers between logic levels for an unpredictable duration', 'The clock frequency automatically doubles', 'The output is guaranteed to latch to 0'],
            correct_option_index: 1,
            explanation: 'Timing violations cause metastability, where internal feedback loops fail to resolve cleanly to 0 or 1, corrupting synchronous operation.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000017',
            question_text: 'What distinguishes a Moore machine from a Mealy machine?',
            options: ['Moore machine outputs depend only on the current state, whereas Mealy machine outputs depend on both current state and current inputs', 'Moore machines do not use flip-flops', 'Mealy machines can only have 2 states', 'Moore machines change state without a clock signal'],
            correct_option_index: 0,
            explanation: 'In Moore FSMs, output is a pure function of state registers. In Mealy FSMs, outputs react combinationally to external inputs within the clock period.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000018',
            question_text: 'What is the characteristic equation of a JK flip-flop?',
            options: ['Q_next = D', 'Q_next = J * Q_bar + K_bar * Q', 'Q_next = J xor K', 'Q_next = J * K'],
            correct_option_index: 1,
            explanation: 'When J=1, K=0 (set), Q_next=1; when J=0, K=1 (reset), Q_next=0; when J=1, K=1 (toggle), Q_next=Q_bar. This matches J Q_bar + K_bar Q.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000019',
            question_text: 'How many flip-flops are required to construct a modulo-16 synchronous binary counter?',
            options: ['2', '4', '8', '16'],
            correct_option_index: 1,
            explanation: 'A modulo-N counter requires ceil(log2(N)) flip-flops. Since log2(16) = 4, exactly 4 flip-flops are needed.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000020',
            question_text: 'What is the maximum operating clock frequency f_max for a synchronous sequential circuit with t_clk-q = 2ns, combinational logic delay t_comb = 5ns, and setup time t_su = 1ns?',
            options: ['100 MHz', '125 MHz', '200 MHz', '500 MHz'],
            correct_option_index: 1,
            explanation: 'Minimum clock period T_clk = t_clk-q + t_comb + t_su = 2ns + 5ns + 1ns = 8ns. Max frequency f_max = 1 / 8ns = 125 MHz.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000021',
            question_text: 'What is a Johnson counter (twisted ring counter) with 4 flip-flops capable of counting?',
            options: ['4 states', '8 states (2 * n)', '16 states', '32 states'],
            correct_option_index: 1,
            explanation: 'By feeding the inverted output of the last flip-flop back into the first, an n-stage Johnson counter cycles through 2n = 8 distinct states.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0213-000000000004',
        title: 'Quiz 4: Computer Architecture, RISC-V, Pipelining, and Caches',
        passing_score: 75,
        order_index: 4,
        questions: [
          {
            id: 'd0000000-0000-0000-0313-000000000022',
            question_text: 'What special property does register x0 possess in the RISC-V ISA?',
            options: ['It stores the program counter (PC)', 'It is hardwired to constant value 0, and writes to it are silently ignored', 'It is the stack pointer', 'It stores floating point status flags'],
            correct_option_index: 1,
            explanation: 'In RISC-V, register x0 always reads as zero, providing a convenient constant for move operations (addi rd, rs1, 0) and zero comparisons.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000023',
            question_text: 'In a classic 5-stage RISC pipeline, what type of hazard occurs when an instruction requires data that has been loaded by a preceding instruction but not yet written back?',
            options: ['Structural hazard', 'Read-After-Write (RAW) data hazard', 'Write-After-Read (WAR) hazard', 'Control hazard'],
            correct_option_index: 1,
            explanation: 'A RAW data hazard happens when an instruction attempts to read a register before a previous instruction writes its result.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000024',
            question_text: 'Why cannot data forwarding eliminate the stall cycle for a Load-Use hazard (e.g., lw x1, 0(x2) followed immediately by add x3, x1, x4)?',
            options: ['The ALU is turned off during load instructions', 'The loaded data is only available from data memory at the end of the MEM stage, whereas the ADD instruction needs it at the beginning of the EX stage', 'RISC-V registers cannot be forwarded', 'Forwarding only works for branch instructions'],
            correct_option_index: 1,
            explanation: 'The load data is produced at the end of stage 4 (MEM), while the dependent instruction needs operands at stage 3 (EX). This backward time requirement mandates 1 pipeline bubble.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000025',
            question_text: 'In a 4-way set-associative cache with 32-bit addresses, 64-byte blocks, and 128 sets, how many bits are used for the tag field?',
            options: ['6 bits', '7 bits', '19 bits', '25 bits'],
            correct_option_index: 2,
            explanation: 'Block offset = log2(64) = 6 bits. Set index = log2(128) = 7 bits. Tag bits = 32 - 7 - 6 = 19 bits.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000026',
            question_text: 'What cache write policy updates both the cache block and main memory simultaneously on every write hit?',
            options: ['Write-Back', 'Write-Through', 'No-Write-Allocate', 'Lazy Invalidation'],
            correct_option_index: 1,
            explanation: 'Write-Through writes data to both cache and memory immediately, ensuring memory is always consistent at the cost of higher bus traffic.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000027',
            question_text: 'What is the Average Memory Access Time (AMAT) if Hit Time is 1 ns, Miss Rate is 5%, and Miss Penalty is 80 ns?',
            options: ['1.05 ns', '4.00 ns', '5.00 ns', '81.00 ns'],
            correct_option_index: 2,
            explanation: 'AMAT = Hit Time + (Miss Rate * Miss Penalty) = 1 ns + (0.05 * 80 ns) = 1 ns + 4 ns = 5.0 ns.'
          },
          {
            id: 'd0000000-0000-0000-0313-000000000028',
            question_text: 'What hardware structure translates virtual page numbers (VPN) to physical page numbers (PPN) quickly without accessing memory page tables?',
            options: ['Branch Target Buffer (BTB)', 'Translation Lookaside Buffer (TLB)', 'Return Address Stack (RAS)', 'Instruction Register (IR)'],
            correct_option_index: 1,
            explanation: 'The TLB is a dedicated, fully associative or set-associative hardware cache storing recent page translations to accelerate virtual memory address mapping.'
          }
        ]
      }
    ],
    assignments: [
      {
        id: 'd0000000-0000-0000-0413-000000000001',
        title: 'Assignment 1: 32-Bit ALU and Finite State Machine Controller in Verilog/HDL',
        description: `Design and simulate digital hardware modules using Verilog HDL (or Python digital simulation frameworks):
1. **Arithmetic Logic Unit (ALU):**
   - Implement a modular 32-bit ALU supporting 8 operations: ADD, SUB, AND, OR, XOR, SLT (Set Less Than signed), SLL (Shift Left Logical), and SRL (Shift Right Logical).
   - Generate condition status flags: Zero ($Z$), Negative ($N$), Carry-Out ($C$), and Overflow ($V$).
   - Implement two\'s complement subtraction and verify signed overflow detection logic: $V = (A_{31} \\cdot \\bar{B}_{31} \\cdot \\bar{S}_{31}) + (\\bar{A}_{31} \\cdot B_{31} \\cdot S_{31})$.
2. **Sequential Traffic Light Controller (FSM):**
   - Implement a synchronous Finite State Machine for an intersection with Main Street, Side Street, and pedestrian crosswalks.
   - Specify Moore machine state transitions: GREEN_MAIN, YELLOW_MAIN, GREEN_SIDE, YELLOW_SIDE, PEDESTRIAN_WALK.
   - Code a testbench applying clock pulses, emergency vehicle priority overrides, and pedestrian sensor inputs.
   - Verify waveform timing, setup/hold constraints, and output hazard freedom.`,
        due_date: '2026-11-22T23:59:59Z',
        rubric: [
          { criterion: '32-Bit ALU Logic & Operations', max_points: 30, description: 'Accurate implementation of all 8 arithmetic/logical operations and shift capabilities.' },
          { criterion: 'ALU Status Flags & Overflow Detection', max_points: 20, description: 'Correct Z, N, C, and two\'s complement signed overflow logic V.' },
          { criterion: 'Moore FSM Controller Synthesis', max_points: 25, description: 'Robust state transition table, reset handling, and priority override logic.' },
          { criterion: 'Testbench Verification & Waveform Analysis', max_points: 25, description: 'Comprehensive simulation testbench covering corner cases, edge transitions, and timing verification.' }
        ]
      },
      {
        id: 'd0000000-0000-0000-0413-000000000002',
        title: 'Assignment 2: 5-Stage Pipelined RISC-V Processor Simulator',
        description: `Develop a cycle-accurate software simulator in Python or C++ modeling a 5-stage pipelined RISC-V processor:
1. **Instruction Fetch & Decode (IF/ID):**
   - Decode RV32I instructions: R-type (\`add\`, \`sub\`, \`and\`, \`or\`, \`slt\`), I-type (\`addi\`, \`lw\`), S-type (\`sw\`), B-type (\`beq\`, \`bne\`), and J-type (\`jal\`).
   - Maintain 32 general-purpose registers (with \`x0\` locked to 0) and Program Counter (\`PC\`).
2. **Hazard Detection & Forwarding Unit:**
   - Detect Read-After-Write (RAW) data hazards and forward results from EX/MEM and MEM/WB stages directly to ALU inputs.
   - Detect Load-Use hazards and inject a 1-cycle pipeline bubble (stalling IF and ID stages).
   - Handle branch mispredictions by flushing the pipeline (inserting NOPs).
3. **Execution & Memory Simulation:**
   - Simulate a unified 64 KB memory space and measure instructions executed, total clock cycles, Cycles Per Instruction (CPI), and stall breakdown.
   - Execute benchmark programs (e.g. recursive Fibonacci, Array QuickSort) and compare execution cycles with forwarding enabled vs disabled.`,
        due_date: '2026-12-02T23:59:59Z',
        rubric: [
          { criterion: 'RV32I Instruction Decoding & Datapath', max_points: 25, description: 'Correct instruction parsing, sign extension, and execution across all 5 stages.' },
          { criterion: 'Hazard Detection & Stalling Logic', max_points: 25, description: 'Accurate detection of Load-Use hazards and pipeline stalls without data corruption.' },
          { criterion: 'Data Forwarding Unit', max_points: 25, description: 'Seamless EX-to-EX and MEM-to-EX forwarding avoiding unnecessary bubbles.' },
          { criterion: 'Benchmark Execution & Performance Metrics', max_points: 25, description: 'Accurate execution of sorting benchmark, reporting CPI, pipeline metrics, and cycle analysis.' }
        ]
      }
    ]
  }
];
