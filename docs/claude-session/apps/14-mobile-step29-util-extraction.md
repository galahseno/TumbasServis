# Claude Session Log — 14: Refactor — per-feature util/mapper extraction (Home + Booking)

**Tool:** Claude Code, model Sonnet 5
**Date:** 2026-09-28
**Topic:** Extract private helper logic out of `HomeViewModel` and `BookingRepositoryImpl` into per-feature util packages so both stay simple orchestrators.

## Initial prompt

"i want improve the home_view_model.dart and booking_repository_impl.dart — for now the code is too long, i want extract the extension function in the util package each feature layer so viewmodel and repo impl can stay simple."

## Research performed

One Explore agent mapped existing conventions: every repo impl in the project keeps JSON mapping inline (no mapper/DTO precedent anywhere); the only utils live in `core/presentation/utils` (`abstract final class` statics — DateFormatter pattern); enum extensions use the `X` suffix co-located with the enum in `core/domain/model`; tests exercise public API only (extraction therefore invisible to them). The `flutter-data-layer` skill documents `data/mapper/<name>_mapper.dart` (pure extensions, no I/O) as the sanctioned extraction target despite the project never having used it. Both target files read in full; the duplicated capacity-validation blocks in `confirmBooking` vs `rescheduleBooking` identified as mergeable.

## Clarifying interview

One `AskUserQuestion` round, 2 questions, both recommended options accepted:
1. Booking data layout: `mapper/` + `util/` split (vs single `util/`).
2. Home presentation layout: `lib/home/presentation/utils/` (vs co-located screen mappers dir).

Plan written to `~/.claude/plans/i-want-improve-the-silly-zebra.md`, approved via `ExitPlanMode`.

## Execution

**Home (`lib/home/presentation/utils/`):** `home_booking_display.dart` (motorInServiceStatus, toActiveBookingDisplay, majorityStatus, displayLabel) and `home_draft_display.dart` (toHomeDraftDisplay, currentStep, motorLabel). VM now 106 lines, data-gathering + state assembly only. One knock-on lint: `draft == null ? null : ...` became `draft?.toHomeDraftDisplay(...)` now that an extension member makes `?.` applicable.

**Booking mappers (`lib/booking/data/mapper/`):** `time_slot_mapper.dart`, `booking_mapper.dart`, `booking_draft_mapper.dart`. Writers named `toXJson()` (never `toJson()` — freezed codegen shadowing risk). Conditional-key omission (`complaint_note`/`mechanic_id`/`note`) preserved exactly.

**Booking utils (`lib/booking/data/util/`):** `BookingCodeGenerator` (counter box, seed hack `counters['260929'] = 416` moved verbatim, order load-bearing), `SlotCapacityValidator` (validateDraft + unified hasSharedCapacityFor/canPlaceUnits replacing duplicated blocks in confirmBooking and both rescheduleBooking branches), `TimeSlotFormatX` (slotKey unpadded / auditLabel padded — the padLeft asymmetry is persisted-behavior contract). Both classes take `LocalStore` via constructor; built in the repo's initializer list from already-injected deps, so the constructor signature and DI module are untouched.

**Tests:** 7 new files, 34 new tests — round-trips (freezed `==`), conditional-key absence, unknown-enum fallbacks, majority tie-break table, step boundaries, expiry clamp, code-generator seed tripwire (`TS-260929-0417`, increment, fresh date, padding), validator error strings + canonical occupancy table + sibling grouping, padded/unpadded labels. Two test-authoring mistakes caught by the run itself (asserted expected-not-actual behavior for empty workshop name; wrong note-presence assertion) — both fixed by matching actual verbatim-moved behavior.

**Result:** VM 215→106 lines; repo 928→~600 lines. `flutter analyze` zero issues. `test/home` 25 green, `test/booking` 44 green, existing repo/VM assertions unchanged.

## Review rounds

(none yet)

## Key decisions worth flagging to a reviewer

- **7 pre-existing full-suite failures** (router ×2, otp, splash, app_shell ×3) — missing `sharedPreferencesProvider` overrides in those harnesses, exposed once Home entered the router in step 12's uncommitted state. Verified at a HEAD worktree (passes there — Home route doesn't exist at HEAD) and by provider-chain trace; **not** caused by this refactor. They need their own fix (likely a shared test override of `sharedPreferencesProvider`), flagged to the user.
- `confirmBooking`'s ~180-line unit-assembly block deliberately left in place — it is multi-repository flow logic, not extractable pure mapping; candidate for a future split if the repo needs to shrink further.
- `_ensureSeeded()` also left in the repo (9 lines, booking-specific seeding); same future option as above.
- `_find<T>` kept as private repo static — generic language-level helper, no `collection` dependency, not worth a file.

## Output

Files touched: 2 rewired (`home_view_model.dart`, `booking_repository_impl.dart`), 7 new lib files, 7 new test files, step doc `docs/plan/mobile-app/29-util-extraction-home-booking.md`. Commit left to the user per workflow.
