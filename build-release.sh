#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_PATH="$ROOT_DIR/CS2AdminTool/CS2AdminTool.csproj"
DIST_DIR="$ROOT_DIR/dist"
PUBLISH_DIR="$DIST_DIR/publish"

RIDS=("linux-x64" "linux-arm64" "win-x64")

rm -rf "$PUBLISH_DIR"
mkdir -p "$PUBLISH_DIR"

for rid in "${RIDS[@]}"; do
  out="$PUBLISH_DIR/$rid"
  echo "Publishing $rid..."
  dotnet publish "$PROJECT_PATH" -c Release -r "$rid" --self-contained true -o "$out" /p:PublishSingleFile=true /p:IncludeNativeLibrariesForSelfExtract=true

  archive="$DIST_DIR/CS2AdminTool-$rid.tar.gz"
  rm -f "$archive"
  tar -C "$out" -czf "$archive" .
  echo "Created $archive"
done

echo "Release artifacts are ready in $DIST_DIR"
