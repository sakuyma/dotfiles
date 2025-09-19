local colors = {
  bg = "#181825",
  fg = "#bbc2cf",
  yellow = "#f9e2af",
  cyan = "#008080",
  darkblue = "#081633",
  green = "#a6e3a1",
  orange = "#fab387",
  violet = "#b4befe",
  magenta = "#cba6f7",
  blue = "#89b4fa",
  red = "#f38ba8",
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


local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end


ins_left {
  function()
    return "▊"
  end,
  color = { fg = colors.blue },
  padding = { left = 0, right = 1 },
}


ins_left {
  function()
    return " "
  end,
  color = function()
    local mode_color = {
      n = colors.red,
      i = colors.green,
      v = colors.blue,
      [""] = colors.blue,
      V = colors.blue,
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
    return { fg = mode_color[vim.fn.mode()] }
  end,
  padding = { left = 1, right = 1 },
}


ins_left {
  "filesize",
  fmt = string.upper,
  cond = conditions.buffer_not_empty,
}


ins_left {
  "filename",
  cond = conditions.buffer_not_empty,
  file_status = false,
  color = { fg = colors.magenta },
}


ins_left {
  "location",
}


ins_right {
  "branch",
  icon = "*",
  color = { fg = colors.magenta },
}


ins_right {
  "fileformat",
  fmt = string.upper,
  icons_enabled = false,
  color = { fg = colors.fg },
}


ins_right {
  "o:encoding",
  fmt = string.upper,
  color = { fg = colors.fg },
}


ins_right {
  "progress",
  fmt = string.upper,
  color = { fg = colors.fg },
}


ins_right {
  function()
    return "▊"
  end,
  color = { fg = colors.blue },
  padding = { left = 1, right = 0 },
}


require("lualine").setup (
  config
)
