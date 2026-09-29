# Step 24 — S06 Notifikasi, S25 Profil & Pengaturan, S26 Panel Mode Demo

| | |
|---|---|
| **Status** | ✅ Done |
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

## Open questions (answered at kickoff, 2026-09-29)

1. S26's "Reset semua data" scope — **Answered:** one `DemoResetService` (`core/data/service/`), not a `resetToSeed()` on every repository. It clears the demo boxes (`garage`, `bookings`, `booking_drafts`, `booking_code_counters`, `invoices`, `reviews`, `notifications`), drops the `TrackingSimulator`'s tracked units and disarms a pending error; every repository re-seeds lazily from `assets/mock/` when its box is empty. Session, theme and demo settings are untouched. The S26 view model then re-runs `DemoContentSeeder.seedIfNeeded` (canonical booking + draft) and invalidates the screens the shell keeps alive. `DemoModeController.requestReset/resetRequests` had no consumer and were removed.
2. Deep-link routing from S06 taps — **Answered:** `go_router` paths + `extra`, via a `NotificationDeepLinkResolver`, never ad-hoc `Navigator.push`.

### Kickoff decisions (interview 2026-09-29)

| # | Topic | Decision |
|---|---|---|
| 1 | Deep links | Seed JSON and `StatusNotificationCoordinator` now write real routes (`/bookings/:id/unit/:code`, `/bookings/:id`, `/invoice/:id`, `/booking/vehicles?motorId=\|voucherId=`). The resolver also maps the legacy paths (`/tracking/..`, `/booking/<id>`, `/booking/select-motor?..`) so rows already in local storage keep working. This fixes the step 22 carry-over (`/tracking/$id/$code` matched no route) |
| 2 | Armed error scope | `InvoiceRepositoryImpl.markPaid` and `ReviewRepositoryImpl.submitReview` now consume the one-shot error (login + Ringkasan confirm already did). Unlocks S23's inline error + "Coba lagi" and S24's send-failure snackbar on device — the gap step 23 deferred here. Not garage, not tracking advance/reset (the panel is the control surface) |
| 3 | Reset mechanism | `DemoResetService`, see open question 1 |
| 4 | Domain additions | `NotificationRepository.markAllRead()`; `SettingsRepository.isNotificationsEnabled()/setNotificationsEnabled()` (`LocalStore` prefs, default on). Off → `addNotification` is a no-op, `watchUnreadCount` emits 0 (bell badge drops live via `LocalStore.notificationsEnabledChanges`), existing notifications stay readable |
| 5 | Seed booking id | The runtime canonical booking id is `bk_<micros>`, but seed notifications 001–005 link `bk_active_0417`. The resolver treats that token as an alias and looks the booking up by code `TS-260929-0417`; if it is missing it falls back to Riwayat with "Booking tidak ditemukan." |
| 6 | Timestamps | `NotificationRepositoryImpl` rebases every seed timestamp by `clock.now() − 2026-09-29 10:30` at seeding time (first launch and after Reset), so Hari ini / Minggu ini / Lebih lama stay populated on any date. Seed copy and the `Minggu ini` reminder date were aligned to the design table |
| 7 | S26 target | First `berlangsung` booking; none → "no active booking" state. Majukan semua / Reset semua loop `TrackingRepository.advanceUnitStatus/resetUnitStatus` per unit (skips units already at Selesai for Majukan) — the S21 shortcut's path |

Defaults applied without asking (design step 18 decisions 1–14 stand): S06/S26 are pushed pages, S25 renders in `AppShell`'s Profil slot; "Tandai semua dibaca" sits in the first group's header row (accepted design deviation); neutral logout dialog "Keluar dari akun?" (`Batal` + `Keluar`), session only; Tentang = bottom sheet "Versi 1.0.0 (1)"; Reset = danger dialog "Ya, reset data" → snackbar "Data demo dikembalikan" → Home; unread = dot + semibold + hidden semantics "Belum dibaca"; title/body never clamped; phone masked `+62 812-****-7890`; demo caption shown once at the top of S26.

Build decisions made while implementing (flag at review):

