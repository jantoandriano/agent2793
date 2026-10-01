# TypeScript Rules

Load when the repository uses TypeScript. The project's `tsconfig` and lint configuration take precedence.

## Type safety

- Keep types at least as strict as the surrounding code and `tsconfig` require. Do not loosen compiler options.
- Do not use `any`. Use `unknown` for untrusted values and narrow them (type guards, schema validation).
- Avoid type assertions (`as Foo`) and non-null assertions (`value!`). Prefer narrowing. When an assertion is genuinely needed, add a comment saying why it is safe.
- Do not use `@ts-ignore`. If suppression is unavoidable, use `@ts-expect-error` with a reason, and mention it in the implementation report.
- Fix type errors by fixing the mismatch, not by widening types until they compile.

## Modelling

- Model alternatives with discriminated unions rather than optional fields that are "only set when X".
- Derive types instead of duplicating them: `ReturnType`, `Parameters`, indexed access, `z.infer` — follow what the project uses.
- Use `readonly` and `as const` where the project does.
- Follow the project's choice between `type` and `interface`, and between `enum` and union literals.

## Boundaries

- Validate external data (API responses, request bodies, environment variables, `JSON.parse` output, local storage) at the boundary using the project's validation approach (zod, valibot, io-ts, custom guards). TypeScript types alone do not validate runtime data.
- Exported functions and public types should have explicit types so consumers and reviewers do not depend on inference.

## Modules

- Follow the project's import conventions (path aliases, `import type`, file extensions under `NodeNext`).
- Do not add barrel files or re-exports unless the project uses them.

## Validation

Run the project's typecheck command (e.g. `tsc --noEmit` via a `typecheck` script). Type errors in files you did not touch that appear after your change are yours until proven otherwise.
