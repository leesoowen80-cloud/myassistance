# Product Requirements — myassistance

## Problem
The team tracks recurring operational work across spreadsheets and chat threads. Records go stale, ownership is unclear, and status is always out of date. There is no single place anyone can trust.

## Target User
Internal operations team (3–15 people). Daily users who log, update, and check the status of shared work items.

## Core Objects
- **Work Item** — the unit of work: title, description, status, priority, assignee, due date
- **Team Member** — name, email, role (admin / member)
- **Activity** — append-only log of every change to a work item
- **Audit Log** — system-level record of every write action

## MVP Must-Haves
- [ ] Create a work item (title, description, status, priority, assignee, due date)
- [ ] Edit any field on a work item
- [ ] Delete a work item (with confirmation)
- [ ] Dashboard table showing all items with status badges and assignee
- [ ] Activity feed showing the latest changes across all items
- [ ] Stat cards: Open / In Progress / Blocked / Done counts
- [ ] Filter by status and assignee
- [ ] App loads with demo data — no login required to view

## Non-Goals (v1)
- User authentication and per-user data isolation
- Email notifications
- AI tagging or scoring
- Recurring workflow templates
- Reporting exports

## Success Criteria
A team member opens `/dashboard`, sees all five seeded work items, clicks **New Item**, fills the form, saves — the new row appears in the table and in the activity feed within two seconds. A colleague on a different machine refreshes and sees the same new item.
