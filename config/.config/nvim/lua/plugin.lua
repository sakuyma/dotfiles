-- setup plugin manager --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- setup plugins --
require("lazy").setup({
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
            lazy = true,
        },
        -- lsp
        {
            "neovim/nvim-lspconfig",
            event = { "BufReadPost", "BufNewFile" },
            dependencies = {
                "williamboman/mason.nvim",
                "williamboman/mason-lspconfig.nvim",
            },
        },
        -- completion
        {
            "hrsh7th/nvim-cmp",
            lazy = true,
            event = "InsertEnter",
            dependencies = {
                { "onsails/lspkind.nvim", lazy = true, event = "InsertEnter" },
                { "hrsh7th/cmp-nvim-lsp", lazy = true, event = "InsertEnter" },
                { "hrsh7th/cmp-buffer", lazy = true, event = "InsertEnter" },
                { "hrsh7th/cmp-path", lazy = true, event = "InsertEnter" },
                { "hrsh7th/cmp-cmdline", lazy = true, event = "InsertEnter" },
                { "saadparwaiz1/cmp_luasnip", lazy = true, event = "InsertEnter" },
            },
        },
        -- syntax
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            event = { "BufReadPost", "BufNewFile" },
            cmd = { "TSInstall", "TSUpdate" },
        },
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            dependencies = { "nvim-treesitter/nvim-treesitter" },
            event = { "BufReadPost", "BufNewFile" },
        },
        -- outline
        {
            "stevearc/aerial.nvim",
            version = "^v2.0.0",
            cmd = "AerialToggle",
            keys = { "<leader>a" },
        },
        -- ui-improvement
        {
            "folke/noice.nvim",
            event = "VeryLazy",
            dependencies = {
                "MunifTanjim/nui.nvim",
                "rcarriga/nvim-notify",
            },
        },
        {
            "lewis6991/gitsigns.nvim",
            event = "BufReadPost",
            keys = {
                { "]c", function() require("gitsigns").next_hunk() end },
                { "[c", function() require("gitsigns").prev_hunk() end },
            },
        },
        -- formatter
        {
            "stevearc/conform.nvim",
            event = { "BufReadPost", "BufNewFile" },
        },
        -- debugger
        {
            "mfussenegger/nvim-dap",
            event = { "BufReadPost", "BufNewFile" },
            dependencies = {
                "nvim-neotest/nvim-nio",
                "rcarriga/nvim-dap-ui",
                "theHamsta/nvim-dap-virtual-text",
            },
        },
        -- troubleshoots
        {
            "folke/trouble.nvim",
            cmd = "Trouble",
            keys = { "<leader>xx" },
        },
        -- autopairs
        {
            "windwp/nvim-autopairs",
            event = "InsertEnter",
        },
        -- terminal
        {
            "akinsho/toggleterm.nvim",
            cmd = "ToggleTerm",
            keys = { "<leader>tt" },
        },
        -- theme (catppuccin основная, остальные ленивые)
        {
            "catppuccin/nvim",
            lazy = false,
            priority = 1000,
        },
        {
            "neanias/everforest-nvim",
            lazy = true,
        },
        {
            "ellisonleao/gruvbox.nvim",
            lazy = true,
        },
        {
            "rebelot/kanagawa.nvim",
            lazy = true,
        },
        {
            "rose-pine/neovim",
            lazy = true,
        },
        {
            "folke/tokyonight.nvim",
            lazy = true,
        },
        -- tabs
        {
            "akinsho/bufferline.nvim",
            event = "BufAdd",
            dependencies = { "nvim-tree/nvim-web-devicons" },
        },
        -- dashboard
        {
            "nvimdev/dashboard-nvim",
            event = "VimEnter",
        },
        -- explorer + lazygit + indent
        {
            "folke/snacks.nvim",
            lazy = true,
            keys = {
                { "<leader>e", function() require("snacks").explorer() end },
                { "<leader>gg", function() require("snacks").lazygit() end },
            },
        },
        -- statusline
        {
            "nvim-lualine/lualine.nvim",
            event = "VeryLazy",
        },
        -- todocomments
        {
            "folke/todo-comments.nvim",
            event = { "BufReadPre", "BufNewFile" },
            dependencies = { "nvim-lua/plenary.nvim" },
        },
        -- finder
        {
            "nvim-telescope/telescope.nvim",
            branch = "0.1.x",
            cmd = "Telescope",
            keys = {
                { "<leader>ff", "<cmd>Telescope find_files<cr>" },
                { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
            },
            dependencies = {
                "nvim-lua/plenary.nvim",
                "folke/todo-comments.nvim",
            },
        },
        {
            "mfussenegger/nvim-lint",
            event = { "BufReadPost", "BufNewFile" },
        },
        -- AI
        {
            "folke/sidekick.nvim",
            lazy = true,
            cmd = "Sidekick",
        },
        -- Colorizer
        {
            "norcalli/nvim-colorizer.lua",
            event = { "BufReadPost", "BufNewFile" },
        },
        {
            "nvim-mini/mini.surround",
            event = "VeryLazy",
        },
        -- Obsidian in term
        {
            "MeanderingProgrammer/render-markdown.nvim",
            ft = "markdown",
            lazy = true,
            config = function()
                require("render-markdown").setup({})
            end,
        },
        {
            "epwalsh/obsidian.nvim",
            lazy = true,
            ft = "markdown",
            dependencies = { "nvim-lua/plenary.nvim" },
        },
        {
            'saecki/crates.nvim',
            ft = "toml",
            tag = 'stable',
            config = function()
                require('crates').setup()
            end,
        },
    },
})
