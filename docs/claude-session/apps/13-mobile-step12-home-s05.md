# Claude Session Log — 13: Mobile-app step 12 — S05 Beranda (Home) + real AppShell wiring

**Tool:** Claude Code, model Sonnet 5
**Date:** 2026-09-28
**Topic:** The app's entry screen — greeting, primary booking CTA, active-booking card(s), draft-resume card, promo carousel, garage strip, quick links — wired to real repositories, replacing `AppShell`'s Beranda `Placeholder()`.

## Initial prompt

"i want to do docs/plan/mobile-app/12-xx, interviewme with detail if need" + "ref the export png image as minimal as posible, only read needed png for this scope plan." Follow-up after the first build pass: "got error in home page when try in emulator" (a real crash report). Final: "is the riwayat in bottom home page (beside katalog) do same with riwayat in the bottom nav? if yes remove it and keep full width for katalog and then approve do the rest except commit push."

## Research performed

Read the step file, the approved design step 05 doc + session log, and 4 of the design's phone-scope PNGs (populated/empty/loading + the component sheet — tablet and dark exports deliberately skipped as out of scope for a phone-only step, per the user's minimal-PNG instruction). One Explore agent mapped domain models, repository interfaces, DI provider patterns, the router, and `AppShell`'s slot mechanism. Direct code reads (not agent-delegated) then surfaced 3 real gaps beyond the step file's own 2 listed open questions:

- `BookingRepository` had no non-mutating way to check for an existing draft (`createDraft()` always materializes one if none exists).
- The design's canonical populated-state content (active booking `TS-260929-0417`, Supra X 125 draft) exists nowhere in the codebase — not in mock seed JSON, not in local storage.
- `FleetProgress` is design-documented as reused by S20 (tracking) — not Home-specific.

Mid-build, a 4th gap surfaced while implementing the seeding approach: `BookingRepositoryImpl._ensureCountersSeeded()` carries an explicit comment stating `TS-260929-0417` is a **reserved** code meant to come from a real `confirmBooking()` walkthrough (S10→S18), not a static seed row — directly contradicting the just-approved plan to add it to `bookings_seed.json`. Caught before any seed-data edit was made.

## Clarifying interview

Plan-mode `AskUserQuestion` round, 3 questions, all recommended options accepted:
1. Add `BookingRepository.getCurrentDraft()` as a non-mutating peek.
2. Materialize the canonical demo booking + draft lazily, via real repository calls (not static seed data).
3. `FleetProgress` lives in `core/presentation/components/` (cross-feature, same precedent as `UnitStatusBadge`), not home-local.

A 2nd, unplanned round followed the counter-reservation discovery: re-confirmed with the user to seed the canonical booking **programmatically** (`confirmBooking` + `TrackingRepository.advanceUnitStatus`, walking the same repository calls the real S10–S18 flow will) rather than as a static `bookings_seed.json` row, keeping the reserved counter untouched.

Full plan written to `~/.claude/plans/i-want-to-do-silly-kitten.md` and approved via `ExitPlanMode` before implementation.

## Execution

**Domain (small additive changes):** `BookingRepository.getCurrentDraft()` (peek, never creates/deletes) and `.deleteDraft()`; `UnitStatus.stageIndex` (0–5 forward-stage position, for progress-bar rendering).

**Data:** `BookingRepositoryImpl` implements both new methods. New `core/data/service/demo_content_seeder.dart` (`DemoContentSeeder`) — walks `confirmBooking()` with the canonical 3-motor draft, then `TrackingRepository.advanceUnitStatus()` (3× for `-A`/`-B` → `dikerjakan`, 2× for `-C` → `diperiksa`), then `createDraft()` + `updateDraft()` for the Supra X 125 draft at "Langkah 2 dari 4." Idempotent (checks for the canonical code first). Wired from `home_presentation_module.dart` rather than `core/data/di/` — it needs both `BookingRepository` and `TrackingRepository`, and `core/` must not depend on feature-level providers.

**Presentation:** New cross-feature components `core/presentation/components/fleet_progress.dart` (hard-stop-gradient segments + mandatory text label) and `vehicle_select_card.dart` (garage strip tile, compact + in-service variant). Small additive fix to `TsAppBar`: its `.home` factory never actually rendered the `TsLogo` mark+wordmark, just plain text — added a `titleWidget` override. Built `lib/home/presentation/` in full: `home_state.dart` (freezed, with `HomeActiveBookingDisplay`/`HomeDraftDisplay` records pre-carrying derived display strings), `home_view_model.dart` (parallel loads + majority status-label/caption derivation per design decision 14 + draft-step derivation), 7 components (`active_booking_card`, `draft_resume_card`, `booking_cta_card`, `quick_link_tile`, `section_title_row`, `garage_add_tile`, `promo_carousel`), `home_page.dart`. Router's Beranda branch now points to `HomePage` instead of `Placeholder()`.

