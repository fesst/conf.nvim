require("motleyfesst.utils")

if is_not_ssh() then
    -- PostgreSQL-specific features
    local keymap = vim.keymap.set

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

    -- Function to get current connection
    local function get_current_connection()
        return current_connection
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

    -- Set up keybindings
    local function setup_keybindings()
        -- Query templates
        keymap("n", "<leader>qt", function()
            local templates = vim.tbl_keys(query_templates)
            vim.ui.select(templates, {
                prompt = "Select query template:",
            }, function(choice)
                if choice then
                    local table_name = vim.fn.input("Enter table name: ")
                    insert_template(choice, table_name)
                end
            end)
        end, { desc = "Insert query template" })

        -- Connection management
        keymap("n", "<leader>qc", function()
            local conns = vim.tbl_keys(connections)
            vim.ui.select(conns, {
                prompt = "Select database connection:",
            }, function(choice)
                if choice then
                    switch_connection(choice)
                end
            end)
        end, { desc = "Switch database connection" })

        -- Format query results
        keymap("n", "<leader>qf", format_query_results, { desc = "Format query results" })

        -- Quick access to common queries
        keymap("n", "<leader>ql", function()
            insert_template("long_running")
        end, { desc = "Show long-running queries" })
        keymap("n", "<leader>qk", function()
            insert_template("locks")
        end, { desc = "Show locks" })
        keymap("n", "<leader>qs", function()
            insert_template("table_stats", vim.fn.expand("<cword>"))
        end, { desc = "Show table stats" })
        keymap("n", "<leader>qi", function()
            insert_template("index_stats", vim.fn.expand("<cword>"))
        end, { desc = "Show index stats" })
    end

    -- Initialize
    setup_keybindings()

    -- Export functions for use in other files
    return {
        switch_connection = switch_connection,
        insert_template = insert_template,
        format_query_results = format_query_results,
    }
end
