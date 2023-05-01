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

function run_mason_install_all() {
  # Check if Neovim is installed
  if ! command -v nvim &> /dev/null; then
    _warning "Neovim is not installed. Please install Neovim first."
    return 1
  fi

  _process "Running MasonInstallAll in Neovim..."

  # Run the MasonInstallAll command and quit Neovim
  if ! nvim +MasonInstallAll +q; then
    _warning "Failed to run MasonInstallAll in Neovim. Please check your Neovim configuration."
    return 1
  fi

  _success "MasonInstallAll successfully executed in Neovim."
}

