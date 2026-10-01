# Git

Goal: use git to understand and verify your change without ever damaging work that is not yours.

## Before the first edit

```text
git status
```

Record:

- current branch
- modified, staged, and untracked files that already exist (the **baseline**)
- whether a merge, rebase, or cherry-pick is in progress — if so, stop and ask before editing

If the baseline is not clean:

1. Inspect the existing changes (`git diff`, `git diff --staged`, read untracked files).
2. Decide whether they belong to the current task (for example, the human started the work and asked you to finish it).
3. If they do not belong to the task, leave them exactly as they are and keep them out of your change.
4. If you need to edit a file that already has unrelated changes, or you cannot tell which changes are part of the task, ask.

## While working

- Only modify files your task requires.
- Track files you create. Remove temporary files (scratch scripts, debug output) before completion.
- Do not stage, commit, or push unless the task or the human asks. Committing, branching, and pushing are often handled by the host agent or the human.

## Branch awareness

- Know which branch you are on. Do not assume a branching strategy; follow the project's rules or the host agent's workflow.
- If the project forbids work on the default branch and you are on it, ask before creating or switching branches.
- Never switch branches with uncommitted changes that are not yours.

## Destructive commands

Never run these unless the human explicitly requests the specific operation in the current session:

```text
git reset --hard
git clean -f / -fd / -fdx
git checkout -- <path>      git restore <path>       (discards working-tree changes)
git stash drop / git stash clear
git branch -D
git push --force / --force-with-lease
git rebase (on shared or pushed branches)
rm / delete of files you did not create
```

To discard **your own** change to a file that had no pre-existing changes, prefer editing the file back over discarding with git, so pre-existing work cannot be lost by mistake.

To compare against the original code (for example, to check whether a failure is pre-existing), use a non-destructive method:

- `git stash push -- <your files>` then `git stash pop` immediately after — only when those files contain nothing but your changes
- `git worktree add <tmp-path> HEAD` to get a clean copy, then remove the worktree
- `git show HEAD:<path>` to read the original version of a file

## Before completion

```text
git status
git diff
git diff --staged
```

Then verify:

- every changed or new file is intended
- baseline files are unchanged (same content as when you started)
- no temporary or generated files are left behind unless the project tracks them
- no secrets, credentials, or local config appear in the diff

You may only state "only the intended files changed" after running these commands. List changed files in the final report (see `completion.md`).
