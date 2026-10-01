---
name: engineer
description: Run the full engineering lifecycle on a task, from understanding to a verified final report.
---

# /engineer

Primary command. Takes a task (ticket text, issue link, or description) and carries it through the full lifecycle defined in `core/AGENTS.md`.

```text
Understand → Clarify → Investigate → Plan → Implement → Test → Fix → Review → Validate → Complete
```

## Input

The task description passed with the command. If none is given, ask for it.

## Steps

1. **Load behavior.** Follow `core/AGENTS.md` and the `software-engineering` skill. Load project instructions (`AGENTS.md` or equivalent) and treat them as overriding generic behavior except for safety rules.
2. **Check git.** Run `git status` and record the baseline (`git.md`).
3. **Understand.** Extract objective, acceptance criteria, constraints, non-goals, assumptions (`requirements.md`).
4. **Choose a workflow.** Feature → `workflows/feature.md`; bug → `workflows/bugfix.md`; refactor → `workflows/refactor.md`; diagnosis only → `workflows/investigation.md`.
5. **Clarify.** Ask only material questions, batched (`requirements.md`, `human-escalation.md`).
6. **Investigate.** Find the existing pattern, tests, and validation commands (`investigation.md`).
7. **Plan.** Proportional plan using `templates/task-plan.md` for non-trivial tasks. For large or high-risk changes, share the plan and wait for confirmation (`planning.md`).
8. **Implement and test.** Follow the chosen workflow. Write tests alongside code; run targeted tests (`implementation.md`, `testing.md`).
9. **Fix.** On failure, debug by root cause; at most 3 focused attempts per failure, then escalate (`debugging.md`).
10. **Review.** Review the actual diff; loop back to implement/test until findings are resolved (`code-review.md`).
11. **Validate.** Run all applicable validation commands after the last change (`testing.md`).
12. **Complete.** Inspect `git status` / `git diff` and produce the final report with a final status (`completion.md`).

## Constraints

- Do not commit, push, or open a PR unless asked; report `READY FOR PR` instead.
- Do not skip phases; scale them to the task.

## Output

Brief progress notes at phase transitions, then the final report from `completion.md`.
