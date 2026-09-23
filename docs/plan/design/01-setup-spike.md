# Step 01 — Setup & Figma-conversion spike

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | — (infrastructure) |
| **Owns screens** | — |
| **Owns components** | — |
| **PRD refs** | [02](../../../prd/02-brand-design-system.md) (Figma doc spec), [06](../../../prd/06-responsive-layout.md) (window classes), [08](../../../prd/08-deliverables-acceptance.md) (M1, M2) |
| **Pen location** | `design/pencil/tumbasservis.pen` → `00 Cover`, `98 Demo Content`, `99 Spike` (deleted before review closes) |
| **Depends on** | — |
| **Claude session** | `docs/claude-session/03-design-step01-setup-spike.md` (written after approval) |

## Goal

De-risk the whole plan before any product design is drawn: create the real `.pen` file with its canvas scaffold, prove the Pencil features the plan relies on, choose the **Pencil → Figma conversion path** (there is no native Pencil → Figma export), and lock the shared demo content and the two PRD inconsistencies that would otherwise leak into every screen.

## Inputs

- Already confirmed while planning (Pencil skill docs + Context7 `/websites/pencil_dev`): themes/variables, reusable components + `ref` instances (no cross-file refs → single file), Material Symbols Rounded icons, all Google Fonts (Exo 2), `background_blur` effect, `note` nodes, export to png/jpeg/webp/pdf/html-css/html-tailwind, Figma → Pencil import.
- Pencil currently has an unsaved `pencil-new.pen` open with one empty frame.
- Demo-content draft and the PRD inconsistency in [`00-index.md`](00-index.md#canonical-demo-content).

## Open questions (ask at kickoff)

1. **Window classes** — confirm: device type via `shortestSide ≥ 600`, layout class via width (360 compact / 800 medium / 1024 expanded / 1280 large). Then fix `prd/06` wording. *Recommended: yes.*
2. **Demo prices** — approve the final 3-unit price set (subtotal Rp428.000, voucher −Rp42.800, total Rp385.200) and per-unit line items produced by this step.
3. **Illustration style** — approve the sample `Generate svg` output (flat geometric, orange/sand, line weight) before ~11 are generated later.
4. **File creation** — can `execute` create/open `design/pencil/tumbasservis.pen` by path, or must the user use *Save As* in the Pencil app?
5. **Figma access and plan limits** — does the user have a Figma account/plan with plugin access (html.to.design, variables import), and is a Figma MCP/connector with write access available? Also verify the plan's limits on **pages per file** and **variable modes**: PRD 02 needs six pages and Light/Dark modes, and Starter-tier files have historically capped both. If capped, decide now (split pages across files, or emulate dark with a second collection) so step 20 has no surprise.

## Scope

### Deliverables

| Deliverable | Detail |
|---|---|
| `tumbasservis.pen` | Saved in `design/pencil/`, replaces the unsaved `pencil-new.pen` |
| Canvas scaffold | Section-header frame component; `00 Cover` (title, tagline "Servis banyak motor, sekali booking.", version, date, palette strip placeholder); row anchors for Foundations / Components / Flows |
| `98 Demo Content` | One frame: user, garage (3 motors with plates + models), workshop, slot, booking/unit codes, voucher, price table (per-unit lines → subtotal → discount → total → duration) |
| `99 Spike` | Throw-away smoke tests (deleted before close) |
| Spike report | Table in *Session log* / *Review rounds*: each Figma path rated 1–5 on auto-layout, variables, components, text, naming, effort |

### Pencil smoke tests (each with a screenshot)

| Test | Pass criterion |
|---|---|
| Themed variables | `SetVariables` with theme axis `mode` (values `light` and `dark`); a frame copied with `theme:{mode:"dark"}` re-resolves fills and text |
| Font | `Exo 2` renders; weights 400 / 600 / 800 available (ExtraBold needed for the TS monogram) |
| Type units | Determine `letterSpacing` units (px vs em) and `lineHeight` multiplier behavior → record conversion rule for PRD 02's type scale |
| Component + instance | Reusable frame + `ref` with `descendants` override; nested instance override path works |
| Glass | Frame with `background_blur` radius 14 + tint fill (`#FFFFFF` @ 42%) over a gradient → acceptable frosted look; record the missing `saturate(180%)` gap |
| Icons | `Material Symbols Rounded` `home`, `history`, `two_wheeler`, `person`, `notifications` at 24dp; weight 400; check whether a filled variant is selectable |
| Note node | `note` renders legibly next to a frame |
| Shadow stack | Two-layer outer shadow with negative spread (PRD `shadow-md`) renders correctly |
| Screenshot/Export | `TakeScreenshot` and `Export png` write to `design/pencil/exports/` |
| Illustration | One `Generate svg` sample (empty-garage motor scene) with palette hexes in the prompt; check placeholder flag clears; then convert to a reusable component |

### Figma conversion path tests

Run each on one reusable component (a primary button with icon) **and** one sample frame (a phone screen with the glass nav). Rate fidelity and effort.

| # | Path | What to verify |
|---|---|---|
| 1 | `Export html-css` → Figma *html.to.design* plugin | auto-layout kept? fonts/colors? components lost? |
| 2 | Pencil canvas copy → paste in Figma | supported at all? layers/auto-layout/vectors |
| 3 | Tokens: `GetVariables()` → JSON → Figma variables import plugin (Light/Dark modes) | modes map 1:1 |
| 4 | Figma MCP/connector with write access (if available) | can it create frames/variables/components programmatically from Pencil data? |
| 5 | Fallback: manual rebuild in Figma from Pencil spec + PNG exports | estimate effort for 28 components + P0 screens |

Decision output: **primary path**, **fallback**, and an effort estimate for step 20. If the primary path is manual/heavy, flag it so step 12 can decide to start P0 Figma conversion early.

## Checklist

### Build
- [ ] `get_app_state` confirms Pencil connected; file saved at `design/pencil/tumbasservis.pen` (or user asked to Save As).
- [ ] Remaining Pencil skill docs read when needed (`scripts-and-shaders.md`, others only if used).
- [ ] All Pencil smoke tests above pass or are logged with a workaround.
- [ ] Letter-spacing / line-height conversion rule recorded (used by step 02).
- [ ] Section-header component + `00 Cover` frame built.
- [ ] Demo-content frame built and approved (prices consistent).
- [ ] Illustration style sample generated, approved or redirected.
- [ ] All five Figma paths tested and rated; primary + fallback chosen.
- [ ] Window-class decision applied to `prd/06` (edit text only after user confirms).
- [ ] `99 Spike` frames deleted; root contains only Cover, Demo Content, scaffold.

### Quality (automated, run in `execute`)
- [ ] Clipping check on `00 Cover` and `98 Demo Content` → zero `problems`.
- [ ] Raw-hex audit on Cover/Demo frames → zero (variables created here or in step 02 — if step 02 owns the tokens, Cover uses a minimal temporary set that step 02 replaces).
- [ ] Every node named; `placeholder` cleared.

### /better-interface
- [ ] Scope limited to `00 Cover` + illustration sample (no product screens yet). Accessibility and Layout marked `Not reviewed: no product UI in scope`; Writing, Typography, Color, UI reviewed on the Cover.
- [ ] Report recorded below; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: Cover, Demo Content, spike report + decisions needed.
- [ ] Every review round logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] PNG export of Cover + Demo Content to `design/pencil/exports/step01/`.
- [ ] Claude session file written (include the spike report and chosen Figma path).
- [ ] Tracker in `00-index.md` set to ✅; decision log updated with the chosen Figma path and window-class decision.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
