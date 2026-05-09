#!/usr/bin/env bash
set -euo pipefail

if ! command -v gem >/dev/null 2>&1; then
  echo "! ruby/gem not installed; skipping colorls"
  exit 0
fi

if command -v colorls >/dev/null 2>&1; then
  echo "→ colorls already installed"
  exit 0
fi

echo "→ Installing colorls"
# Use --user-install on macOS / system Ruby to avoid needing sudo.
if [[ "$(uname -s)" == "Darwin" ]]; then
  gem install --user-install colorls
else
  sudo gem install colorls
fi
