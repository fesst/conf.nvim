$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$testDir = Join-Path $scriptDir 'test_files'
$logFile = if ($env:NVIM_LOG_FILE) { $env:NVIM_LOG_FILE } else { Join-Path $scriptDir 'nvim.log' }

function Write-Status {
    param([string]$Message)
    Write-Host "[+] $Message" -ForegroundColor Green
}

function Write-TestError {
    param([string]$Message)
    Write-Host "[x] $Message" -ForegroundColor Red
}

function Ensure-Venv {
    if ($env:VIRTUAL_ENV) {
        $venvScripts = Join-Path $env:VIRTUAL_ENV 'Scripts'
        if ($env:Path -notlike "*$venvScripts*") {
            $env:Path = "$venvScripts;$env:Path"
        }
        return
    }

    $localVenv = Join-Path $repoRoot '.venv'
    if (-not (Test-Path $localVenv)) {
        throw "No active virtual environment and $localVenv is missing"
    }

    $env:VIRTUAL_ENV = $localVenv
    $env:Path = "$(Join-Path $localVenv 'Scripts');$env:Path"
}

function Run-Headless {
    param(
        [string]$Name,
        [string[]]$Commands
    )

    Write-Status "Running: $Name"
    $args = @('--headless') + $Commands
    $output = & nvim @args 2>&1
    $output | Out-File -FilePath $logFile -Append -Encoding utf8

    if ($LASTEXITCODE -eq 0) {
        Write-Status "Success: $Name"
        return
    }

    throw "Failed: $Name"
}

function New-TestFiles {
    New-Item -ItemType Directory -Path $testDir -Force | Out-Null

    @'
local function add(a, b)
    return a + b
end

print(add(1, 2))
'@ | Out-File -FilePath (Join-Path $testDir 'test.lua') -Encoding utf8

    @'
def add(a: int, b: int) -> int:
    return a + b


print(add(1, 2))
'@ | Out-File -FilePath (Join-Path $testDir 'test.py') -Encoding utf8

    @'
# Test Markdown

This file exists to exercise markdown startup paths.
'@ | Out-File -FilePath (Join-Path $testDir 'test.md') -Encoding utf8
}

function Cleanup {
    if (Test-Path $testDir) {
        Remove-Item -Path $testDir -Recurse -Force
    }
    if (Test-Path $logFile) {
        Remove-Item -Path $logFile -Force
    }
}

New-Item -ItemType Directory -Path (Split-Path -Parent $logFile) -Force | Out-Null
Set-Content -Path $logFile -Value ''

Ensure-Venv
New-TestFiles

try {
    Run-Headless -Name 'Plugin bootstrap' -Commands @('+Lazy! restore', '+qa')
    Run-Headless -Name 'Basic startup' -Commands @("+lua assert(package.loaded['lazy'], 'lazy.nvim did not load')", '+qa')
    Run-Headless -Name 'Plugin availability' -Commands @(
        "+lua assert(pcall(require, 'telescope'), 'telescope missing')",
        "+lua assert(pcall(require, 'nvim-treesitter.configs'), 'treesitter missing')",
        "+lua assert(pcall(require, 'blink.cmp'), 'blink.cmp missing')",
        "+lua assert(pcall(require, 'conform'), 'conform missing')",
        "+lua assert(pcall(require, 'lint'), 'nvim-lint missing')",
        "+lua assert(pcall(require, 'tabby'), 'tabby missing')",
        '+qa'
    )
    Run-Headless -Name 'Commands available' -Commands @(
        "+lua assert(vim.fn.exists(':Telescope') == 2, ':Telescope missing')",
        "+lua assert(vim.fn.exists(':ConformInfo') == 2, ':ConformInfo missing')",
        '+qa'
    )
    Run-Headless -Name 'Lua filetype' -Commands @(
        "+edit $testDir/test.lua",
        "+lua assert(vim.bo.filetype == 'lua', 'expected lua filetype')",
        '+qa'
    )
    Run-Headless -Name 'Python filetype' -Commands @(
        "+edit $testDir/test.py",
        "+lua assert(vim.bo.filetype == 'python', 'expected python filetype')",
        '+qa'
    )
    Run-Headless -Name 'Markdown filetype' -Commands @(
        "+edit $testDir/test.md",
        "+lua assert(vim.bo.filetype == 'markdown', 'expected markdown filetype')",
        '+qa'
    )
    Run-Headless -Name 'Health check' -Commands @('+checkhealth', '+qa')

    Cleanup
    Write-Status 'All sanity tests passed'
    exit 0
}
catch {
    Write-TestError $_
    exit 1
}
