local option = vim.opt -- set local variable 
-- general --
option.termguicolors = true                -- enable true color
option.encoding = "utf-8"                  -- set UTF-8 encoding
option.fileencoding = "utf-8"              -- default file encoding
option.modelines = 0                       -- disable CVE-2007-2438 vulnerability
option.wildmode = "longest:full,full"      -- autocompletes in command line
option.clipboard = "unnamedplus"           -- use system clipboard
option.updatetime = 100                    -- update timeout
option.mouse = "a"                         -- enable mouse support
option.langmap:append {
  "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ",
  "фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz",
}                                           -- enable support russian layout

-- editor --
option.number = true                       -- enable absolute numbering of current line
option.relativenumber = true               -- enable relative line numbering
option.numberwidth = 2                     -- line number width
option.fillchars = {
  eob = " ",
}                                          -- interface symbols
option.scrolloff = 10                      -- minimum number of lines above/below cursor when scrolling
option.smoothscroll = true                 -- enable smooth scrolling
option.cursorline = true                   -- highlight cursor line
option.signcolumn = "yes"                  -- enable sign column
option.splitbelow = true                   -- when horizontal split open new window at bottom
option.splitright = true                   -- when vertically split open new window on right


-- indents --
option.expandtab = true                    -- replace Tabs with spaces
option.tabstop = 4                         -- number of spaces for tabs
option.shiftwidth = 4                      -- number of spaces when auto-adding margins
option.softtabstop = 4                     -- number of spaces during autotabulation
option.smarttab = true                     -- smart tabulation behavior
option.smartindent = true                  -- smart code alignment


-- search --
option.hlsearch = true                     -- enable search results highlight
option.incsearch = true                    -- enable search as you type
option.ignorecase = true                   -- ignore case when searching
option.smartcase = true                    -- ignore case if there are no uppercase letters
option.infercase = true                    -- save register when auto-complete
option.guicursor = "i:block"               -- block cursor in instert mode

-- performance --
option.laststatus = 3                      -- enable global status line
option.ruler = false                       -- disable character ruler
option.showtabline = 2                     -- enable tab line
option.showmode = false                    -- disable display mode 
option.wrap = true                         -- enable line wrapping
option.linebreak = true                    -- enable wrap only by words
option.whichwrap = ""                      -- which keys enable transfer to next line
option.showbreak = " 󱞩 "                   -- add arrow at beginning of moved line
option.backup = false                      -- disable backup files
option.writebackup = false                 -- disable creation of temporary backups
option.swapfile = false                    -- disable creation .swp files
option.undofile = true                     -- save history of changes
