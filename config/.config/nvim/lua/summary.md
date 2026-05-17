
# plugin.lua

```
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
            lazy = true,
            event = "InsertEnter",

            dependencies = {
                {
                    "onsails/lspkind.nvim",
                    lazy = true,
                    event = "InsertEnter"
                },
                {
                    "hrsh7th/cmp-nvim-lsp",
                    lazy = true,
                    event = "InsertEnter"
                },
                {
                    "hrsh7th/cmp-buffer",
                    lazy = true,
                    event = "InsertEnter",
                },
                {
                    "hrsh7th/cmp-path",
                    lazy = true,
                    event = "InsertEnter",
                },
                {
                    "hrsh7th/cmp-cmdline",
                    lazy = true,
                    event = "InsertEnter",
                },
                {
                    "L3MON4Dl3/LuaSnip",
                    lazy = true,
                    event = "InsertEnter",
                    build = "make install_jsregexp",
                },
                {
                    "saadparwaiz1/cmp_luasnip",
                    lazy = true,
                    event = "InsertEnter"
                },
            },
        },
        -- syntax
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            event = { "BufReadPost", "BufNewFile" },
            cmd = { "TSInstall", "TSUpdate" }
        },
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            dependencies = {
                "nvim-treesitter/nvim-treesitter",
            },
            event = { "BufReadPost", "BufNewFile" },
        },
        -- outline
        {
            "stevearc/aerial.nvim",
            version = "^v2.0.0",
            event = {
                "BufReadPost",
                "BufNewFile",
            },
            cmd = "AerialToggle"
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
            event = "VeryLazy",
            keys = {
                { "]c", function() require("gitsigns").next_hunk() end },
                { "[c", function() require("gitsigns").prev_hunk() end },
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
            priority = 1000,
        },
        {
            "neanias/everforest-nvim",
            lazy = false,
            priority = 1000,
        },
        {
            "ellisonleao/gruvbox.nvim",
            lazy = false,
            priority = 1000,
        },
        {
            "rebelot/kanagawa.nvim",
            lazy = false,
            priority = 1000,
        },
        {
            "rose-pine/neovim",
            lazy = false,
            priority = 1000,
        },
        {
            "folke/tokyonight.nvim",
            lazy = false,
            priority = 1000,
        },
        -- tabs
        {
            "akinsho/bufferline.nvim",
            version = "*",
            dependencies = {
                "nvim-tree/nvim-web-devicons",
            },
        },
        -- dashboard
        {
            "nvimdev/dashboard-nvim",
            lazy = false,
        },
        -- explorer + lazygit + indent
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
        {
            "nvim-mini/mini.surround",
        },
        -- Obsidian in term
        {
            "MeanderingProgrammer/render-markdown.nvim",
            ft = "markdown",
            lazy = true,
            config = function()
                require("render").setup({})
            end,
        },
        {
            "epwalsh/obsidian.nvim",
            version = "*",
            lazy = true,
            ft = "markdown",
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
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

```

# require.lua

```
-- plugins --
require("plugin")

-- theme setup (must be before colorscheme) --
require("ui.theme")

-- settings (early load for colorscheme) --
require("settings.colors")
require("settings.options")

-- code --
require("code.autopairs")
require("code.debugger")
require("code.formatter")
require("code.outline")
require("code.vcs")
require("code.linters")
require("code.lsp")
require("code.ai")
-- ui --
require("ui.tabs")
require("ui.statusline")
require("ui.ui-improvement")
require("ui.notifications")
require("ui.dashboard")

-- utils --
require("utils.explorer")
require("utils.finder")
require("utils.terminal")
require("utils.todocomments")
require("utils.troubleshoots")
require("utils.surround")

-- settings --
require("settings.autocmds")
require("settings.keymaps")
require("settings.plugins-keymaps")

```

# utils/markdown.lua

```
require("obsidian.nvim").setup({
    dir = "~/Obsidian",
    notes_subdir = "",
    new_notes_location = "current_dir",
    daily_notes = {
      folder = "dailies",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      default_tags = { "daily" },
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    mappings = {
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },
    
    open_notes_in = "current",
    
    ui = {
      enable = true,
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
      },
    },
    
    attachments = {
      img_folder = "assets",  -- папка для картинок
    },
    
    picker = {
      name = "telescope.nvim",
    },
    
    sort_by = "modified",
    sort_reversed = true,
    
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
})

```

# utils/surround.lua

```
require("mini.surround").setup({
	custom_surroundings = nil,

	-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
	highlight_duration = 500,

	-- Number of lines within which surrounding is searched
	n_lines = 20,

	-- Whether to respect selection type:
	-- - Place surroundings on separate lines in linewise mode.
	-- - Place surroundings on each line in blockwise mode.
	respect_selection_type = false,

	-- How to search for surrounding (first inside current line, then inside
	-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
	-- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
	-- see `:h MiniSurround.config`.
	search_method = "cover",

	-- Whether to disable showing non-error feedback
	-- This also affects (purely informational) helper messages shown after
	-- idle time if user input is required.
	silent = false,
})

```

# utils/explorer.lua

```
require("snacks").setup()

```

