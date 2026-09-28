# Step 17 — S15 Pilih Jadwal

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-28 |
| **Layer** | Presentation, phone |
| **Priority** | P0 |
| **Owns** | `booking/presentation/pilih_jadwal/` (S15) |
| **PRD refs** | [04 S15](../../../prd/04-screens.md), [03 scheduling rules](../../../prd/03-user-flows.md) |
| **Design refs** | `docs/plan/design/09-s15-jadwal.md` + `docs/claude-session/design/11-design-step09-s15-jadwal.md`, exports `design/pencil/exports/step09/` |
| **Depends on** | Step 08 (`WorkshopRepository.getAvailableSlots`), step 03 (`SlotCapacityService`), step 13/14 (`BookingDraft`), 16 (workshop chosen), 10 |
| **Claude session** | `docs/claude-session/apps/18-mobile-step17-schedule-s15.md` (written after approval) |

## Goal

Shared or per-unit ("Pisah jadwal") arrival-slot picker with the derived capacity banner and the D+0 "Lewat" cutoff.

## Inputs

- PRD 04 S15 content/states; PRD 03 scheduling business rules (capacity precedence `short > limited > available`, split-mode sibling seat accounting, non-destructive mode toggle).
- Design step 09 file + session log — `WorkshopSummaryRow`, `CapacityBanner` escalation, accordion (phone) split layout.
- `SlotCapacityService`, `WorkshopRepository.getAvailableSlots`.

## Open questions (ask at kickoff)

