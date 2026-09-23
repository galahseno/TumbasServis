# Step 07 — S11 Detail Servis per Motor (core challenge screen)

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | P0 |
| **Owns screens** | S11 |
| **Owns components** | (screen-local): `UnitHeader`, `CopyFromRow`, `ComplaintSection`, tablet `EstimatePane` |
| **PRD refs** | [04 S11](../../../prd/04-screens.md), [03 per-unit rules, "Salin dari", pricing/duration, edge cases](../../../prd/03-user-flows.md), [06 S11 row + device matrix](../../../prd/06-responsive-layout.md), [01 pillar 2](../../../prd/01-overview.md) |
| **Pen location** | Flows row `S11` |
| **Depends on** | Steps 02–04, 06 |
| **Claude session** | `docs/claude-session/09-design-step07-s11-detail-servis.md` (written after approval) |

## Goal

Design the assessment's core differentiator: configuring service, parts/oil and complaint **independently per unit**, without ever making the single-motor path heavier. This is the largest and most scrutinized screen — every state, every breakpoint, plus the tablet list-detail-summary layout.

> Largest step. If context gets heavy, run it as two sessions — **07a** phone (light + dark + stress) and **07b** tablet — with the review gate after 07b (or one gate per half, user's choice). Log both in this file.

## Inputs

- `BookingStepper` (step 2/4 + "2/3 ✓" badge), `VehicleTabChip` (✓ ● ○ error; rail variant for tablet), `ServiceOptionTile`, `PartOptionTile` (compact), `TsChip` (complaint presets), `TsTextField` (multiline + counter), `StickyEstimateBar`, `TsDialog`.
- Business rules: ≥1 service per unit; complaint mandatory if `requiresComplaint`; 250-char cap with counter near the limit; parts filtered by model; "Salin dari" copies services + compatible parts only, never complaint notes; chip row hidden for a single unit; "Lanjut" enabled only when every chip shows ✓.

## Open questions (ask at kickoff)

1. **Service selection model.** PRD wireframe uses radio tiles, but S16 recaps "Servis Berkala + Oli" (multiple services per unit) and rules say "≥1 service type chosen". Confirm: checkbox-style multi-select, with `Perbaikan/Keluhan` combinable? (Step 04 must expose the matching `ServiceOptionTile` variant.)
2. **"Salin dari" interaction.** Single source (nearest complete unit) as in the wireframe, or always a sheet listing eligible source units? Where does the "N item suku cadang tidak disalin" note live and how long is it shown?
3. **Keluhan presets.** Approve preset chip list (e.g. Rem bunyi, Getar, Mesin brebet, Susah hidup, Oli merembes, Lampu mati) + "+" for custom.
4. **Disabled "Lanjut" reason.** Show a reason line ("Lengkapi PCX 160") in the sticky bar? Recommended yes — a disabled control must explain itself.
5. **Tablet-landscape 1-unit.** With one unit the rail is hidden — 2-pane (form + estimate) or centered form?
6. **P2 complaint photo attachment** — include the optional photo row now or leave out (cut-line)?
7. **Estimate on phone:** running total includes unfinished units or only complete ones? (Ties to the step-01 price set.)

## Scope

### Frame matrix

Breakpoints: Phone 360×800 · Tablet-P 800×1280 (medium) · Tablet-L 1280×800 (large: 3-pane) · Expanded 1024×768 (rail + form, estimate as sticky bar).

| # | State | Phone | Tablet-P | Tablet-L | Expanded | Dark |
|---|---|---|---|---|---|---|
| 1 | Single unit — chip row hidden, service chosen | ✔ | ✔ | ✔ | — | phone |
| 2 | Multi-unit (3) — chips ✓ ● ○, "Salin dari" visible | ✔ | ✔ | ✔ | ✔ | phone + Tablet-P + Tablet-L |
| 3 | Complaint required, note empty → error (chip in error state, "Lanjut" blocked) | ✔ | ✔ | — | — | phone |
| 4 | After "Salin dari": inline note about dropped incompatible parts | ✔ | — | — | — | phone |
| 5 | "Salin dari" source sheet (if approved in Q2) | ✔ | ✔ (centered modal) | — | — | phone |
| 6 | All units complete — all ✓, "Lanjut" enabled | ✔ | ✔ | ✔ | — | phone |
| 7 | Loading (catalog fetch skeleton) | ✔ | ✔ | ✔ | — | phone |
| 8 | Error (retry) | ✔ | ✔ | ✔ | — | phone |
| 9 | Remove-unit confirm dialog (unit already has selections) | ✔ | ✔ | — | — | phone |
| 10 | Keyboard open on complaint field — sticky bar above the keyboard inset | ✔ | — | — | — | phone |
| — | Stress: 360×640 (state 2) | ✔ | — | — | — | — |
| — | Stress: text scale ×1.3 (state 2, chip row + tiles) | ✔ | — | — | — | — |

### Layout targets (PRD 06)

- Phone: chip tabs (scrollable, with a visible scroll cue) + stacked cards; sticky glass `StickyEstimateBar` above the bottom inset.
- Tablet portrait: chip tabs (top) + stacked cards, max-width 720 centered; sticky bar.
- Expanded (1024): unit **rail** (left) + config form; estimate stays a sticky bar.
- Large (1280): **list-detail-summary** — unit rail · config form · live `EstimatePane` (price breakdown + duration + Lanjut).

### Components built here (flag for inventory)

| Component | Notes |
|---|---|
| `UnitHeader` | Motor nickname + model + plate (ellipsis), completion status |
| `CopyFromRow` | "⎘ Salin dari Vario" action; disabled/hidden rules |
| `ComplaintSection` | Preset chips + multiline field + counter; required/optional variants; error state |
| `EstimatePane` | Tablet-large right pane: per-unit lines + total + duration + CTA |

### Content & copy

Use the demo booking (Vario 125 ✓, Beat 110 ●, PCX 160 ○). Service catalog, part names/prices, and running estimate must match the step-01 price sheet.

### Annotations to place

- Chip-switching preserves each unit's in-progress state; completion logic for ✓ / ● / ○ / error.
- "Lanjut" gating and the disabled-reason line; unit removal recomputes chips (1 unit → chip row hides).
- "Lihat semua" → S12 sheet route (step 15); selections sync back to the active unit.
- Keyboard handling: content scrolls above the keyboard; sticky bar repositions above the inset.
- Motion: chip select 150ms; card expand 250ms; reduce-motion behavior.
- Semantics for chips ("Vario 125, lengkap") and the character counter.

## Checklist

### Build
- [ ] Kickoff questions answered; step-04 component variants confirmed (checkbox-style service tile, chip rail variant).
- [ ] States 1–10 built for the required breakpoints; dark copies built.
- [ ] Expanded 1024×768 frame (rail + form + sticky bar) built.
- [ ] Tablet-L 3-pane composition uses `EstimatePane` and rail rows (instances only).
- [ ] Stress frames (360×640, ×1.3) built and clean.
- [ ] Complaint error uses icon + text + border (not color alone); chip error state matches.
- [ ] Demo content consistent with the step-01 sheet.
- [ ] (If Q6 = yes) P2 photo-attachment row built; otherwise noted as cut.

### Quality (automated, run in `execute`)
- [ ] Clipping check on every step frame → zero `problems`.
- [ ] Raw-hex audit → zero.
- [ ] Every node named; instances only; `placeholder` cleared.
- [ ] Coverage script: frame names match the matrix above.
- [ ] Long-content test: long nickname, 250-char complaint, 4 parts → no clipping.

### /better-interface
- [ ] Run `/better-interface` with scope = all S11 frames (names + node ids); if the scope is too large for one pass, split per breakpoint group and consolidate (skill's scope-narrowing rule) — state the boundary.
- [ ] Report recorded below; HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: single vs multi-unit, error, copy note, complete state, tablet-P, 1024 rail, 1280 3-pane, keyboard frame, stress frames.
- [ ] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] PNG export to `design/pencil/exports/step07/`.
- [ ] Claude session file written.
- [ ] Tracker set to ✅; inventory additions updated.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
