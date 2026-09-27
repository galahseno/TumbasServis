# Step 03 — Repository interfaces & domain business rules

| | |
|---|---|
| **Status** | ✅ Approved |
| **Layer** | Domain |
| **Priority** | — |
| **Owns** | `lib/core/domain/repository/` (10 interfaces), `lib/core/domain/service/` (`Clock` port + 7 business-rule services) |
| **PRD refs** | [05 repository interfaces table](../../../prd/05-data-model-mock.md), [03 business rules](../../../prd/03-user-flows.md), [07 quality gates](../../../prd/07-architecture-tech.md) |
| **Design refs** | — (no visual review) |
| **Depends on** | Step 02 |
| **Claude session** | `docs/claude-session/apps/04-mobile-step03-domain-rules-repositories.md` (written after approval) |

## Goal

Declare every repository as an interface (the ports), and implement the business rules that must be true regardless of UI or transport as domain services with full unit-test coverage — this is the PRD 07 "quality gates" unit-test list, done here rather than deferred. No repository *implementation* is written in this step (that starts in step 06).

## Inputs

- `.claude/skills/flutter-domain-layer/SKILL.md` (interface design guidance, "no use cases" rule, business-logic placement test).
- `prd/05-data-model-mock.md` → *Repository interfaces (domain language)* table (10 interfaces, representative methods).
- `prd/03-user-flows.md` → *Business rules (→ domain layer)* section: vehicle selection, per-unit service config, pricing/duration (makespan), scheduling/capacity, promo/voucher, forms/gates, identifiers/status.
- `prd/07-architecture-tech.md` → *Quality gates* unit-test list (pricing/discount math, fleet-duration makespan, per-unit validation, "Salin dari" compatibility filtering, slot-capacity checks, voucher eligibility, booking/unit status derivation).

## Open questions (ask at kickoff)

