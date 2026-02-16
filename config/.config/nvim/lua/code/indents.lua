-- indents.lua

local hl = vim.api.nvim_set_hl

hl(0, "IblIndent", { fg = "#585b70", nocombine = true })
hl(0, "IblScope", { fg = "#a6adc8", nocombine = true })

hl(0, "IndentBlanklineChar", { fg = "#585b70", nocombine = true })
hl(0, "IndentBlanklineSpaceChar", { fg = "#585b70", nocombine = true })
hl(0, "IndentBlanklineContextChar", { fg = "#a6adc8", nocombine = true })

-- Старые имена для совместимости
hl(0, "IndentBlankline", { link = "IblIndent" })
hl(0, "IndentBlanklineScope", { link = "IblScope" })

-- Настройка плагина
require("ibl").setup {
  indent = {
    char = "│",
    highlight = "IblIndent",  
    smart_indent_cap = true,
  },
  scope = {
    enabled = true,
    show_start = true,
    show_end = false,
    char = "│",
    highlight = "IblScope",  
  },
  exclude = {
    filetypes = {
      "dashboard",
      "help",
      "lazy",
      "mason",
      "neo-tree",
      "Trouble",
    },
  },
}
