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
