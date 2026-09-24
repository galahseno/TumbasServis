# Claude Session Log — 12: Design step 10 — S16 Ringkasan + S17 Pilih Voucher

**Tool:** Claude Code + Pencil MCP + `/better-interface` skills, model Sonnet 5
**Date:** 2026-09-24
**Topic:** Kickoff interview, "Summary blocks" component sheet (recap card, unit accordion, voucher row, confirm bar / pane, estimate block), 39 frames (S16 and S17 on phone, Tablet-Portrait, Tablet-Landscape, Expanded; light + dark; text ×1.3 and 360×640 stress), `/better-interface`, review gate, export. The step file was still the original stub (written before steps 04 – 09), so this session did the kickoff the way steps 06 – 09 did.

---

## Initial prompt

> i want to do docs/plan/design/10-xx, interview me with detail if need

(Started in plan mode; the plan was approved before any edit.) Later turn (review gate):

> approve

## Research performed

1. Read `docs/plan/design/00-index.md` (conventions, Pencil facts, decision log, demo content, canvas layout), the step 10 stub, the step 04 and step 09 files (kickoff-decision format, `PriceBreakdown` / `VoucherCard` decisions, `CapacityBanner` reuse note), the step 07 decisions (`EstimatePane`, booking app bar), `19-full-app-audit.md`, `prd/03` (pricing, makespan, voucher rules, edge cases), `prd/04` (S16 / S17 wireframes), `prd/05` (`Voucher`), `prd/06` (S16 / S17 rows).
2. Pencil pre-flight: `get_app_state`, Pencil skill docs (`SKILL.md`, `pen-schema.md`, `execute.md`), screenshots of `PriceBreakdown` Summary / Expanded / Pane and `VoucherCard` Eligible / Selected / Ineligible, structure reads of `SelectionFooter` ×2, `CapacityBanner` Warning / Info, `ErrorState Inline`, `PriceBreakdown` parts, `TsAppBar` Step / Back, `BookingStepper` Phone step 4, `EstimatePane`, `TsButton` Primary / Outline / Ghost, `TsIconButton`, `Skeleton`, `TsRadio`, the S15 phone / Tablet-P / Tablet-L / Expanded frame scaffolds and the S15 blocks sheet.
3. Found while planning: (a) `UnitSummaryAccordion` and the step 04 `PriceBreakdown` per-unit rows would show every unit twice; (b) `CapacityBanner` has one action but the invalid-slot banner needs two; (c) the ineligible reason "Butuh min. 2 motor" cannot appear with 3 motors (needs a single-motor frame); (d) PRD 03 has no duration rule for split mode; (e) PCX 160 has no complaint in the canonical data, so the recap's Keluhan row needs demo data; (f) S17 has no entry other than S16 (promo CTAs).

## Clarifying interview (`AskUserQuestion`, 3 rounds, 12 questions)

Every recommended option accepted. Question 12 (extra frames, multi-select) — the user kept the two recommended frames.

**Round 1 — S16 structure**
| Question | Answer |
|---|---|
| S17 presentation | Full page, route `/booking/summary/voucher` |
| Unit info split | Accordion = detail, breakdown = one static line per unit |
| Confirm bar | Flat sticky bar, total row + full-width CTA (no glass) |
| Schedule card | Bengkel row + Jadwal row, separate Ubah links, split slots inside the Jadwal row |

**Round 2 — behavior and copy**
| Question | Answer |
|---|---|
| Makespan | Inline caption "dikerjakan bergantian di 2 bay" |
| Estimate wording | "Estimasi biaya" / "Total estimasi" by text override |
| Voucher row | Row opens S17, separate "Hapus" with an undo snackbar |
| Confirm error | Inline banner above the bar + "Coba lagi" |

**Round 3 — S17, pane, frames**
| Question | Answer |
|---|---|
| S17 apply | Radio + footer "Pakai voucher" with a saving preview |
| Code field | None (PRD scope) |
| Tablet-L pane | Voucher row inside the pane, above the estimate |
| Extra frames | S16 Expanded 1024×768 + S17 single motor |

## Execution

