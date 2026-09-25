# Step 18 — S06 Notifikasi · S25 Profil & Pengaturan · S26 Panel Mode Demo

| | |
|---|---|
| **Status** | ✅ Approved (2026-09-25) |
| **Priority** | P1 |
| **Owns screens** | S06, S25, S26 |
| **Owns components** | `NotificationTile`; (added, flag for `prd/02`): `TsSegmentedControl`, `SettingsRow`, `SettingsGroup`, `UserCard`, `ThemeSetting`, `ThemePreview`, `DemoPanel`, `DemoUnitRow`, `ErrorSimBanner`, `AboutContent` (`TsSwitch` is built in step 09 and instanced here; **`TsSlider` dropped**, decision 8) |
| **PRD refs** | [04 S06, S25, S26](../../../prd/04-screens.md), [05 demo-mode infra](../../../prd/05-data-model-mock.md), [03 F3/edge cases](../../../prd/03-user-flows.md), [06 S06/S25/S26 rows](../../../prd/06-responsive-layout.md) |
| **Pen location** | "Step 18" lane (see Canvas), later re-homed to Flows rows `S06`, `S25`, `S26` in step 19 |
| **Depends on** | Steps 02–05 (`AppShell`), 09 (`TsSwitch`), 16 (`StatusTimeline`, `DemoModeShortcut`), 17 (app-bar action slot recipe) |
| **Claude session** | `docs/claude-session/20-design-step18-notif-profile-demo.md` (written after approval) |

## Goal

Design the notification inbox, the profile/settings screen (theme switch, notification switch, demo mode entry, about, logout) and the reviewer-facing **Mode Demo panel** that drives tracking speed, manual status stepping, a one-shot forced network error and data reset. The panel must read as an obvious tooling surface, distinct from product UI.

## Inputs

- `AppShell` (Profil tab), `TsAppBar` (`Type=Back` with the action slot, `Type=Title`), `TsSwitch`, `TsDialog` (`Confirm Destructive`, `Confirm Save` structure), `TsSnackbar`, `SheetHeader`, `EmptyState / Type=Notifikasi`, `Skeleton`, `UnitStatusBadge`, `StatusTimeline / State=Live`, `DemoModeShortcut` (look reused), `TsLogo`.
- S06 groups: Hari ini / Minggu ini / Lebih lama; categories: status, promo, reminder; deep links per decision 3.

## Kickoff decisions (answered 2026-09-25, interview with the user; every recommended option chosen)

1. **S06 moment (Q1):** same as S05 — **Sel 29 Sep 2026 ≈ 10.30, service under way**, **2 unread** (matches the S05 bell "2").
2. **Read state (Q5):** unread = accent dot + semibold title + hidden semantics label "Belum dibaca" (never color alone). Tap marks read, then navigates. App-bar action **"Tandai semua dibaca"** (compact ghost text button, disabled at 0 unread); the bell badge on S05 drops live. No swipe-to-delete.
3. **Deep links:** unit status → **S21 of that unit**; booking confirmation → S20; invoice ready → **S23**; promo → **S10 with the voucher carried** (step 10 locked S17 to S16-only, so PRD 04 "S17 or Home" is outdated); service-due reminder → **S10 with that motor preselected**.
4. **Notifikasi toggle:** one master switch, subtitle "Status servis, promo, dan pengingat". Off = no new in-app notifications and no bell badge; existing ones stay readable. The off state is an annotation only (no S06 banner frame).
5. **S25 Tab-L right panel (Q1):** **"Pratinjau tema"** — a small app mock forced to the chosen theme (frame-level `theme` override). Mode Demo row pushes S26 as a full page (own two-pane); Tentang = modal; Keluar = dialog. No master-detail.
6. **Logout:** **neutral confirm** "Keluar dari akun?" — body "Data motor dan booking tetap tersimpan di perangkat ini."; actions "Batal" + primary "Keluar". Clears the session only → S03. **Amends the stub**, which listed logout as danger; danger styling is now "Reset semua data" only.
7. **Tentang (Q6):** sheet with logo, "TumbasServis", "Versi 1.0.0 (1)", "Aplikasi demo. Bengkel, harga, dan pembayaran hanya simulasi.", "Dibuat oleh Galah". No links, no AI mention.
8. **Speed (Q3):** **segmented control** "Mati / 15 dtk / 5 dtk", default 15 dtk (PRD 05). **`TsSlider` dropped** (amends PRD 04 "slider"); `TsSegmentedControl` serves both the theme and the speed control.
9. **Status controls:** panel for booking `TS-260929-0417` with rows **-A Vario 125, -B Beat 110, -C PCX 160** (`UnitStatusBadge` + "Majukan" + "Reset"), footer "Majukan semua" / "Reset semua". "Majukan" disabled at Selesai. Tab-L live preview = `StatusTimeline / State=Live` of the selected row.
10. **Error simulation:** **one-shot, auto-disarm** (PRD "next action fails"). On = armed banner on S26 ("Aksi berikutnya akan gagal"); after one failed write the toggle returns to Off. The indicator lives on S26 only.
11. **Reset semua data (Q4):** garage, bookings, draft, notification read-state, invoices, reviews → PRD 05 seed. Session, theme and demo settings are kept. Danger dialog lists these; snackbar "Data demo dikembalikan"; returns to Home (the empty-state moment of S05).
12. **Demo identity (Q2):** reuse the `DemoModeShortcut` language — `surface-inset` fill + `border-default` stroke, muted "MODE DEMO" label + icon, caption "Kontrol status khusus demo — bukan bagian produk." on every S26 panel. No dashes (Pencil has no stroke dash), no global banner. The S25 Mode Demo row carries a small "Demo" tag.
13. **Extra frames:** S26 no active booking · S26 unit at Selesai · S06 all read · text ×1.3 stress on S06 / S25 / S26 (the user said "pick recommended"; all four options taken, trim at review if too heavy).
14. **Canvas:** own **"Step 18" lane** at x 37,000 from y 36,000 (below the Step 17 lane), nothing existing moves; components sheet at x 41832. Step 19 re-homes both lanes.

