# Step 17 — Invoice & Rating: S23 Invoice · S24 Beri Ulasan

| | |
|---|---|
| **Status** | ✅ Approved (2026-09-25) |
| **Priority** | P1 |
| **Owns screens** | S23, S24 |
| **Owns components** | `RatingStars`; (screen-local, flag for `prd/02`): `PaymentStatusTag`, `PaidBanner`, `InvoiceSummaryCard`, `MechanicRatingRow`, `ReviewRecap` |
| **PRD refs** | [04 S23/S24](../../../prd/04-screens.md), [03 F4](../../../prd/03-user-flows.md), [05 Invoice/Review entities](../../../prd/05-data-model-mock.md), [06 S23/S24 rows](../../../prd/06-responsive-layout.md) |
| **Pen location** | "Step 17" lane (see Concurrency), later re-homed to Flows rows `S23`, `S24` in step 19 |
| **Depends on** | Steps 02–04 (`PriceBreakdown`), 10 (`ConfirmBar` / `ConfirmPane`), 16 (`MechanicCard`, S20 entry) |
| **Claude session** | `docs/claude-session/19-design-step17-invoice-rating.md` (written after approval) |

## Goal

Design the itemized invoice for a completed multi-unit booking (per-unit lines, fleet total, mock "Tandai Lunas") and the post-service review (workshop rating + optional per-mechanic ratings + optional comment, read-only recap). Build `RatingStars` (input + display).

## Inputs

- `PriceBreakdown / Variant=Invoice` (`m9GfI`, per unit, all expanded), `ConfirmBar` / `ConfirmPane` (step 10), `WorkshopCtaBar`, `TsButton`, `TsTextField / Multiline`, `TsSnackbar`, `TsDialog / Confirm Save`, `FormErrorBanner`, `WorkshopSummaryRow`, `MechanicCard` (avatar recipe), `Skeleton`, `System / Keyboard`.
- Rules: invoice is generated once the booking is `Selesai`; "Tandai Lunas" is a mock action that flips to paid and unlocks S24; S24 = one workshop rating + optional rating per mechanic when different mechanics served different units.

## Kickoff decisions (answered 2026-09-25, interview with the user; every recommended option chosen)

1. **Tandai Lunas (Q1):** confirm dialog (`TsDialog / Confirm Save`, non-destructive): "Tandai sudah dibayar?" + "Simulasi, tidak ada pembayaran sungguhan"; actions "Ya, tandai lunas" / "Kembali". Guards an irreversible mock state that unlocks S24.
2. **S24 unlock (Q2):** hard gate at entry. S20 "Beri ulasan" stays visible but disabled with reason line "Tandai lunas di invoice dulu" until paid; S23 Paid footer = "Beri Ulasan" → "Lihat ulasan" once reviewed. **Handoff for step 16 (S20, other session):** Selesai-unpaid = "Lihat invoice" enabled + "Beri ulasan" disabled with that reason; Selesai-paid = "Beri ulasan" enabled; reviewed = "Lihat ulasan". The user relays this; this step does not edit the step 16 file.
3. **P2 Unduh/Bagikan (Q3):** one P2 variant frame (S23 Paid phone, "Bagikan" icon action in the app bar, S18 share-ticket precedent). Default frames stay clean.
4. **Paid look (Q4):** success-soft banner (check icon + "Lunas" + "Dibayar Sel, 29 Sep 2026 · 11.24") + `PaymentStatusTag` (Belum dibayar / Lunas, icon + text) in the header and the total row; the footer CTA swaps "Tandai Lunas" → "Beri Ulasan". No stamp.
5. **Star input (Q5):** whole stars only, 5 × 48 dp targets; live word label under the stars (1 Buruk · 2 Kurang · 3 Cukup · 4 Baik · 5 Sangat baik) + "4 dari 5"; half stars only in read-only display (average ★ 4,8); state = filled vs outline **shape**, never color alone; arrow keys + `Semantics` value in the note.
6. **Mechanics (Q6):** 2 rows — Mas Rudi · Beat 110 (matches step 16 S21) and Pak Anto · Vario 125 + PCX 160 (2 bays = 2 mechanics). Rows optional ("Opsional", unrated by default). A single-mechanic booking hides the section (PRD: "if different mechanics served different units").
7. **Submitted (Q7):** same screen swaps to the read-only `ReviewRecap` + snackbar "Ulasan terkirim. Terima kasih!" + CTA "Kembali ke detail booking" → S20.
8. **S24 Tab-L pane (Q8):** live recap preview (`ReviewRecap` updates while filling; empty = "Ulasanmu akan tampil di sini"; after submit = final recap). This is the reading of PRD 06 "submitted-reviews preview".
9. **Extras (Q9):** S24 comment keyboard-open · S24 single-mechanic variant · S23 "Tandai Lunas" error. ×1.3 stress not built.
10. **Comment (Q10):** optional, `TsTextField / Multiline`, 300-char counter, placeholder "Ceritakan pengalamanmu (opsional)". Submit always enabled, validate on submit; only the workshop rating is required (inline error "Pilih bintang untuk bengkel"). No tag chips.
11. **Concurrency (Q11):** step 16 runs in another session on the same `.pen`. Own lane, no shifts: the component sheet goes at x 40424 (right of Tracking Blocks `iZ2qP`, x 39016), the S23 / S24 frames in a new "Step 17" lane below the component sheets (x ≥ 37,000, y ≥ 22,000, empty region), and no existing node is moved. Step 19 re-homes the frames under the Flows anchors (ids kept, one `Update y` pass).

