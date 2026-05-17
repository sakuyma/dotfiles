local exec = hl.exec_cmd

return function()
    hl.on("hyprland.start", function()
        exec("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
        exec("waybar & awww-daemon & swaync")
        exec("wl-clipboard-history -t ; wl-paste --type text --watch cliphist store ; wl-paste --type image --watch cliphist store ; wl-clip-persist --clipboard regular --display wayland")
        exec("hyprctl plugin load ~/.config/hypr/modules/plugins/hyprselect.so")
        exec("foot --server")
        exec("ollama serve")
        exec("hyprpm reload")
        exec("hyprsunset")
    end)
end
