# Claude Session Log — 19: Mobile-app step 18 — S16 Ringkasan & S17 Pilih Voucher

**Tool:** Claude Code, model Claude Sonnet 5
**Date:** 2026-09-28
**Topic:** Booking summary/confirm screen (S16) and the voucher picker (S17) — final review + confirm, itemized estimate, invalid-slot re-validation, confirm-error demo hook, voucher eligibility + apply/undo.

## Initial prompt

"i want to do docs/plan/mobile-app/18-xx, interview me with detail if need, use grepai to explore codebase" (Plan mode.)

## Research performed

`grepai`/Agent tool calls hit a transient server-side classifier outage this session, so research was done directly with Read/Bash instead of Explore subagents:
- Design step 10 file + its session log — 39-frame matrix, 12 kickoff decisions, the canonical 3-unit voucher table (`DISKON10`/`HEMAT25`/`FLEET15`/`HEMAT75`), and the copy corrections applied *after* the original write-up (step 12 fix: S17 footer "Total Rp385.200" → "Total estimasi Rp385.200", CTA "Pakai voucher" → "Terapkan"; S16 banner "Tersisa 2 tempat" → "Tersisa 2 motor"; `VoucherRow` icon tile `accent-soft` → `surface-inset`).
- Existing code: `pilih_jadwal_view_model.dart`/`_page.dart` (step 17, closest structural precedent — `_waitForDraft` polling, `TsAppBar.close`, `BookingStepper`, `SelectionFooter`), `BookingDraftViewModel` (found `BookingDraft.voucherId` already existed as a field, no domain-model change needed), `BookingRepositoryImpl.confirmBooking` (already resolves the voucher/discount/total — no repo change needed; but no `DemoModeController` wiring at all, which became kickoff question 2), `VoucherEligibilityService`/`PricingCalculator`/`FleetDurationCalculator` (all reused as-is), `DemoModeController.consumeArmedError()` (existed since step 05 but never consumed by anything — this step is its first real caller), `CapacityBanner` (only a single action slot — the slot-invalid banner needs two: "Pisah jadwal"/"Pilih jam lain"), test fakes (`FakeBookingRepository.confirmBooking` threw `UnimplementedError`; `FakeCatalogRepository.getVouchers()` was hardcoded to an empty list — both needed extending).

## Clarifying interview

