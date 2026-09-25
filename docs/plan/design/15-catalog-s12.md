# Step 15 — S12 Katalog Suku Cadang & Oli

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-25 |
| **Priority** | P1 |
| **Owns screens** | S12 |
| **Owns components** | (screen-local): `PartDetailSheet` (Sheet / Modal × Select Add / Select Selected / Select Incompatible / Browse), `CompatRow`, `SpecRow`, `SelectedPartsBar`, `CategoryChipRow`, `CompatToggleRow`, `PartOptionTile` Loading masters (amends step 04) |
| **PRD refs** | [04 S12](../../../prd/04-screens.md), [03 parts rules ("Salin dari" compatibility)](../../../prd/03-user-flows.md), [05 parts](../../../prd/05-data-model-mock.md), [06 S12 row](../../../prd/06-responsive-layout.md) |
| **Pen location** | Components sheet "Catalog blocks" (x 37608, light y 8760, dark copy y 12380 or below); Flows rows `S12` (phone rows after the S09 phone rows, tablet rows below the S09 tablet rows) — exact ids in *Frame ids* at close |
| **Depends on** | Steps 02–04 (`PartOptionTile`, `TsChip`, `TsCheckbox`), 05 (`QuickLinkTile` entry), 07 (S11 shortlist, `System / Keyboard`), 08 (`SearchBar`), 09 (`TsSwitch`), 14 (`BrandHeader`, modal pattern) |
| **Claude session** | `docs/claude-session/17-design-step15-catalog.md` (written after approval) |

## Goal

