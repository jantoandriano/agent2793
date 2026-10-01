# Workflow: Release

For preparing a release. The agent **prepares**; the human **publishes**. Never tag, push, publish packages, deploy, or create releases unless explicitly asked for that specific step.

## 1. Understand the release process

Find how this project releases before doing anything:

- release docs (`RELEASING.md`, `CONTRIBUTING`, README)
- CI release jobs (`.github/workflows/release*.yml`, ...)
- versioning tools (changesets, semantic-release, release-please, `npm version`, `cargo release`, bump scripts)
- changelog format and location
- versioning scheme (SemVer, CalVer) and branch model (release branches, tags on main)

If the project automates releases (e.g. semantic-release on merge), the agent's job is usually only to verify readiness. Do not run release automation locally.

## 2. Determine scope

- List changes since the last release: `git log <last-tag>..<release-base> --oneline`.
- Map them to tickets. Check `.work/*/ticket.md` statuses: tickets meant for the release must be `DONE` (merged). Tickets `READY_FOR_PR` or earlier are not in the release.
- Classify changes (breaking, feature, fix) to determine the version bump per the project's scheme. A breaking change in a minor/patch release is a human checkpoint.

## 3. Prepare

In a dedicated worktree and branch (e.g. `release/1.4.0`), following the project's process:

- bump versions with the project's tool
- update the changelog from merged changes; every entry traceable to a commit or ticket
- update migration notes for breaking changes

## 4. Validate

Run the full validation, including checks normally skipped for speed (integration, e2e, build of all packages), as CI does for releases. Record results in the same format as `ticket/validate.md`.

## 5. Report and hand over

Report: version and why, included tickets/changes, breaking changes, validation results (verified / not verified), and the exact commands the human should run to publish (tag, push, publish), as documented by the project.
