---
name: deliver
description: Lean 3-phase workflow for non-trivial features, changes and refactors: (1) Spec, a rich spec file produced through brainstorming and codebase/Jira context, (2) Code, TDD in small vertical slices, (3) Review & Fix, a bounded loop with fresh-context review against the spec. Use when the user asks to build or change something that touches more than 1-2 files, mentions "spec", or hands over a Jira ticket or brief. Skip for typo fixes, obvious one-liners and bugs with a known cause; use TDD directly for those.
---

# Branch -> Spec -> Code -> Review & Fix -> MR/PR

A replacement for the brainstorm -> plan -> execute -> review chain.
There is NO separate implementation-plan file. The spec is the only document, and it
carries intent, interfaces and acceptance criteria, never function bodies.

Write all documents in the user's language. Keep code, identifiers and commands in English.

## Reuse rules

Prefer existing skills over re-inventing their steps. Invoke them by name with the Skill tool.
If a skill is not installed, say so in one line and continue with the fallback written here.
Never paste a skill's content into the spec.

Primary (Superpowers): `brainstorming`, `test-driven-development`, `systematic-debugging`,
`verification-before-completion`, `requesting-code-review`, `receiving-code-review`. Also `create-mr` (Phase 4). Optional: `using-git-worktrees`, `dispatching-parallel-agents`.

Do NOT invoke `writing-plans` or `executing-plans`. This workflow replaces them.
When `brainstorming` reaches its "write the plan" hand-off, stop there and continue at Phase 1, step 4.

## Phase 0: BRANCH

Runs before anything else. Skip only if the user already gave both values.

1. Get two values from the user: the **base branch** (checkout from where) and the **new branch name**.
   If either is missing, ask for it (one question, both missing values together). Never guess or default to `main`.
2. Run `git fetch`, then `git checkout -b <new-branch> <base-branch>`. If the working tree is dirty, tell the user and stop.
3. Remember the base branch. It is the target of the MR/PR at the end, and is recorded in the spec header.

## Phase 1: SPEC

Goal: a spec the user can approve in under 5 minutes of reading, and an agent can implement without asking again.

1. **Gather context first (cheap, silent).**
   - If a Jira key or link is given, read the ticket (Atlassian MCP) including linked issues and comments.
   - If a handoff brief exists (for example from a Claude Desktop brainstorm), treat it as settled decisions and do not re-ask them.
   - Map the affected code with Codegraph and/or Serena: entry points, callers, data flow, existing patterns to reuse.
     Prefer symbol-level queries over reading whole files.
   - Check for project glossary, ADRs, CLAUDE.md conventions.
2. **Brainstorm.** Invoke `brainstorming`. One question at a time, only about things the context could not answer.
3. **Enrich (pick by risk, do not run all).**

   | Trigger | Skill to reuse |
   |---|---|
   | Requirement still vague after brainstorming | `grill-me` / `grill-with-docs` (Matt Pocock) or `interview-me` (Addy Osmani) |
   | New domain terms or unclear ubiquitous language | `domain-modeling` |
   | New or changed API, module boundary, public interface | `api-and-interface-design` |
   | Handles user input, auth, money, secrets, external calls | `security-and-hardening` |
   | Runs in production, needs metrics, logs or tracing | `observability-and-instrumentation` |
   | Uses a framework or library feature you are not sure about | `source-driven-development` |
   | High stakes or irreversible (migrations, payments, data deletion) | `doubt-driven-development` |
   | No quality bar written down | `constraint-driven-development` |
   | Existing behavior must not change | Characterization tests listed in the spec |

4. **Write the spec** to `~/.deliver/<repo>/DDMMYYYYhhmmss_<name>.md` using the template below.
   `<repo>` is the basename of the git root, `<name>` a short kebab-case topic. Create the directory if missing,
   and take the timestamp from `date +%d%m%Y%H%M%S`. The spec lives outside the repo, so never commit it.
5. **Gate.** Show a short summary (goal, scope, open questions) and ask for approval.
   Do not start Phase 2 without a clear yes. Open questions that block implementation must be resolved now.

### Spec template (omit empty sections)

```
# <Title>
Source: <Jira key / link / brief>   Status: Draft | Approved   Size: S | M | L
Base branch: <branch the work was checked out from>   Branch: <new branch>

## Goal            1-3 sentences: the outcome and why it matters
## Non-goals       what this change deliberately does not do
## Context         affected modules/files (from Codegraph/Serena), patterns to reuse, glossary terms
## Decisions       decision -> reason (only those that were actually debated)
## Interfaces      signatures, endpoints, DTOs, events, schema changes. Signatures only, no bodies
## Behavior        main flow, edge cases, error cases, concurrency/idempotency, backward compatibility
## Acceptance criteria
- [ ] AC1: <observable, verifiable statement> -> verify: <test name or command>
- [ ] AC2: ...
## Test strategy   what is unit/integration/e2e, what to mock, characterization tests
## Risks & rollout migrations, feature flags, rollback, monitoring
## Security & observability   only what applies (authz, validation, PII, logs/metrics)
## Open questions  must be empty before approval
## Review log      filled in Phase 3
```

