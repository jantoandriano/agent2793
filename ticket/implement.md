# Ticket Phase: Implement

**Status:** `READY` → `IN_PROGRESS`
**Role:** Implementer
**Produces:** code and tests in the ticket worktree

Goal: the smallest correct change that satisfies the ticket, with tests.

## Steps

1. **Read the ticket** — `ticket.md`: acceptance criteria, constraints, non-goals, decisions.
2. **Read the analysis** — `analysis.md` and `dependency-analysis.md`.
3. **Read the plan** — `plan.md`.
4. **Verify the workspace** — branch and status checks (`rules/git.md`). Set `ticket.status: IN_PROGRESS`.
5. **Inspect the affected code** — reread the files you will change; they may have changed since analysis.
6. **Implement the smallest correct change** — following `rules/engineering.md`, `rules/coding.md`, and the stack rules that apply. Follow the existing pattern named in the plan.
7. **Add or update tests** — alongside the code, per the plan's test section (`rules/testing.md`). For bugs, the regression test first.
8. **Run targeted tests** — the tests for the files you changed. On failure, debug by root cause, within the retry limit (`rules/engineering.md`).
9. **Check scope** — `git status` and `git diff`: every changed line serves the ticket; no files outside the plan unless the plan was updated; no debug code.
10. **Hand over to validation** — continue to `ticket/validate.md`.

The implementation report is produced in `ticket/finish.md`, after validation and review.

## Scope

Do not silently expand the ticket. If implementation reveals a larger issue:

- **Do not** refactor everything.
- Record it for the report's *Suggested follow-up*: discovered issue, impact, proposed solution, why it is outside the ticket scope.
- If the ticket cannot be completed correctly without it, stop and ask (scope expansion checkpoint).

If you find you need to change a file another active ticket is changing (see `dependency-analysis.md`), stop and reassess the classification before editing it.

## Coming back from validation or review

When `ticket/validate.md` or `ticket/review.md` sends you back:

- set `ticket.status: IN_PROGRESS`
- fix the specific failure or finding — nothing else
- run targeted tests, then return to validation; everything downstream reruns

## Exit

The plan is implemented, targeted tests pass, the diff contains only intended changes.
