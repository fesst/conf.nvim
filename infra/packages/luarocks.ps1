# LuaRocks packages
$LUAROCKS_PACKAGES = @(
    "luacheck"      # Required for Lua linting
)

# Export variables
$env:LUAROCKS_PACKAGES = $LUAROCKS_PACKAGES -join " "
