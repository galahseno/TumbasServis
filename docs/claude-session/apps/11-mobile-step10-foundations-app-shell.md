# Claude Session Log — 11: Mobile-app step 10 — Foundations: theme, router, app shell, core components

**Tool:** Claude Code, model Sonnet 5
**Date:** 2026-09-28
**Topic:** Real `bootstrap()`, light/dark theme (`ColorScheme` + `TsThemeExtension` + `TextTheme`) from PRD 02's design-resolved tokens, the full PRD 07 route table (stub pages), the 4 `StatefulShellRoute` branches behind a single responsive `AppShell`, and the 15-component shared library.

## Initial prompt

"i want to do docs/plan/mobile-app/10-xx, interviewme with detail if need"

## Research performed

Two parallel Explore agents: one read `prd/02-brand-design-system.md` (full token table, later re-read directly), the design-phase session logs (`docs/plan/design/02-foundations.md`, `03-components-core.md`, `05-s05-home.md`) for every token/value resolved *after* the raw PRD 02 draft (`text-muted`→`sand-600`, `border-control`, `focus-ring`→`orange-600` light, `rating-star`, `accent-fill` split, glass tokens, etc.), and confirmed the Pencil PNG exports for steps 02/03/05 don't exist on disk (only `step02/app-icon/` + `step04/silhouettes/`); the other read `prd/07-architecture-tech.md`'s route table, the `flutter-presentation-layer` skill's DI/routing/bootstrap conventions, PRD 06's breakpoints, the existing `SessionRepository`/`SettingsRepository` signatures, and the current `pubspec.yaml`/`lib/` state (no `app/`/`core/presentation/` yet, `main.dart` still the scaffold stub).

A Plan agent then produced a concrete file-by-file build order and flagged two ambiguities not covered by the step file's own open questions.

## Clarifying interview (AskUserQuestion rounds → answers)

1. Exo 2 font sourcing → **fetch the true variable-font builds from Google Fonts' GitHub source repo now** (not the `google_fonts` runtime package — PRD wants self-hosted).
2. Build all 12 `AppShell` masters now vs. stub → **build now**, as one widget (not 12 classes).
3. Glass `NavBar`: real `BackdropFilter` now vs. flat placeholder → **real now**, flat-fallback swap point documented as a comment for step 20.
4. Pencil PNG exports missing on disk → **skip the pixel-diff QA gate**, build from the resolved markdown spec instead.
5. (Surfaced by the Plan agent) Router redirect exempt set `{/splash, /onboarding}` would bounce a mid-login user out of `/otp` (`SessionRepository.currentUser()` only returns non-null after `verifyOtp()`) → **add `/otp` to the exempt set**.
6. (Surfaced by the Plan agent) Whether non-tab-root routes (`/garage/add`, `/bookings/:id`, ...) nest under their branch's `GoRoute` or sit as top-level siblings → **top-level siblings**, full-screen push over the shell chrome.

## Execution (files written, tests added/passing)

