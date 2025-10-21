Write-Host "This is the installation script."
Write-Host "It will copy my setup to your powershell profile folder."
Write-Host "After copying, it will install required modules. (e.g. new PSReadLine for oh-my-posh)"
$backupChoice = Read-Host "Do you wish to create a backup of your current profile? (Y/n)" # Default: Y
if ($backupChoice -eq "" -or $backupChoice -match '^[Yy]$') {
    . .\backup.ps1
}

# Delete old profile
Write-Host "Deleting current profile..."
Remove-Item $PROFILE -ErrorAction SilentlyContinue

# Copy new profile
Write-Host "Copying new profile..."
Copy-Item .\Microsoft.PowerShell_profile.ps1 $PROFILE
Write-Host "Profile copied to $PROFILE"

# Install requirements
Write-Host "Installing required modules..."
. .\requirements.ps1
Write-Host "Requirements installed."

# Copy scripts
Write-Host "Copying scripts..."
Copy-Item .\custom_scripts\* (Split-Path $PROFILE -Parent)\custom_scripts -Recurse -Force
Copy-Item .\Scripts\* (Split-Path $PROFILE -Parent)\Scripts -Recurse -Force
Write-Host "Scripts copied."

# Copy Oh-My-Posh themes
Copy-Item .\themes\* $env:POSH_THEMES_PATH -Recurse -Force

Write-Host "Installation complete! Please restart your PowerShell session to apply changes."