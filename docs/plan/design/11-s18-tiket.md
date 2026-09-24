# Step 11 — S18 Booking Berhasil (Tiket Servis)

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-24 |
| **Priority** | P0 |
| **Owns screens** | S18 |
| **Owns components** | `SuccessHeader`, `QrCode` (real matrix), `TicketActions` (Bar / Pane), P2 `ShareTicketRow`; amends step 04: `TicketCard` (Code Row + copy button, `QrCode` instead of the icon, Loading masters), `TicketUnitRow` (Slot Line), `TicketCard Units Panel` (Loading). `TicketUnitRow` itself lives in step 04 |
| **PRD refs** | [04 S18 + P2 extras](../../../prd/04-screens.md), [03 identifiers & status](../../../prd/03-user-flows.md), [06 S18 row + stress screens](../../../prd/06-responsive-layout.md) |
| **Pen location** | Components sheet "Ticket & success" (x 33528, light y 8760, dark copy under it); Flows rows `S18` (phone rows after the S17 phone rows, tablet rows below the S17 tablet rows) |
| **Depends on** | Steps 02–04, 10 |
| **Claude session** | `docs/claude-session/13-design-step11-s18-tiket.md` (written after approval) |

## Goal

Design the flow's terminal success screen: confirmation, booking code + QR, perforated `TicketCard` with **per-unit sub-tickets** (each with unit code and status badge), workshop + schedule recap, and next actions. It is the last frame of the M1 prototype.

## Inputs

- `TicketCard` (phone + landscape variants, with `TicketUnitRow` and a QR slot, step 04), `TicketCard Units Panel` (Tablet-L status list), `UnitStatusBadge` ("Terjadwal"), `TsButton` (primary + secondary), `TsIconButton`, `TsSnackbar`, `Skeleton`, `ConfirmBar` (flat sticky recipe, step 10).
- Identifiers: `TS-260929-0417`, units `-A`, `-B`, `-C`. Demo booking from step 01.
- Business note: total is "bayar di bengkel" (paid later); every price is an estimate → "Total estimasi".

> **Hand-off from step 10 (2026-09-24, kickoff):** S16 "Konfirmasi booking" → loading "Mengonfirmasi…" → S18. Totals must match S16: subtotal Rp428.000, voucher −Rp42.800, total **Rp385.200** "bayar di bengkel" (10 % voucher applied in the canonical run); workshop + schedule recap strings as in S16 ("Sel, 29 Sep · 09.00"). In split mode S18's per-unit rows carry each unit's own slot.

## Kickoff decisions (answered 2026-09-24, interview with the user)

Three `AskUserQuestion` rounds (12 questions). Every recommended option was accepted; in the extras question (multi-select) the user picked only the recommended snackbar frame.

