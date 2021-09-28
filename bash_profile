PATH=/home/linuxbrew/.linuxbrew/bin/:$PATH
PATH=$HOME/bin:$PATH

RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

export PATH RIPGREP_CONFIG_PATH

[ -s "$HOME/.bashrc" ] && source "$HOME/.bashrc"
