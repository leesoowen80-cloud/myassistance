# Test Plan — myassistance

## Success Scenario (manual walkthrough)
1. Open `/dashboard` — confirm 5 seeded work items appear in the table.
2. Verify stat cards show correct counts (1 In Progress, 2 Open, 1 Blocked, 1 Done).
3. Click **New Item** — modal opens with empty form fields.
4. Fill: Title="Test task", Status=Open, Priority=High, Assignee=Jordan Lee, Due=tomorrow. Click Save.
5. Confirm new row appears at top of table (or correct sort position). Modal closes.
6. Confirm activity feed shows "Jordan Lee — created — Test task".
7. Click edit on the new row → change Status to In Progress → Save.
8. Confirm badge updates to yellow In Progress. Activity feed shows status_changed.
9. Click delete on the new row → confirmation dialog appears → confirm delete.
10. Row is gone. Activity feed shows deleted entry.

## Filter Tests
- Select Status = Blocked → only the blocked item shows.
- Select Assignee = Alex Rivera → only Alex's items show.
- Reset filters → all items reappear.

## Empty State
- Delete all items → table shows "No work items yet" message with New Item CTA.

## Error Cases
- Submit New Item form with blank Title → inline validation error, no DB write.
- Simulate network error (disable network) → error toast appears, form data preserved.
- Reload page after creating item → item persists (not lost on refresh).

## Overdue Highlight
- Edit any item's due date to yesterday, status ≠ Done → row shows red tint.
- Change status to Done → red tint removed.
