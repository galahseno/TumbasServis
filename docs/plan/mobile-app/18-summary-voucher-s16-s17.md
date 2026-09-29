# Step 18 — S16 Ringkasan & S17 Pilih Voucher

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-28 |
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
- [x] Open questions answered (kickoff interview, 4 questions, all recommended options accepted — see session log).
- [x] S16 built: loading, ready-with-voucher, ready-no-voucher, invalid-slot (shared mode only, matches the design's own frame matrix), confirming, confirm-error, split-recap, single-unit. S17 built: loading, populated (eligible/ineligible grouped + "Tidak pakai voucher"), empty, single-motor (all ineligible).
- [x] `/booking/summary`, `/booking/summary/voucher` routes wired to `RingkasanPage`/`VoucherPage`.
- [ ] Stress frame (360×640, text ×1.3) — not separately verified; no simulator/device was exercised this session (see *Deviations* below).

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean on every step-18 file. (A repo-wide run also reformatted 7 unrelated pre-existing files elsewhere — those were reverted, left untouched, out of this step's scope.)
- [x] `flutter test test/booking/presentation/ringkasan/ test/booking/presentation/voucher/ test/booking/presentation/components/capacity_banner_test.dart` → 10/10 green, canonical Rp385.200 total verified (subtotal 428000 → 10% DISKON10 → 42800 discount → 385200 total); full `flutter test` → 380/380 green (no regressions).
- [ ] Screenshots vs. `design/pencil/exports/step10/*.png` — **not done**, see *Deviations*.

### Review gate
- [x] Status 🔵; user shown the file list + test results below.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `028 - Create Booking Flow — Ringkasan & Voucher (S16, S17)`.
- [x] Claude session file written (`docs/claude-session/apps/19-mobile-step18-summary-voucher-s16-s17.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Deviations from the original scope

- **No visual verification this session.** Only a macOS desktop target and a wireless physical iPhone were available (no simulator/emulator), so the app was not run and no screenshots were taken against `design/pencil/exports/step10/*.png`. Everything else (structure, copy, states, logic) was built and unit-tested against the design doc's exact numbers/copy, but pixel/spacing parity is unverified — flag this explicitly at review.
- **"Ubah `<motor>`" always opens S11 on its default active unit**, not the specific tapped unit — `DetailServisViewModel` resolves its own active tab internally and doesn't yet accept a target motor id from the route. Follow-up, not a blocker for P0.
- **`NoVoucherOption`/`VoucherCard` design components were merged into one `VoucherCard`** (used with `title: 'Tidak pakai voucher'` for the no-voucher row) rather than building a second component — same visual language, fewer files.
- **`SummaryCard` dropped the icon tile**, matching the design step's own build note ("with a 40 dp tile the canonical string wrapped to two lines").
- Split-mode slot-invalidity is not checked on S16 entry (only shared-mode is, matching the design's frame matrix, which has no split+invalid combo state).

## Review rounds

#### Round 1 — 2026-09-28
- **Shown:** file list (new `ringkasan/`, `voucher/` folders + display utils, `capacity_banner` amendment, DI/router wiring, fake-repo extensions), `flutter analyze`/`dart format`/`flutter test` results (10/10 new, 380/380 full suite).
- **User feedback:** "i test all and good, approve"
- **Changes made:** none.
- **Outcome:** approved.

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-28 | Kickoff | Read step file, design step 10 file + session log (39 frames, kickoff decisions, copy corrections applied post-hoc in steps 12/19), PRD 03/04, and the existing booking-flow code (step 17's `pilih_jadwal`, `booking_draft_view_model`, domain services, DI, router, fakes). 4 `AskUserQuestion` (re-validation timing, confirm-error demo hook, split-duration formula, voucher-undo mechanism) — all recommended options accepted |
| 2026-09-28 | Build | `capacity_banner.dart` amended (2nd action slot); `booking_draft_view_model.dart` gained `setVoucher`; new `ringkasan/` (page, view model, state, 5 components) and `voucher/` (page, view model, state, 1 component) folders; `ringkasan_display.dart`/`voucher_display.dart` presentation utils; DI providers + router wiring; `fake_booking_repository.dart`/`fake_catalog_repository.dart` extended for `confirmBooking`/`getVouchers` |
| 2026-09-28 | Fix | Riverpod rejected a synchronous provider-state write from `initState` (`router_test.dart` caught it) — deferred `RingkasanViewModel.reload()` behind `Future(() => …)` |
| 2026-09-28 | Quality | `flutter analyze` 0 issues; `dart format` clean; new tests 10/10 green (canonical total, slot-invalid banner copy, confirm success/demo-error, voucher undo, eligible/ineligible sort + shortfall text, capacity banner 2-action); full suite 380/380 green |
