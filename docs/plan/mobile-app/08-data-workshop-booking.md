# Step 08 — Data layer: Workshop & Booking

| | |
|---|---|
| **Status** | ✅ |
| **Layer** | Data |
| **Priority** | — |
| **Owns** | `workshop/data/` (`WorkshopRepositoryImpl`), `booking/data/` (`BookingRepositoryImpl`) |
| **PRD refs** | [05](../../../prd/05-data-model-mock.md), [03 F2 booking flow, F6 cancel/modify](../../../prd/03-user-flows.md) |
| **Design refs** | — |
| **Depends on** | Steps 03, 04, 05, 07 (catalog, for service/part lookups the booking draft needs) |
| **Claude session** | `docs/claude-session/apps/09-mobile-step08-data-workshop-booking.md` (written after approval) |

## Goal

Implement the two data-heaviest repositories: workshop (list/detail/slot availability with capacity) and booking (the `BookingDraft` lifecycle, confirm/cancel/reschedule). This is the data-layer backbone of the P0 core challenge flow.

## Inputs

- `.claude/skills/flutter-data-layer/SKILL.md`.
- `prd/03-user-flows.md` F2 (entry points, draft persistence/expiry, exit-dialog rule), F6 (cancel scope choice, reschedule re-validation).
- `prd/05-data-model-mock.md` `WorkshopRepository`/`BookingRepository` method lists, `TimeSlot`/`BookingDraft` field shapes.
- Step 03's `SlotCapacityService`, `FleetDurationCalculator`.

## Open questions (ask at kickoff)

1. `getAvailableSlots(workshopId, date)` mock generation — pre-baked per the design plan's exact S15 demo numbers (booked counts `1·1·3·4·5·2·3·1·5` for the canonical Sel 29 Sep date) vs. a general seeded-random generator for other dates. Recommend: hard-code the canonical date's exact booked counts (so the demo/QA matches the design pixel-for-pixel) and generate plausible pseudo-random counts (capacity 5, seeded by date+workshop) for every other date.
   - **Answered (2026-09-28):** yes, per the recommendation. **Correction found during research:** the canonical demo workshop is `ws_001` "Bengkel Jaya Motor", not `ws_003` as this doc originally said — `ws_003` is a different workshop ("Motor Care Kotagede"); all seed bookings and the S13/S15 design docs agree on `ws_001`. Non-canonical workshop/date pairs use a deterministic hash of `workshopId|date|hour` mod `(capacity+1)`, stable across restarts.
2. `BookingDraft` persistence + 24h expiry — stored via `LocalStore` as a single "current draft" slot (PRD 03: only one draft resumable from Home at a time)? Confirm single-draft-only is correct (matches "Lanjutkan draft" being singular on S05).
   - **Answered (2026-09-28):** confirmed. `createDraft()` is an idempotent get-or-create against a single fixed key (`booking_drafts/current`) — returns the existing draft if unexpired, discards and recreates if expired.
3. `confirmBooking(draft)` — where does booking-code generation (`TS-YYMMDD-NNNN`) live: domain (pure, needs a random/sequence source) or here in the repository impl (has access to `Clock` + a counter)? Recommend: repository impl generates it (needs I/O-adjacent state — a persisted running counter), domain only defines the format/parsing.
   - **Answered (2026-09-28):** repository impl, per the recommendation. A per-day counter is persisted in a new `booking_code_counters` LocalStore box, seeded from the maxima in `bookings_seed.json` plus one deliberate override (`260929 → 416`) so the live canonical confirm flow deterministically produces `TS-260929-0417`.
4. **New, surfaced this session:** slot capacity must reflect real bookings, or the app would let a user double-book a slot they just filled. **Answered:** `getAvailableSlots` overlays the mock baseline with a live count of active (non-`dibatalkan`) real `BookingUnit`s at that workshop/date/hour, computed by a new shared `SlotOccupancyCalculator` (`lib/core/data/service/`) that both repositories call directly — this avoids a `WorkshopRepository`↔`BookingRepository` provider cycle.
5. **New, surfaced this session:** `Booking` had `sharedSlot` but no field for each unit's own slot in a confirmed split-mode booking — nowhere to persist it. **Answered:** added `Map<String, TimeSlot>? unitSlots` (keyed by `unitCode`) to the `Booking` domain entity (additive/nullable, no existing call site broken), regenerated `booking.freezed.dart`.
6. **New, surfaced this session:** `GarageRepositoryImpl.hasActiveBooking` was stubbed `(_) async => false` pending this step. **Answered:** rewired in `garage_data_module.dart` to a real check against `bookingRepositoryProvider`, fail-closed (blocks deletion) on error.

## Scope

### Files / classes to build

*(DTO/mapper folders from the original scaffold below were skipped — inline `_xFromJson`/`_xToJson` methods instead, matching the convention steps 05–07 already settled on. Actual files built are listed after each bullet in italics.)*

`lib/workshop/data/`:
- `model/workshop/response/…`, `model/slot/response/…` DTOs; `mapper/workshop_mapper.dart`. *(skipped — inline mapping)*
- `repository/workshop_repository_impl.dart` — `getWorkshops({filter})` ("Buka sekarang" + sort), `getWorkshop(id)`, `getAvailableSlots(workshopId, date)` (per-hour booked/capacity, using `Clock` for the D+0 cutoff and open/closed-now status). *(built as planned)*
- `di/workshop_data_module.dart`. *(built as planned)*

