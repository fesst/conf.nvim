-- Add the lua directory to the package path
local path_sep = package.config:sub(1,1) -- Get the path separator for the current OS
local script_dir = debug.getinfo(1, "S").source:match("@?(.*/)")
local lua_dir = script_dir .. ".." .. path_sep .. ".." .. path_sep .. "lua"
package.path = package.path .. ";" .. lua_dir .. path_sep .. "?.lua;" .. lua_dir .. path_sep .. "?" .. path_sep .. "init.lua"

-- Try to require the module with error handling
local status, print_table = pcall(require, "motleyfesst.print_table")
if not status then
    print("Error loading module:", print_table)
    os.exit(1)
end

-- Example nested table
local test_table = {
    name = "John",
    age = 30,
    address = {
        street = "123 Main St",
        city = "New York",
        zip = 10001,
        coordinates = {
            lat = 40.7128,
            long = -74.0060,
        },
    },
    hobbies = { "reading", "coding", "gaming" },
    scores = {
        math = 95,
        science = 88,
        history = 92,
    },
}

-- Print the table with error handling
local success, err = pcall(print_table.print_table, test_table)
if not success then
    print("Error printing table:", err)
    os.exit(1)
end
