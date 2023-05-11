#!/bin/bash

function install_neovim() {
  # Check if Neovim is already installed globally
  if command -v nvim &> /dev/null; then
    _info "Neovim is already installed globally."
  else
    _process "→ Installing Neovim globally from source"
  fi

  # Install necessary dependencies (Debian/Ubuntu)
  sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl >> "$LOG" 2>&1

  # Clone Neovim repository into a temporary directory
  temp_dir=$(mktemp -d)
  git clone https://github.com/neovim/neovim.git "$temp_dir" >> "$LOG" 2>&1
  cd "$temp_dir"

  # Checkout the master branch and build
  git checkout master >> "$LOG" 2>&1
  make CMAKE_BUILD_TYPE=RelWithDebInfo >> "$LOG" 2>&1

  # Install Neovim
  sudo make install >> "$LOG" 2>&1

  # Clean up
  cd -
  rm -rf "$temp_dir"

  _success "Neovim installed or updated globally from the master branch."
}

function install_nvchad() {
  _process "→ Setting up Neovim with NvChad"

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
    _info "NvChad is already installed. Skipping the installation"
    return 1
  fi

  # Check if the ~/.config/nvim directory exists and is not empty
  if [ -d ~/.config/nvim ] && [ "$(ls -A ~/.config/nvim)" ]; then
    _warning "The ~/.config/nvim directory already exists and is not empty. Please remove or move it before running this function"
    return 1
  fi

  # Install NvChad
  _process "→ Installing NvChad"
  git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

  _success "Neovim setup with NvChad completed"
}

function run_mason_install_all() {
  # Check if Neovim is installed
  if ! command -v nvim &> /dev/null; then
    _warning "Neovim is not installed. Please install Neovim first."
    return 1
  fi

  _process "→ Running MasonInstallAll in Neovim"

  # Run the MasonInstallAll command and quit Neovim
  if ! nvim +MasonInstallAll +q; then
    _warning "Failed to run MasonInstallAll in Neovim. Please check your Neovim configuration."
    return 1
  fi

  _success "MasonInstallAll successfully executed in Neovim."
}

function run_lazy_install() {
  # Check if Neovim is installed
  if ! command -v nvim &> /dev/null; then
    _warning "Neovim is not installed. Please install Neovim first."
    return 1
  fi

  _process "→ Running Lazy install in Neovim"

  # Run the MasonInstallAll command and quit Neovim
  if ! nvim +"Lazy install" +q; then
    _warning "Failed to run Lazy install in Neovim. Please check your Neovim configuration."
    return 1
  fi

  _success "Lazy install successfully executed in Neovim."
}
