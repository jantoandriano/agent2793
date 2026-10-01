# Workflow: Investigation

For `ticket.type: investigation` — the goal is understanding, not changing code: "Why does X happen?", "How does Y work?", "What would Z take?", "Where is this slow?"

```text
Understand question → Investigate → Gather evidence → Conclude → Report
```

## Steps

1. **Understand the question** — what decision will the answer support? That sets the depth.
2. **Investigate** — as in `ticket/analyze.md` §3. A worktree is still recommended so experiments cannot disturb other work.
3. **Gather evidence** — read code, run existing tests, run read-only commands, reproduce. For failures follow Observe → Reproduce → Isolate → Hypothesize (`rules/engineering.md`) and confirm hypotheses without code changes.
4. **Conclude** — separate confirmed facts, likely explanations, and unknowns.
5. **Report** — write `analysis.md` in the format below and present it.

## Constraints

- Do not modify code, configuration, or dependencies unless the human asks.
- Temporary instrumentation (a debug log) is allowed only when necessary for evidence; remove it, verify with `git status` that the worktree is back to its baseline, and mention it in the report.
- Lifecycle: `TODO → ANALYZING`, then present the report. The planning and implementation states and `READY_FOR_PR` are skipped. The human sets `DONE` when they accept the findings (or turns them into a new implementation ticket).

## Report format (`analysis.md`)

```markdown
# Investigation: <TICKET-ID>

## Question
## Findings
Confirmed facts, each with evidence (file:line, command output).
## Relevant Files
## Root Cause
If identifiable; otherwise leading hypotheses and how to confirm them.
## Unknowns
## Recommended Next Steps
Concrete options, e.g. "Create ticket: add index on orders.customer_id (est. small)".
```