Rules for the spec: every acceptance criterion must be checkable by a test or a command.
"Works correctly" is not a criterion. Prefer 5-10 sharp criteria over 30 vague ones.

## Phase 2: CODE

The main agent coordinates; a low-cost subagent writes the code. This keeps the expensive
context small. ALWAYS delegate the implementation of every slice, however small.

1. Split the work into thin vertical slices, each mapped to one or more acceptance criteria.
   Track slices with the task list, not with a new file.
2. For each slice, spawn one subagent on the cheapest capable model (`model: "haiku"`, or `"sonnet"` when the slice
   needs real design judgment). Its prompt contains: the spec path, the slice and its AC ids, and the instruction
   to run `test-driven-development` (failing test -> minimal implementation -> green -> refactor) and to commit
   with a message that references the AC id. Do not rewrite the plan or paste the spec into the prompt.
   Ask for a short report: files touched, tests added, command output proving green, anything surprising.
3. Run slices sequentially. Run them in parallel only when truly independent (`dispatching-parallel-agents`).
4. After each slice, the main agent checks the report against the AC (run the verify command, skim the diff),
   not the whole implementation. Reject and re-dispatch with the concrete failure if it does not hold.
5. On any unexpected failure, switch to `systematic-debugging`. Do not guess-fix in a loop. If the subagent
   failed twice on the same slice, take the slice over (or escalate the model) instead of a third retry.
6. Surgical changes: touch only what the slice needs, match existing style, mention unrelated issues instead of fixing them,
   remove only the dead code your own change created. State this in the subagent prompt.
7. If implementation proves the spec wrong, stop, update the spec (Decisions/Behavior), tell the user in one or two lines, then continue.

## Phase 3: REVIEW & FIX (bounded loop)

Repeat up to **3 iterations**:

1. **Verify.** Follow `verification-before-completion`: run tests, typecheck, lint, build.
   Collect evidence per acceptance criterion (test name or command output). A criterion without evidence is not done.
2. **Review.** Use `requesting-code-review` with a fresh-context reviewer. Give it the spec path and the diff since the base commit.
   Ask for two separate axes:
   - Spec compliance: every acceptance criterion and non-goal respected, nothing missing, nothing extra.
   - Code quality: correctness, security, error handling, concurrency, performance on real load, tests that would catch a regression, readability.
   Findings must be labeled Critical / Important / Minor, each with: what the code does, what goes wrong, suggested fix.
   Optional extra lenses when relevant: `code-review-and-quality`, `security-and-hardening` checklist.
   If ponytail is installed, run `/ponytail-review` as one extra pass focused on "what can be cut or reused instead of written".
   Treat its findings like any other: triage before acting, and never let it remove validation, error handling, security or tests the spec requires.
   If it is not installed, skip this line silently.
3. **Triage.** Follow `receiving-code-review`: verify each finding against the code before acting, push back on wrong ones with evidence,
   no performative agreement.
4. **Fix** Critical and Important findings. Minor ones only if cheap or the user asked. Re-run verification.
   Delegate fixes to a low-cost subagent as in Phase 2.
5. Append to the spec's Review log: iteration number, findings fixed, findings rejected (with reason), remaining items.

**Exit when:** no Critical/Important findings remain AND every acceptance criterion has passing evidence.
**Escalate to the user (do not loop further)** when: iteration 3 still has Critical/Important findings, the same finding returns twice,
or fixing requires changing the spec's goal or scope.

## Phase 4: CREATE MR/PR

After Phase 3 exits cleanly, invoke the `create-mr` skill with the Skill tool to open the MR/PR
from the current branch into the base branch from Phase 0 (pass it as the target).
Do NOT ask the user for permission or confirmation: create it directly, and do not run `finishing-a-development-branch`.
If Phase 3 escalated to the user instead of exiting cleanly, do not create the MR/PR.

## Final report (keep it short)

- What was built, in 2-3 sentences
- Acceptance criteria status (done / not done, with evidence pointers)
- Findings rejected or deferred, and why
- Spec path
- MR/PR link

## Token discipline

- Read symbols and snippets via Codegraph/Serena before reading whole files.
- Do not restate the spec in chat, link to it.
- Do not write code into the spec. Do not create a plan file.
- Skip enrichment skills whose trigger does not apply.
- Phase 2 coding always runs in a low-cost subagent; the main agent only plans slices and checks reports.
- Small tasks: collapse Phase 1 to a 10-line spec (Goal, Acceptance criteria, Risks) and keep the same Phase 2 and 3.