`lib/booking/data/`:
- `model/draft/cache/…` (local persistence shape for `BookingDraft`), `model/booking/response/…` (seed booking DTO for `bookings_seed.json`). *(skipped — inline mapping)*
- `mapper/booking_draft_mapper.dart`, `mapper/booking_mapper.dart`. *(skipped — inline mapping)*
- `repository/booking_repository_impl.dart` — `createDraft()`, `updateDraft(draft)` (persist, 24h expiry stamp), `confirmBooking(draft)` (generates code, prices via `PricingCalculator`, durations via `FleetDurationCalculator`, persists as a `Booking`, clears the draft), `getBookings({status})`, `getBooking(id)`, `cancelBooking(id, {unitCode?})` (scope choice, releases slot seats, recomputes remaining units/price), `rescheduleBooking(id, newSlots)` (re-validates via `SlotCapacityService`). *(built as planned)*
- `di/booking_data_module.dart`. *(built as planned)*

Also built, not in the original scaffold:
- `lib/core/data/service/slot_occupancy_calculator.dart` — shared baseline+live-overlay slot occupancy, used by both repos to avoid a provider cycle.
- Edited `lib/garage/data/di/garage_data_module.dart` (real `hasActiveBooking` wiring) and `lib/core/domain/model/booking/booking.dart` (added `unitSlots` field).

### Tests to write

- `test/core/data/service/slot_occupancy_calculator_test.dart` — canonical table exactness, baseline determinism, overlay counting (shared/split, `dibatalkan` exclusion).
- `test/workshop/data/repository/workshop_repository_impl_test.dart` — canonical date's exact slot/capacity numbers match the design plan's S15 table; D+0 `Lewat` cutoff via a `FakeClock`; open/closed-now status; live booking increments/decrements occupancy.
- `test/booking/data/repository/booking_repository_impl_test.dart` — draft create→update→confirm round-trip produces the canonical 3-unit booking's exact total (Rp385.200) and code `TS-260929-0417`; draft expires after 24h (`FakeClock`); cancel-whole vs. cancel-one-unit recomputes correctly (incl. voucher drop); reschedule re-validates capacity and is guarded past `terjadwal`.

## Checklist

### Build
- [x] Open questions answered (slot generation strategy, draft-singularity, code-generation home, live capacity overlay, split-mode slot gap, garage wiring).
- [x] Both repository impls + DI modules written. *(DTOs/mappers deliberately skipped — inline json methods instead, per steps 05–07 convention.)*
- [x] `BookingRepositoryImpl` uses `Clock`, `PricingCalculator`, `FleetDurationCalculator`, `SlotCapacityService`, `VoucherEligibilityService`, `BookingStatusDerivation` from `core/domain/service` — no re-implemented business logic.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test test/workshop/data/ test/booking/data/ test/core/data/service/ test/garage/data/` → green (all 154 tests in the full suite pass), canonical numbers verified against the design plan.

### Review gate
- [x] Status 🔵; show the user both impls + test results, especially the canonical-booking total match.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `018 - Create Workshop & Booking Data Layer`.
- [x] Claude session file written (`docs/claude-session/apps/09-mobile-step08-data-workshop-booking.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Review rounds

#### Round 1 — 2026-09-28
- **Shown:** `lib/workshop/data/repository/workshop_repository_impl.dart`, `lib/workshop/data/di/workshop_data_module.dart`, `lib/booking/data/repository/booking_repository_impl.dart`, `lib/booking/data/di/booking_data_module.dart`, `lib/core/data/service/slot_occupancy_calculator.dart`, the `garage_data_module.dart` rewiring, the `Booking.unitSlots` domain amendment, and all 3 new/updated test files (31 new tests) — full suite 154/154 passing; `flutter analyze` 0 issues; `dart format` clean; canonical slot table, Rp385.200 total, and `TS-260929-0417` code all verified exactly.
- **User feedback:** "approve"
- **Changes made:** none requested
- **Outcome:** approved

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-28 | Explored PRD 05/03 F2+F6, design doc `09-s15-jadwal.md`, and the step 03–07 codebase (domain contracts, core services, Catalog/Garage impl patterns, mock assets, `LocalStore`, test conventions) via parallel Explore agents | Full picture of existing contracts and conventions to reuse |
| 2026-09-28 | Kickoff interview (4 questions: slot generation strategy, live capacity overlay, code-gen location, garage wiring) — user picked the recommended option on all four | Decisions locked in, logged above |
| 2026-09-28 | Design phase via a Plan agent — surfaced the `ws_003`→`ws_001` canonical-workshop correction, the `Booking.unitSlots` domain gap, and the Workshop↔Booking provider-cycle risk | Full implementation plan drafted, verified against source files, written to the plan file |
| 2026-09-28 | Follow-up interview (2 questions: add `unitSlots` field now vs. later, garage fail-closed vs. fail-open on error) — user picked the recommended option on both | Plan finalized |
| 2026-09-28 | Implemented: `Booking.unitSlots` field + freezed regen; `SlotOccupancyCalculator`; `WorkshopRepositoryImpl` + DI; `BookingRepositoryImpl` + DI; rewired `garage_data_module.dart` | 5 new/edited lib files |
| 2026-09-28 | Fixed a Riverpod top-level type-inference cycle between `bookingRepositoryProvider`/`garageRepositoryProvider` by adding explicit `Provider<T>` type annotations | `flutter analyze` → 0 issues |
| 2026-09-28 | Wrote `slot_occupancy_calculator_test.dart`, `workshop_repository_impl_test.dart`, `booking_repository_impl_test.dart` (31 new tests); ran `flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test` (full suite) | 0 analyze issues, format clean, 154/154 tests green, canonical numbers (slot table, Rp385.200, `TS-260929-0417`) verified exactly |
| 2026-09-28 | User approved Round 1 | Step closed; commit `018 - Create Workshop & Booking Data Layer` proposed; tracker set to ✅ |
