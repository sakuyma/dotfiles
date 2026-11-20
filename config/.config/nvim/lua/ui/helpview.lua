-- helpview.nvim: renders vimdoc (":help") with treesitter and shows a
-- floating preview. The plugin is loaded eagerly (lazy = false) because it has
-- to attach to help buffers as they are created; see plugin.lua.
--
-- Run ":checkhealth helpview" after changing the config to verify the vimdoc
-- parser and the icon provider are available.

local M = {}

function M.setup()
    require("helpview").setup({
        preview = {
            enable = true,

            -- Floating preview plus the in-place vimdoc decorations.
            -- Hybrid mode is off: the floating window renders the whole
            -- buffer while preview modes are active, and "hybrid_modes"
            -- stays empty so no mode switches to raw text.
            enable_hybrid_mode = false,
            hybrid_modes = {},

            modes = { "n", "c", "no" },
            filetypes = { "help" },

            -- Large help files are only partially rendered to keep scrolling
            -- responsive.
            max_buf_lines = 500,
            debounce = 150,

            icon_provider = "internal",

            splitview_winopts = { split = "right" },
            preview_winopts = { width = 80 },
        },

        vimdoc = {
            -- Every section below defaults to enabled. Keep this list explicit
            -- so individual decorations can be turned off in one place, e.g.
            --   tags = { enable = false }
            arguments = { enable = true },
            code_blocks = { enable = true },
            headings = { enable = true },
            highlight_groups = { enable = true },
            horizontal_rules = { enable = true },
            inline_codes = { enable = true },
            keycodes = { enable = true },
            modelines = { enable = true },
            notes = { enable = true },
            optionlinks = { enable = true },
            tags = { enable = true },
            taglinks = { enable = true },
            urls = { enable = true },
        },
    })
end

return M
