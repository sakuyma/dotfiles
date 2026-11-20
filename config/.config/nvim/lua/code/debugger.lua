-- Debugger: nvim-dap + dap-ui + virtual text, Rust/C/C++ via codelldb, Python via debugpy.

local M = {}

local data = vim.fn.stdpath("data")

local function define_signs()
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition" })
    vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint" })
    vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpointRejected" })
end

local function setup_codelldb(dap)
    local executable = data .. "/mason/packages/codelldb/extension/adapter/codelldb"
    if vim.fn.executable(executable) ~= 1 then
        return
    end

    dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
            command = executable,
            args = { "--port", "${port}" },
        },
    }

    local function configurations()
        return {
            {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = {},
                runInTerminal = false,
            },
            {
                name = "Attach to process",
                type = "codelldb",
                request = "attach",
                pid = require("dap.utils").pick_process,
                args = {},
            },
        }
    end

    dap.configurations.rust = configurations()
    dap.configurations.c = configurations()
    dap.configurations.cpp = configurations()
end

local function setup_python(dap)
    local python = data .. "/mason/packages/debugpy/venv/bin/python"
    if vim.fn.executable(python) ~= 1 then
        return
    end

    dap.adapters.python = {
        type = "executable",
        command = python,
        args = { "-m", "debugpy.adapter" },
        options = { source_filetype = "python" },
    }

    dap.configurations.python = {
        {
            name = "Launch file",
            type = "python",
            request = "launch",
            program = "${file}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            justMyCode = false,
        },
    }
end

local function setup_ui()
    local dapui = require("dapui")

    dapui.setup({
        layouts = {
            {
                elements = {
                    { id = "scopes", size = 0.3 },
                    { id = "watches", size = 0.3 },
                    { id = "stacks", size = 0.3 },
                },
                size = 0.3,
                position = "right",
            },
            {
                elements = {
                    { id = "console", size = 0.55 },
                    { id = "repl", size = 0.45 },
                },
                position = "bottom",
                size = 0.25,
            },
        },
        icons = {
            expanded = " ",
            collapsed = " ",
            current_frame = " ",
        },
        controls = {
            icons = require("icons").debugger,
        },
    })

    require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        virt_lines = false,
        virt_text_pos = "eol",
        text_prefix = "* ",
    })

    local listeners = require("dap").listeners
    listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ reset = true })
    end
    listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
end

function M.setup()
    local dap = require("dap")

    setup_codelldb(dap)
    setup_python(dap)
    define_signs()
    setup_ui()
end

return M
