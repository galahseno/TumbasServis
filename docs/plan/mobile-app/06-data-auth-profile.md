# Step 06 — Data layer: Auth & Profile (Settings)

| | |
|---|---|
| **Status** | ✅ Approved |
| **Layer** | Data |
| **Priority** | — |
| **Owns** | `auth/data/` (`SessionRepositoryImpl`), `profile/data/` (`SettingsRepositoryImpl`) |
| **PRD refs** | [05](../../../prd/05-data-model-mock.md), [03 F1 first-launch & auth](../../../prd/03-user-flows.md) |
| **Design refs** | — |
| **Depends on** | Steps 03, 05 |
| **Claude session** | `docs/claude-session/apps/07-mobile-step06-data-auth-profile.md` (written after approval) |

## Goal

Implement the two smallest, most cross-cutting repositories: session (login/OTP/logout/current user) and settings (theme mode, demo-mode flag) — both mock, both persisted locally, both consumed by nearly every other feature indirectly (session gates routing; settings drives theme + `DemoModeController`).

## Inputs

- `.claude/skills/flutter-data-layer/SKILL.md` (DTO/mapper/repository-impl/DI pattern).
- `prd/03-user-flows.md` F1 (mock OTP `123456`, persisted session, wrong-code handling).
- `prd/05-data-model-mock.md` `SessionRepository`/`SettingsRepository` method lists.
- Step 05's `LocalStore`, `DemoModeController`.

## Open questions (ask at kickoff)

1. Mock login has no real DTO (no HTTP) — confirm `login(phone)`/`verifyOtp(code)` are still modeled with tiny request/response-shaped classes in `auth/data/model/` for consistency with the skill's DTO convention, or skip DTOs entirely for a fully local mock (recommend: skip — no transport boundary exists here, the repository impl talks to `LocalStore` directly; DTOs are for the JSON boundary, which steps 07–09 do have).
2. Session persistence: store just a boolean "is logged in" + the seeded `User`, or a mock token string too (for parity with a future real backend)? Recommend a mock token string (`"mock-session-token"`) stored via `LocalStore`, since PRD 07's `redirect` logic checks `SessionRepository.currentUser()`.

## Scope

### Files / classes to build

`lib/auth/data/`:
- `repository/session_repository_impl.dart` — `SessionRepositoryImpl implements SessionRepository`: `login` (always succeeds after `simulateLatency`), `verifyOtp` (`123456` → success, else `Result.error`), `logout` (clears session only, per PRD 04 S25 "neutral logout"), `currentUser()` (reads `LocalStore` + `user.json` via `MockJsonLoader`).
- `di/auth_data_module.dart` — `sessionRepositoryProvider` (interface-typed).

`lib/profile/data/`:
- `repository/settings_repository_impl.dart` — `SettingsRepositoryImpl implements SettingsRepository`: `getThemeMode`/`setThemeMode` (persisted via `LocalStore`), `isDemoModeEnabled`/`setDemoMode` (delegates to `DemoModeController`).
- `di/profile_data_module.dart` — `settingsRepositoryProvider`.

### Tests to write

- `test/auth/data/repository/session_repository_impl_test.dart` — correct OTP succeeds, wrong OTP errors, `currentUser()` reflects persisted session across a "restart" (new `LocalStore` instance reading the same fake backing store).
- `test/profile/data/repository/settings_repository_impl_test.dart` — theme mode round-trips; demo-mode flag round-trips and matches `DemoModeController` state.

## Checklist

### Build
- [x] Open questions answered.
- [x] `SessionRepositoryImpl`, `SettingsRepositoryImpl` written + DI modules.
- [x] Neither impl imports anything under `*/presentation/`.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test test/auth/data/ test/profile/data/` → green.

### Review gate
- [x] Status 🔵; show the user both impls + test results.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `016 - Create Auth & Profile Data Layer`.
- [x] Claude session file written (`docs/claude-session/apps/07-mobile-step06-data-auth-profile.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Review rounds

#### Round 1 — 2026-09-28
- **Shown:** `session_repository_impl.dart`, `settings_repository_impl.dart`, both DI modules, 12/12 test results, quality-gate output.
- **User feedback:** "approve"
- **Changes made:** none.
- **Outcome:** approved.

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-28 | Kickoff open questions answered (skip DTOs; no mock token, flag+cached User only). | — |
| 2026-09-28 | Wrote `SessionRepositoryImpl`, `SettingsRepositoryImpl` + DI modules. | 4 files: `auth/data/repository/session_repository_impl.dart`, `auth/data/di/auth_data_module.dart`, `profile/data/repository/settings_repository_impl.dart`, `profile/data/di/profile_data_module.dart` |
| 2026-09-28 | Wrote repo-impl tests. | 2 files: `test/auth/data/repository/session_repository_impl_test.dart` (8 tests), `test/profile/data/repository/settings_repository_impl_test.dart` (4 tests) |
| 2026-09-28 | Quality gate. | `flutter analyze` 0 issues; `dart format` clean; `flutter test test/auth/data/ test/profile/data/` → 12/12 passed; layer-direction grep clean |
| 2026-09-28 | Review round 1 — approved. | Status → ✅ |
