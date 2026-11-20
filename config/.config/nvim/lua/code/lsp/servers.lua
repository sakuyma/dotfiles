-- Language server definitions.
-- Only overrides live here: cmd/filetypes/root_markers and defaults come from
-- nvim-lspconfig's lsp/<name>.lua configs and are merged by vim.lsp.config(name, ...).

return {
    pyright = {
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true,
                },
            },
        },
    },
    clangd = {
        cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=never",
            "--completion-style=detailed",
        },
    },
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                check = { command = "clippy" },
            },
        },
    },
    lua_ls = {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                telemetry = { enable = false },
            },
        },
    },
    html = {},
    jsonls = {},
    cssls = {},
}
