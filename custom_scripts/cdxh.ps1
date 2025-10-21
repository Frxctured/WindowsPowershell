$ScriptVersion = "1.0"
Write-Output "$ScriptVersion" > $null # Dummy output to set version variable and ignore errors
function cdxh {
<#
.SYNOPSIS
    Basically a shorthand for cdx -History

.DESCRIPTION
    cdxh lets you view your path history and switch to a previous directory using your path stack

.NOTES
    Author: Ajan Zuberi
    Version: 1.0
#>
    param(
        # Directory stack to display (defaults to unique paths from current stack)
        [string[]]$Stack = (Get-Location -Stack | ForEach-Object { $_.Path } | Select-Object -Unique)
    )

    Write-Host "Select a directory from history:"

    # Display each directory in stack with number
    for ($i = 0; $i -lt $Stack.Count; $i++) {
        Write-Host "$($i + 1)) $($Stack[$i])"
    }

    # Prompt user until a valid selection is made
    $selection = $null
    while ($null -eq $selection) {
        $UserInput = Read-Host "Enter number of directory"
        if ($UserInput -match '^\d+$') {
            $num = [int]$UserInput
            if ($num -ge 1 -and $num -le $Stack.Count) {
                $selection = $Stack[$num - 1]
            } else {
                Write-Host "Invalid number, try again."
            }
        } else {
            Write-Host "Not a number, try again."
        }
    }

    # Change directory to selected path and confirm
    Push-Location $selection
    Write-Host "Changed directory to $selection"
}
