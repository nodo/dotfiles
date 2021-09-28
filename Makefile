DOTFILES := bash_profile ripgreprc
BREWFILE := Brewfile
HOMEBREW_LOCATION := /home/linuxbrew/.linuxbrew/bin/
APT_PACKAGES := build-essential

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

.PHONY: vim-plug
vim-plug:
	curl --silent -fLo ${HOME}/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

.PHONY: nvim
nvim: vim-plug
	mkdir -p ~/.config/nvim
	ln -fs $(PWD)/nvim/init.vim ~/.config/nvim/init.vim
	/home/linuxbrew/.linuxbrew/bin/nvim +PlugInstall +qa

.PHONY: $(APT_PACKAGES)
$(APT_PACKAGES):
	sudo apt-get install -y $@

.PHONY: $(DOTFILES)
install: $(DOTFILES) $(APT_PACKAGES) brew-bundle nvim
