# Define your custom paths here
$Global:cdxPaths = @{
    # Example shortcuts
    "doc" = "$HOME\Documents"
    "dl"  = "$HOME\Downloads"
    "desk" = "$HOME\Desktop"
    "pics" = "$HOME\Pictures"
    "music" = "$HOME\Music"
    "vids" = "$HOME\Videos"
}

$ScriptVersion = "1.1"
Write-Output "$ScriptVersion" > $null # Dummy output to set version variable and ignore errors
function cdx {
<#
.SYNOPSIS
    Enhanced cd command for quick directory navigation

.DESCRIPTION
    cdx lets you navigate directories faster with:
    - Shortcut paths (like 'docs', 'dl')
    - Command-based directory jumping
    - Interactive history selection
    - Directory stack management

.PARAMETER Path
    Target directory or shortcut name

.PARAMETER History
    Show interactive directory history menu

.PARAMETER ClearHistory
    Clear all saved directory stack history

.EXAMPLE
    cdx docs
    # Goes to Documents folder

.EXAMPLE
    cdx -History
    # Shows directory history selection

.EXAMPLE
    cdx -ClearHistory
    # Clears directory stack

.NOTES
    Author: Ajan Zuberi
    Version: 1.1
#>
    
    param(
        [Parameter(ValueFromPipeline=$true)]
        [string]$Path,
        [switch]$History,
        [switch]$ClearHistory
    )

    process {
        # --------------------------
        # Clear directory history
        # --------------------------
        if ($ClearHistory) {
            while ((Get-Location -Stack).Count -gt 1) { Pop-Location | Out-Null }
            Write-Host "Directory history cleared."
            return
        }

        # --------------------------
        # Show history selection menu
        # --------------------------
        if ($History) {
            cdxh
            return
        }

        # --------------------------
        # Default behavior: go home if no path specified
        # --------------------------
        if (-not $Path) {
            Set-Location $HOME
            return
        }

        # --------------------------
        # Step 1: literal path
        # --------------------------
        if (Test-Path $Path -PathType Container) {
            Push-Location $Path
            return
        }

        # --------------------------
        # Step 2: full shortcut match
        # --------------------------
        if ($Global:cdxPaths.ContainsKey($Path)) {
            Push-Location $Global:cdxPaths[$Path]
            return
        }

        # --------------------------
        # Step 3: first-segment shortcut expansion
        # --------------------------
        $segments = $Path -split '[\\/]', 2
        $first = $segments[0]
        $rest  = if ($segments.Count -gt 1) { $segments[1] } else { "" }

        if ($Global:cdxPaths.ContainsKey($first)) {
            $expandedPath = if ($rest) { Join-Path $Global:cdxPaths[$first] $rest } else { $Global:cdxPaths[$first] }
            if (Test-Path $expandedPath -PathType Container) {
                Push-Location $expandedPath
                return
            } else {
                Write-Host "Path not found: $expandedPath" -ForegroundColor Yellow
                return
            }
        }

        # --------------------------
        # Step 4: command/script fallback
        # --------------------------
        $cmd = Get-Command $Path -ErrorAction SilentlyContinue
        if ($cmd -and $cmd.Source) {
            Push-Location (Split-Path $cmd.Source)
            return
        }

        # --------------------------
        # Step 5: final fallback
        # --------------------------
        Push-Location $Path
    }
}

# Register autocomplete for cdx
Register-ArgumentCompleter -CommandName cdx -ParameterName Path -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBound)

    # Split input into shortcut and remainder
    $segments = $wordToComplete -split '[\\/]', 2
    $first = $segments[0]
    $rest  = if ($segments.Count -gt 1) { $segments[1] } else { "" }

    # If only partial shortcut is typed, suggest matching shortcut keys
    if ($segments.Count -eq 1 -and $Global:cdxPaths.Keys -match "$wordToComplete") {
        $Global:cdxPaths.Keys | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
    $shortcut = $_
    $quoted = if ($shortcut -match '\s') { "`"$shortcut\`"" } else { "$shortcut\" }

    [System.Management.Automation.CompletionResult]::new(
        $quoted,
        $quoted,
        'ParameterValue',
        "Shortcut to $shortcut"
    )
}
        return
    }

    # Expand shortcut if valid
    if ($Global:cdxPaths.ContainsKey($first)) {
        $expandedPath = if ($rest) { Join-Path $Global:cdxPaths[$first] $rest } else { $Global:cdxPaths[$first] }
    } else {
        $expandedPath = $wordToComplete
    }

    # Suggest directories under expanded path
    Get-ChildItem -Directory -Path "$expandedPath*" -ErrorAction SilentlyContinue | ForEach-Object {
        $quoted = if ($_.FullName -match '\s') { "`"$($_.FullName)\`"" } else { "$($_.FullName)\" }
        [System.Management.Automation.CompletionResult]::new(
            $quoted,
            $quoted,
            'ParameterValue',
            $_.FullName
        )
    }
}