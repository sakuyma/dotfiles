local progs = require("modules.programs")

local bind = hl.bind
local exec = hl.dsp.exec_cmd

return function()
    local mainMod = "SUPER"
    local secMod = "SUPER+SHIFT"
    local thirdMod = "SUPER+ALT"

    bind(mainMod .. "+Q", hl.dsp.window.close())
    bind(mainMod .. "+V", hl.dsp.window.float({ action = "toggle" }))

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

    bind("ALT+F11", exec("gnome-calculator"))
    bind("ALT+F10", exec("killall wlogout || wlogout"))

    bind("ALT+G", exec("~/.config/scripts/picker"))
    bind("F11", hl.dsp.window.fullscreen())
    bind("Print", exec("~/.config/scipts/fullscreen_screenshot.sh"))
    bind("SHIFT+Print",
        exec(
        "grim -g \"$(slurp -o -r -c '##000000')\" -t ppm - | satty --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png"))
    bind("CTRL+Print",
        exec(
        "grim -g \"$(slurp -o)\" -t ppm - | satty --filename - --output-filename ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png"))
    bind(mainMod .. "+mouse:274", exec("~/.config/scripts/hyprzoom z 2"))
    bind(mainMod .. "+N", exec("swaync-client -t"))

    bind(mainMod .. "+left", hl.dsp.focus({ direction = "l" }))
    bind(mainMod .. "+right", hl.dsp.focus({ direction = "r" }))
    bind(mainMod .. "+up", hl.dsp.focus({ direction = "u" }))
    bind(mainMod .. "+down", hl.dsp.focus({ direction = "d" }))

    bind(mainMod .. "+ALT+right", hl.dsp.window.move({ x = 50, y = 0, relative = true }))
    bind(mainMod .. "+ALT+left", hl.dsp.window.move({ x = -50, y = 0, relative = true }))
    bind(mainMod .. "+ALT+up", hl.dsp.window.move({ x = 0, y = -50, relative = true }))
    bind(mainMod .. "+ALT+down", hl.dsp.window.move({ x = 0, y = 50, relative = true }))

    bind(mainMod .. "+H", hl.dsp.focus({ direction = "l" }))
    bind(mainMod .. "+L", hl.dsp.focus({ direction = "r" }))
    bind(mainMod .. "+K", hl.dsp.focus({ direction = "u" }))
    bind(mainMod .. "+J", hl.dsp.focus({ direction = "d" }))

    bind(mainMod .. "+ALT+L", hl.dsp.window.move({ x = 50, y = 0, relative = true }))
    bind(mainMod .. "+ALT+H", hl.dsp.window.move({ x = -50, y = 0, relative = true }))
    bind(mainMod .. "+ALT+K", hl.dsp.window.move({ x = 0, y = -50, relative = true }))
    bind(mainMod .. "+ALT+J", hl.dsp.window.move({ x = 0, y = 50, relative = true }))

    for i = 1, 9 do
        bind(mainMod .. "+" .. i, hl.dsp.focus({ workspace = tostring(i) }))
        bind(secMod .. "+" .. i, hl.dsp.window.move({ workspace = tostring(i) }))
    end
    bind(mainMod .. "+0", hl.dsp.focus({ workspace = "10" }))
    bind(secMod .. "+0", hl.dsp.window.move({ workspace = "10" }))

    bind(mainMod .. "+ALT+left", hl.dsp.window.swap({ direction = "l" }))
    bind(mainMod .. "+ALT+right", hl.dsp.window.swap({ direction = "r" }))
    bind(mainMod .. "+ALT+up", hl.dsp.window.swap({ direction = "u" }))
    bind(mainMod .. "+ALT+down", hl.dsp.window.swap({ direction = "d" }))
    bind(mainMod .. "+ALT+H", hl.dsp.window.swap({ direction = "l" }))
    bind(mainMod .. "+ALT+L", hl.dsp.window.swap({ direction = "r" }))
    bind(mainMod .. "+ALT+K", hl.dsp.window.swap({ direction = "u" }))
    bind(mainMod .. "+ALT+J", hl.dsp.window.swap({ direction = "d" }))

    bind(mainMod .. "+SHIFT+right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
    bind(mainMod .. "+SHIFT+left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
    bind(mainMod .. "+SHIFT+up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))
    bind(mainMod .. "+SHIFT+down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))
    bind(mainMod .. "+SHIFT+L", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
    bind(mainMod .. "+SHIFT+H", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
    bind(mainMod .. "+SHIFT+J", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))
    bind(mainMod .. "+SHIFT+K", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))

    bind(mainMod .. "+mouse:272", hl.dsp.window.drag(), { mouse = true })
    bind(mainMod .. "+mouse:273", hl.dsp.window.resize(), { mouse = true })

    bind("XF86AudioRaiseVolume", exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
    bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
    bind("XF86AudioMute", exec("pamixer -t"), { locked = true })
    bind("ALT+XF86AudioRaiseVolume", exec("brightnessctl -e4 -n2 set 5%+"), { repeating = true })
    bind("ALT+XF86AudioLowerVolume", exec("brightnessctl -e4 -n2 set 5%-"), { repeating = true })
end
