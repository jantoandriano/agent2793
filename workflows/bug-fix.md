# Workflow: Bug Fix

For `ticket.type: bug` — existing behavior that is incorrect. Follow `workflows/ticket.md`, with these additions.

```text
Understand symptom → Reproduce → Investigate → Root cause → Plan fix → Implement → Regression test → Validate → Review → Report
```

## Analyze

1. **Symptom** — observed vs. expected behavior, where, when, since when. If expected behavior is not determinable from code, tests, or docs, ask.
2. **Reproduce** — the smallest reproduction, preferably a failing automated test. Confirm it fails for the reported reason. If you cannot reproduce, report what you tried and ask for more information; do not fix blind.
3. **Investigate** — trace the failing path; check history of the affected code (`git log -p <path>`) for the change that introduced it when useful.
4. **Root cause** — explain *why* it happens, not only where. Check whether the same cause affects other code paths. Record it in `analysis.md`.

## Plan

- Fix the root cause, not the symptom. A retry, a null check that hides bad data, or a caught exception is acceptable only when analysis shows it is the correct fix — and the plan says why.
- If the correct fix changes behavior other code relies on, that is a checkpoint.

## Implement

- Write the regression test first; confirm it fails; then fix.
- Smallest change that removes the root cause. No opportunistic refactoring.
- Other locations with the same root cause: fix only if in scope; otherwise list them as follow-ups.

## Validate and review focus

- The regression test fails without the fix and passes with it.
- Surrounding behavior is unchanged.
- The report states the root cause explicitly.

If a regression test is genuinely impossible (e.g. a production-only race condition), the report explains why and how the fix was verified.
