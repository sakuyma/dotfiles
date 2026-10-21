local progs = require("modules.programs")

local bind = hl.bind
local exec = hl.dsp.exec_cmd
local hypr = hl.dsp
local plugin = hl.plugin

return function()
    local mainMod = "SUPER"
    local secMod = "SUPER+SHIFT"
    local thirdMod = "SUPER+ALT"

    local qs = "qs -c MacShell ipc call "

    hl.bind("SUPER + V",          hl.dsp.exec_cmd(qs .. "spotlight clipboard"))
    hl.bind("SUPER + period",     hl.dsp.exec_cmd(qs .. "spotlight emoji"))
    hl.bind("SUPER + Space",      hl.dsp.exec_cmd(qs .. "spotlight toggle"))
    hl.bind("ALT + TAB",          hl.dsp.exec_cmd(qs .. "switcher next"))
    hl.bind("CTRL + ALT + W",     hl.dsp.exec_cmd(qs .. "wallpapers toggle"))
    hl.bind("PRINT",              hl.dsp.exec_cmd(qs .. "screenshot region"))

    -- MacLock (lock screen)
    hl.bind("SUPER + L",          hl.dsp.exec_cmd("sh ~/.config/quickshell/MacLock/lock-via-ipc.sh"))

    bind(mainMod .. "+Q", hypr.window.close())

    bind(mainMod .. "+RETURN", exec(progs.terminal))
    bind(mainMod .. "+SHIFT+RETURN", exec(progs.terminal_alt))
    bind(mainMod .. "+O", exec("killall fuzzel || ~/.config/scripts/options.sh"))

    bind(mainMod .. "+T", exec(progs.telegram))
    bind(mainMod .. "+B", exec(progs.browser_main))
    bind(secMod .. "+B", exec(progs.browser_second))
    bind(mainMod .. "+E", exec(progs.file_manager))
    bind(secMod .. "+M", exec(progs.lockscreen))
    bind(mainMod .. "+M", exec(progs.music))

    bind("CTRL+ALT+Delete", exec("killall wlogout || wlogout"))
    bind(mainMod .. "+D", exec("killall fuzzel || fuzzel"))
    bind(mainMod .. "+Y", exec("killall fuzzel || ~/.config/scripts/clipboard-manager.sh"))

    bind("ALT+F10", exec("killall wlogout || wlogout"))

    bind("ALT+G", exec("~/.config/scripts/picker"))
    bind(mainMod .. "+F", hypr.window.fullscreen())
    bind("Print", exec("~/.config/scipts/fullscreen_screenshot.sh"))
    bind("SHIFT+Print",
        exec(
            "grim -g \"$(slurp -o -r -c '##000000')\" -t ppm - | wl-copy"))
    bind("CTRL+Print",
        exec(
            "grim -g \"$(slurp -o)\" - | tee ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png | wl-copy"))
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

    bind(mainMod .. "+SHIFT+right", hypr.window.resize({ x = 50, y = 0, relative = true }))
    bind(mainMod .. "+SHIFT+left", hypr.window.resize({ x = 0, y = -50, relative = true }))
    bind(mainMod .. "+SHIFT+down", hypr.window.resize({ x = 0, y = 50, relative = true }))

    bind(mainMod .. "+mouse:272", hypr.window.drag(), { mouse = true })
    bind(mainMod .. "+mouse:273", hypr.window.resize(), { mouse = true })

    bind("XF86AudioRaiseVolume", exec("pamixer --increase 5 ; ~/.config/scripts/OSD.sh"),
        { repeating = true })
    bind("XF86AudioLowerVolume", exec("pamixer --decrease 5 ; ~/.config/scripts/OSD.sh"),
        { repeating = true })
    bind("XF86AudioMute", exec("pamixer -t"), { locked = true })
    bind("ALT+XF86AudioRaiseVolume", exec("brightnessctl -e4 -n2 set 5%+"), { repeating = true })
    bind("ALT+XF86AudioLowerVolume", exec("brightnessctl -e4 -n2 set 5%-"), { repeating = true })

    bind("ALT+TAB", function() plugin.hyprexpo.expo() end)

    -- Toggle DPMS на SUPER+F12
    local dpms_off = false
    bind(mainMod .. "+F12", function()
        hl.timer(function()
            if dpms_off then
                hl.dispatch(hl.dsp.dpms({ action = "enable" }))
                dpms_off = false
            else
                hl.dispatch(hl.dsp.dpms({ action = "disable" }))
                dpms_off = true
            end
        end, { timeout = 500, type = "oneshot" })
    end)

    hl.define_submap("hyprexpo", function()
        hl.bind("left", function() hl.plugin.hyprexpo.kb_focus("left") end)
        hl.bind("right", function() hl.plugin.hyprexpo.kb_focus("right") end)
        hl.bind("up", function() hl.plugin.hyprexpo.kb_focus("up") end)
        hl.bind("down", function() hl.plugin.hyprexpo.kb_focus("down") end)
        -- vim like:
        hl.bind("h", function() hl.plugin.hyprexpo.kb_focus("left") end)
        hl.bind("l", function() hl.plugin.hyprexpo.kb_focus("right") end)
        hl.bind("k", function() hl.plugin.hyprexpo.kb_focus("up") end)
        hl.bind("j", function() hl.plugin.hyprexpo.kb_focus("down") end)


        hl.bind("return", function() hl.plugin.hyprexpo.kb_confirm() end)
        hl.bind("escape", function() hl.plugin.hyprexpo.expo("cancel") end)
    end)
end
