$ErrorActionPreference = 'Stop'

# Set up Visual Studio environment
$vsPath = "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools"
if (Test-Path $vsPath) {
    $vsDevCmd = Join-Path $vsPath "Common7\Tools\VsDevCmd.bat"
    if (Test-Path $vsDevCmd) {
        Write-Output "Setting up Visual Studio environment..."
        cmd /c "`"$vsDevCmd`" && set" | ForEach-Object {
            if ($_ -match "^(.*?)=(.*)$") {
                $name = $matches[1]
                $value = $matches[2]
                [System.Environment]::SetEnvironmentVariable($name, $value, [System.EnvironmentVariableTarget]::Process)
            }
        }
    }
}

# Verify Visual Studio environment
$clPath = (Get-Command cl.exe -ErrorAction SilentlyContinue).Source
if ($clPath) {
    Write-Output "Visual Studio environment set up successfully. cl.exe found at: $clPath"
} else {
    Write-Error "Failed to set up Visual Studio environment. cl.exe not found."
    exit 1
}
