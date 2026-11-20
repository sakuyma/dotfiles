-- Trouble: diagnostics, TODOs and quickfix lists.

local M = {}

function M.setup()
    require("trouble").setup({
        position = "bottom",
        height = 10,
        focus = true,
        auto_jump = false,
        keys = {
            q = "close",
            ["<esc>"] = "cancel",
            ["<cr>"] = "jump",
            o = "jump_close",
            j = "next",
            k = "prev",
            dd = "delete",
            r = "refresh",
            R = "toggle_refresh",
        },
        icons = {
            indent = {
                top = " ",
                middle = " ",
                last = " ",
                fold_open = " ",
                fold_closed = " ",
                ws = " ",
            },
            folder_closed = " ",
            folder_open = " ",
        },
    })
end

return M
