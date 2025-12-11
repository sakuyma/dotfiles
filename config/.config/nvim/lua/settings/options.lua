-- general --
vim.opt.termguicolors = true                -- enable true color
vim.opt.encoding = "utf-8"                  -- set UTF-8 encoding
vim.opt.fileencoding = "utf-8"              -- default file encoding
vim.opt.modelines = 0                       -- disable CVE-2007-2438 vulnerability
vim.opt.wildmode = "longest:full,full"      -- autocompletes in command line
vim.opt.clipboard = "unnamedplus"           -- use system clipboard
vim.opt.updatetime = 5000                   -- update timeout
vim.opt.mouse = "a"                         -- enable mouse support
vim.opt.langmap:append {
  "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ",
  "фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz",
}                                           -- enable support russian layout


-- editor --
vim.opt.number = true                       -- enable absolute numbering of current line
vim.opt.relativenumber = true               -- enable relative line numbering
vim.opt.numberwidth = 2                     -- line number width
vim.opt.fillchars = {
  eob = " ",
}                                           -- interface symbols
vim.opt.scrolloff = 10                      -- minimum number of lines above/below cursor when scrolling
vim.opt.smoothscroll = true                 -- enable smooth scrolling
vim.opt.cursorline = true                   -- highlight cursor line
vim.opt.signcolumn = "yes"                  -- enable sign column
vim.opt.splitbelow = true                   -- when horizontal split open new window at bottom
vim.opt.splitright = true                   -- when vertically split open new window on right


-- indents --
vim.opt.expandtab = true                    -- replace Tabs with spaces
vim.opt.tabstop = 2                         -- number of spaces for tabs
vim.opt.shiftwidth = 2                      -- number of spaces when auto-adding margins
vim.opt.softtabstop = 2                     -- number of spaces during autotabulation
vim.opt.smarttab = true                     -- smart tabulation behavior
vim.opt.smartindent = true                  -- smart code alignment


-- search --
vim.opt.hlsearch = true                     -- enable search results highlight
vim.opt.incsearch = true                    -- enable search as you type
vim.opt.ignorecase = true                   -- ignore case when searching
vim.opt.smartcase = true                    -- ignore case if there are no uppercase letters
vim.opt.infercase = true                    -- save register when auto-complete


-- performance --
vim.opt.laststatus = 3                      -- enable global status line
vim.opt.ruler = false                       -- disable character ruler
vim.opt.showtabline = 1                     -- enable tab line
vim.opt.showmode = false                    -- disable display mode 
vim.opt.wrap = true                         -- enable line wrapping
vim.opt.linebreak = true                    -- enable wrap only by words
vim.opt.whichwrap = ""                      -- which keys enable transfer to next line
vim.opt.showbreak = " 󱞩 "                   -- add arrow at beginning of moved line
vim.opt.backup = false                      -- disable backup files
vim.opt.writebackup = false                 -- disable creation of temporary backups
vim.opt.swapfile = false                    -- disable creation .swp files
vim.opt.undofile = true                     -- save history of changes
