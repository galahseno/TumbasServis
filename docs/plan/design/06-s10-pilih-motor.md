# Step 06 — S10 Pilih Motor

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | P0 |
| **Owns screens** | S10 |
| **Owns components** | (screen-local): booking-exit confirm dialog variant, `SelectionCounter` |
| **PRD refs** | [04 S10](../../../prd/04-screens.md), [03 F2 + vehicle-selection rules + edge cases](../../../prd/03-user-flows.md), [06](../../../prd/06-responsive-layout.md) (S10 row) |
| **Pen location** | Flows row `S10` |
| **Depends on** | Steps 02–05 |
| **Claude session** | `docs/claude-session/08-design-step06-s10-pilih-motor.md` (written after approval) |

## Goal

Design the first booking step: multi-select 1–5 motors from the garage, with the disabled ("Sedang dalam servis") and max-reached rules made obvious and never color-only. Also design the **exit-booking confirm dialog** ("Keluar dari booking? Draft akan disimpan.") that every booking step reuses.

## Inputs

- `BookingStepper` (step 1/4), `VehicleSelectCard` (select mode: unselected / selected / disabled reasons), `StickyEstimateBar` or plain sticky footer, `EmptyState` (garage), `TsDialog`.
- Demo garage: 3 motors; one motor must be shown as "Sedang dalam servis" in the populated frame.

## Open questions (ask at kickoff)

1. **Footer.** Plain sticky footer with "Lanjut" (PRD wireframe text) or the glass `StickyEstimateBar` without a price yet? *Recommended: plain sticky footer — price appears from S11.*
2. **Max-reached demo.** The demo garage has 3 motors, so max-reached needs a specimen garage of ≥ 6. Approve a specimen frame with 6 motors (labelled "Demo: garage 6 motor")?
3. **Selection counter** placement: header row above the list ("2 dari 5 motor dipilih") vs inside the footer.
4. **"+ Tambah motor lain"** — a card at the end of the list vs a text button in the header. (Both lead inline to S08.)
5. **Pre-selected entry** (from garage / rebook): any "Dipilih dari Garasi" hint, or identical to a user-selected state?

## Scope

### Frame matrix

| State | Phone | Tablet-P | Tablet-L | Dark |
|---|---|---|---|---|
| Loading (skeleton cards) | ✔ | ✔ | ✔ | phone |
| Empty garage (illustration + "Tambah motor pertamamu" CTA) | ✔ | ✔ | ✔ | phone |
| Populated — none selected (Lanjut disabled + reason line) | ✔ | — (same layout as next row) | — | phone |
| Populated — 2 of 5 selected, 1 disabled "Sedang dalam servis" | ✔ | ✔ | ✔ | phone + both tablets |
| Max-reached — 5 of 5 (others disabled "Maks. 5 motor") | ✔ | ✔ | — | phone |
| Exit-booking confirm dialog (over populated) | ✔ | ✔ | — (modal identical) | phone |
| Stress: 360×640 | ✔ | — | — | — |
| Stress: text scale ×1.3 (populated) | ✔ | — | — | — |

### Layout targets (PRD 06)

- Phone: 1-col card list. Tablet portrait: 2-col grid. Tablet landscape: 2–3-col grid (state the chosen count).
- Stepper: compact phone variant; wider tablet variant, centered within max-width.

### Content & copy

- Title "Pilih Motor"; helper copy in the friendly voice ("Yuk, pilih motor yang mau diservis").
- Counter: "2 dari 5 motor dipilih". Disabled reasons: "Sedang dalam servis", "Maks. 5 motor".
- CTA: "Lanjut" (disabled state explains why: "Pilih minimal 1 motor").
- Cards: nickname, plate, model with ellipsis; category silhouette in the photo slot.

### Annotations to place

- Selection rules (1–5, disabled rules), disabled reason announced by `Semantics`.
- Entry points and pre-selection (garage → pre-checked; rebook → pre-checked same motors).
- Exit dialog: system back and close icon both trigger it; confirm → draft saved → Home shows "Lanjutkan draft".
- Empty-garage CTA → S08 → returns here with the new motor selectable.

## Checklist

### Build
- [ ] Kickoff questions answered.
- [ ] All states in the matrix built for the listed breakpoints; dark copies built.
- [ ] Exit dialog built as a **non-destructive** dialog (the draft is saved): primary = "Simpan & keluar", secondary = "Lanjutkan booking"; no danger styling (a danger hue here would be a semantic-color misuse). Offer "Buang draft" only as a separate, danger-styled, confirmed action if the user wants it.
- [ ] Disabled cards carry a visible reason text (not only reduced opacity).
- [ ] Stress frames built; long nickname/plate ellipsis verified.
- [ ] Demo content consistent with the step-01 sheet.

### Quality (automated, run in `execute`)
- [ ] Clipping check on every step frame → zero `problems`.
- [ ] Raw-hex audit → zero.
- [ ] Every node named; instances only; `placeholder` cleared.
- [ ] Coverage script: frame names match the matrix above.

### /better-interface
- [ ] Run `/better-interface` with scope = all S10 frames (names + node ids).
- [ ] Report recorded below; HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: populated (selected/disabled), max-reached, empty, dialog, tablets, dark.
- [ ] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] PNG export to `design/pencil/exports/step06/`.
- [ ] Claude session file written.
- [ ] Tracker set to ✅.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
