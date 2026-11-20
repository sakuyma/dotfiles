local option = vim.opt

-- general
option.termguicolors = true
option.encoding = "utf-8"
option.fileencoding = "utf-8"
option.modelines = 0 -- CVE-2007-2438
option.wildmode = "longest:full,full"
option.clipboard = "unnamedplus"
option.updatetime = 250
option.mouse = "a"
option.langmap:append({
    "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz",
})

-- editor
option.number = true
option.relativenumber = true
option.numberwidth = 2
option.fillchars = { eob = " " }
option.scrolloff = 10
option.smoothscroll = true
option.cursorline = true
option.signcolumn = "yes"
option.splitbelow = true
option.splitright = true
option.guicursor = "n-v-c-sm:block,i-ci-ve:block,r-cr-o:hor20"

-- indents
option.expandtab = true
option.tabstop = 4
option.shiftwidth = 4
option.softtabstop = 4
option.smarttab = true
option.smartindent = true

-- search
option.hlsearch = true
option.incsearch = true
option.ignorecase = true
option.smartcase = true
option.infercase = true

-- windows / statusline
option.laststatus = 3
option.ruler = false
option.showmode = false

-- wrapping is enabled per filetype in settings/autocmds.lua
option.wrap = false
option.linebreak = true
option.whichwrap = ""
option.showbreak = " 󱞩 "

-- files
option.backup = false
option.writebackup = false
option.swapfile = false
option.undofile = true
