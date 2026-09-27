# Step 26 — Tablet (bonus): responsive utils + booking flow (S10, S11, S13–S18)

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Layer** | Presentation, tablet (bonus) |
| **Priority** | Bonus |
| **Owns** | `core/presentation/utils/` (window-size-class helper), tablet-portrait + tablet-landscape layouts for S10, S11, S13, S14, S15, S16, S17, S18 |
| **PRD refs** | [06 responsive layout](../../../prd/06-responsive-layout.md) (window size classes, per-screen layout table, booking-flow-chrome rule) |
| **Design refs** | Each screen's own design step file (06–11) + session logs, tablet-portrait/expanded/tablet-landscape frames + exports |
| **Depends on** | Step 25 (mobile portrait fully hardened) |
| **Claude session** | `docs/claude-session/apps/27-mobile-step26-tablet-booking-flow.md` (written after approval) |

## Goal

**First tablet step.** Introduce the window-size-class helper once, then add tablet-portrait (medium/expanded) and tablet-landscape (large) layouts to every P0 booking-flow screen, per PRD 06's per-screen table. This is explicitly bonus scope (PRD 01/08) — it starts only after the entire phone app is hardened.

## Inputs

- PRD 06 window size classes (`shortestSide ≥ 600` = tablet; layout class by **width**: 360 compact / 800 medium / 1024 expanded / 1280 large) and the per-screen layout table for S10/S11/S13–S18.
- PRD 06 "booking-flow chrome": no `NavBar`/`NavRail` at any size in S10–S18; tablet gets a full-width app bar + stepper, content centered at the max-width.
- Each screen's design step file for the exact tablet composition (e.g. S11's three-pane rail 252 · form 572/700 · `EstimatePane` 360 at expanded/large).

## Open questions (ask at kickoff)

1. Responsive-utils shape — a `WindowSizeClass` enum (`compact`/`medium`/`expanded`/`large`) computed from `MediaQuery.sizeOf(context).width` + a `DeviceType` (`phone`/`tablet`) from `shortestSide`, exposed via an `InheritedWidget`/`context` extension, or a plain top-level function called per-build? Recommend a `context.windowSizeClass` extension (cheap, no extra `InheritedWidget` needed since `MediaQuery` already rebuilds on resize).
2. Per-screen split — one PR-sized session per screen (8 sub-steps inside this one step file) or all 8 in one long session? Recommend treating this file's checklist as 8 sequential sub-checklists (one review shown at the end) so a single session can still be interrupted/resumed screen-by-screen without losing track — note progress per screen in the session log as it happens.
3. `EstimatePane` (S11 large) and the other tablet-only components — new files in each screen's `components/`, confirming no phone-only widget needs restructuring to accept a tablet layout (should be additive, not a rewrite, since the skill's screens are already state+callback driven).

## Scope

### Files / classes to build

`core/presentation/utils/window_size_class.dart` — the size-class + device-type helper.

Per screen (S10, S11, S13, S14, S15, S16, S17, S18): a `LayoutBuilder`/`context.windowSizeClass` branch inside each existing `_page.dart` selecting compact vs. medium vs. expanded vs. large composition, plus any tablet-only component (`EstimatePane`, `DateGrid`, split `UnitSlotSection` rail, `ConfirmPane`, S18's status-panel-beside-ticket).

### Tests to write

- `test/core/presentation/utils/window_size_class_test.dart` — the 4 width breakpoints + the `shortestSide` device-type split, including the PRD 06 "narrow tablet window can legitimately fall to Compact" edge case.
- Layout tests per screen at 800×1280, 1280×800, and 1024×768 (S11/S13/S15/S16 only, per PRD 06) confirming no overflow and the correct layout class is selected.

## Checklist

### Build
- [ ] Open questions answered.
- [ ] Window-size-class helper built and unit-tested.
- [ ] S10 tablet (2-col/3-col grid) — done.
- [ ] S11 tablet (medium chip-row+form+pill; expanded rail+form+pill; large rail+form+`EstimatePane`) — done.
- [ ] S13/S14 tablet (list+pane split at expanded/large) — done.
- [ ] S15 tablet (date-grid+slots at expanded; 2-week calendar+split rail at large) — done.
- [ ] S16/S17 tablet (two-pane recap+`ConfirmPane`; S17 grid) — done.
- [ ] S18 tablet (ticket+status-panel side by side at large) — done.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test` → green (whole suite + new tablet tests).
- [ ] Layout tests at 800×1280 / 1280×800 / 1024×768 → 0 overflow for all 8 screens.
- [ ] Screenshots vs. each screen's design-step tablet exports.

### Review gate
- [ ] Status 🔵; show the user tablet screenshots for all 8 screens (portrait + landscape) + test results.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `036 - Add Tablet Layouts — Booking Flow (S10, S11, S13–S18)`.
- [ ] Claude session file written (`docs/claude-session/apps/27-mobile-step26-tablet-booking-flow.md`).
- [ ] Tracker in `00-index.md` set to ✅.

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
