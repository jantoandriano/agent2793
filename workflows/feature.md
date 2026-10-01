# Workflow: Feature

For new functionality or new behavior.

```text
Understand → Clarify → Investigate → Plan → Implement → Test → Review → Validate → Complete
                                              ↑          |        |         |
                                              └── Fix ←──┴────────┴─────────┘
```

## Steps

1. **Understand** — objective, acceptance criteria, constraints, non-goals, assumptions (`requirements.md`). New features often leave behavior for errors, empty states, and permissions unstated; list these explicitly.
2. **Clarify** — ask about material gaps: user-visible behavior, public API shape, data model, permissions (`human-escalation.md`).
3. **Investigate** — find the closest existing feature and use it as the template for structure, naming, errors, and tests (`investigation.md`).
4. **Plan** — `templates/task-plan.md`. Map each acceptance criterion to a test. For public API or data model additions, confirm the plan with the human (`planning.md`).
5. **Implement** — smallest complete change; additive rather than modifying existing behavior; include docs/config/changelog updates the project normally makes (`implementation.md`).
6. **Test** — happy path, edge cases, invalid input, error handling, and permission checks. Run targeted tests (`testing.md`). On failure, Fix (`debugging.md`).
7. **Review** — the actual diff; loop to Implement → Test on findings (`code-review.md`).
8. **Validate** — full applicable validation after the last change (`testing.md`).
9. **Complete** — final report and status (`completion.md`).

## Feature-specific checks

- Is the feature reachable the way users will reach it (route registered, export added, menu entry, CLI flag wired)?
- Is it behind a feature flag if the project uses flags for new features?
- Are new configuration options documented with defaults?
- Do existing behaviors remain unchanged when the feature is not used?
