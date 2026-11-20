-- LSP: diagnostics, server registration, buffer-local keymaps.

local M = {}

local function augroup(name)
    return vim.api.nvim_create_augroup("code_lsp_" .. name, { clear = true })
end

local function diagnostics()
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
end

local function register_servers(capabilities)
    vim.lsp.config("*", { capabilities = capabilities })

    for name, overrides in pairs(require("code.lsp.servers")) do
        vim.lsp.config(name, overrides)

        -- Only enable servers whose executable is actually available.
        -- A function cmd is resolved lazily by Neovim, so it cannot be checked here.
        local cmd = vim.lsp.config[name].cmd
        local available = type(cmd) == "function" or (type(cmd) == "table" and vim.fn.executable(cmd[1]) == 1)
        if available then
            vim.lsp.enable(name)
        end
    end
end

local function keymaps()
    vim.api.nvim_create_autocmd("LspAttach", {
        group = augroup("attach"),
        callback = function(event)
            local opts = { buffer = event.buf }

            vim.keymap.set(
                "n",
                "<leader>ld",
                vim.lsp.buf.definition,
                vim.tbl_extend("force", opts, { desc = "LSP: definition" })
            )
            vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP: hover" }))
            vim.keymap.set(
                "n",
                "<leader>li",
                vim.lsp.buf.implementation,
                vim.tbl_extend("force", opts, { desc = "LSP: implementation" })
            )
            vim.keymap.set(
                "n",
                "<leader>lr",
                vim.lsp.buf.references,
                vim.tbl_extend("force", opts, { desc = "LSP: references" })
            )
            vim.keymap.set(
                "n",
                "<leader>ln",
                vim.lsp.buf.rename,
                vim.tbl_extend("force", opts, { desc = "LSP: rename" })
            )
            vim.keymap.set(
                { "n", "v" },
                "<leader>la",
                vim.lsp.buf.code_action,
                vim.tbl_extend("force", opts, { desc = "LSP: code action" })
            )
            vim.keymap.set(
                "n",
                "<leader>le",
                vim.diagnostic.open_float,
                vim.tbl_extend("force", opts, { desc = "LSP: diagnostic float" })
            )
            vim.keymap.set(
                "n",
                "[d",
                vim.diagnostic.goto_prev,
                vim.tbl_extend("force", opts, { desc = "Previous diagnostic" })
            )
            vim.keymap.set(
                "n",
                "]d",
                vim.diagnostic.goto_next,
                vim.tbl_extend("force", opts, { desc = "Next diagnostic" })
            )
        end,
    })

    -- Keep the status line clean: progress messages are noise here.
    vim.lsp.handlers["$/progress"] = function() end
end

function M.setup()
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
    if vim.fn.isdirectory(mason_bin) == 1 then
        vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
    end

    diagnostics()
    require("code.lsp.mason").setup()
    register_servers(require("cmp_nvim_lsp").default_capabilities())
    keymaps()
end

return M
