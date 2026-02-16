vim.api.nvim_create_autocmd("Signal", {
  pattern = "SIGUSR1",
  group = vim.api.nvim_create_augroup("reload_colors_on_signal", {}),
  callback = function()
    vim.cmd(":so ~/.config/nvim/lua/settings/colors.lua")
    vim.schedule(vim.cmd.redraw)
  end,
  nested = true,
})
