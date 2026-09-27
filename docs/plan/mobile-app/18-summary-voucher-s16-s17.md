# Step 18 — S16 Ringkasan & S17 Pilih Voucher

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Layer** | Presentation, phone |
| **Priority** | S16 P0, S17 P1 |
| **Owns** | `booking/presentation/ringkasan/` (S16), `booking/presentation/voucher/` (S17) |
| **PRD refs** | [04 S16/S17](../../../prd/04-screens.md), [03 pricing/promo rules](../../../prd/03-user-flows.md) |
| **Design refs** | `docs/plan/design/10-s16-s17-ringkasan.md` + `docs/claude-session/design/12-design-step10-s16-s17-ringkasan.md`, exports `design/pencil/exports/step10/` |
| **Depends on** | Step 17 (schedule chosen), step 08 (`BookingRepository.confirmBooking`), step 07 (`CatalogRepository.getVouchers`), step 03 (`VoucherEligibilityService`), 10 |
| **Claude session** | `docs/claude-session/apps/19-mobile-step18-summary-voucher-s16-s17.md` (written after approval) |

## Goal

Final review + confirm (S16) and the voucher picker (S17, full page reachable only from S16). Confirming here calls `BookingRepository.confirmBooking`, producing the real `Booking` that step 19 shows on the ticket.

## Inputs

- PRD 04 S16/S17 content/states; PRD 03 (voucher itemization, invalid-slot re-validation edge case, makespan captions differ shared vs. split).
- Design step 10 file + session log — `UnitSummaryAccordion`, flat confirm bar (0 glass — deliberate contrast with S11's glass bar), `VoucherRow` applied/empty states.
- `PricingCalculator`, `VoucherEligibilityService`, `BookingRepository.confirmBooking`.

## Open questions (ask at kickoff)

1. Re-validation on entering S16 (PRD 03 edge case: slot fills up while the user was on S15) — where does this live: a check inside `pilih_jadwal`'s exit or `ringkasan`'s entry (`build()`)? Recommend: S16 entry, since PRD 03 explicitly frames it as "re-validate on entering S16".
2. Confirm-error handling (inline banner + "Coba lagi") — confirm this reuses `DemoModeController`'s one-shot error-injection flag as its test hook (so the same mechanism S26 exposes to reviewers drives this state), not a separate fake-failure switch.

## Scope

### Files / classes to build

`booking/presentation/ringkasan/` — `ringkasan_page.dart`, `ringkasan_view_model.dart` (recompute on entry, confirm action), `components/summary_card.dart`, `components/unit_summary_accordion.dart`, `components/voucher_row.dart`, `components/payment_note.dart`, `state/ringkasan_state.dart`.

`booking/presentation/voucher/` — `voucher_page.dart`, `voucher_view_model.dart`, `components/voucher_card.dart`, `state/voucher_state.dart`.

### Tests to write

- `test/booking/presentation/ringkasan/ringkasan_view_model_test.dart` — canonical 3-unit total (Rp385.200 with `DISKON10`); invalid-slot banner shows the exact copy + both recovery actions; confirm success clears the draft and returns a `Booking` id; confirm error (via `DemoModeController` armed) shows the retry banner and doesn't clear the draft.
- `test/booking/presentation/voucher/voucher_view_model_test.dart` — eligible-first sort with saving amounts; ineligible rows show the exact shortfall reason text; single-motor booking makes all 4 vouchers ineligible with the right reasons.

## Checklist

### Build
- [ ] Open questions answered.
- [ ] S16 built for loading, ready-with-voucher, ready-no-voucher, invalid-slot, confirming, confirm-error, split-recap, single-unit, stress. S17 built for loading, populated, empty, single-motor.
- [ ] `/booking/summary`, `/booking/summary/voucher` routes wired.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test test/booking/presentation/ringkasan/ test/booking/presentation/voucher/` → green, canonical total verified.
- [ ] Screenshots vs. `design/pencil/exports/step10/*.png`.

### Review gate
- [ ] Status 🔵; show the user both screens (all states) + test results.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `028 - Create Booking Flow — Ringkasan & Voucher (S16, S17)`.
- [ ] Claude session file written (`docs/claude-session/apps/19-mobile-step18-summary-voucher-s16-s17.md`).
- [ ] Tracker in `00-index.md` set to ✅.

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
