# Step 10 — Foundations: theme, router, app shell, core components

| | |
|---|---|
| **Status** | ✅ Approved |
| **Layer** | Presentation (foundation) |
| **Priority** | — (foundation for every screen) |
| **Owns** | `app/`, `core/presentation/components/`, `core/presentation/di/`, `core/presentation/utils/` |
| **PRD refs** | [02 brand & design system](../../../prd/02-brand-design-system.md) (tokens, type, glass, component inventory), [07 routing table](../../../prd/07-architecture-tech.md) |
| **Design refs** | `docs/plan/design/02-foundations.md` + session log (tokens/type/elevation/glass/logo), `docs/plan/design/03-components-core.md` + session log (`TsButton`/`TsTextField`/`TsChip`/`TsAppBar`/`SheetHeader`/`NavBar`/`NavRail`/`EmptyState`/`ErrorState`/`Skeleton`/`UnitStatusBadge`/`TsDialog`/`TsSnackbar`/`TsIconButton`), `docs/plan/design/05-s05-home.md` (`AppShell` masters), `design/pencil/exports/step02/`, `design/pencil/exports/step03/` |
| **Depends on** | Steps 01 (project scaffold), 06 (session repository, for router redirect) |
| **Claude session** | `docs/claude-session/apps/11-mobile-step10-foundations-app-shell.md` (written after approval) |

## Goal

