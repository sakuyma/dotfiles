-- setup plugin manager --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- setup plugins --
require("lazy").setup {   
  ui = {
    border = "rounded",
    size = {
      width = 0.75,
      height = 0.75,
    },
    icons = require("icons").plugins,
  },
  spec = {
    -- icons
    {
      "nvim-tree/nvim-web-devicons",
      version = "*",
    },
    -- lsp
    {
      "neovim/nvim-lspconfig",
      event = {
        "BufReadPost",
        "BufNewFile",
      },
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
      },
    },
    -- completion
    {
      "hrsh7th/nvim-cmp",
      event = {
        "BufReadPost",
        "BufNewFile",
      },
      dependencies = {
        "onsails/lspkind.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
      },
    },
    -- syntax
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      event = "VeryLazy",
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
    },
    -- outline
    {
      "stevearc/aerial.nvim",
      version = "^v2.0.0",
      event = {
        "BufReadPost",
        "BufNewFile",
      },
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
    },
    -- ui-improvement
    {
      "folke/noice.nvim",
      event = {
        "VeryLazy",
      },
      dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
      },
    },
    {
      "lewis6991/gitsigns.nvim",
      event = {
        "BufReadPre",
        "BufNewFile",
      },
    },
    -- formatter
    {
      "stevearc/conform.nvim",
      event = {
        "BufReadPost",
        "BufNewFile",
      },
    },
    -- debugger
    {
      "mfussenegger/nvim-dap",
      event = {
        "BufReadPost",
        "BufNewFile",
      },
      dependencies = {
        "nvim-neotest/nvim-nio",
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
      },
    },
    -- troubleshoots
    {
      "folke/trouble.nvim",
      event = {
        "BufReadPre",
        "BufNewFile",
      },
    },
    -- autopairs
    {
      "windwp/nvim-autopairs",
      event = {
        "InsertEnter",
      },
    },
    -- terminal
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      event = {
        "BufReadPost",
        "BufNewFile",
      },
    },
    -- theme --
    {
        "catppuccin/nvim",
        lazy = false,
        priority = 1000
    },
		{
      'akinsho/bufferline.nvim',
      version = "*",
      dependencies = {
        'nvim-tree/nvim-web-devicons',
      },
      after = "catppuccin",	
    },

    -- indents
    {
      "lukas-reineke/indent-blankline.nvim",
      event = {
        "BufReadPost",
        "BufNewFile",
      },
    },
    -- dashboard
    {
      "nvimdev/dashboard-nvim",
      lazy = false,
    },
    -- explorer + lazygit
    {
      "folke/snacks.nvim",
      version = "*",
    },
    -- statusline
    {
      "nvim-lualine/lualine.nvim",
      lazy = false,
    },
    -- todocomments
    {
      "folke/todo-comments.nvim",
      event = {
        "BufReadPre",
        "BufNewFile",
      },
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },
    -- finder
    {
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "folke/todo-comments.nvim",
      },
    },
    {
      "mfussenegger/nvim-lint",
    },
    -- AI
    {
  	"folke/sidekick.nvim",
    },
    -- Colorizer
    {
        "norcalli/nvim-colorizer.lua",
    },
 },
    }
