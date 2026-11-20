-- Plugin declarations. Behaviour lives in the modules under lua/{ui,code,utils};
-- keymaps live here so lazy.nvim can load a plugin on first use.

-- bootstrap lazy.nvim
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

require("lazy").setup({
    ui = {
        border = "rounded",
        size = { width = 0.75, height = 0.75 },
        icons = require("icons").plugins,
    },
    spec = {
        ------------------------------------------------------------------
        -- startup
        ------------------------------------------------------------------
        {
            "catppuccin/nvim",
            name = "catppuccin",
            lazy = false,
            priority = 1000,
            config = function()
                require("ui.theme").setup()
            end,
        },
        {
            "nvim-treesitter/nvim-treesitter",
            branch = "main",
            lazy = false,
            priority = 100,
            build = ":TSUpdate",
            config = function()
                require("utils.treesitter").setup()
            end,
        },
        {
            "nvim-tree/nvim-web-devicons",
            lazy = true,
        },
        {
            "folke/snacks.nvim",
            lazy = false,
            priority = 900,
            config = function()
                require("ui.snacks").setup()
            end,
            keys = {
                {
                    "<leader>t",
                    function()
                        require("snacks").terminal.toggle()
                    end,
                    mode = { "n", "t" },
                    desc = "Terminal: toggle",
                },
                {
                    "<leader>n",
                    function()
                        require("snacks").explorer()
                    end,
                    desc = "Explorer",
                },
                {
                    "<leader>ff",
                    function()
                        require("snacks").picker.files()
                    end,
                    desc = "Find: files",
                },
                {
                    "<leader>fo",
                    function()
                        require("snacks").picker.recent()
                    end,
                    desc = "Find: recent files",
                },
                {
                    "<leader>fg",
                    function()
                        require("snacks").picker.grep()
                    end,
                    desc = "Find: live grep",
                },
                {
                    "<leader>fb",
                    function()
                        require("snacks").picker.buffers()
                    end,
                    desc = "Find: buffers",
                },
                {
                    "<leader>ft",
                    function()
                        require("snacks").picker.todo_comments()
                    end,
                    desc = "Find: todo comments",
                },
                {
                    "<leader>gg",
                    function()
                        require("snacks").lazygit()
                    end,
                    desc = "Git: lazygit",
                },
                {
                    "<leader>gb",
                    function()
                        require("snacks").picker.git_branches()
                    end,
                    desc = "Git: branches",
                },
                {
                    "<leader>gc",
                    function()
                        require("snacks").picker.git_log()
                    end,
                    desc = "Git: commits",
                },
                {
                    "<leader>gs",
                    function()
                        require("snacks").picker.git_status()
                    end,
                    desc = "Git: status",
                },
                {
                    "<leader>bd",
                    function()
                        require("snacks").bufdelete.delete()
                    end,
                    desc = "Buffer: delete",
                },
                {
                    "<leader>bo",
                    function()
                        require("snacks").bufdelete.others()
                    end,
                    desc = "Buffer: delete others",
                },
            },
        },
        ------------------------------------------------------------------
        -- editing
        ------------------------------------------------------------------
        {
            "echasnovski/mini.pairs",
            event = "InsertEnter",
            opts = {
                modes = { insert = true, command = false, terminal = false },
                mappings = {
                    ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
                    ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
                    ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
                    [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
                    ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
                    ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
                    ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
                    ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
                    ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
                },
            },
        },
        {
            "norcalli/nvim-colorizer.lua",
            event = "BufReadPost",
            opts = {},
        },
        ------------------------------------------------------------------
        -- lsp + completion
        ------------------------------------------------------------------
        {
            "neovim/nvim-lspconfig",
            event = { "BufReadPre", "BufNewFile" },
            dependencies = {
                "williamboman/mason.nvim",
                "williamboman/mason-lspconfig.nvim",
                "hrsh7th/cmp-nvim-lsp",
            },
            config = function()
                require("code.lsp").setup()
            end,
        },
        {
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            dependencies = {
                "L3MON4D3/LuaSnip",
                { "onsails/lspkind.nvim", lazy = true, event = "InsertEnter" },
                { "hrsh7th/cmp-nvim-lsp", lazy = true, event = "InsertEnter" },
                { "hrsh7th/cmp-buffer", lazy = true, event = "InsertEnter" },
                { "hrsh7th/cmp-path", lazy = true, event = "InsertEnter" },
                { "hrsh7th/cmp-cmdline", lazy = true, event = "InsertEnter" },
                { "saadparwaiz1/cmp_luasnip", lazy = true, event = "InsertEnter" },
            },
            config = function()
                require("code.completion").setup()
            end,
        },
        ------------------------------------------------------------------
        -- code tooling
        ------------------------------------------------------------------
        {
            "stevearc/conform.nvim",
            cmd = "ConformInfo",
            config = function()
                require("code.formatter").setup()
            end,
            keys = {
                {
                    "<leader>lf",
                    function()
                        require("conform").format({ async = true, lsp_format = "fallback" })
                    end,
                    mode = { "n", "v" },
                    desc = "Format buffer",
                },
            },
        },
        {
            "mfussenegger/nvim-lint",
            event = { "BufReadPost", "BufWritePost" },
            config = function()
                require("code.linters").setup()
            end,
        },
        {
            "mfussenegger/nvim-dap",
            dependencies = {
                "nvim-neotest/nvim-nio",
                "rcarriga/nvim-dap-ui",
                "theHamsta/nvim-dap-virtual-text",
            },
            config = function()
                require("code.debugger").setup()
            end,
            keys = {
                {
                    "<F5>",
                    function()
                        require("dap").continue()
                    end,
                    desc = "Debug: continue",
                },
                {
                    "<F10>",
                    function()
                        require("dap").step_over()
                    end,
                    desc = "Debug: step over",
                },
                {
                    "<F11>",
                    function()
                        require("dap").step_into()
                    end,
                    desc = "Debug: step into",
                },
                {
                    "<F12>",
                    function()
                        require("dap").step_out()
                    end,
                    desc = "Debug: step out",
                },
                {
                    "<leader>db",
                    function()
                        require("dap").toggle_breakpoint()
                    end,
                    desc = "Debug: toggle breakpoint",
                },
                {
                    "<leader>dB",
                    function()
                        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                    end,
                    desc = "Debug: conditional breakpoint",
                },
                {
                    "<leader>dl",
                    function()
                        require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
                    end,
                    desc = "Debug: log point",
                },
                {
                    "<leader>dr",
                    function()
                        require("dap").repl.open()
                    end,
                    desc = "Debug: REPL",
                },
                {
                    "<leader>dL",
                    function()
                        require("dap").run_last()
                    end,
                    desc = "Debug: run last",
                },
                {
                    "<leader>du",
                    function()
                        require("dapui").toggle()
                    end,
                    desc = "Debug: toggle UI",
                },
                {
                    "<leader>dx",
                    function()
                        require("dap").terminate()
                    end,
                    desc = "Debug: terminate",
                },
            },
        },
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            branch = "main",
            event = { "BufReadPost", "BufNewFile" },
            dependencies = { "nvim-treesitter/nvim-treesitter" },
            config = function()
                require("utils.textobjects").setup()
            end,
        },
        {
            "stevearc/aerial.nvim",
            cmd = "AerialToggle",
            config = function()
                require("code.outline").setup()
            end,
            keys = {
                { "<leader>a", "<cmd>AerialToggle!<cr>", desc = "Outline: toggle" },
            },
        },
        ------------------------------------------------------------------
        -- git
        ------------------------------------------------------------------
        {
            "lewis6991/gitsigns.nvim",
            event = { "BufReadPost", "BufNewFile" },
            config = function()
                require("code.gitsigns").setup()
            end,
            keys = {
                {
                    "]c",
                    function()
                        require("gitsigns").next_hunk()
                    end,
                    desc = "Next hunk",
                },
                {
                    "[c",
                    function()
                        require("gitsigns").prev_hunk()
                    end,
                    desc = "Previous hunk",
                },
                {
                    "<leader>hs",
                    function()
                        require("gitsigns").stage_hunk()
                    end,
                    mode = { "n", "v" },
                    desc = "Hunk: stage",
                },
                {
                    "<leader>hr",
                    function()
                        require("gitsigns").reset_hunk()
                    end,
                    mode = { "n", "v" },
                    desc = "Hunk: reset",
                },
                {
                    "<leader>hS",
                    function()
                        require("gitsigns").stage_buffer()
                    end,
                    desc = "Hunk: stage buffer",
                },
                {
                    "<leader>hR",
                    function()
                        require("gitsigns").reset_buffer()
                    end,
                    desc = "Hunk: reset buffer",
                },
                {
                    "<leader>hp",
                    function()
                        require("gitsigns").preview_hunk()
                    end,
                    desc = "Hunk: preview",
                },
                {
                    "<leader>hb",
                    function()
                        require("gitsigns").blame_line()
                    end,
                    desc = "Hunk: blame line",
                },
                {
                    "<leader>hB",
                    function()
                        require("gitsigns").toggle_current_line_blame()
                    end,
                    desc = "Toggle line blame",
                },
                {
                    "<leader>hd",
                    function()
                        require("gitsigns").diffthis()
                    end,
                    desc = "Hunk: diff this",
                },
            },
        },
        ------------------------------------------------------------------
        -- ui
        ------------------------------------------------------------------
        {
            "akinsho/bufferline.nvim",
            event = "BufAdd",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                require("ui.bufferline").setup()
            end,
            keys = {
                { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Buffer: next" },
                { "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", desc = "Buffer: previous" },
            },
        },
        {
            "folke/noice.nvim",
            event = "VeryLazy",
            dependencies = { "MunifTanjim/nui.nvim" },
            config = function()
                require("ui.noice").setup()
            end,
        },
        -- diagnostics / todos / markdown
        {
            "folke/trouble.nvim",
            cmd = "Trouble",
            config = function()
                require("utils.trouble").setup()
            end,
            keys = {
                { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
                { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "TODOs (Trouble)" },
                { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
            },
        },
        {
            "folke/todo-comments.nvim",
            event = { "BufReadPre", "BufNewFile" },
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function()
                require("utils.todo").setup()
            end,
        },
        {
            "OXY2DEV/markview.nvim",
            lazy = false,
            dependencies = { "nvim-treesitter/nvim-treesitter" },
            opts = {
                previewers = {
                    latex = {
                        engine = "pdftocairo", -- Use "magick" (ImageMagick) or "pdftocairo"
                    },
                },
            },
        },
        {
            "OXY2DEV/helpview.nvim",
            lazy = false,
            config = function()
                require("ui.helpview").setup()
            end,
        },
        -- {
        --     "epwalsh/obsidian.nvim",
        --     ft = "markdown",
        --     dependencies = {
        --         "nvim-lua/plenary.nvim",
        --         "echasnovski/mini.pick",
        --     },
        --     config = function()
        --         require("utils.obsidian").setup()
        --     end,
        -- },
        {
            "echasnovski/mini.pick",
            lazy = true,
        },
        {
            "saecki/crates.nvim",
            ft = "toml",
            tag = "stable",
            opts = {},
        },
        -- ai
        {
            "folke/sidekick.nvim",
            cmd = "Sidekick",
            config = function()
                require("code.sidekick").setup()
            end,
            keys = {
                { "<leader>sc", "<cmd>Sidekick cli toggle<cr>", desc = "AI: toggle CLI" },
            },
        },
    },
})

-- The statusline is native (no plugin); set it up after lazy.nvim has loaded the
-- colorscheme so the palette is available.
require("ui.statusline").setup()