Design the full parts/oil browser: category chips, search, part tiles (list on phone, grid on tablets), compatibility handling and a detail sheet. It serves two modes on one page — **select mode** (from S11 "Lihat semua", staged selection that commits to the active unit) and **browse mode** (from S05's "Katalog suku cadang" quick link, no unit context, no cart).

## Inputs

- `PartOptionTile` Compact / Grid × Default / Selected / Incompatible (`G7cFN` `m6Ns8` `vgdJK` / `ZUZHh` `r3cOJe` `Aorqa`), `TsChip`, `TsCheckbox`, `TsSwitch`, `SearchBar` (`a9IPSs` …), `SheetHeader`, `UnitHeader / Remove=No` `CLy2n`, `BrandHeader` `Vqbe4`, `EmptyState / Type=Filter` `H7Y9p`, `Illustration / Empty Search` `Myjen`, `TsAppBar / Type=Close` `rHS0h` / `Type=Back` `R7zOVC`, `TsDialog / Type=Confirm Save` `tMRhF`, `CopySourceSheet / Layout=Modal` `bI28g` + `MotorModelPicker / Layout=Modal` `T5Crx` (modal pattern and shadow), `System / Keyboard` `Eov7k`, `Skeleton`, `TsButton`.
- Rules: parts are filtered by the unit's `MotorModel.category` and `cc` (PRD 03); incompatible parts are explained, never silently hidden when the user asks to see them; "Salin dari" drops incompatible parts and reports them (S11).

## Kickoff decisions (answered 2026-09-25, interview with the user)

Two `AskUserQuestion` rounds (8 questions). Every recommended option was accepted; the extras question was answered "pick recommended" (browse-mode detail sheet, dirty-close dialog, search keyboard-open; the text ×1.3 + Expanded 1024 extra was not selected).

| # | Topic | Decision |
|---|---|---|
| 1 | Presentation | **Full-screen page at every size**, pushed over S11 (`/booking/configure/parts`; no `NavBar` / `NavRail`, booking-flow chrome rule of step 06). Select-mode app bar = `Type=Close` + "Suku cadang & oli"; browse mode = `Type=Back`. Phone 1-col list, Tab-P 2-col grid (centered 720), Tab-L 4-col grid (`PartOptionTile / Layout=Grid`). Detail = bottom sheet (phone) / centered modal 560 (tablet) |
| 2 | Incompatible parts (select) | Row "Hanya yang cocok untuk Beat 110" with `TsSwitch`, default **ON** (compatible only). OFF → incompatible tiles appear disabled with a reason ("Untuk matic 125–160 cc"; icon + text, never color alone). One extra frame shows OFF |
| 3 | Selection sync | **Staged.** Ticks stay local until "Selesai", which commits to S11's active unit. Close / back with changes → `TsDialog / Confirm Save` "Buang perubahan?" ("Buang" / "Lanjut memilih", non-destructive like the booking-exit dialog). No changes → closes silently |
| 4 | Tap targets | Leading 48 dp checkbox toggles; the tile body opens the detail sheet, whose CTA also toggles ("Tambah ke booking" / "Hapus dari booking"). Browse mode: no checkbox, body opens the detail |
| 5 | Browse mode | Plain catalog: no unit header, toggle, checkbox or cart. The tile meta line shows the rule ("Matic 90–110 cc"); the detail sheet lists the user's garage motors with ✓ Cocok / ✕ Tidak cocok; the only action is close |
| 6 | Catalog | 14 parts, chips **Semua · Oli · Kampas rem · Busi · Aki · Ban · Filter udara** (table below) |
| 7 | Compat block (detail sheet) | Rule line ("Cocok untuk matic 90–110 cc") + one row per garage motor (icon + text). No per-model list |
| 8 | Extras | + browse-mode detail sheet, + dirty-close dialog, + search keyboard-open (17 frames). Not built: text ×1.3 stress, Expanded 1024 |

**Defaults applied without a question** (change at review if unwanted):

- Demo unit = **Beat 110** (`AB 5678 ZZ`, unit -B): S11 hands over MPX1 already ticked; the frames show MPX1 + Kampas Rem ticked = "2 dipilih · Rp103.000" (the stub's example). Beat 110 is a 110 cc matic → 7 of 14 parts fit.
- Sticky bar = flat `SelectedPartsBar` ("N dipilih" + "Suku cadang Rp…" + "Selesai"); S11's `StickyEstimateBar` stays the only glass bar. "Selesai" is enabled with 0 ticked (commits an empty list). On tablets the bar width = content column (the S11 width-override trick).
- Unit header reuses `UnitHeader / Remove=No` ("Untuk: Beat 110 · AB 5678 ZZ"); search = `SearchBar`, placeholder "Cari oli, kampas, aki…".
- "Semua" is grouped by category with reused `BrandHeader` group headers; a category chip shows a flat list. No sort control, no quantity (`BookingUnit.partIds[]` has none).
- Part imagery = category icon on a tinted tile (step 04 default; closes the stub's imagery question). Voice "kamu", sentence case.
- Error state = annotation only (S11 already shows "Katalog gagal dimuat" + "Coba lagi").
- Dark = default state per breakpoint + the compatible detail sheet on the phone. One session, one review gate.

### Mock catalog (canonical; written to `parts.json` in the step 19 PRD sync)

| Category | Part | Grade · volume | Price | Compat (category · cc) |
|---|---|---|---|---|
| Oli | AHM Oil MPX1 | 10W-30 · 0,8 L | Rp58.000 | matic 90–110 |
| Oli | AHM Oil MPX2 | 10W-30 · 0,8 L | Rp70.000 | matic 125–160 |
| Oli | AHM Oil SPX2 | 10W-30 · 0,8 L | Rp62.000 | bebek 100–125 |
| Oli | Yamalube Sport | 10W-40 · 1 L | Rp98.000 | sport 150–250 |
| Kampas rem | Kampas Rem Matic | — | Rp45.000 | matic 110–160 |
| Kampas rem | Kampas Rem Bebek | — | Rp40.000 | bebek 100–125 |
| Kampas rem | Kampas Rem Sport | — | Rp120.000 | sport 150–250 |
| Busi | Busi NGK Standar | — | Rp28.000 | matic + bebek ≤ 160 |
| Busi | Busi NGK Iridium | — | Rp95.000 | matic + bebek ≤ 160 |
| Aki | Aki GS Astra 12V | 5 Ah | Rp185.000 | matic 110–160 |
| Aki | Aki Yuasa 12V | 3,5 Ah | Rp165.000 | bebek 100–125 |
| Ban | Ban Tubeless IRC | 80/90-14 | Rp185.000 | matic 90–125 |
| Ban | Ban Tubeless Federal | 90/90-14 | Rp210.000 | matic 125–160 |
| Filter udara | Filter Udara Matic | — | Rp35.000 | matic 90–160 |

For Beat 110: compatible = MPX1, Kampas Rem Matic, both Busi, Aki GS Astra, Ban IRC, Filter Udara (**7**); incompatible = the other 7. Prices of MPX1 / MPX2 / Kampas Rem / Busi match the S11 shortlist and the step 01 price sheet. Garage rows in the detail sheet: Vario 125 (matic 125), Beat 110 (matic 110), PCX 160 (matic 160), Supra X 125 (bebek 125).

### Amended while building (2026-09-25)

| # | Topic | Change and why |
|---|---|---|
| A1 | Flat list, no group headers | The kickoff default "Semua grouped by category" (`BrandHeader`) was dropped: for Beat 110 it gave 6 headers for 7 parts on the phone and half-empty rows in the 2- / 4-col grids. The list is one flat list in category order; the chip row does the filtering. `BrandHeader` is unused |
| A2 | Compat block in select mode | Select mode shows the rule line + **one row (the active unit)**; browse mode shows all four garage motors. Decision 7 said "one row per garage motor" for both; four rows made the select sheet taller than the viewport with its sticky CTA. **Open for the user at review** |
| A3 | Search frame query | "busi" (2 results) instead of "oli" (only MPX1 fits Beat 110, one result) |
| A4 | Tablet header | Tab-P: header row = `UnitHeader` (300) + `SearchBar`, chips 720, toggle 360; Tab-L: header row (unit 360 + search) + tools row (chips + toggle 340) so 2 grid rows fit the 800 dp viewport above the bar |
| A5 | Reason badge copy | "Tidak cocok · untuk matic 125–160 cc" (review fix: without "untuk" the range read as the range the part is *not* for) |
| A6 | Viewport crops | The three detail-sheet frames (phone light, dark, incompatible, browse) are 800 dp viewport crops: `Scroll Viewport` › `Scrolled Content`, bar and gesture bar stay in flow under the scrim. The dirty-close frame is a full-scroll capture (1,015 dp) |
| A7 | No new tile master | The step 04 `Layout=Compact` tile carries brand · grade in its name / meta and the reason row; `Layout=Grid` gets a width override + `Selection Mark` x override. Only the two Loading masters were added. `EmptyState / Type=Filter` reused with text overrides (no `Type=Search`) |
| A8 | `Mode=Select Selected` | Built on the component sheet only (Hapus dari booking); no frame shows it |

## Scope

### Frame matrix (17 frames)

Naming: `S12 Katalog / <State> / <Phone|Tablet-Portrait|Tablet-Landscape>` (+ ` · Dark`). Phone frames = full-scroll captures `fit_content(800)` with status + gesture bar; tablets = fixed viewports without system bars.

| # | State | Frames |
|---|---|---|
| 1–6 | Select Populated (Beat 110, toggle ON, grouped by category, MPX1 + Kampas Rem ticked) | Phone, Phone · D, Tab-P 2-col, Tab-P · D, Tab-L 4-col, Tab-L · D |
| 7 | Select, "Hanya yang cocok" OFF (incompatible tiles + reasons) | Phone |
| 8 | Select Search, keyboard open (query "oli", bar above the keyboard) | Phone |
| 9 | Select Loading (real header + skeleton tiles, "Selesai" disabled) | Phone |
| 10 | Select Empty (search "Ninja" → empty state + "Hapus pencarian") | Phone |
| 11 | Dirty-close dialog over Select Populated | Phone |
| 12 | Browse Populated (no unit context, no checkbox, rule in the meta line) | Phone |
| 13–15 | Detail sheet, compatible (select, "Tambah ke booking") | Phone, Phone · D, Tab-P modal |
| 16 | Detail sheet, incompatible (disabled CTA + reason) | Phone |
| 17 | Detail sheet, browse (garage ✓ / ✕, no CTA) | Phone |

Detail / dialog frames = a `Copy` of frame 1 (or 12) + an absolute `Dialog Overlay` (`fill: $scrim`, literal size) + the sheet / modal / dialog (step 07a / 14 pattern).

### Layout targets (PRD 06 + kickoff)

- **Phone:** app bar (close / back) → `UnitHeader` (select only) → `SearchBar` → `CategoryChipRow` (scroll cue) → `CompatToggleRow` (select only) → grouped list of `PartOptionTile` → flat `SelectedPartsBar` (select only) above the gesture inset.
- **Tab-P:** same order, content centered at 720, 2-col grid, bar width 720 centered.
- **Tab-L:** full-width app bar, content 1232 (24 dp margins), 4-col grid (`Layout=Grid`), bar width = content column. No rail, no side pane.

### Components built here

| Component | Notes |
|---|---|
| `PartDetailSheet` (Layout=Sheet · Modal × Mode=Select Add · Select Selected · Select Incompatible · Browse) | `SheetHeader` (part name + close), category icon tile, brand · grade · volume, price, `SpecRow` list, compat block (rule line + `CompatRow` per garage motor), CTA slot (Tambah ke booking / Hapus dari booking / disabled + reason / none). Modal copies the shadow of `CopySourceSheet / Layout=Modal` |
| `CompatRow` (Compatible · Incompatible), `SpecRow` | Garage motor row: nickname + plate + ✓ Cocok / ✕ Tidak cocok; label / value row |
| `SelectedPartsBar` (Default · None · Loading) | Flat sticky bar; width override for tablets |
| `CategoryChipRow` | `TsChip` row, scroll specimen with fade cue (`bg-page-clear`) |
| `CompatToggleRow` (On · Off) | Label + `TsSwitch` |
| `PartOptionTile` Loading (Compact · Grid) | Skeleton tiles; also the browse meta line (rule) and, if the read of `G7cFN` / `vgdJK` shows brand · grade does not fit, a `Layout=List` master (recorded as a step 04 amendment) |
| Focus specimens | Tile checkbox, tile body, chip, toggle row, detail CTA (step 09 method) |

### Annotations to place

- Entry: S11 "Lihat semua" (select mode, active unit) and S05 `QuickLinkTile` (browse mode). Exit: "Selesai" commits and returns to S11; close / back with changes → dirty dialog.
- Compat rule: model category + cc range; toggle default ON; incompatible reason names category + cc.
- S11 sync: a part ticked here that is not in the S11 shortlist is appended to the S11 list (step 19 audit item).
- Semantics: checkbox "Pilih AHM Oil MPX1", tile body "Lihat detail AHM Oil MPX1", toggle, chips as a selectable group, "Selesai" + count as one node, focus order, sheet / modal focus containment + Escape + focus return; motion sheet 250 ms, reduce-motion = fade only.
- Search: keyboard-open, content scrolls above the keyboard, bar above the keyboard. No cart. Error state = the S11 `ErrorState` pattern.

### Frame ids

Phone rows under the Flows – Phone anchor (light header `t6kYv` y 67,400, frames y 67,586; dark header `rlOMA` y 69,600, frames y 69,786; notes `i0dW3` x 4,400); tablet rows below the S09 tablet rows (Tab-P header `MjE1I` y 130,000, frames y 130,186; Tab-L header `I3NmHv` y 131,800, frames y 131,986; notes `I6iL3k` x 2,720).

| # | Frame | Id | Position · size |
|---|---|---|---|
| 1 | Select Populated / Phone | `ryN4e` | 0, 67,586 · 360 × 1,015 |
| 2 | Select Populated / Phone · Dark | `DcW2i` | 0, 69,786 · 360 × 1,015 |
| 3 | Select Populated / Tablet-Portrait | `CT4gU` | 0, 130,186 · 800 × 1,280 |
| 4 | Select Populated / Tablet-Portrait · Dark | `Sq6Ev` | 880, 130,186 |
| 5 | Select Populated / Tablet-Landscape | `Gk2Kc` | 0, 131,986 · 1,280 × 800 |
| 6 | Select Populated / Tablet-Landscape · Dark | `ZigRM` | 1,360, 131,986 |
| 7 | Select Incompatible Shown / Phone | `AQ6je` | 440, 67,586 · 360 × 1,777 |
| 8 | Select Search Keyboard / Phone | `HcvEw` | 880, 67,586 · 360 × 800 |
| 9 | Select Loading / Phone | `jBill` | 1,320, 67,586 · 360 × 951 |
| 10 | Select Empty / Phone | `KuPhA` | 1,760, 67,586 · 360 × 879 |
| 11 | Select Dirty Close Dialog / Phone | `s4DqIW` | 2,200, 67,586 · 360 × 1,015 |
| 12 | Browse Populated / Phone | `C7heY` | 2,640, 67,586 · 360 × 1,190 |
| 13 | Detail Select Add / Phone | `W6RfBX` | 3,080, 67,586 · 360 × 800 |
| 14 | Detail Select Add / Phone · Dark | `XwVTO` | 440, 69,786 · 360 × 800 |
| 15 | Detail Select Add / Tablet-Portrait (modal) | `ZXobW` | 1,760, 130,186 · 800 × 1,280 |
| 16 | Detail Select Incompatible / Phone | `QZHlf` | 3,520, 67,586 · 360 × 800 |
| 17 | Detail Browse / Phone | `wDIII` | 3,960, 67,586 · 360 × 800 |

Notes: `QZIEm` (entry and commit), `Jbixy` (compatibility and detail), `m38edl` (semantics, focus, states) on the phone notes frame `i0dW3`; `CYOan` (tablet layout) on `I6iL3k`. The Flows – Tablet block moved down 4,000 dp (anchor `URsZs` y 72,500; 172 root nodes).

### Component ids

Sheet **Catalog blocks** `IZxQh` (x 37,608, y 8,760, 1,200 × ~2,500; dark copy `bmjBM` y 12,380, 17 unnamed refs renamed). Masters: `CategoryChipRow` Scroll `rBkAf` / Wide `F14Xh7` · `CompatToggleRow` On `qDZGR` / Off `gWIeH` · `SelectedPartsBar` Default `K5lB7` / None `KtNzu` / Loading `vAHXj` · `PartOptionTile` Compact Loading `F8wGzw` / Grid Loading `sPael` · `SpecRow` `LleoG` · `CompatRow` Compatible `Sui8w` / Incompatible `VaXxq` · `PartDetailSheet` Sheet Select Add `qEGtB` / Select Selected `peARX` / Select Incompatible `h9tbr` / Browse `IhEVg`, Modal Select Add `AfJ1O`. Focus specimens (section `ITCdI`): `TsCheckbox (focused)`, compact tile, grid tile, toggle row, "Selesai" and "Tambah ke booking" buttons.

## Checklist

### Build
- [x] Kickoff questions answered (8) and recorded above.
- [x] Masters read (`PartOptionTile` ×4, `SearchBar`, `EmptyState / Type=Filter`, `UnitHeader`, `TsAppBar` Close / Back, `TsDialog / Confirm Save`, `TsChip`, `SelectionFooter`); no tile extension needed (A7).
- [x] "Catalog blocks" sheet built (light `IZxQh` + dark copy `bmjBM`) with focus specimens.
- [x] All 17 matrix frames built; dark copies built (see *Frame ids*).
- [x] Compatibility conveyed with icon + text (not color alone).
- [x] Part names / prices consistent with the S11 shortlist and the step 01 price sheet (Rp103.000 = 58.000 + 45.000).

### Quality (automated, run in `execute`)
- [x] Clipping check on every step frame → zero `problems` (separate call, `resolveInstances: true`; the chip-row scroll overflow and disabled chains exempt).
- [x] Raw-hex audit → zero (654 nodes).
- [x] Every node named; instances only; `placeholder` cleared.
- [x] Contrast audit (1,460 text + icon nodes, 0 failures), text < 12 sp scan (0 of 1,385), 48 dp targets, wrap test, throw-away ×1.3 copies (4, deleted, 0 `TMP` roots).
- [x] Coverage script: 17 `S12 Katalog / …` roots match the matrix (names in *Frame ids*).

### /better-interface
- [x] Run `/better-interface` with scope = all S12 frames + sheets (names + node ids).
- [x] Report recorded below; HIGH / MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [x] Status set to 🔵; user shown: select mode (phone / tablets / dark), toggle OFF, search, loading, empty, dirty dialog, browse, the three detail sheets.
- [x] Review rounds logged; user approval recorded (2026-09-25, "approve").

### Close (only after approval)
- [x] PNG export to `design/pencil/exports/step15/` (17 PNG + `INDEX.md`, sheets in `components/`, verified with `ls`).
- [x] Claude session file written (`docs/claude-session/17-design-step15-catalog.md`).
- [x] Tracker set to ✅.

## /better-interface report

**Scope:** S12 Katalog, 17 frames (`ryN4e` `DcW2i` `CT4gU` `Sq6Ev` `Gk2Kc` `ZigRM` `AQ6je` `HcvEw` `jBill` `KuPhA` `s4DqIW` `C7heY` `W6RfBX` `XwVTO` `ZXobW` `QZHlf` `wDIII`) + sheets `IZxQh` / `bmjBM` + notes `QZIEm` `Jbixy` `m38edl` `CYOan` · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens · **Convention docs found:** 00-index.md (Pencil mapping table, safe-layout rules), prd/02, prd/06, steps 04 / 07 / 14 files

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | Names for every icon-only control (close, back, clear, sheet close), focused specimens for the checkbox, compact + grid tile, toggle row, both CTAs (chips, search, icon buttons carry their step 03 states), focus order, sheet / modal focus containment, live announcements, 48 dp targets, color-alone check (incompatible, selected, toggle), reduced motion | 1 MEDIUM (fixed) |
| Layout | Reading order, grouping gaps, chip-row scroll cue, margins / insets, tablet header rows and grid geometry, ×1.3 copies of frames 1, 7, detail (phone) and Tab-L | 2 LOW |
| Writing | Every string against the step 03 / 07 / 14 voice ("kamu", sentence case), button verbs, empty state, dialog, reason copy | 1 MEDIUM + 1 LOW (fixed) |
| Typography | Type-role tokens, min size, wrapping at ×1.3, line counts, tabular figures | 1 LOW (fixed as annotation), shared with Layout LOW |
| Color | 1,460 text + icon pairs composited from the rendered ancestors, light and dark; semantic use (warning for incompatible, no danger hue) | Clear (1 pre-existing) |
| UI | Radii nesting, states (default, selected, incompatible, loading, empty, disabled CTA), specimens, motion notes | Clear |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| MEDIUM (fixed) | Writing | Select Incompatible Shown `AQ6je` ×7 tiles (`WEPXN` `D35Co` `r2anx0` `dMbfo` `TQf7L` `XQ4Yg` `zRevQ`) and Detail Select Incompatible `QZHlf` ×7 | "Tidak cocok · matic 125–160 cc" | "Tidak cocok · untuk matic 125–160 cc" | Without "untuk" the range reads as the range the part is not for; a mismatch the user cannot resolve |
| MEDIUM (fixed) | Accessibility | Semantics note `m38edl` | No name for the search clear button and the app-bar close / back; no announcement of result count or selection count after a change | Names "Hapus pencarian", "Tutup katalog", "Kembali"; polite live region for result count and "2 dipilih, Rp103.000"; compat-row semantics; loading announcement | Icon-only controls need names; list and count updates are silent to a screen reader |
| LOW (fixed) | Writing | Browse Populated `C7heY` and Detail Browse `wDIII`, Busi tiles | "Matic dan bebek ≤ 160 cc" (sheet says "hingga 160 cc") | "Matic dan bebek hingga 160 cc" | One phrase for one rule |
| LOW (fixed) | Typography | Bar counter and total (`SelectedPartsBar` `K5lB7`) | Digits shift as the count changes | Note: tabular figures on counter and total | Values that change need tabular numbers |
| LOW (left) | Layout · Typography | Compact `PartOptionTile` in `ryN4e`, `AQ6je`, `C7heY` (7 of 7 select names wrap) | 128 dp of 328 for name + meta beside checkbox, icon tile and price; rows 86 – 98 dp vs the 76 dp S11 rows | Decide at step 19 whether the shared master moves the price under the meta | The master is shared with S11 (approved); a change touches both screens |
| LOW (left) | Layout | Phone header stack (`ryN4e`) | 12 dp between search, chips, toggle and list vs 8 dp between tiles | Optional 16 dp before the list | Inter-group gap under 2× the intra-group gap |
| Pre-existing | Color | `TsChip` Semua selected `l8xuU` on `accent-soft` | `focus-ring` 2.92 : 1 (step 13) | step 19 | Already in the step 19 list |

**Verification:** *Passed* — clipping 0 rows over 23 roots (`resolveInstances: true`; chip-row scroll overflow and disabled chains exempt; two 24 dp sheet-row overflows found and fixed: `S12 Toolbar Row 3` gap 24 → 12); raw hex 0 of 654 nodes; unnamed non-ref nodes 0; placeholders 0; contrast 1,460 text + icon nodes, 0 failures; text < 12 sp 0 of 1,385; four ×1.3 throw-away copies (Select Populated, Select Incompatible, Detail Add, Tab-L): names, badges and the toggle label wrap, nothing clips, copies deleted (0 `TMP` roots); reason badges 14 of 14 on one line after the copy fix. **Not verified:** screen-reader and keyboard traversal (annotations only), forced-colors, 320 dp width (frames start at 360), Flutter semantics output.
**Verdict:** Approve
**Fixes applied:** MEDIUM ×2 and LOW ×2 above · **LOW left for user:** compact-tile density (shared with S11), header-to-list gap. Pre-existing: `focus-ring` on `accent-soft` → step 19.

## Review rounds

#### Round 1 — 2026-09-25
- **Frames shown:** select mode (phone, Tab-P, Tab-L, dark), toggle OFF, search keyboard, loading, empty, dirty-close dialog, browse, three detail sheets (compatible phone / dark / Tab-P modal, incompatible, browse). Open items named: A2 (select-mode compat block shows the active unit only), A1 (flat list), two LOW left.
- **User feedback:** "approve"
- **Changes made:** none.
- **Outcome:** approved

## Session log

| Time | Action | Result / node ids |
|---|---|---|
| 08:05 | Kickoff | Plan mode; read index, stub, PRD 03 / 04 / 05 / 06, steps 04 / 07 / 14; 2 interview rounds (8 questions); plan approved |
| 08:05 | Docs | This file rewritten; `00-index.md` decision log, demo content, inventory, tracker 🟡; `19-full-app-audit.md` items |
| — | Canvas prep | Flows – Tablet block (172 root nodes) moved down 4,000 dp, anchor `URsZs` y 72,500 |
| — | Masters read | `PartOptionTile` ×4, `SearchBar`, `UnitHeader`, `TsDialog`, `TsAppBar`, `SelectionFooter`, `TsChip`, `SheetHeader`: no tile extension needed |
| — | Sheet built | `IZxQh`: chips, toggle, bar, loading tiles, `PartDetailSheet` ×5, `SpecRow`, `CompatRow` ×2, focus specimens |
| — | Frames | 17 frames + 4 row headers + 4 notes; dark sheet `bmjBM` (17 refs renamed) |
| 08:24 | Checks + report | Clipping, hex, names, contrast (1,460), ×1.3 copies; `/better-interface` Approve; fixes: reason copy, "hingga", semantics note |
| 08:28 | Close | Approved; 17 frames + 2 sheets exported to `design/pencil/exports/step15/` (`INDEX.md`), session file `17-design-step15-catalog.md`, tracker ✅ |
