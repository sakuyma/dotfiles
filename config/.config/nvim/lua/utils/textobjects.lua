-- Tree-sitter text objects: select and move by syntax node.

local M = {}

local function select(query, lhs, desc)
    vim.keymap.set({ "x", "o" }, lhs, function()
        require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
    end, { desc = "Select " .. desc })
end

local function goto(direction, query, lhs, desc)
    vim.keymap.set("n", lhs, function()
        require("nvim-treesitter-textobjects.move")[direction](query, "textobjects")
    end, { desc = desc })
end

function M.setup()
    require("nvim-treesitter-textobjects").setup({
        select = {
            lookahead = true,
            selection_modes = {
                ["@function.outer"] = "V",
                ["@class.outer"] = "V",
            },
            include_surrounding_whitespace = false,
        },
        move = { set_jumps = true },
    })

    select("@function.outer", "af", "function (outer)")
    select("@function.inner", "if", "function (inner)")
    select("@class.outer", "ac", "class (outer)")
    select("@class.inner", "ic", "class (inner)")
    select("@parameter.outer", "aa", "parameter (outer)")
    select("@parameter.inner", "ia", "parameter (inner)")

    goto("goto_next_start", "@function.outer", "]f", "Next function")
    goto("goto_previous_start", "@function.outer", "[f", "Previous function")
end

return M
