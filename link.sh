#/bin/bash

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
	# bakcup
	cp -L "${HOME}/${file[1]}" "${DIR}/backup/${file[1]}"
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

link_dotfiles
