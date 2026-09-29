# Step 26 — Tablet (bonus): responsive utils + booking flow (S10, S11, S13–S18)

| | |
|---|---|
| **Status** | ✅ Approved |
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

## Open questions (answered at kickoff, 2026-09-29)

1. **Responsive-utils shape** → `WindowSizeClass` enum (`compact`/`medium`/`expanded`/`large`, breakpoints 600 / 840 / 1200) + `context.windowSizeClass` / `context.isTablet` extension in `core/presentation/utils/window_size_class.dart`; pure `WindowSizeClass.fromWidth` for `LayoutBuilder` sites. No `InheritedWidget`.
2. **Per-screen split** → one step, 8 ordered sub-checklists (helper → S10 → S13/S14 → S17 → S16 → S18 → S15 → S11), progress logged per screen below.
3. **Tablet-only components** → not purely additive: S11 (form/pane/rail), S16 (recap vs `ConfirmPane`), S13/S14 (`WorkshopDetailContent` shared by the pane and the page), S15 (`_SharedSlots` / `_UnitSlots` shared by stacked and pane layouts) needed their bodies split; phone output is unchanged (P0/P1 phone layout matrices stay green).
4. **Widths 840–1199 on S10 / S14 / S17 / S18** (no design frame) → use the nearest **Large** layout from ≥840 (S10 3-col, S17 2×440, S18 480+400, S14 standalone 560/648). Medium (600–839) = Tablet-P layout.
5. **`BookingStepper` on tablet** → 720 centered at every tablet size (S11 decision 20). The S10 Large export (stepper at content width 1040) is treated as a design anomaly; PRD 06's "full width" wording is superseded.
6. **Overflow proof** → new tablet matrix: 8 screens (11 variants) × {800×1280, 1280×800, 1024×768, 673×841} × text {1.0, 1.3}, plus a loading-skeleton pass at ×1.3; phone matrices rerun as regression.

## Scope

### Files / classes to build

`core/presentation/utils/window_size_class.dart` — the size-class + device-type helper.

