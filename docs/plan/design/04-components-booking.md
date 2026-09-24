# Step 04 — Booking components

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-24 |
| **Priority** | — (foundation for P0 booking flow) |
| **Owns screens** | — |
| **Owns components** | `VehicleTabChip`, `VehicleSelectCard`, `ServiceOptionTile`, `PartOptionTile`, `WorkshopCard`, `SlotChip`, `DateStripItem`, `BookingStepper`, `StickyEstimateBar`, `PriceBreakdown`, `TicketCard`, `PromoBanner`, `VoucherCard`; added at kickoff: `TsCheckbox`, `TsRadio`, `TicketUnitRow` (moved from step 11), `PageIndicator` (moved from step 13) |
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

## Kickoff decisions (answered 2026-09-24, interview with the user; every recommended option accepted)

Four `AskUserQuestion` rounds; the seven original open questions plus six found while planning.

| # | Question | Answer |
|---|---|---|
| 1 | Export scope ("only keep what I need from the previous plan") | PNG export and the html2figma test import cover **only the new step 04 sheets** (6 light + 6 dark). Steps 02–03 sheets are not re-exported. Test import = 6 light sheets + the dark Selection sheet as HTML (one frame per file); the user checks the flattened look, *Combine as variants* on `VehicleSelectCard`, one nested override |
| 2 | Service selection model (old Q7) | `ServiceOptionTile` default = **checkbox multi-select** (≥ 1 service required; matches `BookingUnit.serviceIds[]` and the seed booking with `svc_berkala` + `svc_oli`); radio variant also built for any exclusive group. Step 07 builds S11 on this |
| 3 | Selection glyphs | New shared masters **`TsCheckbox`** and **`TsRadio`** (unchecked / checked / disabled, 48dp target, focus ring by override). Flutter: themed `Checkbox` / `Radio` wrappers; appended to *Inventory additions* in `00-index.md` |
| 4 | `BookingStepper` phone | Numbered circles joined by a line + **one caption row** (`Langkah 2 dari 4 · Servis`) with the completion badge (`2/3 ✓`) right-aligned; never truncates. Wide / tablet variant shows all four labels inline |
| 5 | `StickyEstimateBar` layout (old Q4) | Two-line left (`Estimasi · 1 jam` Body Small `text-body`, `Rp228.000` Title Large) + **Lanjut CTA right**, inside the glass bar. Full word "jam", no "±". CTA-disabled state adds a reason line ("Pilih layanan untuk Vario 125") |
| 6 | Glass tint | Standard **42 %** `glass-tint`. Text contrast is measured over the S11 worst-case backdrops (accent-soft tile, selected accent border, sand card) in both themes; a mode below 4.5 : 1 falls back to `glass-tint-strong` and is logged in `prd/02` |
| 7 | `PriceBreakdown` density (old Q3) | **Collapsible per unit** (row = name + subtotal + chevron); S16 default all collapsed; fleet subtotal, voucher line (success + icon) and total always visible; S23 invoice variant all expanded |
| 8 | `VehicleTabChip` overflow (old Q1) | Horizontal scroll + **24dp fade edge** (`bg-page` gradient) + a half-visible chip; label = nickname (ellipsis ~12 chars) + status glyph; rail-row variant for expanded / large |
| 9 | `TicketCard` perforation (old Q2) | **Two notches (ellipses, fill `bg-page`) + dashed `border-default` line**; the ticket is only ever placed on `bg-page` (annotated) |
| 10 | Ticket scope vs step 11 | `TicketCard` and **`TicketUnitRow`** are built here with a **QR slot placeholder tile** (`qr_code_2` icon, ≥ 160dp, quiet zone). Step 11 keeps `SuccessHeader` + the real `QrCode` pattern. `TicketUnitRow` moves from step 11 to this step |
| 11 | Silhouettes (old Q5) | 3 × `Generate(svg)` (matic first → user approves style → bebek, sport). **Two-tone, token-bound**: every fill snapped to semantic tokens so the art flips with the theme, on a `surface-inset` tile (unlike the step 03 sticker illustrations, these are ≤ 96dp and sit in every garage card). No new token expected; if one is needed it is added and logged |
| 12 | `PromoBanner` (old Q6) | **Tonal `accent-soft` gradient** (token stops), decor circles + a Material icon, `text-on-accent-soft`, accent CTA. 3 variants: voucher / multi-motor / service reminder. No `Generate` budget spent |
| 13 | `SlotChip` states | **5 states**: available / limited (`Sisa 2`) / **short** (remaining < unit count, disabled, icon + `Sisa 1`) / full (`Penuh`, disabled) / selected. Step 09's capacity banner explains `short` |
| 14 | `WorkshopCard` layout | Thumb left (80×80 aspect-ratio placeholder), text right (name, ★ 4,8 · 1,2 km, Buka / Tutup badge, `2 bay servis`); default / closed / selected (`border-accent`) |
| 15 | Sample motors | **Sheet-only samples**: Supra X 125 (bebek, AB 3344 KL) and Ninja 250 (sport, AB 7788 MN), for the silhouettes and the in-service / max-5 states. Canonical demo content (3 matics) is unchanged |
| 16 | Mark position | Leading on `ServiceOptionTile` / `PartOptionTile`; trailing on `VehicleSelectCard` / `VoucherCard` |

