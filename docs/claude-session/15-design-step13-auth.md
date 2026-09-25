# Claude Session Log — 15: Design step 13 — Auth (S01 Splash · S02 Onboarding · S03 Login · S04 OTP)

**Tool:** Claude Code + Pencil MCP + `/better-interface` skills, model Sonnet 5
**Date:** 2026-09-24 – 2026-09-25
**Topic:** Kickoff interview, "Auth blocks" component sheet (`OtpInput`, `AuthLink`, `TermsNote`, `AuthHero`, `OnboardingContent`, `AuthCard`, onboarding art vignettes, numeric keyboard), 33 frames (S01 – S04 on phone, Tablet-Portrait, Tablet-Landscape, light + dark), fallback from `Generate(svg)` to component vignettes.

---

## Initial prompt

> i want to do docs/plan/design/13-xx, interviewme with detail if need

(Started in plan mode; the plan was approved before any edit.) Later turns: "do rest" (after the vignette fallback and the numbers were in), then at the review gate:

> approve

## Research performed

1. Read `docs/plan/design/00-index.md` (conventions, Pencil facts, decision log, demo content, canvas layout, templates), the step 13 stub, the step 11 file (kickoff-decision format), the PRD sections `prd/04` S01 – S04, `prd/03` F1, `prd/06` rows S01 – S04 and `prd/02` logo / splash.
2. Found while planning: (a) the step file's illustration budget (3 of ≈ 11) and the two dark-mode recipes in the repo (step 03 sticker tile vs step 04 token-bound art); (b) PRD copy voice is "kamu" (existing frames use it, no "Anda"); (c) `TsLogo` lockups, `TsTextField` prefix / error masters, `PageIndicator`, `System / Keyboard` already exist; (d) the last tablet rows end at y 83,886, the last phone rows at y 48,339, so the tablet block had to move.
3. Pencil pre-flight: `get_app_state`, `read_skill` (SKILL, `execute`, `pen-schema`), root listing, reads of `TsTextField` Default / Focused / Error, `TsButton` Primary / Ghost, `TsAppBar / Type=Back`, `PageIndicator`, `TsLogo` marks and lockups, `System / Keyboard`, the S18 phone frame and the sheet skeleton of `Components / Ticket & Success`.

## Clarifying interview (`AskUserQuestion`, 3 rounds, 10 questions)

Every recommended option accepted. The extra-frames question (multi-select) kept only the recommended keyboard-open frames.

**Round 1 — art, splash, OTP hint, Tablet-L pane**
| Question | Answer |
|---|---|
| Onboarding art | `Generate(svg)`, token-bound (later replaced, see below) |
| Splash | Mark-only default + 1 wordmark end-state phone frame (light + dark) |
| OTP demo hint | Visible "Kode demo: 123456" line |
| Tablet-L auth pane | `AuthHero` reusing the slide-1 art, no fourth generation |

**Round 2 — layout, validation, extras**
| Question | Answer |
|---|---|
| S02 phone | Art band on top (~55 %), text + indicator + CTA below |
| S03 / S04 phone | Top-aligned, left text, terms pinned at the bottom |
| S03 validation | CTA always enabled, error on submit / blur |
| Extra frames | Keyboard-open S03 and S04 only |

**Round 3 — OTP submit, sessions**
| Question | Answer |
|---|---|
| OTP submit | "Verifikasi" only (disabled until 6 digits), no auto-submit |
| Sessions | One session |

**Build-time question (Round 4, 1 question):** `Generate(svg)` delivered nothing → the user chose **"Fall back to component vignettes"** over waiting or retrying.

## Execution

