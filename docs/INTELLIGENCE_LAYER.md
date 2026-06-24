# Intelligence Layer — myassistance

## Messy Inputs
- Free-text work item titles and descriptions written in varied styles
- Inconsistent priority language ("urgent", "ASAP", "when you get a chance")
- No standard categorisation across the team today

## Auto-Structure Schema (example)
```json
{
  "work_item_id": "c1000...",
  "suggested_tags": "vendor, onboarding, finance",
  "source": "gpt-4o",
  "confidence": 0.87,
  "review_status": "unreviewed"
}
```

## Events to Track
- Work item created (trigger tag suggestion)
- Status changed to `blocked` (trigger workload alert candidate)
- Due date passed with status ≠ done (overdue signal)

## Scoring Rules (v1 — rule-based)
- **Overdue score:** due_date < today AND status ≠ done → flag red
- **Workload score per assignee:** count of open + in_progress items (threshold: > 5 = high load)
- **Priority weight:** high=3, medium=2, low=1 — sum per assignee

## What Gets Ranked
- Work items sorted by: overdue first → priority → due date
- Assignees sorted by workload score descending

## v1 vs Later
- **v1:** rule-based overdue flag and sort order only
- **Next:** AI tag suggestions on create (stored, shown as draft, one-click accept)
- **Later:** LLM workload summaries, anomaly detection on blocked items
