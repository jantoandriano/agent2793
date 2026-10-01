---
name: test
description: Determine and run the appropriate validation for the current changes, and diagnose any failures.
---

# /test

Determine which validation applies, run it, and diagnose failures.

## Input

Optional: a scope (files, package, test name) or a specific command. Default scope: the current uncommitted changes.

## Steps

1. Follow `core/AGENTS.md`, the `software-engineering` skill, and project instructions.
2. Run `git status` to see what changed (`git.md`).
3. Find the validation commands from CI config, project instructions, and package scripts (`testing.md`).
4. Run targeted tests for the changed code first, then broader validation (typecheck, lint, full or affected tests, build) as appropriate.
5. Read results correctly: confirm tests actually ran, and separate new failures from pre-existing ones (`testing.md`).
6. For each failure, classify it and diagnose the root cause (`debugging.md`).

## Constraints

- Diagnose failures; fix them only when the fix is clearly within the scope of the current change and the human expects fixes (for example, `/test` was invoked as part of `/engineer`, or the human asked). Otherwise report the diagnosis and recommended fix.
- Never perform broad unrelated fixes, delete or skip tests, or weaken assertions to get a green run.
- Apply the retry limit (3 focused attempts per failure) to any fixes made.

## Output

```markdown
## Validation
- `<command>` — passed / failed (summary) / not applicable / not verified (reason)

## Failures
For each: test or check, classification, root cause (or current hypothesis), evidence, recommended fix or fix applied.

## Pre-existing or unrelated failures
```
