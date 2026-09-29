# Step 25 — P1 hardening (full phone-portrait app) + app identity

| | |
|---|---|
| **Status** | ✅ Approved |
| **Layer** | Hardening |
| **Priority** | — |
| **Owns** | Quality pass across every P1 screen + cross-screen consistency of the whole phone app; **Part B:** app display name, launcher icon (Android + macOS), Android launch screen |
| **PRD refs** | [06 device matrix & safe-layout rules](../../../prd/06-responsive-layout.md), [08 acceptance](../../../prd/08-deliverables-acceptance.md), [02 brand](../../../prd/02-brand-design-system.md) |
| **Design refs** | `design/pencil/exports/step*/` (all P1 steps), `design/pencil/exports/step02/app-icon/` |
| **Depends on** | Step 24 |
| **Claude session** | `docs/claude-session/apps/26-mobile-step25-p1-hardening.md` (written after approval) |

## Goal

Mirror step 20, but for the full P1 surface: `flutter analyze` clean across the entire app, remaining widget/layout tests, an overflow sweep across every P1 screen at the PRD 06 phone matrix, and a cross-screen consistency check (notification badge counts agree between S05/S06/S21; booking status agrees between S05/S19/S20; demo-reset actually resets everything step 24 claimed it would).

**Part B (added at kickoff):** "finish the app" — display name **Tumbas Service**, app icon = the in-app splash tile (Android + macOS), and an Android launch screen with no white flash / stray default icon.

## Decisions (kickoff interview, 2026-09-29)

| Topic | Decision |
|---|---|
| Scope | Step 25 + identity work. Tablet (26–27) and release deliverables (keystore, signed APK, README, hosting = step 28) stay out |
| Deferred P1 states | **Document only** — no new features (see *Known limitations* below) |
| Display name | **OS label only** — Android `android:label`, macOS `PRODUCT_NAME`, `MaterialApp.title`. In-app wordmark (`Tumbas`+`Servis`), Dart package and `applicationId` untouched |
| Icon art | Splash tile look (`TsLogo`: `scheme.primary` `#C24C1D`, white Exo 2 wght 800 "TS"). Note `TsLogo`'s radius (`size·22/40`) exceeds half the size, so the tile is actually a **circle** — identical to the approved Pencil export in shape |
| Launch screen | Hand-edited Android XML, **no `flutter_native_splash`** (removed from dev deps) |

## Scope

### Part A — hardening

- Baseline: `flutter analyze` 0 issues, `dart format` clean, `flutter test` 820 green **before** any change.
- New `test/layout/p1_layout_matrix_test.dart` — 4 phone sizes (PRD 06) × text ×1.0/×1.3 for the P1 screens that had no matrix yet: S01 Splash, S02 Onboarding, S03 Login, S04 OTP, S12 Katalog (browse + select, 18 long-named parts), S14 Detail bengkel (in-flow + standalone), S17 Voucher = 72 tests. (S07–S09 already covered by `garage_layout_matrix_test.dart`; S06/S23–S26 by their own page tests at 320×568/360×640/412×915; S19–S22 by `tracking_flow_test.dart`.)
- New `test/app/cross_screen_consistency_test.dart` (11 tests, real provider graph on a temp Hive store):
  - unit-status labels agree across S05 card, S19–S21 timeline, S07–S09 history row and the badge (badge deliberately says "Check-in / Antre" per PRD 02);
  - unread count: S05 bell == S06 list == repository through open-one, mark-all, and a new S21 status event;
  - booking status: S05 card / S19 / S20 derive from one `Booking` (seed → Berlangsung, all units done → Selesai);
  - S26 "Reset semua data" round-trip: garage, bookings + unit statuses, notifications, invoice, review, armed error, draft all back to the seeded state, and the open Home/Notifikasi view models reload to it.

### Bugs found and fixed (owning feature, pointer back to step 25)

| # | Where | Bug | Fix |
|---|---|---|---|
| 1 | `auth/presentation/otp/otp_page.dart`, `otp/components/auth_link.dart` (step 11) | S04 overflowed on every phone size: "phone + Ganti nomor" row, resend-countdown link, demo-code pill and "Masukkan 6 digit kode" hint were non-flexing `Row`s | `Wrap` for the phone row; `Flexible` text in the link, pill and hint |
| 2 | `auth/presentation/onboarding/onboarding_page.dart`, `components/onboarding_slide.dart` (step 11) | S02 overflowed at 360×640 and at ×1.3 on every size (copy column + ticket vignette) | Copy column: `LayoutBuilder` + `SingleChildScrollView` + `IntrinsicHeight` (keeps `spaceBetween` when it fits, scrolls when not); art pane: `FittedBox` scale-down |
| 3 | `workshop/presentation/detail_bengkel/detail_bengkel_page.dart` (step 16) | S14 "Salin" / "Buka di Maps" buttons overflowed the address row on every size | `Wrap` |
| 4 | `notification/`, `booking/`, `garage/` `*_repository_impl.dart` `_ensureSeeded` (steps 07–09) | Race: when two callers hit an empty box together (Home + Notifikasi rebuilt at once after S26 reset) the second saw the half-written seed. Reproduced: after reset, S05 bell and S06 list showed 1 of 2 unread while the repository held 2 | One shared in-flight seeding future per repository (`_seeding ??= _seedIfEmpty()…`) |

