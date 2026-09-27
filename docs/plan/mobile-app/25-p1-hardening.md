# Step 25 — P1 hardening (full phone-portrait app)

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Layer** | Hardening |
| **Priority** | — |
| **Owns** | Quality pass across every P1 screen + cross-screen consistency of the whole phone app |
| **PRD refs** | [06 device matrix & safe-layout rules](../../../prd/06-responsive-layout.md), [08 acceptance](../../../prd/08-deliverables-acceptance.md) |
| **Design refs** | `design/pencil/exports/step*/` (all P1 steps) |
| **Depends on** | Step 24 |
| **Claude session** | `docs/claude-session/apps/26-mobile-step25-p1-hardening.md` (written after approval) |

## Goal

Mirror step 20, but for the full P1 surface: `flutter analyze` clean across the entire app, remaining widget/layout tests, an overflow sweep across every P1 screen at the PRD 06 phone matrix, and a cross-screen consistency check (notification badge counts agree between S05/S06/S21; booking status agrees between S05/S19/S20; demo-reset actually resets everything step 24 claimed it would).

## Inputs

- PRD 06 full device matrix (all 4 phone sizes) — P1 screens are checked "at minimum on the standard phone" per PRD 06, but this step aims for the full phone matrix where time allows.
- Every P1 step's file/session log (13–24 minus the P0-only ones) for its exact state list, to confirm nothing was silently skipped.

## Open questions (ask at kickoff)

1. Scope of the "remaining states" every P1 screen deferred (per the state-coverage rule, only default+empty+one loading/error was mandatory per screen) — decide here, per screen, which of the deferred states are worth adding now vs. leaving as a documented gap for the README's "known limitations" (step 28).

## Scope

### Tests to write / verify present

- `flutter analyze` + `dart format` clean across the whole project.
- `flutter test` full suite green.
- Layout/overflow tests at the phone matrix for the remaining dense P1 screens (S11 already covered in step 20; add S08 form, S12 grid, S15 already P0-covered, S23 breakdown) at ×1.3 where copy is long.
- Cross-screen consistency check script/manual pass: notification unread count (S05 bell, S06 list, this step's assertion they agree); booking status label consistency (S05 card vs. S19/S20); demo "Reset semua data" round-trip verified against every affected repository from steps 06–09.

## Checklist

### Build
- [ ] Open questions answered (which deferred P1 states get built now vs. documented as a gap).
- [ ] Any found bug fixed in its owning feature, noted with a pointer back here.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues (whole project).
- [ ] `dart format --set-exit-if-changed .` → clean (whole project).
- [ ] `flutter test` → green (whole suite).
- [ ] Layout tests for the remaining dense P1 screens → 0 overflow.
- [ ] Manual overflow sweep across every P1 screen at the standard phone size (+ the full matrix where time allows).
- [ ] Cross-screen consistency checks pass (badge counts, status labels, demo-reset completeness).

### Review gate
- [ ] Status 🔵; show the user the full-suite summary, the consistency-check results, and the list of any consciously-deferred states (for the README).
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `035 - Harden Full Phone-Portrait App (P1 Screens)`.
- [ ] Claude session file written (`docs/claude-session/apps/26-mobile-step25-p1-hardening.md`).
- [ ] Tracker in `00-index.md` set to ✅. **The entire mobile-portrait app (P0 + P1, S01–S26) is now solid — tablet work starts next.**

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
