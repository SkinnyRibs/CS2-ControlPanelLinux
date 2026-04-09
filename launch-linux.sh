#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RID="${1:-linux-x64}"
APP_PATH="$ROOT_DIR/dist/publish/$RID/CS2AdminTool"

if [[ -x "$APP_PATH" ]]; then
  exec "$APP_PATH"
fi

echo "No published binary found at: $APP_PATH"
echo
if command -v dotnet >/dev/null 2>&1; then
  echo "Running from source via dotnet..."
  exec dotnet run --project "$ROOT_DIR/CS2AdminTool/CS2AdminTool.csproj"
fi

echo "dotnet is not installed and no self-contained binary is available."
echo "Fix:"
echo "  1) Build binaries: ./build-release.sh"
echo "  2) Then run:      ./launch-linux.sh $RID"
echo "  3) Or download a release artifact and run ./CS2AdminTool directly"
exit 1
