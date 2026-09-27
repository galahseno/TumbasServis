# Step 22 — S19 Riwayat, S20 Detail Booking, S21 Lacak Unit, S22 Ubah Jadwal/Batalkan

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Layer** | Presentation, phone |
| **Priority** | P1 |
| **Owns** | `tracking/presentation/` (S19, S20, S21, S22) |
| **PRD refs** | [04 S19–S22](../../../prd/04-screens.md), [03 F3 tracking, F6 cancel/modify](../../../prd/03-user-flows.md) |
| **Design refs** | `docs/plan/design/16-tracking-s19-s22.md` + `docs/claude-session/design/18-design-step16-tracking.md`, exports `design/pencil/exports/step16/` |
| **Depends on** | Step 09 (`TrackingRepository`/`TrackingSimulator`), step 08 (`BookingRepository`), 10 |
| **Claude session** | `docs/claude-session/apps/23-mobile-step22-tracking-s19-s22.md` (written after approval) |

## Goal

Booking history, the per-booking hub, the live per-unit status timeline (wired to the real `TrackingSimulator`), and the reschedule/cancel sheets. Replaces the S05 active-booking-card and S09 "Lacak servis" placeholder routes.

## Inputs

- PRD 04 S19–S22 content/states; PRD 03 F3 (auto-advance timer, notification push, S05/S06 badge agreement), F6 (cancel scope choice, reschedule re-validation, checked-in units become immutable).
- Design step 16 file + session log — scrolling underline tabs with counts, flat `UnitStatusRow`, cancel-scope chooser with wrapping reason chips.
- `TrackingRepository.watchUnitStatus`, `BookingRepository.cancelBooking/rescheduleBooking`.

## Open questions (ask at kickoff)

1. S21's `DemoModeShortcut` ("Majukan status"/"Reset") — this is the *same* simulator control S26 (step 24) will also expose; confirm both call the identical `TrackingRepository.advanceUnitStatus/resetUnitStatus` methods so there's exactly one source of truth (no duplicated advance logic between the two screens).
2. Live `Stream` consumption in `StatusTimeline` — `ref.watch` a `StreamProvider.family<UnitStatus, (bookingId, unitCode)>` per unit, confirm this is the right granularity vs. one stream per booking.

## Scope

### Files / classes to build

`tracking/presentation/di/tracking_presentation_module.dart`.

`tracking/presentation/riwayat/` — `riwayat_page.dart`, `riwayat_view_model.dart` (tab counts), `components/history_tab_row.dart`, `components/booking_history_card.dart`, `state/riwayat_state.dart`.

`tracking/presentation/detail_booking/` — `detail_booking_page.dart`, `detail_booking_view_model.dart`, `components/fleet_progress.dart` (full version — extends the S05 mini from step 12), `components/unit_status_row.dart`, `state/detail_booking_state.dart`.

`tracking/presentation/lacak_unit/` — `lacak_unit_page.dart`, `lacak_unit_view_model.dart` (watches the live stream), `components/status_timeline.dart`, `components/mechanic_card.dart`, `components/demo_mode_shortcut.dart`, `state/lacak_unit_state.dart`.

`tracking/presentation/ubah_jadwal_batalkan/` — `ubah_jadwal_sheet.dart`, `batalkan_dialog.dart`, `components/cancel_scope_chooser.dart`, shared view model logic reusing step 17's slot-picking components.

### Tests to write

- `test/tracking/presentation/riwayat/riwayat_view_model_test.dart` — tab counts match the 4 seed bookings; motor-filtered entry (from S09) shows the dismissible chip.
- `test/tracking/presentation/lacak_unit/lacak_unit_view_model_test.dart` — stream-driven state reaches `Selesai` (`fakeAsync`); demo shortcut and S26 (once built) drive the identical underlying method.
- `test/tracking/presentation/ubah_jadwal_batalkan/` — cancel-scope (whole vs. one-unit) recomputes remaining units/price; reschedule blocked once any unit is checked in.

## Checklist

### Build
- [ ] Open questions answered.
- [ ] S19 built for loading/empty-per-tab/populated-per-tab; S20 for all 5 statuses + loading; S21 for loading/live/completed/cancelled; S22 for sheet/loading/error/dialog/success-snackbar.
- [ ] `/bookings`, `/bookings/:id`, `/bookings/:id/unit/:unitCode` routes wired; S05 active-booking card and S09 "Lacak servis" link now point here for real.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test test/tracking/` → green.
- [ ] Screenshots vs. `design/pencil/exports/step16/*.png`.

### Review gate
- [ ] Status 🔵; show the user all 4 screens (all states) + the live-tracking demo + test results.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `032 - Create Tracking Screens (S19–S22)`.
- [ ] Claude session file written (`docs/claude-session/apps/23-mobile-step22-tracking-s19-s22.md`).
- [ ] Tracker in `00-index.md` set to ✅.

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
