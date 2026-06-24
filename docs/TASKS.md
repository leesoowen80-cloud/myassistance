# Tasks — myassistance

## Gantt Overview
```
Sprint 1 (days 1–3): DB + core work-item engine (create/edit/delete/list)
Sprint 2 (days 4–5): Dashboard polish + filters          ← v1 FUNCTIONAL
Sprint 3 (days 6–7): Lock it down (auth + RLS)
Sprint 4 (days 8–10): Intelligence + notifications
```

---

## Sprint 1 — DB & Core Work-Item Engine
**Goal:** Any visitor can open /dashboard and log, edit, and delete real work items that persist to the database.

- [ ] Run migration SQL — all tables created, seed data loaded
- [ ] `/dashboard` page renders work items table from DB (no login wall)
- [ ] **New Item** button opens form modal with all fields
- [ ] Form submit → POST `/api/work-items` → inserts row + activity row + audit row
- [ ] Edit icon → opens pre-filled modal → PATCH `/api/work-items/[id]` → updates row + logs activity
- [ ] Delete button → confirmation dialog → DELETE `/api/work-items/[id]` → removes row + logs audit
- [ ] Activity feed panel reads from `activities` table, shows last 20 entries
- [ ] Empty state: "No work items yet — add the first one" with CTA
- [ ] Loading skeleton on data fetch; error toast on failure

**Definition of Done:** Create, edit, delete all persist and reflect in UI. Activity feed updates. No dead buttons.

---

## Sprint 2 — Dashboard Polish & Team Visibility ✅ v1 FUNCTIONAL
**Goal:** The dashboard is the team's daily operating screen — scannable, filterable, reliable.

- [ ] Status badge colours: Open=blue, In Progress=yellow, Blocked=red, Done=green
- [ ] Priority badge: High=red, Medium=orange, Low=grey
- [ ] Stat cards row: Open / In Progress / Blocked / Done counts
- [ ] Filter bar: by status (dropdown), by assignee (dropdown), reset button
- [ ] Overdue highlight: due_date < today AND status ≠ done → row tinted red
- [ ] Default sort: overdue first → priority desc → due date asc
- [ ] Assignee column shows display_name from team_members
- [ ] Responsive layout: table scrolls horizontally on small screens
- [ ] Manual test pass against TEST_PLAN.md

**Definition of Done:** Success scenario from PRD is fully usable. Filters work. Overdue items flagged.

---

## Sprint 3 — Lock It Down
**Goal:** Real user accounts; data scoped to authenticated team members.

- [ ] Enable Supabase Auth (email/password)
- [ ] Login and Sign-up pages at `/login` and `/signup`
- [ ] Replace permissive RLS policies with `auth.uid() = user_id` owner policies
- [ ] API route middleware: reject unauthenticated writes with 401
- [ ] Role check in middleware: admin-only routes guarded
- [ ] Dashboard remains publicly readable; write actions redirect to login if not authed
- [ ] Link `team_members.user_id` to `auth.uid()` on signup

**Definition of Done:** Unauthenticated user can view but not write. Authenticated member can do full CRUD on their team's items only.

---

## Sprint 4 — Intelligence & Notifications
**Goal:** Reduce manual work with smart tagging and proactive updates.

- [ ] `suggest_tags` edge function: on work item create, call LLM, write AI tag fields
- [ ] Dashboard shows AI tags as chips with "unreviewed" indicator; one-click accept/reject
- [ ] Workload score badge per assignee (rule-based: count of open+in_progress items)
- [ ] In-app notification dot when an item is assigned to the logged-in user
- [ ] Admin audit log viewer page at `/admin/audit`
- [ ] Weekly digest email via Supabase Edge Function + cron

**Definition of Done:** Tags appear automatically; accepted tags persist; workload scores visible; notification triggers on assignment.
