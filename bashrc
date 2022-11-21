# Linuxbrew
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
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Aliases
alias k=kubectl
alias ls="ls --color=auto"
alias vim=nvim
alias dotfiles="cd /workspaces/.codespaces/.persistedshare/dotfiles"

eval "$(starship init bash)"
