# Step 09 — S15 Pilih Jadwal

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-24 |
| **Priority** | P0 |
| **Owns screens** | S15 |
| **Owns components** | `TsSwitch` (moved from step 18), `ScheduleModeToggle`, `WorkshopSummaryRow`, `CapacityBanner`, `UnitSlotSection`, `DateStripItem` grid variant + `DateGrid`; amends `SlotChip` (caption "Sisa n motor") |
| **PRD refs** | [04 S15](../../../prd/04-screens.md), [03 scheduling rules + edge cases](../../../prd/03-user-flows.md), [06 S15 row](../../../prd/06-responsive-layout.md) |
| **Pen location** | Components sheet "Schedule" (x 30808, light y 8760, dark copy under it); Flows rows `S15` (phone rows after the S14 rows, tablet rows below the S14 tablet rows) |
| **Depends on** | Steps 02–08 |
| **Claude session** | `docs/claude-session/11-design-step09-s15-jadwal.md` (written after approval) |

## Goal

Design the shared arrival slot picker (default) and the optional **per-unit split schedule**, with capacity made visible: available / limited / short / full / past / selected, and the "not enough capacity for N motors" recovery path (banner → split mode).

## Inputs

- `DateStripItem`, `SlotChip` (available / limited / short / full / selected), `BookingStepper` (step 3/4, phone + wide), `TsAppBar / Type=Step`, `SelectionFooter`, `Skeleton`, `TsDialog` (exit), `VehicleTabChip` rail-row (S11), `EmptyState`.
- PRD 03 rules: slots 08.00–16.00 hourly, D+0 (if ≥ 2 h from now) → D+14; `limited` when remaining ≤ 2; `full` when `booked ≥ capacity`; shared mode needs capacity ≥ units; split mode validates each unit's slot (see decision 6: siblings counted).
- Step 08 hand-off: S14 in-flow CTA "Pilih bengkel ini" / "Lanjut ke jadwal" → S15; every demo workshop closes ≥ 17.00, so the 08.00–16.00 grid is valid for all of them. Workshop context = Bengkel Jaya Motor (2 bay).
- Step 04 decision 13: `short` = remaining < unit count (disabled, icon + caption).

## Kickoff decisions (answered 2026-09-24, interview with the user)

Three `AskUserQuestion` rounds (12 questions) plus defaults found while planning. Every recommended option was accepted; question 11 (extra frames) had no marked default, so the recommended set was applied on the user's "pick recommended".

