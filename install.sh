#!/usr/bin/env bash
LOG="${HOME}/logs/dotfile-installer.log"
GITHUB_USER="bscholer"
GITHUB_REPO="dotfiles"
USER_GIT_AUTHOR_NAME="Ben Scholer"
USER_GIT_AUTHOR_EMAIL="github@benscholer.com"
DIR="${HOME}/.dotfiles"
PROGRAMS=("git" "zsh" "vim" "sl" "trash-cli" "fontconfig" "htop" "curl" "wget" "ripgrep" "python3-venv")
INSTALL_NODE=true
package_manager=""

export TERM=${TERM:-xterm-256color}

for var in "$@"
do
  if [ "$var" = "--no-node" ]; then
    INSTALL_NODE=false
    _info "Skipping Node Installation"
  fi
done

mkdir -p "${LOG%/*}" && touch "$LOG"

_intro() {
  echo "🐧 ******** bscholer terminal setup script ******** 🐧"
  echo ""
}

_info() {
  echo "$(date) INFO:  $@" >> $LOG
  printf "$(tput setaf 4)%s...$(tput sgr0)\n" "$@"
}

_process() {
  echo "$(date) PROCESSING:  $@" >> $LOG
  printf "$(tput setaf 6)%s...$(tput sgr0)\n" "$@"
}

_success() {
  local message=$@
  printf "%s✓ Success: %s%s\n" "$(tput setaf 2)" "$message" "$(tput sgr0)"
}

_warning() {
  echo "$(date) WARNING:  $@" >> $LOG
  printf "$(tput setaf 3)⚠ Warning:$(tput sgr0) %s!\n" "$@"
}

_finish() {
  echo ""
  echo "🎉 Installation complete! Enjoy the terminal! 🎉"
}

detect_package_manager() {
  if command -v apt-get &> /dev/null; then
    echo "apt-get"
  elif command -v pacman &> /dev/null; then
    echo "pacman"
  elif command -v dnf &> /dev/null; then
    echo "dnf"
  elif command -v yum &> /dev/null; then
    echo "yum"
  elif command -v brew &> /dev/null; then
    echo "brew"
  elif command -v pkg &> /dev/null; then
    echo "pkg"
  else
    _warning "No supported package manager found. Please install one and try again"
    exit 1
  fi
}

update_package_manager() {
  _info "Updating package manager..."

  case "$(package_manager)" in
    apt-get)
      _process "Updating apt-get package manager"
      sudo apt-get update -y >> $LOG 2>&1
      _success "Updated apt-get package manager"
      ;;
    dnf)
      _process "Updating dnf package manager"
      sudo dnf update -y >> $LOG 2>&1
      _success "Updated dnf package manager"
      ;;
    yum)
      _process "Updating yum package manager"
      sudo yum update -y >> $LOG 2>&1
      _success "Updated yum package manager"
      ;;
    pacman)
      _process "Updating pacman package manager"
      sudo pacman -Sy >> $LOG 2>&1
      _success "Updated pacman package manager"
      ;;
    zypper)
      _process "Updating zypper package manager"
      sudo zypper refresh >> $LOG 2>&1
      _success "Updated zypper package manager"
      ;;
    pkg)
      _process "Updating pkg package manager"
      pkg update >> $LOG 2>&1
      _success "Updated pkg package manager"
      ;;
    *)
      _warning "Unsupported package manager. Skipping update."
      ;;
  esac
}

