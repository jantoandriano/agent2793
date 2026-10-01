# Workflow: Refactor

For structural changes that must not change behavior: renaming, extracting, moving, simplifying, replacing an internal implementation.

```text
Understand → Clarify → Investigate → Establish safety net → Plan → Implement (small steps, test after each)
  → Review → Validate → Complete
```

## Steps

1. **Understand** — the structural goal and why (`requirements.md`). Define the boundary: exactly what will be refactored and what will not.
2. **Clarify** — if the refactor touches public APIs, shared code, or many callers, confirm the scope with the human.
3. **Investigate** — find every caller and consumer of the code being changed, including dynamic references (reflection, string-based lookup, config, templates) that search may miss (`investigation.md`).
4. **Establish a safety net** — run the existing tests for the affected code and record the result. If coverage of the current behavior is weak, add characterization tests that pin the *current* behavior before changing anything (`testing.md`).
5. **Plan** — sequence the refactor into small steps, each of which leaves the code compiling and tests passing (`planning.md`).
6. **Implement in small steps** — after each step, run the safety-net tests. If a test fails, the step changed behavior: undo or fix the step before continuing (`implementation.md`, `debugging.md`).
7. **Review** — confirm the diff contains only structural changes. Any behavior change is a finding (`code-review.md`).
8. **Validate** — full applicable validation, including typecheck and build, since refactors often break distant consumers (`testing.md`).
9. **Complete** — final report stating explicitly that behavior is preserved and what evidence supports that (`completion.md`).

## Refactor-specific rules

- **Behavior preservation is the requirement.** Existing tests must pass without modification, except tests that reference renamed or moved internals; those changes must be mechanical.
- **Do not mix refactoring with behavior changes or bug fixes.** If you find a bug, report it; fix it separately unless the human asks to combine them.
- **Scope control.** Refactor only what the task names. Do not "clean up" adjacent code.
- **Backwards compatibility.** For public APIs, keep the old name/signature as a deprecated alias or confirm a breaking change with the human.
