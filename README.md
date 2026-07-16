# claude_usage

A KDE Plasma 6 panel widget that shows your Claude Pro quota usage.
Also works as a custom [Waybar](https://github.com/Alexays/Waybar) module.

*[Leia em português](README.pt-BR.md)*

## What it shows

```
Claude  5h: 14% (↑12%) (13:50)  |  7d: 40% (↑57%) | ●
```

- **5h:** usage within the 5-hour window; the `(↑XX%)` pacing figure is what you would have spent by now at an even burn rate; the  icon (U+F0E2, Font Awesome) is followed by the local reset time (`five_hour.resets_at`)
- **7d:** usage within the 7-day window; the `(↑XX%)` pacing figure is recomputed by the minute from the start of the cycle (`seven_day.resets_at − 7 days`)
- **●:** Claude's operational status (`status.claude.com`) — green, yellow, orange or red

Left-clicking the widget refreshes quota and status together. Right-clicking opens a menu with two separate entries: **Recarregar cota** (reload quota) and **Recarregar status** (reload status).

## Layout

```
claude_usage/
├── claude_usage.sh        # bash script that queries the API
├── plasmoid/              # KDE widget package
│   ├── metadata.json
│   └── contents/
│       ├── ui/main.qml
│       └── icons/claude.png
├── README.md
└── CHANGELOG.md
```

The plasmoid is installed by symlinking it into `~/.local/share/plasma/plasmoids/com.celo.claudeusage/`.

## How it works

The script reads Claude Code's OAuth token from `~/.claude/.credentials.json` and
queries `https://api.anthropic.com/api/oauth/usage` for quota usage and
`https://status.claude.com/api/v2/status.json` for operational status. The widget
runs the script every 5 minutes and renders the result in the panel.

The `(↑XX%)` pacing figure next to `7d` is computed by the minute:
`elapsed_minutes / (7 × 24 × 60) × 100`. It climbs about 0.05% per 5-minute refresh.
The start of the cycle is derived from the API's own `seven_day.resets_at`, so if
Anthropic changes the reset day or time, the widget follows along on its own.

The script keeps a 60-second local cache in `~/.cache/claudebar/usage.json` and
automatically refreshes the OAuth token when it is about to expire.

## Script modes

`claude_usage.sh` takes a single argument that selects the output format:

| Mode | Output |
|------|--------|
| `usage` | `Claude  5h: X% (↑Y%) (HH:MM)  \|  7d: Z% (↑W%)` |
| `status` | `none` / `minor` / `major` / `critical` / `unknown` |
| `waybar` | JSON with `text`, `tooltip` and `class` for a Waybar custom module |
| `all` (default) | `<usage>::<status>` — the format the plasmoid consumes |

## Installation

```bash
# 1. clone the repository
git clone https://github.com/marcelomogami/claude-usage.git ~/projects/personal/claude_usage
cd ~/projects/personal/claude_usage

# 2. make the script executable
chmod +x claude_usage.sh

# 3. symlink the plasmoid
ln -s "$PWD/plasmoid" ~/.local/share/plasma/plasmoids/com.celo.claudeusage

# 4. restart plasmashell
kquitapp6 plasmashell && plasmashell &

# 5. add the "Claude Usage" widget to your panel from the KDE menu
```

> **Note:** the script path is hardcoded in `plasmoid/contents/ui/main.qml`
> (`scriptBase`). If you clone the repository elsewhere, adjust that line.

### Waybar

Add a custom module to `~/.config/waybar/config.jsonc`:

```jsonc
"custom/claude": {
    "exec": "bash ~/projects/personal/claude_usage/claude_usage.sh waybar",
    "return-type": "json",
    "interval": 300
}
```

## Requirements

- KDE Plasma 6 (for the plasmoid) or Waybar (for the custom module)
- `jq` and `curl`
- Claude Code installed and authenticated (`~/.claude/.credentials.json`)

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## License

[MIT](LICENSE) © Marcelo Mogami

A personal project, not affiliated with Anthropic. "Claude" is a trademark of Anthropic.
