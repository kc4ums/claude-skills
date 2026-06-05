# Claude Code Skill Installer
# Usage:
#   List available skills:   irm https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1 | iex
#   Install a skill:         $env:SKILL="osha-wood-mill"; irm https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1 | iex
#   Install all skills:      $env:SKILL="all"; irm https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1 | iex

$repo     = "https://raw.githubusercontent.com/kc4ums/claude-skills/main"
$skillsDir = "$env:USERPROFILE\.claude\skills"
$target   = $env:SKILL

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

# No target — list available skills and their install commands
if (-not $target) {
    Write-Host ""
    Write-Host "Available skills from kc4ums/claude-skills:" -ForegroundColor Cyan
    Write-Host ""
    foreach ($skill in $manifest.skills) {
        Write-Host "  /$($skill.name)" -ForegroundColor Yellow -NoNewline
        Write-Host " — $($skill.description)"
    }
    Write-Host ""
    Write-Host "Install one skill:" -ForegroundColor Cyan
    Write-Host '  $env:SKILL="<name>"; irm https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1 | iex'
    Write-Host ""
    Write-Host "Install all skills:" -ForegroundColor Cyan
    Write-Host '  $env:SKILL="all"; irm https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1 | iex'
    Write-Host ""
    exit 0
}

# Install all
if ($target -eq "all") {
    Write-Host ""
    Write-Host "Installing all skills to $skillsDir ..." -ForegroundColor Cyan
    foreach ($skill in $manifest.skills) {
        Install-Skill $skill
    }
    Write-Host ""
    Write-Host "Done. Start a new Claude Code conversation to use your skills." -ForegroundColor Green
    exit 0
}

# Install one specific skill
$skill = $manifest.skills | Where-Object { $_.name -eq $target }
if (-not $skill) {
    Write-Host ""
    Write-Host "ERROR: Skill '$target' not found." -ForegroundColor Red
    Write-Host "Run without " -NoNewline
    Write-Host '$env:SKILL' -ForegroundColor Yellow -NoNewline
    Write-Host " set to see available skills."
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "Installing skill to $skillsDir ..." -ForegroundColor Cyan
Install-Skill $skill
Write-Host ""
Write-Host "Done. Start a new Claude Code conversation to use /$($skill.name)." -ForegroundColor Green
Write-Host ""

# Clean up the env var so it doesn't linger in the session
Remove-Item Env:\SKILL -ErrorAction SilentlyContinue
