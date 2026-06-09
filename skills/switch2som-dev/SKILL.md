---
name: switch2som-dev
description: Switch the current git repository to the som-dev branch, rebase it on origin/main, and delete local AI-generated branches with the prefixes codex/ or claude/. Use when the user asks to return a repo to som-dev, sync it with main, or clean up local Codex/Claude branches.
---

# Switch To som-dev

Run the bundled script from the target git repository:

```bash
"$CODEX_HOME/skills/switch2som-dev/scripts/switch2som-dev.sh"
```

If `CODEX_HOME` is unset, use:

```bash
"$HOME/.codex/skills/switch2som-dev/scripts/switch2som-dev.sh"
```

The script does exactly this:

1. Verify the current directory is inside a git work tree.
2. Check out `som-dev`.
3. Run `git pull origin main --rebase --autostash`.
4. Delete every local branch whose name starts with `codex/` or `claude/`.

Operational notes:

- Run it from the repository root or anywhere inside the target repository.
- Let git fail naturally if checkout or rebase cannot proceed.
- Report the final branch, whether the rebase succeeded, and which branches were deleted.
- Do not delete remote branches; this skill only removes local branches.
