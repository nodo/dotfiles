return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'monsonjeremy/onedark.nvim'

  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        renderer = {
          special_files = {},
        },
      })
    end
  }

  use 'tpope/vim-commentary'

  use 'tpope/vim-fugitive'

  use 'ntpeters/vim-better-whitespace'

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        sections = {
          lualine_c = {},
          lualine_x = { 'filetype' },
        }
      })
    end
  }

  use {
     'nvim-treesitter/nvim-treesitter',
     run = ':TSUpdate',
  }
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  use 'neovim/nvim-lspconfig'

  use 'williamboman/nvim-lsp-installer'

  use {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup {}
    end
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup()
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            }
          }
        }
      }
    end
  }
end)
