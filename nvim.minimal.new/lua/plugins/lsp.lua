local servers = {}

servers["lua_ls"] = {}

if vim.fn.executable("go") == 1 then
	servers["gopls"] = {}
end

if vim.fn.executable("ruby") == 1 then
	servers["sorbet"] = {}
	servers["ruby_lsp"] = {}
end

local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]definition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("ge", require("telescope.builtin").diagnostics, "[G]oto [E]rrors")
end

return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		priority = 20,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		priority = 20,
		opts = {
			ensure_installed = vim.tbl_keys(servers),
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		priority = 20,
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local lspconfig = require("lspconfig")
			for server_name, settings in pairs(servers) do
				lspconfig[server_name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = settings,
					filetypes = (servers[server_name] or {}).filetypes,
				})
			end
		end,
	},
}
