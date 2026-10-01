# agent2793

A reusable engineering operating system for AI coding agents.

agent2793 is **not an application and not a coding agent**. It is a set of plain Markdown instructions plus three small shell scripts that make AI coding agents (Kilo Code, Claude Code, Cursor, Codex, ...) work tickets the way a careful engineer does — and let several of them work on the same repository at the same time without stepping on each other.

```text
Reusable instructions + ticket workflow + git worktree isolation + ticket context
+ dependency awareness + validation + review
```

## What it gives you

- **Consistent behavior** — every agent session follows the same rules: understand before changing, minimal change, existing patterns first, root-cause debugging, evidence before claims.
- **A standard ticket workflow** — analyze → plan → human checkpoint → implement → validate → self-review → report.
- **Parallel tickets** — one branch, one worktree, one context directory, one agent session per ticket.
- **Dependency detection** — before planning, each ticket is classified `ISOLATED`, `RELATED`, `BLOCKED`, or `CONFLICTING` against other active tickets.
- **Honest completion** — `READY_FOR_PR` only after validation actually ran and the real diff was reviewed.
- **Project overrides** — your repository's own `AGENTS.md` and rules take precedence over the generic ones.
- **Human approval at decision points** — public API changes, migrations, security, scope expansion, unclear dependencies.

## Repository layout

```text
AGENTS.md              entry point for AI agents — the contract
rules/                 engineering, architecture, coding, typescript, react, testing, git, security, documentation
workflows/             ticket (canonical), feature, bug-fix, refactor, investigation, code-review, release
ticket/                phase instructions: analyze, plan, implement, validate, review, finish
templates/             ticket, plan, dependency-analysis, review, implementation-report
workspace/             worktree model and ticket context structure
scripts/               create-worktree, start-ticket, finish-ticket
providers/             how to load this into Kilo Code, Claude Code, Codex, others
```

## Using agent2793 in your projects

The examples use Kilo Code, agent2793 at `D:/Projects/agent2793`, and an application at `D:/Projects/my-app`. Run commands in Git Bash (or any bash on macOS/Linux). Other tools: [`providers/`](providers/README.md).

### Once per machine (optional)

Put the scripts on your `PATH` (`~/.bashrc`) so you can type `start-ticket` instead of the full path:

```bash
export PATH="/d/Projects/agent2793/scripts:$PATH"
```

### Once per project

In the project's main checkout:

```bash
cd /d/Projects/my-app
mkdir -p .kilo .work

cat > .kilo/kilo.jsonc <<'EOF'
{
  "$schema": "https://app.kilo.ai/config.json",
  "instructions": ["D:/Projects/agent2793/AGENTS.md"],
  "permission": { "external_directory": "ask" }
}
EOF

echo ".kilo/kilo.jsonc" >> .work/local-files
```

- `instructions` makes Kilo load the agent2793 contract in this project.
- `external_directory: "ask"` lets the agent read agent2793's files and `.work/`, which are outside the ticket worktree (Kilo prompts first; use `"allow"` to skip prompts).
- `.work/local-files` makes `start-ticket` copy the uncommitted `.kilo/kilo.jsonc` into every ticket worktree — a new worktree contains only committed files.
- Nothing here is committed. Keep `.kilo/` out of git through your global gitignore or `.git/info/exclude`; `start-ticket` excludes `.work/` automatically.

Optional, committed to the project:

