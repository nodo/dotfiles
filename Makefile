DOTFILES := bash_profile ripgreprc tmux.conf
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
	ln -fs $(PWD)/$@ ${HOME}/.$@

.PHONY: nvim
nvim:
	ln -fs $(PWD)/nvim ${HOME}/.config/nvim
	nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

.PHONY: $(APT_PACKAGES)
$(APT_PACKAGES):
	sudo apt-get install -y $@

.PHONY: $(DOTFILES)
install: $(DOTFILES) $(APT_PACKAGES) brew-bundle nvim
