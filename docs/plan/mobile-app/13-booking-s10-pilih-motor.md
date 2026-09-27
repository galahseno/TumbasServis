# Step 13 — S10 Pilih Motor

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Layer** | Presentation, phone |
| **Priority** | P0 |
| **Owns** | `booking/presentation/pilih_motor/` (S10), `BookingDraft` ViewModel scaffold (survives S10–S17) |
| **PRD refs** | [04 S10](../../../prd/04-screens.md), [03 F2 vehicle selection](../../../prd/03-user-flows.md) |
| **Design refs** | `docs/plan/design/06-s10-pilih-motor.md` + `docs/claude-session/design/08-design-step06-s10-pilih-motor.md`, exports `design/pencil/exports/step06/` |
| **Depends on** | Steps 07 (garage), 08 (booking draft), 10 (shell/components) |
| **Claude session** | `docs/claude-session/apps/14-mobile-step13-booking-s10-pilih-motor.md` (written after approval) |

## Goal

Build the booking flow's entry screen and — critically — the **shared, non-autoDispose `BookingDraft` provider** that S10 through S17 will all read/mutate. Getting this provider's lifetime right here saves rework in steps 14/17/18.

## Inputs

- PRD 07 *Booking draft state* section (non-autoDispose, scoped to the booking route sub-tree, disposed on flow exit/completion).
- PRD 04 S10 content/states; PRD 03 F2 (1–5 motors, disabled "Sedang dalam servis"/"Maks. 5 motor" reasons, exit-dialog rule).
- Design step 06 file + session log — exact copy, `VehicleSelectCard` states, "+ Tambah motor lain" card, sticky footer counter/reason-line behavior.
- `GarageRepository.getMotors()`, `BookingRepository.createDraft()/updateDraft()`.

## Open questions (ask at kickoff)

1. `BookingDraft` provider scope — a `ProviderScope` boundary wrapping the `/booking/*` route sub-tree (per the skill's suggestion) vs. a plain non-autoDispose `NotifierProvider` explicitly reset on flow exit/completion. Recommend the explicit-reset provider (simpler with `go_router`'s flat route tree; a nested `ProviderScope` per sub-route is more fragile with shell routes).
2. Exit dialog (`Keluar dari booking?`) — built once here as a reusable `booking/presentation/components/exit_booking_dialog.dart` (used by every step S10–S17's app-bar close action), confirm this is the right screen step to introduce it (recommend yes, since S10 is first to need it).
3. A motor added via S08 (not built until step 21) mid-flow — since `garage/presentation` (S08) doesn't exist yet, "+ Tambah motor lain" can only route to a placeholder for now; confirm this is an acceptable temporary gap (closed automatically once step 21 replaces the placeholder — the route already exists from step 10's stub).

## Scope

### Files / classes to build

`booking/presentation/di/booking_presentation_module.dart` — `bookingDraftProvider` (the shared, explicitly-scoped Notifier) + `pilihMotorViewModelProvider`.

`booking/presentation/booking_draft/` — `booking_draft_view_model.dart` (`BookingDraftViewModel extends Notifier<BookingDraft?>`; methods: `selectMotor`, `deselectMotor`, `reset`, `isMotorSelectable(motor)`).

`booking/presentation/pilih_motor/` — `pilih_motor_page.dart`, `pilih_motor_view_model.dart`, `components/vehicle_select_card.dart`, `state/pilih_motor_state.dart` (loading/empty-garage/none-selected/selected/max-reached).

`booking/presentation/components/exit_booking_dialog.dart` — reusable across S10–S17.

### Tests to write

- `test/booking/presentation/booking_draft/booking_draft_view_model_test.dart` — select/deselect updates state; max-5 blocks a 6th; a motor with an active booking is not selectable.
- `test/booking/presentation/pilih_motor/pilih_motor_view_model_test.dart` — "Lanjut" disabled with "Pilih minimal 1 motor" at 0; disabled with "Lepas satu untuk memilih motor lain" at 5; empty-garage state shows the add-motor CTA.
- Widget test: exit dialog appears only when ≥1 motor is selected; both actions are non-destructive (draft persists either way).

## Checklist

### Build
- [ ] Open questions answered (draft-provider scope decided and documented — this decision is referenced by steps 14/17/18, don't relitigate).
- [ ] S10 built for loading/empty/none-selected/selected/max-reached/exit-dialog/stress states.
- [ ] `/booking/vehicles` route wired; router redirect confirms session before entry.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test test/booking/` → green.
- [ ] Manual run: select 3 canonical motors, "Lanjut" navigates on (to a step-14 placeholder for now); backgrounding the app and returning keeps the selection.
- [ ] Screenshots vs. `design/pencil/exports/step06/*.png`.

### Review gate
- [ ] Status 🔵; show the user the screen + the draft-provider design decision + test results.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `023 - Create Booking Flow — Pilih Motor (S10)`.
- [ ] Claude session file written (`docs/claude-session/apps/14-mobile-step13-booking-s10-pilih-motor.md`).
- [ ] Tracker in `00-index.md` set to ✅.

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