### Defaults applied without asking (flag at review)

- **Chrome:** S06 and S26 are pushed pages (back arrow, no `NavBar` / `NavRail`) at every size, as S12 / S23. S25 uses `AppShell` (Profil tab): Compact = `NavBar`, Medium = rail, Large = extended rail. S06 is reached from the bell, S26 from S25 (and the S21 shortcut mirrors it).
- **Theme default = "Sistem"**, so a dark `Copy` stays coherent; the Tab-L preview shows the chosen theme regardless of the frame's own theme.
- **Theme control** = 3 segments, icon + label (`brightness_auto` / `light_mode` / `dark_mode`, names verified at build); the speed control = label only. Selected = accent fill + semibold label (not color alone); 48 dp height.
- **Keluar row** neutral (no red); Mode Demo row = chevron + "Demo" tag; Tentang row subtitle "Versi 1.0.0".
- **Timestamps:** Hari ini `10.26`; Minggu ini (rolling last 7 days) `Sen 28 Sep`; Lebih lama `10 Sep`. Title and body **wrap with no line clamp** (corrected by the review: at text ×1.3 the body needs 4 lines, a clamp would truncate it), row ≥ 72 dp, the whole tile is the tap target.
- **Tab-P About** = centered modal 560 (sheet → modal convention of S12 / S22). Dialogs stay phone-only (identical on tablet).
- **Late component:** `TsButton / Type=Outline, Size=Compact, State=Disabled` (the compact set has Default only; amends step 03) for "Majukan" at Selesai.

## Demo content (canonical continuity)

Now = **Sel 29 Sep 2026 ≈ 10.30**. S06 order (2 unread only):

| Group | Category | Title · body | Time | Goes to |
|---|---|---|---|---|
| Hari ini | status · **unread** | PCX 160 sedang diperiksa · Montir mulai memeriksa unit -C di Bengkel Jaya Motor. | 10.26 | S21 -C |
| Hari ini | status · **unread** | Beat 110 mulai dikerjakan · Unit -B dikerjakan oleh Mas Rudi. | 10.18 | S21 -B |
| Hari ini | status | Vario 125 mulai dikerjakan · Unit -A dikerjakan oleh Pak Anto. | 10.05 | S21 -A |
| Hari ini | status | Semua motor sudah check-in · 3 motor masuk antrean Bengkel Jaya Motor. | 09.08 | S20 |
| Minggu ini | status | Booking berhasil · TS-260929-0417 · 3 motor · Sel, 29 Sep · 09.00 | Sen 28 Sep | S20 |
| Minggu ini | reminder | Waktunya ganti oli Supra X 125 · Sudah 3 bulan sejak servis terakhir. | Sen 28 Sep | S10 (Supra X 125 preselected) |
| Minggu ini | promo | Potongan Rp25.000 servis · HEMAT25, min. belanja Rp300.000, berlaku sampai 5 Okt. | Sab 26 Sep | S10 + voucher |
| Lebih lama | status | Servis selesai · Beat 110 · Invoice TS-260910-0091 tersedia, total Rp143.000. | 10 Sep | S23 |
| Lebih lama | promo | Diskon 10% servis ≥2 motor · DISKON10, ajak motor kedua. | 3 Sep | S10 + voucher |

