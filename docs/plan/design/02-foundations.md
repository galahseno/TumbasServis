# Step 02 — Foundations (tokens, type, elevation, glass, icons, logo)

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-24 |
| **Priority** | — (foundation for all P0/P1) |
| **Owns screens** | — |
| **Owns components** | `TsLogo` (+ design-only masters: `Type / <Role>` text nodes, `System / Status Bar`, `System / Gesture Bar`) |
| **PRD refs** | [02](../../../prd/02-brand-design-system.md) (color, typography, spacing, elevation, glass, iconography, motion, logo), [06](../../../prd/06-responsive-layout.md) (grid) |
| **Pen location** | `01 Foundations` row: Color, Type, Spacing & Radius, Elevation, Glass, Icons, Motion, Logo boards |
| **Depends on** | Step 01 |
| **Claude session** | `docs/claude-session/04-design-step02-foundations.md` (written after approval) |

## Goal

Encode the PRD 02 design system as Pencil **variables** (light/dark themes) and specimen boards, so every later frame uses tokens only. Resolve the known contrast problems in the raw tokens before components are built on top of them. Build the `TsLogo` component family.

## Inputs

- PRD 02 primitives and semantic tables (light/dark), status colors, type scale, spacing 4-pt scale, radius, shadow, glass, iconography, motion, logo rules.
- Step 01 results: type-unit conversion rule, glass approximation, window-class decision.
- **Tokens already created in step 01** (final PRD 02 names and hexes; extend them, do not replace): 19 color primitives, themed semantic `bg-page`, `surface-card`, `surface-inset`, `text-heading/body/muted/faint`, `accent`, `text-accent`, `text-on-accent`, `accent-soft`, `border-subtle/default`, `success`, plus `accent-fill`, `glass-tint`, `glass-border`, `font-family`, `spacing-4 … spacing-48` and `radius-sm … radius-pill`. Cover, Demo Content, `SectionHeader` and the spike bind to them.
- **Carried from the step 01 `/better-interface` pass:** the Cover uses a 64 px hero (Display size beyond the scale) and a 26 px monogram — add a named Cover step (64/72, −1.6 tracking) to the Type board or move the hero to Display Small; replace the Cover's temporary logo tile with `TsLogo`; rebind the Cover's raw font sizes to number variables.
- Token risks and the kickoff decisions in [`00-index.md`](00-index.md#token-risks--decided-at-step-02-kickoff-2026-09-23).
- **Route B rules from step 01:** PRD `blur(14px)` = Pencil `background_blur` radius **28** (the HTML export halves the radius); strokes use `strokeAlignment: "inner"` so they export as CSS `border`, not `outline`.

## Open questions (ask at kickoff)

All answered 2026-09-23 (interview with the user; every recommended option accepted). Contrast figures were computed from the resolved hexes; glass/shadow values were read from the source site CSS (`/_astro/PortfolioPage.*.css`).

1. **Text-muted on light (3.39–3.82 : 1) — Answered:** darken. New primitive `sand-600` `#756C65`; `text-muted` light → `sand-600` (4.93 page / 5.14 card / 4.56 inset). Dark stays `#9A918B` (≥ 5.82). `prd/02` updated.
2. **Status colors as text on light — Answered:** add `success-text`, `warning-text`, `info-text`, `danger-text` and `*-soft` in **both** modes. Light text = `green-700 #33794F`, `warning-700 #8F641A`, `info-700 #1F63E9`, `red-700 #CC291F` on `*-100` tints (4.61–4.75 : 1). Dark: `*-soft` = base @ 16 %; text = base, except `info-text` `#6090EF` and `danger-text` `#E76861`, lightened because the plain base measured 4.49 / 4.13 on the soft tint. Base status tokens stay for icons, dots and borders.
3. **Control boundaries ≥ 3 : 1 — Answered:** add `border-control` (light `sand-500` `#8A817A` 3.39–3.82; dark `#6C645F` 3.11–3.32). `border-default` stays for decorative dividers and card edges.
4. **Glass border/sheen — Answered:** use the site values. Light `glass-border` `#1A171614` (sand-900 8 %), sheen `#FFFFFFBF` top / `#FFFFFF40` bottom, shadow sand-900 4 % + 18 %. Dark `glass-border` `#FFFFFF1A`, sheen `#FFFFFF17` / `#FFFFFF08`, shadow `#00000066` + `#000000B3`. Replaces the step 01 placeholders (`#FFFFFF99` / `#FFFFFF24`). `saturate(180%)` remains a documented gap.
5. **Text styles — Answered:** reusable `Type / <Role>` text nodes + number variables per role (`type-<role>-size` / `-lh` / `-tracking`).
6. **System chrome — Answered:** Android status bar 24dp + gesture inset 24dp. Built here as reusable `System / Status Bar` and `System / Gesture Bar` so every screen instances them.
7. **Exo 2 weights — Answered:** 400 / 600 / 800 only (800 = logo monogram).
8. **New, found during kickoff — Answered:** `text-accent` (`orange-600`) on `accent-soft` (`orange-100`) = 4.1 : 1 (fails), and Flutter M3 maps `onPrimaryContainer` there. Add `text-on-accent-soft` (light `orange-700 #B04418` = 4.83 : 1; dark `orange-400` ≥ 5.71 : 1). `text-accent` is unchanged elsewhere (4.64 : 1 on `bg-page`).
9. **New — Answered:** Cover hero 64 px becomes a named doc-only Type step `Type / Cover Display` 64/72, −1.6 tracking, 600 (never shipped in Flutter).

## Scope

### Variables

| Group | Variables |
|---|---|
| Primitives (color) | `orange-100/300/400/500/600`, `sand-0/50/100/200/300/400/500/700/900/950`, `green-400`, `red-400`, `warning-400`, `info-400` (19, exist) **+12 added here:** `sand-600` `#756C65`, `orange-700` `#B04418`, `green-100` `#EAF6EF`, `green-700` `#33794F`, `warning-100` `#FAF3E6`, `warning-700` `#8F641A`, `info-100` `#EBF1FD`, `info-300` `#6090EF`, `info-700` `#1F63E9`, `red-100` `#FCEBEA`, `red-300` `#E76861`, `red-700` `#CC291F` |
| Semantic (color, themed `mode`) | Full PRD 02 table: `bg-page`, `surface-card`, `surface-inset`, `surface-hover`, `text-heading/body/muted/faint`, `accent`, `accent-hover`, `text-accent`, `text-on-accent`, `accent-soft`, `border-subtle/default/strong/accent`, `success`, `danger`, `warning`, `info` + **added by the kickoff decisions:** `border-control`, `text-on-accent-soft`, `success-text/soft`, `warning-text/soft`, `info-text/soft`, `danger-text/soft`; `text-muted` light re-pointed to `sand-600` |
| Button fill split | `accent-fill` (light `orange-600`, dark `orange-400`) — the WCAG divergence from PRD 02 — vs `accent` (brand surfaces/indicators) |
| Alpha values | `accent-soft` dark = `orange-400 @ 16%` (`#FF855129`); glass tint light `#FFFFFF6B` (42%), dark `#1C191866` (40%); status `*-soft` dark = base @ 16 % |
| Glass (site values, Q4) | `glass-border` `#1A171614` / `#FFFFFF1A`; `glass-sheen-top` `#FFFFFFBF` / `#FFFFFF17`; `glass-sheen-bottom` `#FFFFFF40` / `#FFFFFF08`; `glass-shadow-1/2` sand-900 4 % + 18 % / `#00000066` + `#000000B3`; `glass-blur` 28 (= PRD `blur(14px)`) |
| Shadow | `shadow-sm-1/2`, `shadow-md-1/2`, `shadow-accent` colors + themed geometry numbers; light = PRD 02, dark = source-site values |
| Added during the build | `glass-tint-strong` (site, 80 %), `glass-shadow-2-spread`, `focus-ring` (site `--focus-ring`; orange-500 / orange-400). **134 variables total** (76 color, 54 number, 4 string) |
| Spacing | `spacing-4 … spacing-48` = 4, 8, 12, 16, 20, 24, 32, 40, 48 (named by value; already created in step 01) |
| Radius | `radius-sm` 8, `radius-md` 12, `radius-lg` 16, `radius-xl` 22, `radius-pill` 999 |
| Type | `font-family` = Exo 2; `type-<role>-size` / `-lh` / `-tracking` per role (below, + doc-only `cover-display` 64 / 1.125 / −1.6); `font-weight-regular/semibold/extrabold` = 400 / 600 / 800 |
| Status colors | Per unit status (PRD 02 table) mapped to semantic tokens + text/soft variants |

### Type scale (line-height as multiplier for Pencil; verify letter-spacing units from step 01)

| Role | Size / LH | Multiplier | Weight | Tracking |
|---|---|---|---|---|
| Display Small | 36 / 44 | 1.222 | 600 | −0.025em (−0.9) |
| Headline Large | 28 / 34 | 1.214 | 600 | −0.025em (−0.7) |
| Headline Small | 22 / 28 | 1.273 | 600 | −0.025em (−0.55) |
| Title Large | 20 / 26 | 1.3 | 600 | 0 |
| Title Medium | 16 / 22 | 1.375 | 600 | 0 |
| Body Large | 16 / 24 | 1.5 | 400 | 0 |
| Body Medium | 14 / 22 | 1.571 | 400 | 0 |
| Body Small | 12 / 18 | 1.5 | 400 | 0 |
| Label Large | 14 / 20 | 1.429 | 600 | +0.025em (+0.35) |
| Label Small | 12 / 16 (was 11 / 16 until step 12) | 1.333 | 600 | +0.025em (+0.3) |

### Boards

| Board | Content |
|---|---|
| Color | Primitives grid; semantic tokens light and dark side by side (themed frames); status-color chips; **contrast matrix** of every text/background and control/background pair with ratios and pass/fail |
| Type | Reusable text nodes for the 10 roles + specimen with realistic Indonesian copy |
| Spacing & Radius | 4-pt scale, radius samples; 4/8/12 column grids for 360 / 800 / 1280 with margins 16 / 24 / 24 |
| Elevation | `shadow-sm`, `shadow-md`, `shadow-accent` (light) + dark-tuned versions; multi-layer effect arrays |
| Glass | Bottom-bar and estimate-bar recipe: `background_blur` 14 + tint + 1px border + sheen; flat fallback; budget rule (≤ 1–2 per screen) |
| Icons | Material Symbols Rounded grid: every icon the PRD needs (nav, actions, status, empty states), sizes 24 / 20 / 16, states default / active / disabled, semantics-label note |
| Motion | `note` specs: 150ms ease-out micro-interactions, 250ms route, 300ms staggered timeline, reduce-motion fallback |
| Logo | see below |

### `TsLogo` components (owned here)

| Variant | Detail |
|---|---|
| Mark, light | 40×40 tile, radius 22-base scale, fill `orange-500`, "TS" Exo 2 ExtraBold `#FFFFFF` |
| Mark, dark | fill `orange-400`, monogram `#1A0E07` |
| Mark + wordmark | "Tumbas" `text-heading` + "Servis" `text-accent`, Exo 2 SemiBold; never mark < 24dp |
| App icon | Adaptive: 108dp canvas, foreground monogram in 66dp safe zone, solid tile background; legacy square + round fallbacks; 1024 PNG export |
| Splash mark | Tile centered on `bg-page`; wordmark fade-in note (~400ms, static if reduce-motion) |
| Min-size demo | 24dp mark specimen proving legibility |

The mark is a rounded-rect frame + text (no generated art).

## Built boards (node ids, `design/pencil/TumbasServis.pen`)

Light row y 1620, dark copies y 5028 (`… · Dark`, `theme:{mode:"dark"}`); Foundations headers at y 1480 / (1360, 4880).

| Board | Light | Dark copy | Notes |
|---|---|---|---|
| Color | `YHwYB` (1200×3694) | — (panels already show both modes) | primitives, light/dark semantic panels, status badges, contrast matrix (49 rows), resolutions, focus ring |
| Type | `jmtVQ` | `yhms5` | 11 reusable `Type / <Role>` text nodes (10 roles + doc-only `Cover Display`), weights, ID formats |
| Spacing & Layout | `ckizH` (1376 wide, so the 1280 grid is 1:1) | `x2Y1wQ` | spacing, radius, `System / Status Bar` `Q0b9h`, `System / Gesture Bar` `u5frX1`, 4/8/12-column grids |
| Elevation | `b6ejTZ` | `kTbei` | shadow specimens bound to variables, spec table, dark-mode rule |
| Glass | `jdqz6` | `ifnWF` | nav, estimate, flat fallback; text-on-glass measurements |
| Icons | `QnTvm` | `Admyd` | 64 Material Symbols Rounded, sizes, states, Semantics note |
| Motion | `I1uWY6` | — (notes only) | 4 timings, 2 curve plots, reduce-motion rules |
| Logo | `g029J` | `NCMYz` | masters `Mw9wv` `xRKBK` `VvIb7` `QS5Zn` `X98Qyx` (Mark 24/32/40/56/96), `NSvgr` (Compact), `z7UmE` (Large); splash ×3; app icons: Adaptive `zqZWT`, Guides `UEfwI`, Legacy `LAwg8` `xjlCy`, Store 1024 `BExyG` |

**Icon coverage** (cross-checked against the 26 PRD 04 screens and the global patterns): navigation, actions, booking content, status, settings/system and selection controls are all present. Three names were replaced because the icon set lacks them (`expand_more` → `keyboard_arrow_down`, `expand_less` → `keyboard_arrow_up`, `local_offer` → `sell`). No filled variant exists, so filled-star ratings use weight 700 + `accent` vs weight 400 + `text-faint`.

## Checklist

### Build
- [x] Kickoff questions answered (2026-09-23); PRD 02 updated for every approved token divergence, plus `focus-ring` and the `surface-hover` rule found by the review.
- [x] Primitives + semantic variables created via `SetVariables` (merge) with `mode` themes; 134 variables; resolved values re-read and contrast re-computed from them.
- [x] Spacing, radius, type variables created; type scale reusable text nodes built (variable binding read back: 36 / 1.2222 / −0.9 … 64 / 1.125 / −1.6).
- [x] Color, Type, Spacing & Layout, Elevation, Glass, Icons, Motion, Logo boards built.
- [x] Contrast matrix built from resolved values (49 rows, both modes); every Restricted / Paired / Decor row has a documented resolution.
- [x] Dark-mode toggle demonstrated: six board copies with `theme:{mode:"dark"}` re-resolve with no manual edits (dark board fill `#100E0D`, heading `#F7F4F2`, logo tile `#FF8551`, monogram `#1A0E07`).
- [x] `TsLogo` variants built as reusable components (5 marks, 2 lockups); app icon set and splash built. **PNG export happens at Close, after approval.**
- [x] Icon list complete for all PRD 04 screens (cross-checked, see *Built boards*).

### Quality (automated, run in `execute`)
- [x] Clipping check on every board (15 frames incl. dark copies and Cover) → zero `problems` outside intentional `Decor` shapes.
- [x] Raw-hex audit → zero (fills, strokes, effects on 2,259 nodes).
- [x] Every text/background pair resolves to ≥ 4.5 : 1 (text) or ≥ 3 : 1 (UI/large) in both modes or is listed as Restricted / Paired / Decor: token matrix + a per-node audit of 1,089 text nodes (only the logo monogram, white on `orange-500` 3.45 : 1, is below 4.5, a logotype).
- [x] Every node named (20 unnamed instance refs from the dark copies renamed); `placeholder` cleared.

### /better-interface
- [x] `/better-interface` run with scope = foundation boards (names + node ids). Color and Typography primary; Accessibility = contrast + icon semantics + naming; Layout / Writing / UI as applicable.
- [x] Report recorded below; verdict `Approve` (no HIGH). 3 of 4 MEDIUM fixed; **MEDIUM 1 (`danger` vs `accent` hue) is a user decision** (it changes a site-derived token). 7 LOW listed.

### Review gate
- [x] Status set to 🔵; user shown (in-session, boards in Pencil): Color board (both modes), contrast matrix, Type board, Logo family, app icon.
- [x] Every review round logged; user approval recorded (2026-09-24, "approved").

### Close (only after approval)
- [x] PNG export of the 14 boards + Cover to `design/pencil/exports/step02/`, app icon 1024 (+ legacy, adaptive) to `step02/app-icon/`, with an `INDEX.md` mapping node ids to names.
- [x] Claude session file written: `docs/claude-session/04-design-step02-foundations.md`.
- [x] Tracker in `00-index.md` set to ✅.

## /better-interface report

**Scope:** the eight Foundations boards and their six dark copies plus `00 Cover`: Color `YHwYB`, Type `jmtVQ` / `yhms5`, Spacing & Layout `ckizH` / `x2Y1wQ`, Elevation `b6ejTZ` / `kTbei`, Glass `jdqz6` / `ifnWF`, Icons `QnTvm` / `Admyd`, Motion `I1uWY6`, Logo `g029J` / `NCMYz`, Cover `CWn50` · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens · **Convention docs found:** `00-index.md`, `prd/02`, `prd/06` (no other interface guidelines). Read-only review; the fixes below were a separate, logged action.

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | Contrast: token matrix + per-node audit of 1,089 text nodes in both modes; icon Semantics note; hit-area note; reduce-motion rules; badge color-alone check (icon + label present); focus indicator | 2 findings (both MEDIUM) |
| Layout | Clipping check on 15 frames; grouping gaps on Color / Icons / Spacing boards; grid definitions vs PRD 06. 320 px / 200 % zoom and RTL: **Not reviewed, no screens yet** | 1 finding (LOW) |
| Writing | Indonesian specimen copy (verb-first labels, "Lanjut" flow vocabulary, sentence case), the Semantics label list, board copy | Clear |
| Typography | Scale vs PRD 02, descending heading sizes, weights 400 / 600 / 800, line-height and tracking per role, 11 px floor, numeric figures | 2 findings (LOW) |
| Color | Ramp and token naming, role use, OKLCH hue distances, both theme sets, focus and control boundaries | 3 findings (1 MEDIUM, 2 LOW) |
| UI | Icon sizes and weights, shadows vs borders, glass recipe, motion values, theme-switch behavior | 3 findings (1 MEDIUM, 2 LOW) |

| Severity | Domain | Location (board · node id) | Before | After | Why |
|---|---|---|---|---|---|
| MEDIUM | Color | Color `YHwYB` · chips `Chip danger` / `Chip accent` (both panels) | `danger` red-400 `#E4574F` = oklch hue 26.5° vs `accent` orange-500 `#E4622F` 40.3° (Δ 13.8°); `danger-text` `#CC291F` 29.1° vs `accent-fill` `#C24C1D` 39.8° (Δ 10.7°) | **Decision needed, not applied:** move `danger` at least 15° from `accent` (toward crimson, hue ≈ 15–20°), or keep the site hues and require an icon + label on every destructive control | "One color, one meaning" (within 15° = the same color). The primary "Konfirmasi Booking" (orange) and the destructive "Batalkan" (red) read as one color family side by side. Both hexes come from the source site, so a change needs your approval |
| MEDIUM | Accessibility | Contrast matrix `faKfu` (Color board) | No `surface-hover` / `accent-soft` rows; `border-control` on `surface-hover` is 3.39 light / **2.79 dark**; `text-accent` on `surface-hover` 4.29 light | Rows added; resolution: `surface-hover` only for borderless rows, bordered controls keep their fill and change only their border to `border-accent` **[applied]** | The matrix claimed every control/background pair; the hover fill breaks the 3 : 1 control-boundary rule in dark |
| MEDIUM | Accessibility | Variables (no token); site `:focus-visible` | No focus indicator token or spec although the source site defines `--focus-ring` (2 dp, offset 2) | `focus-ring` token (orange-500 / orange-400), specimen in both modes, 4 matrix rows (≥ 3.07 : 1 on every surface), `prd/02` row + rule **[applied]** | Every step 03 control would invent its own ring; a missing visible focus indicator is an escalation trigger once controls exist |
| MEDIUM | UI | Color `YHwYB` · 14 × `Badge Icon`; Icons `QnTvm` · `Sizes Note` `qz7MA` | Badge icons 14 px; the Icons board says "16 in badges" | Badge icons 16 px (matches the Label Small line height of 16) **[applied]** | Two boards contradicted each other; `UnitStatusBadge` in step 03 would inherit the wrong one |
| LOW | Typography | Type `jmtVQ` · `Type / Label Small`; Glass `jdqz6` · 4 × `Nav Label`; Color · `Badge Label` | Label Small 11 px on nav labels and status badges | Consider 12 / 16 (M3 uses 12 for `NavigationBar` labels) | Meaningful labels below the 12 px floor; PRD 02 sets 11, so left for you |
| LOW | Typography | Type `jmtVQ` · Formats Section `AM7xS` | No tabular-figure spec for values that change (estimate total, OTP countdown) | Note: Flutter `FontFeature.tabularFigures()`; verify Exo 2 ships `tnum`, else give the value a fixed-width slot | Live totals shift the layout as digits change |
| LOW | UI | Motion `I1uWY6` | No rule for theme switches | Add: a theme change is instant (`MaterialApp.themeAnimationDuration = Duration.zero`) | A whole-screen color lerp on every element smears the switch |
| LOW | UI | Motion `I1uWY6` · `Motion Timeline` `ttfBV` | Stagger 80 ms (my assumption; PRD gives only 300 ms) | ~100 ms | The staged-entrance guidance is ~100 ms |
| LOW | Color | Color `YHwYB` primitives | Primitives `warning-*` / `info-*` are named by role while `green-*` / `red-*` are named by hue; `warning` points at `warning-400` | Rename to hue (`amber-*`, `blue-*`) | Primitive/semantic seam: a hue change to the warning color would leave misleading names. Needs a variable rename + PRD edit |
| LOW | Color | Spacing `ckizH` · `Radius Sample …` strokes; Logo `g029J` · app icons `zqZWT` `UEfwI` `LAwg8` `xjlCy` `BExyG` | `border-control` on decorative radius samples; app icons use primitives `$orange-500` / `$sand-0` directly | `border-default` on the samples; optional semantic `app-icon-bg` / `app-icon-fg` | Token used outside its role. The app-icon primitives are intentional (launcher icons never theme) |
| LOW | Layout | Icons `QnTvm` · cells `keyboard_arrow_down` / `keyboard_arrow_up` | Long names wrap to two lines, so those cells are taller than their row | Uniform cell height or a shorter caption | Uneven row rhythm |

**Verification:** Passed — `GetVariables()` = 134 variables, values re-read; contrast recomputed from resolved values (token matrix 49 rows in both modes; per-node audit of 1,089 text nodes, only the logo monogram below 4.5); clipping 0 on 15 frames (`Decor` blobs exempt); raw-hex audit 0 on 2,259 nodes; naming / placeholder 0 after fixes; dark copies read back (board `#100E0D`, text `#F7F4F2`, tile `#FF8551`, monogram `#1A0E07`); OKLCH hues computed for the accent / danger pair; source-site CSS read for glass, shadow, easing, duration and focus values; small-node screenshots of every board section. **Not verified** — RTL and 320 px / 200 % zoom (no screens); Exo 2 `tnum` support; whether html2figma keeps the emulated glass sheen lines and the `Type /` reusable text nodes (step 04 test import); rendering in Flutter (`BackdropFilter`, `FocusTheme`); optical centering of the monogram (by eye).
**Verdict:** Approve (no HIGH). One MEDIUM (`danger` vs `accent`) is open for your decision.
**Fixes applied:** MEDIUM Accessibility ×2 (matrix rows + `surface-hover` rule; `focus-ring` token and spec), MEDIUM UI ×1 (badge icons 16). **Decision needed:** MEDIUM Color. **LOW left for you:** the seven rows above.

## Review rounds

#### Round 1 — 2026-09-24
- **Frames shown:** the eight Foundations boards (light) and six dark copies, the Cover, the `/better-interface` report and six decisions (`danger` vs `accent` hue, logo circle vs rounded-square, grid gutters 16 / 24 / 24, new tokens `focus-ring` and `glass-tint-strong`, Label Small 11 px, motion defaults).
- **User feedback:** "approved". No answers to the individual decisions, so the stated defaults stand: circle tile, gutters 16 / 24 / 24, both new tokens kept, Label Small 11, motion as built.
- **Changes made:** none after the report (fixes had been applied before the gate).
- **Outcome:** approved. **Carried to step 03:** the `danger` vs `accent` hue question (MEDIUM, still open), Label Small 11 px on nav labels and badges, `glass-tint-strong` for unpredictable backdrops, the tabular-figures note, instant theme switch, and the 7 LOW findings.

## Session log

| Time | Action | Result / node ids |
|---|---|---|
| 2026-09-23 | Kickoff | Read step 01/02, `00-index`, `prd/02`; app state OK; `.pen` root + 51 variables read. Source site CSS fetched (glass, shadow, accent-glow, easing, tracking values). Contrast script run on every token pair |
| 2026-09-23 | Kickoff interview (2 rounds) | Q1–Q9 answered, all recommended options; see *Open questions* |
| 2026-09-23 | Step 01 leftover | 8 foreign root nodes re-verified by id/type/position, then deleted on the user's instruction; root = 8 Claude-created nodes |
| 2026-09-23 | Variables | `SetVariables` merge: 12 primitives, semantic tokens (status text/soft, `border-control`, `text-on-accent-soft`, glass, shadows), 33 type + 3 weight variables; later `glass-tint-strong`, `glass-shadow-2-spread`, `focus-ring`. 134 total; resolved contrast re-computed, all targets met |
| 2026-09-23 | Docs | Kickoff record in `01-setup-spike`, `02-foundations`, `00-index` (token risks resolved) and `prd/02` (primitives, semantic table, accessibility rules, M3 mapping, status badges, glass, dark shadows) |
| 2026-09-23 | Type board | `jmtVQ` + 11 reusable `Type / <Role>` text nodes; variables read back |
| 2026-09-23 | Color board | `YHwYB`: primitives, light/dark panels, badges, contrast matrix (only the expected Restricted / Paired rows), resolutions |
| 2026-09-23 | Spacing & Layout | `ckizH`; found `width` does not accept a variable (bars 0 wide) → literal widths; `System / Status Bar` `Q0b9h`, `System / Gesture Bar` `u5frX1` |
| 2026-09-23 | Elevation | `b6ejTZ`; effect variables (color, blur, offset) resolve; fixed a 16 px table overflow |
| 2026-09-23 | Glass | `jdqz6`; **inner shadows are not honored** → sheen emulated with two 1px lines; text-on-glass measured (fails over sand-900 in light, over orange in dark) → `glass-tint-strong` documented |
| 2026-09-23 | Icons | `QnTvm`; 3 icon names missing from the set replaced (`keyboard_arrow_down/up`, `sell`) |
| 2026-09-24 | Motion, Logo | `I1uWY6`; `g029J`: PRD "radius 22 on 40" renders as a circle (kept, as approved on the Cover); monogram 61 px inside the 66 dp safe zone |
| 2026-09-24 | Cover | `Brand Row` temp tile replaced by `TsLogo Large` (same 247×56); text bound to type variables, 0 raw font sizes |
| 2026-09-24 | Dark copies, canvas | 6 `· Dark` boards, 20 refs renamed; anchors/masters moved to y 8400+ (Components) to clear the boards |
| 2026-09-24 | Automated checks | clipping 0, raw hex 0, unnamed 0, placeholder 0; 1,089-text-node contrast audit clean except the logo monogram |
| 2026-09-24 | `/better-interface` | 11 findings (0 HIGH, 4 MEDIUM, 7 LOW), verdict Approve; 3 MEDIUM fixed, 1 decision open |
| 2026-09-24 | Fixes | Matrix +11 rows (12 added, 1 hypothetical row removed), resolutions, `focus-ring` token + specimen `H8com`, badge icons 16; dark header moved to (1360, 4880); `prd/02` `focus-ring` + `surface-hover` rules |
| 2026-09-24 | Step 12 change (`Label Small`) | `type-label-sm-size` 11 → 12, `type-label-sm-lh` 1.4545 → 1.3333 (same 16 px line), `type-label-sm-tracking` 0.275 → 0.3; `SectionHeader` `Index` `Gpvrl` bound to the tokens; Label Small now equals Label Medium (12 / 16 / 600 / 0.3); PRD 02 type table (Label Small 11 / 16) to be updated in step 19 |