- **Docs (kickoff record):** step 13 file rewritten (10 decisions, defaults, 33-frame matrix, layout, components, copy, annotations, checklist), `00-index.md` (decision-log row, demo-content row, inventory row, tracker).
- **Canvas prep:** Flows – Tablet block (124 root nodes) moved down 9,000 dp (anchor y 59,000); phone rows y 49,000 – 58,386, tablet rows y 95,000 – 106,386; sheet `Components / Auth Blocks` `ukN2m` at x 34888 (dark copy `XPAMy`, y 12380).
- **`Generate(svg)` failure:** slide 1 attempted 3 times (nested `VaMzH`, root `FoVos`, plain root `zvHdw`) plus a 120 px probe `J6nEIN`: all empty, flag cleared, nothing after ~20 calls; all 4 frames deleted. Fallback = component vignettes, 11 → 8 illustrations used.
- **Components (sheet `ukN2m`):** `System / Keyboard Numeric` `VDcFy`; `OtpInput` Focused `gmCXF` / Filled `t1Fvk` / Error `q2WBg` / Loading `H4Mu2`; `AuthLink` `U6nZrD` / `wZhQZ`; `TermsNote` `wTB1l`; `OnboardingContent` `a1Gd4`; `AuthCard` `I5Qwg`; `AuthHero` `LqEdW` (Large slide-1 vignette in its `Hero Art`); `OnboardingArt` Slide 1 / 2 / 3 Phone `P8fJJ` / `VIyOa` / `D5weG` and Slide 1 Large `NDee7`; focus specimens `t2h6eL`.
- **33 frames:** S01 ×8, S02 ×8, S03 ×8, S04 ×9 (ids in `docs/plan/design/13-auth-s01-s04.md`, *Frame ids*); 4 row-header pairs per screen, 4 handoff-note frames (8 notes) with explicit heights.
- **Build fixes found by screenshots and audits:** masked number wrapped mid-number → own line + "Ganti nomor" in a row; ghost `TsButton` indented links 16 dp → `AuthLink`; terms line cannot hold inline spans → two-line `TermsNote`, "TumbasServis" dropped so it fits at ×1.3; onboarding Tab-P band 400 → 360.
- **Automated checks:** clipping 0 (35 roots, `resolveInstances:true`, disabled chains skipped); raw hex 0 on 3,934 nodes; unnamed nodes 1,938 = step 04 silhouette internals (exempt); placeholders cleared; contrast 684 nodes on frames (266 dark) + 228 on sheets, 3 failures fixed (`Lewati` 4.10 → `text-on-accent-soft`, `Wordmark Servis` in `AuthHero` 4.10 → `text-on-accent-soft`, timeline check 2.58 → `success-soft` / `success-text`), min 3.49 : 1 after fixes; text < 12 sp 0 of 516; ×1.3 on S03 default / invalid and S04 default / wrong and 360×640 on S03 / S04 default (0 clip rows), 6 throw-away copies deleted.
- **Pencil findings** (written to `00-index.md`, "Verified in step 13"): `Generate(svg)` can silently deliver nothing and its flag is not a progress signal; visitor `Get` on a frame with a replaced slot needs `resolveInstances:true`; fresh frames screenshot blank 2 – 3 calls; ref override recipes; absolute overlays hide from a parent-chain contrast audit; ghost `TsButton` indent; dark sheet re-copy after adding sections.
- **Export at close:** 33 frames in `design/pencil/exports/step13/` + 2 sheets in `…/step13/components/` and `INDEX.md`, verified with `ls` (33 PNG in the folder, 2 in `components/`).

## /better-interface

All six domain skills applied to the 33 frames and both sheets. 1 HIGH + 2 MEDIUM fixed:
- HIGH accessibility — new `AuthLink` and the terms links had no designed focus state: "Focus specimens" section added (`Ganti nomor`, `Kirim ulang kode`, `Lewati` on `accent-soft`, `Syarat & Ketentuan`).
- MEDIUM accessibility — clear button had no semantics label and no focus order anywhere: S02 / S03 / S04 notes now state "Hapus nomor" and the orders.
- MEDIUM color — `focus-ring` (orange-500) is 2.92 : 1 on `accent-soft`: the `Lewati` specimen uses `text-on-accent-soft`; the shared token goes to step 19.
- 3 LOW left: "Verifikasi" disabled until 6 digits (kickoff decision 9), period underlined inside the "Kebijakan Privasi." link, S02 phone titles 22 sp vs 28 sp on S03 / S04.
Verdict Approve.

## Review rounds

Round 1 — user replied "approve"; no changes.

## Key decisions worth flagging to a reviewer

- **No generated art:** the three onboarding illustrations are component vignettes on the tonal panel (silhouettes + ticket, motor cards + service pills, status timeline + `FleetProgress`); theme-aware by construction, no palette snapping. `AuthHero` reuses the slide-1 Large vignette. The illustration budget stays at 8 of ≈ 11.
- **CTA states:** S03 "Kirim kode OTP" is never disabled (validate on submit / blur); S04 "Verifikasi" is disabled until 6 digits with no auto-submit. The two differ on purpose (kickoff decisions 7 and 9); `better-accessibility` prefers the S03 pattern for both (step 19 to confirm app-wide).
- **Demo mode:** "Kode demo: 123456" is a visible info line meant to sit behind a Flutter demo flag.
- **Text links:** "Ganti nomor" and the resend control are 48 dp `AuthLink` (zero side padding, focus specimens), not ghost buttons; terms links are inline, underlined `text-accent`.
- **Numeric keypad:** the keyboard frames use a new design-only numeric pad because the fields are phone / OTP inputs.
- **Focus ring on tonal surfaces:** `focus-ring` measures 2.92 : 1 on `accent-soft`; step 13 uses `text-on-accent-soft` locally, the token decision is carried to step 19.
- **Canvas:** the Flows – Tablet block moved down another 9,000 dp; all row positions are in the `00-index.md` layout paragraph.

## Output

- Pencil (`design/pencil/TumbasServis.pen`, unsaved until the user presses Cmd+S): sheets `ukN2m` / `XPAMy`, 33 frames, row headers and notes in the Flows – Phone / Flows – Tablet blocks.
- Exports: `design/pencil/exports/step13/` (33 PNG + `INDEX.md`, sheets in `components/`).
- Docs: `docs/plan/design/13-auth-s01-s04.md` (decisions, built ids, report), `00-index.md` (decision log, demo content, inventory, tracker ✅, canvas layout, Pencil facts, risk row), `19-full-app-audit.md` (PRD / token items collected in step 13).
