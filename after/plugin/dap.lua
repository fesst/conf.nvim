local dap = require('dap')
local dapui = require('dapui')

-- Auto-install DAP adapters
local mason_registry = require("mason-registry")
local function ensure_dap_installed()
    local adapters = {
        "debugpy",           -- Python
        "netcoredbg",        -- C#
        "elixir-ls",         -- Elixir
    }
    
    for _, adapter in ipairs(adapters) do
        if not mason_registry.is_installed(adapter) then
            mason_registry.get_package(adapter):install()
        end
    end
end

ensure_dap_installed()

-- DAP UI setup
dapui.setup({
    icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
    mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    element_mappings = {
        stacks = {
            open = "<CR>",
            expand = "o",
        },
        scopes = {
            open = "<CR>",
            expand = "o",
        },
        breakpoints = {
            open = "<CR>",
            expand = "o",
        },
    },
    expand_lines = true,
    layouts = {
        {
            elements = {
                { id = "scopes", size = 0.33 },
                { id = "breakpoints", size = 0.17 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
            },
            size = 0.33,
            position = "right",
        },
        {
            elements = {
                { id = "repl", size = 0.45 },
                { id = "console", size = 0.55 },
            },
            size = 0.27,
            position = "bottom",
        },
    },
    controls = {
        enabled = true,
        element = "repl",
        icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
        },
    },
    floating = {
        max_height = 0.9,
        max_width = 0.5,
        border = "rounded",
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    windows = { indent = 1 },
})

-- DAP keymaps
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<leader>du', dap.step_out, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>dB', function()
    dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'Debug: Set Conditional Breakpoint' })
vim.keymap.set('n', '<leader>dl', function()
    dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end, { desc = 'Debug: Set Log Point' })
vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Debug: Open REPL' })
vim.keymap.set('n', '<leader>dL', dap.run_last, { desc = 'Debug: Run Last' })

-- DAP events
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

-- Python DAP configuration
dap.adapters.python = {
    type = 'executable',
    command = 'python',
    args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = function()
            return vim.fn.exepath('python3')
        end,
    },
    {
        type = 'python',
        request = 'attach',
        name = 'Attach to process',
        processId = function()
            return vim.fn.input('Process ID: ')
        end,
    },
}

-- JavaScript/TypeScript DAP configuration
dap.adapters.node = {
    type = 'server',
    host = 'localhost',
    port = '${port}',
    executable = {
        command = 'node',
        args = { '--inspect-brk' },
    },
}

dap.configurations.javascript = {
    {
        type = 'node',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'auto',
        console = 'integratedTerminal',
    },
}

dap.configurations.typescript = dap.configurations.javascript

-- Go DAP configuration
-- Note: Requires manual installation of Delve:
-- go install github.com/go-delve/delve/cmd/dlv@latest
dap.adapters.delve = {
    type = 'server',
    port = '${port}',
    executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}' },
    },
}

dap.configurations.go = {
    {
        type = 'delve',
        name = 'Debug',
        request = 'launch',
        program = '${file}',
    },
    {
        type = 'delve',
        name = 'Debug test',
        request = 'launch',
        mode = 'test',
        program = '${file}',
    },
}

-- Rust and C/C++ DAP configuration
-- Note: Requires manual installation of CodeLLDB:
-- cargo install codelldb
dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
        command = 'codelldb',
        args = { '--port', '${port}' },
    },
}

dap.configurations.rust = {
    {
        type = 'codelldb',
        request = 'launch',
        name = 'Debug executable',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
    {
        type = 'codelldb',
        request = 'launch',
        name = 'Debug unit tests',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        args = { '--test' },
        stopOnEntry = false,
    },
}

-- C/C++ DAP configuration
dap.configurations.cpp = {
    {
        name = 'Launch file',
        type = 'cppdbg',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
        setupCommands = {
            {
                text = '-enable-pretty-printing',
                description = 'enable pretty printing',
                ignoreFailures = false,
            },
        },
    },
}

dap.configurations.c = dap.configurations.cpp

-- Lua DAP configuration
dap.adapters.nlua = function(callback, config)
    callback({ type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 })
end

dap.configurations.lua = {
    {
        type = 'nlua',
        request = 'attach',
        name = 'Attach to running Neovim instance',
        host = function()
            return vim.fn.input('Host [127.0.0.1]: ', '127.0.0.1')
        end,
        port = function()
            return tonumber(vim.fn.input('Port: ', '8086'))
        end,
    },
}

-- Java DAP configuration
dap.configurations.java = {
    {
        type = 'java',
        request = 'launch',
        name = 'Debug (Attach)',
        hostName = '127.0.0.1',
        port = 5005,
    },
    {
        type = 'java',
        request = 'launch',
        name = 'Debug (Launch)',
        program = function()
            return vim.fn.input('Path to main class: ', vim.fn.getcwd() .. '/', 'file')
        end,
    },
}

-- Kotlin DAP configuration
dap.configurations.kotlin = dap.configurations.java

-- PHP DAP configuration
dap.adapters.php = {
    type = 'executable',
    command = 'php',
    args = { '-dxdebug.remote_enable=1', '-dxdebug.remote_autostart=1' },
}

dap.configurations.php = {
    {
        type = 'php',
        request = 'launch',
        name = 'Listen for Xdebug',
        port = 9003,
    },
}

-- Ruby DAP configuration
dap.adapters.ruby = {
    type = 'executable',
    command = 'bundle',
    args = { 'exec', 'rdbg', '-n', '--open', '--port', '${port}' },
}

dap.configurations.ruby = {
    {
        type = 'ruby',
        request = 'launch',
        name = 'Rails server',
        program = 'bundle',
        args = { 'exec', 'rails', 'server' },
        askArgs = true,
    },
    {
        type = 'ruby',
        request = 'launch',
        name = 'RSpec current file',
        program = 'bundle',
        args = { 'exec', 'rspec', '${file}' },
        askArgs = true,
    },
}

-- Elixir DAP configuration
dap.adapters.mix_task = {
    type = 'executable',
    command = 'elixir-ls-debugger',
    args = {},
}

dap.configurations.elixir = {
    {
        type = 'mix_task',
        name = 'mix test',
        task = 'test',
        taskArgs = { '--trace' },
        request = 'launch',
        startApps = true,
        projectDir = '${workspaceFolder}',
        requireFiles = {
            'test/**/test_helper.exs',
            'test/**/*_test.exs'
        },
    },
    {
        type = 'mix_task',
        name = 'mix test current file',
        task = 'test',
        taskArgs = { '${file}' },
        request = 'launch',
        startApps = true,
        projectDir = '${workspaceFolder}',
    },
}

-- C# DAP configuration
dap.adapters.coreclr = {
    type = 'executable',
    command = 'netcoredbg',
    args = { '--interpreter=vscode' },
}

dap.configurations.cs = {
    {
        type = 'coreclr',
        name = 'Launch .NET Core',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end,
    },
}

-- Zig DAP configuration
dap.adapters.zls = {
    type = 'executable',
    command = 'zls',
    args = { '--debug' },
}

dap.configurations.zig = {
    {
        type = 'zls',
        name = 'Debug',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
    },
}
