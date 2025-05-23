-- luacheck: globals vim
-- luacheck: globals require
-- luacheck: globals pcall
-- luacheck: globals pairs
-- luacheck: globals ipairs
-- luacheck: globals next
-- luacheck: globals type
-- luacheck: globals string
-- luacheck: globals table
-- luacheck: globals math
-- luacheck: globals tonumber
-- luacheck: globals tostring
-- luacheck: globals print
-- luacheck: globals select
-- luacheck: globals assert
-- luacheck: globals error
-- luacheck: globals pcall
-- luacheck: globals xpcall
-- luacheck: globals load
-- luacheck: globals loadfile
-- luacheck: globals dofile
-- luacheck: globals collectgarbage
-- luacheck: globals coroutine
-- luacheck: globals debug
-- luacheck: globals io
-- luacheck: globals os
-- luacheck: globals package
-- luacheck: globals bit
-- luacheck: globals jit

-- Ignore unused variables in certain contexts
ignore = {
    "211", -- Unused variable
    "212", -- Unused argument
    "213", -- Unused loop variable
}

-- Maximum line length
max_line_length = 120

-- Allow unused variables in certain contexts
allow_defined = true
allow_defined_top = true

-- Check for global variables
globals = {
    -- Neovim specific globals
    "vim",
    "require",
    "pcall",
    "pairs",
    "ipairs",
    "next",
    "type",
    "string",
    "table",
    "math",
    "tonumber",
    "tostring",
    "print",
    "select",
    "assert",
    "error",
    "pcall",
    "xpcall",
    "load",
    "loadfile",
    "dofile",
    "collectgarbage",
    "coroutine",
    "debug",
    "io",
    "os",
    "package",
    "bit",
    "jit"
} 