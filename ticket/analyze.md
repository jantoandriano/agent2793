# Ticket Phase: Analyze

**Status:** `TODO` → `ANALYZING`
**Role:** Investigator
**Produces:** `ticket.md` (filled in), `analysis.md`, `dependency-analysis.md`

Goal: understand the ticket, the codebase, and the ticket's relationship to other work before any plan is made.

## 1. Verify the workspace

Run the checks in `rules/git.md` ("Verify before modifying code"). Locate your context directory, `<main worktree>/.work/<TICKET-ID>/`. If `ticket.md` does not exist, create it from `templates/ticket.md`.

If the project's dependencies are not installed in this worktree (each worktree has its own `node_modules`, virtualenv, build output), install them with the project's normal command (e.g. `pnpm install --frozen-lockfile`, `npm ci`) before investigating behavior.

Set `ticket.status: ANALYZING`.

## 2. Understand the ticket

Read the full ticket text the human gave you (description, acceptance criteria, comments, linked items). Paste it into `ticket.md` → Description. Then fill in:

- **Acceptance criteria** — observable checks. If the ticket has none, derive them from the description and list them as assumptions.
- **Constraints** — what must stay true.
- **Non-goals** — what the ticket does not ask for.
- **Open questions** — material ambiguities (see `rules/engineering.md`, Human checkpoints).

Separate requirements from implementation suggestions. "Add a retry so the job stops failing" requires the job to stop failing; the retry is a suggestion. Treat a suggestion as binding only if it is phrased as a constraint.

## 3. Investigate the codebase

Answer "How does this repository already solve problems like this?" before "How should I implement this?"

- Project instructions: `AGENTS.md`, `CONTRIBUTING`, `README`, project rule files.
- Stack: package manifests, lockfiles, framework, build tools.
- Validation commands: CI config and package scripts (`rules/testing.md`).
- Relevant code: search for the domain terms of the ticket; trace from entry points (routes, components, commands) to the code doing the work; read callers of what you will change.
- Similar implementations: the closest existing example to use as a template.
- Tests: where tests for this code live and how they are written. Run them once to record a baseline when feasible.
- Side effects: consumers of the code, public contracts (`rules/architecture.md`).

Write `analysis.md`:

```markdown
# Analysis: <TICKET-ID>

## Summary
What the ticket requires, in 2–4 sentences.

## Relevant Code
- `path/to/file.ts` — role in this ticket

## Existing Patterns
The implementation to follow and why.

## Tests
Existing tests and baseline result. Validation commands found.

## Side Effects and Risks

## Open Questions
```

Proportionality: for a one-line fix, `analysis.md` may be five lines. For a cross-module change, be thorough.

## 4. Analyze dependencies

Determine how this ticket relates to other work. Use only evidence, not guesses.

### Gather evidence

```bash
git worktree list                                  # other active ticket worktrees
ls <main worktree>/.work/                          # other ticket contexts
git diff --name-only <base>...<other-branch>       # files another ticket has changed (committed)
```

Also read, for each other active ticket: `ticket.md` (title, status, dependencies), `plan.md` (planned files and API changes). Note uncommitted work in other worktrees is invisible to `git diff` on their branch; their `plan.md` is the best signal.

From your ticket: explicit references to other ticket IDs ("depends on", "after", "follow-up to"), links the human provided, and APIs or components the ticket needs that do not exist yet.

### Determine shared surface

List the files, modules, and contracts your ticket will likely touch (from the investigation). Intersect them with the files and contracts other tickets have changed or plan to change. These are the **shared files** and **shared APIs**.

### Classify

| Classification | Meaning | Example | Action |
|---|---|---|---|
| `ISOLATED` | No shared files, APIs, data, or ordering with other known work | Storybook docs vs. authentication tests | Proceed |
| `RELATED` | Same area or feature, but independent; overlap is incidental and compatible | Two tickets add different props to `FormGenerator` docs | Proceed; keep changes to shared files minimal; note coordination |
| `BLOCKED` | Needs another ticket's output (API, component, schema) that is not merged | HYP-102 consumes the `FormGenerator` API that HYP-101 is changing | Set status `BLOCKED`; ask the human: wait, or base this branch on the other ticket's branch |
| `CONFLICTING` | Another active ticket changes the same code or contract incompatibly, or both would design the same thing | Two tickets each redesign `FormGenerator`'s validation API | Human checkpoint: decide ordering or ownership before planning |

If several apply, record all and use the most restrictive (`BLOCKED`/`CONFLICTING` > `RELATED` > `ISOLATED`).

Mark a dependency **confirmed** only when it is stated in the ticket, stated by the human, or evident from code (you need an API that another ticket's plan creates). Otherwise mark it **potential** and ask. Never invent Jira links.

Do not independently redesign an API another active ticket is changing.

Write `dependency-analysis.md` from `templates/dependency-analysis.md`, and update `ticket.md` → `dependencies`.

## Exit

- Ticket understood; open questions listed.
- `analysis.md` and `dependency-analysis.md` written.
- If there are open questions that change the implementation, or the classification is `BLOCKED` or `CONFLICTING`: ask the human and wait.
- Otherwise continue to `ticket/plan.md`.
