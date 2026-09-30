# Step 27 — Tablet (bonus): remaining screens (S01–S09, S12, S19–S26)

| | |
|---|---|
| **Status** | ✅ Approved |
| **Layer** | Presentation, tablet (bonus) |
| **Priority** | Bonus |
| **Owns** | Tablet-portrait + tablet-landscape layouts for every screen not covered by step 26 |
| **PRD refs** | [06 responsive layout](../../../prd/06-responsive-layout.md) (per-screen layout table for the remaining screens) |
| **Design refs** | Each screen's own design step file + session log, tablet frames/exports (`design/pencil/exports/step05,13–18/`) |
| **Depends on** | Step 26 (window-size-class helper already exists; reused, not rebuilt) |
| **Claude session** | `docs/claude-session/apps/28-mobile-step27-tablet-remaining-screens.md` (written after approval) |

## Goal

Finish the bonus responsive pass: S01–S04 (splash, onboarding, login, OTP), S05 (2-col grid + `NavRail`), S06 (centered list), S07–S09 (grid/split), S12 (grid), S19–S22 (list-detail split), S23/S24 (breakdown+pane, live recap), S25/S26 (menu+preview panel, split controls).

## Inputs

- PRD 06 per-screen layout table for S01–S09, S12, S19–S26.
- Each screen's design step file's tablet decisions (already built once in Pencil — reuse the composition, not re-derive it).

## Open questions (answered at kickoff, 2026-09-29)

1. **S01–S04 in scope?** → **Yes.** The index coverage map assigns them to step 27 (the earlier scope list forgot them); S01 needed nothing, S02/S03/S04 got real tablet layouts.
2. **`NavRail` / extended `NavRail`** → already built in step 10; this step only verifies tab content reflows beside it. Two small corrections found on the way: the rail measured 102 dp (medium) / 256 dp (large) against the design's 80 / 240, so `minWidth: 80`, `minExtendedWidth: 240` and zero destination padding were set (now 86 / 240).
3. **Sub-checklist per screen** → yes, same resumable approach as step 26 (below).
4. **Test matrix** → 4 sizes (800×1280, 1280×800, 1024×768, 673×841) × text ×1.0 / ×1.3 + loading pass (the step file only required the first two).
5. **Extra tablet bugs found while exploring** → fix both: (a) `TsSnackbar(aboveNavBar: true)` lifted the snackbar 76 dp for a phone `NavBar` even where a rail replaced it (Home, Garasi now pass `isCompact`; S15/S24 keep the flag on purpose — it clears the footer bar, not a nav bar); (b) S12 part detail, S25 About and S22 "Ubah jadwal" were full-width bottom sheets → centered 560 modal on tablets (design/PRD 06).
6. **S19 split behaviour** → first booking is auto-selected, a tap selects (accent border) instead of pushing, "Buka detail" pushes the full S20; the selection lives in the view model so it survives rotation.
7. **Widths 840–1199** (no frame for any of these screens) → the **Large** layout, as in step 26; 600–839 = Tab-P.

## Scope

### Files / classes built

**Shared**
- `core/presentation/components/adaptive_sheet.dart` — `showAdaptiveSheet`: bottom sheet on compact, centered ≤560 `Dialog` (no drag handle) from 600 dp. Used by S12 part detail, S25 About, S22 Ubah jadwal, S11 copy-source sheet. `SheetHeader` drops its handle from 600 dp.
- `TsDialog.custom(maxWidth:)` — S22 cancel dialog is 400 on tablets (design), everything else stays 560.
- `NavRail` widths (see Open question 2); `UnitStatusBadge` label now ellipsizes instead of overflowing in narrow cards; `VehicleSelectCard` / `GarageAddTile` take a `width`.

**Per screen** (each a branch on `context.windowSizeClass`, phone output unchanged)

