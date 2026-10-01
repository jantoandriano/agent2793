# Adapter: Codex

> Uses the Codex CLI global instruction file `~/.codex/AGENTS.md`. Confirm against the current Codex documentation when installing.

## Mapping

| Engineering Agent | Codex |
|---|---|
| `AGENTS.md` (always loaded) | Appended to `~/.codex/AGENTS.md` |
| `EA_HOME` | A line in `~/.codex/AGENTS.md` |
| `rules/`, `ticket/`, `workflows/`, `templates/` | Read on demand from `EA_HOME` |
| Project rules | Project `AGENTS.md` files (repository root down to the working directory) — loaded by Codex as usual, more specific files taking precedence |

## Install

```sh
git clone <engineering-agent-repo-url> ~/.engineering-agent
{
  echo
  echo "Engineering Agent root: $HOME/.engineering-agent"
  echo
  cat ~/.engineering-agent/AGENTS.md
} >> ~/.codex/AGENTS.md
```

This appends a copy: after updating the root (`git pull`), replace that section again. Windows: `%USERPROFILE%\.codex\AGENTS.md`.

## Use

```sh
~/.engineering-agent/scripts/start-ticket HYP-123 --title "Add CSV export"
cd ../worktrees/HYP-123 && codex
```

```text
Implement Jira ticket HYP-123. Follow the agent2793 workflow.
<paste the ticket description>
```

One `codex` session per worktree for parallel tickets. Use a read-only sandbox/approval mode for analysis-only and investigation tickets.

## Limitations

- The default sandbox limits writes to the working directory. The agent must write its context in `<main worktree>/.work/<ID>/`, outside the ticket worktree: allow that directory as writable (e.g. `--add-dir`, or the corresponding sandbox setting), or approve the writes.
- Codex caps the combined size of loaded `AGENTS.md` content. `AGENTS.md` here is kept compact; if a large project `AGENTS.md` exceeds the limit, raise it in Codex configuration.

## Verify

See "Verify an installation" in [`providers/README.md`](../README.md).
