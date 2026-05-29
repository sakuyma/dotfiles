local terminal = "footclient"
local terminal_alt = "kitty"
local file_manager = "thunar"
local browser_main = "zen-browser"
local browser_second = "helium-browser"
local telegram = "AyuGram"
local discord = "discord --enable-features=UseOzonePlatform --ozone-platform=wayland"
local music = "LD_PRELOAD=/usr/local/lib/spotify-adblock.so spotify --enable-features=UseOzonePlatform --ozone-platform=wayland"
local obsidian = "obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland"
local ide = "vscodium --disable-gpu-sandbox --enable-features=UseOzonePlatform --ozone-platform=wayland"

return {
    terminal = terminal,
    terminal_alt = terminal_alt,
    file_manager = file_manager,
    browser_main = browser_main,
    browser_second = browser_second,
    telegram = telegram,
    discord = discord,
    music = music,
    obsidian = obsidian,
    ide = ide
}
