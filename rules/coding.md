# Coding Rules

Project conventions override everything here. These rules apply where the project is silent.

## Consistency

- Match the surrounding code: naming, file layout, import style, error handling, comment density.
- Use the project's formatter and linter configuration. Format only the files you changed, unless the project formats everything as a rule.
- Do not reorder imports, rename variables, or restyle code you did not otherwise need to change.

## Naming

- Use names from the ticket's domain and the existing codebase. If the code calls it `Account`, do not call it `Customer` in new code.
- Name functions after what they do (`calculateInvoiceTotal`), booleans as predicates (`isArchived`, `hasAccess`).
- Avoid abbreviations the codebase does not already use.

## Functions and modules

- Keep functions focused on one job. Extract a helper when it removes duplication you are adding or makes a branch readable — not preemptively.
- Prefer early returns over deep nesting.
- Keep side effects at the edges; keep core logic pure where the project already does.

## Error handling

- Use the project's error mechanism (exceptions, result types, error codes, HTTP status mapping).
- Handle failures at system boundaries: I/O, network, parsing, user input.
- Never swallow errors silently. A catch block must handle, translate, or rethrow — and log according to project conventions.
- Error messages state what failed and include identifiers that help debugging, without secrets or personal data.

## Comments

- Comment *why*, not *what*. Explain non-obvious constraints, workarounds, and decisions.
- Do not leave commented-out code.
- Do not add `TODO`/`FIXME` without a ticket reference (`TODO(HYP-456): ...`). Unreferenced TODOs belong in the implementation report as follow-ups.

## Before finishing

Search your diff for and remove:

- debug output (`console.log`, `print`, `dbg!`, `debugger`, temporary logging)
- focused or skipped tests (`.only`, `fit`, `fdescribe`, `.skip`, `xit`) you added
- hard-coded test data, local paths, or credentials
- accidental files (scratch scripts, editor files, generated output not tracked by the project)

## Performance

- Do not optimize without a reason: a stated requirement, a known hot path, data sizes that break the naive approach, or a measurement.
- Do avoid known bad patterns in new code: N+1 queries, unbounded memory on large inputs, quadratic loops over user-sized data, blocking I/O on hot paths.