| Screen | Tab-P (medium) | Tab-L (≥ 840) |
|---|---|---|
| S01 Splash | unchanged (centered logo) | unchanged |
| S02 Onboarding | centered 560 card, art 300, `Lewati` top-right | copy left (≤480, display title) · art panel right (art 420) |
| S03 / S04 Auth | centered 480 `AuthCard` (`AuthLayout`) | form ≤480 left · `AuthHero` brand panel right; OTP back arrow inside the form column |
| S05 Beranda | rail + content ≤720, greeting in the app bar, CTA hugs its label, Active │ Draft row, one-up promos, 5 fill-width garage cards, Riwayat + Katalog tiles | content ≤1040, two-up promos (`PromoCarousel.perView`) |
| S06 Notifikasi | already centered 720 — verified | same |
| S07 Garasi | 2 columns, 24 gutter | 3 columns (from the expanded class) |
| S08 Motor form | centered form (model picker = modal, existing) | form (≤600 column) + `MotorPreviewPane` 360 (live nickname / plate / model, muted placeholders) |
| S09 Motor detail | stacked ≤720 | hero + CTA + delete left (400) · details + history right |
| S12 Katalog | content ≤720, detail = centered modal | content ≤1232, unit label + search share a row, chips + toggle share a row, 4 columns |
| S19 Riwayat | single list ≤720, push on tap | list 420 · embedded S20 pane (auto-select, tap selects, "Buka detail") |
| S20 Detail booking | stacked ≤720 (`DetailBookingBody` extracted from the page) | overview left · unit list + actions right |
| S21 Lacak unit | timeline ≤640 | unit header + timeline left · ETA + mechanic + demo shortcut right |
| S22 Sheets | Ubah jadwal = centered ≤560 modal; Batalkan dialog 400 | same |
| S23 Invoice | stacked 640 + capped bottom bar | breakdown left · `InvoiceSummaryCard` 360 (total, status, lines, CTA), no bar |
| S24 Ulasan | centered 560 + capped bar | form + inline CTA · live `ReviewRecap(preview: true)` 400 ("Ulasanmu akan tampil di sini" until a star is chosen) |
| S25 Profil | centered 560 (About = modal) | menu left · `ThemePreview` "Pratinjau tema" right (mini app painted with the chosen theme; System follows the device) |
| S26 Mode demo | centered 560 | controls left (Kecepatan + Status, tappable unit rows, "Dipratinjau") · `DemoPreviewPane` live timeline + Simulasi galat + Data demo right |

### Deliberate deviations from the design exports

- Widths 840–1199 use the Large layout (no expanded frames exist for these screens).
- S24 after submit keeps the phone/Tab-P recap (single centered card) instead of morphing the right pane into the final recap.
- S05 Tab-L promo dots count reachable pages (2 for 3 promos two-up), not slides.
- S08 keeps the phone photo field; the preview card uses the generic `two_wheeler` icon (the app has no per-category silhouettes).
- The app bar of S20 / S21 / S23 / S24 stays full width above the split (matches the exports).

### Also fixed on the way (found by the real-font tests)

- `PromoCarousel`: the peeking neighbour slide (viewport 0.92) laid out a 17 dp wide column → overflow stripes on phones; slide height now grows with text scale and is taller where the title wraps.
- `DraftResumeCard`: expiry label and the two buttons could overflow narrow cards.
- `LocalStore`: parallel first reads now share one Hive init / one open-per-box future (Home reads in parallel since the load-progress fix).
- Layout tests for these screens load the real Exo 2 font (`loadAppFonts`); `flutter test` otherwise renders Ahem (1 em-wide glyphs) which reports overflows a device never has. Phone matrices from earlier steps are unchanged.

### Tests written

- `test/layout/tablet_remaining_layout_matrix_test.dart` — 21 screen variants × 4 tablet sizes × text ×1.0 / ×1.3 + loading pass → 0 overflow (S01–S09 incl. add/edit and in-service/free, S12 browse/select, S19–S21, S23 unpaid/paid, S24, S25, S26).
- `test/layout/tablet_remaining_layout_selection_test.dart` — each width class picks the right composition (card vs split, `AuthHero`, `MotorPreviewPane`, garage columns, S19 pane + tap-select, `InvoiceSummaryCard` vs bar, `ReviewRecap` preview follows stars, `ThemePreview` follows the segmented control, `DemoPreviewPane` follows the tapped row).
- `test/layout/tablet_remaining_flow_test.dart` — S22 "Ubah jadwal" is a ≤560 dialog and Batalkan ≤400 at both orientations and both text scales, phone keeps the bottom sheet; S19 selection, S26 preview unit and S08 typed nickname survive large → medium → large.
- `test/layout/home_rich_phone_layout_test.dart` — populated Beranda (active booking, draft, promos, 4 motors) on three phones × two scales.
- Components: `adaptive_sheet_test`, `theme_preview_test` (forced dark inside a light app, System follows the platform), `local_store_test` (parallel opens).
- Shared support: `test/support/tablet_layout_support.dart` (`pumpShellRoute` through the real router + `AppShell`, `pumpRoutedScreen`, `richAppOverrides`, `loadAppFonts`, `unmountScreen`, `expectNoLayoutErrorsDuring`).

