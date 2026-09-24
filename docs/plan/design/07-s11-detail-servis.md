# Step 07 — S11 Detail Servis per Motor (core challenge screen)

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-24 (07a phone + 07b tablet) |
| **Priority** | P0 |
| **Owns screens** | S11 |
| **Owns components** | (screen-local, flagged for `prd/02`): `UnitHeader`, `CopyFromRow` + `CopyNote`, `CopySourceSheet` (+ `CopySourceRow`), `ComplaintSection`, `TsAppBar` step variant, tablet `EstimatePane`; design-only `System / Keyboard`; `VehicleTabChip` active-status variants (amends step 04) |
| **PRD refs** | [04 S11](../../../prd/04-screens.md), [03 per-unit rules, "Salin dari", pricing/duration, edge cases](../../../prd/03-user-flows.md), [06 S11 row + device matrix](../../../prd/06-responsive-layout.md), [01 pillar 2](../../../prd/01-overview.md) |
| **Pen location** | Flows row `S11` |
| **Depends on** | Steps 02–04, 06 |
| **Claude session** | `docs/claude-session/09-design-step07-s11-detail-servis.md` (written after the 07b approval; both halves are logged in this file) |

## Goal

Design the assessment's core differentiator: configuring service, parts/oil and complaint **independently per unit**, without ever making the single-motor path heavier. This is the largest and most scrutinized screen — every state, every breakpoint, plus the tablet list-detail-summary layout.

Run as two sessions (kickoff decision 1): **07a** = kickoff, components, phone frames (light + dark + stress); **07b** = tablet-portrait, expanded, tablet-landscape, `EstimatePane`, `/better-interface`, the one review gate, export.

## Inputs

- `BookingStepper` (step 2/4 + "2/3 ✓" badge), `VehicleTabChip` (✓ ○ error, active = selected style; rail variant for tablet), `ServiceOptionTile` (checkbox), `PartOptionTile` (compact), `TsChip` (complaint presets), `TsTextField` (multiline + counter), `StickyEstimateBar`, `PriceBreakdown` (pane variant), `TsDialog` (destructive), `TsSnackbar` (with action), `SheetHeader`, `ErrorState`, `Skeleton`, `TsIconButton`.
- Business rules: ≥1 service per unit; complaint mandatory if `requiresComplaint`; 250-char cap with counter near the limit; parts filtered by model; "Salin dari" copies services + compatible parts only, never complaint notes; chip row hidden for a single unit; "Lanjut" enabled only when every chip shows ✓.

## Kickoff decisions (answered 2026-09-24, interview with the user; every recommended option accepted)

Three `AskUserQuestion` rounds (11 questions); the plan's seven open questions plus five found while planning. Old Q1 (service model) and Q4 (disabled-Lanjut reason) were already settled in step 04 (decisions 2 and 5).

| # | Topic | Decision |
|---|---|---|
| 1 | Sessions | **07a** phone (kickoff, components, phone light + dark + stress) and **07b** tablet; **one review gate after 07b**. 07a ends with screenshots for a heads-up only, no gate. One session file, written after the 07b approval |
| 2 | Service model (old Q1, step 04) | `ServiceOptionTile` checkbox multi-select, ≥ 1 service required, Perbaikan/Keluhan combinable with the others |
| 3 | Keluhan visibility (found while planning: PRD 04 text says "only if the selected service requires it", its wireframe shows "opsional" always) | **Collapsed row** "+ Tambah keluhan (opsional)" that expands on tap. Selecting Perbaikan/Keluhan auto-expands it and makes it required; the empty-required state is icon + text + border (never color alone), the chip goes to error |
| 4 | Active chip (found while planning: the four built states ✓ ● ○ error are exclusive, so the active unit hides its completion) | **Active = selected style and it keeps its status glyph** (✓ complete / ○ incomplete / error). Amends step 04: the existing Active master gets glyph ○ (Active+Incomplete), plus **Active+Complete** and **Active+Error**, for the chip and the rail row. The badge "N/3 ✓" always matches the chips. Semantics "Beat 110, lengkap, dipilih" |
| 5 | "Salin dari" (old Q2) | The row names the source when exactly one other unit has selections ("Salin dari Vario 125", one tap). With 2+ sources the same row (chevron) opens a **source sheet** (phone bottom sheet, tablet centered modal). Copy replaces the unit's selections; snackbar "Disalin dari Beat 110 · Urungkan" restores them; a persistent inline note "N item suku cadang tidak disalin karena tidak kompatibel" stays when parts were dropped. Complaint is never copied |
| 6 | Estimate (old Q7) | **Everything selected so far, live**: every ticked service + part on any unit, complete or not; a unit with nothing adds 0. Duration = makespan on the 2-bay workshop. Caption "Estimasi · 1 jam". Canonical run: 1 unit Rp85.000 · 1 jam → 2 units Rp228.000 · 1 jam → 3 units Rp428.000 · 2 jam |
| 7 | Tablet-L with 1 unit (old Q5) | **2-pane**: form + `EstimatePane`, rail hidden. 3 units = rail · form · `EstimatePane`. Expanded 1024 = rail + form + sticky bar. Tablet-P = chips (top) + cards, content max 720, sticky bar |
| 8 | App bar (deferred from step 06 decision 5) | **Back leading + close trailing**, title "Detail servis". Back → S10 (draft kept); close → the step 06 exit dialog (only with ≥ 1 selection; "Simpan & keluar" / "Lanjutkan booking"). Reused by S13–S16 |
| 9 | Remove unit (found while planning: PRD 03 edge case has no control in the wireframe) | Trailing icon button in `UnitHeader`, semantics "Keluarkan Beat 110 dari booking". Hidden with 1 unit. A unit with no selections is removed at once; a unit with selections opens the destructive `TsDialog` (state 9). Dropping to 1 unit hides the chip row and the badge |
| 10 | Service tiles | **3 tiles** as in the PRD wireframe: Servis Berkala Rp85.000 · 60 mnt, Ganti Oli Rp35.000 · 30 mnt, Perbaikan/Keluhan "mulai Rp50.000" · 60 mnt (`requiresComplaint`). Only Servis Berkala is canonical; the two other prices are proposals, changeable at review, written to `services.json` in the step 19 PRD sync |
| 11 | Keluhan presets (old Q3) | 6 chips: Rem bunyi · Getar · Mesin brebet · Susah hidup · Oli merembes · Lampu mati, plus "Lainnya" (focuses the field). A chip toggles and appends / removes its label in the note; the label counts toward the 250 limit. No data-model change (`complaintNote` stays one string) |
| 12 | P2 complaint photo (old Q6) | Left out; one annotation marks where the row would sit |

