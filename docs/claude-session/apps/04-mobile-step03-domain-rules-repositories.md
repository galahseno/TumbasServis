# Claude Session Log — 04: Mobile-app step 03 — Repository interfaces & domain business rules

**Tool:** Claude Code (CLI agent), model Sonnet 5
**Date:** 2026-09-27
**Topic:** Declare all 10 repository interfaces and implement `Clock` + 7 business-rule domain services with full unit-test coverage, per `docs/plan/mobile-app/03-domain-rules-repositories.md`.

## Initial prompt

> i want to do docs/plan/mobile-app/03-xx, interviewme with detail if need

## Research performed

1. Read `docs/plan/mobile-app/03-domain-rules-repositories.md` in full (goal, inputs, open questions, scope, checklist).
2. Read `00-index.md`'s "Repository-interface method skeleton" table (all 10 interfaces) and "Domain services" table (`Clock` + 7 services); confirmed step 02 approved and step 03 a clean start (`repository/`/`service/` didn't exist yet).
3. Read `prd/05-data-model-mock.md`'s repository table (one extra detail: `getAvailableSlots` returns per-hour `booked`/`capacity`).
4. Read `prd/03-user-flows.md`'s "Business rules (→ domain layer)" section in full — vehicle selection, per-unit config, pricing/duration (makespan), scheduling/capacity, promo/voucher, forms/gates, identifiers/status — plus the canonical demo numbers (3-unit booking Rp85.000/Rp143.000/Rp200.000 → Rp428.000 → DISKON10 → Rp385.200; voucher table; 5-unit stress case).
5. Read `prd/07-architecture-tech.md`'s "Quality gates" unit-test list.
6. Read `.claude/skills/flutter-domain-layer/SKILL.md` — purity constraint, repository-interface shape, "no use cases" rule, business-logic placement test.
7. Read every step-02 entity file directly (`Motor`, `MotorModel`, `Part`, `ServiceType`, `Voucher`, `Workshop`, `TimeSlot`, `BookingDraft`/`UnitConfig`, `BookingUnit`, `Booking`, `UnitStatus`, `BookingStatus`, `Invoice`, `Review`, `User`, `AppNotification`, `Result`) to get exact field names/types before drafting signatures.

## Clarifying interview (2 rounds, `AskUserQuestion`)

**Round 1 — the step doc's own 3 open questions + folder layout:**

| Question | Answer |
|---|---|
| `Clock` port shape | `abstract class Clock { DateTime now(); }`, DI-provided everywhere |
| 7 domain services: fold related ones or keep separate | Keep all 7 separate |
| Domain services: static/stateless or DI-provided | Plain stateless classes, no DI (except `Clock`) |
| `repository/`/`service/` layout | Subfolder both by concept |

**Round 2 — 4 design ambiguities a Plan-agent design pass surfaced while reading real entity fields against the PRD:**

