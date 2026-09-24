# Step 19 — Full-app audit

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | — (gate before Figma conversion) |
| **Owns screens** | — |
| **Owns components** | — |
| **Reviews** | All 26 screens (S01–S26), all components, all tokens |
| **PRD refs** | [02 inventory + Figma doc spec](../../../prd/02-brand-design-system.md), [04 screen inventory](../../../prd/04-screens.md), [06 device matrix](../../../prd/06-responsive-layout.md), [08 B1–B5](../../../prd/08-deliverables-acceptance.md) |
| **Pen location** | Whole document; refresh `P0 Flow Board` |
| **Depends on** | Steps 01–18 |
| **Claude session** | `docs/claude-session/21-design-step19-full-app-audit.md` (written after approval) |

## Goal

Verify the finished Pencil design is **complete, consistent and convertible** before it is copied into Figma: every PRD screen/state/breakpoint exists, tokens are the only source of color/type/space, the component inventory matches the PRD (plus documented additions), and the PRD is updated to match design decisions made along the way.

## Inputs

- All steps' matrices and Session logs; the index's *Inventory additions* list.
- PRD 02 inventory (28) and PRD 04/06 screen and layout tables.

## Open questions (ask at kickoff)

1. Which PRD edits does the user want applied now (token divergences from step 02, `TsDialog`/`TsSnackbar` and other inventory additions, price set, and the Starter dark-mode workaround if step 01 chose two collections)? Approve the exact diff list before editing `prd/`. The window-class wording in `prd/06` was already fixed in step 01.
2. Any frames the user wants dropped or added before conversion (each removed frame saves Figma effort).

### PRD 04 S05 corrections collected in step 05 (2026-09-24; apply in this step after approval)

- **Status label rule:** the active-booking card shows the unit status shared by most motors (ties → earliest stage) + a caption when units differ; the derived booking status `Berlangsung` (PRD 03) is not shown on the card.
- **Draft card:** title, motor summary, step X/4, expiry line (warning under 3 h), "Lanjutkan" + "Hapus draft" (confirm dialog); draft motors must be free (PRD 03 in-service rule).
- **Garage strip:** in-service motors carry a compact status badge; "Lihat semua" link; "+" tile.
- **Tablet app bar:** medium / large drop the logo (the rail carries it); greeting is the bar title.
- **Copy:** sentence case ("Mulai booking", "Garasi saya", "Katalog suku cadang"), as decided in step 03.
- **Demo content:** the Home populated state adds the sheet-only Supra X 125 (AB 3344 KL) as a 4th motor and the draft.
- **Promo carousel:** page dots only (non-interactive, "Promo 1 dari 3"); auto-advance 5 s stops on touch / focus / hover and with reduce-motion. A visible pause / play button was proposed by the step 05 review (WCAG 2.2.2) and declined by the user; PRD 04 S05 keeps the carousel as specified.
- **Draft card:** "Lanjutkan" is a Secondary (tonal) button so the filled primary stays on the booking CTA.
- **Tablet nav:** the medium / large app bar carries the greeting + bell without the logo (a `TsAppBar / Type=Title, Actions=Bell` master).

### PRD S10 / booking-flow corrections collected in step 06 (2026-09-24; apply in this step after approval)

- **PRD 04 S10 copy:** sentence case ("Pilih motor", "Lanjut"); the selection counter ("N dari 5 motor dipilih") lives in the sticky footer with a reason line ("Pilih minimal 1 motor" at 0, "Lepas satu untuk memilih motor lain" at 5), not in a header row; "+ Tambah motor lain" is an end-of-list card that stays enabled at max-reached; a motor added from S08 comes back available, not auto-selected (snackbar "Motor ditambahkan").
- **PRD 03 exit rule:** the exit-booking dialog ("Keluar dari booking? Draft akan disimpan.") appears only when the draft holds ≥ 1 selected motor; actions "Simpan & keluar" / "Lanjutkan booking"; discarding a draft stays on Home ("Hapus draft"). Empty-garage CTA text is "Tambah motor pertamamu" (PRD 03 edge case says "Tambah Motor").
- **PRD 06 S10 row:** large = 3-column grid (content max ~1040); the booking flow S10–S18 shows no `NavBar` / `NavRail` (focused flow).
- **Demo content:** S10 garage = 3 canonical + Supra X 125 + Ninja 250 (in service); max-reached specimen adds Scoopy 110.
- **Continuity check (audit track):** S05 populated (Vario / Beat / PCX in service) is the state after the S10 → S18 flow, not before it.

### PRD S11 corrections collected in step 07 (2026-09-24; apply in this step after approval)

