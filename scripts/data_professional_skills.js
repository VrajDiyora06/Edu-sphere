// scripts/data_professional_skills.js
// Courses 14-15: Data Analytics with Python, Technical Communication and Problem Solving

export const coursesProfessionalSkills = [
  // -------------------------------------------------------------------------
  // 14. Data Analytics with Python
  // -------------------------------------------------------------------------
  {
    id: 'd0000000-0000-0000-0000-000000000014',
    title: 'Data Analytics with Python',
    slug: 'data-analytics-with-python',
    description: 'Practical data science and analytics engineering: NumPy vectorized computations, Pandas data wrangling and aggregation, exploratory data analysis (EDA), data visualization with Matplotlib and Seaborn, hypothesis testing, A/B testing statistical methodology, and interactive dashboards.',
    category: 'Data Science',
    level: 'Beginner',
    thumbnail_url: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?q=80&w=800&auto=format&fit=crop',
    lessons: [
      {
        id: 'd0000000-0000-0000-0114-000000000001',
        title: 'NumPy Foundations: N-Dimensional Arrays, Broadcasting, and Vectorization',
        duration_minutes: 40,
        is_free_preview: true,
        order_index: 1,
        content: `### Learning Objectives
- Construct and manipulate contiguous $N$-dimensional arrays (\`ndarray\`) with specific data types.
- Master NumPy broadcasting rules across varying tensor shapes.
- Eliminate explicit Python loops using vectorized universal functions (\`ufunc\`).

### NumPy Broadcasting Semantics
Two dimensions are compatible when:
1. They are equal, or
2. One of them is 1.

\`\`\`python
import numpy as np

# A has shape (4, 1, 6)
# B has shape    (3, 1)
# Resulting broadcast shape: (4, 3, 6)
A = np.ones((4, 1, 6))
B = np.zeros((3, 1))
result = A + B
print(f"Broadcast shape: {result.shape}") # (4, 3, 6)
\`\`\`

### Vectorized Performance Comparison
Computing Euclidean distance on $10^6$ vectors:
\`\`\`python
# Python loop: ~850 ms
# NumPy vectorized: ~3.2 ms (>250x speedup via SIMD and contiguous C memory)
distances = np.linalg.norm(points_a - points_b, axis=1)
\`\`\`

### Key Takeaways
- NumPy arrays store contiguous blocks of homogeneous memory, bypassing Python object pointer indirection.
- Always prefer \`axis\`-based reduction (\`sum\`, \`mean\`, \`std\`) over iterative accumulation.`
      },
      {
        id: 'd0000000-0000-0000-0114-000000000002',
        title: 'Pandas Data Wrangling: Series, DataFrames, Indexing, and Cleaning',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 2,
        content: `### Learning Objectives
- Differentiate between label-based indexing (\`.loc\`) and integer position-based indexing (\`.iloc\`).
- Clean noisy real-world data: handling null values (\`dropna\`, \`fillna\`, interpolation), duplicate removal, and type coercion.
- Apply boolean masking and multi-condition filtering on large datasets.

### Indexing Taxonomy
\`\`\`python
import pandas as pd

df = pd.DataFrame({
    'ticker': ['AAPL', 'MSFT', 'GOOGL', 'AMZN'],
    'price': [182.5, 415.0, 175.2, 178.9],
    'volume': [54000000, 22000000, 19000000, 31000000]
}, index=['a', 'b', 'c', 'd'])

# Label-based slice (includes end index)
tech_subset = df.loc['a':'c', ['ticker', 'price']]

# Position-based slice (excludes end index)
first_two = df.iloc[0:2, 0:2]

# Boolean filtering
high_volume = df[df['volume'] > 20000000]
\`\`\`

### Handling Missing Data
1. Detection: \`df.isna().sum()\` gives missing value counts per column.
2. Imputation: Continuous features can be imputed using median or group-wise means to prevent data leakage.
3. Drop: \`df.dropna(subset=['critical_id'])\` removes rows with unrecoverable identifiers.`
      },
      {
        id: 'd0000000-0000-0000-0114-000000000003',
        title: 'Aggregations and Relational Operations: GroupBy, Merge, and Pivot Tables',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 3,
        content: `### Learning Objectives
- Execute Split-Apply-Combine workflows using \`groupby\` with custom and multiple aggregations.
- Combine datasets using relational algebra operations (\`merge\` with inner, outer, left, right joins).
- Reshape tabular structures with \`pivot_table\`, \`melt\`, and \`stack/unstack\`.

### Split-Apply-Combine Workflow
\`\`\`python
# Aggregating sales metrics by region and product category
summary = df.groupby(['region', 'category']).agg(
    total_revenue=('sale_amount', 'sum'),
    avg_order_value=('sale_amount', 'mean'),
    transaction_count=('order_id', 'count'),
    p95_revenue=('sale_amount', lambda x: np.percentile(x, 95))
).reset_index()
\`\`\`

### Relational Joins in Pandas
\`\`\`python
# Merging transactions with customer demographics
merged_df = pd.merge(
    orders,
    customers,
    on='customer_id',
    how='left',
    suffixes=('_order', '_customer')
)
\`\`\`

### Reshaping Data
- \`pivot_table\`: Converts long data to wide format, applying aggregations across intersections.
- \`melt\`: Unpivots wide columns into key-value pair rows for tidy data modeling.`
      },
      {
        id: 'd0000000-0000-0000-0114-000000000004',
        title: 'Exploratory Data Analysis (EDA): Distributions, Outliers, and Correlation',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 4,
        content: `### Learning Objectives
- Compute summary statistics: mean, median, variance, skewness, and kurtosis.
- Identify outliers using Interquartile Range (IQR) bounds and Z-score thresholds.
- Measure bivariate dependencies using Pearson linear correlation vs Spearman monotonic rank correlation.

### Outlier Detection Mathematical Rules
1. **Interquartile Range (IQR):**
   $$IQR = Q_3 - Q_1$$
   $$\\text{Mild Outliers:} \\quad x < Q_1 - 1.5 \\cdot IQR \\quad \\lor \\quad x > Q_3 + 1.5 \\cdot IQR$$
   $$\\text{Extreme Outliers:} \\quad x < Q_1 - 3.0 \\cdot IQR \\quad \\lor \\quad x > Q_3 + 3.0 \\cdot IQR$$
2. **Z-Score Rule (for Gaussian distributions):**
   $$z = \\frac{x - \\mu}{\\sigma}, \\quad |z| > 3 \\implies \\text{Outlier candidate}$$

### Pearson vs Spearman Correlation
- **Pearson $r$:** Measures strict linear correlation $\\frac{\\text{Cov}(X, Y)}{\\sigma_X \\sigma_Y} \\in [-1, +1]$. Highly sensitive to extreme outliers.
- **Spearman $\\rho$:** Pearson correlation applied to variable ranks; captures any monotonic non-linear relationship.`
      },
      {
        id: 'd0000000-0000-0000-0114-000000000005',
        title: 'Statistical Visualization: Matplotlib and Seaborn Grammar of Graphics',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 5,
        content: `### Learning Objectives
- Apply the object-oriented Matplotlib interface (\`fig, ax = plt.subplots()\`) over stateful \`pyplot\`.
- Select chart types matching data types: KDE plots, Violin plots, Box plots, Pair plots, and Heatmaps.
- Design accessible, publication-grade figures with clear color palettes, annotations, and labels.

### Visual Taxonomy
| Data Types | Recommended Chart Type | Matplotlib / Seaborn Method |
| :--- | :--- | :--- |
| Single Continuous Variable | Histogram with KDE overlay | \`sns.histplot(x, kde=True)\` |
| Continuous vs Categorical | Box plot / Split Violin plot | \`sns.violinplot(x='cat', y='val', data=df)\` |
| Two Continuous Variables | Scatter plot with marginal dists | \`sns.jointplot(x='v1', y='v2', kind='reg')\` |
| Correlation Matrix | Heatmap with diverging palette | \`sns.heatmap(corr, annot=True, cmap='vlag')\` |
| High-Dimensional Overview | Pairplot with hue grouping | \`sns.pairplot(df, hue='target')\` |

### Publication-Grade Figure Generation
\`\`\`python
import matplotlib.pyplot as plt
import seaborn as sns

fig, ax = plt.subplots(figsize=(8, 5), dpi=150)
sns.boxplot(data=df, x='category', y='revenue', palette='Blues_r', ax=ax)
ax.set_title('Revenue Distribution by Category', fontsize=14, fontweight='bold', pad=12)
ax.set_xlabel('Product Category', fontsize=11)
ax.set_ylabel('Revenue ($)', fontsize=11)
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
plt.tight_layout()
\`\`\``
      },
      {
        id: 'd0000000-0000-0000-0114-000000000006',
        title: 'Hypothesis Testing and A/B Experimentation Methodology',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 6,
        content: `### Learning Objectives
- Formulate Null ($H_0$) and Alternative ($H_1$) hypotheses and select appropriate statistical tests.
- Interpret p-values, Type I errors (False Positive $\\alpha$), and Type II errors (False Negative $\\beta$).
- Execute Student's Two-Sample t-test, Welch's t-test (unequal variance), and Chi-Square test of independence.
- Calculate Sample Size requirements via statistical power analysis.

### Statistical Test Selection Tree
\`\`\`
Continuous Dependent Variable:
├── Comparing 2 Independent Groups:
│   ├── Normal distribution & equal variance: Student's t-test
│   ├── Normal distribution & unequal variance: Welch's t-test
│   └── Non-normal distribution: Mann-Whitney U test
└── Comparing >2 Groups: One-Way ANOVA (Post-hoc Tukey HSD)

Categorical Dependent Variable:
└── Contingency Tables (e.g. Conversion A vs B): Pearson Chi-Square test (or Fisher's Exact test)
\`\`\`

### A/B Testing Pitfalls to Avoid
1. **Peeking Problem:** Checking p-values continuously and stopping as soon as $p < 0.05$ severely inflates Type I error. Fix via sequential testing or fixed-sample execution.
2. **Novelty Effect:** Users initially engage with UI changes out of curiosity, followed by reversion to baseline.`
      },
      {
        id: 'd0000000-0000-0000-0114-000000000007',
        title: 'Time Series Analytics: Resampling, Moving Averages, and Seasonality',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 7,
        content: `### Learning Objectives
- Parse and set datetime indices in Pandas and handle irregular sampling intervals.
- Resample time series at varying frequencies (\`D\`, \`W\`, \`M\`, \`Q\`) using downsampling and upsampling.
- Compute rolling window statistics, exponential moving averages (EMA), and decompose seasonal components.

### Pandas Resampling and Rolling Calculations
\`\`\`python
# Daily to weekly resampling with multiple metrics
weekly_metrics = df['sales'].resample('W-MON').agg(['sum', 'mean'])

# 7-day and 30-day simple moving average (SMA)
df['sma_7'] = df['sales'].rolling(window=7, min_periods=1).mean()
df['sma_30'] = df['sales'].rolling(window=30, min_periods=1).mean()

# Exponential Moving Average (EMA) with span=14
df['ema_14'] = df['sales'].ewm(span=14, adjust=False).mean()
\`\`\`

### Seasonal Decomposition
Decompose time series $Y_t$ into:
$$Y_t = T_t + S_t + I_t \\quad (\\text{Additive}) \\quad \\lor \\quad Y_t = T_t \\times S_t \\times I_t \\quad (\\text{Multiplicative})$$
- $T_t$: Long-term trend.
- $S_t$: Periodic seasonal cycle.
- $I_t$: Irregular residual noise.`
      }
    ],
    quizzes: [
      {
        id: 'd0000000-0000-0000-0214-000000000001',
        title: 'Quiz 1: NumPy Arrays, Vectorization, and Broadcasting',
        passing_score: 75,
        order_index: 1,
        questions: [
          {
            id: 'd0000000-0000-0000-0314-000000000001',
            question_text: 'What are the dimensions of the broadcast result when adding an array of shape (5, 1, 4) to an array of shape (3, 4)?',
            options: ['(5, 3, 4)', '(5, 4, 3)', '(15, 4)', 'Broadcasting fails because dimensions do not match'],
            correct_option_index: 0,
            explanation: 'Aligning shapes from the right: (5, 1, 4) and (1, 3, 4). Dimension 4 matches 4; dimension 1 broadcasts to 3; leading dimension 5 prepends. Output shape is (5, 3, 4).'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000002',
            question_text: 'Why does a vectorized NumPy operation execute orders of magnitude faster than a standard Python for-loop?',
            options: ['NumPy automatically translates code into assembly and skips memory checks', 'NumPy operates on contiguous blocks of homogeneous data types using compiled C loops and CPU SIMD instructions', 'NumPy runs exclusively on GPU graphics hardware', 'NumPy rounds all floating point numbers to integers'],
            correct_option_index: 1,
            explanation: 'NumPy arrays store fixed-size contiguous memory blocks, eliminating dynamic typing overhead, pointer indirection, and leveraging CPU vectorization.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000003',
            question_text: 'What is the effect of arr.reshape(-1, 1) on a 1D NumPy array of length N?',
            options: ['Flattens the array into a scalar', 'Transforms the array into a 2D column vector with shape (N, 1)', 'Reverses the order of elements', 'Deletes all negative values'],
            correct_option_index: 1,
            explanation: 'Passing -1 allows NumPy to infer the dimension automatically. For length N, (-1, 1) converts the vector into an (N, 1) 2D column matrix.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000004',
            question_text: 'What does np.dot(A, B) compute when A and B are 2-dimensional matrices?',
            options: ['Element-wise multiplication', 'Standard matrix multiplication (equivalent to A @ B)', 'Vector cross product', 'Outer product of row sums'],
            correct_option_index: 1,
            explanation: 'For 2D arrays, np.dot performs standard matrix multiplication, identical to the @ operator.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000005',
            question_text: 'Which function creates an array of 50 evenly spaced numbers between 0 and 10 inclusive?',
            options: ['np.arange(0, 10, 50)', 'np.linspace(0, 10, 50)', 'np.random.uniform(0, 10, 50)', 'np.zeros((10, 50))'],
            correct_option_index: 1,
            explanation: 'np.linspace(start, stop, num) generates num evenly spaced points over the specified closed interval [start, stop].'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000006',
            question_text: 'In a 2D array arr of shape (10, 20), what does arr.sum(axis=0) return?',
            options: ['A single total scalar sum', 'A 1D array of 20 elements containing the sum of each column', 'A 1D array of 10 elements containing the sum of each row', 'A 2D array of cumulative sums'],
            correct_option_index: 1,
            explanation: 'Collapsing axis=0 computes sums along the vertical column direction, leaving length 20.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000007',
            question_text: 'What is the distinction between a view and a copy in NumPy slicing?',
            options: ['Views use more memory than copies', 'A slice of an array returns a view sharing the same underlying memory buffer; modifying the view modifies the original array', 'Copies are updated automatically when the original array changes', 'NumPy never creates views'],
            correct_option_index: 1,
            explanation: 'Basic indexing and slicing return memory views without copying data. To modify a slice safely without mutating the source, call .copy().'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0214-000000000002',
        title: 'Quiz 2: Pandas Data Wrangling, Merging, and Grouping',
        passing_score: 75,
        order_index: 2,
        questions: [
          {
            id: 'd0000000-0000-0000-0314-000000000008',
            question_text: 'What is the fundamental difference between df.loc and df.iloc in Pandas?',
            options: ['df.loc is purely integer-based, while df.iloc is label-based', 'df.loc is label-based and includes the endpoint of slices, while df.iloc is integer-based and excludes the endpoint', 'df.loc only works on columns, df.iloc only works on rows', 'df.loc is deprecated in modern Pandas versions'],
            correct_option_index: 1,
            explanation: '.loc accesses rows and columns by their index/column names (inclusive of stop bounds), while .iloc accesses by 0-indexed integer positions (half-open range [start, stop)).'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000009',
            question_text: 'Which method should you use to convert a wide-format DataFrame with monthly columns (Jan, Feb, Mar) into a long-format DataFrame with a single Month column?',
            options: ['pd.pivot_table()', 'df.melt()', 'df.groupby()', 'df.unstack()'],
            correct_option_index: 1,
            explanation: 'pd.melt() unpivots DataFrames from wide format to long format, gathering identifier and measurement variables.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000010',
            question_text: 'In a SQL-style join performed via pd.merge(df1, df2, how=\'left\'), what happens to rows in df1 that have no matching key in df2?',
            options: ['They are excluded from the output DataFrame', 'They are retained, and the columns from df2 are populated with NaN', 'The operation raises a KeyError', 'They are duplicated for every row in df2'],
            correct_option_index: 1,
            explanation: 'A left outer join preserves every row from the left DataFrame, filling unmatched columns from the right DataFrame with NaN (missing values).'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000011',
            question_text: 'How does the transform method in df.groupby(\'category\')[\'sales\'].transform(\'mean\') differ from the agg method?',
            options: ['transform calculates median instead of mean', 'transform returns a Series with the exact same index and length as the original DataFrame, broadcasting group statistics across individual rows', 'transform only works on text columns', 'transform drops all duplicate values'],
            correct_option_index: 1,
            explanation: 'While .agg() reduces each group to a single summary row, .transform() broadcasts the calculated group statistic back to align with every original row.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000012',
            question_text: 'Which expression correctly filters a DataFrame df for transactions where category is \'Electronics\' and price is greater than 100?',
            options: ['df[df[\'category\'] == \'Electronics\' and df[\'price\'] > 100]', 'df[(df[\'category\'] == \'Electronics\') & (df[\'price\'] > 100)]', 'df[df[\'category\'].isin(\'Electronics\') or df[\'price\'] > 100]', 'df.filter(\'category == Electronics & price > 100\')'],
            correct_option_index: 1,
            explanation: 'Pandas requires bitwise operators (& for AND, | for OR) with parenthesized boolean conditions due to operator precedence.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000013',
            question_text: 'What is the purpose of df.drop_duplicates(subset=[\'email\'], keep=\'last\')?',
            options: ['Deletes the email column', 'Removes all duplicate records sharing an email, keeping only the final occurrence encountered in the DataFrame', 'Sorts emails in alphabetical order', 'Replaces duplicate emails with empty strings'],
            correct_option_index: 1,
            explanation: 'The subset parameter identifies duplicate rows by specific key columns, and keep=\'last\' retains the final record while dropping earlier duplicates.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000014',
            question_text: 'Why should you avoid using iterative for-loops like for index, row in df.iterrows() to perform calculations on large DataFrames?',
            options: ['iterrows() creates Python tuple objects for every row, making it hundreds of times slower than vectorized column expressions or apply()', 'iterrows() deletes rows after reading them', 'iterrows() cannot process integer values', 'iterrows() only reads the first 100 rows'],
            correct_option_index: 0,
            explanation: 'iterrows() converts each row into a Python Series object on every iteration, destroying NumPy vectorized performance and introducing significant overhead.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0214-000000000003',
        title: 'Quiz 3: Exploratory Data Analysis and Statistical Visualization',
        passing_score: 75,
        order_index: 3,
        questions: [
          {
            id: 'd0000000-0000-0000-0314-000000000015',
            question_text: 'In an Interquartile Range (IQR) outlier analysis, what are the standard cutoff boundaries for mild outliers?',
            options: ['Mean +/- 2 Standard Deviations', '[Q1 - 1.5 * IQR, Q3 + 1.5 * IQR]', '[Q1 - 0.5 * IQR, Q3 + 0.5 * IQR]', '[Minimum value, Maximum value]'],
            correct_option_index: 1,
            explanation: 'Tukey\'s boxplot rule identifies values below Q1 - 1.5 * IQR or above Q3 + 1.5 * IQR as outliers.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000016',
            question_text: 'When should Spearman rank correlation be preferred over Pearson correlation coefficient?',
            options: ['When data has a strictly linear relationship and is normally distributed', 'When data exhibits non-linear monotonic relationships or contains extreme outliers that distort linear covariance', 'When the dataset has fewer than 10 samples', 'Only when working with categorical binary data'],
            correct_option_index: 1,
            explanation: 'Spearman correlation evaluates monotonic rank order rather than raw linear values, making it robust against non-linear scaling and heavy-tailed outliers.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000017',
            question_text: 'What visualization is best suited for comparing the full probability distribution and density of a continuous metric across multiple categories?',
            options: ['Pie chart', 'Violin plot or Box plot', 'Stacked bar chart', 'Simple line chart'],
            correct_option_index: 1,
            explanation: 'Violin plots combine box plots with kernel density estimation (KDE), showing median, quartiles, and distribution shape (e.g. bimodal distributions).'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000018',
            question_text: 'What does a positive skewness value indicate about a feature distribution?',
            options: ['The distribution is symmetrical', 'The right tail is elongated and the majority of observations are concentrated to the left of the mean', 'The left tail is elongated', 'The variance is negative'],
            correct_option_index: 1,
            explanation: 'Positive (right) skewness means the tail extends toward larger positive values, pulling the mean to the right of the median.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000019',
            question_text: 'In Matplotlib, why is the object-oriented API (fig, ax = plt.subplots()) preferred for production applications over the pyplot state-machine?',
            options: ['It runs without Python installed', 'It provides explicit, modular control over multiple axes, subplots, and figure elements without relying on global implicit state', 'It prevents users from changing line colors', 'It only works in Jupyter notebooks'],
            correct_option_index: 1,
            explanation: 'Explicitly manipulating Figure and Axes objects makes plotting code reusable, testable, and prevents unintended interference across multiple figures.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000020',
            question_text: 'What does a correlation matrix heatmap with diverging colormap (e.g. coolwarm) display along its main diagonal?',
            options: ['Zero values', 'Value 1.0 (each feature has a perfect correlation of 1.0 with itself)', 'Mean values of the features', 'P-values of the hypothesis test'],
            correct_option_index: 1,
            explanation: 'The correlation of any variable with itself is by definition 1.0, so the diagonal entries of a correlation matrix are always 1.0.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000021',
            question_text: 'What is the purpose of a Q-Q (Quantile-Quantile) plot in exploratory analysis?',
            options: ['To compare two independent regression lines', 'To visually assess whether a sample distribution follows a theoretical distribution (such as Gaussian normal distribution)', 'To detect missing values across time steps', 'To calculate the sample variance'],
            correct_option_index: 1,
            explanation: 'A normal Q-Q plot compares sample quantiles against standard normal theoretical quantiles; data adhering to the 45-degree diagonal line is normally distributed.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0214-000000000004',
        title: 'Quiz 4: Hypothesis Testing and Experimentation',
        passing_score: 75,
        order_index: 4,
        questions: [
          {
            id: 'd0000000-0000-0000-0314-000000000022',
            question_text: 'What does a p-value of 0.03 indicate in a hypothesis test where significance level alpha is set to 0.05?',
            options: ['There is a 3% probability that the alternative hypothesis is true', 'Assuming the null hypothesis is true, there is a 3% probability of observing test results at least as extreme as those measured; we reject H0', 'The experiment has failed and must be restarted', 'The effect size is exactly 0.03'],
            correct_option_index: 1,
            explanation: 'A p-value is P(observed data | H0). Because p = 0.03 < alpha (0.05), we reject the null hypothesis in favor of the alternative.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000023',
            question_text: 'What is a Type I error in statistical hypothesis testing?',
            options: ['Failing to reject the null hypothesis when it is false (False Negative)', 'Rejecting the null hypothesis when it is actually true (False Positive)', 'Using the wrong sample size formula', 'Measuring variables with incorrect units'],
            correct_option_index: 1,
            explanation: 'A Type I error (probability alpha) occurs when an experiment falsely claims a statistically significant effect when none actually exists.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000024',
            question_text: 'Why is Welch\'s t-test generally preferred over Student\'s traditional two-sample t-test?',
            options: ['It does not require normal distributions', 'It does not assume equal variances between the two comparison groups, making it robust against heteroscedasticity', 'It works on datasets with zero observations', 'It gives higher p-values in all experiments'],
            correct_option_index: 1,
            explanation: 'Welch\'s t-test relaxes the homoscedasticity assumption (equal variances) while retaining near-identical power when variances happen to be equal.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000025',
            question_text: 'What is the statistical testing consequence of repeated peeking at conversion data during an active A/B test and stopping early?',
            options: ['It improves statistical power', 'It severely inflates the false positive rate (Type I error) far beyond the nominal alpha level of 0.05', 'It makes the p-value completely constant', 'It eliminates sampling variance'],
            correct_option_index: 1,
            explanation: 'Continuous peeking creates multiple testing opportunities for random noise fluctuations to dip below p=0.05, artificially driving false positive rates up to 20-30%.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000026',
            question_text: 'Which statistical test is appropriate for evaluating whether click-through conversion rates (conversions vs non-conversions) differ significantly between variant A and variant B?',
            options: ['Paired t-test', 'Pearson Chi-Square test of independence (or Two-proportion Z-test)', 'One-way ANOVA', 'Principal Component Analysis'],
            correct_option_index: 1,
            explanation: 'Comparing counts of categorical outcomes (converted vs not converted) across two independent groups uses a 2x2 contingency table evaluated with Chi-Square or two-proportion Z-test.'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000027',
            question_text: 'What does statistical power (1 - beta) represent in an experimentation study?',
            options: ['The probability of rejecting the null hypothesis when an actual true effect exists (True Positive rate)', 'The probability of making a Type I error', 'The ratio of treatment group size to control group size', 'The maximum allowable execution runtime of the test'],
            correct_option_index: 0,
            explanation: 'Power is the probability that a test correctly detects an effect of a given minimum detectable size when that effect is truly present (typically targeted at 80% or 90%).'
          },
          {
            id: 'd0000000-0000-0000-0314-000000000028',
            question_text: 'In time series analysis, what does an Exponential Moving Average (EMA) do differently than a Simple Moving Average (SMA)?',
            options: ['EMA assigns equal weight to all past time periods', 'EMA assigns exponentially decreasing weights to older data points, prioritizing more recent observations', 'EMA eliminates all trend lines', 'EMA requires weekly data only'],
            correct_option_index: 1,
            explanation: 'EMA applies weights that decline exponentially over past time steps, making it respond faster to recent price or volume changes than an SMA.'
          }
        ]
      }
    ],
    assignments: [
      {
        id: 'd0000000-0000-0000-0414-000000000001',
        title: 'Assignment 1: E-Commerce Multi-Table Wrangling & Comprehensive EDA Report',
        description: `Analyze real-world transactional e-commerce data across multiple relational tables:
1. **Relational Data Wrangling:**
   - Ingest 3 datasets: \`orders.csv\` (order id, customer id, date, status), \`order_items.csv\` (order id, product id, quantity, price), and \`products.csv\` (product id, category, cost).
   - Perform inner and outer joins to create an analytics master view.
   - Clean data: impute missing categorical categories, parse ISO datetime strings, and eliminate cancelled/fraudulent transactions.
2. **Feature Engineering & Aggregation:**
   - Compute Customer Lifetime Value (CLV), Average Order Value (AOV), and 30-day repurchase retention rate.
   - Reshape data using \`pivot_table\` to display quarterly revenue by category and geographical region.
3. **Exploratory Visualizations:**
   - Construct Matplotlib/Seaborn figures: monthly revenue trend with rolling 7-day moving average, boxplots of order value distributions across categories, and a correlation heatmap.
4. **Outlier & Distribution Analysis:**
   - Run IQR and Z-score outlier detection on order values and document how filtering high-value wholesale transactions impacts variance and skewness.`,
        due_date: '2026-11-24T23:59:59Z',
        rubric: [
          { criterion: 'Relational Merge & Data Cleaning', max_points: 25, description: 'Accurate joins, proper null imputation, and data type coercion without data loss.' },
          { criterion: 'Feature Engineering & Grouping', max_points: 25, description: 'Correct CLV, AOV, and customer retention metrics using split-apply-combine and pivoting.' },
          { criterion: 'Statistical EDA & Outlier Handling', max_points: 25, description: 'Rigorous distribution analysis, IQR outlier boundary calculation, and skewness diagnostics.' },
          { criterion: 'Visualization Quality & Insights', max_points: 25, description: 'Publication-quality figures with clear labels, legends, palettes, and actionable business insights.' }
        ]
      },
      {
        id: 'd0000000-0000-0000-0414-000000000002',
        title: 'Assignment 2: End-to-End A/B Testing Analysis and Hypothesis Evaluation',
        description: `Design, analyze, and report on a simulated digital product A/B experiment:
1. **Sample Size & Power Calculation:**
   - Pre-experiment power analysis: calculate required sample size per variant for baseline conversion rate of 5.0%, Minimum Detectable Effect (MDE) of 0.5% (relative 10% lift), significance level $\\alpha = 0.05$, and power $1 - \\beta = 0.80$.
2. **Sanity Checks & Data Validation:**
   - Perform Sample Ratio Mismatch (SRM) test using a Chi-Square goodness-of-fit test to verify that the 50/50 traffic split was not compromised.
3. **Hypothesis Testing:**
   - Test conversion rate differences using Pearson\'s Chi-Square test of independence and Two-proportion Z-test, reporting test statistic, p-value, and 95% confidence interval for absolute lift.
   - Test Average Revenue Per User (ARPU) using both Student\'s t-test and Welch\'s t-test, and run a non-parametric Mann-Whitney U test to handle revenue skewness.
4. **Business Decision Recommendation:**
   - Synthesize results into an executive summary addressing statistical significance, practical economic significance, risks of novelty bias, and launch/no-launch decision.`,
        due_date: '2026-12-04T23:59:59Z',
        rubric: [
          { criterion: 'Power Analysis & Sample Sizing', max_points: 25, description: 'Accurate mathematical calculation of required sample size given alpha, beta, and MDE.' },
          { criterion: 'SRM Test & Data Validation', max_points: 20, description: 'Correct execution of Chi-Square goodness-of-fit test to check for traffic split integrity.' },
          { criterion: 'Statistical Testing & Confidence Intervals', max_points: 30, description: 'Thorough hypothesis testing with Welch\'s t-test, Chi-square, and non-parametric checks.' },
          { criterion: 'Executive Report & Recommendation', max_points: 25, description: 'Clear technical interpretation translating statistical findings into a sound launch recommendation.' }
        ]
      }
    ]
  },

  // -------------------------------------------------------------------------
  // 15. Technical Communication and Problem Solving
  // -------------------------------------------------------------------------
  {
    id: 'd0000000-0000-0000-0000-000000000015',
    title: 'Technical Communication and Problem Solving',
    slug: 'technical-communication-problem-solving',
    description: 'Essential professional engineering capabilities: structured technical writing (RFCs, design documents, postmortems), API documentation, root cause analysis (5 Whys, Ishikawa diagrams), cognitive bias mitigation, engineering trade-off frameworks, and collaborative technical presentation.',
    category: 'Professional Development',
    level: 'Beginner',
    thumbnail_url: 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?q=80&w=800&auto=format&fit=crop',
    lessons: [
      {
        id: 'd0000000-0000-0000-0115-000000000001',
        title: 'Structured Technical Writing: The Minto Pyramid and Clear Engineering Prose',
        duration_minutes: 40,
        is_free_preview: true,
        order_index: 1,
        content: `### Learning Objectives
- Structure documents using the Minto Pyramid Principle: Bottom-line upfront (BLUF).
- Eliminate vague attributions, passive voice ambiguities, and jargon-dense fluff.
- Draft concise technical executive summaries that communicate decisions and tradeoffs.

### The Minto Pyramid Structure
\`\`\`
                     [ Core Recommendation / BLUF ]
                                   |
           +-----------------------+-----------------------+
           |                                               |
   [ Supporting Key Line 1 ]                       [ Supporting Key Line 2 ]
           |                                               |
     +-----+-----+                                   +-----+-----+
     |           |                                   |           |
  [ Data A ]  [ Data B ]                          [ Data C ]  [ Data D ]
\`\`\`

### Writing Guidelines
1. **Bottom-Line Upfront (BLUF):** State the decision or finding in the very first sentence. Do not bury recommendations at the conclusion of a chronological narrative.
2. **Active Voice and Direct Ownership:**
   - *Weak:* "It was determined that latency degradation was experienced."
   - *Strong:* "The database connection pool saturated, increasing 99th percentile API latency from 45ms to 1,200ms."
3. **Specific Quantified Metrics:** Avoid words like "fast", "scalable", or "large". Use concrete numbers ($p99 < 50\\text{ ms}$, throughput $> 15,000\\text{ RPS}$).`
      },
      {
        id: 'd0000000-0000-0000-0115-000000000002',
        title: 'Software Design Documents (RFCs) and Architecture Decision Records (ADRs)',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 2,
        content: `### Learning Objectives
- Formulate Request for Comments (RFC) documents for complex software proposals.
- Document irreversible technical choices using Architecture Decision Records (ADRs).
- Evaluate alternatives using weighted decision matrices and trade-off analyses.

### Standard Architecture Decision Record (ADR) Schema
\`\`\`markdown
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
\`\`\``
      },
      {
        id: 'd0000000-0000-0000-0115-000000000003',
        title: 'Incident Management and Blameless Postmortems',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 3,
        content: `### Learning Objectives
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
5. **Action Items:** Preventive and corrective tasks assigned with owners and strict SLA deadlines.`
      },
      {
        id: 'd0000000-0000-0000-0115-000000000004',
        title: 'Root Cause Analysis Frameworks: 5 Whys, Ishikawa, and Fault Trees',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 4,
        content: `### Learning Objectives
- Execute the 5 Whys iterative interrogation technique to drill down to fundamental systemic vulnerabilities.
- Construct Ishikawa (Fishbone / Cause-and-Effect) diagrams categorizing contributing vectors.
- Build quantitative Fault Tree Analysis (FTA) models using boolean logic gates.

### The 5 Whys in Software Engineering
\`\`\`
Problem: Production payment checkout returned HTTP 500 errors for 22 minutes.
1. Why? The payment service ran out of memory and was killed by Linux OOM killer.
2. Why? A memory leak occurred during transaction receipt generation.
3. Why? A newly deployed library held unclosed file descriptors in memory.
4. Why? The deployment lacked integration regression tests for resource leaks.
5. Why? The CI/CD pipeline does not run automated load and leak tests before staging rollout.
Action: Add automated 10-minute soaking memory leak tests into the staging deployment gate.
\`\`\`

### Ishikawa (Fishbone) Diagram Dimensions
- **People:** Training, shifts, alert fatigue, handover communication.
- **Process:** Code review standards, rollback procedures, change management.
- **Tools / Technology:** Monitoring coverage, CI/CD validation gates, staging fidelity.
- **Environment:** Cloud infrastructure limits, network latency, external vendor dependencies.`
      },
      {
        id: 'd0000000-0000-0000-0115-000000000005',
        title: 'API Documentation and Technical Specifications: OpenAPI and Developer Portals',
        duration_minutes: 40,
        is_free_preview: false,
        order_index: 5,
        content: `### Learning Objectives
- Author comprehensive API contracts using the OpenAPI 3.1 specification.
- Document error schemas, rate limits, pagination conventions, and idempotency keys.
- Write actionable quickstarts, interactive code examples, and troubleshooting guides.

### Best Practices for API Documentation
1. **Show Complete Payloads:** Always provide realistic JSON request and response payloads, not just abstract type names.
2. **Explicit Error Catalogs:** Document every HTTP status code (400, 401, 403, 404, 409, 422, 429, 500) with specific error codes and remediation advice.
3. **Authentication & Security:** Clearly detail token formats (e.g. \`Bearer <jwt>\`), scoping requirements, and header signatures.
4. **Idempotency Standards:** Explain how clients can safely retry network timeouts by attaching \`Idempotency-Key\` headers.`
      },
      {
        id: 'd0000000-0000-0000-0115-000000000006',
        title: 'Cognitive Biases in Engineering Decision Making and Trade-off Frameworks',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 6,
        content: `### Learning Objectives
- Recognize cognitive biases in software projects: Sunk Cost Fallacy, Confirmation Bias, bikeshedding (Law of Triviality), and Not-Invented-Here (NIH) syndrome.
- Evaluate build vs buy tradeoffs using Total Cost of Ownership (TCO) models.
- Apply weighted scoring matrices to make objective architectural selections.

### Cognitive Traps in Technology
1. **Sunk Cost Fallacy:** Continuing to invest engineering hours into a failing legacy framework simply because two years were already spent building it.
2. **Law of Triviality (Parkinson\'s Bikeshedding):** Teams spend 5 minutes debating a complex database migration strategy, but spend 45 minutes arguing over code formatting or button color.
3. **Not-Invented-Here (NIH):** Rejecting robust, battle-tested open-source libraries to build internal custom solutions with hidden maintenance burdens.

### Weighted Decision Matrix Template
| Evaluation Criteria | Weight (%) | Solution A (Custom Build) | Solution B (Managed SaaS) | Solution C (OSS Library) |
| :--- | :--- | :--- | :--- | :--- |
| Time to Market | 30% | 4/10 (1.2) | 9/10 (2.7) | 8/10 (2.4) |
| Maintenance Overhead | 25% | 3/10 (0.75) | 9/10 (2.25) | 6/10 (1.5) |
| Direct Financial Cost | 20% | 8/10 (1.6) | 4/10 (0.8) | 9/10 (1.8) |
| Flexibility / Extensibility | 25% | 9/10 (2.25) | 6/10 (1.5) | 8/10 (2.0) |
| **Weighted Total** | **100%** | **5.80** | **7.25** | **7.70** |`
      }
    ],
    quizzes: [
      {
        id: 'd0000000-0000-0000-0215-000000000001',
        title: 'Quiz 1: Structured Writing and Communication Principles',
        passing_score: 75,
        order_index: 1,
        questions: [
          {
            id: 'd0000000-0000-0000-0315-000000000001',
            question_text: 'What is the core principle of the Minto Pyramid (BLUF - Bottom-Line Upfront)?',
            options: ['Start with chronological background history before introducing decisions', 'Present the primary recommendation or conclusion first, followed by structured supporting rationales and data', 'Avoid using numbers or metrics in document titles', 'Write documents using poetic metaphors'],
            correct_option_index: 1,
            explanation: 'BLUF communicates the critical takeaway immediately, respecting busy stakeholders\' time and allowing readers to grasp the core decision before evaluating supporting details.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000002',
            question_text: 'Which sentence demonstrates effective, direct technical prose?',
            options: ['It was noticed that perhaps the server was running somewhat slowly.', 'Due to the fact that traffic was high, errors were encountered by users.', 'High database connection pool saturation increased p99 API latency from 45ms to 1,200ms.', 'Things did not go as planned during the deployment.'],
            correct_option_index: 2,
            explanation: 'The sentence uses active voice, identifies the exact technical mechanism (connection pool saturation), and provides concrete quantified metrics (p99 latency from 45ms to 1200ms).'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000003',
            question_text: 'Why should passive voice generally be avoided in technical documentation?',
            options: ['Passive voice makes documents too short', 'Passive voice often obscures who or what performed the action, creating ambiguity in responsibilities and root causes', 'Compilers cannot parse passive voice', 'Passive voice is always grammatically incorrect'],
            correct_option_index: 1,
            explanation: 'Passive constructions like "the configuration was changed" omit the actor and mechanism, which can cause confusion during incident postmortems.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000004',
            question_text: 'What is the role of an Executive Summary in a 20-page engineering proposal?',
            options: ['To list all bibliography citations', 'To provide a self-contained 1-page overview containing problem statement, recommended solution, cost, and expected impact', 'To copy the table of contents', 'To provide code listings of all functions'],
            correct_option_index: 1,
            explanation: 'An executive summary enables technical directors and leadership to evaluate the proposal\'s viability and business justification without reading all 20 pages.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000005',
            question_text: 'What is the best way to describe performance requirements in a technical specification?',
            options: ['"The system must be blazing fast."', '"The API must handle many concurrent users."', '"99.9% of read requests must return in under 100ms at loads up to 5,000 requests per second."', '"Performance should be optimized as much as possible."'],
            correct_option_index: 2,
            explanation: 'Effective engineering requirements are specific, measurable, achievable, and verifiable with clear percentiles and traffic boundaries.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000006',
            question_text: 'In technical communication, what does the term "bikeshedding" (Parkinson\'s Law of Triviality) describe?',
            options: ['Building physical sheds for servers', 'The tendency of groups to spend disproportionate time debating trivial, easily understood topics while neglecting complex, critical issues', 'Documenting bike route APIs', 'Writing code comments in markdown'],
            correct_option_index: 1,
            explanation: 'Parkinson\'s Law of Triviality demonstrates that discussions expand on trivial matters (because everyone has an opinion on them) while complex matters receive little scrutiny.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0215-000000000002',
        title: 'Quiz 2: Technical Specifications, RFCs, and ADRs',
        passing_score: 75,
        order_index: 2,
        questions: [
          {
            id: 'd0000000-0000-0000-0315-000000000007',
            question_text: 'What is the primary purpose of an Architecture Decision Record (ADR)?',
            options: ['To track employee vacation days', 'To capture an important architectural decision, its context, chosen alternatives, and positive/negative consequences for future maintainers', 'To store passwords and API keys', 'To replace unit tests'],
            correct_option_index: 1,
            explanation: 'An ADR records the rationale and tradeoffs behind architectural decisions, preventing future engineers from re-debating settled questions without knowing the historical context.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000008',
            question_text: 'What section of an RFC document addresses why alternative approaches were not chosen?',
            options: ['Glossary', 'Considered Alternatives / Non-Goals', 'License', 'Author Acknowledgements'],
            correct_option_index: 1,
            explanation: 'Documenting considered alternatives explicitly demonstrates thorough engineering evaluation and explains why alternative tools or architectures were rejected.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000009',
            question_text: 'Why is defining explicit "Non-Goals" crucial in software design specifications?',
            options: ['To make the document look longer', 'To protect the project from scope creep by establishing clear boundaries on what the system will NOT attempt to solve', 'To list bugs that will never be fixed', 'To prevent other teams from writing code'],
            correct_option_index: 1,
            explanation: 'Non-goals establish scope boundaries, align stakeholder expectations, and prevent feature creep from delaying deliveries.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000010',
            question_text: 'What standard HTTP header allows clients to safely retry POST requests after network timeouts without risking duplicate processing?',
            options: ['Authorization', 'Idempotency-Key', 'Accept-Encoding', 'User-Agent'],
            correct_option_index: 1,
            explanation: 'An Idempotency-Key header enables servers to identify duplicate requests and return the cached original response without reprocessing transactions.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000011',
            question_text: 'What is the benefit of using OpenAPI (formerly Swagger) specifications for REST APIs?',
            options: ['It eliminates the need for databases', 'It provides a machine-readable schema that automatically generates interactive documentation, mock servers, and client SDKs', 'It compiles Python code into C++', 'It prevents all network errors'],
            correct_option_index: 1,
            explanation: 'OpenAPI definitions provide a standard contract that synchronizes frontend and backend development while automating documentation generation and SDK production.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000012',
            question_text: 'In an ADR, what must be documented under the "Consequences" section?',
            options: ['Only the positive benefits expected', 'Both positive outcomes and negative trade-offs, technical debts, or operational burdens introduced by the decision', 'A list of employees who disagreed with the decision', 'A link to download the software'],
            correct_option_index: 1,
            explanation: 'Every engineering decision involves trade-offs. An honest ADR clearly outlines the costs, maintenance overhead, and new constraints along with the benefits.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0215-000000000003',
        title: 'Quiz 3: Incident Management and Blameless Postmortems',
        passing_score: 75,
        order_index: 3,
        questions: [
          {
            id: 'd0000000-0000-0000-0315-000000000013',
            question_text: 'What is the guiding tenet of a blameless postmortem culture?',
            options: ['Never document when an outage occurs', 'View human error as a symptom of fragile systemic designs, and focus investigation on improving guardrails, tools, and processes rather than assigning blame', 'Blame external third-party cloud providers exclusively', 'Punish the engineer who made the commit'],
            correct_option_index: 1,
            explanation: 'Blameless cultures encourage open reporting of mistakes so organizations can engineer systemic safeguards that prevent any single human action from causing catastrophe.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000014',
            question_text: 'What is the primary responsibility of the Incident Commander (IC) during a high-severity production outage?',
            options: ['Writing code to patch the bug directly', 'Coordinating response efforts, assigning investigative roles, facilitating communication, and protecting responders from external interruptions', 'Answering customer support tickets', 'Updating marketing banners on social media'],
            correct_option_index: 1,
            explanation: 'The Incident Commander orchestrates the response team, prevents duplication of work, delegates tasks, and maintains clear status communications without getting bogged down in individual debugging.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000015',
            question_text: 'What is Mean Time to Detect (MTTD)?',
            options: ['The time between the start of an incident and when the engineering team becomes aware of it', 'The time between alert firing and full resolution', 'The duration of the postmortem meeting', 'The time required to roll back code'],
            correct_option_index: 0,
            explanation: 'MTTD measures the latency between the moment an operational failure or bug is introduced and the moment monitoring or customer reports bring it to engineering attention.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000016',
            question_text: 'What makes an incident action item effective in preventing recurring failures?',
            options: ['Telling developers to "be more careful next time"', 'Assigning a single owner, a clear delivery deadline, and an automated technical safeguard (e.g. CI validation or circuit breaker)', 'Archiving the ticket immediately', 'Scheduling weekly meetings indefinitely'],
            correct_option_index: 1,
            explanation: 'Action items must address systemic vulnerabilities with automated technical defenses, specific ownership, and tracked delivery timelines.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000017',
            question_text: 'Why are UTC timestamps strictly required when assembling an incident timeline?',
            options: ['UTC is required by law for all databases', 'UTC provides an unambiguous, universal standard that prevents confusion when coordinating across distributed teams and global cloud regions', 'UTC runs faster than local time', 'UTC eliminates daylight savings adjustments in code only'],
            correct_option_index: 1,
            explanation: 'Distributed teams and cloud infrastructure operate across different time zones. Standardizing on UTC eliminates ambiguity during chronological incident reconstruction.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000018',
            question_text: 'What is a "dark launch" in progressive delivery?',
            options: ['Deploying code at midnight', 'Deploying a feature to production with its user interface disabled or hidden behind a feature flag, allowing backend verification under live production traffic', 'Launching an unencrypted website', 'Deleting all monitoring logs'],
            correct_option_index: 1,
            explanation: 'Dark launches test backend performance, database queries, and system stability under real production load before exposing the new functionality to end users.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0215-000000000004',
        title: 'Quiz 4: Root Cause Analysis and Engineering Tradeoffs',
        passing_score: 75,
        order_index: 4,
        questions: [
          {
            id: 'd0000000-0000-0000-0315-000000000019',
            question_text: 'How does the 5 Whys technique uncover systemic root causes?',
            options: ['By asking five different engineers who caused the problem', 'By repeatedly asking "Why?" to traverse layers of direct symptoms down to underlying procedural, architectural, or organizational deficiencies', 'By limiting the investigation to five minutes', 'By checking five lines of code'],
            correct_option_index: 1,
            explanation: 'The 5 Whys drills past surface-level symptoms to discover the deeper systemic vulnerabilities that allowed the failure to occur in the first place.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000020',
            question_text: 'What are the main branches of an Ishikawa (Fishbone) diagram used for software quality analysis?',
            options: ['HTML, CSS, JavaScript, SQL', 'People, Process, Technology/Tools, Environment, and Management', 'Cost, Revenue, Profit, Margin', 'Input, Processing, Output, Storage'],
            correct_option_index: 1,
            explanation: 'Fishbone diagrams categorize causal factors into structured dimensions (People, Process, Tools, Environment), ensuring that analysis is not narrowly restricted to code alone.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000021',
            question_text: 'What is the Sunk Cost Fallacy in software project management?',
            options: ['Underestimating cloud computing costs', 'Continuing to pour resources into an ineffective or failing approach solely because significant time, money, or effort has already been invested in it', 'Failing to pay open-source maintainers', 'Purchasing discounted hardware'],
            correct_option_index: 1,
            explanation: 'The Sunk Cost Fallacy leads teams to persist with sub-optimal technical choices to justify past expenditures, rather than evaluating future utility objectively.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000022',
            question_text: 'What is Not-Invented-Here (NIH) syndrome?',
            options: ['An aversion to adopting external, existing, and proven solutions, leading teams to build unnecessary in-house custom tools with high maintenance overhead', 'A licensing issue with proprietary software', 'Refusing to hire external contractors', 'Deploying software in foreign cloud regions'],
            correct_option_index: 0,
            explanation: 'NIH syndrome manifests when engineers reject established industry solutions in favor of custom home-grown alternatives, diverting focus from core business value.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000023',
            question_text: 'What does Total Cost of Ownership (TCO) include when evaluating a "Build vs. Buy" architectural decision?',
            options: ['Only the initial software license fee', 'Initial development costs, ongoing maintenance, bug fixing, on-call operational overhead, hosting, security updates, and opportunity costs', 'Only the developer\'s hourly wage', 'The cost of laptop computers'],
            correct_option_index: 1,
            explanation: 'TCO considers the full lifecycle expenses of building and operating software, demonstrating that "free" internal code often incurs high long-term maintenance costs.'
          },
          {
            id: 'd0000000-0000-0000-0315-000000000024',
            question_text: 'What is Confirmation Bias in engineering problem diagnosis?',
            options: ['Requiring two engineers to approve a pull request', 'The tendency to search for, interpret, and favor information that validates pre-existing hypotheses while ignoring contradicting telemetry data', 'Sending email confirmations to customers', 'Verifying database transactions with commit tokens'],
            correct_option_index: 1,
            explanation: 'Confirmation bias leads responders to focus on logs that support their pet theory about an outage, causing them to overlook contradictory evidence that points to the true cause.'
          }
        ]
      }
    ],
    assignments: [
      {
        id: 'd0000000-0000-0000-0415-000000000001',
        title: 'Assignment 1: Comprehensive Software Architecture RFC & Decision Record',
        description: `Author a formal Request for Comments (RFC) and an accompanying Architecture Decision Record (ADR) for a complex software migration:
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
   - Write a formal ADR following standard markdown conventions: Status, Context, Decision, and Consequences (positive and negative).`,
        due_date: '2026-11-26T23:59:59Z',
        rubric: [
          { criterion: 'BLUF & Problem Formulation', max_points: 25, description: 'Clear executive summary with quantified metrics and precise description of existing limitations.' },
          { criterion: 'Architecture Specification & Diagrams', max_points: 25, description: 'Detailed technical design, API contracts, failure modes, and security considerations.' },
          { criterion: 'Weighted Decision Matrix & Alternatives', max_points: 25, description: 'Thorough evaluation of rejected alternatives with explicit scoring across cost, latency, and risk.' },
          { criterion: 'Formal ADR & Consequences', max_points: 25, description: 'Structured ADR accurately capturing positive impacts, operational trade-offs, and technical debt.' }
        ]
      },
      {
        id: 'd0000000-0000-0000-0415-000000000002',
        title: 'Assignment 2: Production Incident Blameless Postmortem and RCA Investigation',
        description: `Investigate and document a simulated high-severity production outage using structured Root Cause Analysis frameworks:
1. **Incident Case Study:**
   Analyze a provided multi-system failure: A primary database failover triggered connection storms across 40 backend microservice instances, saturating connection limits and causing cascading cascading 504 Gateway Timeouts across consumer checkout for 48 minutes.
2. **Incident Reconstruction & Timeline:**
   - Compile a minute-by-minute timeline using UTC timestamps covering trigger, initial alerting, triage steps, mitigation, and recovery.
   - Calculate Mean Time to Detect (MTTD), Mean Time to Acknowledge (MTTA), and Mean Time to Recover (MTTR).
3. **Structured Root Cause Analysis:**
   - Perform a full 5 Whys analysis drilling down from direct error symptoms to organizational CI/CD and capacity testing gaps.
   - Construct an Ishikawa (Fishbone) diagram categorizing contributing factors across People, Process, Tools, and Environment.
4. **Preventive Action Plan & Action Items:**
   - Formulate 4 prioritized corrective action items (preventive, detective, and mitigative) following SMART criteria (Specific, Measurable, Achievable, Relevant, Time-bound), specifying owners and automated architectural defenses (e.g. exponential jittered backoff, circuit breakers, and connection poolers).`,
        due_date: '2026-12-06T23:59:59Z',
        rubric: [
          { criterion: 'Chronological Timeline & MTTR Metrics', max_points: 20, description: 'Accurate UTC timeline tracing events and proper calculation of detection and recovery metrics.' },
          { criterion: '5 Whys Deep-Dive Analysis', max_points: 25, description: 'Rigorous recursive questioning reaching fundamental architectural and cultural failure modes.' },
          { criterion: 'Ishikawa Fishbone Diagram', max_points: 25, description: 'Multi-dimensional categorization of contributing factors avoiding narrow technical bias.' },
          { criterion: 'SMART Action Items & Systemic Defenses', max_points: 30, description: 'Concrete, high-leverage engineering action items implementing automated safeguards.' }
        ]
      }
    ]
  }
];
