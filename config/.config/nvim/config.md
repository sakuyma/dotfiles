# Neovim Config — Design & Operations

Living design document for this Neovim configuration.
Target: **Neovim 0.12.x**, LuaJIT. Current state: 39 plugins, ~18 ms cold start,
all plugin configuration lazy unless it must run at startup.

```sh
just          # list maintenance commands
just startup  # slowest startup phases
just health   # :checkhealth
```

---

## 1. Goals

- A keyboard-first IDE for Rust / C / C++ / Python / Lua / web, plus markdown notes.
- Fast startup: only startup-critical work runs eagerly.
- One obvious place for every concern: declarations in `plugin.lua`, behaviour in a
  domain module, keymaps next to the plugin they belong to.
- Theme colors come from one palette, never from hardcoded hex values.
- Missing external tools must never break startup or spam the message area.

---

## 2. Architecture

```
init.lua                     leader keys, module cache, core settings, plugin manager
lua/
  plugin.lua                 the entire lazy.nvim spec (triggers, keys, config hooks)
  icons.lua                  all glyphs, referenced by name
  settings/
    settings.lua             aggregator for the three core modules
    options.lua              vim.opt values
    autocmds.lua             spell/wrap per filetype, yank highlight
    keymaps.lua              core keymaps only — may never require a plugin
  ui/
    theme.lua                Catppuccin flavour + palette + custom highlights
    statusline.lua           native statusline, colors derived from the palette
    bufferline.lua           bufferline options
    noice.lua                cmdline/messages UI
    snacks.lua               picker, explorer, terminal, dashboard, indent
    helpview.lua             vimdoc decorations + floating ":help" preview
  code/
    lsp/
      init.lua               diagnostics, server registration, LspAttach keymaps
      servers.lua            per-server overrides only
      mason.lua              Mason + mason-lspconfig (install-only)
    completion.lua           nvim-cmp, LuaSnip, cmdline completion
    formatter.lua            conform.nvim (manual formatting)
    linters.lua              nvim-lint, skips linters that are not installed
    debugger.lua             nvim-dap: codelldb (Rust/C/C++), debugpy (Python)
    outline.lua              aerial
    gitsigns.lua             hunk signs
    sidekick.lua             AI CLI integration
  utils/
    treesitter.lua           parser installation + per-buffer highlighting
    textobjects.lua          select/move text objects
    todo.lua                 todo-comments
    trouble.lua              diagnostics/TODO lists
    obsidian.lua             Obsidian vault integration (picker: mini.pick)
stylua.toml                  formatting contract for this tree
justfile                     fmt / check / startup / health / parsers / clean / sync
```

### Load order

1. `init.lua` sets `mapleader` **before** anything else, then enables the Lua module
   cache, then loads core settings, then lazy.nvim.
2. lazy.nvim loads `lazy = false` plugins in priority order: Catppuccin (1000) →
   Snacks (900) → nvim-treesitter (100).
3. Everything else loads on its declared trigger (event, command, filetype, key).
4. Plugin `config` functions call a module's `setup()`; modules do not require each
   other except parent → child (`code.lsp` → `code.lsp.servers`).

Because the leader is set before `lazy.setup()`, every `<leader>…` entry in the spec
resolves correctly — this used to be broken (leader was assigned after the spec was
registered, so lazy created `\a` and `\xx` stubs instead of `<Space>a` / `<Space>xx`).

---

## 3. Principles (and where they are enforced)

| Principle | Enforcement |
|---|---|
| Declarations in one place | All plugins live in `lua/plugin.lua`; modules only contain behaviour |
| No plugin `require` in startup files | `settings/keymaps.lua` and `settings/*` only use core APIs |
| Laziness is honest | Triggers match real usage; plugins that must run early are `lazy = false` on purpose |
| Keymaps are discoverable | Every mapping has `desc`; keymaps ship with the plugin spec so lazy can load on first use |
| One source of color truth | `ui/theme.lua` owns the flavour/palette; statusline and highlights read from it |
| Missing tools are not errors | LSP servers are executable-guarded; linters are filtered by availability; DAP adapters are installed-checked |
| Native-first | LSP via `vim.lsp.config` / `vim.lsp.enable`; nvim-lspconfig is used only for its `lsp/*.lua` defaults |
| Filetype-scoped behaviour | `wrap` is on only for prose; spell only for text/markdown/gitcommit |
| Structure over cleverness | Domain folders, one `setup()` per plugin, 4-space style pinned by `stylua.toml` |
| No dead configuration | Unused files, commented-out configs and duplicate assignments were removed |

