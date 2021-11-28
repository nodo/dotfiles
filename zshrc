export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="mrtazz"

source $ZSH/oh-my-zsh.sh

# Needed for codespaces
export SHELL=/bin/zsh

PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
PATH=$HOME/bin:$PATH
export PATH

# Go tools
export PATH="$HOME/go/bin:$PATH"
export GOPATH="$HOME/go"

# Custom binaries
export PATH="$HOME/bin:$PATH"

# Others
export EDITOR='nvim'
export GIT_OPEN='nvim'
export GITHUB_USER=nodo
export CGO_ENABLED=0
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Alias and helpers
alias k=kubectl
alias cat=bat
alias ls="ls --color=auto"
alias vim=nvim

DOTFILES=/workspaces/.codespaces/.persistedshare/dotfiles
alias dotfiles='cd $DOTFILES'

complete -F __start_kubectl k
