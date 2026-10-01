# Workflow: Code Review

The review procedure used for self-review (`ticket/review.md`) and for reviewing another change on request (a PR, another ticket's branch, a colleague's diff).

## Scope and mode

- **Self-review:** your ticket's working tree and branch. Findings are fixed through the ticket workflow.
- **Reviewing other work:** read-only. Do not modify files, commit, or check out the other branch in its worktree. Use `git diff <base>...<branch>`, `git show <branch>:<path>`, or a temporary detached worktree you create and remove yourself. Report findings; fix nothing unless asked.

## 1. Collect the change

```bash
git status
git diff                       # unstaged
git diff --staged              # staged
git diff <base>...<branch>     # committed changes on a branch
```

Read new untracked files in full. Read enough surrounding code (callers, related tests, existing patterns) to judge each change. Know the intent: the ticket's acceptance criteria, or — for others' work — the PR description; if intent is unknown, state the intent you inferred.

## 2. Checklist

| Area | Check |
|---|---|
| Correctness | Each acceptance criterion met, with evidence. Boundary values and error paths right. |
| Scope | Every file and hunk serves the ticket. No unrelated refactors or formatting. |
| Regressions | Callers of changed code still work. Default behavior unchanged unless intended. |
| Type safety | No `any`, unchecked casts, non-null assertions, or suppressions without justification (`rules/typescript.md`). |
| Error handling | Project conventions followed; no swallowed errors; useful messages. |
| Tests | Important behavior covered; new tests ran and would fail without the change; nothing skipped or weakened. |
| Accessibility | For UI: semantics, labels, keyboard, focus, states (`rules/react.md`). |
| Security | Input validated, no injection, no secrets, authorization preserved (`rules/security.md`). |
| API compatibility | Public contracts unchanged, or changed intentionally, approved, and documented (`rules/architecture.md`). |
| Unnecessary changes | No changes that could be removed without affecting the ticket. |
| Debug code | No `console.log`, `debugger`, temporary logging, `.only`/`.skip`. |
| TODOs | No new TODO without a ticket reference. |
| Accidental files | No scratch files, generated output, lockfile changes without dependency changes, local config. |
| Parallel work | No changes to files shared with other active tickets beyond what `dependency-analysis.md` anticipated. |

## 3. Findings

| Severity | Meaning | Example |
|---|---|---|
| Critical | Data loss, security hole, broken core behavior | SQL built from request input |
| High | Requirement not met, or likely bug on a common path | Export ignores the date filter |
| Medium | Edge-case bug, missing test for important behavior, confusing convention violation | Empty list returns 500 |
| Low | Minor clarity issue not caught by tooling | Unclear variable name in a long function |

Each finding: severity, location (file:line or symbol), problem, why it matters (evidence), recommended fix. Distinguish facts from concerns. No praise, no overall numeric score.

Write findings with `templates/review.md`.