### Defaults applied without asking

- Chrome: `TsAppBar / Type=Back` only, no `NavBar` / `NavRail` (S20 / S21 parity); entry from S20 or a notification deep link (S23).
- Star glyph = token-bound **`path`** star (Material 24-unit geometry, `viewBox`) — verified in the step spike: filled = `warning-text` fill + stroke (same token as the `WorkshopCard` star), empty = `border-control` outline, half = empty star + a clipped half-width frame holding the filled star. Material Symbols `star` has no fill axis in Pencil.
- Invoice reference = booking code (PRD 05 `Invoice.bookingId`; no invented invoice number). Payment note "Bayar di bengkel" → "Dibayar di bengkel".
- S23 phone / Tab-P: flat sticky `ConfirmBar` (total + CTA); Tab-L pane = `InvoiceSummaryCard`. S24 phone / Tab-P: flat `WorkshopCtaBar` "Kirim ulasan"; Tab-L pane = `ReviewRecap`.

## Demo content (canonical continuity)

Booking `TS-260929-0417`, all units Selesai on Sel 29 Sep 2026 (makespan 2 h from 09.00): invoice issued **11.08**, paid **11.24**, review sent **11.31**.

| Unit | Lines | Unit total |
|---|---|---|
| -A Vario 125 | Servis Berkala Rp85.000 | **Rp85.000** |
| -B Beat 110 | Servis Berkala Rp85.000 · AHM Oil MPX1 Rp58.000 | **Rp143.000** |
| -C PCX 160 | Servis Berkala Rp85.000 · AHM Oil MPX2 Rp70.000 · Kampas Rem Rp45.000 | **Rp200.000** |

Subtotal **Rp428.000** · DISKON10 **−Rp42.800** · Total **Rp385.200** (= S16 / S18). Workshop Bengkel Jaya Motor ★ 4,8 (126 ulasan), Jl. Melati Raya No. 12, Sleman.

S24 filled example: workshop 5★ "Sangat baik", comment "Cepat dan rapi. Montirnya jelas menerangkan kondisi rem PCX.", Mas Rudi 5★, Pak Anto 4★ "Baik". Single-mechanic variant = seed `TS-260910-0091` (Beat 110, Servis Berkala + Oli, Rp143.000, Mas Rudi only; S09 history parity).

## Scope

### Frame matrix (27 frames)

