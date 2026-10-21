return function()
    hl.config({
        input = {
            kb_layout = "us, ru",
            kb_variant = "",
            kb_model = "",
            kb_options = "caps:shiftlock,grp:caps_toggle, compose:menu",
            kb_rules = "",
            follow_mouse = 1,
            sensitivity = 0,
            touchpad = {
                natural_scroll = true
            }
        },
        cursor = {
            no_warps = true
        }
    })

    hl.device({
        name = "attack-shark-r5-ultra-mouse-2.4g",
        sensitivity = -0.75
    })
end
