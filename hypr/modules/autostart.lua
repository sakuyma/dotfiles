local exec = hl.exec_cmd

return function()
    hl.on("hyprland.start", function()
        exec("sh ~/.local/bin/macshell-start")
        exec(
            "wl-clipboard-history -t ; wl-paste --type text --watch cliphist store ; wl-paste --type image --watch cliphist store ; wl-clip-persist --clipboard regular --display wayland")
        exec("hyprpm reload")
    end)
end
