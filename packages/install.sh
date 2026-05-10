#!/usr/bin/env bash
# Installs everything available via the system package manager.
# Anything that's not in the package manager (or that needs a specific
# install path, like p10k or oh-my-zsh) lives in chezmoi run_once_* scripts.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log()  { printf '\033[36m→\033[0m %s\n' "$*"; }
warn() { printf '\033[33m!\033[0m %s\n' "$*" >&2; }
ok()   { printf '\033[32m✓\033[0m %s\n' "$*"; }

# Read a list file, ignore comments / blank lines.
read_list() { grep -vE '^\s*(#|$)' "$1"; }

install_macos() {
  if ! command -v brew >/dev/null 2>&1; then
    log "Installing Homebrew"
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Make brew available in this shell on Apple Silicon.
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  log "brew bundle --file=$DIR/Brewfile"
  brew bundle --file="$DIR/Brewfile"
  ok "Homebrew packages installed"
}

install_linux_apt() {
  log "Installing apt packages"
  sudo apt-get update -y
  # shellcheck disable=SC2046
  sudo apt-get install -y $(read_list "$DIR/apt.txt")
  install_linux_extras
}

install_linux_dnf() {
  log "Installing dnf packages"
  # shellcheck disable=SC2046
  sudo dnf install -y $(read_list "$DIR/dnf.txt")
  install_linux_extras
}

install_lazygit_linux() {
  if command -v lazygit >/dev/null 2>&1; then return 0; fi
  log "Installing lazygit"
  local tmp version url
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN
  version=$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
    | grep -Po '"tag_name": "v\K[^"]*' || true)
  if [[ -z "$version" ]]; then warn "Could not resolve lazygit version"; return 0; fi
  url="https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_x86_64.tar.gz"
  curl -fsSL "$url" -o "$tmp/lazygit.tar.gz"
  tar -xf "$tmp/lazygit.tar.gz" -C "$tmp" lazygit
  sudo install "$tmp/lazygit" /usr/local/bin/lazygit
}

install_lazydocker_linux() {
  if command -v lazydocker >/dev/null 2>&1; then return 0; fi
  log "Installing lazydocker"
  curl -fsSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
}

install_gh_linux() {
  if command -v gh >/dev/null 2>&1; then return 0; fi
  log "Installing GitHub CLI (gh)"
  if command -v apt-get >/dev/null 2>&1; then
    type -p curl >/dev/null
    sudo install -dm 755 /etc/apt/keyrings
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | sudo dd of=/etc/apt/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt-get update -y
    sudo apt-get install -y gh
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y "dnf-command(config-manager)"
    sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
    sudo dnf install -y gh
  fi
}

install_zoxide_linux() {
  # zoxide is in apt (since 22.04) and dnf, so it's already covered by
  # apt.txt / dnf.txt. Only fall back to curl if the package wasn't
  # available — and if even that fails, don't abort the whole install
  # (zoxide upstream's installer doesn't handle every libc/arch combo).
  if command -v zoxide >/dev/null 2>&1; then return 0; fi
  log "Installing zoxide (curl fallback)"
  curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash || \
    warn "zoxide install failed — install it via your package manager"
}

install_btop_linux() {
  if command -v btop >/dev/null 2>&1; then return 0; fi
  log "Installing btop"
  if   command -v apt-get >/dev/null 2>&1; then sudo apt-get install -y btop || true
  elif command -v dnf     >/dev/null 2>&1; then sudo dnf install -y btop     || true
  fi
}

install_nerd_fonts_linux() {
  local font_dir="$HOME/.local/share/fonts"
  mkdir -p "$font_dir"
  if find "$font_dir" -maxdepth 1 -name 'JetBrainsMono*' | grep -q .; then
    return 0
  fi
  log "Installing JetBrainsMono Nerd Font"
  local tmp; tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/JetBrainsMono.zip" \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip -q -o "$tmp/JetBrainsMono.zip" -d "$font_dir"
  fc-cache -f "$font_dir" >/dev/null || true
  rm -rf "$tmp"
}

install_linux_extras() {
  # Best-effort: a single tool failing should not abort everything else,
  # otherwise one broken upstream installer takes the whole bootstrap down.
  install_lazygit_linux    || warn "lazygit install failed"
  install_lazydocker_linux || warn "lazydocker install failed"
  install_gh_linux         || warn "gh install failed"
  install_zoxide_linux     || warn "zoxide install failed"
  install_btop_linux       || warn "btop install failed"
  install_nerd_fonts_linux || warn "Nerd Fonts install failed"
  ok "Linux extras installed (any failures above are non-fatal)"
}

case "$(uname -s)" in
  Darwin)
    install_macos
    ;;
  Linux)
    if   command -v apt-get >/dev/null 2>&1; then install_linux_apt
    elif command -v dnf     >/dev/null 2>&1; then install_linux_dnf
    else
      warn "No supported Linux package manager found (apt-get / dnf)."
      exit 1
    fi
    ;;
  *)
    warn "Unsupported OS: $(uname -s)"
    exit 1
    ;;
esac
