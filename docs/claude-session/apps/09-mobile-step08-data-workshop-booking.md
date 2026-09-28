# Claude Session Log — 09: Mobile-app step 08 — Data layer: Workshop & Booking

**Tool:** Claude Code, model Sonnet 5
**Date:** 2026-09-28
**Topic:** `WorkshopRepositoryImpl` (slot availability with capacity) + `BookingRepositoryImpl` (`BookingDraft` lifecycle, confirm/cancel/reschedule)

## Initial prompt

"i want to do docs/plan/mobile-app/08-xx, interview me with detail if need"

## Research performed

Two parallel Explore agents: one read `prd/05-data-model-mock.md`, `prd/03-user-flows.md` (F2/F6), and `docs/plan/design/09-s15-jadwal.md` for the canonical S15 slot table, the Rp385.200 3-unit pricing breakdown, and the `TS-YYMMDD-NNNN` code format; the other read the existing domain contracts (`WorkshopRepository`, `BookingRepository`, entities, `Result`, `Clock`/`SlotCapacityService`/`FleetDurationCalculator`/`PricingCalculator`), the Catalog/Garage data-layer pattern from step 07 (inline json mapping, `LocalStore` seed-once, Riverpod DI), mock assets, and test conventions (`FakeClock`, `FakeLatencySimulator`, real `LocalStore` + temp Hive dir).

## Clarifying interview (AskUserQuestion rounds → answers)

Round 1 — 4 questions (the doc's 3 original open questions, plus a new one surfaced by reading the code):
1. Slot generation strategy → **canonical hardcode (`ws_001`/2026-09-29) + seeded pseudo-random for other dates**.
2. Live capacity overlay (do real bookings affect `getAvailableSlots`?) → **yes, overlay real bookings on the baseline**.
3. Booking code generation location → **repository impl, via a persisted per-day counter**.
4. `GarageRepositoryImpl.hasActiveBooking` stub rewiring → **yes, rewire it in this step**.

A Plan agent then designed the concrete implementation, surfacing two more things: a research correction (the canonical workshop is `ws_001` "Bengkel Jaya Motor", not `ws_003` as the doc said — a stale PRD placeholder) and a real domain gap (`Booking` had no field for split-mode per-unit slots).

Round 2 — 2 questions:
1. Add `Booking.unitSlots` field now (closing the split-mode gap) vs. defer → **add it now**.
2. `GarageRepositoryImpl.hasActiveBooking` fail-closed vs. fail-open on a fetch error → **fail-closed**.

User picked the recommended option on all six questions across both rounds.

## Execution (files written, tests added/passing)

- `lib/core/domain/model/booking/booking.dart` — added `Map<String, TimeSlot>? unitSlots` field (additive/nullable); regenerated `booking.freezed.dart` via `build_runner`.
- `lib/core/data/service/slot_occupancy_calculator.dart` — new shared helper: `baselineBooked` (canonical hardcode for `ws_001`/2026-09-29, else a deterministic hash of `workshopId|date|hour`), `overlayBooked` (live count of active `BookingUnit`s from the `bookings` LocalStore box, shared- and split-mode aware, excluding `dibatalkan`), `bookedCount` (sum). Used by both repos directly (no DI provider) to avoid a Workshop↔Booking provider cycle.
- `lib/workshop/data/repository/workshop_repository_impl.dart` + `di/workshop_data_module.dart` — `getWorkshops({openNowOnly})` (sorted by distance), `getWorkshop(id)`, `getAvailableSlots` (9-hour grid, capacity 5, via the shared calculator).
- `lib/booking/data/repository/booking_repository_impl.dart` + `di/booking_data_module.dart` — `createDraft()` (idempotent get-or-create, single fixed key), `updateDraft`, `confirmBooking` (capacity re-validation at write time, resolves user/services/parts/motors/voucher, builds `BookingUnit`s, generates the code via a per-day counter keyed by the slot's date, clears the draft), `getBookings`/`getBooking`, `cancelBooking` (whole or per-unit, recomputes pricing/voucher/status), `rescheduleBooking` (guards non-`terjadwal` units, re-validates capacity).
- `lib/garage/data/di/garage_data_module.dart` — `hasActiveBooking` rewired to a real check against `bookingRepositoryProvider`, fail-closed on error.
- Fixed a Riverpod top-level type-inference cycle (`bookingRepositoryProvider` ↔ `garageRepositoryProvider`, since each now imports the other's module) by adding explicit `Provider<T>` type annotations to both declarations.
- `test/core/data/service/slot_occupancy_calculator_test.dart`, `test/workshop/data/repository/workshop_repository_impl_test.dart`, `test/booking/data/repository/booking_repository_impl_test.dart` — 31 new tests.
- Full suite: 154/154 passing; `flutter analyze` 0 issues; `dart format --set-exit-if-changed .` clean. Canonical numbers verified exactly: slot table `1·1·3·4·5·2·3·1·5` (ws_001/2026-09-29), booking total Rp385.200 (subtotal 428.000, DISKON10 −42.800), code `TS-260929-0417`.

## Review rounds (user feedback → changes → approval)

Round 1 — shown both impls, both DI modules, the shared calculator, the garage rewiring, the domain amendment, and all test results. User replied "approve" with no changes requested.

## Key decisions worth flagging to a reviewer

- The canonical demo workshop is `ws_001`, not `ws_003` — the plan doc's own inputs section had a stale reference; corrected during research and confirmed against `workshops.json`, `bookings_seed.json`, and the S13/S15 design docs, all of which agree on `ws_001`.
- `Booking.unitSlots` is a genuinely new domain-layer field added mid-step (not scope creep) — split-mode bookings are P0 and had nowhere to persist each unit's own slot before this.
- `WorkshopRepositoryImpl` and `BookingRepositoryImpl` never import each other; they share `SlotOccupancyCalculator` (a `const`-constructible, DI-free helper) instead, specifically to avoid a provider cycle. `BookingRepositoryImpl` does depend on `CatalogRepository`/`GarageRepository`/`SessionRepository` directly (no cycle risk there — none of those three watch `bookingRepositoryProvider` during their own construction).
- `BookingRepository` still has no `deleteDraft()`/`getDraft()` — flagged for whichever step builds Home's "Hapus draft" action.
- S26 "Reset semua data" must also clear the new `booking_code_counters` LocalStore box, or replaying the canonical demo after a reset would produce `TS-260929-0418` instead of `...-0417`.

## Output (files touched, next step)

Files touched: `lib/core/domain/model/booking/booking.dart`, `lib/core/domain/model/booking/booking.freezed.dart`, `lib/core/data/service/slot_occupancy_calculator.dart`, `lib/workshop/data/repository/workshop_repository_impl.dart`, `lib/workshop/data/di/workshop_data_module.dart`, `lib/booking/data/repository/booking_repository_impl.dart`, `lib/booking/data/di/booking_data_module.dart`, `lib/garage/data/di/garage_data_module.dart`, `test/core/data/service/slot_occupancy_calculator_test.dart`, `test/workshop/data/repository/workshop_repository_impl_test.dart`, `test/booking/data/repository/booking_repository_impl_test.dart`, `docs/plan/mobile-app/08-data-workshop-booking.md`, `docs/plan/mobile-app/00-index.md`.

Next step: **09** — the next unbuilt step in `00-index.md` (presentation layer work now has a complete data-layer foundation for workshop/booking, garage, catalog, auth/profile, and core infra).