- **PRD 04 S11 content:** Keluhan is a collapsed optional row ("+ Tambah keluhan (opsional)") that auto-opens and becomes required with Perbaikan/Keluhan (not "shown only if the selected service requires it"); "Salin dari" sits directly under the unit header; a unit with selections is removed through a destructive dialog, with a remove icon in the unit header (hidden with one unit); back → S10 keeps the draft, close → the exit dialog under the ≥ 1-selection rule. The wireframe "Est. Rp412.000 · 2j" becomes "Estimasi · 1 jam / Rp228.000" (live, everything selected so far); "Lanjut" is disabled with a reason line ("Pilih layanan untuk PCX 160") until every chip is ✓.
- **PRD 04 / 06 S11 tablet:** medium = chip row on top + form (max 720) + glass pill; expanded (840–1199) = unit rail 252 + form + pill; large (≥ 1200) = rail 252 · form 572 · live `EstimatePane` 360 (static per-unit lines, no voucher), 1 unit = form 720 + pane 360 centered. Rail rows = the phone chip states (glyph + nickname + plate / status). The wide stepper carries the "N/3 ✓" badge.
- **`prd/02` inventory:** add `EstimatePane`, `CopySourceSheet` (sheet + modal), `UnitHeader`, `CopyFromRow` / `CopyNote`, `ComplaintSection`, `TsAppBar` step variant, `System / Keyboard` (design-only); `VehicleTabChip` gains Active + Complete / Incomplete / Error.
- **Data (`services.json`):** three S11 services — Servis Berkala Rp85.000 · 60 mnt, Ganti Oli Rp35.000 · 30 mnt, Perbaikan/Keluhan Rp50.000 "estimasi awal" · 60 mnt (`requiresComplaint`); the two non-canonical prices are proposals.

### PRD S13 / S14 corrections collected in step 08 (2026-09-24; apply in this step after approval)

- **PRD 04 S13 content:** each `WorkshopCard` shows the bay count and "Estimasi N jam untuk M motor" (makespan of the draft's units over that workshop's bays); the chosen workshop carries a "Dipilih" tag; no sticky footer (the choice is committed from S14). Filters: "Buka sekarang" is an independent toggle, "Rating tertinggi" / "Terdekat" are mutually exclusive sorts (default Terdekat) with a result line "N bengkel · urut terdekat". Stepper caption "Langkah 3 dari 4 · Bengkel & Jadwal"; sentence case titles.
- **PRD 04 S14 / PRD 03 F2:** the CTA depends on the context — in-flow "Pilih bengkel ini" → S15 ("Lanjut ke jadwal" when the workshop is already chosen), standalone "Booking di sini" → S10 with the workshop carried and S13 skipped. S14 in the flow has no stepper (back + close). The standalone entry has no source screen in the PRD: it is the workshop row of S18 / S20 (added in steps 11 / 16).
- **PRD 03 (pricing & duration) / PRD 04 S11:** S11's duration is computed for a standard 2-bay workshop because no workshop is chosen yet; S13 shows the per-workshop makespan and S16 the final one. A workshop closed *now* is still bookable (slots 08.00–16.00 for D+0…D+14), so every workshop stays open through 17.00; "Buka sekarang" filters by the current time only.
- **PRD 05 `Workshop`:** add `reviewCount` (S14 "126 ulasan") and a structured `openHours` (open / close time) so the status line and the "Buka sekarang" filter are computed, not stored text.
- **PRD 06 S13 row:** Tablet-P = 1-col list (max 720); Expanded (1024) = list 400 + S14 pane 552; Large (1280) = list 440 + pane 768 with the CTA pinned at the pane bottom. Standalone S14 Large = photo + map left (560), info right (648).
- **`prd/02` inventory:** add `SearchBar`, `FilterChipRow`, `StaticMap`, `WorkshopPhoto`, `WorkshopInfoBlock`, `WorkshopDetailContent`, `WorkshopCtaBar`; `WorkshopCard` gains the estimate row and the "Dipilih" tag.
- **Demo content:** S13 workshop list is in the `00-index.md` demo table; `workshops.json` needs the five entries (bays 2 / 3 / 2 / 1 / 2, hours to 17.00 / 18.00 / 17.00 / 17.00 / 17.00, Cahaya closed now).

### PRD S15 corrections collected in step 09 (2026-09-24; apply in this step after approval)

