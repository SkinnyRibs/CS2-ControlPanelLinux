#!/usr/bin/env bash
set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI is required. Install from https://cli.github.com/"
  exit 1
fi

if [[ $# -lt 1 ]]; then
  echo "Usage: ./release-github.sh <tag> [title]"
  exit 1
fi

TAG="$1"
TITLE="${2:-$TAG}"

./build-release.sh

gh release create "$TAG" \
  "dist/CS2AdminTool-linux-x64.tar.gz" \
  "dist/CS2AdminTool-linux-arm64.tar.gz" \
  "dist/CS2AdminTool-win-x64.tar.gz" \
  --title "$TITLE" \
  --generate-notes