| # | Topic | Decision |
|---|---|---|
| 1 | Success mark | Circular tinted check badge (`success-soft` + check icon, weight 700) + "Booking berhasil!" + subline "Tunjukkan tiket ini di bengkel saat datang." No `Generate` (the 5 illustration slots went to empty / error). Scale-in 300 ms annotation; static under reduce-motion |
| 2 | QR | **Real scannable QR** of the booking code (Version 1, 21 × 21 modules, computed offline), drawn by a loop of rectangles (row run-lengths merged) in a `QrCode` master. Tile + modules bound to **primitives** (`sand-50` / `sand-950`, deliberately not theme-aware) → dark-on-light in both themes. Module 6 dp = 126 dp code in the 176 dp tile (quiet zone ≈ 4 modules). Replaces the icon inside the `TicketCard` masters (Phone + Landscape), so the step 04 sheets update by themselves. Flutter = `qr_flutter` (state quiet zone + min size) |
| 3 | Code placement | The code appears **once, on the ticket**, with a 48 dp "Salin" `TsIconButton` (semantics "Salin kode booking"; snackbar "Kode booking disalin"). `SuccessHeader` carries no code. Amends `TicketCard` (Code Block → Code Row + copy button) |
| 4 | CTAs (phone, Tablet-P) | **Flat sticky footer** (0 glass; `ConfirmBar` recipe): primary "Lacak status" (→ S20) + secondary "Kembali ke beranda" (→ S05), stacked, above the gesture inset. Sentence case per step 03 (PRD: "Kembali ke Beranda") |
| 5 | Top bar | **None** on every breakpoint. System back = Beranda (draft cleared; no return into the booking flow) — annotation |
| 6 | Split mode | `TicketUnitRow` gains an `enabled:false` **Slot Line** ("Sel, 29 Sep · 09.00"); Schedule row = "Sel, 29 Sep 2026 · jam berbeda tiap motor". Shared mode: the slot appears only in the recap |
| 7 | Tablet-L | Left = `SuccessHeader` + `TicketCard / Landscape` 480; right = `TicketCard Units Panel` 400 (read-only, no chevrons; S20 owns navigation) + CTAs (pane variant) below it. Group 480 + 24 + 400 = 904, centered, fits 800 dp. Same composition at Expanded 1024 → **no Expanded frame** (annotation) |
| 8 | P2 extras | `ShareTicketRow` (two compact outline buttons "Bagikan tiket" / "Tambah ke kalender" with icons, 48 dp) under the ticket in **one phone-light variant frame**; P0 frames stay without it. Check label fit at 328 dp and ×1.3, stack if it wraps |
| 9 | Loading | Real `SuccessHeader` + skeleton ticket ("Membuat tiket…"); "Lacak status" disabled, "Kembali ke beranda" active |
| 10 | Unit rows | As built: name + "Unit -A · services", summary max **2 lines** then ellipsis; no plate (PRD does not list it) |
| 11 | Stress | 360×640 = **5-unit specimen** (PRD max): adds `-D` Supra X 125 and `-E` Ninja 250 (see Demo data). ×1.3 = canonical 3 units + the 54-character workshop name from S13 |
| 12 | Extras | + **Copied-code snackbar frame** (phone light). Skipped: voucher line on the ticket, Expanded frame, Tablet-L single / split |

**Found while planning** (defaults applied without a question; change at review if unwanted):

- Copy corrected from the earlier draft: weekday **"Sel, 29 Sep 2026 · 09.00"** (canonical; PRD says "Sen"), total row "Total estimasi · Bayar di bengkel · Rp385.200" (same words as S16).
- Tablet-P = `TicketCard / Phone` stretched to 560 (ref `width` override) and a 560 dp inner-width bar; no new master.
- Tablet-L Loading = skeleton ticket 480 + skeleton panel 400, "Lacak status" disabled.
- ECC level Q or M, decided when the matrix is generated (both fit a 14-character alphanumeric payload in Version 1).

## Demo data

Canonical set from `00-index.md`, Bengkel Jaya Motor, Sel 29 Sep 2026 · 09.00.

| Unit | Row text | Badge |
|---|---|---|
| Vario 125 (-A) | "Unit -A · Servis Berkala" | Terjadwal |
| Beat 110 (-B) | "Unit -B · Servis Berkala + Oli" | Terjadwal |
| PCX 160 (-C) | "Unit -C · Servis Berkala + Oli + Kampas rem" | Terjadwal |

Recap: "Bengkel Jaya Motor", "Sel, 29 Sep 2026 · 09.00", "Total estimasi · Bayar di bengkel · **Rp385.200**" (subtotal Rp428.000 − voucher Rp42.800; the ticket shows the total only).

