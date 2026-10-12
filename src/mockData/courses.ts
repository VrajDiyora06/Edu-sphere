import type { Course } from '../types';

export const MOCK_COURSES: Course[] = [
  {
    id: 'course-1',
    title: 'Modern Web Development with React 18 & TypeScript',
    slug: 'react-typescript-web-dev',
    description: 'Master full-stack modern web application development using React 18, TypeScript, Tailwind CSS, and component-driven software design principles.',
    category: 'Web Development',
    level: 'Beginner',
    thumbnailUrl: 'https://images.unsplash.com/photo-1633356122544-f134324a6cee?q=80&w=800&auto=format&fit=crop',
    instructorName: 'Dr. Aris Vance',
    instructorTitle: 'Senior Frontend Architect & Educator',
    instructorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop',
    isPublished: true,
    enrolledCount: 1420,
    rating: 4.9,
    modulesCount: 3,
    lessonsCount: 6,
    totalDurationHours: 4.5,
    modules: [
      {
        id: 'mod-1',
        title: 'Module 1: React 18 Core Concepts & TS Syntax',
        description: 'Learn JSX, props, state, component lifecycle, and TypeScript interfaces.',
        orderIndex: 1,
        lessons: [
          {
            id: 'les-1-1',
            title: 'Lesson 1.1: Introduction to JSX & Component Trees',
            content: 'JSX allows you to write HTML-like markup inside JavaScript files. Learn how React renders virtual DOM trees efficiently.',
            videoUrl: 'https://www.youtube.com/embed/SqcY0GlETPk',
            durationMinutes: 25,
            isFreePreview: true,
            orderIndex: 1,
            resources: [
              { id: 'res-1', title: 'React 18 Cheatsheet (PDF)', fileUrl: '#', fileType: 'PDF' },
              { id: 'res-2', title: 'Starter Code Repository', fileUrl: '#', fileType: 'ZIP' }
            ]
          },
          {
            id: 'les-1-2',
            title: 'Lesson 1.2: State Management with useState & useReducer',
            content: 'Understand how React manages reactive UI state and handles re-renders.',
            videoUrl: 'https://www.youtube.com/embed/w7ejDZ8SWv8',
            durationMinutes: 35,
            isFreePreview: false,
            orderIndex: 2
          }
        ],
        quiz: {
          id: 'quiz-1',
          title: 'React Fundamentals Assessment',
          passingScore: 70,
          questions: [
            {
              id: 'q1-1',
              questionText: 'What is the primary benefit of using TypeScript with React components?',
              explanation: 'TypeScript provides static compile-time type checking, reducing runtime errors.',
              options: [
                { id: 'opt-1', optionText: 'Static compile-time type safety and enhanced IDE autocompletion' },
                { id: 'opt-2', optionText: 'It makes React code run 5x faster in the browser' },
                { id: 'opt-3', optionText: 'It eliminates the need to use CSS in web apps' }
              ]
            },
            {
              id: 'q1-2',
              questionText: 'Which React hook should be used to manage local component state?',
              options: [
                { id: 'opt-4', optionText: 'useState' },
                { id: 'opt-5', optionText: 'useEffect' },
                { id: 'opt-6', optionText: 'useContext' }
              ]
            }
          ]
        }
      },
      {
        id: 'mod-2',
        title: 'Module 2: Tailwind CSS & Design System Architecture',
        description: 'Build responsive, accessible user interfaces using utility-first CSS.',
        orderIndex: 2,
        lessons: [
          {
            id: 'les-2-1',
            title: 'Lesson 2.1: Modern Utility-First Styling Patterns',
            content: 'Explore flexbox, grid, glassmorphism, and responsive break-points.',
            videoUrl: 'https://www.youtube.com/embed/dFgzHOX84xQ',
            durationMinutes: 40,
            isFreePreview: true,
            orderIndex: 1
          }
        ]
      }
    ]
  },
  {
    id: 'course-2',
    title: 'Database Engineering with PostgreSQL & Supabase',
    slug: 'postgresql-supabase-database-engineering',
    description: 'Learn relational database modeling, SQL queries, Row Level Security (RLS) policies, and serverless backend architecture.',
    category: 'Databases & Backend',
    level: 'Intermediate',
    thumbnailUrl: 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?q=80&w=800&auto=format&fit=crop',
    instructorName: 'Prof. Marcus Chen',
    instructorTitle: 'Database Systems Specialist',
    instructorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&auto=format&fit=crop',
    isPublished: true,
    enrolledCount: 980,
    rating: 4.8,
    modulesCount: 2,
    lessonsCount: 4,
    totalDurationHours: 3.8,
    modules: [
      {
        id: 'mod-db-1',
        title: 'Module 1: Relational Schema Design & SQL Optimization',
        description: 'Primary keys, foreign keys, indexes, and normalization.',
        orderIndex: 1,
        lessons: [
          {
            id: 'les-db-1',
            title: 'Lesson 1.1: Designing Normalized Relational Schemas',
            content: 'Master Third Normal Form (3NF) and foreign key CASCADE rules.',
            videoUrl: 'https://www.youtube.com/embed/qw--VTLTIGU',
            durationMinutes: 30,
            isFreePreview: true,
            orderIndex: 1
          }
        ]
      }
    ]
  },
  {
    id: 'course-3',
    title: 'Artificial Intelligence & Large Language Models in Practice',
    slug: 'ai-llm-practical-applications',
    description: 'Understand prompt engineering, vector embeddings, RAG pipelines, and integrating Gemini API into modern web applications.',
    category: 'AI & Data Science',
    level: 'Advanced',
    thumbnailUrl: 'https://images.unsplash.com/photo-1677442136019-21780efad99a?q=80&w=800&auto=format&fit=crop',
    instructorName: 'Dr. Elena Rostova',
    instructorTitle: 'AI Research Lead',
    instructorAvatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=200&auto=format&fit=crop',
    isPublished: true,
    enrolledCount: 2150,
    rating: 5.0,
    modulesCount: 4,
    lessonsCount: 8,
    totalDurationHours: 6.0,
    modules: [
      {
        id: 'mod-ai-1',
        title: 'Module 1: Fundamentals of Generative AI & APIs',
        description: 'How Transformer architectures process context windows.',
        orderIndex: 1,
        lessons: [
          {
            id: 'les-ai-1',
            title: 'Lesson 1.1: Context Windows & Temperature Tuning',
            content: 'Learn parameters governing generative output determinism and creativity.',
            videoUrl: 'https://www.youtube.com/embed/aircAruvnKk',
            durationMinutes: 45,
            isFreePreview: true,
            orderIndex: 1
          }
        ]
      }
    ]
  }
];

export const MOCK_CATEGORIES = [
  'All Categories',
  'Web Development',
  'Databases & Backend',
  'AI & Data Science',
  'Software Architecture'
];
