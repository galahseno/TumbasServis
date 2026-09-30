# Step 28 — Release, signing & polish

| | |
|---|---|
| **Status** | ✅ Approved (2026-09-30) — post-push verification (secrets, dry run, first tag) is the user's |
| **Layer** | Release |
| **Priority** | — (M3/M4/M5 are mandatory) |
| **Owns** | App-id alignment, Android release signing, macOS release entitlements, tag-triggered GitHub release workflow, README, native splash, full device-matrix pass, submission checklist |
| **PRD refs** | [07 Android build](../../../prd/07-architecture-tech.md), [08 deliverables & acceptance](../../../prd/08-deliverables-acceptance.md) |
| **Design refs** | `design/pencil/exports/step02/app-icon/` (adaptive icon), any splash export |
| **Depends on** | Step 27 (everything else complete) |
| **Claude session** | `docs/claude-session/apps/29-mobile-step28-release-polish.md` (written after approval) |

## Goal

Turn the finished app into the mandatory deliverables (M3 public repo, M4 installable APK, M5 README) **and make releasing repeatable**: pushing a `vX.Y.Z` tag builds a signed Android APK + an ad-hoc-signed macOS DMG and publishes a GitHub Release. Finish with a final acceptance pass against PRD 08's traceability matrix and submission checklist.

## Inputs

- PRD 07 Android build section (applicationId, signing, `flutter build apk --release`).
- PRD 08 mandatory/bonus traceability matrix (M1–M5, B1–B5) and pre-submission checklist.
- `assets/icon/*` + the `flutter_launcher_icons` block in `pubspec.yaml` (icons already generated in step 25).

## Open questions (answered at kickoff, 2026-09-30)