install_programs() {
  local package_manager="$(detect_package_manager)"
  if [[ -z "$package_manager" ]]; then
    _warning "No supported package manager found. Please install one and try again"
    exit 1
  fi

  _process "Installing dependencies using $package_manager..."

  case "$package_manager" in
    apt-get)
      _process "Installing dependencies using apt-get package manager"
      sudo apt-get install -y "${PROGRAMS[@]}" >> $LOG 2>&1
      ;;
    pacman)
      _process "Installing dependencies using pacman package manager"
      sudo pacman -S "${PROGRAMS[@]}" --noconfirm >> $LOG 2>&1
      ;;
    dnf)
      _process "Installing dependencies using dnf package manager"
      sudo dnf install -y "${PROGRAMS[@]}" >> $LOG 2>&1
      ;;
    yum)
      _process "Installing dependencies using yum package manager"
      sudo yum install -y "${PROGRAMS[@]}" >> $LOG 2>&1
      ;;
    brew)
      _process "Installing dependencies using brew package manager"
      brew install "${PROGRAMS[@]}" >> $LOG 2>&1
      ;;
    pkg)
      _process "Installing dependencies using pkg package manager"
      sudo pkg install -y "${PROGRAMS[@]}" >> $LOG 2>&1
      ;;
    *)
      _warning "No supported package manager found. Please install one and try again"
      exit 1
      ;;
  esac

  if [[ $? -eq 0 ]]; then
    _success "Installed: ${PROGRAMS[@]}"
  else
    _warning "Please install the following packages first, then try again: ${PROGRAMS[@]} \n" && exit
  fi
}

install_ohmyzsh() {
  _process "→ Installing oh-my-zsh"
  if [ -d ~/.oh-my-zsh ]; then
    _success "oh-my-zsh already installed"
  else
    git clone --quiet --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    [[ $? ]] && _success "Installed oh-my-zsh"
  fi
}

install_zsh_plugins() {
  _process "→ Installing zsh plugins"

  _process "  → Installing zsh-autosuggestions"
  if [ -d ~/.oh-my-zsh/plugins/zsh-autosuggestions ]; then
    cd ~/.oh-my-zsh/plugins/zsh-autosuggestions && git pull --quiet
  else
    git clone --quiet --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
  fi

  _process "  → Installing zsh-syntax-highlighting"
  if [ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    cd ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git pull --quiet
  else
    git clone --quiet --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  fi

  _process "  → Installing zsh-completions"
  if [ -d ~/.oh-my-zsh/custom/plugins/zsh-completions ]; then
    cd ~/.oh-my-zsh/custom/plugins/zsh-completions && git pull --quiet
  else
    git clone --quiet --depth=1 https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
  fi

  _process "  → Installing zsh-history-substring-search"
  if [ -d ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search ]; then
    cd ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search && git pull --quiet
  else
    git clone --quiet --depth=1 https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search
  fi

  _success "Installed zsh plugins"
}

function install_neovim_globally() {
  # Check if Neovim is already installed globally
  if command -v nvim &> /dev/null; then
    _warning "Neovim is already installed globally."
    return 0
  fi

  _process "Installing Neovim globally using AppImage..."

  # Download the AppImage
  curl -sSLO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage

  # Make the AppImage executable
  chmod u+x nvim.appimage

  # Test running the AppImage
  if ! ./nvim.appimage --version &> /dev/null; then
    _warning "Running nvim.appimage directly failed. Attempting to extract and run..."
    ./nvim.appimage --appimage-extract &> /dev/null 2>&1
    if ! ./squashfs-root/AppRun --version &> /dev/null; then
      _warning "Failed to run Neovim after extraction. Aborting installation."
      return 1
    fi
  fi

  # Expose Neovim globally
  sudo mv squashfs-root / &> /dev/null 2>&1
  sudo ln -s /squashfs-root/AppRun /usr/bin/nvim &> /dev/null 2>&1

  _success "Neovim installed globally."
}

install_colorls() {  
  sudo gem install colorls > /dev/null
  _success "Installed colorls"
}

install_lazygit() {
  _process "→ Installing lazygit"

  case "$package_manager" in
    apt-get)
      temp_dir=$(mktemp -d)

      LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*' 2>/dev/null)
      curl -sLo "${temp_dir}/lazygit.tar.gz" "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
      tar xf "${temp_dir}/lazygit.tar.gz" -C "${temp_dir}" lazygit >> $LOG 2>&1
      sudo install "${temp_dir}/lazygit" /usr/local/bin >> $LOG 2>&1

      rm -rf "${temp_dir}"
      ;;
    dnf)
      sudo dnf copr enable atim/lazygit -y >> $LOG 2>&1
      sudo dnf install lazygit >> $LOG 2>&1
      ;;
    pacman)
      sudo pacman -S lazygit >> $LOG 2>&1
      ;;
    brew)
      brew install jesseduffield/lazygit/lazygit >> $LOG 2>&1
      ;;
    port)
      sudo port install lazygit >> $LOG 2>&1
      ;;
    xbps)
      sudo xbps-install -S lazygit >> $LOG 2>&1
      ;;
    scoop)
      scoop bucket add extras >> $LOG 2>&1
      scoop install lazygit >> $LOG 2>&1
      ;;
    go)
      go install github.com/jesseduffield/lazygit@latest >> $LOG 2>&1
      ;;
    choco)
      choco install lazygit >> $LOG 2>&1
      ;;
    conda)
      conda install -c conda-forge lazygit >> $LOG 2>&1
      ;;
    emerge)
      sudo emerge dev-vcs/lazygit >> $LOG 2>&1
      ;;
    pkg)
      pkg install lazygit >> $LOG 2>&1
      ;;
    *)
      _warning "Unsupported package manager. Please install lazygit manually"
      ;;
  esac

  _success "Installed lazygit"
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

