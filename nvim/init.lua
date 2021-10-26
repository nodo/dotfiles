require 'plugins'
require 'lsp'
require 'treesitter'

-- colortheme
require('onedark').setup()

-- leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Options
vim.o.number = true
vim.o.colorcolumn = '100'
vim.o.expandtab = true
vim.o.termguicolors = true
vim.o.signcolumn = 'yes'
vim.o.showmode = false
vim.o.wrap = false
vim.o.mouse = 'a'
vim.o.updatetime = 250
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.clipboard = vim.o.clipboard .. 'unnamedplus'

-- folding options using tree-sitter
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldlevelstart = 99 -- start with all folds open

local opts = { noremap=true, silent=true }

-- General key mappings
vim.api.nvim_set_keymap('n', '<BS>', ':noh<CR>', opts)
vim.api.nvim_set_keymap('i', '<c-f>', '<esc>la', opts)
vim.api.nvim_set_keymap('i', '<c-b>', '<esc>i', opts)
vim.api.nvim_set_keymap('i', '<c-a>', '<esc>^i', opts)
vim.api.nvim_set_keymap('i', '<c-e>', '<esc>g_a', opts)

-- Window movement
vim.api.nvim_set_keymap('n', '<c-h>', '<c-w>h', opts)
vim.api.nvim_set_keymap('n', '<c-j>', '<c-w>j', opts)
vim.api.nvim_set_keymap('n', '<c-k>', '<c-w>k', opts)
vim.api.nvim_set_keymap('n', '<c-l>', '<c-w>l', opts)

-- NvimTree
vim.api.nvim_set_keymap('n', '\\', ':NvimTreeToggle<CR>', opts)
vim.api.nvim_set_keymap('n', '|', ':NvimTreeFindFileToggle<CR>', opts)
vim.g.nvim_tree_special_files = {}

-- Telescope
vim.api.nvim_set_keymap('n', '<c-p>', ':Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<c-g>', ':Telescope live_grep<CR>', opts)

-- Other useful mappings available by default
-- <Leader>hb : toggle blame on the current line (via GitSigns)

-- TODO
-- * auto-formatting / auto-import for gopls
-- * treesitter mappings

