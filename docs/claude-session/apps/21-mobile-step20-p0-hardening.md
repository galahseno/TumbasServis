# Claude Session Log — 21: Mobile-app step 20 — P0 hardening + checkpoint fixes

**Tool:** Claude Code, model Claude Sonnet 5.5 (Opus 5.5 in plan mode)
**Date:** 2026-09-29
**Topic:** Fix the state/UX bugs found in manual use of the step-19 P0 flow, then run the planned hardening pass (analyze/format/tests, layout matrix, manual device sweep).

## Initial prompt

"i want to do docs/plan/mobile-app/20-xx, interviewme with detail if need, use grepai to explore codebase — also i want to improve and fix this checkpoint feature" followed by a 10-item bug list (selection flicker, draft-motor mismatch, exit dialog only on step 1, snackbar never dismissing, keyboard overflow + Katalog state reset, single-select bengkel chips, no close icon on Detail bengkel, jadwal loading state, short-slot snackbar + split assist, voucher ripple/re-apply, and a sweep for the same bugs elsewhere). Follow-ups: Katalog search would not open the keyboard; Ringkasan edits grew the back stack.

## Research performed

- `grepai search` plus direct reads of the booking/catalog/workshop presentation layers, `BookingDraftViewModel`, `BookingRepositoryImpl`, `DemoContentSeeder`, `TsSnackbar`, `EmptyState`, the DI modules, `bookings_seed.json`, `garage_seed.json`, and the design index for the canonical demo motors.
- Context7 (Flutter docs): action `SnackBar`s no longer auto-dismiss unless `persist: false`.
- go_router 17.5 source: page `settings.name` is `state.name ?? state.path`, so `popUntil` can target `Routes.bookingSummary`.

## Clarifying interview

Four `AskUserQuestion` decisions:
1. **Exit flow** — back arrow that pops one step on steps 2–5; only S10 keeps X + dialog.
2. **Filter chips** — radio, Terdekat default, re-tap is a no-op.
3. **Short slot** — snackbar with "Pisah jadwal" that switches to split and auto-assigns; sibling conflicts also snackbar.
4. **Hardening tooling** — automated WidgetTester size matrix + one manual device pass; flat fallback accepted if `BackdropFilter` janks.

## Execution

Root causes and fixes:
- **Selection flicker** — `_persist` overwrote optimistic state with each (out-of-order) write result. Now optimistic-only state, serialized/coalesced writes.
- **Draft motor "Sedang dalam servis"** — `bookings_seed.json` had active booking `TS-261006-0419` on `motor_004` (the free demo-draft motor). Moved to `motor_006`. Added `refreshActiveBookings()` (prunes in-service draft motors + notice on S10) and stopped re-seeding the demo draft on every launch.
- **Stale screen state / voucher re-apply** — screen VMs (booking, catalog, workshop, auth) are `NotifierProvider.autoDispose`; `bookingDraftProvider` stays keep-alive. `VoucherViewModel._load` defers its first state write one microtask.
- **Snackbar** — `TsSnackbar`: `persist: false`, 4 s / 6 s, replaces the current one.
- **Keyboard overflow** — `EmptyState` scrolls when bounded; Katalog hides secondary rows while the keyboard is open.
- **Exit dialog / Detail bengkel** — `TsAppBar.back` on steps 2–5; extra close icon removed.
- **Bengkel filter** — `WorkshopFilter` enum replaces `openNowOnly` + `sortMode` (freezed regenerated).
- **Pilih jadwal** — skeleton grid while loading, per-request stale guard, `SlotTapOutcome` (selected/blocked/short/siblingConflict), `splitFromShortSlot`, `SlotChip.onDisabledTap`, text-scale-aware grid row height.
- **Voucher card** — `InkWell` → `GestureDetector` (no ripple).
- **Katalog search keyboard (follow-up)** — my keyboard-compaction used `if` on Column children, which re-created the search `TextField` (new focus node) as the IME opened. Fixed with `Visibility` + key.
- **Ringkasan back stack (follow-up)** — `summaryEditReturnProvider` marks an edit started from Ringkasan; Jadwal "Lanjut" and Detail servis "Lanjut" call `returnToSummary` (`popUntil` summary, stopping at `isFirst`) instead of pushing.
- **Layout matrix findings** — 8 real overflows fixed in `SlotChip`, `NavBar`, `TsLogo`, `AddMotorCard`, `WorkshopStatusPill`, `UnitSummaryAccordion`, Katalog.

Tests: existing VM tests keep autoDispose providers alive inside their wait helpers; new tests for the draft race and prune, seeder, jadwal outcomes/split/stale-date, voucher re-apply, `TsSnackbar`, `EmptyState`, filter chips, voucher card, pilih motor rapid taps, Detail servis back arrow, Katalog search focus, Ringkasan edit stack, and `test/layout/p0_layout_matrix_test.dart` (6 screens × 4 phone sizes × text ×1.0/×1.3, plus S05 and S12 keyboard-open).

Quality gates: `flutter analyze` 0 issues; `dart format --set-exit-if-changed .` clean (7 pre-existing unformatted test files reformatted); `flutter test` 475/475.

## Review rounds

- Round 1: Katalog search keyboard would not open; Ringkasan edits grew the back stack → both fixed with regression tests (suite 471 → 475).
- Round 2 (2026-09-29): user ran all P0 screens on device — "i test all and approve, do the rest except commit push". Approved, no changes.

## Key decisions worth flagging to a reviewer

- The "draft motor in service" bug was **seed data**, not only logic: the PRD-05 seed booking conflicted with the design's free Supra X. NMAX 155 is now the extra in-service motor. Existing installs keep old Hive data until app data is cleared.
- Provider `autoDispose` means anything reading a screen VM with `container.read` (tests) must keep it alive with `container.listen`.
- Detail servis "Lanjut" in edit mode skips the workshop/schedule steps; Ubah bengkel still walks Bengkel → Detail → Jadwal before returning.
- Snackbars on Pilih jadwal use `aboveNavBar: true` to clear the selection footer; the Detail servis "Salin" snackbar can still overlap its sticky bar.
- `BackdropFilter`: only the glass `NavBar` uses it in the P0 flow; the user's device pass reported no jank, no DevTools trace recorded, flat fallback not needed.

## Output

Tracker set to ✅ in `00-index.md`. Commit message proposed: `030 - Harden P0 Booking Flow (Fixes, Layout, Tests)`. Not committed or pushed. Next: step 21 — Garage S07–S09.
