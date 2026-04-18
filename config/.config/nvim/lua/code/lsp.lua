local mason_path = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_path .. ":" .. vim.env.PATH

-- Diagnostic config
vim.diagnostic.config({
	virtual_text = false,
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		source = "always",
		border = "rounded",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.ERROR] = "",
		},
	},
})

-- Completion setup
local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		completion = {
			border = "rounded",
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
			scrollbar = false,
		},
		documentation = {
			border = "rounded",
		},
	},
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text",
			maxwidth = 50,
			ellipsis_char = "...",
			before = function(entry, vim_item)
				vim_item.menu = ({
					nvim_lsp = "[LSP]",
					luasnip = "[Snip]",
					buffer = "[Buf]",
					path = "[Path]",
				})[entry.source.name]
				return vim_item
			end,
		}),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-c>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	}),
})

vim.opt.pumheight = 10

-- Mason setup
require("mason").setup({
	ui = {
		border = "rounded",
		height = 0.75,
		width = 0.75,
		icons = require("icons").manager,
	},
})
require("mason-lspconfig").setup({
    ensure_installed = {
        "pyright",
        "rust_analyzer",
        "lua_ls",
        "clangd",
        "marksman",
        "html",
        "jsonls",
        "cssls",
        "ltex",
    },
    automatic_installation = true,

})
-- Capabilities for cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local function has_cmd(cmd)
	return vim.fn.executable(cmd) == 1
end

-- Lsp setup
local lsp = vim.lsp

-- Pyright
if has_cmd("pyright-langserver") then
	vim.lsp.config["pyright"] = {
		cmd = { "pyright-langserver", "--stdio" },
		filetypes = { "python", "py" },
		root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "workspace",
					useLibraryCodeForTypes = true,
				},
			},
		},
		capabilities = capabilities,
	}
	lsp.enable("pyright")
end

-- Clangd
if has_cmd("clangd") then
	vim.lsp.config["clangd"] = {
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--header-insertion=never",
			"--completion-style=detailed",
		},
		filetypes = { "c", "cpp" },
		root_markers = { ".clangd", "compile_commands.json", ".git" },
		capabilities = capabilities,
	}
	lsp.enable("clangd")
end

-- Rust analyzer
if has_cmd("rust-analyzer") then
	vim.lsp.config["rust-analyzer"] = {
		cmd = { "rust-analyzer" },
		filetypes = { "rust" },
		root_markers = { "Cargo.toml", "rust-project.json", ".git" },
		settings = {
			["rust-analyzer"] = {
				checkOnSave = { command = "clippy" },
			},
		},
		capabilities = capabilities,
	}
	lsp.enable("rust-analyzer")
end

-- Lua
if has_cmd("lua-language-server") then
	vim.lsp.config["lua_ls"] = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = { ".luarc.json", ".luacheckrc", ".git" },
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = { enable = false },
				hint = { enable = true, semicolon = "Disable" },
				codeLens = { enable = true },
			},
		},
		capabilities = capabilities,
	}
    lsp.enable("lua_ls")
end

-- HTML
if has_cmd("vscode-html-language-server") then
	vim.lsp.config["html"] = {
		cmd = { "vscode-html-language-server", "--stdio" },
		filetypes = { "html" },
		root_markers = { "package.json", ".git" },
		init_options = {
			configurationSection = { "html", "css", "javascript" },
			embeddedLanguages = { css = true, javascript = true },
			provideFormatter = true,
		},
		capabilities = capabilities,
	}
    lsp.enable("html")
end

-- JSON
if has_cmd("vscode-json-language-server") then
	vim.lsp.config["jsonls"] = {
		cmd = { "vscode-json-language-server", "--stdio" },
		filetypes = { "json", "jsonc" },
		root_markers = { ".git" },
		init_options = { provideFormatter = true },
		capabilities = capabilities,
	}
    lsp.enable("jsonls")
end

-- CSS
if has_cmd("vscode-css-language-server") then
	vim.lsp.config["cssls"] = {
		cmd = { "vscode-css-language-server", "--stdio" },
		filetypes = { "css", "scss", "less" },
		root_markers = { "package.json", ".git" },
		settings = {
			css = { validate = true },
			less = { validate = true },
			scss = { validate = true },
		},
		init_options = { provideFormatter = true },
		capabilities = capabilities,
	}
    lsp.enable("cssls")
end

-- Marksman
if has_cmd("marksman") then
	vim.lsp.config["marksman"] = {
		cmd = { "marksman", "server" },
		filetypes = { "markdown" },
		root_markers = { ".marksman.toml", ".git" },
		capabilities = capabilities,
	}
    lsp.enable("marksman")
end

-- Grammarly
if has_cmd("grammarly-languageserver") then
	vim.lsp.config["grammarly"] = {
		cmd = { "grammarly-languageserver", "--stdio" },
		filetypes = { "markdown" },
		root_markers = { ".git" },
		init_options = {
			clientId = "client_BaDkMgx4X19X9UxxYRCXZo",
		},
		capabilities = capabilities,
	}
    lsp.enable("grammarly")
end

-- LTeX
if has_cmd("ltex-ls") then
	vim.lsp.config["ltex"] = {
		cmd = { "ltex-ls" },
		filetypes = { "markdown", "tex" },
		root_markers = { ".git" },
		settings = {
			ltex = {
				enabled = { "markdown", "tex" },
			},
		},
		capabilities = capabilities,
	}
    lsp.enable("ltex")
end

vim.lsp.enable(vim.tbl_keys(vim.lsp.config))

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			client.server_capabilities.progressProvider = false
		end
	end,
})

local original_notify = vim.notify
vim.notify = function(msg, level, opts)
	if level == vim.log.levels.ERROR then
		original_notify(msg, level, opts)
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>fgi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<leader>fgr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>frn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	end,
})
