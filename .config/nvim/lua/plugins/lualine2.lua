local colors = {
  bg1 = "#313244",
  bg2 = "#45475a",
  fg = "#cdd6f4",
  black = "#11111b",
  yellow = "#f9e2af",
  cyan = "#008080",
  green = "#a6e3a1",
  orange = "#fab387",
  violet = "#b4befe",
  magenta = "#cba6f7",
  blue = "#89b4fa",
  red = "#f38ba8",
}


local theme = {
  normal = {
    a = { fg = colors.black, bg = colors.red },
    b = { fg = colors.fg, bg = colors.bg1 },
    c = { fg = colors.fg, bg = colors.bg2 },
  },
  insert = { a = { fg = colors.black, bg = colors.green } },
  visual = { a = { fg = colors.black, bg = colors.blue } },
  command = { a = { fg = colors.black, bg = colors.magenta } },
  replace = { a = { fg = colors.black, bg = colors.yellow } },
  terminal = { a = { fg = colors.black, bg = colors.violet } },
}


require("lualine").setup {
  options = {
    theme = theme,
    component_separators = "",
    section_separators = { left = "", right = "" },
    globalstatus = true,
  },
  sections = {
    lualine_a = {
      { "mode", icon = "", },
    },
    lualine_b = {
      { "filename", file_status = false, symbols = { unnamed = "NO NAME", newfile = "NEW", }, },
    },
    lualine_c = {
      { "branch", icon = "", },
    },
    lualine_x = {
      { "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = " ", warn = " ", info = " " },
        diagnostics_color = {
          error = { fg = colors.red },
          warn = { fg = colors.yellow },
          info = { fg = colors.green },
        },
      },
    },
    lualine_y = {
      { "encoding", fmt = string.upper, },
      { "fileformat", fmt = string.upper, icons_enabled = false, },
    },
    lualine_z = {
      { "location", },
    },
  },
}
