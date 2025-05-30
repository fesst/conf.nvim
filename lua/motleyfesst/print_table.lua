local M = {}

-- Helper function to check if a value is a table
local function is_table(t)
    return type(t) == "table"
end

-- Helper function to check if a table is empty
local function is_empty(t)
    return next(t) == nil
end

-- Helper function to get the type of a value
local function get_type(v)
    if is_table(v) then
        return "table"
    end
    return type(v)
end

-- Function to print a table with proper indentation
function M.print_table(t, indent)
    indent = indent or 0
    local indent_str = string.rep("  ", indent)

    if not is_table(t) then
        print(indent_str .. tostring(t))
        return
    end

    if is_empty(t) then
        print(indent_str .. "{}")
        return
    end

    print(indent_str .. "{")
    for k, v in pairs(t) do
        local key_str = type(k) == "string" and k or "[" .. tostring(k) .. "]"
        if is_table(v) then
            print(indent_str .. "  " .. key_str .. " =")
            M.print_table(v, indent + 2)
        else
            local value_str = type(v) == "string" and '"' .. v .. '"' or tostring(v)
            print(indent_str .. "  " .. key_str .. " = " .. value_str)
        end
    end
    print(indent_str .. "}")
end

return M
