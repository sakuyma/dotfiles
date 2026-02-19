return {
  -- theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("theme").setup()
   end,
  },
  
  -- Bufferline (вкладки)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "catppuccin/nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("tabs").setup()
    end,
  },
  
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("statusline").setup()
    end,
  },
  
  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup()
    end,
  },
  
  -- Notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notifications").setup()
    end,
  },
  
  -- UI improvements
  {
    "stevearc/dressing.nvim",
    config = function()
      require("ui-improvement").setup()
    end,
  },
}
