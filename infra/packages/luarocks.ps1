$ErrorActionPreference = 'Stop'

# Install Visual Studio Build Tools if not present
if (-not (Get-Command cl.exe -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Visual Studio Build Tools..."
    choco install visualstudio2019buildtools --package-parameters "--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended" -y
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install Visual Studio Build Tools"
    }

    # Refresh environment variables to include VS tools
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# LuaRocks packages
$LUAROCKS_PACKAGES = @(
    "luacheck"      # Required for Lua linting
    "luaformatter"  # Required for Lua formatting
)

# Export variables
$env:LUAROCKS_PACKAGES = $LUAROCKS_PACKAGES

# Install packages
foreach ($package in $LUAROCKS_PACKAGES) {
    Write-Host "Installing $package..."
    try {
        $output = luarocks install $package --verbose 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Failed to install $package, attempting to install without compilation..."
            $output = luarocks install $package --verbose --no-doc 2>&1
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to install $package: $output"
            }
        }
    }
    catch {
        Write-Warning "Failed to install $package: $_"
        continue
    }
}
