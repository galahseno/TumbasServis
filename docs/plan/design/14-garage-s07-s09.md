# Step 14 — Garage: S07 Garasi Saya · S08 Tambah/Edit Motor · S09 Detail Motor

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | P1 |
| **Owns screens** | S07, S08, S09 |
| **Owns components** | (screen-local): `MotorModelPicker` (sheet), `PlateField` variant, `ServiceHistoryRow`, live-preview card |
| **PRD refs** | [04 S07–S09](../../../prd/04-screens.md), [03 F5](../../../prd/03-user-flows.md), [05 entities](../../../prd/05-data-model-mock.md), [06 S07–S09 rows](../../../prd/06-responsive-layout.md) |
| **Pen location** | Flows rows `S07`, `S08`, `S09` |
| **Depends on** | Steps 02–05 (shell) |
| **Claude session** | `docs/claude-session/16-design-step14-garage.md` (written after approval) |

## Goal

Design motor management: list/grid of owned motors, add/edit form with searchable brand/model picker, and the motor detail with service history and the "Booking motor ini" entry into the P0 flow. Includes the delete confirmation and the blocked-delete dialog for motors with active bookings.

## Inputs

- `AppShell` (Garasi tab), `VehicleSelectCard` (display mode) + silhouettes, `TsTextField`, `TsButton`, `TsDialog`, `EmptyState` (garage), `Skeleton`, `SheetHeader`.
- Fields (PRD 04 S08): nickname, brand/model picker (searchable), plate number, year (optional), photo (optional, silhouette if skipped).
- Rules: deleting a motor with an active booking is blocked ("Motor ini punya booking aktif"); cancel on a dirty form asks for confirmation.

## Open questions (ask at kickoff)

1. **Photo input** — design a photo picker row with placeholder/silhouette, or a simple "Tambah foto (opsional)" affordance only?
2. **Model picker** — bottom sheet with search + grouped by brand (Honda/Yamaha/Suzuki) vs full-page? *Recommended: sheet on phone, popover/modal on tablet.*
3. **Plate format** — Indonesian plates (e.g. `AB 1234 XY`): auto-format + inline validation hint copy.
4. **History list** on S09 — how many rows + "Lihat semua"? Empty-history copy.
5. **S07 add entry** — FAB vs header "+" (PRD allows both). *Recommended: header "+" and an end-of-list add card.*
6. **Landscape S08** — the live preview card mirrors the `VehicleSelectCard` display mode?

## Scope

### Frame matrix

| Screen · State | Phone | Tablet-P | Tablet-L | Dark |
|---|---|---|---|---|
| S07 Populated (3 motors) | ✔ | ✔ 2-col | ✔ 3-col | all three |
| S07 Empty ("Tambah motor pertamamu") | ✔ | ✔ | ✔ | — |
| S07 Loading | ✔ | — | — | — |
| S08 Add — default | ✔ | ✔ centered form | ✔ form left + live preview right | all three |
| S08 Edit — prefilled | ✔ | — | — | — |
| S08 Validation error (invalid plate, missing model) | ✔ | — | — | — |
| S08 Model picker sheet (search + brand groups) | ✔ | ✔ (centered modal) | — | — |
| S08 Dirty-cancel confirm dialog | ✔ | — | — | — |
| S09 Populated with history | ✔ | ✔ | ✔ hero left / details + history right | all three |
| S09 History empty sub-state | ✔ | — | — | — |
| S09 Delete confirm dialog (danger) | ✔ | — | — | — |
| S09 Delete blocked dialog ("Motor ini punya booking aktif") | ✔ | — | — | — |

### Layout targets (PRD 06)

- S07: 1-col list → 2-col grid → 3-col grid. S08: full-width form → centered max 560 → form + live preview. S09: stacked → stacked max 720 → hero left / details right.

### Components built here

| Component | Notes |
|---|---|
| `MotorModelPicker` | Sheet: search field, brand section headers, model rows with category + cc |
| `ServiceHistoryRow` | Past booking date, code, services summary, status badge |
| Live-preview card | Uses `VehicleSelectCard` display mode as instance |

### Content & copy

Demo garage: Vario 125 (AB 1234 XY), Beat 110 (AB 5678 ZZ), PCX 160 (AB 9012 QR). Model list ~15 across Honda/Yamaha/Suzuki (matic/bebek/sport) per PRD 05.

### Annotations to place

- S07 card → S09; "+" → S08; S09 "Booking motor ini" → S10 with the motor pre-checked (F2 entry point).
- Delete flow: confirm → back to S07; blocked when active booking.
- Save → back to S07 with new/updated card visible.
- Keyboard handling on S08.

## Checklist

### Build
- [ ] Kickoff questions answered.
- [ ] All matrix states built for required breakpoints; dark defaults built.
- [ ] Delete dialog uses danger styling with de-emphasized cancel; blocked dialog is informational (no danger confirm).
- [ ] Model picker search and empty-search result annotated.
- [ ] Silhouettes used consistently with step 04 (no new art).

### Quality (automated, run in `execute`)
- [ ] Clipping check on every step frame → zero `problems`.
- [ ] Raw-hex audit → zero.
- [ ] Every node named; instances only; `placeholder` cleared.
- [ ] Coverage script: frame names match the matrix above.

### /better-interface
- [ ] Run `/better-interface` with scope = all S07–S09 frames (names + node ids).
- [ ] Report recorded below; HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: garage list/grid, empty, add form + picker, detail + history, dialogs, tablet-L, dark.
- [ ] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] PNG export to `design/pencil/exports/step14/`.
- [ ] Claude session file written.
- [ ] Tracker set to ✅.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
