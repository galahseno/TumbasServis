# Step 22 — S19 Riwayat, S20 Detail Booking, S21 Lacak Unit, S22 Ubah Jadwal/Batalkan

| | |
|---|---|
| **Status** | ✅ Done |
| **Layer** | Presentation, phone |
| **Priority** | P1 |
| **Owns** | `tracking/presentation/` (S19, S20, S21, S22) |
| **PRD refs** | [04 S19–S22](../../../prd/04-screens.md), [03 F3 tracking, F6 cancel/modify](../../../prd/03-user-flows.md) |
| **Design refs** | `docs/plan/design/16-tracking-s19-s22.md` + `docs/claude-session/design/18-design-step16-tracking.md`, exports `design/pencil/exports/step16/` |
| **Depends on** | Step 09 (`TrackingRepository`/`TrackingSimulator`), step 08 (`BookingRepository`), 10 |
| **Claude session** | `docs/claude-session/apps/23-mobile-step22-tracking-s19-s22.md` |

## Goal

Booking history, the per-booking hub, the live per-unit status timeline (wired to the real `TrackingSimulator`), and the reschedule/cancel sheets. Replaces the S05 active-booking-card and S09 "Lacak servis" placeholder routes.

## Inputs

- PRD 04 S19–S22 content/states; PRD 03 F3 (auto-advance timer, notification push, S05/S06 badge agreement), F6 (cancel scope choice, reschedule re-validation, checked-in units become immutable).
- Design step 16 file + session log — scrolling underline tabs with counts, flat `UnitStatusRow`, cancel-scope chooser with wrapping reason chips.
- `TrackingRepository.watchUnitStatus`, `BookingRepository.cancelBooking/rescheduleBooking`.

## Open questions (ask at kickoff)

1. S21's `DemoModeShortcut` ("Majukan status"/"Reset") — this is the *same* simulator control S26 (step 24) will also expose; confirm both call the identical `TrackingRepository.advanceUnitStatus/resetUnitStatus` methods so there's exactly one source of truth (no duplicated advance logic between the two screens).
   - **Answered (2026-09-29):** confirmed — S21 calls only those two repo methods (a view-model test asserts it). ⚠ `TrackingSimulator.advanceAll()/resetAll()` bypass the repo (memory only); step 22's sync coordinator now persists every simulator transition so they no longer desync, but step 24 should still loop the repo per unit (noted in the step 24 file).
2. Live `Stream` consumption in `StatusTimeline` — `ref.watch` a `StreamProvider.family<UnitStatus, (bookingId, unitCode)>` per unit, confirm this is the right granularity vs. one stream per booking.
   - **Answered (2026-09-29), with a correction:** `watchUnitStatus` emits `BookingUnit` (not `UnitStatus`). S21 subscribes to one unit stream in its view model; S20 subscribes to one stream per non-terminal unit and re-derives the booking status with `BookingStatusDerivation`. Family view-model providers (no `StreamProvider`) so subscriptions are cancelled in `ref.onDispose`.

### Kickoff decisions (interview 2026-09-29)

| # | Topic | Decision |
|---|---|---|
| 1 | Step 09's known gap: timer ticks not persisted, simulator not rehydrated after relaunch (Majukan after restart wrote Check-in *backwards*) | **Fixed in this step**: `TrackingSimulator.hydrate` + `transitions`, `TrackingSyncCoordinator` persists every transition and hydrates at start-up, `TrackingRepositoryImpl` hydrates lazily, `TrackingStatusWriter` is idempotent + serialized |
| 2 | Mechanics (`mechanics.json` loaded nowhere; live demo booking had no `mechanicId`) | `WorkshopRepository.getMechanics()`; writer assigns on first leave of Terjadwal (A/C → Pak Anto `mech_002`, B → Mas Rudi `mech_001`), assign-if-null, reset keeps it |
| 3 | Cancel reason chips | Persisted: optional `reason` on `BookingRepository.cancelBooking` → Dibatalkan `StatusEvent.note` |
| 4 | "Ubah jadwal" on split-schedule bookings | Visible but disabled with reason "Jadwal per motor belum bisa diubah di demo" (design = annotation only); Batalkan still works per unit |
| 5 | Live scope | S20 + S21 live; S05 + S19 reload on return / tab re-entry (no new global stream) |
| 6 | "Booking lagi" | Built: S10 accepts a list of motors to pre-check (in-service motors skipped, max 5) |
| 7 | S19 default tab | Berlangsung, else first non-empty tab |
| 8 | Back on S20/S21 | `canPop ? pop : go(Riwayat / S20)` — S18 reaches S20 with `context.go` (empty stack) |

