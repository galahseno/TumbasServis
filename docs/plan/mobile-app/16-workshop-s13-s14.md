# Step 16 — S13 Pilih Bengkel & S14 Detail Bengkel

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-28 |
| **Layer** | Presentation, phone |
| **Priority** | S13 P0, S14 P1 |
| **Owns** | `workshop/presentation/` (S13, S14 in both in-flow and standalone variants) |
| **PRD refs** | [04 S13/S14](../../../prd/04-screens.md) |
| **Design refs** | `docs/plan/design/08-s13-s14-bengkel.md` + `docs/claude-session/design/10-design-step08-s13-s14-bengkel.md`, exports `design/pencil/exports/step08/` |
| **Depends on** | Steps 08 (`WorkshopRepository`), 13 (`BookingDraft`, for makespan-per-workshop), 10 |
| **Claude session** | `docs/claude-session/apps/17-mobile-step16-workshop-s13-s14.md` (written after approval) |

## Goal

Workshop list (search/filter/sort) and detail — S14 has two variants (in-flow from S13, standalone from S18/S20 workshop rows) that share one page with a mode flag.

## Inputs

- PRD 04 S13/S14 content/states; PRD 03 (makespan-per-workshop shown as "Estimasi N jam untuk M motor").
- Design step 08 file + session log — closed-now-stays-bookable rule, "Dipilih" tag, standalone-skips-S13 entry per PRD 03.
- `WorkshopRepository.getWorkshops({filter})/getWorkshop(id)`, `FleetDurationCalculator` (per-workshop bay count).

## Open questions (ask at kickoff)

