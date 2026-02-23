return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(args.match)
                if lang and require("nvim-treesitter.parsers")[lang] then
                    require("nvim-treesitter").install({ lang })
                    pcall(vim.treesitter.start)
                end
                vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                vim.wo[0][0].foldmethod = 'expr'
                vim.wo[0][0].foldlevel = 99
            end,
        })
    end,
}