| Variant | Data |
|---|---|
| Single unit | Vario 125 only, "Unit -A · Servis Berkala", total **Rp85.000** (no voucher applies to one motor) |
| Split schedule | Slot Line per row: Vario 09.00, Beat 10.00, PCX 13.00 (Sel, 29 Sep); Schedule row "Sel, 29 Sep 2026 · jam berbeda tiap motor"; total Rp385.200 |
| 5-unit specimen (stress 360×640, annotated "Demo: 5 motor") | `TS-261002-0418` · Jum, 2 Okt 2026 · 08.00 (a 5-motor shared slot needs an empty hour; Sel 29 Sep 09.00 has 4 seats left) · adds `-D` Supra X 125 "Servis Berkala" Rp85.000 and `-E` Ninja 250 "Servis Berkala + Kampas rem" Rp130.000 · subtotal Rp643.000 · DISKON10 −Rp64.300 · total **Rp578.700** |
| Text ×1.3 | Canonical booking, workshop "Bengkel Resmi Sumber Rejeki Motor & Spesialis Matic Ngaglik" (S13 long-name stress) |

## Scope

### Frame matrix (18 frames)

Naming: `S18 Booking Berhasil / <State> / <Breakpoint>` (`… · Dark`). Phone frames are full-scroll captures (Loading fixed 800); tablets are fixed viewports (no status / gesture bar, no `NavBar` / `NavRail`).

| State | Phone | Ph·D | Tab-P | Tab-P·D | Tab-L | Tab-L·D |
|---|---|---|---|---|---|---|
| Loading ("Membuat tiket…") | ✔ | ✔ | ✔ | | ✔ | |
| Populated — 3 units, shared slot | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ |
| Populated — single unit | ✔ | ✔ | | | | |
| Populated — split schedule (per-unit slots) | ✔ | ✔ | | | | |
| P2 variant (share + calendar) | ✔ | | | | | |
| Copied-code snackbar | ✔ | | | | | |
| Stress 360×640 (5 units, dense ticket) | ✔ | | | | | |
| Stress text ×1.3 (3 units, long workshop) | ✔ | | | | | |

Count: 12 phone + 3 Tablet-P + 3 Tablet-L = **18**.

### Layout targets (PRD 06 + kickoff)

- **Phone 360** (margins 16): status bar · `SuccessHeader` · `TicketCard / Phone` (328) · [P2 `ShareTicketRow`] · flat `TicketActions / Bar` above the gesture inset (content scrolls; no app bar).
- **Tablet-P 800×1280:** ticket centered max **560**; bar inner width 560, pinned to the viewport bottom.
- **Tablet-L 1280×800:** group 480 + 24 + 400 (904), centered; left column `SuccessHeader` + ticket, right column status panel + `TicketActions / Pane`.
- Targets ≥ 48 dp (Salin, CTAs, share / calendar buttons); ellipsis + max 2 lines on unit summaries, workshop name wraps; no fixed-height box around text; ×1.3 must not clip the recap or the total.

### Components built here

New sheet **"Ticket & success"** (x 33528, light y 8760; dark copy under it, or lower if the sheet is taller than ~3,400 dp).

| Component | Notes |
|---|---|
| `SuccessHeader` | Check badge + "Booking berhasil!" + subline; centered; fills its column |
| `QrCode` | Real matrix (rectangles by loop, run-length merged), light tile + dark modules from **primitives** (always dark-on-light, also in dark mode), ≥ 126 dp code with quiet zone. One master per code (canonical `TS-260929-0417`, specimen `TS-261002-0418`); swapped into `TicketCard` |
| `TicketActions` | `Layout=Bar` (flat sticky, top border) / `Layout=Pane` (no border, Tablet-L); states Default / Tracking Disabled (loading) |
| `ShareTicketRow` (P2) | "Bagikan tiket" + "Tambah ke kalender", compact outline buttons with icons |
| `TicketCard` amendments (step 04) | Code Row (code + 48 dp copy `TsIconButton`); `QrCode` replaces the icon; `TicketCard / Layout=Phone \| Landscape, State=Loading` skeleton masters |
| `TicketUnitRow` amendment (step 04) | `enabled:false` Slot Line (split mode) |
| `TicketCard Units Panel / State=Loading` | Skeleton panel for Tablet-L |

### Content & copy

