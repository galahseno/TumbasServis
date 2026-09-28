# Claude Session Log — 15: Mobile-app step 14 — Booking S11 Detail Servis per Motor

**Tool:** Claude Code, model Sonnet 5 (`claude-sonnet-5`)
**Date:** 2026-09-28
**Topic:** Build S11 (per-unit service/parts/complaint config, "Salin dari" copy, live sticky estimate bar) behind `/booking/configure`; then, on request, root-cause and fix 7 pre-existing test failures unrelated to this step.

## Initial prompt

"i want to do docs/plan/mobile-app/14-xx, interviewme with detail if need" — run mobile-app step 14 per `docs/plan/mobile-app/14-booking-s11-detail-servis.md` and the workflow in `00-index.md`, with a kickoff interview per the per-step workflow.

## Research performed

Plan-mode Phase 1 exploration, 3 parallel Explore agents:
1. PRD 04 (S11 section: states, wireframe, exact copy) + PRD 03 (per-unit service config, pricing/duration, validation rules) — `prd/04-screens.md`, `prd/03-user-flows.md`.
2. Design refs — `docs/plan/design/07-s11-detail-servis.md`, `docs/claude-session/design/09-design-step07-s11-detail-servis.md`, `design/pencil/exports/step07/`, and `00-index.md`'s canonical demo content (derivation of the Rp85.000/Rp228.000/Rp428.000 · 1j/1j/2j progression).
3. Existing code — `BookingDraftViewModel`/`UnitConfig`/`BookingDraft` entities, domain services (`UnitConfigValidator`, `SalinDariCompatibilityFilter`, `PricingCalculator`, `FleetDurationCalculator`), `CatalogRepository`, step-13's `pilih_motor` screen as the established presentation-layer pattern, shared components (`TsChip`, `TsTextField`, `TsDialog`, `TsAppBar`, `TsSnackbar`, `BookingStepper`, `exit_booking_dialog`).

Then read the critical files directly (booking_draft.dart, the domain services, CatalogRepository, router.dart, routes.dart) before finalizing the plan.

## Clarifying interview (AskUserQuestion rounds → answers)

