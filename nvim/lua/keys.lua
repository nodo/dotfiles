vim.keymap.set("n", "<BS>", ":noh<CR>", {})

-- copy relative path
vim.keymap.set("n", "<leader>yr", function()
	vim.fn.setreg("+", "@" .. vim.fn.expand("%") .. ":" .. vim.fn.line("."))
end, { desc = "Copy file:line to clipboard" })
vim.keymap.set("v", "<leader>yr", function()
	vim.fn.setreg("+", "@" .. vim.fn.expand("%") .. ":" .. vim.fn.line("'<") .. "-" .. vim.fn.line("'>"))
end, { desc = "Copy file:line range to clipboard" })

-- copy absolute path
vim.keymap.set("n", "<leader>ya", function()
	vim.fn.setreg("+", "@" .. vim.fn.expand("%:p") .. ":" .. vim.fn.line("."))
end, { desc = "Copy absolute file:line to clipboard" })
vim.keymap.set("v", "<leader>ya", function()
	vim.fn.setreg("+", "@" .. vim.fn.expand("%:p") .. ":" .. vim.fn.line("'<") .. "-" .. vim.fn.line("'>"))
end, { desc = "Copy absolute file:line range to clipboard" })
