local dap = require("dap")
local dapui = require("dapui")
local virtualtext = require("nvim-dap-virtual-text")


dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = "/home/thehilde/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb",
    args = {"--port", "${port}"},
  },
}


dap.configurations.cpp = {
  {
    name = "launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("path to executable ~ ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
  {
    name = "attach to process",
    type = "codelldb",
    request = "attach",
    pid = require("dap.utils").pick_process,
    args = {},
  },
}


dap.configurations.c = dap.configurations.cpp


vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition" })
vim.fn.sign_define("DapLogPoint", { text = "󰦪", texthl = "DapLogPoint" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped" })
vim.fn.sign_define("DapBreakpointRejected", { text = "󰗖", texthl = "DapBreakpointRejected" })


dapui.setup {
  icons = {
    expanded = " ",
    collapsed = " ",
    current_frame = " ",
  },
  controls = {
    icons = {
      play = "",
      pause = "",
      step_into = "󰆹",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "",
      terminate = "",
      disconnect = "",
    },
  },
}


dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open({ reset = true })
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close({})
end


virtualtext.setup {
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
  virt_text_win_col = nil,
  text_prefix = "~ ",
}


vim.keymap.set("n", "<F5>", function() dap.continue() end)
vim.keymap.set("n", "<F10>", function() dap.step_over() end)
vim.keymap.set("n", "<F11>", function() dap.step_into() end)
vim.keymap.set("n", "<F12>", function() dap.step_out() end)
vim.keymap.set("n", "<Leader>b", function() dap.toggle_breakpoint() end)
vim.keymap.set("n", "<Leader>B", function() dap.set_breakpoint(vim.fn.input("breakpoint condition: ")) end)
vim.keymap.set("n", "<Leader>lp", function() dap.set_breakpoint(nil, nil, vim.fn.input("log point message: ")) end)
vim.keymap.set("n", "<Leader>dr", function() dap.repl.open() end)
vim.keymap.set("n", "<Leader>dl", function() dap.run_last() end)
vim.keymap.set("n", "<Leader>du", function() dapui.toggle() end)
