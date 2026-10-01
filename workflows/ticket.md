# Workflow: Ticket

The canonical workflow for executing a Jira (or any tracker) ticket. Type-specific workflows (`feature.md`, `bug-fix.md`, `refactor.md`, `investigation.md`) add rules on top of this one; they do not replace it.

```text
Ticket
  ↓
Context                   start-ticket / ticket.md
  ↓
Dependency Analysis       ISOLATED · RELATED · BLOCKED · CONFLICTING
  ↓
Codebase Investigation
  ↓
Implementation Plan
  ↓
Human Checkpoint
  ↓
Implementation  ←────────────┐
  ↓                          │ failure / finding
Validation  ─────────────────┤
  ↓                          │
Self Review  ────────────────┘
  ↓
Implementation Report
  ↓
Ready for PR
```

## Phases

| Phase | Purpose | Phase file | Output | Status |
|---|---|---|---|---|
| Ticket | Receive the work: ID, title, description, acceptance criteria | — | Ticket text from the human | `TODO` |
| Context | Isolated branch + worktree + context directory exist and are verified | `ticket/analyze.md` §1–2 | `ticket.md` | `ANALYZING` |
| Dependency analysis | Know whether this ticket can proceed independently of other work | `ticket/analyze.md` §4 | `dependency-analysis.md` | `ANALYZING` |
| Codebase investigation | Know how the repository already solves this kind of problem | `ticket/analyze.md` §3 | `analysis.md` | `ANALYZING` |
| Implementation plan | Decide files, approach, tests, validation, risks | `ticket/plan.md` §1 | `plan.md` | `PLANNED` |
| Human checkpoint | Get approval where decisions are significant | `ticket/plan.md` §2 | Decisions in `ticket.md` | `READY` |
| Implementation | Smallest correct change, with tests | `ticket/implement.md` | Code + tests | `IN_PROGRESS` |
| Validation | Prove it works with the project's own checks | `ticket/validate.md` | `validation.md` | `VALIDATING` |
| Self review | Find problems in the real diff | `ticket/review.md` | `review.md` | `REVIEWING` |
| Implementation report | Honest record: implemented, verified, not verified, issues, follow-ups | `ticket/finish.md` | `implementation-report.md` | `READY_FOR_PR` |

Dependency analysis needs the file list from investigation, and investigation benefits from knowing related tickets; in practice both happen during the analyze phase and inform each other.

## Lifecycle

```text
TODO → ANALYZING → PLANNED → READY → IN_PROGRESS → VALIDATING → REVIEWING → READY_FOR_PR → DONE

BLOCKED     from any state; record blocked_reason; resume at the state it was blocked in
CANCELLED   set by the human; work stops
```

| Transition | Set by | Condition |
|---|---|---|
| → `TODO` | `scripts/start-ticket` or agent | Context created |
| → `ANALYZING` | Agent | Workspace verified |
| → `PLANNED` | Agent | `plan.md` written |
| → `READY` | Agent, after checkpoint | Approved, or no checkpoint triggers in `auto` mode |
| → `IN_PROGRESS` | Agent | Implementation started, or returning from a failure/finding |
| → `VALIDATING` | Agent | Targeted tests pass; full validation running |
| → `REVIEWING` | Agent | Validation passed |
| → `READY_FOR_PR` | Agent | Definition in `ticket/finish.md` met |
| → `DONE` | Human | PR merged |
| → `BLOCKED` | Agent or human | See `AGENTS.md` §9 |
| → `CANCELLED` | Human | Ticket abandoned |

Backward transitions are normal: `VALIDATING → IN_PROGRESS` on a failure, `REVIEWING → IN_PROGRESS` on a finding, `IN_PROGRESS → PLANNED` when the plan proves wrong in a way that needs a checkpoint. Everything downstream of a code change runs again.

**Never** set `DONE` or `READY_FOR_PR` because code was written.

## Choosing the type-specific workflow

| `ticket.type` | Add |
|---|---|
| `feature` | `workflows/feature.md` |
| `bug` | `workflows/bug-fix.md` |
| `refactor` | `workflows/refactor.md` |
| `investigation` | `workflows/investigation.md` (ends with findings, not code) |
| `chore` | This workflow only |

## Roles

The phases map to conceptual roles. One agent session normally plays all of them in sequence; the boundaries are drawn so separate agents could play them later, communicating only through the context files.

| Role | Phases | Reads | Writes |
|---|---|---|---|
| Investigator | Context, dependency analysis, investigation | Ticket, repository, other tickets' context | `ticket.md`, `analysis.md`, `dependency-analysis.md` |
| Planner | Plan, checkpoint | Analysis files | `plan.md`, decisions in `ticket.md` |
| Implementer | Implementation | `ticket.md`, analysis, plan | Code, tests |
| Validator | Validation | Plan, repository config | `validation.md` |
| Reviewer | Self review, report | Diff, all context files | `review.md`, `implementation-report.md` |

Because each role reads its inputs from files rather than from conversation memory, a phase can be resumed in a new session: read `ticket.md` (status tells you where you are) and the files for the current phase.
