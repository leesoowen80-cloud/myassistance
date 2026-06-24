# Agentic Layer — myassistance

## Risk Levels & Actions

### Low — auto-execute (no approval needed)
- Auto-tag a work item on create → writes `tags` + `tags_source` + `tags_confidence` + `tags_review_status='unreviewed'`
- Generate a one-line status summary for the dashboard card

### Medium — light approval (member confirms before write)
- Reassign a work item to a different member (agent drafts → user clicks Confirm)
- Change status in bulk for a filtered set

### High — always approval (explicit human click)
- Send an external notification (email/Slack) about a blocked item
- Mark a set of items done via a batch action

### Critical — human-only (no agent involvement)
- Delete a work item or bulk-delete
- Change a member's role to admin

## Named Tools (approved list)
- `suggest_tags(work_item_id)` — calls LLM, writes AI fields only
- `draft_reassign(work_item_id, new_assignee_id)` — creates a pending action row
- `send_notification(work_item_id, channel)` — after explicit approval only

## Audit Log Fields
`actor_name`, `action`, `target_table`, `target_id`, `payload (jsonb)`, `created_at`

## v1 vs Later
- **v1:** No agentic actions; all writes are direct user actions
- **Next:** `suggest_tags` auto-runs on item create (low risk, stored as unreviewed)
- **Later:** draft_reassign and batch status tools with approval flow
