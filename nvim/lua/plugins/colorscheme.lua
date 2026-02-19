return {
    "catppuccin/nvim",
    lazy = false,     -- load at startup
    priority = 1000,  -- load as early as possible
    opts = {},
    config = function()
        require("catppuccin").setup({
            flavour = "macchiato",
            integrations = {
                gitsigns = true,
                treesitter = true,
            },
        })

        vim.cmd.colorscheme "catppuccin"
    end,
}