S25: **Galah** · `+62 812-****-7890` · avatar "G". S26: booking `TS-260929-0417` (-A Dikerjakan, -B Dikerjakan, -C Diperiksa, as S05); the Selesai frame = -A Selesai, -B Dikerjakan, -C Diperiksa. Speed default 15 dtk.

## Scope

### Frame matrix (31 frames)

Names `S<id> <Name> / <State> / <Breakpoint>[ · Dark]`. Dark = `Copy` with `theme: {mode: "dark"}`.

| Screen · State | Phone | Tablet-P | Tablet-L | Dark |
|---|---|---|---|---|
| S06 Populated (grouped, 2 unread, all 3 categories) | ✔ | ✔ list 720 | ✔ list 720 centered | all three |
| S06 Empty ("Belum ada notifikasi") | ✔ | — | — | — |
| S06 Loading (skeleton rows) | ✔ | — | — | — |
| S06 All Read (no dots, "Tandai semua dibaca" disabled) | ✔ | — | — | — |
| S06 Stress ×1.3 | ✔ | — | — | — |
| S25 Default (user card, Tema, Notifikasi, Mode Demo, Tentang, Keluar) | ✔ | ✔ 560 | ✔ menu left / "Pratinjau tema" right | all three |
| S25 Logout Dialog (neutral) | ✔ | — | — | — |
| S25 About Sheet | ✔ | — | — | — |
| S25 About Modal | — | ✔ | — | — |
| S25 Stress ×1.3 | ✔ | — | — | — |
| S26 Default (speed, unit rows + booking footer, error sim, reset data) | ✔ | ✔ 560 | ✔ controls left / live `StatusTimeline` right | all three |
| S26 Reset Dialog (danger) | ✔ | — | — | — |
| S26 Error Armed (toggle on + armed banner) | ✔ | — | — | — |
| S26 No Active Booking (unit controls disabled, reason line) | ✔ | — | — | — |
| S26 Unit Selesai (-A Selesai, Majukan disabled) | ✔ | — | — | — |
| S26 Stress ×1.3 | ✔ | — | — | — |

S06 = 3 + 3 + 1 + 1 + 1 + 1 = 10; S25 = 3 + 3 + 1 + 1 + 1 + 1 = 10; S26 = 3 + 3 + 1 + 1 + 1 + 1 + 1 = 11. Row headers and handoff notes are extra.

### Layout targets (PRD 06 + kickoff)

S06: single list → centered max 720 (Tab-P and Tab-L identical). S25: 1-col menu → centered 560 → menu ~440 left · "Pratinjau tema" ~500 right inside the extended rail shell. S26: stacked panels → centered 560 → controls ~520 left · live preview ~480 right (no shell). Phone frames `fit_content(800)`, `clip: true`.

### Canvas

"Step 18" lane at x 37,000, y ≥ 36,000 (Step 17 lane ends ≈ 34,100), no existing node moved. Components sheet `Components / Notification & Settings Blocks` at x 41832 (light y 8760, dark copy y 12380, lower if the sheet is taller than 3,620 dp).

### Components built here

| Component | Notes |
|---|---|
| `NotificationTile` (owned, PRD 02) | Category = Status / Promo / Reminder × State = Unread / Read (6) + `State=Loading`; leading category icon tile, title, body, timestamp, unread dot |
| Group header | Reuse `SectionTitleRow` if it fits; else `NotificationGroupHeader` |
| `TsSegmentedControl` | Segments = 3, Selected = 1 / 2 / 3, Style = Icon+Label / Label; selected by accent fill + semibold label |
| `SettingsRow`, `SettingsGroup` | Leading icon, title, subtitle, trailing: chevron / `TsSwitch` On / Off / "Demo" tag |
| `UserCard`, `ThemeSetting`, `ThemePreview` | Avatar initial + name + masked phone; label + segmented control; Tab-L forced-theme mini app |
| `DemoPanel`, `DemoUnitRow`, `ErrorSimBanner` | `DemoModeShortcut` tokens; row = name + badge + "Majukan" + "Reset" (Default / At Selesai); armed banner |
| `AboutContent` | Logo, name, version, demo note, credit |
| `TsButton / Outline, Compact, Disabled` | Late variant (step 03 amendment) |
| Reused, not redrawn | `TsSwitch`, `TsDialog` (`Confirm Destructive`; `Confirm Save` structure for the neutral logout), `TsAppBar` Back (+ action slot) / Title, `AppShell / Active=Profil`, `SheetHeader`, `EmptyState / Notifikasi`, `Skeleton`, `UnitStatusBadge`, `StatusTimeline / Live`, `TsSnackbar`, `TsLogo` |

