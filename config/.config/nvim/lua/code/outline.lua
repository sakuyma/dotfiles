-- Aerial outline.

local M = {}

function M.setup()
    require("aerial").setup({
        backends = { "lsp", "treesitter" },
        filter_kind = {
            "Class",
            "Function",
            "Method",
            "Interface",
            "Struct",
            "Array",
            "Constructor",
            "Enum",
            "Module",
        },
        close_behavior = "global",
        show_guides = false,
        layout = {
            default_direction = "left",
            max_width = { 40, 0.3 },
            min_width = 25,
        },
        icons = require("icons").outline,
    })
end

return M
