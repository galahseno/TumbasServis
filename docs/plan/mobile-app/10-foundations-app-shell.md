# Step 10 — Foundations: theme, router, app shell, core components

| | |
|---|---|
| **Status** | ⬜ Not started |
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
2. `TsThemeExtension` field list — confirm it should include every non-`ColorScheme` token from PRD 02's mapping table (`textMuted`, `textFaint`, `borderDefault`, `borderStrong`, `focusRing`, status colors + soft/text variants, glass tokens, shadow tokens, `ratingStar`) plus the design-phase additions (`ratingStar`, `focus-ring` light = `orange-600`).
3. Router redirect: global `redirect` reads `sessionRepositoryProvider.currentUser()` — confirm the "no session → `/login`, except `/splash` and `/onboarding`" gate is the only global rule for now (per-route gates like the review hard-gate arrive with their own screens later).
4. `NavBar`/`NavRail`/`AppShell` — build all 12 `AppShell` masters now (compact/medium/large × 4 tabs) as real widgets even though only S05's tab has content yet (the other 3 branches show a `Placeholder` until steps 21/22/24 replace them)? Recommended — matches the design's own "shell first" sequencing.
5. Glass `NavBar`: build the real `BackdropFilter` now, or a flat placeholder now and add the glass treatment once the perf budget is checked in step 20? Recommend: build it real now (only 1 instance on screen, well under the 1–2 budget) but keep the flat-fallback swap point documented for step 20 to exercise if needed.

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
- [ ] Open questions answered.
- [ ] Theme (`ColorScheme` + `TsThemeExtension` + `TextTheme`) matches PRD 02's **design-phase-resolved** tokens exactly, both themes.
- [ ] Router: every PRD 07 route present (stub pages OK), global redirect works, 4 shell branches wired.
- [ ] All core components built with every state the design specifies (default/pressed/focused/disabled/loading where applicable); no color-only status signaling.
- [ ] `AppShell` (12 masters) built with a content slot.
- [ ] Formatters produce PRD 02's exact example outputs (`Rp412.000`, `Sen, 29 Sep 2026`, `09.00`).

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test test/app/ test/core/presentation/` → green.
- [ ] Manual run: app boots to `/splash` placeholder, theme toggle (light/dark) visibly correct, bottom `NavBar`/`NavRail` swap at the PRD 06 breakpoints (compact/medium/large) even with placeholder content.
- [ ] Screenshot each core component's states; compare against `design/pencil/exports/step03/*.png` for color/spacing/type parity.

### Review gate
- [ ] Status 🔵; show the user the theme (light+dark screenshots), the component gallery, and the route table.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `020 - Create App Foundations, Theme & Shared Components`.
- [ ] Claude session file written (`docs/claude-session/apps/11-mobile-step10-foundations-app-shell.md`).
- [ ] Tracker in `00-index.md` set to ✅.

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
