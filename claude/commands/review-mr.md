# Review Merge Request

Review a GitLab Merge Request using Clean Code and Functional Programming principles.

## Usage

```
/review-mr <MR_URL_or_ID> [--repo <namespace/project>]
```

**Examples:**
- `/review-mr https://gitlab.com/finviet/ecopos-backend/-/merge_requests/42` — paste full MR URL
- `/review-mr 42` — review MR !42 in the current repo
- `/review-mr 42 --repo finviet/ecopos-backend` — review MR !42 in a specific repo

---

## Steps

### 1. Parse arguments

Inspect `$ARGUMENTS` to determine input format:

**If the argument is a full GitLab MR URL** (e.g. `https://gitlab.com/group/project/-/merge_requests/123`):
- Extract `namespace/project` from the URL path (everything between the host and `/-/merge_requests/`)
- Extract `MR_ID` as the numeric segment after `/merge_requests/`
- Strip any trailing query string or fragment (`?...`, `#...`)
- Set `REPO=<namespace/project>` and `MR_ID=<number>`

**If the argument is a plain number** (e.g. `42`):
- Set `MR_ID=<number>`
- Use `--repo` flag value if provided, otherwise let `glab` infer from the current git remote

**Example parsing:**
```
Input:  https://gitlab.com/finviet/ecopos-backend/-/merge_requests/42
        → REPO=finviet/ecopos-backend  MR_ID=42

Input:  42 --repo finviet/ecopos-backend
        → REPO=finviet/ecopos-backend  MR_ID=42

Input:  42
        → REPO=(from git remote)  MR_ID=42
```

### 2. Fetch MR metadata

Run:
```bash
glab mr view <MR_ID> [--repo <namespace/project>]
```

Extract:
- Title, description, author, target branch, source branch
- Labels, milestone (if any)

### 3. Fetch the diff

Run:
```bash
glab mr diff <MR_ID> [--repo <namespace/project>]
```

Capture the full unified diff output.

### 4. Fetch changed file list

Run:
```bash
glab mr view <MR_ID> --comments [--repo <namespace/project>] 2>/dev/null | head -5
glab api "projects/:fullpath/merge_requests/<MR_ID>/changes" 2>/dev/null \
  | jq -r '.changes[].new_path' 2>/dev/null || echo "(file list unavailable)"
```

Use the diff to enumerate changed files if the API call is unavailable.

### 5. Perform Code Review

Analyze the diff thoroughly against the following criteria:

---

#### 🧹 Clean Code Principles

**Naming & Readability**
- Are variable, function, and class names meaningful and intention-revealing?
- Do names avoid abbreviations, noise words (`data`, `info`, `manager`), or misleading names?
- Are booleans named as predicates (`isActive`, `hasPermission`)?

**Functions**
- Do functions do ONE thing only?
- Are functions small (ideally ≤ 20 lines)?
- Do functions have ≤ 3 parameters? If more, is a parameter object used?
- Are there any flag arguments (boolean params that change function behavior)?
- Do functions operate at a single level of abstraction?

**Comments & Documentation**
- Is the code self-documenting (minimal need for comments)?
- Are there any redundant, misleading, or outdated comments?
- Are complex business rules or non-obvious decisions explained?

**Error Handling**
- Are errors handled explicitly rather than swallowed silently?
- Are `null`/`undefined` returns avoided where possible (prefer throwing or returning a typed error)?
- Is error handling separated from business logic?

**Code Structure**
- Is there duplicated logic that should be extracted (DRY)?
- Are magic numbers and magic strings replaced with named constants?
- Is dead code (commented-out blocks, unused variables/imports) present?
- Does the code follow the Single Responsibility Principle at file/module level?

---

#### λ Functional Programming Principles

**Immutability**
- Are `const` used consistently? Are variables mutated unnecessarily?
- Are arrays/objects mutated in place (`push`, `splice`, direct property assignment) instead of creating new ones?
- Are function parameters mutated?

**Pure Functions**
- Do functions have hidden side effects (modifying external state, I/O inside pure logic)?
- Are functions deterministic given the same input?

**Composition over Imperative Loops**
- Are `map`, `filter`, `reduce`, `flatMap` used instead of `for`/`forEach` where appropriate?
- Are utility chains readable and not excessively nested?
- Are there opportunities to compose smaller functions instead of large imperative blocks?

**Avoid Side Effects in Logic**
- Is I/O (logging, DB calls, HTTP) separated from pure transformation logic?
- Are side effects pushed to the edges (controllers/handlers) rather than buried in domain logic?

**Option/Result patterns**
- Is `null`/`undefined` propagation handled safely (optional chaining, nullish coalescing)?
- Are there opportunities to use a Result/Either pattern instead of try/catch in domain logic?

---

### 6. Output Format

Structure your review as follows:

---

## 🔍 MR Review: !<MR_ID> — <Title>

**Author:** <author> | **Branch:** `<source>` → `<target>`

**Summary of changes:** _(1–3 sentence description of what this MR does)_

---

### ✅ Strengths
_(What is done well — reinforce good patterns)_

---

### 🚨 Critical Issues
_(Must-fix before merge — correctness, security, data integrity)_

For each issue:
> **File:** `path/to/file.ts` · **Line(s):** ~42
> **Problem:** ...
> **Suggestion:**
> ```ts
> // improved code snippet
> ```

---

### ⚠️ Clean Code Issues
_(Code quality, readability, naming, structure)_

Same format as above.

---

### λ Functional Programming Issues
_(Immutability, pure functions, composition)_

Same format as above.

---

### 💡 Minor / Nits
_(Optional improvements, style, small refactors)_

---

### 📊 Review Summary

| Category | Rating | Notes |
|---|---|---|
| Readability | 🟢 / 🟡 / 🔴 | |
| Naming | 🟢 / 🟡 / 🔴 | |
| Function Design | 🟢 / 🟡 / 🔴 | |
| Immutability | 🟢 / 🟡 / 🔴 | |
| Pure Functions | 🟢 / 🟡 / 🔴 | |
| FP Composition | 🟢 / 🟡 / 🔴 | |
| Error Handling | 🟢 / 🟡 / 🔴 | |
| Overall | 🟢 / 🟡 / 🔴 | |

**Verdict:** `APPROVE` / `REQUEST_CHANGES` / `NEEDS_DISCUSSION`

---

> 🟢 Good &nbsp;|&nbsp; 🟡 Needs improvement &nbsp;|&nbsp; 🔴 Critical issue

---

### Notes

- If `glab` is not authenticated, run `glab auth login` first.
- If `--repo` is not provided, `glab` uses the remote of the current git repository.
- Focus review on the **changed lines** in the diff, not the entire codebase.
- For large MRs (>500 lines changed), prioritize Critical and Clean Code issues; note that FP review may be partial.