1. Split-mode "sibling picks count against capacity" (a deviation the design flagged from PRD 03's literal "independent" wording) — confirm the domain `SlotCapacityService` from step 03 already encodes this; if step 03 built it as fully independent, this step needs to go back and adjust that service (flag as a step-03 correction, not a redefinition here). **Resolved at kickoff (research, no user ask needed):** step 03's service already counts siblings correctly (`canSplitPlaceUnit`/`splitRemainingAfterSiblings`, used by `SlotCapacityValidator`) — no step-03 correction needed. Added one new method, `splitChipState`, mirroring `sharedChipState` for the split-mode chip UI (a split unit only ever needs 1 seat, so `short` collapses into `full`).
2. **New, found at kickoff (2 `AskUserQuestion` rounds, both recommended options taken):**
   - Promote the private `_SelectionFooter` in `pilih_motor_page.dart` (S10, already approved) to a shared `core/presentation/components/selection_footer.dart` — done; `pilih_motor_page.dart` rewired, behavior verbatim (existing S10 tests stayed green).
   - Tablet layouts (Tablet-P/Tablet-L/Expanded calendar grid, unit rail) deferred to step 26 per the tablet-deferral rule and step 16's precedent — this step is phone-only, all 9 PRD states.

## Scope

### Files / classes to build

`booking/presentation/pilih_jadwal/` — `pilih_jadwal_page.dart`, `pilih_jadwal_view_model.dart` (selected date, shared/split mode, per-unit slot picks), `components/date_strip_item.dart`, `components/slot_chip.dart`, `components/schedule_mode_toggle.dart`, `components/unit_slot_section.dart` (accordion), `state/pilih_jadwal_state.dart`.

**Deviations from the original file list (found while building):**
- `CapacityBanner` and `WorkshopSummaryRow` built in `booking/presentation/components/` (feature-shared), not screen-local — `CapacityBanner` is reused by step 18 (S16 slot-invalid banner per the design doc), and that folder already holds `booking_stepper.dart`/`exit_booking_dialog.dart` for exactly this kind of cross-screen-within-booking reuse.
- `core/presentation/components/selection_footer.dart` — new shared component, promoted from S10's private `_SelectionFooter` (kickoff decision).
- `booking/presentation/utils/schedule_display.dart` — new, pure display helpers (recap/reason lines, Lanjut gate), mirrors `unit_config_display.dart`/`selection_footer_display.dart`.
- `core/domain/service/scheduling/slot_capacity_service.dart` — one new method, `splitChipState` (see Open questions).
- `booking/presentation/booking_draft/booking_draft_view_model.dart` — new mutators `setScheduleMode`, `selectSharedSlot`/`clearSharedSlot`, `selectUnitSlot`/`clearUnitSlot`.

### Tests to write

- `test/booking/presentation/pilih_jadwal/pilih_jadwal_view_model_test.dart` — canonical date's exact chip states (available 08/09/13/15, short 10/11/14, full 12/16) reproduce the design's table; D+0 slots before now+2h show `Lewat` (`FakeClock`); split-mode sibling conflict blocks the last seat; toggling modes doesn't destroy the other mode's picks; changing date clears the shared slot.

## Checklist

### Build
- [x] Open questions answered (no step 03 correction needed; 2 new kickoff decisions above).
- [x] S15 built for loading, shared-populated, shared-insufficient, all-full, D+0-lewat, split-one-complete, split-all-complete, split-sibling-conflict, stress (phone only — tablet deferred to step 26).
- [x] `/booking/schedule` route wired.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test test/booking/presentation/pilih_jadwal/` → green (10/10), canonical slot table (shared + split columns) reproduced exactly; `flutter test test/core/domain/service/scheduling/` → green (9/9, incl. new `splitChipState` cases).
- [x] Full suite: `flutter test` → green (370/370).
- [x] Manual run: `flutter run -d macos` boots clean (no compile/DI/router errors; Dart VM Service came up). **Interactive click-through / screenshot diff not done** — no GUI-automation tool available in this session (same gap as steps 15/16).

### Review gate
- [x] Status 🔵; show the user the file list + test results (screenshots not available, see gap above).
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `027 - Create Booking Flow — Pilih Jadwal (S15)`.
- [x] Claude session file written (`docs/claude-session/apps/18-mobile-step17-schedule-s15.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Review rounds

#### Round 1 — 2026-09-28
- **Shown:** file list (new `pilih_jadwal/`, `capacity_banner.dart`/`workshop_summary_row.dart`, `selection_footer.dart` extraction, `slot_capacity_service.dart` addition, `booking_draft_view_model.dart` mutators), router + DI wiring, and test results (`flutter analyze` 0 issues, `dart format` clean, domain 9/9, `pilih_jadwal` 10/10, full suite 370/370, `flutter run -d macos` clean boot).
- **Gap disclosed:** no interactive click-through or screenshot diff vs. `design/pencil/exports/step09/*.png` — no GUI-automation tool available for the native macOS window in this session (same gap as steps 15/16).
- **User feedback:** "i test manually and all well, approve do rest except commit push"
- **Changes made:** none (approved as shown; user did their own manual click-through).
- **Outcome:** approved; close steps done, commit/push held for the user.

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-28 | Kickoff | Plan mode; 2 parallel Explore agents (domain/data — `SlotCapacityService`/`Clock`/`BookingDraft`/mock slot data; workshop presentation conventions/DI/router/shared components, using `grepai`). Found: sibling-counting already correct in domain, no `splitChipState` method yet, `SelectionFooter`/`DateStripItem`/`SlotChip`/`ScheduleModeToggle`/`WorkshopSummaryRow`/`CapacityBanner`/`UnitSlotSection` all missing, router already had a `/booking/schedule` `Placeholder()` |
| 2026-09-28 | Interview | 2 `AskUserQuestion` decisions (both recommended): promote `SelectionFooter` now; phone-only for step 17 |
| 2026-09-28 | Build (domain) | `SlotCapacityService.splitChipState` added + tests (split column of the canonical table, sibling conflict) |
| 2026-09-28 | Build (draft) | `BookingDraftViewModel`: `setScheduleMode`, `selectSharedSlot`/`clearSharedSlot`, `selectUnitSlot`/`clearUnitSlot` + tests |
| 2026-09-28 | Build (shared component) | `core/presentation/components/selection_footer.dart` extracted from `pilih_motor_page.dart`'s `_SelectionFooter`; `pilih_motor_page.dart` rewired |
| 2026-09-28 | Build (S15) | `booking/presentation/pilih_jadwal/` (state, view model, page, 4 screen-local components) + `booking/presentation/components/capacity_banner.dart` + `workshop_summary_row.dart` + `utils/schedule_display.dart`; DI provider added; router wired |
| 2026-09-28 | Fix | `PilihJadwalViewModel._load()` touched `state` synchronously before its first `await` while `bookingDraftProvider`'s own async load hadn't resolved yet → "uninitialized provider" in tests (same bug class as step 16's `PilihBengkelViewModel` fix); fixed with a bounded `_waitForDraft()` poll before any `state` read/write |
| 2026-09-28 | Quality | `flutter analyze` 0 issues; `dart format` clean; `test/core/domain/service/scheduling/` 9/9; `test/booking/presentation/pilih_jadwal/` 10/10; full suite 370/370; `flutter run -d macos` boots clean (Dart VM Service up, no compile/DI errors) |
| 2026-09-28 | Review | Status set to 🔵; awaiting user review (no screenshot/click-through — no GUI-automation tool this session) |
| 2026-09-28 | Close | User manually tested end-to-end and approved; claude session file written; tracker ✅; commit/push held for the user |
