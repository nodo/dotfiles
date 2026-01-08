return {
    "folke/snacks.nvim",
    lazy = false,    -- load at startup
    priority = 1000, -- load as early as possible
    opts = {
        indent = {
            enabled = true,
            animate = {
                enabled = false,
            },
        },
        dashboard = {
            sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
                { section = "startup" },
            },
        },
        statuscolumn = {
        },
    },
}