# utils/troubleshoots.lua

```
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

```

# utils/todocomments.lua

```
require("todo-comments").setup {
  signs = true,
  sign_priority = 8,
  keywords = {
    FIX = { icon = " ", color = "#f38ba8", alt = { "FIXME", "BUG", "ISSUE", }, },
    TODO = { icon = " ", color = "#a6e3a1", alt = { "DOING", }, },
    WARN = { icon = " ", color = "#f9e2af", alt = { "WARNING", }, },
    PERF = { icon = "󰥔 ", color = "#fab387", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE", }, },
    NOTE = { icon = " ", color = "#89b4fa", alt = { "INFO", }, },
    TEST = { icon = " ", color = "#b4befe", alt = { "TESTING", "PASSED", "FAILED", }, },
  },
  gui_style = {
    fg = "NONE",
    bg = "BOLD",
  },
  merge_keywords = true,
  highlight = {
    multiline = true,
    multiline_context = 10,
    before = "",
    keyword = "wide",
    after = "fg",
    comments_only = true,
    max_line_len = 400,
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    pattern = [[\b(KEYWORDS):]],
  },
}

```

# utils/terminal.lua

```
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
}

```

# utils/finder.lua

```
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")


require("telescope").setup {
  defaults = {
    preview = true,
    initial_mode = "insert",
    path_display = {
      "smart",
    },
    prompt_prefix = "  ",
    selection_caret = "~> ",
    results_title = false,
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.60,
      },
      width = 0.90,
      height = 0.80,
    },
    mappings = {
      i = {
        ["<c-k>"] = actions.move_selection_previous,
        ["<c-j>"] = actions.move_selection_next,
        ["<c-c>"] = actions.close,
      },
    },
    file_ignore_patterns = {
      "%.bin", "%.o", "%.a", "%.so", "%.dll",
      "%.zip", "%.tar", "%.gz",
      "%.png", "%.jpg", "%.jpeg", "%.gif", "%.pdf", "%.mp3", "%.mp4",
    },
  },
  pickers = {
    find_files = {},
    oldfiles = {},
    live_grep = {},
    git_branches = {},
    git_commits = {},
    git_status = {},
  },
}


-- vim.keymap.set("n", "<leader>ff", builtin.find_files)
-- vim.keymap.set("n", "<leader>fo", builtin.oldfiles)
-- vim.keymap.set("n", "<leader>ft", builtin.live_grep)
-- vim.keymap.set("n", "<leader>tt", "<cmd>TodoTelescope<cr>")
-- vim.keymap.set("n", "<leader>gb", builtin.git_branches)
-- vim.keymap.set("n", "<leader>gc", builtin.git_commits)
-- vim.keymap.set("n", "<leader>gs", builtin.git_status)

```

# ui/ui.lua

```
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

```

# ui/ui-improvement.lua

```
require("noice").setup({
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	presets = {
		command_palette = true,
		bottom_search = false,
		long_message_to_split = true,
		inc_rename = false,
		lsp_doc_border = false,
	},
	cmdline = {
		format = {
			cmdline = {
				icon = "->",
			},
			search_down = {
				icon = " ",
			},
			search_up = {
				icon = " ",
			},
			filter = {
				icon = "",
			},
			lua = {
				icon = "",
			},
			help = {
				icon = "",
			},
		},
	},
})
vim.opt.termguicolors = true
require("colorizer").setup()

```

# ui/theme.lua

```
require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true,
	no_italic = true,
	no_bold = true,
	no_underline = true,
	styles = {
		comments = {},
		conditionals = {},
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = {},
		booleans = {},
		properties = {},
		types = {},
		operators = {},
		miscs = {},
	},
	integrations = {
		cmp = true,
		treesitter = true,
		telescope = true,
		bufferline = true,
		mason = true,
	},
})

```

# ui/tabs.lua

```
require("bufferline").setup({
	highlights = require("catppuccin.special.bufferline").get_theme(),
	options = {
		hover = {
			enabled = true,
			delay = 200,
			reveal = { "close" },
		},
		mode = "tabs",
		numbers = "buffer_id",
		separator_style = "slopped",
		always_show_bufferline = true,
		show_buffer_icons = true,
		show_buffer_close_icons = true,
		show_close_icon = true,
		max_name_length = 18,
		truncate_names = true,
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false, -- only applies to coc
		diagnostics_update_on_event = true,
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			return "(" .. count .. ")"
		end,

		indicator = {
			style = "underline",
		},
		buffer_close_icon = "󰅖",
		modified_icon = "● ",
		close_icon = " ",
		left_trunc_marker = " ",
		right_trunc_marker = " ",
	},
})

```

# ui/statusline.lua