| Screen · State | Phone | Tablet-P | Tablet-L | Dark |
|---|---|---|---|---|
| S23 Unpaid (per-unit lines, fleet total, workshop info, "Tandai Lunas") | ✔ | ✔ | ✔ breakdown left / `InvoiceSummaryCard` right | all three |
| S23 Paid ("Lunas", paid date, "Beri Ulasan") | ✔ | — | — | phone |
| S23 Confirm dialog | ✔ | ✔ | — | — |
| S23 Loading | ✔ | — | — | — |
| S23 Error (Tandai Lunas failed) | ✔ | — | — | — |
| S23 P2 variant (Paid + "Bagikan") | ✔ | — | — | — |
| S24 Default (empty stars, comment, 2 mechanic rows) | ✔ | ✔ | ✔ form left / preview right | all three |
| S24 Validation (workshop rating required) | ✔ | — | — | — |
| S24 Keyboard-open (comment) | ✔ | — | — | — |
| S24 Submitting | ✔ | — | — | — |
| S24 Submitted (read-only recap) | ✔ | — | ✔ pane = final recap | phone |
| S24 Filling (live preview) | — | — | ✔ | — |
| S24 Single mechanic (section hidden) | ✔ | — | — | — |

S23 = 6 + 2 + 2 + 1 + 1 + 1 = 13; S24 = 6 + 1 + 1 + 1 + 2 + 1 + 1 + 1 = 14. Row headers and handoff notes are extra.

### Layout targets (PRD 06 + kickoff)

S23: stacked (phone) → centered 640 (Tab-P) → breakdown 720 left · `InvoiceSummaryCard` 360 right (Tab-L, S16 two-pane recipe). S24: stacked form → centered 560 → form 560 left · live preview 400 right.

### Components built here

| Component | Notes |
|---|---|
| `RatingStars` (owned, PRD 02) | Star atoms Empty / Half / Full (path); Input Large (workshop, 5 × 48 dp + word label), Input Compact (mechanic rows), Display (read-only, half values, value text); `RatingLabel` |
| `PaymentStatusTag` | Belum dibayar / Lunas, icon + text |
| `PaidBanner` | success-soft, check icon + "Lunas" + paid time |
| `InvoiceSummaryCard` | Tab-L pane: total, voucher line, `PaymentStatusTag`, workshop info, CTA; Unpaid / Paid / Confirming |
| `MechanicRatingRow` | Avatar initial (`MechanicCard` recipe), name, units served, `RatingStars` Compact, "Opsional" tag |
| `ReviewRecap` | Read-only: workshop stars + word label, comment, mechanic rows, "Dikirim …"; Submitted / Preview Empty |
| Reused, not redrawn | `PriceBreakdown / Variant=Invoice` (adapt copy), `ConfirmBar`, `WorkshopCtaBar`, `TsDialog / Confirm Save`, `TsSnackbar`, `FormErrorBanner`, `TsTextField / Multiline`, `WorkshopSummaryRow`, `TsAppBar / Type=Back` (+ `Actions` slot for the P2 frame), `Skeleton`, `System / Keyboard` |

### Annotations to place

- Invoice generation trigger; "Tandai Lunas" flips state, unlocks S24; S20 handoff (decision 2).
- Star input semantics (`Semantics` "Nilai bengkel, 4 dari 5"), arrow-key operation, 150 ms selection feedback (reduce-motion: none), polite live region for the word label, "Lunas" and the submit result.
- Where each screen is reached (S20 actions; notification deep link → S23); "Marking / submitting" error handling and S26 "Simulasikan galat jaringan".

## Built (node ids, `design/pencil/TumbasServis.pen`)

Sheet **"Components / Invoice & Review Blocks"** `f5BFW` (x 40424, y 8760, 1200 × ~2,700) with dark copy `ExPX4` (y 12380; 27 unnamed refs renamed; re-copied after the review fixes): `RatingStars` Input Large Value 0 `CMBGR` · 4 `La05C` · 5 `nBeZw`, Input Compact 0 `I3u0Vj` · 4 `FNdQA` · 5 `dtzZi`, Display 5 `nCKLu` · 4 `dQvpB` · 4.5 `t85PL`; `RatingLabel` Empty `FQr5U` · Value `uy29K`; focus specimens `W2Avb` (Large) · `yOY41` (Compact); `PaymentStatusTag` Unpaid `L3VRMh` · Paid `qLIbI`; `PaidBanner` `b8yrEY`; `InvoiceHeaderCard` Unpaid `lENIE` · Paid `LrOFq`; `InvoiceSummaryCard` Unpaid `y7rCv` · Paid `nViIm` · Confirming `jelKY`; `WorkshopRatingCard` Empty `e2UTX` · Rated `Oh81F` · Error `PNz9N`; `MechanicRatingRow` Unrated `m7p8I` · Rated `btKXs`; `ReviewRecap` Submitted `u6tAd` · Preview `fgRFI` · Preview Empty `Hvysq`.

