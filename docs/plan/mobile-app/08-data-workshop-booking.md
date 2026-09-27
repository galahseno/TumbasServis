# Step 08 — Data layer: Workshop & Booking

| | |
|---|---|
| **Status** | ⬜ Not started |
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
2. `BookingDraft` persistence + 24h expiry — stored via `LocalStore` as a single "current draft" slot (PRD 03: only one draft resumable from Home at a time)? Confirm single-draft-only is correct (matches "Lanjutkan draft" being singular on S05).
3. `confirmBooking(draft)` — where does booking-code generation (`TS-YYMMDD-NNNN`) live: domain (pure, needs a random/sequence source) or here in the repository impl (has access to `Clock` + a counter)? Recommend: repository impl generates it (needs I/O-adjacent state — a persisted running counter), domain only defines the format/parsing.

## Scope

### Files / classes to build

`lib/workshop/data/`:
- `model/workshop/response/…`, `model/slot/response/…` DTOs; `mapper/workshop_mapper.dart`.
- `repository/workshop_repository_impl.dart` — `getWorkshops({filter})` ("Buka sekarang" + sort), `getWorkshop(id)`, `getAvailableSlots(workshopId, date)` (per-hour booked/capacity, using `Clock` for the D+0 cutoff and open/closed-now status).
- `di/workshop_data_module.dart`.

`lib/booking/data/`:
- `model/draft/cache/…` (local persistence shape for `BookingDraft`), `model/booking/response/…` (seed booking DTO for `bookings_seed.json`).
- `mapper/booking_draft_mapper.dart`, `mapper/booking_mapper.dart`.
- `repository/booking_repository_impl.dart` — `createDraft()`, `updateDraft(draft)` (persist, 24h expiry stamp), `confirmBooking(draft)` (generates code, prices via `PricingCalculator`, durations via `FleetDurationCalculator`, persists as a `Booking`, clears the draft), `getBookings({status})`, `getBooking(id)`, `cancelBooking(id, {unitCode?})` (scope choice, releases slot seats, recomputes remaining units/price), `rescheduleBooking(id, newSlots)` (re-validates via `SlotCapacityService`).
- `di/booking_data_module.dart`.

### Tests to write

- `test/workshop/data/repository/workshop_repository_impl_test.dart` — canonical date's exact slot/capacity numbers match the design plan's S15 table; D+0 `Lewat` cutoff via a `FakeClock`; open/closed-now status.
- `test/booking/data/repository/booking_repository_impl_test.dart` — draft create→update→confirm round-trip produces the canonical 3-unit booking's exact total (Rp385.200); draft expires after 24h (`FakeClock`); cancel-whole vs. cancel-one-unit recomputes correctly; reschedule re-validates capacity.

## Checklist

### Build
- [ ] Open questions answered (slot generation strategy, draft-singularity, code-generation home).
- [ ] Both repository impls + DTOs + mappers + DI modules written.
- [ ] `BookingRepositoryImpl` uses `Clock`, `PricingCalculator`, `FleetDurationCalculator`, `SlotCapacityService` from `core/domain/service` — no re-implemented business logic.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test test/workshop/data/ test/booking/data/` → green, canonical numbers verified against the design plan.

### Review gate
- [ ] Status 🔵; show the user both impls + test results, especially the canonical-booking total match.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `018 - Create Workshop & Booking Data Layer`.
- [ ] Claude session file written (`docs/claude-session/apps/09-mobile-step08-data-workshop-booking.md`).
- [ ] Tracker in `00-index.md` set to ✅.

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
