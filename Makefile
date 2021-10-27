DOTFILES := bash_profile ripgreprc tmux.conf
BREWFILE := Brewfile
HOMEBREW_LOCATION := /home/linuxbrew/.linuxbrew/bin
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

# Install packer.nvim
${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim:
	git clone --depth 1 https://github.com/wbthomason/packer.nvim $@

.PHONY: nvim
nvim: ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim
	mkdir -p ${HOME}/.config
	ln -fs $(PWD)/nvim ${HOME}/.config/nvim
	rm -rf ${HOME}/.config/nvim/plugin
	$(HOMEBREW_LOCATION)/nvim --headless -u ${HOME}/.config/nvim/lua/nodo/plugins.lua -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

.PHONY: $(APT_PACKAGES)
$(APT_PACKAGES):
	sudo apt-get install -y $@

.PHONY: $(DOTFILES)
install: $(DOTFILES) $(APT_PACKAGES) brew-bundle nvim
