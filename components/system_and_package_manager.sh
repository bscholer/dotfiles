#!/bin/bash
# this file contains functions, designed to be used by other scripts

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
  _info "Updating package manager"

  case "$(package_manager)" in
    apt-get)
      _process "Updating apt-get package manager"
      sudo apt-get update -y >> "$LOG" 2>&1
      _success "Updated apt-get package manager"
      ;;
    dnf)
      _process "Updating dnf package manager"
      sudo dnf update -y >> "$LOG" 2>&1
      _success "Updated dnf package manager"
      ;;
    yum)
      _process "Updating yum package manager"
      sudo yum update -y >> "$LOG" 2>&1
      _success "Updated yum package manager"
      ;;
    pacman)
      _process "Updating pacman package manager"
      sudo pacman -Sy >> "$LOG" 2>&1
      _success "Updated pacman package manager"
      ;;
    zypper)
      _process "Updating zypper package manager"
      sudo zypper refresh >> "$LOG" 2>&1
      _success "Updated zypper package manager"
      ;;
    pkg)
      _process "Updating pkg package manager"
      pkg update >> "$LOG" 2>&1
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

  _process "Installing dependencies using $package_manager"

  case "$package_manager" in
    apt-get)
      _process "Installing required dependencies using apt-get package manager"
      sudo apt-get install -y "${REQUIRED_PROGRAMS[@]}" >> "$LOG" 2>&1
      if [[ $? -eq 0 ]]; then
        _success "Installed required dependencies using apt-get package manager"
      else
        _warning "Failed to install some required dependencies using apt-get package manager"
      fi
      _process "Installing optional dependencies using apt-get package manager"
      sudo apt-get install -y "${OPTIONAL_PROGRAMS[@]}" >> "$LOG" 2>&1
      if [[ $? -eq 0 ]]; then
        _success "Installed optional dependencies using apt-get package manager"
      else
        _warning "Failed to install some optional dependencies using apt-get package manager"
      fi
      ;;
    pacman)
      _process "Installing required dependencies using pacman package manager"
      sudo pacman -S "${REQUIRED_PROGRAMS[@]}" --noconfirm >> "$LOG" 2>&1
      if [[ $? -eq 0 ]]; then
        _success "Installed required dependencies using pacman package manager"
      else
        _warning "Failed to install some required dependencies using pacman package manager"
      fi
      _process "Installing optional dependencies using pacman package manager"
      sudo pacman -S "${OPTIONAL_PROGRAMS[@]}" --noconfirm >> "$LOG" 2>&1
      if [[ $? -eq 0 ]]; then
        _success "Installed optional dependencies using pacman package manager"
      else
        _warning "Failed to install some optional dependencies using pacman package manager"
      fi
      ;;
    dnf)
      _process "Installing required dependencies using dnf package manager"
      sudo dnf install -y "${REQUIRED_PROGRAMS[@]}" >> "$LOG" 2>&1
      if [[ $? -eq 0 ]]; then
        _success "Installed required dependencies using dnf package manager"
      else
        _warning "Failed to install some required dependencies using dnf package manager"
      fi
      _process "Installing optional dependencies using dnf package manager"
      sudo dnf install -y "${OPTIONAL_PROGRAMS[@]}" >> "$LOG" 2>&1
      if [[ $? -eq 0 ]]; then
        _success "Installed optional dependencies using dnf package manager"
      else
        _warning "Failed to install some optional dependencies using dnf package manager"
      fi
      ;;
    yum)
      _process "Installing required dependencies using yum package manager"
      sudo yum install -y "${REQUIRED_PROGRAMS[@]}" >> "$LOG" 2>&1
      if [[ $? -eq 0 ]]; then
        _success "Installed required dependencies using yum package manager"
      else
        _warning "Failed to install some required dependencies using yum package manager"
      fi
      _process "Installing optional dependencies using yum package manager"
      sudo yum install -y "${OPTIONAL_PROGRAMS[@]}" >> "$LOG" 2>&1
      if [[ $? -eq 0 ]]; then
        _success "Installed optional dependencies using yum package manager"
      else
        _warning "Failed to install some optional dependencies using yum package manager"
      fi
      ;;
    brew)
      _process "Installing required dependencies using brew package manager"
      brew install "${REQUIRED_PROGRAMS[@]}" >> "$LOG" 2>&1
      if [[ $? -eq 0 ]]; then
        _success "Installed required dependencies using brew package manager"
      else
        _warning "Failed to install some required dependencies using brew package manager"
      fi
      _process "Installing optional dependencies using brew package manager"
      brew install "${OPTIONAL_PROGRAMS[@]}" >> "$LOG" 2>&1
      if [[ $? -eq 0 ]]; then
        _success "Installed optional dependencies using brew package manager"
      else
        _warning "Failed to install some optional dependencies using brew package manager"
      fi
      ;;
    pkg)
      _process "Installing required dependencies using pkg package manager"
      sudo pkg install -y "${REQUIRED_PROGRAMS[@]}" >> "$LOG" 2>&1
      if [[ $? -eq 0 ]]; then
        _success "Installed required dependencies using pkg package manager"
      else
        _warning "Failed to install some required dependencies using pkg package manager"
      fi
      _process "Installing optional dependencies using pkg package manager"
      sudo pkg install -y "${OPTIONAL_PROGRAMS[@]}" >> "$LOG" 2>&1
      if [[ $? -eq 0 ]]; then
        _success "Installed optional dependencies using pkg package manager"
      else
        _warning "Failed to install some optional dependencies using pkg package manager"
      fi
      ;;
    *)
      _warning "No supported package manager found. Please install one and try again"
      exit 1
      ;;
  esac

  if [[ $? -eq 0 ]]; then
    _success "Installed: ${REQUIRED_PROGRAMS[@]}"
    _success "Installed: ${OPTIONAL_PROGRAMS[@]}"
  else
    _warning "Please install the following packages first, then try again: ${REQUIRED_PROGRAMS[@]} \n" && exit
  fi
}
