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