---

## 4. Plugin loading strategy

| Strategy | Plugins |
|---|---|
| Startup (`lazy = false`) | catppuccin, snacks, nvim-treesitter, markview, helpview |
| `BufReadPre` / `BufNewFile` | nvim-lspconfig, gitsigns, todo-comments, textobjects, nvim-lint (`BufReadPost`/`BufWritePost`) |
| `InsertEnter` | nvim-cmp (+ sources), mini.pairs |
| `BufAdd` / `VeryLazy` | bufferline; noice |
| Filetype | markview, obsidian (markdown), crates (toml) |
| Command | trouble (`Trouble`), aerial (`AerialToggle`), conform (`ConformInfo`), sidekick (`Sidekick`) |
| Key only | nvim-dap (F5/F10–F12 and `<leader>d*`) |

`snacks.nvim` is deliberately eager: dashboard, indent guides, notifier and explorer are
startup features. Claiming it was lazy (the old spec) only hid a `require` that forced it.

---

## 5. Keymap policy

Leader and local leader are both `<Space>`.

```
<leader>w/q/Q   write · quit · force quit all
<leader>f*      find (files, recent, grep, buffers, todos)
<leader>g*      git (lazygit, branches, commits, status)
<leader>h*      git hunks (stage, reset, preview, blame, diff)
<leader>l*      LSP (definition, hover, implementation, references, rename, action, float, format)
<leader>d*      debugger (breakpoints, REPL, UI, terminate) + F5/F10/F11/F12
<leader>b*      buffers (next, previous, delete, delete others); <leader>bb alternate
<leader>T*      tab pages (new, duplicate, edit, close, only, move)
<leader>x*      diagnostics and TODOs (Trouble)
<leader>a       outline toggle
<leader>s*      AI assistant
<leader>t       terminal toggle
<leader>n       file explorer
<leader>v*      splits (vs vertical, vh horizontal)
<leader>hl      clear search highlight
```

Non-prefix mappings are intentional and consistent with the existing editing style:

- `j`/`k` move by display line, `J`/`K` line start/end; `H`/`L` keep their native
  top/bottom-of-screen behaviour.
  These shadow Vim defaults; `K` no longer opens hover because LSP hover is
  `<leader>lh`, so a key never means two different things depending on the buffer.
- `<C-h/j/k/l>` window navigation; `<C-u>/<C-d>` scrolling is centred.
- `x` deletes without yanking, `<C-Y>` duplicates the current line.
- `<Tab>`/`<S-Tab>` are **not** remapped: the jump list works again. Buffer switching is
  `<leader>bn` / `<leader>bp` (and `<leader>fb` in the picker).
- Tab pages moved to uppercase `<leader>T*`; previously `<leader>t` meant both
  “terminal” and “tab”, and `tt` collided with the todo picker.

---

## 6. Theme and colors

- Flavour: `mocha` (`ui/theme.lua`), transparent background, no italic/bold/underline.
- `ui/theme.lua` exposes `flavour` and `palette()`; `ui/statusline.lua` and the custom
  highlights (`FloatBorder`, `SnacksIndent`, `SnacksIndentScope`, `SignColumn`) read
  from it and are re-applied on every `ColorScheme` event.
- Catppuccin integrations enabled for installed plugins: aerial, cmp, dap, dap-ui,
  gitsigns, trouble, mason, mini, native_lsp, noice, render-markdown, snacks, treesitter.
- Bufferline gets its colors from `catppuccin.special.bufferline` (guarded with `pcall`).
- Bufferline renders **buffers** (`mode = "buffers"`) and hides the tabline automatically
  when only one buffer is open (`always_show_bufferline = false`). Opening a second
  buffer brings it back.
- The statusline is written directly against Neovim's statusline items
  (`vim.o.statusline = "%!v:lua.require('ui.statusline').render()"`). The layout follows
  the structure from the bars.nvim statusline guide, but no statusline plugin is
  required.

---

## 7. Language tooling

### LSP