### 07b kickoff decisions (answered 2026-09-24, three `AskUserQuestion` rounds, 11 questions; every recommended option accepted)

| # | Topic | Decision |
|---|---|---|
| 13 | Tablet capture | **Fixed viewports** 800×1280 / 1024×768 / 1280×800, clipped, no status / gesture bar (as the S05 / S10 tablet frames). Long states show a scrolled position + scroll cue; rail, pane and bar are pinned, only the form scrolls |
| 14 | `EstimatePane` | New master (the existing `PriceBreakdown / Variant=Pane` `ajTlg` is the S16 one: voucher + "Konfirmasi booking"). Title "Estimasi biaya", one **static** line per unit (name + subtotal; a unit with nothing = "Belum dipilih"), divider, Total, "Estimasi · N jam", reason line, Lanjut. No voucher (starts at S16). Lines are read-only, no active marker, not tappable: the rail is the only unit switcher. Reuses `PriceBreakdown Unit / State=Static` `b1Fc7`, `Total Row` `sVRWq`, `Note Row` `pZ3Zt`. Variants: Units=3 Default / CTA Disabled / Loading / Error, Units=1 Default |
| 15 | Rail row | The built rail rows stay (`lsQRa`, `lBXKN`, `Q0U73`, …: glyph + nickname + "plate · status", 252×62). No new rail masters; a plain "Motor" label sits above the rows |
| 16 | Estimate bar (Tablet-P, Expanded) | Same floating glass pill, **width = form column** (720 on Tablet-P, 700 on Expanded, centered under the form column), 8 dp above the bottom edge; width override on `StickyEstimateBar` (verify the Main Row reflows) |
| 17 | Parts shortlist | Stacked `PartOptionTile / Layout=Compact` at every width; no grid tile on S11 |
| 18 | Tablet-L geometry | 3-pane: margins / gutters 24, rail 252 · form **572** · pane 360 (24+252+24+572+24+360+24 = 1280). 1-unit 2-pane = **centered group**: form 720 + 24 + pane 360 = 1104, 88 dp side margins. Expanded: rail 252 · form 700 (24+252+24+700+24 = 1024) + pill |
| 19 | Badge "N/3 ✓" | Stays in the wide `BookingStepper` row (right end) in every tablet frame; the rail carries no badge. The wide master's `Completion Badge` sits at (0,0) and is placed by override (absolute, x = width − 52) or a `Badge=Yes` master |
| 20 | Stepper placement | Wide stepper 720 dp **centered on the frame** at every tablet size (as the S10 tablets); the panes start below it |
| 21 | Tablet stress | +1 frame: `Stress Text 1.3 / Tablet-Landscape` (Multi Unit 3-pane, script-scaled). Matrix 16 → **17** (38 → 39 frames) |
| 22 | 07a defect found at kickoff | `Multi Unit` `QiJSV` and `Remove Unit Dialog` `r1uhZn` (+ dark `j2s2Pp`, `sKc7x`) show PCX ○ incomplete with the enabled `StickyEstimateBar / Default` `eArud`. Rule (PRD 03 / 04, decision 6): Lanjut enabled only when every chip is ✓. **Fixed in 07b**: `CTA Disabled` `aDCZ9` with reason "Pilih layanan untuk PCX 160" (override key `QpfuR`, as in `hxQ1H`), frame heights re-measured, dialog overlay height updated; logged as a 07a correction. All tablet Multi Unit frames and the pane use the same disabled state |

Defaults applied without a question (change at review if unwanted): Tablet-P chip row = natural-width chips left-aligned in the 720 column (`VehicleTabRow / Overflow=None`, no fade); the Source sheet on Tablet-P = new centered **modal** variant, 560 wide, close button, no drag handle (PRD 06 S22: modal max 560); Remove dialog = the existing `TsDialog / Confirm Destructive` centered (dialogs are breakpoint-identical); Loading = rail with known units + form skeletons + pane Loading, badge hidden; Error = inline `ErrorState` in the form + pane Error, two "Coba lagi" like the phone; no keyboard frame on tablet (annotation only); `/better-interface` runs once, report split into Phone (07a) and Tablet groups; export = key frames only.

Defaults applied without a question at the 07a kickoff (change at review if unwanted): the stepper badge is hidden with a single unit; the parts shortlist shows 3 model-compatible parts + "Lihat semua" (→ S12, annotation only; the S12 sheet is step 15); incompatible parts are hidden on S11 (the compatibility badge lives on S12); canonical unit contents — Vario 125 = Servis Berkala (Rp85.000), Beat 110 = Servis Berkala + AHM Oil MPX1 (Rp143.000), PCX 160 = Servis Berkala + AHM Oil MPX2 + Kampas Rem (Rp200.000); keyboard = a design-only `System / Keyboard` master (not a Flutter widget); export at close = key frames only, no HTML export / Figma import until step 12.

## Scope

### Frame matrix

39 frames (07a 22, 07b 17). Names: `S11 Detail Servis / <State> / <Phone|Tablet-Portrait|Tablet-Landscape|Expanded>` + ` · Dark`; states `Single Unit`, `Multi Unit`, `Complaint Required`, `Copied`, `Copy Source Sheet`, `All Complete`, `Loading`, `Error`, `Remove Unit Dialog`, `Keyboard`, `Stress 360x640`, `Stress Text 1.3`.

