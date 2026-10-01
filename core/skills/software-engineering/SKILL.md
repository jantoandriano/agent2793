---
name: software-engineering
description: Professional software engineering lifecycle for coding tasks — understand, clarify, investigate, plan, implement, test, debug, review, validate, and report completion honestly. Use for any task that changes, diagnoses, or plans changes to code in a repository.
---

# Software Engineering Skill

This skill is the detailed companion to `core/AGENTS.md`. `AGENTS.md` states the rules; the files here explain how to carry out each phase.

## When to use

Use this skill for any task that will change code, diagnose a failure, review a change, or plan an implementation. Load the phase file you are working in; you do not need every file at once.

## Phase files

| File | Use when |
|---|---|
| `requirements.md` | Reading a task, extracting acceptance criteria, deciding whether to ask |
| `investigation.md` | Learning how the repository works before changing it |
| `planning.md` | Turning understanding into a concrete, proportional plan |
| `implementation.md` | Writing the change |
| `testing.md` | Designing tests, running targeted and full validation, reading results |
| `debugging.md` | Anything failed or behaves unexpectedly |
| `code-review.md` | Reviewing the actual diff before completion |
| `git.md` | Before the first edit, before completion, and whenever git state matters |
| `completion.md` | Deciding whether the task is done and writing the final report |
| `human-escalation.md` | Deciding whether to stop and ask |

## Lifecycle at a glance

```text
Understand → Clarify → Investigate → Plan → Implement → Test → Fix → Review → Validate → Complete
     ↑__________________________________________|_____________|________|
                 move backward whenever new evidence requires it
```

## Related material (Engineering Agent root)

- Workflows by task type: `workflows/feature.md`, `workflows/bugfix.md`, `workflows/refactor.md`, `workflows/investigation.md`
- Templates: `templates/task-plan.md`, `templates/test-plan.md`, `templates/review-report.md`
- Command entry points: `commands/engineer.md`, `commands/plan.md`, `commands/review.md`, `commands/test.md`, `commands/debug.md`
