# Adapter: Codex

> Paths and features below follow the Codex CLI's documented configuration (`~/.codex/`). Codex features (custom prompts, skills) have changed across releases; confirm against the current Codex documentation when installing.

## Mapping

| Engineering Agent | Codex mechanism |
|---|---|
| `core/AGENTS.md` | Global instructions: `~/.codex/AGENTS.md` |
| `core/skills/software-engineering/` | Skills directory (`~/.codex/skills/software-engineering/`) where supported; otherwise read on demand from the root |
| `commands/*.md` | Custom prompts: `~/.codex/prompts/`, invoked as `/prompts:<name>` |
| `workflows/`, `templates/` | Read from the Engineering Agent root |
| Project rules | Project `AGENTS.md` files (repository root down to the working directory) — loaded as usual |

## Install (user level)

macOS / Linux:

```sh
git clone <engineering-agent-repo-url> ~/.engineering-agent
EA=~/.engineering-agent

mkdir -p ~/.codex/prompts ~/.codex/skills
ln -s "$EA/core/skills/software-engineering" ~/.codex/skills/software-engineering
for f in "$EA"/commands/*.md; do ln -s "$f" ~/.codex/prompts/"$(basename "$f")"; done

# ~/.codex/AGENTS.md may already exist: append rather than overwrite.
{
  echo
  echo "Engineering Agent root: $EA"
  echo "Skill files: $EA/core/skills/software-engineering/ — read the relevant phase file before each phase."
  echo
  cat "$EA/core/AGENTS.md"
} >> ~/.codex/AGENTS.md
```

Because the contract is appended as a copy, re-run the append (after removing the old section) when you update the root. Windows: same layout under `%USERPROFILE%\.codex\`.

## Usage

```text
/prompts:engineer Add CSV export to the invoice list (ticket INV-142)
/prompts:plan     Migrate the settings page to the new form library
/prompts:review
/prompts:test
/prompts:debug    tests/invoices/export.test.ts fails with "TypeError: rows is not iterable"
```

If your Codex version requires an explicit argument placeholder in prompts, append `$ARGUMENTS` to copied prompt files.

## Read-only commands

Run `/prompts:plan` and `/prompts:review` with a read-only sandbox / approval mode so the no-edit constraint is enforced, not only instructed.

## Project-specific rules

Codex reads `AGENTS.md` files from the global location and from the repository, with more specific files taking precedence — the same precedence `core/AGENTS.md` describes. Project rules override the generic contract except its safety rules. No changes to the target repository are needed.

## Limitations

- Codex caps the combined size of loaded `AGENTS.md` content. `core/AGENTS.md` is compact for this reason; detailed guidance lives in skill files that are read on demand. If a large project `AGENTS.md` pushes the total over the limit, raise the limit in Codex configuration or shorten project instructions.
- Custom prompts are user-level only; they are not shared through the repository.
- Without skill support, the agent depends on the "Skill files:" line to find phase guidance; commands also reference the skill files directly.

## Verify

See "Verifying any installation" in [`providers/README.md`](../README.md).