install_powerlevel10k() {
  _process "→ Installing ⚡ powerlevel10k"
  if [ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ] && [ -d ~/powerlevel10k ]; then
    cd ~/powerlevel10k && git pull --quiet
    [[ $? ]] && _success "Updated ⚡ powerlevel10k"
  else
    git clone --quiet --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    [[ $? ]] && _success "Installed ⚡ powerlevel10k"
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
  _process "Installing Ruby..."

  case "${package_manager}" in
    apt-get)
      sudo apt-get install -y ruby-full >> $LOG 2>&1
      ;;
    dnf)
      sudo dnf install -y ruby >> $LOG 2>&1
      ;;
    pacman)
      sudo pacman -S --noconfirm ruby >> $LOG 2>&1
      ;;
    zypper)
      sudo zypper install -y ruby >> $LOG 2>&1
      ;;
    pkg)
      pkg install -y ruby >> $LOG 2>&1
      ;;
    apk)
      apk add --no-cache ruby >> $LOG 2>&1
      ;;
    *)
      _warning "Unsupported package manager. Please install Ruby manually"
      return 1
      ;;
  esac

  _success "Ruby installation completed."
}

function install_nvchad() {
  _process "Setting up Neovim with NvChad..."

  # Prerequisites
  if ! command -v nvim &> /dev/null; then
    _warning "Neovim not found. Please install Neovim globally before running this function"
    return 1
  fi

  if ! command -v git &> /dev/null; then
    _warning "Git not found. Please install Git before running this function"
    return 1
  fi

  # Check if NvChad is already installed
  if [ -e ~/.config/nvim/lua/custom/chadrc.lua ]; then
    _warning "NvChad is already installed. Skipping the installation"
    return 1
  fi

  # Check if the ~/.config/nvim directory exists and is not empty
  if [ -d ~/.config/nvim ] && [ "$(ls -A ~/.config/nvim)" ]; then
    _warning "The ~/.config/nvim directory already exists and is not empty. Please remove or move it before running this function"
    return 1
  fi

  # Install NvChad
  _process "Installing NvChad..."
  git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

  _process "Neovim setup with NvChad completed"
}

setup_git_authorship() {
  _process "→ Setting up Git author"
  git config --global user.email "$USER_GIT_AUTHOR_EMAIL"
  git config --global user.name "$USER_GIT_AUTHOR_NAME"

  [[ $? ]] && _success "Set Git author"
}

