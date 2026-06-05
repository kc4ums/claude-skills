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

**Step 1** — Open Claude Code and start a new chat.

**Step 2** — Copy and paste this into the chat to see all available skills, then press Enter:

```
! irm https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1 | iex
```

**Step 3** — Install the skill you want by pasting this, then press Enter:

```
! $env:SKILL="osha-wood-mill"; irm https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1 | iex
```

Replace `osha-wood-mill` with the skill name you want. To install everything at once, use `all` instead of a skill name.

**Step 4** — Start a new chat. The skill is ready to use.

That's it. No downloads, no setup, no configuration files.

---

## Using a skill

Once installed, just type the slash command in any Claude Code chat:

```
/osha-wood-mill
/bible-verses I feel overwhelmed
```