- "Booking berhasil!", "Tunjukkan tiket ini di bengkel saat datang.", "Kode booking", "TS-260929-0417", per-unit rows (Vario 125 · -A, Beat 110 · -B, PCX 160 · -C), "Bengkel Jaya Motor", "Sel, 29 Sep 2026 · 09.00", "Total estimasi · Bayar di bengkel · Rp385.200", CTAs "Lacak status" (→ S20) and "Kembali ke beranda" (→ S05), panel "Status tiap motor" / "Status berubah setelah motor check-in di bengkel.", loading caption "Membuat tiket…", snackbar "Kode booking disalin", P2 "Bagikan tiket" / "Tambah ke kalender".

### Annotations to place

- Success motion: check scale-in 300 ms; reduce-motion = static.
- QR encodes the booking code; stays dark-on-light in dark mode for scanability; `qr_flutter` quiet zone + minimum size.
- CTA destinations (S20 / S05); system back = Beranda (no return into the booking flow); the draft is cleared on success.
- Semantics: ticket announced as a single group ("Tiket booking TS-260929-0417, 3 motor, Bengkel Jaya Motor, Selasa 29 September pukul 09.00"); QR text alternative = the code; Salin = "Salin kode booking"; success announced politely once.
- Split rule (Slot Line + Schedule row), the 5-unit specimen, Expanded = same layout as Tablet-L, P2 share sheet + calendar intent.

## Built (node ids, `design/pencil/TumbasServis.pen`)

**Sheet** "Ticket & success": light `N2rLS` (x 33528, y 8760, 1200 × 2,631), dark copy `M9j5Hs` (y 12380). Masters: `QrCode / Code=TS-260929-0417` `U2e8f2` (114 rectangles) and `Code=TS-261002-0418` `a8pfm` (127) · `SuccessHeader` `R9FCY` · `TicketActions` Bar Default `oghSX` / Bar Tracking Disabled `Jt3r4` / Pane Default `Shfq1` / Pane Tracking Disabled `bHYVP` · `ShareTicketRow` `pxhpQ` · `TicketCard / Layout=Phone, State=Loading` `aXwmG` · `Layout=Landscape, State=Loading` `WOBWO` · `TicketCard Units Panel / State=Loading` `Hrv5i` · a split-mode `TicketCard` specimen `NGUKn` · focus specimens `yRC3G`.

**Amended step 04 masters:** `TicketCard / Layout=Phone` `FgxE2` and `Layout=Landscape` `kHGZP` (`Code Row` = code + `Copy Button`, `QR Code` = `QrCode` instance, Workshop / Schedule rows and their texts now `fill_container` so a long workshop name wraps), `TicketUnitRow` `n7aSUT` (`enabled:false` `Slot Line`).

| Row | Header | Frames |
|---|---|---|
| Phone light (y 45186) | `RecpV` (y 45000) | Loading `p8itRV` · Populated `f84RVz` · Single Unit `FlLEZ` · Split Schedule `PyZ2m` · P2 Share + Calendar `JS2XZ` · Copied Code Snackbar `t5z5Mm` · Stress 360×640 `uuF33` · Stress Text ×1.3 `EkS65` · notes `WaJs1` (5 notes, x 3520) |
| Phone dark (y 47186) | `X47ud` (y 47000) | Loading `cUJBu` · Populated `l6fgxs` · Single Unit `uei3l` · Split Schedule `N5uav` |
| Tablet-Portrait (y 80186) | `kkO2t` (y 80000) | Loading `RsuLb` · Populated `MBlqK` · Populated Dark `I54zaS` · notes `a82BUy` (x 2640) |
| Tablet-Landscape (y 83086) | `onjoO` (y 82900) | Loading `LVt8b` · Populated `nlNWO` · Populated Dark `kDvWq` · notes `jBlvc` (x 4080) |

The Flows – Tablet block moved down 4,000 dp (anchor y 50000). Build notes: Loading is a full-scroll capture (not a fixed 800: the skeleton ticket needs the height); Stress 360×640 = clipped `Scroll Body` with the footer pinned; Tablet-P bar = full-width `surface-card` strip with the Pane variant at 560 inside; Tablet-P ticket = `TicketCard / Phone` at 560 with the two `Tear Line` refs overridden to 560 and the right notch to x 548; Tablet-L = a `Content Group` (columns top-aligned, ticket top = status panel top via a 196 dp top padding on the right column).

