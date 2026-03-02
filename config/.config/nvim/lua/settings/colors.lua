-- general options --
local hl = vim.api.nvim_set_hl              -- set local variable
vim.opt.background = "dark"                 -- enable dark theme
vim.cmd.colorscheme "catppuccin"            -- choose color scheme
vim.opt.syntax = "on"                       -- enable syntax highlighting
vim.opt.showmatch = false                   -- disable highlight pair elements


-- neovim --
hl(0, "FloatBorder", { fg = "#89b4fa", bg = "NONE" })
hl(0, "SignColumn", { fg = "NONE" })


-- notifications --
hl(0, "NotifyERRORBorder", { fg = "#f38ba8" })
hl(0, "NotifyWARNBorder", { fg = "#f9e2af" })
hl(0, "NotifyINFOBorder", { fg = "#a6e3a1" })
hl(0, "NotifyDEBUGBorder", { fg = "#89b4fa" })
hl(0, "NotifyTRACEBorder", { fg = "#bac2de" })
hl(0, "NotifyERRORIcon", { fg = "#f38ba8" })
hl(0, "NotifyWARNIcon", { fg = "#f9e2af" })
hl(0, "NotifyINFOIcon", { fg = "#a6e3a1" })
hl(0, "NotifyDEBUGIcon", { fg = "#89b4fa" })
hl(0, "NotifyTRACEIcon", { fg = "#bac2de" })
hl(0, "NotifyERRORTitle", { fg = "#f38ba8" })
hl(0, "NotifyWARNTitle", { fg = "#f9e2af" })
hl(0, "NotifyINFOTitle", { fg = "#a6e3a1" })
hl(0, "NotifyDEBUGTitle", { fg = "#89b4fa" })
hl(0, "NotifyTRACETitle", { fg = "#bac2de" })


-- finder --
hl(0, "TelescopeNormal", { bg = "NONE" })
hl(0, "TelescopePromptTitle", { fg = "#11111b", bg = "#f38ba8" })
hl(0, "TelescopePreviewTitle", { fg = "#B4BEFE", bg = "#B4BEFE" })
