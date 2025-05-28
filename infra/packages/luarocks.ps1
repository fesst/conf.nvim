$ErrorActionPreference = 'Stop'

# Function to check if a package is installed
function Test-LuaRocksPackage {
    param($PackageName)
    $package = luarocks list --porcelain | Select-String "^$PackageName\s"
    return $package -ne $null
}

# Install LuaRocks if not already installed
if (-not (Get-Command luarocks -ErrorAction SilentlyContinue)) {
    Write-Host "Installing LuaRocks..."
    choco install luarocks -y
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install LuaRocks"
    }
    refreshenv
}

# Verify LuaRocks installation
if (-not (Get-Command luarocks -ErrorAction SilentlyContinue)) {
    throw "LuaRocks not found in PATH after installation"
}

# Install required LuaRocks packages
$packages = @(
    @{Name = "luacheck"; Installed = $false}
    @{Name = "luaformatter"; Installed = $false}
)

foreach ($package in $packages) {
    if (-not (Test-LuaRocksPackage $package.Name)) {
        Write-Host "Installing $($package.Name)..."
        try {
            luarocks install $package.Name
            if ($LASTEXITCODE -ne 0) {
                Write-Warning "Failed to install $($package.Name), attempting to install without compilation..."
                luarocks install $package.Name --no-deps
                if ($LASTEXITCODE -ne 0) {
                    throw "Failed to install $($package.Name)"
                }
            }
        } catch {
            Write-Warning "Failed to install $($package.Name): $_"
            # Continue with other packages even if one fails
            continue
        }
    } else {
        Write-Host "$($package.Name) is already installed"
    }
}

# Verify installations
foreach ($package in $packages) {
    if (-not (Test-LuaRocksPackage $package.Name)) {
        Write-Warning "$($package.Name) installation verification failed"
    }
}

Write-Host "LuaRocks packages installation completed"
