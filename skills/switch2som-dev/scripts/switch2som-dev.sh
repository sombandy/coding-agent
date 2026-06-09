#!/usr/bin/env bash

set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: run this script inside a git repository." >&2
  exit 1
fi

git checkout som-dev
git pull origin main --rebase --autostash

ai_branches="$(
  git for-each-ref refs/heads --format='%(refname:short)' \
    | grep -E '^(codex/|claude/)' || true
)"

if [ -z "${ai_branches}" ]; then
  echo "No local AI-generated branches found."
  exit 0
fi

echo "Deleting local AI-generated branches:"
while IFS= read -r branch; do
  [ -n "${branch}" ] || continue
  echo " - ${branch}"
  git branch -D "${branch}"
done <<EOF
${ai_branches}
EOF
