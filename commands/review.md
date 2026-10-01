---
name: review
description: Review the current working-tree changes (or a given diff/branch) and report findings without modifying code.
---

# /review

Review an implementation and report findings. Do not change code unless the human explicitly asks.

## Input

Optional: a scope (files, a branch to compare against, a commit range) and the requirement the change is meant to satisfy. Default scope: all uncommitted changes in the working tree. If no requirement is given, infer intent from the diff, commit messages, and branch name, and state the inferred intent.

## Steps

1. Follow `core/AGENTS.md`, the `software-engineering` skill, and project instructions.
2. Collect the change (`git.md`, `code-review.md`):
   - working tree: `git status`, `git diff`, `git diff --staged`, and read untracked files
   - branch: `git diff <base>...HEAD`
3. Read enough surrounding code to judge each change: callers, existing patterns, related tests (`investigation.md`).
4. Review every dimension in `code-review.md`.
5. Optionally run the existing tests, typecheck, and lint to support findings. Report what you ran.

## Constraints

- Do not modify files, stage, commit, or run formatters that write.
- Report problems; do not report praise or an overall numeric score.
- Distinguish facts ("this function is called with `null` from `routes.ts:42`") from concerns ("this may be slow for large accounts").

## Output

Use `templates/review-report.md`. Each finding includes:

- **Severity** — Critical, High, Medium, or Low (`code-review.md`)
- **Location** — file and line or function
- **Problem** — what is wrong
- **Reasoning** — why it matters, with evidence
- **Recommended fix** — specific and minimal
