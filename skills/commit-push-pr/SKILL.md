---
name: commit-push-pr
description: Commit relevant changes, rebase som-dev on main, force-push som-dev, and create or update a PR
---

Create or update a PR with this simple flow:

1. **Commit the relevant changes:**
   - Run `git status` to see what changed
   - Use `git add <specific-files>` to stage only the files related to this task
   - Do NOT use `git add .` - be selective
   - Exclude any unrelated changes, debug files, or experimental code
   - Exclude `.md` design docs unless the user explicitly asks to commit them
   - Generate a concise commit message
   - Do not include your marketing material like "Generated with [Claude Code]" or "Co-Authored-By: Claude"
   - Use the configured Git identity. If the repo or environment has the wrong author, commit with `--author="Somnath Banerjee <somnath.banerjee@gmail.com>"`
   - Commit the staged changes

2. **Get the latest main onto `som-dev`:**
   - Stay on `som-dev`
   - Run `git pull origin main --rebase --autostash`
   - If conflicts occur, stop and ask me for help

3. **Force-push `som-dev`:**
   - Run `git push --force-with-lease origin HEAD:som-dev`
   - Do not pull or rebase from `origin/som-dev`
   - If the force-with-lease push fails, stop and report the branch state

4. **Create or update the PR:**
   - Check whether `som-dev` already has an open PR against `main`
   - If it does, report that PR instead of creating a duplicate
   - If it does not, create a PR from `som-dev` to `main`
   - Use the commit message as the PR title if there’s a single commit
   - Write a PR description with 1–2 sentences summarizing the change

## How to Use

### Let Codex decide what to commit:

```
/commit-push-pr
```

Codex will review changes and stage only relevant files.

### With your own commit message:

```
/commit-push-pr fix: resolve FareHarbor timeout issue
```

### With more specific instructions:

```
/commit-push-pr feat: add Redis caching - only commit the cache files, not the test changes
```
