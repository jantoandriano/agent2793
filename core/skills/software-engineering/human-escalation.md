# Human Escalation

Goal: maximum **safe** autonomy — proceed independently on everything you can determine safely, and stop exactly where a human decision is needed.

Asking is a decision point, not a failure. Guessing on a high-impact decision is a failure.

## Stop and ask when

| Situation | Example |
|---|---|
| Requirements are materially ambiguous | "Archive old orders" — soft delete, move to another table, or export and delete? |
| Requirements conflict | Ticket says "keep API unchanged" and "return the new field in the response" |
| Architecture decision with significant consequences | New service vs. module in existing service; new database table vs. JSON column |
| Destructive operation required | Dropping a column, deleting files or data, rewriting git history, force-push |
| Credentials or secrets involved | Task needs an API key, production access, or secret rotation |
| Security-sensitive behavior unclear | Who may access the new endpoint; whether to log a field that may contain personal data |
| Retry limit reached | Same failure after 3 focused fix attempts (see `debugging.md`) |
| Scope must grow significantly | Fix requires changing a shared library used by other teams |
| Existing changes create uncertainty | Uncommitted changes in files you must edit, and their purpose is unclear |
| External system needs authorization | Deploying, publishing a package, calling a paid API, posting to an issue tracker |
| Task conflicts with repository rules | Task asks for ESLint config; project rules mandate Biome |
| Required validation cannot run | Integration tests need infrastructure that is unavailable |

## Do not ask when

- The answer is in the code, tests, documentation, configuration, or git history.
- The choice is low-impact, reversible, and consistent with existing patterns — make it and record the assumption.
- You want reassurance on a decision the rules already cover.

## How to escalate

Make the message self-contained and cheap to answer:

1. **Situation** — what you were doing and where you stopped.
2. **Question or blocker** — one clear question per decision.
3. **Options** — the realistic choices and their consequences.
4. **Recommendation** — which option you would choose and why.
5. **Evidence** — relevant output, file references, attempts made.
6. **What continues** — what you can do while waiting, if anything.

Batch related questions into one message.

## While waiting

- Continue only with work that the answer cannot invalidate (investigation, test scaffolding for agreed behavior).
- Do not implement one option "provisionally" if the human may choose another and the work would be thrown away or would leave the repository in a misleading state.
- If you stop mid-task, report status `NEEDS HUMAN INPUT` or `BLOCKED` with the final report format from `completion.md`, so the state of the work is clear.

## After the answer

Record the decision in the plan and final report. Treat it as a requirement from then on. If the decision overrides a safety rule (for example, the human explicitly approves `git reset --hard`), it applies only to the operation approved, not to similar future operations.
