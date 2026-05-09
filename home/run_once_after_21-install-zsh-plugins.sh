#!/usr/bin/env bash
set -euo pipefail

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

clone_or_update() {
  local repo="$1"
  local dest="$2"
  if [[ -d "$dest/.git" ]]; then
    echo "→ Updating $(basename "$dest")"
    git -C "$dest" pull --quiet --ff-only || true
  else
    echo "→ Cloning $(basename "$dest")"
    git clone --depth=1 --quiet "$repo" "$dest"
  fi
}

clone_or_update https://github.com/zsh-users/zsh-autosuggestions          "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_or_update https://github.com/zsh-users/zsh-syntax-highlighting.git  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_or_update https://github.com/zsh-users/zsh-completions              "$ZSH_CUSTOM/plugins/zsh-completions"
clone_or_update https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