| # | State | Phone | Tablet-P | Expanded 1024×768 | Tablet-L | Dark |
|---|---|---|---|---|---|---|
| 1 | Single unit — no chip row, no badge, Servis Berkala chosen | ✔ | ✔ | — | ✔ (2-pane) | phone |
| 2 | Multi-unit (3) — chips, Beat active + complete, "2/3 ✓", "Salin dari Vario 125" | ✔ | ✔ | ✔ | ✔ (3-pane) | phone + Tablet-P + Tablet-L |
| 3 | Complaint required, note empty → chip error, "Lanjut" blocked with reason | ✔ | ✔ | — | — | phone |
| 4 | After "Salin dari": inline note about dropped incompatible parts + Urungkan snackbar | ✔ | — | — | — | phone |
| 5 | "Salin dari" source sheet (2 sources) | ✔ | ✔ (centered modal) | — | — | phone |
| 6 | All units complete — 3/3 ✓, "Lanjut" enabled | ✔ | ✔ | — | ✔ | phone |
| 7 | Loading (catalog fetch skeleton) | ✔ | ✔ | — | ✔ | phone |
| 8 | Error (retry) | ✔ | ✔ | — | ✔ | phone |
| 9 | Remove-unit confirm dialog (unit has selections) | ✔ | ✔ | — | — | phone |
| 10 | Keyboard open on the complaint field — sticky bar above the keyboard | ✔ | — | — | — | phone |
| — | Stress: 360×640 (state 2) | ✔ | — | — | — | — |
| — | Stress: text scale ×1.3 (state 2, chip row + tiles) | ✔ | — | — | — | — |

Phone: 10 light + 10 dark + 2 stress = 22 (07a). Tablet-P 8 light + 1 dark, Expanded 1, Tablet-L 5 light + 1 dark + 1 stress (`Stress Text 1.3 / Tablet-Landscape`, decision 21) = 17 (07b). In every Multi Unit frame PCX is ○, so the bar / pane is the **disabled** state with "Pilih layanan untuk PCX 160" (decision 22).

### Canonical content per state (Vario ✓ · Beat ✓ · PCX ○ unless noted)

| # | Content |
|---|---|
| 1 | Vario 125 only, `AB 1234 XY`; Servis Berkala ticked; no parts; Estimasi · 1 jam / Rp85.000 |
| 2 | Chips Vario ✓ · **Beat ✓ (active)** · PCX ○, badge "2/3 ✓"; Beat = Servis Berkala + AHM Oil MPX1 ticked, Kampas Rem unticked; "Salin dari Vario 125"; Estimasi · 1 jam / Rp228.000 |
| 3 | PCX active, Servis Berkala + Perbaikan/Keluhan ticked, note empty; PCX chip = Active+Error; Keluhan expanded with the error; bar disabled, reason "Tulis keluhan untuk PCX 160" (a specimen: the total is recomputed and differs from the canonical run) |
| 4 | PCX active right after copying from Beat: Servis Berkala copied, MPX1 dropped (not compatible with 160 cc) → note "1 item suku cadang tidak disalin karena tidak kompatibel"; snackbar "Disalin dari Beat 110 · Urungkan" |
| 5 | PCX active, Vario + Beat complete → sheet "Salin dari motor mana?" with two source rows (service summaries) + footnote "Keluhan tidak ikut disalin" |
| 6 | 3/3 ✓, PCX active = Servis Berkala + AHM Oil MPX2 + Kampas Rem; Estimasi · 2 jam / Rp428.000; Lanjut enabled |
| 7 | Real app bar + stepper + chip row (units known from S10), skeleton cards, estimate bar loading, CTA disabled |
| 8 | Inline `ErrorState` "Katalog gagal dimuat" + "Coba lagi", estimate bar error variant |
| 9 | State 2 dimmed with `scrim` + dialog "Keluarkan Beat 110 dari booking?" — "Pilihan servis dan suku cadang untuk motor ini akan dihapus." — Keluarkan (danger) / Batal |
| 10 | PCX, Perbaikan/Keluhan ticked, Keluhan expanded and focused with typed text and counter, `System / Keyboard`, bar above the keyboard, no gesture bar |

### Layout targets (PRD 06)

- No `NavBar` / `NavRail` on any breakpoint (step 06 decision 2). Frame = status bar (phone) + `TsAppBar` step variant + `BookingStepper` + body + sticky bar + gesture bar.
- Phone: chip tabs (scrollable, fade edge, visible scroll cue) + stacked cards; sticky glass `StickyEstimateBar` above the bottom inset.
- Tablet portrait: chip tabs (top) + stacked cards, max-width 720 centered; sticky bar (pill, width 720).
- Expanded (1024): unit **rail** (left, 252) + config form (700); estimate stays a sticky pill (width 700, under the form column).
- Large (1280): **list-detail-summary** — unit rail 252 · config form 572 · live `EstimatePane` 360 (per-unit lines + total + duration + Lanjut); 1 unit = form 720 + `EstimatePane` 360, centered group (decisions 13 – 20).

### Components built here (flag for inventory)

| Component | Notes |
|---|---|
| `VehicleTabChip` + rail row (step 04 amend) | Active+Incomplete (glyph ○, replaces ●), Active+Complete, Active+Error; edits the existing Active master, adds 2 chip + 2 rail masters |
| `TsAppBar / Type=Step` | back leading, title, close trailing (reused S13–S16) |
| `UnitHeader` | nickname (2 lines then ellipsis) · model · plate · status text · trailing remove icon button; variant without the button (1 unit) |
| `CopyFromRow` (+ `CopyNote`) | single-source and multi-source (chevron) rows; hidden when < 2 units or no other unit has selections; `CopyNote` inline info banner (icon + text) |
| `CopySourceSheet` (+ `CopySourceRow`) | source rows with the service summary, footnote; also used as the centered modal on tablet (07b) |
| `ComplaintSection` | Collapsed, Expanded optional, Required, Error, near-limit counter; preset chips + multiline field |
| `System / Keyboard` | design-only Android keyboard for state 10 |
| `EstimatePane` (07b) | title + static per-unit lines + total + duration + reason line + Lanjut; Units=3 default / CTA disabled / loading / error, Units=1 default (decision 14) |
| `CopySourceSheet / Layout=Modal` (07b) | centered 560 dp modal with close button for tablet (decision, defaults) |

