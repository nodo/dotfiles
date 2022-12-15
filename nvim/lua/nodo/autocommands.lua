local go = require "nodo.languages.go"

local go_group = vim.api.nvim_create_augroup("go_group", { clear = true })
vim.api.nvim_create_autocmd( "FileType", {
  pattern = "go",
  group = go_group,
  callback = go.setup,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  group = go_group,
  callback = go.format,
})
