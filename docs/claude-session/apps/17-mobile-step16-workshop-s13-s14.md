# Claude Session Log — 17: Mobile-app step 16 — S13 Pilih Bengkel & S14 Detail Bengkel

**Tool:** Claude Code, model Claude Sonnet 5
**Date:** 2026-09-28
**Topic:** Workshop list (S13) and workshop detail (S14, in-flow + standalone variants) presentation screens.

## Initial prompt

"Run mobile-app step 16 — follow `docs/plan/mobile-app/16-workshop-s13-s14.md` and the workflow in `00-index.md`." (Plan mode; user asked for an interview if needed and for grepai to be used during exploration.)

## Research performed

Three parallel Explore agents:
1. Workshop domain/data layer — `Workshop` entity, `WorkshopRepository` (no search/sort param, only `openNowOnly`), `WorkshopRepositoryImpl`'s mock data (5 canonical workshops), `FleetDurationCalculator`, `BookingDraft.workshopId`, existing booking presentation conventions, route constants already declared in `routes.dart`.
2. Reusable presentation patterns — `core/presentation/components` inventory, katalog's screen conventions (Notifier view-model pattern, freezed state, search/filter wiring, bottom-sheet pattern), `detail_servis`'s glassmorphic sticky-bar and shared-draft pattern, test-fake conventions, confirmed `url_launcher` is already a pubspec dependency (unused so far).
3. PRD/design refs — full S13/S14 content from `prd/04-screens.md`, the makespan/closed-now/standalone-skip rules from `prd/03-user-flows.md`, the full approved design spec (`docs/plan/design/08-s13-s14-bengkel.md`) including the demo workshop list, canonical Jaya detail, and the `/better-interface` copy fixes; the design session log's key decisions.

Found two real gaps the step file's own open questions didn't cover: `Workshop` has no lat/lng (only an address string), and `staticMapAssetPath`/a workshop photo asset don't actually exist on disk (no `assets/images/` folder registered).

## Clarifying interview

Two `AskUserQuestion` rounds, both recommended options chosen:
1. "Buka di Maps" target — **address-based Google Maps search URL** (`https://www.google.com/maps/search/?api=1&query=<address>`) via `url_launcher`, not a `geo:` URI (no lat/lng available).
2. `StaticMap` + `WorkshopPhoto` art — **both built as token-drawn placeholder widgets** (`CustomPaint`/gradient+icon), matching the design spec's own "no `Generate`, illustration budget spent" decision; `Workshop.staticMapAssetPath` is unused.

The step file's own two open questions were resolved without a fresh ask, from existing codebase convention: one `DetailBengkelPage` + a `WorkshopDetailVariant` enum (matches `DetailServisPage`'s existing variant-branching style).

## Execution

Files written:
- `lib/workshop/presentation/di/workshop_presentation_module.dart`
- `lib/workshop/presentation/pilih_bengkel/` — `pilih_bengkel_page.dart`, `pilih_bengkel_view_model.dart`, `state/pilih_bengkel_state.dart` (+ freezed), `components/{search_bar,filter_chip_row,workshop_card}.dart`
- `lib/workshop/presentation/detail_bengkel/` — `detail_bengkel_page.dart`, `detail_bengkel_view_model.dart`, `state/detail_bengkel_state.dart` (+ freezed), `components/{static_map,workshop_photo,workshop_cta_bar}.dart`
- `lib/workshop/presentation/components/{chosen_tag,workshop_status_pill}.dart` (shared between both screens)
- `lib/workshop/presentation/utils/{workshop_status_display,workshop_maps}.dart`
- `BookingDraftViewModel.selectWorkshop(id)` added (`_persist` pattern, matching `selectMotor`/`toggleService`)
- Router: the 3 `Placeholder()` entries for `bookingWorkshop`, `bookingWorkshopDetailTemplate`, `workshopDetailTemplate` replaced with real pages
- `test/support/fake_workshop_repository.dart` fleshed out (`getWorkshop`/`getAvailableSlots` were `throw UnimplementedError()`)

Tests added: `test/workshop/presentation/pilih_bengkel/pilih_bengkel_view_model_test.dart` (4), `test/workshop/presentation/detail_bengkel/detail_bengkel_view_model_test.dart` (6), plus 2 new tests in the existing `booking_draft_view_model_test.dart` for `selectWorkshop`/standalone-reset.

One real bug caught and fixed along the way: `PilihBengkelViewModel.build()` called `_load()` synchronously, which read `state.openNowOnly` as an argument before its first `await` — since `build()` hadn't returned yet, this threw "tried to read the state of an uninitialized provider" in every test. Fixed by threading `openNowOnly` through as an explicit parameter instead of reading `state` pre-await (mirrors why `PilihMotorViewModel`/`DetailServisViewModel`'s own `_load()` never touch `state` before their first await).

A second real bug: the existing `test/app/navigation/router_test.dart` (which pumps every declared route) caught a genuine `RenderFlex` overflow in `PilihBengkelPage`'s empty state — the stepper + helper text + search bar + filter chips + result line left too little vertical room for `EmptyState`'s illustration+title+body+CTA at a compact window size. Fixed by wrapping the empty-state branch in a `SingleChildScrollView`.

Quality gates: `flutter analyze` 0 issues; `dart format --set-exit-if-changed .` clean; `flutter test test/workshop/` 19/19; full suite 356/356; `flutter run -d macos` boots clean to Home with no compile/DI errors (confirms `workshopPresentationModule` wiring and the new router entries).

Incidental cleanup: `dart format` had reformatted 7 unrelated pre-existing test files (cosmetic line-wrap only, from a dart format version difference) — reverted those to keep the diff scoped to this step's work.

## Review rounds

Round 1 (2026-09-28): shown the file list, the two kickoff decisions, and test results; disclosed the gap (no interactive click-through or screenshot diff — no GUI-automation tool available this session for the native macOS window). User did their own manual click-through and replied "i test manually and approve all, do rest except commit push". Approved as shown, no changes requested.

## Key decisions worth flagging to a reviewer

- `Workshop` truly has no lat/lng in this codebase — "Buka di Maps" is a text-search Maps URL, not a pin-drop. If a future step needs precise coordinates, the domain model will need a field added.
- `StaticMap` and `WorkshopPhoto` are permanently placeholder art (not a "fill in later" stub) per the design's own illustration-budget decision — `Workshop.staticMapAssetPath` is dead data in the mock JSON unless a later step decides to wire real assets.
- `PilihBengkelViewModel`/`DetailBengkelViewModel` both read "now" via `ref.read(clockProvider)` per call (not cached in state), matching the `home_view_model.dart` precedent — keeps open/closed status testable via `FakeClock` override without a dedicated clock field.

## Output

Files touched: see Execution above. Next step: 17 — S15 (schedule), which the in-flow CTA already targets (`Routes.bookingSchedule`, currently still a `Placeholder()`).
