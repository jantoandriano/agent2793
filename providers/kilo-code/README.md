# Adapter: Kilo Code

First practical target.

> Based on Kilo's config file `kilo.jsonc` (schema `https://app.kilo.ai/config.json`): global at `~/.config/kilo/kilo.jsonc`, per project at `<project>/.kilo/kilo.jsonc` (or `<project>/kilo.jsonc`; `.kilo/` wins), deep-merged. It uses the `instructions` key ("Additional instruction files or patterns to include") and the `external_directory` permission. Older Kilo Code versions used `~/.kilocode/rules/` instead; if yours does, place `AGENTS.md` there with the same effect.

## Mapping

| Engineering Agent | Kilo |
|---|---|
| `AGENTS.md` (always loaded) | `instructions` in `kilo.jsonc` (global or per project) |
| `EA_HOME` | Path of the instruction file; also `workspace.engineering_agent` in `ticket.md` |
| `rules/`, `ticket/`, `workflows/`, `templates/` | Read on demand from `EA_HOME` |
| Reading `EA_HOME` and `.work/` outside the worktree | `permission.external_directory` |
| Project rules | Project `AGENTS.md` — loaded by Kilo as usual |

Use absolute paths in `instructions`. Below, `EA_HOME` is `D:/Projects/agent2793`; substitute your location.

## Option A — per project, local only (recommended for trying it out)

Loads Engineering Agent only for chosen repositories, without committing anything to them.

1. In the application repository's main checkout, create `.kilo/kilo.jsonc`:

   ```jsonc
   {
     "$schema": "https://app.kilo.ai/config.json",
     "instructions": ["D:/Projects/agent2793/AGENTS.md"],
     "permission": { "external_directory": "ask" }
   }
   ```

   `"ask"` prompts before reading outside the opened folder (Engineering Agent files, `.work/`); use `"allow"` to skip prompts.

2. Tell `start-ticket` to copy it into every ticket worktree — create `.work/local-files`:

   ```text
   .kilo/kilo.jsonc
   ```

   Ticket worktrees contain only tracked files; without this step Kilo in the worktree would not see the config. The copy is kept out of `git status` (`workspace/structure.md`, "Local files copied into worktrees").

3. Keep `.kilo/` out of commits in the main checkout: it is ignored if your global gitignore lists it; otherwise add `/.kilo/` to `.git/info/exclude`.

## Option B — global

Loads Engineering Agent in every Kilo session, for every repository and worktree. Add to `~/.config/kilo/kilo.jsonc` (Windows: `C:\Users\<you>\.config\kilo\kilo.jsonc`):

```jsonc
"instructions": ["D:/Projects/agent2793/AGENTS.md"],
```

and set `external_directory` in your existing `permission` block as in option A. No `.work/local-files` needed.

## Option C — committed to the project

Commit `.kilo/kilo.jsonc` to the application repository so every clone and worktree has it. Only sensible when everyone has Engineering Agent at the same absolute path.

## Use

In Git Bash:

```bash
cd /d/Projects/my-app
/d/Projects/agent2793/scripts/start-ticket HYP-123 --title "Add CSV export"
code D:/Projects/worktrees/HYP-123      # one VS Code window per ticket = one Kilo session
```

In that window's Kilo panel:

```text
Implement Jira ticket HYP-123. Follow the agent2793 workflow.
<paste the ticket description>
```

When the agent reports completion:

```bash
/d/Projects/agent2793/scripts/finish-ticket HYP-123
```

## Agents (modes)

| Phase | Kilo agent |
|---|---|
| Analyze, plan, investigation tickets, reviewing others' work | `plan` or `ask` (read-only) |
| Implement, validate, self-review, finish | `code` |
| Diagnosing a specific failure | `debug` |

## Limitations

- Not confirmed from Kilo's documentation: whether a project `instructions` list is appended to or replaces the global one, and how relative paths in `instructions` resolve. Absolute paths avoid the second; if you use both global and project instructions, check that both load.
- Every worktree needs its own dependency install (`node_modules` is not shared).
- Kilo's auto-approve settings decide whether commands run without confirmation. Keep approval on for git writes (commit, push) if you want "never push unless asked" enforced by the tool as well.

## Verify

See "Verify an installation" in [`providers/README.md`](../README.md). In the verification session, ask Kilo: "Which instruction files are loaded?" — it should list `AGENTS.md` from the Engineering Agent root.
