try {
    if (-not (Get-InstalledModule -Name 'PSReadLine' -ErrorAction SilentlyContinue) -or
        ((Get-InstalledModule -Name 'PSReadLine' -ErrorAction SilentlyContinue).Version -lt [version]'2.3.6')) {
        Write-Host "Installing PSReadLine 2.3.6..."
        Install-Module -Name 'PSReadLine' -RequiredVersion '2.3.6' -Scope CurrentUser -Force
    } 
    else {
        Write-Host "PSReadLine version 2.3.6 or higher is already installed."
    }
}
catch {
    Write-Host "Something went wrong. " -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    return
}
