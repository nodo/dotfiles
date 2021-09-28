PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
PATH=$HOME/bin:$PATH
export PATH

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

DOTFILES=/workspaces/.codespaces/.persistedshare/dotfiles
alias dotfiles='cd $DOTFILES'

bash "$DOTFILES/hack/keep_alive.sh" &

[ -s "$HOME/.bashrc" ] && source "$HOME/.bashrc"
