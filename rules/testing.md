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
2. Validation (`ticket/validate.md`): typecheck → lint → format check → **affected tests** → build, or the order CI uses.

Rerun any check after a code change; earlier results no longer count.

## Affected tests locally, full suite in CI

Standard practice, in three parts:

1. **Locally — fast feedback:** run only the tests affected by the ticket's changes, plus whole-project typecheck, lint, and build.
2. **CI — the gate:** the full suite runs on every PR and must pass before merge.
3. **The author owns CI:** a failing check on the ticket's PR is feedback on the ticket, handled like a review comment (`ticket/pr-feedback.md`).

Affected-only testing is safe only because of part 2. **If the repository has no CI configuration**, nothing runs the full suite later — run it locally.

- **Affected** = tests that import the changed files, directly or indirectly, plus test files you changed. Use the runner's own support:

  | Runner | Command |
  |---|---|
  | Vitest | `vitest related --run <changed source files>` |
  | Jest | `jest --findRelatedTests <changed source files>` |
  | pytest | test files for the changed modules (`tests/test_<module>.py`), or `pytest --testmon` if the project uses it |
  | Go | `go test` for the changed packages and the packages that import them |
  | Others | the narrowest test target the project defines for the changed area |

- **Run the full suite instead** when:
  - the change can affect any test: dependencies or lockfile, test runner configuration, test setup files, shared mocks or fixtures, `tsconfig`/build configuration;
  - the runner cannot select affected tests faithfully — e.g. the project's test script sets env vars, wraps the runner, or passes config/project flags, which calling the runner directly would drop;
  - the repository has no CI;
  - the human or project rules ask for it (`tests-scope: full` in `.agent2793/validation`).
- Affected selection follows imports. It misses tests that reach code through dynamic loading, registries, config, or the network — that is what the CI run is for.
- Typecheck, lint, and build always cover the whole project; type errors and lint violations surface outside the changed files.
- Report the scope honestly: "Tests: PASS (affected tests of 3 changed files)" and list the full suite under *Not verified* ("full test suite — runs in CI").

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
