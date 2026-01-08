return {
    "stevearc/conform.nvim",
    lazy = false,
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({ async = false })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    opts = {
        formatters_by_ft = {
            go = { "goimports" },
            ruby = { "rubocop" },
        },
    },
}