Asked the step file's 3 listed open questions + 1 more surfaced during research (bay count for the makespan calc with no workshop chosen yet). All 4 recommended options accepted:
1. **State ownership** — extend `BookingDraftViewModel` with `UnitConfig` mutation methods (mirrors its existing `selectMotor`/`deselectMotor`), not a separate notifier.
2. **S12 placeholder** — "Lihat semua" shows a snackbar ("Katalog lengkap segera hadir"), no navigation (S12 isn't built until step 15).
3. **Estimate recompute** — synchronous on every toggle, no debounce.
4. **Bay count** — hardcode `bayCount = 2` as a constant in `detail_servis_view_model.dart` (matches design's "standard 2-bay workshop" note and the canonical numbers).

Plan approved via `ExitPlanMode`.

## Execution (files written, tests added/passing)

**New:** `lib/booking/presentation/detail_servis/` (`detail_servis_page.dart`, `detail_servis_view_model.dart`, `state/detail_servis_state.dart` + `.freezed.dart`, 8 components: `vehicle_tab_chip`, `unit_header`, `copy_from_row`, `copy_source_sheet`, `copy_note`, `service_option_tile`, `part_option_tile`, `complaint_section`, `sticky_estimate_bar`); `lib/booking/presentation/utils/unit_config_display.dart` (pure helpers: chip status, Lanjut-gating reason, estimate formatting, copy-source resolution).

**Edited:** `booking_draft_view_model.dart` (+5 methods: `toggleService`/`togglePart`/`setComplaintNote`/`setUnitConfig`/`removeUnit`), `booking_presentation_module.dart` (+`detailServisViewModelProvider`), `router.dart` (`/booking/configure` → `DetailServisPage`, was `Placeholder`).

**Tests:** extended `booking_draft_view_model_test.dart` (+5 cases for the new methods); new `detail_servis_view_model_test.dart` (14 cases: pure-helper unit tests + `DetailServisViewModel` tests covering tab-switch isolation, `copyFrom`/`undoCopy`, and the canonical 3-unit price/duration progression); new `detail_servis_page_widget_test.dart` (2 widget tests, phone-width 360dp: the full canonical progression through real chip taps — this is PRD 07's named widget-test requirement — and the remove-unit immediate-vs-confirm-vs-hide-row flow). Extended `FakeCatalogRepository` with settable `serviceTypesResult`/`partsResult` (was hardcoded to empty).

The 360dp widget-test pass caught and fixed 3 real `RenderFlex` overflow bugs (`complaint_section.dart`'s collapsed row, `copy_from_row.dart`'s label, the page's "Suku cadang / oli" header row) and a test-only chip-tap hit-test issue (fixed with `tester.ensureVisible`, since the chip row is genuinely narrower than 3 chips' natural width and needs a real scroll).

`flutter analyze` 0 issues, `dart format` clean throughout.

## Review rounds (user feedback → changes → approval)

See the step file's own **Review rounds** section (Round 1). Summary: user said "approve", then separately asked to also fix the 7 pre-existing `flutter test` failures in this session (unrelated to S11, present on `main` before this session started — confirmed via `git stash` diff both before and after this step's own changes).

## Key decisions worth flagging to a reviewer

- **Root cause of the 7 pre-existing failures** (`app_shell_test.dart` ×3, `router_test.dart` ×2, `splash_view_model_test.dart` ×1, `otp_view_model_test.dart` ×1): all pump the real router/`App`, which can reach `HomePage`. `HomeViewModel`/`DemoContentSeeder` touch `localStoreProvider`, whose real implementation needs Hive + `path_provider` file I/O — real `dart:io` never completes under `testWidgets`' fake-time zone without `tester.runAsync`. `HomeViewModel._load()` has no try/catch around its fire-and-forget call, so the resulting exception was silently unhandled and `isLoading` stayed `true` forever — an infinite shimmer animation that made `pumpAndSettle` time out. Diagnosed empirically with a throwaway `testWidgets` probe (deleted after use) rather than guessed.
- **Fix:** new `test/support/home_screen_fake_overrides.dart` fakes every repository `HomeViewModel`/`DemoContentSeeder` touches (booking, garage, catalog, workshop, notification, tracking), pre-seeding the fake booking repo so `DemoContentSeeder.seedIfNeeded()` short-circuits past calls the fake doesn't implement (`confirmBooking`, unset `createDraft`). Wired into all 4 previously-failing files.
- **Bonus find:** fixing that let `router_test.dart`'s "every declared route resolves without throwing" test reach `/booking/configure` for the first time (previously it always hung on `/home` before getting that far) — which surfaced a genuine S11 bug: `DetailServisPage` showed an infinite-loading skeleton forever, never an error, when reached with 0 motors selected (`activeMotorId` resolves to `null`). Fixed by distinguishing that case from "still loading" and showing an `EmptyState` ("Belum ada motor dipilih" → "Pilih motor" pops back to S10).
- **Not done:** no live device/simulator run or screenshot comparison against `design/pencil/exports/step07/*.png` — no emulator available in this environment (only macOS desktop + a wireless physical iPhone). Flagged explicitly rather than claimed.
- Unrelated formatter-version drift in 6 other test files (touched by a repo-wide `dart format .`) was reverted both times to keep the diff scoped to this step's actual work.

## Output (files touched, next step)

**New:** `lib/booking/presentation/detail_servis/**` (12 files incl. generated `.freezed.dart`), `lib/booking/presentation/utils/unit_config_display.dart`, `test/booking/presentation/detail_servis/**` (3 test files), `test/support/home_screen_fake_overrides.dart`.

**Edited:** `lib/app/navigation/router.dart`, `lib/booking/presentation/booking_draft/booking_draft_view_model.dart`, `lib/booking/presentation/di/booking_presentation_module.dart`, `test/support/fake_catalog_repository.dart`, `test/booking/presentation/booking_draft/booking_draft_view_model_test.dart`, `test/core/presentation/components/app_shell_test.dart`, `test/app/navigation/router_test.dart`, `test/auth/presentation/splash/splash_view_model_test.dart`, `test/auth/presentation/otp/otp_view_model_test.dart`.

Full suite: 341/341 green, `flutter analyze` 0 issues. Not committed/pushed (user commits per project convention). Proposed commit message: `024 - Create Booking Flow — Detail Servis (S11)`.

Next step: **15 — Catalog S12** (`docs/plan/mobile-app/15-catalog-s12.md`), which will replace S11's "Lihat semua" snackbar placeholder with the real full parts catalog.
