import React from 'react';
import { renderToString } from 'react-dom/server';
import ReactMarkdown from 'react-markdown';
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';

export function preprocessMarkdown(raw) {
  if (!raw) return '';

  let text = raw.replace(/\r\n/g, '\n');

  // Normalize escaped newlines if text is a single escaped string
  if (text.includes('\\n') && !text.includes('\n')) {
    text = text.replace(/\\n/g, '\n');
  }

  // Normalize double-escaped LaTeX commands: \\text{ -> \text{
  text = text.replace(/\\\\(text|frac|le|ge|approx|cdot|quad|qquad|times|sqrt|pm|sum|prod|int|partial|alpha|beta|gamma|delta|lambda|mu|sigma|omega|mathbb|mathcal|mathbf|neq|in|infty|sim|left|right|dots|ldots)/g, '\\$1');

  // Normalize display math delimiters: \[ ... \] or \\[ ... \\] -> $$ ... $$
  text = text.replace(/(?:\\\\|\\)\[([\s\S]*?)(?:\\\\|\\)\]/g, (_m, c) => {
    return `\n\n$$\n${c.trim()}\n$$\n\n`;
  });

  // Normalize inline math delimiters: \( ... \) or \\( ... \\) -> $ ... $
  text = text.replace(/(?:\\\\|\\)\(([\s\S]*?)(?:\\\\|\\)\)/g, (_m, c) => {
    return `$${c.trim()}$`;
  });

  // Clean up whitespace inside inline math ($ math $ -> $math$) so remark-math parses it
  text = text.replace(/(?<!\$)\$(?!\$)([^\$\n]+?)(?<!\$)\$(?!\$)/g, (match, inner) => {
    const trimmed = inner.trim();
    if (!trimmed) return match;
    return `$${trimmed}$`;
  });

  return text;
}

const samples = [
  `1. **Bottom-Line Upfront (BLUF):** State the decision or finding in the very first sentence.
2. **Active Voice and Direct Ownership:**
   - *Weak:* "It was determined that latency degradation was experienced."
   - *Strong:* "The database connection pool saturated, increasing 99th percentile API latency from 45ms to 1,200ms."
3. **Specific Quantified Metrics:** Avoid words like "fast", "scalable", or "large". Use concrete numbers ($p99 < 50\\text{ ms}$, throughput $> 15,000\\text{ RPS}$).
   - Peak target: $p_{99} < 50\\,\\text{ms}$
   - Capacity: $$\\text{Throughput} = 15{,}000\\ \\text{RPS}$$
   - Escaped LaTeX: \\[ \\text{QPS} = \\frac{N}{\\text{latency}} \\] and \\( \\lambda = 0.95 \\)`
];

for (const s of samples) {
  const processed = preprocessMarkdown(s);
  console.log('PROCESSED:\n', processed);

  const html = renderToString(
    React.createElement(
      ReactMarkdown,
      {
        remarkPlugins: [remarkMath],
        rehypePlugins: [[rehypeKatex, { strict: false, throwOnError: false }]],
      },
      processed
    )
  );

  console.log('\n--- RENDERED HTML SNIPPETS ---');
  console.log('Includes <ol>: ', html.includes('<ol>'));
  console.log('Includes <ul>: ', html.includes('<ul>'));
  console.log('Includes katex-display: ', html.includes('katex-display'));
  console.log('Includes katex: ', html.includes('class="katex"'));
  console.log('Total HTML length: ', html.length);
}
