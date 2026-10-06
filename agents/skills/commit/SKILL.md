---
name: commit
description: Use when writing, amending, or reviewing a git commit message, or right before running git commit, in any project that has no commit convention of its own.
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
