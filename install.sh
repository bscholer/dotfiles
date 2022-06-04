#!/usr/bin/env bash
LOG="${HOME}/Library/Logs/dotfiles.log"
GITHUB_USER="bscholer"
GITHUB_REPO="dotfiles"
USER_GIT_AUTHOR_NAME="Ben Scholer"
USER_GIT_AUTHOR_EMAIL="benscholer3248511@gmail.com"
DIR="/usr/local/opt/${GITHUB_REPO}"
PROGRAMS=("git" "zsh" "vim" "sl" "trash-cli" "ruby-full" "build-essential" "fontconfig" "htop") # passwd, which provides chsh intentionally left out

mkdir -p "${LOG%/*}" && touch "$LOG"

_process() {
  echo "$(date) PROCESSING:  $@" >> $LOG
  printf "$(tput setaf 6) %s...$(tput sgr0)\n" "$@"
}

_success() {
  local message=$@
  printf "%s✓ Success:%s\n" "$(tput setaf 2)" "$(tput sgr0) $message"
}

_warning() {
  echo "$(date) WARNING:  $@" >> $LOG
  printf "$(tput setaf 3)⚠ Warning:$(tput sgr0) %s!\n" "$@"
}

_finish() {
  echo "🎉 Installation complete! Enjoy the terminal! 🎉"
}

install_curl_wget() {
  _process "→ Installing curl and wget" 
  if sudo apt-get install -y curl wget > /dev/null || sudo pacman -S curl wget > /dev/null || sudo dnf install -y curl wget > /dev/null || sudo yum install -y curl wget > /dev/null || sudo brew install curl wget > /dev/null || pkg install curl wget > /dev/null ; then
    _success "Installed curl and wget"
  else
    _warning "Please install the following packages first, then try again: curl wget \n" && exit
  fi
}

install_zsh_git() {
  if command -v apt-get &> /dev/null; then
    _process "→ Updating packages"
    sudo apt-get update > /dev/null && sudo apt-get upgrade -y > /dev/null
  fi
  if command -v dnf &> /dev/null; then
    _process "→ Updating packages"
    sudo dnf update > /dev/null 
  fi

  if sudo apt-get install -y "${PROGRAMS[@]}" > /dev/null || sudo pacman -S "${PROGRAMS[@]}" > /dev/null || sudo dnf install -y "${PROGRAMS[@]}" > /dev/null || sudo yum install -y "${PROGRAMS[@]}" > /dev/null || sudo brew install "${PROGRAMS[@]}" > /dev/null || pkg install "${PROGRAMS[@]}" > /dev/null ; then
    _success "Installed ${PROGRAMS[@]}"
  else
    _warning "Please install the following packages first, then try again: ${PROGRAMS[@]} \n" && exit
  fi
}

install_ohmyzsh() {
  _process "→ Installing oh-my-zsh"
  if [ -d ~/.oh-my-zsh ]; then
    _success "Installed oh-my-zsh"
  else
    git clone --quiet --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
  fi

  # double check it got installed
  if [ -d ~/.oh-my-zsh ]; then
    _success "Installed oh-my-zsh"
  fi
}

