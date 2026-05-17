local progs = require("modules.programs")

local bind = hl.bind
local exec = hl.dsp.exec_cmd
local hypr = hl.dsp

return function()
    local mainMod = "SUPER"
    local secMod = "SUPER+SHIFT"
    local thirdMod = "SUPER+ALT"

    bind(mainMod .. "+Q", hypr.window.close())
    bind(mainMod .. "+V", hypr.window.float({ action = "toggle" }))

    bind(mainMod .. "+RETURN", exec(progs.terminal))
    bind(mainMod .. "+SHIFT+RETURN", exec(progs.terminal_alt))
    bind(mainMod .. "+O", exec("killall fuzzel || ~/.config/scripts/options.sh"))

    bind(mainMod .. "+T", exec(progs.telegram))
    bind(mainMod .. "+B", exec(progs.browser_main))
    bind(secMod .. "+B", exec(progs.browser_second))
    bind(mainMod .. "+E", exec(progs.file_manager))

    bind("CTRL+ALT+Delete", exec("killall wlogout || wlogout"))
    bind(mainMod .. "+D", exec("killall fuzzel || fuzzel"))
    bind(mainMod .. "+Y", exec("killall fuzzel || ~/.config/scripts/clipboard-manager.sh"))

    bind("ALT+F10", exec("killall wlogout || wlogout"))

    bind("ALT+G", exec("~/.config/scripts/picker"))
    bind(mainMod .. "+F", hypr.window.fullscreen())
    bind("Print", exec("~/.config/scipts/fullscreen_screenshot.sh"))
    bind("SHIFT+Print",
        exec(
            "grim -g \"$(slurp -o -r -c '##000000')\" -t ppm - | satty --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png"))
    bind("CTRL+Print",
        exec(
            "grim -g \"$(slurp -o)\" -t ppm - | satty --filename - --output-filename ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png"))
    bind(mainMod .. "+mouse:274", exec("~/.config/scripts/hyprzoom z 2"))
    bind(mainMod .. "+N", exec("swaync-client -t"))

    bind(mainMod .. "+left", hypr.focus({ direction = "l" }))
    bind(mainMod .. "+right", hypr.focus({ direction = "r" }))
    bind(mainMod .. "+up", hypr.focus({ direction = "u" }))
    bind(mainMod .. "+down", hypr.focus({ direction = "d" }))

    bind(mainMod .. "+ALT+right", hypr.window.move({ x = 50, y = 0, relative = true }))
    bind(mainMod .. "+ALT+left", hypr.window.move({ x = -50, y = 0, relative = true }))
    bind(mainMod .. "+ALT+up", hypr.window.move({ x = 0, y = -50, relative = true }))
    bind(mainMod .. "+ALT+down", hypr.window.move({ x = 0, y = 50, relative = true }))

    bind(mainMod .. "+H", hypr.focus({ direction = "l" }))
    bind(mainMod .. "+L", hypr.focus({ direction = "r" }))
    bind(mainMod .. "+K", hypr.focus({ direction = "u" }))
    bind(mainMod .. "+J", hypr.focus({ direction = "d" }))

    bind(mainMod .. "+ALT+L", hypr.window.move({ x = 50, y = 0, relative = true }))
    bind(mainMod .. "+ALT+H", hypr.window.move({ x = -50, y = 0, relative = true }))
    bind(mainMod .. "+ALT+K", hypr.window.move({ x = 0, y = -50, relative = true }))
    bind(mainMod .. "+ALT+J", hypr.window.move({ x = 0, y = 50, relative = true }))

    for i = 1, 9 do
        bind(mainMod .. "+" .. i, hypr.focus({ workspace = tostring(i) }))
        bind(secMod .. "+" .. i, hypr.window.move({ workspace = tostring(i) }))
    end
    bind(mainMod .. "+0", hypr.focus({ workspace = "10" }))
    bind(secMod .. "+0", hypr.window.move({ workspace = "10" }))

    bind(mainMod .. "+ALT+left", hypr.window.swap({ direction = "l" }))
    bind(mainMod .. "+ALT+right", hypr.window.swap({ direction = "r" }))
    bind(mainMod .. "+ALT+up", hypr.window.swap({ direction = "u" }))
    bind(mainMod .. "+ALT+down", hypr.window.swap({ direction = "d" }))
    bind(mainMod .. "+ALT+H", hypr.window.swap({ direction = "l" }))
    bind(mainMod .. "+ALT+L", hypr.window.swap({ direction = "r" }))
    bind(mainMod .. "+ALT+K", hypr.window.swap({ direction = "u" }))
    bind(mainMod .. "+ALT+J", hypr.window.swap({ direction = "d" }))

    bind(mainMod .. "+SHIFT+right", hypr.window.resize({ x = 50, y = 0, relative = true }))
    bind(mainMod .. "+SHIFT+left", hypr.window.resize({ x = 0, y = -50, relative = true }))
    bind(mainMod .. "+SHIFT+down", hypr.window.resize({ x = 0, y = 50, relative = true }))
    bind(mainMod .. "+SHIFT+L", hypr.window.resize({ x = 50, y = 0, relative = true }))
    bind(mainMod .. "+SHIFT+H", hypr.window.resize({ x = -50, y = 0, relative = true }))
    bind(mainMod .. "+SHIFT+J", hypr.window.resize({ x = 0, y = 50, relative = true }))
    bind(mainMod .. "+SHIFT+K", hypr.window.resize({ x = 0, y = -50, relative = true }))

    bind(mainMod .. "+mouse:272", hypr.window.drag(), { mouse = true })
    bind(mainMod .. "+mouse:273", hypr.window.resize(), { mouse = true })

    bind("XF86AudioRaiseVolume", exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
    bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
    bind("XF86AudioMute", exec("pamixer -t"), { locked = true })
    bind("ALT+XF86AudioRaiseVolume", exec("brightnessctl -e4 -n2 set 5%+"), { repeating = true })
    bind("ALT+XF86AudioLowerVolume", exec("brightnessctl -e4 -n2 set 5%-"), { repeating = true })
end
