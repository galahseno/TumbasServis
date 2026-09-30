# Claude Session Log — 29: Mobile-app step 28 — Release, signing & polish

**Tool:** Claude Code, model Sonnet 5.5
**Date:** 2026-09-30
**Topic:** Tag-triggered GitHub release (signed Android APK + ad-hoc macOS DMG), release signing, app-id alignment, README, reduced-motion audit, final acceptance walk.

## Initial prompt

> i want to do docs/plan/mobile-app/28-xx, interviewme with detail if need, use grepai to explore codebase
> for release i want use github workflow when push tag to release prod my android app and macos app, for secret set in local and ignore but give summarize which i should add and how in the github secret (security proper)

## Research performed

- `grepai search` + reads: no `.github/`; `android/app/build.gradle.kts` release used the debug key; `key.properties.example` + gitignore entries existed, no keystore; Android id `com.galahseno.tumbas_servis` vs PRD 07 `com.galahseno.tumbasservis`; macOS bundle `com.galahseno.tumbasServis`, sandbox on without file-access entitlement (needed by `image_picker`), ad-hoc `CODE_SIGN_IDENTITY`; only Apple *Development* certs on the machine; generated files committed (no `build_runner` in CI); native splash resources already hand-written in step 25.
- Resolved current major versions + commit SHAs of the five GitHub Actions used, via `gh api`.

## Clarifying interview

| Question | Answer |
|---|---|
| macOS signing | Ad-hoc / unsigned (no Apple secrets) |
| Android keystore | Claude generates it locally; user-chosen password; base64 for CI transport |
| Release shape | tag `vX.Y.Z` → build-name; plus DMG (via `hdiutil`) and `SHA256SUMS.txt` (user asked whether recommended → yes, both); no AAB |
| App id | Align to PRD 07 (`com.galahseno.tumbasservis`) |

## Execution

- App id aligned (Gradle, `MainActivity.kt` package dir, macOS xcconfig + RunnerTests ids).
- Android: `signingConfigs.release` from `android/key.properties`, debug fallback when absent; keystore (PKCS12) + `key.properties` generated, both gitignored; `key.properties.example` refreshed.
- macOS: `files.user-selected.read-only` entitlement added (Release + DebugProfile).
- `.github/workflows/release.yml`: verify → android ‖ macos → release; dry-run via `workflow_dispatch`; SHA-pinned actions, least-privilege permissions, secrets scoped to the Android signing step, keystore removed in an `always()` step, debug-signature guard via `apksigner`, tag-on-main check, env-passed untrusted context. `actionlint` clean.
- README written; step 28 file + index updated.
- Reduced-motion audit: 3 gaps fixed (onboarding page turn + dots, promo dots); +2 widget tests.
- Verified locally: APK signed `CN=Tumbas Servis`, package id correct; macOS build ad-hoc signed, entitlements present, `codesign --verify --deep --strict` OK, DMG builds; `flutter analyze` 0, format clean, 1412 tests pass.

## Review rounds

Round 1 — user: "approve do the rest except commit and push" → finished the remaining items, staged nothing beyond the working tree for the user's manual review; no commit, no push, no `gh secret set` (user adds the secrets themselves).

## Key decisions worth flagging to a reviewer

- macOS build is intentionally **not notarized** (no paid Developer ID); README documents the Gatekeeper bypass. Adding notarization later means ~6 more secrets and a signing step.
- Debug-key fallback in Gradle is deliberate (M5: reviewer with only Flutter must run `--release`); the workflow fails if a release APK is debug-signed.
- The keystore password is intentionally weak (assessment project, user's choice) and is **not** recorded in any committed doc.
- `flutter_native_splash` not added — step 25's launch resources already cover it.
- PRD 08 M3: repo is currently **private**; must be made public before submission.
- Known layering deviations (presentation importing `booking/data/util/time_slot_format.dart` and three `core/data/service/*` files) noted, not fixed here.

## Output

Files: `.github/workflows/release.yml`, `android/app/build.gradle.kts`, `android/key.properties.example`, `MainActivity.kt` (moved), `macos/Runner/{Configs/AppInfo.xcconfig,Release.entitlements,DebugProfile.entitlements}`, `macos/Runner.xcodeproj/project.pbxproj`, `README.md`, onboarding/promo reduced-motion fixes + test, step 28 + index docs.
Next (user): set 4 GitHub secrets, commit, push, run dry-run, make repo public, push first tag.
