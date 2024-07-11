return {
	"catppuccin/nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		vim.cmd.colorscheme("catppuccin-frappe")
	end,
}
