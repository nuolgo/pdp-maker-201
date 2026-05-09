#!/usr/bin/env bash

set -euo pipefail

branch="${1:-main}"
primary_remote="${PRIMARY_REMOTE:-origin}"
mirror_remote="${MIRROR_REMOTE:-}"

echo "Pushing ${branch} to ${primary_remote}..."
git push "${primary_remote}" "${branch}"

if [[ -n "${mirror_remote}" ]] && git remote get-url "${mirror_remote}" >/dev/null 2>&1; then
  echo "Pushing ${branch} to ${mirror_remote}..."
  git push "${mirror_remote}" "${branch}"
  echo "Done. ${branch} is now synced to ${primary_remote} and ${mirror_remote}."
else
  if [[ -n "${mirror_remote}" ]]; then
    echo "Mirror remote '${mirror_remote}' not configured — skipped." >&2
  fi
  echo "Done. ${branch} pushed to ${primary_remote}."
fi
