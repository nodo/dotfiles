local lsp_installer = require("nvim-lsp-installer")

local on_attach = function(_, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<Up>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<Down>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

lsp_installer.on_server_ready(function(server)
    -- if server.name == "gopls" then
    -- end
    server:setup({
      on_attach = on_attach,
    })
    vim.cmd [[ do User LspAttachBuffers ]]
end)

local signs = {
  { prefix = "DiagnosticSign", values = { Error = "✖", Warn = " ", Hint = " ", Info = "ℹ" } },
  { prefix = "LspDiagnosticsSign", values = { Error = "✖", Warning = " ", Hint = " ", Information = "ℹ" } },
}
for _, data in ipairs(signs) do
  local prefix = data['prefix']
  local values = data['values']
  for sign_type, icon in pairs(values) do
    local hl = prefix .. sign_type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false, -- don't display text directly
  signs = true,
  underline = true,
  update_in_insert = false,
})