```
local colors = {
	fg = "#cdd6f4",
	bg = "#1c1c2c",
	yellow = "#f9e2af",
	cyan = "#89dceb",
	green = "#a6e3a1",
	orange = "#fab387",
	violet = "#b4befe",
	magenta = "#cba6f7",
	blue = "#89b4fa",
	red = "#f38ba8",
	lavender = "#B4BEFE",
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

local config = {
	options = {
		component_separators = "",
		section_separators = "",
		theme = {
			normal = { c = { fg = colors.fg, bg = colors.bg } },
			inactive = { c = { fg = colors.fg, bg = colors.bg } },
		},
		globalstatus = true,
	},
	sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
}

local function insertLeft(component)
	table.insert(config.sections.lualine_c, component)
end
local function insertRight(component)
	table.insert(config.sections.lualine_x, component)
end

insertLeft({
	function()
		return ""
	end,
	color = { fg = colors.lavender },
	padding = { left = 0, right = 1 },
})

insertLeft({
	"mode",
	icon = "",
	color = function()
		local color = {
			n = colors.lavender,
			i = colors.green,
			v = colors.red,
			["\22"] = colors.red,
			V = colors.red,
			c = colors.magenta,
			no = colors.red,
			s = colors.orange,
			S = colors.orange,
			ic = colors.violet,
			R = colors.yellow,
			Rv = colors.violet,
			cv = colors.red,
			ce = colors.red,
			r = colors.cyan,
			rm = colors.cyan,
			["r?"] = colors.cyan,
			["!"] = colors.red,
			t = colors.red,
		}
		return {
			fg = color[vim.fn.mode()],
		}
	end,
	padding = { left = 1, right = 1 },
})

insertLeft({
	"filesize",
	fmt = string.upper,
	cond = conditions.buffer_not_empty,
})

insertLeft({
	"filename",
	cond = conditions.buffer_not_empty,
	file_status = false,
	color = { fg = colors.lavender },
})

insertLeft({
	"location",
})

insertLeft({
	"diagnostics",
	sources = {
		"nvim_diagnostic",
	},
	symbols = {
		error = " ",
		warn = " ",
		hint = " ",
		info = " ",
	},
	diagnostics_color = {
		error = { fg = colors.red },
		warn = { fg = colors.yellow },
		info = { fg = colors.green },
	},
})

insertRight({
	"branch",
	icon = "",
	color = { fg = colors.lavender },
})

insertRight({
	"encoding",
	fmt = string.upper,
	color = { fg = colors.fg },
})

insertRight({
	"fileformat",
	fmt = string.upper,
	icons_enabled = false,
	color = { fg = colors.fg },
})

insertRight({
	"progress",
	fmt = string.upper,
	color = { fg = colors.fg },
})

insertRight({
	function()
		return ""
	end,
	color = { fg = colors.lavender },
	padding = { left = 1, right = 0 },
})

require("lualine").setup(config)

```

# ui/notifications.lua

```
require("notify").setup({
	background_colour = "#11111b",
	render = "wrapped-compact",
	stages = "fade_in_slide_out",
	max_width = 30,
	minimum_width = 30,
	timeout = 2000,
	fps = 60,
	level = 0,
	icons = require("icons").notifications,
})

vim.notify = require("notify")

```

# ui/dashboard.lua

```
local function header()
	return {
		"",
		"",
		"",
		"               __                              ",
		"   _________ _/ /____  ____  ______ ___  ____ _",
		"  / ___/ __  / //_/ / / / / / / __  __ \\/ __  /",
		" (__  ) /_/ / ,< / /_/ / /_/ / / / / / / /_/ / ",
		"/____/\\____/_/|_|\\____/\\__  /_/ /_/ /_/\\____/  ",
		"                      /____/                   ",
		"",
		"",
		"",
	}
end
require("dashboard").setup({
	theme = "doom",
	config = {
		header = header(),
		center = {
			{
				desc = " New file",
				desc_hl = "Comment",
				key = "e",
				key_hl = "Comment",
				key_format = "%s",
				action = ":enew",
			},
			{
				desc = " Explorer",
				desc_hl = "Comment",
				key = "n",
				key_hl = "Comment",
				key_format = "%s",
				action = ":lua Snacks.explorer()",
			},
			{
				desc = " Find file",
				desc_hl = "Comment",
				key = "f",
				key_hl = "Comment",
				key_format = "%s",
				action = ":Telescope find_files",
			},
			{
				desc = " Recently",
				desc_hl = "Comment",
				key = "r",
				key_hl = "Comment",
				key_format = "%s",
				action = ":Telescope oldfiles",
			},
			{
				desc = "󰈆 Quit",
				desc_hl = "Comment",
				key = "q",
				key_hl = "Comment",
				key_format = "%s",
				action = ":q",
			},
		},
		footer = {},
		vertical_center = true,
	},
})

```

# settings/colors.lua

