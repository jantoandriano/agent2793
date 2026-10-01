# Code Review

Goal: catch problems in the actual change before a human reviewer does.

Review what is on disk, not what you remember writing.

## 1. Collect the change

```text
git status            # every modified, added, deleted, and untracked file
git diff              # unstaged changes
git diff --staged     # staged changes, if any
```

Also read new untracked files you created in full; `git diff` does not show them. Compare the file list against the pre-existing changes you recorded before the first edit (see `git.md`). Only your changes are under review; pre-existing changes must be untouched.

## 2. Review each dimension

| Dimension | Check |
|---|---|
| Correctness | Each acceptance criterion is satisfied, with evidence (test or command output). Edge cases from the plan are handled. Logic is right for boundary values. |
| Scope | Every changed file and hunk serves the requirement. No stray debug code, commented-out code, unrelated formatting, or accidental file changes. |
| Architecture | Change follows the pattern identified during investigation. Module boundaries and dependency directions are respected. |
| Maintainability | Names are clear. A new engineer could follow the change. Comments explain why, not what. No dead code. |
| Types | No loosened types, unchecked casts, or suppressed errors without justification. Public types are accurate. |
| Error handling | Failure cases follow repository conventions. Errors are not swallowed. Messages are useful. |
| Security | Untrusted input is validated. No injection risk. No secrets in code, logs, tests, or fixtures. Authorization checks preserved on new entry points. |
| Performance | No N+1 queries, unbounded memory, or quadratic work on user-sized data in new code. |
| Tests | Important behavior is covered. New tests ran and would fail without the change. No tests deleted or weakened. |
| Regression | Callers of changed functions still work. Default behavior is unchanged unless intended. |
| API compatibility | Public APIs, config, CLI flags, schemas, and formats are unchanged or changed intentionally and documented. |

## 3. Classify findings

| Severity | Meaning | Example |
|---|---|---|
| Critical | Data loss, security hole, or broken core behavior | SQL built by string concatenation from request input |
| High | Requirement not met, or likely bug in a common path | Export ignores the date filter |
| Medium | Bug in an edge case, missing test for important behavior, convention violation that will confuse maintainers | Empty list returns 500 instead of header-only CSV |
| Low | Minor clarity or style issue not caught by tooling | Variable name `d` in a 40-line function |

Each finding states: severity, file and location, the problem, why it matters, and the recommended fix. Do not assign an overall numeric score.

Use `templates/review-report.md` when a written review is requested (for example by `commands/review.md`).

## 4. Resolve findings

```text
Review → finding → Implement → Test → Review
```

- Fix every Critical and High finding. Fix Medium findings unless the fix expands scope; then list them as known limitations.
- Low findings: fix if trivial and in scope; otherwise mention them.
- After any fix, rerun affected tests and review the new diff again. A review of code that has since changed does not count.
- If the same finding keeps returning after 3 fix cycles, escalate (see `human-escalation.md`).
- If a fix requires a decision the human should make (behavior change, API change), ask rather than choose.

## Exit condition

The final diff has been reviewed across all dimensions after the last code change, and all findings are resolved, explicitly deferred as known limitations, or accepted by the human.
