# Workspace Structure

Reference for paths, file formats, and who may write what. Concepts: `workspace/README.md`.

## Paths

| Item | Default | Override |
|---|---|---|
| Main worktree | The original clone; first entry of `git worktree list` | — |
| Ticket worktree | `<parent of main worktree>/worktrees/<TICKET-ID>` (i.e. `../worktrees/HYP-123`) | `EA_WORKTREE_ROOT` env var, `--path` |
| Ticket branch | `<prefix>/<TICKET-ID>` — prefix from type: `feature`, `bugfix`, `refactor`, `investigation`, `chore` | `--branch` |
| Context directory | `<main worktree>/.work/<TICKET-ID>/` | — |
| Engineering Agent root | Where this repository is cloned (recommended `~/.engineering-agent`) | — |

Ticket IDs match `^[A-Za-z][A-Za-z0-9_]*-[0-9]+$` (e.g. `HYP-123`). If several repositories share a parent directory and ticket IDs can repeat across them, set `EA_WORKTREE_ROOT` per repository (e.g. `../worktrees/my-app`).

Finding the context directory from inside a ticket worktree:

```bash
main=$(git worktree list --porcelain | head -1 | cut -d' ' -f2-)
ls "$main/.work/HYP-123/"
```

`ticket.md` also records `workspace.context` and `workspace.worktree` as absolute paths.

## Context directory

```text
.work/HYP-123/
├── ticket.md                   context + state (created by start-ticket)        — all phases
├── analysis.md                 investigation findings                           — ticket/analyze.md
├── dependency-analysis.md      relationship to other tickets                    — ticket/analyze.md
├── plan.md                     implementation plan                              — ticket/plan.md
├── validation.md               validation results                               — ticket/validate.md, finish-ticket
├── review.md                   self-review findings                             — ticket/review.md
├── implementation-report.md    final report                                     — ticket/finish.md
├── tracker-comment.md          comment for the issue tracker ticket             — ticket/finish.md
├── pr-feedback.md              PR review feedback, one section per round        — ticket/pr-feedback.md
└── logs/                       validation command output (finish-ticket)

.work/local-files               optional: untracked files to copy into new worktrees (see below)
```

Templates for these files are in `templates/`. `analysis.md` and `validation.md` formats are defined in `ticket/analyze.md` and `ticket/validate.md`.

## `ticket.md` fields

YAML header, then a Markdown body (description, acceptance criteria, constraints, non-goals, open questions, decisions, status history).

| Field | Values | Set by |
|---|---|---|
| `ticket.id` | e.g. `HYP-123` | start-ticket |
| `ticket.title` | text | start-ticket / agent |
| `ticket.type` | `feature` · `bug` · `refactor` · `investigation` · `chore` | start-ticket / agent |
| `ticket.status` | `TODO` · `ANALYZING` · `PLANNED` · `READY` · `IN_PROGRESS` · `VALIDATING` · `REVIEWING` · `READY_FOR_PR` · `DONE` · `BLOCKED` · `CANCELLED` | agent; `DONE`/`CANCELLED` by human |
| `ticket.blocked_reason` | text, when `BLOCKED` | agent |
| `ticket.updated` | date of last change | agent |
| `workspace.branch` | ticket branch | start-ticket |
| `workspace.base` | branch the ticket started from and will merge into | start-ticket |
| `workspace.worktree` | absolute path | start-ticket |
| `workspace.context` | absolute path of the context directory | start-ticket |
| `workspace.engineering_agent` | absolute path of the Engineering Agent root | start-ticket |
| `dependencies.classification` | `UNKNOWN` · `ISOLATED` · `RELATED` · `BLOCKED` · `CONFLICTING` | agent (analyze) |
| `dependencies.blocked_by` | ticket IDs | agent (analyze) |
| `dependencies.related_to` | ticket IDs | agent (analyze) |
| `dependencies.shared_files` | paths shared with other active tickets | agent (analyze) |
| `checkpoint.mode` | `auto` · `always` | human (default `auto`) |
| `checkpoint.plan_approved` | `true` · `false` | agent, after human approval |
| `tracker.comment` | `ask` · `auto` · `off` — end-of-ticket comment in the issue tracker (`ticket/finish.md` §4) | start-ticket (`--tracker-comment`, `EA_TRACKER_COMMENT`, default `ask`) / human |
| `tracker.comment_posted` | date + link/ID of the posted comment | agent |
| `pr.url`, `pr.number` | the ticket's pull request | agent (when it opens the PR or finds it) / human |
| `pr.respond` | `ask` · `auto` · `off` — pushing fixes and replying to PR feedback (`ticket/pr-feedback.md`) | start-ticket (`--pr-respond`, `EA_PR_RESPOND`, default `ask`) / human |
| `pr.feedback_handled_at` | GitHub timestamp of the newest feedback item handled; `scripts/check-prs` counts items after it | agent |
| `validation.*` (`typecheck`, `lint`, `tests`, `build`) | `pending` · `pass` · `fail` · `not-run` · `not-applicable` | agent (validate) |

Edit the header in place; keep it valid YAML. Append to Status History on every status change: `- 2026-10-01 IN_PROGRESS — plan approved`.

## Write permissions

| Location | Owning agent | Other agents | Human |
|---|---|---|---|
| Own ticket worktree | read/write | read only via git (`git diff <base>...<branch>`, `git show`) | read/write |
| Own `.work/<ID>/` | read/write | read | read/write |
| Main worktree code | read | read | read/write |
| Shared git refs (branches, tags, stash) | own ticket branch only | — | all |

## Local files copied into worktrees

A new worktree contains only tracked files. Untracked local configuration in the main worktree — typically per-project AI tool settings that load Engineering Agent — would be missing, and the agent in the worktree would run without it.

List such files in `<main worktree>/.work/local-files`, one repository-relative path per line (`#` comments allowed):

```text
# per-project AI tool config
.kilo/kilo.jsonc
```

`scripts/start-ticket` copies each listed path (file or directory) into the new worktree. It:

- skips paths tracked by git (the worktree already has them) and paths that do not exist
- rejects absolute paths and paths containing `..`
- never overwrites a file already present in the worktree; re-running `start-ticket` copies only what is missing
- adds the path to `.git/info/exclude` if it is not already ignored, so it never shows in `git status` or a PR

Copies are independent: later edits in the main worktree do not propagate to existing worktrees.

## Project validation override

If automatic detection in `scripts/finish-ticket` does not fit a project, the project may commit `.agent2793/validation`:

```text
# name: command      (run from the worktree root, in order)
typecheck: pnpm -r typecheck
lint: pnpm biome check .
tests: pnpm vitest run
build: pnpm -r build
```

When this file exists, it replaces automatic detection.
