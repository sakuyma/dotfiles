-- setup lazy.nvim --
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
    icons = {
      cmd = " ",
      debug = " ",
      event = "󱐋 ",
      keys = "󰌆 ",
      loaded = "",
      not_loaded = "",
      plugin = "󰏔 ",
      runtime = " ",
      source = "󰘬 ",
      start = " ",
    },
  },
  
  spec = {


    -- neovim/nvim-lspconfig - lsp config
    { 
      "neovim/nvim-lspconfig", event = { "BufReadPost", "BufNewFile" }, 
      dependencies = { 
        { "williamboman/mason.nvim", event = "VeryLazy" }, 
        { "williamboman/mason-lspconfig.nvim", event = "VeryLazy" }, 
      },
    },


    -- hrsh7th/nvim-cmp - autocomplete
    {
      "hrsh7th/nvim-cmp", event = { "BufReadPost", "BufNewFile" },
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


    -- nvim-treesitter/nvim-treesitter - syntax highlighting
    {
      "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", event = "VeryLazy",
    },

    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
    },


    -- stevearc/aerial.nvim - code outline window
    {
      "stevearc/aerial.nvim", version = "^v2.0.0", event = { "BufReadPost", "BufNewFile" },
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
      },
    },


    -- stevearc/conform.nvim - formatter
    {
      "stevearc/conform.nvim", event = { "BufReadPost", "BufNewFile" }
    },


    -- mfussenegger/nvim-dap - debugger
    {
      "mfussenegger/nvim-dap", event = { "BufReadPost", "BufNewFile" },
      dependencies = {
        "nvim-neotest/nvim-nio",
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
      },
    },


    -- folke/trouble.nvim - diagnostics, references and location list
    {
      "folke/trouble.nvim", event = { "BufReadPre", "BufNewFile" },
    },


    -- windwp/nvim-autopairs - auto close pairs
    {
      "windwp/nvim-autopairs", event = "InsertEnter", config = true,
    },


    -- akinsho/toggleterm.nvim - terminal
    {
      "akinsho/toggleterm.nvim", version = "*", event = { "BufReadPost", "BufNewFile" },
    },


    -- catppuccin/nvim - theme
    {
      "catppuccin/nvim", lazy = false,
    },


    -- lukas-reineke/indent-blankline - indent guides
    {
      "lukas-reineke/indent-blankline.nvim", event = { "BufReadPost", "BufNewFile" },
    },


    -- nvimdev/dashboard-nvim - dashboard
    {
      "nvimdev/dashboard-nvim", lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
    },


    -- nvim-tree/nvim-tree.lua - files tree
    {
      "nvim-tree/nvim-tree.lua", version = "*",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
    },


    -- nvim-lualine/lualine.nvim - status line 
    {
      "nvim-lualine/lualine.nvim",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
    },


    -- folke/todo-comments.nvim - todo comments
    {
      "folke/todo-comments.nvim", event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },


    -- nvim-telescope/telescope.nvim - fuzzy finder
    {
      "nvim-telescope/telescope.nvim", branch = "0.1.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },


  },

}
