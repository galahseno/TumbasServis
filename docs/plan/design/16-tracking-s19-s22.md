# Step 16 — Tracking: S19 Riwayat · S20 Detail Booking · S21 Lacak Unit · S22 Ubah Jadwal / Batalkan

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | P1 |
| **Owns screens** | S19, S20, S21, S22 |
| **Owns components** | `StatusTimeline`, `MechanicCard`; (screen-local, flag for `prd/02`): `BookingHistoryCard`, `UnitStatusRow`, `FleetProgress` (full), `CancelScopeChooser`, `DemoModeShortcut` |
| **PRD refs** | [04 S19–S22 + P2 extras](../../../prd/04-screens.md), [03 F3, F6, status machine, booking-status derivation](../../../prd/03-user-flows.md), [06 S19–S22 rows](../../../prd/06-responsive-layout.md), [02 status colors](../../../prd/02-brand-design-system.md) |
| **Pen location** | Flows rows `S19`, `S20`, `S21`, `S22` |
| **Depends on** | Steps 02–05 (shell, `FleetProgress` mini), 09 (slot picker reuse) |
| **Claude session** | `docs/claude-session/18-design-step16-tracking.md` (written after approval) |

## Goal

Design post-booking: history, the booking hub with per-unit status, the per-unit live timeline (the assessment's pillar 4), and the modify/cancel sheets. Build `StatusTimeline` and `MechanicCard`, and make the status machine unmistakable without relying on color.

## Inputs

- `AppShell` (Riwayat tab), `UnitStatusBadge`, `TsChip`/tabs, `FleetProgress`, `PriceBreakdown`, S15 date/slot picker (reused inside the S22 sheet), `TsDialog`, `TsSnackbar`, `EmptyState`, `Skeleton`.
- Status machine: Terjadwal → Check-in/Antre → Diperiksa → Dikerjakan → QC → Selesai, with Dibatalkan from any pre-Selesai state. Booking status derived from units (Terjadwal / Berlangsung / Selesai / Dibatalkan). Cancel/reschedule only while `Terjadwal`.

## Open questions (ask at kickoff)

1. **Timeline anatomy** — vertical stepper with timestamps per node, current-node pulse (motion note), estimated completion pinned at the top?
2. **S20 action availability** — when actions are disabled (unit already checked in), show the reason inline ("Sudah check-in — tidak bisa dibatalkan").
3. **S19 tabs** — segmented tabs with counts (Mendatang 1 · Berlangsung 1 · Selesai 2 · Dibatalkan 1)?
4. **Mechanic card** — appears once assigned; content: avatar initial, name, rating; mechanic per unit or per booking?
5. **S22 cancel** — scope choice (seluruh booking / satu unit) as radio list in a `TsDialog` + reason chips; confirm danger button label.
6. **Demo Mode shortcut on S21** — inline card with "Majukan status" / "Reset" mirroring S26; visually clearly separated from product UI (labelled "Mode Demo").
7. **P2 "additional work found"** approval card on S21 — include now (optional) or cut?

## Scope

### Frame matrix

| Screen · State | Phone | Tablet-P | Tablet-L | Dark |
|---|---|---|---|---|
| S19 Populated — tab "Berlangsung" (cards with code, date, motor count, status) | ✔ | ✔ | ✔ list-detail (S20 preview right) | all three |
| S19 Other tabs (Mendatang / Selesai / Dibatalkan) | ✔ (3 frames) | — | — | — |
| S19 Empty (per-tab example) | ✔ | — | — | — |
| S19 Loading | ✔ | — | — | — |
| S20 Terjadwal (actions: Ubah jadwal, Batalkan enabled) | ✔ | ✔ | ✔ overview left / units + actions right | all three |
| S20 Berlangsung (actions disabled + reason) | ✔ | — | — | phone |
| S20 Selesai (Lihat Invoice + Beri Ulasan) | ✔ | — | — | phone |
| S20 Dibatalkan | ✔ | — | — | — |
| S20 Loading | ✔ | — | — | — |
| S21 Live (current node = Dikerjakan, mechanic, ETA, Mode Demo shortcut) | ✔ | ✔ | ✔ timeline left / mechanic card right | all three |
| S21 Completed | ✔ | — | — | phone |
| S21 Cancelled | ✔ | — | — | — |
| S21 Loading | ✔ | — | — | — |
| S22 Ubah Jadwal sheet (S15 picker inside sheet) | ✔ | ✔ centered modal | — | phone |
| S22 Batalkan dialog (scope choice + reason chips) | ✔ | ✔ | — | phone |
| S22 Loading / error / success toast (annotated states) | ✔ (3 small frames) | — | — | — |

### Layout targets (PRD 06)

- S19: list with tabs → max 720 → list-detail split. S20: stacked → max 720 → overview left / units + actions right. S21: vertical timeline (max 640 on tablet) → timeline left / mechanic (map) card right. S22: full-width bottom sheet → centered modal max 560.

### Components built here

| Component | Notes |
|---|---|
| `StatusTimeline` (owned, PRD 02) | Vertical stepper; nodes done / current / pending / cancelled; timestamps; icon + label per node; reveal motion 300ms staggered |
| `MechanicCard` (owned, PRD 02) | Avatar initial, name, rating; assigned / not-yet-assigned variants |
| `BookingHistoryCard` | Code, workshop, date, motor count, derived booking status badge |
| `UnitStatusRow` | Unit name, code, badge, tap → S21 |
| `FleetProgress` (full) | Extends the step-05 mini variant to the S20 fleet bar |
| `CancelScopeChooser` | Radio list: seluruh booking / per unit |
| `DemoModeShortcut` | Small labelled card: step / reset |

### Annotations to place

- Status machine, derived booking status, disabled-action rules, timer-driven auto-advance and demo control.
- Each status change updates S05 card, S20, S21 live and pushes an in-app notification (S06).
- S22: reschedule re-runs slot availability (F2 scheduling rules); cancelling all units cancels the booking; pricing recomputes for remaining units.
- Motion: timeline reveal 300ms, current-node emphasis (with non-motion cue), reduce-motion.

## Checklist

### Build
- [ ] Kickoff questions answered.
- [ ] `StatusTimeline` and `MechanicCard` built with all node/assignment states, light + dark.
- [ ] S19–S22 frames built per matrix; dark defaults built.
- [ ] Status shown with icon + label + shape everywhere (badge, timeline node, progress segment).
- [ ] Destructive cancel uses danger confirm with de-emphasized cancel; disabled actions state the reason.
- [ ] S22 sheet reuses the S15 picker as instances.
- [ ] (If Q7 = yes) P2 "additional work" card built; otherwise noted as cut.

### Quality (automated, run in `execute`)
- [ ] Clipping check on every step frame → zero `problems`.
- [ ] Raw-hex audit → zero.
- [ ] Every node named; instances only; `placeholder` cleared.
- [ ] Coverage script: frame names match the matrix above.

### /better-interface
- [ ] Run `/better-interface` with scope = all S19–S22 frames (names + node ids); if too large, run per screen group and consolidate, stating the boundary.
- [ ] Report recorded below; HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: history, each booking status on S20, live/completed/cancelled timeline, sheets, tablet-L splits, dark.
- [ ] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] PNG export to `design/pencil/exports/step16/`.
- [ ] Claude session file written.
- [ ] Tracker set to ✅; inventory additions updated.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
