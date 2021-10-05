call plug#begin('~/.nvim/plugged')

Plug 'gruvbox-community/gruvbox'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-commentary'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'folke/trouble.nvim'

call plug#end()

" === colorscheme config
" silent! is to allow the installation of all plugings using `nvim +PlugInstall +qa`
silent! colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'medium'

let mapleader = " "

" LSP Installer
silent! lua << EOF
  local function setup_servers()
    require'lspinstall'.setup()
    local servers = require'lspinstall'.installed_servers()
    for _, server in pairs(servers) do
      require'lspconfig'[server].setup{}
    end
  end

  setup_servers()

  -- automatically setup servers again after `:LspInstall <server>`
  require'lspinstall'.post_install_hook = function ()
    setup_servers() -- makes sure the new server is setup in lspconfig
    vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
  end
EOF

" === LSP
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> ] <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> [ <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

silent! lua << EOF
  -- Taken from https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports
  function goimports(timeout_ms)
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if not result or next(result) == nil then return end
    local actions = result[1].result
    if not actions then return end
    local action = actions[1]

    -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
    -- is a CodeAction, it can have either an edit, a command or both. Edits
    -- should be executed first.
    if action.edit or type(action.command) == "table" then
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit)
      end
      if type(action.command) == "table" then
        vim.lsp.buf.execute_command(action.command)
      end
    else
      vim.lsp.buf.execute_command(action)
    end
  end
EOF

autocmd BufWritePre *.go lua goimports(1000)
autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 100)

" === tree-sitter
silent! lua << EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = "all",
  ignore_install = { "haskell" },
  highlight = {
    enable = true,
  },
  matchup = {
    enable = true,
  },
}
EOF

" configure nvcode-color-schemes
let g:nvcode_termcolors=256

" === gitsigns
silent! lua << EOF
require('gitsigns').setup {}
EOF

" === telescope
silent! lua << EOF
local actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
      n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      }
    }
  }
}
EOF

nnoremap <c-p> <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>


" === nvimtree
" https://github.com/kyazdani42/nvim-tree.lua
let g:nvim_tree_ignore = [ '.git' ]
let g:nvim_tree_gitignore = 1
let g:nvim_tree_disable_default_keybindings = 1

silent! lua << EOF
require('nvim-tree').setup {}
EOF

silent! lua <<EOF
    local tree_cb = require('nvim-tree.config').nvim_tree_callback
    vim.g.nvim_tree_bindings = {
      { key = "<CR>",  cb = tree_cb("edit") },
      { key = "<C-v>", cb = tree_cb("vsplit") },
      { key = "<C-x>", cb = tree_cb("split") },
      { key = "P",     cb = tree_cb("parent_node") },
      { key = "<",     cb = tree_cb("prev_sibling") },
      { key = ">",     cb = tree_cb("next_sibling") },
      { key = "<Tab>", cb = tree_cb("preview") },
      { key = "I",     cb = tree_cb("toggle_ignored") },
      { key = "H",     cb = tree_cb("toggle_dotfiles") },
      { key = "R",     cb = tree_cb("refresh") },
      { key = "a",     cb = tree_cb("create") },
      { key = "d",     cb = tree_cb("remove") },
      { key = "r",     cb = tree_cb("rename") },
      { key = "<C-r>", cb = tree_cb("full_rename") },
      { key = "y",     cb = tree_cb("copy_name") },
      { key = "Y",     cb = tree_cb("copy_absolute_path") },
      { key = "q",     cb = tree_cb("close") },
      { key = "g?",    cb = tree_cb("toggle_help") },
    }
EOF

nnoremap \  :NvimTreeToggle<cr>
nnoremap \| :NvimTreeFindFile<cr>

silent! lua << EOF
  require("trouble").setup {}
EOF

nnoremap <leader>xx <cmd>TroubleToggle<cr>

silent! lua << EOF
  function setup_lsp_diags()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics,
      {
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
      }
    )
  end
  setup_lsp_diags()
EOF

" === Mappings
noremap <c-g> <esc>
inoremap <c-g> <esc>
inoremap <c-f> <esc>la
inoremap <c-b> <esc>i
inoremap <c-a> <esc>^i
inoremap <c-e> <esc>g_a

inoremap jk <esc>
nnoremap <silent> <BS> :noh<cr>

" === Misc

set termguicolors
set colorcolumn=100
set relativenumber
set numberwidth=4
set nowrap
set cursorline
set expandtab
set clipboard+=unnamedplus

syntax on

