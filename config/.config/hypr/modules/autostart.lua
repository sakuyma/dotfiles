local exec = hl.exec_cmd

return function()
    hl.on("hyprland.start", function()
        exec("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
        exec("awww-daemon")
        exec("swaync")
        exec("hyprctl setcursor Bibata-Modern-Classic 22")
        exec(
            "wl-clipboard-history -t ; wl-paste --type text --watch cliphist store ; wl-paste --type image --watch cliphist store ; wl-clip-persist --clipboard regular --display wayland")
        exec("foot --server")
        exec("hyprpm reload")
        exec("hyprsunset")
        exec("waybar")
    end)
end
