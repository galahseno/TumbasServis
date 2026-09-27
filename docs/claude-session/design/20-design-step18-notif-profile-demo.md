# Claude Session Log — 20: Design step 18 — Notifications, Profile, Demo panel (S06, S25, S26)

**Tool:** Claude Code + Pencil MCP + `/better-interface` skills, model Sonnet 5
**Date:** 2026-09-25
**Topic:** Kickoff interview (4 rounds, 14 decisions), "Notification & Settings Blocks" component sheet, 31 frames (S06 Notifikasi, S25 Profil, S26 Mode Demo on phone, Tablet-Portrait, Tablet-Landscape, light + dark, plus dialogs, sheet / modal, extra states and text ×1.3 stress), `/better-interface` pass, export.

---

## Initial prompt

> i want to do docs/plan/design/18-xx, interviewme with detail if need

(Started in plan mode; the plan was approved before any edit.) At the review gate:

> approve

## Research performed

1. Read the step 18 stub (status ⬜, 7 open questions, 22-frame matrix), `00-index.md` (conventions, Pencil facts, decision log, demo content, canvas layout, inventory, tracker, templates, `/better-interface` mapping for Pencil), the step 17 file and session log (kickoff-decision format, lane recipe), `prd/04` S06 / S25 / S26, `prd/05` (`DemoModeController`, `TrackingSimulator`, seed data, `NotificationRepository`), `prd/06` S06 / S25 / S26 rows, `19-full-app-audit.md` block F.
2. Found while planning: (a) PRD 04 S06 says a promo opens "S17 or Home", but step 10 made S17 reachable only from S16; (b) PRD 04 S26 says "slider" while the stub itself recommended a segmented control; (c) the stub listed logout as a danger action although logout only clears the session (data persists locally, PRD 05); (d) Pencil has no stroke dash, so "dashed Mode Demo surfaces" would be a row of rectangles; (e) `DemoModeShortcut` (step 16) already sets the demo look; (f) the S05 bell shows 2 unread, so S06 must show the same moment; (g) S25 Tab-L "active panel" needs content that is not a nested two-pane S26.
3. Pencil pre-flight (read-only, plan mode): `get_app_state` (all reusable components; no `NotificationTile`, `TsSegmentedControl` or `SettingsRow` existed), `Get` on `DemoModeShortcut`, `TsSwitch`, `EmptyState / Notifikasi`, `TsDialog` variants, `TsAppBar` Back / Title, `AppShell` Profil (three sizes), the S05 phone / Tab-P / Tab-L frames (rail 80 / 240, content 720 / 1,040), `TsChip` (selected style), compact `TsButton`, `StatusTimeline`, `SectionTitleRow`, the Invoice sheet (sheet skeleton).

## Clarifying interview (`AskUserQuestion`, 4 rounds, 14 questions)

Every recommended option accepted (the "extra frames" multi-select was answered "pick recommended"; all four options were taken).

**Round 1 — S06**
| Question | Answer |
|---|---|
| App moment | Same as S05: Sel 29 Sep ≈ 10.30, 2 unread |
| Read state | Dot + semibold + hidden label; "Tandai semua dibaca"; no swipe-delete |
| Deep links | Unit → S21, invoice → S23, promo → S10 with the voucher, reminder → S10 with the motor |

**Round 2 — S25**
| Question | Answer |
|---|---|
| Notifikasi toggle | One master switch, off state annotation only |
| Tab-L right panel | "Pratinjau tema" (forced-theme mini app) |
| Logout dialog | Neutral confirm, session only, data kept |
| Tentang sheet | Version + demo note + "Dibuat oleh Galah", no links, no AI mention |

**Round 3 — S26**
| Question | Answer |
|---|---|
| Speed control | Segmented Mati / 15 dtk / 5 dtk (`TsSlider` dropped) |
| Controls | Per-unit rows + booking-level "Majukan semua / Reset semua" |
| Error simulation | One-shot, auto-disarm, armed banner on S26 only |
| Reset data | Seed data, session / theme / demo settings kept, back to Home |

**Round 4 — identity, extras, canvas**
| Question | Answer |
|---|---|
| Demo identity | Reuse the S21 `DemoModeShortcut` language |
| Extra frames | S26 no booking / Selesai, S06 all read, ×1.3 stress on all three |
| Placement | Own "Step 18" lane, no shifts |

## Execution