## Checklist

### Build
- [x] Kickoff questions answered (2026-09-24, 12 decisions above).
- [x] QR matrices generated with `segno` 1.6.6 (Version 1, ECC Q, masks 3 / 0) in a scratchpad venv, drawn by loop with row run-lengths merged, 4-module quiet zone; **decoded back from 7 exported PNGs** (light, dark, Tablet-P, Tablet-L light + dark, ×1.3, 5-unit specimen) with OpenCV `QRCodeDetector`.
- [x] Masters: `QrCode` ×2, `SuccessHeader`, `TicketActions` ×4, `ShareTicketRow`, `TicketCard` / `TicketUnitRow` amendments, Loading masters ×3, focus specimens; sheet + dark copy.
- [x] All 18 matrix frames built; dark copies built with `theme: {mode: "dark"}`.
- [x] Per-unit rows use `UnitStatusBadge` instances (icon + label); status not color-only.
- [x] Stress frames built and clean (5-unit 360×640 scroll viewport, ×1.3 with the 54-character workshop name wrapping to 3 lines).
- [x] Demo content matches the step-01 sheet (code, total, unit list) and S16's arithmetic (428.000 − 42.800 = 385.200; specimen 643.000 − 64.300 = 578.700).

### Quality (automated, run in `execute`)
- [x] Clipping check on every step frame and both sheets → 0 real `problems` (exempt: the clipped `Scroll Body` of Stress 360×640, disabled subtrees, `Decor …`, `Modules …`, `Skeleton …`); step 04 ticket sheets re-checked after the master amendments: only the pre-existing carousel peek.
- [x] Raw-hex audit → 0 (QR modules use the `sand-0` / `sand-900` primitives).
- [x] Every node named (0 unnamed; the 11 unnamed refs of each dark-sheet copy renamed `<master> (instance)`, twice because the sheet was re-copied after the review fixes); instances only; `placeholder` cleared on 18 frames + 2 sheets.
- [x] Coverage script: 18 expected names, 0 missing, 0 extra.
- [x] Contrast audit on resolved values (both themes): 513 text + icon nodes, 0 fails, min 4.56 : 1.

### /better-interface
- [x] Run `/better-interface` with scope = all S18 frames (names + node ids).
- [x] Report recorded below; MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [x] Status set to 🔵; user shown: populated phone (light/dark), tablet-P, tablet-L, single/split variants, loading, P2, snackbar, stress frames.
- [x] Review rounds logged; user approval recorded (2026-09-24, "approve").

### Close (only after approval)
- [x] PNG export to `design/pencil/exports/step11/` (18 frames + 2 sheets = 20 PNG + `INDEX.md`, verified with `ls`).
- [x] Claude session file written (`docs/claude-session/13-design-step11-s18-tiket.md`).
- [x] Tracker set to ✅.

## /better-interface report

