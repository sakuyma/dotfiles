-- general options --
local hl = vim.api.nvim_set_hl              -- set local variable
vim.opt.background = "dark"                 -- enable dark theme
vim.opt.syntax = "on"                       -- enable syntax highlighting
vim.opt.showmatch = false                   -- disable highlight pair elements


-- neovim --
hl(0, "FloatBorder", { fg = "#89b4fa", bg = "NONE" })
hl(0, "SignColumn", { fg = "NONE" })

-- Indents
hl(0, "SnacksIndent", { fg = "#6C7086", nocombine = true })

hl(0, "SnacksIndentScope", { fg = "#b4befe", nocombine = true })
