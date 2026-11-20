local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
    return vim.api.nvim_create_augroup("general_" .. name, { clear = true })
end

-- Spell checking for prose.
autocmd("FileType", {
    group = augroup("spell"),
    pattern = { "text", "markdown", "gitcommit" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = { "ru", "en" }
    end,
})

-- Soft-wrap prose, keep code hard-wrapped.
autocmd("FileType", {
    group = augroup("prose_wrap"),
    pattern = { "text", "markdown", "gitcommit", "tex", "asciidoc" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
    end,
})

-- Briefly highlight yanked text.
autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
        vim.highlight.on_yank({
            higroup = "Visual",
            timeout = 500,
            on_visual = true,
        })
    end,
})
