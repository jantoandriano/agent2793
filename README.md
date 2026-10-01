# Engineering Agent

**Engineering Agent is not a coding agent. It is a reusable engineering behavior layer for coding agents.**

It is a set of plain Markdown documents — a behavioral contract, a skill, commands, workflows, and templates — that you load into an existing AI coding agent (Kilo Code, Claude Code, Codex, and others) so that it works the way a careful, experienced software engineer does: understand the task, investigate the repository, plan, implement, test, debug by root cause, review the real diff, validate, and report honestly.

## The problem

Coding agents are good at editing files. Left to defaults, they often:

- start editing before understanding the task or the repository
- invent new patterns instead of following existing ones
- treat tests as an afterthought, or skip them
- "fix" failures by trial and error, or by weakening tests
- loop forever on the same failure
- touch unrelated files, or overwrite uncommitted user work
- declare success without running the build, the tests, or looking at the diff

Engineering Agent addresses these with concrete, checkable rules — for example: *run `git status` before the first edit and preserve existing changes*; *at most 3 focused fix attempts per failure, then escalate*; *never report a check as passing unless you ran it after your last change*.

## How it differs from a coding agent

| | Coding agent (Kilo Code, Claude Code, Codex, ...) | Engineering Agent |
|---|---|---|
| Reads, searches, edits files | ✅ | — |
| Runs commands, uses git | ✅ | — |
| Model, reasoning, tool calling | ✅ | — |
| Decides *how* to approach an engineering task | Generic defaults | ✅ Defined lifecycle and rules |
| When to ask a human | Varies | ✅ Explicit escalation rules |
| What "done" means | Varies | ✅ Evidence-based Definition of Done |

The coding agent is the runtime. Engineering Agent is the professional discipline it follows. There is no server, no runtime, no API integration — only behavior definitions.

## Supported providers

| Provider | Adapter |
|---|---|
| Kilo Code (first target) | [`providers/kilo-code/`](providers/kilo-code/README.md) |
| Claude Code | [`providers/claude-code/`](providers/claude-code/README.md) |
| Codex | [`providers/codex/`](providers/codex/README.md) |

Any agent that can load instruction files and read files on demand can use it; see [`providers/README.md`](providers/README.md) for writing a new adapter.

## Installation (concept)

```text
Clone Engineering Agent → pick your provider → link the contract, skill, and commands into the provider's user-level config → open any repository
```

1. Clone this repository to a stable location (recommended `~/.engineering-agent`). This is the **Engineering Agent root**.
2. Follow your provider's adapter to:
   - make `core/AGENTS.md` always-loaded instructions, and state where the root is
   - expose `core/skills/software-engineering/` as a skill
   - expose `commands/*.md` as slash commands
3. Open any repository and give the agent a task.

Installing at user level means target repositories need no changes and do not need to know which provider you use.

## Usage (concept)

```text
/engineer Add CSV export to the invoice list. Columns: number, customer, date, total.
          Empty list should export only the header.
```

The agent then, in order:

1. runs `git status` and notes any uncommitted work it must preserve
2. extracts acceptance criteria, constraints, non-goals; asks only material questions
3. finds how the repository already does similar exports, its test conventions, and its validation commands
4. writes a short plan (files, tests, commands, risks)
5. implements the smallest complete change with tests
6. runs targeted tests; on failure debugs by root cause (max 3 attempts, then asks)
7. reviews `git diff` across correctness, scope, types, security, tests, compatibility
8. runs typecheck, lint, tests, build
9. ends with a report and one status: `READY FOR PR`, `NEEDS HUMAN INPUT`, or `BLOCKED`

Example report tail:

```text
## Validation
- pnpm typecheck — passed
- pnpm lint — passed
- pnpm test — passed (214 tests, 6 new)
Not verified:
- pnpm test:e2e — requires a browser runtime not available here.

## Final status
NEEDS HUMAN INPUT — e2e suite must be run before merging.
```

## Core workflow

```text
Understand → Clarify → Investigate → Plan → Implement → Test → Fix → Review → Validate → Complete
```

The lifecycle moves backward when evidence requires it:

```text
Test fails            → Fix → Implement → Test
Review finds an issue → Implement → Test → Review
Plan proves wrong     → Plan (updated, with the reason stated)
```

Every phase is scaled to the task — a typo fix runs through the same phases in seconds. Task-specific workflows refine the lifecycle:

| Workflow | For |
|---|---|
| [`workflows/feature.md`](workflows/feature.md) | New functionality |
| [`workflows/bugfix.md`](workflows/bugfix.md) | Incorrect behavior — reproduce first, fix the root cause, add a regression test |
| [`workflows/refactor.md`](workflows/refactor.md) | Structural change — safety net first, small steps, behavior preserved |
| [`workflows/investigation.md`](workflows/investigation.md) | Understanding or diagnosis without code changes |

## Repository layout

