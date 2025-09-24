return {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        require("catppuccin").setup({
            flavour = "frappe",
            integrations = {
                gitsigns = true,
                treesitter = true,
            },
        })

        vim.cmd.colorscheme "catppuccin"
    end,
}
