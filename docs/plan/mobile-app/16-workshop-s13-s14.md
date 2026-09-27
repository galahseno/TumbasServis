# Step 16 — S13 Pilih Bengkel & S14 Detail Bengkel

| | |
|---|---|
| **Status** | ⬜ Not started |
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

1. S14's two variants — one `WorkshopDetailPage` with a `variant` enum (`inFlow`/`standalone`) switching the app-bar/CTA, or two thin page wrappers around one shared body widget? Recommend one page + variant enum (matches the design's own "two variants" framing without duplicating the body).
2. `url_launcher` "Buka di Maps" — confirm the static-map asset + external intent is stubbed with a placeholder map image now (no real Maps API key per PRD 01 scope) and just needs a valid `geo:`/maps URL scheme for the intent.

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
- [ ] Open questions answered.
- [ ] S13 built for loading/empty/populated/chosen/stress; S14 built for loading/populated/populated-standalone/closed/chosen/stress.
- [ ] `/booking/workshop`, `/booking/workshop/:id`, `/workshops/:id` routes wired.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test test/workshop/` → green.
- [ ] Manual run: in-flow S13→S14→"Pilih bengkel ini" continues the draft; standalone S14 from a placeholder entry starts a fresh draft with the workshop carried.
- [ ] Screenshots vs. `design/pencil/exports/step08/*.png`.

### Review gate
- [ ] Status 🔵; show the user both screens (both S14 variants) + test results.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `026 - Create Workshop Screens (S13, S14)`.
- [ ] Claude session file written (`docs/claude-session/apps/17-mobile-step16-workshop-s13-s14.md`).
- [ ] Tracker in `00-index.md` set to ✅.

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
