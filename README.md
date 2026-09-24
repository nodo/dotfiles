# dotfiles

## setup

```sh
curl https://mise.run | sh
git clone https://github.com/nodo/dotfiles.git ~/personal/dotfiles
cd ~/personal/dotfiles && mise trust && mise bootstrap
```

- `mise bootstrap --dry-run` preview changes
- `mise bootstrap status` inspect state
- `mise run test` run bootstrap in a Linux container

System packages and dotfiles live in `mise.toml`; CLI tools in `config/mise.toml` (linked as the global mise config).

## neovim keybindings

- `<leader>f` format

- `gd` go to definition
- `gr` go to references
- `ge` go to errors
- `gi` go to implementations

- `<leader>tt` run test
- `<leader>tT` run test file
- `<leader>ta` run test suite
- `<leader>tl` run last test
- `<leader>tg` visit test file

- `<leader><leader>` find files
- `<leader>,` find buffers
- `<leader>sg` search grep
- `<leader>sr` search resume
    - `c-k` quote string
    - `c-i` add "--iglob" to specify specific directories
    - `c-f` freeze the list and fuzzy find

- `<BS>` remove search highlight
- `<leader>yr` copy relative path with lines
- `<leader>ya` copy absolute path with lines
