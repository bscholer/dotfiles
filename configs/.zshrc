# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH Performance tweaks
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Load only the essential plugins first
plugins=(git z)

source $ZSH/oh-my-zsh.sh

# Lazy load nvm
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  nvm "$@"
}
node() {
  unset -f node
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  node "$@"
}
npm() {
  unset -f npm
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  npm "$@"
}

# Lazy load additional plugins
source_if_exists() {
  [ -f "$1" ] && source "$1"
}

# Lazy load completion and syntax highlighting
source_if_exists ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source_if_exists ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source_if_exists ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source_if_exists ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions/zsh-completions.plugin.zsh

EDITOR='nvim'

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
alias ga='find . -type f -name "*.tif" -exec gdaladdo -r average {} 2 4 8 16 \;'

# Spotify
alias sp='spt'
alias spl='spt playback --like'
alias spn='spt playback --next'
alias spp='spt playback --previous'

# Git aliases
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
  # Check if gh command exists
  if ! command -v gh > /dev/null 2>&1; then
    echo "Error: GitHub CLI (gh) is not installed. Please install it first."
    return 1
  fi

  # Check if we're in a git repository
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not in a git repository."
    return 1
  fi

  # Check if we have any changes to commit
  if [[ -z "$(git status --porcelain)" ]]; then
    echo "Error: No changes to commit."
    return 1
  fi

  # Use read with timeout to prevent hanging
  local ticket=""
  local prTitle=""
  local REPLY=""
  
  echo -n "Enter JIRA ticket number (just number for default PROC-, leave blank to skip): "
  read ticket
  
  echo -n "Enter PR title: "
  read prTitle
  
  # Validate PR title is not empty
  if [[ -z "$prTitle" ]]; then
    echo "Error: PR title cannot be empty"
    return 1
  fi

  local title=""
  local story=""
  
  # Build the title and story
  if [[ -n "$ticket" ]]; then
    local ticketId=""
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

  local body="${story}# Work Done
- "

  # Create PR with error handling
  if ! gh pr create --title "$title" --body "$body" --draft; then
    echo "Error: Failed to create PR"
    return 1
  fi

  # Open PR in browser with error handling
  if ! gh pr view --web; then
    echo "Error: Failed to open PR in browser"
    return 1
  fi
}

alias rm='trash'                # Remove using sudo and opions -r and -f
alias v="nvim"                  # Open a file in nvim
alias d="docker"                # Docker
alias dc="docker-compose"       # Docker compose
alias dl="lazydocker"           # lazydocker

# Load theme after plugins
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [ -n "$DISPLAY" ]; then
  export DISPLAY=:0
fi

export LIBGL_ALWAYS_INDIRECT=1

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

