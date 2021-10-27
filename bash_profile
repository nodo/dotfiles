PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
PATH=$HOME/bin:$PATH
export PATH

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export EDITOR=nvim

DOTFILES=/workspaces/.codespaces/.persistedshare/dotfiles
alias dotfiles='cd $DOTFILES'
alias vim=nvim

[ -s "$HOME/.bashrc" ] && source "$HOME/.bashrc"
