# Claude Code Skill Installer
# Run interactively:  iwr https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1 -OutFile "$env:TEMP\ccinstall.ps1"; & "$env:TEMP\ccinstall.ps1"
# Install directly:   ... & "$env:TEMP\ccinstall.ps1" -Skill osha-wood-mill
# Install all:        ... & "$env:TEMP\ccinstall.ps1" -Skill all

param(
    [string]$Skill = ""
)

$repo      = "https://raw.githubusercontent.com/kc4ums/claude-skills/main"
$skillsDir = "$env:USERPROFILE\.claude\skills"

# Fetch the manifest
try {
    $manifest = Invoke-RestMethod "$repo/skills.json" -ErrorAction Stop
} catch {
    Write-Host "ERROR: Could not fetch skills. Check your internet connection." -ForegroundColor Red
    exit 1
}

function Install-SkillByName($name) {
    $dir = "$skillsDir\$name"
    New-Item -ItemType Directory -Force $dir | Out-Null
    Invoke-WebRequest "$repo/$name/SKILL.md" -OutFile "$dir\SKILL.md" -ErrorAction Stop
}

function Show-Menu {
    Write-Host ""
    Write-Host "Available Claude Code skills:" -ForegroundColor Cyan
    Write-Host ""
    $i = 1
    foreach ($s in $manifest.skills) {
        $tag = if (Test-Path "$skillsDir\$($s.name)\SKILL.md") { " [installed]" } else { "" }
        Write-Host "  $i. /$($s.name)$tag" -ForegroundColor Yellow -NoNewline
        Write-Host " — $($s.description)"
        $i++
    }
    Write-Host "  A. All skills"
    Write-Host ""
}

function Do-Install($names) {
    $ok = 0; $fail = 0
    foreach ($name in $names) {
        Write-Host "  Installing /$name..." -NoNewline
        try {
            Install-SkillByName $name
            Write-Host " done" -ForegroundColor Green
            $ok++
        } catch {
            Write-Host " FAILED" -ForegroundColor Red
            $fail++
        }
    }
    Write-Host ""
    if ($fail -eq 0) {
        Write-Host "Installed $ok skill(s). Start a new Claude Code chat to use them." -ForegroundColor Green
    } else {
        Write-Host "Installed $ok, failed $fail. Check your internet connection." -ForegroundColor Red
    }
    Write-Host ""
}

# ── Direct install (non-interactive) ─────────────────────────────────────────
if ($Skill -eq "all") {
    Show-Menu
    Do-Install ($manifest.skills | ForEach-Object { $_.name })
    exit 0
}

if ($Skill) {
    $match = $manifest.skills | Where-Object { $_.name -eq $Skill }
    if (-not $match) {
        Write-Host "ERROR: Skill '$Skill' not found. Run without -Skill to see available skills." -ForegroundColor Red
        exit 1
    }
    Do-Install @($Skill)
    exit 0
}

# ── Interactive numbered menu (loops until Q) ─────────────────────────────────
Write-Host ""
Write-Host "kc4ums/claude-skills — Skill Installer" -ForegroundColor Cyan

while ($true) {
    Show-Menu
    $choice = Read-Host "Enter a number, A for all, or Q to quit"

    if ($choice -match "^[Qq]$") {
        Write-Host "Bye!" -ForegroundColor Gray
        Write-Host ""
        exit 0
    }

    if ($choice -match "^[Aa]$") {
        Do-Install ($manifest.skills | ForEach-Object { $_.name })
        continue
    }

    $idx = $null
    if ([int]::TryParse($choice, [ref]$idx) -and $idx -ge 1 -and $idx -le $manifest.skills.Count) {
        Do-Install @($manifest.skills[$idx - 1].name)
        continue
    }

    Write-Host "Invalid — enter a number from the list, A for all, or Q to quit." -ForegroundColor DarkOrange
    Write-Host ""
}
