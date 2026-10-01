# Adapter: Kilo Code

First practical target.

> Kilo Code (VS Code, JetBrains, CLI) has changed configuration paths across versions. This adapter uses the documented global rules directory `~/.kilocode/rules/`. If your version uses a different location (newer versions may use `.kilo/`), keep the mapping and change only the path. Kilo Code also reads a project's `AGENTS.md`.

## Mapping

| Engineering Agent | Kilo Code |
|---|---|
| `AGENTS.md` (always loaded) | Global rule: `~/.kilocode/rules/engineering-agent.md` |
| `EA_HOME` | Global rule: `~/.kilocode/rules/engineering-agent-root.md` |
| `rules/`, `ticket/`, `workflows/`, `templates/` | Read on demand from `EA_HOME` |
| Project rules | Project `AGENTS.md` and `.kilocode/rules/` — loaded by Kilo Code as usual |

## Install

macOS / Linux / Git Bash:

```sh
git clone <engineering-agent-repo-url> ~/.engineering-agent
mkdir -p ~/.kilocode/rules
ln -s ~/.engineering-agent/AGENTS.md ~/.kilocode/rules/engineering-agent.md
echo "Engineering Agent root: $HOME/.engineering-agent" > ~/.kilocode/rules/engineering-agent-root.md
```

Windows PowerShell (symlinks need Developer Mode or an elevated shell; otherwise use `Copy-Item` and re-copy after updates):

```powershell
git clone <engineering-agent-repo-url> "$HOME\.engineering-agent"
New-Item -ItemType Directory -Force "$HOME\.kilocode\rules" | Out-Null
New-Item -ItemType SymbolicLink -Path "$HOME\.kilocode\rules\engineering-agent.md" -Target "$HOME\.engineering-agent\AGENTS.md"
"Engineering Agent root: $HOME\.engineering-agent" | Set-Content "$HOME\.kilocode\rules\engineering-agent-root.md"
```

## Use

```sh
cd ~/projects/my-app
~/.engineering-agent/scripts/start-ticket HYP-123 --title "Add CSV export"
code ../worktrees/HYP-123        # or open the folder in your Kilo Code host
```

In Kilo Code, in that window:

```text
Implement Jira ticket HYP-123. Follow the engineering-agent workflow.
<paste the ticket description>
```

One VS Code window (or Kilo CLI session) per worktree gives each ticket its own agent session.

## Modes

| Phase | Suggested mode |
|---|---|
| Analyze, plan, investigation tickets, reviewing others' work | Architect / Ask (read-only) |
| Implement, validate, self-review, finish | Code |

The documents already forbid edits where appropriate; a read-only mode enforces it. You may create a custom "Engineer" mode, but rules alone are sufficient.

## Limitations

- Kilo Code must be allowed to read outside the opened worktree: `EA_HOME` and `<main worktree>/.work/`. If file access is restricted to the workspace, add both folders to the VS Code workspace (File → Add Folder to Workspace) or approve the reads.
- Global rules are loaded in every session; `AGENTS.md` is kept compact for this reason.
- Kilo Code's own auto-approve settings decide whether commands run without confirmation. Keep approval on for git commands that write (commit, push) if you want the "never push unless asked" rule enforced by the tool as well.

## Verify

See "Verify an installation" in [`providers/README.md`](../README.md).
