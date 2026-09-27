# Step 20 — P0 hardening

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Layer** | Hardening |
| **Priority** | — |
| **Owns** | Quality pass across every P0 screen (S03, S05, S10, S11, S13, S15, S16, S18) |
| **PRD refs** | [06 device matrix & safe-layout rules](../../../prd/06-responsive-layout.md), [07 quality gates](../../../prd/07-architecture-tech.md), [08 M2/B4 acceptance](../../../prd/08-deliverables-acceptance.md) |
| **Design refs** | `design/pencil/exports/step*/` (pixel-parity source for every P0 screen) |
| **Depends on** | Step 19 |
| **Claude session** | `docs/claude-session/apps/21-mobile-step20-p0-hardening.md` (written after approval) |

## Goal

Close the gap between "P0 flow runs once" and "P0 flow is solid": `flutter analyze` clean, the PRD-07-named widget tests complete, layout tests across the PRD 06 **phone** device matrix + text-scale ×1.3 for the dense P0 screens, a manual overflow sweep, and the `BackdropFilter` glass-nav perf check.

## Inputs

- PRD 06 device test matrix (phone sizes: 360×640, 360×800, 393×852, 412×915) and safe-layout checklist (48dp targets, ellipsis+max-lines, sticky-bar keyboard/inset handling, no fixed-height text boxes).
- PRD 07 quality gates (the named widget-test list, already partly covered per-step — this step verifies the full set is present and green together).
- PRD 08 B4 acceptance ("zero overflow across the device matrix, verified manually per P0 screen at minimum").

## Open questions (ask at kickoff)

1. Layout-test tooling — `flutter test`'s `tester.binding.window` size overrides (`testWidgetsWithWindowSize` pattern) for the 4 phone sizes × the dense-screen list (S05/S11/S16/S18), or a manual device/emulator sweep only? Recommend automated `WidgetTester` size overrides for regression safety, backed by one manual emulator pass for real-font/real-keyboard behavior automated tests can't see.
2. `BackdropFilter` perf check — profile on the lowest-spec emulator/device available; if jank appears, confirm the flat `surface-card` + `border-subtle` fallback (documented in PRD 02/08) is acceptable to ship instead of chasing glass performance.

## Scope

### Tests to write / verify present

- Full `flutter analyze` + `dart format` clean across the whole `lib/` (not just this step's own files).
- Layout/overflow tests at the 4 phone sizes for S05, S11, S16, S18 (the PRD 06-named dense screens) + ×1.3 text scale for the same 4.
- `flutter test` full suite green (everything from steps 02–19).
- One manual emulator/device pass across all 4 phone sizes for every P0 screen, checking the PRD 06 safe-layout checklist item by item.
- `BackdropFilter` profiling note (DevTools performance overlay on the booking flow's sticky bars + the glass `NavBar`).

## Checklist

### Build
- [ ] Open questions answered.
- [ ] Any overflow/gating bug found is fixed in its owning feature (not patched here) and the fix is noted with a pointer back to this step's session log.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues (whole project).
- [ ] `dart format --set-exit-if-changed .` → clean (whole project).
- [ ] `flutter test` → green (whole suite).
- [ ] Layout tests at 4 phone sizes × the 4 dense screens + ×1.3 text scale → 0 overflow.
- [ ] Manual device-matrix sweep across all P0 screens → 0 overflow, 0 `RenderFlex overflowed` errors in the console.
- [ ] `BackdropFilter` budget respected (≤1–2 visible at once) with an acceptable frame time; fallback path exercised if not.

### Review gate
- [ ] Status 🔵; show the user the full test-suite summary, the layout-test results, and the manual sweep notes (+ any fixes made).
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `030 - Harden P0 Booking Flow (Layout, Tests, Analyze)`.
- [ ] Claude session file written (`docs/claude-session/apps/21-mobile-step20-p0-hardening.md`).
- [ ] Tracker in `00-index.md` set to ✅. **The mandatory Home→Booking-Success flow (assessment pillars 1–4) is now solid.**

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