- **PRD 03 scheduling / edge cases (split validation):** in split mode a unit's slot is validated against the seats left *after the other units' picks* (remaining = slot remaining − units already placed there), not "capacity ≥ 1" independently; otherwise 3 motors could be booked into a 1-seat slot. Chips update live; S16 still re-validates on entry.
- **PRD 03 scheduling (chip state precedence):** `short` (remaining < number of units, shared mode) > `limited` (remaining ≤ 2) > `available`. For a 3-motor shared booking `limited` never shows; it shows in split mode and for 1–2-unit bookings. Capacity counts **motors per hour** (`TimeSlot.capacity`), so the caption reads "Sisa n motor".
- **PRD 03 scheduling (D+0):** slots earlier than now + 2 h are shown disabled with "Lewat" (not hidden), with the helper "Booking hari ini minimal 2 jam sebelum jam datang."
- **PRD 03 / PRD 04 (mode switching):** the "Pisah jadwal per motor" toggle is non-destructive — the draft keeps the shared slot and the per-unit slots separately and only the active mode counts. Changing the date clears the shared slot.
- **PRD 04 S15 content:** adds a compact workshop row ("Bengkel Jaya Motor · 2 bay servis · Ubah" → S13), the month in each strip item caption (the calendar grid carries a "Sep – Okt 2026" range), a derived capacity banner (info / warning, action "Pisah jadwal"), a flat sticky footer with the slot recap ("Sel, 29 Sep 2026 · 09.00" / "n dari 3 motor terjadwal") and a reason line while Lanjut is disabled; all-full day = "Semua jam penuh" / "Coba tanggal lain — masih ada jam kosong di hari berikutnya." + a "Lihat <next day>" action (the UI says "jam", not "slot"). No "Konfirmasi" here; Lanjut → S16.
- **PRD 06 S15 row:** Phone / Tablet-P = horizontal date strip above the 3-column slot grid; Expanded (1024) = date grid 400 + slots 552; Large (1280) = 2-week calendar grid 480 + slots 728 (split: unit rail 240 · grid 420 · slots 524). Tablet-L date control = 7 × 3 calendar grid, weekday-aligned.
- **PRD 05 `TimeSlot` / mock data:** capacity 5 motors per hour in the demo; `getAvailableSlots(workshopId, date)` must return per-hour `booked` and `capacity`; the D+0 cutoff is computed from the clock, not stored.
- **`prd/02` inventory:** add `TsSwitch`, `ScheduleModeToggle`, `WorkshopSummaryRow`, `CapacityBanner`, `UnitSlotSection`, `DateGrid` (+ the grid variant of `DateStripItem`); `SlotChip` caption "Sisa n motor" and the "Lewat" label.

## Scope

### Audit tracks

| Track | Method | Pass criterion |
|---|---|---|
| Screen coverage | Script: expected frames (all matrices, PRD 04 states, PRD 06 rows) vs existing names | Zero missing; extras justified |
| Token integrity | Script over the whole document: fills/strokes/effects/gaps/paddings/radius/font size not bound to variables | Zero raw values (documented exceptions only, e.g. QR constants) |
| Component inventory | List reusable components vs PRD 02 (28) + additions; unused components; detached instances | Every PRD component present with listed variants; no unused; zero detached |
| Naming | Script: frame names match `S<id> <Name> / <State> / <Breakpoint>[ · Dark]`; every node named | Zero violations |
| Contrast | Script: resolved text/background pairs in light + dark | Text ≥ 4.5:1, UI ≥ 3:1, or documented decorative |
| Overflow | Clipping script over every root frame | Zero `problems` |
| Stress | Existence and cleanliness of 360×640 and ×1.3 frames for S05, S11, S16, S18 | Present + clean |
| Copy | Text-node scan: `Rp` format, dates, terminology, no lorem/placeholder | Zero violations |
| Continuity | Demo data (motors, plates, codes, totals) across S05/S10/S11/S16/S18/S20/S23 | Identical |
| Tablet | Every screen has PRD 06-conformant tablet frames | Per matrix |
| Dark | Every dark frame required by the rules exists and passes contrast | Per matrix |
| Figma compatibility | Check frames and components against the *Figma-plugin compatibility* rules in [`00-index.md`](00-index.md#figma-plugin-compatibility) (rules from the step 01 spike and the step 04 / step 12 test imports) | Zero violations |

### `/better-interface` runs (one per feature group — respects the skill's scope-narrowing rule)

| Run | Scope |
|---|---|
| A | Auth: S01–S04 |
| B | Shell + Home: S05, `AppShell`, `NavBar`/`NavRail` |
| C | Garage + Catalog: S07–S09, S12 |
| D | Booking core: S10, S11, S13–S18 (flow-level, complements step 12) |
| E | Tracking + Invoice + Review: S19–S24 |
| F | Notifications + Profile + Demo: S06, S25, S26 |

Each run: ≤ 15 findings, systemic root causes consolidated (token/component fixes outrank single-frame fixes); HIGH/MEDIUM fixed; LOW listed.

### Deliverables

- Audit report (tracks + `/better-interface` runs) in this file.
- PRD edit list applied after user approval (`prd/02` inventory + tokens + Figma dark-mode workaround, `prd/00` decision log; `prd/06` window classes already done in step 01).
- Refreshed `P0 Flow Board`; full-document PNG export set.
- Conversion manifest for step 20: component list with variants, style/variable list, screen list with node ids, plus the html2figma version and import options (Auto Layout on/off) that worked in the step 12 test import.

## Checklist

### Build
- [ ] Kickoff questions answered.
- [ ] All audit tracks run; failures fixed in the owning frames (logged against owning steps).
- [ ] Runs A–F done; consolidated findings recorded.
- [ ] PRD edits agreed and applied.
- [ ] Flow board refreshed from current frames.
- [ ] Conversion manifest written.

### Quality (automated, run in `execute`)
- [ ] Every script above re-run after fixes and reports zero violations.
- [ ] `placeholder` flags all cleared document-wide.

### /better-interface
- [ ] Runs A–F reports recorded below; all HIGH fixed; MEDIUM fixed; LOW listed; each verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: audit summary table, PRD diff list, conversion manifest, flow board.
- [ ] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] Full PNG export set to `design/pencil/exports/final/`.
- [ ] Claude session file written.
- [ ] Tracker set to ✅; decision log updated.

## /better-interface report

_Not run yet._ One block per run (A–F), using the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