## Checklist

### Build
- [x] Open questions answered.
- [x] Shared foundation: `showAdaptiveSheet`, rail widths, snackbar offset, `TsDialog.maxWidth`, tablet test support.
- [x] S01, S02, S03, S04 tablet — done.
- [x] S05, S06 tablet — done.
- [x] S07, S08, S09 tablet — done.
- [x] S12 tablet — done.
- [x] S19, S20, S21, S22 tablet — done.
- [x] S23, S24 tablet — done.
- [x] S25, S26 tablet — done.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test` → green (1410 tests, whole suite incl. new tablet tests + all phone matrices).
- [x] Layout tests at 800×1280 / 1280×800 / 1024×768 / 673×841 (×1.0 / ×1.3, plus loading) → 0 overflow for every screen in scope.
- [~] Screenshots vs. each screen's design-step tablet exports — widget-test renders (real Exo 2 font; icon glyphs show as boxes because the icon font isn't loaded under `flutter test`) of S02, S03, S05, S07–S09, S19–S21, S23–S26 reviewed against the exports; **not** run on a physical/emulated tablet — user to eyeball on a real tablet/emulator.

### Review gate
- [x] Status 🔵; tablet renders + test results ready to show.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `037 - Add Tablet Layouts — Remaining Screens`.
- [x] Claude session file written (`docs/claude-session/apps/28-mobile-step27-tablet-remaining-screens.md`).
- [x] Tracker in `00-index.md` set to ✅. **Every screen now has phone + tablet-portrait + tablet-landscape layouts — the full PRD 06 responsive scope is complete.**

## Review rounds

#### Round 1 — 2026-09-30
- **Shown:** file list, widget-test renders (S02, S03, S05, S07–S09, S19–S21, S23–S26 at 800×1280 / 1280×800), test results, notes on the two extra fixes.
- **User feedback:** "approve and do rest except commit and push".
- **Changes made:** none requested.
- **Outcome:** approved

### Notes for the reviewer

- **Known pre-existing phone quirk left alone:** `TsButton(fullWidth: false)` still fills the row when its parent gives loose constraints (its inner `Container` is centered). Where a hugging button matters on the screens touched here (Home CTA, promo CTA, draft-card buttons) it is wrapped in `IntrinsicWidth`.
- **Not verified on hardware:** everything above is widget-test level. Rotation, the S19 split and the S26 preview are the parts worth a real tablet.
- **Also done this session, outside this step's scope** (requested together, not written up as a step): voucher auto-revalidation on Ringkasan (drops a voucher that stopped qualifying + reason snackbar) and Home first-load progress (parallel reads + `%` card). Tests: `ringkasan_view_model_test`, `ringkasan_voucher_notice_test`, `home_view_model_test`, `home_loading_progress_test`, `demo_content_seeder_test`.

## Session log

| Time | Action | Result |
|---|---|---|
| kickoff | Read step file, PRD 06, index; 2 Explore agents (code inventory + design frames) | Found S01–S04 missing from the scope list, `aboveNavBar` and full-width sheets on tablet, rail 102/256 dp vs 80/240, tests render Ahem |
| kickoff | Interview (4 questions) | S01–S04 in; 4 sizes × 2 scales; fix snackbar + sheets; S19 auto-select |
| build | `showAdaptiveSheet`, rail widths, `TsDialog.maxWidth`, snackbar offset | Katalog / profile / tracking suites green |
| build | Tablet test support + real-font loader; matrix grown per screen | Ahem-vs-Exo finding; matrices green screen by screen |
| build | S02 → S03/S04 → S05 → S07–S09 → S12 → S19–S21 → S23/S24 → S25/S26 | Each pass: analyze clean + affected suites + matrix |
| verify | Screenshot renders (light, 800×1280 / 1280×800) | Fixed: hero CTA and promo CTA filled the card, draft-card buttons stacked, preview pane stretched full height, Home showed non-running bookings (test fake ignored the status filter) |
| verify | Populated phone Home with the real font | Found and fixed the promo slide overflow and draft-card overflow |
| verify | `dart format` clean · `flutter analyze` 0 issues · `flutter test` 1410 passing | Ready for review |
| review | User approved | No changes requested |
| close | Claude-session file, tracker ✅ | Not committed / pushed |
