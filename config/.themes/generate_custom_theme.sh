#!/usr/bin/env bash

clear
echo "=================================================="
echo "    🎨 saku•core Theme Generator (Full Tree)     "
echo "=================================================="
echo ""

read -p "📝 Название темы (напр., Mocha-Lavender): " THEME_NAME
THEME_NAME="${THEME_NAME:-Custom-Theme}"

echo ""
echo "Вводи HEX-коды (например: 1e1e2e или #1e1e2e):"
echo "--------------------------------------------------"

get_color() {
    local prompt=$1 default=$2 res
    read -p "$prompt [$default]: " res
    res="${res:-$default}"
    [[ $res =~ ^# ]] && echo "$res" || echo "#$res"
}

# Собираем палитру
ACCENT=$(get_color "🔹 Accent (Lavender)" "b4befe")
BASE=$(get_color "⬛ Base" "1e1e2e")
MANTLE=$(get_color "🔲 Mantle (Вторичный фон)" "181825")
CRUST=$(get_color "🌑 Crust (Границы/Темный)" "11111b")
SURFACE0=$(get_color "🔘 Surface 0 (Поля/Элементы)" "313244")
SURFACE1=$(get_color "🔘 Surface 1 (Ховеры)" "45475a")
SURFACE2=$(get_color "🔘 Surface 2" "585b70")
OVERLAY0=$(get_color "👵 Overlay 0 (Мутед текст)" "6c7086")
TEXT=$(get_color "⚪ Text (Основной текст)" "cdd6f4")
SUBTEXT0=$(get_color "🔘 Subtext 0" "a6adc8")

# Дополнительные ассеты для полноценных терминалов/конфигов
RED=$(get_color "🍒 Red" "f38ba8")
GREEN=$(get_color "🍏 Green" "a6e3a1")
YELLOW=$(get_color "🍋 Yellow" "f9e2af")
BLUE=$(get_color "🐳 Blue" "89b4fa")
MAUVE=$(get_color "🍇 Mauve" "cba6f7")

# Убираем решетку для конфигов, которые её не переваривают (kitty, alacritty)
HEX_ACCENT=${ACCENT#}  HEX_BASE=${BASE#}      HEX_MANTLE=${MANTLE#}
HEX_CRUST=${CRUST#}    HEX_SURFACE0=${SURFACE0#} HEX_SURFACE1=${SURFACE1#}
HEX_TEXT=${TEXT#}      HEX_RED=${RED#}        HEX_GREEN=${GREEN#}
HEX_YELLOW=${YELLOW#}  HEX_BLUE=${BLUE#}      HEX_MAUVE=${MAUVE#}

echo -e "\n🚀 Накатываю конфигурации по дереву..."

# --- 0. Корень: theme.conf ---
mkdir -p $THEME_NAME 
cd $THEME_NAME
mkdir -p .
cat << EOF > "theme.conf"
# $THEME_NAME generated palette
\$accent = $ACCENT
\$base = $BASE
\$mantle = $MANTLE
\$crust = $CRUST
\$surface0 = $SURFACE0
\$surface1 = $SURFACE1
\$text = $TEXT
EOF

# --- 1. Alacritty ---
mkdir -p alacritty
cat << EOF > "alacritty/theme.toml"
[colors.primary]
background = "0x$HEX_BASE"
foreground = "0x$HEX_TEXT"

[colors.normal]
black = "0x$HEX_MANTLE"
red = "0x$HEX_RED"
green = "0x$HEX_GREEN"
yellow = "0x$HEX_YELLOW"
blue = "0x$HEX_BLUE"
magenta = "0x$HEX_MAUVE"
cyan = "0x$HEX_ACCENT"
white = "0x$HEX_TEXT"
EOF

# --- 2. Dunst ---
mkdir -p dunst
cat << EOF > "dunst/dunstrc"
[global]
    frame_color = "$ACCENT"
    separator_color = "$SURFACE0"
    font = "JetBrainsMono Nerd Font 10"

[urgency_low]
    background = "$BASE"
    foreground = "$TEXT"

[urgency_normal]
    background = "$BASE"
    foreground = "$TEXT"
    timeout = 10

[urgency_critical]
    background = "$BASE"
    foreground = "$RED"
    frame_color = "$RED"
EOF

# --- 3. Hypr Module (Lua theme) ---
mkdir -p hypr/modules
cat << EOF > "hypr/modules/theme.lua"
-- Theme: $THEME_NAME
local M = {}
M.accent = "$ACCENT"
M.base = "$BASE"
M.mantle = "$MANTLE"
M.crust = "$CRUST"
M.surface0 = "$SURFACE0"
M.text = "$TEXT"
return M
EOF

# --- 4. Kitty ---
mkdir -p kitty
cat << EOF > "kitty/theme.conf"
background #$HEX_BASE
foreground #$HEX_TEXT
selection_background #$HEX_SURFACE1
selection_foreground #$HEX_TEXT
url_color #$HEX_ACCENT

# Colors
color0 #$HEX_MANTLE
color1 #$HEX_RED
color2 #$HEX_GREEN
color3 #$HEX_YELLOW
color4 #$HEX_BLUE
color5 #$HEX_MAUVE
color6 #$HEX_ACCENT
color7 #$HEX_TEXT
EOF

# --- 5. Niri Module ---
mkdir -p niri/modules
cat << EOF > "niri/modules/theme.kdl"
// $THEME_NAME Niri configuration
layout {
    focus-ring {
        color "$ACCENT"
    }
    border {
        off-color "$MANTLE"
    }
}
EOF

# --- 6. Neovim (Base Colors definition) ---
mkdir -p nvim/lua/settings
cat << EOF > "nvim/lua/settings/colorsheme.lua"
-- Generated $THEME_NAME palette for Neovim
local colors = {
  base = "$BASE",
  mantle = "$MANTLE",
  crust = "$CRUST",
  accent = "$ACCENT",
  surface0 = "$SURFACE0",
  surface1 = "$SURFACE1",
  text = "$TEXT",
}
-- Тут может быть твой setup для любимого плагина темы (напр. catppuccin/base16)
EOF

# --- 7. Rofi ---
mkdir -p rofi
cat << EOF > "rofi/theme.rasi"
* {
    bg: $BASE;
    bg-alt: $MANTLE;
    fg: $TEXT;
    accent: $ACCENT;
    
    background-color: @bg;
    text-color: @fg;
}
EOF

# --- 8. SwayNC ---
mkdir -p swaync
cat << EOF > "swaync/theme.css"
@define-color cc-bg $BASE;
@define-color noti-bg $MANTLE;
@define-color noti-border $SURFACE0;
@define-color text-color $TEXT;
@define-color accent-color $ACCENT;
EOF

# --- 9. Vesktop ---
mkdir -p vesktop/settings
cat << EOF > "vesktop/settings/quickCss.css"
.visual-refresh.theme-dark,.visual-refresh .theme-dark {
  --brand-experiment: $ACCENT;
  --bg-brand: $ACCENT;
  --brand-500: $ACCENT !important;
  --header-primary: $TEXT !important;
  --header-secondary: $SUBTEXT0 !important;
  --__header-bar-background: $MANTLE !important;
  --text-normal: $TEXT !important;
  --text-muted: $SUBTEXT0 !important;
  --text-link: $ACCENT !important;
  --background-primary: $BASE !important;
  --background-secondary: $MANTLE !important;
  --background-tertiary: $CRUST !important;
  --background-accent: $SURFACE1 !important;
  --scrollbar-thin-thumb: $ACCENT;
}
EOF

# --- 10. Waybar ---
mkdir -p waybar
cat << EOF > "waybar/theme.css"
@define-color bg-main $BASE;
@define-color bg-alt $ACCENT;
@define-color bg-hover $SURFACE1;
@define-color bg-second $MANTLE;
@define-color bg-third $SURFACE0;
@define-color fg-main $ACCENT;
@define-color fg-unactive $OVERLAY0;
@define-color content-act $TEXT;
@define-color ply-main $CRUST;
EOF

# --- 11. Zen Browser (userChrome & userContent) ---
mkdir -p zen
cat << EOF > "zen/userChrome.css"
@media (prefers-color-scheme: dark) {
  :root {
    --zen-colors-primary: $SURFACE0 !important;
    --zen-primary-color: $ACCENT !important;
    --zen-colors-secondary: $SURFACE0 !important;
    --zen-colors-tertiary: $MANTLE !important;
    --zen-colors-border: $ACCENT !important;
    --toolbarbutton-icon-fill: $ACCENT !important;
    --lwt-text-color: $TEXT !important;
    --sidebar-text-color: $TEXT !important;
    --lwt-sidebar-background-color: $CRUST !important;
    --toolbar-bgcolor: $SURFACE0 !important;
    --newtab-background-color: $BASE !important;
  }
}
EOF

cat << EOF > "zen/userContent.css"
@media (prefers-color-scheme: dark) {
  @-moz-document url-prefix("about:") {
    :root {
      --in-content-page-color: $TEXT !important;
      --color-accent-primary: $ACCENT !important;
      background-color: $BASE !important;
    }
  }
}
EOF

# --- 12. GTK 3 & 4 Assets (Генерируем базовые цвета css инжектом, если нужно) ---
# Для полноценной генерации GTK тем обычно используют gradience/cli, но базовые ini мы поправим
for v in "gtk-3.0" "gtk-4.0"; do
    mkdir -p "$v"
    cat << EOF > "$v/settings.ini"
[Settings]
gtk-theme-name = $THEME_NAME
gtk-application-prefer-dark-theme = true
EOF
done

echo "--------------------------------------------------"
echo "🎉 Готово! Все конфиги в дереве перегенерированы под '$THEME_NAME'."
echo "================================================--"
