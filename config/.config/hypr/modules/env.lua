local env = hl.env

return function()
    env("WAYLAND_DISPLAY", "wayland-1")
    env("GDK_BACKEND", "wayland,x11,*")
    env("QT_QPA_PLATFORM", "wayland;xcb")
    env("SDL_VIDEODRIVER", "wayland")
    env("CLUTTER_BACKEND", "wayland")
    env("XDG_CURRENT_DESKTOP", "Hyprland")
    env("XDG_SESSION_TYPE", "wayland")
    env("XDG_SESSION_DESKTOP", "Hyprland")
    env("MOZ_ENABLE_WAYLAND", "1")
    env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
    env("QT_QPA_PLATFORMTHEME", "qt6ct")
end
