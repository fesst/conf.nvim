# PowerShell script for Neovim sanity tests

$ErrorActionPreference = 'Stop'

# Add Neovim to PATH if not already present
$nvimPaths = @(
    "C:\Program Files\Neovim\bin",
    "C:\tools\neovim\nvim-win64\bin"
)

foreach ($path in $nvimPaths) {
    if (Test-Path $path) {
        if ($env:Path -notlike "*$path*") {
            $env:Path = "$path;$env:Path"
        }
        break
    }
}

# Test directory and log file setup
$TEST_DIR = "infra/test_files"
$LOG_FILE = if ($env:NVIM_LOG_FILE) { $env:NVIM_LOG_FILE } else { "infra/nvim.log" }
$VENV_DIR = ".venv"

# Function to print status messages
function Write-Status {
    param($Message)
    Write-Host "[+] $Message" -ForegroundColor Green
}

function Write-Error {
    param($Message)
    Write-Host "[x] $Message" -ForegroundColor Red
}

# Function to ensure virtual environment is activated
function Ensure-Venv {
    if ($env:VIRTUAL_ENV) {
        Write-Status "Using existing virtual environment: $env:VIRTUAL_ENV"

        # Add virtual environment to PATH if not already there
        $venvScriptsPath = Join-Path $env:VIRTUAL_ENV "Scripts"
        if ($env:PATH -notlike "*$venvScriptsPath*") {
            $env:PATH = "$venvScriptsPath;$env:PATH"
        }

        # Verify Python is available
        if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
            Write-Error "Python not found in PATH after virtual environment activation"
            exit 1
        }

        Write-Status "Python version: $(python --version)"
        Write-Status "Python path: $(Get-Command python | Select-Object -ExpandProperty Source)"
    }
    else {
        Write-Error "VIRTUAL_ENV environment variable not set"
        exit 1
    }
}

# Function to run nvim command with logging
function Run-Nvim {
    param(
        [string]$Command,
        [string]$TestName
    )

    Write-Status "Running: $TestName"
    $output = nvim --headless -c $Command -c 'quit' 2>> $LOG_FILE
    if ($LASTEXITCODE -eq 0) {
        Write-Status "Success: $TestName"
        return $true
    }
    else {
        Write-Error "Failed: $TestName"
        Add-Content -Path $LOG_FILE -Value "Command: $Command"
        return $false
    }
}

# Function to run lua command with logging
function Run-Lua {
    param(
        [string]$Command,
        [string]$TestName
    )

    Write-Status "Running: $TestName"
    $output = nvim --headless -c "lua $Command" -c 'quit' 2>> $LOG_FILE
    if ($LASTEXITCODE -eq 0) {
        Write-Status "Success: $TestName"
        return $true
    }
    else {
        Write-Error "Failed: $TestName"
        Add-Content -Path $LOG_FILE -Value "Lua Command: $Command"
        return $false
    }
}

# Create test files
function Create-TestFiles {
    Write-Status "Creating test files..."
    New-Item -ItemType Directory -Force -Path $TEST_DIR | Out-Null

    # Create test.lua
    @'
local function test()
    print("Test function")
end
test()
'@ | Out-File -FilePath "$TEST_DIR/test.lua" -Encoding utf8

    # Create test.md
    @'
# Test Markdown
This is a test markdown file.
'@ | Out-File -FilePath "$TEST_DIR/test.md" -Encoding utf8

    # Create test.py
    @'
def test():
    print("Test function")

if __name__ == "__main__":
    test()
'@ | Out-File -FilePath "$TEST_DIR/test.py" -Encoding utf8
}

# Test functions
function Test-BasicFunctionality {
    Write-Status "Testing basic functionality..."

    if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) {
        Write-Error "Neovim is not installed"
        exit 1
    }

    if (-not (Run-Nvim 'quit' "Basic startup/exit")) { exit 1 }
    if (-not (Run-Nvim "e $TEST_DIR/test.lua" "Lua file test")) { exit 1 }
    if (-not (Run-Nvim "e $TEST_DIR/test.md" "Markdown file test")) { exit 1 }
    if (-not (Run-Nvim "e $TEST_DIR/test.py" "Python file test")) { exit 1 }
}

