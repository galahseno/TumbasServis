# Step 05 — Data-layer core infrastructure

| | |
|---|---|
| **Status** | ✅ Approved |
| **Layer** | Data |
| **Priority** | — |
| **Owns** | `lib/core/data/service/`, `lib/core/data/di/` |
| **PRD refs** | [05 mock infrastructure](../../../prd/05-data-model-mock.md), [07 tech stack](../../../prd/07-architecture-tech.md) |
| **Design refs** | — |
| **Depends on** | Steps 03 (domain interfaces/`Clock` port), 04 (mock JSON files exist) |
| **Claude session** | `docs/claude-session/apps/06-mobile-step05-data-core-infra.md` (written after approval) |

## Goal

Build the shared, cross-feature data-layer services every repository impl (steps 06–09) will depend on: the mock JSON loader, the simulated-latency helper, the local storage wrapper, `DemoModeController`, `TrackingSimulator`, and `SystemClock` (the real `Clock` impl). These are genuinely shared by 2+ features, so they live in `core/data/`, not any one feature.

## Inputs

- `.claude/skills/flutter-data-layer/SKILL.md` (service vs. repository-impl division of labor, local storage & cache pattern).
- `prd/05-data-model-mock.md` → *Mock infrastructure* section (asset loader, simulated latency, error injection, reset, `TrackingSimulator`, local persistence list).
- Step 03's `Clock` port.

## Open questions (ask at kickoff)

