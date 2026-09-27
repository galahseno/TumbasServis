# Step 01 — Project setup & scaffold

| | |
|---|---|
| **Status** | ✅ Approved |
| **Layer** | Setup |
| **Priority** | — |
| **Owns** | Flutter project scaffold, `pubspec.yaml`, lint config, `Result<T>`, README skeleton |
| **PRD refs** | [07 architecture & tech](../../../prd/07-architecture-tech.md) (feature map, tech stack, Android build), [08 M3/M5](../../../prd/08-deliverables-acceptance.md) |
| **Design refs** | `design/pencil/exports/step02/app-icon/` (adaptive icon PNGs, if reused now) |
| **Depends on** | — (first step) |
| **Claude session** | `docs/claude-session/apps/02-mobile-step01-setup-scaffold.md` (written after approval) |

## Goal

Stand up the Flutter project at the repo root with the clean-architecture folder skeleton, the reference dependency stack, lint rules that keep the layer boundary honest, and one shared cross-layer type (`Result<T>`) — no feature code yet. Ends with a green `flutter analyze` + `flutter test` on an empty app.

## Inputs

- `.claude/skills/flutter-clean-architecture/SKILL.md` (canonical folder tree, dependency rule, style rules).
- `prd/07-architecture-tech.md` (tech stack list, Android build section, quality gates).
- Installed toolchain: Flutter 3.44.0 stable / Dart 3.12.0 (`flutter --version`).
- Existing repo root: `prd/`, `docs/`, `design/`, `.claude/`, `.gitignore`, `Assessment/` (must survive `flutter create` untouched).

## Open questions (ask at kickoff)

1. `flutter create` at the repo root will want to write its own `.gitignore`/`analysis_options.yaml`/`README.md` — confirm merging into the existing ones (keeping `Assessment/`, `.idea/`, `.grepai/`, `.claude/` ignores) rather than overwriting. → **Merged** (root `.gitignore` untouched by `flutter create` since it pre-existed; Flutter/Dart entries + keystore ignore appended by hand).
2. Reuse `design/pencil/exports/step02/app-icon/*.png` for `flutter_launcher_icons` now, or defer icon/splash wiring to step 28 (recommended — icons only need to exist once, right before the release build; keeps this step code-only)? → **Deferred to step 28** (recommended option). Packages added to `pubspec.yaml` now, left unconfigured.
3. Any package version pin the user already knows conflicts with Flutter 3.44.0 (none expected — resolved live via `flutter pub add`)? → **None.** Resolved live; `freezed` repinned from an auto-resolved `4.0.0-dev.3` prerelease to stable `^3.2.5` (matches `freezed_annotation 3.1.0`, the latest stable — `freezed` stable `4.x` needs `freezed_annotation 4.x`, not yet released).
4. `minSdkVersion`/`targetSdkVersion`: accept `flutter create`'s current Flutter-3.44 defaults, or does the assessment target a specific minimum Android version? → **Accepted Flutter 3.44 defaults**, no override.
5. (Added during execution) Step 28's doc notes keystore `.gitignore` entries get added "if not already added in step 01" — add now or wait? → **Added now**: `.gitignore` gained `android/key.properties`, `*.jks`, `*.keystore`; committed `android/key.properties.example` placeholder.

## Scope

### Files / classes to build