### Annotations to place

- Tap → destination per category (decision 3); unread badge on the bell updates live; semantics label per tile ("Belum dibaca. PCX 160 sedang diperiksa. 10.26").
- Theme change applies live and persists; "Sistem" follows the OS; segmented control semantics (radio group, selected state).
- Notifikasi switch off behavior (decision 4).
- Mode Demo effects: auto-advance interval, "Majukan" / "Reset" per unit and per booking (same `TrackingSimulator` as the S21 shortcut), one-shot error (auto-disarm), seed reset; where else the shortcut appears (S21).
- Logout confirm → S03, session cleared, data kept; reset confirm → seed data + snackbar + Home.
- Reduce-motion: no shimmer on Loading; 150 ms selection feedback.

## Built (node ids, `design/pencil/TumbasServis.pen`)

Sheet **"Components / Notification & Settings Blocks"** `nUFiI` (x 41832, y 8760, 1200 × 3,128) with dark copy `w4hH6t` (y 12380; 31 unnamed refs renamed; re-copied after the review fixes):
`NotificationTile` Status Unread `BUkFE` · Promo Unread `lt1AB` · Reminder Unread `n2Giwa` · Status Read `jjXCk` · Promo Read `FzmQ3` · Reminder Read `pKyNV` · Loading `Q8I8px`; `NotificationGroupHeader` `YLM3b`; `TsSegmentedControl` Icon+Label Selected 1 / 2 / 3 `osozy` `hb9bs` `sviQv`, Label Selected 1 / 2 / 3 `N175mg` `PCGmu` `KZMba`; `SettingsRow` Chevron `v9szj` · Demo `jVZn7` · Switch On `xk1p7` · Switch Off `mxjdi`; `UserCard` `Icv2g`; `ThemeSetting` `zWT49`; `AboutContent` `kg65Q`; `ThemePreview` System `kYgej` · Light `mwE6i` · Dark `GEjnX`; `DemoPanel` `JGO1B` (slot `Panel Body` `qT6rD`); `DemoUnitRow` Default `lX7sN` · Selected `nA3GQ` · At Selesai `uYrnb`; `ErrorSimBanner` `IVS70`; `DemoPreviewPane` `Kw2nz`; `TsButton / Outline, Compact, Disabled` `a4H2Gl`; focus specimens section `k5kih`. `SettingsGroup` is a composition (card + 1 dp dividers), not a master.

Frames (31) in the **"Step 18" lane** (x 37,000, y 36,000 – 56,904; nothing existing moved), row headers `A9v4G` `jzRfN` `MnSiE` `gbGbC` (S06) · `Hqu9s` `VoiXx` `R61be4` `iW2lA` (S25) · `VYwzJ` `SEkI2` `aSbGD` `ILis9` (S26), handoff notes `r8NMpp` (S06, x 39,400) · `oGP82` (S25, x 39,400) · `NbLBw` (S26, x 39,800):

