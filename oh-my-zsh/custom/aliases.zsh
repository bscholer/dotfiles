alias c='clear; ls; echo "\r"'   # Clear terminal screen
alias sd='sudo shutdown now'     # Shutdown computer now
alias sdr='sudo shutdown -r now' # Restart computer now
alias nuke='rm -rf . -i'         # Delete all files/directories in a directory
alias rc='vim ~/.zshrc'          # Open ~/.zshrc for editing
alias vrc='vim ~/.vimrc'         # Open ~/.vimrc for editing
alias src='source ~/.zshrc'      # Source ~/.zshrc
alias open='xdg-open'            # Open a file using xdg-open

# Git aliases
function lazygit() {             # A function to add, commit, and push all at once.
    git add .
    git commit -a -m "$1"
    git push
}
function chpwd() {               # Runs everytime you change directories
	clear
    ls
    echo "\r"
}
alias grm='git stash; git stash clear'		# Clears out any unwanted changes
alias ga='git add .' # Adds changed files
alias gc='git commit -m' # Commits, expects commit message in double quotes
alias gps='git push' # Pushes commit(s)
alias gpl='git pull' # Pulls changes
alias gm='git merge' # Merges two branches
function gmmd() {# Merges a branch (argument 1) into master
	git checkout master
	git merge master "$1"
	git branch -D "$1"
	git push --set-upstream origin master
}
alias gb='git branch'
alias gck='git checkout'
alias gbd='git branch -D'


alias rm='trash'                           # Remove using sudo and opions -r and -f
alias i="sudo dnf install"                 # Install a package
alias red="sudo redshift &"                # Start redshift in the background
alias e="vim"                              # Open a file in vim
alias sp="ssh bscholer@data.cs.purdue.edu" # ssh into data server at Purdue
alias smc="ssh root@198.211.102.183"       # ssh into minecraft server at DigitalOcean
alias sms="ssh root@159.203.168.38"        # ssh into minecraft server at DigitalOcean
alias spl="ssh pi@plexPi.local"     # ssh into Plex server
alias rmo="rm -f *.orig"                   # Delete original files created by astyle
alias fix="sed -i ';' *.*"                 # replaces symlink with actual file
alias minecraft="java -jar ~/Minecraft.jar"

alias \$=''

eval $(thefuck --alias)
