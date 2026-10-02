# agent2793 Setup (instructions for the AI agent)

The human asked you to set up agent2793 in their project, or to start, check, or clean up tickets with it. Follow the matching section exactly. `EA_HOME` is the directory containing this file.

Ground rules for everything below:

- Do not commit, push, or modify tracked files unless the human approves the specific change.
- Do not overwrite existing configuration; merge into it.
- Report exactly what you created or changed, with paths.

## A. Set up a project

Run in the project the human has open.

### 1. Check the repository

```bash
git rev-parse --show-toplevel      # must succeed: this is a git repository
git worktree list                  # first entry = main worktree
git status --short
```

- Not a git repository → stop and tell the human.
- Current directory is a ticket worktree, not the main worktree (first entry of `git worktree list`) → tell the human to run setup in the main checkout, and stop.
- Note pre-existing changes; do not touch them.

### 2. Load agent2793 into the AI tool for this project

**Kilo** — edit `<project>/.kilo/kilo.jsonc` (create it if missing):

```jsonc
{
  "$schema": "https://app.kilo.ai/config.json",
  "instructions": ["<EA_HOME>/AGENTS.md"],
  "permission": { "external_directory": "ask" }
}
```

- Use the absolute `EA_HOME` path with forward slashes (e.g. `D:/Projects/agent2793/AGENTS.md`).
- If the file exists: add the entry to `instructions` if it is not already there, keeping existing entries and comments; add `permission.external_directory: "ask"` only if `external_directory` is not set. Change nothing else.
- If `.kilo/kilo.jsonc` is tracked by git (`git ls-files .kilo/kilo.jsonc` prints it), the change would be committed for everyone: show the diff and ask before editing.

**Other tools** — follow `providers/<tool>/README.md` for per-project or global setup, and ask the human which they want.

### 3. Make ticket worktrees get the config

Ticket worktrees contain only committed files. Add the tool config path to `<project>/.work/local-files` (create `.work/` if needed), one path per line, without duplicating existing lines:

```text
.kilo/kilo.jsonc
```

### 4. Keep local files out of git

