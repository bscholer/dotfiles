#!/usr/bin/env bash
LOG="${HOME}/Library/Logs/dotfiles.log"
GITHUB_USER="bscholer"
GITHUB_REPO="dotfiles"
USER_GIT_AUTHOR_NAME="Ben Scholer"
USER_GIT_AUTHOR_EMAIL="benscholer3248511@gmail.com"
DIR="/usr/local/opt/${GITHUB_REPO}"
PROGRAMS=("git" "zsh" "vim" "sl" "trash-cli" "ruby-full" "build-essential" "fontconfig")

mkdir -p "${LOG%/*}" && touch "$LOG"

_process() {
    echo "$(date) PROCESSING:  $@" >> $LOG
    printf "$(tput setaf 6) %s...$(tput sgr0)\n" "$@"
}

_success() {
  local message=$@
  printf "%s✓ Success:%s\n" "$(tput setaf 2)" "$(tput sgr0) $message"
}

install_curl_wget() {
  _process "→ Installing curl and wget" 
  if command -v curl &> /dev/null && command -v wget &> /dev/null; then
    echo -e "curl and wget are already installed\n"
  else
    if sudo apt-get install -y curl wget > /dev/null || sudo pacman -S curl wget > /dev/null || sudo dnf install -y curl wget > /dev/null || sudo yum install -y curl wget > /dev/null || sudo brew install curl wget > /dev/null || pkg install curl wget > /dev/null ; then
      echo -e "curl and wget Installed\n"
    else
      echo -e "Please install the following packages first, then try again: curl wget \n" && exit
    fi
  fi
}


install_zsh_git() {
  if command -v apt-get &> /dev/null; then
    _process "→ Updating apt"
    sudo apt-get update > /dev/null && sudo apt-get upgrade -y > /dev/null
  fi
  if command -v dnf &> /dev/null; then
    _process "→ Updating dnf"
    sudo dnf update > /dev/null 
  fi

  if sudo apt-get install -y "${PROGRAMS[@]}" > /dev/null || sudo pacman -S "${PROGRAMS[@]}" > /dev/null || sudo dnf install -y "${PROGRAMS[@]}" > /dev/null || sudo yum install -y "${PROGRAMS[@]}" > /dev/null || sudo brew install "${PROGRAMS[@]}" > /dev/null || pkg install "${PROGRAMS[@]}" > /dev/null ; then
    echo -e "${PROGRAMS[@]}"
    _success "${PROGRAMS[@]} Installed"
  else
    echo -e "Please install the following packages first, then try again: ${PROGRAMS[@]} \n" && exit
  fi
}

install_ohmyzsh() {
  _process "→ Installing oh-my-zsh"
  if [ -d ~/.oh-my-zsh ]; then
    _success "oh-my-zsh is already installed"
  else
    git clone --quiet --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
  fi

  # double check it got installed
  if [ -d ~/.oh-my-zsh ]; then
    _success "oh-my-zsh Installed"
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
  _process "→ Installing Nerd Fonts version of Hack, Roboto Mono, DejaVu Sans Mono"

  wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf -P ~/.fonts/
  wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/complete/Roboto%20Mono%20Nerd%20Font%20Complete.ttf -P ~/.fonts/
  wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf -P ~/.fonts/

  fc-cache -fv ~/.fonts
  _success "Installed Nerd Fonts"
}

install_powerlevel10k() {
  _process "→ Installing powerlevel10k"
  if [ -d ~/.config/ezsh/oh-my-zsh/custom/themes/powerlevel10k ]; then
    cd ~/.config/ezsh/oh-my-zsh/custom/themes/powerlevel10k && git pull --quiet
  else
    git clone --quiet --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/ezsh/oh-my-zsh/custom/themes/powerlevel10k
  fi
}

install_node() {
  if ! type -P 'npm' &> /dev/null; then
    _process "→ Installing node"

    curl https://www.npmjs.org/install.sh | sh

    [[ $? ]] \
    && _success "node and npm Installed"
  fi
}

setup_git_authorship() {
  GIT_AUTHOR_NAME=eval "git config user.name"
  GIT_AUTHOR_EMAIL=eval "git config user.email"

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

download_dotfiles() {
    _process "→ Creating directory at ${DIR} and setting permissions"
    mkdir -p "${DIR}"

    _process "→ Downloading repository to /tmp directory"
    curl -#fLo /tmp/${GITHUB_REPO}.tar.gz "https://github.com/${GITHUB_USER}/${GITHUB_REPO}/tarball/master"

    _process "→ Extracting files to ${DIR}"
    tar -zxf /tmp/${GITHUB_REPO}.tar.gz --strip-components 1 -C "${DIR}"

    _process "→ Removing tarball from /tmp directory"
    rm -rf /tmp/${GITHUB_REPO}.tar.gz

    _process "→ Cloining repository"

    [[ $? ]] && _success "${DIR} created, repository downloaded and extracted"

    # Change to the dotfiles directory
    cd "${DIR}"
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
                _process "→ Linking ${links[$index]}"
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

        source "${HOME}/.bash_profile"
        [[ $? ]] && _success "All files have been copied"
    fi
}

install() {
  link_dotfiles
  install_zsh_git
  install_ohmyzsh
  install_zsh_plugins

  install_colorls
  install_node

  install_fonts
  install_powerlevel10k <--- copy setup too

  install_curl_wget
  download_dotfiles

  #install_crontab
  #install_vim_plugins
  setup_git_authorship
  #generate_ssh_key
}

install
