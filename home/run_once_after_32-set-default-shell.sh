#!/usr/bin/env bash
set -euo pipefail

if [[ "${SHELL:-}" == *"zsh"* ]]; then
  exit 0
fi

ZSH_PATH="$(command -v zsh || true)"
if [[ -z "$ZSH_PATH" ]]; then
  echo "! zsh not found on PATH; skipping default-shell change"
  exit 0
fi

# /etc/shells must list zsh on macOS or chsh refuses.
if ! grep -qx "$ZSH_PATH" /etc/shells 2>/dev/null; then
  echo "→ Adding $ZSH_PATH to /etc/shells (sudo)"
  echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
fi

if command -v chsh >/dev/null 2>&1; then
  echo "→ Changing default shell to $ZSH_PATH"
  chsh -s "$ZSH_PATH" || echo "! chsh failed; run it manually"
else
  echo "! chsh not available; set zsh as default shell manually"
fi
