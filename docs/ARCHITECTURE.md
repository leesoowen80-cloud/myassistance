# Architecture — myassistance

## Stack
- **Frontend:** Next.js 14 (App Router) + Tailwind CSS
- **Backend/DB:** Supabase (Postgres + RLS + Realtime)
- **Hosting:** Vercel

## Build Sequence
**Now:** DB schema → work item CRUD → dashboard → activity feed 
**Next:** Auth, RLS lock-down, role enforcement, filters 
**Later:** AI tagging, workload scoring, notifications, exports

## Key User Action — "Log a work item"
1. Member fills **New Item** form in the browser
2. Next.js API route validates input and writes a row to `work_items`
3. Same route appends a row to `activities` and `audit_logs`
4. Supabase Realtime broadcasts the insert to all connected clients
5. Dashboard table and activity feed re-render live — no page reload needed

## Layer Plan
1. **Data first** — tables, seed rows, permissive RLS so demo works without login
2. **App logic** — CRUD routes, status transitions, activity writes, filter queries
3. **Smart features** — AI tagging, workload scores, notifications (added after core is stable)

## Core Without AI
All create/edit/delete/list operations are pure Postgres queries. AI fields (`tags`, `tags_confidence`, etc.) are nullable — removing the AI layer leaves a fully functional ops tool.
