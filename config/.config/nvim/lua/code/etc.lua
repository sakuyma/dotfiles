require("snacks").setup({
    indent = {
        enabled = true,
        indent = {
            enabled = true,
            char = "│",
            hl = "SnacksIndent",
        },
        scope = {
            enabled = true,
            char = "│",
            hl = "SnacksIndentScope",
        },
        exclude = {
            filetypes = { "dashboard" },
        },
    },
})
