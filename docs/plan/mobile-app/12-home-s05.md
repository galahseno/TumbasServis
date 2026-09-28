# Step 12 — S05 Beranda (Home) + real AppShell wiring

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-28 |
| **Layer** | Presentation, phone |
| **Priority** | P0 |
| **Owns** | `home/presentation/` (S05), real `AppShell` Beranda-tab content |
| **PRD refs** | [04 S05](../../../prd/04-screens.md), [03 F2/F3 entry points](../../../prd/03-user-flows.md) |
| **Design refs** | `docs/plan/design/05-s05-home.md` + `docs/claude-session/design/07-design-step05-s05-home.md`, exports `design/pencil/exports/step05/` |
| **Depends on** | Steps 07 (garage/catalog data), 08 (booking data, for active/draft cards), 09 (notification unread count), 10 (shell/theme/components) |
| **Claude session** | `docs/claude-session/apps/13-mobile-step12-home-s05.md` (written after approval) |

## Goal

Build the app's entry screen: greeting, primary booking CTA, active-booking card(s), draft-resume card, promo carousel, garage strip, quick links — all wired to real repositories (no more placeholder shell content).

## Inputs

- PRD 04 S05 content/states; PRD 03 F2 (draft resume, entry points), F3 (active-booking card → S20 tap target).
- Design step 05 file + session log — 16 kickoff decisions verbatim (status-label rule, `FleetProgress` mini, stacked active-booking cards max 2, promo carousel behavior with **no** pause/play button per the design review, `DraftResumeCard` copy).
- Repositories: `GarageRepository`, `CatalogRepository` (promos), `BookingRepository` (active booking + draft), `NotificationRepository` (unread count).

## Open questions (ask at kickoff)