Per screen (S10, S11, S13, S14, S15, S16, S17, S18): a `LayoutBuilder`/`context.windowSizeClass` branch inside each existing `_page.dart` selecting compact vs. medium vs. expanded vs. large composition, plus any tablet-only component (`EstimatePane`, `DateGrid`, split `UnitSlotSection` rail, `ConfirmPane`, S18's status-panel-beside-ticket).

### Built (actual)

- **Helpers / shared:** `window_size_class.dart`, `MaxWidthBox`, `maxContentWidth` on `SelectionFooter` / `ConfirmBar` / `TicketActions` (strip stays full-bleed, inner content capped), `BookingStepper` 720 cap + label-fit fallback (only the current label stays when large text would overflow), `UnitRail` (shared by S11 + S15 split), `app/orientation_policy.dart` (phone portrait-locked, tablet free — none existed before).
- **S10:** 2-col (720) / 3-col (1040); fixed the card-width maths (ignored the 2×20 scroll padding → dropped a column) and top-aligned the grid (was vertically centered on tall windows).
- **S13/S14:** S13 list-detail split (list 400/440 + `WorkshopDetailPane` with pinned CTA, preview state in `PilihBengkelState`/VM, previewed-card chevron + accent border), replacing the fixed `mainAxisExtent: 140` grid that clipped at ×1.3; S14 stacked 720 (photo 300 / map 200) and standalone split (560 / 648) via extracted `WorkshopDetailContent`.
- **S17:** 1-col 560 / 2-col grid (`VoucherCard.margin`), "Tidak pakai voucher" full width, footer capped.
- **S16:** stacked 720 + capped `ConfirmBar`; expanded/large two-pane (recap + 360 `ConfirmPane`), `EstimateBreakdown` / `PriceLine` extracted so both layouts share them.
- **S18:** 560 ticket + capped actions; expanded/large ticket 480 + `TicketUnitsPanel` 400 with actions under the panel (an invisible header copy keeps the panel top level with the ticket top at any text scale); error state keeps the bottom bar so Beranda stays reachable.
- **S15:** medium 720 stack; shared expanded/large = date column (workshop row, toggle, `DateGrid` 400/480) + slots pane with the footer pinned inside; split large = `UnitRail` 252 · `DateGrid` 420 · slots 512 (design's 252, not PRD's 240); skeleton grid now uses the same text-scale-aware row extent as the real grid.
- **S11:** medium chip row + 720 form + pill; expanded multi-unit rail 252 + form + pill under the form; large rail + form + `EstimatePane` 360 (1 unit: form 720 + pane, no rail); copy-source sheet becomes a centered 560 dialog on tablet.

### Tests to write

- `test/core/presentation/utils/window_size_class_test.dart` — the 4 width breakpoints + the `shortestSide` device-type split, including the PRD 06 "narrow tablet window can legitimately fall to Compact" edge case and the 673×841 foldable boundary.
- `test/app/orientation_policy_test.dart` — phone display locks portrait, tablet display unlocks all orientations (pure function + widget).
- `test/layout/tablet_layout_matrix_test.dart` — 0 overflow for S10, S11 (1 + 3 units), S13, S14 (in-flow + standalone), S15 (shared + split), S16, S17, S18 × 4 tablet sizes × text ×1.0 / ×1.3, plus a loading-skeleton pass.
- `test/layout/tablet_layout_selection_test.dart` — each width class picks the layout PRD 06 prescribes (rail / pill / `EstimatePane` / `DateGrid` / `ConfirmPane` / `TicketUnitsPanel` / column counts / list-detail preview).
- `test/layout/tablet_rotation_test.dart` — portrait ↔ landscape keeps S11's active unit, S13's previewed workshop and S15's chosen slot.
- Component tests: `DateGrid`, `EstimatePane`, `ConfirmPane`, `UnitRail`.
- Shared harness `test/support/layout_test_harness.dart` (fixtures, `pumpLayoutScreen`, overflow capture) — `p0_layout_matrix_test.dart` now imports it instead of private copies.

## Checklist

### Build
- [x] Open questions answered.
- [x] Window-size-class helper built and unit-tested (+ orientation policy).
- [x] S10 tablet (2-col/3-col grid) — done.
- [x] S11 tablet (medium chip-row+form+pill; expanded rail+form+pill; large rail+form+`EstimatePane`) — done.
- [x] S13/S14 tablet (list+pane split at expanded/large) — done.
- [x] S15 tablet (date-grid+slots at expanded; date grid + slots pane at large; split rail·grid·slots at large) — done.
- [x] S16/S17 tablet (two-pane recap+`ConfirmPane`; S17 grid) — done.
- [x] S18 tablet (ticket+status-panel side by side at expanded/large) — done.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test` → green (1084 tests, whole suite incl. new tablet tests + all phone matrices).
- [x] Layout tests at 800×1280 / 1280×800 / 1024×768 / 673×841 (×1.0 / ×1.3, plus loading skeletons) → 0 overflow for all 8 screens.
- [~] Screenshots vs. each screen's design-step tablet exports — 21 widget-test renders (real Exo 2 font, icon glyphs show as boxes because the icon font isn't loaded under `flutter test`) reviewed against the exports; **not** run on a physical/emulated tablet — user to eyeball on a real tablet/emulator.

### Review gate
- [x] Status 🔵; tablet screenshots (portrait + landscape) + test results shown to the user.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `036 - Add Tablet Layouts — Booking Flow (S10, S11, S13–S18)`.
- [x] Claude session file written (`docs/claude-session/apps/27-mobile-step26-tablet-booking-flow.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Review rounds

#### Round 1 — 2026-09-29
- **Shown:** file list + 21 tablet renders (S10, S11, S13–S18 at 800×1280 / 1024×768 / 1280×800) + test results.
- **User feedback:** "got overflow in suku cadang & oil page, in the info (tidak cocok) for layout >=2 row more" / "ubah jadwal sheet, date can't be scroll horizontally — after fix this approve and do rest except commit and push". Clarified: the overflow appears after switching **off** "Hanya yang cocok untuk …" on S12 (incompatible tiles show the wrapped "Tidak cocok · untuk …" line).
- **Changes made:**
  - **S12 katalog:** the ≥600 `GridView` used a fixed `mainAxisExtent: 76`; the wrapped warning line overflowed by 34–96px. Replaced by content-sized rows (`IntrinsicHeight` `Row`s, 2 columns ≥600, 4 ≥1024). New `test/layout/katalog_tablet_layout_test.dart` (4 tablet sizes × ×1.0/×1.3, switch off): 8 failures on the old grid, 0 on the fix.
  - **"Ubah jadwal" sheet date strip:** root cause = Flutter's default `ScrollBehavior` does not drag with a mouse / trackpad / stylus (touch worked), so on a tablet emulator / desktop / Chromebook the horizontal strip could not be scrolled. New `lib/app/app_scroll_behavior.dart` (`AppScrollBehavior`, all pointer kinds) wired into `MaterialApp.router`; fixes every horizontal scrollable (S15 date strip, filter chips) at once. Tests: `tracking_flow_test.dart` drags the strip with touch and mouse on a tablet (mouse case fails without the behavior).
  - Test harness: `captureLayoutErrors` now restores `FlutterError.onError` on teardown.
- **Outcome:** approved ("approve and do rest except commit and push")

### Notes for the reviewer

- **Known pre-existing phone quirks left alone** (visible on tablet too, out of scope): S11 complaint preset `TsChip`s and S14 "Salin / Buka di Maps" `TsButton`s each fill the full row inside a `Wrap` (their `Center` wrapper expands), so they stack one per row instead of flowing.
- **Deliberate deviations from the design exports:** stepper 720 centered everywhere; S15 split at *expanded* (840–1199) has no designed frame → keeps the stacked accordion layout (rail·grid·slots needs ≥1200); S11 with 1 unit at expanded → stacked layout (no single-unit Expanded frame); S16 recap keeps its 20dp inner padding so its left edge sits 20dp inside the export's; S13 has no equal-height card rows.
- **`aboveNavBar: true` snackbars in S15 kept on purpose** — the flag lifts the snackbar above the footer, not just a nav bar.
- **Tablet tests found real overflows the phone matrices never reached:** stepper at ×1.3 (fixed), S13 fixed-height grid cell (replaced).

## Session log

| Time | Action | Result |
|---|---|---|
| kickoff | Read step file, PRD 06, design step files 06–11 + exports index; 2 Explore agents (code + design) | Code: only S10/S13 branch on width, both with defects; no tablet tests; no orientation policy. Design: Expanded frames only S11/S13/S15/S16 |
| kickoff | Interview (4 questions) | 840–1199 → Large layout; stepper 720; 4-size × 2-scale matrix; one step / 8 sub-checklists |
| build | `WindowSizeClass` + `MaxWidthBox` + unit tests; extract `layout_test_harness.dart` from p0 matrix | p0 matrix still 63/63 |
| build | Baseline tablet matrix before any layout work | 31 failures (stepper ×1.3, S13 fixed grid) |
| build | S10 → S13/S14 → S17 → S16 → S18 → S15 → S11 | Matrix + p0/p1/booking/workshop suites green after each |
| build | Loading-skeleton matrix pass | Passed after draining pending timers in the test |
| build | Orientation policy + tests | Phone portrait-locked, tablet free |
| build | Selection, rotation and component tests | All green |
| verify | Screenshot renders → found S10 vertically centered, S15 pane footer detached, shots reusing ProviderScope | Fixed S10 (`Align` top), footer `backgroundColor`, harness `UniqueKey` |
| verify | `dart format` clean · `flutter analyze` 0 issues · `flutter test` 1084 passing | Ready for review |
| review | User: S12 overflow with incompatible parts (switch off) + "Ubah jadwal" date strip not scrollable | Reproduced both (S12: 8 failing tablet cases; strip: mouse drag ignored by default `ScrollBehavior`) |
| fix | S12 fixed-height grid → content-sized rows; `AppScrollBehavior` (all drag devices) on the app | Katalog tablet test 8/8, strip touch+mouse tests green |
| verify | `dart format` clean · `flutter analyze` 0 issues · `flutter test` 1094 passing | Approved |
| close | Claude-session file, tracker ✅ | Not committed / pushed |
