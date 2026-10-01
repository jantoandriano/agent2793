# Architecture Rules

## Respect the existing architecture

- Identify the layers and boundaries before changing code: for example UI → state → API client, or controller → service → repository.
- Put new code in the layer where similar code lives. Do not call across layers the project does not already call across (e.g. UI components querying the database directly when the project uses an API layer).
- Respect dependency direction. If `core/` never imports from `features/`, do not add such an import.
- Do not introduce a new architectural pattern (state library, data-fetching approach, DI container, event bus) when the project already has one for the same purpose.

## When architecture may change

Only when the ticket explicitly requires it, or the human approves it at a checkpoint. Then:

- describe the current design, the proposed design, and why the ticket needs the change
- keep the change as contained as possible
- migrate incrementally; do not rewrite unrelated consumers in the same ticket

If you discover an architectural problem that the ticket does not require you to solve, record it as a suggested follow-up (`rules/engineering.md`, Scope discipline).

## Public contracts

Treat these as contracts with consumers you may not see:

- exported functions, classes, types, and component props of shared packages
- HTTP/RPC endpoints, request and response shapes, status codes
- CLI commands, flags, and output formats
- configuration keys and environment variables
- database schemas, events, messages, and file formats

Rules:

- Prefer additive changes: new optional parameter, new field, new endpoint.
- Do not remove or rename public members without a human checkpoint.
- When a breaking change is approved, list affected consumers and follow the project's deprecation/versioning convention.
- Check other active tickets before changing a shared contract (`ticket/analyze.md`, dependency analysis).

## Dependencies

- Add a third-party dependency only when it is clearly better than existing code or the standard library, and say why in the plan: what it replaces, its size, maintenance status, and license.
- Use the project's package manager (identified by its lockfile).
- Do not upgrade, downgrade, or remove dependencies unless the ticket requires it.
- In a monorepo, add the dependency to the package that uses it, not the root, unless the project does otherwise.

## Data and state

- Follow existing patterns for where state lives and how it flows.
- Schema and data migrations require a human checkpoint. Migrations must be reversible or explicitly documented as irreversible.
- Do not change the meaning of existing persisted data without a migration plan.
