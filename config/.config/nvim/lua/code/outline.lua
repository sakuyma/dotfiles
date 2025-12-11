require("aerial").setup {
  backends = {
    "lsp",
    "treesitter",
  },
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
    max_width = {
      40,
      0.3
    },
    min_width = 25,
  },
  ignore = {
    filetypes = {},
  },
  icons = require("icons").outline,
}


-- vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<cr>")
-- vim.keymap.set("n", "[[", "<cmd>AerialPrev<cr>")
-- vim.keymap.set("n", "]]", "<cmd>AerialNext<cr>")
