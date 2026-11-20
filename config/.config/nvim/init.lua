-- Entry point.
-- Only startup-critical configuration lives here: leader keys, the Lua module cache,
-- editor options/autocmds/core keymaps, and finally the plugin manager.
-- Everything plugin-related is declared in lua/plugin.lua and lazily configured
-- by the modules under lua/{ui,code,utils}.

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.loader.enable()

require("settings.settings")
require("plugin")
