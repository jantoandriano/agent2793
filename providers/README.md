# Provider Adapters

Everything outside `providers/` is tool-neutral Markdown. An adapter explains how to make one AI coding tool load it. Provider-specific details live here and nowhere else.

| Provider | Adapter |
|---|---|
| Kilo Code (first target) | [`kilo-code/`](kilo-code/README.md) |
| Claude Code | [`claude-code/`](claude-code/README.md) |
| Codex | [`codex/`](codex/README.md) |
| Cursor and others | See "Any other agent" below |

Provider features change often. Each adapter names the mechanism it relies on; confirm it against the provider's current documentation when installing.

## What an adapter must achieve

1. **`AGENTS.md` is always loaded** — through the tool's global (user-level) instruction mechanism, so every session in every repository gets it without modifying the repositories.
2. **The agent knows `EA_HOME`** — a line such as `Engineering Agent root: ~/.engineering-agent` next to the instructions, so the agent can open `rules/`, `ticket/`, `workflows/`, and `templates/` on demand. (`ticket.md` also records it, as `workspace.engineering_agent`.)
3. **Project instructions still load** — the tool's normal project instruction files (`AGENTS.md`, rule directories) keep working, so project rules can override generic ones (`AGENTS.md` §3).
4. **The agent can read files outside the worktree** — it must read `EA_HOME` and the context directory in the main worktree. If the tool sandboxes reads to the open folder, allow these two locations.

Only `AGENTS.md` is loaded up front; everything else is read when the phase needs it. This keeps the always-on context small.

## Installation pattern

```sh
git clone <engineering-agent-repo-url> ~/.engineering-agent
```

Then follow the adapter for your tool. Optionally put the scripts on your `PATH`:

```sh
export PATH="$HOME/.engineering-agent/scripts:$PATH"   # start-ticket, finish-ticket, create-worktree
```

On Windows, run the scripts from Git Bash (or WSL).

## Any other agent

For Cursor or any tool with global or project rules:

1. Add a global rule (or, if the tool has none, a project rule kept out of version control) containing:
   ```text
   Engineering Agent root: ~/.engineering-agent
   Read ~/.engineering-agent/AGENTS.md at the start of every task and follow it.
   ```
   or include `AGENTS.md` content directly if the tool cannot read files referenced by rules.
2. Verify as below.

## Verify an installation

In a test repository:

```sh
start-ticket TEST-1 --title "Add a --verbose flag"
```

Open the printed worktree in the tool and send:

```text
Implement ticket TEST-1. Follow the engineering-agent workflow. Stop after the plan.
```

Expected: the agent checks branch, status, and worktrees; sets `ticket.status` to `ANALYZING`; writes `analysis.md` and `dependency-analysis.md` in `.work/TEST-1/`; writes `plan.md`; and modifies no code.
