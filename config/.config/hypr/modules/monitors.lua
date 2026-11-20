return function()
    hl.monitor({
        output = "",
        mode = "highres@highrr",
        position = "auto",
        scale = "auto"
    })
    hl.config({
        render = {
            cm_auto_hdr = 0,
        }
    })
end