1. **macOS signing** → **ad-hoc / unsigned**, no Apple secrets (no paid Developer ID). README documents the Gatekeeper bypass (Open Anyway / `xattr -dr com.apple.quarantine`). Packaged as `.dmg` with the built-in `hdiutil` (no third-party action).
2. **Android keystore** → generated locally with `keytool` (PKCS12, alias `tumbas`), gitignored, shipped to CI as a base64 secret. Password chosen by the user (assessment project; weak by choice — noted, not a template for real apps). Never written into this repo's docs or session logs.
3. **Release shape** → tag `vX.Y.Z[-suffix]` → `--build-name X.Y.Z`, `--build-number $GITHUB_RUN_NUMBER`; a `-suffix` tag is a prerelease. Outputs: APK, macOS DMG, `SHA256SUMS.txt`, generated release notes. AAB skipped (no Play Store).
4. **Application id** → aligned to PRD 07: `com.galahseno.tumbasservis` on Android **and** macOS (was `com.galahseno.tumbas_servis` / `com.galahseno.tumbasServis`), done before the first signed release since the id is permanent once shipped.
5. **APK hosting** → GitHub Releases (the workflow's output; README links to `/releases/latest`).
6. **Native splash** → already satisfied by step 25's hand-written launch resources (`launch_background.xml` = `bg-page` colour, Android 12 `windowSplashScreen*` with the launcher icon, night variants). `flutter_native_splash` deliberately **not** added — no new dependency needed; macOS has no OS-level splash.
7. **Reduced-motion audit** → verify-only checklist item, not a retrofit, unless the pass finds a miss.

## Scope

### Built (this session)

- `android/app/build.gradle.kts` — `namespace`/`applicationId` → `com.galahseno.tumbasservis`; `signingConfigs.release` read from `android/key.properties` when present, **debug-key fallback when absent** (so a reviewer with only Flutter still runs `--release`; CI asserts the file exists and the APK isn't debug-signed). `MainActivity.kt` moved to `.../com/galahseno/tumbasservis/`.
- `android/key.properties.example` refreshed (committed); real `android/key.properties` + `android/app/upload-keystore.jks` (both gitignored).
- `macos/Runner/Configs/AppInfo.xcconfig` + `Runner.xcodeproj` (RunnerTests) → `com.galahseno.tumbasservis`; `Release.entitlements`/`DebugProfile.entitlements` gain `com.apple.security.files.user-selected.read-only` (sandboxed `image_picker`).
- `.github/workflows/release.yml` — `verify` (analyze + test, tag-on-main check, version derivation) → `android` + `macos` in parallel → `release` (checksums, `gh release create`). `workflow_dispatch` = dry run (artifacts only). Hardening: `permissions: {}` + per-job least privilege (`contents: write` only in `release`), every action pinned to a commit SHA, `persist-credentials: false`, secrets only in the `android` job's signing step and the `release` environment, keystore decoded into `$RUNNER_TEMP` and removed in an `if: always()` step, untrusted `github.*` values passed via `env` not interpolated into scripts, `concurrency` + `timeout-minutes`.
- `README.md` — filled (overview, download, macOS first-launch, run from source, architecture, release process, signing secrets).

### Reduced-motion audit (done)

Every animated file was cross-checked for `disableAnimations` handling. Already correct: S01 splash, success header (S18), skeleton, segmented control, home loading progress, rating stars, history tab row, status timeline (S21), promo carousel auto-advance. **Three gaps fixed**: onboarding `nextPage` (now `jumpToPage`), onboarding dot `AnimatedContainer`, promo-carousel dot `AnimatedContainer` (both `Duration.zero`). New test: `test/auth/presentation/onboarding/onboarding_reduced_motion_test.dart` (reduced → one frame advances; default → still animates).

### PRD 08 traceability walk (done)

| Row | Result |
|---|---|
| M1 Figma link | Out of this plan — design-phase steps 20–21 (still deferred) |
| M2 Pixel parity | Checked per screen in steps 11–25 (exports comparison); not re-done here |
| M3 Public repo, clean history | Repo is **currently PRIVATE** (`gh repo view`) → **user must make it public before submission**. 37 commits, numbered `NNN - Title`, one slice each |
| M4 Installable APK | Release-key-signed APK builds and verifies locally; public link exists only after the first tag push |
| M5 README | Filled. Note: PRD text says `build_runner` step — generated files are committed, so it is documented as needed only when editing `@freezed`/`@JsonSerializable` classes |
| B1 Screens | S01–S26 all built (steps 11–24) |
| B2 Brand + light/dark | `AppTheme.light/dark` + `themeModeProvider` wired in `app.dart` |
| B3 Mock data + state mgmt | 11 mock JSONs (5 workshops, 16 models, 14 parts, 6 mechanics, 9 notifications, 5 seeded bookings…); Riverpod only — no `provider`/`bloc`/`ChangeNotifier` in `lib/` |
| B4 Responsive | Layout tests present at all 8 PRD 06 sizes (×1.0 and ×1.3 text); whole suite green. A hands-on device pass is left to the user's own emulator run |
| B5 Clean architecture | `grep package:flutter/ lib/*/domain lib/core/domain` → empty. **Documented deviations** in `presentation/` → `data/`: (a) `*/data/di/*_data_module.dart` provider imports — the skill's "reach repositories through DI", intended; (b) 4 files import `booking/data/util/time_slot_format.dart` (`pilih_jadwal` VM + 2 components, `ubah_jadwal_view_model`) and 7 import `core/data/service/{demo_mode_controller,photo_picker_service,demo_content_seeder}.dart` — known cross-feature services from steps 05/12/24; candidates for step 29's `utils/` extraction, not release blockers |

### Tests to write / verify

- Full device-matrix manual pass (PRD 06: 360×640, 360×800, 393×852, 412×915, 800×1280, 1280×800, 1024×768, 673×841): every P0 screen at minimum; P1/P2 on the standard phone + one tablet size.
- Reduced-motion pass: `MediaQuery.disableAnimations` → S01 wordmark, S05 carousel, S11/S21 timelines, S02 slides fall back to static/instant.
- Clean-install smoke test of the **released** APK on a clean emulator/device.

## Secrets (GitHub → repo `galahseno/TumbasServis`)

Only four, all Android. macOS needs none; `GITHUB_TOKEN` is automatic.

| Secret | Content |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | base64 of `upload-keystore.jks` (binary → text encoding only, not encryption) |
| `ANDROID_KEYSTORE_PASSWORD` | keystore password |
| `ANDROID_KEY_PASSWORD` | key password (equals keystore password for PKCS12) |
| `ANDROID_KEY_ALIAS` | `tumbas` |

Set with `gh secret set NAME --repo galahseno/TumbasServis` (paste at the prompt, or `< file` for the base64). Back up the `.jks` offline; losing it means future releases can't be signed as the same app. Recommended (optional): a repo ruleset limiting `v*` tag creation to the owner, and required reviewers on the `release` environment.

## Checklist

### Build
- [x] Open questions answered.
- [x] App id aligned (Android + macOS).
- [x] Release signing wired; keystore + `key.properties` generated locally, ignored by git.
- [x] `flutter build apk --release` → signed with `CN=Tumbas Servis`, package `com.galahseno.tumbasservis`.
- [x] `flutter build macos --release` → ad-hoc signed, sandbox + file-access entitlements present, `codesign --verify --deep --strict` OK, DMG packaging OK.
- [x] `.github/workflows/release.yml` written; `actionlint` clean; all `uses:` SHA-pinned.
- [x] README filled per M5.
- [x] Native splash — satisfied by step 25 launch resources (no new dependency).
- [ ] **User:** set the 4 GitHub secrets, push, run the dry run (`workflow_dispatch`) → green.
- [ ] **User:** make repo public, push first tag → Release has APK, DMG, `SHA256SUMS.txt`; APK link opens in incognito without a permission prompt.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test` → 1412 passed (+2 reduced-motion tests).
- [x] PRD 06 device matrix → covered by layout tests at all 8 sizes (0 overflow); hands-on emulator pass left to the user.
- [x] Reduced-motion pass (3 gaps fixed).
- [x] PRD 08 traceability matrix walked (see above).

### Review gate
- [x] Diff, workflow, secrets table and traceability walk shown.
- [x] Approved.

### Close (only after approval)
- [x] Commit message proposed: `038 - Release Workflow, Signing & README` (user commits + pushes).
- [x] Claude session file written (`docs/claude-session/apps/29-mobile-step28-release-polish.md`) — no passwords in it.
- [x] Tracker in `00-index.md` set to ✅. **Mobile-app implementation plan complete — M3/M4/M5 satisfied; M1/M2 depend on the (separately tracked) design-phase Figma conversion steps 20–21.**

## Review rounds

#### Round 1 — 2026-09-30
- **Shown:** plan (interview answers), then diff + workflow + secrets table + local build verification.
- **User feedback:** "approve do the rest except commit and push"
- **Changes made:** reduced-motion fixes + test, traceability walk, session log, tracker; staged for the user's own review (no commit/push).
- **Outcome:** approved

## Session log

| Time | Action | Result |
|---|---|---|
| — | Explored (grepai): no workflows, release signing = debug key, ids mismatched PRD 07, macOS sandbox lacks file access | Plan approved (interview: ad-hoc macOS, new keystore, tag→version, align ids) |
| — | Aligned ids, wired signing, generated keystore/`key.properties`, entitlements, workflow, README | APK signed w/ release cert, macOS ad-hoc OK, actionlint clean, analyze 0 / format clean / 1410 tests pass |
| — | Reduced-motion audit → 3 gaps fixed + test; PRD 08 walk; native splash judged already done | analyze 0 / format clean / 1412 tests pass |