| Row | Frames (node id) |
|---|---|
| S06 phone light, header y 36,000, frames y 36,186 | Populated `rUjMH` · Empty `oLxL9` · Loading `z6pjrA` · All Read `WiPuS` · Stress ×1.3 `lPUgN` (x 0 / 440 / 880 / 1,320 / 1,760) |
| S06 phone dark, header y 38,200, frame y 38,386 | Populated `HYboq` |
| S06 Tablet-Portrait, header y 40,000, frames y 40,186 | Populated `f5hGAh` · Dark `pU0RF` (x 0 / 880) |
| S06 Tablet-Landscape, header y 41,700, frames y 41,886 | Populated `S1z0v` · Dark `M9YG0` (x 0 / 1,360) |
| S25 phone light, header y 43,100, frames y 43,286 | Default `bJZYH` (812) · Logout Dialog `o8g1v2` · About Sheet `mZuD1` · Stress ×1.3 `UajxP` (920) |
| S25 phone dark, header y 45,000, frame y 45,186 | Default `P3MmCx` |
| S25 Tablet-Portrait, header y 46,700, frames y 46,886 | Default `EeC4f` · Dark `Rfhv2` · About Modal `IrZMI` (x 0 / 880 / 1,760) |
| S25 Tablet-Landscape, header y 48,400, frames y 48,586 | Default `ZnPTU` · Dark `daC16` (x 0 / 1,360) |
| S26 phone light, header y 49,900, frames y 50,086 | Default `y2Qno5` (1,448) · Reset Dialog `F5NqM` · Error Armed `cQ2Rx` · No Active Booking `e3PSr` · Unit Selesai `RbLFf` · Stress ×1.3 `lwpan` (x 0 … 2,200) |
| S26 phone dark, header y 52,300, frame y 52,486 | Default `XJxOc` |
| S26 Tablet-Portrait, header y 54,000, frames y 54,186 | Default `cVbA4` (1,322) · Dark `D4v7S0` |
| S26 Tablet-Landscape, header y 55,700, frames y 55,886 | Default `kmIv3` (1,018) · Dark `KUg8V` |

Build decisions made while building (flag at review; all inside the kickoff decisions unless marked **deviation**):
- **Deviation (decision 2):** "Tandai semua dibaca" sits in the **first group's header row**, not in the app bar. The ×1.3 stress frame showed the app-bar title wrapping to "Notifi / kasi" beside the long action; the action is now a compact ghost button right-aligned in the "Hari ini" header row (disabled in All Read, absent in Empty / Loading).
- **Deviation (decision 12):** every S26 panel carries the "MODE DEMO" label + icon on the inset surface, but the caption "Kontrol status khusus demo — bukan bagian produk." appears **once** at the top of the page (repeating it four times per screen is noise).
- **Tab-L S26:** left column = intro + Kecepatan + Status booking (unit rows, first row selected "Dipratinjau"); right column = `DemoPreviewPane` (live `StatusTimeline`) + Simulasi galat + Data demo, so both columns fit one ≈ 1,000 dp capture.
- **Selected `DemoUnitRow`** = card surface + 2 dp accent border + "Dipratinjau" tag (not a tinted fill: the audit measured the muted plate on `accent-soft` at 4.36 : 1 and the Dikerjakan badge at 4.48 : 1 in dark).
- **Notification category discs:** Status = `accent-soft`; Promo and Reminder = neutral inset disc + border (the first build borrowed the info / warning ramps; `/better-interface` MEDIUM). Category is also carried by the icon and the "Status · / Promo · / Pengingat ·" text.
- **Stress ×1.3:** S26 "Booking Actions" (Majukan semua / Reset semua) stacks into a column (Flutter `Wrap`); S06 / S25 needed no other change.
- **Added while building:** `NotificationGroupHeader`, `DemoPreviewPane`, `ThemePreview` ×3 (System / Light / Dark), focus specimens (review).
- Frame chrome: S06 / S26 = status bar + back bar + gesture bar (phone), back bar only (tablet); S25 = `AppShell` (Profil). Dialog / sheet / modal frames = wrapper frame + `Copy` of the screen + scrim + overlay.

Pencil facts (verified in step 18; copy to `00-index.md` at close):
- **A frame-level `theme: {mode}` on a nested frame renders inside a frame of the other theme** (the `ThemePreview` stages: forced light inside a dark frame and the reverse); the mini app is built from tokens, rectangles and ellipses only (no text under 12 sp).
- **Root frames holding slot-filled `DemoPanel` instances came back with a 0.9157 dp child offset** that the clipping check reported as "partially clipped" (Gesture Bar, Scroll Body, last panel). `Copy` + `Delete` of the original clears it (ids change); a section whose children were moved (`Move`) kept stale y until a no-op `Update` of `gap` (25 → 24) forced a relayout.
- **An instance cannot take children**, so a dialog / sheet on an `AppShell` screen = a plain `layout: "none"` wrapper frame holding a `Copy` of the screen ref, a `$scrim` rectangle and the dialog ref (recipe of steps 06 / 17 generalised to ref screens).
- **Override keys containing `/` are read as paths:** the dialog's `"TsButton / Primary (confirm)/zZjKm"` did nothing; use the ids (`<dialogId>/w6MH4/zZjKm`).
- **Slot replacement through `descendants`** works with nested `ref` children that carry their own `descendants` (`DemoPanel` `qT6rD` → unit rows, buttons); sub-instances swap with `{type: "ref", ref: <master>}` (`Status Badge` → Diperiksa).
- **`strokeWidth: {bottom: 1}`** works on a master (row dividers) and `strokeWidth: 0` overrides it on the last instance in a card.
- **`Replace(inst + "/<Action 1 id>", {type: "ref", …})`** swaps the app-bar action for a ghost text button on a screen-level instance (worked here, where it threw inside a master in step 05).
- `Get(document, visit)` and the whole-document `Get(visit)` throw ("cannot read property of undefined"); the audit iterates known root ids instead.

