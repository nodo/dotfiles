.PHONY: help install test _brew _link _tmux _zsh

help:
	@echo "Available targets:"
	@echo "  install  - Run full setup"
	@echo "  test     - Run tests in Docker (Linux)"
	@echo ""
	@echo "Private targets:"
	@echo "  _brew    - Install Homebrew and packages"
	@echo "  _link    - Symlink dotfiles and configs"
	@echo "  _tmux    - Install tmux plugins"
	@echo "  _zsh     - Set default shell to zsh"

install:
	./script/setup

test:
	./script/test.sh

_brew:
	./script/brew

_link:
	./script/link

_tmux:
	./script/tmux

_zsh:
	./script/zsh
