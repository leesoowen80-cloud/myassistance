create table if not exists teams (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  name text not null,
  description text,
  created_at timestamptz not null default now()
);

alter table teams enable row level security;
drop policy if exists "teams_v1_read" on teams;
create policy "teams_v1_read" on teams for select using (true);
drop policy if exists "teams_v1_write" on teams;
create policy "teams_v1_write" on teams for all using (true) with check (true);

create table if not exists team_members (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  team_id uuid references teams(id) on delete cascade,
  display_name text not null,
  email text,
  role text not null default 'member',
  created_at timestamptz not null default now()
);

alter table team_members enable row level security;
drop policy if exists "team_members_v1_read" on team_members;
create policy "team_members_v1_read" on team_members for select using (true);
drop policy if exists "team_members_v1_write" on team_members;
create policy "team_members_v1_write" on team_members for all using (true) with check (true);

create table if not exists work_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  team_id uuid references teams(id) on delete cascade,
  title text not null,
  description text,
  status text not null default 'open',
  priority text not null default 'medium',
  assignee_id uuid references team_members(id),
  due_date date,
  tags text,
  tags_source text,
  tags_confidence numeric,
  tags_review_status text default 'unreviewed',
  created_at timestamptz not null default now()
);

alter table work_items enable row level security;
drop policy if exists "work_items_v1_read" on work_items;
create policy "work_items_v1_read" on work_items for select using (true);
drop policy if exists "work_items_v1_write" on work_items;
create policy "work_items_v1_write" on work_items for all using (true) with check (true);

create table if not exists activities (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  team_id uuid references teams(id) on delete cascade,
  work_item_id uuid references work_items(id) on delete cascade,
  actor_name text not null,
  action text not null,
  detail text,
  created_at timestamptz not null default now()
);

alter table activities enable row level security;
drop policy if exists "activities_v1_read" on activities;
create policy "activities_v1_read" on activities for select using (true);
drop policy if exists "activities_v1_write" on activities;
create policy "activities_v1_write" on activities for all using (true) with check (true);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  team_id uuid references teams(id) on delete set null,
  actor_name text not null,
  action text not null,
  target_table text,
  target_id uuid,
  payload jsonb,
  created_at timestamptz not null default now()
);

alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

insert into teams (id, name, description) values
  ('a1000000-0000-0000-0000-000000000001', 'Operations Team', 'Core internal ops department');

insert into team_members (id, team_id, display_name, email, role) values
  ('b1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'Alex Rivera', 'alex@example.com', 'admin'),
  ('b1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000001', 'Jordan Lee', 'jordan@example.com', 'member'),
  ('b1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000001', 'Sam Patel', 'sam@example.com', 'member');

insert into work_items (id, team_id, title, description, status, priority, assignee_id, due_date) values
  ('c1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'Vendor onboarding — Acme Corp', 'Collect W9, set up payment terms, add to supplier list', 'in_progress', 'high', 'b1000000-0000-0000-0000-000000000001', current_date + 3),
  ('c1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000001', 'Monthly compliance report', 'Compile Q2 data and submit to finance by EOM', 'open', 'high', 'b1000000-0000-0000-0000-000000000002', current_date + 7),
  ('c1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000001', 'Update internal SOP for ticket escalation', 'Review current SOP, incorporate feedback from last retro', 'blocked', 'medium', 'b1000000-0000-0000-0000-000000000003', current_date + 14),
  ('c1000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000001', 'IT access review for new hire — Casey Kim', 'Provision email, Slack, drive, and internal tools', 'done', 'medium', 'b1000000-0000-0000-0000-000000000002', current_date - 1),
  ('c1000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000001', 'Reconcile June expense submissions', 'Cross-check receipts vs card statements, flag missing items', 'open', 'low', 'b1000000-0000-0000-0000-000000000001', current_date + 5);

insert into activities (team_id, work_item_id, actor_name, action, detail) values
  ('a1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000001', 'Alex Rivera', 'created', 'Created work item: Vendor onboarding — Acme Corp'),
  ('a1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000001', 'Alex Rivera', 'status_changed', 'Status changed to in_progress'),
  ('a1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000004', 'Jordan Lee', 'created', 'Created work item: IT access review for new hire — Casey Kim'),
  ('a1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000004', 'Jordan Lee', 'status_changed', 'Status changed to done'),
  ('a1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000003', 'Sam Patel', 'status_changed', 'Status changed to blocked — waiting on legal review');