local function header()
  return {
    "",
    "",
    "",
    " _      ____ ____  ____ ________   ___  ____",
    "| | /| / / // /\\ \\/ / // /  _/ /  / _ \\/ __/",
    "| |/ |/ / _  /  \\  / _  // // /__/ // / _/  ",
    "|__/|__/_//_/   /_/_//_/___/____/____/___/  ",
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
      desc = "New file",
      desc_hl = "Comment",
      key = "e",
      key_hl = "Comment",
      key_format = "%s",
      action = ":enew",
      },
      {
      desc = "Explorer",
      desc_hl = "Comment",
      key = "n",
      key_hl = "Comment",
      key_format = "%s",
      action = ":NvimTreeToggle",
      },
      {
      desc = "Find file",
      desc_hl = "Comment",
      key = "f",
      key_hl = "Comment",
      key_format = "%s",
      action = ":Telescope find_files",
      },
      {
      desc = "Recently",
      desc_hl = "Comment",
      key = "r",
      key_hl = "Comment",
      key_format = "%s",
      action = ":Telescope oldfiles",
      },
      {
      desc = "Quit                       ",
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
