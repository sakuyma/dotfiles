require("todo-comments").setup {
  signs = true,
  sign_priority = 8,
  keywords = {
    FIX = { icon = " ", color = "#f38ba8", alt = { "FIXME", "BUG", "ISSUE", }, },
    TODO = { icon = " ", color = "#a6e3a1", alt = { "DOING", }, },
    WARN = { icon = " ", color = "#f9e2af", alt = { "WARNING", }, },
    PERF = { icon = "󰥔 ", color = "#fab387", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE", }, },
    NOTE = { icon = " ", color = "#89b4fa", alt = { "INFO", }, },
    TEST = { icon = " ", color = "#b4befe", alt = { "TESTING", "PASSED", "FAILED", }, },
  },
  gui_style = {
    fg = "NONE",
    bg = "BOLD",
  },
  merge_keywords = true,
  highlight = {
    multiline = true,
    multiline_context = 10,
    before = "",
    keyword = "wide",
    after = "fg",
    comments_only = true,
    max_line_len = 400,
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    pattern = [[\b(KEYWORDS):]],
  },
}
