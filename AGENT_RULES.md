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

### Constructor Functions

Constructor functions accept a single struct parameter for their dependencies, never a positional parameter list.

```go
type UserDeps struct {
	FieldA string
	FieldB string
	FieldC string
}

type User struct {
	fieldA string
	fieldB string
	fieldC string
}

func NewUser(d UserDeps) *User {
	return &User{
		fieldA: d.FieldA,
		fieldB: d.FieldB,
		fieldC: d.FieldC,
	}
}
```

- Applies to all constructor functions (`New*`), regardless of parameter count.
- Keeps call sites readable and stable as dependencies are added, removed, or reordered.
- The deps struct name follows the pattern `<Type>Deps`.

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

# Go Testing

## Table-Driven Tests

Table-driven tests are the default structure for testing any function with more than one meaningful input/output combination.

```go
func TestCalculateDiscount(t *testing.T) {
	tests := []struct {
		name    string
		price   float64
		tier    CustomerTier
		want    float64
		wantErr error
	}{
		{
			name:  "regular customer gets no discount",
			price: 100,
			tier:  TierRegular,
			want:  100,
		},
		{
			name:  "premium customer gets 20 percent off",
			price: 100,
			tier:  TierPremium,
			want:  80,
		},
		{
			name:    "negative price is rejected",
			price:   -10,
			tier:    TierRegular,
			wantErr: ErrInvalidPrice,
		},
	}

	for _, tt := range tests {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			got, err := CalculateDiscount(tt.price, tt.tier)

			if tt.wantErr != nil {
				require.ErrorIs(t, err, tt.wantErr)
				return
			}
			require.NoError(t, err)
			assert.Equal(t, tt.want, got)
		})
	}
}
```

- The `tests` slice is a slice of anonymous structs with a mandatory `name` field, used as the subtest name in `t.Run`.
- Each case captures a single scenario: one set of inputs and one expected outcome (value or error), never both a success and a failure path in the same case.
- Re-bind the loop variable (`tt := tt`) before use in the closure, unless the Go version in use already scopes loop variables per iteration (Go 1.22+).
- Expected error values are compared with `errors.Is`/`require.ErrorIs`, never by string, consistent with the Error Assertions rule below.
- Do not fall back to a sequence of standalone `Test_X1`, `Test_X2` functions for scenarios that vary only by input — that is what the table is for. Standalone test functions are reserved for genuinely distinct setups (e.g. different mocked dependencies, different constructors) that a table can't express cleanly.
- Keep one table per function under test. Do not merge unrelated functions into a single shared table for convenience.

## Test Naming

- Test names follow the pattern `Test_<Function>_<Scenario>_<Expected>` (e.g. `TestCreateWallet_InsufficientBalance_ReturnsError`).
- Subtests created with `t.Run` use descriptive names, never bare indices.

## Test Isolation

- Use `t.Cleanup()` instead of scattered `defer` calls for teardown, so resources are released even if the test fails partway through.
- Never share mutable state between tests via package-level variables. Each test sets up its own fixtures.
- Tests must be safe to run in any order and multiple times.

## Parallelism

- Mark independent unit tests with `t.Parallel()`, especially at the domain/usecase layer.
- Tests sharing a limited resource (DB connection pool, a testcontainer) are grouped or bounded to avoid contention; do not blindly parallelize integration tests.

## Test Helpers

- Any shared setup or assertion function calls `t.Helper()` as its first line, so failures report the caller's line, not the helper's.

## Layered Testing (Clean Architecture)

- Domain/usecase layer: pure unit tests. Mock dependencies via interfaces defined at the consumer side — never mock concrete structs.
- Repository layer (pgx/sqlc): use `testcontainers-go` with a real PostgreSQL instance rather than mocking SQL strings; sqlc-generated queries are concrete enough that string-mocking produces false positives.
- Separate unit tests from integration tests using build tags or `-short`: `go test -short ./...` runs unit tests only; integration tests require an explicit tag or environment flag.

## Error Assertions

- Never compare errors by string (`err.Error() == "..."`).
- Use `errors.Is` / `errors.As` against sentinel errors or custom error types defined in the domain layer.

## Assertion Style

- Use `require` when a failed assertion should stop the test immediately (e.g. setup failures).
- Use `assert` when multiple independent checks should all run and report in a single pass.
- Do not mix `testify` and stdlib assertions arbitrarily within the same package.

## Mocks and Fakes

- Define interfaces at the consumer side.
- Generate mocks with `mockery` or `moq`; never hand-write mock structs that must be kept in sync with an interface manually.

## Concurrency and Timing

- Never use `time.Sleep` to wait for asynchronous behavior (e.g. Redis pub/sub, notification queues).
- Use polling with an explicit timeout, channels, or `sync.WaitGroup` instead.
- Run `go test -race` by default for any package involving goroutines or channels.

## Golden Files

- For large or complex outputs (JSON API responses, generated documents), use golden files with an `-update` flag to regenerate them, rather than asserting field-by-field.

## Coverage

- Coverage percentage is a signal, not a target. Every test must contain at least one assertion that verifies actual behavior — never write a test solely to increase coverage numbers.

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
