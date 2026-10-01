# Requirements

Goal: know exactly what "done" means before touching code.

## 1. Read the whole task

Read the full ticket, issue, message, and any linked material before forming an opinion. Requirements are often in comments, screenshots, linked issues, or a sentence at the end.

## 2. Extract the parts

Write down (mentally for trivial tasks, explicitly for non-trivial ones):

| Item | Question | Example |
|---|---|---|
| Objective | What outcome does the requester want? | Users can export invoices as CSV |
| Acceptance criteria | What observable checks prove it works? | Export button on invoice list; file has columns X, Y, Z; empty list exports header only |
| Constraints | What must stay true? | No new dependencies; must work for 50k rows |
| Non-goals | What is explicitly out of scope? | PDF export; scheduling exports |
| Expected behavior | What happens on normal and abnormal input? | Invalid date range → 400 with message |
| Affected areas | Which modules, APIs, users are touched? | `invoices` service, `/api/invoices/export`, admin UI |
| Risks | What could go wrong or break? | Memory use on large exports; permission leaks |
| Assumptions | What are you assuming that nobody stated? | CSV uses UTF-8 with comma separator |

If the task does not state acceptance criteria, derive them from the objective and the existing behavior of similar features, and list them as assumptions.

## 3. Separate requirements from suggestions

Tickets often mix *what* with *how*.

- "Add a retry so the job stops failing" — requirement: the job stops failing. Suggestion: a retry. If investigation shows the root cause is a bad query, a retry would hide it; fix the root cause and explain why.
- "Use Redis to cache this" — check whether the project already has a caching layer. If the suggestion conflicts with the repository's architecture, raise it rather than silently choosing either option.

Treat a suggestion as binding only when it is phrased as a constraint ("must use", "do not change") or when deviating would surprise the requester.

## 4. Identify non-goals

State what you will not do, even if it seems related. This prevents scope creep and makes review easier. Examples: "Will not migrate existing records", "Will not change the public API signature", "Will not fix the unrelated flaky test in `auth.test.ts`" (mention it in the report instead).

## 5. Decide: resolve, assume, or ask

For each unclear point:

1. **Resolve it from the repository.** Check code, tests, docs, config, git history, and similar features. Most questions end here.
2. **Assume it** when the choice is low-impact, reversible, and consistent with existing patterns. Record the assumption in the plan and the final report.
3. **Ask** when the answer materially changes the implementation and cannot be inferred safely.

Ask when:

- expected behavior is undefined and the options produce different user-visible results
- two requirements conflict
- there are multiple materially different implementations (different data models, different public APIs)
- public API behavior, database schema, or data migration behavior is unclear
- the task implies destructive behavior (deleting data, removing endpoints, dropping columns)
- an architectural decision has long-term consequences
- security or permission behavior is unclear
- a business rule cannot be inferred (pricing, eligibility, retention periods)

Do not ask:

- what test framework, package manager, or style to use — look it up
- questions whose answer is in the codebase
- for confirmation of trivial, reversible choices
- one question at a time across several messages — batch them

## 6. How to ask

Make questions cheap to answer:

```text
Before implementing, two decisions affect the design:

1. Deleted users' invoices — should export include them?
   a) Include, marked "deleted user" (matches the invoice list page)
   b) Exclude
   I'd go with (a) to match existing UI behavior.

2. Max export size — the list endpoint caps at 1,000 rows. Should export also cap, or stream everything?
```

Provide context, options, consequences, and your recommendation. While waiting, continue with work that does not depend on the answer (investigation, test scaffolding), unless the answer could invalidate it.

## Exit condition

You can state the objective, acceptance criteria, constraints, non-goals, and assumptions, and no open question would materially change the implementation.
