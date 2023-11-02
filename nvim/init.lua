-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require('lazy').setup({
  'github/copilot.vim',

  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
})

-- Copilot
vim.keymap.set('i', '..', '<Plug>(copilot-next)')
vim.keymap.set('i', ',,', '<Plug>(copilot-previous)')

-- Colorscheme
vim.cmd.colorscheme "catppuccin-frappe"
