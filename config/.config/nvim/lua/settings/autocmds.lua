-- general options --
local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
  return vim.api.nvim_create_augroup("general_" .. name, { clear = true })
end


-- check for spell in text filetypes --
autocmd("FileType", {
  group = augroup("spell"),
  pattern = {
    "text",
    "markdown",
  },
  callback = function()
    vim.opt_local.spelllang = {
      "ru",
      "en",
    }
    vim.opt_local.spell = true
  end,
})


-- highlight on yank --
autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({
      higroup = "Visual",
      timeout = 500,
      on_visual = true,
    })
  end,
})

autocmd("Signal", {
  pattern = "SIGUSR1",
  group = vim.api.nvim_create_augroup("reload_colors_on_signal", {}),
  callback = function()
    vim.cmd(":so ~/.config/nvim/lua/settings/colors.lua")
    vim.schedule(vim.cmd.redraw)
  end,
  nested = true,
})

