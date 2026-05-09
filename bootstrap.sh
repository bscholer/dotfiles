#!/usr/bin/env bash
# One-shot bootstrap for a fresh machine.
#
#   curl -fsSL https://raw.githubusercontent.com/bscholer/dotfiles/master/bootstrap.sh | bash
#
# What this does:
#   1. Installs chezmoi if it's missing.
#   2. Runs `chezmoi init --apply bscholer/dotfiles`, which:
#      - clones the repo to ~/.local/share/chezmoi
#      - prompts for name/email/install_node/install_nvchad (once)
#      - applies dotfiles to $HOME
#      - runs run_onchange_/run_once_ scripts (which install packages and
#        clone oh-my-zsh, p10k, tpm, NvChad, nvm, etc.)
#
# Re-running just `chezmoi apply` later updates dotfiles + re-runs any
# scripts whose content changed.
set -euo pipefail

GITHUB_USER="${GITHUB_USER:-bscholer}"
GITHUB_REPO="${GITHUB_REPO:-dotfiles}"

log() { printf '\033[36m→\033[0m %s\n' "$*"; }
ok()  { printf '\033[32m✓\033[0m %s\n' "$*"; }

ensure_chezmoi() {
  if command -v chezmoi >/dev/null 2>&1; then return 0; fi

  log "Installing chezmoi"
  case "$(uname -s)" in
    Darwin)
      if command -v brew >/dev/null 2>&1; then
        brew install chezmoi
      else
        sh -c "$(curl -fsSL https://get.chezmoi.io)" -- -b "$HOME/.local/bin"
        export PATH="$HOME/.local/bin:$PATH"
      fi
      ;;
    Linux)
      sh -c "$(curl -fsSL https://get.chezmoi.io)" -- -b "$HOME/.local/bin"
      export PATH="$HOME/.local/bin:$PATH"
      ;;
    *)
      echo "Unsupported OS: $(uname -s)" >&2
      exit 1
      ;;
  esac
}

ensure_chezmoi

log "chezmoi init --apply ${GITHUB_USER}/${GITHUB_REPO}"
chezmoi init --apply "${GITHUB_USER}/${GITHUB_REPO}"

ok  "Done. Open a new shell to pick up the new \$SHELL / config."
