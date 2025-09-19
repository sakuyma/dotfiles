require("mason").setup {
  automatic_installation = false,
  ensure_installed = {
    "clangd",
    "clang-format",
    "codelldb",
  },
  ui = {
    check_outdated_packages_on_open = true,
    border = "rounded",
    height = 0.75,
    width = 0.75,
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
}


local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig.clangd.setup {
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--completion-style=detailed",
    "--offset-encoding=utf-16",
  },
  filetypes = {
    "c", "cpp", "objc", "objcpp",
  },
}


vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })


vim.diagnostic.config {
  virtual_text = false,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    source = "always",
    border = "rounded",
  },
}