function Test-HealthCheck {
    Write-Status "Running health check..."
    New-Item -ItemType Directory -Force -Path $TEST_DIR | Out-Null

    $output = nvim --headless -c 'checkhealth' -c 'quit' 2>&1
    if ($LASTEXITCODE -eq 0) {
        $output | Out-File -FilePath "$TEST_DIR/checkhealth.log"
        Write-Status "checkhealth completed successfully"
    }
    else {
        Write-Error "checkhealth failed"
        exit 1
    }
}

function Test-CorePlugins {
    Write-Status "Testing core plugin loading..."

    if (-not (Run-Lua 'if not package.loaded["lazy"] then error("Lazy not loaded") end' "Lazy plugin test")) { exit 1 }
    if (-not (Run-Lua 'if not package.loaded["nvim-treesitter"] then error("Treesitter not loaded") end' "Treesitter plugin test")) { exit 1 }
    if (-not (Run-Nvim "e $TEST_DIR/test.py" "LSP config test")) { exit 1 }
    if (-not (Run-Lua 'if not package.loaded["nvim-lspconfig"] then error("LSP config not loaded") end' "LSP config plugin test")) { exit 1 }
    if (-not (Run-Lua 'if not package.loaded["mason"] then error("Mason not loaded") end' "Mason plugin test")) { exit 1 }
    if (-not (Run-Lua 'if not package.loaded["telescope"] then error("Telescope not loaded") end' "Telescope plugin test")) { exit 1 }
}

function Test-Harpoon {
    Write-Status "Testing Harpoon functionality..."
    if (-not (Run-Lua 'if not package.loaded["harpoon"] then error("Harpoon not loaded") end' "Harpoon loading test")) { exit 1 }
    if (-not (Run-Lua 'if not require("harpoon.mark").add_file then error("Harpoon mark functionality not available") end' "Harpoon mark functionality test")) { exit 1 }
}

function Test-Postgres {
    Write-Status "Testing PostgreSQL functionality..."
    if (-not (Run-Lua 'if not package.loaded["sqlls"] then error("SQL LSP not loaded") end' "SQL LSP loading test")) { exit 1 }
    if (-not (Run-Lua 'if not require("lspconfig").sqlls then error("SQL LSP config not available") end' "SQL LSP config test")) { exit 1 }
}

function Test-TextFileHandling {
    Write-Status "Testing text file handling..."
    # Create a test text file
    "This is a test text file" | Out-File -FilePath "$TEST_DIR/test.txt" -Encoding utf8

    Write-Status "Testing text file handling..."
    $output = nvim --headless -c "e $TEST_DIR/test.txt" -c 'lua local clients = vim.lsp.get_clients(); if clients then for _, client in ipairs(clients) do if client.name == "null-ls" then error("null-ls should not be attached to text files") end end end' -c 'quit'
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Text file handling test failed"
        exit 1
    }

    Write-Status "Testing markdown file handling..."
    "# Test Markdown" | Out-File -FilePath "$TEST_DIR/test.md" -Encoding utf8
    $output = nvim --headless -c "e $TEST_DIR/test.md" -c 'lua local clients = vim.lsp.get_clients(); if clients then for _, client in ipairs(clients) do if client.name == "null-ls" then error("null-ls should not be attached to markdown files") end end end' -c 'quit'
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Markdown file handling test failed"
        exit 1
    }

    Write-Status "Verifying text file handling..."
    $output = nvim --headless -c "e $TEST_DIR/test.txt" -c 'lua local clients = vim.lsp.get_clients(); if clients then for _, client in ipairs(clients) do if client.name == "null-ls" then error("null-ls should not be attached to text files") end end end' -c 'quit'
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Text file handling verification failed"
        exit 1
    }
}

function Cleanup {
    Write-Status "Cleaning up test files..."
    if (Test-Path $TEST_DIR) {
        Remove-Item -Path $TEST_DIR -Recurse -Force
    }
    if (Test-Path $LOG_FILE) {
        Remove-Item -Path $LOG_FILE -Force
    }
}

# Main test execution
Write-Status "Running Neovim sanity tests..."

# Initialize log file
New-Item -ItemType Directory -Force -Path (Split-Path $LOG_FILE -Parent) | Out-Null
"=== Neovim Test Log $(Get-Date) ===" | Out-File -FilePath $LOG_FILE -Encoding utf8

# Ensure virtual environment is activated
Ensure-Venv

Create-TestFiles
Test-BasicFunctionality
Test-HealthCheck
Test-CorePlugins
Test-Harpoon
Test-Postgres
Test-TextFileHandling
Cleanup

Write-Status "All sanity tests passed successfully!"
