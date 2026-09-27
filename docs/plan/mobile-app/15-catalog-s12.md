# Step 15 — S12 Katalog Suku Cadang & Oli

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Layer** | Presentation, phone |
| **Priority** | P1 |
| **Owns** | `catalog/presentation/` (S12, select + browse modes) |
| **PRD refs** | [04 S12](../../../prd/04-screens.md) |
| **Design refs** | `docs/plan/design/15-catalog-s12.md` + `docs/claude-session/design/17-design-step15-catalog.md`, exports `design/pencil/exports/step15/` |
| **Depends on** | Steps 07 (`CatalogRepository`), 14 (S11's "Lihat semua" link target), 10 |
| **Claude session** | `docs/claude-session/apps/16-mobile-step15-catalog-s12.md` (written after approval) |

## Goal

Build the full parts/oil browser in its two modes — select (pushed over S11, staged selection committed via "Selesai") and browse (Home quick link, no unit context) — and wire S11's "Lihat semua" placeholder to it.

## Inputs

- PRD 04 S12 content/states (staged selection, compatibility toggle, category chips, search).
- Design step 15 file + session log — staged-selection dirty-close dialog, compat block (rule line + garage rows ✓/✕), `TsSwitch` default ON behavior.
- `CatalogRepository.getParts({modelId})`.

## Open questions (ask at kickoff)

1. Staged selection hand-off back to S11 — the simplest mechanism with `go_router` is `context.push<List<String>>('/booking/configure/parts')` and awaiting the popped result; confirm this (vs. writing straight into the shared `BookingDraftViewModel` from S12, which would couple `catalog` to `booking`'s state — recommend the pushed-result approach to keep `catalog` decoupled).
2. Browse-mode entry (`/catalog`, Home quick link) — same page, a `mode` parameter switches unit-context UI on/off; confirm no separate page class is needed.

## Scope

### Files / classes to build

`catalog/presentation/di/catalog_presentation_module.dart`.

`catalog/presentation/katalog/` — `katalog_page.dart` (mode: select/browse), `katalog_view_model.dart` (search, category filter, compat toggle, staged selection set), `components/part_detail_sheet.dart`, `components/compat_row.dart`, `components/selected_parts_bar.dart`, `components/category_chip_row.dart`, `state/katalog_state.dart`.

### Content & copy notes

Category chips "Semua · Oli · Kampas rem · Busi · Aki · Ban · Filter udara", row "Hanya yang cocok untuk Beat 110", "N dipilih · Subtotal …", "Tambah ke booking" / "Hapus dari booking", dirty-close "Buang perubahan?". 14-part catalog exact prices from step 04's `parts.json`.

### Tests to write

- `test/catalog/presentation/katalog/katalog_view_model_test.dart` — compat toggle OFF shows incompatible tiles disabled with the category+cc reason; search filters by name; staged selection survives a category-chip change; "Selesai" returns exactly the staged set.

## Checklist

### Build
- [ ] Open questions answered.
- [ ] S12 built for select-populated, incompatible-shown, loading, empty, browse-populated, search-keyboard-open, detail (add/incompatible/browse), dirty-close-dialog.
- [ ] `/booking/configure/parts` and `/catalog` routes wired; S11's "Lihat semua" placeholder replaced.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test test/catalog/` → green.
- [ ] Manual run: select-mode round-trip into S11 updates its shortlist; browse-mode from Home shows no unit context.
- [ ] Screenshots vs. `design/pencil/exports/step15/*.png`.

### Review gate
- [ ] Status 🔵; show the user both modes + test results.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `025 - Create Katalog Suku Cadang Screen (S12)`.
- [ ] Claude session file written (`docs/claude-session/apps/16-mobile-step15-catalog-s12.md`).
- [ ] Tracker in `00-index.md` set to ✅.

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
