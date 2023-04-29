
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
