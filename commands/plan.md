---
name: plan
description: Understand, investigate, and produce an implementation plan without changing production code.
---

# /plan

Produce an implementation plan for a task. Do not implement it.

```text
Understand → Investigate → Plan
```

## Input

The task description passed with the command. If none is given, ask for it.

## Steps

1. Follow `core/AGENTS.md`, the `software-engineering` skill, and project instructions.
2. **Understand** the task (`requirements.md`). Collect open questions instead of guessing.
3. **Investigate** the repository: relevant files, existing patterns, tests, validation commands (`investigation.md`).
4. **Plan** using `templates/task-plan.md` (`planning.md`), with the test strategy from `templates/test-plan.md` when non-trivial.

## Constraints

- Do not modify production code, tests, configuration, or dependencies.
- Read-only commands only (reading files, searching, `git status`, `git log`, running existing tests to establish a baseline). Do not run commands that write to the repository, install dependencies, or change external systems.
- If the human asks for the plan to be saved to a file, write only that file.

## Output

The completed task plan, followed by:

- **Open questions** — decisions the human must make before implementation, with options and a recommendation.
- **Assumptions** — choices you made where the answer was low-impact.

The plan should be ready to hand to `/engineer` or a human.
