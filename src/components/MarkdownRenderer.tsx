import React, { useMemo } from 'react';
import ReactMarkdown from 'react-markdown';
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';
import 'katex/dist/katex.min.css';

import { preprocessMarkdown } from '../lib/markdown';

interface MarkdownRendererProps {
  content: string;
  className?: string;
  compact?: boolean;
}

export const MarkdownRenderer: React.FC<MarkdownRendererProps> = ({
  content,
  className = '',
  compact = false,
}) => {
  const processed = useMemo(() => preprocessMarkdown(content), [content]);

  if (!processed) {
    return null;
  }

  const baseTextSize = compact ? 'text-xs' : 'text-xs sm:text-sm';
  const headingMargin = compact ? 'mt-2 mb-1' : 'mt-3.5 mb-1.5';
  const listSpacing = compact ? 'space-y-0.5 my-1' : 'space-y-1 my-1.5';

  return (
    <div className={`markdown-content ${baseTextSize} leading-relaxed text-[#1F2421] ${className}`}>
      <ReactMarkdown
        remarkPlugins={[remarkMath]}
        rehypePlugins={[[rehypeKatex, { strict: false, throwOnError: false }]]}
        components={{
          h1: ({ children }) => (
            <h1 className="font-editorial text-lg sm:text-xl font-bold text-[#1F2421] mt-4 mb-2 tracking-tight border-b border-[#E5E2D9] pb-1.5 flex items-center gap-2">
              {children}
            </h1>
          ),
          h2: ({ children }) => (
            <h2 className="font-editorial text-base sm:text-lg font-bold text-[#1F2421] mt-3.5 mb-1.5 tracking-tight flex items-center gap-2">
              {children}
            </h2>
          ),
          h3: ({ children }) => (
            <h3 className={`font-semibold text-[#1F2421] ${headingMargin} flex items-center gap-1.5 ${compact ? 'text-xs' : 'text-xs sm:text-sm'}`}>
              <span className="w-1.5 h-1.5 rounded-full bg-[#1B3B2B] inline-block shrink-0" />
              <span>{children}</span>
            </h3>
          ),
          h4: ({ children }) => (
            <h4 className={`font-semibold text-[#1F2421] ${headingMargin} ${compact ? 'text-[11px]' : 'text-xs'}`}>
              {children}
            </h4>
          ),
          p: ({ children }) => (
            <p className="my-2 leading-relaxed text-[#2D3748]">
              {children}
            </p>
          ),
          strong: ({ children }) => (
            <strong className="font-semibold text-[#1F2421]">
              {children}
            </strong>
          ),
          em: ({ children }) => (
            <em className="italic text-[#1F2421]">
              {children}
            </em>
          ),
          ul: ({ children }) => (
            <ul className={`list-disc pl-5 ${listSpacing} text-[#2D3748] marker:text-[#1B3B2B] [&>li>p]:my-0 [&>li>p]:leading-relaxed [&>li>ul]:my-0.5 [&>li>ol]:my-0.5 [&>li>ul]:pl-4 [&>li>ol]:pl-4`}>
              {children}
            </ul>
          ),
          ol: ({ children }) => (
            <ol className={`list-decimal pl-5 ${listSpacing} text-[#2D3748] marker:text-[#1B3B2B] [&>li>p]:my-0 [&>li>p]:leading-relaxed [&>li>ul]:my-0.5 [&>li>ol]:my-0.5 [&>li>ul]:pl-4 [&>li>ol]:pl-4`}>
              {children}
            </ol>
          ),
          li: ({ children }) => (
            <li className="leading-relaxed">
              {children}
            </li>
          ),
          blockquote: ({ children }) => (
            <blockquote className="border-l-3 border-[#1B3B2B] bg-[#F4F1EA] px-3.5 py-2 my-2.5 rounded-r text-[#1F2421] italic leading-relaxed text-xs">
              {children}
            </blockquote>
          ),
          code: ({ children, ...props }) => {
            return (
              <code
                className="px-1.5 py-0.5 rounded bg-[#F4F1EA] border border-[#E5E2D9] text-[#1B3B2B] font-mono text-[11px] sm:text-xs break-words"
                {...props}
              >
                {children}
              </code>
            );
          },
          pre: ({ children }) => (
            <pre className="p-3.5 my-2.5 rounded-md bg-[#1F2421] border border-[#3A453F] text-[#EAEFE9] font-mono text-[11px] sm:text-xs overflow-x-auto whitespace-pre leading-normal [&>code]:bg-transparent [&>code]:border-0 [&>code]:p-0 [&>code]:text-inherit">
              {children}
            </pre>
          ),
          table: ({ children }) => (
            <div className="overflow-x-auto my-3">
              <table className="w-full text-left border-collapse border border-[#E5E2D9] text-xs rounded-md overflow-hidden">
                {children}
              </table>
            </div>
          ),
          thead: ({ children }) => (
            <thead className="bg-[#F4F1EA] border-b border-[#E5E2D9] text-[#1F2421] font-bold">
              {children}
            </thead>
          ),
          tbody: ({ children }) => (
            <tbody className="divide-y divide-[#E5E2D9] bg-white">
              {children}
            </tbody>
          ),
          tr: ({ children }) => (
            <tr className="hover:bg-[#FAF9F5] transition-colors">
              {children}
            </tr>
          ),
          th: ({ children }) => (
            <th className="p-2.5 font-semibold text-[#1F2421] border-b border-[#E5E2D9]">
              {children}
            </th>
          ),
          td: ({ children }) => (
            <td className="p-2.5 text-[#2D3748] border-b border-[#E5E2D9]">
              {children}
            </td>
          ),
          a: ({ href, children }) => (
            <a
              href={href}
              target="_blank"
              rel="noopener noreferrer"
              className="text-[#1B3B2B] underline decoration-[#1B3B2B]/40 hover:decoration-[#1B3B2B] font-medium"
            >
              {children}
            </a>
          ),
          hr: () => <hr className="border-[#E5E2D9] my-3" />,
        }}
      >
        {processed}
      </ReactMarkdown>
    </div>
  );
};
