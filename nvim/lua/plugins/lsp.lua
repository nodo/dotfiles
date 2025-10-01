local servers = {}

servers["lua_ls"] = {}

if vim.fn.executable("go") == 1 then
    servers["gopls"] = {}
end

if vim.fn.executable("ruby") == 1 then
    servers["sorbet"] = {}
end

if vim.fn.executable("node") == 1 then
    servers["copilot"] = {}
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
            for server_name, settings in pairs(servers) do
                vim.lsp.config[server_name] = settings
                vim.lsp.enable(server_name)
            end

            -- the default keymaps still applies like K, these are the extra bindings
            vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>", { desc = "[G]oto [D]efinition" })
            vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>", { desc = "[G]oto [R]eferences" })
            vim.keymap.set("n", "ge", ":Telescope diagnostics<CR>", { desc = "[G]oto [E]rrors" })
        end,
    },
}
