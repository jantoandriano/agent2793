# Dependency Analysis: <TICKET-ID>

<!-- See ticket/analyze.md §4. Use evidence only. Mark anything not stated in the ticket, by the human, or evident from code as "potential". -->

## Classification

<!-- ISOLATED | RELATED | BLOCKED | CONFLICTING -->

## Dependencies

### Blocked By

<!-- - HYP-101 (confirmed: ticket says "after HYP-101") — needs the new FormGenerator API -->

### Related Tickets

<!-- - HYP-103 (potential) — also edits FormGenerator stories -->

### Potential Conflicts

<!-- Shared files and APIs with other active tickets, and how each was detected.
- src/components/FormGenerator.tsx — changed on feature/HYP-101 (git diff), in this plan's file list -->

## Evidence

<!-- Commands run and sources read: git worktree list, git diff --name-only <base>...<branch>, other tickets' plan.md, ticket text. -->

## Recommendation

<!-- Proceed | proceed with coordination | wait for <ticket> | base on <branch> | human decision needed — and why. -->

## Questions for the Human

<!-- Uncertain relationships that need confirmation. -->
