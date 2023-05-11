#!/bin/bash

install_lazygit() {
  _process "→ Installing lazygit"

  case "$package_manager" in
    apt-get)
      temp_dir=$(mktemp -d)

      LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*' 2>/dev/null)
      curl -sLo "${temp_dir}/lazygit.tar.gz" "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
      tar xf "${temp_dir}/lazygit.tar.gz" -C "${temp_dir}" lazygit >> "$LOG" 2>&1
      sudo install "${temp_dir}/lazygit" /usr/local/bin >> "$LOG" 2>&1

      rm -rf "${temp_dir}"
      ;;
    dnf)
      sudo dnf copr enable atim/lazygit -y >> "$LOG" 2>&1
      sudo dnf install lazygit >> "$LOG" 2>&1
      ;;
    pacman)
      sudo pacman -S lazygit >> "$LOG" 2>&1
      ;;
    brew)
      brew install jesseduffield/lazygit/lazygit >> "$LOG" 2>&1
      ;;
    port)
      sudo port install lazygit >> "$LOG" 2>&1
      ;;
    xbps)
      sudo xbps-install -S lazygit >> "$LOG" 2>&1
      ;;
    scoop)
      scoop bucket add extras >> "$LOG" 2>&1
      scoop install lazygit >> "$LOG" 2>&1
      ;;
    go)
      go install github.com/jesseduffield/lazygit@latest >> "$LOG" 2>&1
      ;;
    choco)
      choco install lazygit >> "$LOG" 2>&1
      ;;
    conda)
      conda install -c conda-forge lazygit >> "$LOG" 2>&1
      ;;
    emerge)
      sudo emerge dev-vcs/lazygit >> "$LOG" 2>&1
      ;;
    pkg)
      pkg install lazygit >> "$LOG" 2>&1
      ;;
    *)
      _warning "Unsupported package manager. Please install lazygit manually"
      ;;
  esac

  _success "Installed lazygit"
}

install_colorls() {  
  sudo gem install colorls >> "$LOG" 2>&1
  _success "Installed colorls"
}

install_lazydocker() {
  _process "→ Installing lazydocker"
  curl -s https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash >> "$LOG" 2>&1
  _success "Installed lazydocker"
}

install_fonts() {
  _process "→ Installing Nerd Fonts 🤓 "

  _process "  → Installing JetBrains Mono"
  wget -q -N https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/Ligatures/Light/complete/JetBrains%20Mono%20Nerd%20Font%20Complete%20Mono%20Light.ttf -P ~/.fonts/
  _process "  → Installing Hack"
  wget -q -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf -P ~/.fonts/
  _process "  → Installing Roboto Mono"
  wget -q -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/complete/Roboto%20Mono%20Nerd%20Font%20Complete.ttf -P ~/.fonts/
  _process "  → Installing DejaVu Sans Mono"
  wget -q -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf -P ~/.fonts/

  fc-cache -fv ~/.fonts > /dev/null
  [[ $? ]] && _success "Installed Nerd Fonts 🤓 "
}

install_gotop() {
  _process "→ Installing gotop"

  if command -v gotop > /dev/null; then
    _success "gotop already installed"
    return 0;
  fi

  if command -v go > /dev/null; then
    _process "  → Installing from source"
    go get github.com/cjbassi/gotop
  else
    _process "  → Installing prebuilt binary"
    git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop
    /tmp/gotop/scripts/download.sh
    sudo mv /tmp/gotop/gotop /usr/local/bin/
  fi

  if command -v gotop > /dev/null; then
    _success "gotop installed successfully"
  else
    _warning "Failed to install gotop"
  fi
}

install_node() {
  if [ "$INSTALL_NODE" = false ]; then
    _process "→ I"
    return 0;
  else
    _process "→ Installing node stuff"
  fi

  _process "  → Installing nvm"
  if ! command -v nvm > /dev/null; then
    export NVM_DIR="$HOME/.nvm" && (
      [ ! -d "${NVM_DIR}" ] && git clone --quiet https://github.com/nvm-sh/nvm.git "$NVM_DIR"
      cd "$NVM_DIR"
      git checkout --quiet `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    ) && \. "$NVM_DIR/nvm.sh"

    source ~/.nvm/nvm.sh > /dev/null
  fi
  
  if ! command -v node > /dev/null; then
    _process "  → Installing node"
    nvm install node > /dev/null
  fi

  if ! command -v yarn > /dev/null; then _process "  → Installing yarn"
    npm install --quiet -g yarn > /dev/null
  fi

  _success "Installed node"
}

function install_ruby() {
  _process "→ Installing Ruby"

  case "${package_manager}" in
    apt-get)
      sudo apt-get install -y ruby-full >> "$LOG" 2>&1
      ;;
    dnf)
      sudo dnf install -y ruby >> "$LOG" 2>&1
      ;;
    pacman)
      sudo pacman -S --noconfirm ruby >> "$LOG" 2>&1
      ;;
    zypper)
      sudo zypper install -y ruby >> "$LOG" 2>&1
      ;;
    pkg)
      pkg install -y ruby >> "$LOG" 2>&1
      ;;
    apk)
      apk add --no-cache ruby >> "$LOG" 2>&1
      ;;
    *)
      _warning "Unsupported package manager. Please install Ruby manually"
      return 1
      ;;
  esac

  _success "Ruby installation completed."
}

install_go() {
  if [ "$INSTALL_GO" = false ]; then
    _process "→ Skipping Go installation"
    return 0;
  else
    _process "→ Installing Go and related tools"
  fi

  _process "  → Installing gvm"
  if ! command -v gvm > /dev/null; then
    bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer) >> "$LOG" 2>&1
    source "$HOME/.gvm/scripts/gvm"
  fi
  
  if ! command -v go > /dev/null; then
    _process "  → Installing Go"
    gvm install go1.x -B >> "$LOG" 2>&1
    gvm use go1.x --default >> "$LOG" 2>&1
  fi

  _success "Installed Go"
}

function install_python3_venv() {
  _process "Installing Python3 venv"

  case "${package_manager}" in
    apt-get)
      sudo apt-get install -y python3-venv >> "$LOG" 2>&1
      ;;
    dnf)
      sudo dnf install -y python3-virtualenv >> "$LOG" 2>&1
      ;;
    pacman)
      sudo pacman -S --noconfirm python-virtualenv >> "$LOG" 2>&1
      ;;
    zypper)
      sudo zypper install -y python3-virtualenv >> "$LOG" 2>&1
      ;;
    pkg)
      pkg install -y py37-virtualenv >> "$LOG" 2>&1
      ;;
    apk)
      apk add --no-cache py3-virtualenv >> "$LOG" 2>&1
      ;;
    *)
      _warning "Unsupported package manager. Please install Python3 venv manually"
      return 1
      ;;
  esac

  _success "Python3 venv installation completed."
}
