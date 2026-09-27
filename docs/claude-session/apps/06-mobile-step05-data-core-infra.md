# Claude Session Log — 06: Mobile-app step 05 — Data-layer core infrastructure

**Tool:** Claude Code (CLI agent), model Sonnet 5
**Date:** 2026-09-27
**Topic:** Build the shared `core/data/` services every feature repository impl (steps 06–09) will depend on — mock JSON loading, simulated latency, local persistence, demo-mode control, tracking simulation, and the real `Clock` — per `docs/plan/mobile-app/05-data-core-infra.md`.

## Initial prompt

> i want to do docs/plan/mobile-app/05-xx, interviewme with detail if need

## Research performed

1. Read `docs/plan/mobile-app/05-data-core-infra.md` in full (goal, inputs, open questions, scope, checklist), and steps 03/04 (both ✅ approved) to confirm dependencies were satisfied.
2. Read `prd/05-data-model-mock.md`'s *Mock infrastructure* section and `prd/07-architecture-tech.md`'s feature map / tech stack / quality gates.
3. Read `.claude/skills/flutter-data-layer/SKILL.md` for the service-vs-repository division of labor and local-storage/cache pattern.
4. Read existing `lib/core/domain/` on disk: `Clock` port, `Result<T>`, `UnitStatus` (forward-order + `canTransitionTo`), `BookingStatusDerivation`, `AppThemeMode`, `SettingsRepository` — to match the exact types/enums the new services need to produce or consume.
5. Read `pubspec.yaml` — confirmed `hive_ce`/`shared_preferences` were already added at scaffold time (no new storage-lib decision needed), but `path_provider` was absent (only pulled in transitively).
6. Inspected the installed `hive_ce` package source (`Hive.init(path)` / `Hive.openBox<E>(name)` signatures) to confirm the wrapper design was buildable without `hive_ce_flutter`.

## Clarifying interview (4 rounds, `AskUserQuestion`)

| Question | Answer |
|---|---|
| `LocalStore` structured-store API shape | Generic per-box JSON blob API (`getAll/get/put/delete/clear`), not typed per-collection methods — keeps `core/data` ignorant of feature DTOs |
| `simulateLatency()` behavior under `flutter test` | Injectable `LatencySimulator` interface; real impl randomizes 300–800ms, a `FakeLatencySimulator` (zero delay) overrides via DI in tests |
| `DemoModeController` "Reset semua data" propagation | Broadcast `Stream<void> resetRequests`; step 05 only emits the signal, feature repos (steps 06–09) subscribe and restore their own seed data |
| `TrackingSimulator` scheduling | Real `dart:async Timer`, tested with `package:fake_async` (new dev dependency) |

All 4 questions answered with the recommended option.

## Execution

**`lib/core/data/service/`** (6 files): `mock_json_loader.dart` (`MockJsonLoader`, caches decoded `assets/mock/*.json` per filename), `latency_simulator.dart` (`LatencySimulator` interface + `RandomLatencySimulator`), `local_store.dart` (`LocalStore`: shared_preferences flags + generic hive_ce JSON-blob box wrapper), `demo_mode_controller.dart` (`DemoModeController`: one-shot error flag, `TrackingSpeed` setting, reset broadcast stream), `tracking_simulator.dart` (`TrackingSimulator`: per-unit status stream, chained one-shot `Timer` advance, manual advance/reset), `system_clock.dart` (`SystemClock implements Clock`).

**`lib/core/data/di/core_data_module.dart`** (new): one `Provider` per service, `latencySimulatorProvider`/`clockProvider` interface-typed; `sharedPreferencesProvider` is a placeholder `Provider` that throws until a future `bootstrap.dart` overrides it with an awaited `SharedPreferences.getInstance()`.

**`pubspec.yaml`**: added `path_provider` (dependency, for `LocalStore`'s Hive directory) and `fake_async` (dev dependency, for `tracking_simulator_test.dart`).

**Tests** (`test/core/data/service/`, 4 files, 12 tests) + `test/support/fake_latency_simulator.dart`: `mock_json_loader_test.dart` (loads/caches all 11 mock files), `local_store_test.dart` (shared_prefs + hive round-trips, using a temp dir resolver — no platform channel needed), `demo_mode_controller_test.dart` (arm/consume-once, reset broadcast), `tracking_simulator_test.dart` (using `fake_async`: check-in advances to `selesai` at the configured speed, manual advance/reset bypass the timer, switching to `mati` stops auto-advance).

**Quality gate:** `flutter analyze` → 0 issues; `dart format --set-exit-if-changed .` → clean; `flutter test test/core/data/` → 12/12 green; full suite `flutter test` → 98/98 green (no regressions); `grep -rln "presentation/" lib/core/data/` → empty.

## Review rounds

#### Round 1 — 2026-09-27
- **Shown:** kickoff interview (4 `AskUserQuestion` rounds), then the service list, file list, and full test/analyze/format results.
- **User feedback:** "approve"
- **Changes made:** none requested.
- **Outcome:** Approved.

## Key decisions worth flagging to a reviewer

- **`path_provider` and `fake_async` promoted to direct dependencies** — both existed only transitively before this step; `path_provider` backs `LocalStore`'s Hive directory lookup (injected as a `StorageDirectoryResolver` function so tests avoid the platform channel entirely), `fake_async` drives `TrackingSimulator`'s virtual-time tests.
- **`TrackingSimulator` uses chained one-shot `Timer` calls, not `Timer.periodic`** — same wall-clock guarantee, but a `TrackingSpeed` change takes effect on the very next tick instead of waiting out the current period.
- **`DemoModeController.trackingSpeed` is in-memory only**, not persisted — PRD 07's local-persistence list names only session flag / theme mode / demo-mode flag; no new storage key was invented for it.
- **`TrackingSimulator`'s per-unit `StreamController`s are `sync: true`** — a watcher listening right after `checkIn()`/`advance()` sees the new status immediately, not after a microtask; deliberate for both the tests and a future tracking screen.
- **`DemoModeController.resetRequests` is a pure signal** — step 05 never touches feature local storage; each feature repository impl (steps 06–09, not yet built) is responsible for subscribing and restoring its own seed data from `assets/mock/*.json`.

## Output

- 6 new files in `lib/core/data/service/`, 1 new `lib/core/data/di/core_data_module.dart`, `pubspec.yaml` gains `path_provider` + `fake_async`.
- 4 new test files (12 tests) + 1 test support fake under `test/core/data/service/` and `test/support/`.
- `docs/plan/mobile-app/05-data-core-infra.md` checklist, deviations, review rounds, and session log filled in; status set to ✅.
- `docs/plan/mobile-app/00-index.md` step 05 tracker row set to ✅.
- This log: `docs/claude-session/apps/06-mobile-step05-data-core-infra.md`.
- Commit proposed: `015 - Create Core Data Infrastructure`.
- Next: step 06 (first feature repository impl — likely session/settings, garage, or catalog per `00-index.md`'s sequence).
