/**
 * Markdown and LaTeX preprocessing utilities for EduSphere.
 * Normalizes TeX delimiters (\[..\], \(..\), and double-escaped variants) into standard
 * Markdown math syntax ($..$, $$..$$) for clean KaTeX parsing across Gemini responses,
 * curriculum notes, and fallback answers.
 */
export function preprocessMarkdown(raw: string): string {
  if (!raw) return '';

  let text = raw.replace(/\r\n/g, '\n');

  // If escaped newlines exist without raw newlines (e.g. raw JSON strings), normalize them
  if (text.includes('\\n') && !text.includes('\n')) {
    text = text.replace(/\\n/g, '\n');
  }

  // 1. Normalize double-escaped common LaTeX commands: \\text{ -> \text{
  text = text.replace(
    /\\\\(text|frac|le|ge|approx|cdot|quad|qquad|times|sqrt|pm|sum|prod|int|partial|alpha|beta|gamma|delta|lambda|mu|sigma|omega|mathbb|mathcal|mathbf|neq|in|infty|sim|left|right|dots|ldots)/g,
    '\\$1'
  );

  // 2. Normalize LaTeX display math: \[ ... \] or \\[ ... \\] -> $$ ... $$
  text = text.replace(/(?:\\\\|\\)\[([\s\S]*?)(?:\\\\|\\)\]/g, (_m, content) => {
    return `\n\n$$\n${content.trim()}\n$$\n\n`;
  });

  // 3. Normalize LaTeX inline math: \( ... \) or \\( ... \\) -> $...$
  text = text.replace(/(?:\\\\|\\)\(([\s\S]*?)(?:\\\\|\\)\)/g, (_m, content) => {
    return `$${content.trim()}$`;
  });

  // 4. Clean up whitespace directly inside single-dollar inline math delimiters
  // e.g. "$ p_{99} < 50\,\text{ms} $" -> "$p_{99} < 50\,\text{ms}$" so remark-math recognizes it
  text = text.replace(/(?<!\$)\$(?!\$)([^\$\n]+?)(?<!\$)\$(?!\$)/g, (match, inner) => {
    const trimmed = inner.trim();
    if (!trimmed) return match;
    return `$${trimmed}$`;
  });

  return text;
}

export function sanitizeMathDelimiters(markdown: string): string {
  // Gracefully close trailing unclosed display math delimiters emitted by streaming LLMs
  const countDisplay = (markdown.match(/\$\$/g) || []).length;
  if (countDisplay % 2 !== 0) {
    return markdown + '\n$$\n';
  }
  return markdown;
}
