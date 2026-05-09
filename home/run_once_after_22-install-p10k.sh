#!/usr/bin/env bash
set -euo pipefail

# .zshrc sources ~/powerlevel10k/powerlevel10k.zsh-theme directly, so install
# it at that exact path rather than via a package manager.
if [[ -d "$HOME/powerlevel10k/.git" ]]; then
  echo "→ Updating powerlevel10k"
  git -C "$HOME/powerlevel10k" pull --quiet --ff-only || true
else
  echo "→ Installing powerlevel10k"
  git clone --depth=1 --quiet https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
fi
