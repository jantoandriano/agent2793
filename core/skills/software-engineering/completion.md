# Completion

Goal: decide honestly whether the task is done, and report it so a human can verify that quickly.

A task is not complete because code changed. It is complete when the evidence says so.

## Definition of done

| # | Criterion | Evidence |
|---|---|---|
| 1 | Requirements understood; ambiguities resolved or recorded as assumptions | Understanding / assumptions stated |
| 2 | Implementation complete for every acceptance criterion | Mapping criterion → change |
| 3 | Tests added or updated where appropriate | Test files in diff, or reason none were needed |
| 4 | Tests pass | Command and result from this session, after the last change |
| 5 | Typecheck passes (if the repository has one) | Command and result |
| 6 | Lint passes (if the repository has one) | Command and result |
| 7 | Build passes (if the repository has one) | Command and result |
| 8 | Self-review completed on the final diff | Review dimensions checked after the last change |
| 9 | Review findings resolved, deferred as limitations, or accepted by the human | Findings list |
| 10 | Actual diff inspected | `git status` / `git diff` run before reporting |
| 11 | No unrelated changes; baseline changes untouched | Changed-file list matches intent |
| 12 | Known limitations documented | Limitations section |

"If the repository has one": a check that does not exist is **not applicable** and does not block completion. A check that exists but was not run, or could not run, **does** block `READY FOR PR`.

## Final status

Report exactly one:

| Status | When |
|---|---|
| `READY FOR PR` | All criteria above are met. |
| `NEEDS HUMAN INPUT` | Work is blocked on a decision, approval, credential, or a check that could not run in this environment. State exactly what is needed. |
| `BLOCKED` | The retry limit was reached or a problem could not be resolved. State what was tried and the options. |

Never report `READY FOR PR` with unverified required checks. Never soften a blocked state into a success ("mostly done", "should work").

## Final report

```markdown
## Summary
One to three sentences: what was asked and what was done.

## Implementation
Key changes and why, mapped to acceptance criteria. Assumptions made.

## Tests
Tests added or changed, and what each proves.

## Validation
- `pnpm typecheck` — passed
- `pnpm lint` — passed
- `pnpm test` — passed (214 tests, 6 new)
- `pnpm build` — not applicable (library has no build step)

Not verified:
- (list anything not run, with the reason)

## Review
Dimensions checked; findings and how each was resolved.

## Changed files
- `src/invoices/export.ts` — new CSV export
- `src/invoices/routes.ts` — register export route
- `tests/invoices/export.test.ts` — new tests
Pre-existing changes left untouched: `README.md`

## Known limitations
Deferred findings, out-of-scope issues noticed, pre-existing failures.

## Final status
READY FOR PR
```

Scale the report to the task: a typo fix needs a few lines; keep every heading that has content and mark the rest "None".

## Rules

- Every pass/fail claim cites a command you ran in this session after the last code change.
- If you changed code after running a check, the check must be rerun before it can be reported as passing.
- Report pre-existing and unrelated failures separately from your own results; do not hide them and do not count them as yours.
