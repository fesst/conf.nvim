-- Set leader key
vim.g.mapleader = " "

-- Bracket-related mappings
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Smart text object detection and selection
local function smart_select_text_object()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- Convert to 1-indexed

    -- Patterns to detect different text objects
    local patterns = {
        -- Environment variables ${...}
        { pattern = "%$%{[^}]*%}", name = "env_var" },
        -- Quoted strings "..." or '...'
        { pattern = '"[^"]*"', name = "double_quote" },
        { pattern = "'[^']*'", name = "single_quote" },
        -- Parentheses (...)
        { pattern = "%([^)]*%)", name = "parentheses" },
        -- Square brackets [...]
        { pattern = "%[[^%]]*%]", name = "square_brackets" },
        -- Curly braces {...}
        { pattern = "%{[^}]*%}", name = "curly_braces" },
        -- Angle brackets <...>
        { pattern = "%<[^>]*%>", name = "angle_brackets" },
        -- Backticks `...`
        { pattern = "`[^`]*`", name = "backticks" },
        -- File paths (simplified: word chars, dots, slashes, hyphens)
        { pattern = "[%w%./_%-]+", name = "path" },
    }

    -- Find the pattern that contains the cursor position
    for _, p in ipairs(patterns) do
        local start_pos = 1
        while true do
            local s, e = line:find(p.pattern, start_pos)
            if not s then break end

            -- Check if cursor is within this match
            if col >= s and col <= e then
                -- Set visual selection by positioning start and end
                local row = vim.api.nvim_win_get_cursor(0)[1]
                -- Set visual selection start
                vim.fn.setpos("'<", {0, row, s, 0})
                -- Set visual selection end
                vim.fn.setpos("'>", {0, row, e, 0})
                -- Enter visual mode to activate the selection
                vim.cmd('normal! gv')
                return true
            end
            start_pos = e + 1
        end
    end

    -- Fallback to word selection if no pattern matches
    vim.cmd('normal! viw')
    return false
end

-- Smart bracket deletion function
local function smart_delete_brackets(open_char, close_char)
    return function()
        -- Simple deletion: find opening bracket, delete it, find closing bracket, delete it
        vim.cmd('normal! F' .. open_char .. 'xf' .. close_char .. 'x')
        vim.notify('Deleted brackets: ' .. open_char .. close_char, vim.log.levels.INFO)
    end
end

-- Smart bracket change function
local function smart_change_brackets(old_open, old_close, new_open, new_close)
    return function()
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]

        -- Check if cursor is on or after the opening bracket
        local open_pos = line:find(old_open, 1, true)
        local close_pos = line:find(old_close, 1, true)

        if open_pos and close_pos then
            if col >= open_pos then
                -- Cursor is on or after opening bracket, search right
                vim.cmd('normal! f' .. old_close .. 'Fx')
            else
                -- Cursor is before opening bracket, search left
                vim.cmd('normal! F' .. old_open .. 'xf' .. old_close .. 'x')
            end
            -- Insert new brackets
            vim.cmd('normal! i' .. new_open .. new_close .. '<Esc>P')
        end
    end
end

-- Smart surround function for normal mode
local function smart_surround(open_char, close_char)
    return function()
        smart_select_text_object()
        vim.cmd('normal! x')
        vim.cmd('normal! i' .. open_char .. close_char .. '<Esc>P')
    end
end

-- Surround with brackets (visual mode)
map("v", "<leader>b(", "xi()<Esc>P")
map("v", "<leader>b[", "xi[]<Esc>P")
map("v", "<leader>b{", "xi{}<Esc>P")
map("v", "<leader>b<", "xi<><Esc>P")
map("v", "<leader>b'", "xi''<Esc>P")
map("v", '<leader>b"', 'xi""<Esc>P')
map("v", "<leader>b`", "xi``<Esc>P")

-- Smart surround with brackets (normal mode)
map("n", "<leader>b(", smart_surround("(", ")"))
map("n", "<leader>b[", smart_surround("[", "]"))
map("n", "<leader>b{", smart_surround("{", "}"))
map("n", "<leader>b<", smart_surround("<", ">"))
map("n", "<leader>b'", smart_surround("'", "'"))
map("n", '<leader>b"', smart_surround('"', '"'))
map("n", "<leader>b`", smart_surround("`", "`"))

-- Delete surrounding brackets (smart logic)
map("n", "<leader>B(", smart_delete_brackets("(", ")"))
map("n", "<leader>B[", smart_delete_brackets("[", "]"))
map("n", "<leader>B{", smart_delete_brackets("{", "}"))
map("n", "<leader>B<", smart_delete_brackets("<", ">"))
map("n", "<leader>B'", smart_delete_brackets("'", "'"))
map("n", '<leader>B"', smart_delete_brackets('"', '"'))
map("n", "<leader>B`", smart_delete_brackets("`", "`"))

-- Change surrounding brackets (smart logic)
map("n", "<leader>bc(", smart_change_brackets("(", ")", "(", ")"))
map("n", "<leader>bc[", smart_change_brackets("[", "]", "[", "]"))
map("n", "<leader>bc{", smart_change_brackets("{", "}", "{", "}"))
map("n", "<leader>bc<", smart_change_brackets("<", ">", "<", ">"))
map("n", "<leader>bc'", smart_change_brackets("'", "'", "'", "'"))
map("n", '<leader>bc"', smart_change_brackets('"', '"', '"', '"'))
map("n", "<leader>bc`", smart_change_brackets("`", "`", "`", "`"))

-- Add brackets at the end of line
map("n", "<leader>ba(", "A()<Esc>i")
map("n", "<leader>ba[", "A[]<Esc>i")
map("n", "<leader>ba{", "A{}<Esc>i")
map("n", "<leader>ba<", "A<><Esc>i")

-- Add brackets at the start of line (simplified)
map("n", "<leader>bi(", "I()<Esc>")
map("n", "<leader>bi[", "I[]<Esc>")
map("n", "<leader>bi{", "I{}<Esc>")
map("n", "<leader>bi<", "I<><Esc>")
map("n", "<leader>bi'", "I''<Esc>")
map("n", '<leader>bi"', 'I""<Esc>')
map("n", "<leader>bi`", "I``<Esc>")
