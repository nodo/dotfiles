if vim.fn.executable("go") == 0 then
  return {}
end

return {
  { import = "lazyvim.plugins.extras.lang.go" },
}
