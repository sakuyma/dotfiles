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
                "--config",
                "style_edition=2024",
            },
        },
        clang_format = {
            prepend_args = {
                "--style={BasedOnStyle: LLVM, AllowShortIfStatementsOnASingleLine: AllIfsAndElse, BreakBeforeBraces: Attach, SpaceBeforeParens: ControlStatements, IndentWidth: 4, ColumnLimit: 80}"
            },
        },
    },
}
