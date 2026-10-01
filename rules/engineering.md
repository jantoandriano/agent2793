# Engineering Rules

Core principles that apply to every ticket, in every repository.

## Understand before change

Before modifying code:

- inspect the repository structure, package configuration, and project instructions
- understand the architecture around the change: entry points, layers, module boundaries
- identify the modules relevant to the ticket and read their callers
- find the existing patterns for this kind of change
- read the existing tests for the affected code
- identify dependencies: libraries, internal modules, other active tickets
- identify side effects: who else uses what you will change

Do not rewrite existing architecture because another approach looks cleaner. Prefer consistency with the existing project unless the ticket explicitly requires an architectural change.

## Minimal change

- Modify only what the ticket requires. "Required" includes tests, error handling, types, and docs the project normally updates with code.
- No unrelated refactoring, renaming, reformatting, or file moves.
- Do not change public APIs unless the ticket requires it (and then see human checkpoints).
- Do not add a dependency when the standard library or an existing dependency solves the problem. Justify every new dependency in the plan.
- Preserve existing behavior outside the ticket scope.
- Before finishing, every changed line must serve the ticket. Revert lines that do not.

## Existing patterns first

Before creating any new function, component, hook, class, utility, or abstraction:

1. Search for an existing implementation of the same thing.
2. Search for similar components or modules.
3. Search for similar utilities and helpers.
4. Search for existing tests that show the expected usage.
5. Follow the established convention you found.

Do not duplicate existing functionality. Do not introduce an abstraction for a single use. When existing code is inconsistent, follow the module you are changing.

## Scope discipline

The ticket defines the scope. When implementation reveals a larger problem (architectural flaw, widespread bug, missing abstraction), **do not fix everything**. Record it in the implementation report under *Suggested follow-up*:

- discovered issue
- impact
- proposed solution
- why it is outside the ticket scope

If the ticket cannot be completed correctly without the larger change, stop and ask (human checkpoint: scope expansion).

## Root-cause debugging

When something fails:

```text
Observe → Reproduce → Isolate → Hypothesize → Change → Verify
```

1. **Observe:** read the full error and stack trace; find the first error, not the last.
2. **Reproduce:** run the smallest command that shows the failure.
3. **Isolate:** narrow it to the line, input, or condition.
4. **Hypothesize:** state one specific cause and predict what the fix will change.
5. **Change:** make one targeted change that tests the hypothesis.
6. **Verify:** rerun the reproduction, then the surrounding tests. Remove temporary debug code.

If the result contradicts the prediction, revert the change and form a new hypothesis. Random trial-and-error is not allowed.

Classify every failure before changing anything:

| Class | Action |
|---|---|
| Implementation bug | Fix the implementation |
| Test bug | Fix the test only if you can show the test is wrong; explain in the report |
| Environment (missing service, deps not installed, wrong tool version) | Fix the environment if safe and in scope; otherwise report it. Do not change code to work around it. |
| Pre-existing failure (fails on the base branch too) | Do not fix as part of this ticket unless it blocks it; report it |
| Flaky / unrelated | Rerun once to confirm; report it |
| Interference from another agent (port in use, shared DB, shared cache) | Do not stop their processes; report and ask |

Never make a suite green by modifying unrelated code, skipping or deleting tests, weakening assertions, loosening types, or swallowing errors.

## Retry limit

**Maximum 3 focused fix attempts per distinct failure.** An attempt is one hypothesis-driven change plus a rerun. A new, different failure starts its own count; the same failure reappearing does not reset it.

After 3 attempts: stop, set the ticket status to `BLOCKED`, and report the failure, each hypothesis and its result, what you now know, what blocks progress, and the options you see.

## Human checkpoints

Ask and wait for confirmation when:

| Trigger | Example |
|---|---|
| Ambiguous requirements | "Archive old orders" — soft delete, move, or export-and-delete? |
| Architectural trade-offs | New service vs. module; new table vs. JSON column |
| Public API change | Changing a function signature exported from a package, an endpoint response shape, a component's props contract |
| Database migration | Any schema or data migration |
| Destructive operation | Deleting data or files you did not create; rewriting history |
| Security-sensitive change | Authentication, authorization, crypto, secrets, PII handling |
| Unclear ticket dependencies | Ticket mentions another ticket's work without saying whether it is done |
| Scope expansion | Fix requires changing a shared library or another team's module |
| Conflicting work | Your change and another active ticket's change overlap and must be reconciled |

A good question gives context, the options, their consequences, and your recommendation, and batches related questions into one message. While waiting, continue only with work the answer cannot invalidate.

Do not ask about things you can determine from the code, tests, configuration, documentation, or project conventions. Make low-impact, reversible choices yourself and record them as assumptions.

## Evidence over assertion

- Never state that a check passed unless you ran it after your last change and saw it pass.
- Never state that only intended files changed without running `git status` and `git diff`.
- Write *Not verified: <check> — <reason>* rather than implying success.
