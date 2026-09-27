# Claude Session Log — 06: Design step 04 — Booking components

**Tool:** Claude Code + Pencil MCP + local Python (Playwright/Chromium pre-check of HTML exports), model Sonnet 5
**Date:** 2026-09-24
**Topic:** Run the step 04 kickoff interview, build the booking components (selection marks, vehicle chips and cards, service and part tiles, workshop / slot / date, stepper, estimate bar, price breakdown, ticket, promo, voucher, silhouettes) in light and dark, run `/better-interface`, fix HIGH + MEDIUM findings, export for the Figma test import, and get the user's approval.

---

## Initial prompt

> i want to do docs/plan/design/04-xx, interviewme with detail if need
> export pencil i only keep what i need from previous plan

Later turn:

> approve, all export i check look good in figma

## Research performed

1. Read `docs/plan/design/04-components-booking.md`, `00-index.md`, `03-components-core.md`, `docs/claude-session/05-design-step03-components-core.md`; `prd/02` (inventory, glass, tokens), `prd/03` (business rules: 5-motor cap, in-service disabled, capacity, voucher eligibility), `prd/04` (S10–S18), `prd/05` (data model, `serviceIds[]`), `prd/06` (per-screen layout).
2. `get_app_state`, Pencil `pen-schema` and `execute` docs (gradient stops accept variables, ellipse sweep, slots), one read of variables (148) and of the step 03 masters (chip, button, badge, nav bar, dialog row) to reuse their recipes.
3. Confirmed the step 02–03 exports had been trimmed on disk by the user (only `step02/app-icon` remained), which is how "only keep what I need from the previous plan" was read.
4. `better-*` skills (accessibility, layout, writing, typography, colors, ui) loaded for the review.

## Clarifying interview (`AskUserQuestion`, 4 rounds + 1 mid-build check)

Every recommended option was accepted.

**Round 1 — process and shared parts**
| Question | Answer |
|---|---|
| "Export pencil, only keep what I need" scope | Booking sheets only for PNG + Figma test import; steps 02–03 not re-exported |
| Service selection (old Q7) | Checkbox multi-select default, radio variant also built |
| Shared checkbox / radio | New `TsCheckbox` + `TsRadio` masters |
| Stepper on phone | Numbered circles + one caption row (`Langkah 2 dari 4 · Servis`) + completion badge |

**Round 2 — estimate bar, price, tabs**
| Question | Answer |
|---|---|
| `StickyEstimateBar` layout | Two-line left + Lanjut right, "1 jam" (no "±"), disabled adds a reason line |
| Glass tint | 42 %, measure over S11 backdrops, fall back only if it fails |
| `PriceBreakdown` density | Collapsible per unit, S16 collapsed, invoice expanded |
| `VehicleTabChip` overflow | Scroll + 24 dp fade edge + peeking chip |

**Round 3 — ticket, silhouettes, promo**
| Question | Answer |
|---|---|
| Perforation | Two `bg-page` notches + dashed line |
| Ticket scope vs step 11 | `TicketCard` + `TicketUnitRow` here with a QR slot tile; step 11 keeps `SuccessHeader` + real `QrCode` |
| Silhouettes in dark | Two-tone, token-bound (no sticker tile) |
| `PromoBanner` | Tonal `accent-soft` gradient, no photos |

**Round 4 — states and layout**
| Question | Answer |
|---|---|
| `SlotChip` states | Add `Short` (fewer seats than units) |
| `WorkshopCard` | Thumb left, text right |
| Sample motors | Sheet-only Supra X 125 (bebek) + Ninja 250 (sport) |
| Mark position | Leading on tiles, trailing on cards |

**Mid-build:** the matic silhouette style was shown and approved before bebek and sport were generated.

## Execution