generate_ssh_key() {
  _process "→ Seting up SSH keys"
  mkdir -p ~/.ssh

  if [ ! -f ~/.ssh/id_ed25519.pub ]; then
    _process "  → Generating SSH keys"
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "${USER_GIT_AUTHOR_EMAIL}" -q -N ""

    _process "  → Starting ssh-agent"
    eval "$(ssh-agent -s)" > /dev/null

    _process "  → Adding SSH key to ssh-agent"
    ssh-add ~/.ssh/id_ed25519 > /dev/null

    printf "\r\nCopy and add the following SSH key to GitHub (https://github.com/settings/keys):\r\n"
    cat ~/.ssh/id_ed25519.pub

    echo ""
  else
    _process "  → SSH key already exists"
  fi
}

download_dotfiles() {
  _process "→ Installing dotfiles"

  _process "  → Cloining repository"
  if [ -d "${DIR}" ]; then
    cd "${DIR}" && git pull --quiet
  else
    git clone --quiet --depth=1 https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git "${DIR}"
  fi

  # Change to the dotfiles directory
  cd "${DIR}"

  _process "  → Switching remote to SSH"
  git remote set-url origin git@github.com:${GITHUB_USER}/${GITHUB_REPO}.git

  [[ $? ]] && _success "Repository downloaded"
}

link_dotfiles() {
  # symlink files to the HOME directory.
  if [[ -f "${DIR}/opt/files" ]]; then
    _process "→ Symlinking dotfiles in /configs"
    _info "  Backing up existing dotfiles to ${DIR}/backup"
    mkdir -p "${DIR}/backup"

    # Set variable for list of files
    files="${DIR}/opt/files"

    # Store IFS separator within a temp variable
    OIFS=$IFS
    # Set the separator to a carriage return & a new line break
    # read in passed-in file and store as an array
    IFS=$'\r\n'
    links=($(cat "${files}"))

    success=true

    # Loop through array of files
    for index in ${!links[*]}
    do
      for link in ${links[$index]}
      do
        _process "  → Linking ${links[$index]}"
        # set IFS back to space to split string on
        IFS=$' '
        # create an array of line items
        file=(${links[$index]})
        # Create backup directory if it doesn't exist
        mkdir -p "${DIR}/backup/$(dirname ${file[1]})"
        # Backup
        cp -L "${HOME}/${file[1]}" "${DIR}/backup/${file[1]}"
        # Create symbolic link
        ln -fs "${DIR}/${file[0]}" "${HOME}/${file[1]}"

        # Test if the symlink was created successfully
        if [[ ! -L "${HOME}/${file[1]}" || ! "$(readlink "${HOME}/${file[1]}")" == "${DIR}/${file[0]}" ]]; then
          success=false
          _warning "Failed to link ${links[$index]}"
        fi
      done
      # set separater back to carriage return & new line break
      IFS=$'\r\n'
    done

    # Reset IFS back
    IFS=$OIFS

    if $success; then
      _success "All files have been copied"
    else
      _warning "Some files failed to link"
    fi
  fi
}

set_default_shell() {
  _process "→ Checking default shell"
  if [[ $SHELL != *"zsh" ]]; then
    if command -v chsh > /dev/null; then
      if chsh -s $(which zsh); then
	_success "Changed shell"
      else
	_warning "Something went wrong changing shells"
      fi
    else
      echo "zsh" >> ~/.bashrc
      _warning "chsh not found, appending to ~/.bashrc"
    fi
  else
    _info "  Default shell already zsh"
  fi
}


install() {
  _intro

  package_manager=$(detect_package_manager)

  install_programs
  install_lazygit
  install_ohmyzsh
  install_zsh_plugins

  install_neovim_globally
  install_ruby
  install_nvchad

  install_colorls
  install_node

  install_fonts
  install_powerlevel10k

  download_dotfiles
  link_dotfiles

  #install_crontab
  setup_git_authorship
  generate_ssh_key
  set_default_shell

  _finish

  cd ~
  zsh
}

install
