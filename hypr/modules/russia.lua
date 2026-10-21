local exec = hl.exec_cmd

return function()
    hl.on("hyprland.start", function()
        exec("tg-ws-proxy")
    end)
end