| # | Topic | Decision |
|---|---|---|
| 1 | Tablet-L date control | **2-week calendar grid**: 7 cols × 3 rows, weekday header Sen–Min, D+0 in its weekday column, blanks outside D+0…D+14. New grid variant of `DateStripItem` + `DateGrid`. Phone and Tablet-P keep the horizontal strip |
| 2 | Split layout | Phone + Tablet-P: **`UnitSlotSection` accordion**, one open at a time; collapsed row = motor + chosen slot, or "Pilih jam". Tablet-L: **unit rail** (S11 rail-row, shows each unit's chosen slot) + date grid + slot grid |
| 3 | Workshop context | New compact **`WorkshopSummaryRow`** on top: "Bengkel Jaya Motor · 2 bay servis · Ubah" (Ubah → S13). PRD 04 S15 lists none; added because capacity is workshop-specific |
| 4 | Footer | Reuse **`SelectionFooter`** (flat, no glass; S10 / S14 recipe). Shared recap "Sel, 29 Sep 2026 · 09.00"; split "2 dari 3 motor terjadwal"; disabled adds a reason line |
| 5 | Capacity banner | **Derived + escalating.** Shown above the slot grid whenever the selected day has ≥ 1 `short` chip. **Info** tone "Beberapa jam hanya muat 1–2 motor" when other slots still fit; **warning** tone "Kapasitas tidak cukup untuk 3 motor" when no slot fits. Action "Pisah jadwal" turns split mode on. Disabled chips never carry the message alone (Flutter disabled controls take no taps, screen readers skip them) |
| 6 | Split capacity math | **Count siblings.** A chip's remaining = slot remaining − units already placed on it; chips update live. Deviates from PRD 03 ("validated independently, capacity ≥ 1"), which allows 3 motors on a 1-seat slot → PRD 03 fixed in step 19 |
| 7 | Mode switching | **Non-destructive.** Draft keeps the shared slot and the per-unit slots separately; only the active mode counts. No dialog, nothing cleared |
| 8 | Chip caption | **"Sisa 2 motor"** (limited) / **"Sisa 1 motor"** + icon (short) / **"Penuh"** (full). Capacity counts motors per hour. Amends the step 04 `SlotChip` masters (closes the step 04 LOW "Sisa n") |
| 9 | Demo today | **Sen 28 Sep 2026, now 10.20.** Strip D+0 = Sen 28 Sep … D+14 = Sen 12 Okt (spans two months); the canonical slot Sel 29 Sep · 09.00 is the 2nd strip item; the calendar grid is exactly 3 rows from the Sen column |
| 10 | D+0 rule | Slots earlier than now + 2 h show **disabled "Lewat"** (Full recipe, label override, no new master) + helper "Booking hari ini minimal 2 jam sebelum jam datang." + one dedicated phone frame |
| 11 | Extra frames | **Expanded 1024×768** shared populated · **Split all complete** (Lanjut on) · **Split sibling conflict**. Skipped: all-full day on tablets. Trim at review if unwanted |
| 12 | Stress | Shared populated at 360×640 and text ×1.3, **plus split mode at ×1.3** → 3 stress frames |

**Found while planning** (defaults applied without a question; change at review if unwanted):

- **`limited` vs `short` precedence.** PRD 03 says limited = remaining ≤ 2 and shared needs remaining ≥ units, so for 3 units `limited` can never appear (≤ 2 < 3 is already `short`). Rule: **`short` (remaining < units) > `limited` (remaining ≤ 2) > `available`**. `limited` shows in split mode (each unit needs 1 seat) and for 1–2-unit bookings. PRD 03 wording fixed in step 19.
- **`TsSwitch` moves from step 18 to this step** (the "Pisah jadwal per motor" toggle needs a switch; precedent: `TicketUnitRow` 11 → 04). Step 18 instances it.
- **`CapacityBanner` is built generic** (Tone = Info / Warning, icon + text + action) so step 10 reuses it for the S16 "slot became invalid" banner.
- Slot grid = **3 columns on every breakpoint** (9 hourly slots = 3 × 3); chips hug their height so a two-line caption survives text ×1.3.
- Choosing another date **clears the shared slot** (explicit re-pick; Lanjut disabled with the reason line). Split sections clear the same way.
- Month: each strip item carries its month in the caption line ("Sep" / "Okt"), so the strip needs no extra caption; the calendar-grid panel header carries the range **"Sep – Okt 2026"** (corrected in the review, the plan first had one caption above the strip). Selected-date heading in PRD format "Sel, 29 Sep 2026".
- Loading = real app bar + stepper + workshop row + strip, toggle disabled, slot grid = 9 `Skeleton` chips, footer CTA disabled. Static shimmer + note; reduce-motion = no shimmer.
- All-full day = `EmptyState`-style block, icon only (illustration budget 11 / 11 spent, no `Generate`): "Semua jam penuh" + "Coba tanggal lain — masih ada jam kosong di hari berikutnya." + CTA **"Lihat Jum, 2 Okt"** (next day with a slot that fits all 3 motors). "jam" is the UI term everywhere (chips, footer, banner); "slot" stays in the docs only (review fix).
- Simulated network error = annotation only (Mode Demo, as in step 08). One session, one review gate.
- Tablet frames are fixed viewports (no status / gesture bar), no `NavBar` / `NavRail` (step 06 / 07 pattern). Close (✕) → exit dialog under the ≥ 1-selection rule (S15 always has ≥ 1 selection, so it always shows).

## Demo data

Capacity **5 motors per hour** (mock), Bengkel Jaya Motor, 3 motors (Vario 125 `AB 1234 XY`, Beat 110 `AB 5678 ZZ`, PCX 160 `AB 9012 QR`).

**Sel 29 Sep 2026** (canonical, populated):

| Hour | Booked | Left | Shared (3 motors) | Split — Beat, after Vario took 09.00 |
|---|---|---|---|---|
| 08.00 | 1 | 4 | available | available |
| 09.00 | 1 | 4 | **selected** (canonical) | Vario ✓ · Beat sees 3 left → available |
| 10.00 | 3 | 2 | short "Sisa 2 motor" | limited "Sisa 2 motor" |
| 11.00 | 4 | 1 | short "Sisa 1 motor" | limited "Sisa 1 motor" |
| 12.00 | 5 | 0 | Penuh | Penuh |
| 13.00 | 2 | 3 | available | available |
| 14.00 | 3 | 2 | short | limited |
| 15.00 | 1 | 4 | available | available |
| 16.00 | 5 | 0 | Penuh | Penuh |

3 short chips → the info banner is on the default populated frame (decision 5).

| Day | Purpose | Data |
|---|---|---|
| Sen 28 Sep (Hari ini, now 10.20) | D+0 rule | 08–12 "Lewat"; 13 available (3 left); 14 short (2 left); 15 available (4 left); 16 Penuh. Nothing selected, Lanjut disabled |
| Sel 29 Sep | Shared populated, split | table above |
| Rab 30 Sep | Insufficient capacity (warning banner) | 08 left 2 · 09 left 1 · 10 Penuh · 11 left 2 · 12 Penuh · 13 left 1 · 14 left 2 · 15 Penuh · 16 left 1 → every slot short or full |
| Kam 1 Okt | All full | 9 × Penuh; CTA "Lihat Jum, 2 Okt" |
| Sibling conflict | Split, Sel 29 Sep | Vario ✓ 11.00 (took the last seat) → Beat sees 11.00 "Penuh" + row "11.00 sudah dipakai Vario 125" |

Split "one unit complete": Vario ✓ Sel 29 Sep · 09.00 (collapsed row), Beat expanded (date Sel 29 Sep, no slot yet), PCX collapsed "Pilih jam". Split "all complete": Vario 09.00, Beat 10.00, PCX 13.00 → "3 dari 3 motor terjadwal", Lanjut enabled.

## Scope

### Frame matrix (27 frames)

| State | Phone | Phone·D | Tab-P | Tab-P·D | Tab-L | Tab-L·D | Other |
|---|---|---|---|---|---|---|---|
| Loading (slot grid skeleton) | ✔ | ✔ | ✔ | | ✔ | | |
| Shared — populated (Sel 29 Sep, 09.00 selected, info banner) | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | **Expanded 1024×768** (light) |
| Shared — insufficient capacity (Rab 30 Sep, warning banner, Lanjut disabled) | ✔ | ✔ | ✔ | | ✔ | | |
| Split — Vario ✓, Beat open | ✔ | ✔ | ✔ | | ✔ | | |
| All slots full (Kam 1 Okt) | ✔ | ✔ | | | | | |
| D+0 "Hari ini" (Sen 28 Sep, "Lewat") | ✔ | | | | | | |
| Split — all complete | ✔ | | | | | | |
| Split — sibling conflict | ✔ | | | | | | |
| Stress | | | | | | | 360×640 shared · ×1.3 shared · ×1.3 split |

Count: 4 + 6 + 4 + 4 + 2 + 1 + 1 + 1 + 1 (Expanded) + 3 = **27**. Naming: `S15 Pilih Jadwal / Shared Populated / Phone`, `… / Phone · Dark`, `… / Tablet-Portrait`, `… / Tablet-Landscape`, `… / Expanded`, `S15 Pilih Jadwal / Split One Complete / Phone`, `… / Stress ×1.3 / Split`. Phone frames are full-scroll captures (Loading and All-full fixed 800).

### Layout targets (PRD 06 + kickoff)

- **Phone 360** (margins 16): status bar + `TsAppBar / Type=Step` "Pilih jadwal" (back + close) + `BookingStepper` step 3 ("Langkah 3 dari 4 · Bengkel & Jadwal") + `WorkshopSummaryRow` + `ScheduleModeToggle` + date strip (month in each item caption, scroll cue, snap) + selected-date heading + banner / helper + 3 × 3 slot grid (+ sibling / D+0 helper row) + flat `SelectionFooter` above the gesture inset. Split: the toggle stays on; strip + grid live inside each `UnitSlotSection`.
- **Tablet-P 800×1280:** full-width app bar + wide stepper centered 720; content centered 720; same order, wider chips; split = accordion at 720.
- **Tablet-L 1280×800, shared:** margins / gap 24 · left column **480** (workshop row, toggle, calendar grid) · right column **728** (heading, banner, slot grid, footer pinned at the pane bottom). **Split:** 24 · unit rail **240** · 24 · date grid **420** · 24 · slots **524** · 24.
- **Expanded 1024×768:** 24 · left **400** · 24 · right **552** · 24 (same shape as S13). Calendar cells 48 dp (≥ 360 needed inside the 368 usable width; tight, verified by read-back).
- Chips ≥ 48 dp tall; every state carries icon / caption, never color alone; no fixed-height box around text.

### Components / illustrations to build

New sheet "Schedule" (x 30808, light y 8760, dark copy below it; S13 / S14 blocks ended at 29448 + 1360). No illustration.

| Component | Notes |
|---|---|
| `TsSwitch` (moved from step 18) | Off / On / Disabled; 48 dp target around the track; focus ring by override; Flutter = themed `Switch` |
| `ScheduleModeToggle` | Off / On; label "Pisah jadwal per motor"; helper Off "Semua motor datang di jam yang sama.", On "Atur jam datang untuk tiap motor."; whole row is the target |
| `WorkshopSummaryRow` | Workshop name (ellipsis) · "2 bay servis" · "Ubah" text action (48 dp) |
| `CapacityBanner` | Tone = Info / Warning; leading icon + title + optional body + action; reused by step 10 |
| `UnitSlotSection` | Collapsed-Incomplete / Collapsed-Complete / Expanded; ✓ / ○ glyph, nickname + plate (ellipsis), chosen slot "Sel, 29 Sep · 09.00" or "Pilih jam"; Expanded holds the strip + grid |
| `DateStripItem` grid variant + `DateGrid` | Cell states default / selected / today / today+selected / outside-range (blank); weekday header row; same selected recipe as the strip item (`accent-soft` + 2 px `border-accent`) |
| `SlotChip` (amended) | Caption text "Sisa n motor" on limited / short; `Lewat` = Full master with label override (verify the master exposes label + icon nodes; if not, add a Past master and log it) |
| Reused | `TsAppBar / Type=Step`, `BookingStepper` (phone + wide), `SelectionFooter`, `VehicleTabChip` rail-row (Tablet-L split: needs a slot line; if the master has no room, add a rail + slot variant and log it under Inventory additions), `Skeleton`, `TsDialog` exit, `EmptyState` (all-full, icon only) |

### Content & copy

- Title "Pilih jadwal"; stepper "Langkah 3 dari 4 · Bengkel & Jadwal"; calendar panel header "Tanggal kedatangan" + "Sep – Okt 2026"; heading "Sel, 29 Sep 2026" + caption "Jam datang untuk 3 motor". Date format `EEE, d MMM yyyy`, time `09.00`.
- Banners: Info "Beberapa jam hanya muat 1–2 motor" + action "Pisah jadwal". Warning "Kapasitas tidak cukup untuk 3 motor" + body "Tidak ada jam kosong yang muat semua motor hari ini." + action "Pisah jadwal per motor".
- Chips: available = time only; limited "Sisa 2 motor"; short = icon + "Sisa 1 motor"; full "Penuh"; past "Lewat"; selected = selected recipe (+ ✓).
- D+0 helper "Booking hari ini minimal 2 jam sebelum jam datang."; sibling row "11.00 sudah dipakai Vario 125".
- Footer recap: shared "Sel, 29 Sep 2026 · 09.00"; split "1 dari 3 motor terjadwal" / "3 dari 3 motor terjadwal". Reasons: "Pilih jam kedatangan" · "Tidak ada jam yang muat 3 motor" · "Pilih jam untuk Beat 110". CTA "Lanjut".
- All-full: "Semua jam penuh" / "Coba tanggal lain — masih ada jam kosong di hari berikutnya." + "Lihat Jum, 2 Okt".

### Annotations to place

- `short` > `limited` > `available` precedence; capacity counted in motors; `full` when `booked ≥ capacity`; split counts sibling picks.
- D+0 cutoff (now + 2 h); date change clears the shared slot; mode toggle keeps both drafts.
- Banner is derived from the day's chips; action focus order; disabled chips are not the only carrier of the reason.
- Date strip scroll / snap + visible scroll cue; calendar grid keyboard order (row-major).
- Race case: slot fills while the user is on S15 / S16 → re-validated on S16 (step 10), same banner component.
- Semantics: "09.00, tersedia" · "10.00, sisa 2 motor, terbatas" · "10.00, hanya muat 2 motor, tidak bisa untuk 3 motor" · "12.00, penuh" · "08.00, lewat"; switch "Pisah jadwal per motor, aktif / nonaktif".
- Simulated network error via Mode Demo (annotation only); keyboard N/A.

## Built (node ids, `design/pencil/TumbasServis.pen`)

Sheet **"Components / S15 Blocks"** `FP9V3` (x 30808, y 8760, 1200 × ~2,000 dp) with dark copy `kHMYt` (y 12380): `TsSwitch` ×4 (Off `lhia5` / On `M9uTa` / Disabled `zSGbW` / Disabled On `VXBrf`), `ScheduleModeToggle` ×2 (`N5xNs` / `TyPDO`), `WorkshopSummaryRow` `okLzp`, `CapacityBanner` Info `Rg4rc` / Warning `jsn9r`, `DateGridCell` ×5 (`CrE25` `oMQ6Q` `cks9R` `vw6rA` `zRwhR`), `DateGrid` `GDeP4` (Sen 28 Sep … Sen 12 Okt, 7 × 3), `UnitSlotSection` ×3 (`E62zmN` Collapsed Incomplete, `r64QOX` Collapsed Complete, `amYOh` Expanded, slot `rLGWS`), `DateStrip` `z2Qsb` (15 items, 24 dp fade), focus specimens section `c59Zq`. `SlotChip` Limited / Short captions amended (`gUTUy` "Sisa 2 motor", `x0IXC` "Sisa 1 motor"); the four step 04 sheet overrides updated (`n57YgG` `n8nJg7` `YvwcW` `iuPbJ`); `SlotChip` masters got 6 dp side padding and a fill-container status row so the caption wraps instead of clipping at text ×1.3.

The **Flows – Tablet block moved down 3,000 dp** (72 root nodes, anchor now y 38000). Frames (27), all named `S15 Pilih Jadwal / <State> / <Breakpoint>`:

| Row | Frames (node id) |
|---|---|
| Phone light, header `n1RxpB` (y 33300), frames y 33486 | Loading `N1qwZb` · Shared Populated `cZkON` · Shared Insufficient `k1jUlV` · All Full `fFlo7` · D+0 Lewat `i6kQrm` · Split One Complete `OTfUk` · Split All Complete `zVXtG` · Split Sibling Conflict `j4COcK` · Stress 360×640 `HgyZO` · Stress Text ×1.3 `fNgNv` · Stress Text ×1.3 Split `GheTy` · notes `xQw1b` (5 notes) |
| Phone dark, header `h7dVIg` (y 35300), frames y 35486 | Loading `X3a5vr` · Shared Populated `HLk4b` · Shared Insufficient `RH1gq` · All Full `mkptR` · Split One Complete `G67Ri` |
| Tablet-Portrait, header `kbcfX` (y 55000), frames y 55186 | Loading `k4EJ5` · Shared Populated `tYhLU` · Shared Insufficient `L1rLZ` · Split One Complete `fAceO` · Shared Populated Dark `W26Ig` · notes `CYu2r` |
| Expanded, header `n9idZ` (y 56700), frame y 56886 | Shared Populated `UbSyr` · notes `OswHO` |
| Tablet-Landscape, header `bZTWy` (y 57900), frames y 58086 | Loading `f03lft` · Shared Populated `BN16k` · Shared Insufficient `ncZIw` · Split One Complete `mdpKi` · Shared Populated Dark `wlyQ2` · notes `muC2a` |

Build decisions made while building (all inside the kickoff decisions unless marked):
- **Frame builder pasted per call** (globals do not persist); chip states derive from one `stateOf(left, units, selected, past)` function, so the slot table and the refs cannot drift.
- **Split accordion body** = `Replace(instance + "/rLGWS", …)` with a 312 dp strip and the grid; a nested `ScheduleModeToggle` On is the split-mode header. Tablet-L split = rail 252 · calendar 420 · slots 512 (kickoff said 240 / 420 / 524; the S11 rail-row master is 252 wide, so the pane took the difference).
- **Tablet footers** = `SelectionFooter` with `Main Row` padding 40 (Tablet-P, aligned to the 720 column) / 24 (pane footers on Tablet-L and Expanded).
- **All-full** = icon tile (`event_busy`) + title + body + tonal "Lihat Jum, 2 Okt"; no `Generate`.
- Tablet-L **loading** keeps the calendar grid real and skeletons only the slot grid.
- **Stress 360×640** = clipped `Scroll Body` (`fill_container`, footer stays above the gesture bar); its `Slots Block` reads "partially clipped" by design (scroll).
- **Float-epsilon clip flags** (`400.00000000000006 + 48`, three chips at `221.333…`) appear on Tablet-L shared / insufficient frames and one calendar weekday label; exact bounds read back as fitting, no real clipping.

## Checklist

### Build
- [x] Kickoff questions answered (12 decisions above).
- [x] Doc edits recorded (this file, `00-index.md`, `19-full-app-audit.md`, notes in steps 04 / 10 / 18).
- [x] "Schedule" sheet built (light + dark copy), tokens + instances only.
- [x] All 27 matrix frames built; dark copies built.
- [x] Slot states (available / limited / short / full / past / selected) distinguishable without color (caption, icon, shape).
- [x] Insufficient-capacity banner + split toggle interaction annotated.
- [x] Tablet-L side-by-side uses the calendar grid; split uses the unit rail.
- [x] Stress frames built and clean.
- [x] Demo content consistent with `00-index.md` (slot, units, plates, workshop).

### Quality (automated, run in `execute`)
- [x] Clipping check on every step frame and both sheets → zero real `problems` (exempt by name: `Item …` / `Cell …` strip scroll items, `Scroll Fade`, disabled subtrees, the stress 360×640 scroll body; float-epsilon flags documented above).
- [x] Raw-hex audit (without `resolveInstances`) → 0 of 1,020 nodes. (A first run with `resolveVariables` printed 5,730 resolved hexes, an artifact of resolving; do not audit hex that way.)
- [x] Every node named (0 unnamed, 0 unnamed refs after the dark-copy rename loop); `placeholder` cleared on 28 roots.
- [x] Coverage script: 27 frame names match the matrix.
- [x] Targets ≥ 48 × 48 dp on 913 interactive nodes (SlotChip, strip item, calendar cell, switch, toggle, links, CTA, rail, section header) → 0 under.
- [x] Contrast on resolved values, 2,729 text + icon nodes over frames and sheets → 2 rows, both the check glyph of the **disabled** switch (2.37 light / 1.89 dark; disabled controls are exempt, the state also reads from the thumb position and the muted track).
- [x] **State-vs-rule audit:** 189 chips over 22 frames recomputed from the slot table, unit count and sibling picks (`short` > `limited` > `available`, past, selected) → 0 state mismatches, captions match ("Sisa n motor" / "Penuh" / "Lewat" / "Dipilih"), 0 wrong times; banner tone matches the chips on every shared frame (Info while some slot fits, Warning when none); footer variant matches the gate on all 27 frames (Lanjut on only with a shared slot or all 3 units scheduled); recap counters read "Sel, 29 Sep 2026 · 09.00" / "1 dari 3" / "3 dari 3 motor terjadwal".

### /better-interface
- [x] Run `/better-interface` with scope = all S15 frames + sheets (names + node ids).
- [x] Report recorded below; HIGH / MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [x] Status set to 🔵; user shown: shared populated (info banner), warning banner, split (phone + Tablet-L rail), calendar grid, D+0 "Lewat", sibling conflict, dark.
- [x] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [x] PNG export to `design/pencil/exports/step09/` + `INDEX.md` (27 frames + 2 sheets, 29 PNG, `ls` shows 30 files with the index).
- [x] Claude session file written (`docs/claude-session/11-design-step09-s15-jadwal.md`).
- [x] Tracker set to ✅.

## /better-interface report

**Scope:** all 27 `S15 Pilih Jadwal / …` frames (ids in *Built*) + `Components / S15 Blocks` `FP9V3` and its dark copy `kHMYt` · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens, Flutter target (semantics via notes) · **Convention docs found:** 00-index.md, prd/02, prd/03, prd/06, steps 04 / 08 review reports (same class of findings, used as precedent). Web-only rules (`prefers-reduced-motion` CSS, `<label for>`) mapped as in 00-index.

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | Focus specimens for every keyboard-reachable S15 control; semantics / live-region notes; 913 targets ≥ 48 dp; color-only states (chip icon + caption + border, banner icon + title, accordion glyph); reduced-motion note; ×1.3 and 360×640 stress | 1 HIGH, 1 MEDIUM (both fixed) |
| Layout | Grouping and edges on phone / Tablet-P / Tablet-L / Expanded; scroll cues (strip fade, accordion chevron); pane geometry; footer alignment; stress clipping | 1 LOW |
| Writing | Every label vs action, terminology ("jam" vs "slot"), sentence case, verb-first actions, errors name the fix, empty state points forward | 1 MEDIUM (fixed), 1 LOW |
| Typography | Role sizes on new nodes (weekday header, captions), wrap behavior at ×1.3, line-height, no fixed-height text boxes | 1 MEDIUM (fixed), 1 LOW carried |
| Color | Contrast script over 2,729 text / icon nodes, both themes; one meaning per color; one filled action per view; state colors vs meaning | 1 LOW |
| UI | Concentric radii, icon weights, disabled recipes, state cues without motion, dark copies | 1 MEDIUM (fixed), 1 LOW |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| HIGH | Accessibility | Sheet `FP9V3`: `SlotChip` `mONRh` `i7C4p` `lgGhs` `IKMKa`, `DateStripItem` `x709g` `f6Q0c`, `DateGridCell` `CrE25` `oMQ6Q`, `UnitSlotSection` `E62zmN` `amYOh`, `ScheduleModeToggle` `N5xNs` `TyPDO` | keyboard / switch-access controls on tablet (9 chips, 15 date cells, 3 accordion headers, the toggle) with no designed focused state (only `TsSwitch` had a ring) | Focus specimens section `c59Zq` (light) and dark copy: 2 dp `focus-ring` outside the border, 2 dp offset, radius = inner + 4, for chip available / selected / short, strip item default / selected, calendar cell default / selected, section header, toggle | Escalation trigger: a keyboard-reachable control with no visible focus indicator; the same class as the step 04 HIGH (rails, cards) |
| MEDIUM | Accessibility | S15 Handoff Notes · Phone `xQw1b` | Notes covered chips, banner, split, date / motion, but not the date cells, the switch, the accordion state or the live region | Fifth note `AlAfU` "Semantics (Flutter)": date item / cell labels with `selected`, grid focus group and arrow keys, switch name + value, accordion header state, banner as polite live region, disabled Lanjut keeps its reason line, back / close labels | Every control announces name, role and state; handoff must say how |
| MEDIUM | Writing | All Full · Phone `fFlo7` and dark `mkptR` (`Empty Title`) | "Semua slot penuh" beside "Pilih jam", "Belum ada jam dipilih", "Tidak ada jam yang muat 3 motor" | "Semua jam penuh" (docs updated in 09, 19) | One term for the same thing; "slot" is a system word, "jam" is what the chips show |
| MEDIUM | Typography | `DateGrid` `GDeP4` weekday header (`ujsEL` `Qvd2K` `DmqCg` `UYjKO` `w8pVO9` `L1mibY` `qsU53`) | Label Small 11 px, while the strip's weekday (`DateStripItem`) is Label Medium 12 px | Label Medium (`type-label-md-*`) | Sibling date components share one weekday role; ≥ 12 px for column headers |
| MEDIUM | UI | `WorkshopSummaryRow` `okLzp` › `Icon Tile` `WyfWQ` (every screen instance) | `radius-md` 12 inside a `radius-lg` 16 card with 8 dp padding | `radius-sm` 8 (concentric = 16 − 8) | Same class as the step 04 MEDIUM: outer = inner + padding |
| MEDIUM | Writing | Calendar panels on Tablet-L / Expanded (6 frames, `Date Panel Header`) | Month only on the "1 Okt" cell; 28 – 30 Sep cells and the panel gave no month | Panel header "Tanggal kedatangan" + "Sep – Okt 2026" (`Month Range`); the strip keeps the month in each item caption; docs corrected | The range spans two months; the recorded decision promised a month cue |
| LOW (left) | Layout | Shared frames on Tablet-L `f03lft` `BN16k` `ncZIw`, Expanded `UbSyr` | Left column ends ~ 240 dp above the pane bottom (calendar shorter than the slot pane) | Balance in step 19 (e.g. helper text or the recap under the calendar) | Shared edges and balance; repeat of the step 07 / 08 LOW |
| LOW (left) | UI | `UnitSlotSection / State=Expanded` `amYOh` bodies (phone, Tab-P) | Chips and strip items (`radius-md` 12) inset 8 dp inside a `radius-lg` 16 card (concentric 8) | Local `radius-sm` overrides, or a 12 dp body padding once the chip caption fits 96 dp | 4 dp delta; shared component radius kept for consistency across screens |
| LOW (left) | Color | `WorkshopSummaryRow` icon tile (`accent-soft` + `text-on-accent-soft`) | Static tile in the selected-state recipe on a screen whose selected chip / date use the same fill | `surface-inset` tile, `text-body` icon | One color, one meaning; same LOW as the step 04 promo icon disc |
| LOW (left) | Typography | `SlotChip` status caption, `DateStripItem` / `DateGridCell` caption lines | Label Small 11 px | Decide with the type scale in step 19 | Already open from steps 03 / 04 |
| LOW (left) | Writing | D+0 Lewat `i6kQrm` footer | "Belum ada jam dipilih" over "Pilih jam kedatangan" says the same twice | Reason names the cause only; same pattern as the approved S10 footer, decide in step 19 | Delete words that do no work |

**Verification:** passed — coverage script (27 names vs the matrix); clipping on 27 frames + 2 sheets (0 real; float-epsilon flags documented); raw hex 0 / 1,020 nodes; unnamed 0; placeholders 0; targets 913 / 0 under 48 dp; contrast 2,729 nodes, 2 rows (disabled switch check, exempt); state-vs-rule audit 189 chips / 0 mismatches, banner tone and footer gate consistent on all frames; screenshots of every frame group (phone light / dark, Tablet-P, Tablet-L, Expanded, stress ×1.3, specimens, both sheets). **Not verified:** Flutter rendering of focus rings, live-region announcements, switch and accordion semantics, snap scrolling and real 150 / 250 ms motion (notes only); screen-reader pass; RTL and 200 % zoom (×1.3 stress only); html2figma output (not exported until step 12).
**Verdict:** Approve
**Fixes applied:** the HIGH and five MEDIUM above (specimens, semantics note, "Semua jam penuh", weekday role, icon tile radius, calendar month range) · **LOW left for user:** Tablet-L left-column balance, nested radius in the expanded section, icon tile color, Label Small 11 px, D+0 footer wording

## Review rounds

#### Round 1 — 2026-09-24
- **Frames shown:** shared populated (info banner), insufficient (warning banner), split (phone + Tablet-L rail), calendar grid, D+0 Lewat, sibling conflict, dark, stress; the sheet with focus specimens.
- **User feedback:** "approve"
- **Changes made:** none.
- **Outcome:** approved.

## Session log

| Time | Action | Result / node ids |
|---|---|---|
| 2026-09-24 | Kickoff | Read `00-index`, steps 04 / 08 files, PRD 03 / 04 / 06. Three `AskUserQuestion` rounds (12 questions), all recommended options accepted; question 11 applied as the recommended set. Found while planning: `limited` / `short` precedence, `TsSwitch` moved from step 18, `CapacityBanner` reuse in step 10. Kickoff recorded in this file, `00-index.md`, `19-full-app-audit.md` before any Pencil edit |
| 2026-09-24 | Components | Sheet `FP9V3` built (switch ×4, toggle ×2, summary row, banner ×2, calendar cell ×5, date grid, section ×3, strip); `SlotChip` captions "Sisa n motor"; Flows – Tablet block moved down 3,000 dp |
| 2026-09-24 | Phone frames | Light row (8 states + 3 stress) `n1RxpB`, dark row (5) `h7dVIg`; chips fit at 99 / 104 dp; Loading / All Full sized to fit |
| 2026-09-24 | Tablet frames | Tablet-Portrait (4 + dark), Expanded (1), Tablet-Landscape (4 + dark); footers aligned to 40 / 24 dp; dark copies renamed (0 unnamed) |
| 2026-09-24 | Stress + notes | ×1.3 shared (84 text nodes) and split (87); 360×640; handoff notes for phone (4), Tablet-P, Expanded, Tablet-L; note heights set from bounds |
| 2026-09-24 | Automated checks | Coverage 27 / 27; clip, hex, unnamed, placeholders, targets, contrast, state-vs-rule audits as listed in the checklist |
| 2026-09-24 | `/better-interface` | 1 HIGH + 5 MEDIUM fixed (focus specimens, semantics note, "Semua jam penuh", weekday role, icon tile radius, calendar month range), 5 LOW left; dark sheet re-copied (19 refs renamed); verdict Approve |
| 2026-09-24 | Review gate | Status 🔵; frame list, deviations (rail 252 / 420 / 512, month range on the calendar) and the info banner on the default frame flagged; user replied "approve" |
| 2026-09-24 | Close | PNG export of 27 frames + 2 sheets to `design/pencil/exports/step09/` with `INDEX.md`; session file `11-design-step09-s15-jadwal.md`; tracker ✅; Pencil facts and canvas layout added to `00-index.md` |
