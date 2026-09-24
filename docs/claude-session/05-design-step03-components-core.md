# Claude Session Log — 05: Design step 03 — Core components

**Tool:** Claude Code + Pencil MCP + local Python for contrast math, models Sonnet 5 / Opus 5.5
**Date:** 2026-09-24
**Topic:** Run the step 03 kickoff interview, add the tokens the components need, build the Core component sheets (buttons, inputs, status and feedback, navigation, states, illustrations) in light and dark, run `/better-interface`, fix HIGH + MEDIUM findings, and get the user's approval.

---

## Initial prompt

> i want to do docs/plan/design/03-xx
> interviewme with detail if need

Later turn:

> approve

## Research performed

1. Read `docs/plan/design/00-index.md`, `02-foundations.md`, `03-components-core.md`, `04-components-booking.md` (inputs for the shared components), `docs/claude-session/04-design-step02-foundations.md`; `prd/02-brand-design-system.md`, `prd/04-screens.md` (global patterns, states), `prd/06-responsive-layout.md` (nav per window class, 48 dp targets).
2. `get_app_state` and a read of the `.pen` root (anchors, masters, 134 variables) before touching anything; the Pencil `execute` docs.
3. Contrast script (WCAG relative luminance) over 32 new-token pairs before any question was asked, then again for pressed overlays (a dark overlay drops tonal fills to 3.8–4.1 : 1), focus rings on every surface, and the danger border.
4. Existing `Illustration / Empty Garage` (style reference for the four new generations), the Step 02 Glass NavBar recipe (copied into `NavBar`) and the Color board status badges (icon and label names reused).
5. `better-*` skills (accessibility, layout, writing, typography, colors, ui) loaded for the review.

## Clarifying interview (`AskUserQuestion`, 4 rounds)

Every recommended option was accepted.

**Round 1 — carried-over decisions**
| Question | Answer |
|---|---|
| `danger` vs `accent` hue (13.8°) | Keep the site hues; icon + explicit label + confirm dialog on every destructive control |
| Illustrations in dark mode | Light sticker tile, art unchanged (palette-snapped), 1 px outline |
| Variant modeling | Masters for the states screens use (default / disabled / loading); pressed and focused are overrides |
| Nav labels | New role Label Medium 12; icons `home` `history` `two_wheeler` `person`; active = accent-soft pill + weight 700 |

**Round 2 — look of the controls**
| Question | Answer |
|---|---|
| Secondary button | Tonal orange (`accent-soft` + `text-on-accent-soft`); outline and ghost distinct |
| Text field label | Static label above the 48 dp box |
| Chip selected | Tonal + `border-accent` + leading check |
| Snackbar | Inverse surface (3 new tokens) |

**Round 3 — danger button, PNGs, defaults**
| Question | Answer |
|---|---|
| Danger button | Solid `Danger` only as the dialog confirm; `Danger Outline` for on-screen triggers |
| Step 02 board PNGs missing on disk | "I moved them": nothing to do |
| Build defaults (flat rail / app bar, generic skeletons, dialog 312 / 560, spinner loading, compact 40 in 48, dark copies) | Accept all |

**Round 4 — found while planning**
| Question | Answer |
|---|---|
| NavBar tint over unpredictable content | `glass-tint-strong` (80 %) |
| Chip label size | Label Large 14 (PRD said Label Small 11) |
| Icon-only buttons | New `TsIconButton` component |

## Execution

- **Docs (kickoff record):** step 03 file (13 decisions, token table), `00-index` (tracker, `TsIconButton` inventory row), `prd/02` (11 tokens, Label Medium, M3 error / inverse mapping, button types, NavBar tint).
- **Variables:** 148 (134 + 8 color + 3 type + `state-pressed`, `accent-pressed`, `danger-pressed`); `Type / Label Medium` `LqAAP` on the Type board (light and dark).
- **Illustrations:** 4 × `Generate(svg)` started first (`Qy9CB` `eorqH` `JU8tB` `Myjen`), finished while other sheets were built; palette-snap 89 nodes, max RGB shift 28, 0 skipped; all five on the sticker tile.
- **Sheets** (light y 8760, dark copies y 12380): Buttons `u46xe`, Inputs `rd8CS`, Status & Feedback `d8teOe`, Navigation `tBuEd`, States `WG7ja`, Illustrations `fnfFf`; 100 reusable masters (`TsButton` 22, `TsIconButton` 4, `TsTextField` 8, `TsChip` 3, `UnitStatusBadge` 14, `TsSnackbar` 4, `TsDialog` 4, `Dialog Choice Row` 2, `TsAppBar` 4, `SheetHeader` 2, `NavBar` 4 + items 2, `NavRail` 8 + items 4, `EmptyState` 4, `ErrorState` 2, `Skeleton` 4, `Illustration` 5).
- **Canvas:** Flows anchors moved to y 16000 / 18400; dark header `AEaD0` y 12240.
- **Automated checks:** clipping 0 (12 frames, disabled subtrees and `Decor` ignored), raw hex 0 on 1,603 nodes, unnamed 0 (100 refs renamed after the dark copies), placeholder 0, 47 interactive nodes ≥ 48 × 48, contrast on 650 text + 238 icon nodes in both themes 0 fails.
- **Pencil findings** (written to `00-index`): absolute `fill_container` children collapse a hug parent; disabled nodes report false "fully clipped"; notes do not reflow after an edit; even plain-assigned globals were undefined in the next `execute`; `resolveInstances` ids are editable paths; sub-node screenshots have no backdrop.

