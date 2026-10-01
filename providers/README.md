# Provider Adapters

The core (`core/`, `commands/`, `workflows/`, `templates/`) is provider-neutral. An adapter documents how to load it into one specific coding agent. Provider-specific details belong here and nowhere else.

| Provider | Adapter | Status |
|---|---|---|
| Kilo Code | [`kilo-code/`](kilo-code/README.md) | First target |
| Claude Code | [`claude-code/`](claude-code/README.md) | Documented |
| Codex | [`codex/`](codex/README.md) | Documented |

Provider features change often. Each adapter lists the mechanisms it relies on; check them against the provider's current documentation when installing.

## What every adapter must map

| Engineering Agent piece | Purpose | Typical provider mechanism |
|---|---|---|
| `core/AGENTS.md` | Always-on behavioral contract | Global/user instruction file or always-applied rules |
| `core/skills/software-engineering/` | Detailed phase guidance, loaded on demand | Skills directory (`SKILL.md` with `name`/`description` frontmatter), or rule files |
| `commands/*.md` | User-invoked entry points (`/engineer`, `/plan`, ...) | Custom slash commands, prompts, or workflows |
| `workflows/`, `templates/` | Referenced by commands and skill files | Read from the Engineering Agent root at runtime |
| Engineering Agent root | Lets the agent resolve paths like `workflows/bugfix.md` | Stated in the installed instruction file |
| Project `AGENTS.md` / rules | Project-specific overrides | Provider's normal project instruction loading — unchanged |

## Installation pattern

1. Clone the repository to a stable location, the **Engineering Agent root**. Recommended: `~/.engineering-agent`.
2. Make `core/AGENTS.md` always loaded at user/global level, and tell the agent where the root is, e.g. add:
   ```text
   Engineering Agent root: ~/.engineering-agent
   ```
3. Expose `core/skills/software-engineering/` through the provider's skill mechanism. Prefer a symlink over a copy so `git pull` in the root updates it.
4. Expose each file in `commands/` through the provider's command mechanism. Rename on collision with built-in commands (for example `ea-review`).
5. Leave project instructions where the project keeps them. The target repository does not need to know which provider or adapter is in use.

Installing at user/global level keeps target repositories untouched. Installing at project level (committing the files into a repository) is possible but couples that repository to a provider; prefer it only when a team agrees to it.

## Writing a new adapter

Create `providers/<provider>/README.md` covering:

1. **Mapping** — how each row of the table above maps to the provider.
2. **Installation** — exact paths and commands, user-level and (optionally) project-level.
3. **Skills** — how the skill is discovered and loaded; fallback if the provider has no skill mechanism (e.g. reference the files from the instruction file and let the agent read them on demand).
4. **Commands** — how commands are invoked, how arguments are passed, and name collisions.
5. **Project rules** — which project instruction files the provider reads and in what order, so the precedence in `core/AGENTS.md` holds.
6. **Limitations** — anything the provider cannot do (no read-only mode, instruction size limits, no skill loading) and the workaround.
7. **Verification** — a short prompt that proves the installation works.

Do not modify core files to suit one provider. If the core needs a change to be portable, change it in provider-neutral terms.

## Verifying any installation

In a test repository with an uncommitted change, ask the agent:

```text
/plan Add a --verbose flag to the CLI
```

Expected: it runs `git status` and notes the existing change, identifies the project's conventions and validation commands, produces a plan in the `templates/task-plan.md` shape, and modifies no files.
