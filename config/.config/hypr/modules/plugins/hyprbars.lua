local colors = require("modules.theme")

if hl.plugin.hyprbars then
    local hb = hl.plugin.hyprbars
    hl.config({
        plugin = {
            hyprbars = {
                bar_height = 32,
                bar_color = colors.Foreground,
                bar_blur = true,
                bar_title_enabled = true,
                bar_text_size = 18,
                bar_text_font = "Google Sans Flex",
                bar_text_weight = "bold",
                bar_text_align = "center",
                bar_padding = 15,
                bar_button_padding = 6,
                bar_buttons_alignment = "left",
            },
        },
    })
    hl.plugin.hyprbars.add_button({
        bg_color = colors.Red,
        fg_color = colors.Background,
        size = 16,
        icon = "",
        action = "hyprctl dispatch 'hl.dsp.window.close()'"
    })
    hl.plugin.hyprbars.add_button({
        bg_color = colors.Green,
        fg_color = colors.Background,
        size = 16,
        icon = "",
        action = [[hyprctl dispatch 'hl.dsp.window.fullscreen({ action = "toggle"})']]
    })
    hl.plugin.hyprbars.add_button({
        bg_color = colors.Yellow,
        fg_color = colors.Background,
        size = 16,
        icon = "",
        action = "hyprctl eval toggle_minimize"
    })
end