1. S14's two variants — one `WorkshopDetailPage` with a `variant` enum (`inFlow`/`standalone`) switching the app-bar/CTA, or two thin page wrappers around one shared body widget? Recommend one page + variant enum (matches the design's own "two variants" framing without duplicating the body). **Resolved without a fresh ask** — codebase precedent (`DetailServisPage`'s variant-style branching) already answers this; built as one `DetailBengkelPage` + `WorkshopDetailVariant` enum.
2. `url_launcher` "Buka di Maps" — confirm the static-map asset + external intent is stubbed with a placeholder map image now (no real Maps API key per PRD 01 scope) and just needs a valid `geo:`/maps URL scheme for the intent. **Resolved at kickoff (2 new gaps found, both asked via `AskUserQuestion`, both recommended options chosen):**
   - `Workshop` has no lat/lng (only an address string) — "Buka di Maps" builds an address-based Google Maps search URL (`https://www.google.com/maps/search/?api=1&query=<address>`) via `url_launcher`, not a `geo:` URI.
   - `Workshop.staticMapAssetPath` points to PNGs that don't exist (no `assets/images/` folder registered), and `WorkshopPhoto` has no asset/field at all — both `StaticMap` and `WorkshopPhoto` are built as token-drawn placeholder widgets (`CustomPaint`/gradient+icon), matching the design spec's own "no `Generate`, illustration budget spent" decision. `staticMapAssetPath` is unused.

## Scope

### Files / classes to build

`workshop/presentation/di/workshop_presentation_module.dart`.

`workshop/presentation/pilih_bengkel/` — `pilih_bengkel_page.dart`, `pilih_bengkel_view_model.dart` (search, "Buka sekarang" toggle, sort), `components/workshop_card.dart`, `components/search_bar.dart`, `components/filter_chip_row.dart`, `state/pilih_bengkel_state.dart`.

`workshop/presentation/detail_bengkel/` — `detail_bengkel_page.dart` (variant-aware), `detail_bengkel_view_model.dart`, `components/static_map.dart`, `components/workshop_photo.dart`, `components/workshop_cta_bar.dart`, `state/detail_bengkel_state.dart`.

### Tests to write

- `test/workshop/presentation/pilih_bengkel/pilih_bengkel_view_model_test.dart` — "Buka sekarang" filters correctly against `FakeClock`; default sort is Terdekat; makespan estimate per workshop matches `FleetDurationCalculator`.
- `test/workshop/presentation/detail_bengkel/detail_bengkel_view_model_test.dart` — in-flow CTA → `/booking/schedule`; standalone CTA → `/booking/vehicles` with the workshop id carried and S13 skipped.

## Checklist

### Build
- [x] Open questions answered.
- [x] S13 built for loading/empty/populated/chosen/stress (WorkshopCard shows the "Dipilih" tag when chosen; the "Resmi" long-name workshop covers the stress case via `maxLines`/ellipsis); S14 built for loading/populated/populated-standalone/closed/chosen/stress.
- [x] `/booking/workshop`, `/booking/workshop/:id`, `/workshops/:id` routes wired.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test test/workshop/` → green (19/19: 9 repo + 4 `PilihBengkelViewModel` + 6 `DetailBengkelViewModel`).
- [x] `flutter test` (full suite) → green (356/356), including 2 new `BookingDraftViewModel.selectWorkshop`/reset tests.
- [x] Manual run: `flutter run -d macos` boots clean to Home with no compile/DI errors (confirms `workshopPresentationModule` wiring, the new router entries, and `BookingDraftViewModel.selectWorkshop` are sound). **Interactive click-through not done** — no GUI-automation tool available in this session to drive the native macOS window (same gap as step 15).
- [ ] Screenshots vs. `design/pencil/exports/step08/*.png`. **Not done**, same reason.

### Review gate
- [x] Status 🔵; show the user both screens (both S14 variants) + test results.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `026 - Create Workshop Screens (S13, S14)`.
- [x] Claude session file written (`docs/claude-session/apps/17-mobile-step16-workshop-s13-s14.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Review rounds

#### Round 1 — 2026-09-28
- **Shown:** file list (new `workshop/presentation/`, router + `BookingDraftViewModel.selectWorkshop`, fleshed-out `FakeWorkshopRepository`), the two kickoff decisions (Maps URL, token-drawn `StaticMap`/`WorkshopPhoto`), and test results (`flutter analyze` 0 issues, `dart format` clean, `test/workshop/` 19/19, full suite 356/356, `flutter run -d macos` clean boot).
- **Gap disclosed:** no interactive click-through or screenshot diff vs. `design/pencil/exports/step08/*.png` — no GUI-automation tool available for the native macOS window in this session.
- **User feedback:** "i test manually and approve all, do rest except commit push"
- **Changes made:** none (approved as shown; user did their own manual click-through).
- **Outcome:** approved; close steps done, commit/push held for the user.

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-28 | Kickoff | Plan mode; 3 parallel Explore agents (workshop domain/data, reusable presentation patterns, PRD/design refs); found `WorkshopRepository` has no search/sort param (client-side in the VM), `staticMapAssetPath`/photo assets don't exist, no lat/lng on `Workshop` |
| 2026-09-28 | Interview | 2 `AskUserQuestion` decisions (both recommended): Maps CTA = address-based Google Maps URL; `StaticMap`/`WorkshopPhoto` = token-drawn placeholders, ignore `staticMapAssetPath` |
| 2026-09-28 | Build | `workshop/presentation/` (di module, `pilih_bengkel/` page+VM+state+3 components, `detail_bengkel/` page+VM+state+3 components, 2 shared components, 2 utils files); `BookingDraftViewModel.selectWorkshop` added; router's 3 `Placeholder()` routes wired; `test/support/fake_workshop_repository.dart` fleshed out |
| 2026-09-28 | Fix | `PilihBengkelViewModel.build()` read `state` before an await inside the sync portion of `_load()`, called from `build()` itself → "uninitialized provider" in tests; fixed by threading `openNowOnly` as a parameter instead of reading `state` pre-await |
| 2026-09-28 | Quality | `flutter analyze` 0 issues, `dart format` clean, `flutter test test/workshop/` 19/19, full suite 356/356 (after fixing a real `RenderFlex` overflow in `PilihBengkelPage`'s empty state, caught by the existing `router_test.dart`, by wrapping it in a `SingleChildScrollView`); `flutter run -d macos` boots clean |
| 2026-09-28 | Review | User manually tested both screens end-to-end and approved; close steps done, commit/push held for the user |