1. `Clock` port shape — `abstract class Clock { DateTime now(); }` with a `FakeClock` in `test/`, confirm this is the right level (vs. injecting `DateTime.now` closures per-call).
2. Domain-service granularity — one class per rule (as listed) vs. folding closely related rules together (e.g. `SlotCapacityService` + `FleetDurationCalculator` both operate on workshop bays/slots)? Recommend keeping them separate (single responsibility, matches the PRD's own rule-by-rule phrasing) unless a natural overlap emerges while writing tests.
3. Are these domain services plain static-method utility classes, or do they need to be DI-provided (for a future fake-swap in widget tests)? Recommend small stateless classes with a no-arg constructor, instantiated directly by ViewModels in step 12+ (no DI needed — they hold no state, per the skill's "extract a domain service, call it from the ViewModel" guidance) except `Clock`, which is DI-provided everywhere so tests can override it.

## Scope

### Files / classes to build

`lib/core/domain/repository/`: `session_repository.dart`, `settings_repository.dart`, `garage_repository.dart`, `catalog_repository.dart`, `workshop_repository.dart`, `booking_repository.dart`, `tracking_repository.dart`, `invoice_repository.dart`, `review_repository.dart`, `notification_repository.dart` — method signatures per the `00-index.md` *Repository-interface method skeleton* table, all returning `Result<T>` / `Stream<T>`.

`lib/core/domain/service/`:
- `clock.dart` — `Clock` port.
- `pricing_calculator.dart` — per-unit subtotal, fleet subtotal, voucher discount, total (PRD 03 "Pricing & duration").
- `fleet_duration_calculator.dart` — shared-slot makespan across N bays; split-mode per-unit duration.
- `unit_config_validator.dart` — ≥1 service per unit; complaint required when `requiresComplaint`; 250-char cap.
- `salin_dari_compatibility_filter.dart` — copy services + compatible parts, report dropped incompatible parts.
- `slot_capacity_service.dart` — shared-mode capacity check; split-mode remaining-after-siblings; chip-state precedence (`short > limited > available > full`); D+0 "Lewat" cutoff via `Clock`.
- `voucher_eligibility_service.dart` — `minUnits`/`minSubtotal`/`validUntil` checks + shortfall message ("kurang Rp…").
- `booking_status_derivation.dart` — unit status machine transitions (forward-only + cancel branch) and the derived `BookingStatus` from a list of units.

### Tests to write

One test file per service in `test/core/domain/service/`, covering the PRD 07 quality-gate scenarios verbatim:
- `pricing_calculator_test.dart` — the canonical 3-unit booking (Rp85.000/Rp143.000/Rp200.000 → Rp428.000 subtotal → 10% voucher → Rp385.200 total) from the design plan's canonical demo content, plus a no-voucher and a single-unit case.
- `fleet_duration_calculator_test.dart` — 3 units × 60 min on 2 bays → ~120 min makespan (not 180); split-mode → per-unit duration only.
- `unit_config_validator_test.dart` — 0 services → invalid; `requiresComplaint` service + empty note → invalid; 251-char note → invalid.
- `salin_dari_compatibility_filter_test.dart` — copies compatible parts, drops+reports an incompatible one, never copies the complaint note.
- `slot_capacity_service_test.dart` — shared capacity < unit count → disabled with reason; split sibling-conflict (3rd unit can't take the last seat another sibling already took); D+0 before now+2h → `Lewat`.
- `voucher_eligibility_service_test.dart` — each of the 4 canonical vouchers against the 3-unit and 1-unit booking (matches the design plan's voucher table exactly).
- `booking_status_derivation_test.dart` — every PRD 03 derivation rule (`Terjadwal` while any unit not checked in; `Berlangsung` while any unit mid-flow; `Selesai` once all `Selesai`/mixed with `Dibatalkan`; `Dibatalkan` only if *all* cancelled).

## Checklist

### Build
- [x] Open questions answered.
- [x] 10 repository interfaces written, method signatures match `00-index.md`'s skeleton table.
- [x] `Clock` port + 7 domain services written.
- [x] No `package:flutter/`, no riverpod, no storage import anywhere under `core/domain/`.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test test/core/domain/` → green, every PRD 07 quality-gate scenario present and passing.
- [x] `grep -rln 'package:flutter/' lib/core/domain/` → empty.

### Review gate
- [x] Status 🔵; show the user the interface list, the service list, and the test results (scenario-by-scenario).
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `013 - Create Domain Repositories & Business Rules`.
- [x] Claude session file written (`docs/claude-session/apps/04-mobile-step03-domain-rules-repositories.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Deviations from this doc's literal scope

- `settings/app_theme_mode.dart` added (new `AppThemeMode` enum) — `SettingsRepository.getThemeMode/setThemeMode` needs a domain-owned theme type since Flutter's `ThemeMode` can't be imported under `domain/`; step 02's `model/` was already approved so this was scoped into `repository/settings/` instead of reopening it.
- Both `repository/` and `service/` got concept subfolders (`session/`, `settings/`, …; `pricing_duration/`, `unit_config/`, `scheduling/`, `voucher/`, `status/`), matching step 02's "Grouping folders" convention, rather than flat directories as the doc's file list literally reads.
- `TrackingRepository.watchUnitStatus` returns `Stream<BookingUnit>` (richer entity — history/mechanic/timestamps), not a bare `UnitStatus` stream — the 00-index skeleton table didn't specify a return type.
- `VoucherEligibilityService.shortfallMessage` returns the full Indonesian string (hand-rolled Rp thousands-formatter lives in domain) rather than deferring string composition to presentation.
- `BookingStatusDerivation`'s precedence when unit statuses mix (`Dibatalkan` > `Selesai` > `Berlangsung` > `Terjadwal`) is this step's own interpretation — PRD 03 states the four rules but not an explicit priority order.
- `SettingsRepository.setDemoMode(bool enabled)` scoped to a simple on/off flag; speed + error-injection stay with `DemoModeController` (step 05).
- `test/support/fake_clock.dart` introduced as a new shared-fixture location (first cross-file test fixture in the repo; prior tests mirror `lib/` 1:1).

All of the above were raised and resolved with the user in the kickoff interview before implementation (see Review rounds).

## Review rounds

#### Round 1 — 2026-09-27
- **Shown:** kickoff interview covering the doc's 3 open questions (`Clock` shape, service granularity, DI vs static) plus 4 design ambiguities surfaced while reading PRD text against the actual step-02 entities (`AppThemeMode` placement, `BookingStatusDerivation` precedence, voucher message string-vs-ints, tracking stream richness); then the full interface list, service list, and `flutter test` scenario-by-scenario output.
- **User feedback:** accepted every recommended option in both interview rounds; "aprrove i commit manually, do rest."
- **Changes made:** none requested — plan and implementation approved as presented.
- **Outcome:** Approved.

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-27 | Explored `00-index.md` skeleton table, PRD 05/03/07, `flutter-domain-layer` skill, step02 entity state | Confirmed step03 was a clean start, gathered exact business-rule wording and canonical demo numbers |
| 2026-09-27 | Kickoff interview round 1 (`AskUserQuestion`) | Clock = abstract-class port + DI; 7 services stay separate; services stateless/no-DI; both `repository/` and `service/` get concept subfolders |
| 2026-09-27 | Plan-agent design pass over real entity fields (`Motor`, `Part`, `Voucher`, `TimeSlot`, `UnitStatus`, etc.) | Exact signatures/APIs drafted; 9 risks/ambiguities flagged |
| 2026-09-27 | Kickoff interview round 2 (`AskUserQuestion`) | `AppThemeMode` in `repository/settings/`; status-derivation precedence accepted; voucher message returns full string; tracking stream is `Stream<BookingUnit>` |
| 2026-09-27 | Wrote 10 repository interfaces + `Clock` + 7 domain services + `FakeClock` fixture | All files created per plan |
| 2026-09-27 | Wrote 7 test files (35 new tests) covering every PRD 07 quality-gate scenario with canonical numbers | `flutter test test/core/domain/` → 86/86 passed (51 step02 + 35 new) |
| 2026-09-27 | `flutter analyze`, `dart format --set-exit-if-changed .`, `grep -rln 'package:flutter/' lib/core/domain/` | 0 issues; clean; empty (purity confirmed) |
| 2026-09-27 | Shown review gate; user approved, will commit manually | Step closed |
