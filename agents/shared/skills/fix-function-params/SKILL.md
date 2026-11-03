---
name: fix-function-params
description: Use when asked to audit, find or fix TypeScript/JavaScript functions or methods that take more than 2 parameters, or to bring existing code in line with the "At Most Two Parameters" rule (params object, `<FunctionName>Params` type).
---

# Fix Function Params

Audits a TS/JS codebase for functions with more than 2 parameters and refactors each one to a single typed params object, per the "At Most Two Parameters" rule in the TypeScript rules. This is a refactor: behavior must not change.

## 1. Audit

Run from the project root (needs a git repo; scans tracked files, skips `.d.ts` and constructors, which the rule exempts):

```bash
node <this-skill-dir>/scripts/find-violations.mjs .
```

Output: `<file>:<line>  <name>  <paramCount>  <tags>`. Exit 1 means violations exist. Exit 2 prints a one-time install command for a TypeScript build with a JS compiler API (TS 7+ has none); run it and re-run the audit.

Sort each hit into one bucket:

| Bucket | When | Action |
|---|---|---|
| Fix | Plain function or method in this repo | Refactor (step 2) |
| Skip: library callback | `callback` tag and the callee comes from a dependency (`reduce`, Express `(err, req, res, next)`, React `onChange`), or a named function handed to a dependency by reference (`app.use(errorHandler)`) | Leave as is |
| Fix: own callback | `callback` tag but the callee and its callback type live in this repo | Refactor the callback type, the callee's invocation and every callback together |
| Skip: implements external contract | Method implements or overrides an interface/class from a dependency | Leave as is |
| Skip: generated / vendored | File is generated (codegen, migrations output) or vendored | Leave as is |
| Ask: public API | Exported from a published package (`package.json` without `"private": true`) | Ask the user; it is a breaking change |

Show the user the bucketed list before editing. If they asked only to audit, stop here.

## 2. Fix, one function at a time

1. Find every call site first: LSP/codegraph references, plus `grep -rn "<name>"` for dynamic uses (`.apply`, `.call`, `.bind`, passed as a value, spies/mocks in tests).
2. Declare `type <FunctionName>Params` (PascalCase; prefix with the class name if a method's name collides). Put it next to the function unless the project keeps types in a dedicated file.
3. Map parameters to properties:
   - optional `b?: T` → `b?: T`
   - default `c = 1` → `c?: number` in the type, `{ c = 1 }` in the destructuring
   - rest `...args` stays a separate parameter only if the total is then ≤ 2; otherwise becomes `args: T[]`
4. Destructure in the signature: `function createUser({ name, email, role }: CreateUserParams)`, so the body stays unchanged.
5. Update overload signatures together with the implementation.
6. Rewrite every call site to pass an object: `createUser({ name, email, role })`.

After each file: run the project's typecheck (`tsc --noEmit` or the `typecheck` script). Type errors are the list of call sites you missed. JS files and `any`-typed callers are not caught by the typecheck, so the grep from step 1 is required there.

## 3. Verify and report

- Run the project's lint and full test suite. Existing tests are the safety net; do not edit assertions to make them pass. A failing test means a call site was converted wrong.
- Re-run the audit; only skipped and asked items may remain.
- Report a table: `file:line | name | fixed / skipped (reason) / waiting on user`.

## Common Mistakes

- Converting a library callback: the library still passes positional arguments, so the callback silently receives `undefined`.
- Refactoring a constructor: constructors are exempt (DI frameworks inject them positionally).
- Dropping a default value when moving it into the type.
- Missing call sites in tests, mocks (`toHaveBeenCalledWith(a, b, c)`) and JS files.
- Changing behavior or renaming parameters in the same pass; keep the refactor mechanical.
