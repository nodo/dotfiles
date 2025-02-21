return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		{
			"nvim-telescope/telescope-live-grep-args.nvim",
			version = "^1.0.0",
		},

	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local lga_actions = require("telescope-live-grep-args.actions")

		telescope.setup({
			defaults = {
				layout_strategy = "vertical",
				layout_config = {
					mirror = true,
					prompt_position = "top",
				},
			},
			pickers = {
				find_files = {
					hidden = true,
				},
			},
			extensions = {
				live_grep_args = {
					auto_quoting = true,
					mappings = {
						i = {
							["<C-k>"] = lga_actions.quote_prompt(),
							["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
							-- freeze the current list and start a fuzzy search in the frozen list
							["<C-f>"] = actions.to_fuzzy_refine,
						},
					},
				},
			}
		})

		telescope.load_extension("fzf")
		telescope.load_extension("live_grep_args")

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>sg", require("telescope").extensions.live_grep_args.live_grep_args, { desc = "[s]earc [g]rep" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[s]earch [r]esume" })

		-- shorter versions
		vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "find files" })
		vim.keymap.set("n", "<leader>,", builtin.buffers, { desc = "find buffers" })
	end,
}