Defaults applied without a question: variant modeling as step 03 (masters for states screens use, pressed / focused are sheet overrides); `PageIndicator` built here for `PromoBanner` (moved from step 13); part tiles use a category icon tile, no photo; open / closed and compatibility badges are sub-masters inside their component (no `TsBadge` in the inventory); `DateStripItem` today = `Hari ini` caption + dot; `VoucherCard` eligible shows the computed saving ("Hemat Rp42.800"); selected + focused card = 2dp `focus-ring` outside the `border-accent` border; disabled recipe reused from `TsChip` Disabled; sentence case.

## Scope

### Components and variants

| Component | Variants / states |
|---|---|
| `TsCheckbox` / `TsRadio` (added) | unchecked / checked / disabled (+ disabled checked); 48dp target around a 24dp glyph; focus ring by override; shared by the four selectable components below |
| `VehicleTabChip` | complete (✓) / active (●) / incomplete (○) / error; icon + text so state is never color alone; scroll-cue wrapper variant (24dp `bg-page` fade + half-visible chip); **rail-row variant** (vertical list row, same four states) for S11 at expanded/large widths |
| `VehicleSelectCard` | Mode **select**: unselected / selected (trailing `TsCheckbox`, `border-accent`) / disabled with reason "Sedang dalam servis" / disabled "Maks. 5 motor". Mode **display** (garage list/grid, tap → detail; used by S07, S08 preview). Mode **compact** (Home garage strip; S05). Silhouette tile with aspect-ratio box; nickname, plate, model with ellipsis |
| `ServiceOptionTile` | default / selected / disabled; name, price (Estimasi), duration; `requiresComplaint` hint slot; **checkbox-style (default) and radio-style** variants, leading mark |
| `PartOptionTile` | checkbox-style default / selected / incompatible (reason); brand, grade, price, category icon tile; compact (S11 shortlist) and catalog-grid variants (shared with step 15) |
| `WorkshopCard` | thumb left (80×80 placeholder), name, rating, distance, open/closed badge, `2 bay servis`; default / closed / selected (tablet list-detail) |
| `SlotChip` | available / limited (`Sisa 2`) / **short** (remaining < units, disabled) / full (`Penuh`, disabled, not color-only) / selected |
| `DateStripItem` | default / selected / today / today + selected; weekday + day number, `Hari ini` caption + dot on today |
| `BookingStepper` | 4 steps ① Motor ② Servis ③ Bengkel & Jadwal ④ Ringkasan; step state done / current / upcoming; phone = circles + one caption row, wide = all 4 labels inline; completion-badge slot (S11 "2/3 ✓") |
| `StickyEstimateBar` | glass bar (42 % `glass-tint`): two-line `Estimasi · 1 jam` / `Rp228.000` + Lanjut CTA; states: default, CTA disabled (with reason line), loading (recomputing), error; sits above bottom inset |
| `PriceBreakdown` | per-unit row (name, subtotal, chevron) collapsible to line items (label, qty, price), fleet subtotal, voucher discount line (success-colored + icon), total, `Estimasi 2 jam`; collapsed-unit / expanded-unit; S16 (with / without voucher), invoice variant reused by S23, sticky-pane variant for tablet |
| `TicketCard` | perforated ticket (two `bg-page` notches + dashed line) with QR slot placeholder tile, booking code, `TicketUnitRow`s (nested `UnitStatusBadge`), workshop + schedule recap; phone and tablet-landscape variants (ticket left / units right) |
| `TicketUnitRow` (moved from step 11) | motor name, unit code (-A), service summary (ellipsis), `UnitStatusBadge` |
| `PromoBanner` | carousel card: tonal `accent-soft` gradient + decor circles + icon + CTA; 3 content variants (voucher / multi-motor / service reminder) |
| `PageIndicator` (moved from step 13) | dots with active pill; announced position "Slide 1 dari 3"; used by the promo carousel here, onboarding in step 13 |
| `VoucherCard` | eligible (selectable, selected, shows "Hemat Rp42.800") / ineligible (disabled + specific reason e.g. "Butuh min. 2 motor"); trailing `TsRadio` |

