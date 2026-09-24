# Step 10 — S16 Ringkasan + S17 Pilih Voucher

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | S16 P0 · S17 P1 |
| **Owns screens** | S16, S17 |
| **Owns components** | (screen-local): `SummaryCard` (workshop & schedule), `UnitSummaryAccordion`, `PaymentNote`, `VoucherRow` |
| **PRD refs** | [04 S16/S17](../../../prd/04-screens.md), [03 pricing/duration/voucher rules + edge cases](../../../prd/03-user-flows.md), [06 S16/S17 rows](../../../prd/06-responsive-layout.md) |
| **Pen location** | Flows rows `S16`, `S17` |
| **Depends on** | Steps 02–04, 06–09 |
| **Claude session** | `docs/claude-session/12-design-step10-s16-s17-ringkasan.md` (written after approval) |

## Goal

Design the final review before confirming: workshop + schedule recap with edit links, per-unit collapsible summaries, itemized `PriceBreakdown` (per-unit → fleet subtotal → voucher → total), voucher entry, payment note and the "Konfirmasi Booking" CTA — plus the voucher picker with eligible/ineligible reasons.

## Inputs

- `BookingStepper` (step 4/4), `PriceBreakdown`, `VoucherCard`, `StickyEstimateBar` or plain CTA bar, `TsDialog`, `TsSnackbar`, `ErrorState`/inline banner. **From step 09:** `CapacityBanner` (Tone = Warning, icon + text + action) is the inline banner for the S16 "slot became invalid" state — instance it, do not redraw; suggested actions "Pisah jadwal" (→ S15 split) / "Pilih jam lain" (→ S15). S15 recap strings for the split-schedule summary: "Sel, 29 Sep · 09.00" per unit.
- Rules: all prices "Estimasi"; total duration = **makespan** across the workshop's bays (not a sum) — e.g. 2 bays, 3 units × 60 min ≈ 120 min; re-validate slot on entering S16; voucher discount is its own line; payment = "Bayar di bengkel saat selesai".

## Open questions (ask at kickoff)

1. **S17 presentation.** PRD allows sheet or full page; PRD 06 gives tablet a 1-col/2-col *page* layout. *Recommended: full page (route `/booking/summary/voucher`), no sheet.* Confirm.
2. **Confirm CTA placement.** Sticky bottom CTA bar (phone) vs inline at the end; on tablet-L it lives in the right pane. Glass or flat here? (Glass budget ≤ 2.)
3. **Makespan display.** How is "Estimasi 2 jam" explained — an info tooltip/sheet ("Dikerjakan bersamaan di 2 bay")?
4. **Confirm failure.** Mode Demo can force an error: inline banner + retry vs snackbar? (Recommended: inline banner near the CTA with "Coba lagi".)
5. **Split-schedule recap.** Per-unit slots inside the workshop & schedule card, or inside each unit accordion?
6. **Voucher removal.** Where is "Hapus voucher" on S16 once applied (row action vs back on S17 "Tidak pakai voucher" only)?
7. **Price consistency.** Numbers must match step-01's price set (subtotal Rp428.000, voucher −Rp42.800, total Rp385.200).

## Scope

### Frame matrix

| Screen · State | Phone | Tablet-P | Tablet-L | Dark |
|---|---|---|---|---|
| S16 Loading (recomputing after an edit) | ✔ | ✔ | ✔ | phone |
| S16 Ready — voucher applied, 3 units (units collapsed, one expanded) | ✔ | ✔ | ✔ two-pane | phone + both tablets |
| S16 Ready — no voucher | ✔ | ✔ | — | phone |
| S16 Error — slot became invalid (banner + fix link) | ✔ | ✔ | ✔ | phone |
| S16 Split-schedule recap | ✔ | ✔ | — | phone |
| S16 Single-unit booking (1 motor) | ✔ | — | — | phone |
| S16 Confirm loading ("Mengonfirmasi…") | ✔ | — | — | phone |
| S16 Confirm error (demo network error + retry) | ✔ | — | — | phone |
| S16 Stress: 360×640, text ×1.3 (price breakdown is a named dense screen) | ✔ | — | — | — |
| S17 Populated — eligible + ineligible (with reasons) + "Tidak pakai voucher" | ✔ | ✔ | ✔ 2-col grid | phone + both tablets |
| S17 Loading | ✔ | — | — | phone |
| S17 Empty ("Belum ada voucher") | ✔ | — | — | — |

### Layout targets (PRD 06)

- S16: stacked with sticky bottom bar (phone/tablet-P max-width 720); tablet-L **two-pane** — recap list left, sticky `PriceBreakdown` + CTA right.
- S17: 1-col list (tablet max-width 560), 2-col grid on landscape.

### Components built here

| Component | Notes |
|---|---|
| `SummaryCard` | Workshop + schedule with "Ubah" links to S13/S15; split-mode variant |
| `UnitSummaryAccordion` | Per-unit collapsible: services, parts, complaint recap, "Ubah" link to S11 for that unit |
| `PaymentNote` | "Bayar di bengkel saat selesai" with icon |
| `VoucherRow` | S16 row: "Pilih Voucher ›" / applied state with remove |

### Content & copy

- Title "Ringkasan"; CTA "Konfirmasi Booking".
- Lines: "Subtotal Rp428.000", "Diskon voucher −Rp42.800", "Total Rp385.200", "Estimasi 2 jam", "Bayar di bengkel".
- Ineligible voucher reason: "Butuh min. 2 motor".

### Annotations to place

- Edit links route back to S13 / S15 / S11(unit) and return to S16.
- Re-validation on entering S16; invalid-slot banner recovery (split schedule or next available).
- Confirm → loading → S18; error retry.
- Makespan explanation; voucher eligibility evaluation.
- Semantics: totals read as one group; edit links have unit-specific labels ("Ubah Vario 125").

## Checklist

### Build
- [ ] Kickoff questions answered.
- [ ] All S16 and S17 states built for required breakpoints; dark copies built.
- [ ] Discount line shows icon/sign + text, not color alone.
- [ ] Tablet-L two-pane: right pane sticky (`PriceBreakdown` + CTA) built with instances.
- [ ] Stress frames built and clean (price breakdown does not clip at ×1.3).
- [ ] Numbers verified against the step-01 price sheet.

### Quality (automated, run in `execute`)
- [ ] Clipping check on every step frame → zero `problems`.
- [ ] Raw-hex audit → zero.
- [ ] Every node named; instances only; `placeholder` cleared.
- [ ] Coverage script: frame names match the matrix above.
- [ ] Arithmetic check script: line items → subtotal → discount → total equal on all frames.

### /better-interface
- [ ] Run `/better-interface` with scope = all S16 + S17 frames (names + node ids).
- [ ] Report recorded below; HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: ready (voucher), no voucher, error banner, split recap, tablet-L two-pane, S17 eligible/ineligible, dark.
- [ ] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] PNG export to `design/pencil/exports/step10/`.
- [ ] Claude session file written.
- [ ] Tracker set to ✅.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