install_zsh_plugins() {
  _process "→ Installing zsh plugins"

  _process "  → Installing zsh-autosuggestions"
  if [ -d ~/.config/ezsh/oh-my-zsh/plugins/zsh-autosuggestions ]; then
    cd ~/.config/ezsh/oh-my-zsh/plugins/zsh-autosuggestions && git pull --quiet
  else
    git clone --quiet --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.config/ezsh/oh-my-zsh/plugins/zsh-autosuggestions
  fi

  _process "  → Installing zsh-syntax-highlighting"
  if [ -d ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    cd ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git pull --quiet
  else
    git clone --quiet --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  fi

  _process "  → Installing zsh-completions"
  if [ -d ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-completions ]; then
    cd ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-completions && git pull --quiet
  else
    git clone --quiet --depth=1 https://github.com/zsh-users/zsh-completions ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-completions
  fi

  _process "  → Installing zsh-history-substring-search"
  if [ -d ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-history-substring-search ]; then
    cd ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-history-substring-search && git pull --quiet
  else
    git clone --quiet --depth=1 https://github.com/zsh-users/zsh-history-substring-search ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-history-substring-search
  fi
  _success "Installed zsh plugins"
}

install_colorls() {  
  sudo gem install colorls > /dev/null
  _success "Installed colorls"
}

install_fonts() {
  _process "→ Installing Nerd Fonts 🤓"

  _process "  → Installing Hack"
  wget -q -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf -P ~/.fonts/
  _process "  → Installing Roboto Mono"
  wget -q -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/complete/Roboto%20Mono%20Nerd%20Font%20Complete.ttf -P ~/.fonts/
  _process "  → Installing DejaVu Sans Mono"
  wget -q -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf -P ~/.fonts/

  fc-cache -fv ~/.fonts > /dev/null
  _success "Installed Nerd Fonts"
}

install_powerlevel10k() {
  _process "→ Installing ⚡ powerlevel10k"
  if [ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]; then
    cd ~/.oh-my-zsh/custom/themes/powerlevel10k && git pull --quiet
  else
    git clone --quiet --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  fi
}

install_node() {
  _process "→ Installing node"
  if ! command -v nvm &> /dev/null; then
    _process "  → Installing nvm"
    curl -s -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.3/install.sh &> /dev/null | bash &> /dev/null
    source ~/.nvm/nvm.sh &> /dev/null

    _process "  → Installing node"
    nvm install node &> /dev/null

    _process "  → Installing yarn"
    npm install --quiet -g yarn &> /dev/null

    [[ $? ]] && _success "Installed nvm, node, and npm"
  fi
}

install_vim_plugins() {
  _process "→ Installing vim plugins (this may take some time)"
  _process "  → Installing vundle"
  git clone --quiet https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

  _process "  → Installing vim plugins"
  vim +PluginInstall +qall &> /dev/null

  _process "  → Installing CoC.vim"
  cd ~/.vim/bundle/coc.nvim && yarn install --silent &> /dev/null && yarn build --silent &> /dev/null

  [[ $? ]] && _success "Installed vim plugins"
}

setup_git_authorship() {
  GIT_AUTHOR_NAME=$(git config --global user.name)
  GIT_AUTHOR_EMAIL=$(git config --global user.email)

  if [[ ! -z "$GIT_AUTHOR_NAME" ]]; then
    _process "→ Setting up Git author"

    read USER_GIT_AUTHOR_NAME
    if [[ ! -z "$USER_GIT_AUTHOR_NAME" ]]; then
      GIT_AUTHOR_NAME="${USER_GIT_AUTHOR_NAME}"
      $(git config --global user.name "$GIT_AUTHOR_NAME")
    else
      _warning "No Git user name has been set.  Please update manually"
    fi

    read USER_GIT_AUTHOR_EMAIL
    if [[ ! -z "$USER_GIT_AUTHOR_EMAIL" ]]; then
      GIT_AUTHOR_EMAIL="${USER_GIT_AUTHOR_EMAIL}"
      $(git config --global user.email "$GIT_AUTHOR_EMAIL")
    else
      _warning "No Git user email has been set.  Please update manually"
    fi
  else
    _process "→ Git author already set, moving on..."
  fi
}

generate_ssh_key() {
  _process "→ Seting up SSH keys"
  mkdir -p ~/.ssh

  if [ ! -f "~/.ssh/id_ed25519.pub" ]; then
    _process "  → Generating SSH keys"
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "${USER_GIT_AUTHOR_EMAIL}" -q -N ""
  else
    _process "  → SSH key already exists"
  fi

  _process "  → Start ssh-agent"
  eval "$(ssh-agent -s)" > /dev/null

  _process "  → Add SSH key to ssh-agent"
  ssh-add ~/.ssh/id_ed25519 &> /dev/null

  printf "\r\nCopy and add the following SSH key to GitHub (https://github.com/settings/keys):"
  cat ~/.ssh/id_ed25519.pub

  echo ""
}

download_dotfiles() {
  _process "→ Installing dotfiles"

  _process "  → Cloining repository"
  git clone --quiet https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git "${DIR}"

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

    # Set variable for list of files
    files="${DIR}/opt/files"

    # Store IFS separator within a temp variable
    OIFS=$IFS
    # Set the separator to a carriage return & a new line break
    # read in passed-in file and store as an array
    IFS=$'\r\n'
    links=($(cat "${files}"))

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
	# Create symbolic link
	ln -fs "${DIR}/${file[0]}" "${HOME}/${file[1]}"
      done
      # set separater back to carriage return & new line break
      IFS=$'\r\n'
    done

    # Reset IFS back
    IFS=$OIFS

    [[ $? ]] && _success "All files have been copied"
  fi
}

set_default_shell() {
  _process "→ Changing shell to zsh"
  if command -v chsh &> /dev/null; then
    if chsh -s $(which zsh); then
      _success "Changed shell"
    else
      _warning "Something went wrong changing shells"
    fi
  else
    echo "zsh" >> ~/.bashrc
    _warning "chsh not found, appending to ~/.bashrc"
  fi
}


install() {
  install_curl_wget
  install_zsh_git
  install_ohmyzsh
  install_zsh_plugins

  install_colorls
  install_node

  install_fonts
  install_powerlevel10k

  download_dotfiles
  link_dotfiles

  install_vim_plugins

  #install_crontab
  setup_git_authorship
  generate_ssh_key
  set_default_shell

  _finish

  cd ~
  zsh
}

install
