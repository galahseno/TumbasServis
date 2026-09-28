# Claude Session Log — 07: Mobile-app step 06 — Data-layer Auth & Profile

**Tool:** Claude Code (CLI agent), model Sonnet 5
**Date:** 2026-09-28
**Topic:** Build `SessionRepositoryImpl` (`auth/data/`) and `SettingsRepositoryImpl` (`profile/data/`) — the two smallest, most cross-cutting repositories (session gates routing; settings drives theme + demo mode) — per `docs/plan/mobile-app/06-data-auth-profile.md`. First feature-level data step; no `RepositoryImpl` or feature `data/di/` folder existed anywhere in `lib/` before this.

## Initial prompt

> iwant to do docs/plan/mobile-app/06-xx, interviewme with detail if need

## Research performed

1. Read `docs/plan/mobile-app/06-data-auth-profile.md` and `00-index.md` (conventions, repository placement map, decision log) to confirm scope and dependencies (steps 03/05, both ✅).
2. Read `.claude/skills/flutter-data-layer/SKILL.md` for the repository-impl / DI-module pattern.
3. Explored existing step 05 output on disk: `LocalStore` (session flag, theme mode, demo-mode flag via `shared_preferences`; generic JSON-blob box API via `hive_ce`), `MockJsonLoader`, `LatencySimulator`/`FakeLatencySimulator`, `DemoModeController`, `core_data_module.dart`'s plain-`Provider` DI style.
4. Read the exact `SessionRepository`/`SettingsRepository` interfaces, `User` entity, `Result<T>`, `AppThemeMode`, and `assets/mock/user.json` to pin down signatures and shapes before writing any code.
5. Grepped `lib/`/`test/` for every consumer of `DemoModeController` and of `LocalStore.getDemoModeEnabled` — confirmed `DemoModeController` has no boolean "enabled" state and no current consumer treats it as the settings source of truth.

## Clarifying interview (`AskUserQuestion`, 2 questions)

| Question | Answer |
|---|---|
| DTOs for login/verifyOtp, or skip since no HTTP boundary exists? | Skip DTOs — repo impl talks straight to `LocalStore`/`MockJsonLoader`; DTOs stay reserved for steps 07–09's real JSON boundaries |
| Session persistence: flag + cached `User` only, or also a mock token string? | Flag + `User` only — no token concept anywhere in the domain interface, and PRD 07's redirect logic only checks `currentUser()` |

Both answered against the step file's stated recommendation for the second (flag+user vs. flag+user+token) — user chose the leaner option over the step doc's own suggestion.

## Execution

