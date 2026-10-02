# Ticket Phase: Finish

**Status:** `REVIEWING` → `READY_FOR_PR` (or `BLOCKED`)
**Role:** Reviewer / reporter
**Produces:** `implementation-report.md`, `tracker-comment.md` (and the posted tracker comment)

Goal: an honest, verifiable report and a correct final status.

## 1. Final checks

Optionally run `scripts/finish-ticket <TICKET-ID>` from the ticket worktree. It verifies git status, runs the validation it can detect, scans the diff for debug code and conflict markers, writes `validation.md`, drafts `implementation-report.md` if missing, and prints whether the ticket looks ready. It does not commit, push, or change `ticket.status`.

Whether or not you use the script, confirm:

- [ ] `git branch --show-current` is the ticket branch
- [ ] `git status` / `git diff` reviewed after the last change; only intended files changed; pre-existing changes untouched
- [ ] no debug code, focused/skipped tests, stray TODOs, or accidental files
- [ ] all applicable validation ran after the last change (`validation.md`)
- [ ] self-review complete (`review.md`), findings resolved or recorded
- [ ] `dependency-analysis.md` still accurate

## 2. Write the implementation report

Create or complete `implementation-report.md` from `templates/implementation-report.md`.

Every statement falls into exactly one category:

| Category | Meaning |
|---|---|
| **Implemented** | Code exists in the diff |
| **Verified** | A command or check you ran shows it works (name the command) |
| **Not verified** | Not checked, with the reason |
| **Known issue** | A limitation or defect that remains |
| **Suggested follow-up** | Out-of-scope work discovered: issue, impact, proposal, why out of scope |

Do not claim validation that was not executed. "Tests: PASS" requires a test command you ran after your last change.

## 3. Set the final status

| Status | When |
|---|---|
| `READY_FOR_PR` | All checks above are satisfied; no required check is unverified unless the human accepted it |
| `BLOCKED` | Something prevents readiness: failing check after the retry limit, unanswered checkpoint, unavailable required validation, unresolved dependency. Set `ticket.blocked_reason`. |

Update `ticket.md` and append to Status History. Then report to the human: final status, summary, and the path to `implementation-report.md`.

## 4. Comment on the tracker ticket

Leave a comment on the ticket in the issue tracker (e.g. Jira) saying what was done, so people following the ticket see the result without opening the repository. Applies when the final status is `READY_FOR_PR`; for `BLOCKED`, offer a comment explaining the blocker but post only if the human agrees.

1. **Mode** — read `tracker.comment` in `ticket.md` (missing, e.g. in tickets created before this setting existed → `ask`):

   | Mode | Behavior |
   |---|---|
   | `ask` (default) | Show the draft, post only after the human approves it |
   | `auto` | Post without asking — the human chose this for the ticket |
   | `off` | Do not draft or post |

2. **Draft** — write `.work/<ID>/tracker-comment.md` from `templates/tracker-comment.md`, using `implementation-report.md`. Same honesty rules as the report: "Verified" only for checks that actually ran. Never include local paths, secrets, tokens, raw logs, or internal hostnames. Keep it short; it is for people reading the ticket, not for reviewers of the code.

3. **Post** — use the tracker tool available in your session (for example a Jira/Atlassian MCP tool that adds a comment to an issue), with the ticket ID (`ticket.id`) as the issue key.
   - Post exactly one comment. **Do not** change the issue's status, assignee, fields, labels, or links, and do not transition it, unless the human asks.
   - No tracker tool available, or posting fails → do not retry more than once; give the human the draft (path and text) to paste, and report that it was not posted.

4. **Record** — set `tracker.comment_posted` in `ticket.md` to the date and the comment link or ID, and append to Status History (`- 2026-10-01 tracker comment posted`).

If `tracker.comment_posted` is already set (the ticket was finished before and came back), post a new comment only when something changed since, and say in it that it updates the earlier one. Never edit or delete existing comments.

## 5. Opening the PR (only when asked)

Commit, push, and open the PR only when the human asks. When asked:

1. Commit the ticket's changes on the ticket branch (project commit convention, ticket ID in the message).
2. `git push -u origin <ticket branch>` — only this branch.
3. Open the PR with the project's PR template if one exists (`gh pr create`, or a GitHub MCP tool). Base it on `workspace.base`. The description summarizes the implementation report: what changed, how it was verified, what was not verified, known limitations.
4. Record `pr.url` and `pr.number` in `ticket.md`, set `ticket.status: IN_REVIEW`, append to Status History.

## After the PR is open

Review comments and requested changes are handled in the same ticket session with `ticket/pr-feedback.md`, when the human asks ("Address PR feedback for HYP-123"). `scripts/check-prs` shows which tickets have new feedback.

## After merge (human)

- Clean up, from the main checkout, after closing the ticket's agent session:

  ```bash
  <EA_HOME>/scripts/cleanup-ticket HYP-123     # or --merged for every merged ticket; --dry-run to preview
  ```

  It verifies the PR is merged and nothing would be lost, removes the worktree and local branch, sets `ticket.status: DONE`, and keeps `.work/HYP-123/` as the record of the work.

- Abandoned ticket: set `ticket.status: CANCELLED` with a reason; remove the worktree when no longer needed.