- Mason installs `pyright`, `rust_analyzer`, `lua_ls`, `clangd`, `html`, `jsonls`, `cssls`.
- `mason-lspconfig` runs with `automatic_enable = false`: the allowlist in
  `code/lsp/servers.lua` is authoritative. Before this, every installed Mason server
  (including `ruff`, `ltex`, `marksman`, `purescriptls`) was silently enabled.
- `servers.lua` contains only overrides; command, filetypes and root markers come from
  nvim-lspconfig defaults and are merged by `vim.lsp.config(name, overrides)`.
- Servers with a table `cmd` are enabled only when the executable exists; function
  commands (html/json/css) are resolved by Neovim itself.
- Diagnostics: virtual text off, signs on, rounded float, severity sorted. `$/progress`
  notifications are suppressed to keep the cmdline quiet.
- Keymaps are attach-time and buffer-local (`<leader>l*`, `[d`/`]d`).

### Completion

- nvim-cmp on `InsertEnter`; LuaSnip (VS Code snippets) for expansion; lspkind formatting.
- Sources: LSP, snippets, path, buffer. Cmdline and search get their own source sets, so
  the installed `cmp-cmdline` is actually used.
- Prose/config filetypes prefer the buffer source.

### Formatting and linting

- conform.nvim: **manual** formatting only (`<leader>lf`, `ConformInfo`). Per-filetype
  chain: black+isort, rustfmt, clang_format, stylua, prettier.
- nvim-lint: runs on read, write and `InsertLeave`. The desired linter map is filtered at
  setup time against `vim.fn.executable`, so a missing tool is skipped instead of erroring
  on every buffer. Active on a typical machine: shellcheck, ruff, clangtidy, codespell.
  Removed invalid entries: `stylua` and `taplo` are not nvim-lint linters; `clang_tidy`
  is spelled `clangtidy`.

### Debugging

- `codelldb` adapter shared by `rust`, `c`, `cpp`; guarded by the Mason executable path.
- `python` via Mason's debugpy venv (`debugpy.adapter`).
- dap-ui layouts, virtual text, and auto open/close listeners.
- Keymaps: F5 continue, F10/F11/F12 stepping, `<leader>db` breakpoint, `<leader>dB`
  conditional, `<leader>dl` log point, `<leader>dr` REPL, `<leader>dL` run last,
  `<leader>du` toggle UI, `<leader>dx` terminate.

### Treesitter

- `main` branch. Parsers are declared in `utils/treesitter.lua` and installed with
  `require("nvim-treesitter").install(...)`; highlighting is started per buffer by a
  `FileType` autocmd (on the main branch it is **not** automatic).
- Installed: bash, c, cpp, css, diff, dockerfile, gitcommit, html, javascript, json, lua,
  luadoc, markdown(+inline), python, query, regex, rust, toml, tsx, typescript, vim,
  vimdoc, yaml.
- Text objects: `af`/`if` functions, `ac`/`ic` classes, `aa`/`ia` parameters,
  `]f`/`[f` next/previous function.

### Help viewer

- `helpview.nvim` is eager (`lazy = false`): it has to attach to `help` buffers as they
  are created. It renders `vimdoc` with the `vimdoc` treesitter parser and opens a
  centred floating preview plus in-place decorations.
- `ui/helpview.lua` keeps hybrid mode off (`hybrid_modes = {}`), uses helpview's
  internal icon set and starts a split view on the right when requested.
- Per-buffer control is `:Helpview toggle`; `:Help`/`:H` open help through the plugin.
  `:checkhealth helpview` verifies the parser and icon provider.

---

## 8. Prerequisites

| Tool | Why |
|---|---|
| `tree-sitter-cli` on `$PATH` | nvim-treesitter (main) compiles parsers with it |
| `ripgrep` | pickers, todo-comments, obsidian |
| `stylua` | Lua formatting (`just fmt`, `<leader>lf` in Lua files) |
| `prettier`, `black`, `isort`, `clang-format`, `rustfmt` | formatters |
| `shellcheck`, `ruff`, `clang-tidy`, `codespell`, … | linters (missing ones are skipped) |
| `lazygit` | `<leader>gg` |
| Nerd Font | icons |

`tree-sitter-cli` is not installed by the config. On this machine it was installed with
`npm install -g --prefix ~/.local tree-sitter-cli`; parsers live in
`stdpath("data")/site/parser`.

---

## 9. Maintenance

