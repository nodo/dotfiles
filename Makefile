DOTFILES := bash_profile ripgreprc

.PHONY: $(DOTFILES)
$(DOTFILES):
	ln -fs $(PWD)/$@ ~/.$@

.PHONY: $(DOTFILES)
install: $(DOTFILES)
