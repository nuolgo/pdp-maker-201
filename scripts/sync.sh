#!/usr/bin/env bash

set -euo pipefail

remote="${REMOTE:-origin}"
branch="$(git rev-parse --abbrev-ref HEAD)"

if [[ "${branch}" == "HEAD" ]]; then
  echo "Detached HEAD — nothing to sync." >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Working tree has uncommitted changes. Commit or stash first." >&2
  git status --short
  exit 1
fi

echo "Fetching ${remote}..."
git fetch "${remote}" "${branch}"

echo "Rebasing local ${branch} onto ${remote}/${branch}..."
git pull --rebase "${remote}" "${branch}"

echo "Pushing ${branch} to ${remote}..."
git push "${remote}" "${branch}"

echo "Done. ${branch} is in sync with ${remote}."
