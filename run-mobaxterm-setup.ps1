# run-mobaxterm-setup.ps1
# irm https://raw.githubusercontent.com/Don-Paterson/MobaXterm-Setup/main/run-mobaxterm-setup.ps1 | iex

$ErrorActionPreference = 'Stop'
Write-Host "=== MobaXterm Setup ===" -ForegroundColor Cyan

# Install MobaXterm
Write-Host "Installing MobaXterm..." -ForegroundColor Yellow
winget install Mobatek.MobaXterm --silent --accept-source-agreements --accept-package-agreements --source winget
if ($LASTEXITCODE -notin @(0, -1978335189)) {
    Write-Warning "winget exited with code $LASTEXITCODE"
}

# Launch MobaXterm briefly to generate MobaXterm.ini
Write-Host "Waiting for MobaXterm to initialise..." -ForegroundColor Yellow
$iniDir   = "$env:APPDATA\MobaXterm"
$iniPath  = "$iniDir\MobaXterm.ini"
$mobaPath = 'C:\Program Files (x86)\Mobatek\MobaXterm\MobaXterm.exe'

if ((Test-Path $mobaPath) -and -not (Test-Path $iniPath)) {
    Start-Process $mobaPath
    $timeout = 15
    while (-not (Test-Path $iniPath) -and $timeout -gt 0) {
        Start-Sleep 1; $timeout--
    }
    Stop-Process -Name MobaXterm -ErrorAction SilentlyContinue
    Start-Sleep 1
}

# Fetch and inject sessions
Write-Host "Importing sessions..." -ForegroundColor Yellow
$sessionsUrl = "https://raw.githubusercontent.com/Don-Paterson/MobaXterm-Setup/main/MobaXterm-Sessions.mxtsessions"
$sessions = Invoke-RestMethod -Uri $sessionsUrl

if (Test-Path $iniPath) {
    $ini = Get-Content $iniPath -Raw
    $ini = ($ini -replace '(?s)\r?\n\[Bookmarks[^\]]*\].*', '').TrimEnd()
    $ini += "`r`n`r`n$sessions"
    Set-Content $iniPath $ini -NoNewline
} else {
    Set-Content $iniPath $sessions
}

Write-Host "Sessions imported successfully" -ForegroundColor Green
Write-Host "=== Done ===" -ForegroundColor Cyan
