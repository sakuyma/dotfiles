require("nvim-tree").setup {
  sort = {
    sorter = "case_sensitive",
    folders_first = true,
  },
  view = {
    width = 30,
    side = "right",
    centralize_selection = true,
    signcolumn = "yes",
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
      git_placement = "signcolumn",
      glyphs = {
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
          unstaged = "",
          staged = "",
          unmerged = "",
          renamed = "➜",
          untracked = "",
          deleted = "",
          ignored = "󰆢",
        },
      },
    },
    indent_markers = {
      enable = false,
      inline_arrows = false,
    },
    root_folder_label = function(path)
      return " " .. vim.fn.fnamemodify(path, ":~")
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


vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", { silent = true })