- **Voucher carry (S06 promo → S10):** `PilihMotorPage` gained an additive `voucherId` and the router an additive `PilihMotorArgs` extra; `BookingDraftViewModel.preselectVoucher` keeps the voucher until the draft has loaded (like `preselectMotors`). The draft holds the voucher; S16 still applies eligibility.
- **Seeding guard:** `DemoContentSeeder` marks `DemoModeController.isSeeding` while it advances the canonical booking, and `StatusNotificationCoordinator` skips notifications during it. Without it the coordinator's 2 s discovery poll would catch the booking mid-seed and add status notifications on top of the 2 seeded unread, so the S05 bell would not read "2".
- **Speed change is live:** `TrackingSimulator` listens to `DemoModeController.speedChanges` and re-schedules running units at the new interval (Mati cancels them). Before, a change only applied to the next status.
- **`TsSegmentedControl`** is a new shared component (`core/presentation/components/`), used for the theme (icon + label) and speed (label) controls; radio-group semantics, 48 dp, accent fill + semibold selected.
- **Group header** is a `Wrap`, not a `Row`: at large text the "Tandai semua dibaca" action drops under the title instead of squeezing it (the layout test caught a real 25 px overflow at 320 dp).
- `StatusNotificationCoordinator` imports `app/navigation/routes.dart` (pure constants) so the route shape has one source of truth.

## Scope

### Files / classes built

**Data / domain (additive):** `NotificationRepository.markAllRead`, `SettingsRepository` notifications flag, `LocalStore` (flag + change stream), `NotificationRepositoryImpl` (markAllRead, gating, seed rebase, `Clock`), `SettingsRepositoryImpl`, `DemoModeController` (armed/speed/seeding streams and flags), `TrackingSimulator` (`clearAll`, live speed), `InvoiceRepositoryImpl` + `ReviewRepositoryImpl` (armed error), `DemoResetService` + `demoResetServiceProvider`, `DemoContentSeeder` (seeding flag), `StatusNotificationCoordinator` (real deep link, seeding guard), `assets/mock/notifications_seed.json`.

**S06:** `notification/presentation/di/notification_presentation_module.dart`; `notifikasi/` — `notifikasi_page.dart`, `notifikasi_view_model.dart`, `state/notifikasi_state.dart`, `components/notification_tile.dart`, `components/notification_group_header.dart`; `utils/notification_grouping.dart`, `utils/notification_deep_link_resolver.dart`.

**S25:** `profile/presentation/di/profile_presentation_module.dart`; `profil/` — `profil_page.dart`, `profil_view_model.dart`, `state/profil_state.dart`, `components/user_card.dart`, `theme_setting.dart`, `settings_row.dart`.

**S26:** `demo_mode/` — `demo_mode_page.dart`, `demo_mode_view_model.dart`, `state/demo_mode_state.dart`, `components/demo_panel.dart`, `demo_unit_row.dart`, `error_sim_banner.dart`.

**Shared / wiring:** `core/presentation/components/ts_segmented_control.dart`; router (`/notifications`, `/profile`, `/profile/demo-mode` real; S05 bell already pushed `Routes.notifications`); `booking/presentation/pilih_motor/pilih_motor_args.dart`; test support (`FakeNotificationRepository` rewrite, `FakeSettingsRepository` flag, `FakeSessionRepository.logoutCalls`, `FakeLogoutHandler`, `notification_fixtures.dart`).

### Tests written

