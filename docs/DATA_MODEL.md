# Data Model — myassistance

## teams
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | gen_random_uuid() |
| user_id | uuid | nullable; owner at lock-down |
| name | text | required |
| description | text | optional |
| created_at | timestamptz | auto |

## team_members
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable; links to auth.uid() at lock-down |
| team_id | uuid FK → teams | |
| display_name | text | required |
| email | text | |
| role | text | 'admin' \| 'member' \| 'viewer' |
| created_at | timestamptz | auto |

## work_items
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| team_id | uuid FK → teams | |
| title | text | required |
| description | text | |
| status | text | open \| in_progress \| blocked \| done |
| priority | text | low \| medium \| high |
| assignee_id | uuid FK → team_members | |
| due_date | date | |
| tags | text | **AI field** |
| tags_source | text | e.g. 'gpt-4o' |
| tags_confidence | numeric | 0–1 |
| tags_review_status | text | 'unreviewed' \| 'accepted' \| 'rejected' |
| created_at | timestamptz | auto |

## activities
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| team_id | uuid FK → teams | |
| work_item_id | uuid FK → work_items | |
| actor_name | text | display name of who acted |
| action | text | created \| edited \| status_changed \| deleted |
| detail | text | human-readable description |
| created_at | timestamptz | auto |

## audit_logs
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| team_id | uuid FK → teams | |
| actor_name | text | |
| action | text | |
| target_table | text | |
| target_id | uuid | |
| payload | jsonb | full before/after snapshot |
| created_at | timestamptz | auto |

## RLS
All tables: permissive v1 policies (select + all) — replaced with `auth.uid() = user_id` at lock-down sprint.
