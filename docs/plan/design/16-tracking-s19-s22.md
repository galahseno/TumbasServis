# Step 16 — Tracking: S19 Riwayat · S20 Detail Booking · S21 Lacak Unit · S22 Ubah Jadwal / Batalkan

| | |
|---|---|
| **Status** | ✅ Done (2026-09-25) — rescue of the first build, see *Rescue (2026-09-25)* |
| **Priority** | P1 |
| **Owns screens** | S19, S20, S21, S22 |
| **Owns components** | `StatusTimeline`, `MechanicCard`; (screen-local, flag for `prd/02`): `BookingHistoryCard`, `UnitStatusRow`, `FleetProgress` (full), `CancelScopeChooser`, `DemoModeShortcut`, `HistoryTab` / `HistoryTabRow` |
| **PRD refs** | [04 S19–S22 + P2 extras](../../../prd/04-screens.md), [03 F3, F6, status machine, booking-status derivation](../../../prd/03-user-flows.md), [06 S19–S22 rows](../../../prd/06-responsive-layout.md), [02 status colors](../../../prd/02-brand-design-system.md) |
| **Pen location** | Flows – Phone rows S19–S22 (after S12, y 71,500 – 82,536); Flows – Tablet rows appended below S12 (y 144,400 – 155,900) |
| **Depends on** | Steps 02–05 (shell, `FleetProgress` mini), 09 (slot picker reuse), 17 (S20 → S24 gate) |
| **Claude session** | `docs/claude-session/18-design-step16-tracking.md` (written after approval) |

## Goal

