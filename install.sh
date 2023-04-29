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

download_and_source_scripts() {
  local script_base_url="https://raw.githubusercontent.com/bscholer/dotfiles/master/components"
  
  _process "Fetching installer script files list from the repository..."
  local installer_scripts=$(curl -s "${script_base_url}" | grep -Po '(?<=href=")[^"]*(?=")')
  
  # Create a temporary directory to store the scripts
  local temp_dir=$(mktemp -d)
  
  _process "Downloading and sourcing script files in temporary directory..."
  for script_name in ${installer_scripts}; do
    _process "  → Downloading and sourcing ${script_name}"
    wget --quiet -O "${temp_dir}/${script_name}" "${script_base_url}/${script_name}"
    source "${temp_dir}/${script_name}"
  done
  
  # Remove the temporary directory
  rm -r "${temp_dir}"
}

install() {
  _intro

  download_and_source_scripts

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