### Annotations to place

- Chip switching preserves each unit's in-progress state; completion logic for ✓ / ○ / error and the active style; chip-status semantics ("Beat 110, lengkap, dipilih").
- "Lanjut" gating and the disabled-reason line; unit removal recomputes chips (1 unit → chip row and badge hide); the removal dialog appears only when the unit has selections.
- "Salin dari": single vs multi source, copy replaces the unit's selections, Urungkan window, dropped-parts note, complaint never copied.
- Keluhan: collapsed by default, auto-open + required with Perbaikan/Keluhan, presets write into the note, counter near the limit, P2 photo would sit under the field (not built).
- "Lihat semua" → S12 sheet route (step 15); selections sync back to the active unit.
- Keyboard handling: content scrolls above the keyboard; sticky bar repositions above the inset.
- Back → S10, close → exit dialog only with ≥ 1 selection; app bar reused S13–S16.
- Motion: chip select 150 ms; card / section expand 250 ms; snackbar 250 ms; reduce-motion behavior.
- Semantics for chips and the character counter (polite live region near the limit); icon-only remove button label.

## Checklist

### Build — 07a
- [x] Kickoff questions answered (12 decisions above); step-04 variants confirmed (checkbox tile, chip rail; active-status variants to add).
- [x] `VehicleTabChip` + rail active-status variants built; existing Active master re-glyphed.
- [x] New masters built on the S11 blocks sheet (light + dark copy): `TsAppBar / Type=Step`, `UnitHeader`, `CopyFromRow`, `CopyNote`, `CopySourceSheet`, `ComplaintSection` variants, `System / Keyboard`.
- [x] States 1–10 built on phone (light), dark copies built, stress frames (360×640, ×1.3) built and clean.
- [x] Complaint error uses icon + text + border (not color alone); chip error state matches.
- [x] Demo content consistent with the demo-content sheet (totals Rp85.000 → Rp228.000 → Rp428.000).
- [x] Long-content test: long nickname, 250-char complaint, 4 parts (`QlnHL`).

### Build — 07b
- [x] Kickoff questions answered (decisions 13 – 22).
- [x] 07a correction: Multi Unit / Remove Unit Dialog bars (light + dark) → disabled with reason (decision 22).
- [x] Tablet-P (8 light + 1 dark), Expanded (1), Tablet-L (5 light + 1 dark + 1 stress) frames built.
- [x] `EstimatePane` built; tablet-L 3-pane and 2-pane compositions use it and the rail rows (instances only).
- [x] Source sheet as a centered modal on tablet-P.

### Quality (automated, run in `execute`)
- [x] Clipping check on every step frame → zero `problems` (07b frames; 07a frames checked at 07a).
- [x] Raw-hex audit → zero.
- [x] Every node named; instances only; `placeholder` cleared.
- [x] Coverage script: frame names match the matrix above.
- [x] Arithmetic script: S11 totals equal the demo-content sheet.

### /better-interface
- [x] Run once after 07b with scope = all S11 frames (names + node ids); split per breakpoint group if too large and state the boundary (tablet group in depth, phone group by the automated checks).
- [x] Report recorded below; HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate (after 07b)
- [x] Status set to 🔵; user shown: single vs multi-unit, error, copy note + source sheet, complete state, tablet-P, 1024 rail, 1280 3-pane and 2-pane, keyboard frame, stress frames.
- [x] Review rounds logged; user approval recorded (2026-09-24, "approve").

### Close (only after approval)
- [x] PNG export of the key frames to `design/pencil/exports/step07/` + `INDEX.md` (27 PNG, verified with `ls`).
- [x] Claude session file written (`docs/claude-session/09-design-step07-s11-detail-servis.md`).
- [x] Tracker set to ✅; inventory additions updated; canvas-layout and "Verified in step 07" facts in `00-index.md`; S11 PRD corrections queued in `19-full-app-audit.md`.

## Built sheets and frames (node ids, `design/pencil/TumbasServis.pen`)

### 07a — components + phone (2026-09-24)

Component sheet **S11 blocks** `nSN5s` (light, x 26728, y 8760, right of the S10 blocks) and its dark copy `x7zHcC` (y 12380; 18 refs renamed after the `Copy`). No new variables. Masters (ids):

| Family | Masters |
|---|---|
| `VehicleTabChip` (amends step 04) | Active Complete `t9Qgh`, Active Error `m5jdSG`; the old Active `mvcAv` is now **Active Incomplete** (glyph ○, radio_button_unchecked); rail rows Active Complete `lBXKN`, Active Error `Q0U73`, old rail Active `lsQRa` → Active Incomplete. Unselected Error chip `ZWERV` / rail `Q6qYL` went from a 2 dp to a **1 dp** border so selected (2 dp) vs unselected stays the same grammar for every status |
| App bar | `TsAppBar / Type=Step` `mYhlk` (back · title · close) |
| Unit header | `UnitHeader / Remove=Yes` `YEC5q`, `Remove=No` `CLy2n`; status row overridden per instance (✓ / ○ / error) |
| Salin dari | `CopyFromRow / Sources=One` `Nryr6`, `Sources=Many` `CBGfS` (+ focused / pressed specimens), `CopyNote` `i4ss3l`, `CopySourceRow` `ukrHl`, `CopySourceSheet` `dgVBx` |
| Keluhan | `ComplaintSection` Collapsed `QDDPB`, Optional `vukht`, Required `Tt1G7`, Error `Bi9Cm`, Typing `vOhW7` (+ near-limit specimen `DwnMr`, 239 / 250) |
| Design-only | `System / Keyboard` `Eov7k` |
| Specimens | snackbar "Disalin dari Beat 110 · Urungkan" `bHpXs`, destructive dialog "Keluarkan Beat 110 dari booking?" `SzzyC` (an instance of `TsDialog / Confirm Destructive`) |

