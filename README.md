# Claude Skills

Extra slash commands you can add to [Claude Code](https://claude.ai/code).

---

## What's available

| Command | What it does |
|---------|-------------|
| `/bible-verses` | Type how you're feeling — get 5 relevant Bible verses |
| `/osha-wood-mill` | Get a current OSHA regulatory briefing for wood mill safety |

---

## How to install

> **You need Claude Code** — the desktop app or CLI, not regular Claude chat at claude.ai. [Download Claude Code here.](https://claude.ai/code)

### Option A — GUI app (easiest)

Paste this into a Claude Code chat and press Enter — a small installer window will pop up:

```
! $f="$env:TEMP\ccgui.ps1"; irm https://raw.githubusercontent.com/kc4ums/claude-skills/main/installer-gui.ps1 -OutFile $f; Start-Process powershell "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$f`""
```

Check the skills you want and click **Install Selected** or **Install All**. Already-installed skills are labeled **[installed]**. No dependencies — uses built-in Windows tools only.

### Option B — Numbered menu

Paste this into a Claude Code chat and press Enter:

```
! irm https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1 -OutFile "$env:TEMP\ccinstall.ps1"; & "$env:TEMP\ccinstall.ps1"
```

It will show a numbered list of available skills. Type a number and press Enter to install that skill, or type **A** to install all of them. Then start a new Claude Code chat — the skill is ready to use.

---

## Using a skill

Once installed, just type the slash command in any Claude Code chat:

```
/osha-wood-mill
/bible-verses I feel overwhelmed
```

