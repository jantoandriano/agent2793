# Ticket Phase: Self-Review

**Status:** `VALIDATING` → `REVIEWING`
**Role:** Reviewer
**Produces:** `review.md`

Goal: find problems in the actual change before a human reviewer does.

## Steps

1. Set `ticket.status: REVIEWING`.
2. Collect the actual change — never review from memory:

   ```bash
   git status
   git diff
   git diff --staged
   git diff <base>...HEAD     # if anything was committed
   ```

   Read new untracked files in full.
3. Review it with the procedure and checklist in `workflows/code-review.md`, against this ticket's acceptance criteria, plan, and non-goals.
4. Also check against parallel work: did the change touch any file listed as shared in `dependency-analysis.md`? If a new overlap appeared, update `dependency-analysis.md` and reassess.
5. Write `review.md` from `templates/review.md`.

## Resolve findings

```text
REVIEW → finding → IMPLEMENT → VALIDATE → REVIEW
```

- Critical and High: fix (back to `ticket/implement.md`).
- Medium: fix unless it expands scope; otherwise record as known issue or follow-up.
- Low: fix if trivial and in scope; otherwise record.
- Decisions that belong to the human (behavior or API changes): ask.

After any fix, rerun validation and review the new diff. A review of code that has since changed does not count. If the same finding recurs after 3 fix cycles, set `BLOCKED` and escalate.

## Exit

The final diff, after the last code change, has been reviewed; every finding is fixed, recorded as a known issue/follow-up, or accepted by the human. Continue to `ticket/finish.md`.
