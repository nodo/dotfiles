local servers = {}

servers["lua_ls"] = {}

if vim.fn.executable("go") == 1 then
	servers["gopls"] = {}
end

if vim.fn.executable("ruby") == 1 then
	servers["sorbet"] = {}
	servers["ruby_lsp"] = {}
end

return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			ensure_installed = vim.tbl_keys(servers),
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local lspconfig = require("lspconfig")
			for server_name, _ in pairs(servers) do
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end

			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "show info" })
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "[g]o to [d]definition" })
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "[g]o to [r]eferences" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[c]ode [a]ction" })
		end,
	},
}
