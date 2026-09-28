# Claude Session Log — 15: Mobile-app step 13 — S10 Pilih Motor + `BookingDraft` provider

**Tool:** Claude Code, model Sonnet 5
**Date:** 2026-09-28
**Topic:** The booking flow's entry screen — multi-select 1–5 motors from the garage — plus the shared, non-autoDispose `BookingDraft` provider that S10 through S17 will all read/mutate.

## Initial prompt

"i want to do docs/plan/mobile-app/13-xx, interviewme with detail if need" + "extract util or mapper from viewmodel or repo impl like follow flutter skill in local project." Follow-up after the first build pass: user manually tested S10 on device, it worked, then asked to confirm the seed data (all garage motors showing "Sedang dalam servis"). Final: "approve do rest except commit push."

## Research performed

Three Explore agents in parallel: (1) design doc `06-s10-pilih-motor.md` + its session log + PRD refs (`04-screens.md` S10 section, `03-user-flows.md` F2, `07-architecture-tech.md`'s booking-draft-state section); (2) existing `GarageRepository`/`BookingRepository`/`Motor`/`BookingDraft` domain+data layers (steps 07/08, already built); (3) house presentation conventions from already-shipped screens (Home, Auth) — `Notifier<FlatFreezedState>` pattern, extension-based display mappers in `presentation/utils/`, hand-written (non-generated) Riverpod providers, `TsDialog`/`TsButton`/`TsAppBar` shared components.

Direct code reads then surfaced one thing the explore pass missed: core already has `lib/core/presentation/components/vehicle_select_card.dart` — a fixed-width 124px non-selection display card used by Home's horizontal garage list. Different shape from S10's full-width checkbox-select card, so the new one is named `MotorSelectCard` (booking-local) to avoid the name clash.

## Clarifying interview

Plan-mode `AskUserQuestion` round, 4 questions, all recommended options accepted:
1. `BookingDraft` provider scope — explicit-reset non-autoDispose `NotifierProvider` (not a nested `ProviderScope` route boundary).
2. `BookingStepper` (4-node) — build as a reusable component now (`booking/presentation/components/booking_stepper.dart`), not inline-then-extract later.
3. S10's close (X) app bar — extend core `TsAppBar` with a `TsAppBarLeading` (`none`/`back`/`close`) rather than a one-off booking app bar.
4. Exit dialog base — add `TsDialog.confirmSave(...)` to core `ts_dialog.dart` (mirrors `confirmDestructive`'s two-button shape, primary instead of danger), wrapped by `exit_booking_dialog.dart`.

Full plan written to `~/.claude/plans/i-want-to-do-breezy-riddle.md` and approved via `ExitPlanMode` before implementation.

## Execution

**Core additions (small, reused by later booking steps):** `TsAppBar` gained `TsAppBarLeading` + a `TsAppBar.close(...)` factory (close icon, custom semantic label, reused by S11+'s back+close combo later). `TsDialog` gained `confirmSave(...)`.

**`booking/presentation/`** (first presentation code in this feature — `booking/` previously had `data/` only):
- `di/booking_presentation_module.dart` — `bookingDraftProvider` (`NotifierProvider<BookingDraftViewModel, BookingDraft?>`, non-autoDispose) + `pilihMotorViewModelProvider`.
- `booking_draft/booking_draft_view_model.dart` — `BookingDraftViewModel extends Notifier<BookingDraft?>`. `_load()` fetches `getBookings()` once (caching a `Set<String>` of motor IDs with a non-terminal booking) then `getCurrentDraft()`/`createDraft()`. `selectMotor`/`deselectMotor` optimistically update `state` then persist via `updateDraft()`. `isMotorSelectable(motor)` and `hasActiveBooking(motorId)` are sync, reading the cached set — no per-card async calls.
- `pilih_motor/` — `pilih_motor_page.dart`, `pilih_motor_view_model.dart` (just loads `getMotors()` — selection itself lives in `bookingDraftProvider`, not duplicated), `state/pilih_motor_state.dart` (flat freezed, house pattern — not a sealed union), `components/motor_select_card.dart`, `components/add_motor_card.dart`.
- `components/booking_stepper.dart`, `components/exit_booking_dialog.dart`.
- `utils/motor_select_display.dart` (`MotorSelectDisplayX` extension on `Motor` — `disabledReason`, `semanticLabel`) and `utils/selection_footer_display.dart` (pure `selectionReasonLine(...)` function) — the mapper/util extraction the user explicitly asked for, following the house `home/presentation/utils/*_display.dart` pattern; both are unit-tested directly without pumping a widget.

**Router:** `/booking/vehicles`'s `Placeholder()` swapped for `PilihMotorPage`.

**PopScope/exit handling:** `canPop: selectedCount == 0` (dynamic); when blocked, `onPopInvokedWithResult` shows the confirm dialog then calls `Navigator.pop()` (unconditional — bypasses `canPop`, avoiding the classic pop-loop bug). Close-icon button uses the same handler.

**Tests:** `booking_draft_view_model_test.dart` (select/deselect/persist, 6th-motor block, active-booking-blocks-selection, terminal-booking-doesn't-block), `pilih_motor_view_model_test.dart` (loading/empty/error + `selectionReasonLine` pure-function cases), `exit_booking_dialog_widget_test.dart` (0-selected skips the dialog, "Lanjutkan booking" keeps the draft, "Simpan & keluar" exits non-destructively).

**Bugs found and fixed along the way:**
- `createDraftResult ?? throw UnimplementedError()` in `fake_booking_repository.dart` — `throw` needs parens after `??` in this Dart grammar position (`?? (throw ...)`).
- Widget tests need `MaterialApp(theme: AppTheme.light)`, not a bare default theme — `TsThemeExtension.of(context)` throws a null-check error otherwise (the extension is only registered on the app's real theme).

**Quality:** `flutter analyze` 0 issues; `dart format` clean; `flutter test test/booking/` 59/59. Full `flutter test` run checked for regressions from the shared `TsAppBar`/`TsDialog` edits — confirmed via `git stash` that the 7 failing tests (`router_test.dart` ×2, `otp_view_model_test.dart`, `splash_view_model_test.dart`, `app_shell_test.dart` ×3, all `pumpAndSettle` timeouts on infinite shimmer animations) reproduce identically on unmodified `main` — pre-existing, unrelated to this step.

## Review rounds

**Round 1:** user ran S10 on a real device — worked. Asked to confirm the "Sedang dalam servis" seed data. Traced the real cause: `DemoContentSeeder` (steps 019–022, runs on every Home load) seeds a canonical **active** booking at runtime covering motor_001/002/003 (Vario/Beat/PCX, `dikerjakan`/`diperiksa`), and the static `bk_seed_004` covers motor_004 (Supra X, `terjadwal`) — together every garage motor had a non-terminal booking, leaving zero free to demo S10's own happy path. This also contradicted the design doc's demo story (decision 1: Vario/Beat/PCX free + pre-selected, Ninja 250 the disabled example) — a conflict with the already-shipped Home/Tracking canonical booking that predates this step.

Presented 3 options; user picked "add fresh free motors + Ninja 250" (lowest regression risk — leaves the canonical booking and `bk_seed_004` untouched). Added `motor_005` (Ninja 250, `AB 7788 MN`, its own `bk_seed_005` active booking) + `motor_006`/`motor_007` (NMAX 155, Satria F150 — free) to `garage_seed.json`/`bookings_seed.json`. Updated `garage_repository_impl_test.dart`'s hardcoded seed counts (4→7, 5→8, since it now depends on total motor count, not just which ones). Re-ran `flutter analyze` (clean) and full `flutter test` (same 7 pre-existing unrelated failures, nothing new). Approved. Commit/push explicitly left to the user.

## Key decisions worth flagging to a reviewer

- Design decision 1's exact demo story ("Vario/Beat/PCX pre-selected, 3-of-5, carries to S11") no longer reproduces as written — those 3 motors stay locked by Home's canonical booking. When step 14 (S11) is built, its "3 units carry over" continuity will need to reference the new free motors (NMAX 155, Satria F150) instead, or whichever motors the tester actually selects.
- `MotorSelectCard` is intentionally a separate widget from core's existing `vehicle_select_card.dart` (different shape/purpose — Home's compact 124px display tile vs. S10's full-width checkbox-select card). Worth knowing if a future step is tempted to merge them.
- The design's "stress" states (360×640, text ×1.3) and tablet 2/3-col grid breakpoints were built (responsive `Wrap`-based layout, no hardcoded phone-only sizing) but not separately screenshot-verified against `design/pencil/exports/step06/*.png` — no simulator/device was available in this CLI session.
- `BookingStepper` and `TsAppBar`'s close-leading variant were built now (not in the step file's original scope list) because the design composes them into S10 and S11+ will need them unchanged — confirmed with the user at kickoff rather than assumed.

## Output

Files touched: `lib/booking/presentation/**` (new, full feature), `lib/core/presentation/components/{ts_app_bar,ts_dialog}.dart`, `lib/app/navigation/router.dart`, `test/booking/presentation/**` (new), `test/support/fake_booking_repository.dart`, `test/garage/data/repository/garage_repository_impl_test.dart`, `assets/mock/{garage_seed,bookings_seed}.json`. Not committed — staged for the user's own commit/push. Next step: 14 — S11 Detail Servis per Motor.
