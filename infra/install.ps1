param(
    [switch]$UseChocolatey
)

$ErrorActionPreference = "Stop"

function Test-Command {
    param ($Command)
    try { if (Get-Command $Command) { return $true } }
    catch { return $false }
}

function Install-Chocolatey {
    if (-not (Test-Command choco)) {
        Write-Host "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        $env:Path = "$env:Path;$env:ChocolateyInstall\bin"
    }
}

function Install-WingetPackages {
    $packages = @(
        "Git.Git",
        "LLVM.LLVM",
        "BurntSushi.ripgrep.MSVC",
        "sharkdp.fd",
        "Neovim.Neovim",
        "OpenJS.NodeJS.LTS",
        "Microsoft.Python.3.12"
    )

    foreach ($package in $packages) {
        winget install --id $package --accept-source-agreements --accept-package-agreements --silent
    }
}

function Install-ChocolateyPackages {
    Write-Host "Installing system dependencies using Chocolatey..."
    choco install -y `
        neovim `
        python `
        nodejs `
        git `
        llvm `
        ripgrep `
        fd `
        lua `
        luarocks
}

function Refresh-ProcessPath {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    foreach ($extraPath in @(
        'C:\ProgramData\chocolatey\bin',
        'C:\Program Files\Neovim\bin',
        'C:\tools\neovim\nvim-win64\bin',
        'C:\Program Files (x86)\Lua\5.1'
    )) {
        if ((Test-Path $extraPath) -and ($env:Path -notlike "*$extraPath*")) {
            $env:Path = "$extraPath;$env:Path"
        }
    }
}

function Ensure-Rust {
    if (-not (Test-Command rustup)) {
        Invoke-WebRequest -Uri https://win.rustup.rs -OutFile rustup-init.exe
        .\rustup-init.exe -y
        Remove-Item rustup-init.exe
    }

    $cargoBin = Join-Path $env:USERPROFILE '.cargo\bin'
    if ($env:Path -notlike "*$cargoBin*") {
        $env:Path = "$cargoBin;$env:Path"
    }

    rustup default stable
}

function Ensure-Venv {
    $venvPath = if ($env:VIRTUAL_ENV) { $env:VIRTUAL_ENV } else { Join-Path (Get-Location) '.venv' }
    if (-not (Test-Path $venvPath)) {
        python -m venv $venvPath
    }

    $env:VIRTUAL_ENV = $venvPath
    $env:Path = "$(Join-Path $venvPath 'Scripts');$env:Path"
}

try {
    Write-Host "Starting Neovim configuration installation..."

    if ($UseChocolatey -or $env:CI -eq 'true' -or -not (Test-Command winget)) {
        Install-Chocolatey
        Install-ChocolateyPackages
    } else {
        Install-WingetPackages
    }

    Refresh-ProcessPath
    Ensure-Venv

    & "$PSScriptRoot\packages\pip.ps1"
    & "$PSScriptRoot\packages\npm.ps1"
    Ensure-Rust
    & "$PSScriptRoot\packages\cargo.ps1"
    & "$PSScriptRoot\packages\luarocks.ps1"
    & "$PSScriptRoot\packages\nvim.ps1"

    Write-Host "Installation completed successfully!"
} catch {
    Write-Error "An error occurred during installation: $_"
    exit 1
}