```sh
just fmt        # stylua .
just check      # stylua --check .
just startup    # 20 slowest startup entries
just health     # interactive :checkhealth
just parsers    # TSUpdate
just sync       # Lazy sync
just clean      # remove plugins no longer in the spec
just count      # Lua line count
```

### Adding a plugin

1. Add one entry in `lua/plugin.lua` with the narrowest trigger that works and a `keys`
   table whose entries all have `desc`.
2. Put behaviour in a module under `lua/{ui,code,utils}/` that returns `M` with
   `M.setup()`.
3. Reference it as `config = function() require("domain.module").setup() end`.
4. Never require plugins from `settings/keymaps.lua`.

---

## 10. Accepted tradeoffs

- `J`/`K` replace `^`/`$` (word movement stays on `b`/`w`); `H`/`L` are native. The LSP
  hover collision was resolved by moving hover to `<leader>lh`.
- Formatting is manual (no format-on-save) and linting is asynchronous.
- Prose gets soft wrap and spell; code does not.
- `whichwrap = ""` is intentional: `h`/`l` never jump to the previous/next line.
- The statusline has a solid `mantle` background even though the editor is transparent.
- Tab pages are de-emphasised in favour of buffers.
- Upstream deprecation warning `vim.tbl_flatten` comes from helpview, not from this
  config.

---

## 11. Refactor changelog

| Before | After |
|---|---|
| Leader set after `lazy.setup()`; `<leader>a`/`<leader>xx` bound to `\a`/`\xx` | Leader set in `init.lua` before the spec; verified `maparg("<leader>a")` |
| Two leader assignments (`""` and `" "`) | One assignment in `init.lua` |
| 260-line `code/lsp.lua` mixing diagnostics, cmp, mason, servers | `code/lsp/{init,servers,mason}.lua` + `code/completion.lua` |
| Plugin keymaps in a startup file requiring snacks/dap | Keymaps in the plugin spec; no plugin requires in settings |
| Spec advertised lazy events but startup required everything | Startup ~63 ms → ~18 ms; only 3 eager plugins |
| Dead files: `autopairs.lua`, `linters.lua`, `markdown.lua`, `colorsheme.lua` | Removed; mini.pairs configured in the spec; nvim-lint wired and active; Obsidian configured |
| Linting configured nowhere | nvim-lint installed, availability-filtered, event-triggered |
| Treesitter installed but no parsers and no highlight start | Parsers installed, `FileType` start hook, working highlighting |
| 5 unused colorschemes + stale lock entries + orphan plugin dirs | `:Lazy clean` run; 39 specs, all intentional |
| `:Gitsigns` command wrappers and duplicate `]c`/`[c` | Action-function keymaps declared once |
| `separator_style = "slopped"` | `"slope"` |
| No-op `vim.lsp.enable(vim.tbl_keys(vim.lsp.config))` | Removed; explicit allowlist |
| All installed Mason servers auto-enabled | `automatic_enable = false` |
| `automatic_installation` (removed in mason-lspconfig v2) | `ensure_installed` only |
| `guicursor = "i:block"` wiped default cursors | Explicit full `guicursor` string |
| `<leader>q` = `q!`, `<BS>` = `:edit #`, `<Tab>` = buffer cycle | Safe `:q`, `:e #` on `<leader>bb`, jump list restored |
| Hardcoded hex colors in statusline and highlights | Palette-derived colors, reapplied on `ColorScheme` |
| DAP Rust-only; ignored Python/C/C++ | codelldb for Rust/C/C++ + debugpy for Python |
| Obsidian picker pointed at uninstalled telescope | `mini.pick` added and used |
| No formatter config for contributors | `stylua.toml` + `just fmt/check` |
| `justfile` only counted lines | fmt, check, startup, health, parsers, clean, sync |

---

## 12. Open items (optional)

- Install the external formatters/linters, or move them into Mason's `ensure_installed`
  (`stylua` and most linters are currently not on `$PATH`; they are skipped gracefully).
- Mason still holds `ltex-ls`, `marksman`, `purescript-language-server` binaries from
  earlier experiments. They no longer start; remove with `:MasonUninstall` if unwanted.
- `which-key.nvim` would make the (now complete) `<leader>` groups browsable.
- Tree-sitter folding (`foldexpr`) is not enabled.
- No CI/lint job; `just check` is the local entry point.
- `render-markdown` uses defaults; tune conceal/anti-conceal per taste.
