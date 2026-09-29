# Step 23 — S23 Invoice & S24 Beri Ulasan

| | |
|---|---|
| **Status** | ✅ Done |
| **Layer** | Presentation, phone |
| **Priority** | P1 |
| **Owns** | `invoice/presentation/` (S23), `review/presentation/` (S24) |
| **PRD refs** | [04 S23/S24](../../../prd/04-screens.md), [03 F4 completion→invoice→rating](../../../prd/03-user-flows.md) |
| **Design refs** | `docs/plan/design/17-invoice-rating-s23-s24.md` + `docs/claude-session/design/19-design-step17-invoice-rating.md`, exports `design/pencil/exports/step17/` |
| **Depends on** | Step 09 (`InvoiceRepository`, `ReviewRepository`), step 22 (S20's "Lihat invoice"/"Beri ulasan" entry points), 10 |
| **Claude session** | `docs/claude-session/apps/24-mobile-step23-invoice-review-s23-s24.md` |

## Goal

Per-unit itemized invoice with the mock "Tandai lunas" flow, and the hard-gated post-service review (workshop stars + optional per-mechanic rating, gated behind a paid invoice).

## Inputs

- PRD 04 S23/S24 content/states; PRD 03 F4 (non-destructive "Tandai lunas" confirm, review hard-gate copy on S20, ≥2-mechanic rule).
- Design step 17 file + session log — `RatingStars` word-label + "n dari 5", `ReviewRecap` read-only submitted state.
- `InvoiceRepository.getInvoice/markPaid`, `ReviewRepository.submitReview/getReview`.

## Open questions (ask at kickoff)

1. Confirm S20's "Lihat invoice"/"Beri ulasan" links (built as placeholders in step 22) now point to these real routes, and the disabled-with-reason state ("Tandai lunas di invoice dulu") reads live from `InvoiceRepository`, not a stale flag.
   - **Answered (2026-09-29):** confirmed. S20 already pushed `Routes.invoice/review` and derives `canReview = invoicePaid && !hasReview` from `invoiceRepositoryProvider`/`reviewRepositoryProvider` on every load (`detail_booking_view_model.dart`), so only the router `Placeholder`s were swapped. One gap found + fixed: S20 never reloaded after returning from S23/S24, so the gate stayed stale after "Tandai lunas" → S20 now `await`s the push and calls `refresh()` (covered by a flow test).

### Kickoff decisions (interview 2026-09-29)

| # | Topic | Decision |
|---|---|---|
| 1 | S23 error state ("Tandai lunas" fails) | Inline error + "Coba lagi" built; proven by VM/widget tests with a fake repo. No data-layer failure injection, so it cannot be triggered on device until step 24's S26 "Simulasikan galat" |
| 2 | `ConfirmBar` | Generalized and moved to `core/presentation/components/confirm_bar.dart` (`totalLabel`, `ctaLabel`, `loadingLabel`); Ringkasan passes its old copy. Loading state now shows spinner + label (was spinner-only) — matches the design's "loading CTA keeps its label" |
| 3 | Review gate | `/review/:bookingId` while unpaid → blocked `EmptyState` "Tandai lunas di invoice dulu" + "Buka invoice" (defense-in-depth on top of the repo refusal). Same route serves "Lihat ulasan": an existing review opens straight in the read-only recap |
| 4 | P2 "Bagikan" (S23) | Skipped (no `share_plus`; S18 share never built) — see known gaps |

Defaults applied without asking: design step 17 kickoff decisions 1–10 (dialog copy, whole-star input 5×48 dp + word label + "n dari 5", optional mechanic rows hidden for <2 mechanics, submitted = same-screen recap + snackbar + "Kembali ke detail booking", 300-char comment validated on submit, submit always enabled, sentence-case CTAs, dismiss "Batal").

Build decisions made while implementing:

- **Navigation:** S23 "Beri ulasan"/"Lihat ulasan" and the S24 blocked-state "Buka invoice" use `pushReplacement`, so the stack stays `S20 → S23|S24` and "Kembali ke detail booking" (pop) lands on S20; with an empty stack (deep link) back falls back to `go(bookingDetail)`.
- **S24 send failure** = error snackbar, form kept (not an inline banner); snackbars use `aboveNavBar` so they never cover the flat CTA bar.
- **Loading** is parallelised in both view models (invoice ‖ booking, then workshop ‖ review ‖ vouchers) — sequential simulated latency would have made S23 take ~3 s.
- **Mechanic rows** come from distinct `BookingUnit.mechanicId`s resolved via `WorkshopRepository.getMechanics()`; unknown ids are ignored; tapping the same mechanic star again clears that (optional) rating. Ratings are dropped from the saved `Review` when the section is hidden.
- **RatingStars** uses Material `star_rounded / star_outline_rounded / star_half_rounded` (state = shape, `ratingStar` token colour); input is a `slider`-semantics control with arrow-key + increase/decrease actions and a 2 dp focus ring; the focus wrapper is 2 dp padding so 5 × 48 dp fits the 248 dp card at 320 dp width.
- **Total row:** `PaymentStatusTag` sits under the total (beside it overflowed at 320 dp); the header card also carries the tag.

## Scope

### Files / classes to build

`invoice/presentation/di/invoice_presentation_module.dart`; `invoice/presentation/invoice/` — `invoice_page.dart`, `invoice_view_model.dart`, `components/invoice_header_card.dart`, `components/price_breakdown_invoice.dart`, `components/invoice_totals.dart`, `components/paid_banner.dart`, `components/payment_status_tag.dart`, `state/invoice_state.dart`.

`review/presentation/di/review_presentation_module.dart`; `review/presentation/ulasan/` — `ulasan_page.dart`, `ulasan_view_model.dart`, `components/rating_stars.dart` (input, whole-star, word label), `components/mechanic_rating_row.dart`, `components/review_recap.dart`, `state/ulasan_state.dart`.

### Additive core/S20 changes (approved at kickoff / found while building)

- `ConfirmBar` moved to `core/presentation/components/` and parametrised (Ringkasan import + copy updated).
- `DetailBookingPage`: invoice/review actions go through `_openAndRefresh` (push, then `refresh()`).
- Router: both `Placeholder`s replaced by `InvoicePage` / `UlasanPage`.
- Test support: `FakeInvoiceRepository` (lines, discount, paid time, `failMarkPaid`, `delay`, call logs), `FakeReviewRepository` (`failSubmit`, call log), `invoice_review_fixtures.dart` (canonical 3-unit booking + lines, single-mechanic booking, DISKON10), both fakes added to `homeScreenFakeOverrides`.

### Tests to write

- `test/invoice/presentation/invoice/invoice_view_model_test.dart` — per-unit lines match the canonical booking exactly; "Tandai lunas" confirm dialog copy; paid state unlocks "Beri ulasan".
- `test/review/presentation/ulasan/ulasan_view_model_test.dart` — mechanic section hidden for 1 mechanic, shown for ≥2; submit validated on submit (button stays enabled); submitted state shows the read-only recap; a pre-payment submit attempt is rejected (defense-in-depth check from step 09).

## Checklist

### Build
- [x] Open questions answered (+ kickoff interview).
- [x] S23 built for unpaid/paid/error/loading/confirm-dialog; S24 built for default/validation/submitting/single-mechanic/keyboard/submitted (+ blocked-unpaid).
- [x] `/invoice/:bookingId`, `/review/:bookingId` routes wired; S20 links now real.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test test/invoice/ test/review/` → green (full suite: 716 passing, was 666).
- [x] Screenshots vs. `design/pencil/exports/step17/*.png` — PNGs used as the build reference; all screens then tested by the user on device (no automated pixel diff).

### Review gate
- [x] Status 🔵; show the user both screens (all states) + test results.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `033 - Create Invoice & Review Screens (S23, S24)`.
- [x] Claude session file written (`docs/claude-session/apps/24-mobile-step23-invoice-review-s23-s24.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Review rounds

- Round 1 (2026-09-29): user tested all screens on device — "i test all and good, approve do the rest except commit and push". No changes requested. Approved.

### Known gaps / notes for the reviewer
- P2 "Bagikan" on S23 (paid) not built — no `share_plus` and S18's share was never built; candidate for step 28.
- S23 "Tandai lunas" error state exists (inline + "Coba lagi") but cannot be triggered on device until step 24 adds failure injection.
- The S24 mechanic section only appears for the runtime canonical booking (Pak Anto A/C, Mas Rudi B); seed bookings are single-unit/single-mechanic. A workshop's aggregate rating/count is not changed by a submitted review (static demo).
- Seed invoices are recomputed from the live catalog (step 09 note), so `bk_seed_001`'s total is Rp178.000, not its stored Rp143.000.
- Phone only; tablet layouts (S23 breakdown 720 + `InvoiceSummaryCard` 360, S24 live recap pane) are step 27. No `InvoiceSummaryCard` built.
- Notification deep link `/tracking/...` and the S06 "invoice ready → S23" mapping are step 24.
- The app was not launched by Claude in this session; layout was verified by widget tests (320×568 ×1.0, 360×640 ×1.3, 412×915 ×1.3) and analyzer, and on-device behaviour by the user.

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-29 | Explored data/domain/S20 wiring/design step 17 with grepai + reads; interview (4 decisions) | Plan approved |
| 2026-09-29 | Core: `ConfirmBar` → core + params; S20 refresh-on-return; router wired | analyze clean |
| 2026-09-29 | S23: state/VM/page + header, breakdown, totals, paid banner, tag; S24: state/VM/page + `RatingStars`/`RatingLabel`, mechanic row, recap | analyze clean |
| 2026-09-29 | Tests: invoice VM + page, ulasan VM + page, `RatingStars`, S20 refresh; fixed real bugs found by them (totals row + recap + star row overflow at 320 dp; snackbar covering CTA); parallelised loads | 716/716 green, analyze + format clean |
| 2026-09-29 | User on-device review | Approved, no changes |
| 2026-09-29 | Close: session file, tracker ✅, files staged (not committed) | Done |
