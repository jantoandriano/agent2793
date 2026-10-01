# Debugging

Goal: fix failures by finding their root cause, not by trying things until the output changes.

## The loop

```text
Observe → Reproduce → Isolate → Hypothesize → Change → Validate
```

| Step | Do | Do not |
|---|---|---|
| Observe | Read the full error, stack trace, and the failing assertion. Note the first error, not just the last. | Skim the summary line and guess. |
| Reproduce | Run the smallest command that shows the failure (single test, single input). Confirm it fails consistently. | Debug a failure you cannot reproduce. |
| Isolate | Narrow to the exact line, input, or condition. Read the code on the failing path. Add temporary logging or assertions if needed. | Change code before you know where the problem is. |
| Hypothesize | State one specific cause: "`parseDate` returns UTC but the test expects local time." Predict what the fix will change. | Hold several vague theories and change several things at once. |
| Change | Make one targeted change that tests the hypothesis. | Bundle unrelated "while I'm here" edits. |
| Validate | Rerun the reproduction. Then rerun the surrounding tests. Remove temporary logging. | Declare it fixed because the error message changed. |

If the result contradicts your prediction, your hypothesis was wrong. Revert the change, return to Isolate, and form a new hypothesis. Do not stack fixes on a wrong hypothesis.

**Random trial-and-error is prohibited.** Every change made while debugging must be justified by a stated hypothesis.

## Classify the failure first

| Class | Signs | Action |
|---|---|---|
| Implementation bug | Failure is in code you changed or its direct effect | Fix the implementation |
| Test bug | Test asserts the wrong thing, or relies on order/time/randomness | Fix the test only if you can show the test, not the code, is wrong. Explain why in the report. |
| Environment problem | Missing service, wrong tool version, permissions, path, network | Do not change code to work around it. Report it, or fix the environment only if that is safe and in scope. |
| Dependency problem | Failure inside a third-party package, version mismatch | Check lockfile and changelogs. Do not upgrade without reason and approval. |
| Pre-existing failure | Fails on the original code too | Do not fix it as part of this task unless it blocks the task. Report it. |
| Unrelated / flaky | Fails intermittently or in an area your change cannot affect | Rerun once to confirm flakiness. Report it; do not "fix" it silently. |

To check whether a failure is pre-existing, compare against the baseline you took during investigation. If you have no baseline, inspect the original code without destroying your work — for example with `git stash` *only if the working tree contains nothing but your own changes and you restore it immediately*, or with a separate worktree. See `git.md`.

## Never do this to make tests pass

- Modify unrelated code
- Delete, skip, or weaken tests that were passing before
- Change expected values to match broken output
- Loosen types or suppress errors without understanding them
- Add sleeps or retries to hide race conditions
- Catch and ignore the exception

## Retry limit

**Maximum focused fix attempts per distinct failure: 3.** One attempt = one hypothesis-driven change plus a rerun.

After 3 attempts on the same failure, stop and escalate:

```text
Blocked: `invoice export > handles 50k rows` still fails (timeout at 30s).

Attempts:
1. Hypothesis: N+1 query in row mapping. Batched the lookup. Result: 41s → 33s, still fails.
2. Hypothesis: CSV string concatenation is quadratic. Switched to streaming writer. Result: 33s → 31s.
3. Hypothesis: test DB lacks the index on invoices.customer_id. Confirmed index exists. No change.

What I know: 28s is spent in `loadInvoices` (measured). The query plan shows a sequential scan.
Blocking: unclear whether the 30s limit is a real requirement or a test default.
Options: (a) raise the test timeout, (b) add a covering index via migration (needs approval), (c) paginate the export.
```

A different failure appearing after a fix starts its own count. The same failure reappearing does not reset the count.

## Exit condition

The failure is explained by a confirmed root cause, the targeted fix makes the reproduction pass, surrounding tests still pass, and temporary debugging code is removed — or the retry limit is reached and the failure is escalated.