## Checklist

### Build
- [x] Kickoff questions answered.
- [x] `NotificationTile` variants + `TsSegmentedControl` + settings / demo blocks built, light + dark.
- [x] S06, S25, S26 frames built per matrix (31); dark defaults built.
- [x] Danger styling only on "Reset semua data" (logout is neutral, decision 6).
- [x] Demo panel visually distinct and labelled (`DemoModeShortcut` language).
- [x] Unread state conveyed by dot + weight + label (not color alone).

### Quality (automated, run in `execute`)
- [x] Clipping check on every step frame → zero `problems` (33 roots, `resolveInstances: true`; exempt disabled chains).
- [x] Raw-hex audit → zero.
- [x] Every node named; instances only; `placeholder` cleared.
- [x] Coverage script: 31 / 31 frame names match the matrix above.

### /better-interface
- [x] Run `/better-interface` with scope = all S06, S25, S26 frames (names + node ids).
- [x] Report recorded below; HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [x] Status set to 🔵; user shown: inbox, empty, settings + theme, demo panel, dialogs, tablet-L, dark.
- [x] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [x] PNG export to `design/pencil/exports/step18/` (+ `INDEX.md`): 31 frames + 2 sheets in `components/`, verified with `ls`.
- [x] Claude session file written.
- [x] Tracker set to ✅; inventory additions updated (`TsSlider` dropped, see the index inventory row).

## /better-interface report

