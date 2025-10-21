### Load Custom Scripts/Commands ###

## "Settings"
$OhMyPoshTheme = "Frxctured"        # Theme for oh-my-posh prompt
$ScriptFolder = "custom_scripts"    # Folder containing custom scripts. This will be loaded into PowerShell
$SkipPrefix = "!"                   # Files starting with this prefix will be skipped


# Do not change below this line
$SCRIPTPATH = Join-Path (Split-Path $PROFILE -Parent) $ScriptFolder
$LogPath = "$SCRIPTPATH\!$ScriptFolder.log"

Write-Host "Loading custom scripts from: " -NoNewline -ForegroundColor Yellow
Write-Host "`"$SCRIPTPATH`"" -ForegroundColor Blue
if (Test-Path $SCRIPTPATH) {
    $total = (Get-ChildItem -Path $SCRIPTPATH -Filter *.ps1).Count
    $success = 0
    $skip = (Get-ChildItem -Path $SCRIPTPATH -Filter *.ps1) | Where-Object { $_.Name -like '!*' } | Measure-Object | Select-Object -ExpandProperty Count
    $fail = 0
    $failedScripts = @()
    Get-ChildItem -Path $SCRIPTPATH -Filter *.ps1 | Where-Object { $_.Name -notlike "$SkipPrefix*" } | ForEach-Object {
        # Write-Host "Loading $($_.BaseName)..." -ForegroundColor Cyan
        $scriptBaseName = $_.BaseName
        try {
            . $_.FullName -ErrorAction Stop
            if (Test-Path variable:\ScriptVersion) {
                $version = $ScriptVersion
                Write-Host "Loaded $scriptBaseName (v$version)" -ForegroundColor Cyan
                Remove-Variable ScriptVersion -ErrorAction SilentlyContinue
            }
            else {
                Write-Host "Loaded $scriptBaseName (no version info)" -ForegroundColor Cyan
            }
            # log to file
            Add-Content -Path "$LogPath" -Value "[$(Get-Date)] Success: $scriptBaseName loaded successfully."

            $success++
        }
        catch {
            $failedScripts += $scriptBaseName
            $errorMessage = $_.Exception.Message
            Write-Host "Failed to load $scriptBaseName" -ForegroundColor Red

            # log to file
            Add-Content -Path "$LogPath" -Value "[$(Get-Date)] ERROR: $scriptBaseName failed:`n$errorMessage"
            $fail++
        }
    }
    if ($fail -eq 0) {
        Write-Host "All scripts loaded successfully! Skipped $skip." -ForegroundColor Green
    }
    else {
        Write-Host "Loaded $success out of $total script(s). $fail script(s) failed. Skipped $skip."
        if ($fail -gt 0) {
            Write-Host "Failed scripts:"
            $failedScriptsString = $failedScripts -join ", "
            Write-Host $failedScriptsString -ForegroundColor Red
            Write-Host "Logs are available in: `"$LogPath`"." -ForegroundColor Red
            Write-Host "Press any key to continue..."
            [System.Console]::ReadKey($true) | Out-Null
        }
    }
} else {
    Write-Host "Path does not exist." -ForegroundColor Red
    Write-Host "Skipping script loading."
    Write-Host "Press any key to continue..."
    [System.Console]::ReadKey($true) | Out-Null
}


### Oh-My-Posh Prompt
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Host "oh-my-posh is not installed or not on PATH! skipping custom prompt" -ForegroundColor Red
} else {
    $themePath = Join-Path $env:POSH_THEMES_PATH "$OhMyPoshTheme.omp.json"
    oh-my-posh init pwsh --config $themePath | Invoke-Expression
    Write-Host "oh-my-posh loaded with theme: $OhMyPoshTheme" -ForegroundColor DarkGray
}

Clear-Host