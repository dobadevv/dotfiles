# TypeScript Projects

## No Enums

Never define a TypeScript `enum`. Instead, declare a `const` object with `as const`, then derive a union type with the same name from its values.

```ts
export const PAYMENT_STATUS = {
  SUCCESS: 'Success',
  FAIL: 'Fail',
  PENDING: 'Pending',
} as const;

export type PAYMENT_STATUS = (typeof PAYMENT_STATUS)[keyof typeof PAYMENT_STATUS];
```

- The object and the type share the same name, so `PAYMENT_STATUS.SUCCESS` works as a value and `PAYMENT_STATUS` works as a type.
- Always use `as const` so the values are narrowed to literal types.

## Explicit Access Modifiers

Always declare an explicit access modifier (`public`, `protected`, or `private`) on every class method, including constructors, getters, setters, and static methods. Never rely on the implicit `public` default.

```ts
export class PaymentService {
  public constructor(private readonly gateway: PaymentGateway) {}

  public async charge(amount: number): Promise<PAYMENT_STATUS> {
    this.assertPositive(amount);
    return this.gateway.charge(amount);
  }

  protected buildReference(): string {
    return crypto.randomUUID();
  }

  private assertPositive(amount: number): void {
    if (amount <= 0) throw new InvalidAmountError(amount);
  }
}
```

- Use the narrowest modifier that works: `private` by default, `protected` only when subclasses need it, `public` only for the class's intended API.
- Prefer TypeScript modifiers over `#private` fields/methods unless the project already uses ECMAScript private names.

## One Style per File

Each file is either object-oriented (classes) or functional (functions), never both. Do not define top-level functions next to a class in the same file.

```ts
// Don't: a class with module-level helper functions
export class SessionTokenService {
  public verify(token: string): SessionPayload | null {
    return parsePayload(token);
  }
}

function parsePayload(token: string): SessionPayload | null { /* ... */ }
```

```ts
// Do: the helper becomes a private method
export class SessionTokenService {
  public verify(token: string): SessionPayload | null {
    return this.parsePayload(token);
  }

  private parsePayload(token: string): SessionPayload | null { /* ... */ }
}
```

- A helper used only by its class becomes a `private` method.
- A function that other code needs, or that is tested on its own, moves to a `helpers` (or `utils`) file next to the code that uses it, and that file contains only functions.
- Constants and types are not a style: they follow the project's rules on where constants and types live.
- Test files are exempt, since specs naturally mix test blocks, fake classes and helper functions.

## At Most Two Parameters

A function or method takes at most 2 parameters. When it needs more, declare a type for the parameters and accept a single object instead.

```ts
// Don't: more than 2 positional parameters
function createUser(name: string, email: string, role: UserRole): User { /* ... */ }
```

```ts
// Do: one typed params object
type CreateUserParams = {
  name: string;
  email: string;
  role: UserRole;
};

function createUser({ name, email, role }: CreateUserParams): User { /* ... */ }
```

- Applies to functions, arrow functions and class methods.
- Exempt: constructors, and callbacks whose signature a library dictates (e.g. `reduce((acc, item, index) => ...)`, Express `(err, req, res, next)`). A callback type defined in this codebase is not exempt.
- Name the type `<FunctionName>Params` (e.g. `CreateUserParams`), using PascalCase.
- Keep the function declaration on a single line whenever possible. That matters most.
- Destructure in the signature only if the whole declaration still fits on one line (the project's Prettier `printWidth`, default 100).
- If it would wrap, never let the formatter break the destructuring across lines. Name the parameter `params` and destructure on the first line of the body instead.

```ts
// Don't: destructuring that wraps the declaration over several lines
private toComputedFields({
  labCenter,
  isMissingCoordinates,
  now,
}: ToComputedFieldsParams): LabComputedFields {
  // ...
}
```

```ts
// Do: one-line declaration, destructure in the body
private toComputedFields(params: ToComputedFieldsParams): LabComputedFields {
  const { labCenter, isMissingCoordinates, now } = params;
  // ...
}
```
