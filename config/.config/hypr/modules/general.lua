local colors = require("modules.theme")

return function()
    hl.config({
        general = {
            gaps_in = 5,
            gaps_out = 20,
            border_size = 3,
            col = {
                active_border = colors.Accent,
                inactive_border = colors.Background
            },
            resize_on_border = false,
            allow_tearing = true
        }
    })
end
