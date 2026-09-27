# Step 23 — S23 Invoice & S24 Beri Ulasan

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Layer** | Presentation, phone |
| **Priority** | P1 |
| **Owns** | `invoice/presentation/` (S23), `review/presentation/` (S24) |
| **PRD refs** | [04 S23/S24](../../../prd/04-screens.md), [03 F4 completion→invoice→rating](../../../prd/03-user-flows.md) |
| **Design refs** | `docs/plan/design/17-invoice-rating-s23-s24.md` + `docs/claude-session/design/19-design-step17-invoice-rating.md`, exports `design/pencil/exports/step17/` |
| **Depends on** | Step 09 (`InvoiceRepository`, `ReviewRepository`), step 22 (S20's "Lihat invoice"/"Beri ulasan" entry points), 10 |
| **Claude session** | `docs/claude-session/apps/24-mobile-step23-invoice-review-s23-s24.md` (written after approval) |

## Goal

Per-unit itemized invoice with the mock "Tandai lunas" flow, and the hard-gated post-service review (workshop stars + optional per-mechanic rating, gated behind a paid invoice).

## Inputs

- PRD 04 S23/S24 content/states; PRD 03 F4 (non-destructive "Tandai lunas" confirm, review hard-gate copy on S20, ≥2-mechanic rule).
- Design step 17 file + session log — `RatingStars` word-label + "n dari 5", `ReviewRecap` read-only submitted state.
- `InvoiceRepository.getInvoice/markPaid`, `ReviewRepository.submitReview/getReview`.

## Open questions (ask at kickoff)

1. Confirm S20's "Lihat invoice"/"Beri ulasan" links (built as placeholders in step 22) now point to these real routes, and the disabled-with-reason state ("Tandai lunas di invoice dulu") reads live from `InvoiceRepository`, not a stale flag.

## Scope

### Files / classes to build

`invoice/presentation/di/invoice_presentation_module.dart`; `invoice/presentation/invoice/` — `invoice_page.dart`, `invoice_view_model.dart`, `components/invoice_header_card.dart`, `components/price_breakdown_invoice.dart`, `components/paid_banner.dart`, `state/invoice_state.dart`.

`review/presentation/di/review_presentation_module.dart`; `review/presentation/ulasan/` — `ulasan_page.dart`, `ulasan_view_model.dart`, `components/rating_stars.dart` (input, whole-star, word label), `components/mechanic_rating_row.dart`, `components/review_recap.dart`, `state/ulasan_state.dart`.

### Tests to write

- `test/invoice/presentation/invoice/invoice_view_model_test.dart` — per-unit lines match the canonical booking exactly; "Tandai lunas" confirm dialog copy; paid state unlocks "Beri ulasan".
- `test/review/presentation/ulasan/ulasan_view_model_test.dart` — mechanic section hidden for 1 mechanic, shown for ≥2; submit validated on submit (button stays enabled); submitted state shows the read-only recap; a pre-payment submit attempt is rejected (defense-in-depth check from step 09).

## Checklist

### Build
- [ ] Open questions answered.
- [ ] S23 built for unpaid/paid/error/loading/confirm-dialog; S24 built for default/validation/submitting/single-mechanic/keyboard/submitted.
- [ ] `/invoice/:bookingId`, `/review/:bookingId` routes wired; S20 links now real.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test test/invoice/ test/review/` → green.
- [ ] Screenshots vs. `design/pencil/exports/step17/*.png`.

### Review gate
- [ ] Status 🔵; show the user both screens (all states) + test results.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `033 - Create Invoice & Review Screens (S23, S24)`.
- [ ] Claude session file written (`docs/claude-session/apps/24-mobile-step23-invoice-review-s23-s24.md`).
- [ ] Tracker in `00-index.md` set to ✅.

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
