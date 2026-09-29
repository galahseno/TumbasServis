# Claude Session Log — 27: Mobile-app step 26 — Tablet booking flow (S10, S11, S13–S18)

**Tool:** Claude Code, model Claude Sonnet 5.5
**Date:** 2026-09-29
**Topic:** First tablet step: a window-size-class helper, an orientation policy, and tablet layouts (medium / expanded / large) for the eight booking-flow screens, with the acceptance bar "no overflow page or widget at any tablet size".

## Initial prompt

"i want to do docs/plan/mobile-app/26-xx, interviewme with detail if need, use grepai to explore codebase — make sure we didn't have overflow page and widget in tablet layout". After review: "got overflow in suku cadang & oil page, in the info (tidak cocok) for layout >=2 row more; ubah jadwal sheet, date can't be scroll horizontally — after fix this approve and do rest except commit and push".

## Research performed

- `grepai` index + two parallel Explore agents: (1) current phone code of S10/S11/S13–S18, shared chrome, existing layout tests; (2) tablet design spec from PRD 06, design step files 06–11 and the export index (per-size compositions, pane widths, tablet-only components, PRD-vs-design inconsistencies).
- Findings that shaped scope: only S10 and S13 branched on width (both defective: S10 card width ignored the 2×20 scroll padding, S13 used a fixed `mainAxisExtent: 140` grid); S11/S14–S18 were full-width phone layouts; no tablet test existed; no orientation policy existed; `BookingStepper` overflowed at ×1.3; design has Expanded (1024) frames only for S11/S13/S15/S16.

## Clarifying interview (decisions)

| Question | Answer |
|---|---|
| Widths 840–1199 on S10/S14/S17/S18 (no frame) | Use the nearest Large layout from ≥840; medium = Tablet-P |
| `BookingStepper` width on tablet | 720 centered at every size |
| Overflow proof | 4 sizes (800×1280, 1280×800, 1024×768, 673×841) × text ×1.0/×1.3 |
| Execution | One step, 8 ordered sub-checklists |

## Execution

- **Shared:** `WindowSizeClass` + `context.windowSizeClass` / `isTablet`; `MaxWidthBox`; `maxContentWidth` on `SelectionFooter` / `ConfirmBar` / `TicketActions`; `UnitRail` (S11 + S15); stepper 720 cap with a label-fit fallback; `OrientationPolicy` (phone portrait-locked from the physical display size, tablet free); `AppScrollBehavior`.
- **Per screen:** S10 2/3-col; S13 list-detail (`WorkshopDetailPane`, preview state) + S14 stacked / standalone split (`WorkshopDetailContent`); S17 1-col / 2×440; S16 two-pane (`ConfirmPane`, `EstimateBreakdown`, `PriceLine`); S18 ticket + `TicketUnitsPanel`; S15 `DateGrid` + slots pane and split rail·grid·slots; S11 chip row / rail / `EstimatePane`, tablet copy-source dialog.
- **Tests added:** `window_size_class_test`, `orientation_policy_test`, `tablet_layout_matrix_test` (overflow + loading skeletons), `tablet_layout_selection_test`, `tablet_rotation_test`, `katalog_tablet_layout_test`, component tests (`DateGrid`, `EstimatePane`, `ConfirmPane`, `UnitRail`), date-strip drag tests in `tracking_flow_test`; shared `test/support/layout_test_harness.dart` (p0 matrix now imports it).
- **Bugs found by the tablet tests and fixed:** stepper overflow at ×1.3; S13 fixed grid cell; S10 card-width maths; S10 vertically centered grid; S15 skeleton grid height.
- **Bugs reported in review and fixed:** S12 katalog fixed-height grid overflowed when "Hanya yang cocok" is switched off (wrapped "Tidak cocok · untuk …" line) → content-sized rows; "Ubah jadwal" date strip not draggable with a mouse / trackpad / stylus (default `ScrollBehavior` is touch-only) → `AppScrollBehavior` on the app.
- Screenshots: 21 widget-test renders (Exo 2 loaded; icon font is not, so glyphs show as boxes) compared with the design exports.

Verification: baseline 1084 tests after the first pass → final `flutter test` 1094/1094; `flutter analyze` 0 issues; `dart format` clean.

## Review rounds

- Round 1 (2026-09-29): S12 overflow with incompatible parts + date strip not scrollable in the reschedule sheet. Both reproduced with failing tests, fixed. Approved: "approve and do rest except commit and push".

## Key decisions worth flagging to a reviewer

- **Deliberate design deviations:** stepper 720 everywhere (PRD says full width; S10 export shows 1040); S15 split at expanded (840–1199) keeps the stacked accordion (no frame; needs ≥1200 for rail·grid·slots); S11 one unit at expanded → stacked layout; S15 rail is 252 (design) not 240 (PRD); S13 card rows are not equal height; S16 recap keeps 20dp inner padding.
- `AppScrollBehavior` changes every scrollable in the app (mouse/trackpad drag now scrolls). Intended for tablet emulators, desktop and Chromebooks; no effect on touch.
- Orientation policy is new behavior (`SystemChrome.setPreferredOrientations`), decided from the display's shortest side so a tablet in split-screen keeps rotating. Not verified on a physical device.
- Pre-existing phone quirks left alone: S11 complaint chips and S14 "Salin / Buka di Maps" buttons fill the full row inside a `Wrap`.
- Renders were produced by widget tests, not on an emulator/tablet.
- Pre-existing staged `.DS_Store` files (`.DS_Store`, `design/.DS_Store`) are also in the index; unrelated to this step, check before committing.

## Output

Tracker set to ✅ in `00-index.md`. Commit message proposed: `036 - Add Tablet Layouts — Booking Flow (S10, S11, S13–S18)`. Not committed or pushed. Next: step 27 (tablet — remaining screens).
