# Adapter: Claude Code

> Paths and features below follow Claude Code's documented user-level configuration (`~/.claude/`). Confirm against the current Claude Code documentation when installing.

## Mapping

| Engineering Agent | Claude Code mechanism |
|---|---|
| `core/AGENTS.md` | User memory `~/.claude/CLAUDE.md`, via an `@` import |
| `core/skills/software-engineering/` | Skills: `~/.claude/skills/software-engineering/` |
| `commands/*.md` | Custom slash commands: `~/.claude/commands/` |
| `workflows/`, `templates/` | Read from the Engineering Agent root |
| Project rules | Project `CLAUDE.md` (and `@AGENTS.md` imports inside it) — loaded as usual |

## Install (user level)

macOS / Linux:

```sh
git clone <engineering-agent-repo-url> ~/.engineering-agent
EA=~/.engineering-agent

mkdir -p ~/.claude/skills ~/.claude/commands
ln -s "$EA/core/skills/software-engineering" ~/.claude/skills/software-engineering
for f in "$EA"/commands/*.md; do ln -s "$f" ~/.claude/commands/ea-"$(basename "$f")"; done

cat >> ~/.claude/CLAUDE.md <<'EOF'

# Engineering Agent
Engineering Agent root: ~/.engineering-agent
@~/.engineering-agent/core/AGENTS.md
EOF
```

Windows: same layout under `%USERPROFILE%\.claude\`; create links with `New-Item -ItemType SymbolicLink` (Developer Mode or elevated shell) or copy the files.

Commands are installed with an `ea-` prefix because Claude Code ships built-in commands that may share names (for example `/review`). Alternatively, package the repository as a Claude Code plugin, which namespaces commands automatically (`/engineering-agent:review`).

## Usage

```text
/ea-engineer Add CSV export to the invoice list (ticket INV-142)
/ea-plan     Migrate the settings page to the new form library
/ea-review
/ea-test
/ea-debug    tests/invoices/export.test.ts fails with "TypeError: rows is not iterable"
```

The text after the command is passed as the command's input. If your version requires an explicit placeholder, append `$ARGUMENTS` to the end of each installed command file (copy instead of symlink in that case).

## Read-only commands

Use plan mode for `/ea-plan` and `/ea-review` to enforce the no-edit constraint. Permission settings can additionally restrict tools.

## Project-specific rules

Claude Code reads the project's `CLAUDE.md`, not `AGENTS.md`. For projects that keep their rules in `AGENTS.md`, the project's `CLAUDE.md` can contain `@AGENTS.md`. Project instructions override the generic contract except its safety rules (`core/AGENTS.md`, "Instruction precedence"). The Engineering Agent installation does not require changes to the target repository.

## Limitations

- The imported `core/AGENTS.md` is loaded into every session; skill files load on demand.
- Skills are selected by their `description`. If the skill is not picked up for a task, ask for it explicitly ("use the software-engineering skill") or invoke a command, which references it directly.
- Built-in Claude Code behaviors (its own git and commit guidance, built-in review commands) coexist with this contract. Where they differ, the more conservative rule should win; the safety rules in `core/AGENTS.md` are compatible with Claude Code's defaults.

## Verify

See "Verifying any installation" in [`providers/README.md`](../README.md).
