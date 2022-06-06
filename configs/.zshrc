# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


if [ -d "/usr/local/opt/dotfiles" ]; then
  $(/usr/local/opt/dotfiles/update.sh)
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

source $ZSH/oh-my-zsh.sh

EDITOR='vim'

DISABLE_UPDATE_PROMPT="true"

plugins=(git z zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search zsh-completions extract catimg docker aws)

unsetopt complete_aliases

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

#alias c='clear; ls; echo "\r";'   # Clear terminal screen
alias c='clear'                  # Clear terminal screen
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
  git commit --quiet -a -m "$1"
  git push --quiet && printf "%s✓ Pushed successfully!%s\n" "$(tput setaf 2)" "$(tput sgr0)"
}

alias lg='lazygit'               # Because I'm really lazy

alias rm='trash'                 # Remove using sudo and opions -r and -f
alias i="sudo apt install"       # Install a package
alias v="vim"                    # Open a file in vim
alias d="sudo docker"            # Docker
alias d="sudo docker-compose"    # Docker compose

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export LIBGL_ALWAYS_INDIRECT=1

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# colors!!
if [ -x "$(command -v colorls)" ]; then
    alias ls="colorls --almost-all"
    alias la="colorls -al"
fi
