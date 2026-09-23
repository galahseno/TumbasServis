# Step 08 — S13 Pilih Bengkel + S14 Detail Bengkel

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | S13 P0 · S14 P1 |
| **Owns screens** | S13, S14 |
| **Owns components** | (screen-local): `SearchBar`, `FilterChipRow`, static-map placeholder, `WorkshopInfoBlock` |
| **PRD refs** | [04 S13/S14](../../../prd/04-screens.md), [03 F2 entry points](../../../prd/03-user-flows.md), [05 workshops](../../../prd/05-data-model-mock.md), [06 S13/S14 rows](../../../prd/06-responsive-layout.md) |
| **Pen location** | Flows rows `S13`, `S14` |
| **Depends on** | Steps 02–04 |
| **Claude session** | `docs/claude-session/10-design-step08-s13-s14-bengkel.md` (written after approval) |

## Goal

Design workshop choice for the whole booking (S13) and the pre-commit detail view with static map (S14), including the tablet **list-detail split** where S14 content is the right pane of S13.

## Inputs

- `WorkshopCard`, `TsChip` (filters), `TsTextField` (search), `BookingStepper` (step 3/4), `EmptyState` (no results), `Skeleton`, `TsAppBar`, `TsButton`.
- Workshops are fictional, Yogyakarta-area, with rating, hours, bay count, distance, static-map asset reference (PRD 05).
- Business rule: from S14 "Booking di sini" → S15; from a carried-forward workshop S13 is skipped.

## Open questions (ask at kickoff)

1. **Static map look.** Options: (a) stylized map made from shapes + pin icon; (b) `Generate ai` map-style image (raster); (c) plain labelled placeholder. Flutter will ship 8–10 static assets — which fidelity should the design promise? *Recommended (b) for one representative asset, reused.*
2. **S14 CTA label.** PRD says "Booking di sini" while inside the booking flow it selects the workshop for the draft — keep the PRD label or use "Pilih bengkel ini"? 
3. **Filters.** PRD chips: Buka sekarang · Rating tertinggi · Terdekat — multi-select or single sort + toggle? Show sort semantics (sort vs filter) visually?
4. **Bay capacity hint** wording on `WorkshopCard` ("3 bay · antrean ringan"?) and whether it depends on the number of units chosen.
5. **Open/closed** badge must not rely on color alone — approve icon + text ("Buka · tutup 17.00" / "Tutup").
6. **S14 photo** — aspect-ratio gradient placeholder with initials, consistent with the imagery decision?

## Scope

### Frame matrix

| Screen · State | Phone | Tablet-P | Tablet-L | Dark |
|---|---|---|---|---|
| S13 Loading | ✔ | ✔ | ✔ | phone |
| S13 Empty (filter returns none) | ✔ | ✔ | ✔ | phone |
| S13 Populated (search + filters + 5 cards) | ✔ | ✔ | ✔ list-detail with S14 pane populated | phone + both tablets |
| S13 Populated, a card selected (tablet list-detail highlight) | — | — | ✔ (same as above; selected card shown) | — |
| S14 Loading | ✔ | ✔ | ✔ (as pane) | phone |
| S14 Populated (photo, name/rating/hours, map + "Buka di Maps", services, address, CTA) | ✔ | ✔ | ✔ standalone: map/photo left, info right | phone + both tablets |
| S14 Closed workshop variant (CTA still enabled? behavior noted) | ✔ | — | — | — |
| Stress: 360×640 (S13 populated, S14 populated) | ✔ | — | — | — |

### Layout targets (PRD 06)

- S13 phone/tablet-P: single column list (tablet max-width 720). Tablet-L: list left, S14 content right (list-detail).
- S14 phone/tablet-P: stacked sections (tablet max-width 720). Tablet-L: map/photo left, info right.

### Components built here

| Component | Notes |
|---|---|
| `SearchBar` | Uses `TsTextField` with search icon, clear affordance |
| `FilterChipRow` | Scrollable row of `TsChip` filters with scroll cue |
| Static-map placeholder | Rounded aspect-ratio box + pin + "Buka di Maps" action |
| `WorkshopInfoBlock` | Hours table, services offered (chips), address with copy/open action |

### Content & copy

- Title "Pilih Bengkel"; S14 "Detail Bengkel". Bengkel Jaya Motor is the demo winner; other workshops fictional (e.g. Bengkel Sinar Roda, Motor Care Kotagede).
- Address, hours, "Buka di Maps" (external intent via `url_launcher`).

### Annotations to place

- Entry/exit: S13 card → S14; S14 CTA → S15; workshop carried forward from other entry → S13 skipped.
- List-detail behavior at expanded/large; selection persists.
- Static map is an asset, no API key; external maps intent.
- Semantics: workshop card announces name, rating, distance, open state.

## Checklist

### Build
- [ ] Kickoff questions answered.
- [ ] S13 states for required breakpoints; S14 states for required breakpoints; dark copies.
- [ ] Tablet-L list-detail composed with the S14 pane as instances (no redrawn pane).
- [ ] Open/closed and rating shown with icon + text.
- [ ] Static-map placeholder consistent across cards/pane.
- [ ] Stress frames built and clean; long workshop names / addresses ellipsize or wrap.

### Quality (automated, run in `execute`)
- [ ] Clipping check on every step frame → zero `problems`.
- [ ] Raw-hex audit → zero.
- [ ] Every node named; instances only; `placeholder` cleared.
- [ ] Coverage script: frame names match the matrix above.

### /better-interface
- [ ] Run `/better-interface` with scope = all S13 + S14 frames (names + node ids).
- [ ] Report recorded below; HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: S13 list (phone), empty, tablet-L list-detail, S14 phone + standalone landscape, dark.
- [ ] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] PNG export to `design/pencil/exports/step08/`.
- [ ] Claude session file written.
- [ ] Tracker set to ✅.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
