# Claude Session Log — 19: Design step 17 — Invoice & Rating (S23 Invoice, S24 Beri Ulasan)

**Tool:** Claude Code + Pencil MCP + `/better-interface` skills, model Sonnet 5
**Date:** 2026-09-25
**Topic:** Kickoff interview, "Invoice & Review Blocks" component sheet (`RatingStars` + 6 screen components + focus specimens), 27 frames (S23 and S24 on phone, Tablet-Portrait, Tablet-Landscape, light + dark), `/better-interface` pass, export. Ran in parallel with the step 16 session (S19 – S22) on the same `.pen`.

---

## Initial prompt

> i want to do docs/plan/design/17-xx, interviewme with detail if need, on other session im work with 16-xx

(Started in plan mode; the plan was approved before any edit.) At the review gate:

> approve

## Research performed

1. Read `docs/plan/design/00-index.md` (conventions, Pencil facts, decision log, demo content, canvas layout, inventory, templates, `/better-interface` mapping for Pencil), the step 17 stub (status ⬜, five open questions, 21-frame matrix), the step 16 file (kickoff-decision format, its concurrency decision: Tracking Blocks sheet at x 39016, phone rows from y 74,000, Flows – Tablet anchor move deferred), the step 15 session log (interview and close shape), and `prd/03` F4, `prd/04` S23 / S24 / S20, `prd/05` `Invoice` / `Review` / `Mechanic` / seed bookings, `prd/06` S23 / S24 rows.
2. Found while planning: (a) PRD 03 says "Tandai Lunas unlocks S24", but step 16's S20 Selesai frame lists both "Lihat invoice" and "Beri ulasan" with no gate, so S24 access needed a decision; (b) PRD 06 says S24 Tab-L shows a "submitted-reviews preview", which is ambiguous (own review vs other people's); (c) `Invoice` has only `paidAt` and `Review` no timestamp, but the UI needs "Diterbitkan" and "Dikirim" times; (d) Pencil's icon font has no fill axis, so a rating star cannot show filled vs outline as an icon; (e) step 16 and step 17 edit the same `.pen` and the same shared docs at once.
3. Pencil pre-flight (read-only, plan mode): `get_app_state` (all reusable components, top-level nodes), `read_skill` (SKILL, `pen-schema`, `execute`), and reads of `PriceBreakdown / Variant=Invoice`, `ConfirmBar`, `ConfirmPane`, `WorkshopCtaBar`, `MechanicCard`, `WorkshopSummaryRow`, `TsAppBar / Type=Back`, `TsDialog / Confirm Save`, `FormErrorBanner`, `TsTextField / Multiline`, `SuccessHeader`, the Tracking Blocks sheet, S16 phone / Tab-P / Tab-L skeletons, the `WorkshopCard` rating star token.
4. Star spike: a `path` star (Material geometry) filled / outline / half (clipped frame) in light and dark rendered as wanted; the spike frame first rendered blank in light mode (stale child offsets) and a `Copy` fixed it; spike frames deleted.

## Clarifying interview (`AskUserQuestion`, 3 rounds, 11 questions)

Every recommended option accepted.

**Round 1 — S23 and gating**
| Question | Answer |
|---|---|
| "Tandai Lunas" flow | Confirm dialog (non-destructive, "Simulasi, tidak ada pembayaran sungguhan") |
| S24 unlock | Hard gate at entry: S20 "Beri ulasan" disabled with a reason until paid (handoff to step 16) |
| P2 Unduh / Bagikan | One P2 variant frame (Paid, app-bar "Bagikan") |
| Paid look | Success-soft banner + tag, footer CTA swaps to "Beri ulasan" (no stamp) |

**Round 2 — S24**
| Question | Answer |
|---|---|
| Star input | Whole stars, 5 × 48 dp, word label + "4 dari 5", half stars only in display |
| Mechanics | 2 rows (Mas Rudi, Pak Anto), section hidden for a single mechanic |
| After submit | Same screen → read-only `ReviewRecap` + snackbar + "Kembali ke detail booking" |
| Tab-L right pane | Live recap preview of the user's own review |

**Round 3 — extras, comment, concurrency**
| Question | Answer |
|---|---|
| Extras | S24 keyboard-open, S24 single-mechanic variant, S23 Tandai Lunas error (×1.3 stress not built) |
| Comment | Optional, 300-char counter, validate on submit, no tag chips |
| Concurrency with step 16 | Own lane, no shifts (sheet at x 40424, frames in a "Step 17" lane, step 19 re-homes) |

## Execution

