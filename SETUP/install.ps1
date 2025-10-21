Write-Host "This is the installation script."
Write-Host "It will copy my setup to your powershell profile folder."
Write-Host "After copying, it will install required modules. (e.g. new PSReadLine for oh-my-posh)"
$backupChoice = Read-Host "Do you wish to create a backup of your current profile? (Y/n)" # Default: Y
if ($backupChoice -eq "" -or $backupChoice -match '^[Yy]$') {
    . .\backup.ps1
}

# Delete old profile
Write-Host "Deleting current profile..." -ForegroundColor Red
Remove-Item $PROFILE -ErrorAction SilentlyContinue

# Copy new profile
Write-Host "Copying new profile..." -ForegroundColor Cyan
Copy-Item ..\Microsoft.PowerShell_profile.ps1 $PROFILE
Write-Host "Profile copied to $PROFILE" -ForegroundColor Green

# Copy scripts
Write-Host "Copying scripts..." -ForegroundColor Cyan
# Create script folders
New-Item -ItemType Directory -Path (Join-Path (Split-Path $PROFILE -Parent) "custom_scripts") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path (Split-Path $PROFILE -Parent) "Scripts") -Force | Out-Null

Copy-Item ..\custom_scripts\ -Destination (Split-Path $PROFILE -Parent) -Recurse -Force
Copy-Item ..\Scripts\ -Destination (Split-Path $PROFILE -Parent) -Recurse -Force
Write-Host "Scripts copied." -ForegroundColor Green

# Copy Oh-My-Posh themes
Write-Host "Copying themes..." -ForegroundColor Cyan
Copy-Item ..\themes\* $env:POSH_THEMES_PATH -Recurse -Force
Write-Host "Themes copied." -ForegroundColor Green

# Install requirements
Write-Host "Installing required modules..." -ForegroundColor Cyan
. .\requirements.ps1
Write-Host "Requirements installed." -ForegroundColor Green

Write-Host "Installation complete! Please restart your PowerShell session to apply changes."