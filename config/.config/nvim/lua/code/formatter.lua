require("conform").setup {
  formatters_by_ft = {
    c = {
      "clang-format",
    },
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
