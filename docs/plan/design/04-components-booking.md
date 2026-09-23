# Step 04 — Booking components

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | — (foundation for P0 booking flow) |
| **Owns screens** | — |
| **Owns components** | `VehicleTabChip`, `VehicleSelectCard`, `ServiceOptionTile`, `PartOptionTile`, `WorkshopCard`, `SlotChip`, `DateStripItem`, `BookingStepper`, `StickyEstimateBar`, `PriceBreakdown`, `TicketCard`, `PromoBanner`, `VoucherCard` |
| **PRD refs** | [02](../../../prd/02-brand-design-system.md) (inventory, glass), [03](../../../prd/03-user-flows.md) (business rules: limits, compatibility, capacity, voucher eligibility), [04](../../../prd/04-screens.md) (S10–S18 content) |
| **Pen location** | `02 Components` row → Booking group |
| **Depends on** | Steps 01–03 |
| **Claude session** | `docs/claude-session/06-design-step04-components-booking.md` (written after approval) |

## Goal

Build the domain-specific components that make the multi-vehicle booking flow work, with every state the business rules imply, so screens in steps 05–11 are pure composition (instances only). Includes the three motor-category silhouettes used by `VehicleSelectCard` and garage cards.

## Inputs

- Step 03 components (chips, buttons, badges) — booking components nest them as instances.
- Business rules in PRD 03: 5-motor cap, disabled "Sedang dalam servis", incompatible parts, slot capacity (`limited` ≤ 2 remaining, `full`), voucher eligibility reasons, makespan duration.
- Demo content sheet from step 01.

## Open questions (ask at kickoff)

1. **`VehicleTabChip` overflow.** With up to 5 units, chips scroll horizontally on phone — show a fade/peek cue so scrollability is visible (skill trigger: content behind a scroll edge without cue). Confirm chip label = motor nickname (ellipsis at ~12 chars) + status glyph.
2. **`TicketCard` perforation.** Cut-out notches via layered ellipses in the page background color vs a dashed divider only? Notches need the bg token; check dark mode works.
3. **`PriceBreakdown` density.** Per-unit collapsible groups or always-expanded on S16? (Recommended: collapsible per unit, total always visible.)
4. **`StickyEstimateBar`.** Duration format ("2 j" vs "±2 jam") and whether the CTA sits inside the glass bar. PRD wireframe: `Est. Rp412.000 · 2j [Lanjut]` inside.
5. **Silhouettes.** Generate 3 category silhouettes (matic / bebek / sport) as `Generate svg` (budget 3 of the ≈11) — approve style on the first before generating the other two.
6. **`PromoBanner`.** Gradient/illustration only, no photos; 3–4 banner variants (voucher, multi-motor, service reminder).
7. **Service selection model.** PRD wireframe draws radio tiles, yet S16 recaps "Servis Berkala + Oli" (several services per unit) and the rules only require ≥ 1 service. Confirm checkbox-style multi-select as the default, with radio kept for any mutually exclusive group. (Step 07 depends on this.)

## Scope

### Components and variants

| Component | Variants / states |
|---|---|
| `VehicleTabChip` | complete (✓) / active (●) / incomplete (○) / error; icon + text so state is never color alone; scroll-cue wrapper variant; **rail-row variant** (vertical list row, same four states) for S11 at expanded/large widths |
| `VehicleSelectCard` | Mode **select**: unselected / selected (checkbox, `border-accent`) / disabled with reason "Sedang dalam servis" / disabled "Maks. 5 motor". Mode **display** (garage list/grid, tap → detail; used by S07, S08 preview). Mode **compact** (Home garage strip; S05). Silhouette or photo slot with aspect-ratio box; nickname, plate, model with ellipsis |
| `ServiceOptionTile` | default / selected / disabled; name, price (Estimasi), duration; `requiresComplaint` hint; **radio-style and checkbox-style** selection variants (decided at kickoff Q7) |
| `PartOptionTile` | checkbox-style default / selected / incompatible (reason); brand, grade, price; compact (S11 shortlist) and catalog-grid variants (shared with step 15) |
| `WorkshopCard` | name, rating, distance, open/closed badge, bay-capacity hint; default / selected (tablet list-detail) ; photo slot placeholder |
| `SlotChip` | available / limited (low capacity, remaining count) / full (disabled, not color-only) / selected |
| `DateStripItem` | default / selected / today; weekday + day number |
| `BookingStepper` | 4 steps ① Motor ② Servis ③ Bengkel & Jadwal ④ Ringkasan; step state done / current / upcoming; compact phone + wide tablet variants; completion-badge slot (S11 "2/3 ✓") |
| `StickyEstimateBar` | glass bar: total price + duration + CTA; states: default, CTA disabled (with reason line), loading (recomputing), error; sits above bottom inset |
| `PriceBreakdown` | line items (label, qty, price), per-unit subtotal, fleet subtotal, voucher discount line (success-colored + icon), total; collapsed-unit / expanded-unit; invoice variant reused by S23 |
| `TicketCard` | perforated-edge ticket with QR slot, booking code, per-unit sub-rows with `UnitStatusBadge`, workshop + schedule recap; phone and tablet-landscape variants (ticket left / units right) |
| `PromoBanner` | carousel card: gradient/illustration + CTA + page dots; 3 content variants |
| `VoucherCard` | eligible (selectable, selected) / ineligible (disabled + specific reason e.g. "Butuh min. 2 motor") |

### Illustrations

| Asset | Notes |
|---|---|
| Motor silhouettes ×3 | matic / bebek / sport; single-color line/flat in palette, used by `VehicleSelectCard`, garage cards, S09 hero |

### Annotations to place

- Scroll cue and snap behavior for `VehicleTabChip` and `DateStripItem`.
- `StickyEstimateBar`: keyboard inset behavior, glass fallback.
- `TicketCard`: QR encodes booking code; min QR size for scan.
- Semantics: selected/disabled announcement text for cards and chips.

## Checklist

### Build
- [ ] Kickoff questions answered.
- [ ] All 13 components built with every listed state, light + dark, tokens only.
- [ ] Nested instances of step-03 components (badges, chips, buttons) — no re-drawn copies.
- [ ] Silhouettes generated and componentized.
- [ ] Every text element uses the Type-board reusable roles; long strings tested (long nickname, long workshop name, 3-line complaint) with ellipsis/wrap.
- [ ] Component sheet per group with a realistic populated example built from the demo-content sheet.
- [ ] 48dp targets verified; status/eligibility never conveyed by color alone.

### Quality (automated, run in `execute`)
- [ ] Clipping check on every component sheet → zero `problems`.
- [ ] Raw-hex audit → zero.
- [ ] Stress instances: 360-wide container, text scale ×1.3 for `VehicleSelectCard`, `PriceBreakdown`, `TicketCard` → no clipping.
- [ ] Every node named; overrides addressable by unique names.

### /better-interface
- [ ] Run `/better-interface` with scope = Booking component sheets (names + node ids).
- [ ] Focus on Accessibility (states, targets, semantics), Layout (grouping, alignment, reading order inside cards), Color (status/eligibility), UI polish (concentric radius, glass, perforation).
- [ ] Report recorded below; HIGH/MEDIUM fixed; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: select card states, chips/strip, stepper, estimate bar, price breakdown, ticket, voucher, silhouettes.
- [ ] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] PNG exports to `design/pencil/exports/step04/`.
- [ ] Claude session file written.
- [ ] Tracker set to ✅.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
