---
name: pr-review
description: Review an open pull request by PR number to identify high-severity bugs and high-impact performance regressions. Use when the user provides a PR number and asks for review findings on correctness risks, breaking behavior changes, and optimization opportunities.
---

# PR Review

## Scope

- Accept a PR number as input (for example: `123`).
- Check out the PR branch with `gh pr checkout <PR#>` before reviewing.
- Do not use manual pull-ref fetch commands like `git fetch origin pull/<PR#>/head:...` unless the user explicitly requests that fallback.
- Review only the files changed in that open PR.
- Prioritize issues that can cause incorrect behavior, crashes, data loss, security exposure, or significant latency/cost increases.
- Ignore style-only feedback unless it hides a major bug or performance issue.

## Workflow

1. Validate PR state and fetch changes:
   - Run `gh pr view <PR#> --json state,title,baseRefName,headRefName,url`.
   - If state is not `OPEN`, stop and report that the PR must be open.
2. Check out the PR branch:
   - Run `gh pr checkout <PR#>`.
   - If checkout fails, stop and report the exact blocker (auth, permissions, dirty worktree, or missing `gh` setup).
3. Build review diff after checkout:
   - Read the PR base branch from step 1 (`baseRefName`).
   - Run `git fetch origin <baseRefName>`.
   - Run `git diff --name-status origin/<baseRefName>...HEAD` and inspect changed files.
4. Check correctness risks first:
   - Boundary conditions, null handling, and error propagation.
   - State mutation, race conditions, and resource cleanup.
   - API contract changes and backward compatibility.
5. Check optimization opportunities with clear impact:
   - Repeated expensive I/O, N+1 queries, redundant loops/allocations.
   - Unnecessary recomputation or rerenders.
   - Algorithmic complexity hotspots.
6. Attach evidence for every finding:
   - Exact file and line reference.
   - Failure mode or performance impact.
   - Minimal fix proposal.

## Report Format

Return findings first, ordered by severity:

- `P0`: Critical breakage, security issue, or data loss risk.
- `P1`: High-confidence bug or clear performance regression.
- `P2`: Moderate risk or worthwhile optimization.

For each finding include:

- Title
- Why it matters
- File and line
- Suggested fix

If no major issues are found, state: `No major bugs or high-impact optimization issues found.`
