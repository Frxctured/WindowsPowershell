# PowerShell Profile Backup Script
# This script backs up your current PowerShell profile to a timestamped folder

$DestProfile = Split-Path -Parent $PROFILE

# Check if profile folder exists
if (-not (Test-Path $DestProfile)) {
    Write-Host "ERROR: PowerShell profile folder not found at $DestProfile" -ForegroundColor Red
    return
}

# Create backup folder with timestamp
$BackupFolderPath = Join-Path $DestProfile "..\WindowsPowerShell_Backup_$(Get-Date -Format yyyyMMdd_HHmmss)"
$BackupFolder = [System.IO.Path]::GetFullPath($BackupFolderPath)

if (-not (Test-Path $BackupFolder)) {
    New-Item -Path $BackupFolder -ItemType Directory | Out-Null
}

Write-Host "Backing up existing profile to $BackupFolder..." -ForegroundColor Yellow
Copy-Item -Path "$DestProfile\*" -Destination $BackupFolder -Recurse -Force -Container

Write-Host "Backup complete! Your profile has been saved to:" -ForegroundColor Green
Write-Host $BackupFolder -ForegroundColor Cyan