### Illustrations

| Asset | Notes |
|---|---|
| Motor silhouettes ×3 | matic / bebek / sport; two-tone flat, every fill snapped to semantic tokens (theme-aware, on a `surface-inset` tile), used by `VehicleSelectCard`, garage cards, S09 hero. Sheet samples: Supra X 125 (bebek), Ninja 250 (sport) |

### Annotations to place

- Scroll cue and snap behavior for `VehicleTabChip` and `DateStripItem`.
- `StickyEstimateBar`: keyboard inset behavior, glass fallback.
- `TicketCard`: QR encodes booking code; min QR size for scan.
- Semantics: selected/disabled announcement text for cards and chips.

## Built sheets (node ids, `design/pencil/TumbasServis.pen`)

Components row: light sheets at y 8760, x 8160 / 9520 / 10880 / 12240 / 13600 / 14960; dark copies (`… · Dark`, `theme:{mode:"dark"}`) at y 12380 under the existing dark header `AEaD0`; stress frame at x 16320. Flows anchors unchanged (y 16000 / 18400). One new variable, `bg-page-clear` (149 total). **95 reusable masters**, 2,399 nodes. The plan said five sheets; the Progress sheet was split in two (Progress & estimate / Price breakdown) to stay under the 3,400 dp row budget.

| Sheet | Light | Dark copy | Masters |
|---|---|---|---|
| Selection & vehicles | `OF26X` | `v283S` | `TsCheckbox` 4, `TsRadio` 4, `VehicleTabChip` 4 + rail 4, `VehicleTabRow` 2 (none / scroll), `VehicleSelectCard` 6 (select ×4, display, compact), `Silhouette` 6 (matic / bebek / sport × hero 96 / card 64) |
| Service & parts | `j22LU` | `Lg2YY` | `ServiceOptionTile` 6 (checkbox / radio × default / selected / disabled), `PartOptionTile` 6 (compact / grid × default / selected / incompatible) |
| Workshop & schedule | `CVceb` | `gKq4G` | `WorkshopCard` 3, `SlotChip` 5, `DateStripItem` 4, `DateStrip` scroll specimen 1 |
| Progress & estimate | `sxv4p` | `bHz7a` | `BookingStepper` 8 (phone / wide × step 1–4), `StickyEstimateBar` 4 (default / CTA disabled / loading / error) |
| Price breakdown | `cO90T` | `G9VE8` | `PriceBreakdown` 5 (summary ± voucher, summary expanded, invoice, pane) + parts: line, unit ×3 (collapsed / expanded / static), summary, voucher, total, note rows |
| Ticket & promo | `cfNYX` | `npuQi` | `TicketUnitRow`, `TicketCard` 2 (phone / landscape) + units panel + perforation ×2, `PageIndicator` 3, `PromoBanner` 3, `VoucherCard` 3 |
| Stress ×1.3 (360 wide) | `d13If` | — | 12 instances (select cards, tab row, stepper, both estimate bars, price breakdown, voucher, service tile, part tile, ticket, workshop) with every text node ×1.3 |

