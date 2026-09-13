export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
ENABLE_CORRECTION="false"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

# -------
# Aliases
# -------
alias l="ls" # List files in current directory
alias ll="ls -al" # List all files in current directory in long list format
alias o="open ." # Open the current directory in Finder
alias venvc='uv venv'
alias venva='source .venv/bin/activate'
 
# ----------------------
# Functions
# ----------------------
function py() {
    uv run $1
}

# ----------------------
# Git Aliases
# ----------------------
alias gaa='git add .'
alias gcm='git commit -m'
alias gpsh='git push'
alias gss='git status -s'

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=("$HOME/.docker/completions" $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
export PATH="$HOME/.local/bin:$PATH"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
