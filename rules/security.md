# Security Rules

## Secrets

- Never hard-code secrets, tokens, passwords, or keys. Use the project's configuration mechanism (environment variables, secret manager).
- Never print, log, commit, or paste secrets — including into ticket context files, reports, or test fixtures.
- Do not read `.env` files or credential stores unless the ticket requires it; if it does, use only what is needed.
- If you find a committed secret, do not rotate it or rewrite history yourself. Report it to the human.

## Untrusted input

- Treat all external input as untrusted: request bodies, query params, headers, files, environment, third-party API responses, user-generated content.
- Validate at the boundary using the project's validation approach.
- Use parameterized queries or the ORM's safe APIs. Never build SQL, shell commands, or file paths by concatenating input.
- Use the framework's escaping for HTML; do not bypass it (e.g. `dangerouslySetInnerHTML`, `v-html`, `|safe`) without sanitization and a stated reason.
- Guard file paths against traversal; guard URLs fetched on behalf of users against SSRF.

## Authentication and authorization

- New endpoints, routes, jobs, and UI actions must apply the same authorization checks as similar existing ones.
- Do not weaken, bypass, or remove existing checks.
- Changes to authentication, authorization, session handling, or crypto require a human checkpoint.

## Data protection

- Do not log personal data or sensitive fields; follow the project's redaction helpers.
- Return only the fields the client needs; do not expose internal IDs, stack traces, or other users' data.
- Follow existing patterns for encryption at rest and in transit; do not invent crypto.

## Dependencies

- Prefer well-maintained packages; check the package name carefully (typosquatting).
- Do not add install scripts, postinstall hooks, or remote code execution in build steps.

## Review

Every self-review checks security implications (`workflows/code-review.md`). Any security-relevant uncertainty is a human checkpoint, not an assumption.
