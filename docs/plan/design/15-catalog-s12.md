# Step 15 — S12 Katalog Suku Cadang & Oli

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | P1 |
| **Owns screens** | S12 |
| **Owns components** | (screen-local): `PartDetailSheet`, `SelectedPartsBar`, category filter row |
| **PRD refs** | [04 S12](../../../prd/04-screens.md), [03 parts rules ("Salin dari" compatibility)](../../../prd/03-user-flows.md), [05 parts](../../../prd/05-data-model-mock.md), [06 S12 row](../../../prd/06-responsive-layout.md) |
| **Pen location** | Flows row `S12` |
| **Depends on** | Steps 02–04, 07 |
| **Claude session** | `docs/claude-session/17-design-step15-catalog.md` (written after approval) |

## Goal

Design the full parts/oil browser: category filters, search, part tiles with brand/grade/price/compatibility, and a detail bottom sheet. It serves two modes — **select mode** inside the booking (syncs back to S11's active unit) and **browse mode** from Home's quick link.

## Inputs

- `PartOptionTile` (default / selected / incompatible; catalog-grid variant from step 04), `TsChip`, `SearchBar` (step 08), `SheetHeader`, `EmptyState` (search), `Skeleton`, `TsButton`.
- Rules: parts filtered by unit model category + cc; incompatible parts are explained, never silently hidden in browse mode.

## Open questions (ask at kickoff)

1. **Presentation in select mode.** PRD routes it as a sheet from S11 (`/booking/configure/parts`): full-height sheet on phone, side panel/modal on tablet?
2. **Incompatible parts in select mode** — hidden (as filtered by model) or shown disabled with "Tidak cocok untuk Beat 110"? *Recommended: shown disabled with reason, toggle "Hanya yang cocok".*
3. **Selection summary** — sticky bar "2 dipilih · Rp103.000 · Selesai".
4. **Part imagery** — no photos; category icon on tinted tile?
5. **Category set** — Oli, Kampas, Aki, Ban, … confirm the list to show in chips.

## Scope

### Frame matrix

| State | Phone | Tablet-P | Tablet-L | Dark |
|---|---|---|---|---|
| Select mode — populated (unit context header "Untuk: Beat 110", chips, search, tiles, sticky summary) | ✔ | ✔ 2-col | ✔ 3–4-col | all three |
| Browse mode — populated (no unit context, no selection) | ✔ | — | — | — |
| Loading | ✔ | — | — | — |
| Empty (filter/search returns nothing) | ✔ | — | — | — |
| Part detail bottom sheet (compatible) | ✔ | ✔ (centered modal) | — | phone |
| Part detail sheet (incompatible, reason shown) | ✔ | — | — | — |

### Layout targets (PRD 06)

Phone: 1-col list; tablet portrait: 2-col grid; tablet landscape: 3–4-col grid.

### Components built here

| Component | Notes |
|---|---|
| `PartDetailSheet` | Brand, grade, spec, price, compatibility list, add/remove CTA |
| `SelectedPartsBar` | Sticky summary + "Selesai" (glass budget ≤ 2 with other bars) |
| Category filter row | Reuses `TsChip` scroll row with scroll cue |

### Annotations to place

- Select mode: selections sync back to the active unit on S11; "Selesai" returns.
- Browse mode entry from Home quick link; no cart.
- Compatibility rule (model category + cc).

## Checklist

### Build
- [ ] Kickoff questions answered.
- [ ] All matrix states built for required breakpoints; dark defaults built.
- [ ] Compatibility conveyed with icon + text (not color alone).
- [ ] Part names/prices consistent with the S11 shortlist and the step-01 price sheet.

### Quality (automated, run in `execute`)
- [ ] Clipping check on every step frame → zero `problems`.
- [ ] Raw-hex audit → zero.
- [ ] Every node named; instances only; `placeholder` cleared.
- [ ] Coverage script: frame names match the matrix above.

### /better-interface
- [ ] Run `/better-interface` with scope = all S12 frames (names + node ids).
- [ ] Report recorded below; HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: select mode, browse mode, empty, sheet, tablet grids, dark.
- [ ] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] PNG export to `design/pencil/exports/step15/`.
- [ ] Claude session file written.
- [ ] Tracker set to ✅.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