- **Docs (kickoff record):** step 10 file rewritten (decisions, defaults, demo data, 39-frame matrix, layout, components, copy, annotations), `00-index.md` (decision-log row, two demo-content rows, inventory row, tracker), `19-full-app-audit.md` (PRD S16 / S17 corrections block), one-line notes in steps 04 / 09 / 11.
- **Amended masters:** `CapacityBanner` Warning `jsn9r` — `Action Row` `wYfXA` around the moved `Banner Action` plus a disabled `Banner Action 2` `nZASD` (S15 banner heights unchanged); `VoucherCard` `Reason Badge` made `fill_container` with a wrapping label.
- **Blocks sheet** `zL3do` (x 32168, y 8760; dark copy `V6iLJ` y 12900): `SummaryCard` ×3, `UnitSummaryAccordion` ×2 (+ PCX sample), `VoucherRow` ×3, `PaymentNote`, `PriceBreakdown / Variant=Confirm` ×3, `NoVoucherOption` ×2, `ConfirmBar` ×4, `ConfirmPane` ×4, banner and focus specimens. `SummaryCard` icon tiles were removed after the first screenshot (the canonical schedule string wrapped).
- **39 frames:** S16 phone light ×8 + stress ×2 (`KBNFU` `a2akK` `W0W4LQ` `SfArJ` `i8IrZ` `wOIRn` `cW8xM` `J1cdKm` `jtOzo` `x8mnIG`), phone dark ×8 (`Fmjc0` `coOJY` `peNSW` `Lpgtw` `XIj5u` `qsLDX` `IN94D` `fenBj`), Tablet-P ×5 + dark (`neG2H` `MlZC9` `ByrnU` `psBU3` `lDxkz` `g214s`), Expanded `BmeWv`, Tablet-L ×3 + dark (`LyyOq` `X2tGYU` `B1Z8o0` `bvqVu`); S17 phone ×4 + dark ×2 (`ThHnc` `v4HKI` `R2uGdL` `c1scCE` `RrgSC` `ExGUr`), Tablet-P / Tablet-L + dark (`epVPY` `hB5xr` `kFQMN` `V6AgB`). Flows – Tablet block moved down 8,000 dp (89 root nodes). 5 phone + 5 tablet row headers, 13 handoff notes with explicit heights.
- **Build fixes found by screenshots and reads:** phone Loading made full-scroll; Tablet-P bar Total Row squeeze (Total 240 · Reason fill · CTA 240); Expanded PCX collapsed (660 dp of content in 644 dp); S17 footer preview as two lines; the long reason badge ran into the radio mark.
- **Automated checks:** coverage 39 / 39; clipping 0 real; raw hex 0 / 765 nodes; unnamed 0; placeholders 0; targets 542 / 0 under 48 dp; contrast 2 groups failed then 0 / 2,488 (min 4.56 : 1); arithmetic 29 S16 frames / 0 errors; state-vs-rule S16 gates and S17 28 cards / 0 mismatches.
- **Pencil findings** (written to `00-index.md`, "Verified in step 10"): name-path `descendants`; `Move` keeps ids; `resolveInstances` drops `ref`; `fill_container` sibling collapse; wrapping badge; master child swap; note height re-read; equal-height rows; the contrast script at scale; screenshots of tall frames.
- **Export at close:** 39 frames + 2 sheets (41 PNG) and `INDEX.md` in `design/pencil/exports/step10/`, verified with `ls` (42 files).

## /better-interface

All six domain skills applied to the 39 frames and both sheets. 1 HIGH + 5 MEDIUM fixed:
- HIGH accessibility — the accordion chevron was an unnamed second focus stop (now decorative, part of the header target; its focus specimens deleted).
- MEDIUM — loading states had no announcement; ineligible cards would be skipped by Flutter (reason unreachable); S17 Tablet-L grid rows had unequal heights (fixed with `height: fill_container`); two contrast pairs failed (`Ubah` on `warning-soft` 4.38 : 1, dark `Row Label` 4.44 : 1; fixed to a minimum of 4.56 : 1); amounts had no tabular-figure instruction.
- 8 LOW left: Ubah 4 dp gap, tablet void above the footer, CTA "Pakai voucher" vs "Tidak pakai voucher", empty state without an action, Label Small 11 px, capsule badge, Confirm Loading controls not dimmed, `VoucherRow` tile color.
Verdict Approve.

## Review rounds

Round 1 — user replied "approve"; no changes.

## Key decisions worth flagging to a reviewer

- **Estimate = static lines, detail = accordion** (amends step 04 decision 7): each unit is one line in the arithmetic block and one collapsible detail card; the collapsible `PriceBreakdown` unit rows stay as built for S23.
- **Flat confirm bar with the total repeated on phone:** total row + full-width CTA, no glass; Tablet-L / Expanded put the CTA in the sticky pane; Tablet-P uses a horizontal bar (total left, CTA right).
- **S17 is a full page, apply-with-preview, no code field:** radio list + "Tidak pakai voucher" + footer preview; reachable only from S16.
- **Split-mode duration** is per unit ("Estimasi 1 jam per motor · datang di jam berbeda"): makespan applies to a shared arrival only (PRD 03 fix in step 19).
- **Slot-invalid recovery** reuses `CapacityBanner` with two actions and a disabled CTA with a reason; the amended master leaves S15 untouched.
- **Voucher data:** four mock vouchers (two eligible, two ineligible for 3 motors; all four ineligible for 1 motor) with computed reasons ("kurang Rp72.000").
- **Two accessibility rules carried from step 09:** a disabled control cannot be the only carrier of its reason; state must not rely on color alone.

## Output

- Pencil (`design/pencil/TumbasServis.pen`, unsaved until the user presses Cmd+S): sheets `zL3do` / `V6iLJ`, 39 frames, row headers and notes in the Flows – Phone / Flows – Tablet blocks.
- Exports: `design/pencil/exports/step10/` (41 PNG + `INDEX.md`).
- Docs: `docs/plan/design/10-s16-s17-ringkasan.md` (decisions, built ids, report), `00-index.md` (decision log, demo content, inventory, tracker ✅, canvas layout, Pencil facts), `19-full-app-audit.md` (PRD S16 / S17 corrections), notes in steps 04 / 09 / 11.