- **Docs (kickoff record):** step 18 file rewritten (14 decisions, defaults, demo content, 31-frame matrix, layout, components, annotations, checklist); `00-index.md` decision-log row, demo-content row, inventory row (`TsSlider` removed), tracker 🟡; `19-full-app-audit.md` step 18 block.
- **Component sheet `nUFiI`** (x 41832, dark copy `w4hH6t`): `NotificationTile` (3 categories × read / unread + loading), `NotificationGroupHeader`, `TsSegmentedControl` (Icon+Label / Label × 3 selected), `SettingsRow` ×4, `UserCard`, `ThemeSetting`, `AboutContent`, `ThemePreview` ×3, `DemoPanel` (slot), `DemoUnitRow` ×3, `ErrorSimBanner`, `DemoPreviewPane`, compact disabled outline button, focus specimens. Ids in `docs/plan/design/18-notif-profile-demo.md`, *Built*.
- **31 frames** in the "Step 18" lane (x 37,000, y 36,000 – 56,904): S06 ×10, S25 ×10, S26 ×11, 12 row headers, 3 handoff-note frames. Phone frames are plain frames (S06, S26) or `AppShell` instances (S25); dialogs / sheet / modal = wrapper frame + `Copy` of the screen + scrim + overlay; dark = `Copy` with `theme: dark`; stress = `Copy` + font-size ×1.3 on every resolved text node.
- **Found while building:** ×1.3 stress showed the S06 app-bar title wrapping beside the long action (action moved to the first group header) and the S26 booking buttons overflowing (stacked column); the first S26 frames carried a 0.9 dp child offset that the clipping check reported (`Copy` + `Delete` cleared it); the dialog button overrides keyed by name failed because the names contain `/` (ids used); the contrast audit flagged the selected unit row (fill changed to the card surface).
- **Automated checks:** clipping 0 (33 roots, `resolveInstances: true`, disabled chains exempt), raw hex 0, unnamed 0, placeholder 0, text < 12 sp 0, coverage 31 / 31; contrast 1,542 text + icon nodes, 5 fails = logo monogram (exempt logotype).
- **Export at close:** 31 PNG in `design/pencil/exports/step18/` + 2 sheets in `…/step18/components/` + `INDEX.md`, verified with `ls`.

## /better-interface

All six domain skills applied to the 31 frames and both sheets.
- HIGH ×1 (fixed): the new tappables (`NotificationTile`, `SettingsRow`, segmented segments, `DemoUnitRow`) had no designed focus state → focus specimens with the 2 dp `focus-ring`.
- MEDIUM ×6 (fixed): repeated "Majukan" / "Reset" with no unit in the name and missing live-region announcements (Semantics notes); promo / reminder discs borrowing the info / warning ramps (neutral discs); selected unit row below 4.5 : 1 (card surface + accent border); app-bar action squeezing the title at ×1.3 (list-header action); booking buttons clipped at ×1.3 (column); "body max 2 lines" against a 4-line ×1.3 body (no clamp).
- LOW ×5 left for the user (see the step file): "Reset semua" vs "Reset semua data", the repeated "Simulasi galat" wording, cancel word variance, "MODE DEMO" stored in caps + tabular figures, nested radius of the panel.
- Verdict Approve.

## Review rounds

Round 1 — user approved without changes ("approve"); the six build deviations were accepted.

## Key decisions worth flagging to a reviewer

- **S06 action placement:** "Tandai semua dibaca" is a list-header action in the first group, not an app-bar action as decided at kickoff. The stress frame proved the app bar cannot hold it at large text.
- **Demo identity without a banner:** a labelled inset surface per panel (the `DemoModeShortcut` look), one caption at the page top. No dashed borders (Pencil has no stroke dash) and no global banner.
- **`TsSlider` dropped:** speed is a 3-stop segmented control (PRD 04 said slider); the same `TsSegmentedControl` serves the theme control.
- **Logout is not a danger action:** it clears the session only, data stays on the device; danger styling is reserved for "Reset semua data".
- **Promo destination:** S10 with the voucher carried (PRD 04 "S17 or Home" is outdated since step 10). Reminder → S10 with the motor preselected.
- **Own lane:** frames live in a "Step 18" lane below the Step 17 lane; step 19 re-homes both.
- **Data:** now = Sel 29 Sep 2026 ≈ 10.30, 9 notifications with 2 unread (PCX 160 sedang diperiksa, Beat 110 mulai dikerjakan), matching the S05 bell.
- **Not verified:** Flutter rendering, 320 px / 200 % zoom, RTL, screen readers, Exo 2 tabular figures, html2figma import of the forced-theme `ThemePreview` stages (step 20).

## Output

- Pencil (`design/pencil/TumbasServis.pen`, unsaved until the user presses Cmd+S): sheets `nUFiI` / `w4hH6t`, 31 frames, row headers and notes in the "Step 18" lane.
- Exports: `design/pencil/exports/step18/` (31 PNG + `INDEX.md`, sheets in `components/`).
- Docs: `docs/plan/design/18-notif-profile-demo.md` (decisions, built ids, report, review round), `00-index.md` (decision log, demo content, inventory, tracker ✅, canvas layout, Pencil facts), `19-full-app-audit.md` (PRD / token items and left LOWs collected in step 18).
