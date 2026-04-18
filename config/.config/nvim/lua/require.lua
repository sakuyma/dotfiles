-- plugins --
require("plugin")

-- theme setup (must be before colorscheme) --
require("ui.theme")

-- settings (early load for colorscheme) --
require("settings.colors")
require("settings.options")

-- code --
require("code.autopairs")
require("code.debugger")
require("code.formatter")
require("code.outline")
require("code.vcs")
require("code.linters")
require("code.lsp")
require("code.ai")

-- ui --
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
require("utils.sessions")
require("utils.surround")

-- settings --
require("settings.autocmds")
require("settings.keymaps")
require("settings.plugins-keymaps")
