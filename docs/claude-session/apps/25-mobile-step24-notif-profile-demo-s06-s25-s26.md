# Claude Session Log — 25: Mobile-app step 24 — Notifikasi S06, Profil S25 & Mode Demo S26

**Tool:** Claude Code, model Claude Sonnet 5.5
**Date:** 2026-09-29
**Topic:** Build the last three phone screens (notification inbox, profile/settings, reviewer-facing demo panel) against design step 18, replace the `/notifications`, `/profile` and `/profile/demo-mode` placeholders, and close the step 22/23 hand-offs (deep-link mismatch, failure injection for S23/S24).

## Initial prompt

"i want to do docs/plan/mobile-app/24-xx, interview me with detail if need, use grepai to explore codebase". After review: "i test all and well, approve do the rest except commit and push".

## Research performed

- `grepai` + direct reads of `NotificationRepositoryImpl`, `SettingsRepositoryImpl`, `SessionRepositoryImpl`, `DemoModeController`, `TrackingSimulator`, `DemoContentSeeder`, `StatusNotificationCoordinator`, `LocalStore`, router/routes, `AppShell`, `themeModeProvider`/`LogoutHandler`, S05 bell wiring, S21 shortcut, `BookingDraftViewModel`, PRD 04 S06/S25/S26, design step 18 (doc + PNG exports).
- Findings that shaped scope: (1) `DemoModeController.requestReset/resetRequests` had no consumer; (2) the armed error was consumed only by login and Ringkasan confirm, not `markPaid`/`submitReview`; (3) seed notification deep links (`/tracking/..`, `/booking/select-motor`, `bk_active_0417`) matched no real route or booking id (runtime ids are `bk_<micros>`); (4) `NotificationRepository` had no mark-all-read and `SettingsRepository` no notifications flag; (5) seed timestamps were fixed dates, so grouping would drift; (6) speed changes only applied to the next status; (7) the coordinator's 2 s poll would add status notifications while the seeder builds the demo booking, breaking the bell "2".

## Clarifying interview (7 decisions)

Real routes + resolver (legacy paths mapped); armed error on `markPaid` + `submitReview`; `DemoResetService` (no per-repo `resetToSeed`); add `markAllRead` + notifications flag; alias `bk_active_0417` → booking by code `TS-260929-0417`; rebase seed timestamps to the clock at seed time; S26 controls the first `berlangsung` booking.

## Execution

- **Data / domain:** `DemoModeController` (armed/speed streams, seeding flag); `TrackingSimulator` (live speed, `clearAll`); `LocalStore` (notifications flag + change stream); `NotificationRepositoryImpl` (`markAllRead`, off-gating, seed rebase via `Clock`); `SettingsRepositoryImpl`; `InvoiceRepositoryImpl`/`ReviewRepositoryImpl` (armed error); `DemoResetService`; `DemoContentSeeder` + `StatusNotificationCoordinator` (seeding guard, real deep link); seed JSON aligned to design copy/dates.
- **S06:** `NotifikasiViewModel`, `NotifikasiPage`, `NotificationTile`, `NotificationGroupHeader`, `NotificationGrouping`, `NotificationDeepLinkResolver`; S10 voucher carry (`PilihMotorArgs`, `BookingDraftViewModel.preselectVoucher`).
- **S25:** `ProfilViewModel`, `ProfilPage`, `UserCard`, `ThemeSetting`, `SettingsRow`, About sheet; reuses `themeModeProvider` and `logoutHandlerProvider`.
- **S26:** `DemoModeViewModel`, `DemoModePage`, `DemoPanel`, `DemoUnitRow`, `ErrorSimBanner`; reset = service + re-seed + invalidation of Home/Garasi/Riwayat/draft/notifikasi.
- **Shared:** `TsSegmentedControl`; router wiring.
- **Bugs caught by tests and fixed:** S06 group header overflowed 25 px at 320 dp (Row → Wrap); theme-notifier initial-load race in a test; seed-time notification noise (seeding guard).

Tests: view model + page (states, navigation, dialogs, layout matrix 320×568 ×1.0 / 360×640 ×1.3 / 412×915 ×1.3) for all three screens; resolver, grouping, reset service (incl. box drift guard), simulator speed/`clearAll`, controller streams, coordinator, seeder, notification/settings/invoice/review/session repositories. `flutter analyze` 0 issues; `dart format` clean; `flutter test` 820/820 (baseline 716).

## Review rounds

- Round 1 (2026-09-29): user tested all screens on device — "i test all and well, approve do the rest except commit and push". No changes requested. Approved.

## Key decisions worth flagging to a reviewer

- Reset works by clearing boxes and letting every repository re-seed lazily; the box list is mirrored in `DemoResetService.resetBoxes` (core cannot import feature boxes) and guarded by a drift test.
- The notifications master switch gates at the repository (`addNotification` no-op, badge 0) and re-pushes the unread count through `LocalStore.notificationsEnabledChanges`.
- The seeding guard exists only so a fresh install reads bell "2"; live status notifications after seeding are unchanged.
- S05 promo cards still open S10 without a voucher (Home ignores the promo `deep_link`); only S06 promo taps carry one.
- Not built: S26 live `StatusTimeline` preview and S25 "Pratinjau tema" panel (tablet, step 27).
- Claude did not launch the app; on-device behaviour was verified by the user.
- `lib/main.dart` carries user-added IDE-troubleshooting comments (not part of this step); left unstaged.

## Output

Tracker set to ✅ in `00-index.md`; every screen S01–S26 now exists in phone portrait. Commit message proposed: `034 - Create Notification, Profile & Demo-Mode Screens (S06, S25, S26)`. Not committed or pushed. Next: step 25 — P1 hardening.
