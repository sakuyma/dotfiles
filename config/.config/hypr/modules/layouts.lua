return function()
    hl.config({
        general = {
            layout = "dwindle"
        },
        dwindle = {
            preserve_split = true,
            default_split_ratio = 1
        },
        master = {
            orientation = "right",
            smart_resizing = true
        },
        scrolling = {},
        monocle = {}
    })
end