- **Docs (kickoff record):** step 17 file rewritten (11 decisions, defaults, demo content, 27-frame matrix, layout, components, annotations, checklist); `00-index.md` decision-log row, demo-content row, inventory row, tracker 🟡; `19-full-app-audit.md` step 17 block. Shared docs were edited with targeted `Edit`s after re-reading each anchor, because session 16 edits the same files.
- **Components (sheet `f5BFW`, x 40424, dark copy `ExPX4`):** `RatingStars` Input Large / Compact (Value 0 / 4 / 5) and Display (5 / 4 / 4.5) as `path` stars, `RatingLabel`, `PaymentStatusTag`, `PaidBanner`, `InvoiceHeaderCard`, `InvoiceSummaryCard` (Unpaid / Paid / Confirming), `WorkshopRatingCard` (Empty / Rated / Error), `MechanicRatingRow` (Unrated / Rated), `ReviewRecap` (Submitted / Preview / Preview Empty), focus specimens. Ids in `docs/plan/design/17-invoice-rating-s23-s24.md`, *Built*.
- **27 frames** in the "Step 17" lane (x 37,000; y 22,000 – 33,900): 6 row-header instances per group, 2 handoff-note frames (12 notes) with explicit heights. S23 phone frames are copies of the Unpaid frame (Paid, Error, Dialog, Loading, P2 = `Copy` + `Replace` / `Update`); Tab-P and Tab-L frames reuse the S16 tablet recipes (`ConfirmBar` horizontal, two-pane 720 · 360); the S24 Keyboard Open frame is a clipped `Scroll Viewport` + `System Keyboard`.
- **Build fixes found by screenshots and audits:** the S24 Submitted phone frame went from 800 to 860 dp because the floating snackbar covered the last mechanic row; the keyboard frame's scroll offset −332 → −318 so the comment label shows; the invoice "Kampas Rem Depan" line was overridden to the S16 / S18 label "Kampas Rem"; `ConfirmBar / State=Disabled` reason text overridden for the Loading frame.
- **Automated checks:** clipping 0 (29 roots, `resolveInstances: true`; exempt `Half Clip`, `Scrolled Content`, disabled chains); raw hex 0 of 757 nodes; unnamed non-ref nodes 0; placeholders 2 found (`fTMM0`, `z1lx8I`) and cleared; text < 12 sp 0 of 1,426; contrast 1,646 text + icon + star nodes, 0 failures; arithmetic on 10 invoice frames + the Tab-L pane vs S16 total; coverage 27 / 27 names; step 16 sheet bounds unchanged.
- **Pencil findings** (written to `00-index.md`, "Verified in step 17"): path star + clipped half star, stale-offset root frame (fixed by `Copy`), app-bar action slot recipe, spinner-only loading button, tablet `WorkshopCtaBar` centering, parallel-session lane recipe, dialog on tablet / full-scroll frames, nested-ref swap in overrides, dark sheet re-copy.
- **Export at close:** 27 frames in `design/pencil/exports/step17/` + 2 sheets in `…/step17/components/` and `INDEX.md`, verified with `ls` (27 PNG in the folder, 2 in `components/`).

## /better-interface

All six domain skills applied to the 27 frames, both sheets and the two note frames.
- HIGH ×1 (fixed): the interactive `RatingStars` control had no designed focus state → focus specimens for Large and Compact (step 09 recipe).
- MEDIUM ×2 (fixed): CTA labels in title case against the sentence-case policy (23 text nodes: "Tandai lunas", "Beri ulasan"); spinner-only loading buttons dropped their label ("Mengirim ulasan", "Menandai lunas").
- LOW ×3 fixed as annotations (tabular figures, skeleton loading announcement, Tab-L CTA reachability); LOW ×3 left for the user (`rating-star` token instead of `warning-text`, comment placeholder repeating "(opsional)", doubled "opsional" cue on mechanic rows); 1 pre-existing (status-bar clock 09.41 vs the 11.xx story times → step 19).
- Verdict Approve.

## Review rounds

Round 1 — user approved without changes ("approve").

## Key decisions worth flagging to a reviewer

- **S24 hard gate:** the PRD says "Tandai Lunas unlocks S24"; the design makes that literal: S20 "Beri ulasan" is visible but disabled with a reason until the invoice is paid. Step 16 must show that state on S20 (handoff recorded in the step 17 file and `19-full-app-audit.md`; the user relays it).
- **Star = token-bound `path`,** not an icon: Pencil's Material Symbols has no fill axis, so filled / outline / half needed geometry. Flutter uses `star_rounded` / `star_outline_rounded` / `star_half_rounded` at the same tokens.
- **Own lane:** frames live in a "Step 17" lane, not under the Flows anchors, so two sessions could edit one `.pen` without moving each other's nodes; step 19 re-homes them.
- **Deviations from the PRD text (all in the step 19 list):** sentence-case CTAs; per-mechanic section only for ≥ 2 mechanics; Tab-L "submitted-reviews preview" = live recap of the user's own review; `Invoice.issuedAt` / `Review.createdAt` needed for the displayed times.
- **Data:** mechanics are Mas Rudi (Beat 110, ★ 4,8 as in step 16) and Pak Anto (Vario 125 + PCX 160); invoice issued 11.08, paid 11.24, review sent 11.31; the single-mechanic frame uses seed booking `TS-260910-0091`.

## Output

- Pencil (`design/pencil/TumbasServis.pen`, unsaved until the user presses Cmd+S): sheets `f5BFW` / `ExPX4`, 27 frames, row headers and notes in the "Step 17" lane.
- Exports: `design/pencil/exports/step17/` (27 PNG + `INDEX.md`, sheets in `components/`).
- Docs: `docs/plan/design/17-invoice-rating-s23-s24.md` (decisions, built ids, report, review round), `00-index.md` (decision log, demo content, inventory, tracker ✅, canvas layout, Pencil facts), `19-full-app-audit.md` (PRD / S20-sync items collected in step 17).