Build decisions made while building (all inside the kickoff decisions unless marked):
- **Silhouettes:** matic (3 nodes) approved by the user first, then bebek (31) and sport (71). Each generation is snapped by luminance: dark → `text-body`, light highlights → `surface-inset`, orange → `accent`; the backing rectangle is deleted and the art centered. The Card size (64) is the same art scaled ×0.65 (path `x / y / width / height`), so one generation gives both sizes. Tile radius `radius-sm` (concentric inside a 16 dp card with 12 dp padding).
- **Glass (decision 6, measured):** `text-heading` is ≥ 7.4 : 1 (light) / ≥ 4.7 : 1 (dark) over every S11 worst-case backdrop, including a solid accent fill; `text-body` would be 4.3 : 1 / 2.9 : 1. So the bar uses `text-heading` only, the 42 % tint stays in both themes and **no fallback to `glass-tint-strong` is needed** (recorded in `prd/02`). The sheen is two 1 px flow rows (not absolute layers) so the bar has no fixed height.
- **New token `bg-page-clear`** (`sand-50 @ 0 %` / `sand-950 @ 0 %`): transparent end of the 24 dp scroll-edge fade (tab chips, date strip). Gradient stops accept variables; alpha needs its own token.
- **Tab chips overflow earlier than planned:** three chips with 9-character nicknames need about 354 dp (328 available), so even the canonical 3-unit story scrolls with the third chip peeking. `Overflow=None` shows two units.
- **Disabled reason lives in its own row** under the card / tile (`Reason Row`), not inside the text column, so it survives text ×1.3 (found by the stress frames).
- **`TicketCard` notches are `Decor` ellipses** (fill `bg-page`, half outside the card), so they are exempt from the clipping audit; the dashed tear line is a row of 22 / 34 rectangles (Pencil has no stroke dash).
- **Ticket sheet layout:** the composite (ticket left + units panel right) is a specimen built from instances; the panel is its own master (`TicketCard Units Panel`).
- **Amended in step 11 (2026-09-24):** `TicketCard` (Phone `FgxE2`, Landscape `kHGZP`) gets a `Code Row` (booking code + 48 dp `Copy Button`, `TsIconButton` with `content_copy`), the real `QrCode` master instead of the `qr_code_2` placeholder tile, and `fill_container` Workshop / Schedule rows so long strings wrap; `TicketUnitRow` gets an `enabled:false` `Slot Line` (split-schedule slot). New masters live on the step 11 "Ticket & success" sheet: `TicketCard` Loading (Phone / Landscape) and `TicketCard Units Panel / State=Loading`. Decision 10 above (QR slot placeholder) is superseded.

## Figma test import (user-run)