| Question | Answer |
|---|---|
| Where does the new `AppThemeMode` enum live (step02's `model/` is locked) | New file in `repository/settings/app_theme_mode.dart` |
| `BookingStatusDerivation` precedence for mixed unit statuses | Accept proposed precedence (`Dibatalkan` > `Selesai` > `Berlangsung` > `Terjadwal`) |
| `VoucherEligibilityService.shortfallMessage`: full string in domain, or ints only | Domain returns the full string |
| `TrackingRepository.watchUnitStatus` return type | `Stream<BookingUnit>` (richer entity) |

## Execution

**Repository interfaces** (`lib/core/domain/repository/`, one concept subfolder each): `session/session_repository.dart`, `settings/settings_repository.dart` + `settings/app_theme_mode.dart` (new enum), `garage/garage_repository.dart`, `catalog/catalog_repository.dart`, `workshop/workshop_repository.dart`, `booking/booking_repository.dart`, `tracking/tracking_repository.dart`, `invoice/invoice_repository.dart`, `review/review_repository.dart`, `notification/notification_repository.dart`. All abstract classes, `Future<Result<T>>`/`Stream<T>` returns, domain-typed params only, method names matching `00-index.md`'s skeleton table.

**Domain services** (`lib/core/domain/service/`, grouped by PRD business-rule subsection): `clock.dart`; `pricing_duration/pricing_calculator.dart` + `fleet_duration_calculator.dart` (greedy LPT list-scheduling for fleet makespan); `unit_config/unit_config_validator.dart` + `salin_dari_compatibility_filter.dart`; `scheduling/slot_capacity_service.dart` (chip precedence `lewat > full > short > limited > available`); `voucher/voucher_eligibility_service.dart` (hand-rolled Rp thousands-formatter); `status/booking_status_derivation.dart`.

**Test fixture:** `test/support/fake_clock.dart` (new shared-fixture convention — prior tests mirror `lib/` 1:1, this is the first cross-file fixture).

**Tests written** (`test/core/domain/service/`, 35 new tests): one file per service, covering every PRD 07 quality-gate scenario with the canonical numbers verbatim — 3-unit booking pricing/discount math, 120-min fleet makespan (not the naive 180), unit-config validation edge cases, Salin-dari compatibility filtering (compatible/incompatible/complaint-note-never-copied), slot-capacity chip states across the canonical day table + D+0 cutoff, all 4 canonical vouchers × 3-unit/1-unit bookings with exact shortfall message strings, every booking-status derivation rule.

**Quality gate:** `flutter analyze` → 0 issues; `dart format --set-exit-if-changed .` → clean (auto-fixed on run); `flutter test test/core/domain/` → 86/86 passed (51 step02 + 35 new); `grep -rln 'package:flutter/' lib/core/domain/` → empty.

## Review rounds

#### Round 1 — 2026-09-27
- **Shown:** kickoff interview (2 rounds, above), then the full interface list, service list, and `flutter test` scenario-by-scenario output.
- **User feedback:** accepted every recommended option in both interview rounds; "aprrove i commit manually, do rest."
- **Changes made:** none requested.
- **Outcome:** Approved.

## Key decisions worth flagging to a reviewer

- **`AppThemeMode` is a new enum**, not in step02's original scope — added because `SettingsRepository` needs a domain-owned theme type and Flutter's `ThemeMode` can't cross the purity boundary. Scoped into `repository/settings/` rather than reopening the approved `model/` folder.
- **`BookingStatusDerivation`'s mixed-status precedence is an interpretation**, not verbatim PRD text — PRD 03 states 4 rules without an explicit priority order for a fleet mixing terminal and non-terminal units.
- **`VoucherEligibilityService.shortfallMessage` bakes Indonesian copy + a hand-rolled Rp formatter into the domain layer** — a deliberate purity trade-off, matching the step doc's literal ask and the canonical test strings exactly, over the alternative of returning only ints and deferring string composition to presentation.
- **`TrackingRepository.watchUnitStatus` returns `Stream<BookingUnit>`**, not a bare status enum — richer than the 00-index skeleton table's literal (unspecified) return type, to carry history/mechanic/timestamps for later tracking screens (S20/S21).
- **`repository/` and `service/` both got concept subfolders** even though several (e.g. `repository/session/`) hold only one file — chosen for consistency with step02's `model/` convention and to keep 1:1 greppability against the skeleton table, at the cost of some folder-count overhead.

## Output

- 10 repository interfaces + `Clock` port + 7 domain services in `lib/core/domain/`, no data/presentation coupling.
- 35 new tests (86/86 total in `test/core/domain/`), `flutter analyze`/`format` clean, domain-purity grep empty.
- `docs/plan/mobile-app/03-domain-rules-repositories.md` checklist, deviations, review rounds, and session log filled in; status set to ✅.
- `docs/plan/mobile-app/00-index.md` step 03 tracker row set to ✅.
- This log: `docs/claude-session/apps/04-mobile-step03-domain-rules-repositories.md`.
- Commit proposed (user commits manually): `013 - Create Domain Repositories & Business Rules`.
- Next: step 04.
