# Step 28 — Release & polish

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Layer** | Release |
| **Priority** | — (M3/M4/M5 are mandatory) |
| **Owns** | Launcher icon/splash, full device-matrix pass, release APK, README, submission checklist |
| **PRD refs** | [07 Android build](../../../prd/07-architecture-tech.md), [08 deliverables & acceptance](../../../prd/08-deliverables-acceptance.md) |
| **Design refs** | `design/pencil/exports/step02/app-icon/` (adaptive icon), any splash export |
| **Depends on** | Step 27 (everything else complete) |
| **Claude session** | `docs/claude-session/apps/29-mobile-step28-release-polish.md` (written after approval) |

## Goal

Turn the finished app into the four mandatory deliverables (M3 public repo, M4 installable APK, M5 README) plus a final acceptance pass against PRD 08's traceability matrix and submission checklist.

## Inputs

- PRD 07 Android build section (applicationId, signing, `flutter build apk --release`).
- PRD 08 mandatory/bonus traceability matrix (M1–M5, B1–B5) and pre-submission checklist.
- `design/pencil/exports/step02/app-icon/` (adaptive icon PNGs) for `flutter_launcher_icons`; check for a splash-specific export (the design plan's step 02/11 may not have a dedicated splash PNG — ask the user if one is needed beyond the in-app S01 splash widget already built in step 11).

## Open questions (ask at kickoff)

1. `flutter_native_splash` — does the native (OS-level) splash need to visually match S01's in-app splash (tile mark on `bg-page`), or is a minimal native splash (background color + centered mark, no wordmark animation — animations aren't possible at the native-splash layer anyway) acceptable? Recommend: minimal native splash matching just the tile-mark-on-`bg-page` moment; the wordmark fade-in stays purely in-app (S01's own widget), already built.
2. Release keystore — generate now interactively with the user (requires their input for keystore password/alias), or is one already prepared? This step cannot proceed past the signed-APK step without it.
3. APK hosting — GitHub Releases vs. Google Drive (PRD 08 allows either); confirm which, since the README's download link depends on it.
4. Reduced-motion audit — a manual `MediaQuery.disableAnimations` toggle test across the app (every animated widget already built with a static/instant fallback per each screen step's own build), or does this step need to retrofit any animation that was missed? Treat as a checklist item to verify, not assume.

## Scope

### Files / classes to build

- `flutter_launcher_icons` config + run (adaptive icon from the design export).
- `flutter_native_splash` config + run (per the kickoff decision).
- `android/key.properties.example` (committed) + `.gitignore` entries for the real `key.properties`/`*.jks` (if not already added in step 01).
- `README.md` — filled in full: overview, screenshots (optional), SDK setup (`flutter pub get`, `build_runner`, `flutter run`), APK download link, architecture note (points at the 4 skills + PRD 07), known limitations (any P1 state consciously deferred per step 25's list; the phone-only-with-bonus-tablet framing).
- Final acceptance pass: walk PRD 08's mandatory (M1–M5) and bonus (B1–B5) traceability rows against the actual app; note any gap explicitly (e.g., M1's Figma link is the design phase's own deliverable, tracked separately in `docs/plan/design/20-figma-conversion.md`/`21-figma-prototype-publish.md`, not this plan).
- `flutter build apk --release`.

### Tests to write / verify

- Full device-matrix manual pass (PRD 06: 360×640, 360×800, 393×852, 412×915, 800×1280, 1280×800, 1024×768, 673×841) across every P0 screen at minimum, P1/P2 screens on the standard phone + one tablet size, per PRD 06's own rule.
- Reduced-motion pass: toggle `MediaQuery.disableAnimations` (via an accessibility setting or a debug override) and confirm every animated screen (S01 wordmark, S05 promo carousel, S11/S21 timelines, S02 slides) falls back to static/instant with no state carried by motion alone.
- Clean-install smoke test: `flutter build apk --release` artifact installs and launches on a clean emulator/device with no dev-only config leaking in.

## Checklist

### Build
- [ ] Open questions answered.
- [ ] Launcher icon + splash wired from the design exports.
- [ ] README filled per M5's acceptance criterion ("a reviewer with only Flutter installed can follow it without asking a question").
- [ ] Signed release keystore in place, not committed; `key.properties.example` committed.
- [ ] `flutter build apk --release` succeeds.
- [ ] APK uploaded (GitHub Releases or Drive per the kickoff answer); link opens in incognito without a permission prompt.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues (final, whole project).
- [ ] `dart format --set-exit-if-changed .` → clean (final, whole project).
- [ ] `flutter test` → green (final, whole suite).
- [ ] Full PRD 06 device-matrix manual pass → 0 overflow.
- [ ] Reduced-motion pass → every animation has a static fallback.
- [ ] PRD 08 traceability matrix walked row by row; every mandatory item satisfied, every bonus item addressed or its trade-off documented (tablet depth, any deferred P1 state).

### Review gate
- [ ] Status 🔵; show the user the built APK, the README, the device-matrix pass results, and the completed PRD 08 traceability walk.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `038 - Release Polish, APK Build & README`.
- [ ] Claude session file written (`docs/claude-session/apps/29-mobile-step28-release-polish.md`).
- [ ] Tracker in `00-index.md` set to ✅. **Mobile-app implementation plan complete — M3/M4/M5 satisfied; M1/M2 depend on the (separately tracked) design-phase Figma conversion steps 20–21.**

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
