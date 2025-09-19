require("todo-comments").setup {
  keywords = {
    TODO = { icon = " ", color = "info" },
    FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "ISSUE" } },
    HACK = { icon = " ", color = "warning" },
  },
  highlight = {
    multiline = true,
    comments_only = true,
  },
}
