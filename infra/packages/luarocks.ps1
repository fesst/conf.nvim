$ErrorActionPreference = 'Stop'

$chocoBin = 'C:\ProgramData\chocolatey\bin'
if ($env:Path -notlike "*$chocoBin*") {
    $env:Path = "$chocoBin;$env:Path"
}

$luaPath = 'C:\Program Files (x86)\Lua\5.1'
if ((Test-Path $luaPath) -and ($env:Path -notlike "*$luaPath*")) {
    $env:Path = "$luaPath;$env:Path"
}

function Test-LuaRocksPackage {
    param($PackageName)
    $package = luarocks list --porcelain | Select-String "^$PackageName\s"
    return $package -ne $null
}

if (-not (Get-Command luarocks -ErrorAction SilentlyContinue)) {
    Write-Host "Installing LuaRocks..."
    choco install luarocks -y
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install LuaRocks"
    }
    refreshenv
}

if (-not (Get-Command luarocks -ErrorAction SilentlyContinue)) {
    throw "LuaRocks not found in PATH after installation"
}

$packages = @(
    @{Name = "luacheck"; Installed = $false}
)

foreach ($package in $packages) {
    if (-not (Test-LuaRocksPackage $package.Name)) {
        Write-Host "Installing $($package.Name)..."
        try {
            luarocks install $package.Name
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to install $($package.Name)"
            }
        } catch {
            Write-Warning "Failed to install $($package.Name): $_"
            continue
        }
    } else {
        Write-Host "$($package.Name) is already installed"
    }
}

foreach ($package in $packages) {
    if (-not (Test-LuaRocksPackage $package.Name)) {
        Write-Warning "$($package.Name) installation verification failed"
    }
}

Write-Host "LuaRocks packages installation completed"
