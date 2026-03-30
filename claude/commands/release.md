# Release Command

Create and push a new version tag for dev or uat environments.

## Workflow

1. **Ask about environment with select prompt**
   - Display this selection menu:
     ```
     Select environment for release:
     1. dev
     2. test
     ```
   - Wait for user input (1-2)
   - Store the selected environment name as ENVIRONMENT

2. **Checkout and pull the branch**
   - If ENVIRONMENT is `dev`: checkout `dev` branch
   - If ENVIRONMENT is `test`: checkout `test` branch
   - Run: `git checkout <branch>`
   - Run: `git pull origin <branch>`

3. **Check latest version tag**
   - If ENVIRONMENT is `dev`: Run: `git tag -l 'v*-dev'`
   - If ENVIRONMENT is `test`: Run: `git tag -l 'v*-test'`
   - Parse tags to find the latest version (e.g., v1.2.5-dev or v1.0.0-main)
   - Display: "Current version: v1.2.5-dev" (or "No existing tags found" if none)

4. **Ask for version bump type with select prompt**
   - Display this selection menu:
     ```
     Select version bump type:
     1. major - Breaking changes (1.0.0 → 2.0.0)
     2. minor - New features (1.2.0 → 1.3.0)
     3. patch - Bug fixes (1.2.3 → 1.2.4)
     ```
   - Wait for user input (1-3)
   - Store the selected bump type as BUMP_TYPE

5. **Calculate new version**
   - Based on current version and BUMP_TYPE, calculate new version
   - If no existing tag, start at v0.0.1-<ENVIRONMENT>
   - Format: `v<major>.<minor>.<patch>-<ENVIRONMENT>`
   - Check changes from previous tag and write a description for new tags
     - Description do not list "Merge" commit

6. **Confirm and create tag**
   - Display: "Will create tag: v1.3.0-dev"
   - Prompt: "Proceed? (yes/no)"
   - If yes:
     - Run: `git tag v<major>.<minor>.<patch>-<ENVIRONMENT>`
     - Run: `git push origin v<major>.<minor>.<patch>-<ENVIRONMENT>`
     - Display: "✅ Tag v1.3.0-dev created and pushed successfully!"
   - If no: Cancel operation

## Version Format

- Dev environment: `v1.2.3-dev`
- Test environment: `v1.2.3-test`

## Branch Mapping

- dev → dev branch
- test → test branch

## Example

```
User: /release
Claude: Select environment for release:
        1. dev
        2. uat-ht
User: 1 (use arrow to pick)
Claude: [checks out develop branch and pulls]
        Current version: v1.2.5-dev
        Select version bump type:
        1. major - Breaking changes (1.0.0 → 2.0.0)
        2. minor - New features (1.2.0 → 1.3.0)
        3. patch - Bug fixes (1.2.3 → 1.2.4)
User: 2
Claude: Will create tag: v1.3.0-dev
        Proceed? (yes/no)
User: yes (use arrow to pick)
Claude: [creates and pushes tag]
        ✅ Tag v1.3.0-dev created and pushed successfully!
```

## Template tag description 
```
Date: DD/MM/YYYY hh:mm:ss 
Author: dobadev 
Branch: dev
Changes:
    + Change 1 
    + Change 2
```
