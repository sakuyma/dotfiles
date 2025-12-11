-- general options --
local key = vim.keymap.set                  -- set local variable
vim.g.mapleader = ""                       -- set <leader> key


-- files --
key("n", "<leader>w", "<cmd>w<cr>", { silent = true }) -- save file
key("n", "<leader>q", "<cmd>q!<cr>", { silent = true })-- exit without saving


-- movement --
key("n", "j", "gj")                         -- move down based on transfer
key("n", "k", "gk")                         -- move up based on transfer
key("n", "H", "b")                          -- move to previous word
key("n", "L", "w")                          -- move to next word
key("n", "J", "^")                          -- move to beginning of line
key("n", "K", "$")                          -- move to end of line
key("i", "<c-h>", "<left>")                 -- move left in insert mode
key("i", "<c-j>", "<down>")                 -- move down in insert mode
key("i", "<c-k>", "<up>")                   -- move up in insert mode
key("i", "<c-l>", "<right>")                -- move right in insert mode
key("n", "<c-h>", "<c-w>h")                 -- pane movement left
key("n", "<c-j>", "<c-w>j")                 -- pane movement down
key("n", "<c-k>", "<c-w>k")                 -- pane movement up
key("n", "<c-l>", "<c-w>l")                 -- pane movement right


-- visual --
key("v", "J", ":m '>+1<cr>gv=gv")           -- move selection down
key("v", "K", ":m '<-2<cr>gv=gv")           -- move selection up
key("v", "<", "<gv")                        -- indent left and keep selection
key("v", ">", ">gv")                        -- indent right and keep selection


-- yank and paste --
key("n", "x", "\"_x")                       -- cut without storing to clipboard
key("n", "<leader>c", "yyp")                -- duplicate line


-- window management --
key("n", "<leader>sv", "<c-w>v")           -- split window vertical
key("n", "<leader>sh", "<c-w>s")            -- split window horizontally


-- scrolling --
key("n", "<c-u>", "<c-u>zz")                -- scrolling up with centering
key("n", "<c-d>", "<c-d>zz")                -- scrolling down with centering


-- increment/decrement number --
key("n", "+", "<c-a>")                      -- increment number
key("n", "-", "<c-x>")                      -- decrement number


-- other keymaps --
key("i", "jj", "<esc>")                     -- quit insert mode
key("i", "<d-space>", "<nop>")              -- ignore switch keyboard layout
key("n", "<leader>hl", "<cmd>noh<cr>", { silent = true }) -- disable highlight after searching
