local colors = require("modules.theme")

function toggle_minimize()
    if hl.get_workspace("special:minimized") then
        hl.dispatch(hl.dsp.window.move({ workspace = hl.get_active_workspace(), window = "tag:minimized" }))
        hl.dispatch(hl.dsp.window.clear_tags({ window = "tag:minimized" }))
    else
        hl.dispatch(hl.dsp.window.tag({ tag = "minimized", window = hl.get_active_window() }))
        hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
    end
end

_G.toggle_minimize = toggle_minize

return function()
    require("modules.plugins.hyprglass")
    require("modules.plugins.hyprbars")
    require("modules.plugins.dynamic_cursors")
end
