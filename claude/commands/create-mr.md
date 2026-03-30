# Create Merge Request Command

Create a GitLab merge request for the current branch into **main** branch following the repository's conventions.

## Instructions

1. Run `git status` to check current branch and any uncommitted changes
2. **Ask the user to select the target branch with select prompt**:
   - Display this selection menu:
     ```
     Select target branch for the merge request:
     1. main
     2. test
     3. dev
     4. custom (I'll specify)
     ```
   - Wait for user input (1-4)
   - If option 4, ask: "Which branch should be the target?"
   - Store the selected branch name as TARGET_BRANCH
3. Run `git log ${TARGET_BRANCH}..HEAD --oneline` to see all commits that will be included in the MR
4. Run `git diff ${TARGET_BRANCH}...HEAD --stat` to see a summary of all changes
5. Run `git diff ${TARGET_BRANCH}...HEAD` to see the full diff (if needed for context)
6. Analyze all commits and changes to draft an MR summary that:
   - Provides a clear, concise title following conventional commit format
   - Includes a comprehensive description with:
     - **Summary**: 2-4 bullet points explaining what changed and why
     - **Changes**: Key technical changes made
   - References any related issues or tasks if mentioned in commits
7. Verify the current branch tracks a remote branch:
   - If not tracking remote, push with `git push -u origin <branch-name>`
   - If tracking but not up to date, push with `git push`
8. Create the MR using GitLab CLI with the selected TARGET_BRANCH:
   ```bash
   glab mr create --title "Title here" --description "$(cat <<'EOF'
   ## Summary
   - Bullet point 1
   - Bullet point 2

   ## Changes
   - Technical change 1
   - Technical change 2
   EOF
   )" --target-branch ${TARGET_BRANCH}
   ```
9. Return the MR URL when done

## Notes

- DO NOT mention Claude or Claude Code in the MR description
- If there are uncommitted changes, ask the user if they want to commit them first
- If the branch is not pushed to remote, push it before creating the MR
- The MR title should follow conventional commit format (feat/fix/refactor/docs/test/chore)
- Ensure the MR description is professional and provides sufficient context for reviewers
- The target branch will be selected interactively at the beginning of the process

## Example

```
User: /create-mr
Claude: Select target branch for the merge request:
        1. main
        2. test
        3. dev
        4. custom (I'll specify)
User: 1 (use arrow to pick)
Claude: [runs git log and git diff commands]
        [analyzes commits and changes]
        
        Will create MR with:
        Title: feat: Add user authentication module
        
        Description:
        ## Summary
        - Implemented JWT-based authentication
        - Added login and registration endpoints
        - Created middleware for protected routes
        
        ## Changes
        - New auth controller and service
        - Database migrations for users table
        - Unit tests for authentication flow
        
        Target branch: main
        
        Proceed? (yes/no)
User: yes (use arrow to pick)
Claude: [pushes branch if needed]
        [creates merge request]
        ✅ Merge request created successfully!
        URL: https://gitlab.com/project/merge_requests/123
```
