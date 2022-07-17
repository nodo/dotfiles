local go = {}

function go.setup()
  vim.bo.shiftwidth = 4
  vim.bo.tabstop = 4
  vim.bo.softtabstop = 4
  vim.bo.expandtab = false
end

-- From https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
function go.import(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

function go.format()
  vim.lsp.buf.formatting()
  go.import(1000)
end

local go_group = vim.api.nvim_create_augroup("go_group", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  group = go_group,
  callback = go.format,
})

vim.api.nvim_create_autocmd( "FileType", {
  pattern = "go",
  group = go_group,
  callback = go.setup,
})