```
-- general options --
local hl = vim.api.nvim_set_hl              -- set local variable
vim.cmd.colorscheme("catppuccin")           -- enable catppuccin colorscheme
vim.opt.background = "dark"                 -- enable dark theme
vim.opt.syntax = "on"                       -- enable syntax highlighting
vim.opt.showmatch = false                   -- disable highlight pair elements


-- neovim --
hl(0, "FloatBorder", { fg = "#89b4fa", bg = "NONE" })
hl(0, "SignColumn", { fg = "NONE" })

-- Indent-blankline
hl(0, "IndentBlankline", { fg = "#3a3a3a", nocombine = true })
hl(0, "IndentBlanklineChar", { fg = "#404040", nocombine = true })
hl(0, "IndentBlanklineContext", { fg = "#808080", nocombine = true })
hl(0, "IndentBlanklineContextChar", { fg = "#808080", nocombine = true })
hl(0, "IndentBlanklineSpaceChar", { fg = "#3a3a3a", nocombine = true })
hl(0, "IndentBlanklineSpaceCharBlankline", { fg = "#3a3a3a", nocombine = true })

-- notifications --
hl(0, "NotifyERRORBorder", { fg = "#f38ba8" })
hl(0, "NotifyWARNBorder", { fg = "#f9e2af" })
hl(0, "NotifyINFOBorder", { fg = "#a6e3a1" })
hl(0, "NotifyDEBUGBorder", { fg = "#89b4fa" })
hl(0, "NotifyTRACEBorder", { fg = "#bac2de" })
hl(0, "NotifyERRORIcon", { fg = "#f38ba8" })
hl(0, "NotifyWARNIcon", { fg = "#f9e2af" })
hl(0, "NotifyINFOIcon", { fg = "#a6e3a1" })
hl(0, "NotifyDEBUGIcon", { fg = "#89b4fa" })
hl(0, "NotifyTRACEIcon", { fg = "#bac2de" })
hl(0, "NotifyERRORTitle", { fg = "#f38ba8" })
hl(0, "NotifyWARNTitle", { fg = "#f9e2af" })
hl(0, "NotifyINFOTitle", { fg = "#a6e3a1" })
hl(0, "NotifyDEBUGTitle", { fg = "#89b4fa" })
hl(0, "NotifyTRACETitle", { fg = "#bac2de" })


-- finder --
hl(0, "TelescopeNormal", { bg = "NONE" })
hl(0, "TelescopePromptTitle", { fg = "#11111b", bg = "#f38ba8" })
hl(0, "TelescopePreviewTitle", { fg = "#B4BEFE", bg = "#B4BEFE" })

```

# settings/plugins-keymaps.lua

```
--  general options --
local key = vim.keymap.set -- set local variable
vim.g.mapleader = " "      -- set <leader> key

-- debugger --
local dap = require("dap")
local dapui = require("dapui")
key("n", "<F5>", function()
    dap.continue()
end)
key("n", "<F10>", function()
    dap.step_over()
end)
key("n", "<F11>", function()
    dap.step_into()
end)
key("n", "<F12>", function()
    dap.step_out()
end)
key("n", "<leader>b", function()
    dap.toggle_breakpoint()
    require("conform").format({ async = true, lsp_fallback = true })
    endap.toggle_breakpoint()
end)
key("n", "<leader>B", function()
    dap.set_breakpoint(vim.fn.input("breakpoint condition: "))
end)
key("n", "<leader>lp", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("log point message: "))
end)
key("n", "<leader>dr", function()
    dap.repl.open()
end)
key("n", "<leader>dl", function()
    dap.run_last()
end)
key("n", "<leader>du", function()
    dapui.toggle()
end)

-- formatter --
key("n", "<leader>=", '<cmd>lua require("conform").format({ async = true, lsp_fallback = true })<cr>')

-- outline --
key("n", "<leader>a", "<cmd>AerialToggle!<cr>")
key("n", "[[", "<cmd>AerialPrev<cr>")
key("n", "]]", "<cmd>AerialNext<cr>")

-- vcs --
key("n", "]c", "<cmd>Gitsigns next_hunk<cr>")
key("n", "[c", "<cmd>Gitsigns prev_hunk<cr>")
key("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>")
key("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>")
key("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<cr>")
key("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<cr>")
key("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>")
key("n", "<leader>hb", "<cmd>Gitsigns blame_line<cr>")
key("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<cr>")
key("n", "<leader>hd", "<cmd>Gitsigns diffthis<cr>")
key("v", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>")
key("v", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>")

-- explorer --
key("n", "<leader>n", "<cmd>lua Snacks.explorer()<cr>", { silent = true })

-- finder --
local builtin = require("telescope.builtin")
key("n", "<leader>ff", builtin.find_files)
key("n", "<leader>fo", builtin.oldfiles)
key("n", "<leader>fg", builtin.live_grep)
key("n", "<leader>tt", "<cmd>TodoTelescope<cr>")
key("n", "<leader>gb", builtin.git_branches)
key("n", "<leader>gc", builtin.git_commits)
key("n", "<leader>gs", builtin.git_status)

-- troubleshoots --
key("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")
key("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>")
key("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")

-- tabs --
key("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { noremap = true, silent = true })
key("n", "<S-Tab>", "<Cmd>BufferLineCycleNext<CR>", { noremap = true, silent = true })
key("n", "tt", "<Cmd>BufferLineCycleNext<CR>", { noremap = true, silent = true })

key("n", "<leader>rn", ":file ", { noremap = true, desc = "Rename buffer (display name)" })
key("n", "<leader>tn", "<Cmd>tabnew<CR>", { noremap = true, silent = true, desc = "New tab" })

key("n", "<leader>td", "<Cmd>tab split<CR>", { noremap = true, silent = true, desc = "Duplicate tab" })
key("n", "<leader>te", ":tabedit ", { noremap = true, desc = "Edit file in new tab" })
key("n", "<leader>tc", "<Cmd>tabclose<CR>", { desc = "Close tab" })
key("n", "<leader>to", "<Cmd>tabonly<CR>", { desc = "Close other tabs" })
key("n", "<leader>tm", "<Cmd>tabmove ", { desc = "Move tab to position" })

-- Open LazyGit menu --
key("n", "<leader>lg", "<cmd>lua Snacks.lazygit()<cr>", { desc = "LazyGit" })
key("n", "<bs>", ":edit #<cr>", { silent = true })

-- Open Sidekick (Ai) menu --

key("n", "<leader>sc", "<cmd>Sidekick cli toggle<cr>", { silent = true, desc = "Toggle Sidekick CLI" })

-- mini.surround --
local surround = require("mini.surround")
surround.setup({
    mappings = {
        add = "sa",
        delete = "",
        replace = "",
        find = "",
        find_left = "",
        highlight = "sh",
        update_n_lines = "",
    },
})

```

