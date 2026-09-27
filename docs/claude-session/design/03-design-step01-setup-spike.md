# Claude Session Log — 03: Design step 01 — Setup & Figma-conversion spike

**Tool:** Claude Code + Pencil MCP + local Chromium (Playwright) for HTML render checks, models Opus 5.5 / Sonnet 5
**Date:** 2026-09-23
**Topic:** Lock the Pencil → Figma path in the design plan, then run step 01: create the `.pen` scaffold, prove the Pencil features the plan relies on, fix the demo content, and get the user's approval on a Figma path.

---

## Initial prompt

> i want to do docs/plan/design/00-xx
> i plan to convert pen to figma later use this plugin https://www.figma.com/community/plugin/1601664618009066049/pen-dev-to-figma-free
> interviewme with detail if need

Later turns that changed the plan:

> the result of plugin is not reliable much, i try other and same, let explore to use this flow https://html2figma.com/blog/pen-dev-to-figma/

> this perfect like we want, approve

## Research performed

1. Read `docs/plan/design/00-index.md`, steps 01, 04, 12, 19, 20, 21 and `docs/claude-session/02-design-plan.md`; `prd/02`, `prd/03`, `prd/04`, `prd/05`, `prd/06` for tokens, business rules and the wireframe numbers.
2. The plugin's community page returned HTTP 403, so its claims came from search snippets only (components, theme-mode variables, icons, auto layout) and stayed **unverified**. Found three other `.pen` importers as fallbacks.
3. Figma limits: Starter plan = 3 files, 3 pages per team file, unlimited Drafts; variable modes documented only for Education/Pro/Org/Enterprise; Figma MCP on Starter = about 6 reads/month, so no MCP.
4. Pencil skill docs: `SKILL.md`, `execute.md`, `pen-schema.md`, `guide/components.md`.
5. html2figma blog and site: takes a **local `.html` file** by drag-and-drop, free; blog says components flatten and variables are not carried.
6. Verified the HTML export in the file and in Chromium (Playwright): layout, Exo 2, shadows, glass, icons, illustration and gradients match Pencil's PNG; no components/variables/themes in the HTML.

## Clarifying interview (`AskUserQuestion`, 3 rounds)

**Round 1 — scope and setup**
| Question | Answer |
|---|---|
| Session scope | Update the plan docs, then run step 01 |
| Pen file name | `TumbasServis.pen` (Save As) |
| Figma plan | Starter (free) |
| How Claude verifies Figma output | "Connect Figma MCP" (then dropped in round 2) |

**Round 2 — consequences of Starter**
| Question | Answer |
|---|---|
| Light/Dark modes and pages on Starter | Decide after the spike |
| MCP budget | Skip the MCP |
| Import cadence | Spike in 01, test import after 04 and 12, full import in 20 |
| Window classes | Device type by `shortestSide ≥ 600`, layout class by width |

**Round 3 — kickoff questions**
| Question | Answer |
|---|---|
| Demo price set | Approved: A Rp85.000 · B Rp143.000 · C Rp200.000 → Rp428.000, −Rp42.800, Rp385.200, 2 jam |
| Demo date | **Sel, 29 Sep 2026** (PRD's "Sen" is wrong: 29 Sep 2026 is a Tuesday) |

## Execution

**Part A — plan amendments.** `00-index.md` (decision log, Figma-plugin compatibility rules, Pencil facts, risks, tracker), steps 01, 02, 03, 04, 12, 19, 20 (rewritten for Route B), 21; `prd/06` window-class text fixed.

**Part B — Pencil (`design/pencil/TumbasServis.pen`).**
- Tokens: 19 primitives, themed semantic tokens (`mode` light/dark), `accent-fill`, `glass-tint`, `glass-border`, `font-family`, spacing and radius numbers.
- Scaffold: `SectionHeader` `kcsFb`; anchors `kl83c` `m5khVn` `OwQde` `URsZs`. `00 Cover` `CWn50`. `98 Demo Content` `isFgy` (price arithmetic re-derived from its text nodes). Approved sample `Illustration / Empty Garage` `eWWX8`.
- Smoke tests in a temporary `99 Spike`, all passed or logged with a workaround (table in `01-setup-spike.md`). Spike deleted at close after moving `eWWX8` out.

**Routes.** Route A (`.pen`-importer plugins) was tried by the user, judged unreliable and dropped; its scoring table was never filled. Route B (`html-css` export → html2figma) was tested by the user on `cover.html`, `phones.html`, `components.html` and approved.

**Close.** Automated checks on 239 nodes: 0 raw hex, 0 unnamed frames, 0 clipping (excluding `Decor` bleed shapes), 0 placeholders. PNG exports in `design/pencil/exports/step01/` with an `INDEX.md`.

## /better-interface

Scope: `00 Cover` + illustration sample only. Accessibility and Layout marked not reviewed (no product UI). Result: 2 MEDIUM + 1 LOW, verdict Approve.
- **Fixed:** illustration had 20 raw hexes, none in the palette → snapped to palette tokens (32 nodes); Cover `Description` 18 → 16, `Version`/`Stack` 13 → 14.
- **Carried:** illustration dark-mode policy (step 03), 64 px hero and monogram (step 02). **LOW left:** 11 px swatch captions.
- Contrast measured for every Cover pair: all pass; tightest is the 12 px eyebrow at 4.64 : 1.

## Review rounds

Round 1 — user approved: "this perfect like we want, approve" (after running html2figma). No screenshots or per-feature scores were shared.

## Key decisions worth flagging to a reviewer

- **Route B is approved on the user's verdict only.** Claude could not see Figma; the Chromium render proves the export side, not the import.
- **Components and variables do not survive the HTML export.** Step 20 rebuilds them by hand; Route C (a Figma development plugin fed by a Pencil JSON manifest) is the escape hatch.
- **Starter workaround is a default, not a verified result:** Draft file, Light/Dark as two collections; variable modes and the Draft public link still need checking (step 12, step 20).
- **PRD errors found and settled here, PRD text fixed in step 19:** wrong weekday (29 Sep 2026 is a Tuesday), inconsistent S11/S16/S18 prices, the S11 wireframe plate `AB 1234 XY` on Beat.
- **Pencil facts worth knowing:** `letterSpacing` is px and `lineHeight` a multiplier; no filled icon variant; `Export` paths resolve from the project root and files are named by node id; HTML export halves the blur radius (PRD `blur(14px)` = Pencil 28) and turns centered strokes into `outline` (use inner alignment).
- **Slips to be aware of:** a first export wrote a stray `exports/` folder at the project root (removed); the `.pen` existed only in memory until the user saved it; 8 nodes the user (or Pencil) added to the root were found at close and **left untouched** — the user decides whether to keep them.

## Output

- `design/pencil/TumbasServis.pen` (scaffold, Cover, Demo Content, approved illustration component).
- `design/pencil/exports/step01/` (3 PNGs + `INDEX.md`); `design/pencil/exports/spike-test/` (Route B HTML + Chromium renders, removable once step 20 starts).
- `docs/plan/design/` steps 00–04, 12, 19, 20, 21 updated; `prd/06-responsive-layout.md` edited.
- No commits.
- Next: step 02 (`docs/plan/design/02-foundations.md`).
