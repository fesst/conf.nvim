$ErrorActionPreference = 'Stop'

# Set up Visual Studio environment
$vsPath = Join-Path $env:USERPROFILE "vs_buildtools"
if (Test-Path $vsPath) {
    $vsDevCmd = Join-Path $vsPath "Common7\Tools\VsDevCmd.bat"
    if (Test-Path $vsDevCmd) {
        Write-Output "Setting up Visual Studio environment..."
        Write-Output "Using Visual Studio path: $vsPath"
        Write-Output "Using VsDevCmd.bat: $vsDevCmd"
        cmd /c "`"$vsDevCmd`" && set" | ForEach-Object {
            if ($_ -match "^(.*?)=(.*)$") {
                $name = $matches[1]
                $value = $matches[2]
                [System.Environment]::SetEnvironmentVariable($name, $value, [System.EnvironmentVariableTarget]::Process)
            }
        }
    } else {
        Write-Error "VsDevCmd.bat not found at: $vsDevCmd"
        Write-Output "Directory contents:"
        Get-ChildItem (Split-Path $vsDevCmd -Parent)
    }
} else {
    Write-Error "Visual Studio Build Tools not found at: $vsPath"
    Write-Output "Checking parent directory..."
    $parentDir = Split-Path $vsPath -Parent
    if (Test-Path $parentDir) {
        Write-Output "Parent directory exists. Contents:"
        Get-ChildItem $parentDir
    } else {
        Write-Output "Parent directory does not exist: $parentDir"
    }
}

# Verify Visual Studio environment
$clPath = (Get-Command cl.exe -ErrorAction SilentlyContinue).Source
if ($clPath) {
    Write-Output "Visual Studio environment set up successfully. cl.exe found at: $clPath"
} else {
    Write-Error "Failed to set up Visual Studio environment. cl.exe not found."
    Write-Output "Current PATH: $env:Path"
    exit 1
}