Frames — light row y 23086 (header `D2vfzk` y 22900, fold marker `iNfzI`, notes `oJ2W5` at x 5280); dark row y 24986 (header `ZDhFY` y 24800):

| State | Light | Dark |
|---|---|---|
| Single Unit | `l6oRfS` (1004) | `oyyCM` |
| Multi Unit | `QiJSV` (1110) | `j2s2Pp` |
| Complaint Required | `Nh01Y` (1480) | `mV5yl` |
| Copied | `y0QVv` (1198) | `UfAA8` |
| Copy Source Sheet | `hxQ1H` (1150) | `sPAqK` |
| All Complete | `tL4G5` (1122) | `qmdFq` |
| Loading | `EoXJm` (1040) | `nz5S3` |
| Error | `apW2N` (800) | `yFcHM` |
| Remove Unit Dialog | `r1uhZn` (1110) | `sKc7x` |
| Keyboard | `OoHSH` (800) | `YI9M0` |
| Stress 360x640 / Stress Text 1.3 | `GG52K` (640) / `XDfNp` (1352) | — |
| Long Content (extra specimen, x 7000) | `QlnHL` (1814) | — |

The **Flows – Tablet block moved down 4,000 dp** (27 root nodes: anchor `URsZs` is now y 27000; S05 tablet rows y 27372 / 28958; S10 tablet rows y 30286 portrait / 31886 landscape), so 07b builds its tablet rows below y ≈ 32,700 or in a gap it finds with `FindEmptySpace`.

Build decisions made while building (outside the 12 kickoff decisions unless marked; change at review if unwanted):
- **`CopyFromRow` sits directly under `UnitHeader`**, not at the bottom as in the PRD wireframe: it is a shortcut that fills everything below, so it belongs before the choices. The `CopyNote` sits right under it (next to the action that caused it).
- **Perbaikan/Keluhan tile shows "Rp50.000" with the meta "60 mnt · Estimasi awal"** instead of "mulai Rp50.000" (the longer price wrapped the name to two lines at 360). Part names are short (`Kampas Rem`, `Busi NGK`, `Busi Iridium`); the parts shortlist is per model: Vario / PCX = AHM Oil MPX2 (Rp70.000), Beat = MPX1 (Rp58.000), all + Kampas Rem (Rp45.000) + a spark plug (Rp28.000 / Iridium Rp95.000); the meta line carries the cc range that explains the filter.
- **Unit tab row** = a clipped `layout: none` frame holding a `Chips Track` at a negative x (69 dp for the PCX-active frames) with a 24 dp fade at the right and, when scrolled, at the left. The three chips need 373 dp, so the canonical story scrolls at 360.
- **Full-scroll captures**: the sticky bar sits at the end of the page; the source sheet and the remove dialog are placed in the **top 800 dp viewport** (sheet bottom-anchored at 800, dialog centered at 400); the undo snackbar floats 8 dp above the bar. The Keyboard frame is a fixed 800 dp viewport: `Scrolled Content` at y −108 inside a clipped body so the field and counter stay visible, the bar sits on the keyboard, the gesture bar belongs to the keyboard.
- **Preset chips wrap by hand** (3 / 2 / 2 rows unselected, 4 rows with two selected, because the check icon widens a selected chip): the Typing master has four rows.
- **Complaint Required is a specimen** (PCX with Perbaikan/Keluhan): Rp363.000 · 2 jam, not the canonical run. Loading hides the stepper badge (counts unknown). Error keeps two "Coba lagi" buttons (card + bar), both retry the catalog.
- **Remove icon** = `do_not_disturb_on` (`remove_circle` is not in the set and renders "?").
- **Long Content** specimen (an extra 23rd frame): 46-character nickname, chip label with manual ellipsis, a 4th part tile with a 63-character name, a 250-character complaint (counter 250/250) → no clipping.

### 07b — tablet (2026-09-24)

Component sheet **S11 tablet blocks** `H7JAyy` (light, x 28088, y 8760, right of the S11 blocks) and its dark copy `w0FuJ` (y 12380; 6 unnamed refs renamed after the `Copy`; re-copied once after the review fix). No new variables. Masters: `EstimatePane / Units=3, State=Default` `OX3Bf`, `Units=3, State=CTA Disabled` `LGXN1`, `Units=1, State=Default` `bFTBN`, `State=Loading` `HpwaB`, `State=Error` `RWyOf` (sub-parts reused: `PriceBreakdown Summary Row` `QPzQW`, `Total Row` `sVRWq`, `Note Row` `pZ3Zt`, `TsButton` Primary Default / Disabled / Loading, Outline) · `CopySourceSheet / Layout=Modal` `bI28g` (560 dp) · specimens: wide stepper with the completion badge `o9OSh` and without `cXevl`; handoff notes `u4Rm8`.

Frames — each row led by a `Row Header` ref of `kcsFb` (number "07"); tablet frames are fixed viewports with no status / gesture bar:

| Row | Frames (light → dark) |
|---|---|
| Tablet-Portrait, header `tabHU` y 32900, frames y 33086, notes `a5QLkm` x 7920 | Single Unit `HjIRD` (x 0) · Multi Unit `h7RKy` (880) · Complaint Required `xStsm` (1760) · Copy Source Sheet `JV8Gr` (2640) · All Complete `ueG4e` (3520) · Loading `MR4n2` (4400) · Error `IHS5n` (5280) · Remove Unit Dialog `uKx5o` (6160) · Multi Unit dark `ULVIT` (7040) |
| Expanded, header `xFLRg` y 34500, frame y 34686, notes `huGQv` x 1104 | Multi Unit `X76Qfw` (1024 × 768) |
| Tablet-Landscape, header `HsNe8` y 35600, frames y 35786, notes `jIPyP` x 9520 | Single Unit `ctlnU` (0, 2-pane) · Multi Unit `afpck` (1360, 3-pane) · All Complete `nFYOk` (2720) · Loading `WDhuk` (4080) · Error `iNXIV` (5440) · Multi Unit dark `YrF7p` (6800) · Stress Text 1.3 `q2ueR` (8160) · **Long Content** `W5ReV` (x 10000, extra specimen: 41-character nickname in the rail row + pane line, a wrapped plate / status line) |

**07a correction (decision 22):** `Multi Unit` `QiJSV`, `Remove Unit Dialog` `r1uhZn` and the darks `j2s2Pp`, `sKc7x` now use `StickyEstimateBar / State=CTA Disabled` (new refs `hqBZi` `aXXWG` `t8a4c` `ltZ4l`) with "Pilih layanan untuk PCX 160"; the frames grew 1110 → 1138 dp and the two `Dialog Scrim` rectangles were re-measured (`zqU3x`, `minZN` = 1138).

