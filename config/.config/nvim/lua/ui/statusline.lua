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


insertLeft {
  function()
    return ""
  end,
  color = { fg = colors.lavender, },
  padding = { left = 0, right = 1, },
}


insertLeft {
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
      fg = color[vim.fn.mode()]
    }
  end,
  padding = { left = 1, right = 1, },
}


insertLeft {
  "filesize",
  fmt = string.upper,
  cond = conditions.buffer_not_empty,
}


insertLeft {
  "filename",
  cond = conditions.buffer_not_empty,
  file_status = false,
  color = { fg = colors.lavender },
}


insertLeft {
  "location",
}


insertLeft {
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
    error = { fg = colors.red, },
    warn = { fg = colors.yellow, },
    info = { fg = colors.green, },
  },
}


insertRight {
  "branch",
  icon = "",
  color = { fg = colors.lavender, },
}


insertRight {
  "encoding",
  fmt = string.upper,
  color = { fg = colors.fg, },
}


insertRight {
  "fileformat",
  fmt = string.upper,
  icons_enabled = false,
  color = { fg = colors.fg, },
}


insertRight {
  "progress",
  fmt = string.upper,
  color = { fg = colors.fg, },
}


insertRight {
  function()
    return ""
  end,
  color = { fg = colors.lavender, },
  padding = { left = 1, right = 0, },
}


require("lualine").setup (
  config
)
