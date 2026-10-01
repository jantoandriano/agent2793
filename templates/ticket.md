---
# Ticket context. Machine-readable header (YAML) + human-readable body.
# Field reference: workspace/structure.md
ticket:
  id: {{ID}}
  title: "{{TITLE}}"
  type: {{TYPE}}              # feature | bug | refactor | investigation | chore
  status: TODO                # TODO | ANALYZING | PLANNED | READY | IN_PROGRESS | VALIDATING | REVIEWING | READY_FOR_PR | DONE | BLOCKED | CANCELLED
  blocked_reason: ""
  updated: {{DATE}}

workspace:
  branch: {{BRANCH}}
  base: {{BASE}}
  worktree: {{WORKTREE}}
  context: {{CONTEXT}}
  engineering_agent: {{EA_HOME}}

dependencies:
  classification: UNKNOWN     # UNKNOWN | ISOLATED | RELATED | BLOCKED | CONFLICTING
  blocked_by: []
  related_to: []
  shared_files: []

checkpoint:
  mode: auto                  # auto: wait only when a checkpoint trigger applies | always: always wait for plan approval
  plan_approved: false

tracker:
  comment: {{TRACKER_COMMENT}}   # ask: show the finish comment, post after approval | auto: post without asking | off: never post
  comment_posted: ""          # date and link/ID of the posted comment

validation:                   # pending | pass | fail | not-run | not-applicable
  typecheck: pending
  lint: pending
  tests: pending
  build: pending
---

# {{ID}}: {{TITLE}}

## Description

<!-- Paste the ticket description, acceptance criteria, and relevant comments verbatim. -->

## Acceptance Criteria

- [ ] 

## Constraints

## Non-goals

## Open Questions

## Decisions

<!-- Human answers and checkpoint approvals, dated. Example: 2026-10-01 — Plan approved; keep v1 endpoint as deprecated alias. -->

## Status History

- {{DATE}} TODO — context created
