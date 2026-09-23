# Step 09 — S15 Pilih Jadwal

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | P0 |
| **Owns screens** | S15 |
| **Owns components** | (screen-local): `ScheduleModeToggle`, `UnitSlotSection`, `CapacityBanner`; tablet date-grid variant of the step-04 date-strip item |
| **PRD refs** | [04 S15](../../../prd/04-screens.md), [03 scheduling rules + edge cases](../../../prd/03-user-flows.md), [06 S15 row](../../../prd/06-responsive-layout.md) |
| **Pen location** | Flows row `S15` |
| **Depends on** | Steps 02–04 |
| **Claude session** | `docs/claude-session/11-design-step09-s15-jadwal.md` (written after approval) |

## Goal

Design the shared arrival slot picker (default) and the optional **per-unit split schedule**, with capacity made visible: available / limited / full / selected, and the "not enough capacity for N motors" recovery path.

## Inputs

- `DateStripItem`, `SlotChip` (available / limited / full / selected), `BookingStepper` (step 3/4), `TsButton`, sticky footer, `Skeleton`, `TsDialog`.
- Rules: slots 08.00–16.00 hourly, D+0 (if ≥ 2 h from now) → D+14; `limited` when remaining ≤ 2; `full` when `booked ≥ capacity`; shared mode needs capacity ≥ units; split mode validates each unit's slot independently.

## Open questions (ask at kickoff)

1. **Tablet-landscape date control.** PRD says "date strip left, slot grid right". A vertical strip of 15 days, or a 2-week calendar grid (7 cols × 3 rows)? *Recommended: 2-week calendar grid — reads as a schedule, uses the same `DateStripItem` as a grid cell.* (New variant, added here.)
2. **Split mode layout.** Per-unit collapsible sections each with its own date strip + slot grid (phone), and on landscape? Show a unit switcher (chips/rail) instead of stacking 3 pickers?
3. **Insufficient capacity.** For a chosen shared slot with capacity < N units: slot chip disabled with reason vs selectable + banner? (PRD: shared option disabled for that slot with "Kapasitas tidak cukup untuk N motor", and prompts the "Pisah jadwal" toggle.) Confirm banner + toggle CTA text.
4. **Remaining-capacity display** on `limited` chips ("Sisa 2") — always visible, or only for limited?
5. **All-full day** (not in PRD): empty state "Semua slot penuh — coba tanggal lain" with next-available suggestion. Include? *Recommended yes.*
6. **D+0 rule**: slots earlier than +2 h hidden or shown disabled with reason?

## Scope

### Frame matrix

| State | Phone | Tablet-P | Tablet-L | Dark |
|---|---|---|---|---|
| Loading (slot grid skeleton) | ✔ | ✔ | ✔ | phone |
| Shared — populated (date selected; slots show available / limited / full / one selected) | ✔ | ✔ | ✔ | phone + both tablets |
| Shared — insufficient capacity (banner + suggestion to split) | ✔ | ✔ | ✔ | phone |
| Split mode ("Pisah jadwal per motor") — per-unit pickers, one unit complete | ✔ | ✔ | ✔ | phone |
| All slots full for the selected day (Q5) | ✔ | — | — | phone |
| Stress: 360×640 (shared populated) | ✔ | — | — | — |
| Stress: text scale ×1.3 (shared populated) | ✔ | — | — | — |

### Layout targets (PRD 06)

- Phone: date strip above slot grid; sticky footer "Lanjut".
- Tablet portrait: same, wider slot grid (state columns).
- Tablet landscape: **side-by-side** — date control left, slot grid right.

### Components built here

| Component | Notes |
|---|---|
| `ScheduleModeToggle` | "Pisah jadwal per motor" switch with helper text; explains shared vs split |
| `UnitSlotSection` | Per-unit date + slot picker block with unit header and status (✓ / needs slot) |
| `CapacityBanner` | Info/warning banner with icon + text + action |
| `DateStripItem` grid variant | Calendar-cell variant for tablet landscape (added to the component sheet) |

### Content & copy

- Date format `EEE, d MMM yyyy` (e.g. "Sen, 29 Sep 2026"); time `09.00`.
- Messages: "Kapasitas tidak cukup untuk 3 motor", "Sisa 2 slot", "Penuh".
- Chosen demo slot: Sen, 29 Sep 2026 · 09.00.

### Annotations to place

- Rules for `limited`/`full`, D+0 cutoff, capacity vs unit count, per-unit validation.
- Race case: slot fills while user is on S15/S16 → re-validated on S16 (see step 10).
- Date strip scroll/snap behavior and visible scroll cue.
- Semantics: chip announces "09.00, sisa 2, terbatas".

## Checklist

### Build
- [ ] Kickoff questions answered.
- [ ] All matrix states built; dark copies built.
- [ ] Slot states (available / limited / full / selected) distinguishable without color (label, icon, shape).
- [ ] Insufficient-capacity banner + split toggle interaction annotated.
- [ ] Tablet-L side-by-side layout uses the calendar-grid variant if approved.
- [ ] Stress frames built and clean.
- [ ] Demo content consistent with step-01 sheet.

### Quality (automated, run in `execute`)
- [ ] Clipping check on every step frame → zero `problems`.
- [ ] Raw-hex audit → zero.
- [ ] Every node named; instances only; `placeholder` cleared.
- [ ] Coverage script: frame names match the matrix above.

### /better-interface
- [ ] Run `/better-interface` with scope = all S15 frames (names + node ids).
- [ ] Report recorded below; HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: shared populated, capacity banner, split mode, tablet-L side-by-side, dark.
- [ ] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] PNG export to `design/pencil/exports/step09/`.
- [ ] Claude session file written.
- [ ] Tracker set to ✅.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
