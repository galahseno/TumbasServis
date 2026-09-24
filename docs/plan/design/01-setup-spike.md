# Step 01 — Setup & Figma-conversion spike

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-23 |
| **Priority** | — (infrastructure) |
| **Owns screens** | — |
| **Owns components** | — |
| **PRD refs** | [02](../../../prd/02-brand-design-system.md) (Figma doc spec), [06](../../../prd/06-responsive-layout.md) (window classes), [08](../../../prd/08-deliverables-acceptance.md) (M1, M2) |
| **Pen location** | `design/pencil/TumbasServis.pen` → `00 Cover`, `98 Demo Content`, `99 Spike` (deleted before review closes) |
| **Depends on** | — |
| **Claude session** | `docs/claude-session/03-design-step01-setup-spike.md` (written after approval) |

## Goal

De-risk the whole plan before any product design is drawn: create the real `.pen` file with its canvas scaffold, prove the Pencil features the plan relies on, verify a **Pencil → Figma path** (there is no native export; Route A, the `.pen`-importer plugins such as [Pen.dev to Figma · FREE](https://www.figma.com/community/plugin/1601664618009066049/pen-dev-to-figma-free), was dropped as unreliable; **Route B, `html-css` export → html2figma, was approved**) on the user's **Starter** Figma account and decide the Light/Dark + pages workaround, and lock the shared demo content and the two PRD inconsistencies that would otherwise leak into every screen.

## Inputs

- Already confirmed while planning (Pencil skill docs + Context7 `/websites/pencil_dev`): themes/variables, reusable components + `ref` instances (no cross-file refs → single file), Material Symbols Rounded icons, all Google Fonts (Exo 2), `background_blur` effect, `note` nodes, export to png/jpeg/webp/pdf/html-css/html-tailwind, Figma → Pencil import.
- Pencil currently has `design/pencil/TumbasService.pen` open (empty document, not yet on disk); the user does *Save As* → `design/pencil/TumbasServis.pen`.
- Figma decisions from the 2026-09-23 interview (see [`00-index.md`](00-index.md#decision-log)): plugin path, Starter plan, no Figma MCP (Claude cannot see Figma — the user runs the plugin and sends screenshots), import cadence spike → 04 → 12 → 20. The plugin's page could not be read by Claude (HTTP 403), so its claims (components, theme-mode variables, 1,900+ icons, auto layout) are **unverified** until this spike.
- Demo-content draft and the PRD inconsistency in [`00-index.md`](00-index.md#canonical-demo-content).

## Open questions (ask at kickoff)

1. **Window classes** — **Answered 2026-09-23:** device type via `shortestSide ≥ 600`, layout class via width (360 compact / 800 medium / 1024 expanded / 1280 large). `prd/06` wording already fixed.
2. **Demo prices** — **Answered 2026-09-23 (approved):** A Rp85.000 · B Rp143.000 · C Rp200.000 → subtotal Rp428.000, voucher −Rp42.800, total Rp385.200, 2 jam; date fixed to **Sel, 29 Sep 2026** (PRD's "Sen" is wrong). Full table in [`00-index.md`](00-index.md#canonical-demo-content).
3. **Illustration style** — approve the sample `Generate svg` output (flat geometric, orange/sand, line weight) before ~11 are generated later.
4. **File creation** — **Answered 2026-09-23:** the user uses *Save As* → `design/pencil/TumbasServis.pen`; confirm with `get_app_state`.
5. **Starter workaround** — **Partly answered 2026-09-23:** the account is **Starter**, no Figma MCP. Decide from the plugin-spike result: (a) plugin creates Light/Dark modes on Starter → keep PRD 02 as written; (b) modes blocked → Draft file (unlimited pages) + dark as a second collection (`Semantic Light` / `Semantic Dark`); (c) user upgrades (Education/Pro). Also confirm a Draft can be shared as "Anyone with the link can view" with a working prototype link (M1).

## Scope

### Deliverables

| Deliverable | Detail |
|---|---|
| `TumbasServis.pen` | Saved in `design/pencil/` by the user (*Save As* from the open `TumbasService.pen`) |
| Canvas scaffold | Section-header frame component; `00 Cover` (title, tagline "Servis banyak motor, sekali booking.", version, date, palette strip placeholder); row anchors for Foundations / Components / Flows |
| `98 Demo Content` | One frame: user, garage (3 motors with plates + models), workshop, slot, booking/unit codes, voucher, price table (per-unit lines → subtotal → discount → total → duration) |
| `99 Spike` | Throw-away smoke tests (deleted before close) |
| Spike report | Table in *Session log* / *Review rounds*: each plugin feature rated 1–5 (see Plugin spike), plus the verdict, the Starter workaround and the Figma-compat rules |

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

### Route A — Pen.dev to Figma · FREE plugin (superseded)

> **Superseded 2026-09-23:** the user tried this plugin and a second `.pen` importer and found the results not reliable ("the result of plugin is not reliable much, i try other and same"). The scoring table below was never filled; Route B replaced it.

Claude has no Figma access, so this is a round trip: Claude builds the sample in Pencil, the **user** runs the plugin in Figma and sends screenshots, Claude scores them.

**Import target.** The smoke-test frames in `99 Spike` already cover themed variables, Exo 2 weights, a component + instance override, icons, the two-layer shadow, glass blur, the `Generate svg` illustration and a `note`. Add two things so the plugin is tested on realistic structure:
- a `TsButton / Type=Primary, State=Disabled` sibling of the `State=Default` button, so Figma's *Combine as variants* can be tried;
- one 360×800 phone frame (auto layout) assembling those pieces, plus a dark copy made with `theme:{mode:"dark"}`.

**Procedure (user).**
1. Save the Pencil file, create a new Figma **Draft** named `TumbasServis – Spike` (Drafts have unlimited pages/files on Starter).
2. Run *Pen.dev to Figma · FREE*, import the `99 Spike` content, note the plugin version and any options/warnings shown.
3. Send screenshots: canvas overview · layers panel of the phone frame · Local variables (collections **and modes**) · Assets/components · the overridden instance · one text node's typography panel · the Share dialog (is "Anyone with the link can view" available on a Draft?).
4. Try *Combine as variants* on the two button frames; report whether the `Type=…, State=…` names become properties.

**Scoring (Claude, 1–5 each, evidence = screenshot).**

| Feature | Score | Evidence / note |
|---|---|---|
| Auto layout (direction, gap, padding, alignment, fill/hug sizing) | | |
| Text: Exo 2, weights 400/600/800, size, line height, letter spacing | | |
| Colors bound to variables (not flattened to hex) | | |
| Theme modes (`mode` light / dark) → Figma modes, or a second collection, or flattened | | |
| Components + instances + `descendants` overrides | | |
| *Combine as variants* readiness from `Prop=Value` names | | |
| Icons (Material Symbols Rounded) as vectors/instances | | |
| Two-layer shadow with negative spread → effect styles | | |
| Glass `background_blur` → background blur layer | | |
| `Generate svg` illustration stays a vector | | |
| `note` nodes (kept as sticky/text, or dropped) | | |
| Layer names preserved (no `Frame 12`) | | |
| Import scope (whole canvas vs selection; pages created?) | | |
| Draft share setting (view link + prototype link) | | |
| Manual repair effort (S/M/L) | | |

**Decision output** (recorded in this file and in `00-index.md`):
- **Verdict:** plugin OK / try fallback #1 ([.pen to Figma — Pencil.dev Importer](https://www.figma.com/community/plugin/1619112150017437644/pen-to-figma-pencil-dev-importer)) / fallback #2 ([Pen to Figma Importer](https://www.figma.com/community/plugin/1620424308020292063/pen-to-figma-importer)) / manual rebuild. A plugin fails the spike if auto layout, variables **or** component instances are lost.
- **Starter workaround:** modes supported on Starter → keep PRD 02 as written; blocked → Draft + `Semantic Light` / `Semantic Dark` second collection (PRD 02 wording updated in step 19); or the user upgrades (Education/Pro) before step 20.
- **Figma-compat rules** found (what the plugin drops or garbles and how to design around it) → added to the *Figma-plugin compatibility* section of `00-index.md`.
- **Effort estimate** for step 20 (S/M/L), and whether step 12 should start P0 conversion early.

### Route B — `html-css` export → html2figma (round 2, 2026-09-23)

The user found the `.pen`-importer plugins unreliable, so the flow from [html2figma's guide](https://html2figma.com/blog/pen-dev-to-figma/) is tested: `Export(frame, "html-css", …)` with layer names → drag the `.html` into the html2figma plugin (local files only; free; URL import is on its roadmap).

**Verified on our side (no Figma needed):**

| Check | Result |
|---|---|
| HTML render vs Pencil | Rendered `phones.html` (light + dark) and `cover.html` in Chromium (Playwright): layout, Exo 2, shadows, glass blur, icons, illustration and gradients match the Pencil PNG. The converter therefore starts from a faithful source |
| What the HTML carries | Layer names (`data-pencil-name`), inline SVG for icons/illustration, flex layout, multi-shadow, `backdrop-filter`, hex colors. **No components, variables or themes** (blog confirms components flatten) |
| Strokes | Center-aligned → CSS `outline`; `strokeAlignment: "inner"` → `border` (tested). Use inner so converters keep them |
| Blur unit | Pencil radius 14 → `blur(7px)`: PRD `blur(14px)` = Pencil radius 28 |
| Files | `design/pencil/exports/spike-test/`: `phones.html` (light + dark phone), `cover.html`, `components.html` (`TsButton` ×2 + nested card) and my Chromium renders `*-html.png` for comparison |

**User test (Figma):** in a Starter Draft, run html2figma and drag in `cover.html`, `phones.html`, `components.html` one at a time (turn Auto Layout **on**). Send screenshots of: the canvas result, the layers panel (are names kept? extra wrapper frames?), a text node's typography panel, an effect/stroke on the glass bar, and the components frame. Score with the same table as above; extra rows to fill: stroke kept (`outline` vs `border`), backdrop blur kept, layer names from `data-pencil-name`, extra wrapper frame, auto layout on/off.

**Known gaps to plan for (not converter bugs):** components → rebuilt as Figma components + *Combine as variants* by hand; variables/styles → rebuilt from `GetVariables()`; light/dark → separate frames (Starter has no variable modes anyway). If html2figma also fails, Route C is a small **Figma development plugin** (Plugins → Development → Import from manifest; works on any plan) that reads a JSON manifest exported from Pencil and builds variables, styles, components and frames natively — offered, not started.

### Step 01 outcome (2026-09-23)

- **Verdict:** Route B (`html-css` export → html2figma) **approved by the user** after running it on the exported spike files: "this perfect like we want, approve". No Figma screenshots or per-feature scores were shared, so Claude has verified the export side only (Chromium render matches Pencil); the Figma side rests on the user's verdict.
- **Starter workaround:** deliverable in a **Draft**; Light/Dark variables, when built by hand, as two collections unless the account supports modes; Route B imports no variables. **Not yet verified:** variable modes on the account and the Draft's public link → step 12 test import and step 20.
- **Figma-compat rules:** written to `00-index.md` (*Figma-plugin compatibility*): no components/variables in the HTML, inner-aligned strokes, blur radius ×2, one frame per file, layer names via `data-pencil-name`.
- **Effort estimate for step 20:** **M** — the visual import is accepted as-is; components (`Combine as variants`), variables, text/effect styles and the six pages are rebuilt by hand. Step 12 keeps its P0 test import; early P0 conversion is only needed if the schedule slips. Route C (Figma development plugin) is the escape hatch if the manual rebuild is too heavy.

## Checklist

### Build
- [x] `get_app_state` confirms Pencil connected; file saved at `design/pencil/TumbasServis.pen` (on disk 2026-09-23 22:44, 136 KB; the user must re-save after each Claude edit session — Claude cannot save).
- [x] Remaining Pencil skill docs read when needed (`SKILL.md`, `execute.md`, `pen-schema.md`, `guide/components.md`; the rest not needed).
- [x] All Pencil smoke tests above pass or are logged with a workaround (see *Smoke test results*).
- [x] Letter-spacing / line-height conversion rule recorded (used by step 02) → `00-index.md` *Pencil facts*.
- [x] Section-header component + `00 Cover` frame built.
- [x] Demo-content frame built (prices approved at kickoff; the frame itself is reviewed at the gate).
- [x] Illustration style sample generated and approved (covered by the user's approval at the gate); kept as the `Illustration / Empty Garage` component for step 03.
- [x] Plugin-spike sample built in `99 Spike` (variants pair, phone frame, dark copy).
- [x] Procedure handed to the user (2026-09-23; reference PNGs of the spike phones in `design/pencil/exports/spike-test/`).
- [x] Route A dropped: the user found the `.pen`-importer plugins unreliable; the scoring table was not filled (superseded by Route B).
- [x] Route B export-side checks done (HTML render matches Pencil; strokes and blur mapping recorded).
- [x] Route B run by the user in Figma; verdict **html2figma OK** — "this perfect like we want, approve". No screenshots or per-feature scores were shared, so the Figma side is not independently verified by Claude.
- [x] Starter workaround decided by default (Draft; two collections for Light/Dark; Route B imports no variables) and written to the `00-index.md` decision log. **Not yet verified on the account:** variable modes and the Draft public link → step 12 test import / step 20.
- [x] Figma-compat rules written to the *Figma-plugin compatibility* section of `00-index.md`.
- [x] Window-class decision applied to `prd/06` (done 2026-09-23 after the user confirmed).
- [x] `99 Spike` deleted (container with T01–T07, both spike phones, spike components). Root now holds Cover, Demo Content, the scaffold and the approved `Illustration / Empty Garage` component (moved out of the spike first).
- [x] 8 root nodes Claude did not create (`I5KNFt` `nsxdm` `oJqdu` `k5Viv` = instances of `SectionHeader` / `Illustration`, `EL8jj` `Dq0qQ` `d4nioo` `Hxit1` = detached `TsButton` frames, tiled at x 2600–4760, y 0). **Deleted 2026-09-23 at the start of step 02** on the user's instruction ("for 01 open question, delete the component"); ids/types/positions re-verified first, masters `kcsFb` and `eWWX8` untouched, root list re-read (8 nodes remain: 4 anchors, Cover, Demo Content, the two masters).

### Quality (automated, run in `execute`)
- [x] Clipping check on `00 Cover` and `98 Demo Content` → zero `problems` (`Decor` bleed shapes exempt; run in a separate call from the inserts).
- [x] Raw-hex audit on Cover/Demo frames → zero. Tokens created here with the final PRD 02 names/hexes (19 primitives, 15 semantic tokens themed light/dark incl. `accent-fill`, `glass-tint`, `glass-border`, `font-family`, spacing + radius numbers); step 02 extends the set instead of replacing it.
- [x] Every node named; `placeholder` cleared. (206 nodes scanned across Cover, Demo Content, `SectionHeader` + 4 anchors: 0 default names, 0 placeholders.)

### /better-interface
- [x] Scope limited to `00 Cover` + illustration sample (no product screens yet). Accessibility and Layout marked `Not reviewed: no product UI in scope`; Writing, Typography, Color, UI reviewed on the Cover.
- [x] Report recorded below; verdict `Approve`.

### Review gate
- [x] Status set to 🔵; user shown: Cover, Demo Content, spike report + decisions needed (in-session; Route B files handed over).
- [x] Every review round logged; user approval recorded (2026-09-23, "this perfect like we want, approve").

### Close (only after approval)
- [x] PNG export of Cover + Demo Content (+ the illustration component) to `design/pencil/exports/step01/`, with an `INDEX.md` mapping node ids to names.
- [x] Claude session file written: `docs/claude-session/03-design-step01-setup-spike.md`.
- [x] Tracker in `00-index.md` set to ✅; decision log updated with the Route B verdict, the Starter workaround and the Figma-compat rules.

## Smoke test results (2026-09-23)

Spike nodes (deleted at close, except `eWWX8`, kept as the `Illustration / Empty Garage` component): `99 Spike` `qHLOT` · `T01` `FxI67` · `T02` `REuxU` / `OKtbA` · `T03` `LZNVL` · `T06` `WCzLC` · `T07` `IpZ4n` · components `AZx80` `caf5R` `DYTVh` + instance `dxIyv` · illustration `eWWX8` · phones `UEJ2J` (light) / `qp7dy` (dark). Reference PNGs: `design/pencil/exports/spike-test/`.

| Test | Result | Note |
|---|---|---|
| Themed variables | Pass | Dark `Copy` re-resolves: `#FBFAF9→#100E0D`, heading `#1A1716→#F7F4F2`, body `#463F3A→#C9C1BB`. Variable references and alpha-hex work in themed values |
| Font | Pass | Exo 2 at 400 / 600 / 800 — widths 284 / 291 / 301 for the same string |
| Type units | Pass | `letterSpacing` in **px**; `lineHeight` = multiplier of fontSize (default ≈ 1.35) → rule in `00-index.md` |
| Component + instance | Pass | Override by child id; nested override via `instanceChildId/innerChildId` verified (`Beat 110`, `Booking`) |
| Glass | Pass with gap | `background_blur` 14 + 42% white tint reads as frosted; no `saturate` (documented) |
| Icons | Pass with workaround | Material Symbols Rounded renders, weight 100–700; **no filled variant** → selected = weight 700 + accent |
| Note node | Pass with caveat | Renders as a yellow monospace sticky; no `fill`, ignores `fontFamily` |
| Shadow stack | Pass | Two-layer negative-spread shadow and the accent shadow render as specified |
| Screenshot / Export | Pass with rule | `TakeScreenshot` works. `Export` resolves from the **project root**, names files by node id |
| Illustration | Pass | `Generate svg` finished in a few minutes; flat, on-palette, no text; ~30 raw-hex paths, not theme-aware; converted to component `Illustration / Empty Garage` (`eWWX8`); **style awaits user approval (Q3)** |

Other findings: stale same-call bounds cause false clipping rows (run checks in a separate call); destructured globals do not persist between `execute` calls; the `.pen` file is not on disk until the user saves.

## /better-interface report

**Scope:** `00 Cover` (`CWn50`) and `Illustration / Empty Garage` (`eWWX8`, plus its instance `A0nxg` in `99 Spike Phone / Dark` `qp7dy` for the dark-theme check) · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens · **Convention docs found:** `00-index.md`, `prd/02`, `prd/06` (no other interface guidelines). Read-only review; fixes were a separate action (below).

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | — | Not reviewed: no product UI in scope (plan rule for step 01). Text contrast was measured under Color |
| Layout | Clipping check only (see Verification) | Not reviewed: no product UI in scope |
| Writing | Cover eyebrow, tagline, description, footer against the `prd/02` voice (Bahasa Indonesia, friendly) | Clear |
| Typography | 16 Cover text nodes: size, weight, tracking, line-height vs the PRD 02 scale | 2 findings (1 MEDIUM, 1 LOW) |
| Color | 11 measured pairs (light + dark tokens); all 32 illustration nodes scanned for fills/strokes | 1 finding (MEDIUM) |
| UI | Logo tile radius (31 = 22 ÷ 40 × 56, matches PRD), swatch borders (chips are 1.08–1.13 : 1 vs page, so the 1px border is structural), no shadows, `Decor` shapes | Clear |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| MEDIUM | Color | `Illustration / Empty Garage` `eWWX8` (32 nodes; instances e.g. `A0nxg`) | 0 of 32 nodes token-bound; 20 raw hexes, none in the PRD palette (`#4B3D34` ×7, `#C95D37` ×3, backdrop `#F3ECE5`, …), despite palette hexes in the prompt. In dark, the light backdrop measures 16.45 : 1 against `bg-page` dark, so it reads as a bright block | Snap every fill/stroke to the nearest palette token (`$sand-*`, `$orange-*`) **[applied]**. Dark-mode policy (fixed light "sticker" tile with a 1px `#FFFFFF1A` outline, or themed neutrals) is **carried to step 03** | Bypasses the token system: off-palette drift and no theme response; secondary UI effect is glare in dark |
| MEDIUM | Typography | `00 Cover` `CWn50`: `Description` 18, `Version` 13, `Stack` 13, `Monogram` 26, `Tagline` 64 | 4 sizes outside the PRD 02 scale (11 / 12 / 14 / 16 / 20 / 22 / 28 / 36) and raw px instead of variables | 18 → 16 (Body Large 16/24) and 13 → 14 (Body Medium 14/22) **[applied]**; `Monogram` is replaced by `TsLogo` and the 64 px hero becomes a named Type-board step or Display Small 36/44 → **carried to step 02** | Ad-hoc sizes become unstyled text at Figma import and weaken the type system on the first page reviewers see |
| LOW | Typography | `00 Cover` swatch captions `Label orange-100` … `Label sand-900` (8 nodes, 11 px / 600) | 11 px caption that is the only place a token name appears | 12 px Body Small (12/18); the 96 px chip still fits the longest name (~64 px at 11 px) | Below the 12 px floor for captions; Label Small (11) is meant for badge/chip roles |

**Verification:** Passed — contrast computed from resolved token hexes (light: eyebrow 4.64 : 1, `Servis` wordmark 4.64 : 1 at 28 px, body 9.91 : 1, tagline 17.10 : 1; dark: heading 17.58, body 10.85, accent 8.00; monogram white on `orange-500` 3.45 : 1 is a logotype at 26 px/800, exempt and above the 3 : 1 large-text bar); type read from the nodes (tracking −0.025 em on 64/28 px headings, +1.2 px on the 12 px uppercase eyebrow, line-height 1.125 headings / 1.5–1.56 body, weights ≥ 400); clipping check on Cover and illustration → 0 outside intentional `Decor` shapes; raw-hex scan after fixes → 0 raw, 69 token-bound of 74 nodes; screenshots of Cover, illustration and the dark phone. **Not verified** — Cover in dark theme (no dark Cover frame; contrast computed from tokens only); optical centering of the monogram (by eye only); how the Figma plugin treats token-bound illustration paths (step 01 plugin spike); the all-caps eyebrow is typed in caps because Pencil has no `text-transform` (handoff note, not a Pencil finding).
**Verdict:** Approve (no HIGH). Coverage as reported: Accessibility and Layout not reviewed.
**Fixes applied:** MEDIUM Color: 32 illustration nodes snapped to palette tokens (max RGB shift 28; 1 stroke; 0 skipped); MEDIUM Typography: `Description` 18 → 16 / lh 1.5 (`wStQc`), `Version` and `Stack` 13 → 14 / lh 1.5714 (`hgaUc`, `vDwdx`). **Left open / carried:** illustration dark-mode policy (step 03), Cover 64 px hero + monogram (step 02). **LOW left for user:** 11 px swatch captions.

## Review rounds

#### Round 1 — 2026-09-23
- **Frames shown:** `00 Cover`, `98 Demo Content`, the `Illustration / Empty Garage` sample, the spike phones, and the Route B files (`cover.html`, `phones.html`, `components.html`).
- **User feedback:** on Route A: "the result of plugin is not reliable much, i try other and same, let explore to use this flow" (linking the html2figma guide). After running Route B: "this perfect like we want, approve".
- **Changes made:** Route A dropped, Route B adopted; plan docs 00, 01, 02, 04, 12, 19, 20 updated; spike deleted; PNG exports and `INDEX.md` written.
- **Outcome:** approved.

## Session log

| Time | Action | Result / node ids |
|---|---|---|
| 2026-09-23 | Interview: Figma path, Starter plan, no MCP, cadence, window classes | Decisions in `00-index.md` decision log; plan docs 00, 01, 04, 12, 19, 20, 21 amended; `prd/06` window-class text fixed |
| 2026-09-23 | Kickoff Q2: demo prices + weekday | Approved A Rp85.000 / B Rp143.000 / C Rp200.000 = Rp428.000, −Rp42.800, Rp385.200, 2 jam; date fixed to Sel, 29 Sep 2026 |
| 2026-09-23 | `SetVariables` | 48 vars: 19 primitives, semantic tokens (light/dark), spacing, radius, `font-family`; later + `accent-fill`, `glass-tint`, `glass-border` |
| 2026-09-23 | Built scaffold | `SectionHeader` `kcsFb`; anchors `kl83c` `m5khVn` `OwQde` `URsZs` at y 900 / 2100 / 3600 / 6000 |
| 2026-09-23 | Built `00 Cover` | `CWn50` 1200×720; layout clean; only `Decor` shapes flagged (intentional) |
| 2026-09-23 | Built `98 Demo Content` | `isFgy` 1200×1384; price arithmetic re-derived from the text nodes: items 428.000, unit subtotals 85/143/200, total 385.200 |
| 2026-09-23 | Smoke tests + plugin sample | See *Smoke test results*; phones `UEJ2J` / `qp7dy`; 0 layout problems |
| 2026-09-23 | Automated checks | 206 nodes: 0 raw hex, 0 default names, 0 clipping (non-`Decor`), 0 placeholders |
| 2026-09-23 | Export path test | First try wrote to project-root `exports/` (removed); correct path `./design/pencil/exports/spike-test` works |
| 2026-09-23 | Blocker found, then cleared | No `.pen` on disk at first (in-memory only); the user saved it (`TumbasServis.pen` on disk 22:44). Later edits (palette snap, Cover sizes) need one more Cmd+S |
| 2026-09-23 | `/better-interface` on Cover + illustration | Verdict Approve; 2 MEDIUM + 1 LOW; measured contrast all pass (eyebrow 4.64 : 1 is the tightest) |
| 2026-09-23 | Fixes applied | Illustration: 32 nodes snapped to palette tokens; Cover: `Description` 16, `Version`/`Stack` 14. Re-check: 74 nodes, 0 raw hex, 0 clipping |
| 2026-09-23 | User feedback | `.pen`-importer plugin results "not reliable much"; a second plugin behaved the same → explore html2figma flow (Route B) |
| 2026-09-23 | Approval + close | User: "this perfect like we want, approve". `99 Spike` deleted after moving `eWWX8` out; 239 nodes checked (0 raw hex, 0 unnamed frames, 0 clipping non-`Decor`, 0 placeholders); exports to `exports/step01/`; 8 unexpected root nodes found and left untouched |
| 2026-09-23 | Route B export-side test | Exported `phones.html`, `cover.html`, `components.html`; Chromium render matches Pencil; HTML has no components/variables; center strokes → `outline`, inner → `border`; blur radius halves in CSS |
| 2026-09-23 | Open item closed (during step 02 kickoff) | User: "for 01 open question, delete the component". Deleted the 8 foreign root nodes listed in the Build checklist; root now 8 nodes, all Claude-created |
