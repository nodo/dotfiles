require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "go",
    "ruby",
    "yaml",
    "json",
    "lua",
    "vim",
    "bash",
    "dockerfile",
  },
  highlight = {
    enable = true,
  },
}
