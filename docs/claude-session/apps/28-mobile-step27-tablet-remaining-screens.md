# Claude Session Log — 28: Mobile-app step 27 — Tablet remaining screens (S01–S09, S12, S19–S26)

**Tool:** Claude Code, model Claude Sonnet 5.5
**Date:** 2026-09-29 (approved 2026-09-30)
**Topic:** Last bonus tablet pass — tablet-portrait + landscape layouts for every screen step 26 did not cover — plus two phone UX fixes requested in the same session (voucher auto-revalidation on Ringkasan, Home first-load progress).

## Initial prompt

"i want to do docs/plan/mobile-app/27-xx, interviewme with detail if need, use grepai to explore codebase, also i want to fix and improve: when change motor or service in ringkasan or other, then back to ringkasan again, we need to auto adjust for the voucher (if not valid it should be auto remove and display snackbar to inform user about the change); also for the app first time open home, the loading is take to long, we need to improve loading state to tell user how much % we already load the initial data". After review: "approve and do rest except commit and push".

## Research performed

- `grepai` + two parallel Explore agents: (1) code inventory for S01–S26 (existing width branching, shell/rail behaviour, reusable-body extraction points, existing layout tests and harness API); (2) design inventory (which tablet frames exist, pane widths measured from the PNG exports, PRD-vs-design differences).
- Findings that shaped scope: the index coverage map assigns S01–S04 to step 27 but the step file omitted them; `TsSnackbar(aboveNavBar)` assumed a phone `NavBar`; S12 detail / S25 About / S22 Ubah jadwal were full-width sheets; the rail measured 102/256 dp vs the design's 80/240; **`flutter test` renders Ahem (1 em glyphs), so existing layout tests over-report overflow and the populated Home was never laid out at phone widths**.
- Home slowness traced to 6 sequential repository reads (300–800 ms simulated latency each) plus sequential first-run seeding.

## Clarifying interview (decisions)

| Question | Answer |
|---|---|
| Where to put the fixes | Do them in this session inside step 27; not written up as their own step |
| Home load | Progress % + parallelize reads; keep the latency simulator; card on first load only, plain skeleton on refresh |
| Voucher notice | Reason-specific snackbar, no undo |
| S01–S04 | Included |
| Test matrix | 4 tablet sizes × text ×1.0/×1.3 (+ loading) |
| Extra tablet bugs | Fix snackbar offset and the full-width sheets |
| S19 split | Auto-select first, tap selects, "Buka detail" pushes |

## Execution

- **Fix A:** `RingkasanViewModel._load` re-evaluates the applied voucher with `VoucherEligibilityService`; ineligible → `setVoucher(null)`, `voucherNotice` (`Voucher DISKON10 dilepas — <shortfall>`), page shows one `TsSnackbar.info` then clears it.
- **Fix B:** `HomeViewModel` seeds first, then reads in parallel (`Future.wait` on a record); `DemoContentSeeder.seedIfNeeded(onProgress:)`; `HomeState` gained `isFirstLoad` / `loadProgress` / `loadLabel`; new `HomeLoadingProgress` card; `LocalStore` shares one Hive init / one open per box for parallel readers.
- **Shared:** `showAdaptiveSheet`, `TsDialog.custom(maxWidth)`, rail widths, snackbar offset via `isCompact`, `UnitStatusBadge` ellipsis, `VehicleSelectCard`/`GarageAddTile` width.
- **Per screen:** S02 card/split; S03/S04 `AuthLayout` + `AuthHero`; S05 2-col grid (two-up promos, hugging CTA, fill-width garage strip); S07 columns by size class; S08 `MotorPreviewPane`; S09 two columns; S12 caps + tablet header; S19 list-detail via extracted `DetailBookingBody` (selection in `RiwayatState`); S20/S21 two columns; S22 modal + 400 cancel dialog; S23 `InvoiceSummaryCard`; S24 live `ReviewRecap(preview)`; S25 `ThemePreview`; S26 `DemoPreviewPane` + tappable unit rows.
- **Bugs found by the real-font tests and fixed:** promo slide overflow (peeking neighbour, text-scale height), draft-card overflow, preview pane stretching full height, Home tiles filling the card instead of hugging.
- **Tests added:** `tablet_remaining_layout_matrix_test` (21 variants × 4 sizes × 2 scales + loading), `tablet_remaining_layout_selection_test`, `tablet_remaining_flow_test` (S22 modals, rotation of S19/S26/S08), `home_rich_phone_layout_test`, `adaptive_sheet_test`, `theme_preview_test`, `local_store_test` (parallel opens), `ringkasan_voucher_notice_test`, extended `ringkasan_view_model_test`, `home_view_model_test`, `home_loading_progress_test`, `demo_content_seeder_test`; shared `test/support/tablet_layout_support.dart` (real router + `AppShell`, real-font loader, rich fixtures).
- Riverpod gotchas hit while testing: duplicate provider overrides hang the container silently; `a ?? B()..x = y` cascades apply to the whole `??` expression.

Verification: `flutter test` 1410/1410 (was 1094 at step 26); `flutter analyze` 0 issues; `dart format` clean.

## Review rounds

- Round 1 (2026-09-30): approved as shown — "approve and do rest except commit and push".

## Key decisions worth flagging to a reviewer

- **Deliberate design deviations:** widths 840–1199 use the Large layout (no expanded frames exist for these screens); S24 after submit keeps the single centered recap instead of morphing the right pane; S05 promo dots count reachable pages when two-up; S08 preview uses the generic motor icon.
- Layout tests for these screens load the real Exo 2 font; earlier steps' matrices still render with Ahem (stricter, unchanged).
- `PromoCarousel` slide height and `DraftResumeCard` changed for phones too (real overflow bugs, not tablet-only).
- Pre-existing phone quirk left alone: `TsButton(fullWidth: false)` fills the row under loose constraints; hugging is done with `IntrinsicWidth` only where these screens needed it.
- Nothing was run on a physical tablet — rotation, the S19 split and the S26 preview are the parts worth an emulator pass.
- Pre-existing staged `.DS_Store` files (`.DS_Store`, `design/.DS_Store`) are also in the index; unrelated to this step, check before committing.

## Output

Tracker set to ✅ in `00-index.md`. Commit message proposed: `037 - Add Tablet Layouts — Remaining Screens`. Not committed or pushed. Next: step 28 (release polish).