- `test/notification/presentation/notifikasi/` — `notifikasi_view_model_test` (grouping, unread = bell, each category's route + params, mark-all-read, live arrival), `notification_deep_link_resolver_test` (real + legacy paths, alias by code, fallbacks), `notification_grouping_test` (boundaries, stamps), `notifikasi_page_test` (populated / empty / loading / error / all-read, tap navigation, mark-all, layout 320×568 ×1.0, 360×640 ×1.3, 412×915 ×1.3).
- `test/profile/presentation/profil/` — `profil_view_model_test` (theme persists + applies live, notifications switch + revert, mask, logout via shared handler), `profil_page_test` (default, theme, radio semantics, switch, Mode Demo, logout dialog cancel/confirm, Tentang, layout ×3).
- `test/profile/presentation/demo_mode/` — `demo_mode_view_model_test` (speed drives controller and simulator interval, error arms once → auto-disarms, per-unit + all advance/reset via `TrackingRepository`, busy guard, no active booking, reset restores and keeps demo settings), `demo_mode_page_test` (default, Selesai, no-active, armed banner, reset dialog + flow, layout ×3).
- Data: `notification_repository_impl_test` (+ markAllRead, off-gating, rebase), `settings_repository_impl_test`, `session_repository_impl_test` (logout keeps garage/bookings/draft/theme across a relaunch), `demo_reset_service_test` (keeps session/theme/demo prefs, reseeds `TS-260929-0417`, box drift guard), invoice/review impl armed-error tests, `tracking_simulator_test` (speed, `clearAll`), `demo_mode_controller_test`, `status_notification_coordinator_test` (real deep link, seeding guard), `demo_content_seeder_test` (seeding flag).

## Checklist

### Build
- [x] Open questions answered (reset-seed scope, deep-link wiring) + kickoff interview.
- [x] S06 built for loading/empty/populated/all-read/stress; S25 built for default/logout-dialog/about-sheet/stress; S26 built for default/no-active-booking/unit-selesai/error-armed/reset-dialog/stress.
- [x] `/notifications`, `/profile`, `/profile/demo-mode` routes wired; `AppShell` Profil tab now real; S05 bell → S06 real.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test` → 820 passing (full suite; was 716 at step 23 close).
- [x] Screenshots vs. `design/pencil/exports/step18/*.png` — PNGs used as the build reference; all screens then tested by the user on device (no automated pixel diff).

### Review gate
- [x] Status 🔵; show the user all 3 screens (all states), the reset-seed demo, and test results.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `034 - Create Notification, Profile & Demo-Mode Screens (S06, S25, S26)`.
- [x] Claude session file written (`docs/claude-session/apps/25-mobile-step24-notif-profile-demo-s06-s25-s26.md`).
- [x] Tracker in `00-index.md` set to ✅. **Every screen (S01–S26) now exists in phone portrait.**

## Review rounds

- Round 1 (2026-09-29): user tested all screens on device — "i test all and well, approve do the rest except commit and push". No changes requested. Approved.

### Known gaps / notes for the reviewer
- On-device checks for the user: fresh install shows bell "2" and S06 lists 9 notifications in 3 groups; every seed tap lands (S21 −C/−B/−A, S20, S10 + Supra X 125, S10 + voucher, S23); Notifikasi switch off drops the badge and stops new status notifications; theme changes live; logout keeps garage/bookings; S26 speed / Majukan / Reset; arm error → "Tandai lunas" fails once with "Coba lagi", the retry succeeds; Reset semua data → Home shows the canonical booking again.
- The S05 promo cards still open S10 without a voucher (their own `deep_link` is not read by Home); only S06 promo taps carry the voucher.
- The S26 live `StatusTimeline` preview and the S25 "Pratinjau tema" panel are tablet-only (step 27), not built.
- The app was not launched by Claude in this session; layout was verified by widget tests (320×568 ×1.0, 360×640 ×1.3, 412×915 ×1.3, Ahem font) and analyzer, behaviour by the user.
- Layer note: `notification_deep_link_resolver.dart`, the S26 view model and page import `core/data/service/*` types (`DemoContentSeeder`, `DemoModeController`/`TrackingSpeed`), as `home_presentation_module.dart` and the garage form already do for services.

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-29 | Explored notification/settings/demo data layer, router, S05/S20/S21 with grepai + reads; interview (7 decisions) | Plan approved |
| 2026-09-29 | Data: `DemoModeController` streams, `TrackingSimulator` speed/`clearAll`, `LocalStore` flag, notification + settings repos, armed error on markPaid/submitReview, `DemoResetService`, seed JSON + coordinator deep link | Data suites green |
| 2026-09-29 | S06: resolver, grouping, state/VM, tile, header, page; S10 voucher carry; router | analyze clean |
| 2026-09-29 | S25/S26: `TsSegmentedControl`, profil state/VM/components/page, demo state/VM/components/page; router | analyze clean |
| 2026-09-29 | Tests: VM + page + data for all three; layout test caught a real header overflow (Row → Wrap) | 820/820 green |
| 2026-09-29 | Seeding guard so the bell reads "2" on a fresh install | Full gate: analyze + format clean, 820 green |
| 2026-09-29 | User on-device review | Approved, no changes |
| 2026-09-29 | Close: session file, tracker ✅, files staged (not committed) | Done |
