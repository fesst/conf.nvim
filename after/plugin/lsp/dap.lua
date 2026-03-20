local ssh_utils = require("motleyfesst.utils.ssh")

if ssh_utils.IS_LOCAL() then
    local dap = require("dap")
    local dapui = require("dapui")
    local mason_registry = require("mason-registry")

    local function ensure_dap_installed()
        local adapters = {}
        for _, adapter in ipairs(adapters) do
            if not mason_registry.is_installed(adapter) then
                mason_registry.get_package(adapter):install()
            end
        end
    end
    ensure_dap_installed()

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
            stacks = { open = "<CR>", expand = "o" },
            scopes = { open = "<CR>", expand = "o" },
            breakpoints = { open = "<CR>", expand = "o" },
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

    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Start/Continue" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<leader>du", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: Set Conditional Breakpoint" })
    vim.keymap.set("n", "<leader>dl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end, { desc = "Debug: Set Log Point" })
    vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
    vim.keymap.set("n", "<leader>dL", dap.run_last, { desc = "Debug: Run Last" })

    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end

    -- Disabled adapters moved to after/discharged/dap/

    dap.adapters.node = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
            command = "node",
            args = { "--inspect-brk" },
        },
    }

    dap.configurations.javascript = {
        {
            type = "node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "auto",
            console = "integratedTerminal",
        },
    }

    dap.configurations.typescript = dap.configurations.javascript

    dap.adapters.nlua = function(callback, config)
        callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
    end
    dap.configurations.lua = {
        {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance",
            host = function()
                return vim.fn.input("Host [127.0.0.1]: ", "127.0.0.1")
            end,
            port = function()
                return tonumber(vim.fn.input("Port: ", "8086"))
            end,
        },
    }
    dap.configurations.java = {
        {
            type = "java",
            request = "launch",
            name = "Debug (Attach)",
            hostName = "127.0.0.1",
            port = 5005,
        },
        {
            type = "java",
            request = "launch",
            name = "Debug (Launch)",
            program = function()
                return vim.fn.input("Path to main class: ", vim.fn.getcwd() .. "/", "file")
            end,
        },
    }

    dap.configurations.kotlin = dap.configurations.java

    dap.adapters.php = {
        type = "executable",
        command = "php",
        args = { "-dxdebug.remote_enable=1", "-dxdebug.remote_autostart=1" },
    }

    dap.set_log_level("DEBUG")
end
