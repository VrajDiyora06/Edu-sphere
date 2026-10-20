import React, { useState, useRef, useEffect } from 'react';
import type { DbLesson, DbCourse } from '../types';
import { askLessonDoubt, type DoubtResponse } from '../lib/ai';
import {
  Sparkles,
  Send,
  Loader2,
  AlertCircle,
  HelpCircle,
  Bot,
  User,
  ShieldAlert,
  Info,
} from 'lucide-react';
import { MarkdownRenderer } from './MarkdownRenderer';

interface LessonDoubtPanelProps {
  lesson: DbLesson;
  course: DbCourse;
  userRole: string;
  isEnrolled: boolean;
  studentName?: string;
}

interface ChatMessage {
  id: string;
  sender: 'student' | 'assistant';
  text: string;
  timestamp: string;
  source?: 'ai_provider' | 'fallback';
  model?: string;
  isFallback?: boolean;
  fallbackNotice?: string;
}

function formatTimestamp(): string {
  return new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
}

export const LessonDoubtPanel: React.FC<LessonDoubtPanelProps> = ({
  lesson,
  course,
  userRole,
  isEnrolled,
  studentName: _studentName,
}) => {
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [inputText, setInputText] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const isAuthorized =
    isEnrolled ||
    lesson.is_free_preview ||
    userRole === 'instructor' ||
    userRole === 'admin' ||
    userRole === 'system_admin';

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages, loading]);

  const handleSend = async (questionToSend?: string) => {
    const text = (questionToSend || inputText).trim();
    if (!text || loading) return;

    if (!isAuthorized) {
      setError('Please enroll in this course to ask questions with the AI Doubt Assistant.');
      return;
    }

    const studentMsg: ChatMessage = {
      id: crypto.randomUUID(),
      sender: 'student',
      text,
      timestamp: formatTimestamp(),
    };

    setMessages((prev) => [...prev, studentMsg]);
    setInputText('');
    setLoading(true);
    setError(null);

    const response: DoubtResponse = await askLessonDoubt({
      lessonId: lesson.id,
      lessonTitle: lesson.title,
      lessonContent: lesson.content,
      courseTitle: course.title,
      courseCategory: course.category,
      question: text,
      userRole,
      isEnrolled,
      isFreePreview: lesson.is_free_preview,
    });

    setLoading(false);

    if (!response.success || !response.answer) {
      setError(response.error || 'Failed to generate answer. Please try again.');
      return;
    }

    const assistantMsg: ChatMessage = {
      id: crypto.randomUUID(),
      sender: 'assistant',
      text: response.answer,
      timestamp: formatTimestamp(),
      source: response.source,
      model: response.model,
      isFallback: response.isFallback,
      fallbackNotice: response.fallbackNotice,
    };

    setMessages((prev) => [...prev, assistantMsg]);
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  };

  const starterPrompts = [
    `Summarize the key technical principles of "${lesson.title}".`,
    `What are common pitfalls or errors encountered with this topic?`,
    `Give a practical real-world scenario where this concept applies.`,
  ];

  return (
    <div className="flex flex-col h-full min-h-0 bg-[#FAF9F5] rounded-lg border border-[#E5E2D9] overflow-hidden">
      
      {/* Panel Header */}
      <div className="p-3 sm:px-4 bg-[#F4F1EA] border-b border-[#E5E2D9] flex items-center justify-between shrink-0">
        <div className="flex items-center gap-2.5">
          <div className="w-7 h-7 rounded bg-[#1B3B2B] flex items-center justify-center text-white shadow-2xs">
            <Sparkles className="w-3.5 h-3.5" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h4 className="text-xs font-bold text-[#1F2421]">AI Academic Tutor</h4>
              <span className="px-2 py-0.5 rounded text-[10px] font-semibold bg-[#EAEFE9] text-[#1B3B2B] border border-[#C8D6CA]">
                Curriculum Grounded
              </span>
            </div>
            <p className="text-[11px] text-[#535C56] truncate max-w-[280px] sm:max-w-md">
              Referencing: <span className="text-[#1F2421] font-medium">{lesson.title}</span>
            </p>
          </div>
        </div>

        <div className="text-[11px] text-[#535C56] font-mono hidden sm:block">
          {lesson.content ? 'Lesson Notes Indexed' : 'Summary Context'}
        </div>
      </div>

      {/* Access Warning if not enrolled and not preview */}
      {!isAuthorized && (
        <div className="m-3 p-3 rounded-md bg-[#FDF6F5] border border-[#F2D6D0] flex items-start gap-2.5 text-xs text-[#782617] shrink-0">
          <ShieldAlert className="w-4 h-4 text-[#9E3D2B] shrink-0 mt-0.5" />
          <div>
            <p className="font-semibold text-[#782617]">Lesson Assistance Restricted</p>
            <p className="text-[11px] text-[#9E3D2B] mt-0.5">
              Enroll in this course with your student account to unlock interactive AI doubt resolution.
            </p>
          </div>
        </div>
      )}

      {/* Messages Scroll Area */}
      <div className="flex-1 p-4 sm:p-5 overflow-y-auto min-h-0 space-y-4 text-xs bg-[#FAF9F5]">
        {messages.length === 0 && (
          <div className="h-full flex flex-col items-center justify-center text-center p-4 space-y-3">
            <div className="w-11 h-11 rounded-lg bg-[#EAEFE9] border border-[#C8D6CA] flex items-center justify-center text-[#1B3B2B]">
              <Bot className="w-5 h-5" />
            </div>
            <div className="space-y-1 max-w-sm">
              <h5 className="font-editorial font-bold text-[#1F2421] text-base">Have a doubt about this lesson?</h5>
              <p className="text-[#535C56] text-xs">
                Ask about definitions, architecture, or code covered in{' '}
                <span className="text-[#1B3B2B] font-medium">{lesson.title}</span>.
              </p>
            </div>

            {/* Quick Prompts */}
            <div className="w-full max-w-md pt-2 space-y-2 text-left">
              <div className="text-[10px] font-bold uppercase tracking-wider text-[#535C56]">
                Suggested Questions:
              </div>
              {starterPrompts.map((prompt, idx) => (
                <button
                  key={idx}
                  onClick={() => handleSend(prompt)}
                  disabled={!isAuthorized || loading}
                  className="w-full text-left p-2.5 rounded-md bg-white hover:bg-[#F4F1EA] border border-[#E5E2D9] hover:border-[#C8D6CA] text-[#1F2421] text-xs transition-colors flex items-center justify-between group disabled:opacity-40 cursor-pointer shadow-2xs"
                >
                  <span className="truncate">{prompt}</span>
                  <HelpCircle className="w-3.5 h-3.5 text-[#7A857E] group-hover:text-[#1B3B2B] shrink-0 ml-2" />
                </button>
              ))}
            </div>
          </div>
        )}

        {messages.map((msg) => (
          <div
            key={msg.id}
            className={`flex gap-3 ${msg.sender === 'student' ? 'justify-end' : 'justify-start'}`}
          >
            {msg.sender === 'assistant' && (
              <div className="w-7 h-7 rounded bg-[#EAEFE9] border border-[#C8D6CA] flex items-center justify-center text-[#1B3B2B] shrink-0 mt-0.5 shadow-2xs">
                <Bot className="w-4 h-4" />
              </div>
            )}

            <div
              className={`max-w-[88%] sm:max-w-[85%] rounded-lg p-4 space-y-2 ${
                msg.sender === 'student'
                  ? 'bg-[#1B3B2B] text-white shadow-2xs'
                  : 'bg-white border border-[#E5E2D9] text-[#1F2421] shadow-2xs'
              }`}
            >
              {/* Header inside assistant message */}
              {msg.sender === 'assistant' && (
                <div className="flex items-center justify-between gap-2 pb-2 border-b border-[#E5E2D9] text-[10px]">
                  <div className="flex items-center gap-1.5">
                    {msg.source === 'ai_provider' ? (
                      <span className="px-1.5 py-0.5 rounded bg-[#EAEFE9] text-[#1B3B2B] border border-[#C8D6CA] font-medium">
                        {msg.model || 'Gemini 3.8 Flash'}
                      </span>
                    ) : (
                      <span className="px-1.5 py-0.5 rounded bg-[#F4F1EA] text-[#535C56] border border-[#E5E2D9] font-medium">
                        Curriculum Assistant
                      </span>
                    )}
                  </div>
                  <span className="text-[#7A857E] font-mono">{msg.timestamp}</span>
                </div>
              )}

              {/* Message text */}
              {msg.sender === 'assistant' ? (
                <MarkdownRenderer content={msg.text} />
              ) : (
                <div className="leading-relaxed whitespace-pre-line text-xs font-normal">
                  {msg.text}
                </div>
              )}

              {/* Fallback Notice Banner */}
              {msg.isFallback && (
                <div className="mt-2.5 pt-2 border-t border-[#E5E2D9] flex items-center gap-1.5 text-[11px] text-[#535C56]">
                  <Info className="w-3.5 h-3.5 text-[#7A857E] shrink-0" />
                  <span>{msg.fallbackNotice || 'Answer compiled from verified lesson curriculum.'}</span>
                </div>
              )}
            </div>

            {msg.sender === 'student' && (
              <div className="w-7 h-7 rounded bg-[#2D3748] text-white flex items-center justify-center shrink-0 mt-0.5 shadow-2xs">
                <User className="w-4 h-4" />
              </div>
            )}
          </div>
        ))}

        {loading && (
          <div className="flex gap-3 justify-start items-center text-[#535C56]">
            <div className="w-7 h-7 rounded bg-[#EAEFE9] border border-[#C8D6CA] flex items-center justify-center text-[#1B3B2B] shrink-0">
              <Loader2 className="w-4 h-4 animate-spin" />
            </div>
            <div className="p-3 rounded-md bg-white border border-[#E5E2D9] text-xs text-[#535C56] flex items-center gap-2 shadow-2xs">
              <span className="animate-pulse">Analyzing lesson curriculum and generating explanation...</span>
            </div>
          </div>
        )}

        {error && (
          <div className="p-3 rounded-md bg-[#FDF6F5] border border-[#F2D6D0] text-[#9E3D2B] text-xs flex items-center gap-2">
            <AlertCircle className="w-4 h-4 shrink-0 text-[#9E3D2B]" />
            <span>{error}</span>
          </div>
        )}

        <div ref={messagesEndRef} />
      </div>

      {/* Input Field */}
      <div className="p-3 sm:p-4 bg-white border-t border-[#E5E2D9] shrink-0">
        <div className="flex items-center gap-2">
          <input
            type="text"
            value={inputText}
            onChange={(e) => setInputText(e.target.value)}
            onKeyDown={handleKeyDown}
            disabled={!isAuthorized || loading}
            placeholder={
              isAuthorized
                ? `Ask a question about "${lesson.title}"...`
                : 'Enroll in course to ask questions...'
            }
            className="academic-input py-2 text-xs"
          />
          <button
            onClick={() => handleSend()}
            disabled={!inputText.trim() || !isAuthorized || loading}
            className="btn-forest py-2 px-3 text-xs shrink-0 flex items-center gap-1.5"
            title="Send Question"
          >
            {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Send className="w-4 h-4" />}
          </button>
        </div>
      </div>
    </div>
  );
};

