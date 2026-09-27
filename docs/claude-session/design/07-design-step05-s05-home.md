# Claude Session Log — 07: Design step 05 — S05 Beranda (Home) + AppShell

**Tool:** Claude Code + Pencil MCP + `/better-interface` skills, model Sonnet 5
**Date:** 2026-09-24
**Topic:** Run the step 05 kickoff interview, build the reusable `AppShell` (12 masters) and the Home blocks, design S05 on phone / tablet-portrait / tablet-landscape (light + dark, loading / empty / populated + stress frames), run `/better-interface`, fix HIGH + MEDIUM findings, get the user's approval and export the key frames.

---

## Initial prompt

> i want to do docs/plan/design/05-xx, interviewme with detail if need

Later turn (review gate):

> i don't think we need Pause Play Button beside the pageindicator in home screen, remove it and approved after that, finish all left

## Research performed

1. Read `docs/plan/design/05-s05-home.md`, `00-index.md` (conventions, Pencil facts, decision log), `03-components-core.md` and `04-components-booking.md` (masters, recipes, decisions), `19-full-app-audit.md`, and the previous session log `06-design-step04-components-booking.md`.
2. Read `prd/04` (S05), `prd/03` (F2 entry points and draft, F3 tracking, business rules: in-service motors blocked, unit status machine, booking code format) and `prd/06` (S05 row, nav patterns per window class).
3. `get_app_state` (file open, 149 variables) and reads of the masters this step composes: `TsAppBar`, `NavBar`, `NavRail`, `VehicleSelectCard` compact, `PromoBanner`, `UnitStatusBadge`, `TsButton`, `TsIconButton`, `TsDialog`, `Skeleton`, `System / Status Bar`, `System / Gesture Bar`, silhouettes. Pencil `pen-schema`, `execute` and `components` docs (slots, refs, overrides).
4. Found a data conflict before the interview: all 3 canonical motors are in the active booking, so PRD 03 blocks them from any draft, yet the populated frame needs a draft.
5. `better-*` skills (accessibility, layout, writing, typography, colors, ui) loaded for the review.

## Clarifying interview (`AskUserQuestion`, 4 rounds)

Every recommended option was accepted.

**Round 1 — data conflict and content**
| Question | Answer |
|---|---|
| Draft vs in-service motors | 4th motor: sheet-only Supra X 125 (bebek); draft = Supra X 125 only; Empty state = same 3 motors without badges |
| Mini progress | One segment per unit, filled by that unit's stage, plus a text label |
| Several active bookings | Stack max 2 + "Lihat semua (n)" |
| Empty state emphasis | Larger hero card + matic silhouette (no new `Generate`) |

**Round 2 — draft, greeting, tablet grid, shell**
| Question | Answer |
|---|---|
| `DraftResumeCard` | Resume + visible discard (confirm dialog), expiry always shown, warning under 3 h |
| Greeting emoji | Keep 👋, verify the render (`waving_hand` as fallback) |
| Tablet-portrait grid | Hero spans, then paired cards, promo and garage span, two quick links |
| `AppShell` scope | All 12 masters now |

**Round 3 — garage, promo, tablet bar, loading**
| Question | Answer |
|---|---|
| Garage strip | Compact status badge on in-service motors |
| Promo carousel | 3 slides; phone 1 + peek, 800 one wide, 1280 two-up; auto-advance 5 s with pause on touch / focus, off with reduce-motion |
| Tablet app bar | No logo (rail has it); greeting as title, bell on the right |
| Loading | Real: bar, greeting, CTA, nav, quick links; skeleton: booking area, promo, garage |

**Round 4 — booking card, status, quick links, export**
| Question | Answer |
|---|---|
| `ActiveBookingCard` | + workshop and schedule line |
| Status wording | Most common unit status ("3 motor · Dikerjakan") + caption when units differ |
| Quick links | Two tiles, icon disc + label + chevron |
| Export | Key frames only |

## Execution

