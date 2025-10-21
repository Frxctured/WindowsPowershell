### Oh-My-Posh Prompt

$theme = "Frxctured"

if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Host "oh-my-posh is not installed or not on PATH! skipping custom prompt" -ForegroundColor Red
} else {
    $themePath = Join-Path $SCRIPTPATH "..\themes\$theme.omp.json"
    oh-my-posh init pwsh --config $themePath | Invoke-Expression
    Write-Host "oh-my-posh loaded with theme: $theme" -ForegroundColor DarkGray
}