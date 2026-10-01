# Workflow: Investigation

For tasks whose goal is understanding, not changing code: "Why does X happen?", "How does Y work?", "What would it take to do Z?", "Where is this slow?"

```text
Understand question → Investigate → Gather evidence → Form conclusion → Report
```

## Steps

1. **Understand the question** — what decision will the answer support? That determines how deep to go (`requirements.md`).
2. **Investigate** — explore the repository, trace the relevant paths, read tests and history (`investigation.md`).
3. **Gather evidence** — run read-only commands, existing tests, or reproductions as needed. For a failure, follow Observe → Reproduce → Isolate → Hypothesize from `debugging.md`, confirming hypotheses without code changes.
4. **Form a conclusion** — separate what is confirmed from what is likely and what is unknown.
5. **Report** — in the format below.

## Constraints

- Do not modify code, configuration, or dependencies unless the human asks.
- Temporary instrumentation (for example, a debug log) is allowed only if necessary to gather evidence; remove it before reporting and mention that you used it. Verify with `git status` that the working tree is back to its baseline.

## Output

```markdown
## Question
## Findings
Confirmed facts, each with evidence (file:line, command output).
## Relevant files
## Root cause
If identifiable; otherwise the leading hypotheses and how to confirm them.
## Unknowns
## Recommended next steps
Concrete options, e.g. "Run /engineer with: ..." or "Ask the payments team whether ...".
```