Frames (27), "Step 17" lane at x 37,000 (no existing node moved), all named `S23 Invoice / <State> / <Breakpoint>` or `S24 Beri Ulasan / <State> / <Breakpoint>`:

| Row | Frames (node id) |
|---|---|
| S23 phone light, header `z0KuZ` (y 22,000), frames y 22,186 | Unpaid `N6sbZ` · Paid `HFP2r` · Confirm Dialog `DPVAo` · Loading `l6Y0So` · Error `Ituaf` · P2 Share `HSd9c` · notes `MiFp5` (6 notes, x 39,640) |
| S23 phone dark, header `XTA3K` (y 23,600), frames y 23,786 | Unpaid `bsUIo` · Paid `KVjNM` |
| S23 Tablet-Portrait, header `leSi6` (y 25,100), frames y 25,286 | Unpaid `BjjH8` · Confirm Dialog `ORLUd` · Unpaid Dark `i8OzPI` |
| S23 Tablet-Landscape, header `u7ip8` (y 26,800), frames y 26,986 | Unpaid `g7MUr` · Unpaid Dark `iXINz` (x 38,360) |
| S24 phone light, header `eXcNr` (y 28,100), frames y 28,286 | Default `fTMM0` · Validation `E0ONJ` · Keyboard Open `fM17k` · Submitting `j1BS1` · Submitted `FuIiJ` (860 tall) · Single Mechanic `clwnA` · notes `IqkD2` (6 notes, x 39,640) |
| S24 phone dark, header `RcbCk` (y 29,700), frames y 29,886 | Default `z1lx8I` · Submitted `q0Euv` |
| S24 Tablet-Portrait, header `v37NxY` (y 31,400), frames y 31,586 | Default `VBlec` · Default Dark `BtUDR` |
| S24 Tablet-Landscape, header `spnpS` (y 33,100), frames y 33,286 | Default `jnEc8` · Filling `RysOz` · Submitted `jC53q` · Default Dark `x3EpUP` (x 0 / 1,360 / 2,720 / 4,080) |

Build decisions made while building (inside the kickoff decisions unless marked):
- **Sentence-case CTAs** ("Tandai lunas", "Beri ulasan", "Kirim ulasan", "Kembali ke detail booking"), like S16 / S18; PRD 04 writes them in title case (`/better-interface` MEDIUM, fixed).
- **Added while building:** `InvoiceHeaderCard` (code, issued time, tag, workshop), `WorkshopRatingCard` (Empty / Rated / Error), `RatingLabel` (Empty / Value); the invoice breakdown reuses `PriceBreakdown / Variant=Invoice` `m9GfI` with the "Kampas Rem Depan" line overridden to "Kampas Rem" (S16 / S18 label) and its Paid Badge left disabled (the header tag carries the state). Tab-L left column = header + the same breakdown with the totals rows disabled; the pane carries subtotal-free summary (total, voucher, workshop, time, CTA).
- **S24 Tab-L:** the mechanic rows sit side by side (272 each) so the form column fits the 800 dp viewport without a crop (content 652 of 720 dp); CTA inline at the foot of the column instead of a bar. Tab-P bar = `WorkshopCtaBar` with the CTA at 560 dp centered.
- **S24 Submitted phone frame is 860 dp** (not 800) so the floating snackbar does not cover the last mechanic row.
- **S23 Loading** = skeleton cards + `ConfirmBar / State=Disabled` with the reason "Memuat invoice…".
- **Loading CTA keeps its label** ("Mengirim ulasan" on S24 Submitting, "Menandai lunas" in `InvoiceSummaryCard / State=Confirming`) because `TsButton / State=Loading` is spinner-only (`/better-interface` MEDIUM, fixed).
- The status-bar clock stays at the master's 09.41 on every frame (pre-existing convention; the story times are 11.08 / 11.24 / 11.31).

