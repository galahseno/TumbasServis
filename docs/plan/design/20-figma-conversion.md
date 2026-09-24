# Step 20 — Pencil → Figma import (Route B)

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | — (assessment M1, B5) |
| **Owns screens** | — |
| **Owns components** | — |
| **Converts** | All screens, components and tokens approved in steps 02–18 |
| **PRD refs** | [02 Figma documentation spec](../../../prd/02-brand-design-system.md) (pages, variables, naming, layer hygiene, base frame sizes), [08 M1, M2, B5](../../../prd/08-deliverables-acceptance.md) |
| **Pen location** | Source only; nothing new is designed here (Claude may adjust Pencil to make a re-export cleaner) |
| **Depends on** | Step 01 (Route B approved, Starter decision), steps 04 and 12 (test imports), step 19 (conversion manifest) — or step 12 if early P0 conversion was chosen |
| **Claude session** | `docs/claude-session/22-design-step20-figma-conversion.md` (written after approval) |

## Goal

Get the approved Pencil design into Figma as a documented file matching the PRD 02 spec — variables (Light/Dark per the step 01 Starter decision), text styles, components with variant properties, and every screen frame. Route B: export each frame to HTML (`html-css`), import it with the **html2figma** plugin, then rebuild what HTML cannot carry (components, variables, styles). Pencil remains the source of truth; Figma is the deliverable link.

**Who does what.** Claude has no Figma access (Starter has no usable MCP budget). **Claude** runs the exports, pre-checks each HTML in Chromium against the Pencil PNG, writes each phase's checklist, and judges the screenshots and PNGs the user sends. The **user** runs html2figma and does the Figma-side rebuild. Claude records every result in this file's Session log.

## Inputs

- Step 01 verdict (Route B approved), Starter decision, Figma-compat rules in [`00-index.md`](00-index.md#figma-plugin-compatibility); step 04 and step 12 test-import records (html2figma version, options that worked).
- Step 19 conversion manifest (components + variants, styles/variables, screens with node ids).
- Pencil PNG exports (`design/pencil/exports/`) and HTML exports (`design/pencil/exports/html/`) with their `INDEX.md` (node id ↔ frame name).
- Figma target file, owned by the user (a Draft on Starter unless the plan was upgraded).

## Open questions (ask at kickoff)

1. **Tool status** — is html2figma still working and the same version as in step 12? If it changed, re-test one frame first. If it broke: Route C (Claude writes a Figma development plugin from a Pencil JSON manifest) or manual rebuild.
2. **Deliverable location and plan** — Draft (Starter default) or a team file after an upgrade? Confirm the Light/Dark approach (two collections vs real modes) and that the Draft's public link opens in incognito.
3. **Icons** — html2figma delivers icons as unlinked vectors. Keep as-is, or turn each used icon into a component?
4. **Fonts** — Exo 2 with 400 / 600 / 800 available in the user's Figma.
5. **Review cadence** — one gate at the end, or gates after 20d and 20e (recommended)?
6. **Scope split** — convert P0 first (if step 12 chose early conversion) and P1 later?
7. **Route C** — if the estimate for hand-rebuilding components and variables is too high, should Claude write the Figma development plugin instead?

## Scope

### Target file structure (PRD 02)

| Figma page | Content |
|---|---|
| `00 Cover` | Cover, version, palette strip |
| `01 Foundations` | Color/type/spacing/radius/shadow as Variables + Styles; glass recipe; icon grid; motion notes |
| `02 Components` | Inventory by category with variant properties |
| `03 Flows – Phone` | Screens at 360×800 (+ stress frames), light + dark |
| `04 Flows – Tablet` | Screens at 800×1280 and 1280×800 (+1024×768 for S11) |
| `05 Prototype` | Wired in step 21 |

Starter note: team files cap at 3 pages, Drafts do not. If the deliverable must live in a team file, split the pages across files (decided in Q2).

### Phases

| Phase | Work | Verify |
|---|---|---|
| 20a Export + import | Claude exports one HTML per frame with layer names (`html-css`) and an `INDEX.md`, and renders each in Chromium against the Pencil PNG. The user drags the files into html2figma (Auto Layout on), section by section | Frame count equals the conversion manifest; names kept; Chromium pre-check matches |
| 20b Pages | Move imported frames into the six PRD 02 pages (or the agreed split); drop extra wrapper frames; fix any name html2figma changed | Six pages exist; frames named `S<id> <Name> / <State> / <Breakpoint>[ · Dark]` |
| 20c Tokens | Rebuild variables by hand from `GetVariables()` (Claude supplies the value table): Primitives, Semantic (two collections or modes per Q2), Spacing, Radius; text styles from the Type board; effect styles for shadows; glass recipe; bind imported fills to variables where feasible | Switch mode/collection → swatches flip; values equal the Pencil table (user screenshot of the variables panel) |
| 20d Components | The HTML carries no components: turn repeated frames into components with the `Ts` names, *Combine as variants* from the `Prop=Value` names, replace the flattened copies on screens with instances | Each component's variants match the Pencil component sheet 1:1 |
| 20e Hygiene + repair | Fix what the import missed; run a free lint plugin (e.g. Design Lint) for default names, unbound colors, detached instances | Lint reports zero on the checklist items below |

### Layer hygiene (PRD 02)

Auto-layout on every frame/group that can use it; no default names ("Frame 12", "Rectangle 4"); components use the `Ts` prefix matching Flutter widgets; all colors/type bound to variables/styles; illustrations as vector components; no leftover detached instances.

### Drift check (assessment M2 groundwork)

For every P0 screen the user exports a Figma PNG at the same size as the Pencil export and drops it in `design/figma/exports/`. Claude views both images and records a per-screen pass/deviation table (spacing, color, type, radius, shadow/glass). Deviations are fixed in Figma (Pencil stays authoritative unless the user decides otherwise). If the same deviation repeats, add a rule to the *Figma-plugin compatibility* section of [`00-index.md`](00-index.md#figma-plugin-compatibility).

## Checklist

### Build
- [ ] Kickoff questions answered; html2figma version confirmed; fonts available; deliverable location decided.
- [ ] 20a exports + Chromium pre-check done; files imported; frame count matches the manifest.
- [ ] 20b pages created (or the agreed split); naming convention applied.
- [ ] 20c variables + text styles + effect styles done; mode/collection switch verified with screenshots.
- [ ] 20d components combined into variant sets; screens use instances; variant properties match Pencil.
- [ ] 20e repairs and lint pass done.
- [ ] Drift check table complete for all P0 screens; deviations fixed.

### Quality (user-run lint plugin + screenshots)
- [ ] Naming scan → zero default names.
- [ ] Variable binding scan → zero unbound fills/strokes/type in components and screens.
- [ ] Frame count vs conversion manifest → equal (user reads the page/frame lists; Claude compares).

### /better-interface
- [ ] Run `/better-interface` on the **Figma** P0 flow (screenshots from Figma; node names from the layers panel) to confirm nothing regressed in conversion; scope statement notes it is a conversion regression check. HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: Foundations page (mode/collection switch), Components page, P0 phone + tablet pages, drift table.
- [ ] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] Figma file link (view + edit) recorded in the index; Pencil ↔ Figma mapping table stored in the session file.
- [ ] Claude session file written.
- [ ] Tracker set to ✅.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
