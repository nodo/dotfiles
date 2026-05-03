-- return {
--     "catppuccin/nvim",
--     lazy = false,     -- load at startup
--     priority = 1000,  -- load as early as possible
--     opts = {},
--     config = function()
--         require("catppuccin").setup({
--             flavour = "macchiato",
--             integrations = {
--                 gitsigns = true,
--                 treesitter = true,
--             },
--         })
--
--         vim.cmd.colorscheme "catppuccin-nvim"
--     end,
-- }
return {
      "sainnhe/gruvbox-material",
      lazy = false,
      priority = 1000,
      config = function()
            vim.g.gruvbox_material_background = "medium" -- "hard", "medium", "soft"
            vim.g.gruvbox_material_foreground = "mix"    -- "material", "mix", "original"
            vim.g.gruvbox_material_better_performance = 1
            vim.g.gruvbox_material_enable_italic = 1
            vim.cmd.colorscheme("gruvbox-material")
      end,
}
