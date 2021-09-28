PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
PATH=$HOME/bin:$PATH
export PATH

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

alias dotfiles='cd /workspaces/.codespaces/.persistedshare/dotfiles'

[ -s "$HOME/.bashrc" ] && source "$HOME/.bashrc"
