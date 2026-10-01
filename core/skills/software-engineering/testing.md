# Testing and Validation

Goal: evidence that the change works and nothing else broke.

Testing is part of implementation, not a final step. The **Test** phase runs targeted tests while you implement. The **Validate** phase runs the repository's full validation after review.

## 1. Plan tests before implementing

For each acceptance criterion, decide what proves it. Consider:

| Category | Question |
|---|---|
| Happy path | Does the main scenario work? |
| Edge cases | Empty, single, maximum, boundary values, unicode, time zones, concurrency |
| Invalid input | Wrong types, missing fields, malformed data |
| Error handling | Dependency failures, timeouts, permission denied |
| Regression | Could existing callers or behavior change? Which existing tests cover them? |
| Integration | Does it work across the module/service boundary it touches? |
| Types | For typed public APIs, do the types accept and reject what they should? |
| UI | For UI changes, rendering, interaction, accessibility, and states (loading, empty, error) |

Use `templates/test-plan.md` when the strategy is non-trivial.

## 2. Use the repository's conventions

- Use the existing test framework, file layout, naming, fixtures, and helpers. Do not introduce a different framework without a strong, stated reason and human agreement.
- Put tests where similar tests live. Match their granularity: if the module is tested through its public API, do not add tests against private internals.
- For bug fixes, write a test that fails without the fix and passes with it. Run it before the fix to confirm it reproduces the bug.

## 3. Find the validation commands

Take commands from the repository, in this order of reliability:

1. CI configuration
2. Project instructions (`AGENTS.md`, `CONTRIBUTING`, README)
3. Package scripts (`package.json` scripts, `Makefile` targets, `tox.ini`, ...)
4. Framework defaults, only when nothing above exists

Typical set: targeted tests, full tests, typecheck, lint, build. Record which exist and which do not.

## 4. Run targeted tests first

- Run the tests for the files you changed (single file or name filter). Fast feedback first.
- Then run the tests for the surrounding module or package.
- If the repository is large, run the full suite in the Validate phase rather than after every edit.

## 5. Validate

After review, run every validation command the repository defines for the affected scope, after your last code change:

```text
typecheck → lint → tests (full or affected packages) → build
```

Use the order CI uses if it differs. Every command must be rerun if code changes after it ran.

## 6. Read results correctly

- Read the actual output. An exit code of 0 with "0 tests ran" is not a pass; a filter that matched nothing proves nothing.
- Check that your new tests actually ran (they appear in the output and the count increased).
- Distinguish failures you caused from pre-existing ones by comparing against the baseline you took during investigation, or by rerunning the failing test on the original code (see `git.md` for safe ways to do this).
- Warnings introduced by your change count as problems if the project treats warnings as errors or lints for them.

On failure, go to `debugging.md`. Do not edit tests to match broken behavior.

## 7. When you cannot run something

If a command cannot run (missing service, credentials, platform, time limit), do not claim it passed. Record it:

```text
Not verified:
- Integration tests (pnpm test:integration) — require a running Postgres; none available in this environment.
```

A required check that could not run prevents a `READY FOR PR` status (see `completion.md`).

## Exit condition

**Test:** targeted tests for the change exist, ran, and pass.
**Validate:** every applicable validation command ran after the last change and passed, or is recorded as not applicable or not verified with a reason.
