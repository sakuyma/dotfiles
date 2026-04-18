require("nvim-treesitter.configs").setup({
    -- Автоматически устанавливать парсеры для языков, которые не указаны
    auto_install = true,
    
    -- Явно указываем, какие парсеры установить
    ensure_installed = {
        "rust",
        "python",
        "lua",
        "bash",
        "toml",      -- добавил для твоих конфигов
        "json",
        "markdown",
    },
    
    -- Подсветка синтаксиса
    highlight = {
        enable = true,
        -- Отключаем старую regex-подсветку для чистоты
        additional_vim_regex_highlighting = false,
    },
    
    -- Умные отступы
    indent = {
        enable = true,
    },
    
    -- Пошаговое выделение кода
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gn",
            node_incremental = "gn",
            scope_incremental = "gs",
            node_decremental = "gm",
        },
    },
    
    -- Текстовые объекты (нужен дополнительный модуль!)
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
    },
})

-- Это можно оставить как есть (не относится к Treesitter)
vim.filetype.add({
    pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