Data note: the demo data has 5 seed bookings + the runtime canonical `TS-260929-0417`, so S19 counts are **Mendatang 2 · Berlangsung 1 · Selesai 2 · Dibatalkan 1** (design mock shows Mendatang 1; the step's old "4 seed bookings" test wording was wrong). Seed left untouched.

## Scope

### Files / classes to build

`tracking/presentation/di/tracking_presentation_module.dart`.

`tracking/presentation/riwayat/` — `riwayat_page.dart`, `riwayat_view_model.dart` (tab counts), `components/history_tab_row.dart`, `components/booking_history_card.dart`, `state/riwayat_state.dart`.

`tracking/presentation/detail_booking/` — `detail_booking_page.dart`, `detail_booking_view_model.dart`, `components/fleet_progress.dart` (full version — extends the S05 mini from step 12), `components/unit_status_row.dart`, `state/detail_booking_state.dart`.

`tracking/presentation/lacak_unit/` — `lacak_unit_page.dart`, `lacak_unit_view_model.dart` (watches the live stream), `components/status_timeline.dart`, `components/mechanic_card.dart`, `components/demo_mode_shortcut.dart`, `state/lacak_unit_state.dart`.

`tracking/presentation/ubah_jadwal_batalkan/` — `ubah_jadwal_sheet.dart`, `batalkan_dialog.dart`, `components/cancel_scope_chooser.dart`, shared view model logic reusing step 17's slot-picking components.

### Additive data/domain changes (approved at kickoff)

- `TrackingSimulator`: `hydrate` (no emit; resumes auto-advance for mid-flow units), `isTracking`, sync `transitions` stream.
- `TrackingStatusWriter`: idempotent + serialized writes, assigns `mechanicId` when a unit first leaves Terjadwal, `pendingWrites` flush.
- New `core/data/service/tracking_sync_coordinator.dart` (started in `bootstrap.dart`): hydrates the simulator from the store and persists every transition (timer ticks included). `TrackingRepositoryImpl` hydrates lazily and flushes pending writes before re-reading a unit for the stream.
- `WorkshopRepository.getMechanics()`; `BookingRepository.cancelBooking(..., reason)`; `rescheduleBooking` (shared) ignores cancelled units.
- `BookingDraftViewModel.preselectMotors` + `PilihMotorPage(preselectMotorIds)` + router `extra` accepts `String | List<String>`.
- Core UI: `TsDialog.custom/headerBlock`, `TsButton.loadingLabel`, `FleetProgress.legendLabels`, `SlotChip.captionOverride`, `TsChip` label ellipsis, `AppShell.onBranchSelected` (router refreshes Riwayat on tab re-select).

### Tests to write

- `test/tracking/presentation/riwayat/riwayat_view_model_test.dart` — tab counts match the demo data (Mendatang 2 · Berlangsung 1 · Selesai 2 · Dibatalkan 1); motor-filtered entry (from S09) shows the dismissible chip.
- `test/tracking/presentation/lacak_unit/lacak_unit_view_model_test.dart` — stream-driven state reaches `Selesai` (`fakeAsync`); demo shortcut and S26 (once built) drive the identical underlying method.
- `test/tracking/presentation/ubah_jadwal_batalkan/` — cancel-scope (whole vs. one-unit) recomputes remaining units/price; reschedule blocked once any unit is checked in.

## Checklist

### Build
- [x] Open questions answered (+ kickoff interview).
- [x] S19 built for loading/empty-per-tab/populated-per-tab; S20 for all 5 statuses + loading; S21 for loading/live/completed/cancelled; S22 for sheet/loading/error/dialog/success-snackbar.
- [x] `/bookings`, `/bookings/:id`, `/bookings/:id/unit/:unitCode` routes wired; S05 active-booking card and S09 "Lacak servis" link now point here for real.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test test/tracking/` → green (full suite: 666 passing).
- [x] Screenshots vs. `design/pencil/exports/step16/*.png` — PNGs used as the build reference; all screens then tested by the user on device (no automated pixel diff).

### Review gate
- [x] Status 🔵; show the user all 4 screens (all states) + the live-tracking demo + test results.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `032 - Create Tracking Screens (S19–S22)`.
- [x] Claude session file written (`docs/claude-session/apps/23-mobile-step22-tracking-s19-s22.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Review rounds

- Round 1 (2026-09-29): user tested all screens on device — "i test all is okay, approve do rest except commit and push". One change requested: remove the ripple/splash on the S19 Riwayat tabs (Mendatang … Dibatalkan) → `InkWell` uses `NoSplash` with transparent highlight/hover. While re-verifying, the tab scroll-into-view was also fixed to scroll only when the active tab is clipped (centring pushed the first tab off the left edge), the S19 loading skeleton no longer overflows at 320 dp, and `TsChip` labels ellipsize instead of overflowing at large text. Approved.

### Known gaps / notes for the reviewer
- No motor silhouette art / tablet layouts (S19 list-detail, S20 split, S21 side column, S22 centered modal) — step 26/27.
- S21 `MechanicCard` omits the design's "· 214 servis" (no such data in the model); ETA is `slot start + unit duration` ("±HH.mm"), not a mechanic-updated value.
- "Ubah jadwal" is shared-slot only; split bookings show it disabled with a reason (design = annotation only).
- "Lihat invoice", "Beri ulasan/Lihat ulasan" push `Routes.invoice/review`, still `Placeholder`s until step 23.
- Home "Lihat semua (n)" uses `context.go(Routes.bookings)`; S09 "Lihat semua" uses `context.push(Routes.bookings, extra: motorId)` (filtered page with back + chip) — covered by a widget test.
- Riwayat/Home reload on return from S20 and Riwayat also on tab re-select; there is no live stream for S05/S19 while they stay visible.
- Notification `deepLink` is `/tracking/...` (not a real route) and step 24 should loop the repo for "Majukan semua" — both noted in the step 24 file.
- The app was not launched by Claude in this session; on-device behavior (live timers, relaunch persistence) was verified by the user.

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-29 | Explored data/domain/presentation with grepai + reads; found persistence/mechanic/cancel-reason/multi-preselect gaps; interview (8 decisions) | Plan approved |
| 2026-09-29 | Part A data changes: simulator `hydrate`/`transitions`, idempotent serialized writer + mechanic assignment, `TrackingSyncCoordinator`, `getMechanics`, cancel `reason`, reschedule ignores cancelled units, `preselectMotors` | analyze clean; data tests green |
| 2026-09-29 | Presentation: S19 (tabs, cards, motor filter), S20 (header, `FleetProgress` legend, unit rows, action matrix, live streams), S21 (timeline, mechanic, ETA, demo shortcut), S22 (sheet VM + sheet, Batalkan dialog); routes, Home/tab refresh | analyze clean |
| 2026-09-29 | Tests: simulator/writer/coordinator/repo (relaunch), booking + workshop + draft additions, 4 view-model suites, flow + layout matrix (3 sizes × 2 text scales) | 666/666 green |
| 2026-09-29 | User review: no ripple on Riwayat tabs; fixed tab scroll clipping, skeleton overflow at 320 dp, chip ellipsis | Approved |
