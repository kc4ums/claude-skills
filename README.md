# Claude Skills

Add-on slash commands for [Claude Code](https://claude.ai/code) — by kc4ums.

## Install

**Visit the website and click the download button:**

### [kc4ums.github.io/claude-skills](https://kc4ums.github.io/claude-skills)

No GitHub account required. The site walks you through every step.

---

## Available Skills

| Command | What it does |
|---------|-------------|
| `/bible-verses` | Describe how you are feeling — get 5 relevant Bible verses with explanations |
| `/osha-wood-mill` | Live OSHA regulatory briefing for wood mill and sawmill safety officers |

---

## Using a skill

Once installed, type the slash command in any Claude Code chat:

```
/osha-wood-mill
/bible-verses I feel overwhelmed at work
```

---

## For developers

### Adding a new skill

1. Create a folder with the skill name (e.g. `my-skill/`)
2. Add a `SKILL.md` file inside it following the same format as the existing skills
3. Add an entry to `skills.json`
4. Run `gh release upload v1.0 install.bat --clobber` if `install.bat` changed

### Install via command line (Claude Code)

```
! iwr https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1 -OutFile "$env:TEMP\ccinstall.ps1"; powershell -ExecutionPolicy Bypass -File "$env:TEMP\ccinstall.ps1"
```
