# React Rules

Load when the change touches React components or hooks. Project conventions take precedence.

## Follow the project's patterns

Before writing a component, find two similar components in the project and match:

- file and folder structure (co-located styles, tests, stories)
- styling approach (CSS modules, Tailwind, styled-components, design-system components)
- state management (local state, context, Redux, Zustand, ...)
- data fetching (React Query, SWR, RTK Query, framework loaders)
- form handling and validation libraries

Use existing design-system or shared components instead of building new primitives.

## Components

- Keep components focused. Extract a child component when it simplifies the parent, not preemptively.
- Type props explicitly. Do not change a shared component's props contract without checking its consumers (public contract — `rules/architecture.md`).
- Use stable, unique `key`s from data; not array indexes for lists that reorder or change.

## Hooks and effects

- Follow the Rules of Hooks; do not disable `react-hooks` lint rules.
- Do not use `useEffect` for derived state or for logic that belongs in an event handler.
- Effects that subscribe, fetch, or start timers must clean up.
- Do not add `useMemo`/`useCallback`/`React.memo` without a reason (measured cost or a referential-stability requirement) unless the project does so by convention.

## State

- Keep state as local as possible; lift it only as far as needed.
- Do not duplicate server state in client state when the project uses a server-state library.

## Accessibility

- Use semantic elements (`button`, `a`, `label`, headings) instead of clickable `div`s.
- Every form control has an accessible label; images have meaningful `alt` text or `alt=""` when decorative.
- Interactive elements are keyboard-operable and have visible focus.
- Handle loading, empty, and error states visibly.

## Testing

- Test behavior through what users see and do (e.g. Testing Library queries by role and label), not implementation details.
- Cover the states the ticket introduces: loading, empty, error, permission-denied where relevant.
- If the project uses Storybook, add or update stories for new or changed visual states, and run the Storybook build if it is part of validation.