# settings/options.lua

```
local option = vim.opt -- set local variable 
-- general --
option.termguicolors = true                -- enable true color
option.encoding = "utf-8"                  -- set UTF-8 encoding
option.fileencoding = "utf-8"              -- default file encoding
option.modelines = 0                       -- disable CVE-2007-2438 vulnerability
option.wildmode = "longest:full,full"      -- autocompletes in command line
option.clipboard = "unnamedplus"           -- use system clipboard
option.updatetime = 100                    -- update timeout
option.mouse = "a"                         -- enable mouse support
option.langmap:append {
  "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ",
  "фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz",
}                                           -- enable support russian layout

-- editor --
option.number = true                       -- enable absolute numbering of current line
option.relativenumber = true               -- enable relative line numbering
option.numberwidth = 2                     -- line number width
option.fillchars = {
  eob = " ",
}                                          -- interface symbols
option.scrolloff = 10                      -- minimum number of lines above/below cursor when scrolling
option.smoothscroll = true                 -- enable smooth scrolling
option.cursorline = true                   -- highlight cursor line
option.signcolumn = "yes"                  -- enable sign column
option.splitbelow = true                   -- when horizontal split open new window at bottom
option.splitright = true                   -- when vertically split open new window on right


-- indents --
option.expandtab = true                    -- replace Tabs with spaces
option.tabstop = 4                         -- number of spaces for tabs
option.shiftwidth = 4                      -- number of spaces when auto-adding margins
option.softtabstop = 4                     -- number of spaces during autotabulation
option.smarttab = true                     -- smart tabulation behavior
option.smartindent = true                  -- smart code alignment


-- search --
option.hlsearch = true                     -- enable search results highlight
option.incsearch = true                    -- enable search as you type
option.ignorecase = true                   -- ignore case when searching
option.smartcase = true                    -- ignore case if there are no uppercase letters
option.infercase = true                    -- save register when auto-complete
option.guicursor = "i:block"               -- block cursor in instert mode

-- performance --
option.laststatus = 3                      -- enable global status line
option.ruler = false                       -- disable character ruler
option.showtabline = 2                     -- enable tab line
option.showmode = false                    -- disable display mode 
option.wrap = true                         -- enable line wrapping
option.linebreak = true                    -- enable wrap only by words
option.whichwrap = ""                      -- which keys enable transfer to next line
option.showbreak = " 󱞩 "                   -- add arrow at beginning of moved line
option.backup = false                      -- disable backup files
option.writebackup = false                 -- disable creation of temporary backups
option.swapfile = false                    -- disable creation .swp files
option.undofile = true                     -- save history of changes

```

# settings/keymaps.lua

```
-- general options --
local key = vim.keymap.set                  -- set local variable
vim.g.mapleader = ""                       -- set <leader> key
-- files --
key("n", "<leader>w", "<cmd>w<cr>", { silent = true }) -- save file
key("n", "<leader>q", "<cmd>q!<cr>", { silent = true })-- exit without saving


-- movement --
key("n", "j", "gj")                         -- move down based on transfer
key("n", "k", "gk")                         -- move up based on transfer

key("n", "H", "b")                          -- move to previous word
key("n", "L", "w")                          -- move to next word
key("n", "J", "^")                          -- move to beginning of line
key("n", "K", "$")                          -- move to end of line
key("i", "<c-h>", "<left>")                 -- move left in insert mode
key("i", "<c-j>", "<down>")                 -- move down in insert mode
key("i", "<c-k>", "<up>")                   -- move up in insert mode
key("i", "<c-l>", "<right>")                -- move right in insert mode
key("n", "<c-h>", "<c-w>h")                 -- pane movement left
key("n", "<c-j>", "<c-w>j")                 -- pane movement down
key("n", "<c-k>", "<c-w>k")                 -- pane movement up
key("n", "<c-l>", "<c-w>l")                 -- pane movement right


-- visual --
key("v", "J", ":m '>+1<cr>gv=gv")           -- move selection down
key("v", "K", ":m '<-2<cr>gv=gv")           -- move selection up
key("v", "<", "<gv")                        -- indent left and keep selection
key("v", ">", ">gv")                        -- indent right and keep selection


-- yank and paste --
key("n", "x", "\"_x")                       -- cut without storing to clipboard
key("n", "Y", "yyp")
key("n", "<C-Y>", function()
  vim.cmd('normal! yyp')
  vim.cmd('normal! ==')
end)

-- window management --
key("n", "<leader>sv", "<c-w>v")           -- split window vertical
key("n", "<leader>sh", "<c-w>s")            -- split window horizontally


-- scrolling --
key("n", "<c-u>", "<c-u>zz")                -- scrolling up with centering
key("n", "<c-d>", "<c-d>zz")                -- scrolling down with centering


-- increment/decrement number --
key("n", "+", "<c-a>")                      -- increment number
key("n", "-", "<c-x>")                      -- decrement number


-- other keymaps --
key("i", "jj", "<esc>")                     -- quit insert mode
key("i", "<d-space>", "<nop>")              -- ignore switch keyboard layout
key("n", "<leader>hl", "<cmd>noh<cr>", { silent = true }) -- disable highlight after searching

```

