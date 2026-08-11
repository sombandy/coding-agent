---
name: claude-pr-review
description: Invoke Claude CLI to review an existing GitHub pull request, assess Claude's feedback, implement the findings that should be addressed, and update the same PR. Use when working on a PR whose GitHub URL or PR number is available, with or without additional implementation context or nuances.
---

# Claude PR Review

Review the supplied PR with Claude, then assess and address valid findings in the PR you are working on.

1. Resolve the supplied PR URL to the numeric PR number expected by Claude's
   `/pr-review` skill, then invoke Claude CLI with that number and any optional
   context:

   ```bash
   CLAUDE_CLI="${CLAUDE_CLI:-$HOME/.claude/local/claude}"
   REVIEW_DIR="${SCRATCHPAD_OR_TMP:-$(mktemp -d /tmp/claude-pr-review.XXXXXX)}"
   PR_NUMBER="$(gh pr view "<github-pr-url>" --json number --jq .number)"
   CLAUDE_REVIEW_PROMPT="/pr-review $PR_NUMBER"

   # Only append this block when additional context was supplied.
   CLAUDE_REVIEW_PROMPT="$CLAUDE_REVIEW_PROMPT

   Additional context:
   <optional-context>"

   "$CLAUDE_CLI" -p --output-format text "$CLAUDE_REVIEW_PROMPT" \
     > "$REVIEW_DIR/claude-review.md" \
     2> "$REVIEW_DIR/claude-review.stderr.log"
   ```

   - Omit the additional-context section when none was supplied.
   - If the user supplied a numeric PR number instead of a URL, use it directly.
     Do not pass a GitHub URL to `/pr-review`; its input contract is a PR number.
   - The default executable path matches the current shell alias-based installation. Set `CLAUDE_CLI` when Claude is installed elsewhere; do not rely on aliases in non-interactive shells.
   - Use `-p` to run Claude non-interactively and `--output-format text` so redirected stdout contains only Claude's final response.
   - Use the session scratchpad when available; otherwise create a dedicated
     temporary directory with `mktemp -d` as shown.
   - Reviews typically take several minutes: run the command in the background with a generous timeout (~10 minutes) and continue when it completes; do not block on it or kill it early.
   - An empty findings file is expected while Claude is still running. Do not
     launch another review until the original process has exited. If it exits
     with an empty file, inspect the captured stderr log and exit status before
     retrying.

2. After Claude exits successfully, read `claude-review.md`; it contains only
   Claude's final findings. Do not use `--verbose`, which adds turn-by-turn
   diagnostic output. Consult `claude-review.stderr.log` only if the findings
   file is missing or empty, the process exits unsuccessfully, or invocation
   diagnostics are needed.
3. Assess every finding against the code and available context. Do not apply feedback blindly; reject findings that are incorrect, irrelevant, or outside the PR's intent. In particular, check whether the flagged behavior is introduced by the PR or is a pre-existing, deliberate convention of the codebase — and weigh fixes against the repository's established patterns before accepting them. Findings can also be valid in part; accept the part that holds and reject the rest, saying why.
4. Implement each valid finding that should be addressed and run the relevant validation.
5. Commit and push the fixes to the existing PR branch, following the repository's commit and PR instructions.
6. Report Claude's findings, which ones were accepted or rejected and why, the fixes made, validation results, and the updated PR.

If Claude finds no issues, or none of its findings warrant changes, leave the code unchanged and report that outcome.
