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

.PHONY: $(DOTFILES)
install: $(DOTFILES) brew-bundle
