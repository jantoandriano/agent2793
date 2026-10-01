# agent2793 Setup (instructions for the AI agent)

The human asked you to set up agent2793 in their project, or to start a ticket with it. Follow the matching section exactly. `EA_HOME` is the directory containing this file.

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

### 5. Discover validation

Find the project's validation commands (`rules/testing.md`, "Discover validation commands"): CI config, package scripts, Makefile, README. Compare with what `scripts/finish-ticket` would detect automatically (see its `--help`).

- Detection matches the project → nothing to do.
- Detection would miss or run the wrong commands → propose `.agent2793/validation` (one `name: command` per line, see `workspace/structure.md`). It is a tracked file: ask before creating it.

### 6. Offer project rules (optional)

If the project has no `AGENTS.md`, offer to draft one with the conventions you found (package manager, lint/format tools, test framework, validation commands, branch naming). It is tracked: show the draft and ask before writing it.

### 7. Report

```text
agent2793 set up in <project>

Created/changed:
- .kilo/kilo.jsonc — <created | added instruction entry | already configured>
- .work/local-files — <created | added .kilo/kilo.jsonc | already listed>
- .git/info/exclude — <entries added | nothing needed>

Validation commands: <list>  (automatic detection: <ok | .agent2793/validation proposed>)
Tracked files changed: none   (or: list, with the human's approval)

Next: start a ticket — "Start ticket <ID> with agent2793".
Note: reload the editor window (or restart the agent session) so the new instructions load.
```

## B. Start a ticket

The human says something like "Start ticket HYP-123 'Add CSV export' with agent2793".

1. Confirm you are in the project's main worktree (step A1). If `.work/local-files` does not exist, run section A first, or ask.
2. Run the script with bash (on Windows, Git Bash: `bash` if on PATH, otherwise `"C:/Program Files/Git/bin/bash.exe"`):

   ```bash
   bash <EA_HOME>/scripts/start-ticket <ID> --title "<title>" [--type feature|bug|refactor|investigation|chore] [--base <branch>]
   ```

   Infer `--type` from the human's description when obvious (bug report → `bug`); otherwise use the default. Use `--base <other ticket branch>` only if the human says the ticket builds on another ticket.
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
