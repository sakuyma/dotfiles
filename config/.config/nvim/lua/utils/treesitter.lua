-- Tree-sitter: parser installation and highlighting.
-- On the main branch nvim-treesitter does not enable highlighting by itself:
-- it must be started per buffer, which is what the FileType autocmd below does.
--
-- Cobalt is loaded manually (compiled to ~/.local/share/nvim/site/parser/cobalt.so)
-- because the nvim-treesitter `main` branch no longer supports local grammar
-- registration via get_parser_configs().

local M = {}

M.parsers = {
    "bash",
    "c",
    "cpp",
    "css",
    "diff",
    "dockerfile",
    "gitcommit",
    "html",
    "javascript",
    "json",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "rust",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
    -- NOTE: "cobalt" is intentionally NOT listed here.
    -- It is compiled and loaded manually; see setup() below.
}

-- Filetypes whose parser is managed by nvim-treesitter.
-- Cobalt is handled separately so we can pass the language explicitly.
local managed_langs = {}
for _, lang in ipairs(M.parsers) do
    managed_langs[lang] = true
end

local function start(buf)
    local ft = vim.bo[buf].filetype

    if ft == "cobalt" then
        -- Explicit language name so Neovim finds cobalt.so in the runtime parser dir.
        pcall(vim.treesitter.start, buf, "cobalt")
    elseif managed_langs[ft] then
        pcall(vim.treesitter.start, buf)
    end
end

function M.setup()
    -- Install nvim-treesitter-managed parsers (not cobalt).
    require("nvim-treesitter").install(M.parsers)

    -- Associate .cb / .cobalt files with the cobalt filetype.
    vim.filetype.add({
        extension = {
            cb = "cobalt",
            cobalt = "cobalt",
        },
    })

    -- Start highlighting on every buffer whose filetype has a parser.
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(event)
            start(event.buf)
        end,
    })

    -- Buffers opened before the plugin finished loading.
    vim.schedule(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then
                start(buf)
            end
        end
    end)
end

return M