- `assets/fonts/Exo2-Variable.ttf` + `Exo2-Italic-Variable.ttf` — fetched from `google/fonts`'s `ofl/exo2/` (the true variable builds, not a fixed-weight static instance); registered in `pubspec.yaml` (no `weight:` key — weight requested per-`TextStyle` via `fontVariations`).
- `lib/core/presentation/theme/ts_theme_extension.dart` (new — not in the original scope list) — `TsThemeExtension` class lives under `core/presentation/`, not `app/`, so `core/presentation/components/` never has to import `app/`.
- `lib/app/app_theme.dart` — `AppTheme.light`/`.dark`, `ColorScheme.light()`/`.dark()` per PRD 02's M3 mapping (design-resolved values), `TsThemeExtension` instances, 11-role `TextTheme` (`labelSmall` == `labelMedium`, the step-12 resolution). `onSurfaceVariant` resolved to `text-muted` (PRD 02 maps that ColorScheme role to "text-body / text-muted" ambiguously); `text-body` is applied directly on `TextTheme.body*` instead — documented in a comment so it isn't "corrected" to read `onSurfaceVariant` later. `surfaceTint: Colors.transparent` set on both schemes so M3's default primary-tinted elevation overlay doesn't drift `surface-card` off its exact resolved hex.
- `lib/core/presentation/components/` — 15 files: `ts_logo`, `ts_icon_button`, `ts_button` (6 types × 5 states), `ts_text_field` (error = icon + message, never color-only), `ts_chip`, `unit_status_badge` (7 statuses, reuses the existing `UnitStatus` enum), `skeleton` (respects `MediaQuery.disableAnimations`, re-checked every rebuild), `empty_state`/`error_state` (generic icon placeholder — no illustration SVGs exist yet), `sheet_header`, `ts_app_bar` (named factories per variant), `ts_dialog` (4 static builders, Escape-to-dismiss via `Shortcuts`/`Actions`, focus trap/restore free from `ModalRoute`), `ts_snackbar` (inverse surface, error/action variants don't auto-dismiss), `nav_bar` (the one glass `BackdropFilter` instance), `nav_rail` (one widget covers medium + large-extended via `extended`), `app_shell` (single widget, switches `NavBar`/`NavRail` by `MediaQuery` width — the "12 masters" collapse into this one class).
- `lib/app/navigation/routes.dart` + `router.dart` — full PRD 07 route table: ~22 top-level `GoRoute`s (stub `Placeholder`s) + one `StatefulShellRoute.indexedStack` with 4 branches; global `redirect` exempting `{/splash, /onboarding, /otp}`.
- `lib/core/presentation/di/core_presentation_module.dart` — `themeModeProvider` (`NotifierProvider`, loads/persists via `SettingsRepository`), `logoutHandlerProvider`.
- `lib/core/presentation/utils/` — `currency_formatter.dart`, `date_formatter.dart`, `time_formatter.dart`.
- `lib/bootstrap.dart` + `lib/main.dart` — real bootstrap (`initializeDateFormatting('id_ID', ...)`, `SharedPreferences.getInstance()`); `main.dart` reduced to `void main() => bootstrap();`.
- Tests: `test/app/app_theme_test.dart`, `test/app/app_test.dart`, `test/app/navigation/router_test.dart`, `test/core/presentation/components/{ts_button,ts_text_field,ts_chip,unit_status_badge,app_shell}_test.dart`, `test/core/presentation/utils/{currency,date,time}_formatter_test.dart`, plus `test/support/fake_session_repository.dart` / `fake_settings_repository.dart`. Full project suite: 231/231 passing; `flutter analyze` 0 issues; `dart format --set-exit-if-changed .` clean.

## Review rounds (user feedback → changes → approval)

Round 1 — shown the file list and quality/test summary (no screenshots — no Android emulator or iOS/macOS platform target exists in this environment, only `android/` is scaffolded; a breakpoint-switch widget test stood in for the manual device run). User tested on a real device + desktop, confirmed the blank box-with-cross (`Placeholder`) is expected for this step, and asked to remove the debug banner. Added `debugShowCheckedModeBanner: false` to `lib/app/app.dart`. Approved.

## Key decisions worth flagging to a reviewer

- **Router redirect exempt set is `{/splash, /onboarding, /otp}`**, not the step file's original `{/splash, /onboarding}` — without `/otp`, a user mid-login (S04, `login()` called but not yet `verifyOtp()`) would be bounced back to `/login` before entering the code, since `SessionRepository.currentUser()` only returns non-null post-verification.
- **Only `/home`, `/bookings`, `/garage`, `/profile` live inside the 4 `StatefulShellRoute` branches.** Every other route, including siblings under the same prefix (`/garage/add`, `/garage/:id`, `/bookings/:id`, `/bookings/:id/unit/:unitCode`, etc.), is a top-level `GoRoute` — a full-screen push over the shell chrome. This is an inference from the PRD's "shell tab =" annotations and the two explicit "no shell" call-outs, not spelled out verbatim for every route.
- **`AppShell`'s "12 masters" collapse into one widget**, not 12 classes — the "4 tabs" axis is just which page `StatefulNavigationShell` is already showing.
- **Glass `NavBar` ships without CSS `saturate(180%)`** — no stock Flutter `ImageFilter` equivalent (blur only); the inset sheen highlight is approximated with two 1px hairlines since Flutter has no inset-box-shadow primitive. Both are documented gaps, not silently dropped.
- **`statusNotificationCoordinatorProvider` (built step 09, flagged in that step's session log as "whichever step builds app bootstrap"'s job) is now eagerly read in `bootstrap.dart`** via an explicit `ProviderContainer` + `UncontrolledProviderScope`, not `ref.watch`-ed inside `App` — keeps the root widget decoupled from a data-layer service and keeps `App`'s own widget tests free of the full `LocalStore`/`TrackingSimulator` dependency chain.
- **PRD 02's own date-format example ("Sen, 29 Sep 2026") is internally inconsistent** — 29 Sep 2026 is a real-calendar Tuesday, not Monday. `DateFormatter` computes the weekday from the actual `DateTime` rather than hardcoding a string, so it correctly produces "Sel, 29 Sep 2026"; the test asserts against the real calendar, not the PRD's example text.
- **No on-device/emulator manual run happened this session** — this environment only has `android/` scaffolded (no `ios/`/`macos/` platform folders) and no Android emulator is configured, only a macOS desktop target and a wireless iPhone (which needs `ios/` to exist). A widget test (`app_shell_test.dart`) pumping the real router + `AppShell` at 360/700/1300dp substitutes for the breakpoint check. The user ran the app themselves outside this session (on device + desktop) and confirmed it boots correctly.
- Pencil PNG exports for design steps 02/03/05 don't exist on disk (only `step02/app-icon/` + `step04/silhouettes/`) — the step file's "compare against exported PNGs" checklist item was executed as a manual/spec-only review instead; regenerating those exports is a separate follow-up if pixel-diff QA is wanted later.

## Output (files touched, next step)

Files touched: `pubspec.yaml`, `assets/fonts/Exo2-Variable.ttf`, `assets/fonts/Exo2-Italic-Variable.ttf`, `lib/main.dart`, `lib/bootstrap.dart`, `lib/app/app.dart`, `lib/app/app_theme.dart`, `lib/app/navigation/routes.dart`, `lib/app/navigation/router.dart`, `lib/core/presentation/theme/ts_theme_extension.dart`, `lib/core/presentation/components/{ts_logo,ts_icon_button,ts_button,ts_text_field,ts_chip,unit_status_badge,skeleton,empty_state,error_state,sheet_header,ts_app_bar,ts_dialog,ts_snackbar,nav_bar,nav_rail,app_shell}.dart`, `lib/core/presentation/di/core_presentation_module.dart`, `lib/core/presentation/utils/{currency,date,time}_formatter.dart`, `test/app/{app_theme,app}_test.dart`, `test/app/navigation/router_test.dart`, `test/core/presentation/components/{ts_button,ts_text_field,ts_chip,unit_status_badge,app_shell}_test.dart`, `test/core/presentation/utils/{currency,date,time}_formatter_test.dart`, `test/support/{fake_session_repository,fake_settings_repository}.dart`, `docs/plan/mobile-app/10-foundations-app-shell.md`, `docs/plan/mobile-app/00-index.md`.

Next step: **11** — Auth screens S01–S04 (`docs/plan/mobile-app/11-auth-s01-s04.md`), the first screens to replace the router's `Placeholder` stubs.
