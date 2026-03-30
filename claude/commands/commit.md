# Commit Command

Create a git commit with staged changes following the repository's commit conventions.

## Instructions

1. Run `git status` to see all untracked and modified files
2. Run `git diff --cached` to see staged changes and `git diff` to see unstaged changes
3. Run `git log --oneline -10` to see recent commit messages and understand the commit style
4. Analyze all staged changes and draft a commit message that:
   - Follows the repository's commit message style (based on recent commits)
   - Uses conventional commit format (feat/fix/refactor/docs/test/chore)
   - Focuses on the "why" rather than just the "what"
   - Is concise (1-2 sentences in the body if needed)
5. Stage any additional relevant untracked files if needed (ask user first if unsure)
6. Create the commit 
7. Run `git status` after the commit to verify success
8. Run `git push` to push code to origin

## Notes

- DO NOT add CLAUDE.md and .claude directory
- DO NOT mention about Claude or Claude code in commit message
- DO NOT add Claude Code as author in footer of commit message
- DO NOT commit files that likely contain secrets (.env, credentials.json, etc)
- Ignore changes in .gitignore
- Use a Angular commit convention for the commit message to ensure proper formatting
- If there are no changes to commit, inform the user
- DO NOT push to the remote repository unless explicitly asked
