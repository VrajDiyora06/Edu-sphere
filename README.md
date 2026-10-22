# EduSphere - Learning Management Platform

EduSphere is a full-stack learning management platform designed for students, instructors, and administrators. Built with React 19, TypeScript, Vite, Tailwind CSS, and Supabase.

## Features

- **Role-Based Access Control**: Tailored experiences for Students, Instructors, and Platform Admins.
- **Academic Catalog**: Curated course tracks spanning AI & Emerging Technologies, Computer Science, Engineering, Mathematics, and Professional Skills.
- **Student Dashboard**: Track course progress, manage enrolled curriculums, and generate completion certificates.
- **Interactive Lessons**: Video lecture streaming with an integrated AI Doubt Assistant supporting LaTeX math and Markdown rendering.
- **Quizzes & Assignments**: Auto-graded assessments with passing score thresholds, plus file attachment submissions for project coursework.
- **Instructor Studio**: Comprehensive course authoring environment to manage modules, lessons, quizzes, and grade submissions.
- **Admin Portal**: System diagnostics, user role administration, and catalog maintenance with Row-Level Security (RLS) enforcement.

## Tech Stack

- **Frontend**: React 19, TypeScript, Vite, Tailwind CSS v4, Lucide Icons
- **Markdown & Math**: KaTeX, react-markdown, remark-math, rehype-katex
- **Backend & Database**: Supabase (PostgreSQL, Row-Level Security, Storage Buckets, Triggers)
- **AI Engine**: Google Gemini 1.5 Flash tutor integration via Vite server proxy
- **Linting**: Oxlint

## Getting Started

### Prerequisites

- Node.js (v18 or higher)
- npm or yarn

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/VrajDiyora06/Edu-sphere.git
   cd Edu-sphere
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure environment variables:
   Copy `.env.example` to `.env` and fill in your Supabase credentials:
   ```bash
   cp .env.example .env
   ```

4. Run database migrations:
   Apply the SQL files in `supabase/migrations/` sequentially to your Supabase project.

5. Start the development server:
   ```bash
   npm run dev
   ```

## Contributors

- **Jenil Gabani** - [23BCE076@nirmauni.ac.in](mailto:23BCE076@nirmauni.ac.in)
- **Vraj Diyora** - [diyoravraj@gmail.com](mailto:diyoravraj@gmail.com)
