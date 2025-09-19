-- plugins --
require("plugins.plugins")
require("plugins.lualine2")
require("plugins.todocomments")
require("plugins.nvim-tree")
require("plugins.telescope")
require("plugins.dashboard")
require("plugins.ibl")
require("plugins.catppuccin")
require("plugins.lsp-config")
require("plugins.nvim-cmp")
require("plugins.nvim-dap")
require("plugins.treesitter")
require("plugins.toggleterm")
require("plugins.aerial")
require("plugins.conform")
require("plugins.trouble")


-- base settings --
vim.opt.termguicolors = true           -- enable true color
vim.opt.encoding = "utf-8"             -- set UTF-8 encoding
vim.opt.fileencoding = "utf-8"         -- default file encoding
vim.opt.modelines = 0                  -- disable CVE-2007-2438 vulnerability
vim.opt.wildmode = "longest:full,full" -- autocompletes in command line
vim.opt.clipboard = "unnamedplus"      -- use system clipboard
vim.opt.updatetime = 5000              -- update timeout
vim.opt.mouse = "a"                    -- enable mouse support
vim.opt.langmap:append {
  "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ",
  "фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz",
}                                      -- enable support russian layout


-- editor --
vim.opt.number = true                  -- enable absolute numbering of current line
vim.opt.relativenumber = true          -- enable relative line numbering
vim.opt.numberwidth = 2                -- line number width
vim.opt.fillchars = { eob = " " }      -- disable character before empty lines
vim.opt.scrolloff = 10                 -- minimum number of lines above/below cursor when scrolling
vim.opt.smoothscroll = true            -- enable smooth scrolling
vim.opt.cursorline = true              -- highlight cursor line
vim.opt.signcolumn = "yes"             -- enable sign column
vim.opt.splitbelow = true              -- when horizontal split open new window at bottom
vim.opt.splitright = true              -- when vertically split open new window on right


-- colors --
vim.opt.background = "dark"            -- enable dark theme
vim.cmd.colorscheme "catppuccin"       -- choose color scheme
vim.opt.syntax = "on"                  -- enable syntax highlighting
vim.opt.showmatch = false              -- disable highlight pair elements
vim.cmd([[
  highlight FloatBorder guifg=#89b4fa guibg=NONE
  highlight SignColumn guibg=NONE
  highlight TelescopePromptCounter guifg=#1e1e2e
  highlight TelescopeNormal guibg=NONE
]])                                    -- highlight settings


-- tabulation settings --
vim.opt.expandtab = true               -- replace Tabs with spaces
vim.opt.tabstop = 2                    -- number of spaces for tabs
vim.opt.shiftwidth = 2                 -- number of spaces when auto-adding margins
vim.opt.softtabstop = 2                -- number of spaces during autotabulation
vim.opt.smarttab = true                -- smart tabulation behavior
vim.opt.smartindent = true             -- smart code alignment


-- search --
vim.opt.hlsearch = true                -- enable search results highlight
vim.opt.incsearch = true               -- enable search as you type
vim.opt.ignorecase = true              -- ignore case when searching
vim.opt.smartcase = true               -- ignore case if there are no uppercase letters
vim.opt.infercase = true               -- save register when auto-complete


-- performance --
vim.opt.laststatus = 3                 -- enable global status line
vim.opt.ruler = false                  -- disable character ruler
vim.opt.showtabline = 0                -- disable tab line
vim.opt.showmode = false               -- disable display mode 
vim.opt.wrap = true                    -- enable line wrapping
vim.opt.linebreak = true               -- enable wrap only by words
vim.opt.whichwrap = "h,l"              -- enable transfer to next line on h and l
vim.opt.showbreak = " 󱞩 "              -- add arrow at beginning of moved line
vim.opt.backup = false                 -- disable backup files
vim.opt.writebackup = false            -- disable creation of temporary backups
vim.opt.swapfile = false               -- disable creation .swp files
vim.opt.undofile = true                -- save history of changes


-- mappings --
vim.g.mapleader = " "                  -- assign <leader> key
vim.g.maplocalleader = " "             -- assign <leader> key


-- files
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { silent = true }) -- save file
vim.keymap.set("n", "<leader>q", "<cmd>q!<cr>", { silent = true })-- exit without saving
vim.keymap.set("n", "<leader>e", "<cmd>q<cr>", { silent = true }) -- exit


-- movement
vim.keymap.set("n", "j", "gj")         -- move down based on transfer
vim.keymap.set("n", "k", "gk")         -- move up based on transfer
vim.keymap.set("n", "H", "b")          -- move to previous word
vim.keymap.set("n", "L", "w")          -- move to next word
vim.keymap.set("n", "J", "^")          -- move to beginning of line
vim.keymap.set("n", "K", "$")          -- move to end of line
vim.keymap.set("i", "<C-h>", "<Left>") -- move left in insert mode 
vim.keymap.set("i", "<C-j>", "<Down>") -- move down in insert mode
vim.keymap.set("i", "<C-k>", "<Up>")   -- move up in insert mode
vim.keymap.set("i", "<C-l>", "<Right>")-- move right in insert mode
vim.keymap.set("n", "<C-h>", "<C-w>h") -- pane movement left
vim.keymap.set("n", "<C-j>", "<C-w>j") -- pane movement down
vim.keymap.set("n", "<C-k>", "<C-w>k") -- pane movement up
vim.keymap.set("n", "<C-l>", "<C-w>l") -- pane movement right


-- visual
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- move selection down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- move selection up
vim.keymap.set("v", "<", "<gv")        -- indent left and keep selection
vim.keymap.set("v", ">", ">gv")        -- indent right and keep selection


-- yank and paste
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y') -- yank to clipboard
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p') -- paste from clipboard
vim.keymap.set("n", "<leader>c", "yyp") -- duplicate line


-- window management
vim.keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally


-- other mappingsvim.keymap.set("n", "<C-u>", "<C-u>zz")-- scrolling with centering up

vim.keymap.set("n", "<C-d>", "<C-d>zz")-- scrolling with centering down
vim.keymap.set("i", "jj", "<esc>")     -- exit insert mode
vim.keymap.set("n", "+", "<C-a>")      -- increment number
vim.keymap.set("n", "-", "<C-x>")      -- decrement number
vim.keymap.set("n", "x", '"_x')        -- cut without storing to register
vim.keymap.set("n", "<leader>hl", "<cmd>nohlsearch<cr>", { silent = true }) -- disable highlight after searching