# settings/autocmds.lua

```
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

autocmd("BufReadPost", {
    pattern = "*",
    once = true,
    callback = function()
        pcall(require, "code.syntax")
    end,
})

```

# icons.lua

```
local icons = {
	plugins = {
		cmd = " ",
		debug = " ",
		event = " ",
		keys = "󰌆 ",
		loaded = "",
		not_loaded = "",
		plugin = "󰏔 ",
		runtime = " ",
		source = "󰘬 ",
		start = " ",
	},
	debugger = {
		play = "",
		pause = "",
		step_into = "󰆹",
		step_over = "",
		step_out = "",
		step_back = "",
		run_last = "",
		terminate = "",
		disconnect = "",
	},
	outline = {
		Class = " 󰠱",
		Function = " 󰊕",
		Method = " 󰖷",
		Interface = " ",
		Struct = " ",
		Array = " 󰅨",
		Constructor = " ",
		Enum = " ",
		Module = " 󰐱",
	},
	completion = {
		Array = "󰅨",
		Boolean = "",
		Class = "󰠱",
		Color = "󰏘",
		Constant = "󰏿",
		Constructor = "",
		Enum = "",
		EnumMember = "",
		Event = "",
		File = "",
		Folder = "",
		Function = "󰊕",
		Interface = "",
		Key = "󰌆",
		Keyword = "󰌆",
		Method = "󰖷",
		Module = "󰐱",
		Null = "",
		Number = "",
		Package = "󰏔",
		Property = "󰖷",
		Snippet = "",
		Struct = "",
		Text = "󰉿",
		Unit = "",
	},
	manager = {
		package_installed = "",
		package_pending = "",
		package_uninstalled = "",
	},
	notifications = {
		TRACE = "",
		DEBUG = "",
		INFO = "",
		WARN = "",
		ERROR = "",
	},
	explorer = {
		folder = {
			arrow_closed = " ",
			arrow_open = " ",
			default = "",
			open = "",
			empty = "",
			empty_open = "",
			symlink = "",
			symlink_open = "",
		},
		git = {
			staged = "",
			unstaged = "",
			unmerged = "",
			deleted = "",
			ignored = "",
			renamed = "",
			untracked = "",
		},
	},
}

return icons

```

# code/etc.lua

```
require("snacks").setup({
    indent = {
        enabled = true,
        indent = {
            enabled = true,
            char = "│",
            hl = "SnacksIndent",
        },
        scope = {
            enabled = true,
            char = "│",
            hl = "SnacksIndentScope",
        },
        exclude = {
            filetypes = { "dashboard" },
        },
    },
})

```

# code/lsp.lua

