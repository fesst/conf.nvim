local ok, tabby = pcall(require, "tabby")
if not ok then
    return
end

local is_local = require("motleyfesst.ssh_utils").IS_LOCAL()

-- Rose-pine inspired theme for local; muted for SSH
local theme
if is_local then
    theme = {
        fill = { bg = "#1f1d2e" },
        project = { fg = "#191724", bg = "#c4a7e7", style = "bold" },
        current = { fg = "#e0def4", bg = "#393552", style = "bold" },
        tab = { fg = "#908caa", bg = "#26233a" },
        modified = { fg = "#f6c177" },
        close = { fg = "#eb6f92" },
        tail = { fg = "#191724", bg = "#9ccfd8", style = "bold" },
    }
else
    theme = {
        fill = "TabLineFill",
        project = "TabLineSel",
        current = "TabLineSel",
        tab = "TabLine",
        modified = "WarningMsg",
        close = "ErrorMsg",
        tail = "TabLineSel",
    }
end

tabby.setup({
    line = function(line)
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

        local tab_count = vim.fn.tabpagenr("$")
        local cols = vim.o.columns
        -- Reserve space for project label + tail section
        local reserved = #cwd + 12
        local avail = cols - reserved
        -- Budget per tab (number always shown, name shrinks)
        local per_tab = tab_count > 0 and math.floor(avail / tab_count) or avail
        -- Minimum: "1:" + icon + "…" + close ≈ 8
        local max_name = math.max(per_tab - 8, 1)

        local function shorten_name(name, limit)
            if #name <= limit then
                return name
            end
            if limit <= 1 then
                return name:sub(1, 1)
            end
            return name:sub(1, limit - 1) .. "…"
        end

        return {
            -- LEFT: project name
            {
                { "  " .. cwd .. " ", hl = theme.project },
                line.sep("", theme.project, theme.fill),
            },
            -- TABS: number first, name shrinks to fit
            line.tabs().foreach(function(tab)
                local hl = tab.is_current() and theme.current or theme.tab
                local win = tab.current_win()
                local buf_changed = win.buf().is_changed()
                local name = shorten_name(tab.name(), max_name)
                return {
                    line.sep("", hl, theme.fill),
                    tab.number(),
                    ":",
                    win.file_icon(),
                    " ",
                    name,
                    buf_changed and { " ●", hl = theme.modified } or "",
                    " ",
                    tab.close_btn(""),
                    hl = hl,
                    margin = " ",
                }
            end),
            line.spacer(),
            -- FAR RIGHT: tab count
            {
                line.sep("", theme.tail, theme.fill),
                { "  " .. tab_count .. " ", hl = theme.tail },
            },
            hl = theme.fill,
        }
    end,
    option = {
        buf_name = {
            mode = "unique",
        },
    },
})

-- Keymaps: <leader><Tab> prefix for tab management (no conflict with <leader>t* telescope)
vim.keymap.set("n", "<leader><Tab>n", ":$tabnew<CR>", { desc = "New tab", silent = true })
vim.keymap.set("n", "<leader><Tab>c", ":tabclose<CR>", { desc = "Close tab", silent = true })
vim.keymap.set("n", "<leader><Tab>l", ":tabn<CR>", { desc = "Next tab", silent = true })
vim.keymap.set("n", "<leader><Tab>h", ":tabp<CR>", { desc = "Prev tab", silent = true })
vim.keymap.set("n", "<leader><Tab>$", ":tablast<CR>", { desc = "Last tab", silent = true })
vim.keymap.set("n", "<leader><Tab>1", "1gt", { desc = "Tab 1", silent = true })
vim.keymap.set("n", "<leader><Tab>2", "2gt", { desc = "Tab 2", silent = true })
vim.keymap.set("n", "<leader><Tab>3", "3gt", { desc = "Tab 3", silent = true })
vim.keymap.set("n", "<leader><Tab>4", "4gt", { desc = "Tab 4", silent = true })
vim.keymap.set("n", "<leader><Tab>5", "5gt", { desc = "Tab 5", silent = true })
vim.keymap.set("n", "<leader><Tab>r", ":Tabby rename_tab ", { desc = "Rename tab" })
vim.keymap.set("n", "<leader><Tab>j", ":Tabby jump_to_tab<CR>", { desc = "Jump to tab", silent = true })
