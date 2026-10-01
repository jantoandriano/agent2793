# Ticket Phase: Validate

**Status:** `IN_PROGRESS` → `VALIDATING`
**Role:** Validator
**Produces:** `validation.md`, updated `validation` block in `ticket.md`

Goal: evidence that the change works and nothing else broke, using the project's own checks.

## 1. Determine the checks

Use the commands identified during analysis (`rules/testing.md`, "Discover validation commands"). Do not assume every repository has every check:

| Check | Typical source |
|---|---|
| typecheck | `typecheck` / `type-check` script, `tsc --noEmit`, `mypy` |
| lint | `lint` script, `make lint`, `ruff`, `golangci-lint` |
| format | `format:check` script, `prettier --check`, `biome format`, `gofmt -l` |
| unit tests | `test` script, `pytest`, `go test ./...`, `cargo test` |
| integration tests | `test:integration`, separate CI job |
| build | `build` script, `make build`, `cargo build` |
| storybook | `build-storybook` / `storybook:build` |
| e2e | `test:e2e`, `playwright test`, `cypress run` |

Mark each as available / not applicable. Prefer exactly what CI runs.

## 2. Run

Set `ticket.status: VALIDATING`. Run every applicable check in the worktree, in CI order (default: typecheck → lint → format → tests → build). Run tests in non-watch mode.

`scripts/finish-ticket` runs the common checks it can detect and writes `validation.md`; you may use it, but you are still responsible for checks it does not cover (integration, e2e, storybook, project-specific).

Checks that need unavailable infrastructure (database, browser, credentials) are *not verified*, with the reason — never *passed*.

## 3. Interpret

For each failure:

1. Is it caused by this ticket? Compare with the base branch if unsure (`rules/git.md`, "Comparing with the base branch").
2. Classify it (`rules/engineering.md`, Root-cause debugging).
3. Caused by this ticket → back to `ticket/implement.md`, fix, then rerun **all** checks.
4. Pre-existing, flaky, or environmental → record it; do not fix unrelated code.

Apply the retry limit: 3 focused attempts per distinct failure, then `BLOCKED`.

## 4. Record

Write `validation.md`:

```markdown
# Validation: <TICKET-ID>

| Check | Command | Result | Notes |
|---|---|---|---|
| typecheck | `pnpm typecheck` | PASS | |
| lint | `pnpm lint` | PASS | |
| tests | `pnpm test` | PASS | 214 tests, 6 new |
| build | `pnpm build` | PASS | |
| e2e | `pnpm test:e2e` | NOT RUN | needs browser runtime |

## Pre-existing / unrelated failures
```

Results: `PASS`, `FAIL`, `NOT RUN` (with reason), `N/A` (check does not exist). Update `ticket.md` → `validation` (`pass` / `fail` / `not-run` / `not-applicable`).

## Exit

All applicable checks ran after the last code change and passed, or are recorded as not run with a reason. Continue to `ticket/review.md`.
