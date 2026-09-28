# Claude Session Log — 18: Mobile-app step 17 — S15 Pilih Jadwal

**Tool:** Claude Code, model Claude Sonnet 5
**Date:** 2026-09-28
**Topic:** Shared/per-unit arrival-slot picker (S15) — date strip, hourly slot grid, derived capacity banner, D+0 cutoff, split-mode accordion with sibling seat accounting.

## Initial prompt

"i want to do docs/plan/mobile-app/17-xx, interviewme with detail if need, use grepai to explore codebase" (Plan mode.)

## Research performed

Two parallel Explore agents (both instructed to use `grepai`, confirmed installed and initialized in this repo):
1. Domain/data layer — `SlotCapacityService` (step 03), `Clock`/`FakeClock`, `WorkshopRepository.getAvailableSlots` + its impl (`SlotOccupancyCalculator`'s canonical demo table, matching the design doc exactly), `TimeSlot` entity, `BookingDraft`/`BookingUnit` schedule fields, `BookingDraftViewModel`'s existing mutator shape.
2. Reusable presentation patterns — step 16's screen-folder convention (`Notifier<State>`, flat freezed state with `isLoading`/`hasError`), `booking_presentation_module.dart` (already exists, just needed one more provider line), the router's existing `/booking/schedule` `Placeholder()`, and an inventory of which shared components already exist (`TsSwitch`, `Skeleton`, `TsDialog`, `EmptyState`, `ErrorState`, `BookingStepper`, `TsAppBar`) vs. missing (`SelectionFooter` as a shared component — only a private copy in `pilih_motor_page.dart` — plus `DateStripItem`, `SlotChip`, `ScheduleModeToggle`, `WorkshopSummaryRow`, `CapacityBanner`, `UnitSlotSection`).

Confirmed the step file's own open question (whether the domain service already counts split-mode siblings against capacity, or needs a step-03 correction) was already resolved correctly: `canSplitPlaceUnit`/`splitRemainingAfterSiblings` already decrement by `siblingsAlreadyPlaced`, matching design decision 6 and PRD 03 §96's current wording — no step-03 correction needed.

## Clarifying interview

Two `AskUserQuestion` decisions, both recommended options taken:
1. **Promote `SelectionFooter`** from the private `_SelectionFooter` in `pilih_motor_page.dart` (S10, already approved) to a shared `core/presentation/components/selection_footer.dart`, rewiring S10 to use it — rather than duplicating a screen-local copy for S15.
2. **Phone-only for step 17.** Tablet-P/Tablet-L/Expanded (calendar `DateGrid`, unit rail) deferred to step 26 per the repo's tablet-deferral rule and step 16's own precedent.

## Execution

Files written/changed:
- `lib/core/domain/service/scheduling/slot_capacity_service.dart` — new `splitChipState` method (mirrors `sharedChipState`, fixed unit-count of 1 since a split unit only ever needs one seat — `short` collapses into `full`).
- `lib/booking/presentation/booking_draft/booking_draft_view_model.dart` — new mutators `setScheduleMode`, `selectSharedSlot`/`clearSharedSlot`, `selectUnitSlot`/`clearUnitSlot`, following the existing `copyWith` + `_persist` pattern.
- `lib/core/presentation/components/selection_footer.dart` — new shared component, extracted verbatim from S10's `_SelectionFooter`, generalized to take `recapLine`/`reasonLine`/`ctaLabel`; `lib/booking/presentation/pilih_motor/pilih_motor_page.dart` rewired to use it (behavior unchanged, existing S10 tests stayed green).
- `lib/booking/presentation/components/{capacity_banner,workshop_summary_row}.dart` — new, feature-shared (not screen-local) since the design doc reuses `CapacityBanner` for S16's slot-invalid banner (step 18).
- `lib/booking/presentation/pilih_jadwal/` — `pilih_jadwal_page.dart`, `pilih_jadwal_view_model.dart`, `state/pilih_jadwal_state.dart` (+ freezed), `components/{date_strip_item,slot_chip,schedule_mode_toggle,unit_slot_section}.dart`.
- `lib/booking/presentation/utils/schedule_display.dart` — pure display helpers (recap/reason lines, the Lanjut gate).
- `lib/booking/presentation/di/booking_presentation_module.dart` — `pilihJadwalViewModelProvider` added.
- `lib/app/navigation/router.dart` — `/booking/schedule`'s `Placeholder()` replaced with `PilihJadwalPage()`.
- `test/support/fake_workshop_repository.dart` — extended with a per-date `availableSlotsByDate` override map (needed to drive different canonical/insufficient/all-full days in tests).

Tests added: `test/core/domain/service/scheduling/slot_capacity_service_test.dart` (+2, split-column canonical table + sibling conflict via `splitChipState`), `test/booking/presentation/booking_draft/booking_draft_view_model_test.dart` (+3, schedule mutators), `test/booking/presentation/pilih_jadwal/pilih_jadwal_view_model_test.dart` (10, new file — load, canonical shared table, D+0 Lewat, invalid-slot no-op, valid selection, date-change clears the shared slot, all-full next-day search, non-destructive mode toggle, sibling conflict, split short→limited collapse).

One real bug caught and fixed: `PilihJadwalViewModel._load()` read `ref.read(bookingDraftProvider)` and, on a null draft, wrote to `state` before any `await` — since the booking draft provider's own async load hadn't resolved yet at that point, and this notifier's `build()` hadn't returned yet either, every test threw "tried to read the state of an uninitialized provider." Same bug class as step 16's `PilihBengkelViewModel` fix. Fixed with a bounded `_waitForDraft()` poll (5 ms × up to 200) as the very first statement of `_load()`, so nothing touches `state` synchronously inside `build()`'s call stack, and the VM actually waits for the draft to exist rather than assuming it already does.

A deliberate scope simplification: the disabled-CTA reason line for the shared-insufficient day reuses the generic "Pilih jam kedatangan" copy rather than the design's more specific "Tidak ada jam yang muat N motor" variant — noted here rather than adding a third reason-line branch under time pressure; a straightforward follow-up if a reviewer wants exact parity.

Quality gates: `flutter analyze` 0 issues; `dart format --set-exit-if-changed .` clean; `flutter test test/core/domain/service/scheduling/` 9/9; `flutter test test/booking/presentation/pilih_jadwal/` 10/10; full suite 370/370; `flutter run -d macos` boots clean (Dart VM Service came up, no compile/DI/router errors).

## Review rounds

Round 1 (2026-09-28): shown the file list (new `pilih_jadwal/`, shared `capacity_banner.dart`/`workshop_summary_row.dart`/`selection_footer.dart`, the domain/draft-VM additions), router + DI wiring, and test results. Gap disclosed: no interactive click-through or screenshot diff vs. `design/pencil/exports/step09/*.png` — no GUI-automation tool available for the native macOS window this session (same gap as steps 15/16). User did their own manual click-through and replied "i test manually and all well, approve do rest except commit push". Approved as shown, no changes requested.

## Key decisions worth flagging to a reviewer

- `CapacityBanner` and `WorkshopSummaryRow` deliberately live in `booking/presentation/components/` (feature-shared), not `pilih_jadwal/components/` as the step file originally listed — `CapacityBanner` is designed for reuse by step 18 (S16's slot-invalid banner), matching the design doc's own note.
- `SlotCapacityService.splitChipState` fixes the split unit's needed-seat count at 1, so `SlotChipState.short` can never occur in split mode — only `full`/`limited`/`available`/`lewat`. This is a deliberate collapse, not an oversight; the design doc's own demo table shows the same collapse (a shared "short" hour reads "limited" once split).
- The "all slots full → next day" search (`PilihJadwalViewModel._refreshAllFullNextDate`) walks up to 14 days forward calling `WorkshopRepository.getAvailableSlots` once per candidate day; fine for this mock/demo scale (≤14 network-simulated calls, no real backend), but would need batching or a range-query repository method if slot data ever became a real remote call.
- Reason-line copy for the shared-insufficient-capacity state is generic ("Pilih jam kedatangan") rather than the design's specific "Tidak ada jam yang muat N motor" — see Execution above.

## Output

Files touched: see Execution above. Next step: 18 — S16/S17 (summary + voucher), which will consume `draft.sharedSlot`/`draft.unitSlots` for the estimate block and reuse `CapacityBanner` for the slot-invalid race-condition banner.
