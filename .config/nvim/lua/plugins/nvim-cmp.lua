local cmp = require("cmp")
cmp.setup {
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
      scrollbar = false,
    },
    documentation = cmp.config.disable,
  },
  formatting = {
    format = require("lspkind").cmp_format {
      mode = "symbol_text",
      maxwidth = 50,
      ellipsis_char = "..",
      preset = "codicons",
      menu = {
        buffer = "BUFFER",
        nvim_lsp = "LSP",
        luasnip = "SNIP",
        path = "PATH",
        nvim_lua = "LUA",
        latex_symbols = "TEX",
      },
    },
  },
  mapping = cmp.mapping.preset.insert {
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-c>"] = cmp.mapping.abort(),
    ["<cr>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
}


vim.opt.pumheight = 6
