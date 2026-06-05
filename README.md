# Claude Skills

A collection of custom slash commands for [Claude Code](https://claude.ai/code).

---

## Skills

| Skill | Command | Description |
|-------|---------|-------------|
| [bible-verses](./bible-verses/) | `/bible-verses` | Get 5 Bible verses related to how you're feeling |

---

## How to Install a Skill

### Step 1 — Find your Claude skills folder

| Platform | Path |
|----------|------|
| Windows | `C:\Users\<you>\.claude\skills\` |
| macOS / Linux | `~/.claude/skills/` |

### Step 2 — Copy the skill folder

Download or clone this repo, then copy the skill folder you want into your skills directory.

**Option A — Copy just one skill (Windows PowerShell):**
```powershell
# Create the skills folder if it doesn't exist
New-Item -ItemType Directory -Force "$env:USERPROFILE\.claude\skills\bible-verses"

# Download the skill file
Invoke-WebRequest `
  -Uri "https://raw.githubusercontent.com/kc4ums/claude-skills/main/bible-verses/SKILL.md" `
  -OutFile "$env:USERPROFILE\.claude\skills\bible-verses\SKILL.md"
```

**Option B — Clone the whole repo (all skills at once):**
```bash
# macOS / Linux
git clone https://github.com/kc4ums/claude-skills.git ~/.claude/skills

# Windows PowerShell
git clone https://github.com/kc4ums/claude-skills.git "$env:USERPROFILE\.claude\skills"
```

### Step 3 — Restart Claude Code

Close and reopen Claude Code (or start a new conversation). The skill will appear automatically.

---

## Usage

### `/bible-verses`

Describe how you're feeling and receive 5 relevant Bible verses with references and explanations.

```
/bible-verses I feel anxious and overwhelmed at work
/bible-verses tired
/bible-verses lonely and forgotten
/bible-verses grateful but unworthy
```

**Example output:**

```
**1. Philippians 4:6-7**
"Do not be anxious about anything, but in every situation, by prayer and petition,
with thanksgiving, present your requests to God..."
*Why it relates:* This verse speaks directly to workplace anxiety...
```

Verses are returned in NIV translation with a short explanation of why each one fits your situation.

---

## Contributing

Have a skill to share? Open a pull request — add a new folder with a `SKILL.md` file following the same format as the existing skills.