Four `AskUserQuestion` decisions, all recommended options accepted:
1. **Re-validation timing** — `RingkasanViewModel.build()`/`reload()`, re-run on every S16 entry (not just once on `pilih_jadwal`'s exit).
2. **Confirm-error demo hook** — checked in `RingkasanViewModel` before calling the repo (`consumeArmedError()` short-circuits `confirmBooking`), not by injecting `DemoModeController` into the already-approved `BookingRepositoryImpl`.
3. **Split-mode duration caption** — "Estimasi X jam per motor" uses the **max** per-unit duration across selected units (PRD 03 has no rule here; design step 10 flagged it as a new default).
4. **Voucher-removed Undo** — the view model keeps the just-removed `voucherId` in memory and re-persists it on "Urungkan", mirroring `PilihJadwalViewModel`'s existing in-memory `expandedMotorId` pattern.

## Execution

Files written/changed:
- `lib/booking/presentation/components/capacity_banner.dart` — added an optional second action (`actionLabel2`/`onAction2`), wrapped in a `Wrap` so both render side by side; S15's existing single-action banners unaffected.
- `lib/booking/presentation/booking_draft/booking_draft_view_model.dart` — new `setVoucher(String?)` mutator, same `copyWith` + `_persist` shape as the other setters.
- `lib/booking/presentation/utils/ringkasan_display.dart` — pure functions: `buildUnitLines` (per-unit services/parts/subtotal/duration from the draft + catalog lookups), `unitServiceSummary`, `estimateDurationCaption` (shared makespan vs. split max-per-unit), `jadwalSummaryLine`.
- `lib/booking/presentation/utils/voucher_display.dart` — `evaluateVouchers` (wraps `VoucherEligibilityService`, returns eligible sorted by saving + ineligible with shortfall text as a record).
- `lib/booking/presentation/ringkasan/` — `ringkasan_page.dart` (`ConsumerStatefulWidget`; `initState` fires `reload()` deferred via `Future(() => …)`, "Ubah"/voucher taps go through a `_navigateAndReload` helper that awaits the pushed route's pop before reloading — this is what actually satisfies "re-validate on every S16 entry", since a `Notifier`'s `build()` only ever runs once and popping a child route back to an already-mounted page does not re-run `initState`), `ringkasan_view_model.dart`, `state/ringkasan_state.dart` (+freezed), `components/{summary_card,unit_summary_accordion,voucher_row,payment_note,confirm_bar}.dart`.
- `lib/booking/presentation/voucher/` — `voucher_page.dart`, `voucher_view_model.dart` (reuses `ringkasanViewModelProvider`'s already-loaded `motorsById`/`serviceById`/`partById` instead of re-fetching garage/catalog, since S17 is only reachable from S16), `state/voucher_state.dart` (+freezed), `components/voucher_card.dart` (also doubles as the "Tidak pakai voucher" row).
- `lib/booking/presentation/di/booking_presentation_module.dart` — `ringkasanViewModelProvider`, `voucherViewModelProvider`.
- `lib/app/navigation/router.dart` — `/booking/summary` and `/booking/summary/voucher` `Placeholder()`s replaced with `RingkasanPage()`/`VoucherPage()`.
- `test/support/fake_booking_repository.dart` — `confirmBookingResult`/`confirmBookingCalls` added.
- `test/support/fake_catalog_repository.dart` — `vouchersResult` added (was hardcoded empty).

Tests added: `test/booking/presentation/ringkasan/ringkasan_view_model_test.dart` (5 — canonical total via the loaded lookups, invalid-slot banner copy, confirm success, confirm error via `DemoModeController.armNextWriteError()` without ever calling the repo, undo restores the voucher), `test/booking/presentation/voucher/voucher_view_model_test.dart` (3 — canonical eligible/ineligible split + sort + shortfall text, single-motor all-ineligible, apply persists + marks applied), `test/booking/presentation/components/capacity_banner_test.dart` (2 — single action, second action fires independently).

One real bug caught by `router_test.dart`'s "every declared route resolves without throwing" smoke test: `RingkasanPage.initState()` called `ringkasanViewModelProvider.notifier.reload()` synchronously, which writes `state` before any `await` — Riverpod refuses provider-state writes made synchronously from a widget lifecycle method ("Tried to modify a provider while the widget tree was building"). Fixed by deferring the call one tick: `Future(() => ref.read(...).reload())`.

A scope note, not a bug: `dart format .` run project-wide also reformatted 7 unrelated files with pre-existing formatting drift (test mappers/utils/katalog/home). Reverted those via `git checkout --` to keep the diff scoped to this step; step-18's own files were format-checked individually and are clean.

Quality gates: `flutter analyze` 0 issues; `dart format --set-exit-if-changed` clean on every step-18 file; `flutter test test/booking/presentation/ringkasan/ test/booking/presentation/voucher/ test/booking/presentation/components/capacity_banner_test.dart` 10/10; full suite 380/380 green (no regressions). No interactive run/screenshot diff against `design/pencil/exports/step10/*.png` this session — only a macOS desktop target and a wireless physical iPhone were available (no simulator/emulator).

## Review rounds

Round 1 (2026-09-28): shown the file list (new `ringkasan/`/`voucher/` folders + display utils, the `capacity_banner`/`booking_draft_view_model` amendments, DI/router wiring, fake-repo extensions), and the test/analyze/format results. Gap disclosed: no simulator/emulator available this session, so no screenshot comparison was done. User did their own manual testing on device and replied "i test all and good, approve and do rest except commit and push". Approved as shown, no changes requested.

## Key decisions worth flagging to a reviewer

- **Re-entry reload is route-pop-driven, not just `initState`.** `_navigateAndReload` (`await context.push(path); reload();`) is what makes "re-validate on every S16 entry" actually true for the Ubah/voucher round-trip case — a bare `initState` reload only covers the very first arrival at S16.
- **`DemoModeController.consumeArmedError()` is checked in the view model, before the repository call** — `BookingRepositoryImpl` (step 08, already approved) was left untouched, per the kickoff decision.
- **S17 deliberately reuses S16's already-loaded catalog/garage lookups** (`ringkasanViewModelProvider` state) rather than re-fetching them, since S17 is only ever reached from S16.
- **`NoVoucherOption`/`VoucherCard` were merged into one component** (`VoucherCard` used with `title: 'Tidak pakai voucher'` for the no-voucher row) — same visual language, one fewer file than the design's component list.
- **"Ubah `<motor>`" always opens S11 on its own default active unit**, not the specific tapped motor — `DetailServisViewModel` resolves its active tab internally and doesn't yet accept a target motor id from the route. Flagged as a follow-up, not a blocker for P0.
- Split-mode slot-invalidity is not checked on S16 entry — only shared-mode is, matching the design's own frame matrix (no split+invalid combo state exists in it).

## Output

Files touched: see Execution above. Tracker set to ✅ in `00-index.md`. Next step: 19 — S18 ticket + P0 end-to-end checkpoint, which will consume the `Booking` id `RingkasanViewModel.confirm()` now produces (`Routes.bookingSuccess`, currently still a `Placeholder()`).
