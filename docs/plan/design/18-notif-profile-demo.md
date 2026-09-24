# Step 18 — S06 Notifikasi · S25 Profil & Pengaturan · S26 Panel Mode Demo

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | P1 |
| **Owns screens** | S06, S25, S26 |
| **Owns components** | `NotificationTile`; (added, flag for `prd/02`): `TsSegmentedControl`, `TsSlider`, `SettingsRow` (`TsSwitch` is built in step 09 for the S15 "Pisah jadwal" toggle — instance it here) |
| **PRD refs** | [04 S06, S25, S26](../../../prd/04-screens.md), [05 demo-mode infra](../../../prd/05-data-model-mock.md), [03 F3/edge cases](../../../prd/03-user-flows.md), [06 S06/S25/S26 rows](../../../prd/06-responsive-layout.md) |
| **Pen location** | Flows rows `S06`, `S25`, `S26` |
| **Depends on** | Steps 02–05, 16 |
| **Claude session** | `docs/claude-session/20-design-step18-notif-profile-demo.md` (written after approval) |

## Goal

Design the notification inbox, the profile/settings screen (theme switch, demo mode entry, logout) and the reviewer-facing **Mode Demo panel** that drives tracking speed, manual status stepping, forced network errors and data reset. The panel must read as an obvious tooling surface, distinct from product UI.

## Inputs

- `AppShell` (Profil tab), `NotificationTile`, `TsDialog`, `TsSnackbar`, `EmptyState` (notifikasi), `Skeleton`, `UnitStatusBadge`/`StatusTimeline` (live preview on S26 landscape).
- Groups on S06: Hari ini / Minggu ini / Lebih lama; categories: status, promo, reminder; deep links to S20/S21/S17/Home.

## Open questions (ask at kickoff)

1. **Theme control** — segmented control Sistem / Terang / Gelap; should the design show a live preview swatch (tablet-L right panel)?
2. **Mode Demo visual identity** — a persistent "Mode Demo" banner or dashed-border surfaces to separate it from product UI?
3. **Speed control** — slider with three stops (Mati / 15 dtk / 5 dtk) vs segmented control. *Recommended: segmented (discrete) — sliders are harder to operate accessibly.*
4. **"Reset semua data"** — danger confirm dialog wording; what is restored (seed data)?
5. **Notification read behavior** — unread dot + bold title + "Tandai semua dibaca" action in the app bar?
6. **About screen** — "Tentang Aplikasi" as a sheet with version + credits (Claude session log link?) — content to include.
7. **User card** — name "Galah", phone `+62 812-****-7890`, avatar initial.

## Scope

### Frame matrix

| Screen · State | Phone | Tablet-P | Tablet-L | Dark |
|---|---|---|---|---|
| S06 Populated (grouped, mixed read/unread, all 3 categories) | ✔ | ✔ max-w 720 | ✔ centered | all three |
| S06 Empty ("Belum ada notifikasi") | ✔ | — | — | — |
| S06 Loading | ✔ | — | — | — |
| S25 Default (user card, Tema, Mode Demo, Notifikasi toggle, Tentang, Keluar) | ✔ | ✔ | ✔ menu left / active panel right | all three |
| S25 Logout confirm dialog | ✔ | — | — | — |
| S25 Tentang Aplikasi sheet | ✔ | — | — | — |
| S26 Default (speed, majukan/reset per active booking, error-simulation toggle, reset data) | ✔ | ✔ | ✔ controls left / live status preview right | all three |
| S26 Reset-all confirm dialog (danger) | ✔ | — | — | — |
| S26 Error-simulation armed (toggle on + persistent indicator) | ✔ | — | — | — |

### Layout targets (PRD 06)

S06: single list → centered max 720. S25: 1-col menu → centered max 560 → menu left / active panel right. S26: stacked controls → centered max 560 → controls left / live preview right.

### Components built here

| Component | Notes |
|---|---|
| `NotificationTile` (owned, PRD 02) | Read/unread, icon by category, title, body, timestamp |
| `TsSegmentedControl` | 2–3 segments; selected state by fill + label weight |
| `TsSwitch` | **Built in step 09** (Off / On / Disabled, ≥ 48dp target); instance it here, no rebuild |
| `TsSlider` | Only if Q3 keeps it |
| `SettingsRow` | Leading icon, title, subtitle, trailing control/chevron |

### Annotations to place

- Notification tap → destination per category; unread badge on the bell updates.
- Theme change applies live and persists; system mode follows OS.
- Mode Demo effects (auto-advance interval, manual step/reset, next-write forced error, seed reset) and where else the shortcut appears (S21).
- Logout confirm → S03; session cleared.

## Checklist

### Build
- [ ] Kickoff questions answered.
- [ ] `NotificationTile` variants + new setting controls built, light + dark.
- [ ] S06, S25, S26 frames built per matrix; dark defaults built.
- [ ] Danger styling only on genuinely destructive actions (logout confirm, reset data).
- [ ] Demo panel visually distinct and labelled.
- [ ] Unread state conveyed by dot + weight + label (not color alone).

### Quality (automated, run in `execute`)
- [ ] Clipping check on every step frame → zero `problems`.
- [ ] Raw-hex audit → zero.
- [ ] Every node named; instances only; `placeholder` cleared.
- [ ] Coverage script: frame names match the matrix above.

### /better-interface
- [ ] Run `/better-interface` with scope = all S06, S25, S26 frames (names + node ids).
- [ ] Report recorded below; HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: inbox, empty, settings + theme, demo panel, dialogs, tablet-L, dark.
- [ ] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] PNG export to `design/pencil/exports/step18/`.
- [ ] Claude session file written.
- [ ] Tracker set to ✅; inventory additions updated.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
