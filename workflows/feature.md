# Workflow: Feature

For `ticket.type: feature` — new functionality or behavior. Follow `workflows/ticket.md`, with these additions.

## Analyze

- Find the closest existing feature and use it as the template for structure, naming, error handling, tests, and docs.
- Features often leave error, empty, loading, and permission behavior unstated. List these as acceptance criteria (derived, marked as assumptions) or as open questions.
- Check other active tickets for work on the same screens, endpoints, or components.

## Plan

- Map every acceptance criterion to a test.
- Prefer additive changes to public contracts (`rules/architecture.md`). New public APIs, data models, or migrations are human checkpoints.
- If the project uses feature flags for new features, plan the flag.

## Implement and validate

- Make the feature reachable the way users reach it: route registered, export added, menu entry, CLI flag wired, config documented.
- Behavior when the feature is not used must remain unchanged.
- Update docs, changelog, and stories as the project does (`rules/documentation.md`, `rules/react.md`).

## Review focus

Acceptance criteria all demonstrably met; reachability; unstated states (empty, error, loading, unauthorized) handled; no unrelated changes.
