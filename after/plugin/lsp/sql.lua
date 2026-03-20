local ssh_utils = require("motleyfesst.utils.ssh")

if ssh_utils.IS_LOCAL() then
    -- PostgreSQL-specific features
    local keymap = vim.keymap.set
    local sql_group = vim.api.nvim_create_augroup("SqlSpecificConfig", { clear = true })

    local function setup_tabs(tab_size, expand_tab)
        vim.opt_local.tabstop = tab_size
        vim.opt_local.shiftwidth = tab_size
        vim.opt_local.softtabstop = tab_size
        vim.opt_local.expandtab = expand_tab
    end

    -- Query templates
    local query_templates = {
        explain = [[
        EXPLAIN ANALYZE
        SELECT *
        FROM %s
        WHERE 1=1
        LIMIT 100;
        ]],
        create_table = [[
        CREATE TABLE %s (
            id SERIAL PRIMARY KEY,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        ]],
        create_index = [[
        CREATE INDEX idx_%s_%s ON %s (%s);
        ]],
        vacuum_analyze = [[
        VACUUM ANALYZE %s;
        ]],
        table_stats = [[
        SELECT
        schemaname,
        relname,
        n_live_tup,
        n_dead_tup,
        last_vacuum,
        last_autovacuum,
        last_analyze,
        last_autoanalyze
        FROM pg_stat_user_tables
        WHERE relname = '%s';
        ]],
        index_stats = [[
        SELECT
        schemaname,
        relname,
        indexrelname,
        idx_scan,
        idx_tup_read,
        idx_tup_fetch
        FROM pg_stat_user_indexes
        WHERE relname = '%s';
        ]],
        long_running = [[
        SELECT
        pid,
        age(clock_timestamp(), query_start),
        usename,
        query
        FROM pg_stat_activity
        WHERE state != 'idle'
        AND query NOT ILIKE '%pg_stat_activity%'
        ORDER BY query_start desc;
        ]],
        locks = [[
        SELECT
        blocked_locks.pid AS blocked_pid,
        blocked_activity.usename AS blocked_user,
        blocking_locks.pid AS blocking_pid,
        blocking_activity.usename AS blocking_user,
        blocked_activity.query AS blocked_statement,
        blocking_activity.query AS blocking_statement
        FROM pg_catalog.pg_locks blocked_locks
        JOIN pg_catalog.pg_stat_activity blocked_activity ON blocked_activity.pid = blocked_locks.pid
        JOIN pg_catalog.pg_locks blocking_locks
        ON blocking_locks.locktype = blocked_locks.locktype
        AND blocking_locks.DATABASE IS NOT DISTINCT FROM blocked_locks.DATABASE
        AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
        AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
        AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
        AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
        AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
        AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
        AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
        AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
        AND blocking_locks.pid != blocked_locks.pid
        JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
        WHERE NOT blocked_locks.GRANTED;
        ]],
    }

    -- Connection management
    local connections = {
        dev = {
            name = "Development",
            host = "localhost",
            port = 5432,
            database = "dev_db",
            user = "dev_user",
        },
        test = {
            name = "Test",
            host = "localhost",
            port = 5432,
            database = "test_db",
            user = "test_user",
        },
        prod = {
            name = "Production",
            host = "prod.example.com",
            port = 5432,
            database = "prod_db",
            user = "prod_user",
        },
    }

    -- Current connection
    local current_connection = "dev"

    -- Function to switch connections
    local function switch_connection(conn_name)
        if connections[conn_name] then
            current_connection = conn_name
            vim.notify(
                "Switched to " .. connections[conn_name].name .. " database (" .. current_connection .. ")",
                vim.log.levels.INFO
            )
        else
            vim.notify("Connection " .. conn_name .. " not found", vim.log.levels.ERROR)
        end
    end

    -- Function to insert query template
    local function insert_template(template_name, ...)
        local template = query_templates[template_name]
        if template then
            local query = string.format(template, ...)
            vim.api.nvim_put({ query }, "c", true, true)
        else
            vim.notify("Template " .. template_name .. " not found", vim.log.levels.ERROR)
        end
    end

    -- Function to format query results
    local function format_query_results()
        -- Get the current buffer content
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local formatted_lines = {}

        for _, line in ipairs(lines) do
            -- Replace multiple spaces with a single space
            line = line:gsub("%s+", " ")
            -- Add line to formatted lines
            table.insert(formatted_lines, line)
        end

        -- Replace buffer content with formatted lines
        vim.api.nvim_buf_set_lines(0, 0, -1, false, formatted_lines)
    end

    vim.api.nvim_create_autocmd("FileType", {
        group = sql_group,
        pattern = "sql",
        callback = function(ev)
            setup_tabs(4, true)
            vim.opt_local.syntax = "sql"
            vim.opt_local.commentstring = "-- %s"
            vim.opt_local.formatoptions:append("c")
            vim.opt_local.formatoptions:append("r")
            vim.opt_local.formatoptions:append("o")
            vim.opt_local.formatoptions:append("q")
            vim.opt_local.formatoptions:append("n")
            vim.opt_local.formatoptions:append("j")
            vim.opt_local.textwidth = 100

            local function get_visual_selection()
                local start_pos = vim.fn.getpos("'<")
                local end_pos = vim.fn.getpos("'>")
                if start_pos[2] == 0 or end_pos[2] == 0 then
                    return nil
                end

                local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
                if #lines == 0 then
                    return nil
                end
                lines[1] = lines[1]:sub(start_pos[3], -1)
                lines[#lines] = lines[#lines]:sub(1, end_pos[3])

                return table.concat(lines, " "):gsub("%s+", " ")
            end

            local function run_psql(query)
                if not query or query == "" then
                    vim.notify("No SQL query to execute", vim.log.levels.WARN)
                    return
                end
                vim.cmd("silent !psql -c " .. vim.fn.shellescape(query))
            end

            local opts = { buffer = ev.buf, silent = true }
            keymap("n", "<leader>sc", function()
                local conns = vim.tbl_keys(connections)
                vim.ui.select(conns, {
                    prompt = "Select database connection:",
                }, function(choice)
                    if choice then
                        switch_connection(choice)
                    end
                end)
            end, vim.tbl_extend("force", opts, { desc = "Switch database connection" }))
            keymap("n", "<leader>sT", function()
                local templates = vim.tbl_keys(query_templates)
                vim.ui.select(templates, {
                    prompt = "Select query template:",
                }, function(choice)
                    if choice then
                        local table_name = vim.fn.input("Enter table name: ")
                        insert_template(choice, table_name)
                    end
                end)
            end, vim.tbl_extend("force", opts, { desc = "Insert query template" }))
            keymap("n", "<leader>sF", format_query_results, vim.tbl_extend("force", opts, { desc = "Compact SQL text" }))
            keymap("n", "<leader>sf", ":!pg_format -i %<CR>", vim.tbl_extend("force", opts, { desc = "Format SQL file" }))
            keymap("v", "<leader>se", function()
                local query = get_visual_selection()
                if not query then
                    vim.notify("No selected SQL for EXPLAIN ANALYZE", vim.log.levels.WARN)
                    return
                end
                run_psql("EXPLAIN ANALYZE " .. query)
            end, vim.tbl_extend("force", opts, { desc = "Explain selected query" }))
            keymap("v", "<leader>sr", function()
                run_psql(get_visual_selection())
            end, vim.tbl_extend("force", opts, { desc = "Run selected query" }))
            keymap("n", "<leader>st", function()
                run_psql("\\d " .. vim.fn.expand("<cword>"))
            end, vim.tbl_extend("force", opts, { desc = "Show table structure" }))
            keymap("n", "<leader>sd", function()
                run_psql("\\l+")
            end, vim.tbl_extend("force", opts, { desc = "Show database sizes" }))
            keymap("n", "<leader>ss", function()
                run_psql("\\dt+")
            end, vim.tbl_extend("force", opts, { desc = "Show table sizes" }))
            keymap("n", "<leader>si", function()
                run_psql("SELECT * FROM pg_stat_user_indexes")
            end, vim.tbl_extend("force", opts, { desc = "Show index usage" }))
            keymap("n", "<leader>sl", function()
                run_psql("SELECT * FROM pg_stat_activity WHERE state = 'active'")
            end, vim.tbl_extend("force", opts, { desc = "Show long-running queries" }))
            keymap("n", "<leader>sk", function()
                run_psql("SELECT * FROM pg_locks")
            end, vim.tbl_extend("force", opts, { desc = "Show locks" }))
            keymap("n", "<leader>sv", function()
                run_psql("SELECT * FROM pg_stat_user_tables")
            end, vim.tbl_extend("force", opts, { desc = "Show vacuum status" }))
        end,
    })

    -- Export functions for use in other files
    return {
        switch_connection = switch_connection,
        insert_template = insert_template,
        format_query_results = format_query_results,
    }
end
