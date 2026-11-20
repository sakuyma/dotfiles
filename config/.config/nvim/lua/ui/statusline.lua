-- Statusline built directly on Neovim's statusline items. The layout follows
-- the structure from the bars.nvim statusline guide (item groups, spacing and
-- dynamic Lua values) but has no statusline plugin dependency: `%!v:lua`
-- evaluates render() and Neovim parses the returned string as a normal
-- statusline, so `%<`, `%=` and `%#group#` all work as usual.
--
-- Colors come from `ui.theme.palette()` like the rest of the UI.

local M = {}

-- Same labels and ordering as the previous lualine setup.
local mode_text = {
    n = "NORMAL",
    ["no"] = "O-PENDING",
    nov = "O-PENDING",
    noV = "O-PENDING",
    ["no\22"] = "O-PENDING",
    niI = "NORMAL",
    niR = "NORMAL",
    niV = "NORMAL",
    nt = "NORMAL",
    ntT = "NORMAL",
    v = "VISUAL",
    vs = "VISUAL",
    V = "V-LINE",
    Vs = "V-LINE",
    ["\22"] = "V-BLOCK",
    ["\22s"] = "V-BLOCK",
    s = "SELECT",
    S = "S-LINE",
    ["\19"] = "S-BLOCK",
    i = "INSERT",
    ic = "INSERT",
    ix = "INSERT",
    R = "REPLACE",
    Rc = "REPLACE",
    Rx = "REPLACE",
    Rv = "V-REPLACE",
    Rvc = "V-REPLACE",
    Rvx = "V-REPLACE",
    c = "COMMAND",
    cv = "EX",
    ce = "EX",
    r = "REPLACE",
    rm = "MORE",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    t = "TERMINAL",
}

-- Mode colors, identical to the previous lualine configuration.
-- Keys correspond to the palette-backed groups below.
local mode_color = {
    n = "Accent",
    i = "Green",
    v = "Red",
    ["\22"] = "Red",
    V = "Red",
    ["no"] = "Red",
    c = "Magenta",
    s = "Orange",
    S = "Orange",
    ic = "Accent",
    R = "Yellow",
    Rv = "Accent",
    cv = "Red",
    ce = "Red",
    r = "Cyan",
    rm = "Cyan",
    ["r?"] = "Cyan",
    ["!"] = "Red",
    t = "Red",
}

-- Palette key backing each generated highlight group.
local color_keys = {
    Text = "text",
    Accent = "lavender",
    Red = "red",
    Green = "green",
    Yellow = "yellow",
    Magenta = "mauve",
    Orange = "peach",
    Cyan = "sky",
    Hint = "teal",
}

local function group(name)
    return "%#" .. name .. "#"
end

--- Escapes text so literal `%` is not interpreted as a statusline item.
---@param text string
---@return string
local function escape(text)
    return (text:gsub("%%", "%%%%"))
end

---@param buffer integer
---@return string
local function buffer_name(buffer)
    local name = vim.api.nvim_buf_get_name(buffer)
    if name == "" then
        return ""
    end

    return vim.fn.fnamemodify(name, ":t")
end

local function set_highlights()
    local palette = require("ui.theme").palette()

    for name, key in pairs(color_keys) do
        vim.api.nvim_set_hl(0, "Stl" .. name, {
            fg = palette[key],
            bg = palette.mantle,
            nocombine = true,
        })
    end
end

---@return string
local function mode()
    local current = vim.api.nvim_get_mode().mode
    local color = "Stl" .. (mode_color[vim.fn.mode()] or "Text")

    return group(color) .. " \xEF\x85\x84 " .. (mode_text[current] or current) .. " "
end

---@param buffer integer
---@return string
local function filesize(buffer)
    local name = vim.api.nvim_buf_get_name(buffer)
    local size = name ~= "" and vim.fn.getfsize(name) or -1
    if size <= 0 then
        return ""
    end

    local suffixes = { "b", "k", "m", "g" }
    local i = 1
    while size > 1024 and i < #suffixes do
        size = size / 1024
        i = i + 1
    end

    local format = i == 1 and "%d%s" or "%.1f%s"
    return group("StlText") .. " " .. string.upper(string.format(format, size, suffixes[i])) .. " "
end

---@param buffer integer
---@return string
local function filename(buffer)
    local name = buffer_name(buffer)
    if name == "" then
        return ""
    end

    return group("StlAccent") .. " " .. escape(name) .. " "
end

---@param window integer
---@return string
local function location(window)
    local line, col
    vim.api.nvim_win_call(window, function()
        line = vim.fn.line(".")
        col = vim.fn.charcol(".")
    end)

    return group("StlText") .. " " .. string.format("%3d:%-2d", line, col) .. " "
