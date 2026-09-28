# Step 29 — Util/mapper extraction: HomeViewModel + BookingRepositoryImpl

## Goal

Slim `home_view_model.dart` (215 → ~106 lines) and `booking_repository_impl.dart` (928 → ~600 lines) by extracting private helpers into per-feature util packages. Public API unchanged; behavior frozen (bodies moved verbatim). Establishes the first per-feature `mapper/` and `util/` dirs, following the `flutter-data-layer` skill's canonical split:

- `lib/booking/data/mapper/` — pure JSON ↔ domain extensions (no I/O)
- `lib/booking/data/util/` — stateful helpers owning `LocalStore` access
- `lib/home/presentation/utils/` — display-mapping extensions (mirrors `core/presentation/utils`)

## Scope

### Files created

**Home presentation utils**
- `lib/home/presentation/utils/home_booking_display.dart` — `HomeBookingsX.motorInServiceStatus`, `HomeBookingDisplayX.toActiveBookingDisplay`, `HomeUnitStatusesX.majorityStatus`, `UnitStatusDisplayX.displayLabel`
- `lib/home/presentation/utils/home_draft_display.dart` — `HomeDraftDisplayX.toHomeDraftDisplay` / `.currentStep` / `.motorLabel`

**Booking mappers**
- `lib/booking/data/mapper/time_slot_mapper.dart` — `toTimeSlot()` / `toTimeSlotJson()`
- `lib/booking/data/mapper/booking_mapper.dart` — `toBooking()` / `toBookingJson()` (+ private unit/status-event/motor-snapshot helpers)
- `lib/booking/data/mapper/booking_draft_mapper.dart` — `toBookingDraft()` / `toDraftJson()`

**Booking utils**
- `lib/booking/data/util/booking_code_generator.dart` — `BookingCodeGenerator.next()` (owns counter box + seed hack `counters['260929'] = 416`)
- `lib/booking/data/util/slot_capacity_validator.dart` — `SlotCapacityValidator.validateDraft/hasSharedCapacityFor/canPlaceUnits` (unifies the duplicated capacity blocks in `confirmBooking` + `rescheduleBooking`)
- `lib/booking/data/util/time_slot_format.dart` — `TimeSlotFormatX.slotKey` (unpadded) / `.auditLabel` (padded)

### Files rewired

- `lib/home/presentation/home/home_view_model.dart` — data gathering + state assembly only
- `lib/booking/data/repository/booking_repository_impl.dart` — orchestration only; constructor signature unchanged (helpers built in initializer list from existing deps, DI module untouched)

### Conventions locked

- Domain→Map writers named `toXJson()` (never `toJson()` — freezed codegen shadowing risk); Map→domain readers named `toX()` on `Map<String, dynamic>`.
- Extension names must not collide with `UnitStatusX` / `BookingStatusX` / `ScheduleModeX` (core/domain/model).

### Tests

- `test/home/presentation/utils/home_booking_display_test.dart`, `home_draft_display_test.dart`
- `test/booking/data/mapper/booking_mapper_test.dart`, `booking_draft_mapper_test.dart`
- `test/booking/data/util/booking_code_generator_test.dart`, `slot_capacity_validator_test.dart`, `time_slot_format_test.dart`

### Behavior-drift traps (moved character-for-character)

- Majority-status tie-break (lowest `stageIndex` wins) + `counts.length == 1` early return suppressing the caption
- `counters['260929'] = 416;` stays **after** the seed parse loop
- padLeft asymmetries: `slotKey` unpadded; `auditLabel`/`_formatYyMmDd`/code(4)/home hour(2) padded
- Box names + row shapes are persisted-data contracts
- Capacity checks recompute `booked` from the store (caller slot values ignored); `_capacity = 5` now lives only in the validator
- `expiringSoon` uses raw `inHours < 3`; label clamps negatives to 0

## Checklist

### Build
- [x] Home utils extracted, VM rewired (`draft?.toHomeDraftDisplay(...)` — null-aware now that extension allows it)
- [x] Booking mappers extracted, repo rewired, inline mapper block deleted
- [x] `BookingCodeGenerator` extracted; `_nextCode` call site → `_codeGenerator.next(...)`
- [x] `SlotCapacityValidator` extracted; reschedule's duplicated capacity blocks unified
- [x] `TimeSlotFormatX` extracted (`slotKey` / `auditLabel`)

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` zero issues
- [x] `flutter test test/home` green (25) — VM label/caption/step assertions unchanged
- [x] `flutter test test/booking` green (44) — incl. `TS-260929-0417` counter tripwire and `'Dijadwal ulang'` audit notes
- [x] Full suite: 7 failures in `test/app`, `test/auth`, `test/core` (router/otp/splash/app_shell) — **pre-existing**, caused by missing `sharedPreferencesProvider` overrides in those harnesses once Home entered the router (step-12 uncommitted state); verified at HEAD + traced provider chain, not caused by this refactor

### Review gate
- [ ] User reviews diff

### Close (only after approval)
- [ ] User commits manually (no auto-commit per workflow)

## Review rounds

#### Round 1 — 2026-09-28
- **Shown:** new util/mapper files + rewired VM/repo, test counts
- **User feedback:** —
- **Changes made:** —
- **Outcome:** pending

## Session log

| Time | action | result |
|------|--------|--------|
| — | Plan-mode interview (2 questions: data layout, home layout) | mapper/+util/ split and `lib/home/presentation/utils/` chosen |
| — | Extract home utils + tests | VM 215→106 lines; `test/home` 25 green |
| — | Extract booking mappers + tests | repo −180 lines mapper block; round-trip + conditional-key tests |
| — | Extract `BookingCodeGenerator` + tests | seed-hack tripwire `TS-260929-0417` green |
| — | Extract `SlotCapacityValidator` + `TimeSlotFormatX` + tests | reschedule branches unified; 44 booking tests green |
| — | Full gate | analyze clean; 7 pre-existing failures isolated to app/auth/core scopes |
