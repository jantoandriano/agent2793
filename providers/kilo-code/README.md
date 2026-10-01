# Adapter: Kilo Code

First practical provider target.

> Kilo Code evolves quickly (VS Code extension, JetBrains, and CLI share configuration but have changed paths across versions). The paths below follow Kilo Code's documented `.kilocode/` layout. Confirm them against the current Kilo Code documentation for your version; if your version uses a different directory, keep the same mapping and change only the paths.

## Mapping

| Engineering Agent | Kilo Code mechanism |
|---|---|
| `core/AGENTS.md` | Global custom rules: `~/.kilocode/rules/` |
| `core/skills/software-engineering/` | Skills: `~/.kilocode/skills/software-engineering/` |
| `commands/*.md` | Workflows: `~/.kilocode/workflows/`, invoked as `/<filename>` |
| `workflows/`, `templates/` | Read from the Engineering Agent root |
| Project rules | Project `AGENTS.md` and `.kilocode/rules/` — loaded by Kilo Code as usual |

## Install (user level)

macOS / Linux:

```sh
git clone <engineering-agent-repo-url> ~/.engineering-agent
EA=~/.engineering-agent

mkdir -p ~/.kilocode/rules ~/.kilocode/skills ~/.kilocode/workflows
ln -s "$EA/core/AGENTS.md"                     ~/.kilocode/rules/engineering-agent.md
ln -s "$EA/core/skills/software-engineering"   ~/.kilocode/skills/software-engineering
for f in "$EA"/commands/*.md; do ln -s "$f" ~/.kilocode/workflows/"$(basename "$f")"; done

echo "Engineering Agent root: $EA" > ~/.kilocode/rules/engineering-agent-root.md
```

Windows (PowerShell; symlinks need Developer Mode or an elevated shell — otherwise use `Copy-Item` and re-copy after updates):

```powershell
git clone <engineering-agent-repo-url> "$HOME\.engineering-agent"
$EA = "$HOME\.engineering-agent"
New-Item -ItemType Directory -Force "$HOME\.kilocode\rules", "$HOME\.kilocode\skills", "$HOME\.kilocode\workflows" | Out-Null
New-Item -ItemType SymbolicLink -Path "$HOME\.kilocode\rules\engineering-agent.md" -Target "$EA\core\AGENTS.md"
New-Item -ItemType SymbolicLink -Path "$HOME\.kilocode\skills\software-engineering" -Target "$EA\core\skills\software-engineering"
Get-ChildItem "$EA\commands\*.md" | ForEach-Object { New-Item -ItemType SymbolicLink -Path "$HOME\.kilocode\workflows\$($_.Name)" -Target $_.FullName }
"Engineering Agent root: $EA" | Set-Content "$HOME\.kilocode\rules\engineering-agent-root.md"
```

## Usage

```text
/engineer.md Add CSV export to the invoice list (ticket INV-142)
/plan.md     Migrate the settings page to the new form library
/review.md
/test.md
/debug.md    tests/invoices/export.test.ts fails with "TypeError: rows is not iterable"
```

Kilo Code workflow invocation includes the file extension in some versions (`/engineer.md`) and not in others. Use whatever your version's command palette shows.

## Modes

Kilo Code modes restrict which tools are available. Recommended pairing:

| Command | Mode |
|---|---|
| `/plan`, `/review`, investigation tasks | Architect or Ask (read-only) |
| `/engineer`, `/test`, `/debug` | Code |

`/plan` and `/review` already forbid edits in their text; a read-only mode enforces it. Custom modes (`.kilocodemodes` / global custom modes) can bundle the contract into a dedicated "Engineer" mode if preferred, but rules + workflows are sufficient.

## Project-specific rules

Kilo Code loads the project's `AGENTS.md` and `.kilocode/rules/` in addition to global rules. Project rules override the generic contract except its safety rules (`core/AGENTS.md`, "Instruction precedence"). Nothing needs to be added to the target repository.

## Limitations

- Global rules are always loaded and consume context on every task. `core/AGENTS.md` is kept compact for this reason; the detailed skill files load only when needed.
- If your Kilo Code version does not support skills, add a line to the root rule file: `Skill files: <EA>/core/skills/software-engineering/ — read the relevant phase file before each phase.`
- Workflows run inside the current mode; switch to a read-only mode yourself for `/plan` and `/review` if you want enforcement rather than instruction.

## Verify

See "Verifying any installation" in [`providers/README.md`](../README.md).
