# Workspace Model

How tickets are isolated so several AI agent sessions can work on one repository at the same time.

## The model

```text
one ticket = one branch = one worktree = one context directory = one agent session
```

```text
projects/
├── my-app/                         main worktree — humans; agents do not edit code here
│   └── .work/                      ticket context for all tickets (local, git-excluded)
│       ├── HYP-101/
│       ├── HYP-102/
│       └── HYP-103/
└── worktrees/
    ├── HYP-101/                    feature/HYP-101  ← agent session 1
    ├── HYP-102/                    bugfix/HYP-102   ← agent session 2
    └── HYP-103/                    feature/HYP-103  ← agent session 3
```

Exact layout and file formats: `workspace/structure.md`.

## Why every ticket needs its own worktree

A git repository has one working directory per checkout. If two agents share it:

- **Branches collide.** Agent B switching to its branch changes the files under agent A mid-edit.
- **Changes mix.** Both agents' edits land in the same `git diff`; neither can review or report only its own work.
- **Validation lies.** Agent A's tests run against agent B's half-finished code.
- **Undo is dangerous.** Discarding "my" change can destroy the other agent's work.

`git worktree` gives each branch its own directory while sharing one object store: creating a worktree is fast, takes little disk, and every branch remains visible to every worktree for reading — which is what dependency analysis needs.

## Why context lives in the main worktree

`.work/` sits in the main worktree, not inside each ticket worktree, so that:

- every agent can **read** every other ticket's `ticket.md`, `plan.md`, and `dependency-analysis.md` to detect overlap
- context survives removal of the ticket worktree after merge
- ticket files never appear in a ticket's diff or PR

`scripts/start-ticket` adds `/.work/` to `.git/info/exclude` (local, untracked), so the target repository's `.gitignore` is not modified.

Each agent **writes only its own** `.work/<TICKET-ID>/`.

## Lifecycle of a workspace

```bash
# create
<EA_HOME>/scripts/start-ticket HYP-123 --title "Add CSV export"

# work — open ../worktrees/HYP-123 in the AI coding agent

# check readiness
<EA_HOME>/scripts/finish-ticket HYP-123

# human: commit, push, open PR, merge

# clean up after merge
git worktree remove ../worktrees/HYP-123
git branch -d feature/HYP-123
```

Keep `.work/HYP-123/` as the record of the work, or archive/delete it when no longer useful.

## Dependent tickets

When HYP-102 needs HYP-101's unmerged changes, base it on HYP-101's branch:

```bash
start-ticket HYP-102 --base feature/HYP-101
```

After HYP-101 merges, the human rebases or merges HYP-102 onto the main branch. Agents do not rebase shared branches without approval (`rules/git.md`).

## Shared resources beyond git

Worktrees isolate files, not the machine. Parallel sessions can still collide on:

- **dependencies** — each worktree needs its own install (`node_modules`, virtualenv); installs are per worktree
- **ports** — two dev servers on port 3000
- **databases, caches, containers** — shared local services and test databases
- **global tool state** — global caches, lockfiles of package managers

Use the project's isolation mechanisms where they exist (per-worktree `.env`, random test ports, per-run test databases). Agents must not kill processes, free ports, reset databases, or clear caches they did not create; they report the interference and ask (`rules/engineering.md`).

## Without the scripts

The scripts are conveniences. The contract is:

1. a branch per ticket, checked out in its own worktree
2. `<main worktree>/.work/<TICKET-ID>/ticket.md` created from `templates/ticket.md`
3. `/.work/` excluded from git

Any tool or manual process that produces this layout works with the rest of Engineering Agent.
