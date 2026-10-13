# Python Projects

## Naming

Follow PEP 8 naming conventions. In Python projects, the camelCase rule for application code does not apply:

- Variables, functions, methods, parameters, and module names use **snake_case**.
- Classes, dataclasses, exceptions, and type aliases use **PascalCase**.
- Constants use **UPPER_SNAKE_CASE**.
- Dictionary keys, DTO fields, and API payloads stay **snake_case**, consistent with the snake_case database identifiers.

## Function Parameters

Functions (including factories such as `create_app` or `build_*`) declare their dependencies as explicit parameters. Never wrap them in a single `*Deps` dataclass or similar dependency container.

Do not:

```python
@dataclass(frozen=True)
class AppDeps:
    reader: ArticleReader
    page_size_limits: PageSizeLimits
    cors_allowed_origins: list[str]


def create_app(deps: AppDeps) -> Flask:
    ...
```

Do:

```python
def create_app(
    reader: ArticleReader,
    page_size_limits: PageSizeLimits,
    cors_allowed_origins: list[str],
) -> Flask:
    ...
```

- Applies to every `def`, regardless of parameter count. This overrides the Go-style `<Type>Deps` constructor pattern and the general "group related parameters into objects" guideline for dependencies.
- Pass arguments by keyword at call sites when there is more than one, so calls stay readable and robust to reordering.
- Type-annotate every parameter and the return value.