1. Status-label derivation (design decision 14: "label = the unit status shared by most motors, ties → earliest stage") — confirm this lives as a small pure function in `home/presentation/home_view_model.dart` or is promoted to `core/domain/service/` since S20 might reuse similar logic later (recommend: keep local to Home for now: PRD 03 explicitly says S20's derived `BookingStatus` is a *different* concept from this display label; only promote if step 22 needs the exact same function). **Answered 2026-09-28: keep local to `home_view_model.dart`, per the recommendation.**
2. Promo carousel auto-advance (5s, pause on touch/focus/hover, off under `MediaQuery.disableAnimations`) — a `PageView.builder` + `Timer.periodic`, confirm reduced-motion detection reads `MediaQuery.disableAnimationsOf(context)`. **Answered 2026-09-28: confirmed, as recommended.**
3. **(found during kickoff)** `BookingRepository` has `createDraft()`/`updateDraft()` but no way to check for an existing unexpired draft without materializing one — Home needs a non-mutating peek to decide whether to show `DraftResumeCard`. **Answered 2026-09-28: add `Future<Result<BookingDraft?>> getCurrentDraft()`** to the interface (`core/domain/repository/booking/booking_repository.dart`) + `BookingRepositoryImpl`, returning `null` if absent/expired, never creating or deleting.
4. **(found during kickoff)** The canonical populated demo state (active booking `TS-260929-0417`, 3 units; Supra X 125 draft at step 2/4) exists nowhere — not in `bookings_seed.json`, not in local storage (drafts are only ever created live, and the booking flow that would create one isn't built until steps 13–19). **Answered 2026-09-28: seed both, lazily** — add `TS-260929-0417` as a 5th row to `bookings_seed.json`; lazy-seed the Supra X 125 draft into the local draft box the first time it's found empty (mirrors the existing `_ensureSeeded()` pattern), guarded so it only fires once.
5. **(found during kickoff)** `FleetProgress` is called out by the design as reused/extended by S20 (tracking, step 22) — not home-specific. Home-local component or `core/presentation/components/`? **Answered 2026-09-28: `core/presentation/components/fleet_progress.dart`**, same precedent as `UnitStatusBadge`.

## Scope

### Files / classes to build

`home/presentation/di/home_presentation_module.dart` — `homeViewModelProvider`.

`home/presentation/home/` — `home_page.dart` (rendered inside `AppShell`'s Beranda slot), `home_view_model.dart` (loads garage + active booking + draft + promos + unread count in parallel), `state/home_state.dart` (loading/empty/populated + the derived fields: status label, caption).

`home/presentation/home/components/` — `active_booking_card.dart`, `draft_resume_card.dart`, `booking_cta_card.dart` (compact/hero), `quick_link_tile.dart`, `section_title_row.dart`, `garage_add_tile.dart`, `promo_carousel.dart`.

### Content & copy notes

"Halo, Galah 👋", "Booking servis motor" / "Mulai booking", "Servis banyak motor, sekali booking.", "Garasi saya" / "Lihat semua", "Katalog suku cadang" — verbatim from the design's canonical demo content (booking `TS-260929-0417`, "3 motor · Dikerjakan", "1 motor masih Diperiksa" — lower-case per design step 19's fix F9). **Review-round fix:** the "Riwayat" quick link was dropped (full width now, "Katalog suku cadang" only) — it pushed the exact same `Routes.bookings` route as the bottom-nav Riwayat tab, a redundant duplicate entry point the design doc's PRD-04 wireframe didn't actually call for as a distinct destination.

### Tests to write

- `test/home/presentation/home/home_view_model_test.dart` — empty state (no active booking, no draft); populated state derives the correct status label + caption from the canonical 3-unit booking (A/B Dikerjakan, C Diperiksa → "3 motor · Dikerjakan" + caption); draft-expiry warning color switches under 3h (`FakeClock`).
- Widget test: tapping the active-booking card navigates toward `/bookings/:id` (S20 route — even if S20 itself is a placeholder until step 22, verify the navigation *intent* fires).

## Checklist

### Build
- [x] Open questions answered (2 original + 3 found during kickoff, see above).
- [x] S05 built for loading/empty/populated, state-driven from real repositories (not separate hardcoded frames — the 1-motor/long-name case renders correctly whenever the garage has 1 motor, `VehicleSelectCard` already truncates at 2 lines; **not separately verified**: the 360×640 and text-×1.3 stress frames).
- [x] `AppShell` Beranda slot now renders real content (`HomePage`); other 3 tabs remain placeholders.
- [x] Bell badge reflects real unread count from `NotificationRepository.watchUnreadCount()`.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test test/home/ test/core/presentation/components/fleet_progress_test.dart test/core/data/service/demo_content_seeder_test.dart test/booking/` → 31 passed, 0 failed.
- [ ] Manual run + screenshot comparison vs. `design/pencil/exports/step05/*.png` — **not done**: no GUI-automation tool available in this session for a native macOS/iOS Flutter app, and Home sits behind the login gate. Did smoke-test `flutter run -d macos` — builds and boots with no runtime exception, confirming the DI graph (incl. the new `demoContentSeederProvider`/`homeViewModelProvider`) resolves for real, not just under test overrides. Actual pixel-parity check is left for the user (or a follow-up session with device/simulator screenshot tooling).

### Review gate
- [x] Status 🔵; show the user the screen (all states) + test results.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `022 - Create Home Screen`.
- [x] Claude session file written (`docs/claude-session/apps/13-mobile-step12-home-s05.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Review rounds

#### Round 1 — 2026-09-28
- **Shown:** file list, quality-gate results (analyze/format/31 tests), the `flutter run -d macos` boot smoke-test.
- **User feedback:** ran it live on an Android emulator and hit a crash: `PromoCarousel` called `MediaQuery.maybeDisableAnimationsOf(context)` from `initState()` (inherited-widget lookup before the widget's dependencies are available) — Flutter's own assertion caught it. Then asked whether the "Riwayat" quick-link tile duplicates the bottom-nav Riwayat tab.
- **Changes made:** moved the initial auto-advance schedule from `initState()` to `didChangeDependencies()` in `promo_carousel.dart` (also correctly re-fires if reduce-motion toggles at runtime). Confirmed "Riwayat" quick link pushed the identical `Routes.bookings` route as the bottom-nav tab — removed it, "Katalog suku cadang" now full width.
- **Outcome:** approved (commit/push left to the user).

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-28 | Kickoff | Read step file, design step 05 doc + session log, 4 phone-scope PNGs (populated/empty/loading/component sheet — tablet+dark skipped, out of scope). Explore agent mapped domain models, repos, DI patterns, router, AppShell. Found 3 real gaps beyond the file's own 2 open questions (draft peek, demo-data materialization, `FleetProgress` placement); resolved via `AskUserQuestion`, all recommended options accepted. |
| 2026-09-28 | Course correction | Found `BookingRepositoryImpl._ensureCountersSeeded()`'s comment + the existing `confirmBooking` test proving `TS-260929-0417` is a **reserved** code meant to come from a live walkthrough, not a static seed row — contradicted the just-approved plan. Re-confirmed with the user: seed programmatically (`confirmBooking` + `TrackingRepository.advanceUnitStatus`), not as static JSON. |
| 2026-09-28 | Domain/data | Added `BookingRepository.getCurrentDraft()` (non-mutating peek) and `.deleteDraft()`; added `UnitStatus.stageIndex`; new `core/data/service/demo_content_seeder.dart` (`DemoContentSeeder`, wired from `home_presentation_module.dart` since it needs both `BookingRepository` + `TrackingRepository`, avoiding a core→feature dependency inversion). |
| 2026-09-28 | Presentation | New `core/presentation/components/fleet_progress.dart`, `vehicle_select_card.dart`; small additive fix to `TsAppBar` (`titleWidget`, so `.home` shows the real `TsLogo` instead of plain text — the original factory never actually supported the logo). Built `home/presentation/` in full: state, view model (majority status-label + caption derivation, draft-step derivation, expiry), 7 components, page; wired into `router.dart` replacing the Beranda `Placeholder()`. |
| 2026-09-28 | Tests | `home_view_model_test.dart` (empty/populated/expiry/delete), `fleet_progress_test.dart`, `demo_content_seeder_test.dart`, `active_booking_card_test.dart` (tap→navigate), extended `booking_repository_impl_test.dart`. Found + fixed 2 real bugs via the actual test run: (1) `HomeViewModel` wrote to `state` synchronously inside `build()` → Riverpod "uninitialized provider" crash; (2) `DemoContentSeeder`'s scratch draft had a hardcoded past `expiresAt` → silently rejected as expired by `confirmBooking`. Also hit a missing `id_ID` locale-data init in the test env (added `initializeDateFormatting` to `setUpAll`). Final run: `flutter analyze` clean, `dart format` clean, 31/31 tests green, layer-direction check clean (matches the existing DI-provider-import pattern). |
| 2026-09-28 | Review round 1 | User ran it on a real Android emulator, hit a real crash `initState()`-time `MediaQuery` lookup in `promo_carousel.dart` — fixed by moving the initial schedule to `didChangeDependencies()`. User also asked whether "Riwayat" quick link duplicated the bottom-nav tab; confirmed yes (both `Routes.bookings`), removed it, "Katalog suku cadang" now full width. Re-ran `flutter analyze` + `dart format` clean. Approved; commit/push left to the user. |
