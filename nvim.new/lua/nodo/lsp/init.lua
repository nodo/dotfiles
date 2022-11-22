local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "nodo.lsp.mason"
require("nodo.lsp.handlers").setup()
