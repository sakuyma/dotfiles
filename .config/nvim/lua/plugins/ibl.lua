vim.api.nvim_set_hl(0, "IndentBlankline", { fg = "#585B70" })
vim.api.nvim_set_hl(0, "IndentBlanklineScope", { fg = "#A5ADC8" })


require("ibl").setup {
  indent = {
    char = "│",
    highlight = "IndentBlankline",
    smart_indent_cap = true,
  },
  scope = {
    enabled = true,
    show_start = true,
    show_end = false,
    char = "│",
    highlight = "IndentBlanklineScope",
  },
  exclude = {
    filetypes = {
      "dashboard",
    },
  },
}
