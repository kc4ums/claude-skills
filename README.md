# Claude Skills

A collection of custom slash commands for [Claude Code](https://claude.ai/code).

---

## Skills

| Skill | Command | Description |
|-------|---------|-------------|
| [bible-verses](./bible-verses/) | `/bible-verses` | Get 5 Bible verses related to how you're feeling |
| [osha-wood-mill](./osha-wood-mill/) | `/osha-wood-mill` | OSHA regulatory briefing for wood mill / sawmill safety officers |

---

## How to Install a Skill

> **Requires Claude Code** — these commands use the `!` prefix to run PowerShell in your terminal. They will not work in regular Claude chat at claude.ai. [Get Claude Code here.](https://claude.ai/code)

Paste any of the commands below directly into a **Claude Code** chat window.

### See what's available

Type this into a Claude Code chat (the `!` tells Claude Code to run it in your terminal):

```
! irm https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1 | iex
```

### Install one skill

```
! $env:SKILL="osha-wood-mill"; irm https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1 | iex
```

Replace `osha-wood-mill` with any skill name from the table above.

### Install all skills at once

```
! $env:SKILL="all"; irm https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1 | iex
```

### After installing

Start a new Claude Code conversation — that's it. Claude Code automatically scans the skills folder on startup, no configuration needed.

> **Note:** Skills only need to be installed once and are available in every future conversation automatically.

### Manual install (if you prefer)

Skills are plain markdown files. Copy any `SKILL.md` into `%USERPROFILE%\.claude\skills\<skill-name>\` on Windows or `~/.claude/skills/<skill-name>/` on macOS/Linux.

---

## Usage

### `/bible-verses`

Describe how you're feeling and receive 5 relevant Bible verses with references and explanations.

```
/bible-verses I feel anxious and overwhelmed at work
/bible-verses tired and burned out
/bible-verses grateful but unworthy
```

### `/osha-wood-mill`

Get a live-searched regulatory briefing covering OSHA rule changes, enforcement alerts, and safety updates relevant to wood mill and sawmill operations. Optionally specify a timeframe.

```
/osha-wood-mill
/osha-wood-mill past 6 months
/osha-wood-mill 2024
```

---

## Contributing

Have a skill to share? Open a pull request — add a new folder with a `SKILL.md` file following the same format as the existing skills.