**Scope:** the 18 S18 frames (names and node ids in *Built*) and the "Ticket & success" sheets `N2rLS` / `M9j5Hs`, plus the amended step 04 masters they use · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens · **Convention docs found:** `00-index.md`, `prd/02`, `prd/06`, the step 03 / 04 / 10 files (no CONTRIBUTING, AGENTS or design-system doc; the design has no source files, so locations are frame name + node id). The review itself was read-only; the fixes below were a separate, logged action.

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | Semantics notes (ticket group, QR alternative, Salin, live regions, focus order, reduced motion) · focused states for the new controls · 18 direct button instances ≥ 48 dp (every nested `TsButton` / `TsIconButton` master is 48 dp high) · state never color-only (badge = icon + label, success = icon + words, disabled CTA = reason row) · truncation (no clamp drawn; full service list on S21) | 1 MEDIUM (fixed), 0 open |
| Layout | Phone 360, 360×640 scroll viewport, Tablet-P 800×1280, Tablet-L 1280×800 · sticky footer above the gesture inset · margins 16 · grouping by space · shared edges · growth at ×1.3 (long workshop name wraps to 3 lines, unit summaries wrap, no clipping) | 1 MEDIUM (fixed) |
| Writing | Every label against its action (verb-first CTAs, "Salin", "Bagikan tiket", "Tambah ke kalender") · terminology vs S16 / S18 ("Kode booking", "Total estimasi", "Bayar di bengkel") · loading and disabled reasons · sentence case | 1 LOW |
| Typography | Type-role variables only (no raw sizes) · weights ≥ 400 · booking code Headline Small · wrapping at ×1.3 · truncation rules | 1 LOW |
| Color | 513 text + icon nodes measured on resolved values in both themes (min 4.56 : 1) · QR dark-on-light in both themes (`#1A1716` on `#FFFFFF`) · success hue only for success (badge, icon) · no borrowed tokens | Clear |
| UI | Concentric radii (badge pill, Salin 40 in 48, QR tile 12) · skeleton static recipe · motion note vs the prescribed values · icon weights · one filled action per view (primary "Lacak status", secondary tonal) | 1 MEDIUM (fixed), 1 LOW |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| MEDIUM | Accessibility | Sheet `N2rLS`; notes `SLnGC`; new controls Salin `qeN3H` / `pW7Lh`, CTAs `ZeLN7`, share row `pxhpQ` | No focused state shown for the controls this step introduces (their `Focus Ring` layers are `enabled:false`), and no focus order or initial focus stated | "Focus specimens" section `yRC3G`: Salin with its own ring `BU0J7`, primary / secondary CTA and the compact share button in 2 dp `focus-ring` wrappers (radius = inner + 4); note `SLnGC` gains the order "title → Salin → (P2 share, calendar) → Lacak status → Kembali ke beranda", the skipped read-only rows and the S21 pointer | A keyboard or switch-access user needs a visible indicator and a predictable order on the screen every booking ends on |
| MEDIUM | Layout | `S18 … / Tablet-Landscape` `LVt8b`, `nlNWO`, `kDvWq` (columns `d6tUkE` / `V4w0tS`, `p3jikY` / `P7w3Q`) | Two columns centered independently: the ticket top sat at y 275 and the status panel top at y 188 (populated), a 87 dp stray edge | `Content Group` (`sWD6g`, `dsAhx`) with `alignItems: start` and a 196 dp top padding on the right column: ticket top = panel top = y 196 in the group; group still centered (y 79 / 83) | Shared alignment edges: two unrelated tops read as noise beside each other |
| MEDIUM | UI | Note "Success and motion" `ViJuJ` | Badge "scale 0.6 → 1, ease-out" with the title fading | Badge scale 0.25 → 1 + opacity 0 → 1 + blur 4 → 0 px (spring, 300 ms, bounce 0), title / subline / ticket staggered ≈ 100 ms, static under `disableAnimations` | The staged success entrance is infrequent, so it takes the prescribed values; the state stays readable without the animation |
| LOW | Writing | Loading: caption "Membuat tiket…" (`PnCyD`, `fIcaD`) and reason "Tiket sedang dibuat" (`iQF2u`, `qUBFy`) | Two phrasings of one state in one frame | Keep the caption; make the reason state the consequence, e.g. "Aktif setelah tiket dibuat" | One term per state; the reason should say what unlocks. **Left for you** |
| LOW | Typography | `S18 … / Stress Text ×1.3 / Phone` `EkS65`, subline `h36qP` | "Tunjukkan tiket ini di bengkel saat / datang." leaves a one-word last line | Shorten to "Tunjukkan tiket ini di bengkel." or accept (Flutter has no `text-wrap: pretty`) | Orphaned last word at the largest text size. **Left for you** |
| LOW | UI | `TicketCard` masters `FgxE2` / `kHGZP`, `Code Row` `c4wNKI` / `dBzHr` | The 48 dp Salin button shares the centered row, so the code text sits about 26 dp left of the ticket axis and the QR | Reserve 52 dp on the leading side to centre the text — rejected here because at ×1.3 the row (code 210 + 52 + 48) exceeds the 288 dp inner width; keep, or move Salin below the code | Optical centring vs ×1.3 growth trade-off. **Left for you** |