Build decisions made while building (outside the 22 kickoff decisions; change at review if unwanted):
- **Forms are copies of the phone `Unit Form`** (`Copy` into the tablet frame; width 720 / 700 / 572, padding `[8,0,16,0]`), so every tile, header and complaint block is the phone instance and the state content cannot drift. The unit chips are copies of the phone chip refs in a plain row (gap 8, no scroll track, no fade); the rail is three rail-row refs with name / status overrides; the pane sits in a `Pane Column` (8 dp top padding so its top aligns with the form's first line).
- **Pill** = the `StickyEstimateBar` ref as an absolute child (`x` = the form column's left edge, `y` = frame height − 16 − bar height, `width` = form-column width). It floats over the form, so long content scrolls under the glass. The bar's `fill_container` Main Row reflows at 720 / 700 with no wide variant.
- **Only the Complaint Required frame is scrolled** (form moved up 100 dp inside a clipped `Form Viewport`, node `Scrolled Content`) so the error line stays above the pill; stepper and chips stay pinned above it. The other frames show the top of the form (the content under the pill is the scroll cue).
- **Wide stepper badge:** the `Completion Badge` of `BookingStepper / Size=Wide` is `enabled:false` in the master; an instance override `descendants: {"Completion Badge": {enabled: true}, "Badge Label": {content: "2/3"}}` puts it at the right end and the step lines shorten (no new master).
- **Preset chips in `ComplaintSection`** keep the hand-wrapped 3 / 2 / 2 rows at 720 / 572 (the master has fixed rows); it reads a little sparse on tablet but wraps correctly (listed as LOW).
- **Stress ×1.3** = a `Copy` of `afpck` with 64 text nodes scaled through `Get(..., {resolveInstances, resolveVariables})` + `Update` (including the hidden disabled reason rows).
- **Copy Source Sheet / Remove Unit Dialog** frames = the Multi / Copy state + a full-frame `Sheet Scrim` / `Dialog Scrim` rectangle (`fill: $scrim`, literal 800 × 1280) + the modal (`bI28g`, x 120 y 494) / the phone dialog copy (`TsDialog Keluarkan Motor`, x 244 y 493).

## Checks run (07b)

| Check | Result |
|---|---|
| Clipping (`ctx.problems`, disabled subtrees, `Decor`, `Chips Track`, `Scrolled Content`, the intentional clipped `Unit Form` inside `Form Viewport`), with and without `resolveInstances` | 0 rows over 17 tablet frames + both sheets + 4 corrected phone frames (770 nodes) |
| Raw-hex audit (fills / strokes / effects) | 0 |
| Naming (every node) | 0 unnamed; `placeholder` 0 |
| Contrast, resolved values, ancestor-composited, both themes (glass pill and skeletons skipped: measured in step 04; scrim frames audit the modal / dialog only) | 998 text + icon nodes, 0 failures, minimum 3.49 : 1 (the danger icon, ≥ 3 : 1 rule) |
| 48 dp targets (chips, tiles, buttons, retry, source rows, complaint) | 198 checked, 0 under 48 |
| Coverage vs matrix (07b) | 17 / 17 |
| Arithmetic (makespan on 2 bays) | Single Rp85.000 · 1 jam; Multi / Copy Source Sheet / Expanded Rp228.000 · 1 jam (pane lines 85 + 143 + "Belum dipilih"); Complaint Required Rp363.000 · 2 jam (specimen); All Complete Rp428.000 · 2 jam (85 + 143 + 200) |

## Checks run (07a)

| Check | Result |
|---|---|
| Clipping (`ctx.problems`, disabled subtrees, `Decor`, the intentional clipped tab track / keyboard scroll / 640 viewport exempt) | 0 rows over 23 frames + both sheets |
| Raw-hex audit (fills / strokes) | 0 |
| Naming (every node) | 0 unnamed; dark sheet refs renamed |
| `placeholder` cleared | ✔ all frames |
| Contrast, resolved values, 783 text + icon nodes over the 21 phone frames (text ≥ 4.5 : 1, icons ≥ 3 : 1, glass bar and skeletons skipped: glass measured in step 04, scrim frames audit the sheet / dialog only) | 0 failures |
| 48 dp targets (buttons, chips, rows, tiles, retry, snackbar action) | 0 under 48 |
| Coverage vs matrix (07a) | 22 / 22 + Long Content |
| Arithmetic (by hand, makespan on 2 bays) | Multi Unit Rp228.000 · 1 jam · Copied Rp313.000 · 2 jam · Copy Source Sheet Rp228.000 · 1 jam · All Complete Rp428.000 · 2 jam · Complaint Required / Keyboard Rp363.000 · 2 jam (specimen) · Single Rp85.000 · 1 jam |

## /better-interface report

**Scope:** S11 Detail Servis, 41 frames (39 in the matrix + 2 Long Content specimens) + 2 tablet component sheets, split in two groups. **Tablet group (reviewed in depth, 07b):** Tablet-Portrait `HjIRD` `h7RKy` `xStsm` `JV8Gr` `ueG4e` `MR4n2` `IHS5n` `uKx5o`, dark `ULVIT` · Expanded `X76Qfw` · Tablet-Landscape `ctlnU` `afpck` `nFYOk` `WDhuk` `iNXIV`, dark `YrF7p`, stress `q2ueR`, Long Content `W5ReV` · sheets `H7JAyy` / `w0FuJ`. **Phone group (07a frames, boundary):** the 23 frames were re-run through the automated checks (clipping, raw hex, naming, placeholder, contrast) after the bar correction and the four corrected frames (`QiJSV` `r1uhZn` `j2s2Pp` `sKc7x`) were viewed; a per-state visual walk of all 23 phone frames was **not** repeated in this pass (07a's own inspection stands). · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens · **Convention docs found:** 00-index.md (Pencil mapping of the skill triggers), prd/02, prd/06, steps 04 / 06 decisions

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | 198 interactive targets ≥ 48 dp; focus specimens (buttons, icon buttons, rail row, tiles, `CopyFromRow`); state never by color alone (rail glyph + text, pane reason icon + text, "Belum dipilih"); semantics + keyboard notes (`umUsf` `dhoHJ` `QzMpT`, icon-semantics note); scrim / modal / dialog focus notes; stress ×1.3 and Long Content; content below the fold has a peek cue | 3 findings (1 HIGH fixed) |
| Layout | Grouping (rail · form · pane, 24 dp gutters), shared edges, reading order (rail → form → pane), 720 / 700 / 572 columns, pill at the form-column width, scroll cue under the pill, growth (Long Content: rail row grows, pane line wraps, no clipping) | 2 LOW |
| Writing | Pane title / lines / reason, modal title + helper, error pane, status terms ("Lengkap" / "Belum lengkap" / "Sedang diisi" / "Belum dipilih"), sentence case, verb-first CTAs | Clear |
| Typography | Type roles reused from the scale (Title Medium / Body Md / Headline Small for the total), wrapping in the rail and pane at ×1.3, live numbers | 1 LOW (annotation, merged in finding 3) |
| Color | Contrast on 998 + 1,031 resolved text / icon nodes (tablet + phone, both themes, ancestor-composited): 0 fails, minimum 3.49 : 1 (danger icon, ≥ 3 : 1); raw hex 0; danger hue only on the connection error icon, never on an action | Clear |
| UI | Pane = card recipe (radius-lg, `border-default`, shadow-sm), modal = dialog recipe (radius-xl, shadow-md), glass pill unchanged, icon weights and states inherited from the components | Clear |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| HIGH (fixed) | Accessibility | `CopySourceRow` `ukrHl` inside `CopySourceSheet` `dgVBx` (phone `S11 … / Copy Source Sheet / Phone` `hxQ1H`, dark `sPAqK`) and `CopySourceSheet / Layout=Modal` `bI28g` (`… / Copy Source Sheet / Tablet-Portrait` `JV8Gr`) | Source rows are keyboard / switch-access targets (Enter copies at once) but had no designed focused state (only `CopyFromRow` had one) | Specimen `CopySourceRow (focused)` `Y51QH`: 2 dp `focus-ring` outside the border (radius-lg 16 + 4 dp wrapper = 20, the step 04 tile recipe), on `H7JAyy` / dark `w0FuJ`; modal note names it | A keyboard-reachable control with no visible focus indicator is HIGH on sight; the modal is the tablet's main keyboard path into "Salin dari" |
| MEDIUM (fixed) | Accessibility | `Note Rail` `dhoHJ`, `Note Pane` `umUsf` (blocks sheet; frame notes) | Nothing stated about focus order across three panes | "Focus order: rail, form, pane (Lanjut is the last stop; with one unit: form, pane)" | Keyboard / switch users need to know the pinned pane is reached after the form, in the same order it reads |
| LOW (fixed with the two rows above) | Accessibility · Typography | `ServiceOptionTile / Style=Checkbox` (`n9tmC` `C41FA`, used by every S11 frame), `Note Pane` `umUsf` | Step 04's focused tile specimen is the radio tile (`X1bPBC`); the pane's live numbers had no tabular-figure note (the bar note `S1DYCY` does) | Specimen `ServiceOptionTile Checkbox (focused)` `dCZKX`; note adds `FontFeature.tabularFigures()` for the unit values, total and duration | Same recipe applied to the variant S11 uses; a total that updates live must not shift its neighbours |
| LOW | Layout | Stepper (720, centered) over the panes in `X76Qfw` (x 152), `afpck` / `nFYOk` / `WDhuk` / `iNXIV` (x 280), `ctlnU` (x 280 vs form x 88) | Its left edge lines up with no pane edge | Left as decided (kickoff decision 20); alternative recorded: align the stepper to the form column | A stray alignment edge; deliberate, trade-off accepted for one grammar across all tablet sizes |
| LOW | Layout | `ComplaintSection` preset chips in `xStsm` (720) and the 572 forms | Hand-wrapped rows (3 / 2 / 2) leave the right half of the card empty on tablet | Left: the master has fixed rows; a tablet variant would add five masters for a cosmetic gain | Sparse but wraps correctly at every width |

**Verification (passed):** clipping over the 17 tablet frames + Long Content + both sheets, with and without `resolveInstances` (disabled subtrees, `Decor`, the intentional scroll clips exempt): 0 · phone group, same script: 0 except the intentional 360×640 viewport · raw hex 0 (tablet 770 nodes, phone 746) · every node named, `placeholder` 0 · coverage 17 / 17 (+ Long Content) · contrast, both themes, 0 fails, minimum 3.49 : 1 (icon) · 48 dp: 198 targets checked, 0 under · arithmetic totals equal the demo-content sheet · screenshots of all 17 tablet frames, both sheets, the pane / rail / modal at native size, Tablet-L ×1.3 and Long Content. **Not verified:** Flutter rendering (glass blur, scroll under the pill, pinned rail / pane, ripple), the glass pill's text contrast over the 720 / 700 dp backdrops (measured in step 04 at 328 dp only), focus traversal and screen-reader output, RTL, 200 % zoom beyond the ×1.3 Tablet-L frame, Exo 2 tabular figures, html2figma behavior (first S11 import is step 12).
**Verdict:** Approve
**Fixes applied:** HIGH `CopySourceRow` focus specimen (`Y51QH`); MEDIUM focus-order note (`dhoHJ`, `umUsf`); the LOW checkbox-tile specimen and tabular-figures note were applied together with them (same sheet / same notes; reversible) · **LOW left for user:** stepper alignment (decision 20), tablet preset-chip wrapping

## Review rounds

#### Round 1 — 2026-09-24
- **Frames shown:** single vs multi unit (disabled pill / pane), complaint required, copy source sheet (phone sheet + tablet modal), complete, loading, error, Tablet-P, Expanded rail, Tablet-L 3-pane and 2-pane, text ×1.3 stress, Long Content specimen, the tablet blocks sheet, the `/better-interface` report.
- **User feedback:** "approve"
- **Changes made:** none.
- **Outcome:** approved

## Session log

| Time | Action | Result / node ids |
|---|---|---|
| 2026-09-24 | 07a kickoff | Read PRD 03 / 04 / 06, steps 04 and 06; interview in three rounds (11 questions, all recommended options accepted); matrix rebuilt to 38 frames (07a 22 / 07b 16); this file rewritten; `00-index.md` tracker 🟡, decision log row, inventory additions |
| 2026-09-24 | S11 blocks sheet `nSN5s` | Amended chips: Active → Incomplete glyph, new Active Complete `t9Qgh` / Active Error `m5jdSG`, rails `lBXKN` / `Q0U73`, Error chips to 1 dp; `TsAppBar / Type=Step` `mYhlk`, `UnitHeader` ×2, `CopyFromRow` ×2 + `CopyNote`, `CopySourceRow` / `CopySourceSheet`, `ComplaintSection` ×5, `System / Keyboard`, notes. Found: `remove_circle`, `remove_circle_outline`, `delete_outline`, `brake_alert` are not in Material Symbols Rounded (use `do_not_disturb_on`, `album`, `bolt`); three preset chips per row overflow 328 dp; `sand-200` (primitive) is not theme-aware, keyboard modifier keys use `surface-hover` |
| 2026-09-24 | Tablet block moved | 27 root nodes (Flows – Tablet anchor, S05 / S10 tablet rows) moved +4,000 dp to free y 22,900–26,500 for the S11 phone rows |
| 2026-09-24 | Phone frames | Builder script (pasted per call; globals do not persist) made frames 1–8; overlays (source sheet, remove dialog, snackbar), Keyboard (fixed 800), stress copies (640 viewport; text ×1.3 = 49 nodes), 10 dark copies, dark sheet copy (18 refs renamed), notes `oJ2W5`, row headers, fold marker, Long Content specimen |
| 2026-09-24 | Checks | Clipping 0, raw hex 0, unnamed 0, contrast 783 nodes 0 fails, 48 dp 0 low, coverage 22 / 22 (+ Long Content). 07a stops here: no `/better-interface`, no gate (decision 1). 07b next: tablet-P, expanded 1024, tablet-L, `EstimatePane`, dark tablets, `/better-interface`, review gate, export |
| 2026-09-24 | 07b kickoff | Read this file, `00-index.md`, PRD 04 S11 / 06, steps 04 and 06; screenshots of the phone Multi Unit / All Complete and the S10 tablet frames; interview in three rounds (11 questions, every recommended option accepted → decisions 13 – 22). Found: the S16 `PriceBreakdown / Variant=Pane` `ajTlg` is not reusable as the S11 pane; wide stepper `Completion Badge` at (0,0); **07a defect** — `QiJSV` / `r1uhZn` (+ darks) use the enabled bar with PCX ○. Matrix 16 → 17 (stress) |
| 2026-09-24 | 07b build | 07a fix (4 bars swapped, frames 1138, scrims re-measured); tablet blocks sheet `H7JAyy` + dark `w0FuJ` (`EstimatePane` ×5, modal source sheet, wide-stepper badge specimen, notes); 17 tablet frames (Tablet-P 8 + dark, Expanded, Tablet-L 5 + dark + stress), row headers, notes; checks all clean (see Checks run 07b). Found: same-call screenshots blank again; `execute` globals do not persist (used literal ids); Complaint Required needed a scrolled form so the error is not hidden under the pill |
| 2026-09-24 | 07b `/better-interface` | Loaded the six `better-*` skills; reviewed the tablet group in depth (screenshots at native size of pane, rail, modal, ×1.3, Long Content specimen `W5ReV` added) and re-ran the automated checks over the phone group. Findings: HIGH `CopySourceRow` had no focused state → specimen `Y51QH`; MEDIUM focus order across panes → notes; LOW checkbox-tile specimen `dCZKX` + tabular figures note; LOW stepper edge (decision 20) and preset-chip wrapping left. Dark sheet re-copied (`w0FuJ`, 6 refs renamed). Verdict Approve; status set to 🔵, review gate next |
| 2026-09-24 | Review gate + close | User: "approve". Exported 27 PNG (key frames + both S11 sheets) + `INDEX.md` to `design/pencil/exports/step07/`; session log 09 written; tracker ✅; canvas layout + 07b Pencil facts in `00-index.md`; S11 PRD corrections queued in `19-full-app-audit.md` |
