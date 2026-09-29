# Step 24 — S06 Notifikasi, S25 Profil & Pengaturan, S26 Panel Mode Demo

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Layer** | Presentation, phone |
| **Priority** | P1 |
| **Owns** | `notification/presentation/` (S06), `profile/presentation/` (S25, S26) |
| **PRD refs** | [04 S06/S25/S26](../../../prd/04-screens.md) |
| **Design refs** | `docs/plan/design/18-notif-profile-demo.md` + `docs/claude-session/design/20-design-step18-notif-profile-demo.md`, exports `design/pencil/exports/step18/` |
| **Depends on** | Step 09 (`NotificationRepository`), step 06 (`SettingsRepository`), step 05 (`DemoModeController`), step 22 (`TrackingRepository`, S26's advance/reset shares S21's mechanism), 10 |
| **Claude session** | `docs/claude-session/apps/25-mobile-step24-notif-profile-demo-s06-s25-s26.md` (written after approval) |

## Goal

The notification inbox, account/settings (theme toggle, logout), and the reviewer-facing Mode Demo panel — this closes out the last P1 screens; the whole phone-portrait app is feature-complete after this step.

## Inputs

- PRD 04 S06/S25/S26 content/states; deep-link routing table (status → S21, booking → S20, invoice → S23, promo → S10 with voucher, reminder → S10 with motor).
- Design step 18 file + session log — one master Notifikasi switch, neutral logout (session-only, data kept), segmented "Mati/15 dtk/5 dtk" speed control, one-shot error-sim armed banner.
- `NotificationRepository`, `SettingsRepository`, `DemoModeController`, `TrackingRepository` (S26 reuses S21's advance/reset).

## Open questions (ask at kickoff)

1. S26's "Reset semua data" — confirm the exact scope (garage, bookings, draft, notification read-state, invoices, reviews restored to the step-04 seed; session/theme/demo settings kept) is implemented as one `DemoModeController.resetSeed()` call that every repository impl (steps 06–09) already supports, or whether some repositories need a retroactive `resetToSeed()` method added now.
2. Deep-link routing from S06 taps — confirm each PRD 04 mapping (status→S21, booking→S20, invoice→S23, promo→S10+voucher, reminder→S10+motor) is wired via `go_router`'s path + query params, not ad-hoc `Navigator.push`.

### Carry-over from step 22 (found while building S19–S22)

- **Deep-link mismatch:** `StatusNotificationCoordinator` writes `deepLink: '/tracking/$bookingId/$unitCode'`, but the real S21 route is `Routes.bookingUnitDetail` = `/bookings/:id/unit/:unitCode`. Fix the coordinator (and its test) when wiring S06 taps, or map the legacy path in the resolver.
- **S26 "Majukan semua / Reset semua":** step 22 now persists *every* `TrackingSimulator` transition through `TrackingSyncCoordinator`, so `advanceAll()/resetAll()` no longer desync the store. Still prefer looping `TrackingRepository.advanceUnitStatus/resetUnitStatus` per unit so S21's shortcut and S26 share exactly one path (plus its error handling / armed-error one-shot).
- **Mechanics:** `WorkshopRepository.getMechanics()` exists now (S21 `MechanicCard`); S26's preview can reuse it.

## Scope

### Files / classes to build

`notification/presentation/di/notification_presentation_module.dart`; `notification/presentation/notifikasi/` — `notifikasi_page.dart`, `notifikasi_view_model.dart`, `components/notification_tile.dart`, `components/notification_group_header.dart`, `state/notifikasi_state.dart`.

`profile/presentation/di/profile_presentation_module.dart`; `profile/presentation/profil/` — `profil_page.dart` (rendered inside `AppShell`'s Profil slot), `profil_view_model.dart`, `components/user_card.dart`, `components/theme_setting.dart`, `components/settings_row.dart`, `state/profil_state.dart`. `profile/presentation/demo_mode/` — `demo_mode_page.dart`, `demo_mode_view_model.dart`, `components/demo_unit_row.dart`, `components/error_sim_banner.dart`, `state/demo_mode_state.dart`.

### Tests to write

- `test/notification/presentation/notifikasi/notifikasi_view_model_test.dart` — unread count matches S05's bell badge; each category's deep link resolves to the correct route+params.
- `test/profile/presentation/profil/profil_view_model_test.dart` — theme toggle persists and applies live; logout clears session only (garage/bookings survive a relaunch).
- `test/profile/presentation/demo_mode/demo_mode_view_model_test.dart` — speed control changes `TrackingSimulator`'s interval; error-sim arms once, fails the next write, then auto-disarms; reset-seed restores counts to the step-04 seed while keeping session/theme/demo settings.

## Checklist

### Build
- [ ] Open questions answered (reset-seed scope, deep-link wiring).
- [ ] S06 built for loading/empty/populated/all-read/stress; S25 built for default/logout-dialog/about-sheet/stress; S26 built for default/no-active-booking/unit-selesai/error-armed/reset-dialog/stress.
- [ ] `/notifications`, `/profile`, `/profile/demo-mode` routes wired; `AppShell` Profil tab now real; S05 bell → S06 real.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test test/notification/ test/profile/` → green.
- [ ] Screenshots vs. `design/pencil/exports/step18/*.png`.

### Review gate
- [ ] Status 🔵; show the user all 3 screens (all states), the reset-seed demo, and test results.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `034 - Create Notification, Profile & Demo-Mode Screens (S06, S25, S26)`.
- [ ] Claude session file written (`docs/claude-session/apps/25-mobile-step24-notif-profile-demo-s06-s25-s26.md`).
- [ ] Tracker in `00-index.md` set to ✅. **Every screen (S01–S26) now exists in phone portrait.**

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
