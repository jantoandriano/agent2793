# Workflow: Bug Fix

For existing behavior that is incorrect.

```text
Understand symptom → Reproduce → Investigate → Identify root cause → Plan fix
  → Implement → Regression test → Review → Validate → Complete
```

## Steps

1. **Understand the symptom** — observed behavior, expected behavior, where and when it happens, since when (`requirements.md`). If expected behavior is not obvious from code, tests, or docs, ask.
2. **Reproduce** — find the smallest reproduction. Prefer an automated one: write a failing test that demonstrates the bug and confirm it fails for the reported reason. If you cannot reproduce it, report what you tried and ask for more information rather than fixing blind (`debugging.md`).
3. **Investigate** — trace the failing path; read callers and related tests. Check git history of the affected code for the change that introduced the bug when useful (`investigation.md`).
4. **Identify root cause** — explain *why* the bug happens, not only where. Check whether the same root cause affects other code paths (`debugging.md`).
5. **Plan the fix** — fix the root cause, not the symptom. Name what else could be affected. If the correct fix changes behavior other code relies on, escalate (`planning.md`).
6. **Implement** — the smallest change that fixes the root cause. No opportunistic refactoring (`implementation.md`).
7. **Regression test** — the reproduction test now passes; it would fail if the fix were reverted; surrounding tests still pass (`testing.md`). On failure, Fix (`debugging.md`), within the 3-attempt limit.
8. **Review** — the actual diff; confirm the fix addresses the root cause and introduces no side effects (`code-review.md`).
9. **Validate** — full applicable validation after the last change (`testing.md`).
10. **Complete** — final report including the root cause explanation (`completion.md`).

## Bug-fix-specific rules

- A fix without a reproduction is a guess. If a regression test is genuinely impossible (for example, a race condition only seen in production), document why and how the fix was verified.
- Do not suppress the symptom (catching the exception, adding a null check that hides bad data, adding a retry) unless investigation shows that is the correct fix, and explain why.
- If the same root cause appears elsewhere, fix it there only if in scope; otherwise list the locations in the report.