**Verification:** *Passed* — coverage script (18 expected names, 0 missing / extra); clipping on 18 frames + 2 sheets (0 real; the step 04 ticket sheets only show their pre-existing carousel peek, ×1.3 stress sheet 0); raw hex 0; unnamed 0; placeholders cleared (20); contrast 513 text + icon nodes, 0 fails, min 4.56 : 1 (skipped: system bars, skeletons, disabled chains; the snackbar pair was measured in step 03); 18 direct `TsButton` / `TsIconButton` instances ≥ 48 dp; arithmetic (428.000 − 42.800 = 385.200; single 85.000; specimen 643.000 − 64.300 = 578.700); **QR decode** — `TS-260929-0417` read from the exported PNGs of phone light, phone dark, Tablet-P, Tablet-L light and dark and the ×1.3 frame, `TS-261002-0418` from the 5-unit ticket (OpenCV `QRCodeDetector`, 7 of 7); screenshots of the sheet sections, every phone state, both tablets, dark frames, the 5-unit and single-unit tickets, the focus specimens. **Not verified** — 320 px width and 200 % zoom (no 320 frame; ×1.3 and 360×640 are clean), RTL, a device scan of the QR through `qr_flutter`, screen-reader and keyboard walks (notes only), motion timing, the 2-line clamp (Flutter), html2figma output of the ~240 QR rectangles (step 12 test import), text ×1.3 on the tablets.
**Verdict:** Approve
**Fixes applied:** 3 MEDIUM (focus specimens + focus order note; Tablet-L column alignment; motion note values) · **LOW left for user:** reason wording, ×1.3 orphan, Salin optical offset.

## Review rounds

#### Round 1 — 2026-09-24
- **Frames shown:** populated phone (light / dark), Tablet-P, Tablet-L, single / split, loading, P2, snackbar, both stress frames, the sheet.
- **User feedback:** "approve"
- **Changes made:** none.
- **Outcome:** approved

## Session log

| Time | Action | Result / node ids |
|---|---|---|
| — | Kickoff interview (3 rounds, 12 decisions) | Recorded above; plan approved |
| — | Docs first | Step file, `00-index.md` (decision log, demo content, inventory, tracker), `19-full-app-audit.md` S18 corrections |
| — | QR matrices | `segno` in a scratchpad venv; both matrices decode (`qr.json`); 114 / 127 run-length rectangles |
| — | Sheet + masters | `N2rLS`; `QrCode` `U2e8f2` / `a8pfm`; `TicketCard` amendments; Loading masters `aXwmG` / `WOBWO` / `Hrv5i`; `SuccessHeader`, `TicketActions` ×4, `ShareTicketRow` |
| — | Phone frames | 7 light frames + ×1.3 copy (text fix: workshop row wraps); dark copies ×4; Loading changed from a fixed 800 to a full-scroll capture |
| — | Tablet frames | Tablet-P ×3, Tablet-L ×3; headers `RecpV` / `X47ud` / `kkO2t` / `onjoO`; notes `WaJs1` / `a82BUy` / `jBlvc` |
| — | Self-check | Coverage, clipping, hex, names, contrast, targets; skeleton line overflow fixed (`Geek7`, `IU5EM` → 150) |
| — | `/better-interface` | 3 MEDIUM fixed (focus specimens, Tablet-L alignment, motion note), 3 LOW listed; dark sheet re-copied `M9j5Hs`, dark Tablet-L re-copied `kDvWq` |
| — | QR proof | 7 PNG exports decoded to the expected codes |
| — | Review gate + close | User approved ("approve"); 20 PNG + `INDEX.md` exported to `design/pencil/exports/step11/`; session file `13-design-step11-s18-tiket.md` written; tracker ✅ |
