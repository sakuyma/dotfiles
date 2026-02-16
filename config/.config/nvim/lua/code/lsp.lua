vim.diagnostic.config({
	virtual_text = false,
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		source = "always",
		border = "rounded",
	},
	signs = true,
	signs = {
		text = {
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.ERROR] = "",
		},
	},
})

require("mason").setup({
	automatic_installation = true,
	ensure_installed = {
		-- LSP --
		"rust-analyzer",
		"clangd",
		"pyright",
		"lua_ls",
		-- Debugger
		"codelldb",

		-- Formatter
		"black", -- python
		"rustfmt", -- rust
		"clang-format", -- c like
		"stylua", -- lua

		-- Linter
		"ruff", -- python
		"clang-tidy", -- C/C++
		"luacheck", -- Lua
	},
	ui = {
		check_outdated_packages_on_open = true,
		border = "rounded",
		height = 0.75,
		width = 0.75,
		icons = require("icons").manager,
	},
})
local servers = {
	"rust",
	"lua",
	"python",
	"c",
}
for _, server in ipairs(servers) do
	require("code.lsp." .. server)
end
