-- Linting via nvim-lint. Runs on read, write and leaving insert mode.
-- Linters whose executable is missing are skipped instead of erroring on every buffer.

local M = {}

M.linters_by_ft = {
    sh = { "shellcheck" },
    bash = { "shellcheck" },
    css = { "stylelint" },
    markdown = { "markdownlint" },
    yaml = { "yamllint" },
    python = { "ruff" },
    gitcommit = { "gitlint" },
    json = { "jsonlint" },
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    dockerfile = { "hadolint" },
    c = { "clangtidy" },
    cpp = { "clangtidy" },
}

local function available(lint, name)
    local linter = lint.linters[name]
    return type(linter) == "table" and type(linter.cmd) == "string" and vim.fn.executable(linter.cmd) == 1
end

function M.setup()
    local lint = require("lint")

    local by_ft = {}
    for ft, names in pairs(M.linters_by_ft) do
        by_ft[ft] = vim.tbl_filter(function(name)
            return available(lint, name)
        end, names)
    end

    if available(lint, "codespell") then
        lint.linters.codespell.args = {
            "--builtin=rare,clear,informal,code,names,en-GB_to_en-US",
        }
        for ft, names in pairs(by_ft) do
            if ft ~= "css" and ft ~= "bib" then
                table.insert(names, "codespell")
            end
        end
    end

    for ft, names in pairs(by_ft) do
        if #names == 0 then
            by_ft[ft] = nil
        end
    end

    lint.linters_by_ft = by_ft

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("code_lint", { clear = true }),
        callback = function()
            vim.defer_fn(function()
                require("lint").try_lint()
            end, 100)
        end,
    })
end

return M
