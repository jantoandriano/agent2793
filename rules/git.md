# Git Rules

Multiple agents may share one repository through separate worktrees. These rules keep their work isolated.

## Worktree model

- One ticket = one branch = one worktree = one agent session.
- Recommended creation (or use `scripts/start-ticket`):

  ```bash
  git worktree add ../worktrees/HYP-123 -b feature/HYP-123 <base>
  ```

- All worktrees share one `.git` object store, refs, and stash. Anything that changes shared refs can affect other agents.

## Verify before modifying code

```bash
git branch --show-current   # equals workspace.branch in ticket.md
git status                  # baseline: note pre-existing changes
git worktree list           # your worktree is listed; note other active worktrees
```

Stop and ask if: the branch is wrong; you are in the main worktree while the ticket has its own worktree; a merge, rebase, or cherry-pick is in progress; or `git status` shows changes you cannot attribute.

## Isolation rules

- Modify files only inside your own worktree (plus your own `.work/<TICKET-ID>/` directory).
- Never check out, switch, reset, rebase, or commit on a branch that belongs to another ticket.
- Never run `git switch`/`git checkout <branch>` inside another agent's worktree. Do not switch branches in your own worktree either; the worktree is bound to its ticket.
- Never remove, move, or prune other worktrees (`git worktree remove`, `git worktree prune`).
- Do not use `git stash`: the stash is shared by all worktrees, and another agent's `stash pop` can take your entry (or you theirs).
- Reading other branches is allowed: `git log <branch>`, `git diff <base>...<branch>`, `git show <branch>:<path>`.

## Pre-existing changes

If your worktree already has changes at the start:

1. Inspect them (`git diff`, `git diff --staged`, read untracked files).
2. Decide whether they belong to this ticket (e.g. the human started the work).
3. If not, leave them untouched and keep them out of your changes.
4. If you cannot tell, ask.

## Forbidden without explicit human approval

```text
git reset --hard              git clean -f / -fd / -fdx
git checkout -- <path>        git restore <path>        (discards changes)
git stash (any form)          git branch -D
git push / git push --force   git merge / git rebase onto shared branches
git worktree remove / prune   git commit --amend on pushed commits
deleting files you did not create
```

Approval applies to the specific operation, not to similar future operations.

To undo your own edit to a file, edit it back rather than discarding it with git.

## Comparing with the base branch

To check whether a failure is pre-existing without touching your worktree:

```bash
git worktree add --detach ../worktrees/HYP-123-base <base>   # temporary, for comparison only
# install dependencies if needed, run the failing test there, then:
git worktree remove ../worktrees/HYP-123-base                # allowed: a worktree you created yourself
```

Or read original files with `git show <base>:<path>`.

## Commits, pushes, PRs

- Do not commit unless the human or project rules ask you to. If you commit, commit only on your ticket branch, only your changes, following the project's commit message convention, and reference the ticket ID.
- Never push, merge, or open a PR unless explicitly asked. (Commenting on the tracker ticket: `ticket/finish.md` §4. Opening the PR when asked: `ticket/finish.md` §5. Pushing fixes for PR feedback: `ticket/pr-feedback.md`.)
- Never force-push, and never rebase or amend commits that are already pushed.

## Before declaring completion

```bash
git status
git diff                      # unstaged
git diff --staged             # staged
git diff <base>...HEAD        # committed on the ticket branch, if any
```

Read untracked files you created in full — `git diff` does not show them. Confirm every changed file is intended and pre-existing changes are untouched. Only then may you state which files changed.
