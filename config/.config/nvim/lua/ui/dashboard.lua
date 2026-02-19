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
require("dashboard").setup {
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
}
