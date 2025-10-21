function Push-All {
<#
.SYNOPSIS
    Push to all remotes of a git repository.

.DESCRIPTION
    Runs git push for every remote with the current branch by default

.PARAMETER Branch
    Target branch

.PARAMETER Remotes
    Remotes to push to. Defaults to all remotes if not set.
    Seperate remotes using a comma e.g. "remote1, remote2"


.NOTES
    Author: Ajan Zuberi
    Version: 1.0
#>
    param(
        [string]$Branch = $(git rev-parse --abbrev-ref HEAD),
        [string[]]$Remotes = $(git remote)
    )

    foreach ($remote in $Remotes) {
        Write-Host "Pushing branch '$Branch' to remote '$remote'..."
        git push $remote $Branch
    }
}

Set-Alias pushall Push-All
