#!/usr/bin/env bash
set -euo pipefail

# .tmux.conf ends with `run '~/.tmux/plugins/tpm/tpm'` so tpm has to live there.
if [[ -d "$HOME/.tmux/plugins/tpm/.git" ]]; then
  echo "→ tpm already installed"
  exit 0
fi

echo "→ Installing tmux plugin manager (tpm)"
git clone --depth=1 --quiet https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
echo "  Run \`prefix + I\` inside tmux to install plugins listed in ~/.tmux.conf"