- **Docs (kickoff record):** step 05 file rewritten with 16 decisions, `00-index` (tracker, inventory additions, demo content row), `19-full-app-audit.md` (PRD 04 S05 corrections).
- **Shell sheets** (light y 8760, dark copies y 12380): Compact `sxbrl` (x 17760), Medium `nZsOR` (x 19448), Large `AW1Ie` (x 21248). 12 `AppShell` masters; the slot was smoke-tested with an instance height + `Nav Bar` y override.
- **Home blocks** `giPiP` (x 24008): `FleetProgress` (6 segments, 5 minis, hard-stop gradient fill), `ActiveBookingCard` ×2, `DraftResumeCard` ×2, `BookingCtaCard` ×2, `QuickLinkTile`, `SectionTitleRow`, compact In Service card, `GarageAddTile`, bell states, `TsAppBar / Type=Title, Actions=Bell`, notes; later the focus / pressed specimens.
- **Frames (17):** phone `jcjrw` `ALXSJ` `P1iEfF` `HHBLg` + stress `HcsZK` `oleh5` + dark `cqX7g` `W9lsjI` `k9oVN`; tablet-portrait `d6h0h` `T9GQUw` `XnxOx` + dark `TFJWb`; tablet-landscape `zjTd6` `p69Dk` `AxrXi` + dark `Ty36e`. `Flows – Tablet` anchor moved to y 20000. Notes boxes and an 800 dp fold marker beside the rows.
- **Automated checks:** clipping 0 (the clipped 360×640 viewport, scroll viewports and `Decor` exempt), raw hex 0, unnamed 0, placeholders 0, 224 interactive nodes ≥ 48 × 48, contrast on 447 text + 199 icon nodes in both themes 0 fails (logo monogram 3.45 : 1 is a logotype). The ×1.3 stress frame found the bell badge's fixed height clipping its count (fixed in the step 03 master).
- **Pencil findings** (written to `00-index`): slots work for screens; hug-parent "circular" warnings are false positives when a sibling has a definite size; hard-stop gradients give crisp progress fills; `Update` with `descendants` merges; `Replace` on a nested ref inside a master failed (`Delete` + `Insert` works); emoji renders monochrome; notes need their heights re-read after a text edit.

## /better-interface

Scope: 17 frames + Shell / Home blocks sheets + dark copies. 13 findings (1 HIGH, 5 MEDIUM, 7 LOW), verdict Block → **Approve** after fixes.
- **HIGH fixed:** tappable tiles and garage cards had no focus or pressed state (specimens added).
- **MEDIUM fixed:** Draft "Lanjutkan" was a second filled primary (now tonal secondary); `FleetProgress` fill vs track 2.24 : 1 (outline + lighter track, 3.07 : 1); a 3-line garage nickname (2 lines + ellipsis); bell badge fixed height clipped at ×1.3 (content height).
- **MEDIUM declined by the user:** a visible pause / play button for the promo auto-advance (WCAG 2.2.2). Built, then removed at the review gate.
- **LOW fixed:** redundant status caption on a single-unit booking; bare "Lihat semua" links (semantics labels).
- **LOW left for the user:** tablet "Lihat semua" inset, tablet hero spacing, promo CTA is a filled primary, "Hapus draft" is an accent ghost, 11 px badge text.

## Review rounds

Round 1 — "i don't think we need Pause Play Button beside the pageindicator in home screen, remove it and approved after that, finish all left". The pause / play masters, specimen section and 7 indicator-row instances were removed; frame heights re-measured (phone 1370 / 1019 / 1208, landscape 981 / 800); stress ×1.3, dark frames and the dark Home sheet regenerated; checks re-run clean; approved.

## Key decisions worth flagging to a reviewer

- **Home populated adds a 4th motor and a draft** because PRD 03 blocks in-service motors from a draft; the Empty state is the earlier moment with the same 3 motors and no badges.
- **Status label rule for the domain layer:** the unit status shared by most units, ties → earliest stage, caption when units differ. PRD 03's derived `Berlangsung` is not shown on the card.
- **The promo auto-advance has no visible pause control** (declined by the user). Mitigations: pause on touch / focus / hover, off with reduce-motion, non-interactive dots. WCAG 2.2.2 stays an open risk noted in the report and in step 19.
- **Draft "Lanjutkan" is secondary (tonal)** so the filled orange is the booking CTA only; "Hapus draft" is still an accent ghost as decided at kickoff, although step 03 says destructive triggers use Danger Outline.
- **Screens are `AppShell` instances** with a measured height and a `Nav Bar` y override; phone frames are full-scroll captures with an 800 dp fold marker.
- **Master edits made during the step:** `TsIconButton` badge height (step 03), `FleetProgress` outline, `DraftResumeCard` button type.
- **Not verified:** Flutter rendering (glass, shimmer, carousel, ripple), 320 px width / 200 % zoom, RTL, Exo 2 tabular figures, screen-reader output, the colour emoji, Figma-side fidelity (first S05 import is step 12).
- **Unsaved file:** the `.pen` on disk may lag Pencil's memory until the user saves (Cmd+S); Claude cannot confirm the disk state.

## Output

- `design/pencil/TumbasServis.pen` (4 sheets + 4 dark copies, 17 S05 frames, notes boxes, fold marker).
- `design/pencil/exports/step05/` (8 PNG: 6 frames + Home blocks + Shell · Compact, and `INDEX.md`), verified with `ls`.
- `docs/plan/design/05-s05-home.md`, `00-index.md` (tracker ✅, inventory, canvas layout, Pencil facts), `19-full-app-audit.md` updated.
- No commits.
- Next: step 06 (`docs/plan/design/06-s10-pilih-motor.md`).
