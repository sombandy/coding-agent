---
name: codex-pr-review
description: Invoke Codex CLI to review an existing GitHub pull request, assess Codex's feedback, implement the findings that should be addressed, and update the same PR. Use when working on a PR whose GitHub URL is available, with or without additional implementation context or nuances.
---

# Codex PR Review

Review the supplied PR with Codex, then assess and address valid findings in the PR you are working on.

1. Invoke Codex CLI with the supplied PR URL and optional context:

   ```bash
   command codex exec --ephemeral --output-last-message "$SCRATCHPAD_OR_TMP/codex-review.md" - <<'PROMPT'
   Use $pr-review to review this pull request:
   <github-pr-url>

   Additional context, if any:
   <optional-context>
   PROMPT
   ```

   - Omit the additional-context section when none was supplied.
   - Use `command codex` (not bare `codex`) so shell aliases or functions wrapping `codex` can never mangle the `exec` subcommand.
   - Replace `$SCRATCHPAD_OR_TMP` with your session scratchpad directory if you have one, otherwise `/tmp`.
   - Reviews typically take several minutes: run the command in the background with a generous timeout (~10 minutes) and continue when it completes; do not block on it or kill it early.

2. Read the review from the `--output-last-message` file — it contains only Codex's final findings. Do not page through the full stdout transcript (it can be tens of thousands of tokens of intermediate tool calls and diffs); consult it only if the output file is missing or empty, or you need the evidence behind a specific finding.
3. Assess every finding against the code and available context. Do not apply feedback blindly; reject findings that are incorrect, irrelevant, or outside the PR's intent. In particular, check whether the flagged behavior is introduced by the PR or is a pre-existing, deliberate convention of the codebase — and weigh fixes against the repository's established patterns before accepting them. Findings can also be valid in part; accept the part that holds and reject the rest, saying why.
4. Implement each valid finding that should be addressed and run the relevant validation.
5. Commit and push the fixes to the existing PR branch, following the repository's commit and PR instructions.
6. Report Codex's findings, which ones were accepted or rejected and why, the fixes made, validation results, and the updated PR.

If Codex finds no issues, or none of its findings warrant changes, leave the code unchanged and report that outcome.
