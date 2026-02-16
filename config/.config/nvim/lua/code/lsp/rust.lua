vim.lsp.config("gopls", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    cmd = {
      vim.fn.stdpath("data") .. "/mason/packages/rust-analyzer/rust-analyzer",
    },
    filetypes = {
      "rs", "rust",
    },
  }
)
vim.lsp.enable("rust-analyzer")