Second Route B checkpoint (first was step 01). **Scope trimmed at kickoff (decision 1): only the new step 04 sheets** — steps 02–03 are not re-exported. After the components pass the automated checks, Claude exports the 6 light sheets plus the dark Selection sheet to HTML (`html-css`, one frame per file, `design/pencil/exports/html/step04/`), pre-checks each in Chromium, and the user drags them into html2figma in a scratch Figma Draft and sends screenshots: how the flattened components look · one variant group turned into a component set by hand with *Combine as variants* (e.g. `VehicleSelectCard` modes/states) · a nested instance and its override. Claude scores against the step 01 table, then records drift and any new rules in the *Figma-plugin compatibility* section of [`00-index.md`](00-index.md#figma-plugin-compatibility). Rule violations are fixed in Pencil before the review gate.

## Checklist

### Build
- [x] Kickoff questions answered (2026-09-24, 16 decisions above).
- [x] All 13 components + `TsCheckbox`, `TsRadio`, `TicketUnitRow`, `PageIndicator` built with every listed state, light + dark, tokens only (95 masters, 6 sheets + 6 dark copies).
- [x] Nested instances of step-03 components (`UnitStatusBadge`, `TsButton`, `TsChip` recipe) — no re-drawn copies.
- [x] Silhouettes generated and componentized (3 categories × hero 96 / card 64, token-bound).
- [x] Text uses the type-role variables (`type-*-size / -lh / -tracking`, `font-weight-*`); long strings tested (long nickname, 54-character workshop name, long service and part names) with wrap and manual ellipsis.
- [x] Component sheet per group with a realistic populated example from the demo-content sheet (Vario / Beat / PCX, Bengkel Jaya Motor, Rp428.000 → Rp385.200, `TS-260929-0417`).
- [x] 48dp targets verified (13 interactive families, 0 under); status / eligibility never conveyed by color alone.

### Quality (automated, run in `execute`)
- [x] Clipping check on every sheet, dark copy and the stress frame → 0 (exempt by name: 4 intentional scroll specimens, `Decor` notches / circles, disabled subtrees).
- [x] Raw-hex audit → 0 on 2,399 nodes (fills, strokes, gradient stops, effects).
- [x] Stress instances: 360-wide container, every text node ×1.3, 12 components → no clipping (found and fixed the disabled reason badge on `VehicleSelectCard` / `PartOptionTile`).
- [x] Every node named (0 unnamed outside generated `Art` frames); overrides addressable by unique names / ids.
- [x] Contrast from resolved values in both themes: 1,326 text + 322 icon nodes, 0 fails (star icon fixed to `warning-text`); glass bar measured over the S11 worst-case backdrops (see build decisions).
- [x] Figma test import of the step 04 sheets (trimmed scope) done by the user: "all export i check look good in figma" (no per-feature scores or screenshots sent, no new drift reported); Chromium pre-check found no violations; no new compat rules beyond the `note` drop logged in `00-index.md`.

### /better-interface
- [x] Run `/better-interface` with scope = Booking component sheets (names + node ids).
- [x] Focus on Accessibility (states, targets, semantics), Layout (grouping, alignment, reading order inside cards), Color (status/eligibility), UI polish (concentric radius, glass, perforation).
- [x] Report recorded below; HIGH/MEDIUM fixed; verdict `Approve`.

### Review gate
- [x] Status set to 🔵; user shown: select card states, chips/strip, stepper, estimate bar, price breakdown, ticket, voucher, silhouettes.
- [x] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [x] PNG exports of the 6 light + 6 dark sheets and the 3 silhouettes to `design/pencil/exports/step04/` with `INDEX.md`, verified with `ls` (12 sheets + 3 silhouettes + `INDEX.md`).
- [x] Claude session file written (`docs/claude-session/06-design-step04-components-booking.md`).
- [x] Tracker set to ✅.

## /better-interface report

**Scope:** step 04 sheets, light + dark — Selection & vehicles `OF26X` / `v283S`, Service & parts `j22LU` / `Lg2YY`, Workshop & schedule `CVceb` / `gKq4G`, Progress & estimate `sxv4p` / `bHz7a`, Price breakdown `cO90T` / `G9VE8`, Ticket & promo `cfNYX` / `npuQi`, stress frame `d13If` · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens · **Convention docs found:** 00-index.md, prd/02, prd/06, step 03 file

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | focused specimen per interactive family, semantics / motion / keyboard notes on every sheet, 48 dp targets on 13 families, contrast on 1,326 text + 322 icon nodes in both themes, color-only check on every state | 2 findings (1 HIGH, 1 MEDIUM), fixed |
| Layout | rows against the 1,104 dp content width, scroll cues (tab row, compact strip, date strip, promo carousel), notes vs. row heights, stress frame at 360 wide and ×1.3 | 1 LOW, fixed |
| Writing | sentence case on every label, estimate-bar state copy (reason line, error names the fix), terminology against PRD 04 | 3 LOW (1 fixed, 2 left) |
| Typography | ×1.3 stress, truncation rules per component, role variables | 1 MEDIUM, fixed; tabular figures Not verified |
| Color | contrast pairs (resolved), glass over worst-case backdrops, semantic use, one filled accent per view | 1 MEDIUM fixed, 1 LOW left |
| UI | concentric radius across nested tiles, glass recipe, perforation, focus recipes | 1 MEDIUM, fixed |

| Severity | Domain | Location (sheet · node id) | Before | After | Why |
|---|---|---|---|---|---|
| HIGH | Accessibility | Selection: `VehicleTabChip / Layout=Rail` ×4 (`di2EP` `lsQRa` `LIU97` `Q6qYL`) · Service: `PartOptionTile / Layout=Grid` ×3 (`ZUZHh` `r3cOJe` `Aorqa`) · Price: `PriceBreakdown Unit` collapsed / expanded (`lbbBu` `mIoPJ`) · Ticket: `VoucherCard` ×3 (`UQ201` `wW7Ee` `vK5hP`) | keyboard-reachable rows and cards with no focused specimen | focused specimens added: rail row `d9lx0V` (2 dp `focus-ring` as the border), grid card `jVeVE`, unit row `mngtL`, voucher `yHmZ5` (ring outside the border) | Escalation trigger: a control reachable by keyboard / switch access on tablet with no designed focus indicator |
| MEDIUM | Accessibility | Ticket: `Note Promo` `Ubp7R`, `PageIndicator` ×3 (`CFFUw` `q5ZMT` `zATn7`) | note said "Swipe or tap the dots"; dots are 8 × 8 in a 24 dp master | dots documented as a non-interactive position cue, excluded from semantics; the viewport announces "Promo 1 dari 3" | Tap target far below 24 dp (WCAG 2.5.8); delete the interaction instead of enlarging it |
| MEDIUM | UI | Selection: `Silhouette … Size=Card` ×3 (`b6Xes` `v6TVzN` `MOhrk`) · Workshop: `Photo Slot` ×3 (`hNAz9` `n8FxZd` `T30UP0`) · Ticket: voucher `Icon Tile` ×3 (`EVGk0` `qAQXD` `SN1Cg`) | `radius-md` 12 inside a `radius-lg` 16 card with 12 dp padding | `radius-sm` 8 (concentric = 16 − 12 = 4; nearest token) | Outer = inner + padding; mismatched nested radii read as slightly off on every card |
| MEDIUM | Color | Workshop: `DateStripItem` ×4 (`x709g` `f6Q0c` `KX1O1` `vM4Gc`) | selected = solid `accent-fill` (competes with the Lanjut CTA on S15); default boundary `border-default` 1.4 : 1 | selected = `accent-soft` + 2 px `border-accent` + `text-on-accent-soft` (same recipe as `TsChip` / `SlotChip`); default boundary `border-control` | One filled accent per view; chip-like controls use `border-control` (PRD 02) and one selected recipe |
| MEDIUM | Typography | Selection: `VehicleSelectCard` long-name specimen (`z2g1f`), `VehicleTabChip` long name (`a5EHun`) | "ellipsis after one line (maxLines 1)" while a tap on S10 selects instead of opening the detail | nickname wraps to 2 lines then ellipsis; the full value stays in the semantics label and on S09; chip full name is in the unit header (notes `v0CpNK`, `U4sIYJ`) | Truncated text needs a reachable full value |
| LOW (fixed) | Layout | Selection: `Compact Strip` (`C3rMF`) | caption says the 4th card peeks; the specimen shows all four | clipped 360 wide viewport, the next card peeks | Hidden content needs a visible cue |
| LOW (fixed) | Writing | Progress: `StickyEstimateBar / State=Error` (`nIhD7`) | caption above the statement ("Cek koneksi…" over "Estimasi belum bisa dihitung") | statement first (Label Large), fix second (Body Small) | The error should lead and then name the recovery |
| LOW (left) | Color | Ticket: `PromoBanner` icon disc `G11NzC` `gZApG` `o4w5e` | solid `accent-fill` disc beside an `accent-fill` compact button in the same card | tonal disc (`surface-card` + accent icon) if it reads as a second button | A static shape styled like a control |
| LOW (left) | Writing | Workshop: `SlotChip` `Sisa n`; Ticket: banner CTA `Pakai voucher` | "Sisa 2" does not say what is left; S16 / PRD say "Pilih voucher" | "Sisa 2 slot" if width allows; align the verb with step 10 | Terminology consistency |
| LOW (left) | Typography | badges, `SlotChip` status, `PromoBanner` | Label Small 11 px (already open from step 03) | decide with the type scale in step 19 | Small UI text |

**Verification:** passed — clipping audit on 6 light + 6 dark sheets + stress (0 outside 4 documented scroll specimens, `Decor`, disabled subtrees); raw-hex audit 0 on 2,399 nodes; unnamed 0 outside generated `Art` frames; placeholders 0; interactive masters ≥ 48 × 48 (13 families); contrast from `Get(..., {resolveVariables:true, resolveInstances:true})` with ancestor-composited backgrounds and gradient stops in both themes 0 fails; glass measured over 6 backdrops per theme (light: heading ≥ 7.4, dark: heading ≥ 4.7); HTML exports rendered in Chromium against the Pencil PNG (matching). **Not verified:** Exo 2 tabular figures (`tnum`) on totals; Flutter rendering of glass, focus rings, shimmer and spinner; RTL and 200 % zoom (no screens yet; ×1.3 stress only); html2figma output (user-run).
**Verdict:** Approve
**Fixes applied:** the HIGH, four MEDIUM and two LOW above (star icon → `warning-text` and the disabled reason rows were fixed earlier by the automated audits) · **LOW left for user:** promo icon disc, slot / voucher wording, Label Small 11 px

## Review rounds

#### Round 1 — 2026-09-24
- **Frames shown:** the 6 light + 6 dark sheets (select card states, tab chips + rails, stepper, estimate bar over worst-case backdrops, price breakdown, ticket, voucher, promo, silhouettes) and the 7 HTML exports for the Figma test import.
- **User feedback:** "approve, all export i check look good in figma"
- **Changes made:** none.
- **Outcome:** approved. The three LOW findings (promo icon disc, `Sisa n` / `Pakai voucher` wording, Label Small 11 px) stay open for step 19.
- **Amended in step 09 (2026-09-24, kickoff):** the `SlotChip` `Sisa n` caption becomes **"Sisa n motor"** (limited and short; capacity counts motors per hour), closing that wording LOW; "Lewat" (D+0 past slot) is the Full master with a label override. `Pakai voucher` / Label Small 11 px stay open for step 19.
- **Amended in step 10 (2026-09-24, kickoff):** decision 7 changes for S16 — the estimate block uses **static per-unit lines** (`PriceBreakdown Unit / State=Static` `b1Fc7`) and the per-unit detail moves into the new `UnitSummaryAccordion`; the collapsible `Unit` rows / `Variant=Summary` stay as built (S23 reference). S16 overrides the title to "Estimasi biaya" and the total to "Total estimasi" (masters unchanged). The `Pakai voucher` LOW stays: S16 row "Pilih voucher", S17 CTA "Pakai voucher".

## Session log

| Time | Action | Result / node ids |
|---|---|---|
| 2026-09-24 | Kickoff | Read PRD 02/03/04/05/06, steps 00–03 + session 05, Pencil state (148 variables, 100 masters). 4 `AskUserQuestion` rounds, 16 decisions recorded above. Docs updated: this file, `00-index.md` (tracker 🟡, inventory additions, Figma cadence), `11-s18-tiket.md`, `13-auth-s01-s04.md` |
| 2026-09-24 | Selection sheet | `OF26X`: `TsCheckbox` / `TsRadio` ×8, `VehicleTabChip` 8 + 2 rows, `VehicleSelectCard` 6, token `bg-page-clear`; matic silhouette generated first (`wYIqh`) and approved by the user, then bebek `zw92G` and sport `X9lt4J` (snapped, centered, card size `b6Xes` `v6TVzN` `MOhrk`) |
| 2026-09-24 | Service, workshop, progress, price, ticket sheets | `j22LU`, `CVceb`, `sxv4p`, `cO90T` (split out of Progress), `cfNYX`; 95 masters in total; handoff notes on every sheet; all placeholders cleared |
| 2026-09-24 | Dark copies + stress | six `· Dark` copies (refs renamed after their masters), stress frame `d13If` (12 instances, all text ×1.3) |
| 2026-09-24 | Automated checks | clipping, raw hex, naming, 48 dp, contrast (1,326 text + 322 icons), glass measurement; fixes: star icon, `PartOptionTile` / `VehicleSelectCard` reason rows, estimate-bar caption → `text-heading` |
| 2026-09-24 | `/better-interface` | 10 findings (1 HIGH, 4 MEDIUM, 5 LOW), verdict Block → Approve after fixes; dark copies re-created after the fixes (ids in the sheet table) |
| 2026-09-24 | HTML export for the Figma test import | 7 files in `design/pencil/exports/html/step04/` (6 light sheets + dark Selection), pre-checked in Chromium against the Pencil PNG (layout, fonts, gradients, `backdrop-filter: blur(14px)` all match; no `outline`, all strokes are `border`); `note` nodes are not exported |
| 2026-09-24 | Review gate + close | User approved ("approve, all export i check look good in figma"); 12 sheets + 3 silhouettes exported to `design/pencil/exports/step04/` (15 PNGs + `INDEX.md`, verified with `ls`); session file `06-design-step04-components-booking.md`; tracker ✅ |
