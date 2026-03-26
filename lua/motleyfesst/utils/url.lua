local M = {}

local URL_PATTERN = "https?://%S+"
local WWW_PATTERN = "www%.%S+"

local function trim(text)
    return text and text:match("^%s*(.-)%s*$") or nil
end

local function trim_unmatched_trailing_delimiters(url)
    local matching_openers = {
        [")"] = "(",
        ["]"] = "[",
        ["}"] = "{",
        [">"] = "<",
    }

    while url and url ~= "" do
        local trailing = url:sub(-1)
        local opener = matching_openers[trailing]
        if not opener then
            break
        end

        if trailing == ">" then
            url = url:sub(1, -2)
        else
            local opener_count = select(2, url:gsub("%" .. opener, ""))
            local trailing_count = select(2, url:gsub("%" .. trailing, ""))
            if trailing_count <= opener_count then
                break
            end
            url = url:sub(1, -2)
        end
    end

    return url
end

local function normalize(url)
    if not url or url == "" then
        return nil
    end

    url = trim(url)
    url = trim_unmatched_trailing_delimiters(url)

    if url:match("^www%.") then
        return "https://" .. url
    end

    return url
end

function M.extract(text)
    if type(text) ~= "string" or text == "" then
        return nil
    end

    return normalize(text:match(URL_PATTERN) or text:match(WWW_PATTERN))
end

local function selected_text()
    return table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getcurpos(), { type = vim.fn.mode() }), "\n")
end

local function candidates()
    if vim.fn.mode() ~= "n" then
        return { selected_text() }
    end

    return {
        vim.fn.expand("<cfile>"),
        vim.fn.expand("<cWORD>"),
        vim.api.nvim_get_current_line(),
    }
end

function M.open_from_context()
    local url
    for _, candidate in ipairs(candidates()) do
        url = M.extract(candidate)
        if url then
            break
        end
    end

    if not url then
        vim.notify("[url] no URL found in current context", vim.log.levels.WARN)
        return
    end

    vim.ui.open(url)
end

return M
