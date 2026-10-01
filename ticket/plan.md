# Ticket Phase: Plan

**Status:** `ANALYZING` → `PLANNED` → `READY`
**Role:** Planner
**Produces:** `plan.md`

Goal: decide the change concretely enough that implementation is mostly execution, and get human approval where it matters.

## 1. Write the plan

Create `plan.md` from `templates/plan.md`. It must name:

- the approach, and why it beats the obvious alternative
- the exact files and modules to change or create
- public contracts affected (none, additive, or breaking)
- tests to add or change, mapped to acceptance criteria
- the validation commands found during analysis
- risks and how each will be checked
- the dependency classification and how the plan respects it (e.g. "does not touch `FormGenerator.tsx`, which HYP-101 is changing")

Be proportional: a few lines for a small fix; full sections for a cross-module change. Name concrete files and functions — "add `exportCsv()` to `src/invoices/service.ts` reusing `toRow()`", not "add export logic".

The plan's file list is also how **other agents** detect overlap with your ticket. Keep it accurate; update it if implementation changes the list.

Set `ticket.status: PLANNED`.

## 2. Human checkpoint

Decide whether to wait for approval:

| Condition | Action |
|---|---|
| `checkpoint.mode: always` in `ticket.md`, or the human asked to review the plan | Present the plan and wait |
| Any trigger from `rules/engineering.md` → Human checkpoints applies (public API change, migration, security, trade-offs, scope, unclear dependencies, ...) | Present the plan, highlight the trigger, and wait |
| Dependency classification is `BLOCKED` or `CONFLICTING` and not yet resolved by the human | Wait |
| None of the above, `checkpoint.mode: auto` | Present the plan briefly, state "No checkpoint triggers", and continue |

When presenting, lead with decisions the human must make, then the plan summary. Record the answer under `ticket.md` → Decisions with the date, and set `checkpoint.plan_approved: true` when approved.

Set `ticket.status: READY`.

## Plan changes later

Plans are hypotheses. If implementation shows the plan is wrong:

- small correction (different helper, extra test) — update `plan.md`, note it in one line, continue
- change that triggers a checkpoint (API change, scope expansion, new shared files with another ticket) — stop and return to this phase

## Exit

`plan.md` is written, the checkpoint is satisfied, status is `READY`. Continue to `ticket/implement.md`.
