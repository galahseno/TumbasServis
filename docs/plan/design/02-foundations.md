# Step 02 — Foundations (tokens, type, elevation, glass, icons, logo)

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | — (foundation for all P0/P1) |
| **Owns screens** | — |
| **Owns components** | `TsLogo` |
| **PRD refs** | [02](../../../prd/02-brand-design-system.md) (color, typography, spacing, elevation, glass, iconography, motion, logo), [06](../../../prd/06-responsive-layout.md) (grid) |
| **Pen location** | `01 Foundations` row: Color, Type, Spacing & Radius, Elevation, Glass, Icons, Motion, Logo boards |
| **Depends on** | Step 01 |
| **Claude session** | `docs/claude-session/04-design-step02-foundations.md` (written after approval) |

## Goal

Encode the PRD 02 design system as Pencil **variables** (light/dark themes) and specimen boards, so every later frame uses tokens only. Resolve the known contrast problems in the raw tokens before components are built on top of them. Build the `TsLogo` component family.

## Inputs

- PRD 02 primitives and semantic tables (light/dark), status colors, type scale, spacing 4-pt scale, radius, shadow, glass, iconography, motion, logo rules.
- Step 01 results: type-unit conversion rule, glass approximation, window-class decision.
- Token risks in [`00-index.md`](00-index.md#known-token-risks-decide-in-step-02).

## Open questions (ask at kickoff)

1. **Text-muted on light (≈ 3.6–3.8 : 1).** Options: (a) darken `text-muted` (e.g. toward `sand-600`, ~`#6E665F`), keep PRD name; (b) keep the hex, restrict to ≥ 18.66px bold / non-essential text; (c) both. *Recommended (a): `text-muted` carries real content (captions, hints, timestamps).* Update `prd/02` after approval.
2. **Status colors as text on light.** Add `success-text`, `warning-text`, `info-text`, `danger-text` (darker, ≥ 4.5:1) and `*-soft` tint backgrounds for badges? *Recommended yes* — same deliberate-divergence pattern as `orange-600` in PRD 02.
3. **Control boundaries ≥ 3:1.** Introduce a `border-control` token (≈ `sand-500` light) for input/checkbox/chip boundaries, keeping `border-default` for decorative dividers? *Recommended yes.*
4. **Glass border/sheen values.** PRD names `glass-border` and `glass-sheen` but gives no values. Re-extract from the source site CSS (`galahsenoadjie.vercel.app`) or derive (white @ 60% / white @ 30% light; white @ 10% / 6% dark)?
5. **Text styles.** Pencil has no text styles. Recommended: reusable text nodes on the Type board (`Type / Headline Large` …) + number variables. OK?
6. **System chrome.** Confirm Android status bar 24dp + gesture inset 24dp instead of the Pencil guide's iOS 62px.
7. **Exo 2 weights** actually shipped in the Flutter variable font: confirm 400/600/800 only.

## Scope

### Variables

| Group | Variables |
|---|---|
| Primitives (color) | `orange-100/300/400/500/600`, `sand-0/50/100/200/300/400/500/700/900/950`, `green-400`, `red-400`, `warning-400`, `info-400` (+ any `sand-600` decided in Q1) |
| Semantic (color, themed `mode`) | Full PRD 02 table: `bg-page`, `surface-card`, `surface-inset`, `surface-hover`, `text-heading/body/muted/faint`, `accent`, `accent-hover`, `text-accent`, `text-on-accent`, `accent-soft`, `border-subtle/default/strong/accent`, `success`, `danger`, `warning`, `info` + additions from Q2/Q3 |
| Button fill split | `accent-fill` (light `orange-600`, dark `orange-400`) — the WCAG divergence from PRD 02 — vs `accent` (brand surfaces/indicators) |
| Alpha values | `accent-soft` dark = `orange-400 @ 16%` (`#FF855129`); glass tint light `#FFFFFF6B` (42%), dark `#1C191866` (40%) |
| Spacing | `space-1…space-12` = 4, 8, 12, 16, 20, 24, 32, 40, 48 |
| Radius | `radius-sm` 8, `radius-md` 12, `radius-lg` 16, `radius-xl` 22, `radius-pill` 999 |
| Type | `font-family` = Exo 2; size/weight/letter-spacing/line-height per role (below) |
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
| Label Small | 11 / 16 | 1.455 | 600 | +0.025em (+0.275) |

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

## Checklist

### Build
- [ ] Kickoff questions answered; PRD 02 updated for any approved token divergence.
- [ ] Primitives + semantic variables created via `SetVariables` with `mode` themes; `GetVariables()` output matches the PRD tables.
- [ ] Spacing, radius, type variables created; type scale reusable text nodes built.
- [ ] Color, Type, Spacing & Radius, Elevation, Glass, Icons, Motion boards built.
- [ ] Contrast matrix built from resolved values; every fail has a documented resolution.
- [ ] Dark-mode toggle demonstrated: every board copy with `theme:{mode:"dark"}` re-resolves with no manual edits.
- [ ] `TsLogo` variants built as reusable components; app-icon + splash mark exported.
- [ ] Icon list complete for all PRD 04 screens (cross-checked against the screen inventory).

### Quality (automated, run in `execute`)
- [ ] Clipping check on every board → zero `problems`.
- [ ] Raw-hex audit → zero outside the primitive definitions themselves.
- [ ] Every text/background pair used by a token resolves to ≥ 4.5:1 (text) or ≥ 3:1 (UI/large) in both modes — or is listed as decorative-only.
- [ ] Every node named; `placeholder` cleared.

### /better-interface
- [ ] Run `/better-interface` with scope = foundation boards (names + node ids). Color and Typography domains are primary; Accessibility = contrast + naming of icon semantics; Layout/Writing/UI as applicable (mark which are `Not reviewed: no screens yet`).
- [ ] Report recorded below; all HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: Color board (both modes), contrast matrix, Type board, Logo family, app icon.
- [ ] Every review round logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] PNG export of boards to `design/pencil/exports/step02/`; app icon 1024 PNG.
- [ ] Claude session file written.
- [ ] Tracker in `00-index.md` set to ✅.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