**Scope:** S06 Notifikasi (10 frames: `rUjMH` `oLxL9` `z6pjrA` `WiPuS` `lPUgN` `HYboq` `f5hGAh` `S1z0v` `pU0RF` `M9YG0`), S25 Profil (10: `bJZYH` `o8g1v2` `mZuD1` `UajxP` `P3MmCx` `EeC4f` `IrZMI` `Rfhv2` `ZnPTU` `daC16`), S26 Mode Demo (11: `y2Qno5` `F5NqM` `cQ2Rx` `e3PSr` `RbLFf` `lwpan` `XJxOc` `cVbA4` `D4v7S0` `kmIv3` `KUg8V`), component sheet `nUFiI` + dark `w4hH6t` · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens · **Convention docs found:** 00-index.md, prd/02, prd/06, this step file

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | Names / Semantics annotations on every icon-only and repeated control, focus states of the new tappables, unread / selected / armed state cues (icon, text, weight, shape), reduced-motion notes, 48 dp targets (segments 48, buttons 48, rows ≥ 70, switch 48), dialog focus notes | 2 findings (1 HIGH, 1 MEDIUM), both fixed |
| Layout | 31 frames at 360 / 800 / 1280, text ×1.3 stress on all three screens, clipping script, column balance of Tab-L, grouping (8 / 12 / 16 dp steps), pushed-page chrome | 2 findings (MEDIUM), both fixed; 1 LOW |
| Writing | Every label vs its action, cancel / confirm wording, repeated strings, terminology against S05 / S16 / S21 copy, sentence case | 3 LOW |
| Typography | Type roles (all ≥ 12 sp, 0 rows under), heading descent (20 → 16 → 14), wrapping at ×1.0 / ×1.3, truncation rules | 1 finding (MEDIUM, fixed); 1 LOW |
| Color | Resolved contrast on 1,542 text / icon nodes in both themes (light + dark frames, dark sheet), token roles, semantic-ramp use, forced-theme preview | 2 findings (MEDIUM), both fixed |
| UI | Concentric radii, icon weight vs text weight, elevation, one filled action per view, danger styling limited to Reset | 1 LOW |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| HIGH | Accessibility | Sheet `nUFiI` / `w4hH6t`; every tile / row / segment / unit row in S06 `rUjMH` …, S25 `bJZYH` …, S26 `y2Qno5` … | `NotificationTile`, `SettingsRow`, `TsSegmentedControl` segments and `DemoUnitRow` had no designed focus state (keyboard / switch access) | "Focus Specimens" section `k5kih`: the four components with the 2 dp `$focus-ring` inner stroke; notes point to it | A keyboard-reachable control with no visible focus indicator (escalation trigger). Prior steps added the same specimens for `TsButton`, cards, `RatingStars` **[applied]** |
| MEDIUM | Accessibility | S26 unit rows in `y2Qno5` `cQ2Rx` `RbLFf` `lwpan` `XJxOc` `cVbA4` `kmIv3` …; S06 arrival; S26 armed state | "Majukan" / "Reset" repeated three times with no unit in the name; no announcement for new notifications, armed banner, auto-disarm | Semantics notes: "Majukan Unit -A, Vario 125" etc.; polite live regions ("Notifikasi baru", "Galat simulasi aktif / selesai") in `NbLBw` `r8NMpp` `oGP82` | Repeated labels are ambiguous by ear; dynamic state changes must be announced **[applied]** |
| MEDIUM | Color | `NotificationTile` Promo `lt1AB` `FzmQ3`, Reminder `n2Giwa` `pKyNV` (every S06 frame, sheet) | Promo disc on `info-soft` / `info-text`, Reminder disc on `warning-soft` / `warning-text` | Neutral `surface-inset` disc + `border-default`, icon `text-body`; category still in the meta text and the icon shape | Status ramps borrowed for a non-status category (a reminder read as a warning; same class as the step 08 static-map fix) **[applied]** |
| MEDIUM | Color | `DemoUnitRow / State=Selected` `nA3GQ` (Tab-L frames `kmIv3` `KUg8V`, sheet) | Selected = `accent-soft` fill: plate `text-muted` 4.36 : 1 light, Dikerjakan badge 4.48 : 1 dark | Fill `surface-card`, 2 dp `border-accent`, "Dipratinjau" tag; contrast script 0 fails | Small text below 4.5 : 1 on the rendered pair **[applied]** |
| MEDIUM | Layout | S06 app bar in the first build (`Tandai semua dibaca` as bar action), frame `lPUgN` | At ×1.3 the title wrapped to "Notifi / kasi" (81 dp left for the title) | Action moved to the "Hari ini" header row `cS4pV` (frames `rUjMH` `WiPuS` `f5hGAh` `S1z0v`); app-bar action disabled | Content squeezed by a long action at large text; **deviation from kickoff decision 2**, flagged for the user **[applied]** |
| MEDIUM | Layout | S26 `DemoPanel · Status booking` "Booking Actions", stress frame `lwpan` | At ×1.3 "Reset semua" overflowed the 296 dp panel (clipped) | Buttons stack in a column at large text scale (Flutter `Wrap`) | Action clipped at large text **[applied]** |
| MEDIUM | Typography | Step file defaults; S06 note `DmpnR`; stress frame `lPUgN` | "Title 1 line, body max 2 lines" while the ×1.3 frame needs 4 lines for the promo body | "Title and body wrap with no line clamp" in the step file and the note | A clamp would truncate the notification text with no way to read it **[applied]** |
| LOW | Writing | S26 `DemoPanel · Status booking` vs `Data demo` (`y2Qno5`) | "Reset semua" next to "Reset semua data" | Keep (danger style + confirm dialog guard the second); consider "Reset semua unit" in step 19 if the 296 dp row allows (169 + 150 dp at 14 px does not) | Near-identical labels for actions of very different reach |
| LOW | Writing | S26 `DemoPanel · Simulasi galat` `nF0Eq` | Panel title "Simulasi galat", helper "Uji tampilan galat…", row "Simulasikan galat jaringan" say the same thing three times | Drop the helper (step 19) | Words that do no work |
| LOW | Writing | Dialogs `o8g1v2` `F5NqM` vs step 16 / 17 dialogs | Cancel = "Batal" here, "Kembali" in the S22 / S23 dialogs | Decide one cancel word in step 19 | Vocabulary consistency |
| LOW | Typography | `DemoPanel` `JGO1B` header, `DemoPreviewPane` `Kw2nz`; times "10.26", "15 dtk" | "MODE DEMO" stored in capitals (parity with `DemoModeShortcut`); times and speeds not tabular | Store "Mode Demo" + `textTransform`; tabular figures annotated only | Copy stays natural, digits do not shift |
| LOW | UI | `DemoPanel` (radius 16, padding 16) → `DemoUnitRow` / message card (radius 12) | Inner radius above the concentric value (outer − padding = 0) | Leave; revisit with the step 19 radius audit | Nested radii |

