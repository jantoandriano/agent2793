# Testing Rules

Testing is part of implementation. Plan tests with the change, write them with the code, and run them before claiming anything works.

## Test strategy

For each acceptance criterion, decide what proves it. Consider:

- happy path
- edge cases: empty, single, boundary, large, unicode, time zones
- invalid input
- error handling: dependency failure, timeout, permission denied
- regressions: existing behavior that must not change
- integration across the boundary the change touches
- UI states and accessibility, where relevant

Record the strategy in the plan (`templates/plan.md`, Test Plan).

## Use the project's conventions

- Use the existing test framework, file layout, naming, fixtures, mocks, and helpers. Do not introduce another framework.
- Put tests where similar tests live and test at the same level (public API vs. internals) as neighboring tests.
- Bug fixes need a regression test that fails without the fix. Run it before fixing to confirm it reproduces the bug.

## Discover validation commands

Do not assume every repository has every check. Find the real commands, in this order of reliability:

1. CI configuration (`.github/workflows/`, `.gitlab-ci.yml`, `azure-pipelines.yml`, ...)
2. Project instructions (`AGENTS.md`, `CLAUDE.md` or other AI instruction files, `CONTRIBUTING`, README)
3. Package scripts (`package.json`, `Makefile`, `justfile`, `pyproject.toml`, `tox.ini`, ...)
4. Tool configuration (`tsconfig.json`, `vitest.config.*`, `jest.config.*`, `playwright.config.*`, `.storybook/`)

Possible checks: typecheck, lint, format check, unit tests, integration tests, build, Storybook build, e2e. Record which exist and which do not. A check that does not exist is *not applicable*, not *passed*.

## Run order

1. Targeted tests for the files you changed (single file or name filter).
2. Tests for the surrounding module or package.
3. Full validation (`ticket/validate.md`): typecheck → lint → format check → tests → build, or the order CI uses.

Rerun any check after a code change; earlier results no longer count.

## Read results correctly

- Confirm tests actually ran: "0 tests" or a filter that matched nothing is not a pass.
- Confirm your new tests appear in the output.
- Separate failures you caused from pre-existing ones by comparing with the base branch (`rules/git.md` describes a safe way).
- Watch mode never finishes; run test commands in CI/run mode (e.g. `CI=true`, `vitest run`).

## Never

- delete, skip, or weaken passing tests to get green
- change expected values to match broken output
- add sleeps or retries to hide race conditions
- claim a check passed that you did not run

## When a check cannot run

Record it as *Not verified* with the reason (dependencies not installed, service unavailable, missing credentials). A required check that could not run prevents `READY_FOR_PR` unless the human accepts it.