## /better-interface

Scope: six sheets + six dark copies. 14 findings (1 HIGH, 5 MEDIUM, 8 LOW), verdict Block → **Approve** after fixes. Layout / RTL / 200 % zoom marked not reviewed (no screens).
- **HIGH fixed:** no visible focus on rail items, dialog choice rows and the snackbar action; focused specimens added (snackbar ring uses `accent-on-inverse`, because `focus-ring` is 2.14 : 1 on the dark inverse surface).
- **MEDIUM fixed:** Status sheet had no behavior notes (persistent error / action toasts, dialog focus trap, motion); fixed heights on NavBar and choice rows overflow at text ×1.3 (now padding-based); chip rows wider than the phone column (wrap / peek note); mixed title / sentence case (sentence case on 22 nodes, policy in `prd/02`); field error named no fix ("Contoh: 812-3456-7890").
- **LOW left for the user:** confirm labels `Ya, Batalkan` / `Oke`, `illustration-outline` tint, Label Small 11 px, icon weight rule, press scale 0.96, inline `ErrorState` hue.

## Review rounds

Round 1 — the user answered "approve" after the report, the frame list and the three build decisions to check (sentence case, focus-border exception, pressed tokens). No per-decision changes, so all three stand and the six LOW findings stay open.

## Key decisions worth flagging to a reviewer

- **Danger vs accent (open since step 02) is closed by rules, not by a hue change:** solid red only inside dialogs, `Danger Outline` (icon + label) for triggers, tonal peach for secondary. The two hues are still 13.8° apart.
- **Sentence case is now a PRD 02 rule.** PRD 04 wireframe copy still contains title case ("Booking Servis Motor", "Lihat Invoice"); step 19 aligns it.
- **Focus indicator is not one recipe:** ring wrapper on buttons, built-in ring on icon buttons and chips, the control's own 2 dp border on fields, nav items and choice rows (offset 0), `accent-on-inverse` ring on the snackbar action. `prd/02` records the exceptions.
- **Pressed states use fill tokens, not an overlay.** `state-pressed` exists only for `TsIconButton`. Loading buttons are fixed-width masters (Pencil collapses absolute fill layers in hug parents), so instances must override the width.
- **Chips grew:** Label Large 14 instead of the PRD's Label Small 11, with a 32 dp visual inside a 48 dp target.
- **Glass:** the NavBar uses the strong tint (80 %), so it looks less frosty than the Step 02 Glass board; the standard 42 % tint stays for `StickyEstimateBar` (step 04).
- **PRD 02 inventory is not updated for `TsDialog`, `TsSnackbar`, `TsIconButton`** (step 19 does it, with the user's approval).
- **Slips to be aware of:** the step 02 board PNGs are still not in `design/pencil/exports/step02/` (only `app-icon/`); the user said they moved them and Claude did not verify. The `.pen` on disk was written at 10:37 (2.1 MB) after the review message; Claude cannot confirm it holds the final state, only that Pencil's in-memory document does. Sub-node dark screenshots have no backdrop, so dark tint fills were verified by reading resolved values, not by eye.
- **Not verified:** 320 px / 200 % zoom and RTL (no screens; text scale ×1.3 by arithmetic), Exo 2 `tnum`, Flutter rendering of glass / rings / shimmer / spinner, html2figma handling of nested instances and ring wrappers (step 04 test import).

## Output

- `design/pencil/TumbasServis.pen` (six light sheets, six dark copies, 100 masters).
- `design/pencil/exports/step03/` (12 sheet PNGs, `illustrations/` with 5 masters, `INDEX.md`), verified with `ls`.
- `docs/plan/design/00-index.md`, `03-components-core.md` updated; `prd/02-brand-design-system.md` edited (tokens, Label Medium, M3 mapping, button types, focus exceptions, pressed rule, sentence case).
- No commits.
- Next: step 04 (`docs/plan/design/04-components-booking.md`).
