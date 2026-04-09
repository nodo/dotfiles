return {
    dir = "/Users/nodo/work/entire/entire.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        require("entire").setup({})
        require("telescope").load_extension("entire")
        vim.keymap.set("n", "<leader>ec", ":Entire checkpoints<cr>", { desc = "entire checkpoints" })
    end,
}
