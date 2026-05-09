#!/usr/bin/env bash
set -euo pipefail

if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "oh-my-zsh already installed"
  exit 0
fi

echo "→ Installing oh-my-zsh"
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
