local colors = require("modules.theme")

return function()
    hl.config({
        plugins = {
            hyprexpo = {
                columns = 3,
                gap_size = 0,
                bg_col = colors.Background,
                workspace_method = "first 1"
            },
            hyprbars = {
                bar_height = 32,
                bar_color = colors.Foreground,
                bar_blur = true,
                bar_title_enabled = true,
                bar_text_size = 12,
                bar_text_font = "SF Pro Display Semibold",
                bar_text_align = "center",
                bar_button_alignment = "left",
                bar_padding = 15,
                bar_button_padding = 6,
                hyprbars_button = {
                    { color = colors.Red,   size = 15, cmd = "hyprctl dispatch killactive" },
                    { color = colors.Green, size = 15, cmd = "hyprctl dispatch fullscreen 1" }
                },
                on_double_click = "hyprctl dispatch fullscreen 0"
            },
            hyprscrolling = {
                column_width = 0.55,
                fullscreen_on_one_column = true,
                follow_focus = true
            }
        }
    })
end
