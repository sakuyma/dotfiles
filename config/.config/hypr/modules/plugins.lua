local colors = require("modules.theme")

return function()
    if hl.plugin.hyprglass then
        local hg = hl.plugin.hyprglass

        hg.config({
            default_theme = "dark",
            default_preset = "apple",
            tint_color = 0x8899aa22,

            brightness = 0.9,
            dark = { brightness = 0.82 },
            light = { adaptive_boost = 0.5 },

            layers = { enabled = 1 },
        })
        

        local function tint(c, alpha)
            return tonumber(c:match("%x%x%x%x%x%x"), 16) * 256 + match.floor(alpha * 255 + 0.5)
        end
        -- Layer surfaces: each call whitelists the namespace and configures it
        hg.layer("waybar", { preset = "subtle", mask_threshold = 0.05 })
        hg.layer("swaync")

        -- Presets
        hg.preset("clear", {
            glass_opacity = 0.8,
            blur_strength = 1.0,
            dark = { brightness = 0.82 },
            light = { brightness = 1.2 },
        })

        hg.preset("contrasted", {
            inherits = "high_contrast",
            contrast = 1.2,
            adaptive_dim = 1.5,
            dark = { tint_color = 0x02142aa9 },
        })

        hg.preset("glass", {
            blur_strength = 2.0,
            blur_iterations = 3,
            chromatic_aberration = 0.8,
            fresnel_strenght = 0.8,
            edge_thickness = 0.08,
            lens_distortion = 0.9,
            brightness = 1.0,
            contrast = 1.7,
            saturation = 1,
            vibrancy = 0.8,
            vibrancy_darkness = 1,
            adaptive_boost = 0.5
        })

        hg.preset("apple", {
            blur_strength = 2.2,
            blur_iterations = 3,
            refraction_strenght = 0.55,
            chromatic_aberration = 0.3,
            fresnel_strenght = 0.5,
            specular_strenght = 0.75,
            edge_thickness = 0.05,
            lens_distortion = 0.3,
            dark = { brightness = 0.82, contrast = 0.90, saturation = 0.80, vibrancy = 0.15, adaptive_dim = 0.4 },
            light = { brightness = 1.12, contrast = 0.92, saturation = 0.85, vibrancy = 0.12, adaptive_boost = 0.4 },
        })
    end

    if hl.plugin.hyprbars then
    end
        hl.config({
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
