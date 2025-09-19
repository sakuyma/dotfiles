require("conform").setup {
  formatters_by_ft = {
    c = { "clang_format" },
    cpp = { "clang_format" },
  },
  format_on_save = false,
  formatters = {
    clang_format = {
      prepend_args = {
        "--style={ BasedOnStyle: LLVM, BreakBeforeBraces: Attach, SpaceBeforeParens: ControlStatements, IndentWidth: 2, ColumnLimit: 80, }"
      },
    },
  },
}


vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  require("conform").format {
    async = true,
    lsp_fallback = true,
  }
end)
