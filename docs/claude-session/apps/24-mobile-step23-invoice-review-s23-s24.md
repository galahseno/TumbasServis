# Claude Session Log — 24: Mobile-app step 23 — Invoice S23 & Beri Ulasan S24

**Tool:** Claude Code, model Claude Sonnet 5.5
**Date:** 2026-09-29
**Topic:** Build the invoice (S23) and post-service review (S24) presentation layer against design step 17, replace the `/invoice/:bookingId` and `/review/:bookingId` placeholder routes, and close the step 22 hand-off (S20 entry points).

## Initial prompt

"i want to do docs/plan/mobile-app/23-xx, interview me with detail if need, use grepai to explore codebase". After review: "i test all and good, approve do the rest except commit and push".

## Research performed

- `grepai` + direct reads of `InvoiceRepositoryImpl`/`ReviewRepositoryImpl`, S20 (`DetailBookingPage`/view model/state), router, `ConfirmBar`, `TsDialog`, `TsButton`, theme extension (`ratingStar` token already exists), PRD 03 F4 / 04 S23–S24, design step 17 (doc + session log + PNG exports).
- Findings that shaped scope: (1) S20 already pushed the routes and derived `canReview` live from the repos — only the router placeholders needed swapping, but S20 never reloaded after returning, so the gate went stale after paying; (2) `Invoice` carries no voucher code → look up via `Booking.voucherId` + `CatalogRepository.getVouchers()`; (3) no failure injection exists in `LatencySimulator`, so the S23 error state cannot be triggered on device before step 24; (4) `ConfirmBar` hard-coded "Total estimasi" / "Konfirmasi booking"; (5) no `share_plus` and S18 share was never built; (6) seed bookings are single-unit/single-mechanic, so the mechanic section only appears for the runtime canonical booking.

## Clarifying interview (4 decisions)

S23 error state → build UI, prove with a fake repo (no data-layer change); `ConfirmBar` → generalise and move to core; unpaid `/review/:id` → blocked state with "Buka invoice" (existing review opens as the recap); P2 "Bagikan" → skipped, logged as a gap.

## Execution

- **Core:** `ConfirmBar` moved to `core/presentation/components/` with `totalLabel/ctaLabel/loadingLabel` (Ringkasan updated; loading now shows spinner + label).
- **S20:** invoice/review actions push then `refresh()` on return.
- **S23** (`lib/invoice/presentation/`): `InvoiceViewModel` (invoice ‖ booking, then workshop ‖ review ‖ vouchers; `markPaid`, `retry`, `refresh`), `InvoicePage` (header card, paid banner, per-unit expanded breakdowns, totals with voucher line, payment note, `ConfirmBar` footer, confirm dialog, inline mark-paid error + retry, skeleton + disabled bar "Memuat invoice…"), components `InvoiceHeaderCard`, `PriceBreakdownInvoice`, `InvoiceTotals`, `PaidBanner`, `PaymentStatusTag`.
- **S24** (`lib/review/presentation/`): `UlasanViewModel` (validate on submit, 300-char clamp, optional mechanic ratings keyed by `mechanicId`, dropped when the section is hidden, blocked-unpaid, existing-review recap), `UlasanPage` (workshop stars + word label, comment, "Nilai montir", flat CTA, snackbar, recap, blocked `EmptyState`), components `RatingStars` (input/compact/display, slider semantics, arrow keys, focus ring, half stars in display), `RatingLabel`, `MechanicRatingRow`, `ReviewRecap`.
- **Navigation:** S23 → S24 and blocked S24 → S23 use `pushReplacement`, so the stack stays `S20 → S23|S24` and "Kembali ke detail booking" pops to S20; empty stack falls back to `go(bookingDetail)`.
- **Bugs caught by tests and fixed:** totals row, review recap and 5×48 dp star row overflowed at 320 dp; the floating snackbar covered the flat CTA (now `aboveNavBar`); sequential loads would have taken ~3 s with simulated latency (parallelised).

Tests: `invoice_view_model_test`, `invoice_page_test` (canonical totals Rp428.000 / −Rp42.800 / Rp385.200, dialog copy, paid banner, review hand-off, mark-paid failure + retry, load failure, layout matrix), `ulasan_view_model_test`, `ulasan_page_test` (default, single mechanic, validation, submit → recap, back to S20, failure, blocked, existing review, empty-stack back, layout matrix), `rating_stars_test` (tap, keys, semantics, half stars, words), S20 flow test for refresh-on-return; fakes/fixtures extended. `flutter analyze` 0 issues; `dart format` clean; `flutter test` 716/716 (baseline 666).

## Review rounds

- Round 1 (2026-09-29): user tested all screens on device — "i test all and good, approve do the rest except commit and push". No changes requested. Approved.

## Key decisions worth flagging to a reviewer

- S23's "Tandai lunas" error state is only reachable via a fake repo until step 24's S26 adds failure injection.
- The review hard gate is enforced three times: S20 disabled reason, S24 blocked state, `ReviewRepositoryImpl.submitReview` refusal.
- Submitting a review does not change the workshop's aggregate rating/count (static demo data).
- Seed invoices are recomputed from the live catalog (step 09 note), so `bk_seed_001`'s total is Rp178.000.
- Not built: P2 "Bagikan" on S23 (→ step 28); tablet layouts / `InvoiceSummaryCard` / live recap pane (→ step 27).
- Claude did not launch the app; on-device behaviour was verified by the user.

## Output

Tracker set to ✅ in `00-index.md`. Commit message proposed: `033 - Create Invoice & Review Screens (S23, S24)`. Not committed or pushed. Next: step 24 — Notifications, Profile, Demo (S06, S25, S26).
