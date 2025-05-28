$ErrorActionPreference = 'Stop'

# LuaRocks packages
$LUAROCKS_PACKAGES = @(
    "luacheck"      # Required for Lua linting
    "luaformatter"  # Required for Lua formatting
)

# Export variables
$env:LUAROCKS_PACKAGES = $LUAROCKS_PACKAGES

# Install packages
foreach ($package in $LUAROCKS_PACKAGES) {
    Write-Output "Installing $package..."
    luarocks install $package
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install $package"
    }
}
