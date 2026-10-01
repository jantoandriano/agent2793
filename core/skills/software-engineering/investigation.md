# Investigation

Goal: understand how this repository already works before deciding how to change it.

> Search before inventing.

Answer "How does this repository normally solve problems like this?" before answering "How should I implement this?"

## 1. Orient

Start broad, then narrow. For an unfamiliar repository, check:

| Look at | To learn |
|---|---|
| Root listing, top-level directories | Layout: monorepo, app, library, service |
| `README`, `CONTRIBUTING`, `AGENTS.md`, `docs/` | Stated conventions and project-specific rules |
| Package manifests (`package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `pom.xml`, ...) | Language, framework, dependencies, scripts |
| Lockfiles (`pnpm-lock.yaml`, `yarn.lock`, `poetry.lock`, ...) | Which package manager to use |
| Build/CI config (`Makefile`, `.github/workflows/`, `tsconfig`, `turbo.json`, ...) | Real validation commands and their order |
| Lint/format config (`biome.json`, `.eslintrc`, `ruff.toml`, ...) | Style rules that review will enforce |
| Test config and test directories | Test framework, file naming, fixtures, helpers |

CI configuration is the most reliable source of "what must pass". Prefer the commands CI runs over commands you guess.

## 2. Find the relevant code

- Search for the domain terms in the task (entity names, error messages, route paths, UI labels).
- Trace from an entry point (route, CLI command, event handler, UI component) to the code that does the work.
- Read the callers of anything you plan to change. A function with 30 callers needs a different approach than one with one caller.
- Check public exports and API boundaries: what consumers outside this module depend on.

## 3. Find similar implementations

Before writing anything new, find the closest existing example and use it as the template:

- Adding an endpoint → read two existing endpoints in the same module.
- Adding a validation → find how other inputs are validated.
- Adding a config option → find how existing options are declared, defaulted, and documented.
- Adding an error → find the error types and how they are surfaced to callers.

If two existing patterns conflict, prefer the one used in newer code or in the module you are changing, and mention the inconsistency.

## 4. Read the tests

- Locate tests for the code you will change. Note their style: unit vs integration, fixtures, mocking approach, naming.
- Run them once before changing anything when feasible. This establishes a baseline and reveals pre-existing failures that are not yours (see `debugging.md`).

## 5. Note conventions

Record what your change must match:

- error handling (exceptions vs result types, error codes, logging)
- naming and file organization
- dependency injection and module boundaries
- type strictness (any `strict` settings, banned constructs)
- logging, metrics, i18n, feature flags, migrations — whatever the repo consistently does

## 6. Know when to stop

Investigation is proportional. Stop when you can name:

- the files you will change and why
- the existing pattern you will follow
- the tests you will add or update
- the commands that validate the change

Do not read the whole repository for a localized change. Do continue investigating when you find yourself guessing about behavior you could look up.

## Output

For non-trivial tasks, summarize findings in the "Investigation" section of `templates/task-plan.md`: relevant files, pattern to follow, existing tests, validation commands, surprises.