Pencil facts (verified in step 17; copy to `00-index.md` at close):
- **A rating star is a token-bound `path`** (`geometry` Material 24-unit star, `viewBox [0,0,24,24]`, `strokeLinejoin: "round"`): filled = `fill` + `stroke` `$warning-text`, empty = `stroke` `$border-control` only; a **half star = empty star + a clipped half-width frame** (`clip: true`, `width: size / 2`) holding the filled star. `stroke` takes a plain color / variable string (`{fill: …}` is rejected). The clip frame is exempt by name (`Half Clip`) in the clipping audit.
- **A root frame built with `placeholder: true` in one call and cleared in the same call kept stale child offsets (+50 dp) and rendered blank in light mode**; a `Copy` of its dark twin with `theme: {mode: "light"}` rendered correctly. Read `c.bounds` of the children once after building a root frame; a wrong y means copy it.
- **`TsAppBar / Type=Back` action slot:** `descendants: {Actions: {enabled: true}}`, then `Update("<instId>/<Action 2 id>", {enabled: false})` and the icon of `Action 1` through the resolved path (`<instId>/xFVFI/rJ5Az`, `icon: "share"`); icon names `share`, `payments`, `rate_review`, `event_available`, `schedule` exist.
- **`TsButton / State=Loading` is spinner-only** (`Label` disabled, width 120): show the label with `descendants: {Label: {enabled: true, content}}`; inside a `WorkshopCtaBar` the replaced `CTA` ref needs the resolved path `<barId>/<ctaId>/<labelId>`.
- **`WorkshopCtaBar` on a tablet:** `descendants: {PMZgP: {alignItems: "center"}, CTA: {width: 560}}` centers a 560 dp CTA under an 800 dp bar; `ConfirmBar` tablet recipe (`QtGW7` horizontal, padding [12, 80], `W6y8Bg` and `rFGTX` 280) reused from S16.
- **A whole-document `Get(visit)` throws** (again) and `FindEmptySpace({direction: "bottom"})` returns the space under everything (−220, 133,186); a lane is chosen by reading sheet bounds (`Get(id, visit)` → `c.bounds`) and placing right / below them.
- **A dialog on a tablet full-scroll frame:** scrim rectangle sized to the frame + `TsDialog / Confirm Save` `tMRhF` absolute at the viewport center; text and icon overrides go through resolved ids (`Get(dlg, visit, {resolveInstances: true})`, `save` → `payments`).

## Checklist

### Build
- [x] Kickoff questions answered.
- [x] `RatingStars` Input + Display built, light + dark (focus specimens added by the review).
- [x] S23 and S24 frames built per matrix (27); dark defaults built.
- [x] Line items match the step-01 price sheet (per-unit service + part lines → subtotal → voucher → total).
- [x] Paid / rated states conveyed by icon + label (not color alone).

### Quality (automated, run in `execute`)
- [x] Clipping check on every step frame → zero `problems` (exempt: `Half Clip`, `Scrolled Content`, disabled chains).
- [x] Raw-hex audit → zero (0 of 757 nodes).
- [x] Every node named; instances only; `placeholder` cleared.
- [x] Coverage script: 27 frame names match the matrix above.
- [x] Arithmetic check: invoice lines → total equals S16 / S18 totals (10 frames read; Tab-L pane 385.200 / −42.800).

### /better-interface
- [x] Run `/better-interface` with scope = all S23 + S24 frames (names + node ids).
- [x] Report recorded below; HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [x] Status set to 🔵; user shown: invoice unpaid / dialog / paid / error, review default / validation / submitted, tablet-L filling, dark.
- [x] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [x] PNG export to `design/pencil/exports/step17/` + `INDEX.md` (27 frames + 2 sheets in `components/`).
- [x] Claude session file written.
- [x] Tracker set to ✅; canvas-layout paragraph and Pencil facts in `00-index.md` updated.

