# Step 05 — Data-layer core infrastructure

| | |
|---|---|
| **Status** | ⬜ Not started |
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
- [ ] Open questions answered (storage choice, latency-in-tests behavior).
- [ ] All 6 core data services + DI module written.
- [ ] `core/data/` never imports anything under `*/presentation/`.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test test/core/data/` → green.

### Review gate
- [ ] Status 🔵; show the user the service list + test results.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `015 - Create Core Data Infrastructure`.
- [ ] Claude session file written (`docs/claude-session/apps/06-mobile-step05-data-core-infra.md`).
- [ ] Tracker in `00-index.md` set to ✅.

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
