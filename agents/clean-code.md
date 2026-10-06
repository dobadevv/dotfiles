# Clean Code

Follow Clean Code principles by Robert C. Martin.

## Naming

- Use intention-revealing names.
- Avoid abbreviations and meaningless suffixes.
- Use one consistent term for one concept.
- Classes/types are nouns.
- Functions are verbs.
- Boolean names should read naturally (`isActive`, `hasPermission`, `shouldRetry`).

## Functions

- Keep functions small.
- One level of abstraction per function.
- Prefer 0–2 parameters.
- Group related parameters into objects.
- Avoid boolean flag parameters.
- Avoid hidden side effects.
- Eliminate duplication (DRY).

## Comments

- Prefer self-documenting code.
- Comments explain **why**, not **what**.
- Remove stale or commented-out code.

## Formatting

- Respect the project's formatter and lint rules.
- Keep code consistent with the surrounding codebase.

## Error Handling

- Never silently ignore errors.
- Include meaningful context.
- Keep error handling separate from business logic whenever possible.

## General

- Respect the existing architecture.
- Reuse existing abstractions.
- Avoid unnecessary refactoring.
- Leave the codebase cleaner than you found it.