Design post-booking: history, the booking hub with per-unit status, the per-unit live timeline (the assessment's pillar 4), and the modify/cancel sheets. Build `StatusTimeline` and `MechanicCard`, and make the status machine unmistakable without relying on color.

## Inputs

- `AppShell` (Riwayat tab), `UnitStatusBadge`, `TsChip`/tabs, `FleetProgress`, `PriceBreakdown`, S15 date/slot picker (reused inside the S22 sheet), `TsDialog`, `TsSnackbar`, `EmptyState`, `Skeleton`.
- Status machine: Terjadwal → Check-in/Antre → Diperiksa → Dikerjakan → QC → Selesai, with Dibatalkan from any pre-Selesai state. Booking status derived from units (Terjadwal / Berlangsung / Selesai / Dibatalkan). Cancel/reschedule only while `Terjadwal`.

## Kickoff decisions (answered 2026-09-25, interview with the user)

1. **Timeline anatomy (Q1):** Full — timestamps on done nodes, current node pulse ring + non-motion cue (bold label + "Sedang dikerjakan" caption), estimated-completion card pinned above the timeline, pending nodes muted label-only.
2. **S20 disabled actions (Q2):** actions stay visible, each with an inline reason line ("Sudah check-in — tidak bisa diubah/dibatalkan" · "Invoice tersedia setelah semua motor selesai"); matches the S09/S11 disabled-CTA pattern.
3. **S19 tabs (Q3):** tabs with counts — Mendatang 1 · Berlangsung 1 · Selesai 2 · Dibatalkan 1 (form amended in the rescue, decision 12).
4. **MechanicCard (Q4):** per unit (supports S24 per-mechanic rating). Avatar initial circle + name + rating ★ 4,8; not-yet-assigned variant (dashed avatar, "Montir belum ditentukan").
5. **S22 cancel (Q5):** centered `TsDialog` — title "Batalkan booking?", radio scope list (Seluruh booking — 3 motor / satu unit each), reason chips (Jadwal bentrok · Berubah pikiran · Harga tidak sesuai · Lainnya), danger "Ya, batalkan" + de-emphasized "Kembali".
6. **Mode Demo shortcut (Q6):** yes — labelled card at the bottom of S21 ("Mode Demo" header + "Majukan status" / "Reset"), visually separated from product UI.
7. **P2 "additional work found" card (Q7):** **cut** (P2 first to cut per the cut-line guidance; noted here as cut).
8. **S22 Ubah Jadwal sheet:** shared-slot picker only — S15 date strip + slot grid + `WorkshopSummaryRow` inside the sheet, current slot marked "Jadwal sekarang", flat footer "Simpan jadwal"; split-mode reschedule = annotation only.
9. **Concurrency (asked 2026-09-25):** step 15 (S12) ran in a second session on the same `.pen`; the first build put the Tracking blocks sheet at x 39016 and the phone rows at y 74,000, which the step 15 anchor move then left overlapping the tablet block (fixed in the rescue).

Demo content (canonical continuity, moment Sel 29 Sep 2026 10.20 — same as S05 populated / step-14 garage): S19 tabs hold `TS-260929-0417` Berlangsung (3 motor), `TS-261006-0419` Mendatang (Supra X 125 · Sel 6 Okt · 09.00), Selesai = `TS-260910-0091` + `TS-260714-0058`, Dibatalkan = `TS-260502-0031` (S09 history parity). S20 default = canonical booking Berlangsung (A Dikerjakan · B Dikerjakan · C Diperiksa); Terjadwal state = same booking rewound to Sen 28 Sep (actions enabled, base for both S22 sheets); Selesai state = all units Selesai with "Lihat invoice" + "Beri ulasan" + "Booking lagi". S21 live = unit B Beat 110, current Dikerjakan, ETA ±10.15, Mas Rudi ★ 4,8; completed = unit B end state; cancelled = `TS-260502-0031`. Chrome: S19 = `AppShell` (Riwayat), S20/S21 = `TsAppBar / Type=Back` only.

## Rescue (2026-09-25)

The first build (another model, no session log, no review) was audited read-only against S07 / S09 / S12 / S18 / S23 and repaired in place (node ids kept). Interview answers:

10. **Placement:** under the Flows anchors. Phone rows moved to y 71,500 (after S12); the whole Flows – Tablet block (anchor `URsZs`, ~200 roots incl. the step 16 tablet rows) shifted **+11,000** (anchor now y 83,500). Nothing at x ≥ 36,000 moved.
11. **Repair mode:** fix in place; dark frames deleted and re-copied from the repaired light frames (Pencil rule).
12. **S19 tabs:** scrolling **underline tabs** built from the `HistoryTab` / `HistoryTabRow` masters (label + count, 48 dp hit height, full-bleed row with the first label on the gutter, active tab scrolled into view, edge fade). Active = accent label + 3 dp indicator; weight is `semibold` for both states (Exo 2 has no 700; a weight cue would reflow the row) — deviates from decision 3's "weight 700".
13. **Review:** two gates. Gate 1 (phone repair + placement) approved 2026-09-25 ("Approve, do tablet"); gate 2 = tablet + `/better-interface`.
14. **S20 Selesai:** two frames — **Belum Lunas** (`Beri ulasan` disabled + reason "Tandai lunas di invoice dulu"; S24 hard gate from step 17) and **Lunas** (both enabled). "Lihat ulasan" after a review = annotation.
15. **S21 Tab-L right column:** ETA card + `MechanicCard` + `DemoModeShortcut` (no map; PRD 06 said "mechanic/map card"); left = unit header + timeline.
16. **S19 filtered by motor** (S09 "Lihat semua"): annotation only (dismissible motor chip, counts recompute).

What was wrong and is fixed:
- **Placement:** phone rows (y 74,000–85,036) overlapped the S05 / S10 / S11 / S13–S15 tablet rows; two row headers unnamed / mis-named.
- **S19:** `AppShell` slot was 240 dp high (gesture bar floating mid-screen), bare "Page Title" instead of `TsAppBar / Type=Title`, hand-built 48 dp pill chips.
- **S20–S22 phone:** gesture bar fixed at y 776 over taller full-scroll frames (now `H − 24`); unnamed Status Bar / App Bar refs; sheets floating 100 dp above the bottom (now bottom-anchored with the 24 dp gesture inset inside the sheet); Batalkan dialog children out of order (reason chips rendered under the buttons, wrong override keys made the chips invisible, 630 dp tall, no `TsDialog` radius / shadow).
- **Tablet:** Tab-P bodies left-aligned in an 800 dp frame (now centered at 720 / 640); app-bar title still the master default "Pilih motor"; the S22 modal used the phone sheet header (drag handle, bottom radius) instead of the modal `Title Row` (radius-xl, shadow, close); S19 Tab-L preview showed a Terjadwal booking beside a Berlangsung card.
- **Content:** "Ubah" link on the S20 workshop row (no workshop change in S20 → chevron row to S14 standalone); "Refund deposit Rp0" dropped (no deposits); scope copy "-A · Vario 125" → "Hanya Vario 125 · Unit -A"; Empty (Dibatalkan) frame had a CTA against its note; `UnitStatusRow` text column was 128 dp wide (2–3 line wraps, unequal rows) → badge on the name row, flat rows with dividers.

## Scope

### Frame matrix (as built)

| Screen · State | Phone | Tablet-P | Tablet-L | Dark |
|---|---|---|---|---|
| S19 Berlangsung (tab) | ✔ | ✔ | ✔ list-detail (S20 Berlangsung overview right) | all three |
| S19 Mendatang / Selesai / Dibatalkan | ✔ (3 frames) | — | — | — |
| S19 Empty (Dibatalkan, no CTA) · Loading | ✔ · ✔ | — | — | — |
| S20 Terjadwal (actions enabled) | ✔ | ✔ | ✔ overview left / units + actions right | all three |
| S20 Berlangsung (actions disabled + reason) | ✔ | — | — | phone |
| S20 Selesai Belum Lunas (`Beri ulasan` disabled + reason) | ✔ | — | — | phone |
| S20 Selesai Lunas | ✔ | — | — | — |
| S20 Dibatalkan · Loading | ✔ · ✔ | — | — | — |
| S21 Live (current = Dikerjakan, mechanic, ETA, Mode Demo) | ✔ | ✔ | ✔ timeline left / ETA + mechanic + demo right | all three |
| S21 Completed | ✔ | — | — | phone |
| S21 Cancelled · Loading | ✔ · ✔ | — | — | — |
| S22 Ubah Jadwal sheet (S15 picker) | ✔ bottom sheet | ✔ centered modal 560 | (same modal) | phone |
| S22 Batalkan dialog | ✔ 312 | ✔ 400 | (same dialog) | phone |
| S22 Loading / Error / Success snackbar | ✔ (3 frames) | — | — | — |

43 frames: 21 phone light + 8 phone dark + 8 tablet light + 6 tablet dark.

### Layout targets (PRD 06)

- S19: list with tabs → max 720 → list-detail split. S20: stacked → max 720 → overview left / units + actions right. S21: vertical timeline (max 640 on tablet) → timeline left / mechanic card right. S22: full-width bottom sheet → centered modal max 560.

### Components built here

| Component | Notes |
|---|---|
| `StatusTimeline` (owned, PRD 02) | Vertical stepper; nodes done / current / pending / cancelled; timestamps; icon + label per node; reveal motion 300ms staggered |
| `MechanicCard` (owned, PRD 02) | Avatar initial, name, rating; assigned / not-yet-assigned variants |
| `BookingHistoryCard` | Code, workshop, date, motor count, derived booking status badge (selected = `border-accent` override on Tab-L) |
| `UnitStatusRow` | Restructured in the rescue: `Text Column` = `Name Row` (unit name + badge) over meta; flat row with a bottom divider (`strokeWidth {bottom: 1}`); last row overrides `strokeWidth: 0`; overrides now keyed by name (`Unit Name`, `Unit Meta`, `Status Badge`) |
| `HistoryTab` / `HistoryTabRow` | Rewritten as underline tabs: `Label Cell` (`Label Large`) + `Active Indicator` (3 dp `accent-fill`), 48 dp high, Active / Inactive, 4 row masters (Active = Mendatang / Berlangsung / Selesai / Dibatalkan) |
| `WorkshopSummaryRow` (step 08) | Gained a disabled `Row Chevron` slot; S20 uses `Change Link` off + `Row Chevron` on |
| `FleetProgress` (full) | Extends the step-05 mini variant to the S20 fleet bar |
| `CancelScopeChooser` | Radio list: seluruh booking / per unit ("Hanya <motor> · Unit -X") |
| `DemoModeShortcut` | Small labelled card: step / reset |
| Focus specimens | `Focus Specimens Section` `bGnWH` in the Tracking sheet: `HistoryTab` Active / Inactive, `UnitStatusRow`, `BookingHistoryCard` |

### Annotations placed

- Status machine, derived booking status, disabled-action rules (incl. the Selesai gate), timer-driven auto-advance and demo control; each status change updates S05 card, S20, S21 live and pushes an in-app notification (S06).
- S19 tab behaviour + filter-by-motor; S20 workshop row → S14 standalone; S22 sheet / dialog behaviour, states and cancel rules; tablet layout notes; **Semantics** notes (tabs, cards, back / close icons, timeline nodes, dialog focus, loading announcement, tabular figures).
- Motion: timeline reveal 300ms, current-node emphasis (with non-motion cue), reduce-motion.

## Built (node ids)

| Group | Light | Dark | Notes / headers |
|---|---|---|---|
| Sheet `Components / Tracking Blocks` | `iZ2qP` (x 39016, y 8760) | `zQ4XJ` (y 12380) | — |
| S19 phone (y 71,686) | Berlangsung `mne8D`, Mendatang `tHkHZ`, Selesai `aJK2Q`, Dibatalkan `DTste`, Empty `mGNC0`, Loading `LYhas` | Berlangsung `ywUJ0` (y 73,686) | notes `G06QB3`; headers `cxOPM`, `rsCjT` |
| S20 phone (y 75,286) | Terjadwal `sc4JC`, Berlangsung `eaJvo`, Selesai Belum Lunas `bOe2d`, Selesai Lunas `Wf7JQ`, Dibatalkan `ey2IC`, Loading `qZcwE` | `e8j30`, `cyqgc`, `p5Xu6` (y 76,486) | notes `r5Ran`; headers `Euaq7`, `X1iByM` |
| S21 phone (y 77,686) | Live `cBMsr`, Completed `bWut3`, Cancelled `shbBk`, Loading `o02ex` | `fv98H`, `c59Cz` (y 79,286) | notes `onQBI`; headers `Jv1fK`, `Rc3Tl` |
| S22 phone (y 80,586) | Sheet `StVGw`, Loading `t7qgkb`, Error `Wg6nX`, Batalkan `e0hjjR`, Success `Ansc8` | `w3YVyv`, `Pq77V` (y 81,736) | notes `EDpGd`; headers `ZTjRl`, `QYvPd` |
| S19 tablet | Tab-P `so1mg` (y 144,586), Tab-L `CVJ21` (y 146,386) | `K29fNa`, `KJGZl` | notes `PZ4Un`, `fllNH`; headers `ZwX9L`, `J5Fpu1` |
| S20 tablet | Tab-P `YLjkV` (y 148,186), Tab-L `JABvg` (y 149,886) | `zFpV4`, `Tqzs8` | notes `P5QYh`; headers `iyU4d`, `GBQ7R` |
| S21 tablet | Tab-P `f9lSuN` (y 151,586), Tab-L `GAsGo` (y 153,286) | `j1Gwkd`, `JPBaD` | notes `WVLPI`; headers `I1Mhi`, `UZusM` |
| S22 tablet (y 154,986) | Sheet `SM7hf`, Batalkan `GHTRe` | — | notes `kr4Ic`; header `veIBt` |

## Checklist

### Build
- [x] Kickoff questions answered (2026-09-25) + rescue interview (2026-09-25).
- [x] `StatusTimeline` and `MechanicCard` built with all node/assignment states, light + dark.
- [x] S19–S22 frames per the matrix above (phone, both tablets, dark defaults).
- [x] Status shown with icon + label + shape everywhere (badge, timeline node, progress segment, tab indicator).
- [x] Destructive cancel uses danger confirm with de-emphasized cancel; disabled actions state the reason; S24 gate shown on S20 Selesai.
- [x] S22 sheet reuses the S15 picker as instances.
- [x] P2 "additional work" card → **cut** (decision 7).

### Quality (automated, run in `execute`)
- [x] Clipping check on every step frame → zero `problems` (exempt: tab tracks, float-epsilon rows on `Fleet Bar` / `Legend`).
- [x] Raw-hex audit → zero; no literal `fontWeight` left (71 bound to `$font-weight-*`).
- [x] Every node named (refs excepted); instances only; `placeholder` cleared.
- [x] Coverage: frame names match the matrix (43 frames); root-AABB overlap script → only the 3 pre-existing component-sheet / dark-copy pairs.
- [x] Gesture bar at `H − 24` on every phone frame; app-bar titles correct on all 43 frames.
- [x] Contrast: 1,837 text + icon nodes over 45 frames + both sheets, 0 failures (Monogram logo art exempt).

### /better-interface
- [x] Run with scope = all S19–S22 frames (names + node ids); report below; HIGH + MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [x] Gate 1 (phone repair + placement) approved 2026-09-25.
- [x] Gate 2: status 🔵; user shown phone / tablet / dark rows; approved 2026-09-25 ("Approve, close step").

### Close (only after approval)
- [x] PNG export to `design/pencil/exports/step16/` (43 PNG + `INDEX.md`, Tracking sheets in `components/`).
- [x] Claude session file written (`docs/claude-session/18-design-step16-tracking.md`).
- [x] Tracker set to ✅; inventory additions updated.

## /better-interface report

**Scope:** S19–S22 — phone light `mne8D tHkHZ aJK2Q DTste mGNC0 LYhas` · `sc4JC eaJvo bOe2d Wf7JQ ey2IC qZcwE` · `cBMsr bWut3 shbBk o02ex` · `StVGw t7qgkb Wg6nX e0hjjR Ansc8`; dark `ywUJ0 e8j30 cyqgc p5Xu6 fv98H c59Cz w3YVyv Pq77V`; tablet light `so1mg CVJ21 YLjkV JABvg f9lSuN GAsGo SM7hf GHTRe`, dark `K29fNa KJGZl zFpV4 Tqzs8 j1Gwkd JPBaD`; sheets `iZ2qP` / `zQ4XJ` · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens · **Convention docs found:** 00-index.md, prd/02, prd/04, prd/06, steps 08 / 09 / 17 files

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | Focus specimens in the sheet, every interactive control (tabs, cards, unit rows, buttons, chips, radios, snackbar action), disabled-with-reason states, loading buttons, Semantics notes, non-color status cues, hit heights (tabs 48, rows ≥ 66, chips 48) | 1 HIGH + 2 MEDIUM (fixed) |
| Layout | Skeleton per frame (bars, body, gesture inset), tablet centering, list-detail split, action grouping, sheet / modal anchoring | 1 MEDIUM (fixed), 1 LOW |
| Writing | All visible strings in the 43 frames vs step 08 / 09 terminology, dialog copy, error / empty / disabled reasons | 2 MEDIUM (fixed) |
| Typography | Weights, sizes, line heights, tab label style, wrapping of unit meta and timeline captions, text ≥ 12 sp | 1 MEDIUM (fixed), 1 LOW annotation |
| Color | Resolved contrast for 1,837 nodes light + dark, semantic hues (danger only on cancel, status colors carry icon + label), accent use | Clear |
| UI | Radius / shadow of sheet, modal and dialog vs `TsDialog` and `PartDetailSheet`, concentric radius of focus specimens, loading states | 1 LOW |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| HIGH | Accessibility | Tracking sheet `iZ2qP` · `HistoryTab` `f9qGL` / `T66wxi`, `UnitStatusRow` `VE6Ac`, `BookingHistoryCard` `WnZr8` | New keyboard-reachable tabs and tappable cards / rows had no designed focus state | `Focus Specimens Section` `bGnWH` (wrappers `m0GCfw`, `Y0PnGr`, `SqdD3`, `GkLoQ`: padding 4, `focus-ring` 2 inner, radius inner + 4) | A control with no visible focus indicator is unreachable for keyboard / switch users |
| MEDIUM | Accessibility | S22 Loading `t7qgkb` · footer button `p6PVr` | Spinner-only loading button (label hidden) | `Label` on, "Menyimpan jadwal" beside the spinner | Loading state should keep the label so the action stays announced |
| MEDIUM | Accessibility | Notes `G06QB3`, `r5Ran`, `onQBI`, `EDpGd`, `fllNH` | Icon-only back / close, tab semantics, timeline nodes, dialog focus had no Semantics annotation | "Semantics note" per frame (`CQ289`, `HiqYH`, `SmCn1`, `k5YCd9`, `pRBbN`) | Handoff must name icon-only controls and composite widgets |
| MEDIUM | Layout | S20 Berlangsung `eaJvo` / `cyqgc` (Actions `XN6ZW`), Selesai Belum Lunas `bOe2d` / `p5Xu6` (`iZMBD`) | Reason line 8 dp from both its own button and the next button | `Action Group` frames (button + reason, gap 4), Actions gap 12 | Grouping: equal spacing hides which control the reason belongs to |
| MEDIUM | Writing | Batalkan dialog `e0hjjR` `n88Gg`, `GHTRe` `UaYie` (+ dark) | "Tindakan ini tidak bisa dibatalkan." | "Pembatalan tidak bisa diurungkan." | The cancel verb made "cannot be cancelled" ambiguous on a destructive dialog |
| MEDIUM | Writing | S22 sheets `StVGw`, `t7qgkb`, `Wg6nX`, modal `SM7hf` (+ dark) | "Slot 09.00 adalah jadwal sekarang." | "Jam 09.00 adalah jadwal sekarang." | Step 09 decision: the UI says "jam", not "slot" |
| MEDIUM | Typography | 71 text nodes across the step 16 frames + sheet (`Tab Label` `ZolIe` = `700`, `Code`, `Units Title`, `Unit Name`, `Status Label`, `Reason Label`, `Node Time` …) | Literal `fontWeight` `600` / `normal` / `700` | `$font-weight-semibold` / `$font-weight-regular` | Exo 2 is loaded at 400 / 600 / 800: `700` is synthesized; weights should bind to tokens |
| LOW | Layout | S20 Tab-L `JABvg` | Left column ends at y 208, right at 370 (empty lower left) | Left open (PRD 06 puts actions right) | Balance only; no content or control affected |
| LOW | UI | S20 / S21 Loading `qZcwE`, `o02ex` | Same generic card skeleton on both | Timeline-shaped skeleton for S21 | A skeleton that prefigures the layout reduces shift |
| LOW | Typography | Tab counts, ETA, timeline times | Changing figures | Annotated: tabular figures (Semantics notes) | Prevents layout shift as values update |

**Verification:** *Passed* — clipping 0 over 54 roots with `resolveInstances: true` (exempt: tab tracks, float-epsilon rows); raw hex 0; unnamed non-ref nodes 0; placeholders 0; literal weights 0 after the fix; text < 12 sp 0; contrast 1,837 nodes, 0 failures; gesture bar `H − 24` on all 29 phone frames; app-bar titles checked on all frames; root-overlap script; sub-node screenshots of every changed row. *Not verified:* keyboard traversal and a screen reader (static design), text ×1.3 stress for S19–S22 (not in the matrix), RTL, real motion replay.
**Verdict:** Approve
**Fixes applied:** all HIGH + MEDIUM (ids in the table) · **LOW left for the user:** S20 Tab-L column balance, S21 timeline-shaped loading skeleton, S19 tab weight cue dropped (decision 12). Pre-existing (step 19): status-bar clock 09.41 vs the 10.20 story moment.

## Review rounds

#### Round 1 — 2026-09-25 (gate 1: phone repair + placement)
- **Frames shown:** phone rows S19 – S22 light + dark at y 71,500 – 82,536, new canvas position (overlap fixed), script results.
- **User feedback:** "Approve, do tablet" (AskUserQuestion answer).
- **Changes made:** none requested; tablet rows repaired next.
- **Outcome:** approved.

#### Round 2 — 2026-09-25 (gate 2: tablet + `/better-interface`)
- **Frames shown:** tablet rows S19 – S22 (y 144,400+), phone rows and dark copies, the `/better-interface` report and checks.
- **User feedback:** "Approve, close step" (AskUserQuestion answer).
- **Changes made:** none requested; export (43 PNG + `INDEX.md`), session file and docs written.
- **Outcome:** approved.

## Session log

| Time | Action | Result / node ids |
|---|---|---|
| 2026-09-25 | Kickoff interview (9 questions incl. concurrency + demo story) | All recommended options chosen; P2 card cut; decisions 1–9 |
| 2026-09-25 | First build (other model): sheet + 21 phone frames + 13 tablet frames, no review | Placement, skeleton, dialog and tablet-centering defects (see *Rescue*) |
| 2026-09-25 | Rescue audit (read-only, plan mode) + interview (7 answers) | Decisions 10–16 |
| 2026-09-25 | Phase 1 placement: tablet block +11,000, phone rows −2,500, header names | Anchor `URsZs` y 83,500; phone rows y 71,500 – 82,536; overlap script 0 (3 pre-existing) |
| 2026-09-25 | Underline tabs: `HistoryTab` / `HistoryTabRow` rebuilt; 6 S19 frames rebuilt on the S07 skeleton | `f9qGL`, `T66wxi`, `SftdG` `xJVpk` `G0lhtA` `ehvjF`; S19 frames |
| 2026-09-25 | `UnitStatusRow` restructured; `WorkshopSummaryRow` `Row Chevron`; S20 fixes (chevron row, icons, copy, Selesai Belum Lunas / Lunas) | `VE6Ac`, `okLzp`, `bOe2d`, new `Wf7JQ` |
| 2026-09-25 | S22: sheets bottom-anchored, Batalkan dialog rebuilt (`TsDialog` style, chips fixed, copy), gesture bars `H − 24`, refs named | `StVGw`, `t7qgkb`, `Wg6nX`, `e0hjjR`, `zcAMY` |
| 2026-09-25 | Dark phone frames + Tracking dark sheet re-copied | see *Built* |
| 2026-09-25 | Gate 1 shown, approved | Round 1 |
| 2026-09-25 | Tablet repair: centering, titles, S19 Tab-P / Tab-L rebuilt (list-detail), S21 Tab-L ETA to the side pane, S22 modal + dialog (400), 6 dark copies, 5 notes | see *Built* |
| 2026-09-25 | `/better-interface` (6 domains): 1 HIGH + 6 MEDIUM fixed, 3 LOW listed; darks + sheet re-copied again | report above |
| 2026-09-25 | Final checks | clipping 0, hex 0, unnamed 0, contrast 0 / 1,837, overlaps 3 (pre-existing) |
| 2026-09-25 | Gate 2 approved; export + session file + docs | `exports/step16/` (43 PNG + `INDEX.md` + `components/`), `18-design-step16-tracking.md`; tracker ✅ |
| 2026-09-25 | Step 19 audit fix (F11) | MOTION notes: S20 `e8isll` in `r5Ran`, S22 `pebCU` in `EDpGd` (150 ms swaps / dialog, 250 ms sheet / route, `disableAnimations` = instant / fade only) |