**Tests:** `home_view_model_test.dart` (empty/populated-derivation/expiry-warning/delete-draft, using 6 new lightweight `test/support/Fake*Repository` classes + a `NoopDemoContentSeeder` test double so the view-model tests control state directly without going through the seeder's own orchestration), `fleet_progress_test.dart`, `demo_content_seeder_test.dart` (real repos, in-memory storage), `active_booking_card_test.dart` (tap→navigate), extended `booking_repository_impl_test.dart` for `getCurrentDraft`/`deleteDraft`.

**Two real bugs found via the actual test run, fixed:**
- `HomeViewModel` wrote to `state` synchronously as the first statement inside `build()`'s call chain → Riverpod's "uninitialized provider" guard. Moved the `isLoading`-reset write into `refresh()` (always called post-build); the initial load relies on `HomeState()`'s own `isLoading: true` default.
- `DemoContentSeeder`'s scratch draft had a hardcoded `expiresAt: DateTime(2026, 9, 21)` (copied from an existing test fixture without adjusting it) — already in the past relative to any realistic "now," so `confirmBooking` silently rejected it as expired and no booking was ever created. Set to a far-future date instead (the draft is a transient object passed straight to `confirmBooking`, never itself persisted).

Also hit a missing `id_ID` locale-data init in the test environment (`bootstrap()` does this for the real app; tests need their own `initializeDateFormatting` call) — added to `home_view_model_test.dart`'s `setUpAll`.

**Verification gap flagged honestly, not glossed over:** no GUI-automation tool was available in-session for a native macOS/iOS Flutter app, and Home sits behind the login gate, so pixel-parity screenshots against the design PNGs could not be done by the agent. A `flutter run -d macos` smoke test confirmed the app builds and boots with zero runtime exception (proving the real DI graph resolves, not just under test overrides), and the user was told plainly that live verification was still needed from them.

## Review rounds

**Round 1:** the user ran the app on a real Android emulator (not macOS) and hit a genuine crash the smoke test hadn't caught: `PromoCarousel` called `MediaQuery.maybeDisableAnimationsOf(context)` from `initState()`, which Flutter's own framework assertion disallows (inherited-widget lookups aren't available before a widget's dependencies are attached). Fixed by moving the initial auto-advance schedule to `didChangeDependencies()` (also correctly re-fires if reduce-motion toggles at runtime). The user also asked whether the "Riwayat" quick-link tile duplicated the bottom-nav Riwayat tab — confirmed yes, both pushed `Routes.bookings`; removed the tile, "Katalog suku cadang" now full width. Re-ran `flutter analyze` + `dart format`, clean. Approved (commit/push explicitly left to the user).

## Key decisions worth flagging to a reviewer

- `TS-260929-0417` is still **not** a static seed row anywhere — it's created live, once, the first time `HomeViewModel` loads post-login, via real `confirmBooking()` + `advanceUnitStatus()` calls. If a future step (13–19, the real booking/tracking flow) changes `confirmBooking`'s validation or `TrackingSimulator`'s stage order, `DemoContentSeeder` could silently stop producing the canonical state — worth a quick smoke check when those steps land.
- `TrackingSimulator.advance()` also schedules its own auto-advance timer (per `DemoModeController.trackingSpeed`, default 15s) — meaning the seeded demo booking will keep organically progressing toward "Semua motor selesai" the longer the app session runs. This is existing, intentional app-wide demo behavior (not new to this step), just worth knowing when comparing a long-running session's Home screen against the design's static screenshot.
- The 1-motor/long-name and stress (360×640, text ×1.3) PRD-04 states were **not** separately verified — the screen is state-driven from real data so they should render correctly (`VehicleSelectCard` already truncates at 2 lines), but nobody has actually looked at them.
- Full on-device visual/pixel-parity verification against `design/pencil/exports/step05/*.png` still hasn't happened — only the emulator crash-fix round, which wasn't a design-parity pass.

## Output

Files touched: `lib/home/presentation/**` (new, full screen), `lib/core/presentation/components/{fleet_progress,vehicle_select_card,ts_app_bar}.dart`, `lib/core/presentation/utils/date_formatter.dart`, `lib/core/data/service/demo_content_seeder.dart` (new), `lib/core/domain/model/booking/unit_status.dart`, `lib/core/domain/repository/booking/booking_repository.dart`, `lib/booking/data/repository/booking_repository_impl.dart`, `lib/app/navigation/router.dart`, `test/home/**` (new), `test/core/presentation/components/fleet_progress_test.dart` (new), `test/core/data/service/demo_content_seeder_test.dart` (new), `test/booking/data/repository/booking_repository_impl_test.dart`, `test/support/{fake_booking_repository,fake_catalog_repository,fake_garage_repository,fake_notification_repository,fake_tracking_repository,fake_workshop_repository,noop_demo_content_seeder}.dart` (new). Not committed — staged for the user's own commit. Next step: 13 — S10 Pilih Motor.
