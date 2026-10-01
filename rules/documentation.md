# Documentation Rules

## Update docs with the change

Update documentation in the same ticket when the change affects:

- user-visible behavior (user docs, help text, UI copy)
- public APIs (API reference, JSDoc/docstrings on exported members, OpenAPI specs)
- configuration (new or changed keys, environment variables, defaults)
- setup or developer workflow (README, CONTRIBUTING)
- release notes, if the project keeps a changelog (`CHANGELOG.md`, changesets, ...) — follow its format

Do not rewrite documentation unrelated to the ticket.

## Code-level documentation

- Follow the project's convention for doc comments on exported members.
- Comments explain why, constraints, and non-obvious decisions (`rules/coding.md`).

## Ticket context is documentation

The files in `.work/<TICKET-ID>/` are the record of the work for humans and for other agents. Keep them:

- **current** — update `ticket.md` status and decisions at each transition
- **factual** — distinguish facts (with file paths, commands, output) from assumptions
- **concise** — a reviewer should understand the state of the ticket in two minutes

## Reports

- Implementation reports use `templates/implementation-report.md`.
- Every claim of verification names the command that was run.
- Separate *Implemented*, *Verified*, *Not verified*, *Known issue*, and *Suggested follow-up*. Never merge "not verified" into "done".
