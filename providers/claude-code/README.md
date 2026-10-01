# Adapter: Claude Code

> Uses Claude Code's user memory file `~/.claude/CLAUDE.md` and its `@path` import syntax. Confirm against the current Claude Code documentation when installing.

## Mapping

| Engineering Agent | Claude Code |
|---|---|
| `AGENTS.md` (always loaded) | `@` import in `~/.claude/CLAUDE.md` |
| `EA_HOME` | A line in `~/.claude/CLAUDE.md` |
| `rules/`, `ticket/`, `workflows/`, `templates/` | Read on demand from `EA_HOME` |
| Project rules | Project `CLAUDE.md` (which can `@AGENTS.md` if the project keeps rules there) |

## Install

```sh
git clone <engineering-agent-repo-url> ~/.engineering-agent
cat >> ~/.claude/CLAUDE.md <<'EOF'

# Engineering Agent
Engineering Agent root: ~/.engineering-agent
@~/.engineering-agent/AGENTS.md
EOF
```

Windows: the same file is `%USERPROFILE%\.claude\CLAUDE.md`.

## Use

```sh
~/.engineering-agent/scripts/start-ticket HYP-123 --title "Add CSV export"
cd ../worktrees/HYP-123 && claude
```

```text
Implement Jira ticket HYP-123. Follow the engineering-agent workflow.
<paste the ticket description>
```

Run one `claude` session per worktree for parallel tickets. Plan mode is a good fit for the analyze and plan phases and for investigation tickets.

## Limitations

- Claude Code asks permission for reads outside the working directory. Approve reads of `EA_HOME` and `<main worktree>/.work/`, or add them as additional directories (`--add-dir` or the `additionalDirectories` setting).
- Claude Code's built-in git and commit guidance coexists with these rules; where they differ, the more conservative rule applies.

## Verify

See "Verify an installation" in [`providers/README.md`](../README.md).