```text
core/
  AGENTS.md                         Behavioral contract (always loaded)
  skills/software-engineering/      Detailed phase guidance (loaded on demand)
commands/                           /engineer, /plan, /review, /test, /debug
workflows/                          feature, bugfix, refactor, investigation
templates/                          task-plan, test-plan, review-report
providers/                          Provider adapters (the only provider-specific content)
```

## Skills

The `software-engineering` skill ([`core/skills/software-engineering/SKILL.md`](core/skills/software-engineering/SKILL.md)) holds one file per concern:

| File | Covers |
|---|---|
| [`requirements.md`](core/skills/software-engineering/requirements.md) | Extracting acceptance criteria, non-goals, assumptions; resolve vs. assume vs. ask |
| [`investigation.md`](core/skills/software-engineering/investigation.md) | Learning the repository: structure, conventions, similar code, tests, validation commands |
| [`planning.md`](core/skills/software-engineering/planning.md) | Concrete, proportional, test-aware plans |
| [`implementation.md`](core/skills/software-engineering/implementation.md) | Smallest complete change, existing patterns, compatibility, types, errors |
| [`testing.md`](core/skills/software-engineering/testing.md) | Test planning, targeted vs. full validation, reading results |
| [`debugging.md`](core/skills/software-engineering/debugging.md) | Root-cause loop, failure classification, 3-attempt retry limit |
| [`code-review.md`](core/skills/software-engineering/code-review.md) | Reviewing the actual diff; severities; review → fix loop |
| [`git.md`](core/skills/software-engineering/git.md) | Baseline, preserving user changes, forbidden destructive commands |
| [`completion.md`](core/skills/software-engineering/completion.md) | Definition of Done, final report, final status |
| [`human-escalation.md`](core/skills/software-engineering/human-escalation.md) | When and how to stop and ask |

The skill uses the common `SKILL.md` format (frontmatter `name` and `description`), so providers with skill support can load it directly.

## Commands

| Command | Does | Modifies code |
|---|---|---|
| [`/engineer`](commands/engineer.md) | Full lifecycle, ends with a final report | Yes |
| [`/plan`](commands/plan.md) | Understand → Investigate → Plan | No |
| [`/review`](commands/review.md) | Reviews current diff; findings with severity, location, reasoning, fix | No (unless asked) |
| [`/test`](commands/test.md) | Finds and runs the right validation; diagnoses failures | Only in-scope fixes when expected |
| [`/debug`](commands/debug.md) | Reproduces and root-causes one failure | Only if a fix is requested |

Command names may be prefixed by a provider adapter to avoid collisions (for example `/ea-review` in Claude Code).

## Provider adapters

Adapters map each piece to the provider's mechanisms — instruction files, skills, slash commands — and document limitations such as instruction size limits or read-only modes. Provider-specific statements live only in `providers/`. To support another agent, write a new adapter following [`providers/README.md`](providers/README.md); the core does not change.

## Project-specific customization

Engineering Agent is the most general layer. Projects refine it with their normal instruction files:

```text
Engineering Agent (core/AGENTS.md)
        ↓
Project AGENTS.md (or CLAUDE.md, etc.)
        ↓
Project-specific rules
        ↓
Task requirements
```

More specific layers override more general ones. Example:

```text
Engineering Agent:  Use the project's existing conventions and validation commands.
Project AGENTS.md:  Use pnpm. Lint with Biome, not ESLint. Tests use Vitest. Run `pnpm check` before finishing.
Result:             The agent uses pnpm, Biome, Vitest, and runs `pnpm check` during Validate.
```

Exception: the **safety rules** in `core/AGENTS.md` (preserve user work, no destructive commands, no false completion claims, protect secrets, escalate when required) can only be relaxed by an explicit instruction from the human in the current session — not by a project file or a ticket.

## Design philosophy

- **Behavior, not runtime.** The coding agent already reads, edits, runs, and reasons. Engineering Agent adds judgment about *how* — nothing else.
- **Concrete over aspirational.** "Inspect the existing implementation before creating a new abstraction", not "use best practices".
- **Proportional.** Same lifecycle for every task, scaled to its size. No ceremony for typos, no shortcuts for migrations.
- **Evidence over assertion.** Nothing is reported as passing, complete, or limited to intended files without a command that shows it.
- **Maximum safe autonomy.** Proceed independently on what can be determined safely; stop exactly where a human decision is needed.
- **Provider-neutral core.** Capabilities are described conceptually (read files, search, edit, run commands, inspect git). Provider details live in adapters.

## Roadmap

- Validate and refine the Kilo Code adapter against real tasks
- Adapters for Cursor and other agents
- Install scripts per provider (symlink-based, idempotent)
- Example transcripts showing each workflow end to end
- Optional stack-specific skills (e.g. frontend, database migrations) layered on the core
- A lightweight checker for internal references between documents

## License

[MIT](LICENSE)