- **`AGENTS.md`** — project rules that override the generic ones, e.g. "Use pnpm. Biome, not ESLint. Tests: Vitest. Validate with `pnpm check`."
- **`.agent2793/validation`** — the exact checks `finish-ticket` should run, one `name: command` per line, only if automatic detection gets them wrong (see [`workspace/structure.md`](workspace/structure.md#project-validation-override)).

### For each ticket

**1. Create the workspace**

```bash
cd /d/Projects/my-app
start-ticket HYP-123 --title "Add CSV export"     # --type bug|refactor|investigation|chore
```

This creates branch `feature/HYP-123`, worktree `D:/Projects/worktrees/HYP-123`, and ticket context `.work/HYP-123/ticket.md`, copies the files listed in `.work/local-files`, and lists other active tickets.

**2. Open the worktree in its own window**

```bash
code D:/Projects/worktrees/HYP-123
```

One window per worktree = one Kilo session per ticket. Never point two sessions at the same worktree.

**3. Give Kilo the ticket**

```text
Implement Jira ticket HYP-123. Follow the agent2793 workflow.

<paste the ticket description>
```

**4. Let the agent work**

```text
analyze   verify branch/worktree → understand ticket → investigate codebase
          → dependency analysis (ISOLATED / RELATED / BLOCKED / CONFLICTING)
plan      plan.md: files, approach, tests, validation commands, risks
          → pauses for your approval if a checkpoint applies (API change, migration, security, scope)
implement smallest correct change + tests; root-cause debugging; max 3 fix attempts per failure
validate  the project's own typecheck / lint / tests / build
review    self-review of the real git diff → fix findings → validate again
report    implementation-report.md; status READY_FOR_PR or BLOCKED
```

Everything is recorded in `.work/HYP-123/`: `ticket.md` (status), `analysis.md`, `dependency-analysis.md`, `plan.md`, `validation.md`, `review.md`, `implementation-report.md`. A new session can resume from these files.

**5. Check readiness**

```bash
finish-ticket HYP-123
```

Verifies git state, runs the validation it can detect, scans the diff for debug code, TODOs, and conflict markers, writes `validation.md`, and prints `READY_FOR_PR` or `NOT READY` with reasons. It never commits, pushes, or merges.

**6. Review** `.work/HYP-123/implementation-report.md` — it separates **Implemented**, **Verified**, **Not verified**, **Known issues**, and **Suggested follow-ups** — and the diff.

**7. Commit, push, and open the PR yourself.** The agent does this only when explicitly asked.

**8. Clean up after merge**

```bash
git worktree remove ../worktrees/HYP-123
git branch -d feature/HYP-123
```

Set `status: DONE` in `.work/HYP-123/ticket.md`; keep or archive the context directory.

### Things to remember

- Each worktree needs its own dependency install (`pnpm install` or equivalent); the agent does this during analysis.
- Editing `.kilo/kilo.jsonc` later does not update existing worktrees; new tickets get the new version. To refresh one, delete its copy and re-run `start-ticket` for that ticket.
- On the first ticket, ask Kilo "Which instruction files are loaded?" to confirm it picked up `AGENTS.md`.

### Without the scripts

```bash
git worktree add ../worktrees/HYP-123 -b feature/HYP-123 main
mkdir -p .work/HYP-123 && cp /d/Projects/agent2793/templates/ticket.md .work/HYP-123/   # fill in placeholders
mkdir -p ../worktrees/HYP-123/.kilo && cp .kilo/kilo.jsonc ../worktrees/HYP-123/.kilo/
```

## Parallel tickets

Repeat steps 1–3 for each ticket:

```text
Terminal 1                         Terminal 2                         Terminal 3
start-ticket HYP-101               start-ticket HYP-102 --type bug    start-ticket HYP-103
→ ../worktrees/HYP-101             → ../worktrees/HYP-102             → ../worktrees/HYP-103
→ Kilo session: "Implement         → Kilo session: "Implement         → Kilo session: "Implement
  HYP-101 ..."                       HYP-102 ..."                       HYP-103 ..."
```

```text
my-app/                     main worktree (you)
  .work/HYP-101/ HYP-102/ HYP-103/
worktrees/
  HYP-101/   feature/HYP-101   ← session 1
  HYP-102/   bugfix/HYP-102    ← session 2
  HYP-103/   feature/HYP-103   ← session 3
```

### Why each ticket needs an isolated worktree

If agents share one working directory, switching branches changes files under the other agent mid-edit, both agents' changes end up in one diff, tests run against someone else's half-finished code, and discarding "my" change can destroy the other agent's work. Worktrees give each ticket its own directory and branch while sharing one git object store, so every agent can still *read* the others' branches for dependency analysis. Details: [`workspace/README.md`](workspace/README.md).

### Dependencies between tickets

Each agent compares its planned files and APIs with the other tickets' `plan.md` and branch diffs:

```text
HYP-101 → changes FormGenerator API
HYP-102 → updates FormGenerator consumers      ⇒ HYP-102 BLOCKED by HYP-101
HYP-103 → Storybook docs for unrelated widget  ⇒ ISOLATED
```

For HYP-102 the agent stops and asks: wait for HYP-101, or build on its branch:

```bash
start-ticket HYP-102 --base feature/HYP-101
```

It does not redesign the API itself, and it never invents dependencies — uncertain ones are marked *potential* and raised with you.

Worktrees isolate files, not the machine: dependency installs are per worktree, and dev-server ports, local databases, and caches can still collide. See [`workspace/README.md`](workspace/README.md#shared-resources-beyond-git).

## Ticket lifecycle

```text
TODO → ANALYZING → PLANNED → READY → IN_PROGRESS → VALIDATING → REVIEWING → READY_FOR_PR → DONE
                                         ↑               │            │
                                         └───────────────┴────────────┘   failures and findings loop back
BLOCKED (any time, with reason)    CANCELLED (human)
```

`DONE` is set by a human after merge. Writing code never makes a ticket done. Full transition table: [`workflows/ticket.md`](workflows/ticket.md).

## Agent roles

| Role | Does | Phase files |
|---|---|---|
| Investigator | Understands ticket, codebase, dependencies | `ticket/analyze.md` |
| Planner | Produces the plan, handles the checkpoint | `ticket/plan.md` |
| Implementer | Changes the code and tests | `ticket/implement.md` |
| Validator | Runs the project's checks | `ticket/validate.md` |
| Reviewer | Reviews the diff, writes the report | `ticket/review.md`, `ticket/finish.md` |

One session normally plays all roles in sequence. Because roles communicate only through files in `.work/<ID>/`, separate agents can take roles later without changing the documents.

## Project-specific rules

```text
Global engineering rules (agent2793)
        ↓
Project rules (your repo's AGENTS.md, rule files)
        ↓
Ticket requirements
        ↓
Human instructions
```

More specific wins. Example project `AGENTS.md`:

```markdown
- Package manager: pnpm. Lint/format: Biome (not ESLint/Prettier). Tests: Vitest.
- Validation: `pnpm check` (typecheck + lint + test), then `pnpm build`.
- Feature branches: `feat/<TICKET-ID>`.
```

The agent uses exactly these. Safety rules — never touch another ticket's work, no destructive commands, no false claims, no secrets, no push/merge unless asked — can only be relaxed by an explicit human instruction in the session.

## Scripts

| Script | Does |
|---|---|
| `create-worktree <ID>` | Creates or reuses branch `<prefix>/<ID>` and worktree `../worktrees/<ID>`; refuses if the branch is checked out elsewhere |
| `start-ticket <ID>` | `create-worktree` + `.work/<ID>/ticket.md` + git exclude + copies files listed in `.work/local-files` + list of other active tickets + what to open |
| `finish-ticket [ID]` | Git checks, detected validation, diff scan, `validation.md`, report draft, readiness verdict (exit 0 ready, 2 not ready) |

All support `--help`. Bash; on Windows run them from Git Bash or WSL. They never commit, push, merge, or touch other tickets' worktrees.

## Design principles

- **Instructions, not infrastructure.** The coding agent already reads, edits, runs, and reasons. This repository only defines how.
- **Tool-neutral.** Plain Markdown; provider specifics live in `providers/`.
- **Explicit and checkable.** "Run `git branch --show-current` before editing", not "be careful".
- **Files as the interface.** Ticket state lives in files humans and agents can both read, so sessions can resume and roles can be split.
- **Maximum safe autonomy.** Proceed when clear and low-risk; stop at real decision points.

## Not included (yet)

Deliberately out of scope for the first version: Jira API integration, automatic PR creation, autonomous merging, distributed agent infrastructure, databases, dashboards, cloud orchestration.

## Roadmap

- Field-test the Kilo Code workflow on real multi-ticket sprints
- Native PowerShell versions of the scripts
- Optional Jira import into `ticket.md` (read-only)
- More stack rule files (Python, Go, backend APIs, database migrations)
- A command to summarize all active tickets and their overlaps

## License

[MIT](LICENSE)
