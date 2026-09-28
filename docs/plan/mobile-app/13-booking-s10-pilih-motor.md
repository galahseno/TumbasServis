# Step 13 — S10 Pilih Motor

| | |
|---|---|
| **Status** | ✅ Done |
| **Layer** | Presentation, phone |
| **Priority** | P0 |
| **Owns** | `booking/presentation/pilih_motor/` (S10), `BookingDraft` ViewModel scaffold (survives S10–S17) |
| **PRD refs** | [04 S10](../../../prd/04-screens.md), [03 F2 vehicle selection](../../../prd/03-user-flows.md) |
| **Design refs** | `docs/plan/design/06-s10-pilih-motor.md` + `docs/claude-session/design/08-design-step06-s10-pilih-motor.md`, exports `design/pencil/exports/step06/` |
| **Depends on** | Steps 07 (garage), 08 (booking draft), 10 (shell/components) |
| **Claude session** | `docs/claude-session/apps/15-mobile-step13-booking-s10-pilih-motor.md` (14 was taken out of order by step 29's refactor session) |

## Goal

Build the booking flow's entry screen and — critically — the **shared, non-autoDispose `BookingDraft` provider** that S10 through S17 will all read/mutate. Getting this provider's lifetime right here saves rework in steps 14/17/18.

## Inputs

- PRD 07 *Booking draft state* section (non-autoDispose, scoped to the booking route sub-tree, disposed on flow exit/completion).
- PRD 04 S10 content/states; PRD 03 F2 (1–5 motors, disabled "Sedang dalam servis"/"Maks. 5 motor" reasons, exit-dialog rule).
- Design step 06 file + session log — exact copy, `VehicleSelectCard` states, "+ Tambah motor lain" card, sticky footer counter/reason-line behavior.
- `GarageRepository.getMotors()`, `BookingRepository.createDraft()/updateDraft()`.

## Open questions (ask at kickoff)

1. `BookingDraft` provider scope — a `ProviderScope` boundary wrapping the `/booking/*` route sub-tree (per the skill's suggestion) vs. a plain non-autoDispose `NotifierProvider` explicitly reset on flow exit/completion. Recommend the explicit-reset provider (simpler with `go_router`'s flat route tree; a nested `ProviderScope` per sub-route is more fragile with shell routes).
   **Answered:** explicit-reset non-autoDispose `NotifierProvider` — confirmed by the user at kickoff.
2. Exit dialog (`Keluar dari booking?`) — built once here as a reusable `booking/presentation/components/exit_booking_dialog.dart` (used by every step S10–S17's app-bar close action), confirm this is the right screen step to introduce it (recommend yes, since S10 is first to need it).
   **Answered:** yes — built here, wrapping a new `TsDialog.confirmSave(...)` added to core `ts_dialog.dart` (non-destructive two-button shape, mirrors `confirmDestructive` but with a primary, not danger, confirm button).
3. A motor added via S08 (not built until step 21) mid-flow — since `garage/presentation` (S08) doesn't exist yet, "+ Tambah motor lain" can only route to a placeholder for now; confirm this is an acceptable temporary gap (closed automatically once step 21 replaces the placeholder — the route already exists from step 10's stub).
   **Answered:** yes — routes to the existing `Routes.garageAdd` (`/garage/add`) placeholder; the "Motor ditambahkan" snackbar logic is wired (compares motor count before/after the push) so it activates automatically once step 21 lands.
4. *(Discovered during build, not in the original list.)* `BookingStepper` (4-node) and the S10 app-bar close icon are both composed by the design but weren't in this step's original file list. Built now as reusable pieces (`booking/presentation/components/booking_stepper.dart`; a close-leading variant added to core `TsAppBar`) so S11–S16 reuse them unchanged — confirmed by the user at kickoff.

## Scope

### Files / classes built

`booking/presentation/di/booking_presentation_module.dart` — `bookingDraftProvider` (the shared, explicitly-scoped Notifier) + `pilihMotorViewModelProvider`.

`booking/presentation/booking_draft/` — `booking_draft_view_model.dart` (`BookingDraftViewModel extends Notifier<BookingDraft?>`; methods: `selectMotor`, `deselectMotor`, `reset`, `isMotorSelectable(motor)`, `hasActiveBooking(motorId)`).

`booking/presentation/pilih_motor/` — `pilih_motor_page.dart`, `pilih_motor_view_model.dart`, `components/motor_select_card.dart`, `components/add_motor_card.dart`, `state/pilih_motor_state.dart` (loading/empty-garage/none-selected/selected/max-reached, derived from flags — not a sealed union, matches `HomeState`'s house pattern).

> **Naming note:** core already has `lib/core/presentation/components/vehicle_select_card.dart` — a fixed-width 124px non-selection display card used by Home's horizontal garage list. It's a different shape from S10's full-width checkbox-select card, so the new selectable card is named `MotorSelectCard` (booking-local) instead of reusing that name, to avoid colliding with the existing core widget.

`booking/presentation/components/exit_booking_dialog.dart` — reusable across S10–S17; wraps a new `TsDialog.confirmSave(...)` added to core `lib/core/presentation/components/ts_dialog.dart`.

`booking/presentation/components/booking_stepper.dart` — 4-node stepper (phone + wide), reusable unchanged by S11–S16.

`booking/presentation/utils/motor_select_display.dart` — `MotorSelectDisplayX` extension on `Motor` (`disabledReason`, `semanticLabel`) — the mapper/util extracted out of the ViewModel and card widget, following the house pattern in `home/presentation/utils/*_display.dart`.

`booking/presentation/utils/selection_footer_display.dart` — pure `selectionReasonLine(...)` function, extracted out of the footer widget so the reason-line rule is unit-testable without pumping a page.

**Core additions** (small, reused by later booking steps): `TsAppBar` gained a `TsAppBarLeading` (`none`/`back`/`close`) + `TsAppBar.close(...)` factory; `TsDialog` gained `confirmSave(...)` (primary + ghost button row, non-destructive, mirrors `confirmDestructive`'s shape).

### Tests to write

- `test/booking/presentation/booking_draft/booking_draft_view_model_test.dart` — select/deselect updates state; max-5 blocks a 6th; a motor with an active booking is not selectable.
- `test/booking/presentation/pilih_motor/pilih_motor_view_model_test.dart` — "Lanjut" disabled with "Pilih minimal 1 motor" at 0; disabled with "Lepas satu untuk memilih motor lain" at 5; empty-garage state shows the add-motor CTA.
- Widget test: exit dialog appears only when ≥1 motor is selected; both actions are non-destructive (draft persists either way).

## Checklist

### Build
- [x] Open questions answered (draft-provider scope decided and documented — this decision is referenced by steps 14/17/18, don't relitigate).
- [x] S10 built for loading/empty/none-selected/selected/max-reached/exit-dialog states. (No separate "stress" build pass — same responsive Wrap-based grid handles 360×640 and larger text via normal Flutter text scaling; not separately verified against the stress PNGs, see Quality note below.)
- [x] `/booking/vehicles` route wired; router redirect already confirms session before entry (pre-existing `_redirect` in `router.dart`, unchanged).

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean (on all files touched by this step).
- [x] `flutter test test/booking/` → green (59/59). Full `flutter test` run checked for regressions from the shared `TsAppBar`/`TsDialog` core edits — no new failures; 7 pre-existing failures (`router_test.dart` ×2, `otp_view_model_test.dart`, `splash_view_model_test.dart`, `app_shell_test.dart` ×3, all `pumpAndSettle` timeouts) reproduce identically on unmodified `main`, confirmed via `git stash` — unrelated to this step.
- [x] Manual run: user ran S10 on device. Original wording ("select 3 canonical motors") no longer applies — Vario/Beat/PCX/Supra X are locked by pre-existing demo bookings (see Session log), so the happy path now runs on the fresh free motors (NMAX 155, Satria F150) added to fix that. User confirmed it works.
- [ ] Screenshots vs. `design/pencil/exports/step06/*.png`. **Not done** — no simulator/device attached in this CLI session; pixel-parity pass still pending if the user wants it.

### Review gate
- [x] Status 🔵→✅; screen, draft-provider design decision, and test results shown to the user.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `023 - Create Booking Flow - Pilih Motor (S10)` (not committed — per house rule, staged only, left for the user's own commit/push).
- [x] Claude session file written (`docs/claude-session/apps/15-mobile-step13-booking-s10-pilih-motor.md` — 14 was taken out of order by step 29's refactor session).
- [x] Tracker in `00-index.md` set to ✅.

## Review rounds

**Round 1:** user ran S10 on device, all well; asked to confirm the "Sedang dalam servis" data. Root cause traced (see Session log) — not a bug, `DemoContentSeeder`'s canonical booking + static `bk_seed_004` left zero free motors. User picked "add fresh free motors + Ninja 250" fix over the two more-invasive alternatives; fix applied, re-verified (`flutter analyze` clean, full `flutter test` — same 7 pre-existing unrelated failures, nothing new). Approved. Commit/push explicitly left to the user.

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-28 | Explored design/PRD refs, existing garage/booking domain+data layers, and house presentation conventions (3 parallel Explore agents) before planning. | Found `GarageRepository.getMotors()`/`BookingRepository.createDraft()`/`getCurrentDraft()`/`updateDraft()` already built (steps 07/08); no `booking/presentation/` yet; house pattern is flat freezed state + `Notifier<State>` + extension-based display mappers in `presentation/utils/`. |
| 2026-09-28 | Plan mode: wrote implementation plan, asked user 4 clarifying questions (draft-provider scope, BookingStepper build-now-vs-later, TsAppBar close variant, exit-dialog base). | User picked the recommended option on all 4; plan approved via ExitPlanMode. |
| 2026-09-28 | Implementation: `bookingDraftProvider` (non-autoDispose), `BookingDraftViewModel`, `PilihMotorViewModel`/state/page, `MotorSelectCard`, `AddMotorCard`, `BookingStepper`, `exit_booking_dialog.dart`; extended core `TsAppBar` (close leading) and `TsDialog` (`confirmSave`); wired `/booking/vehicles` in `router.dart`. | Discovered mid-build that core already has a same-named-in-spirit `VehicleSelectCard` (124px Home display card, different shape) — named the new selectable card `MotorSelectCard` to avoid the clash; documented in Scope above. |
| 2026-09-28 | Wrote & ran tests (`booking_draft_view_model_test.dart`, `pilih_motor_view_model_test.dart`, `exit_booking_dialog_widget_test.dart`); `flutter analyze`; `dart format`; full `flutter test` regression sweep. | 59/59 booking tests green, 0 analyze issues, clean format. Fixed two bugs found along the way: `throw` needs parens after `??` (`fake_booking_repository.dart`), and widget tests need `MaterialApp(theme: AppTheme.light)` for `TsThemeExtension.of(context)` to resolve. Confirmed via `git stash` that 7 unrelated test failures pre-exist on `main`. |
| 2026-09-28 | User manual-tested S10 on device; approved, then asked to confirm all seed motors show "Sedang dalam servis". | Found it's real, not a bug: `DemoContentSeeder` (steps 019–022, runs on every Home load) seeds a canonical **active** booking covering motor_001/002/003 (Vario/Beat/PCX, `dikerjakan`/`diperiksa`), and the static `bk_seed_004` covers motor_004 (Supra X, `terjadwal`) — together every garage motor had a non-terminal booking, leaving zero free to demo S10's happy path. This also contradicted the design doc's demo story (decision 1: Vario/Beat/PCX free + selected, Ninja 250 the disabled example) — that story predates a conflict with the already-shipped Home/Tracking canonical booking. |
| 2026-09-28 | Fixed per user's chosen option: added Ninja 250 (`motor_005`, its own active `bk_seed_005` booking) + 2 fresh free motors (`motor_006` NMAX 155, `motor_007` Satria F150) to `garage_seed.json`/`bookings_seed.json`; left the canonical booking and `bk_seed_004` untouched (zero risk to Home/Tracking, already-shipped screens). Updated `garage_repository_impl_test.dart`'s hardcoded seed counts (4→7, 5→8). | `flutter analyze` 0 issues, full `flutter test` — same 7 pre-existing unrelated failures, nothing new. Garage now: Vario/Beat/PCX/Supra X still locked by pre-existing bookings (unchanged), Ninja 250 disabled ("Sedang dalam servis"), NMAX 155 + Satria F150 free and selectable — S10's happy path is demoable again, though the design doc's exact "Vario/Beat/PCX selected" story no longer reproduces (those 3 stay locked); S11's continuity will need to use the new free motors instead when that step is built. |
