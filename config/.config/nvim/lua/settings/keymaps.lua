-- Core keymaps. Nothing in this file may require a plugin:
-- plugin keymaps live in lua/plugin.lua and are loaded by lazy.nvim on use.
--
-- Leader prefix layout:
--   <leader>f  find / pickers      <leader>g  git
--   <leader>l  LSP                 <leader>d  debugger
--   <leader>h  git hunks           <leader>b  buffers
--   <leader>t  terminal            <leader>T  tab pages
--   <leader>x  diagnostics         <leader>s  AI (sidekick)
--   <leader>a  outline             <leader>v  splits
--   <leader>w/q  write / quit

local map = vim.keymap.set

-- files
map("n", "<leader>w", "<cmd>write<cr>", { silent = true, desc = "Write buffer" })
map("n", "<leader>q", "<cmd>quit<cr>", { silent = true, desc = "Quit window" })
map("n", "<leader>Q", "<cmd>quitall!<cr>", { silent = true, desc = "Force quit all" })

-- movement
map("n", "j", "gj", { desc = "Down (display line)" })
map("n", "k", "gk", { desc = "Up (display line)" })
map("n", "J", "^", { desc = "Start of line" })
map("n", "K", "$", { desc = "End of line" })

map("i", "<c-h>", "<left>", { desc = "Move left" })
map("i", "<c-j>", "<down>", { desc = "Move down" })
map("i", "<c-k>", "<up>", { desc = "Move up" })
map("i", "<c-l>", "<right>", { desc = "Move right" })
map("i", "jj", "<esc>", { desc = "Leave insert mode" })
map("i", "<d-space>", "<nop>", { desc = "Ignore layout switch" })

-- windows
map("n", "<c-h>", "<c-w>h", { desc = "Window left" })
map("n", "<c-j>", "<c-w>j", { desc = "Window down" })
map("n", "<c-k>", "<c-w>k", { desc = "Window up" })
map("n", "<c-l>", "<c-w>l", { desc = "Window right" })
map("n", "<leader>vs", "<c-w>v", { desc = "Split vertical" })
map("n", "<leader>vh", "<c-w>s", { desc = "Split horizontal" })

-- visual
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- yank / paste
map("n", "x", '"_x', { desc = "Delete without yanking" })
map("n", "<C-Y>", function()
    vim.cmd("normal! yyp")
    vim.cmd("normal! ==")
end, { desc = "Duplicate line" })

-- scrolling
map("n", "<c-u>", "<c-u>zz", { desc = "Scroll up (centered)" })
map("n", "<c-d>", "<c-d>zz", { desc = "Scroll down (centered)" })

-- numbers
map("n", "+", "<c-a>", { desc = "Increment number" })
map("n", "-", "<c-x>", { desc = "Decrement number" })

-- buffers (plugin-independent)
map("n", "<leader>bb", "<cmd>edit #<cr>", { silent = true, desc = "Alternate buffer" })

-- tab pages (rarely used, hence the separate prefix)
map("n", "<leader>Tn", "<cmd>tabnew<cr>", { silent = true, desc = "Tab: new" })
map("n", "<leader>Td", "<cmd>tab split<cr>", { silent = true, desc = "Tab: duplicate" })
map("n", "<leader>Te", "<cmd>tabedit ", { desc = "Tab: edit file" })
map("n", "<leader>Tc", "<cmd>tabclose<cr>", { silent = true, desc = "Tab: close" })
map("n", "<leader>To", "<cmd>tabonly<cr>", { silent = true, desc = "Tab: close others" })
map("n", "<leader>Tm", "<cmd>tabmove ", { desc = "Tab: move" })

-- search
map("n", "<leader>hl", "<cmd>nohlsearch<cr>", { silent = true, desc = "Clear search highlight" })