```
local mason_path = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_path .. ":" .. vim.env.PATH

-- Diagnostic config
vim.diagnostic.config({
	virtual_text = false,
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		source = "always",
		border = "rounded",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.ERROR] = "",
		},
	},
})

-- Completion setup
local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		completion = {
			border = "rounded",
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
			scrollbar = false,
		},
		documentation = {
			border = "rounded",
		},
	},
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text",
			maxwidth = 50,
			ellipsis_char = "...",
			before = function(entry, vim_item)
				vim_item.menu = ({
					nvim_lsp = "[LSP]",
					luasnip = "[Snip]",
					buffer = "[Buf]",
					path = "[Path]",
				})[entry.source.name]
				return vim_item
			end,
		}),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-c>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	}),
})

vim.opt.pumheight = 10

-- Mason setup
require("mason").setup({
	ui = {
		border = "rounded",
		height = 0.75,
		width = 0.75,
		icons = require("icons").manager,
	},
})
require("mason-lspconfig").setup({
    ensure_installed = {
        "pyright",
        "rust_analyzer",
        "lua_ls",
        "clangd",
        "marksman",
        "html",
        "jsonls",
        "cssls",
        "ltex",
    },
    automatic_installation = true,

})
-- Capabilities for cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local function has_cmd(cmd)
	return vim.fn.executable(cmd) == 1
end

-- Lsp setup
local lsp = vim.lsp

-- Pyright
if has_cmd("pyright-langserver") then
	vim.lsp.config["pyright"] = {
		cmd = { "pyright-langserver", "--stdio" },
		filetypes = { "python", "py" },
		root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "workspace",
					useLibraryCodeForTypes = true,
				},
			},
		},
		capabilities = capabilities,
	}
	lsp.enable("pyright")
end

-- Clangd
if has_cmd("clangd") then
	vim.lsp.config["clangd"] = {
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--header-insertion=never",
			"--completion-style=detailed",
		},
		filetypes = { "c", "cpp" },
		root_markers = { ".clangd", "compile_commands.json", ".git" },
		capabilities = capabilities,
	}
	lsp.enable("clangd")
end

-- Rust analyzer
if has_cmd("rust-analyzer") then
	vim.lsp.config["rust-analyzer"] = {
		cmd = { "rust-analyzer" },
		filetypes = { "rust" },
		root_markers = { "Cargo.toml", "rust-project.json", ".git" },
		settings = {
			["rust-analyzer"] = {
				checkOnSave = { command = "clippy" },
			},
		},
		capabilities = capabilities,
	}
	lsp.enable("rust-analyzer")
end

-- Lua
if has_cmd("lua-language-server") then
	vim.lsp.config["lua_ls"] = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = { ".luarc.json", ".luacheckrc", ".git" },
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = { enable = false },
				hint = { enable = true, semicolon = "Disable" },
				codeLens = { enable = true },
			},
		},
		capabilities = capabilities,
	}
    lsp.enable("lua_ls")
end

-- HTML
if has_cmd("vscode-html-language-server") then
	vim.lsp.config["html"] = {
		cmd = { "vscode-html-language-server", "--stdio" },
		filetypes = { "html" },
		root_markers = { "package.json", ".git" },
		init_options = {
			configurationSection = { "html", "css", "javascript" },
			embeddedLanguages = { css = true, javascript = true },
			provideFormatter = true,
		},
		capabilities = capabilities,
	}
    lsp.enable("html")
end

-- JSON
if has_cmd("vscode-json-language-server") then
	vim.lsp.config["jsonls"] = {
		cmd = { "vscode-json-language-server", "--stdio" },
		filetypes = { "json", "jsonc" },
		root_markers = { ".git" },
		init_options = { provideFormatter = true },
		capabilities = capabilities,
	}
    lsp.enable("jsonls")
end

-- CSS
if has_cmd("vscode-css-language-server") then
	vim.lsp.config["cssls"] = {
		cmd = { "vscode-css-language-server", "--stdio" },
		filetypes = { "css", "scss", "less" },
		root_markers = { "package.json", ".git" },
		settings = {
			css = { validate = true },
			less = { validate = true },
			scss = { validate = true },
		},
		init_options = { provideFormatter = true },
		capabilities = capabilities,
	}
    lsp.enable("cssls")
end

-- Marksman
if has_cmd("marksman") then
	vim.lsp.config["marksman"] = {
		cmd = { "marksman", "server" },
		filetypes = { "markdown" },
		root_markers = { ".marksman.toml", ".git" },
		capabilities = capabilities,
	}
    lsp.enable("marksman")
end

-- Grammarly
if has_cmd("grammarly-languageserver") then
	vim.lsp.config["grammarly"] = {
		cmd = { "grammarly-languageserver", "--stdio" },
		filetypes = { "markdown" },
		root_markers = { ".git" },
		init_options = {
			clientId = "client_BaDkMgx4X19X9UxxYRCXZo",
		},
		capabilities = capabilities,
	}
    lsp.enable("grammarly")
end

-- LTeX
if has_cmd("ltex-ls") then
	vim.lsp.config["ltex"] = {
		cmd = { "ltex-ls" },
		filetypes = { "markdown", "tex" },
		root_markers = { ".git" },
		settings = {
			ltex = {
				enabled = { "markdown", "tex" },
			},
		},
		capabilities = capabilities,
	}
    lsp.enable("ltex")
end

vim.lsp.enable(vim.tbl_keys(vim.lsp.config))

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			client.server_capabilities.progressProvider = false
		end
	end,
})

local original_notify = vim.notify
vim.notify = function(msg, level, opts)
	if level == vim.log.levels.ERROR then
		original_notify(msg, level, opts)
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>fgi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<leader>fgr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>frn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	end,
})

```

# code/vcs.lua

```
require("gitsigns").setup {
  signs = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "-" },
    topdelete = { text = "-" },
    changedelete = { text = "~" },
    untracked = { text = "¦" },
  },
  signs_staged_enable = true,
  signs_staged = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "-" },
    topdelete = { text = "-" },
    changedelete = { text = "~" },
    untracked = { text = "¦" },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  diff_opts = {
    algorithm = "histogram",
    ignore_whitespace_change = true,
    },
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 100,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "<author>, <author_time:%d-%m-%y>: <summary>",
  attach_to_untracked = true,
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,
  max_file_length = 40000,
}

```

# code/outline.lua

