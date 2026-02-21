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
  group = augroup("hotreload"),
  callback = function()
    -- Исправлено: colorscheme (было colorsheme)
    pcall(vim.cmd, "colorscheme default")
    package.loaded['settings.colors'] = nil

    -- Исправлено: pcall (было pccal) и function (было funcion)
    -- Исправлено: colors.lua (было colosheme.lua) и закрывающая скобка
    local success, err = pcall(function()
      vim.cmd("source ~/.config/nvim/lua/settings/colors.lua")
    end)
    
    if not success then
      vim.notify("Error while loading scheme: " .. err, vim.log.levels.ERROR)
    else
      vim.notify("Theme updated", vim.log.levels.INFO)
    end

    vim.schedule(function()
      pcall(vim.cmd, "redraw!")
    end)
  end,
  nested = true,
})
