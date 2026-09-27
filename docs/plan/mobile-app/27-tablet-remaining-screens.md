# Step 27 — Tablet (bonus): remaining screens (S05, S07–S09, S12, S19–S26)

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Layer** | Presentation, tablet (bonus) |
| **Priority** | Bonus |
| **Owns** | Tablet-portrait + tablet-landscape layouts for every screen not covered by step 26 |
| **PRD refs** | [06 responsive layout](../../../prd/06-responsive-layout.md) (per-screen layout table for the remaining screens) |
| **Design refs** | Each screen's own design step file + session log, tablet frames/exports |
| **Depends on** | Step 26 (window-size-class helper already exists; reused, not rebuilt) |
| **Claude session** | `docs/claude-session/apps/28-mobile-step27-tablet-remaining-screens.md` (written after approval) |

## Goal

Finish the bonus responsive pass: S05 (2-col grid + `NavRail`), S06 (centered list), S07–S09 (grid/split), S12 (grid), S19–S22 (list-detail split), S23/S24 (breakdown+pane, live recap), S25/S26 (menu+preview panel, split controls).

## Inputs

- PRD 06 per-screen layout table for S05–S09, S12, S19–S26.
- Each screen's design step file's tablet decisions (already built once in Pencil — reuse the composition, not re-derive it).

## Open questions (ask at kickoff)

1. `AppShell`'s `NavRail` (medium) / extended `NavRail` (large) — already built as part of step 10's foundation; confirm this step only needs to verify the 4 tabs' *content* reflows correctly inside it, not rebuild the shell itself.
2. Same per-screen-sub-checklist approach as step 26 (recommended, for the same resumability reason).

## Scope

### Files / classes to build

Per screen, a tablet-composition branch added to the existing `_page.dart` (additive, same pattern as step 26):
- S05: 2-col grid (promo/garage strip span), `NavRail` content.
- S06: centered list, max-width 720.
- S07: 2-col/3-col grid (reuses `VehicleSelectCard / Mode=Display`).
- S08: centered form 560; tablet-L form+live-preview-pane.
- S09: stacked (Tab-P, full-scroll) / hero+CTA left + details+history right (Tab-L).
- S12: 2-col/4-col grid; detail as a centered modal 560.
- S19: list-detail split (list left, S20 preview right) at Tab-L.
- S20: stacked (Tab-P) / overview left + unit-list+actions right (Tab-L).
- S21: timeline max-640 (Tab-P) / header+timeline left + ETA+mechanic+demo-shortcut right (Tab-L).
- S22: centered modal 560 (both tablet orientations share one size).
- S23: stacked 640 (Tab-P) / breakdown 720 + `InvoiceSummaryCard` 360 (Tab-L).
- S24: centered 560 (Tab-P) / form left + live recap preview right (Tab-L).
- S25: centered 560 (Tab-P) / menu left + "Pratinjau tema" forced-theme panel right (Tab-L).
- S26: centered 560 (Tab-P) / Kecepatan+Status left + preview+Simulasi-galat+Data-demo right (Tab-L).

### Tests to write

- Layout tests at 800×1280 / 1280×800 for each screen above (1024×768 not required outside S11/S13/S15/S16 per PRD 06) → 0 overflow.
- Widget test: S25's "Pratinjau tema" forced-theme panel renders the opposite theme correctly without affecting the real app theme.

## Checklist

### Build
- [ ] Open questions answered.
- [ ] S05, S06 tablet — done.
- [ ] S07, S08, S09 tablet — done.
- [ ] S12 tablet — done.
- [ ] S19, S20, S21, S22 tablet — done.
- [ ] S23, S24 tablet — done.
- [ ] S25, S26 tablet — done.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test` → green (whole suite + new tablet tests).
- [ ] Layout tests at both tablet sizes → 0 overflow for every screen in scope.
- [ ] Screenshots vs. each screen's design-step tablet exports.

### Review gate
- [ ] Status 🔵; show the user tablet screenshots for all remaining screens (portrait + landscape) + test results.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `037 - Add Tablet Layouts — Remaining Screens`.
- [ ] Claude session file written (`docs/claude-session/apps/28-mobile-step27-tablet-remaining-screens.md`).
- [ ] Tracker in `00-index.md` set to ✅. **Every screen now has phone + tablet-portrait + tablet-landscape layouts — the full PRD 06 responsive scope is complete.**

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
