# Step 17 — S15 Pilih Jadwal

| | |
|---|---|
| **Status** | ⬜ Not started |
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

1. Split-mode "sibling picks count against capacity" (a deviation the design flagged from PRD 03's literal "independent" wording) — confirm the domain `SlotCapacityService` from step 03 already encodes this; if step 03 built it as fully independent, this step needs to go back and adjust that service (flag as a step-03 correction, not a redefinition here).

## Scope

### Files / classes to build

`booking/presentation/pilih_jadwal/` — `pilih_jadwal_page.dart`, `pilih_jadwal_view_model.dart` (selected date, shared/split mode, per-unit slot picks), `components/date_strip_item.dart`, `components/slot_chip.dart`, `components/capacity_banner.dart`, `components/schedule_mode_toggle.dart`, `components/unit_slot_section.dart` (accordion), `state/pilih_jadwal_state.dart`.

### Tests to write

- `test/booking/presentation/pilih_jadwal/pilih_jadwal_view_model_test.dart` — canonical date's exact chip states (available 08/09/13/15, short 10/11/14, full 12/16) reproduce the design's table; D+0 slots before now+2h show `Lewat` (`FakeClock`); split-mode sibling conflict blocks the last seat; toggling modes doesn't destroy the other mode's picks; changing date clears the shared slot.

## Checklist

### Build
- [ ] Open questions answered (and step 03's service corrected if needed).
- [ ] S15 built for loading, shared-populated, shared-insufficient, all-full, D+0-lewat, split-one-complete, split-all-complete, split-sibling-conflict, stress.
- [ ] `/booking/schedule` route wired.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test test/booking/presentation/pilih_jadwal/` → green, canonical slot table reproduced exactly.
- [ ] Screenshots vs. `design/pencil/exports/step09/*.png`.

### Review gate
- [ ] Status 🔵; show the user the screen (all states) + test results.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `027 - Create Booking Flow — Pilih Jadwal (S15)`.
- [ ] Claude session file written (`docs/claude-session/apps/18-mobile-step17-schedule-s15.md`).
- [ ] Tracker in `00-index.md` set to ✅.

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
