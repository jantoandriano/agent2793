# Planning

Goal: decide the change concretely enough that implementation is mostly execution.

## Plan contents

A plan normally contains:

1. **Understanding** — the problem in one to three sentences, including acceptance criteria.
2. **Approach** — what you will do and why this approach over the obvious alternative.
3. **Files/modules** — what you expect to change or create.
4. **Tests** — what you will add or modify, and what each proves.
5. **Validation commands** — the exact commands, taken from the repository (see `investigation.md`).
6. **Risks and edge cases** — what could break and how you will check it.

Use `templates/task-plan.md` for non-trivial tasks and `templates/test-plan.md` when the testing strategy is itself non-trivial.

## Proportionality

| Task size | Plan |
|---|---|
| Trivial (typo, one-line fix, config value) | One sentence in your head or message. Still identify how you will verify it. |
| Small (one function or component, clear requirement) | A short list: files, test, command. |
| Medium (several files, new behavior) | Full template, brief sections. |
| Large (cross-module, data model, public API) | Full template, and confirm the approach with the human before implementing. |

A plan longer than the change it describes is too long. A plan that does not name files, tests, or commands for a multi-file change is too short.

## Qualities of a good plan

- **Concrete.** "Add `exportCsv()` to `src/invoices/service.ts`, reuse `toRow()` from `src/invoices/format.ts`" — not "add export logic".
- **Repository-aware.** Names the existing pattern it follows and the conventions it respects.
- **Test-aware.** Every acceptance criterion maps to at least one test or explicit manual check.
- **Explicit about risk.** Names what could break and the check that would catch it.
- **Ordered.** For multi-step changes, sequence the steps so the code compiles and tests can run as early as possible.

## Weighing approaches

When more than one approach is viable, compare briefly on: fit with existing patterns, size of change, risk to existing behavior, and reversibility. Pick the one that fits the repository best, not the one you find most elegant. If the options differ materially in user-visible behavior, public API, or data model, ask (see `human-escalation.md`).

## Updating the plan

Plans are hypotheses. When implementation or testing reveals the plan is wrong, stop, update the plan, and state the change and reason in one line ("Plan change: `toRow()` assumes a single currency; adding a currency column instead of reusing it."). If the change expands scope significantly, escalate before continuing.

## Exit condition

You can name the files, tests, and validation commands, and you know the main risk and how you will check it.