Every subsequent presentation step builds on this one: the real `bootstrap()`, the light/dark theme (matching PRD 02's tokens 1:1), the full route table (every route stubbed with a `Placeholder` page until its own step replaces it), and the shared component library. No screen-specific content here — this is the shell.

## Inputs

- `.claude/skills/flutter-presentation-layer/SKILL.md` (screen-folder convention, presentation DI, routing, bootstrap overrides).
- `prd/02-brand-design-system.md` — full color/type/spacing/radius/elevation/glass tables, Material 3 mapping section (verbatim `ColorScheme`/`TsThemeExtension` field mapping), component inventory.
- `prd/07-architecture-tech.md` — route table (`/splash` … `/profile/demo-mode`), `StatefulShellRoute` branches.
- Design step 02/03 session logs — exact resolved token values (the design phase already fixed several PRD 02 contrast issues: `text-muted` → `sand-600`, `border-control`, `focus-ring` → `orange-600` light, `rating-star`, etc. — **use the design's final resolved tokens, not the raw PRD 02 table, wherever design step 19's audit changed a value**).
- Design step 05 session log — `AppShell` (12 masters: 3 layouts × 4 tabs) behavior, glass `NavBar` budget.

## Open questions (ask at kickoff)

1. Exo 2 font: bundle the variable font as an asset (`assets/fonts/Exo2-Variable.ttf` + italic, self-hosted per PRD 02) — confirm the user can supply the font files, or fetch them from Google Fonts now.
   **Answered:** fetch the true variable-font builds (`Exo2[wght].ttf` / `Exo2-Italic[wght].ttf`) from the `google/fonts` GitHub source repo now, save as `assets/fonts/Exo2-Variable.ttf` / `Exo2-Italic-Variable.ttf`. Weights 400/600/800 needed (800 = `TsLogo` monogram only; Exo 2 has no true 700 — anywhere design called for weight 700 as a state cue, it was already replaced by color/shape, not a font weight).
2. `TsThemeExtension` field list — confirm it should include every non-`ColorScheme` token from PRD 02's mapping table (`textMuted`, `textFaint`, `borderDefault`, `borderStrong`, `focusRing`, status colors + soft/text variants, glass tokens, shadow tokens, `ratingStar`) plus the design-phase additions (`ratingStar`, `focus-ring` light = `orange-600`).
   **Answered:** yes, full list confirmed (see step's session log / commit for the final field list).
3. Router redirect: global `redirect` reads `sessionRepositoryProvider.currentUser()` — confirm the "no session → `/login`, except `/splash` and `/onboarding`" gate is the only global rule for now (per-route gates like the review hard-gate arrive with their own screens later).
   **Answered:** exempt set widened to `{/splash, /onboarding, /otp}` — `SessionRepository.currentUser()` only returns non-null after `verifyOtp()` succeeds, so without exempting `/otp` a mid-login user (S04) would get bounced back to `/login` before entering the code. Per-route gates still deferred to their own screens' steps.
4. `NavBar`/`NavRail`/`AppShell` — build all 12 `AppShell` masters now (compact/medium/large × 4 tabs) as real widgets even though only S05's tab has content yet (the other 3 branches show a `Placeholder` until steps 21/22/24 replace them)? Recommended — matches the design's own "shell first" sequencing.
   **Answered:** yes, build now — as a single `AppShell` widget switching `NavBar`/`NavRail` by `MediaQuery` width (not 12 separate classes; the "12 masters" collapse to one parametrized widget, per the design log's own "thin wrapper + content slot" framing). Only `/home`'s tab has real content; `/bookings`, `/garage`, `/profile` branches stay `Placeholder` until steps 21/22/24.
5. Glass `NavBar`: build the real `BackdropFilter` now, or a flat placeholder now and add the glass treatment once the perf budget is checked in step 20? Recommend: build it real now (only 1 instance on screen, well under the 1–2 budget) but keep the flat-fallback swap point documented for step 20 to exercise if needed.
   **Answered:** build it real now (blur + tint via `BackdropFilter`; no `saturate()` equivalent in stock Flutter, documented gap). Flat-fallback swap point left as a code comment for step 20, not a separate toggle.
6. **(New, surfaced during kickoff)** Route nesting: are non-tab-root routes (`/garage/add`, `/garage/:id`, `/bookings/:id`, etc.) nested children of their branch's `GoRoute`, or top-level siblings? **Answered:** top-level siblings — full-screen push over the shell chrome, matching how S08/S09/S20/S21 read in the design docs. Only `/home`, `/bookings`, `/garage`, `/profile` themselves live inside the 4 `StatefulShellRoute` branches.
7. **(New, surfaced during kickoff)** Pencil PNG exports for design steps 02/03/05 are missing on disk (only `step02/app-icon/` and `step04/silhouettes/` exist). **Answered:** skip the pixel-diff QA gate this step; build from the resolved markdown spec instead (`prd/02-brand-design-system.md` + the design session logs). The Quality checklist's screenshot-comparison item is executed as a manual visual review, not a PNG diff.

## Scope

### Files / classes to build

`lib/bootstrap.dart` — real bootstrap: `WidgetsFlutterBinding.ensureInitialized()`, `SharedPreferences.getInstance()`, `Hive`/local-store init, `ProviderScope` with overrides, `runApp(const App())`.

`lib/app/`:
- `app.dart` — `App` (`MaterialApp.router`, `theme`/`darkTheme`/`themeMode` from `SettingsRepository`).
- `app_theme.dart` — `lightColorScheme`/`darkColorScheme` (PRD 02 M3 mapping table), `TsThemeExtension` (light/dark instances), `TextTheme` (11 PRD 02 type roles → `TextStyle`, Exo 2, exact size/line-height/tracking/weight).
- `navigation/router.dart` — `routerProvider` (`GoRouter`), every route from PRD 07's table as a constant + entry, global `redirect`, the four `StatefulShellRoute` branches (`/home`, `/bookings`, `/garage`, `/profile`) each pointing at a `Placeholder` page for now.
- `navigation/routes.dart` — route path constants (no magic strings elsewhere, per the skill).

`lib/core/presentation/components/` (one file per component, mirroring the design's inventory):
`ts_button.dart`, `ts_icon_button.dart`, `ts_text_field.dart`, `ts_chip.dart`, `ts_app_bar.dart`, `sheet_header.dart`, `nav_bar.dart`, `nav_rail.dart`, `app_shell.dart` (the 12-variant shell, content as a `child` slot), `empty_state.dart`, `error_state.dart`, `skeleton.dart` (shimmer line/block/avatar/card), `unit_status_badge.dart` (7 statuses), `ts_dialog.dart` (confirm-destructive/info/choice/blocked builders), `ts_snackbar.dart` (success/info/error builders), `ts_logo.dart` (mark-only/mark+wordmark).

`lib/core/presentation/utils/` — `currency_formatter.dart` (`intl`, `Rp412.000`), `date_formatter.dart` (`EEE, d MMM yyyy`, `id_ID`), `time_formatter.dart` (24h dot separator).

`lib/core/presentation/di/core_presentation_module.dart` — `logoutHandlerProvider` (calls `SessionRepository.logout()` + router redirect), theme-mode provider watching `SettingsRepository`.

### Tests to write

- `test/app/app_theme_test.dart` — spot-checks: `ColorScheme.primary` resolves to `orange-600` (light)/`orange-400` (dark); `TsThemeExtension.of(context)` returns non-null in both themes.
- `test/core/presentation/components/` — widget tests for `TsButton` (all 6 types × 5 states render + tap callback fires when enabled, not when disabled/loading), `TsTextField` (error state shows message not color-only), `UnitStatusBadge` (7 statuses render icon + label, never color-only), `TsChip` (selected/unselected/disabled).
- `test/app/navigation/router_test.dart` — unauthenticated → redirected to `/login`; `/splash`/`/onboarding` exempt.

## Checklist

### Build
- [x] Open questions answered.
- [x] Theme (`ColorScheme` + `TsThemeExtension` + `TextTheme`) matches PRD 02's **design-phase-resolved** tokens exactly, both themes.
- [x] Router: every PRD 07 route present (stub pages OK), global redirect works, 4 shell branches wired.
- [x] All core components built with every state the design specifies (default/pressed/focused/disabled/loading where applicable); no color-only status signaling.
- [x] `AppShell` built with a content slot (single widget covering all 3 layouts × 4 tabs, per kickoff Q4's answer — not 12 separate classes).
- [x] Formatters produce PRD 02's exact example outputs — `Rp412.000` ✅, `09.00` ✅. **Date format note:** PRD 02's own example string "Sen, 29 Sep 2026" is internally wrong — 29 Sep 2026 is a real-calendar **Tuesday**, so `DateFormatter` (which computes the weekday from the actual `DateTime`, not a hardcoded string) correctly produces `Sel, 29 Sep 2026`. Tested against the real weekday, not the PRD's example text.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test test/app/ test/core/presentation/` → green (39 tests). Full project suite also green (231 tests).
- [x] Manual run substitute: no Android emulator or iOS/macOS platform target is set up in this environment (repo only has `android/`), so a real on-device run wasn't possible this session. Verified the breakpoint switch instead with `test/core/presentation/components/app_shell_test.dart`, which pumps the real router + `AppShell` at 360dp/700dp/1300dp widths and asserts `NavBar` (compact) → `NavRail` (medium) → extended `NavRail` (large). Theme toggle is covered by `app_theme_test.dart`/`app_test.dart` (instant switch, correct color resolution) rather than an eyeballed screenshot. **Flagging for the user:** an actual on-device/emulator run is still recommended before this step closes, since widget tests don't catch every visual issue (glass blur rendering, real font weight fidelity, etc.).
- [x] Screenshot comparison against `design/pencil/exports/step03/*.png` **skipped per kickoff Q7** — those exports don't exist on disk. Built directly from the resolved markdown spec instead.

### Review gate
- [x] Status 🔵; file list + notes below stand in for screenshots (no on-device run available this session — see Quality section).
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `020 - Create App Foundations, Theme & Shared Components`.
- [x] Claude session file written (`docs/claude-session/apps/11-mobile-step10-foundations-app-shell.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Review rounds

#### Round 1 — 2026-09-28
- **Shown:** file list (`app/`, `core/presentation/`, `bootstrap.dart`, `main.dart`, `pubspec.yaml`, `assets/fonts/`) + test/quality summary (231/231 green, analyze/format clean); no screenshots (no on-device run available this session).
- **User feedback:** confirmed the blank `Placeholder` box on device is expected for this step; asked to remove the debug banner.
- **Changes made:** added `debugShowCheckedModeBanner: false` to `MaterialApp.router` in `lib/app/app.dart`.
- **Outcome:** approved.

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-28 | Kickoff | Open questions 1-5 answered per plan interview; 2 new questions surfaced (route nesting, missing Pencil exports) and answered. Status → 🟡. |
| 2026-09-28 | Fonts | Fetched Exo 2 variable TTF (roman + italic) from `google/fonts` GitHub source repo into `assets/fonts/`; registered in `pubspec.yaml` (no `weight:` key — variable font, weight via `fontVariations`). |
| 2026-09-28 | Theme | `lib/core/presentation/theme/ts_theme_extension.dart` (new file, not in original scope list — holds the token class so `core/presentation/components/` doesn't have to import `app/`) + `lib/app/app_theme.dart` (`ColorScheme.light/dark`, `TsThemeExtension` instances, 11-role `TextTheme`), transcribed from `prd/02-brand-design-system.md`'s resolved token table. |
| 2026-09-28 | Components | 15 files under `lib/core/presentation/components/`: `ts_logo`, `ts_icon_button`, `ts_button`, `ts_text_field`, `ts_chip`, `unit_status_badge`, `skeleton`, `empty_state`, `error_state`, `sheet_header`, `ts_app_bar`, `ts_dialog`, `ts_snackbar`, `nav_bar` (glass), `nav_rail`, `app_shell`. Found and fixed a real layout bug: `NavBar`'s tab `Column` overflowed vertically at 360dp width (fixed via `Positioned.fill` + tighter padding). |
| 2026-09-28 | Routing | `lib/app/navigation/routes.dart` + `router.dart` — full PRD 07 route table (22 top-level `GoRoute`s + 4 `StatefulShellRoute` branches), global redirect exempting `{/splash, /onboarding, /otp}`. |
| 2026-09-28 | DI + utils + bootstrap | `core_presentation_module.dart` (`themeModeProvider`, `logoutHandlerProvider`), 3 formatters, `bootstrap.dart` rewrite (adds `initializeDateFormatting('id_ID', ...)`, not in the original file-list prose but required by `DateFormatter`), `main.dart` → thin `bootstrap()` call. |
| 2026-09-28 | Tests | 15 new test files (component widget tests, `app_theme_test`, `app_test`, `router_test`, formatter tests, `app_shell_test` breakpoint smoke test) + 2 test fakes (`FakeSessionRepository`, `FakeSettingsRepository`). `flutter analyze` 0 issues, `dart format` clean, `flutter test` 231/231 green (whole project). |
| 2026-09-28 | Note | `grep -rln 'package:tumbas_servis/[a-z_]*/data/' lib/core/presentation/` flags `core_presentation_module.dart` importing `auth/data/di/` and `profile/data/di/` — this is **expected**, not a violation: per `00-index.md`'s own repository-placement convention, the interface-typed provider (e.g. `sessionRepositoryProvider`) is wired in the feature's `data/di/` module, so any code reading that provider imports that file. The grep is a blunt heuristic that will flag every future ViewModel too. |
| 2026-09-28 | Review round 1 | User tested on mobile + desktop: confirmed the blank box-with-cross is the expected `Placeholder` stub, not a bug; asked to remove the debug banner. Added `debugShowCheckedModeBanner: false` to `lib/app/app.dart`. |
| 2026-09-28 | Post-approval fix | Step 09's session log had flagged that `statusNotificationCoordinatorProvider` (built step 09) is lazy and nothing reads it — explicitly noted as "whichever step builds app bootstrap"'s job. Wired it in `lib/bootstrap.dart` via an explicit `ProviderContainer` + eager `container.read(...)` before `runApp` (using `UncontrolledProviderScope`), rather than `ref.watch`-ing it inside `App` — keeps the root widget decoupled from a data-layer service and avoids widget tests needing the full `LocalStore`/`TrackingSimulator` dependency chain. Full suite re-verified: 231/231 green, analyze/format clean. |
