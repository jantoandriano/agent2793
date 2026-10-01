# Workflow: Refactor

For `ticket.type: refactor` — structural change with **no behavior change**. Follow `workflows/ticket.md`, with these additions.

## Analyze

- Define the boundary precisely: what will be restructured and what will not.
- Find every caller and consumer, including dynamic references search may miss (string-based lookups, reflection, config, templates, other packages in a monorepo).
- Refactors touch many files, so dependency analysis matters more: check every active ticket for overlap. A refactor overlapping another active ticket is usually `CONFLICTING` — ask for ordering.

## Establish a safety net

Before changing anything, run the tests covering the affected code and record the baseline. If coverage of current behavior is weak, add characterization tests that pin the *current* behavior (including current quirks) first.

## Plan

Sequence the refactor into small steps, each leaving the code compiling and tests passing. Public API changes keep the old name/signature as a deprecated alias unless the human approves a breaking change.

## Implement

- After each step, run the safety-net tests. A failure means the step changed behavior — fix or undo that step before continuing.
- Do not mix in bug fixes or behavior changes. Bugs found during the refactor become follow-ups (or a separate ticket), unless the human says otherwise.
- Do not refactor adjacent code outside the boundary.

## Validate and review focus

- Existing tests pass **without modification**, except mechanical updates for renamed/moved internals.
- Full typecheck and build: refactors break distant consumers.
- The diff contains only structural changes; any behavior change is a finding.
- The report states that behavior is preserved and what evidence supports it.
