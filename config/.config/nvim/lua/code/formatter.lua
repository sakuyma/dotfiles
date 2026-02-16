require("conform").setup {
  formatters_by_ft = {
    python = { "black", "isort" },
    rust = { "rustfmt" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
  },
  format_on_save = false,
  formatters = {
    rustfmt = {
      prepend_args = {
      },
    },
    clang_format = {
      prepend_args = {
        "--style={ BasedOnStyle: LLVM, BreakBeforeBraces: Attach, SpaceBeforeParens: ControlStatements, IndentWidth: 2, ColumnLimit: 80, }"
      },
    },
  },
}
