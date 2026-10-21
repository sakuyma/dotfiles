local animation = hl.animation
local curve = hl.curve

return function()
    -- hl.config({
    --     animations = {
    --         enabled = false,
    --     }
    -- })
    local smoothOut = curve("smoothOut", { type = "bezier", points = { { 0.36, 0 }, { 0.66, -0.56 } } })
    local smoothIn = curve("smoothIn", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1.0 } } })
    local overshot = curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
    local softSnap = curve("softSnap", { type = "bezier", points = { { 0.4, 0.0 }, { 0.2, 1 } } })
    local fluent = curve("fluent", { type = "bezier", points = { { 0.0, 0.0 }, { 0.2, 1.0 } } })

    animation({ leaf = "windows", enabled = true, speed = 5.0, bezier = "overshot", style = "popin 80%" })
    animation({ leaf = "windowsIn", enabled = true, speed = 4.0, bezier = "overshot", style = "popin 80%" })
    animation({ leaf = "windowsOut", enabled = true, speed = 5.0, bezier = "smoothOut", style = "popin 95%" })
    animation({ leaf = "windowsMove", enabled = true, speed = 5.0, bezier = "softSnap" })

    animation({ leaf = "layersIn", enabled = true, speed = 5.0, bezier = "smoothIn" })
    animation({ leaf = "layersOut", enabled = true, speed = 5.0, bezier = "softSnap" })

    animation({ leaf = "fade", enabled = true, speed = 5.0, bezier = "smoothIn" })
    animation({ leaf = "fadeIn", enabled = true, speed = 5.0, bezier = "smoothIn" })
    animation({ leaf = "fadeOut", enabled = true, speed = 5.0, bezier = "smoothOut" })
    animation({ leaf = "fadeSwitch", enabled = true, speed = 5.0, bezier = "smoothIn" })
    animation({ leaf = "fadeShadow", enabled = true, speed = 5.0, bezier = "smoothIn" })
    animation({ leaf = "fadeDim", enabled = true, speed = 5.0, bezier = "smoothIn" })
    animation({ leaf = "fadeDpms", enabled = true, speed = 5.0, bezier = "smoothIn" })

    animation({ leaf = "workspaces", enabled = true, speed = 5.0, bezier = "overshot", style = "slidefade 100%" })
    animation({ leaf = "specialWorkspace", enabled = true, speed = 5.0, bezier = "overshot", style = "slidefadevert 30%" })
    --
    -- hl.curve("specialWorkSwitch", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
    -- hl.curve("emphasizedAccel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
    -- hl.curve("emphasizedDecel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
    -- hl.curve("standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })
    --
    -- -- Animation configs
    -- hl.animation({ leaf = "layersIn", enabled = true, speed = 5, bezier = "emphasizedDecel", style = "slide" })
    -- hl.animation({ leaf = "layersOut", enabled = true, speed = 4, bezier = "emphasizedAccel", style = "slide" })
    -- hl.animation({ leaf = "fadeLayers", enabled = true, speed = 5, bezier = "standard" })
    --
    -- hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "emphasizedDecel" })
    -- hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "emphasizedAccel" })
    -- hl.animation({ leaf = "windowsMove", enabled = true, speed = 6, bezier = "standard" })
    -- hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "standard" })
    --
    -- hl.animation({
    --     leaf    = "specialWorkspace",
    --     enabled = true,
    --     speed   = 4,
    --     bezier  = "specialWorkSwitch",
    --     style   = "slidefadevert 15%"
    -- })
    -- hl.animation({ leaf = "fade", enabled = true, speed = 6, bezier = "standard" })
    -- hl.animation({ leaf = "fadeDim", enabled = true, speed = 6, bezier = "standard" })
    -- hl.animation({ leaf = "border", enabled = true, speed = 6, bezier = "standard" })
end
