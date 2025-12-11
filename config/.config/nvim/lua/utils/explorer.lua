require("nvim-tree").setup {
  sort = {
    sorter = "case_sensitive",
    folders_first = true,
  },
  view = {
    width = 32,
    side = "left",
    centralize_selection = true,
    signcolumn = "no",
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
  },
  renderer = {
    group_empty = false,
    symlink_destination = false,
    indent_width = 2,
    icons = {
      git_placement = "before",
      glyphs = {
        folder = require("icons").explorer.folder,
        git = require("icons").explorer.git,
      },
    },
    indent_markers = {
      enable = false,
      inline_arrows = false,
    },
    root_folder_label = function(path)
      return " EXPLORER: " .. vim.fn.toupper(vim.fn.fnamemodify(path, ":~:t"))
    end,
  },
  ui = {
    confirm = {
      remove = true,
      trash = true,
      default_yes = false,
    },
  },
  git = {
    enable = true,
    ignore = false,
  },
  filters = {
    dotfiles = false,
  },
}
