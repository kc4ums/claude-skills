Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$repo      = "https://raw.githubusercontent.com/kc4ums/claude-skills/main"
$skillsDir = "$env:USERPROFILE\.claude\skills"

# ── Form ──────────────────────────────────────────────────────────────────────
$form                  = New-Object System.Windows.Forms.Form
$form.Text             = "Claude Skills Installer"
$form.Size             = New-Object System.Drawing.Size(520, 440)
$form.StartPosition    = "CenterScreen"
$form.FormBorderStyle  = "FixedDialog"
$form.MaximizeBox      = $false
$form.Font             = New-Object System.Drawing.Font("Segoe UI", 9)
$form.BackColor        = [System.Drawing.Color]::White

# ── Header ────────────────────────────────────────────────────────────────────
$header          = New-Object System.Windows.Forms.Label
$header.Text     = "Claude Skills Installer"
$header.Location = New-Object System.Drawing.Point(15, 12)
$header.Size     = New-Object System.Drawing.Size(480, 22)
$header.Font     = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($header)

$sub          = New-Object System.Windows.Forms.Label
$sub.Text     = "Check the skills you want, then click Install."
$sub.Location = New-Object System.Drawing.Point(15, 36)
$sub.Size     = New-Object System.Drawing.Size(480, 16)
$sub.ForeColor = [System.Drawing.Color]::Gray
$form.Controls.Add($sub)

# ── Skill list (CheckedListBox) ───────────────────────────────────────────────
$list                = New-Object System.Windows.Forms.CheckedListBox
$list.Location       = New-Object System.Drawing.Point(15, 60)
$list.Size           = New-Object System.Drawing.Size(480, 280)
$list.CheckOnClick   = $true
$list.BorderStyle    = "FixedSingle"
$list.IntegralHeight = $false
$form.Controls.Add($list)

# ── Status bar ────────────────────────────────────────────────────────────────
$status          = New-Object System.Windows.Forms.Label
$status.Text     = "Fetching skills from GitHub..."
$status.Location = New-Object System.Drawing.Point(15, 350)
$status.Size     = New-Object System.Drawing.Size(480, 18)
$status.ForeColor = [System.Drawing.Color]::Gray
$form.Controls.Add($status)

# ── Buttons ───────────────────────────────────────────────────────────────────
$btnInstall          = New-Object System.Windows.Forms.Button
$btnInstall.Text     = "Install Selected"
$btnInstall.Location = New-Object System.Drawing.Point(15, 375)
$btnInstall.Size     = New-Object System.Drawing.Size(140, 32)
$btnInstall.Enabled  = $false
$btnInstall.BackColor = [System.Drawing.Color]::FromArgb(30, 130, 230)
$btnInstall.ForeColor = [System.Drawing.Color]::White
$btnInstall.FlatStyle = "Flat"
$btnInstall.FlatAppearance.BorderSize = 0
$form.Controls.Add($btnInstall)

$btnAll          = New-Object System.Windows.Forms.Button
$btnAll.Text     = "Install All"
$btnAll.Location = New-Object System.Drawing.Point(165, 375)
$btnAll.Size     = New-Object System.Drawing.Size(110, 32)
$btnAll.Enabled  = $false
$btnAll.FlatStyle = "Flat"
$form.Controls.Add($btnAll)

$btnRefresh          = New-Object System.Windows.Forms.Button
$btnRefresh.Text     = "Refresh List"
$btnRefresh.Location = New-Object System.Drawing.Point(370, 375)
$btnRefresh.Size     = New-Object System.Drawing.Size(125, 32)
$btnRefresh.FlatStyle = "Flat"
$form.Controls.Add($btnRefresh)

# ── Skill name map (display string → folder name) ─────────────────────────────
$skillMap = @{}

function Set-Status($msg, $color = "Gray") {
    $status.Text      = $msg
    $status.ForeColor = [System.Drawing.Color]::$color
    $form.Refresh()
}

function Load-Skills {
    $list.Items.Clear()
    $skillMap.Clear()
    $btnInstall.Enabled = $false
    $btnAll.Enabled     = $false
    Set-Status "Fetching skills from GitHub..."
    try {
        $manifest = Invoke-RestMethod "$repo/skills.json" -ErrorAction Stop
        foreach ($skill in $manifest.skills) {
            $installed = Test-Path "$skillsDir\$($skill.name)\SKILL.md"
            $tag       = if ($installed) { "  [installed]" } else { "" }
            $display   = "/$($skill.name)$tag  —  $($skill.description)"
            $skillMap[$display] = $skill.name
            $list.Items.Add($display, $false) | Out-Null
        }
        $btnInstall.Enabled = $true
        $btnAll.Enabled     = $true
        Set-Status "$($manifest.skills.Count) skill(s) found. Items marked [installed] are already set up."
    } catch {
        Set-Status "Could not load skills — check your internet connection." "Red"
    }
}

function Do-Install($names) {
    $ok = 0; $fail = 0
    foreach ($name in $names) {
        Set-Status "Installing $name..."
        try {
            $dir = "$skillsDir\$name"
            New-Item -ItemType Directory -Force $dir | Out-Null
            Invoke-WebRequest "$repo/$name/SKILL.md" -OutFile "$dir\SKILL.md" -ErrorAction Stop
            $ok++
        } catch { $fail++ }
    }
    if ($fail -eq 0) {
        Set-Status "Done! Installed $ok skill(s). Start a new Claude Code chat to use them." "DarkGreen"
    } else {
        Set-Status "Installed $ok, failed $fail. Check your internet connection." "Red"
    }
    Load-Skills
}

$btnInstall.Add_Click({
    $selected = @($list.CheckedItems | ForEach-Object { $skillMap[$_] })
    if ($selected.Count -eq 0) { Set-Status "Check at least one skill first." "DarkOrange"; return }
    Do-Install $selected
})

$btnAll.Add_Click({
    $all = @($list.Items | ForEach-Object { $skillMap[$_] })
    Do-Install $all
})

$btnRefresh.Add_Click({ Load-Skills })

$form.Add_Shown({ Load-Skills })

[System.Windows.Forms.Application]::Run($form)
