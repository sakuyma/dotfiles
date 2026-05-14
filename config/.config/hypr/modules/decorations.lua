local colors = require("modules.theme")

return function()
    hl.config({
        decoration = {
            rounding = 12,
            rounding_power = 3,
            active_opacity = 1,
            inactive_opacity = 1,
            fullscreen_opacity = 1,
            blur = {
                enabled = true,
                size = 1,
                passes = 5,
                new_optimizations = true,
                contrast = 1.2,
                brightness = 0.9,
                vibrancy = 0.1696,
                vibrancy_darkness = 0.1,
                special = 1,
                ignore_opacity = true,
                xray = false,
                popups = true
            },
            shadow = {
                enabled = false,
                range = 25,
                render_power = 3,
                sharp = false,
                color = colors.Background,
                color_inactive = colors.Background,
                offset = { 0, 0 },
                scale = 1.0
            }
        },
        misc = {
            force_default_wallpaper = 1,
            disable_hyprland_logo = true
        }
    })
end
