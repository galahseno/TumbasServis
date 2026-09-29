# Claude Session Log — 26: Mobile-app step 25 — P1 hardening + app identity

**Tool:** Claude Code, model Claude Sonnet 5.5
**Date:** 2026-09-29
**Topic:** Harden the full phone-portrait app (overflow matrix for the remaining P1 screens, cross-screen consistency checks, demo-reset round-trip) and finish the app's identity: display name "Tumbas Service", launcher icon on Android + macOS from the splash tile, Android launch screen without a native-splash package.

## Initial prompt

"i want to do docs/plan/mobile-app/25-xx, interview me with detail if need, use grepai to explore codebase — also i want finish the app, change the app name (display to user) to "Tumbas Service" and use app icon splash screen for app icon in android and desktop mac". After review: "approve and do rest except commit and push".

## Research performed

- `grepai` + direct reads of the step 25/28 docs, `00-index.md`, `AndroidManifest.xml`, `build.gradle.kts`, macOS `AppInfo.xcconfig`/`Info.plist`, Android launch styles/drawables, `TsLogo`, `SplashPage`, `app_theme.dart` (surface colours), the Pencil app-icon exports, existing layout tests, `DemoResetService`, `DemoContentSeeder`, `StatusNotificationCoordinator`, the notification/booking/garage repositories, and the display-label sources for unit/booking status.
- Findings that shaped scope: `TsLogo`'s radius (`size·22/40`) exceeds half the size, so the "tile" is a circle (same shape as the design export); `flutter_launcher_icons` and `flutter_native_splash` were already in dev deps with no config; macOS already used a spaced product name; S08/S23 already had matrices, so the real matrix gaps were S01–S04, S12 (with data), S14, S17; four separate UnitStatus label mappings exist (badge intentionally says "Check-in / Antre" per PRD 02).

## Clarifying interview (decisions)

Scope = step 25 + identity work folded into the same step file (tablet 26–27 and release deliverables stay out); icon art = splash tile look; name = OS label only (Android label, macOS `PRODUCT_NAME`, `MaterialApp.title`; in-app wordmark, package, `applicationId` untouched); deferred P1 states = document only; launch screen = hand-edited XML, drop `flutter_native_splash`.

## Execution

- **Identity:** name in three places; icon masters generated once with PIL from `Exo2-Variable.ttf` (wght 800) into `assets/icon/`; `flutter_launcher_icons` config in `pubspec.yaml` (Android adaptive `#C24C1D` bg + white fg, macOS on, iOS off); launch colour resources light/dark, `launch_background.xml`, both `NormalTheme`s, new `values-v31`/`values-night-v31` `LaunchTheme` (system splash bg + launcher icon); `flutter_native_splash` removed.
- **Tests added:** `test/layout/p1_layout_matrix_test.dart` (72: S01–S04, S12 browse/select, S14 both variants, S17 × 4 phone sizes × ×1.0/×1.3); `test/app/cross_screen_consistency_test.dart` (11: status labels across surfaces, unread bell/list/repo, booking status derivation, S26 reset round-trip on the real provider graph).
- **Bugs found and fixed:** S04 OTP overflow (`otp_page.dart`, `auth_link.dart`); S02 onboarding overflow (`onboarding_page.dart`, `onboarding_slide.dart`); S14 address-action buttons overflow (`detail_bengkel_page.dart`); `_ensureSeeded` race in notification/booking/garage repositories (after S26 reset, bell and list showed a half-seeded box) → shared in-flight seeding future.
- A unit test written for the seeding race passed without the fix, so it was removed; the reset round-trip test (which failed before the fix) is the guard.

Verification: baseline 820 tests → final `flutter test` 903/903; `flutter analyze` 0 issues; `dart format` clean; `flutter build apk --debug` OK (`aapt2` label "Tumbas Service", adaptive icon); `flutter build macos --debug` OK, app launched (menu bar/window title "Tumbas Service", icon shown).

## Review rounds

- Round 1 (2026-09-29): "approve and do rest except commit and push". No changes requested. Approved.

## Key decisions worth flagging to a reviewer

- Generated launcher assets (Android mipmaps/drawables, macOS `AppIcon.appiconset`) are tool output; regenerate, don't hand-edit. Masters live in `assets/icon/` (not bundled).
- Native launch colour follows the OS dark setting while the in-app theme follows S25 — can differ for one frame.
- `StatusNotificationCoordinator` discovers new bookings on a 2 s poll, so a status change within ~2 s of a booking's creation raises no notification.
- Not verified on hardware: Android 12+/pre-12 launch screen and icon masks (no emulator/device attached during the session).
- Known limitations for step 28's README are listed in `25-p1-hardening.md` (S23 "Bagikan", S25 theme preview, S26 timeline preview).
- Pre-existing staged `.DS_Store` files (`.DS_Store`, `design/.DS_Store`) are also in the index; unrelated to this step, check before committing.

## Output

Tracker set to ✅ in `00-index.md`; the whole phone-portrait app (S01–S26) is hardened. Commit message proposed: `035 - Harden Full Phone App & Set App Identity`. Not committed or pushed. Next: step 26 (tablet booking flow) or step 28 (release polish).
