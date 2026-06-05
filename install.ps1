# Claude Code Skill Installer
# Usage:
#   List available skills:  irm https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1 -OutFile "$env:TEMP\ccinstall.ps1"; & "$env:TEMP\ccinstall.ps1"
#   Install a skill:        irm https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1 -OutFile "$env:TEMP\ccinstall.ps1"; & "$env:TEMP\ccinstall.ps1" -Skill osha-wood-mill
#   Install all skills:     irm https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1 -OutFile "$env:TEMP\ccinstall.ps1"; & "$env:TEMP\ccinstall.ps1" -Skill all

param(
    [string]$Skill = ""
)

$repo      = "https://raw.githubusercontent.com/kc4ums/claude-skills/main"
$skillsDir = "$env:USERPROFILE\.claude\skills"

# Fetch the manifest
try {
    $manifest = Invoke-RestMethod "$repo/skills.json" -ErrorAction Stop
} catch {
    Write-Host "ERROR: Could not fetch skills manifest. Check your internet connection." -ForegroundColor Red
    exit 1
}

function Install-Skill($skill) {
    $dir = "$skillsDir\$($skill.name)"
    New-Item -ItemType Directory -Force $dir | Out-Null
    try {
        Invoke-WebRequest "$repo/$($skill.name)/SKILL.md" -OutFile "$dir\SKILL.md" -ErrorAction Stop
        Write-Host "  Installed: /$($skill.name) — $($skill.description)" -ForegroundColor Green
    } catch {
        Write-Host "  FAILED:    $($skill.name) — could not download SKILL.md" -ForegroundColor Red
    }
}

# No skill specified — list available skills
if (-not $Skill) {
    Write-Host ""
    Write-Host "Available skills from kc4ums/claude-skills:" -ForegroundColor Cyan
    Write-Host ""
    foreach ($s in $manifest.skills) {
        Write-Host "  /$($s.name)" -ForegroundColor Yellow -NoNewline
        Write-Host " — $($s.description)"
    }
    Write-Host ""
    Write-Host "To install a skill, run:" -ForegroundColor Cyan
    Write-Host '  irm https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1 -OutFile "$env:TEMP\ccinstall.ps1"; & "$env:TEMP\ccinstall.ps1" -Skill <name>'
    Write-Host ""
    exit 0
}

# Install all
if ($Skill -eq "all") {
    Write-Host ""
    Write-Host "Installing all skills to $skillsDir ..." -ForegroundColor Cyan
    foreach ($s in $manifest.skills) {
        Install-Skill $s
    }
    Write-Host ""
    Write-Host "Done. Start a new Claude Code conversation to use your skills." -ForegroundColor Green
    exit 0
}

# Install one specific skill
$match = $manifest.skills | Where-Object { $_.name -eq $Skill }
if (-not $match) {
    Write-Host ""
    Write-Host "ERROR: Skill '$Skill' not found. Run without -Skill to see available skills." -ForegroundColor Red
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "Installing to $skillsDir ..." -ForegroundColor Cyan
Install-Skill $match
Write-Host ""
Write-Host "Done. Start a new Claude Code conversation to use /$($match.name)." -ForegroundColor Green
Write-Host ""
