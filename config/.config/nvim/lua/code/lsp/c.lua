vim.lsp.enable("clangd", {
	capabilities = capabilities,
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=never",
		"--completion-style=detailed",
		"--offset-encoding=utf-16",
	},
	filetypes = {
		"c",
		"cpp",
	},
})
