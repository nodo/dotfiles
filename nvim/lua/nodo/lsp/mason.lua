local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
  return
end

local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then
  return
end

local lspconfig = require("lspconfig")

mason.setup {
	ui = {
		border = "none",
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

local servers = {
  -- "bashls",
  -- "gopls",
  -- "jsonls",
  -- "solargraph",
  -- "sumneko_lua",
  -- "yamlls",
}

mason_lspconfig.setup({
	ensure_installed = servers,
	automatic_installation = true,
})


local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("nodo.lsp.handlers").on_attach,
		capabilities = require("nodo.lsp.handlers").capabilities,
	}

	local require_ok, conf_opts = pcall(require, "nodo.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	lspconfig[server].setup(opts)
end
