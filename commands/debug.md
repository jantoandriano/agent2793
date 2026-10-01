---
name: debug
description: Reproduce and diagnose a specific failure using root-cause debugging.
---

# /debug

Reproduce and diagnose one specific failure: a failing test, an error message, a crash, or unexpected behavior.

```text
Observe → Reproduce → Isolate → Hypothesize → Change → Validate
```

## Input

A description of the failure: error output, failing test name, steps to reproduce, or observed vs. expected behavior. If the failure is not specific enough to reproduce, ask for what is missing.

## Steps

1. Follow `core/AGENTS.md`, the `software-engineering` skill, and project instructions.
2. Run `git status` and record the baseline (`git.md`).
3. **Observe** — read the full error and trace.
4. **Reproduce** — find the smallest command or input that triggers it. If it cannot be reproduced, report what was tried and stop.
5. **Isolate** — narrow to the responsible code path.
6. **Classify** — implementation bug, test bug, environment, dependency, pre-existing, or flaky (`debugging.md`).
7. **Hypothesize** — state one specific cause and the prediction that would confirm it.
8. **Change and validate** — only if the human asked for a fix: make one targeted change, rerun the reproduction and surrounding tests. Otherwise confirm the hypothesis with non-invasive checks (logging, reading code, running variations) and report.

## Constraints

- No random trial-and-error. Every change must test a stated hypothesis.
- Maximum 3 focused fix attempts on the same failure, then escalate with the format in `debugging.md`.
- Remove temporary debugging code before finishing.
- If a fix is applied, follow up with review and validation as in `workflows/bugfix.md`.

## Output

```markdown
## Failure
## Reproduction
## Root cause
Evidence for it.
## Classification
## Fix
Applied (with validation results) or recommended.
## Remaining risks / next steps
```
