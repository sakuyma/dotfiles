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
    picker = { enabled = true },
    explorer = { enabled = true },
    notifier = {
        enabled = true,
        timeout = 3000,
        level = vim.log.levels.INFO,
        icons = {
            error = " ",
            warn = " ",
            info = " ",
            debug = " ",
            trace = " ",
        },
        style = "fancy",
        top_down = true,
    },
    dashboard = {
        enabled = true,
        preset = {
            header = [[
    ╭─────────────────────────────────────────────────╮
    │                                             ___ │
    │                                         ,o88888 │
    │                 ,:o:o:oooo.        ,8O88Pd8888" │
    │               .::.::o:ooooOoOoO. ,oO8O8Pd888'"  │
    │           ,.:.::o:ooOoOoOO8O8OOo.8OOPd8O8O"     │
    │          , ..:.::o:ooOoOOOO8OOOOo.FdO8O8"       │
    │         , ..:.::o:ooOoOO8O888O8O,COCOO"         │
    │        , . ..:.::o:ooOoOOOO8OOOOCOCO"           │
    │         . ..:.::o:ooOoOoOO8O8OCCCC"o            │
    │            . ..:.::o:ooooOoCoCCC"o:o            │
    │            . ..:.::o:o:,cooooCo"oo:o:           │
    │         `   . . ..:.:cocoooo"'o:o:::'           │
    │         .`   . ..::ccccoc"'o:o:o:::'            │
    │         :.:.    ,c:cccc"':.:.:.:.:.'            │
    │      ..:.:"'`::::c:"'..:.:.:.:.:.'              │
    │    ...:.'.:.::::"'    . . . . .'                │
    │   .. . ....:."' `   .  . . ''                   │
    │ . . . ...."'                                    │
    │ .. . ."'                                        │
    ╰─────────────────────────────────────────────────╯
    ]],

            keys = {
                {
                    icon = " ",
                    key = "e",
                    desc = "New File",
                    action = ":enew",
                },
                {
                    icon = " ",
                    key = "n",
                    desc = "Explorer",
                    action = ":lua Snacks.explorer()",
                },
                {
                    icon = " ",
                    key = "f",
                    desc = "Find File",
                    action = ":lua Snacks.picker.files()",
                },
                {
                    icon = " ",
                    key = "r",
                    desc = "Recently",
                    action = ":lua Snacks.picker.recent()",
                },
                {
                    icon = "󰊄 ",
                    key = "q",
                    desc = "Quit",
                    action = ":qa",
                },
            },
        },
    },
})
