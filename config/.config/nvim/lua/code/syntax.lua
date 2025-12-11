require("nvim-treesitter.configs").setup {
  auto_install = true,
  ensure_installed = {
    "rust",
    "python",
    "lua",
    "bash",
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gn",
      node_incremental = "gn",
      scope_incremental = "gs",
      node_decremental = "gm",
    },
  },
}


require("nvim-treesitter.configs").setup {
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}
