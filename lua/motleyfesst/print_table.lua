local M = {}

-- Helper function to check if a value is a table
local function is_table(t)
    return type(t) == "table"
end

-- Function to print a table with proper indentation
function M.print_table(t, indent)
    indent = indent or 0
    local spaces = string.rep("  ", indent)

    for k, v in pairs(t) do
        if is_table(v) then
            print(spaces .. tostring(k) .. " = {")
            M.print_table(v, indent + 1)
            print(spaces .. "}")
        else
            print(spaces .. tostring(k) .. " = " .. tostring(v))
        end
    end
end

return M
