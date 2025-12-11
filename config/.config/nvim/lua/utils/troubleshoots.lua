require("trouble").setup {
  position = "bottom",
  height = 10,
  focus = true,
  auto_jump = false,
  keys = {
    q = "close",
    ["<esc>"] = "cancel",
    ["<cr>"] = "jump",
    o = "jump_close",
    j = "next",
    k = "prev",
    dd = "delete",
    r = "refresh",
    R = "toggle_refresh",
  },
  icons = {
    indent = {
      top = " ",
      middle = " ",
      last = " ",
      fold_open = " ",
      fold_closed = " ",
      ws = " ",
    },
    folder_closed = " ",
    folder_open = " ",
  },
}


-- vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")
-- vim.keymap.set("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>")
-- vim.keymap.set("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")