**`lib/auth/data/`**: `repository/session_repository_impl.dart` (`SessionRepositoryImpl`: `login` simulates latency only, no persistence until OTP verified; `verifyOtp('123456')` loads `user.json`, persists session flag + user JSON to `LocalStore`'s `"session"` box; wrong code → `Result.error`, no persistence; `logout()` clears the session flag + cached user only — "neutral logout" scoped to the session box, not other feature boxes; `currentUser()` reads the flag then the cache, degrades to `Ok(null)` on a missing/corrupt cache rather than erroring), `di/auth_data_module.dart` (`sessionRepositoryProvider`, interface-typed, chained off `core_data_module.dart`).

**`lib/profile/data/`**: `repository/settings_repository_impl.dart` (`SettingsRepositoryImpl`: all four methods are thin try/catch pass-throughs to `LocalStore`'s existing flag methods), `di/profile_data_module.dart` (`settingsRepositoryProvider`).

**Tests** (`test/auth/data/repository/`, `test/profile/data/repository/`, 12 tests total): session tests reuse step 05's `local_store_test.dart` temp-dir + mock-`SharedPreferences` scaffolding, `FakeLatencySimulator`, and the real `MockJsonLoader` against the bundled `assets/mock/user.json`; the "restart" case closes Hive and rebuilds a fresh `LocalStore` over the same temp dir/prefs to prove persistence survives a new instance. Settings tests round-trip theme mode and the demo-mode flag against a real `LocalStore`.

**Quality gate:** `flutter analyze` → 0 issues (needed `// ignore_for_file: prefer_initializing_formals` on both impl files, matching `local_store.dart`'s existing precedent, since the private-field constructor params can't be initializing formals without exposing the leading underscore as the external named-arg name); `dart format --set-exit-if-changed .` → clean; `flutter test test/auth/data/ test/profile/data/` → 12/12 green; layer-direction grep (`flutter/` under domain, `data/` under presentation) → both empty.

## Review rounds

#### Round 1 — 2026-09-28
- **Shown:** both repository impls, both DI modules, 12/12 test results, quality-gate output, and the `DemoModeController` design note below.
- **User feedback:** "approve"
- **Changes made:** none requested.
- **Outcome:** Approved.

## Key decisions worth flagging to a reviewer

- **`DemoModeController` is not injected into `SettingsRepositoryImpl`**, despite the step file's literal wording ("delegates to `DemoModeController`"). Verified by grep that `DemoModeController`'s API (`armNextWriteError`, `consumeArmedError`, `trackingSpeed`, `resetRequests`, `requestReset`, `dispose`) has no boolean "demo mode enabled" state, and no code anywhere treats it as one. `LocalStore.getDemoModeEnabled`/`setDemoModeEnabled` is the sole source of truth for the persisted flag; `SettingsRepositoryImpl` talks to `LocalStore` only. If a later presentation step wants toggling demo mode off to also reset runtime state (armed errors, tracking speed), that's view-model orchestration across `settingsRepositoryProvider` and `demoModeControllerProvider` independently — not this repository's job.
- **`logout()` clears the cached user JSON, not just the session flag** — "neutral logout" (PRD 04 S25) means don't wipe *unrelated* app data (garage, bookings), not "leave a stale identity cached after logout." Both the flag and the cached user live in the same `"session"` box/key pair, so clearing both stays inside that one concept.
- **This is the first feature-level `data/di/` folder** — `lib/auth/data/di/auth_data_module.dart` and `lib/profile/data/di/profile_data_module.dart` set the one-provider-per-repository precedent (plain `Provider<T>`, interface-typed, chained off `core_data_module.dart`) that steps 07–09 are expected to mirror.
- **No `model/`/`mapper/` folders in either feature** — per the locked skip-DTOs decision, since neither repo has a real JSON/HTTP boundary to map from; the tiny `User` JSON shape is handled by private `_userToJson`/`_userFromJson` helpers directly in `session_repository_impl.dart`, not a DTO class.
- **Repo-impl tests target the real `LocalStore`**, not a fake — `LocalStore` has no interface today, and introducing one was out of scope; testing against the real thing is also what actually proves the "survives a fresh `LocalStore` instance" requirement rather than assuming it via a hand-rolled fake.

## Output

- 4 new files: `lib/auth/data/repository/session_repository_impl.dart`, `lib/auth/data/di/auth_data_module.dart`, `lib/profile/data/repository/settings_repository_impl.dart`, `lib/profile/data/di/profile_data_module.dart`.
- 2 new test files (12 tests): `test/auth/data/repository/session_repository_impl_test.dart`, `test/profile/data/repository/settings_repository_impl_test.dart`.
- `docs/plan/mobile-app/06-data-auth-profile.md` checklist, review rounds, and session log filled in; status set to ✅.
- `docs/plan/mobile-app/00-index.md` step 06 tracker row set to ✅.
- This log: `docs/claude-session/apps/07-mobile-step06-data-auth-profile.md`.
- Commit proposed: `016 - Create Auth & Profile Data Layer`.
- Next: step 07 (`garage/data/`, `catalog/data/` — `GarageRepositoryImpl`, `CatalogRepositoryImpl`), the first step with a real multi-field mock-JSON asset to map from.
