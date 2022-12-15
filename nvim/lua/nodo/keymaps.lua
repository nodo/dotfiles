function Keymap(mode, key, effect)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap(mode, key, effect, opts)
end

--Remap space as leader key
Keymap("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
-- Better window navigation
Keymap("n", "<C-h>", "<C-w>h")
Keymap("n", "<C-j>", "<C-w>j")
Keymap("n", "<C-k>", "<C-w>k")
Keymap("n", "<C-l>", "<C-w>l")

-- Resize with arrows
Keymap("n", "<C-Up>", ":resize -2<CR>")
Keymap("n", "<C-Down>", ":resize +2<CR>")
Keymap("n", "<C-Left>", ":vertical resize -2<CR>")
Keymap("n", "<C-Right>", ":vertical resize +2<CR>")

-- Navigate buffers
Keymap("n", "<S-l>", ":bnext<CR>")
Keymap("n", "<S-h>", ":bprevious<CR>")

-- Move text up and down
Keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi")
Keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi")

-- No highlights
Keymap('n', '<BS>', ':noh<CR>')

-- Insert --
Keymap("i", "<C-f>", "<esc>la")
Keymap("i", "<C-b>", "<esc>i")
Keymap("i", "<C-a>", "<esc>^i")
Keymap("i", "<C-e>", "<esc>g_a")

-- Visual --
-- Stay in indent mode
Keymap("v", "<", "<gv")
Keymap("v", ">", ">gv")

-- Visual Block --
-- Move text up and down
Keymap("x", "J", ":move '>+1<CR>gv-gv")
Keymap("x", "K", ":move '<-2<CR>gv-gv")
