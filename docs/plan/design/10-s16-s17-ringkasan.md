# Step 10 — S16 Ringkasan + S17 Pilih Voucher

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-24 |
| **Priority** | S16 P0 · S17 P1 |
| **Owns screens** | S16, S17 |
| **Owns components** | `SummaryCard` (Shared / Split / Invalid), `UnitSummaryAccordion`, `PaymentNote`, `VoucherRow`, `PriceBreakdown / Variant=Confirm`, `ConfirmBar`, `ConfirmPane`, `NoVoucherOption`; amends `CapacityBanner` (`Action 2` slot) |
| **PRD refs** | [04 S16/S17](../../../prd/04-screens.md), [03 pricing/duration/voucher rules + edge cases](../../../prd/03-user-flows.md), [06 S16/S17 rows](../../../prd/06-responsive-layout.md) |
| **Pen location** | Components sheet "Summary blocks" (x 32168, light y 8760, dark copy under it); Flows rows `S16`, `S17` (phone rows after the S15 rows, tablet rows below the S15 tablet rows) |
| **Depends on** | Steps 02–04, 06–09 |
| **Claude session** | `docs/claude-session/12-design-step10-s16-s17-ringkasan.md` (written after approval) |

## Goal

Design the final review before confirming: workshop + schedule recap with edit links, per-unit collapsible detail, an itemized estimate (per-unit static lines → fleet subtotal → voucher → total), voucher row, payment note and the "Konfirmasi booking" CTA — plus the voucher picker (full page) with eligible / ineligible reasons.

## Inputs

- `BookingStepper` (Phone / Wide, step 4), `TsAppBar / Type=Step` `mYhlk` (S16), `TsAppBar / Type=Back` `R7zOVC` (S17), `PriceBreakdown` parts (`Summary Row` `QPzQW` for unit lines and Subtotal, `Line` `x097rY` for accordion lines, `Voucher Row` `lP4u6`, `Total Row` `sVRWq`, `Note Row` `pZ3Zt`), `VoucherCard` (`UQ201` eligible · `wW7Ee` selected · `vK5hP` ineligible), `SelectionFooter` `l4zDH` (S17 footer), `CapacityBanner` Warning `jsn9r` (slot invalid), `ErrorState / Type=Inline` `NouOK` (confirm error), `TsButton` Primary Default / Disabled / Loading, `Skeleton`, `EmptyState`, `TsDialog / Confirm Save` `tMRhF` (exit), `TsRadio`, `EstimatePane` (pane recipe, S11).
- Step 09 hand-off: `CapacityBanner` is the S16 "slot became invalid" banner; recap strings "Sel, 29 Sep · 09.00" per unit; S15 split state = Vario 09.00, Beat 10.00, PCX 13.00.
- Rules: all prices are "Estimasi"; total duration = **makespan** across the workshop's bays (not a sum); re-validate the slot on entering S16; the voucher discount is its own line; payment = "Bayar di bengkel saat selesai".

## Kickoff decisions (answered 2026-09-24, interview with the user)

Three `AskUserQuestion` rounds (12 questions). Every recommended option was accepted; in the extra-frames question (multi-select) the user picked the two recommended options.

| # | Topic | Decision |
|---|---|---|
| 1 | S17 form | **Full page**, route `/booking/summary/voucher`, back-only app bar "Pilih voucher", no stepper, no close. Back discards an unsaved radio change (no dialog) |
| 2 | Unit info split | **Accordion = detail, breakdown = static lines.** `UnitSummaryAccordion` holds services + parts (line prices when open) + complaint + "Ubah Vario 125". The estimate block = one static line per unit (`PriceBreakdown Summary Row` `QPzQW`, the recipe of the S11 `EstimatePane`; the kickoff first named `Unit / State=Static` `b1Fc7`, which carries line items) → Subtotal → Diskon voucher → Total. **Amends step 04 decision 7:** S16 no longer uses the collapsible unit rows (`PriceBreakdown / Variant=Summary` stays for S23 reference) |
| 3 | Confirm bar | **Flat sticky bar** (no glass; S16 spends 0 of the 2 glass slots): row "Total estimasi · Rp385.200" + full-width "Konfirmasi booking" below. Tablet-L / Expanded: same recipe pinned at the bottom of the right pane |
| 4 | Schedule card | `SummaryCard` = row **Bengkel** ("Ubah bengkel" → S13, the schedule must be redone) + row **Jadwal** ("Ubah jadwal" → S15). Split mode: the Jadwal row lists "Vario 125 · Sel, 29 Sep · 09.00" per unit under one Ubah. Accordions stay about services |
| 5 | Makespan | **Inline caption** under the total: "Estimasi 2 jam · dikerjakan bergantian di 2 bay" (1 motor: "Estimasi 1 jam"). No tooltip / sheet |
| 6 | Estimate wording | Estimate block title **"Estimasi biaya"**, total label **"Total estimasi"**, by instance text override; masters and the S23 invoice variant keep "Rincian harga" / "Total" |
| 7 | Voucher row | Empty: tag icon · "Pilih voucher" · chevron (+ caption "2 voucher bisa dipakai"). Applied: name + "Hemat Rp42.800" + trailing **"Hapus"** (48 dp, semantics "Hapus voucher"), body tap → S17. Removal = snackbar "Voucher dilepas · Urungkan" (annotation, S11 undo pattern); S17 keeps "Tidak pakai voucher" |
| 8 | Confirm error | **Inline banner** pinned above the flat bar: "Booking belum terkirim — periksa koneksi lalu coba lagi." + "Coba lagi" (`ErrorState / Type=Inline`, icon + text). Mode Demo forces it |
| 9 | S17 apply | **Radio + footer.** Radio list (eligible selectable, ineligible disabled + reason) + "Tidak pakai voucher" row; flat footer previews "Hemat Rp42.800 · Total Rp385.200"; CTA "Pakai voucher" applies and pops to S16, disabled until the choice changes |
| 10 | Code field | **None** (PRD scope: list only). "Voucher entry" = the S16 `VoucherRow` |
| 11 | Tablet-L pane | Right pane order: `VoucherRow` → "Estimasi biaya" static lines → Subtotal → Diskon → Total → caption → `PaymentNote` → "Konfirmasi booking". Left = `SummaryCard` + accordions |
| 12 | Extra frames | + **S16 Expanded 1024×768 two-pane** (light) · + **S17 single-motor** phone. Skipped: voucher-removed snackbar frame, Tablet-L ×1.3 (annotation only) |