**Verification:** Passed — clipping on 33 roots (31 frames, sheet, dark sheet, `resolveInstances: true`, exempt disabled chains): 0; raw hex 0; unnamed nodes 0; `placeholder` 0; text under 12 sp 0; coverage 31 / 31 names; contrast 1,542 text + icon nodes, 5 fails = the logo monogram (3.45 : 1, a logotype, exempt as in steps 05 / 12); screenshots of the S06 phone list and app bar, empty, loading, all read, stress header row, dark, Tab-P / Tab-L; S25 phone, dialogs, sheet, modal, stress, Tab-L light + dark; S26 phone panels, armed, no-booking, reset dialog, stress, Tab-L dark, Tab-P; the theme-preview stages in all three modes. **Not verified:** Flutter rendering (segmented control, ripple, list card clipping), 320 px width and 200 % zoom (only ×1.3 checked), RTL, screen-reader output, Exo 2 tabular figures, and the **html2figma import of the forced-theme preview stages** (step 20).
**Verdict:** Approve
**Fixes applied:** HIGH focus specimens (`k5kih`); MEDIUM semantics notes (`NbLBw` `r8NMpp` `oGP82`), neutral category discs (`K1lA2` `hN0K4` `oJRa6` `uW1bg` + icons `S5he6` `moa0o` `PRAd5` `FvbYF`), selected unit row (`nA3GQ`), header-row action, stacked booking buttons at ×1.3, no-clamp copy · **LOW left for user:** the five LOW rows above.

## Review rounds

### Round 1 — 2026-09-25
- **Frames shown:** S06 (10), S25 (10), S26 (11) in the "Step 18" lane, component sheet + dark copy, the `/better-interface` report, the six deviations from the kickoff decisions (header-row action, one demo caption, neutral category discs, selected row = accent border, no line clamp, Tab-L S26 column split).
- **User feedback:** none requested; all deviations accepted.
- **Approval:** 2026-09-25 — "approve".

## Session log

| Time | Action | Result / node ids |
|---|---|---|
| 2026-09-25 | Kickoff interview (4 rounds, 14 decisions), plan approved | Step file rewritten; index decision-log / demo-content / inventory rows and tracker 🟡; audit block F updated |
| 2026-09-25 | Component sheet + dark copy | `nUFiI` / `w4hH6t` (x 41832): tiles, segmented control, settings rows, S25 / S26 blocks, theme previews |
| 2026-09-25 | S06 frames (10) | Populated / Empty / Loading / All Read / Stress phone, dark, Tab-P, Tab-L (light + dark); stress ×1.3 found the app-bar action wrapping the title → action moved to the first group header |
| 2026-09-25 | S25 frames (10) | `AppShell` Profil phone / Tab-P / Tab-L (light + dark), logout dialog, About sheet + modal, stress |
| 2026-09-25 | S26 frames (11) | Phone / Tab-P / Tab-L (light + dark), reset dialog, error armed, no active booking, unit Selesai, stress; a `Copy` cleared the 0.9 dp child offset on the first builds |
| 2026-09-25 | Automated checks | Clipping 0, hex 0, unnamed 0, placeholder 0, text < 12 sp 0, coverage 31 / 31; contrast audit found the selected unit row (fixed) and the logo monogram (exempt) |
| 2026-09-25 | `/better-interface` | 7 findings fixed (1 HIGH, 6 MEDIUM), 5 LOW left; verdict Approve; dark sheet re-copied |
| 2026-09-25 | Review gate | User approved ("approve") |
| 2026-09-25 | Export | 31 PNG in `design/pencil/exports/step18/` + 2 in `components/` + `INDEX.md`, verified with `ls` |
| 2026-09-25 | Docs | Index tracker ✅, decision-log + Pencil facts + canvas layout, audit block F, session file `20-design-step18-notif-profile-demo.md` |
| 2026-09-25 | Step 19 audit fixes (F2, F11) | S06 `All Read / Phone` `WiPuS` moved from y 0 into its row (re-layout); MOTION note `ZKVyd` in `NbLBw` (S26: 300 ms timeline reveal, 150 ms controls, `disableAnimations` = instant) |
