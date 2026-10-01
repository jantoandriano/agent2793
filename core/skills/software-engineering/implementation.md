# Implementation

Goal: the smallest change that completely satisfies the requirements and fits the repository.

## Before the first edit

- Run `git status` and record pre-existing changes (see `git.md`).
- Have a plan proportional to the task (see `planning.md`).

## Rules

### Smallest complete change

- Change only what the requirement needs. "Complete" includes tests, error handling, types, and documentation the repository normally updates alongside code (changelog, API docs, config docs).
- Do not refactor surrounding code, rename things, or reorganize files unless the requirement needs it. If you see something worth improving, mention it in the final report.
- Do not add speculative features, options, or extension points "for later".

### Follow existing patterns

- Use the pattern you identified during investigation. Match naming, file placement, error handling, logging, and test style.
- Reuse existing utilities and abstractions. Search before writing a helper; there is often one already.
- When existing code is inconsistent, match the module you are changing.

### Abstraction discipline

- Do not introduce an abstraction (base class, generic helper, factory, config layer) for a single use.
- Introduce one when it removes real duplication you are adding, or when the repository's pattern requires it.
- Prefer a little duplication over a wrong abstraction.

### Dependencies

- Do not add a dependency when the standard library or an existing dependency solves the problem.
- Do not upgrade, downgrade, or remove dependencies unless the task requires it. If it is required, say so in the plan and report.
- Use the repository's package manager (identified by the lockfile).

### Formatting

- Do not reformat code you did not change. Run the repository's formatter only on files you changed, or in the mode the project uses (some projects format everything in CI — follow that).
- Keep diffs reviewable: no whitespace churn, no import reordering in untouched code.

### Backwards compatibility

- Treat public APIs, CLI flags, config keys, database schemas, event formats, and file formats as contracts.
- Prefer additive changes (new optional parameter, new endpoint) over changing existing behavior.
- If a breaking change is required, say so explicitly in the plan and confirm with the human unless the task already states it.

### Type safety

- Keep types as strict as the surrounding code. Do not loosen types (e.g. `any`, unchecked casts, ignored type errors) to make an error go away; fix the underlying mismatch.
- If you must suppress a type error, add a comment explaining why and mention it in the report.

### Error handling

- Use the repository's error conventions (exception types, result objects, error codes, HTTP status mapping).
- Handle the failure cases named in the requirements and the obvious ones at system boundaries (I/O, network, user input, parsing).
- Do not swallow errors silently. Do not add catch-all handlers that hide failures.

### Performance

- Do not optimize without a reason. A meaningful reason is: a stated requirement, a known hot path, data sizes that make the naive approach fail, or a measured problem.
- Do avoid obviously bad patterns in new code (N+1 queries, unbounded memory on large inputs, quadratic loops over user-sized data).

### Security

- Validate untrusted input at boundaries. Use parameterized queries and the project's escaping/encoding helpers.
- Never hard-code secrets. Never log secrets, tokens, or personal data.
- Preserve existing authorization checks; add them when you add new entry points.

## Scope control

Before moving to testing, check: does every changed line serve the requirement? Undo changes that do not.

## Exit condition

The change implements the plan (or the updated plan), compiles, and is ready for targeted tests. Tests are written alongside the code, not deferred (see `testing.md`).