**Found while planning** (defaults applied without a question; change at review if unwanted):

- **Sentence case** (step 03): "Konfirmasi booking", not the PRD's "Konfirmasi Booking".
- **Split-mode duration:** arrivals differ, so the makespan does not apply; caption = "Estimasi 1 jam per motor · datang di jam berbeda" (PRD 03 is silent → step 19 note).
- **Slot-invalid state** (Sel 29 Sep 09.00 now holds 2 seats, 3 motors): `CapacityBanner` Warning "Jam 09.00 sudah tidak muat 3 motor" + body "Tersisa 2 tempat di Sel, 29 Sep · 09.00. Pisah jadwal atau pilih jam lain." + actions "Pisah jadwal" / "Pilih jam lain". The master has one action: add an `Action 2` slot (amends step 09, logged). The Jadwal row turns warning (icon + "Jam tidak tersedia" + border, never color alone); "Ubah jadwal" is the way out; the CTA is disabled with the reason "Pilih jadwal baru untuk lanjut".
- **Loading (recomputing after an edit):** real app bar, stepper, `SummaryCard`, accordions; skeleton on `VoucherRow`, the estimate block and the bar total; CTA disabled "Menghitung ulang…".
- **Confirm loading:** CTA = `TsButton` Loading "Mengonfirmasi…"; back / close / Ubah / Hapus disabled (annotation).
- **Voucher set** (`vouchers.json` in step 19): see *Demo data*.
- **Complaint recap needs data:** PCX 160 gets an optional Keluhan on S16 only ("Rem belakang bunyi saat dingin."); the default expanded accordion = PCX 160 (service + 2 parts + note = every row type).
- **S17 entry:** reached only from S16 (it needs a draft). Promo / notification voucher CTAs (S05 `PromoBanner`, S06) start a booking (S10) and carry the voucher id — annotation only. The step 04 LOW "Pakai voucher vs Pilih voucher" stays: S16 row "Pilih voucher", S17 CTA "Pakai voucher".
- **Bar total repeats the estimate Total** on phone (sticky copy); semantics merge it into one announcement.
- S16 accordions toggle independently (S15's one-at-a-time rule is for pickers, this is a recap); the default frames open PCX 160 only.

## Demo data

Canonical set from `00-index.md`, Bengkel Jaya Motor, Sel 29 Sep 2026 · 09.00.

| Unit | Lines | Subtotal |
|---|---|---|
| Vario 125 (`AB 1234 XY`) | Servis Berkala Rp85.000 | **Rp85.000** |
| Beat 110 (`AB 5678 ZZ`) | Servis Berkala Rp85.000 · AHM Oil MPX1 Rp58.000 | **Rp143.000** |
| PCX 160 (`AB 9012 QR`) | Servis Berkala Rp85.000 · AHM Oil MPX2 Rp70.000 · Kampas Rem Rp45.000 · Keluhan "Rem belakang bunyi saat dingin." | **Rp200.000** |

Subtotal **Rp428.000** · voucher 10 % **−Rp42.800** · total **Rp385.200** · 3 × 60 min on 2 bays → **2 jam**. No voucher: Rp428.000. Single unit: Vario only Rp85.000 · 1 jam · no discount. Split: Vario 09.00, Beat 10.00, PCX 13.00 (Sel 29 Sep), caption "Estimasi 1 jam per motor · datang di jam berbeda".

**S17 vouchers** (order: eligible by saving, then ineligible):

| Voucher | Rule | 3 motors, Rp428.000 | 1 motor, Rp85.000 |
|---|---|---|---|
| `DISKON10` "Diskon 10% servis ≥ 2 motor" · s.d. 31 Okt 2026 | percent 10, minUnits 2 | eligible · Hemat Rp42.800 | "Butuh min. 2 motor" |
| `HEMAT25` "Potongan Rp25.000 min. belanja Rp300.000" · s.d. 15 Okt 2026 | flat 25.000, minSubtotal 300.000 | eligible · Hemat Rp25.000 (total Rp403.000) | "Min. belanja Rp300.000 — kurang Rp215.000" |
| "Diskon 15% servis ≥ 4 motor" | percent 15, minUnits 4 | "Butuh min. 4 motor" | "Butuh min. 4 motor" |
| "Potongan Rp75.000 min. belanja Rp500.000" | flat 75.000, minSubtotal 500.000 | "Min. belanja Rp500.000 — kurang Rp72.000" | "Min. belanja Rp500.000 — kurang Rp415.000" |

Populated default = `DISKON10` selected (the applied voucher), footer "Hemat Rp42.800 · Total Rp385.200". Single motor: all four ineligible, "Tidak pakai voucher" selected, footer "Belum ada voucher yang berlaku", CTA disabled.

**Slot-invalid demo:** Sel 29 Sep 09.00 booked 3 → 2 seats left for 3 motors (was 4 left when picked in S15).

## Scope

### Frame matrix (39 frames)

Naming: `S16 Ringkasan / <State> / <Breakpoint>` (`… · Dark`), `S17 Pilih Voucher / <State> / <Breakpoint>`. Phone frames are full-scroll captures (Loading and Confirm states fixed 800); tablets are fixed viewports (no status / gesture bar, no `NavBar` / `NavRail`).

| Screen · State | Phone | Ph·D | Tab-P | Tab-P·D | Tab-L | Tab-L·D | Other |
|---|---|---|---|---|---|---|---|
| S16 Loading (recomputing after an edit) | ✔ | ✔ | ✔ | | ✔ | | |
| S16 Ready — voucher applied, 3 units (PCX expanded) | ✔ | ✔ | ✔ | ✔ | ✔ two-pane | ✔ | **Expanded 1024×768** (light) |
| S16 Ready — no voucher | ✔ | ✔ | ✔ | | | | |
| S16 Error — slot became invalid (banner + fix) | ✔ | ✔ | ✔ | | ✔ | | |
| S16 Split-schedule recap | ✔ | ✔ | ✔ | | | | |
| S16 Single unit (1 motor) | ✔ | ✔ | | | | | |
| S16 Confirm loading ("Mengonfirmasi…") | ✔ | ✔ | | | | | |
| S16 Confirm error (demo network error + retry) | ✔ | ✔ | | | | | |
| S16 Stress | | | | | | | 360×640 · text ×1.3 (phone) |
| S17 Populated — 2 eligible + 2 ineligible + "Tidak pakai voucher" | ✔ | ✔ | ✔ | ✔ | ✔ 2-col | ✔ | |
| S17 Loading | ✔ | ✔ | | | | | |
| S17 Empty ("Belum ada voucher", icon only, no `Generate`) | ✔ | | | | | | |
| S17 Single motor (all ineligible) | ✔ | | | | | | |

Count: S16 4 + 7 + 3 + 4 + 3 + 2 + 2 + 2 + 2 = 29 · S17 6 + 2 + 1 + 1 = 10 → **39**.

### Layout targets (PRD 06 + kickoff)

- **Phone 360** (margins 16): status bar · `TsAppBar / Type=Step` "Ringkasan" (back + close) · `BookingStepper` Phone Step=4 "Langkah 4 dari 4 · Ringkasan" · scroll: [banner] · `SummaryCard` · "Motor (3)" + 3 `UnitSummaryAccordion` · `VoucherRow` · estimate block · `PaymentNote` · flat `ConfirmBar` above the gesture inset.
- **Tablet-P 800×1280:** full-width app bar + Wide stepper centered 720; content column 720; bar inner width 720.
- **Tablet-L 1280×800:** centered group left **720** · 24 · pane **360** = 1104 (88 dp side margins, as the S11 1-unit layout). Pane sticky; it should fit 800 dp, otherwise the pane body scrolls under a pinned CTA (verify by read-back).
- **Expanded 1024×768:** 24 · left **592** · 24 · pane **360** · 24.
- **S17:** phone 1-col; Tablet-P column max **560**; Tablet-L 2 cols × 440 + 16 gap (896, centered), "Tidak pakai voucher" full width under the grid; flat footer pinned, inner width = content width.
- Targets ≥ 48 dp (Ubah links, Hapus, VoucherRow, accordion header, chevron, radio rows); ellipsis + max lines on names / workshop / voucher titles; no fixed-height box around text; stress must not clip the estimate block at ×1.3.

### Components built here

New sheet **"Summary blocks"** (x 32168, light y 8760; dark copy under it, or lower if the sheet is taller than ~3,400 dp).

| Component | Notes |
|---|---|
| `SummaryCard` | Shared / Split / Invalid (warning) variants; two rows Bengkel + Jadwal, each with its own "Ubah …" link |
| `UnitSummaryAccordion` | Collapsed / Expanded; header = nickname + plate + one-line service summary (ellipsis) + "Ubah <motor>" + chevron; body = service / part lines with prices + optional Keluhan |
| `PaymentNote` | payment icon + "Bayar di bengkel saat selesai" |
| `VoucherRow` | Empty / Applied / Loading; Applied carries "Hapus" |
| `PriceBreakdown / Variant=Confirm` | Voucher = Yes / No / Loading; composed from the existing part masters (static unit lines, Summary, Voucher, Total, Note rows); title and total label overridden |
| `ConfirmBar` | Default / Disabled (reason line) / Loading; flat, total row + `TsButton` Primary |
| `ConfirmPane` | Tablet pane: `VoucherRow` + estimate block + `PaymentNote` + CTA; states as the bar |
| `NoVoucherOption` | S17 radio row "Tidak pakai voucher" (Unselected / Selected) |
| `CapacityBanner` (amend) | `Action 2` slot (disabled by default, so step 09 frames do not change) |
| Reused | see *Inputs* |

Focus specimens for the keyboard-reachable new controls (accordion header, Ubah link, `VoucherRow`, Hapus, `NoVoucherOption`) — the step 04 / 09 HIGH class.

### Content & copy

- S16: title "Ringkasan"; CTA "Konfirmasi booking"; card title "Bengkel & jadwal" (rows "Bengkel", "Jadwal"); section "Motor (3)"; accordion summary "Servis Berkala" / "Servis Berkala + 1 suku cadang" / "Servis Berkala + 2 suku cadang"; estimate block "Estimasi biaya", lines per unit, "Subtotal Rp428.000", "Diskon 10% servis ≥ 2 motor −Rp42.800", "Total estimasi Rp385.200", caption "Estimasi 2 jam · dikerjakan bergantian di 2 bay", `PaymentNote` "Bayar di bengkel saat selesai".
- Bar: "Total estimasi" · "Rp385.200"; disabled reasons "Pilih jadwal baru untuk lanjut" / "Menghitung ulang…"; loading "Mengonfirmasi…".
- Banners: slot invalid (see *Found while planning*); confirm error "Booking belum terkirim — periksa koneksi lalu coba lagi." + "Coba lagi".
- Voucher row: empty "Pilih voucher" + "2 voucher bisa dipakai" (1 motor: "Belum ada yang berlaku — lihat syaratnya"); applied "Diskon 10% servis ≥ 2 motor" + "Hemat Rp42.800" + "Hapus".
- S17: title "Pilih voucher"; group headers "Bisa dipakai (2)" / "Belum bisa dipakai (2)"; card sub-line "Kode DISKON10 · s.d. 31 Okt 2026"; footer "Hemat Rp42.800 · Total Rp385.200" + CTA "Pakai voucher"; empty "Belum ada voucher" / "Voucher dari promo akan muncul di sini."; ineligible reasons per the voucher table.

### Annotations to place

- Edit links: "Ubah bengkel" → S13 (then S15 again), "Ubah jadwal" → S15, "Ubah <motor>" → S11 for that unit; each returns to S16 and re-runs the recompute (Loading state).
- Re-validation on entering S16; race case = slot-invalid banner (recovery: split schedule or another time); CTA gate: slot valid and not loading.
- Confirm → loading → S18; error → inline banner + retry (Mode Demo); back / close / edit controls disabled while confirming.
- Makespan (shared) vs per-unit duration (split); eligibility evaluation (minUnits, minSubtotal) and ordering on S17; back discards an unsaved choice; S17 reachable only from S16; promo CTAs go through S10.
- Voucher removal → snackbar "Voucher dilepas · Urungkan"; "Pakai voucher" pops to S16 with the discount line.
- Semantics: estimate block read as one group ("Estimasi biaya, Subtotal Rp428.000, Diskon …, Total estimasi Rp385.200, Estimasi 2 jam"); bar total merged with the CTA label; edit links unit-specific ("Ubah Vario 125"); `VoucherRow` "Pilih voucher, 2 voucher bisa dipakai" / "Hapus voucher"; accordion header state (dibuka / ditutup); error banner as a polite live region; voucher radios "Diskon 10% …, hemat Rp42.800, terpilih" / "… tidak bisa dipakai, butuh min. 4 motor".
- Reduce-motion: accordion expand 150 ms → instant; skeleton shimmer static.

## Built (node ids, `design/pencil/TumbasServis.pen`)

Sheet **"Components / Summary Blocks"** `zL3do` (x 32168, y 8760, 1200 × 3,884 dp) with dark copy `V6iLJ` (y 12900; 22 unnamed refs renamed): `SummaryCard` Shared `GCacW` · Split `i18E70` · Invalid `DsowG`; `UnitSummaryAccordion` Collapsed `oc9ZZ` · Expanded `I86H3` (+ a PCX 160 sample with Keluhan `OB6Eq`); `VoucherRow` Empty `ePikA` · Applied `mNtYC` · Loading `PTEWa`; `PaymentNote` `HQmV7`; `PriceBreakdown / Variant=Confirm` Voucher=Yes `abEhS` · Voucher=No `VdPil` · State=Loading `oMeq5`; `NoVoucherOption` Unselected `b5vo3K` · Selected `CfBR2`; `ConfirmBar` Default `gdg2y` · Disabled `YQWdy` · Confirming `ELAg6` · Recomputing `zVpch`; `ConfirmPane` Default `ZRSWe` · Disabled `akSiS` · Confirming `I5hdLz` · Recomputing `hbCdL`; banner specimens `TAosF`; focus specimens `JVsx9`.

**Amended masters (steps 04 / 09):** `CapacityBanner / Tone=Warning` `jsn9r` gains `Action Row` `wYfXA` holding `Banner Action` `B6aT1` (moved, same id) and `Banner Action 2` `nZASD` (disabled by default; S15 banners measured before / after: 146 / 100 / 124 / 124 dp unchanged). `VoucherCard` masters `UQ201` `wW7Ee` `vK5hP`: `Reason Badge` is `fill_container` and its label wraps (a long reason such as "Min. belanja Rp300.000 — kurang Rp215.000" ran into the radio mark otherwise). The step 04 sheets inherit both changes.

The **Flows – Tablet block moved down 8,000 dp** (89 root nodes; anchor now y 46000). Frames (39), all named `S16 Ringkasan / <State> / <Breakpoint>` or `S17 Pilih Voucher / <State> / <Breakpoint>`:

| Row | Frames (node id) |
|---|---|
| S16 phone light, header `cA7BS` (y 37000), frames y 37186 | Loading `KBNFU` · Ready Voucher `a2akK` · Ready No Voucher `W0W4LQ` · Error Slot Invalid `SfArJ` · Split Recap `i8IrZ` · Single Unit `wOIRn` · Confirm Loading `cW8xM` · Confirm Error `J1cdKm` · Stress 360×640 `jtOzo` · Stress Text ×1.3 `x8mnIG` · notes `O6b86` (6 notes, x 4400) |
| S16 phone dark, header `jshhI` (y 39500), frames y 39686 | Loading `Fmjc0` · Ready Voucher `coOJY` · Ready No Voucher `peNSW` · Error Slot Invalid `Lpgtw` · Split Recap `XIj5u` · Single Unit `qsLDX` · Confirm Loading `IN94D` · Confirm Error `fenBj` |
| S17 phone light, header `zigTP` (y 41500), frames y 41686 | Populated `ThHnc` · Loading `v4HKI` · Empty `R2uGdL` · Single Motor `c1scCE` · notes `pJc3f` (3 notes) |
| S17 phone dark, header `GbxV9` (y 43200), frames y 43386 | Populated `RrgSC` · Loading `ExGUr` |
| S16 Tablet-Portrait, header `FAdjZ` (y 68000), frames y 68186 | Loading `neG2H` · Ready Voucher `MlZC9` · Ready No Voucher `ByrnU` · Error Slot Invalid `psBU3` · Split Recap `lDxkz` · Ready Voucher Dark `g214s` · notes `m8sZeE` |
| S16 Expanded, header `oCczl` (y 69700), frame y 69886 | Ready Voucher `BmeWv` · notes `JqWvr` |
| S16 Tablet-Landscape, header `q0qOcj` (y 70900), frames y 71086 | Loading `LyyOq` · Ready Voucher `X2tGYU` · Error Slot Invalid `B1Z8o0` · Ready Voucher Dark `bvqVu` · notes `NjHRs` |
| S17 Tablet-Portrait, header `R4713` (y 72100), frames y 72286 | Populated `epVPY` · Populated Dark `hB5xr` · notes `UnpCz` |
| S17 Tablet-Landscape, header `AUTg1` (y 73800), frames y 73986 | Populated `kFQMN` · Populated Dark `V6AgB` · notes `fGun9` |

Build decisions made while building (all inside the kickoff decisions unless marked):
- **`SummaryCard` rows have no icon tile:** with a 40 dp tile the canonical "Sel, 29 Sep 2026 · 09.00" wrapped to two lines at 360; the "Bengkel" / "Jadwal" labels carry the meaning.
- **Estimate block** = existing `Summary Row` `QPzQW` per unit (as `EstimatePane`), not `Unit / State=Static`; Subtotal and Diskon rows appear only with a voucher (without one they would repeat the total).
- **Phone Loading is full-scroll** (not fixed 800, unlike the plan's note): at 800 dp the skeleton estimate block sat below the fold. Confirm Loading / Confirm Error stay fixed 800 with a clipped `Scroll Body` (content peeks above the bar).
- **Tablet-P and Expanded show all accordions collapsed** (an open PCX 160 pushed the column 40 dp under the bar / pane); Tablet-L Ready and the phone frames open PCX 160. Tablet-L Error also collapsed (banner + card fill the column).
- **Tablet-P bar** = `ConfirmBar` with `Main Column` overridden to horizontal (total left, CTA right, 240 / 280 wide); a `fill_container` Total Row squeezed to 4 dp when the Disabled reason row sat beside it, so Disabled / Recomputing use Total 240 · Reason fill · CTA 240.
- **S17 Populated shows the state after the user picked `DISKON10` from "no voucher"**: footer "Total Rp385.200" + "Hemat Rp42.800" (two lines, the counter wrapped at one line) and an enabled "Pakai voucher". With the applied voucher re-selected the CTA is disabled (annotation).
- **S17 Tablet-L rows** = 2 cards per `Voucher Grid Row`; the shorter card is `height: fill_container` so both edges align (review fix).
- **Deviations from the kickoff:** none in content; the chevron is decorative (review fix), see the report.

Pencil facts (verified in step 10; copy to `00-index.md` at close):
- **`descendants` keys accept name paths** through two levels (`"Part Line 1/Label"`, `"Total Row/Value"`, `"Banner Action/Label"`, `"CTA/Label"`, `"Note Row/Note"`), so screen builders need no node ids.
- **`Move` keeps ids and instance overrides:** wrapping an existing child in a new `Action Row` inside a master changed no instance (S15 banner heights identical before / after).
- **`Get(..., {resolveInstances:true})` returns instances as plain `frame` nodes** (the `ref` type and id are gone): read `n.ref` from a Get **without** `resolveInstances`, read text overrides from one with it.
- **A `fill_container` sibling collapses when the others are fixed:** a Total Row in a horizontal `Main Column` shrank to 4 dp (label one character per line) with a 280 + 280 dp CTA / reason beside it; give it a width.
- **A hug frame with `width: fill_container` + fixed-width text wraps its label** (`Reason Badge`), the fix for badges whose text can be long.
- **Master child swap:** `Delete` of the last child + `Insert` into the parent works in a master; the frames' instances re-flow without new overrides.
- **`note` auto height changes after a content edit:** re-read the bounds and set the explicit height again (four notes grew 42 – 147 dp).
- **Dark copies of frames keep ref names** (0 unnamed); a dark sheet of masters yielded 22 unnamed refs (renamed).

## Checklist

### Build
- [x] Kickoff questions answered (12 decisions above).
- [x] Doc edits recorded (this file, `00-index.md`, `19-full-app-audit.md`, notes in steps 04 / 09 / 11).
- [x] Reference reads done (`SelectionFooter`, `CapacityBanner`, `ErrorState Inline`, `PriceBreakdown` parts, app bars, `EstimatePane`, `VoucherCard` override keys).
- [x] "Summary blocks" sheet built (light + dark copy), tokens + instances only; focus specimens.
- [x] All 39 matrix frames built; dark copies built.
- [x] Discount line shows icon / sign + text, not color alone; slot-invalid state also has icon + text + border.
- [x] Tablet-L / Expanded two-pane built with instances (pane = `ConfirmPane`, sticky by note).
- [x] Stress frames built and clean (estimate block does not clip at ×1.3).
- [x] Numbers verified against the step-01 price sheet and the voucher table.

### Quality (automated, run in `execute`)
- [x] Clipping check on every step frame and both sheets → 0 real `problems` (exempt: disabled subtrees, the clipped `Scroll Body` of Confirm Loading / Confirm Error / Stress 360×640, `Skeleton …`; the step 04 sheet's `Decor …` bleed and carousel peek are pre-existing).
- [x] Raw-hex audit (without `resolveVariables`) → 0 of 765 nodes.
- [x] Every node named (0 unnamed, 22 unnamed refs of the dark sheet renamed); `placeholder` cleared on 39 frames and both sheets.
- [x] Coverage script: 39 frame names match the matrix, 0 missing, 0 extra.
- [x] Targets ≥ 48 × 48 dp on 542 interactive nodes (Ubah, Hapus, header, `VoucherRow`, cards, radios, CTA, banner actions, back / close, retry) → 0 under (smallest: Ubah 68 × 48, VoucherRow 328 × 56).
- [x] Contrast on resolved values: first run 2,490 text + icon nodes → 2 groups failing (6 nodes: `Ubah` label `#C24C1D` on `warning-soft` 4.38 : 1; dark `Row Label` `#9A918B` on `warning-soft` 4.44 : 1), fixed; re-run 2,488 nodes → 0 failing, minimum 4.56 : 1.
- [x] **Arithmetic script:** 29 S16 frames — unit lines → subtotal → discount (10 % of Rp428.000 = Rp42.800) → total, no-voucher total Rp428.000, single unit Rp85.000, bar total = block total, accordion line sums = unit lines (Vario / Beat / PCX) → 0 errors.
- [x] **State-vs-rule audit:** CTA gate per S16 frame (Default / Disabled on invalid slot / Recomputing on Loading / Confirming on Confirm Loading; 25 frames read directly, the 4 pane frames verified through the nested `ConfirmPane` state) and invalid-slot card / banner only on the invalid frames; S17 — 7 populated / single frames, 28 cards recomputed from unit count + subtotal + rule (master, reason text, saving, selected count, footer preview, no-voucher option) → 0 mismatches.

### /better-interface
- [x] Run `/better-interface` with scope = all S16 + S17 frames and the sheets (names + node ids).
- [x] Report recorded below; HIGH / MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [x] Status set to 🔵; user shown: ready (voucher), no voucher, slot-invalid banner, split recap, Tablet-L pane, S17 eligible / ineligible, dark.
- [x] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [x] PNG export to `design/pencil/exports/step10/` + `INDEX.md` (39 frames + 2 sheets, 41 PNG; `ls` shows 42 files with the index).
- [x] Claude session file written (`docs/claude-session/12-design-step10-s16-s17-ringkasan.md`).
- [x] Tracker set to ✅; canvas layout after step 10 and the Pencil facts above added to `00-index.md`.

## /better-interface report

**Scope:** all 39 `S16 Ringkasan / …` and `S17 Pilih Voucher / …` frames (ids in *Built*) + `Components / Summary Blocks` `zL3do` and its dark copy `V6iLJ` · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens, Flutter target (semantics via notes) · **Convention docs found:** 00-index.md, prd/02, prd/03, prd/06, this file; steps 04 / 08 / 09 review reports (same class of findings, used as precedent). Web-only rules (`prefers-reduced-motion` CSS, `<label for>`, `text-wrap`) mapped as in 00-index.

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | Focus specimens for every keyboard-reachable new control; semantics / live-region notes; 542 targets ≥ 48 dp; color-only states (discount = icon + sign + text, invalid slot = icon + text + border, ineligible = reason text, selected = border + radio); reduced-motion note; ×1.3 and 360×640 stress | 1 HIGH, 2 MEDIUM (fixed) |
| Layout | Grouping and edges on phone / Tablet-P / Tablet-L / Expanded; pane geometry; grid rows; bar alignment; scroll peek on the clipped frames; stress clipping | 1 MEDIUM (fixed), 2 LOW |
| Writing | Every label vs action, terminology (jam, bay, voucher, estimasi), sentence case, verb-first actions, error names the fix, empty state | 2 LOW |
| Typography | Role sizes on new nodes, wrap at ×1.3, line-height, tabular figures on changing amounts | 1 MEDIUM (fixed), 1 LOW |
| Color | Contrast script over 2,490 text / icon nodes, both themes; one meaning per color; one filled action per view; `Hapus` accent (removal is undoable, not danger) | 1 MEDIUM (fixed), 1 LOW |
| UI | Concentric radii (card 16 → row 8 inside 8 dp padding; 16 dp padding cards keep independent inner radii), icon weights, disabled recipes, state cues without motion, dark copies | 2 LOW |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| HIGH | Accessibility | `UnitSummaryAccordion` masters `oc9ZZ` / `I86H3` › `Chevron Button` `IfBrc` / `onU9J` (18 frames + sheet); specimen `RoJda` / `uDOCs` | Icon-only `TsIconButton` (48 × 48) in each accordion header, no semantics: the note made the header one target, so the chevron was an unnamed second focus stop with its own focus specimen | Chevron = decorative `Chevron` frame + `Chevron Icon` (`AkgE7` / `yWmlK`, `YNP69` / `WJid4`) inside the header target, excluded from semantics (note `z88cE2`); chevron specimens deleted | Escalation trigger: an interactive control with no accessible name; a second stop would also announce the toggle twice |
| MEDIUM | Accessibility | Loading frames `KBNFU` `Fmjc0` `neG2H` `LyyOq` (S16), `v4HKI` `ExGUr` (S17) | Skeletons replace the estimate / voucher / list with no announcement: a screen-reader user hears nothing while totals recompute | Notes `z88cE2` / `YqICX`: skeleton hidden from semantics, polite live region "Menghitung ulang estimasi" / "Memuat voucher", then the new total | Dynamic content must be announced; the disabled CTA reason alone is not enough |
| MEDIUM | Accessibility | Ineligible `VoucherCard` `vK5hP` in `ThHnc` `c1scCE` `epVPY` `kFQMN` + dark copies | Disabled radio + card: Flutter skips disabled controls, so the reason ("Butuh min. 4 motor") is unreachable by screen reader | Note `lDVR7`: an ineligible card is a focusable read-only node whose label carries the reason (same class as the step 09 disabled chips) | A disabled control cannot be the only carrier of its reason |
| MEDIUM | Layout | `kFQMN` / `V6AgB` › `Voucher Grid Row` `mtuuR` `PT3Ps`: cards `HaZAK` 84 vs `q4KG5` 106, `n8hmV` 90 vs `JXwcV` 112 | Cards in one grid row had different heights → ragged bottom edge | Shorter card `height: fill_container` → 106 / 106 and 112 / 112 (light + dark) | Shared edges; the same fix as the step 06 equal-height rows |
| MEDIUM | Color | `SummaryCard / Mode=Invalid` `DsowG` › `Ubah Jadwal` `yuulG` (`SfArJ` `psBU3` `B1Z8o0` + sheet) and › `Row Label` `vG4pB` (dark `Lpgtw` + dark sheet) | `Ubah` label `#C24C1D` on `warning-soft` = 4.38 : 1; dark `Row Label` `#9A918B` on `warning-soft` = 4.44 : 1 (both < 4.5 : 1) | `Ubah` label `text-on-accent-soft`, `Row Label` `text-body`; re-measured: 0 failing, minimum 4.56 : 1 | Body text on the tinted row misses the required ratio |
| MEDIUM | Typography | Estimate block `abEhS` `VdPil`, `ConfirmBar` `gdg2y`… (all S16 frames): `Total Value`, `Value` texts | Amounts change on voucher apply / remove and recompute; no tabular-figure instruction, so the total jumps | Note `f7TqSr`: amounts use `FontFeature.tabularFigures()` | Changing values need tabular numerals |
| LOW (left) | Layout | Accordion header `oc9ZZ` / `I86H3`: `Ubah Link` and the header end are 4 dp apart | Ubah (navigates to S11) beside the toggle area with a 4 dp gap | Header gap 8 dp when the text column can spare 4 dp | A mis-tap leaves the summary |
| LOW (left) | Layout | S17 Tablet-P `epVPY` / `hB5xr` (≈ 460 dp between the last card and the footer), S16 Tablet-P frames | Fixed viewport leaves an empty band above the pinned footer | Balance in step 19 (same as the S15 LOW) | Shared edges and balance |
| LOW (left) | Writing | S17 footer CTA "Pakai voucher" | Reads wrong when "Tidak pakai voucher" is the choice after a voucher was applied (state not framed; PromoBanner uses the same verb) | "Terapkan" or a label that follows the choice; decide in step 19 | The label should match the action |
| LOW (left) | Writing | S17 Empty `R2uGdL` | Says what the place is and why it is empty but offers no next action | Add a ghost "Kembali ke ringkasan" or point to the promo list | Empty states point forward |
| LOW (left) | Typography | `VoucherCard` `vK5hP` › `Badge Label` (Label Small 11 px) | Reason text at 11 px | Decide with the type scale in step 19 (open since steps 03 / 04 / 09) | Small reason text is easy to miss |
| LOW (left) | UI | `VoucherCard` `vK5hP` › `Reason Badge` `Y904Cr` (`ThHnc`, `c1scCE`) | A wrapped two-line reason keeps `radius-pill` and reads as a fat capsule | `radius-md` for a badge that wraps | Radius follows the shape |
| LOW (left) | UI | Confirm Loading `cW8xM` / `IN94D` | Back / close / Ubah / Hapus still look enabled while confirming (disabled by note only) | Dim them (`opacity` 0.4) in this state | A locked state should be visible |
| LOW (left) | Color | `VoucherRow` `ePikA` / `mNtYC` › `Icon Tile` | `accent-soft` tile = the selected-state recipe on a static icon | `surface-inset` tile + `text-body` icon (same LOW as steps 04 / 09) | One color, one meaning |

**Verification:** passed — coverage script (39 names, 0 missing / extra); clipping on 39 frames + 2 sheets (0 real); raw hex 0 / 765 nodes; unnamed 0; placeholders 0; targets 542 / 0 under 48 dp; contrast (2 groups failed, fixed, re-run 0 / 2,488, min 4.56 : 1); arithmetic script 29 S16 frames / 0 errors; state-vs-rule audit S16 gates 29 / 29, S17 7 frames / 28 cards / 0 mismatches; screenshots of sheet sections (masters, bars, panes, banners, specimens), phone Ready / Error / Split / Single / Loading / dark, S17 Populated / Single / Loading / Empty, Tablet-P / Tablet-L / Expanded. **Not verified:** Flutter rendering of the specimens, live regions, accordion / radio semantics and tabular figures (notes only); text ×1.3 on tablet and S17 frames (phone ×1.3 and 360×640 only); 320 px width and RTL; screen-reader pass; html2figma output (not exported until step 12).
**Verdict:** Approve
**Fixes applied:** the HIGH and five MEDIUM above (decorative chevron, loading announcements, ineligible-card semantics, equal grid rows, two contrast pairs, tabular figures) · **LOW left for user:** Ubah gap, tablet void, CTA wording, empty-state action, Label Small 11 px, capsule badge, confirm-loading dimming, `VoucherRow` tile color

## Review rounds

#### Round 1 — 2026-09-24
- **Frames shown:** S16 ready (voucher), no voucher, slot-invalid banner, split recap, single unit, Tablet-L two-pane, Expanded; S17 populated, single motor, Tablet-L grid; dark; the sheet with the focus specimens.
- **User feedback:** "approve"
- **Changes made:** none.
- **Outcome:** approved. The eight LOW findings stay open for step 19.

## Session log

| Time | Action | Result / node ids |
|---|---|---|
| 2026-09-24 | Kickoff | Read `00-index`, steps 04 / 07 / 09, PRD 03 / 04 / 06, `prd/05` (Voucher); Pencil screenshots of `PriceBreakdown` Summary / Expanded / Pane and `VoucherCard` ×3. Found: the accordion and the `PriceBreakdown` per-unit rows duplicate each unit; `CapacityBanner` has one action; the ineligible reason "Butuh min. 2 motor" cannot appear with 3 motors; the split-mode duration has no PRD rule. Three `AskUserQuestion` rounds (12 questions), all recommended options accepted. Kickoff recorded in this file, `00-index.md`, `19-full-app-audit.md` before any Pencil edit |
| 2026-09-24 | Amend + sheet | `CapacityBanner` Warning `Action Row` + `Banner Action 2`; sheet `zL3do` (SummaryCard ×3, accordion ×2, VoucherRow ×3, PaymentNote, PriceBreakdown Confirm ×3, NoVoucherOption ×2, ConfirmBar ×4, ConfirmPane ×4, banner + focus specimens); icon tiles removed from `SummaryCard` (wrapping); dark copy `V6iLJ` |
| 2026-09-24 | Phone frames | Tablet block moved down 8,000 dp; S16 phone light ×10 (8 states + 2 stress), dark ×8; S17 phone ×4 + dark ×2; `VoucherCard` `Reason Badge` made `fill_container` (overflow into the radio mark); Loading made full-scroll; S17 footer preview as two lines |
| 2026-09-24 | Tablet frames | S16 Tablet-P ×5 + dark, Expanded, Tablet-L ×3 + dark; S17 Tablet-P / Tablet-L + dark; Tablet-P bar squeeze fixed (Total 240 · Reason fill · CTA 240); Expanded PCX collapsed; row headers and 13 handoff notes with explicit heights |
| 2026-09-24 | Automated checks | Coverage 39 / 39; clip, hex, unnamed, placeholders, targets, contrast (2 groups fixed), arithmetic, state-vs-rule audits as listed in the checklist |
| 2026-09-24 | `/better-interface` | 1 HIGH + 5 MEDIUM fixed (decorative chevron, loading announcements, ineligible-card semantics, equal S17 grid rows, contrast pairs, tabular figures), 8 LOW left; verdict Approve |
| 2026-09-24 | Review gate | Status 🔵; frame list, deviations (chevron decorative, Tablet-P / Expanded accordions collapsed, Loading full-scroll, `Summary Row` estimate lines, amended `CapacityBanner` / `VoucherCard` masters) and the eight LOW flagged; user replied "approve" |
| 2026-09-24 | Close | PNG export of 39 frames + 2 sheets to `design/pencil/exports/step10/` with `INDEX.md`; session file `12-design-step10-s16-s17-ringkasan.md`; tracker ✅; Pencil facts and canvas layout added to `00-index.md` |