end

---@param buffer integer
---@return string
local function diagnostics(buffer)
    local counts = vim.diagnostic.count(buffer)
    local severity = vim.diagnostic.severity
    local parts = {}

    local kinds = {
        { severity = severity.ERROR, icon = "\xEF\x81\x97 ", color = "Red" },
        { severity = severity.WARN, icon = "\xEF\x81\xAA ", color = "Yellow" },
        { severity = severity.INFO, icon = "\xEF\x81\x9A ", color = "Green" },
        { severity = severity.HINT, icon = "\xEF\x81\x99 ", color = "Hint" },
    }

    for _, kind in ipairs(kinds) do
        local count = counts[kind.severity]
        if count and count > 0 then
            table.insert(parts, group("Stl" .. kind.color) .. kind.icon .. count)
        end
    end

    if #parts == 0 then
        return ""
    end

    return group("StlText") .. " " .. table.concat(parts, " ") .. " "
end

---@param buffer integer
---@return string
local function encoding(buffer)
    local value = vim.api.nvim_get_option_value("fileencoding", { buf = buffer })
    if value == "" then
        return ""
    end

    return group("StlText") .. " " .. string.upper(value) .. " "
end

---@param buffer integer
---@return string
local function fileformat(buffer)
    return group("StlText") .. " " .. string.upper(vim.bo[buffer].fileformat) .. " "
end

---@param window integer
---@return string
local function progress(window)
    local current, total
    vim.api.nvim_win_call(window, function()
        current = vim.fn.line(".")
        total = vim.fn.line("$")
    end)

    local value
    if current == 1 then
        value = "Top"
    elseif current == total then
        value = "Bot"
    else
        value = string.format("%2d%%%%", math.floor(current / total * 100))
    end

    return group("StlText") .. " " .. string.upper(value) .. " "
end

-- Branch names are cached per buffer so the statusline does not shell out to
-- git on every redraw. gitsigns' cached value is preferred when available.
local branch_cache = {}

---@param buffer integer
---@return string
local function branch(buffer)
    local head = vim.b[buffer].gitsigns_head
    if type(head) == "string" and head ~= "" then
        return head
    end

    local name = vim.api.nvim_buf_get_name(buffer)
    local cached = branch_cache[buffer]
    local now = vim.uv.now()

    if cached and cached.name == name and now - cached.at < 2000 then
        return cached.value
    end

    local value = ""
    local dir = name ~= "" and vim.fn.fnamemodify(name, ":p:h") or vim.fn.getcwd()

    local out = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--abbrev-ref", "HEAD" })
    if vim.v.shell_error == 0 and out[1] and out[1] ~= "HEAD" then
        value = out[1]
    elseif vim.v.shell_error == 0 then
        out = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--short", "HEAD" })
        if vim.v.shell_error == 0 then
            value = out[1] or ""
        end
    end

    branch_cache[buffer] = { value = value, name = name, at = now }
    return value
end

--- Builds the statusline for the window Neovim is currently drawing.
---@return string
function M.render()
    local window = tonumber(vim.g.statusline_winid) or vim.api.nvim_get_current_win()
    if not vim.api.nvim_win_is_valid(window) then
        window = vim.api.nvim_get_current_win()
    end

    local buffer = vim.api.nvim_win_get_buf(window)

    local parts = {
        -- `%<` marks where Neovim may truncate the line.
        "%<",
        group("StlAccent") .. "\xEE\x82\xB6 ",
        mode(),
    }

    local size = filesize(buffer)
    if size ~= "" then
        table.insert(parts, size)
    end

    local name = filename(buffer)
    if name ~= "" then
        table.insert(parts, name)
    end

    table.insert(parts, location(window))

    local diagnostic_text = diagnostics(buffer)
    if diagnostic_text ~= "" then
        table.insert(parts, diagnostic_text)
    end

    -- `%=` pushes everything after it to the right edge of the window.
    table.insert(parts, group("StlText") .. "%=")

    local branch_name = branch(buffer)
    if branch_name ~= "" then
        table.insert(parts, group("StlAccent") .. " \xEF\x82\x9B " .. escape(branch_name) .. " ")
    end

    table.insert(parts, encoding(buffer))
    table.insert(parts, fileformat(buffer))
    table.insert(parts, progress(window))
    table.insert(parts, group("StlAccent") .. " \xEE\x82\xB4")

    return table.concat(parts)
end

function M.setup()
    set_highlights()

    vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("ui_statusline_highlights", { clear = true }),
        callback = set_highlights,
    })

    vim.o.statusline = "%!v:lua.require('ui.statusline').render()"
end

return M
