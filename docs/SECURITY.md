# Security — myassistance

## Secret Handling
- `SUPABASE_SERVICE_ROLE_KEY` lives only in Vercel server-side env vars — never in client bundles
- All browser calls use the anon key + RLS, not the service role key
- No third-party API keys exposed in frontend code

## Permission Model (end state, reached at lock-down sprint)
| Role | Can do |
|---|---|
| Admin | Full CRUD on all items; manage members; view audit log |
| Member | Create/edit own items; edit any item in team; no member management |
| Viewer | Read-only dashboard |

- v1: permissive RLS (open for demo)
- Lock-down sprint: replace with `auth.uid() = user_id` owner policies; role checked in API route middleware

## Approved-Tools Rule
Agent functions are named, scoped, and imported explicitly. No dynamic `eval`, no `run_any` or `send_any` wrappers. Each tool file exports exactly one action.

## Audit Principle
Every write to `work_items` or `team_members` appends a row to `audit_logs` with actor, action, target, and full payload. Audit rows are insert-only (no update or delete policy).
