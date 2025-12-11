require("bufferline").setup({
  highlights = require("catppuccin.special.bufferline").get_theme(),
  options = {
    hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'},
    },
    mode = "tabs",
    numbers = "ordinal",
    separator_style = "thin",
    always_show_bufferline = true,
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    max_name_length = 18,
    truncate_names = true,
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false, -- only applies to coc
    diagnostics_update_on_event = true,
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
        return "("..count..")"
    end,

    indicator = {
      style = 'underline',
      },
    buffer_close_icon = '󰅖',
    modified_icon = '● ',
    close_icon = ' ',
    left_trunc_marker = ' ',
    right_trunc_marker = ' ',
  }
})
