# Go Projects

In Go projects, the camelCase rule above does not apply to JSON serialization:

- Struct field names stay **PascalCase** (idiomatic Go), per Go naming conventions.
- `json:"..."` tags use **snake_case**, not camelCase, so API request/response payloads are snake_case on the wire.
- This keeps wire format consistent with the snake_case database identifiers instead of introducing a second casing convention.

## Constructor Functions

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