```
require("aerial").setup {
  backends = {
    "lsp",
    "treesitter",
  },
  filter_kind = {
    "Class",
    "Function",
    "Method",
    "Interface",
    "Struct",
    "Array",
    "Constructor",
    "Enum",
    "Module",
  },
  close_behavior = "global",
  show_guides = false,
  layout = {
    default_direction = "left",
    max_width = {
      40,
      0.3
    },
    min_width = 25,
  },
  ignore = {
    filetypes = {},
  },
  icons = require("icons").outline,
}


-- vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<cr>")
-- vim.keymap.set("n", "[[", "<cmd>AerialPrev<cr>")
-- vim.keymap.set("n", "]]", "<cmd>AerialNext<cr>")

```

# code/linters.lua

```
local linterConfig = vim.fn.stdpath("config") .. '.linter_configs'
local cfg = {}

function cfg.linterConfigs()
	local lint = require("lint")
	local linters = require("lint").linters
	lint.linters_by_ft = {
		lua = { "stylua" },
		css = { "stylelint" },
		sh = { "shellcheck" },
		markdown = { "markdownlint" },
		yaml = { "yamllint" },
		python = { "ruff" },
		gitcommit = { "gitlint" },
		json = { "jsonlint" },
		javascript = { "eslint_d" },
		typescript = { "eslint_d" },
		toml = { "taplo" },
		text = {},
    c = { "clang_tidy" },
    cpp = { "clang_tidy" },
    -- Docker
    dockerfile = { "hadolint" },
	}

	-- use for codespell for all except bib and css
	for ft, _ in pairs(lint.linters_by_ft) do
		if ft ~= "bib" and ft ~= "css" then table.insert(lint.linters_by_ft[ft], "codespell") end
	end

	linters.codespell.args = {
		"--ignore-words",
		linterConfig .. "/codespell-ignore.txt",
		"--builtin=rare,clear,informal,code,names,en-GB_to_en-US",
	}

	linters.shellcheck.args = {
		"--shell=bash", -- force to work with zsh
		"--format=json",
		"-",
	}

	linters.yamllint.args = {
		"--config-file",
		linterConfig .. "/yamllint.yaml",
		"--format=parsable",
		"-",
	}

	linters.markdownlint.args = {
		"--disable=no-trailing-spaces", -- not disabled in config, so it's enabled for formatting
		"--disable=no-multiple-blanks",
		"--config=" .. linterConfig .. "/markdownlint.yaml",
	}
end

function cfg.lintTriggers()
	vim.api.nvim_create_autocmd({ "BufReadPost", "InsertLeave", "TextChanged", "FocusGained" }, {
		callback = function() vim.defer_fn(require("lint").try_lint, 1) end,
	})

	-- due to auto-save.nvim, we need the custom event "AutoSaveWritePost"
	-- instead of "BufWritePost" to trigger linting to prevent race conditions
	vim.api.nvim_create_autocmd("User", {
		pattern = "AutoSaveWritePost",
		callback = function() require("lint").try_lint() end,
	})
	-- run once on start
	require("lint").try_lint()
end

return cfg

```

# code/formatter.lua

```
require("conform").setup {
  formatters_by_ft = {
    python = { "black", "isort" },
    rust = { "rustfmt" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
  },
  format_on_save = false,
  formatters = {
    rustfmt = {
      prepend_args = {
      },
    },
    clang_format = {
      prepend_args = {
        "--style={ BasedOnStyle: LLVM, BreakBeforeBraces: Attach, SpaceBeforeParens: ControlStatements, IndentWidth: 2, ColumnLimit: 80, }"
      },
    },
  },
}

```

# code/debugger.lua

```
local dap = require("dap")
local dapui = require("dapui")
local virtualtext = require("nvim-dap-virtual-text")
local data = vim.fn.stdpath("data")


dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = data .. "/mason/packages/codelldb/extension/adapter/codelldb",
    args = {
      "--port",
      "${port}",
    },
  },
}


dap.configurations.rust = {
  {
    name = "launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("path to executable", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
  {
    name = "attach to process",
    type = "codelldb",
    request = "attach",
    pid = require("dap.utils").pick_process,
    args = {},
  },
}


vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpointRejected" })


dapui.setup {
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.3, },
        { id = "watches", size = 0.3, },
        { id = "stacks", size = 0.3, },
      },
      size = 0.3,
      position = "right",
    },
    {
      elements = {
        { id = "console", size = 0.55, },
        { id = "repl", size = 0.45, },
      },
      position = "bottom",
      size = 0.25,
    },
  },
  icons = {
    expanded = " ",
    collapsed = " ",
    current_frame = " ",
  },
  controls = {
    icons = require("icons").debugger,
  },
}


dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open { reset = true, }
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close {}
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close {}
end


virtualtext.setup {
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = true,
  show_stop_reason = true,
  commented = false,
  only_first_definition = true,
  all_references = false,
  virt_lines = false,
  virt_text_pos = "eol",
  virt_text_win_col = nil,
  text_prefix = "* ",
}

```

# code/autopairs.lua

```
require("nvim-autopairs").setup {
  disable_filetype = { 
    "TelescopePrompt",
  },
}

```

# code/ai.lua

```
require("sidekick").setup()

```
