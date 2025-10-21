param(
    [switch]$Force
)

# Check if Python is available
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "[!] Python is not installed or not in PATH."
    return
}

# Check if we're in the project root (i.e., .git exists)
$inProjectRoot = Test-Path ".git" -PathType Container

if (-not $inProjectRoot -and -not $Force) {
    Write-Host "You are not in a git project directory"
    Write-Host ""

    do {
        $answer = Read-Host "Do you want to create a virtual environment anyways? [y/N]"
        if ($answer -eq "") { $answer = "N" }  # Default to "No" if empty
    } while ($answer -notmatch '^[YyNn]$')

    if ($answer -match '^[Nn]$') {
        return
    }
}

# Create virtual environment if it doesn't exist
if (Test-Path ".venv" -PathType Container) {
    Write-Host "[s] Virtual environment already exists."
} else {
    Write-Host "[+] Creating virtual environment..."
    try {
        python -m venv .venv
        Write-Host "[s] Virtual environment created."
    } catch {
        Write-Host "[!] Failed to create virtual environment: $_"
        return
    }
}

# Install dependencies if requirements.txt exists
if (Test-Path "requirements.txt" -PathType Leaf) {
    Write-Host "[+] Installing dependencies from requirements.txt..."
    try {
        .\.venv\Scripts\pip.exe install -r requirements.txt
        Write-Host "[s] Dependencies installed."
    } catch {
        Write-Host "[!] Failed to install dependencies: $_"
    }
} else {
    Write-Host "[i] No requirements.txt found. Skipping dependency installation."
}

# Activate the virtual environment
Write-Host "[i] Activating virtual environment..."
. .\.venv\Scripts\Activate.ps1
