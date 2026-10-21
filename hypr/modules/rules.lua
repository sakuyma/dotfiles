return function()
    hl.layer_rule({ name = "macdock",  match = { namespace = "macdock"  }, blur = true, ignore_alpha = 0.2,  no_anim = true })
    hl.layer_rule({ name = "macspot",  match = { namespace = "macspot"  }, blur = true, ignore_alpha = 0.05, no_anim = true })
    hl.layer_rule({ name = "macbarbg", match = { namespace = "macbarbg" }, blur = true, ignore_alpha = 0.05, no_anim = true })
    hl.layer_rule({ name = "macshot",  match = { namespace = "macshot"  }, no_anim = true })   -- optional: no fade on the screenshot picker


    hl.window_rule({
        match = { class = "com.gabm.satty" },
        float = true,
        size = { 500, 600 },
        center = true,
        opacity = "1",
        dim_around = true,
        name = "satty"
    })

    hl.window_rule({
        match = { class = "com.wallpaper.setter" },
        float = true,
        size = { 900, 500 },
        center = true,
        opacity = "1",
        animation = "popin 85%",
        name = "wallpaper"
    })

    hl.layer_rule({
        match = { namespace = "launcher" },
        dim_around = true,
        animation = "popin 85%",
        name = "rofi"
    })

    hl.layer_rule({
        match = { namespace = "logout_dialog" },
        dim_around = true,
        blur = true,
        animation = "popin 85%",
        name = "wlogout"
    })

    hl.layer_rule({
        match = { namespace = "swaync-control-center" },
        blur = true,
        animation = "slide right 60%",
        ignore_alpha = 0.5,
        xray = false,
        name = "swaync-control-center"
    })

    hl.layer_rule({
        match = { namespace = "swaync-notification-window" },
        blur = true,
        animation = "slide right 60%",
        ignore_alpha = 0.5,
        xray = false,
        name = "swaync-notifications"
    })

    hl.layer_rule({
        match = { namespace = "hyprpicker" },
        no_anim = true,
        blur = false,
        name = "hyprpicker"
    })

    hl.layer_rule({
        match = { namespace = "selection" },
        no_anim = true,
        blur = false,
        name = "selection"
    })
end