- **Docs (kickoff record):** step 04 file (16 decisions, scope table, Figma scope), `00-index` (tracker, inventory additions, Figma cadence, coverage map), `11-s18-tiket.md` (`TicketUnitRow` moved), `13-auth-s01-s04.md` (`PageIndicator` moved), `prd/02` (new token, glass rule, inventory rows).
- **Variables:** 149 (148 + `bg-page-clear`, transparent end of the scroll-edge fade).
- **Silhouettes:** 3 × `Generate(svg)`; each snapped by luminance to `text-body` / `surface-inset` / `accent`, backing rectangle deleted, art centered; card size = the same art scaled ×0.65. Heroes `wYIqh` (matic), `zw92G` (bebek), `X9lt4J` (sport); cards `b6Xes` `v6TVzN` `MOhrk`.
- **Sheets** (light y 8760, dark copies y 12380): Selection & vehicles `OF26X` / `v283S`, Service & parts `j22LU` / `Lg2YY`, Workshop & schedule `CVceb` / `gKq4G`, Progress & estimate `sxv4p` / `bHz7a`, Price breakdown `cO90T` / `G9VE8` (split out of Progress), Ticket & promo `cfNYX` / `npuQi`; stress frame `d13If` at x 16320. 95 reusable masters, 2,399 nodes.
- **Automated checks:** clipping 0 (4 documented scroll specimens, `Decor`, disabled subtrees exempt), raw hex 0, unnamed 0 outside generated `Art`, placeholders 0, 13 interactive families ≥ 48 × 48, contrast on 1,326 text + 322 icon nodes in both themes 0 fails (star icon fixed to `warning-text`), glass bar measured over 6 backdrops per theme; stress frame found and fixed the disabled reason badge on `VehicleSelectCard` / `PartOptionTile`.
- **Pencil findings** (written to `00-index`): same-call screenshots and bounds are stale; `fill_container` text in a hug parent whose size comes from an instance is flagged circular; gradient stops take variables but alpha needs its own token; `Move` keeps ids so overrides survive; generated SVG is a pile of unnamed paths; no stroke dash; `note` nodes are not exported to HTML; `Copy` of a sheet again yields unnamed refs.

## /better-interface

Scope: six sheets + six dark copies + stress frame. 10 findings (1 HIGH, 4 MEDIUM, 5 LOW), verdict Block → **Approve** after fixes.
- **HIGH fixed:** rail rows, grid part cards, unit rows and voucher cards had no designed focus state (focused specimens added).
- **MEDIUM fixed:** promo dots documented as a non-interactive cue (were 8 dp "tap the dots"); nested radius `radius-md` inside `radius-lg` → `radius-sm` on silhouette tiles, photo slots and voucher icon tiles; selected `DateStripItem` was a solid accent fill competing with the CTA (now tonal, `border-control` default); long-nickname copy said "ellipsis after one line" though a tap selects (now 2 lines and the full value in semantics / S09).
- **LOW fixed:** compact strip now shows the peeking card; estimate-bar error leads with the statement.
- **LOW left for the user:** promo icon disc styled like a control, `Sisa n` / `Pakai voucher` wording, Label Small 11 px.

## Review rounds

Round 1 — the user answered "approve, all export i check look good in figma" after the report, the frame list and the 7 HTML exports (6 light sheets + dark Selection) they imported into Figma. No changes requested. No per-feature scores or screenshots were sent, so Figma-side fidelity beyond "look good" is not recorded.

## Key decisions worth flagging to a reviewer

- **Glass bar text is `text-heading` only.** `text-body` fails over a solid accent fill (4.3 : 1 light, 2.9 : 1 dark), so the 42 % tint stays and no fallback to `glass-tint-strong` was needed; the rule is in `prd/02`.
- **Silhouettes are theme-aware, not stickers.** Fills bound to `text-body` / `surface-inset` / `accent`, unlike the step 03 illustrations (raw hexes on a light tile).
- **Inventory moved between steps:** `TicketUnitRow` (11 → 04), `PageIndicator` (13 → 04); `TsCheckbox` and `TsRadio` added. `prd/02` inventory rows for them are still to be added in step 19.
- **Step 04 sheet count is six, not five** (Progress split in two).
- **QR is a slot tile** (`qr_code_2` icon on a fixed light tile), not a pattern; step 11 builds the real `QrCode`.
- **Tab chips scroll even for the canonical 3 units** (about 354 dp needed vs 328).
- **Not verified:** Exo 2 tabular figures on totals, Flutter rendering of glass / rings / shimmer / spinner, RTL and 200 % zoom (no screens), Figma-side fidelity beyond the user's statement.
- **Unsaved file:** the `.pen` on disk may lag Pencil's memory until the user saves (Cmd+S); Claude cannot confirm the disk state.

## Output

- `design/pencil/TumbasServis.pen` (six light sheets, six dark copies, stress frame, 95 masters, 3 silhouettes).
- `design/pencil/exports/step04/` (12 sheet PNGs, `silhouettes/` 3 PNGs, `INDEX.md`), verified with `ls`.
- `design/pencil/exports/html/step04/` (7 HTML files for the Figma test import).
- `docs/plan/design/04-components-booking.md`, `00-index.md`, `11-s18-tiket.md`, `13-auth-s01-s04.md` updated; `prd/02-brand-design-system.md` edited (token, glass rule, inventory rows).
- No commits.
- Next: step 05 (`docs/plan/design/05-s05-home.md`).
