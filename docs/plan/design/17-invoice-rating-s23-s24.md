# Step 17 — Invoice & Rating: S23 Invoice · S24 Beri Ulasan

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | P1 |
| **Owns screens** | S23, S24 |
| **Owns components** | `RatingStars`; (screen-local): `InvoiceSummaryCard`, `MechanicRatingRow`, `ReviewRecap` |
| **PRD refs** | [04 S23/S24](../../../prd/04-screens.md), [03 F4](../../../prd/03-user-flows.md), [05 Invoice/Review entities](../../../prd/05-data-model-mock.md), [06 S23/S24 rows](../../../prd/06-responsive-layout.md) |
| **Pen location** | Flows rows `S23`, `S24` |
| **Depends on** | Steps 02–04 (`PriceBreakdown`), 16 |
| **Claude session** | `docs/claude-session/19-design-step17-invoice-rating.md` (written after approval) |

## Goal

Design the itemized invoice for a completed multi-unit booking (per-unit lines, fleet total, mock "Tandai Lunas") and the post-service review (workshop rating + optional per-mechanic ratings). Build `RatingStars` (display + interactive).

## Inputs

- `PriceBreakdown` (invoice variant, per unit), `TsButton`, `TsTextField` (comment), `TsSnackbar`, `TsDialog`, `UnitStatusBadge`, `MechanicCard`.
- Rules: invoice is generated once the booking is `Selesai`; "Tandai Lunas" is a mock action that flips to paid and unlocks S24; S24 = one workshop rating + optional rating per mechanic if different mechanics served different units.

## Open questions (ask at kickoff)

1. **Invoice paid state** — "Lunas ✓" stamp/banner with `paidAt`; does the "Tandai Lunas" CTA need a confirm dialog (mock demo action)?
2. **P2 "Unduh/Bagikan"** — include a disabled/optional action now or cut?
3. **Rating semantics** — star count labels ("Sangat baik"), required vs optional comment, and how "half-tapped" states are avoided; keyboard/tablet operation of stars (arrow keys) for the a11y note.
4. **Multiple mechanics** — one row per distinct mechanic with the units they served; when only one mechanic served all, hide per-mechanic section?
5. **Submitted recap** — read-only recap on the same screen vs back to S20 with a toast?

## Scope

### Frame matrix

| Screen · State | Phone | Tablet-P | Tablet-L | Dark |
|---|---|---|---|---|
| S23 Unpaid (per-unit lines, fleet total, workshop info, "Tandai Lunas") | ✔ | ✔ | ✔ breakdown left / summary card right | all three |
| S23 Paid ("Lunas ✓", paid date, "Beri Ulasan" enabled) | ✔ | — | — | phone |
| S23 Loading | ✔ | — | — | — |
| S24 Default (empty stars, comment, per-mechanic rows) | ✔ | ✔ | ✔ form left / submitted-reviews preview right | all three |
| S24 Submitting | ✔ | — | — | — |
| S24 Submitted (read-only recap) | ✔ | — | — | phone |
| S24 Validation (workshop rating required) | ✔ | — | — | — |

### Layout targets (PRD 06)

S23: stacked → max 640 → breakdown left / summary right. S24: stacked form → centered max 560 → form left / recap right.

### Components built here

| Component | Notes |
|---|---|
| `RatingStars` (owned, PRD 02) | Display (read-only, half values) and interactive (tap targets ≥ 48dp, label of current value) |
| `InvoiceSummaryCard` | Fleet total, paid state, workshop info, voucher line |
| `MechanicRatingRow` | Mechanic + units served + stars |
| `ReviewRecap` | Read-only submitted state |

### Annotations to place

- Invoice generation trigger; "Tandai Lunas" flips state and unlocks S24.
- Star input semantics (`Semantics` value "4 dari 5"); keyboard operation.
- Where each screen is reached (S20 actions; notification deep link).

## Checklist

### Build
- [ ] Kickoff questions answered.
- [ ] `RatingStars` display + interactive variants built, light + dark.
- [ ] S23 and S24 frames built per matrix; dark defaults built.
- [ ] Line items match the step-01 price sheet (per-unit service + part lines → subtotal → voucher → total).
- [ ] Paid/rated states conveyed by icon + label (not color alone).

### Quality (automated, run in `execute`)
- [ ] Clipping check on every step frame → zero `problems`.
- [ ] Raw-hex audit → zero.
- [ ] Every node named; instances only; `placeholder` cleared.
- [ ] Coverage script: frame names match the matrix above.
- [ ] Arithmetic check: invoice lines → total equals S16/S18 totals.

### /better-interface
- [ ] Run `/better-interface` with scope = all S23 + S24 frames (names + node ids).
- [ ] Report recorded below; HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: invoice unpaid/paid, review default/submitted, tablet-L, dark.
- [ ] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] PNG export to `design/pencil/exports/step17/`.
- [ ] Claude session file written.
- [ ] Tracker set to ✅.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
