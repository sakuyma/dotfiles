-- Single source of truth for colors: the Catppuccin flavour and palette.
-- Other UI modules derive their colors from here instead of hardcoding hex values.

local M = {}

M.flavour = "mocha"

---@return table<string, string>
function M.palette()
    return require("catppuccin.palettes").get_palette(M.flavour)
end

local function custom_highlights()
    local p = M.palette()
    local hl = vim.api.nvim_set_hl
    hl(0, "FloatBorder", { fg = p.blue, bg = "NONE" })
    hl(0, "SignColumn", { fg = "NONE" })
    hl(0, "SnacksIndent", { fg = p.overlay0, nocombine = true })
    hl(0, "SnacksIndentScope", { fg = p.lavender, nocombine = true })
end

function M.setup()
    require("catppuccin").setup({
        flavour = M.flavour,
        transparent_background = true,
        no_italic = true,
        no_bold = true,
        no_underline = true,
        integrations = {
            aerial = true,
            cmp = true,
            dap = true,
            dap_ui = true,
            gitsigns = true,
            lsp_trouble = true,
            mason = true,
            mini = true,
            native_lsp = { enabled = true },
            noice = true,
            render_markdown = true,
            snacks = true,
            treesitter = true,
        },
    })

    -- Re-apply on every colorscheme change so custom highlights follow the palette.
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("ui_highlights", { clear = true }),
        callback = custom_highlights,
    })

    vim.cmd.colorscheme("catppuccin")
end

return M
