GITHUB_USER="bscholer"
GITHUB_REPO="dotfiles"
DIR="/usr/local/opt/${GITHUB_REPO}"

_success() {
  local message=$@
  printf "%s✓ Success:%s\n" "$(tput setaf 2)" "$(tput sgr0) $message"
}

update_dotfiles () {
  if [ -d "${DIR}" ]; then
    $(cd "${DIR}" && git pull)
  fi
}

link_dotfiles() {
  # symlink files to the HOME directory.
  if [[ -f "${DIR}/opt/files" ]]; then
    #_process "→ Symlinking dotfiles in /configs"

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
	#_process "  → Linking ${links[$index]}"
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

    [[ $? ]] && _success "dotfiles updated"
  fi
}

update() {
  update_dotfiles
  link_dotfiles
}

update

