$tools = @("oh-my-posh")

foreach ($t in $tools) {
    if (-not (Get-Command $t -ErrorAction SilentlyContinue)) {
        Write-Host "$t is not installed or not on PATH! Aborting installation." -ForegroundColor Red
	return
    }
}

# Folder this setup.ps1 lives in (the downloaded repo root)
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceProfile = Join-Path $RepoRoot "WindowsPowerShell"
$DestProfile   = Split-Path -Parent $PROFILE

# Make sure source exists
if (-not (Test-Path $SourceProfile)) {
    Write-Host "ERROR: Could not find WindowsPowerShell folder in repo." -ForegroundColor Red
    return
}

# Backup existing profile if it exists
if (Test-Path $DestProfile) {
    $BackupFolder = "$DestProfile\..\WindowsPowerShell_Backup_$(Get-Date -Format yyyyMMdd_HHmmss)"
    if (-not (Test-Path $BackupFolder)) {
        New-Item -Path $BackupFolder -ItemType Directory | Out-Null
    }
    Write-Host "Backing up existing profile to $BackupFolder..." -ForegroundColor Yellow
    Copy-Item -Path "$DestProfile\*" -Destination $BackupFolder -Recurse -Force -Container
}

# Copy repo WindowsPowerShell folder into user profile
Write-Host "Restoring profile from repo..." -ForegroundColor Cyan
Copy-Item -Path "$SourceProfile\*" -Destination $DestProfile -Recurse -Force -Container

Write-Host "Setup complete! All scripts are now in place." -ForegroundColor Green

do {
        $answer = Read-Host "Install modules/requirements? (Y/N)"
    } while ($answer -notmatch '^[YyNn]$')

    if ($answer -match '^[Nn]$') {
        Write-Host "You can install the requirements by typing '. $DestProfile\requirements.ps1'"
        return
    }
. $DestProfile\requirements.ps1

do {
        $answer = Read-Host "Apply new profile now? (Y/N)"
    } while ($answer -notmatch '^[YyNn]$')

    if ($answer -match '^[Nn]$') {
        Write-Host "You can apply the new profile by either restarting powershell or typing '. `$PROFILE'"
        return
    }
. $PROFILE
