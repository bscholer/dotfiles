# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#if [ -d "/usr/local/opt/dotfiles" ]; then
  #$(/usr/local/opt/dotfiles/update.sh)
#fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

source $ZSH/oh-my-zsh.sh

EDITOR='nvim'

DISABLE_UPDATE_PROMPT="true"

plugins=(git z zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search zsh-completions extract catimg docker aws)

unsetopt complete_aliases

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^I'   complete-word       # tab          | complete
bindkey '^[[Z' autosuggest-accept  # shift + tab  | autosuggest

#alias c='clear; ls; echo "\r";'   # Clear terminal screen
alias c='clear'                  # Clear terminal screen
alias sd='sudo shutdown now'     # Shutdown computer now
alias sdr='sudo shutdown -r now' # Restart computer now
alias nuke='rm -rf * -i'         # Delete all files/directories in a directory
alias rc='nvim ~/.zshrc'         # Open ~/.zshrc for editing
# alias vrc='nvim ~/.vimrc'         # Open ~/.vimrc for editing
alias src='source ~/.zshrc'      # Source ~/.zshrc
alias top='gotop'                # top but better
alias p='python3'                # yeah
alias py='python3'               # you know it
alias pip='pip3'                 # yep
# alias a='ai ask'                 # ai is not fun it is painful why are regression transformers in here
alias ga='find . -type f -name "*.tif" -exec gdaladdo -r average {} 2 4 8 16 \;'


# Spotify
alias sp='spt'
alias spl='spt playback --like'
alias spn='spt playback --next'
alias spp='spt playback --previous'

# Git aliases
# qg for quickgit
function qg() {             # A function to add, commit, and push all at once.
  git pull
  git add .
  git commit --quiet -a -m "$1"
  git push --quiet && printf "%s✓ Pushed successfully!%s\n" "$(tput setaf 2)" "$(tput sgr0)"
}
alias gl='lazygit'
alias g='git'                    # git is too long
alias gsu='git submodule update --remote --merge'
alias gcp='git cherry-pick'
alias gr='git revert'

function mkpr() {
  set -euo pipefail
  # Prompt for JIRA ticket number (optional).
  read -r -p "Enter JIRA ticket number (just number for default PROC-, leave blank to skip): " ticket
  # Prompt for the PR title.
  read -r -p "Enter PR title: " prTitle
  # Build title and story section only if ticket was provided.
  if [[ -n "$ticket" ]]; then
    # normalize to full ticket prefix if needed
    if [[ "$ticket" == *"-"* ]]; then
      ticketId="$ticket"
    else
      ticketId="PROC-$ticket"
    fi

    title="[$ticketId] $prTitle"
    story="# Story
https://dronedeploy.atlassian.net/browse/$ticketId

"
  else
    title="$prTitle"
    story=""
  fi

  # Always have a Work Done section.
  body="${story}# Work Done
- "
  # Create the draft PR and open it.
  gh pr create --title "$title" --body "$body" --draft
  gh pr view --web
}

alias rm='trash'                 # Remove using sudo and opions -r and -f
alias v="nvim"                    # Open a file in nvim
alias d="docker"            # Docker
alias dc="docker-compose"   # Docker compose
alias dl="lazydocker"       # lazydocker

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [ -n "$DISPLAY" ]; then
  export DISPLAY=:0
fi

export LIBGL_ALWAYS_INDIRECT=1

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# colors!!
if [ -x "$(command -v colorls)" ]; then
  alias ls="colorls --almost-all"
  alias la="colorls -al"
fi

# Load in some local settings if they exist
if [ -f ~/.zshrc-local ]; then
  source ~/.zshrc-local
fi

export PATH=$PATH:/home/bscholer/.spicetify

export MANPAGER="vim -M +MANPAGER - "

