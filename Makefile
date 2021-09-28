DOTFILES := bash_profile ripgreprc
BREWFILE := Brewfile
HOMEBREW_LOCATION := /home/linuxbrew/.linuxbrew/bin/

$(HOMEBREW_LOCATION)/brew:
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o /tmp/install_homebrew.sh
	/bin/bash < /tmp/install_homebrew.sh

.PHONY: homebrew
homebrew: $(HOMEBREW_LOCATION)/brew

.PHONY: brew-bundle
brew-bundle: homebrew
	$(HOMEBREW_LOCATION)/brew bundle install --no-lock --file $(BREWFILE)

.PHONY: $(DOTFILES)
$(DOTFILES):
	ln -fs $(PWD)/$@ ~/.$@

.PHONY: nvim-plugins
nvim-plugins:
	sh -c 'curl -fLo ${HOME}/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	nvim +PlugInstall +qa

.PHONY: nvim
nvim: nvim-plugins
	mkdir -p ~/.config/nvim
	ln -fs $(PWD)/nvim/init.vim ~/.config/nvim/init.vim

.PHONY: $(DOTFILES)
install: $(DOTFILES) brew-bundle nvim
