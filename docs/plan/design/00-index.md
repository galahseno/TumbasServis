# TumbasServis — Design Plan (Pencil → Figma)

## Purpose

Step-by-step execution plan for the UI/UX design of **TumbasServis**, built from the PRD in [`../../../prd/`](../../../prd/00-index.md). Designs are authored in **Pencil (pencil.dev MCP)** in one file, `design/pencil/TumbasServis.pen`, then brought into **Figma** via **Route B**: `html-css` export → the [html2figma](https://html2figma.com/) plugin (approved in step 01, test-imported after steps 04 and 12, full import in step 20; assessment deliverable M1: public Figma link, Home → Booking Success).

Every step follows the same loop: **build → self-check → `/better-interface` pass → user review gate → session log**, and after the user approves it writes a `docs/claude-session/` file. Nothing is committed by Claude; git is handled by the user.

Primary PRD inputs: [02 brand & design system](../../../prd/02-brand-design-system.md), [03 flows & rules](../../../prd/03-user-flows.md), [04 screens](../../../prd/04-screens.md), [06 responsive layout](../../../prd/06-responsive-layout.md).

## How to run a step

Start a session with: *"Run design step NN — follow `docs/plan/design/NN-<name>.md` and the workflow in `00-index.md`."* One step per session keeps context small and the session log clean. Steps run in order; each lists its dependencies.

## Decision log

Locked in the planning interview (2026-09-23):

| Topic | Decision |
|---|---|
| Step granularity | Feature groups; P0 booking flow ≈ one screen per step; P1 grouped → 14 design steps + setup + 2 audit/checkpoint + 2 Figma = 21 steps |
| Coverage per step | Phone 360×800 + tablet portrait 800×1280 + tablet landscape 1280×800, light + dark (see frame matrix rule) |
| Order | Priority: setup → foundations → components → P0 Home→Success → P1 → audit → Figma |
| Pencil file | Single `design/pencil/TumbasServis.pen` (user does *Save As*; amended 2026-09-23 from `tumbasservis.pen`); sections mirror the Figma pages |
| `/better-interface` | Run after the draft; auto-apply HIGH + MEDIUM fixes in Pencil; list LOW for the user |
| States | P0 screens: every state in `prd/04`. P1 screens: default + empty + one loading/error |
| Figma path | Amended 2026-09-23: plugin **Pen.dev to Figma · FREE** (community id `1601664618009066049`) imports the `.pen` into Figma. Fallbacks if the step 01 spike fails: [.pen to Figma — Pencil.dev Importer](https://www.figma.com/community/plugin/1619112150017437644/pen-to-figma-pencil-dev-importer), then [Pen to Figma Importer](https://www.figma.com/community/plugin/1620424308020292063/pen-to-figma-importer) (open source); last resort = manual rebuild from Pencil spec + PNG exports. Plugin claims (components, theme-mode variables, icons) are unverified until step 01. **Round 2 (2026-09-23):** the user reports the `.pen`-importer plugins unreliable (a second one behaved the same), so **Route B — `html-css` export → [html2figma](https://html2figma.com/blog/pen-dev-to-figma/)** (free; takes a local `.html` file by drag-and-drop) was tested and **approved by the user at step 01 close** ("this perfect like we want, approve"). It is now the primary path; the `.pen`-importer plugins above are dropped. Known gaps handled by hand in step 20: components (rebuilt + *Combine as variants*) and variables/styles (rebuilt from `GetVariables()`). Route C (a Figma development plugin that reads a Pencil JSON manifest) stays an option if the manual rebuild proves too heavy |
| Figma plan | Starter (free). Team files cap at 3 pages/file; **Drafts** have unlimited files and pages. Variable modes are documented only for Education/Pro/Org/Enterprise, so PRD 02's Light/Dark modes likely fail. **Decided at step 01 close (2026-09-23):** the deliverable lives in a **Draft**; Light/Dark variables, when built by hand, are two collections (`Semantic Light` / `Semantic Dark`) unless the account supports modes. Route B imports no variables anyway. Variable modes and the Draft's public link are **not yet verified** on the account → step 12 test import and step 20 |
| Figma MCP | None (Starter allows ≈ 6 MCP reads/month). The user performs every Figma action; Claude supplies per-step checklists and judges the user's screenshots against the Pencil PNG exports |
| Figma import cadence | Spike in step 01 → test import after step 04 (**Booking sheets only**; decided at the step 04 kickoff, step 02–03 sheets are not re-exported) → test import at step 12 (P0 flow) → full import + cleanup + prototype in steps 20–21 |
| Window classes | Confirmed 2026-09-23: device type by `shortestSide ≥ 600`; layout class by **width** (360 compact / 800 medium / 1024 expanded / 1280 large). `prd/06` wording fixed in step 01 |
| Reference research | None (no Mobbin) — design from the PRD |
| Icons | Material Symbols Rounded (closes the PRD 02 open choice) via Pencil `icon` nodes, weight 100–700 |
| Imagery | Flat geometric vectors in orange/sand. Pencil forbids hand-built path art → `Generate(frame, "svg", prompt)` with palette hexes, each result turned into a reusable component. Budget ≈ 11: 5 empty/error/success, 3 onboarding, 3 motor silhouettes. Photo slots = aspect-ratio gradient placeholders |
| Git | No commits by Claude |
| Doc layout | This index + one file per step |

## Conventions

Grounded in the Pencil skill docs (`pen-schema`, `execute`, `guide/components`, `guide/mobile-app`).

### Canvas layout
- Pencil has no pages; the document root holds only screen frames, reusable component frames and section containers. Never place loose text/shapes at root.
- Top rows: `00 Cover`, `01 Foundations` boards, `02 Components`. Layout after step 02: Cover (0, 0) and Demo Content (1360, 0); Foundations header y 1480, light boards y 1620, dark boards (`… · Dark`) y 5028 under their own header at y 4880; Components anchor + masters y 8400, Flows – Phone y 9900, Flows – Tablet y 12300 (anchors move down again when a row needs the room). **After step 03:** six light Components sheets at y 8760 (x 0 / 1360 / 2720 / 4080 / 5440 / 6800), their dark header at y 12240 and dark copies at y 12380, Flows – Phone y 16000, Flows – Tablet y 18400; step 04 sheets continue the light row at y 8760, x 8160 / 9520 / 10880 / 12240 / 13600 / 14960 (dark copies at y 12380 below them; the step 04 stress frame sits at x 16320). **After step 05:** Shell · Compact x 17760, Shell · Medium x 19448, Shell · Large x 21248 and Home blocks x 24008 (light y 8760, dark copies y 12380); S05 phone rows under the Flows – Phone anchor (light y 16372, dark y 18226), Flows – Tablet anchor moved to y 20000 (portrait row y 20372, landscape row y 21958). Below: one row per screen — phone light states → phone dark → tablet portrait → tablet landscape — each row led by a section-header frame. Figma pages are created in step 20.
- Use `FindEmptySpace` for placement; never overlap root objects.

### Variables & themes
- Theme axis `mode: light | dark`. Primitives = plain color variables (`orange-500` …). Semantic tokens = themed variables named exactly like the PRD 02 table (`bg-page`, `surface-card`, `accent`, …). Number variables for spacing/radius/font size; string variable `font-family` = `Exo 2`.
- A dark frame is a `Copy` of the light frame with `theme: {mode: "dark"}` — never re-styled by hand.
- Only variables and components: **no raw hex** in fills/strokes/effects, no detached instances.

### Screen frames
- Fixed width per breakpoint (360 / 800 / 1280); height `fit_content(<device height>)`; `clip: true`; `placeholder: true` while building, cleared as soon as the frame is done.
- Android system chrome: status bar 24dp + gesture-nav inset 24dp (deliberately replaces the Pencil mobile guide's iOS 62px — **confirmed 2026-09-23, step 02**; built as reusable `System / Status Bar` and `System / Gesture Bar` in the step 02 Spacing & Layout board).
- Frame naming (PRD 02 + theme suffix): `S11 Detail Servis / Default / Phone`, `S11 Detail Servis / Default / Phone · Dark`, `… / Tablet-Portrait`, `… / Tablet-Landscape`. Every node has a human name; no "Frame 12".

### Window size classes
- PRD 06 originally said breakpoints are evaluated on `shortestSide`, but its layout table gives tablet-landscape different layouts than tablet-portrait — impossible if both have shortestSide 800. **Decided 2026-09-23 (`prd/06` updated in step 01):** *device type* (phone vs tablet, orientation lock) uses `shortestSide ≥ 600`; *layout class* uses **width** (Material 3). So 360 = compact, 800 = medium, 1024 = expanded, 1280 = large.

### Frame matrix rule
- Light: every required state × 3 breakpoints, except where PRD 06 says the layout is identical across breakpoints (dialogs, sheets, centered forms) — then one tablet frame suffices; the step's matrix marks these explicitly.
- Dark: every P0 state on phone + the default state on both tablets. P1 dark: default state on each breakpoint.
- Stress frames (P0 dense screens only): 360×640 small phone and text scale ×1.3, per PRD 06.

### Components & variants
- Names use the `Ts` prefix = Flutter widget name (PRD 02: one Figma component ↔ one Flutter widget).
- Pencil has no variant properties. Convention: every variant combination that a screen uses is its own reusable frame named `TsButton / Type=Primary, State=Default` (Figma "Property=Value" style, so step 20 can regroup into component sets). Spec-only states (pressed, focused…) may be `ref` overrides on the component sheet — the step's Open questions confirm this per component family.
- Pencil has no text styles: the type scale is built as reusable text nodes on the Type board (`Type / Headline Large` …) plus number variables, so step 20 can create Figma text styles from them.
- Icons are `icon` nodes, `library: "Material Symbols Rounded"`, 24dp default, weight 400; filled variant for selected state where the library supports it.
- **Late additions:** a component or variant discovered inside a screen step is built in that step, placed in the `02 Components` row, listed in the step's *Components built here* table, and appended to *Inventory additions* below. It is never redrawn inline.

### Annotations
- `note` nodes beside frames for motion (150 / 250 / 300 ms, reduce-motion behavior), interaction, sticky/scroll behavior, keyboard behavior, and semantics labels for icon-only controls — handoff for Flutter and for the Figma prototype.

### Automated checks (run inside `execute` every step)
- Clipping: `Get(screen, (n,c) => c.problems && Print(n.name, c.problems))` → zero rows. Run it in a **separate `execute` call** from the inserts: bounds read in the same call are stale and report false "clipped" rows (seen on Cover and Demo Content). Nodes named `Decor …` (intentional bleed) and generated-illustration paths (raw palette hexes) are exempt from the clipping and raw-hex audits.
- Raw-hex audit: any fill/stroke/effect color not starting with `$` → zero rows.
- `TakeScreenshot` per finished section as review evidence.

### Exports
- After approval: `Export(frames, "png", "./design/pencil/exports/stepNN")` — review record and later Flutter pixel-diff source (assessment M2).
- **Verified in step 01:** the output path resolves from the **project root** (not the `.pen` folder), so it must include `./design/pencil/`; files are named `<nodeId>.png` (not the frame name) at scale 2 by default. Every export folder therefore also gets an `INDEX.md` (`nodeId | frame name`) so drift checks and the Figma comparison can match by name.

### Pencil facts (verified in step 01 smoke tests, 2026-09-23)
- **Type units:** `letterSpacing` is in **px** → `px = em × fontSize` (PRD `−0.025em` at 22 → `−0.55`; `+0.025em` at 14 → `0.35`). `lineHeight` is a **multiplier of fontSize** → `lineHeight = PRD line-height px ÷ fontSize` (44/36 → `1.2222`); Exo 2's built-in default ≈ 1.35.
- **Fonts:** Exo 2 renders at weights 400 / 600 / 800 (distinct widths). `fontWeight` is a string (`"600"`).
- **Themes:** `SetVariables` themed values accept variable references (`"$sand-50"`) and hex with alpha; a `Copy` with `theme:{mode:"dark"}` re-resolves every bound fill and text. Semantic tokens bind to primitives, so a primitive change flows through both themes.
- **Icons:** Material Symbols Rounded works (`home`, `history`, `two_wheeler`, `person`, `notifications`, `arrow_back`, `arrow_forward`, `check`); `weight` 100–700 changes stroke. **No filled variant** (no FILL axis) → selected/active state = weight 700 + `accent` color (+ indicator pill), never filled-vs-outlined.
- **`note` nodes:** take no `fill` and ignore `fontFamily`; they render as a yellow monospace sticky. Fine as handoff annotations, not part of the visual design.
- **Effects:** two-layer outer shadow with negative spread renders as specified; `background_blur` 14 + white 42% tint gives an acceptable frost (no `saturate` — documented gap). Effect colors are alpha-hex; `glass-tint` / `glass-border` become themed variables in step 02.
- **Components:** `reusable` frames + `ref` instances; overrides by unique child name or id; a nested override uses `instanceChildId/innerChildId` (verified). A `Copy` of a reusable node makes an instance, so a second variant is built as its own component.
- **Generated SVG:** `Generate(frame,"svg",prompt)` finished in a few minutes and returns ~30 vector children with **raw palette hexes** — not theme-aware (its beige backdrop stays light in dark mode). Screens that show it in dark mode need a light tile behind it or a dark-safe variant; decided in step 03. After every generation, snap all fills/strokes to the nearest palette token (script proven on the step 01 sample: 32 nodes, max RGB shift 28) — the generator ignores palette hexes in the prompt (20 raw hexes, none in the palette).
- **Effects and variables (schema):** `effect` fields (`radius`, `blur`, `spread`, `offset`, `color`) accept variable references (`NumberOrVariable` / `ColorOrVariable`), so shadows and glass are token-bound; step 02 builds `shadow-*` and `glass-*` variables (blur radius `glass-blur` = 28 for PRD `blur(14px)`).
- **Verified in step 02 (2026-09-23/24):**
  - **Inner shadows are not honored.** `effect: {type:"shadow", shadowType:"inner"}` is stored and drawn as `outer` (checked by reading it back and by render). Emulate a 1px inset highlight with a 1px `rectangle` child (`layoutPosition:"absolute"`) instead; the glass sheen uses this.
  - **Variables bind** to `fill`, `stroke`, `cornerRadius`, `gap`, `padding`, `fontSize`, `lineHeight`, `letterSpacing`, `fontWeight`, and to shadow `color` / `blur` / `spread` / `offset.y` and `background_blur.radius`. **`width` / `height` do not accept a variable** (`"$spacing-4"` is coerced to 0): use literal sizes, or `fill_container`.
  - **Reusable text nodes work** (`reusable: true` on a `text`), so the type roles are `Type / <Role>` components. Reading them back elides defaults (weight 400 and tracking 0 are omitted).
  - **Icon names:** `Insert` prints an `issues detected` list for names missing from the set. `expand_more`, `expand_less` and `local_offer` do not exist; use `keyboard_arrow_down`, `keyboard_arrow_up`, `sell`.
  - **Copying a board that holds reusable children** creates instances (`ref`) of the originals, not duplicate masters, but the refs come back **unnamed**; name them after the master (`<master> (instance)`). A `Copy` with `theme:{mode:"dark"}` re-resolves the whole board.
  - **Screenshots of large nodes are downscaled** (~400 px); screenshot a small sub-node (a row, a chip group) to inspect detail. Same-call bounds are stale, so run clipping checks in a later call.
  - **`Get(id, visit, {resolveVariables:true, resolveInstances:true})`** returns resolved colors inside instances and themed frames, which makes a per-node contrast audit possible (step 02: 1,089 text nodes).
  - `Decor …` bleed shapes (e.g. the Glass backdrop blobs) are exempt from the clipping audit by name.
- **Script gotcha:** globals created by destructuring (`[a,b]=fn()`) do not persist between `execute` calls; capture ids with plain assignments. **Step 03 found that even plain-assigned globals were undefined in the next call** (`ReferenceError: 'sheetBtn' is not defined`): read the ids from the previous `Created nodes` list and pass them as literals.
- **Verified in step 03 (2026-09-24):**
  - **Absolute `fill_container` children collapse a hug parent** ("circular sizing"): an overlay layer (`layoutPosition:"absolute"`, `width/height:"fill_container"`) inside a `fit_content` button zeroes the button. Use literal sizes for absolute layers, or avoid them (pressed = a fill token, loading = a fixed-width master).
  - **Disabled (`enabled:false`) nodes report `fully clipped`** in the clipping check: ignore any node whose ancestor chain has `enabled:false`.
  - **`note` nodes size themselves from their text but their row does not reflow after an edit**: set an explicit `height` (read from bounds) on the note.
  - **A row overflows its sheet silently when a cell is added**: re-read the row width against the 1104 dp content width and split into a second row.
  - **Screenshots of sub-nodes have no backdrop**, so translucent dark tokens (16 % orange) look light in a dark copy; verify by reading the resolved value.
  - **`Get(root, visit, {resolveInstances:true})` ids are `instanceId/childId` paths** that `Update` accepts, which is how per-instance copy overrides are edited (update masters first, then the leftover paths).
  - Text-field-like variants work as separate masters plus `enabled` slots (`Prefix`, `Leading Icon`, `Suffix Icon`, `Helper`, `Error Row`, `Counter`); a slot's `descendants` key is the node name, unique inside the master.
- **Verified in step 04 (2026-09-24):**
  - **Screenshots taken in the same `execute` as the inserts come back blank (or stale)**; take them in a later call. Same for `ctx.problems`: a clipping check run right after a big insert reported 133 false rows and was clean one call later.
  - **`fill_container` text inside a hug parent is flagged "circular"** when the parent's only definite size comes from an instance (`Card Cell Long Name`): give the parent an explicit `width`.
  - **Gradient stops accept variables, alpha does not**: a fade to transparent needs its own alpha token (`bg-page-clear`). `rotation: 270` runs a linear gradient left → right.
  - **`Move` keeps ids**, so instance overrides keyed by name or id survive re-parenting a node (used to move disabled reason badges into their own row); a ref accepts root-level overrides (`stroke`, `width`, `opacity`), and nested overrides use `instanceChildId/innerChildId`.
  - **A generated SVG is a flat pile of unnamed `path` / `ellipse` nodes** (3 for matic, 31 bebek, 71 sport) with fixed grays and a `#ffffffb3` backing rectangle: delete the rectangle, snap every fill by luminance to two or three tokens, and scale `x / y / width / height` to derive a smaller size.
  - **No stroke dash**: a dashed line is a row of small rectangles with `space_between`. **`event`, `group_off`, `sell`, `oil_barrel`, `qr_code_2` exist** in Material Symbols Rounded; `expand_more` still does not.
  - **Note nodes are not exported to `html-css`**, so handoff notes never reach html2figma (the HTML is about 400 – 600 px shorter than the sheet).
  - **`Copy` of a sheet holding reusable children again yields unnamed refs**; rename them after their master right after the copy. Deleting and re-copying the dark sheets is the reliable way to refresh them after light-sheet edits that add or move nodes (master edits flow through by themselves).
- **Verified in step 05 (2026-09-24):**
  - **Slots work for screens.** A reusable frame with `slot: []` is filled with `Replace(instance + "/<slotId>", {type:"frame", …})` and `Insert` into the returned id; the instance `height` is overridden and an absolute child moves with `Update(instance + "/<childId>", {y})`. Absolute children cannot anchor to the bottom, so a taller screen needs that `y` override. Pencil keeps warning "fill_container … not inside a flexbox layout" on the slot; it is spurious (render and bounds are right).
  - **"Collapsed size / circular" warnings on a hug parent with one `fill_container` child are false positives** when a sibling has a definite or hug size (equal-height card rows, quick links): bounds read back correct (`Get(..., c.bounds)`). Avoid it only if every child fills.
  - **A hard-stop gradient (two stops at the same position) draws a crisp boundary**, so a progress fill needs no pixel width (`FleetProgress`).
  - **`Update(ref, {descendants})` merges** with the existing overrides. `Replace` on a nested ref inside a master threw (`reading 'type'`); `Delete` + `Insert` into the parent works when the node is the last child.
  - **Emoji in a text node renders as a monochrome glyph** (the text `fill` applies); it is not tofu.
  - **`note` height:** after a content edit the auto height changes but an earlier explicit `height` may stay stale; re-read the bounds and set it again. A `Copy` made before a note edit keeps the old text: delete and re-copy the dark sheet.
  - **Copying an instance keeps slot content and names**; a dark `Copy` re-resolves everything. A text ×1.3 stress copy = `Get(copy, visit, {resolveInstances:true, resolveVariables:true})` + `Update(id, {fontSize})` per text node (47 nodes), then re-measure the body.
  - **Root listing:** `Get(document, (n, c) => c.depth === 0 && …)` lists root nodes; `Get(document, {depth:1})` without a visitor is refused.
- **Unsaved file:** the document lives in Pencil's memory until the user saves (Cmd+S); Claude has no save tool.
- **Generated art internals** (the `rectangle` / `path` children of a generated SVG) are unnamed and exempt from the naming check; the wrapping frame/component is named.
- **Multiplayer:** nodes the user adds while Claude works appear at the root (at step 01 close: 8 unnamed, paste-like nodes; the user told Claude to delete them at step 02 kickoff and they were removed after an id/type/position re-check). Claude never deletes nodes it did not create without asking.
- **HTML export for Figma (Route B):** `Export(frameId, "html-css", "./design/pencil/exports/html/<step>/<frame>.html", {includeLayerNames:true})`, one frame per file. Claude pre-checks each file by rendering it in Chromium (Playwright, cached locally) against the Pencil PNG before the user drags it into html2figma.

### Figma-plugin compatibility
- The converter (html2figma) reads the `html-css` export of each frame, so the Pencil conventions above are what it converts. Keep `Prop=Value` component names (`TsButton / Type=Primary, State=Default`) so Figma's *Combine as variants* can regroup them into component sets, and keep the Type board as the source for Figma text styles.
- Route B's Figma-side result was approved by the user at step 01 close (the imported spike looked as wanted; per-feature scores were not collected). Every further rule the step 04 / step 12 test imports find (what html2figma drops, flattens or garbles) is added here and applies to later steps. Step 19 checks all frames against this list.
- _Rules found so far_ (from the HTML export of Route B, verified in the file and a Chromium render; Figma-side result approved by the user):
  - The `html-css` export carries **no components, no variables, no themes**: instances are expanded into plain frames, every color is a resolved hex, a dark frame is just another resolved frame. Components, variables and styles are rebuilt in Figma from the Pencil spec (`GetVariables()` + the component list).
  - Layer names ride on `data-pencil-name` (icons also carry `data-icon-name` / `data-icon-set`). Keep every node named, as already required.
  - **Strokes: set `strokeAlignment: "inner"`.** The default (center) exports as CSS `outline`, which DOM-based converters may drop; inner exports as `border`.
  - **Blur unit:** Pencil `background_blur.radius` exports as half in CSS (radius 14 → `blur(7px)`). PRD 02's `blur(14px)` therefore needs radius **28** in Pencil (step 02 glass board).
  - Export **one frame per HTML file**: several frames share one absolutely positioned wrapper, which imports as an extra parent frame.
  - Fonts load from Google Fonts in the HTML (Exo 2 is available in Figma as a Google font).
  - Icons, illustrations and effects survive as inline `<svg>`, multi-layer `box-shadow` (negative spread included) and `backdrop-filter`.
  - _Step 04 test import (2026-09-24):_ the user imported the 7 HTML files into Figma and reported "all export i check look good in figma" (no per-feature scores or screenshots, so no new drift rules beyond the `note` drop). Chromium pre-check: 7 sheet files render like the Pencil PNG (no `outline`, gradients as `linear-gradient`, `backdrop-filter: blur(14px)` for radius 28, Exo 2 loaded). **`note` nodes are dropped**, so handoff notes have to be re-created in Figma (comments or sticky notes) in step 20. Scroll specimens export as clipped frames.
- Claude has no Figma access. The user runs html2figma and sends screenshots (canvas, layers panel, Local variables, Assets); Claude scores them against the step's checklist.

### Safe-layout rules (PRD 06, applied as design checks)
48dp minimum targets · ellipsis + max lines on names/plates/workshops/notes · sticky bars sit above the bottom inset · max-widths per PRD 06 table · no fixed-height boxes around text · photo slots have an aspect-ratio box.

### Copy
Bahasa Indonesia, friendly voice (PRD 02). `Rp428.000`, `Sel, 29 Sep 2026`, `09.00`. All strings must be realistic — no lorem ipsum. **Sentence case** for buttons, chips, titles (decided at the step 03 review; proper nouns and service names keep their case); errors name the fix ("Contoh: 812-3456-7890").

## `/better-interface` on Pencil designs

The skill is web-oriented and demands `file:line` evidence. On Pencil frames, cite **frame name + node id** (the skill's format allows "exact screen and component when the artifact has no source files") and attach the screenshot. Mapping for static mobile mockups:

| Skill trigger (web) | Check on the design |
|---|---|
| Control with no accessible name | Icon-only controls carry a `note` with the Flutter `Semantics` label |
| Focus indicator | Designed focused state exists for TsButton / TsTextField / TsChip (tablet + keyboard / switch access) |
| `prefers-reduced-motion` | Motion notes state the `MediaQuery.disableAnimations` fallback, and no state is conveyed by motion alone |
| Clipped at 320px / 200% zoom | 360×640 frame and text-scale ×1.3 stress frames show no clipping |
| Contrast | Ratio computed from `Get(..., {resolveVariables: true})` values; text ≥ 4.5:1, UI boundaries/icons ≥ 3:1 |
| Color-only state | Every status/error/selected state also has icon, label or shape |
| Destructive action confirmation | Dialogs use danger styling; cancel de-emphasized |
| Truncation without full value | Truncated text has a reachable detail (tap → sheet, or wraps) |

Fix authority: the plan decision authorizes fixing HIGH + MEDIUM after the report is recorded. The review itself stays read-only; fixes are a separate, logged action. LOW findings stay listed for the user. A step may not enter the review gate until the verdict is `Approve` (no HIGH left).

## Token risks — decided at step 02 kickoff (2026-09-23)

Measured from the resolved hexes (WCAG relative luminance). Decisions are applied in `prd/02` and as variables in step 02.

| Pair | Measured | Decision |
|---|---|---|
| `text-muted` `#8A817A` on `bg-page` / `surface-card` / `surface-inset` (light) | 3.66 / 3.82 / 3.39 : 1 | **Fixed:** light → new `sand-600` `#756C65` = 4.93 / 5.14 / 4.56 |
| `text-faint` `#B0A79F` on light surfaces | 2.27–2.37 : 1 | Decorative only (disabled/placeholder art); never content. Dark `#6C645F` = 3.11–3.32, same rule |
| `success` / `warning` / `info` / `danger` as **text** on white | 2.58 / 2.44 / 3.23 / 3.64 : 1 | **Fixed:** `*-text` (darker) + `*-soft` tints, both modes, all pairs ≥ 4.6 : 1. Base tokens for icons, dots, borders only |
| `border-default` for control boundaries | 1.37–1.54 : 1 light, 1.40–1.50 dark | **Fixed:** new `border-control` (light `sand-500` 3.39–3.82, dark `#6C645F` 3.11–3.32); `border-default` = decorative dividers |
| `text-accent` `orange-600` on `accent-soft` `orange-100` | 4.10 : 1 | **Fixed:** new `text-on-accent-soft` (light `orange-700` `#B04418` 4.83, dark `orange-400` ≥ 5.71); M3 `onPrimaryContainer` maps to it |
| White on `orange-600` | 4.83 : 1 | ✓ as PRD states |
| `1A0E07` on `orange-400` (dark) | 7.86 : 1 | ✓ |
| `text-muted` dark `#9A918B` on dark surfaces | 5.82–6.23 : 1 | ✓ |

## Canonical demo content

Every screen uses the same story so the prototype reads as one app. Draft from the PRD; **step 01 finalizes it** into a demo-content sheet frame.

| Item | Value |
|---|---|
| User | Galah · `+62 812-3456-7890` (masked `+62 812-****-7890`) |
| Garage | Vario 125 (AB 1234 XY), Beat 110 (AB 5678 ZZ), PCX 160 (AB 9012 QR) |
| Workshop | Bengkel Jaya Motor (fictional, Yogyakarta area) |
| Slot | Sel, 29 Sep 2026 · 09.00 (weekday fixed 2026-09-23: 29 Sep 2026 is a Tuesday, PRD says "Sen"; booking code date = service date) |
| Workshop detail | 2 service bays · ★ 4,8 · 1,2 km · Buka s.d. 17.00 · Jl. Melati Raya No. 12, Sleman, DI Yogyakarta (fictional) |
| Unit A · Vario 125 | Servis Berkala Rp85.000 (60 mnt) → **Rp85.000** |
| Unit B · Beat 110 | Servis Berkala Rp85.000 + AHM Oil MPX1 Rp58.000 (60 mnt) → **Rp143.000** |
| Unit C · PCX 160 | Servis Berkala Rp85.000 + AHM Oil MPX2 Rp70.000 + Kampas Rem Rp45.000 (60 mnt) → **Rp200.000** |
| Totals | Subtotal **Rp428.000** · voucher 10% **−Rp42.800** · total **Rp385.200** · 3 × 60 mnt on 2 bays → makespan **2 jam** |
| S11 running estimate | 1 unit Rp85.000 · 1 j → 2 units (2/3 ✓) Rp228.000 · 1 j → 3 units Rp428.000 · 2 j (voucher applies from S16) |
| Booking | `TS-260929-0417`, units `-A` `-B` `-C` |
| S05 Home populated (step 05 kickoff, 2026-09-24) | Garage strip adds the sheet-only **Supra X 125** (`AB 3344 KL`, bebek) as a 4th free motor; the draft = Supra X 125 only, step 2/4, "Kedaluwarsa dalam 22 jam". Unit stages: A Vario Dikerjakan, B Beat Dikerjakan, C PCX Diperiksa → card "3 motor · Dikerjakan" + "1 motor masih Diperiksa". Empty state = same 3 motors, no badges |
| Voucher | "Diskon 10% servis ≥2 motor" |
| Promo/OTP | demo OTP `123456` |

**Resolved in step 01 kickoff (2026-09-23, user approved):** the price set and weekday in the table above are canonical. PRD 02/03/04 text is corrected in step 19 (S11 estimate, S16 per-unit amounts, S18, the "Sen" weekday, the S11 plate `AB 1234 XY` shown for Beat, `services.json` gains the parts/services used here). Original inconsistency for reference — S11 wireframe shows `Est. Rp412.000`, S16 shows 2 units (Rp428.000 → Rp385.200 after voucher), S18 shows 3 units with the same Rp385.200 total, and `services.json` prices Servis Berkala at Rp85.000 while S16 shows Rp185rb per unit. Target: one 3-unit booking, subtotal Rp428.000, 10% voucher (−Rp42.800), total Rp385.200, duration from makespan on a 2-bay workshop; S11's running estimate consistent with the same line items.

## Per-step workflow

1. **Kickoff** — read the step's PRD refs; ask the user (`AskUserQuestion`) the step's *Open questions* that change layout or content. Set status 🟡.
2. **Build** — `get_app_state`; `read_skill` docs as needed; one `execute` per section with `placeholder: true` until done; frames per the step's matrix; variables + instances only; end each section with a screenshot.
3. **Self-check** — tick the Build checklist; run the automated checks; fix before review.
4. **`/better-interface`** — scope = this step's frames. Record scope/coverage, findings, verification and verdict in the step file. Apply HIGH + MEDIUM, re-screenshot, re-run until `Approve`. List LOW.
5. **Session log** — append rows (time · action · result) to the step's Session log as work happens.
6. **Review gate** — status 🔵; give the user the frame list and what to look at; the user reviews in Pencil and replies *approve* or *changes*. Log each round. Loop until approved.
7. **Close** — only after approval: PNG export; write the `docs/claude-session/` file; status ✅; update the tracker below. No commit.

## Status tracker

⬜ not started · 🟡 in progress · 🔵 in review · ✅ approved

| Step | File | Priority | Owns screens | Status | Claude session file |
|---|---|---|---|---|---|
| 01 | [01-setup-spike.md](01-setup-spike.md) | — | — | ✅ | `03-design-step01-setup-spike.md` |
| 02 | [02-foundations.md](02-foundations.md) | — | — | ✅ | `04-design-step02-foundations.md` |
| 03 | [03-components-core.md](03-components-core.md) | — | — | ✅ | `05-design-step03-components-core.md` |
| 04 | [04-components-booking.md](04-components-booking.md) | — | — | ✅ | `06-design-step04-components-booking.md` |
| 05 | [05-s05-home.md](05-s05-home.md) | P0 | S05 | ✅ | `07-design-step05-s05-home.md` |
| 06 | [06-s10-pilih-motor.md](06-s10-pilih-motor.md) | P0 | S10 | ⬜ | `08-design-step06-s10-pilih-motor.md` |
| 07 | [07-s11-detail-servis.md](07-s11-detail-servis.md) | P0 | S11 | ⬜ | `09-design-step07-s11-detail-servis.md` |
| 08 | [08-s13-s14-bengkel.md](08-s13-s14-bengkel.md) | P0/P1 | S13, S14 | ⬜ | `10-design-step08-s13-s14-bengkel.md` |
| 09 | [09-s15-jadwal.md](09-s15-jadwal.md) | P0 | S15 | ⬜ | `11-design-step09-s15-jadwal.md` |
| 10 | [10-s16-s17-ringkasan.md](10-s16-s17-ringkasan.md) | P0/P1 | S16, S17 | ⬜ | `12-design-step10-s16-s17-ringkasan.md` |
| 11 | [11-s18-tiket.md](11-s18-tiket.md) | P0 | S18 | ⬜ | `13-design-step11-s18-tiket.md` |
| 12 | [12-p0-checkpoint.md](12-p0-checkpoint.md) | — | (S05→S18 flow) | ⬜ | `14-design-step12-p0-checkpoint.md` |
| 13 | [13-auth-s01-s04.md](13-auth-s01-s04.md) | P1 | S01–S04 | ⬜ | `15-design-step13-auth.md` |
| 14 | [14-garage-s07-s09.md](14-garage-s07-s09.md) | P1 | S07–S09 | ⬜ | `16-design-step14-garage.md` |
| 15 | [15-catalog-s12.md](15-catalog-s12.md) | P1 | S12 | ⬜ | `17-design-step15-catalog.md` |
| 16 | [16-tracking-s19-s22.md](16-tracking-s19-s22.md) | P1 | S19–S22 | ⬜ | `18-design-step16-tracking.md` |
| 17 | [17-invoice-rating-s23-s24.md](17-invoice-rating-s23-s24.md) | P1 | S23, S24 | ⬜ | `19-design-step17-invoice-rating.md` |
| 18 | [18-notif-profile-demo.md](18-notif-profile-demo.md) | P1 | S06, S25, S26 | ⬜ | `20-design-step18-notif-profile-demo.md` |
| 19 | [19-full-app-audit.md](19-full-app-audit.md) | — | all | ⬜ | `21-design-step19-full-app-audit.md` |
| 20 | [20-figma-conversion.md](20-figma-conversion.md) | — | all | ⬜ | `22-design-step20-figma-conversion.md` |
| 21 | [21-figma-prototype-publish.md](21-figma-prototype-publish.md) | — | S05→S18 | ⬜ | `23-design-step21-figma-prototype-publish.md` |

Session `02-design-plan.md` records the creation of this plan itself.

## Coverage map

Every screen and every PRD 02 inventory component is owned by exactly one step (each step file has `Owns screens` / `Owns components` lines — grep them to verify).

| Screens | Step |
|---|---|
| S05 | 05 |
| S10 | 06 |
| S11 | 07 |
| S13, S14 | 08 |
| S15 | 09 |
| S16, S17 | 10 |
| S18 | 11 |
| S01–S04 | 13 |
| S07–S09 | 14 |
| S12 | 15 |
| S19–S22 | 16 |
| S23, S24 | 17 |
| S06, S25, S26 | 18 |

| Components (28) | Step |
|---|---|
| `TsLogo` | 02 |
| `TsButton`, `TsTextField`, `TsChip`, `TsAppBar`, `SheetHeader`, `NavBar` / `NavRail`, `EmptyState`, `ErrorState`, `Skeleton`, `UnitStatusBadge` (+ extra `TsDialog`, `TsSnackbar`, `TsIconButton`) | 03 |
| `VehicleTabChip`, `VehicleSelectCard`, `ServiceOptionTile`, `PartOptionTile`, `WorkshopCard`, `SlotChip`, `DateStripItem`, `BookingStepper`, `StickyEstimateBar`, `PriceBreakdown`, `TicketCard`, `PromoBanner`, `VoucherCard` (+ `TsCheckbox`, `TsRadio`, `TicketUnitRow`, `PageIndicator`, see *Inventory additions*) | 04 |
| `StatusTimeline`, `MechanicCard` | 16 |
| `RatingStars` | 17 |
| `NotificationTile` | 18 |

Step 02 also adds design-only masters that are not Flutter widgets: the `Type / <Role>` text nodes (Figma text styles in step 20), `System / Status Bar` and `System / Gesture Bar`.

`TsDialog` and `TsSnackbar` are not in the PRD 02 inventory but PRD 04 "Global patterns" require them; they are added to the inventory in step 03 and must be added to `prd/02` (and become Flutter widgets).

### Inventory additions (running list → applied to `prd/02` in step 19, with user approval)

Components that exist in PRD 04 screens or global patterns but not in the PRD 02 inventory. Steps append here as they build.

| Component | Added in | Why |
|---|---|---|
| `TsDialog`, `TsSnackbar` | 03 | PRD 04 global patterns |
| `TsIconButton` | 03 | Back, close, bell, snackbar dismiss, field clear: 48×48 target, shared by `TsAppBar`, `SheetHeader`, `TsSnackbar`, `TsTextField` (decided at step 03 kickoff) |
| `System / Status Bar`, `System / Gesture Bar` | 02 | Android chrome (24dp + 24dp), instanced by every phone frame; not Flutter widgets |
| `TsCheckbox`, `TsRadio` | 04 | Selection glyph shared by `VehicleSelectCard`, `ServiceOptionTile`, `PartOptionTile`, `VoucherCard`: 48dp target, unchecked / checked / disabled; Flutter = themed `Checkbox` / `Radio` wrappers (decided at step 04 kickoff) |
| `TicketUnitRow`, `PageIndicator` | 04 (moved from 11 / 13) | Needed inside `TicketCard` and `PromoBanner`; steps 11 and 13 instance them instead of redrawing |
| `AppShell` | 05 | Tab shell (bottom `NavBar` / `NavRail`) reused by S05, S07, S19, S25 |
| `ActiveBookingCard`, `DraftResumeCard`, `QuickLinkTile`, `FleetProgress` | 05 (`FleetProgress` full in 16) | S05 content blocks |
| `BookingCtaCard` (Compact / Hero), `SectionTitleRow`, `GarageAddTile`, `VehicleSelectCard` compact In Service variant | 05 (added at kickoff, 2026-09-24) | S05: primary CTA (hero in the empty state), garage strip header / "+" tile, in-service badge on the compact garage card |
| `TsAppBar / Type=Title, Actions=Bell` | 05 (added while building) | Tablet app bar without the logo (the rail carries it). A promo pause / play control was proposed by the review and declined by the user |
| `UnitHeader`, `CopyFromRow`, `ComplaintSection`, `EstimatePane` | 07 | S11 sections |
| `SearchBar`, `FilterChipRow`, `WorkshopInfoBlock` | 08 | S13/S14 (`SearchBar` reused by 15) |
| `ScheduleModeToggle`, `UnitSlotSection`, `CapacityBanner`, date-grid `DateStripItem` | 09 | S15 split/capacity/landscape |
| `SummaryCard`, `UnitSummaryAccordion`, `PaymentNote`, `VoucherRow` | 10 | S16 |
| `SuccessHeader`, `QrCode` (pattern; `TicketUnitRow` moved to 04) | 11 | S18 |
| `OtpInput`, `AuthHero` (`PageIndicator` moved to 04) | 13 | S02–S04 |
| `MotorModelPicker`, `ServiceHistoryRow` | 14 | S08/S09 |
| `PartDetailSheet`, `SelectedPartsBar` | 15 | S12 |
| `BookingHistoryCard`, `UnitStatusRow`, `CancelScopeChooser`, `DemoModeShortcut` | 16 | S19–S22 |
| `InvoiceSummaryCard`, `MechanicRatingRow`, `ReviewRecap` | 17 | S23/S24 |
| `TsSegmentedControl`, `TsSwitch`, `TsSlider`, `SettingsRow` | 18 | S25/S26 |

`VehicleSelectCard` gains display and compact modes (step 04) instead of a separate garage-card component.

## Cut-line guidance

The PRD 7-day plan gives design roughly D1–D3, so this plan is deliberately ordered so a hard stop still leaves a valid submission. If time runs short, cut in this order:

1. P2 optional items inside steps 07, 11, 16 (complaint photo, share/calendar, "additional work" card).
2. Dark-mode frames for P1 screens (keep tokens + P0 dark).
3. Tablet frames for P1 screens (keep one tablet frame each).
4. Step 15 (catalog) degrades to the shortlist already in S11.
5. Step 18 S26 detail (keep S25).

Never cut: steps 01–12, the P0 tablet frames, or step 20–21 (M1 needs the public Figma link). If the step 01 spike or the step 04 / step 12 test imports show the plugin path needs heavy manual repair, step 12 decides whether to start P0 Figma conversion before the P1 steps.

## Templates

### Step file skeleton

````markdown
# Step NN — <Title>

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | P0 / P1 / — |
| **Owns screens** | Sxx |
| **Owns components** | … |
| **PRD refs** | … |
| **Pen location** | … |
| **Depends on** | Step … |
| **Claude session** | `docs/claude-session/<NN+2>-design-stepNN-<slug>.md` (written after approval) |

## Goal
## Inputs
## Open questions (ask at kickoff)
## Scope
### Frame matrix
### Components / illustrations to build
### Content & copy notes
### Annotations to place
## Checklist
### Build
### Quality (automated, run in `execute`)
### /better-interface
### Review gate
### Close (only after approval)
## /better-interface report
## Review rounds
## Session log
````

### `/better-interface` report block (paste into each step)

````markdown
**Scope:** <frame names + node ids> · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens · **Convention docs found:** 00-index.md, prd/02, prd/06

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | | |
| Layout | | |
| Writing | | |
| Typography | | |
| Color | | |
| UI | | |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|

**Verification:** <checks run + result; **Not verified** items>
**Verdict:** Block / Approve
**Fixes applied:** <HIGH/MEDIUM fixed, with node ids> · **LOW left for user:** <list>
````

### Review round block

````markdown
#### Round N — YYYY-MM-DD
- **Frames shown:** …
- **User feedback:** "<quote>"
- **Changes made:** …
- **Outcome:** changes requested / approved
````

### Session log row

`| HH:MM | action | result / node ids |`

### Claude-session file skeleton

Mirrors [`../../claude-session/01-create-prd.md`](../../claude-session/01-create-prd.md):

````markdown
# Claude Session Log — NN: Design step MM — <Title>

**Tool:** Claude Code + Pencil MCP, model <model>
**Date:** YYYY-MM-DD
**Topic:** <one line>

## Initial prompt
## Research performed
## Clarifying interview   (AskUserQuestion rounds → answers)
## Execution              (frames/components built, node ids, exports)
## /better-interface      (findings summary, fixes applied, verdict)
## Review rounds          (user feedback → changes → approval)
## Key decisions worth flagging to a reviewer
## Output                 (files: .pen sections, exports, docs updated)
````

## Risks

| Risk | Mitigation |
|---|---|
| html2figma fidelity on the full component set and the tablet layouts is proven only on the spike | The user approved the spike result at step 01; test imports after steps 04 and 12 catch drift early; fallback = Route C (Figma dev plugin) or manual rebuild |
| Free third-party plugin may change, break or disappear before step 20 | Re-run a small test import at step 12; keep PNG exports + the Pencil spec as the manual-rebuild source |
| Figma Starter caps: 3 pages per team file, variable modes documented only for paid/Education plans (PRD 02 needs 6 pages + Light/Dark) | Decided at step 01 close but not yet verified on the account (check in the step 12 test import); default = Draft file + dark mode as a second collection; alternatively Education/Pro before step 20 |
| Figma work is manual for the user (no Figma MCP) | Claude writes step checklists and the prototype wiring table; user sends screenshots; budget the time in step 12 / 20 / 21 |
| `Generate svg` is slow/expensive and style may drift | ≤ 11 illustrations, each a reusable component; style approved once in step 01 before budget is spent |
| Glass effect: Pencil has `background_blur` but no `saturate` | Approximate with tint + blur + border; note the Flutter `BackdropFilter` spec; flat fallback documented |
| Frame count explosion (states × breakpoints × themes) | Matrix rule above; dark/tablet cut-lines; components + instances only |
| PRD inconsistencies (window classes, demo prices) | Resolved in step 01 and written back to the PRD |
