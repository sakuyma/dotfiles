vim.lsp.enable(
  "lua_ls",
  {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    cmd = {
      vim.fn.stdpath("data") .. "/mason/packages/lua-language-server/lua-language-server",
    },
    filetypes = {
      "lua",
    },
  }
)