For each of `.work/` and `.kilo/kilo.jsonc` (or the other tool's config):

```bash
git check-ignore -q <path> || echo "not ignored"
```

If not ignored, append it to `.git/info/exclude` (local, untracked) — e.g. `/.work/`, `/.kilo/kilo.jsonc`. Do not edit the tracked `.gitignore` without asking.

Then confirm `git status --short` shows no new entries compared to step 1.

### 5. Reuse the project's existing instruction files

Projects often already have instructions written for some AI tool. They are the project rules (`AGENTS.md` §3). **Use them as they are. Never create a new instruction file (`AGENTS.md` or any other) during setup, and do not offer to.**

Look in the project root for:

| File | Usually written for |
|---|---|
| `AGENTS.md` | Kilo, Codex, many others |
| `CLAUDE.md`, `.claude/CLAUDE.md` | Claude Code |
| `.cursorrules`, `.cursor/rules/*.mdc` | Cursor |
| `.github/copilot-instructions.md` | GitHub Copilot |
| `.kilocode/rules/*.md`, `.roo/rules/*.md`, `.clinerules` | Older Kilo Code, Roo, Cline |
| `.windsurfrules`, `GEMINI.md`, `CONVENTIONS.md` | Windsurf, Gemini, Aider |

For **Kilo**: Kilo loads the project's `AGENTS.md` by itself. For every other file found, add its repository-relative path (or glob, e.g. `.cursor/rules/*.mdc`) to `instructions` in `.kilo/kilo.jsonc`, after the agent2793 entry, so the session follows those rules too. If a file only imports others (e.g. `CLAUDE.md` containing `@AGENTS.md`), add the imported files instead, skipping `AGENTS.md`. Use relative paths so each ticket worktree loads its own copy.

These are edits to the local `.kilo/kilo.jsonc` only; tracked files stay unchanged.

### 6. Check validation (report only)

Find the project's validation commands (`rules/testing.md`, "Discover validation commands"): CI config, package scripts, Makefile, README, and the instruction files from step 5. Compare with what `scripts/finish-ticket` would detect automatically (see its `--help`).

Do not create `.agent2793/validation` and do not ask about it. Report what `finish-ticket` would run. If that differs from what the project uses, say so in the report and mention that `.agent2793/validation` can be added later if the human wants (`workspace/structure.md`).

### 7. Report

```text
agent2793 set up in <project>

Created/changed:
- .kilo/kilo.jsonc — <created | added instruction entries | already configured>
- .work/local-files — <created | added .kilo/kilo.jsonc | already listed>
- .git/info/exclude — <entries added | nothing needed>

Project instructions in use: <AGENTS.md (loaded by Kilo), CLAUDE.md (added to instructions), ... | none found>
Validation finish-ticket would run: <list>  (<matches the project | differs: ... — .agent2793/validation can be added later>)
Tracked files changed: none

Next: start a ticket — "Start ticket <ID> with agent2793".
Note: reload the editor window (or restart the agent session) so the new instructions load.
```

## B. Start a ticket

The human says something like "Start ticket HYP-123 'Add CSV export' with agent2793". Every ticket gets its own worktree; never start one by editing in the current folder (`AGENTS.md` §1, "Start ticket").

1. Run from any worktree of the project (the main checkout or another ticket's worktree); the script always places the new worktree next to the main one. If `.work/local-files` does not exist in the main worktree, the tool config will not be copied: mention it and offer section A after the ticket is started.
2. Run the script with bash (on Windows, Git Bash: `bash` if on PATH, otherwise `"C:/Program Files/Git/bin/bash.exe"`):

   ```bash
   bash <EA_HOME>/scripts/start-ticket <ID> --title "<title>" [--type feature|bug|refactor|investigation|chore] [--base <branch>]
   ```

   Infer `--type` from the human's description when obvious (bug report → `bug`); otherwise use the default. Use `--base <other ticket branch>` only if the human says the ticket builds on another ticket. `<ID>` is the ticket ID (e.g. `HYPCRE-7314`); a full branch or Jira branch name (e.g. `feature/HYPCRE-7314-add-csv-export`) is also accepted and reduced to the ticket ID.
3. Report the branch, worktree path, and context path from the script output.
4. Tell the human how to start the ticket's agent session **in the worktree folder**:

   - **Kilo (VS Code):** in Agent Manager, import the existing worktree `<worktree path>` (it is already on disk) to create a session in it. No new window needed.
   - **Any tool:** open the worktree folder as its own workspace/window, or start the tool's CLI with the worktree as working directory.

   and to send in that session:

   ```text
   Implement ticket <ID>. Follow the agent2793 workflow.
   <ticket description>
   ```

Do not implement the ticket in the current session: this session works in the main worktree, and each ticket needs its own session whose working folder is the ticket's worktree (`workspace/README.md`). A new chat in the same folder is not enough — it would still edit the main worktree.

## C. Finish a ticket

The human says "Check if ticket HYP-123 is ready" (in any session of that project):

```bash
bash <EA_HOME>/scripts/finish-ticket <ID>
```

Report the result and blockers. Do not commit, push, or change `ticket.status` unless asked.

## D. PR review feedback

**"Check my PRs" / "Which tickets have PR feedback?"** (any session of the project):

```bash
bash <EA_HOME>/scripts/check-prs
```

Report the table and the suggested actions. Read-only.

**"Address PR feedback for HYP-123"** — must run in that ticket's session (its worktree). If you are in the main worktree or another ticket's worktree, tell the human which session to use and stop. Otherwise follow `ticket/pr-feedback.md`.

## E. Clean up merged tickets

The human says "Clean up merged tickets" or "Clean up HYP-123". Run from the main checkout (first entry of `git worktree list`). If this session works inside a ticket worktree, that worktree cannot be removed from here: say so and skip it.

1. Preview:

   ```bash
   bash <EA_HOME>/scripts/cleanup-ticket --merged --dry-run      # or: cleanup-ticket HYP-123 --dry-run
   ```

2. Tell the human to close the Agent Manager sessions (and editors, dev servers) of the tickets that would be removed. On Windows, open files block the removal.
3. Run the same command without `--dry-run`.
4. Report what was removed and every ticket that was kept, with the script's reason (not merged, uncommitted changes, local commits not in the PR). Do not resolve those yourself. Never use `--force` unless the human names the ticket and accepts losing its uncommitted work.

The script decides "merged" from the pull request on GitHub (`gh`), not from the Jira status: Jira workflows differ (Done, Released, Closed, ...) and a ticket can be Done in Jira while its PR is still open, or the reverse. Do not remove a worktree because of the Jira status. The script keeps `.work/<ID>/`, never deletes remote branches, and sets `ticket.status: DONE` for merged tickets.

`--merged` also cleans up stale Kilo Agent Manager worktrees under `.kilo/worktrees/` (leftovers from Agent Manager sessions that are no longer running), using the same command. A branch-attached one is removed when its PR is merged or its branch is contained in the base; a detached one is removed when its HEAD is contained in the base branch and is not the current base tip. Close the Agent Manager session first; a dirty worktree, and the one this session runs from, are skipped with the reason. The script removes only the worktree directory, never a branch.
