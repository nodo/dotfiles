#!/bin/bash

set -euo pipefail

# install packages
sudo apt-get update
sudo apt-get install -y \
	build-essential \
	curl \
	zsh

# link configuration files
files=(
	"ripgreprc"
	"gitconfig"
	"tmux.conf"
	"zshrc"
)
for file in ${files[@]}; do
	ln -fs ${PWD}/config/${file} ${HOME}/.${file}
done

# starship config file
curl -sS https://starship.rs/install.sh | sh
mkdir -p ${HOME}/.config
starship preset pure-preset -o ${HOME}/.config/starship.toml

# zsh
sudo chsh -s $(which zsh)
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh
