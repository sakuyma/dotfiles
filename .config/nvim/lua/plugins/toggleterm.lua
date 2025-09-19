require("toggleterm").setup {
  direction = "horizontal",
  open_mapping = [[<c-\>]],
  start_in_insert = true,
  size = 15,
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  insert_mappings = true,
  persist_size = true,
  close_on_exit = false,
  float_opts = {
    border = "curved",
    winblend = 2,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
}


vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { silent = true })
vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { silent = true })
