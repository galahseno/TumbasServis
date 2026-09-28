# Step 14 — S11 Detail Servis per Motor (core challenge screen)

| | |
|---|---|
| **Status** | ✅ Approved |
| **Layer** | Presentation, phone |
| **Priority** | P0 (the assessment's core multi-vehicle challenge screen) |
| **Owns** | `booking/presentation/detail_servis/` (S11) |
| **PRD refs** | [04 S11](../../../prd/04-screens.md), [03 per-unit service config rules](../../../prd/03-user-flows.md) |
| **Design refs** | `docs/plan/design/07-s11-detail-servis.md` + `docs/claude-session/design/09-design-step07-s11-detail-servis.md`, exports `design/pencil/exports/step07/` |
| **Depends on** | Step 13 (`BookingDraft` provider + `UnitConfig`), step 07 (catalog: services/parts), step 03 (`UnitConfigValidator`, `SalinDariCompatibilityFilter`), step 10 |
| **Claude session** | `docs/claude-session/apps/15-mobile-step14-booking-s11-detail-servis.md` (written after approval) |

## Goal

The hardest screen in the app: per-unit chip tabs preserving independent in-progress state, "Salin dari" copy with compatibility filtering, collapsible complaint section, live sticky estimate bar. Gets its own step (no other screen bundled in) given its complexity.

## Inputs

- PRD 04 S11 content/states/wireframe; PRD 03 per-unit-service-config + pricing/duration business rules.
- Design step 07 file + session log — chip-tab active-state glyph rule (keeps ✓/○/error, never hides it), "Salin dari" single-source-row vs. sheet-with-2+-sources, collapsed Keluhan auto-open rule, live running estimate.
- `CatalogRepository.getServiceTypes()/getParts({modelId})`, `UnitConfigValidator`, `SalinDariCompatibilityFilter`, `PricingCalculator`, `FleetDurationCalculator`.

## Open questions (ask at kickoff)

1. Per-unit `UnitConfig` state — held inside the shared `BookingDraftViewModel` (as `Map<motorId, UnitConfig>`, per step 02's entity split) so switching chip tabs is just reading a different map entry (no separate per-tab ViewModel), confirming this matches the design's "switching chip tabs preserves each unit's in-progress state" requirement.
2. S12 (Lihat semua → full parts catalog) isn't built until step 15 — confirm S11's "Lihat semua" link routes to a placeholder for now, and the shortlist (`PartOptionTile`s filtered by model) is fully functional standalone in the meantime.
3. Live estimate bar recompute — on every service/part toggle, recompute via `PricingCalculator`/`FleetDurationCalculator` synchronously (no debounce needed, pure functions over in-memory state)?

## Scope

### Files / classes to build

`booking/presentation/detail_servis/` — `detail_servis_page.dart`, `detail_servis_view_model.dart` (active chip index, per-unit validation state, copy-source resolution), `state/detail_servis_state.dart`.

`components/`: `vehicle_tab_chip.dart` (complete/incomplete/error, active-keeps-glyph), `unit_header.dart` (name/plate/remove — remove only with 2+ units), `copy_from_row.dart` + `copy_source_sheet.dart` + `copy_note.dart`, `service_option_tile.dart`, `part_option_tile.dart`, `complaint_section.dart` (collapsed/auto-open/required), `sticky_estimate_bar.dart` (glass, per the design's budget).

### Content & copy notes

"Untuk: Beat 110 · AB 5678 ZZ", "⎘ Salin dari Vario", "Jenis servis" (Servis Berkala Rp85.000 · 60 mnt / Ganti Oli Rp35.000 · 30 mnt / Perbaikan/Keluhan Rp50.000 · 60 mnt), "+ Tambah keluhan (opsional)", "Estimasi · 1 jam", reason line "Pilih layanan untuk PCX 160" — verbatim, matching the design's canonical running-estimate numbers (1 unit Rp85.000·1j → 2 units Rp228.000·1j → 3 units Rp428.000·2j).

### Tests to write

- `test/booking/presentation/detail_servis/detail_servis_view_model_test.dart` — switching tabs preserves each unit's selections; "Lanjut" disabled until every chip is ✓, with the correct per-unit reason line; complaint auto-opens + becomes required for `requiresComplaint` services; "Salin dari" drops incompatible parts and surfaces the "N item tidak disalin" note; removing a unit that has selections requires confirmation and hides the chip row if it drops to 1 unit.
- Widget test: the running estimate bar matches `PricingCalculator`/`FleetDurationCalculator` output at each of the 3 canonical unit-count states (this is also PRD 07's named widget-test requirement: "S11 multi-unit config, chip switching preserves state, Lanjut gating").

## Checklist

### Build
- [x] Open questions answered (kickoff interview, see Session log).
- [x] S11 built for: single unit (chip row hidden), multi unit, complaint required (auto-expand), copied (single-source row), copy-source sheet (2+ sources), all complete (Lanjut enabled), loading (skeleton), error+retry, remove-unit dialog, long content (Flexible/ellipsis fixes from the 360dp widget-test pass). Keyboard-open and true device stress states are code-supported (standard `TsTextField`, scrollable body) but not visually verified — no simulator/emulator available this session (only macOS desktop + a wireless physical iPhone).
- [x] `/booking/configure` route wired (`DetailServisPage` replaces the `Placeholder`).

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test test/booking/presentation/detail_servis/` → green (14 view-model tests + 2 widget tests), including the PRD 07-named widget test.
- [ ] Manual run: 3-unit canonical flow reproduces the design's exact running-estimate numbers at each step. **Not done — no emulator available; the same numeric progression (Rp85.000·1j → Rp228.000·1j → Rp428.000·2j) is asserted by the widget test instead, driven through the real widget tree at 360dp.**
- [ ] Screenshots vs. `design/pencil/exports/step07/*.png`. **Not done, same reason.**
- [x] Full regression check: `flutter test --concurrency=1` → **341/341 green.** The 7 pre-existing failures (app_shell_test.dart ×3, router_test.dart ×2, splash/otp view-model tests ×2) were root-caused and fixed in this same session (see Session log) — real repos going through `localStoreProvider` need Hive/`path_provider` file I/O, which never resolves under `testWidgets`' fake-time zone; fixed by faking every repository `HomeViewModel`/`DemoContentSeeder` touch (`test/support/home_screen_fake_overrides.dart`). Fixing that also surfaced and fixed a genuine S11 bug: `DetailServisPage` showed an infinite-shimmer loading skeleton forever (never an error) when reached with 0 motors selected, instead of an `EmptyState`.

### Review gate
- [x] Status 🔵; show the user the screen (all states) + the widget-test results.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `024 - Create Booking Flow — Detail Servis (S11)` (user commits/pushes, not Claude).
- [x] Claude session file written (`docs/claude-session/apps/15-mobile-step14-booking-s11-detail-servis.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Review rounds

#### Round 1 — 2026-09-28
- **Shown:** Full build summary (files, DI/route wiring), test results (14 view-model + 2 widget tests for S11, 5 more for `BookingDraftViewModel`), full-suite regression status, and the not-done items (no live device/simulator screenshot pass).
- **User feedback:** "approve" — then asked to also fix the 7 pre-existing test failures in the same session, which was done and re-shown (341/341 green).
- **Changes made:** None to S11 itself from this round beyond the incidental `EmptyState` fix surfaced while fixing the pre-existing failures (see Session log).
- **Outcome:** Approved.

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-28 | Kickoff research (PRD 04/03, design step 07 + session log, existing step-13 code/domain services) | 3 Explore agents; full copy/interaction rules and existing `BookingDraft`/`UnitConfig`/domain-service signatures confirmed |
| 2026-09-28 | Kickoff interview (4 questions incl. the step's 3 listed open questions + bay-count) | All 4 recommended options accepted: extend `BookingDraftViewModel` for unit-config mutations; "Lihat semua" → snackbar; sync recompute; hardcode `bayCount = 2` |
| 2026-09-28 | Built domain-adjacent presentation code | `booking_draft_view_model.dart` +5 methods (`toggleService`/`togglePart`/`setComplaintNote`/`setUnitConfig`/`removeUnit`); new `utils/unit_config_display.dart` (pure helpers) |
| 2026-09-28 | Built `detail_servis/` (state, view model, page, 8 components); wired DI provider + `/booking/configure` route | `flutter analyze` 0 issues, `dart format` clean |
| 2026-09-28 | Tests: extended `booking_draft_view_model_test.dart` (+5), new `detail_servis_view_model_test.dart` (14 cases), new `detail_servis_page_widget_test.dart` (2 widget tests); extended `FakeCatalogRepository` with settable results | All green; canonical 85k/228k/428k · 1j/1j/2j progression asserted at both the view-model and widget-test level |
| 2026-09-28 | Fixed 2 real overflow bugs the 360dp widget test caught (`complaint_section.dart` collapsed-row, `copy_from_row.dart` label) and one narrow-row overflow in the page's "Suku cadang / oli" header | Widget tests pass at true phone width |
| 2026-09-28 | Full-suite regression check, `--concurrency=1`, diffed against `git stash` on `main` | Same 7 pre-existing failures on both; zero regressions from this step |
| 2026-09-28 | User asked to fix the 7 pre-existing failures in this session too. Root-caused via a scratch diagnostic test: all 7 pump the real router/`App` and reach `HomePage`; `HomeViewModel`/`DemoContentSeeder` touch `localStoreProvider`, whose real impl needs Hive + `path_provider` file I/O — real `dart:io` never completes under `testWidgets`' fake-time zone without `tester.runAsync`, so `HomeViewModel` hung at `isLoading: true` forever (infinite shimmer → `pumpAndSettle` timeout) | New `test/support/home_screen_fake_overrides.dart` fakes every repo `HomeViewModel`/`DemoContentSeeder` touch; wired into all 4 files |
| 2026-09-28 | Fixing that let `router_test.dart`'s "every declared route" test reach `/booking/configure` for the first time, surfacing a real S11 bug: `DetailServisPage` fell into `_LoadingBody()` (infinite shimmer) forever when 0 motors were selected, rather than an empty state | Fixed: `detail_servis_page.dart` now shows an `EmptyState` ("Belum ada motor dipilih" → "Pilih motor" pops back to S10) when `activeMotorId` resolves to null, distinct from the still-loading case |
| 2026-09-28 | Full-suite regression re-run, `--concurrency=1` | **341/341 green**, 0 flutter analyze issues |
