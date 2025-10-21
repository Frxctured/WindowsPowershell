# PowerShell Profile Configuration

A customized PowerShell profile with Oh My Posh theming and custom scripts.

## ✨ Features

- 🎨 **Custom Oh My Posh Theme** - Beautiful theme (by me) with pink/purple/lilac colors
- 🔧 **Custom Scripts** - Useful automation and navigation scripts
- 📦 **Custom Profile** - Automatically loads custom functions/scripts into your PowerShell session


## 📋 Prerequisites

- [Oh My Posh](https://ohmyposh.dev/) - Install with `winget install JanDeDobbeleer.OhMyPosh`
- PowerShell 5.1 or later

## 🚀 Installation

1. **Clone this repository**
   ```powershell
   git clone https://github.com/Frxctured/WindowsPowershell.git
   cd WindowsPowershell
   ```

2. **Unblock all scripts** so they can run normally
   ```powershell
   Get-ChildItem -Path . -Recurse -Filter *.ps1 | Unblock-File
   ```

3. **Run the installation script**
   ```powershell
   cd .\SETUP
   .\install.ps1
   ```

4. **Follow the prompts** to install modules and apply the profile

## 📁 Structure

```
WindowsPowerShell/
├── Microsoft.PowerShell_profile.ps1   # Main profile script
├── custom_scripts/                    # Custom utility scripts that automatically load
│   ├── cdx.ps1
│   ├── cdxh.ps1
│   └── Push-All.ps1
├── themes/                            # Oh My Posh themes
│   └── Frxctured.omp.json
├── Scripts/                           # Additional installed scripts
└── SETUP/                             # Setup utilities
    ├── backup.ps1                     # Backup script
    ├── install.ps1                    # Main installation script
    └── requirements.ps1               # Module/requirement installer
```

## 🛠️ Usage

### 💾 Backup Your Profile

> **Note:** This already happens automatically in `install.ps1`, but you can run it manually if needed.

Create a timestamped backup of your current profile:
```powershell
.\backup.ps1
```

### 🚫 Exclude Files from Loading

Prefix scripts with `!` (can be customized) to prevent them from loading automatically.

### ⚙️ Set Custom Variables

You can customize variables in `Microsoft.PowerShell_profile.ps1` to fit your needs:

![Variables in Microsoft.PowerShell_profile.ps1](/docs/media/Settings.png)

### 📜 Custom Scripts

- **cdx.ps1** - Custom navigation commands
- **cdxh.ps1** - Navigation history
- **Push-All.ps1** - Git helper for pushing to all remotes

## 🎨 Theme

### A pretty clean theme with purple/pink pastel aesthetic ✨

![Theme Preview](/docs/media/ThemePreview.png)

**Features:**
- ⏱️ Execution time with colors based on success/failure
- 🐍 Python environment display
- 📊 Git branch display
- 🕐 Current time display
- 🖥️ Current shell display


## 📝 License

See [LICENSE](LICENSE) file for details.
