---
name: create-mr
description: Create a merge request or pull request with a generated description. Use when the user asks to create, open, or raise an MR/PR, or says "push and open MR/PR". Must trigger even if the user doesn't say "skill".
---

# Create MR / PR

Create a real GitLab merge request or GitHub pull request with a description from the fixed template below. Never push or create anything before the user explicitly confirms (step 5).

## 1. Detect the platform
- Read `git remote get-url origin`. Contains `github.com` -> GitHub (`gh`, "PR"). Contains `gitlab` or `git2.fptshop.com.vn` -> GitLab (`glab`, "MR"). If unclear, ask the user.
- Verify the CLI is installed and authenticated (`gh auth status` / `glab auth status`). If not, tell the user how to fix it and stop.
- Use "PR" or "MR" consistently in all messages.

## 2. Ask for source and target branch
- Source default: `git branch --show-current`.
- Target default: the repo default branch (try `origin/HEAD`, then `main`, `master`, `develop`).
- Ask: "Which source and target branch do you want to use?" and show the defaults. If the user accepts, go to step 3.
- Stop with an error if source == target, or if the source is main/master/develop.

## 3. Pre-flight checks
- Warn if `git status --porcelain` shows uncommitted changes and ask whether to continue. Never commit unless asked.
- Check whether the source exists on the remote and is up to date. If not, note it must be pushed (normal `git push -u`, never force).
- If an open MR/PR already exists for source -> target, show its URL and stop.
- If the source has no commits that are not in the target, stop.

## 4. Generate the description
- Run `git log <target>..<source> --oneline` and `git diff origin/<target>...<source> --stat`, then read the full diff (or the key files if huge).
- Ticket keys (e.g. `PROJ-123`): extract from branch name and commits. None found -> `N/A`. Never invent one.
- If the remote URL contains `git2.fptshop.com.vn`, format each ticket as a link to `https://reqs.frt.vn/browse/<KEY>`, e.g. `- [PROJ-123](https://reqs.frt.vn/browse/PROJ-123)`. Other remotes keep the plain key.
- Check only the "Type of change" box(es) that match.
- Write the why before the what; don't just restate the diff.
- Checklist: check an item only with evidence (tests added/changed, linter passes). You may run quick, obvious lint/test commands (package.json, Makefile, etc.). "Self test" stays unchecked unless the user confirms they tested manually. Add relevant extra items (migration, breaking change, feature flag).
- "Env changes" section: include only if the diff adds or changes env vars (`.env.example`, config files, docker-compose, `process.env.*`, `os.Getenv`). Placeholder values only, never real secrets. Otherwise omit the section.
- Also write a concise title (Conventional Commits style if the repo uses it).

## 5. Confirm before creating
Show this exact line (swap MR/PR by platform), then the title and full description:

> I will create a MR `<source_branch>` -> `<target_branch>`. Are you agree?

Wait for an explicit yes. If the user wants changes (branches, title, description, draft), apply them and ask again. Push and create nothing before the yes.

## 6. Create
- If the source is not on the remote or is behind: `git push -u origin <source>` (no force).
- Write the description to a temp file and pass it via the CLI (avoids shell-escaping problems):
  - GitHub: `gh pr create --base <target> --head <source> --title "<title>" --body-file <file>`
  - GitLab: `glab mr create --source-branch <source> --target-branch <target> --title "<title>" --description "$(cat <file>)" --yes`
- Add `--draft` only if the user asked.
- Never add assignees, reviewers, labels, or auto-merge unless the user asks.
- Delete the temp file afterwards.
- Reply with the MR/PR URL and a one-line summary. If creation fails, show the error and stop; don't retry with different flags blindly.

## Template (use exactly this structure)

````markdown
## Summary
<1-3 sentences: what and why>

## Related tickets
- PROJ-123

## Type of change
- [ ] Feature
- [ ] Bug fix
- [ ] Refactor (no behavior change)
- [ ] Performance
- [ ] Chore / dependencies / CI
- [ ] Docs

## Changes
- <high-level change 1>
- <high-level change 2>

## Checklist
- [ ] Unit test
- [ ] Linter
- [ ] Self test
- [ ] No debug code / commented-out code
- [ ] Docs updated (if needed)

## Env changes
```
SOME_VAR="...."
```
````
