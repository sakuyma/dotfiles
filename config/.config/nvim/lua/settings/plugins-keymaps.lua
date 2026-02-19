--  general options --
local key = vim.keymap.set                  -- set local variable
vim.g.mapleader = " "                       -- set <leader> key


-- debugger --
local dap = require("dap")
local dapui = require("dapui")
key("n", "<F5>", function() dap.continue() end)
key("n", "<F10>", function() dap.step_over() end)
key("n", "<F11>", function() dap.step_into() end)
key("n", "<F12>", function() dap.step_out() end)
key("n", "<leader>b", function() dap.toggle_breakpoint() end)
key("n", "<leader>B", function() dap.set_breakpoint(vim.fn.input("breakpoint condition: ")) end)
key("n", "<leader>lp", function() dap.set_breakpoint(nil, nil, vim.fn.input("log point message: ")) end)
key("n", "<leader>dr", function() dap.repl.open() end)
key("n", "<leader>dl", function() dap.run_last() end)
key("n", "<leader>du", function() dapui.toggle() end)


-- formatter --
key({ "n", "v", }, "<leader>fc", function()
  require("conform").format { async = true, lsp_fallback = true, }
end)


-- outline --
key("n", "<leader>a", "<cmd>AerialToggle!<cr>")
key("n", "[[", "<cmd>AerialPrev<cr>")
key("n", "]]", "<cmd>AerialNext<cr>")


-- vcs --
key("n", "]c", "<cmd>Gitsigns next_hunk<cr>")
key("n", "[c", "<cmd>Gitsigns prev_hunk<cr>")
key("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>")
key("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>")
key("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<cr>")
key("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<cr>")
key("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>")
key("n", "<leader>hb", "<cmd>Gitsigns blame_line<cr>")
key("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<cr>")
key("n", "<leader>hd", "<cmd>Gitsigns diffthis<cr>")
key("v", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>")
key("v", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>")


-- explorer --
key("n", "<leader>n", "<cmd>lua Snacks.explorer()<cr>", { silent = true })


-- finder --
local builtin = require("telescope.builtin")
key("n", "<leader>ff", builtin.find_files)
key("n", "<leader>fo", builtin.oldfiles)
key("n", "<leader>ft", builtin.live_grep)
key("n", "<leader>tt", "<cmd>TodoTelescope<cr>")
key("n", "<leader>gb", builtin.git_branches)
key("n", "<leader>gc", builtin.git_commits)
key("n", "<leader>gs", builtin.git_status)


-- troubleshoots --
key("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")
key("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>")
key("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")

-- tabs --
key('n', '<Tab>','<Cmd>BufferLineCycleNext<CR>', { noremap = true, silent = true })
key('n', '<S-Tab>','<Cmd>BufferLineCycleNext<CR>', { noremap = true, silent = true })
key('n', 'tt', '<Cmd>BufferLineCycleNext<CR>', { noremap = true, silent = true })

key('n', '<leader>rn', ':file ', { noremap = true, desc = 'Rename buffer (display name)' })
key('n', '<leader>tn', '<Cmd>tabnew<CR>', { noremap = true,silent = true, desc = 'New tab' })

key('n', '<leader>td', '<Cmd>tab split<CR>', { noremap = true, silent = true, desc = 'Duplicate tab' })
key('n', '<leader>te', ':tabedit ', { noremap = true, desc = 'Edit file in new tab'
})
key('n', '<leader>tc', '<Cmd>tabclose<CR>', { desc = 'Close tab' })
key('n', '<leader>to', '<Cmd>tabonly<CR>', { desc = 'Close other tabs' })
key('n', '<leader>tm', '<Cmd>tabmove ', { desc = 'Move tab to position' })


-- Open LazyGit menu -- 
key('n', '<leader>lg', '<cmd>lua Snacks.lazygit()<cr>', { desc = 'LazyGit' })
key('n', '<bs>', ':edit #<cr>', { silent = true })

-- Open Sidekick (Ai) menu --

key("n", "<leader>sc", "<cmd>Sidekick cli toggle<cr>", { silent = true, desc = "Toggle Sidekick CLI" })
