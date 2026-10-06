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
