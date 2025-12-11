require("notify").setup {
  background_colour = "#11111b",
  render = "wrapped-compact",
  stages = "fade_in_slide_out",
  max_width = 30,
  minimum_width = 30,
  timeout = 2000,
  fps = 60,
  level = 0,
  icons = require("icons").notifications,
}


vim.notify = require("notify")
