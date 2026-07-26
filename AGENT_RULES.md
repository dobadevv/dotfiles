
# Global Agent Instructions

These instructions apply to every coding task unless explicitly overridden.

---

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

---

# Database Conventions

Unless the project explicitly specifies otherwise:

- Use **snake_case** for all database identifiers, including tables, columns, indexes, constraints, and foreign keys.
- Use **camelCase** for all application code, including variables, object properties, DTOs, entities, models, and API responses.
- Bridge naming differences using ORM mapping features (e.g. Prisma `@map` and `@@map`) rather than exposing database naming conventions throughout the application.
- Never leak `snake_case` database field names into business logic or application code.
- Follow existing migration and repository patterns when modifying the database schema.

## Go Projects

In Go projects, the camelCase rule above does not apply to JSON serialization:

- Struct field names stay **PascalCase** (idiomatic Go), per Go naming conventions.
- `json:"..."` tags use **snake_case**, not camelCase, so API request/response payloads are snake_case on the wire.
- This keeps wire format consistent with the snake_case database identifiers instead of introducing a second casing convention.

---

# Test-Driven Development

Test-Driven Development (TDD) is the default implementation workflow.

Whenever implementing new functionality, fixing bugs, or changing behavior:

- Always use the **Superpowers `test-driven-development` skill** when it is available.
- Follow the **Red → Green → Refactor** cycle.
- Write or update tests before production code whenever practical.
- Every bug fix should include a regression test.
- Never weaken or disable tests just to make them pass.

Treat test code with the same quality standards as production code.

---

# Semantic Code Exploration

Always prefer semantic code exploration tools before manually browsing files or using grep.

Priority:

1. CodeGraph
2. Serena
3. Graphify
4. Manual file reading
5. grep / find / glob

Use semantic tools whenever you need to:

- understand the codebase
- locate implementations
- search symbols
- find callers or callees
- inspect dependencies
- estimate change impact
- navigate unfamiliar code

Only fall back to traditional text search when semantic tools cannot provide the required information.

---

# Using Superpowers Skills

When using the Superpowers `brainstorming`, `writing-plans`, or `executing-plans` skills, apply the semantic exploration skills (`using-codegraph`, `using-serena`, `using-graphify`) during their research/exploration steps instead of manual grep/find/Read — same priority order as in Semantic Code Exploration above.

- **brainstorming**: use them to explore the existing codebase and constraints before proposing a design.
- **writing-plans**: use them to identify the exact files, symbols, and call sites the plan will touch.
- **executing-plans**: use them while implementing each task to locate the code being changed.

## executing-plans: no per-task pause, review once at the end

`executing-plans`' own Step 2 already runs every task back to back (mark in_progress → follow steps → verify → mark completed) with no per-task user checkpoint — its only review points are Step 1 (critical review of the plan before starting) and Step 3 (`finishing-a-development-branch`, after all tasks are complete). Do not insert a manual approval pause between tasks that the skill itself doesn't ask for — go straight from one task to the next.

This does not relax the skill's actual stop conditions: still stop and ask when blocked, when the plan has critical gaps, when an instruction is unclear, or when verification fails repeatedly. Never start implementation on main/master without explicit user consent.

---

# Commit Messages

All commit messages must follow the [Angular Commit Message Convention](https://github.com/angular/angular/blob/main/contributing-docs/commit-message-guidelines.md).

## Format

```
<type>(<scope>): <short summary>

<body>

<footer>
```

- **type**: describes the kind of change.
- **scope** (optional): the module, component, or area affected.
- **short summary**: imperative, present tense ("add" not "added"/"adds"), no capitalized first letter, no period at the end.
- **body** (optional): explains motivation and contrast with previous behavior — the **why**, not the **what**.
- **footer** (optional): breaking changes (`BREAKING CHANGE: <description>`) and issue references (`Closes #123`, `Fixes #123`).

## Allowed Types

- `build`: changes affecting the build system or external dependencies.
- `ci`: changes to CI configuration and scripts.
- `docs`: documentation-only changes.
- `feat`: a new feature.
- `fix`: a bug fix.
- `perf`: a code change that improves performance.
- `refactor`: a code change that neither fixes a bug nor adds a feature.
- `revert`: reverts a previous commit.
- `style`: changes that do not affect meaning (whitespace, formatting, missing semicolons, etc.).
- `test`: adding or correcting tests.

## Rules

- Keep the summary line to 100 characters or fewer.
- Use the body to explain **why** the change was made, not what changed line-by-line — the diff already shows that.
- Mark breaking changes explicitly with a `BREAKING CHANGE:` footer.
- Do not deviate from this convention unless the project explicitly specifies a different commit convention.
- Never add a `Co-Authored-By: Claude ...` line or any other mention of Claude/Anthropic/Claude Code to commit messages.

---

@RTK.md
