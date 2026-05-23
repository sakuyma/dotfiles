local colors = require("modules.theme")

return function()
    hl.config({
        plugin = {
            hyprexpo = {
                columns = 3,
                gaps_in = 5,
                gaps_out = 0,
                bg_col = colors.Background,
                workspace_method = "center current",
                tile_rounding = 3,
                border_color = colors.Background,
                border_color_current = colors.Green,
                border_color_focus = colors.Accent,
                border_color_hover = colors.Background,

                drag_drop_proxy_color = colors.Accent_low,
                drag_drop_proxy_active_color = colors.Accent_low,
            },
        },
        -- plugin = { 
            -- hyprbars = {
            --     bar_height = 32,
            --     bar_color = colors.Foreground,
            --     bar_blur = true,
            --     bar_title_enabled = true,
            --     bar_text_size = 12,
            --     bar_text_font = "SF Pro Display Semibold",
            --     bar_text_align = "center",
            --     bar_button_alignment = "left",
            --     bar_padding = 15,
            --     bar_button_padding = 6,
            --     hyprbars_button = {
            --         { color = colors.Red, size = 15, cmd = "hyprctl dispatch killactive" },
            --         { color = colors.Green, size = 15, cmd = "hyprctl dispatch fullscreen 1" }
            --     },
            --     on_double_click = "hyprctl dispatch fullscreen 0"
            -- },
    })
end