- `flutter create --org com.galahseno --project-name tumbas_servis --platforms android .` at the repo root (Android-only per PRD 07 "iOS not required"; verify no existing root file is clobbered — dry-run/diff first).
- `pubspec.yaml` — add: `flutter_riverpod`, `freezed_annotation` + `freezed` (dev) + `build_runner` (dev), `json_annotation` + `json_serializable` (dev), `go_router`, `intl`, `shared_preferences`, `hive_ce` (+ its generator if used), `qr_flutter`, `url_launcher`, `flutter_svg`, `flutter_native_splash` (dev), `flutter_launcher_icons` (dev). Versions resolved at build time to latest stable compatible with the installed SDK (PRD 07 — not pinned in the PRD).
- `analysis_options.yaml` — `package:flutter_lints`, plus `always_use_package_imports: true` and a note documenting the manual layer-direction grep (no automated custom lint package needed for this project size).
- `lib/core/domain/model/result.dart` — the shared `Result<T>` sealed class (`Ok`/`Error`), defined once per the skill, since every later layer depends on it.
- `lib/main.dart` — thin, `main() => bootstrap();` stub (`bootstrap()` itself grows in step 10; here it's a placeholder `runApp(MaterialApp(home: Placeholder()))` so the app boots).
- Empty feature folders are **not** pre-created as empty directories (git doesn't track those); each feature's folder appears with its first real file in steps 02–24. This step only creates `lib/core/domain/model/`.
- `README.md` at repo root — skeleton only (Overview, "Setup" section marked TODO, filled in full at step 28 for M5).
- Merge `.gitignore` (keep existing entries; add Flutter's `build/`, `.dart_tool/`, `*.iml` if `flutter create` proposes new ones not already covered).

### Tests to write

- `test/core/domain/model/result_test.dart` — `Result.ok`/`Result.error` construction and exhaustive `switch` pattern matching.
- Default `flutter create` widget test either removed or updated to match the placeholder `main.dart` (no dangling reference to the template counter app).

## Checklist

### Build
- [x] Open questions answered.
- [x] `flutter create` run at root; existing `prd/`, `docs/`, `design/`, `.claude/`, `Assessment/` untouched (verified with `git status`).
- [x] `pubspec.yaml` dependencies added, `flutter pub get` succeeds.
- [x] `analysis_options.yaml` configured.
- [x] `Result<T>` written.
- [x] `main.dart` placeholder boots.
- [x] README skeleton written.
- [x] `.gitignore` merged (no `build/`/`.dart_tool/` tracked; existing entries kept).

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test` → green (`result_test.dart`; template `test/widget_test.dart` removed — no placeholder widget to test against).

### Review gate
- [x] Status 🔵; showed the user `pubspec.yaml`, `analysis_options.yaml`, `Result<T>`, `git status` diff.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `011 - Setup Flutter Project Scaffold`.
- [x] Claude session file written (`docs/claude-session/apps/02-mobile-step01-setup-scaffold.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Review rounds

#### Round 1 — 2026-09-27
- **Shown:** `pubspec.yaml`, `analysis_options.yaml`, `lib/core/domain/model/result.dart`, `git status` diff (`.gitignore`/`README.md` modified; `android/`, `lib/`, `test/`, `pubspec.yaml`/`.lock`, `analysis_options.yaml`, `.metadata` new).
- **User feedback:** "approve, next session when done doing task update the plan so when i manual review can check there too before i say approve and you do the rest"
- **Changes made:** None to the scaffold itself. Adopted as standing workflow: future steps update this file's checklist/review-rounds/session-log **before** requesting approval, so the doc itself is reviewable, not just the chat summary.
- **Outcome:** Approved.

## Session log

| Time | Action | Result |
|---|---|---|
| 21:50 | `flutter create --org com.galahseno --project-name tumbas_servis --platforms android .` | 31 files written; `prd/`, `docs/`, `design/`, `.claude/`, `Assessment/`, root `.gitignore`/`README.md` untouched |
| 21:52 | `flutter pub add` (runtime: riverpod, freezed_annotation, json_annotation, go_router, intl, shared_preferences, hive_ce, qr_flutter, url_launcher, flutter_svg) | 52 deps resolved |
| 21:53 | `flutter pub add --dev` (freezed, build_runner, json_serializable, flutter_native_splash, flutter_launcher_icons) | `freezed` auto-resolved to prerelease `4.0.0-dev.3`; repinned to stable `^3.2.5` |
| 21:55 | Wrote `analysis_options.yaml` additions (`analyzer.exclude` for generated files, `always_use_package_imports: true`) | — |
| 21:56 | Wrote `lib/core/domain/model/result.dart` + `test/core/domain/model/result_test.dart` (4 tests) | — |
| 21:57 | Wrote `lib/main.dart` placeholder; removed template `test/widget_test.dart` | — |
| 21:58 | Merged `.gitignore` (Flutter/Dart entries + `android/key.properties`, `*.jks`, `*.keystore`); added `android/key.properties.example`; wrote README skeleton | — |
| 21:59 | `flutter analyze` / `dart format --set-exit-if-changed .` / `flutter test` | 0 issues; clean; 4/4 tests passed |
