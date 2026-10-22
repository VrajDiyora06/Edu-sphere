# EduSphere Software Configuration Management (SCM) Plan

This document summarizes the Software Configuration Management processes defined in Tutorial 14 for the EduSphere platform.

## 1. Configuration Items (CIs)

| CI ID | Item | Example Paths | Purpose |
|---|---|---|---|
| CI-01 | Frontend source code | `src/pages/`, `src/components/` | User interfaces and interactive views |
| CI-02 | Shared logic & API helpers | `src/lib/` | Supabase clients, access control, media |
| CI-03 | Database schema & migrations | `supabase/migrations/` | Tables, functions, triggers, RLS policies |
| CI-04 | Storage & media configuration | `supabase/`, `src/lib/media.ts` | Course covers, videos, attachment buckets |
| CI-05 | Automated test suite | `scripts/` | RBAC validation, regression scripts |
| CI-06 | Build & dependency configs | `package.json`, `vite.config.ts`, `tsconfig.json` | Reproducible builds |
| CI-07 | Environment templates | `.env.example` | Credential templates without secrets |
| CI-08 | Project documentation | `README.md`, `docs/`, tutorial reports | Architecture and release notes |

## 2. Branching Strategy

- **`main`**: Production-ready, stable baseline for evaluation and submission.
- **`feature/*`**: Short-lived task branches (`feature/course-video-upload`, `feature/quiz-attempt-review`, `feature/ai-doubt-assistant`).
- **`fix/*`**: Bug fixes for identified defects (`fix/student-course-access`).
- **`docs/*`**: Documentation updates and tutorial submissions (`docs/tutorial-14-scm`).

## 3. Configuration Audit Checklist

1. **Functional Configuration Audit (FCA)**:
   - Verification of Student, Instructor, and Admin roles.
   - Row-Level Security policy enforcement across tables.
   - Server-side scoring for quizzes.
2. **Physical Configuration Audit (PCA)**:
   - Clean git status with all CIs tracked.
   - Complete absence of leaked secrets or real `.env` files.
   - Clear reproduction steps from clean checkout.