1. Local structured storage: `hive_ce` (PRD 07's suggestion) vs. plain JSON files in the app documents directory for garage/bookings/notifications lists. Recommend `hive_ce` (typed boxes, matches PRD 07's "or equivalent") unless the user prefers the simpler JSON-file approach to avoid a second storage lib alongside `shared_preferences`.
2. `simulateLatency()` — fixed range 300–800 ms per PRD 05; confirm it should be **skipped entirely under `flutter test`** (so tests aren't slow) via a `Clock`/env check, or genuinely awaited even in tests (recommend: an injectable `LatencySimulator` with a zero-delay fake for tests).
3. `DemoModeController`'s one-shot error flag and `TrackingSimulator`'s timer both need to be reachable from `profile/presentation` (S26) later — confirm they're plain `core/data/service/` classes wired through DI now, read via `ref.watch`/`ref.read` from `profile` later (no premature profile-feature coupling).

## Scope

### Files / classes to build

`lib/core/data/service/`:
- `mock_json_loader.dart` — `MockJsonLoader`, reads/parses `assets/mock/*.json` once, caches in memory for the session.
- `latency_simulator.dart` — `simulateLatency()` helper (randomized 300–800 ms), injectable/fakeable for tests.
- `local_store.dart` — thin wrapper over `shared_preferences` (session flag, theme mode, demo-mode flag) + the structured store (garage/bookings/draft/notifications read-state).
- `demo_mode_controller.dart` — `DemoModeController`: one-shot error-injection flag (arms/disarms itself after the next mock write), "reset seed" trigger, tracking-speed setting (`Mati`/`15 dtk`/`5 dtk`).
- `tracking_simulator.dart` — `TrackingSimulator`: per-unit timer-driven status advance once checked in, exposed as a `Stream`; manual "Majukan"/"Reset" methods.
- `system_clock.dart` — `SystemClock implements Clock` (`DateTime.now()`).

`lib/core/data/di/core_data_module.dart` — providers for all of the above, interface-typed where applicable (`clockProvider` typed as `Clock`).

### Tests to write

- `test/core/data/service/mock_json_loader_test.dart` — loads and caches each of the 11 mock files (using `flutter test`'s asset bundle), parses without error.
- `test/core/data/service/demo_mode_controller_test.dart` — arms → next call fails once → auto-disarms; reset triggers the expected callback/event.
- `test/core/data/service/tracking_simulator_test.dart` — using a `FakeClock`/`fakeAsync`, verifies the timer advances a unit's status through the machine at the configured speed and stops at `Selesai`.

## Checklist

### Build
- [x] Open questions answered (storage choice, latency-in-tests behavior).
- [x] All 6 core data services + DI module written.
- [x] `core/data/` never imports anything under `*/presentation/`.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test test/core/data/` → green.

### Review gate
- [x] Status 🔵; show the user the service list + test results.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `015 - Create Core Data Infrastructure`.
- [x] Claude session file written (`docs/claude-session/apps/06-mobile-step05-data-core-infra.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Deviations from this doc's literal scope

- `path_provider` added as a new direct `pubspec.yaml` dependency (was only present transitively before) — `LocalStore`'s Hive-backed structured store needs a real on-device directory for `Hive.init(path)`, and nothing in steps 01–04 had pulled it in yet. The directory lookup is injected as a `StorageDirectoryResolver` function (not called directly), so tests supply a temp dir instead of hitting a platform channel.
- `fake_async` added as a new `dev_dependencies` entry (was already present transitively via `flutter_test`'s own deps, now promoted to direct) — needed for `tracking_simulator_test.dart`'s virtual-time control, per this session's kickoff interview.
- `TrackingSimulator`'s internal timer uses chained one-shot `Timer(duration, callback)` calls (rescheduled after every advance) rather than a single long-lived `Timer.periodic` — functionally equivalent wall-clock behavior, but lets the configured speed (`TrackingSpeed`) change take effect on the very next tick instead of only after the current period elapses.
- `DemoModeController.trackingSpeed` is session-only (in-memory), not persisted via `LocalStore` — PRD 07's local-persistence list only names session flag / theme mode / demo-mode flag; tracking speed wasn't in that list, so no new storage key was invented for it. Resets to `detik15` on app restart.
- `_controllers` in `TrackingSimulator` use `StreamController.broadcast(sync: true)` so a watcher listening right after `checkIn()`/`advance()` observes the status change immediately rather than after a microtask — needed for both the tests and a tracking screen that expects the current state to already be in `watch()`'s stream synchronously after check-in.

## Review rounds

#### Round 1 — 2026-09-27
- **Shown:** kickoff interview (4 `AskUserQuestion` rounds: `LocalStore` API shape — generic per-box JSON blob vs. typed per-collection methods; `simulateLatency()` test behavior — injectable fake vs. env-check skip; `DemoModeController` reset propagation — broadcast stream vs. direct repo calls; `TrackingSimulator` scheduling — real `Timer` + `fake_async` vs. manual step-only), all recommended options accepted.
- **Files:** `lib/core/data/service/{mock_json_loader,latency_simulator,local_store,demo_mode_controller,tracking_simulator,system_clock}.dart`, `lib/core/data/di/core_data_module.dart`, `test/core/data/service/{mock_json_loader,local_store,demo_mode_controller,tracking_simulator}_test.dart`, `test/support/fake_latency_simulator.dart`.
- **Test results:** `flutter test test/core/data/` → 12/12 green; full suite `flutter test` → 98/98 green (no regressions in steps 02–04's tests).
- **Quality:** `flutter analyze` → 0 issues; `dart format --set-exit-if-changed .` → clean; `grep -rln "presentation/" lib/core/data/` → empty.
- **User feedback:** "approve"
- **Changes made:** none requested.
- **Outcome:** Approved.

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-27 | Read steps 03/04 (both ✅ approved), PRD 05/07, `.claude/skills/flutter-data-layer/SKILL.md`, existing `lib/core/domain/` (Clock port, Result, UnitStatus, BookingStatusDerivation, AppThemeMode, SettingsRepository), `pubspec.yaml` (confirmed `hive_ce`/`shared_preferences` already present, `path_provider` absent) | Confirmed dependency direction and existing conventions to build on |
| 2026-09-27 | Kickoff interview (4 `AskUserQuestion` rounds: LocalStore API shape, latency-in-tests, reset propagation, TrackingSimulator scheduling) | All 4 open questions resolved, all recommended options accepted |
| 2026-09-27 | Implemented 6 core data services + `core_data_module.dart`; added `path_provider` (dependency) and `fake_async` (dev dependency) to `pubspec.yaml`; wrote 4 test files + 1 test support fake | `flutter analyze` 0 issues, `dart format` clean, `flutter test test/core/data/` 12/12 green, full suite 98/98 green |