## /better-interface report

**Scope:** S23 Invoice 13 frames (`N6sbZ` `HFP2r` `DPVAo` `l6Y0So` `Ituaf` `HSd9c` `bsUIo` `KVjNM` `BjjH8` `ORLUd` `i8OzPI` `g7MUr` `iXINz`) + S24 Beri Ulasan 14 frames (`fTMM0` `E0ONJ` `fM17k` `j1BS1` `FuIiJ` `clwnA` `z1lx8I` `q0Euv` `VBlec` `BtUDR` `jnEc8` `RysOz` `jC53q` `x3EpUP`) + sheets `f5BFW` / `ExPX4` + notes `MiFp5` `IqkD2` · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens · **Convention docs found:** 00-index.md (Pencil mapping table, safe-layout rules), prd/02, prd/06, steps 10 / 11 / 14 / 15 copy and chrome decisions

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | Names for icon-only controls (back, share), focused specimens for the star control and the comment field, star targets (5 × 48 dp), one adjustable control + arrow-key semantics, live announcements (Lunas, submit result, loading), error association, reduced-motion note, color-alone check (paid / unpaid, rated / unrated, error) | 1 HIGH + 1 MEDIUM (fixed), 1 LOW (fixed) |
| Layout | Reading order, grouping gaps (16 between cards, 8 – 12 inside), two-pane geometry (720 · 360, 560 · 400), tablet bars, Tab-L viewport fit (652 of 720 dp), overlay and snackbar placement, keyboard-open frame | 1 LOW (fixed as annotation) |
| Writing | Every string against the step 03 / 07 / 14 / 15 voice ("kamu", sentence case), button verbs, dialog wording, error recovery, placeholders, empty state | 1 MEDIUM (fixed), 2 LOW |
| Typography | Type-role tokens, min size 12, wrapping of unit lists at 272 dp, line counts, tabular figures | 1 LOW (fixed as annotation) |
| Color | 1,646 text + icon + star nodes composited from the rendered ancestors, light and dark; semantic use (success for Lunas, warning for Belum dibayar, danger only for the validation error) | Clear (1 LOW token note) |
| UI | Radii nesting, card / banner / tag surfaces, star atoms (stroke weights, half star), loading / disabled / error states, focus specimens, motion notes | Clear |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| HIGH (fixed) | Accessibility | `RatingStars / Mode=Input` masters `CMBGR` `La05C` `nBeZw` `I3u0Vj` `FNdQA` `dtzZi`, used in every S24 frame | An interactive, keyboard-operated control with no designed focused state | Focus specimens `W2Avb` (Large) and `yOY41` (Compact) in sheet `f5BFW`: padding 4, `focus-ring` 2 dp inner stroke, radius 12 (step 09 recipe); semantics note covers arrow keys | A keyboard-reachable control needs a visible focus indicator |
| MEDIUM (fixed) | Writing | 23 text nodes: ConfirmBar CTAs in S23 `N6sbZ` `HFP2r` `DPVAo` `l6Y0So` `Ituaf` `HSd9c` `bsUIo` `KVjNM` `BjjH8` `ORLUd` `i8OzPI`, the `InvoiceSummaryCard` masters (`y7rCv` `nViIm` `jelKY`) and the payment note | "Tandai Lunas", "Beri Ulasan", "Ketuk Tandai Lunas." | "Tandai lunas", "Beri ulasan", "Ketuk Tandai lunas." | One capitalization policy: S16 "Konfirmasi booking" and S18 "Lacak status" are sentence case; "Kirim ulasan" beside "Beri Ulasan" read as sloppiness |
| MEDIUM (fixed) | Accessibility | S24 Submitting `j1BS1` CTA, `InvoiceSummaryCard / State=Confirming` `jelKY` | Loading button shows only the spinner (`TsButton / State=Loading`, `Label` disabled) | Spinner + "Mengirim ulasan" / "Menandai lunas" through `Label: {enabled: true}` | The busy state keeps its name; a bare spinner names nothing |
| LOW (fixed) | Typography | Amounts, the comment counter and times on S23 / S24 | Digits shift as values change | Note `TI9gc` / `OGpqd`: tabular figures on every amount, counter and time | Values that change need tabular numbers |
| LOW (fixed) | Accessibility | S23 Loading `l6Y0So` | Skeleton with no announcement | Note `NDzGq`: announce "Memuat invoice" politely; CTA stays disabled with the reason | Loading must reach non-visual users |
| LOW (fixed) | Layout | S24 Tab-L `jnEc8` `RysOz` | Inline CTA at the column foot; a larger text scale would push it past the fold | Note `GCgEK`: the form column scrolls above the CTA, which stays reachable (measured 652 of 720 dp at ×1) | A primary action must not clip out of reach |
| LOW (left) | Color | `RatingStars` star fill / stroke (`warning-text`, same as the `WorkshopCard` star) | A status token borrowed for a rating glyph | Add a `rating-star` token in step 19 (PRD 02 change needs approval) | "Use a token only in its role"; the amber hue also means "Belum dibayar" and "limited" |
| LOW (left) | Writing | Comment field on `fTMM0` and 6 more frames | Label "Komentar (opsional)" and placeholder "Ceritakan pengalamanmu (opsional)" | Placeholder as an example, e.g. "Contoh: Montirnya ramah dan pengerjaan cepat." | Placeholders show a format; "(opsional)" already sits in the label (wording came from kickoff decision 10) |
| LOW (left) | Writing | Mechanic section (`fTMM0` and 8 more frames) | "Opsional" tag on every row + caption "Boleh dilewati" | Keep the tag, drop the caption clause (or the reverse) | Two cues for one fact |
| Pre-existing | Layout | `System / Status Bar` clock 09.41 on every frame | Story times on S23 / S24 are 11.08 / 11.24 / 11.31 | Decide at step 19 (all steps share the master) | Already a cross-step item |

