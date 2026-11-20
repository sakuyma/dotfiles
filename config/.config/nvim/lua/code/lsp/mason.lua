-- Mason: LSP binaries only. Formatters/linters are expected to be on $PATH.
-- mason-lspconfig v2 only installs; enabling is done through vim.lsp.enable().

local M = {}

M.ensure_installed = {
    "pyright",
    "rust_analyzer",
    "lua_ls",
    "clangd",
    "html",
    "jsonls",
    "cssls",
}

function M.setup()
    require("mason").setup({
        ui = {
            border = "rounded",
            height = 0.75,
            width = 0.75,
            icons = require("icons").manager,
        },
    })

    require("mason-lspconfig").setup({
        ensure_installed = M.ensure_installed,
        -- Only the servers listed in code/lsp/servers.lua are enabled.
        automatic_enable = false,
    })
end

return M
