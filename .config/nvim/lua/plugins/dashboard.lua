local function custom_header()
  return {
    "",
    "",
    "",
    "",
    "    ▄        ▄    ▄      ▄ ▄       █▄ ",
    "  ▄█▀█      █      █   █▀  █        █▄",
    " █    ▀    █ █     █   █▀  ▀▄        █",
    "  ▀▄▄     █  ▀█    █▄▀▀     █        █",
    "     █  ▄█▀▀▄▄█    █▀▄      ▀█      █▀",
    "▄    █  █     ▀█  █▀  ▀▄     ▀█▄  ▄█▀ ",
    "▀▄▄▀▀  ▄▀      █ ▄█    █▄       ▀▀▀▀  ",
    " ",
  }
end


require("dashboard").setup {
  theme = "doom",
  config = {
    header = custom_header(),
    center = {
      {
      desc = "  Make new file",
      key = "n",
      key_format = "%s",
      action = "enew",
      },
      {
      desc = "  File explorer",
      key = "t",
      key_format = "%s",
      action = ":NvimTreeToggle",
      },
      {
      desc = "  Find files",
      key = "f",
      key_format = "%s",
      action = ":Telescope find_files",
      },
      {
      desc = "  Find commands",
      key = "c",
      key_format = "%s",
      action = ":Telescope command_history",
      },
      {
      desc = "  Quit neovim",
      key = "q",
      key_format = "%s",
      action = "q",
      },
    },
    footer = {},
  },
}
