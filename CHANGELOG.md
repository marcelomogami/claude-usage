# Changelog

*[Leia em português](CHANGELOG.pt-BR.md)*

## 1.9 — 2026-06-26

- Added a `waybar` mode to `claude_usage.sh`: emits JSON with `text`, `tooltip` and `class` for a Waybar custom module
- Set up the `custom/claude` module in `~/.config/waybar/config.jsonc` with a 300s interval and CSS colours per operational status

## 1.8 — 2026-06-11

- Fixed the `` icon overlapping the 5h window reset time: added two spaces between the icon and `HH:MM`

## 1.7 — 2026-05-25

- The 7d `↑XX%` indicator is now computed by the minute: uses `ELAPSED_MINUTES / CYCLE_MINUTES × 100` instead of `DAY_IDX × 100 / 7` — it climbs ~0.05% per 5-minute cycle rather than sitting on the same value all day
- 60-second local cache in `~/.cache/claudebar/usage.json` guarded by `flock` — avoids duplicate API requests (e.g. a manual reload landing on top of the timer)
- Automatic OAuth token refresh: detects an `expiresAt` about to lapse and issues `POST /v1/oauth/token` with `grant_type: refresh_token`, updating `~/.claude/.credentials.json` with no manual step
- Added the `(↑XX%)` pacing indicator to the 5h window too, between the percentage and the reset time: `5h: 14% (↑12%) (13:50)`

## 1.6 — 2026-05-19

- Folded the daily quota ceiling into `7d` as `(↑XX%)` instead of a separate segment — visually symmetric with the 5h reset
- Swapped the 5h reset icon from `↻` to `` (U+F0E2, Font Awesome rotate-left), rendered through Qt6 font fallback

## 1.5 — 2026-05-19

- Show the 5h window reset time next to the percentage: `5h: XX% (↻HH:MM)`
- Value read from the API's own `five_hour.resets_at` and formatted as local time

## 1.4 — 2026-05-19

- Added a `max: XX%` marker between 7d and the status dot: the cumulative quota ceiling reachable by end of day, splitting the 7-day window's 100% into 7 equal days (day 1 = 14%, day 7 = 100%)
- Cycle start derived automatically from the API's own `seven_day.resets_at` (cycle = 7 days before the next reset); no configuration, and self-adjusting if the reset moves
- Computed in the script itself (no QML change)

## 1.3 — 2026-05-16

- Context menu (right click) with separate "Recarregar cota" (reload quota) and "Recarregar status" (reload status) entries
- Script accepts a `usage` or `status` argument to fetch only what is needed
- Added a timeout to the status curl (3s connect, 5s total) to keep manual reloads from hanging
- Left click still does a full reload (quota + status)

## 1.2 — 2026-05-15

- Coloured Claude status dot (green/yellow/orange/red) after the percentages
- Queries `status.claude.com/api/v2/status.json` every 5 minutes alongside usage
- Display format: `Claude  5h: XX%  |  7d: XX% | ●`

## 1.1 — 2026-05-14

- Claude icon in the panel (favicon extracted from claude.ai)
- Clicking the widget refreshes the data immediately
- Moved the plasmoid to `claude_usage/plasmoid/` with a symlink in `~/.local/share/plasma/plasmoids/`

## 1.0 — 2026-05-14

- Authenticated queries using Claude Code's OAuth token
- Shows usage for the 5h and 7d windows
- Minimal KDE Plasma 6 widget with no external dependencies
