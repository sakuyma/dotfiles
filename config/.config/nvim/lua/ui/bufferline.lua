-- Bufferline configuration.

local M = {}

function M.setup()
    local ok, special = pcall(require, "catppuccin.special.bufferline")
    local highlights = ok and special.get_theme() or nil

    require("bufferline").setup({
        highlights = highlights,
        options = {
            hover = {
                enabled = true,
                delay = 200,
                reveal = { "close" },
            },
            mode = "buffers",
            numbers = "buffer_id",
            separator_style = "slope",
            always_show_bufferline = false,
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            show_close_icon = true,
            max_name_length = 18,
            truncate_names = true,
            diagnostics = "nvim_lsp",
            diagnostics_update_in_insert = false,
            diagnostics_update_on_event = true,
            diagnostics_indicator = function(count)
                return "(" .. count .. ")"
            end,
            indicator = { style = "underline" },
            buffer_close_icon = "󰄖",
            modified_icon = "● ",
            close_icon = " ",
            left_trunc_marker = " ",
            right_trunc_marker = " ",
        },
    })
end

return M
