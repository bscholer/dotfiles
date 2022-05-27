#!/bin/bash

echo "-------- Installing Packages --------"
apt-get update -y > /dev/null
apt-get upgrade -y > /dev/null
apt-get install -y zsh vim sl fonts-powerline git htop trash-cli curl -y > /dev/null

# Install oh-my-zsh
echo "-------- Installing oh-my-zsh --------"
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh > /dev/null
cp ~/.zshrc ~/.zshrc.orig
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
chsh -s $(which zsh)
echo "-------- oh-my-zsh Install Complete --------"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" > /dev/null

#Setup vim configuration
echo "-------- Configuring Vim --------"
cat <<EOT >> ~/.vimrc
imap jj <Esc>
set number
set cursorline
set nocompatible
set hidden
set wildmenu
set showcmd
set hlsearch
set ignorecase
set smartcase
set autoindent
set nostartofline
set confirm
set undolevels=1000
EOT
echo "-------- Vim Configuration Complete --------\r"

#Setup zsh
echo "-------- Configuring zsh --------"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k > /dev/null

THEME="powerlevel10k\/powerlevel10k"

sed -i s/^ZSH_THEME=".\+"$/ZSH_THEME=\"$THEME\"/g ~/.zshrc && echo "Edited line in ~/zshrc :" && cat ~/.zshrc | grep -m 1 ZSH_THEME

cat <<EOT >> ~/.zshrc
EDITOR='vim'

DISABLE_UPDATE_PROMPT="true"

plugins=(git, z, zsh-autosuggestions, zsh-syntax-highlighting, history-substring-search, extract, catimg, docker)

POWERLINE_RIGHT_A="$IP"
POWERLINE_PATH="short"
POWERLINE_DETECT_SSH="true"
POWERLEVEL10K_SHORTEN_DIR_LENGTH=1
POWERLEVEL10K_SHORTEN_DELIMITER=""
POWERLEVEL10K_SHORTEN_STRATEGY="truncate_from_right"

POWERLEVEL10K_LEFT_PROMPT_ELEMENTS=(status dir vcs)
POWERLEVEL10K_RIGHT_PROMPT_ELEMENTS=(context ram battery time ip)
POWERLEVEL10K_TIME_FORMAT="%D{%H:%M}"

POWERLEVEL10K_STATUS_OK_BACKGROUND='110'
POWERLEVEL10K_STATUS_OK_FOREGROUND='black'
POWERLEVEL10K_STATUS_ERROR_BACKGROUND='red'
POWERLEVEL10K_STATUS_ERROR_FOREGROUND='white'

POWERLEVEL10K_CONTEXT_DEFAULT_BACKGROUND='174'
POWERLEVEL10K_CONTEXT_DEFAULT_FOREGROUND='black'
POWERLEVEL10K_CONTEXT_ROOT_BACKGROUND='166'
POWERLEVEL10K_CONTEXT_ROOT_FOREGROUND='black'

POWERLEVEL10K_DIR_DEFAULT_BACKGROUND='166'
POWERLEVEL10K_DIR_DEFAULT_FOREGROUND='black'
POWERLEVEL10K_DIR_HOME_BACKGROUND='174'
POWERLEVEL10K_DIR_HOME_FOREGROUND='black'
POWERLEVEL10K_DIR_HOME_SUBFOLDER_BACKGROUND='174'
POWERLEVEL10K_DIR_HOME_SUBFOLDER_FOREGROUND='black'

POWERLEVEL10K_RAM_BACKGROUND='110'
POWERLEVEL10K_RAM_FOREGROUND='black'

POWERLEVEL10K_VCS_CLEAN_FOREGROUND='black'
POWERLEVEL10K_VCS_CLEAN_BACKGROUND='150'
POWERLEVEL10K_VCS_UNTRACKED_FOREGROUND='black'
POWERLEVEL10K_VCS_UNTRACKED_BACKGROUND='110'
POWERLEVEL10K_VCS_MODIFIED_FOREGROUND='black'
POWERLEVEL10K_VCS_MODIFIED_BACKGROUND='182'

POWERLEVEL10K_BATTERY_LOW_BACKGROUND='166'
POWERLEVEL10K_BATTERY_LOW_FOREGROUND='black'
POWERLEVEL10K_BATTERY_CHARGING_BACKGROUND='150'
POWERLEVEL10K_BATTERY_CHARGING_FOREGROUND='black'
POWERLEVEL10K_BATTERY_CHARGED_BACKGROUND='110'
POWERLEVEL10K_BATTERY_CHARGED_FOREGROUND='black'
POWERLEVEL10K_BATTERY_DISCONNECTED_BACKGROUND='150'
POWERLEVEL10K_BATTERY_DISCONNECTED_FOREGROUND='black'

POWERLEVEL10K_TIME_BACKGROUND='174'
POWERLEVEL10K_TIME_FOREGROUND='black'

POWERLEVEL10K_IP_BACKGROUND='182'
POWERLEVEL10K_IP_FOREGROUND='black'

POWERLEVEL10K_IP_INTERFACE='wlp2s0'


alias c='clear; ls; echo "\r";'   # Clear terminal screen
alias sd='sudo shutdown now'     # Shutdown computer now
alias sdr='sudo shutdown -r now' # Restart computer now
alias nuke='rm -rf * -i'         # Delete all files/directories in a directory
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

alias rm='trash'                           # Remove using sudo and opions -r and -f
alias i="sudo apt install"                 # Install a package
alias e="vim"                              # Open a file in vim

[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

EOT

echo "-------- zsh Configuration Complete --------"
echo

read -p "Setup with dev tools (node, python, docker)? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -
	apt-get install -y python3 nodejs docker
fi

echo "-------- SETUP COMPLETE --------"