### Part B — app identity

- **Name:** `AndroidManifest.xml` `android:label`, `macos/Runner/Configs/AppInfo.xcconfig` `PRODUCT_NAME`, `MaterialApp.title` → `Tumbas Service`.
- **Icon:** masters generated once from the Exo 2 variable font (wght 800) into `assets/icon/` (`app_icon.png` full circle, `app_icon_macos.png` circle inset 824/1024, `app_icon_fg.png` white "TS" on transparent). `flutter_launcher_icons` config added to `pubspec.yaml` (Android adaptive: bg `#C24C1D` + foreground; macOS on; iOS off — no `ios/` folder). Generated Android mipmaps/drawables/`mipmap-anydpi-v26` and macOS `AppIcon.appiconset` are tool output — regenerate with `dart run flutter_launcher_icons`, don't hand-edit.
- **Launch screen:** `values/colors.xml` + `values-night/colors.xml` `launch_background` (`#FBFAF9` / `#100E0D` = `ColorScheme.surface` light/dark); `launch_background.xml` (both `drawable` and `drawable-v21`) and both `NormalTheme`s use it; new `values-v31` / `values-night-v31` `LaunchTheme` set `windowSplashScreenBackground` + `windowSplashScreenAnimatedIcon=@mipmap/ic_launcher` so Android 12+ shows bg-page + the tile icon, flowing into S01's centred tile. `flutter_native_splash` removed from dev dependencies.

## Checklist

### Build
- [x] Open questions answered (deferred P1 states → document only; identity decisions above).
- [x] Any found bug fixed in its owning feature, noted with a pointer back here (4 bugs, table above).
- [x] Part B: name, icon (Android + macOS), Android launch screen.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues (whole project).
- [x] `dart format --set-exit-if-changed .` → clean (whole project, 484 files).
- [x] `flutter test` → green (whole suite, **903** tests = 820 baseline + 72 layout + 11 consistency).
- [x] Layout tests for the remaining dense P1 screens → 0 overflow (after fixes 1–3).
- [ ] Manual overflow sweep across every P1 screen on a device/emulator — **not done by Claude**: no Android emulator/device attached (only a wireless iPhone, and the project has no `ios/`). Covered instead by the automated matrix above; user to spot-check on their Android device.
- [x] Cross-screen consistency checks pass (badge counts, status labels, demo-reset completeness).
- [x] `flutter build apk --debug` OK: `aapt2 dump badging` → `application-label:'Tumbas Service'`, adaptive `mipmap-anydpi-v26/ic_launcher.xml`; `values-v31` resources link.
- [x] `flutter build macos --debug` OK: `Tumbas Service.app`, `CFBundleName` = Tumbas Service, `AppIcon.icns` shows the tile; launched — menu bar + window title read "Tumbas Service".
- [ ] Not verified on hardware: Android 12+ system splash and pre-12 launch window (no white flash) — needs the user's device, light + dark OS mode.

### Review gate
- [x] Status 🔵; user shown the full-suite summary, the consistency-check results, the bug table and the deferred-states list.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `035 - Harden Full Phone App & Set App Identity` (user commits).
- [x] Claude session file written (`docs/claude-session/apps/26-mobile-step25-p1-hardening.md`).
- [x] Tracker in `00-index.md` set to ✅. **The entire mobile-portrait app (P0 + P1, S01–S26) is now solid — tablet work starts next.**

## Known limitations (feed step 28's README)

- S23 P2 "Bagikan" not built (no `share_plus`; S18 share never built).
- S25 "Pratinjau tema" panel and S26 live `StatusTimeline` preview are tablet-only (step 27).
- Native launch colour follows the **OS** dark setting; in-app theme follows the S25 choice — they can differ for one frame when the user overrides the OS theme.
- `StatusNotificationCoordinator` discovers new bookings on a 2 s poll, so a status change made within ~2 s of a booking being created raises no status notification.
- Tapping S26 "Reset semua data" before the screen's first load finishes can race the screen's own load (observed only in a test that created the view model mid-reset; the normal flow, screen loaded first, is covered and passes).
- Android 12+ system splash and icon masks not eyeballed on a device yet.

## Review rounds

- Round 1 (2026-09-29): "approve and do rest except commit and push". No changes requested. Approved.

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-29 | Kickoff interview (scope, icon art, name scope, launch screen, deferred states, release scope) | Decisions recorded above |
| 2026-09-29 | Baseline `flutter analyze` / `dart format` / `flutter test` | 0 issues / clean / 820 green |
| 2026-09-29 | Part B: name (Android, macOS, `MaterialApp.title`), icon masters (PIL), `flutter_launcher_icons`, Android launch XML, dropped `flutter_native_splash` | `flutter build apk --debug` + `flutter build macos --debug` OK |
| 2026-09-29 | New `p1_layout_matrix_test.dart` | 3 real overflow bugs found (S02, S04, S14) → fixed |
| 2026-09-29 | New `cross_screen_consistency_test.dart` | Seeding race found (bug 4) → fixed in notification/booking/garage repos |
| 2026-09-29 | Full suite | 903 green, analyze 0, format clean |
| 2026-09-29 | Review round 1 | Approved; session log written, tracker ✅, files staged (not committed) |
