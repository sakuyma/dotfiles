-- plugins --
require("plugin")


-- code --
require("code.autopairs")
require("code.debugger")
require("code.formatter")
require("code.indents")
require("code.outline")
require("code.syntax")
require("code.vcs")
require("code.linters")

-- lsp --
require("lsp")

-- ui --
require("ui.theme")
require("ui.tabs")
require("ui.statusline")
require("ui.ui-improvement")
require("ui.notifications")
require("ui.dashboard")

-- utils --
require("utils.explorer")
require("utils.finder")
require("utils.terminal")
require("utils.todocomments")
require("utils.troubleshoots")


-- settings --
require("settings.autocmds")
require("settings.colors")
require("settings.keymaps")
require("settings.options")
require("settings.plugins-keymaps")