**Verification:** *Passed* — clipping 0 rows over 29 roots (`resolveInstances: true`; exempt: `Half Clip` clip frame, `Scrolled Content`, disabled chains) run in a separate call from the inserts; raw hex 0 of 757 nodes; unnamed non-ref nodes 0; placeholders 0 (two `fTMM0` / `z1lx8I` flags found and cleared); text < 12 sp 0 of 1,426; contrast 1,646 text + icon + star nodes, 0 failures (before and after the fixes, sheets included); arithmetic on 10 invoice frames (unit lines → Rp428.000 → −Rp42.800 → Rp385.200; Tab-L left lines + pane) and S16 total Rp385.200; coverage 27 / 27 names; step 16 sheets `iZ2qP` / `RZ6Rs` bounds unchanged (1200 × 1740 at x 39,016). *Not verified* — Flutter runtime (semantics tree, focus traversal, live regions), motion (annotations only), text ×1.3 and 360×640 frames (not built by decision).
**Verdict:** Approve
**Fixes applied:** HIGH ×1, MEDIUM ×2, LOW ×3 above · **LOW left for user:** star token, comment placeholder, doubled "opsional" cue. Pre-existing: status-bar clock → step 19.

## Review rounds

#### Round 1 — 2026-09-25
- **Frames shown:** S23 Unpaid / Confirm dialog / Paid / Error / P2 (phone), Tab-P, Tab-L, dark; S24 Default / Validation / Keyboard-open / Submitting / Submitted / Single mechanic (phone), Tab-P, Tab-L Default / Filling / Submitted, dark; component sheet `f5BFW` / `ExPX4`.
- **User feedback:** "approve"
- **Changes made:** none after the report (the `/better-interface` fixes were applied before the gate).
- **Outcome:** approved

## Session log

