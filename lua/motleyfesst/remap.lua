vim.g.mapleader = " "

local options = { noremap = true, silent = true }
local function map(mode, lhs, rhs, opts)
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

map({'n', 'v'}, "<leader>T", function()
    vim.cmd("botright " .. math.floor(vim.o.lines / 4) .. "split")
    vim.cmd("terminal")
    vim.cmd("startinsert")
end, {})

map("n", "<leader>R", ":source %<CR>")
map("n", "<leader>w", ":write %<CR>")
map("n", "<leader>m", ":messages<CR>")

map("n", "<leader>*", ":nohlsearch<CR>")

map("v", "<leader>b(", "c()<Esc>P")
map("v", "<leader>b[", "c[]<Esc>P")
map("v", "<leader>b{", "c{}<Esc>P")
map("v", "<leader>b<", "c<><Esc>P")
map("v", "<leader>b'", "c''<Esc>P")
map("v", '<leader>b"', 'c""<Esc>P')
map("v", "<leader>b`", "c``<Esc>P")

map("n", "<leader>ba(", "A()<Esc>")
map("n", "<leader>ba[", "A[]<Esc>")
map("n", "<leader>ba{", "A{}<Esc>")
map("n", "<leader>ba<", "A<><Esc>")

map("n", "<leader>bi(", "I()<Esc>")
map("n", "<leader>bi[", "I[]<Esc>")
map("n", "<leader>bi{", "I{}<Esc>")
map("n", "<leader>bi<", "I<><Esc>")
map("n", "<leader>bi'", "I''<Esc>")
map("n", '<leader>bi"', 'I""<Esc>')
map("n", "<leader>bi`", "I``<Esc>")

local function smart_delete_brackets(open_char, close_char)
    return function()
        -- Correct deletion: find opening bracket, delete it, find closing bracket, delete it
        vim.cmd("normal! F" .. open_char .. "x" .. "f" .. close_char .. "x")
    end
end

map("n", "<leader>B(", smart_delete_brackets("(", ")"))
map("n", "<leader>B[", smart_delete_brackets("[", "]"))
map("n", "<leader>B{", smart_delete_brackets("{", "}"))
map("n", "<leader>B<", smart_delete_brackets("<", ">"))
map("n", "<leader>B'", smart_delete_brackets("'", "'"))
map("n", '<leader>B"', smart_delete_brackets('"', '"'))
map("n", "<leader>B`", smart_delete_brackets("`", "`"))

function smart_select_text_object(open_bracket)
    local line = vim.api.nvim_get_current_line()
    local col = vim.fn.col(".") -- 1-based
    local row = vim.fn.line(".") -- current line

    local brackets = {
        ["("] = ")",
        ["["] = "]",
        ["{"] = "}",
        ["<"] = ">",
    }

    local close_bracket = brackets[open_bracket]
    if not close_bracket then
        return false
    end

    -- Паттерн вида "\(....\)"
    local pattern = "%" .. open_bracket .. "[^" .. open_bracket .. close_bracket .. "]-%" .. close_bracket

    local start_pos = 1
    while true do
        local s, e = line:find(pattern, start_pos)
        if not s then
            break
        end
        if col >= s and col <= e then
            -- сохранить в визуальный регистр
            vim.fn.setpos("'<", { 0, row, s, 0 })
            vim.fn.setpos("'>", { 0, row, e, 0 })
            vim.cmd("normal! gv")
            return true
        end
        start_pos = e + 1
    end

    return false
end

local bracket_pairs = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
    ["<"] = ">",
    ['"'] = '"',
    ["'"] = "'",
    ["`"] = "`",
}

local function wrap_under_cursor(open)
    local close = bracket_pairs[open]
    if not close then
        return nil
    end

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()

    local left, right = nil, nil
    for i = col, 1, -1 do
        if line:sub(i, i) == open then
            left = i
            break
        end
    end
    for i = col + 1, #line do
        if line:sub(i, i) == close then
            right = i
            break
        end
    end

    if left and right and left < right then
        local before = line:sub(1, left)
        local middle = line:sub(left + 1, right - 1)
        local after = line:sub(right)
        local new_line = before .. open .. middle .. close .. after
        vim.api.nvim_set_current_line(new_line)
        vim.api.nvim_win_set_cursor(0, { row, left + 1 })
    else
        local word = vim.fn.expand("<cword>")
        local s = line:find(word, 1, true)
        if not s then
            return
        end
        local e = s + #word
        local new_line = line:sub(1, s - 1) .. open .. word .. close .. line:sub(e)
        vim.api.nvim_set_current_line(new_line)
        vim.api.nvim_win_set_cursor(0, { row, s + 1 })
    end
end

for symbol, _ in pairs(bracket_pairs) do
    vim.keymap.set("n", "<leader>b" .. symbol, function()
        return wrap_under_cursor(symbol)
    end, { noremap = true, silent = true })
end