| Time | Action | Result / node ids |
|---|---|---|
| 2026-09-25 | Kickoff interview (3 rounds, 11 questions) | All recommended options chosen; decisions recorded above |
| 2026-09-25 | Status ⬜ → 🟡 | — |
| 2026-09-25 | Pre-flight reads | `PriceBreakdown / Variant=Invoice` `m9GfI` (Paid Badge present but disabled; note row reads "Estimasi 2 jam · Bayar di bengkel" → override), `ConfirmBar` `gdg2y`, `ConfirmPane` `ZRSWe`, `WorkshopCtaBar` `w02XMN`, `MechanicCard` `w6Juk` ("MONTIR · UNIT -B", "★ 4,8 · 214 servis"), `TsAppBar / Type=Back` `R7zOVC` (has a disabled 2-button `Actions` slot), `TsDialog / Confirm Save` `tMRhF`, S16 phone `a2akK` / Tab-P `MlZC9` / Tab-L `X2tGYU` skeletons. Tracking sheet `iZ2qP` = 1200 × 1740 at x 39016 |
| 2026-09-25 | Star spike | Path star + `warning-text` fill / `border-control` outline + clipped-half frame renders in light and dark (`warning-text` `#8F641A` / `#D99A2B`). A root frame built with `placeholder: true` kept stale child offsets (+50 dp) in light mode and rendered blank; a `Copy` of the dark frame with `theme light` rendered correctly. Spike frames deleted |
| 2026-09-25 | Docs kickoff | Step file rewritten; `00-index.md` decision-log row, demo-content row, inventory row, tracker 🟡; `19-full-app-audit.md` "step 17" block |
| 2026-09-25 | Component sheet | `f5BFW` (x 40424, y 8760): 9 `RatingStars`, 2 `RatingLabel`, tags, banner, header cards, summary cards, workshop cards, mechanic rows, recaps; dark copy `f1UM4` (27 unnamed refs renamed), later replaced by `ExPX4` |
| 2026-09-25 | S23 frames | 13 frames in the Step 17 lane (phone 6 + dark 2, Tab-P 3, Tab-L 2), built by `Copy` of the Unpaid phone frame; "Kampas Rem Depan" → "Kampas Rem" override; arithmetic read on 10 frames |
| 2026-09-25 | S24 frames | 14 frames (phone 6 + dark 2, Tab-P 2, Tab-L 4); Keyboard Open = clipped `Scroll Viewport` + `System Keyboard`; Submitted 860 dp after the snackbar covered the last mechanic row |
| 2026-09-25 | Notes | `MiFp5` (S23) and `IqkD2` (S24), 6 notes each, explicit heights (all read back 219 dp; four edited later to 240 – 260) |
| 2026-09-25 | Automated checks | clipping 0, raw hex 0 / 757, unnamed 0, placeholder 2 → 0, text < 12 sp 0, contrast 1,621 → 1,646 nodes 0 failures, arithmetic OK, coverage 27 / 27 |
| 2026-09-25 | `/better-interface` | All six domain skills applied; 1 HIGH + 2 MEDIUM + 3 LOW fixed, 3 LOW left; verdict Approve; dark sheet re-copied (`ExPX4`) |
| 2026-09-25 | Status 🟡 → 🔵 | Review gate: user to review S23 unpaid / dialog / paid / error, S24 default / validation / keyboard / submitted, Tab-L filling, dark |
| 2026-09-25 | User approval | "approve" (round 1) |
| 2026-09-25 | Export | 27 frames → `design/pencil/exports/step17/`, 2 sheets → `…/step17/components/`, `INDEX.md` (`ls`: 27 PNG in the folder, 2 in `components/`) |
| 2026-09-25 | Close | `00-index.md`: tracker ✅, canvas-layout "After step 17", "Verified in step 17"; session file `docs/claude-session/19-design-step17-invoice-rating.md`; status ✅ |
| 2026-09-25 | Step 19 audit fixes (F6, F7, F10, F11) | S23 confirm dialog dismiss "Kembali" → "Batal" (`ErVEy/nFZKr/duZFa`, `RfzCv/nFZKr/duZFa`); star nodes bound to new token `rating-star` (37); 57 literal `fontWeight: "normal"` in the Invoice & Review masters and S24 frames bound to `$font-weight-regular`; MOTION note `YPW51` in `MiFp5`; 12 master strokes set to `strokeAlignment: inner` |
