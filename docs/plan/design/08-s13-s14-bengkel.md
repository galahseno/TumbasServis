# Step 08 — S13 Pilih Bengkel + S14 Detail Bengkel

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-24 |
| **Priority** | S13 P0 · S14 P1 |
| **Owns screens** | S13, S14 |
| **Owns components** | (screen-local, flagged for `prd/02`): `SearchBar`, `FilterChipRow`, `StaticMap`, `WorkshopPhoto`, `WorkshopInfoBlock`, `WorkshopDetailContent`, `WorkshopCtaBar`, `TsAppBar` back-only (only if step 03 has none), `EmptyState` variant Bengkel, `WorkshopCard` Loading; amends step 04 `WorkshopCard` (slots `Estimate Row`, `Chosen Tag`) |
| **PRD refs** | [04 S13/S14](../../../prd/04-screens.md), [03 F2 entry points](../../../prd/03-user-flows.md), [05 workshops](../../../prd/05-data-model-mock.md), [06 S13/S14 rows](../../../prd/06-responsive-layout.md) |
| **Pen location** | Flows rows `S13`, `S14`; component sheet **S13 / S14 blocks** |
| **Depends on** | Steps 02–04, 06–07 (booking-flow chrome and app bar) |
| **Claude session** | `docs/claude-session/10-design-step08-s13-s14-bengkel.md` (written after approval) |

## Goal

Design workshop choice for the whole booking (S13) and the pre-commit detail view with static map (S14), including the tablet **list-detail split** where S14 content is the right pane of S13, the difference between a *previewed* and a *chosen* workshop, and the two contexts S14 is reached from (in the booking flow, and standalone).

## Inputs

- `WorkshopCard` (step 04: thumb 80×80, name, ★ rating · distance, Buka / Tutup badge, `2 bay servis`; default / closed / selected), `TsChip` (filters), `TsTextField` (search recipe), `BookingStepper` (step 3/4, phone + wide), `TsAppBar / Type=Step` `mYhlk`, `EmptyState` + `Illustration / Empty Search` `Myjen`, `Skeleton`, `TsButton`, `SelectionFooter` look (flat sticky bar), `TsDialog / Type=Confirm Save` (exit dialog, annotation only).
- Workshops are fictional, Yogyakarta-area, with rating, hours, bay count, distance and a static-map asset reference (PRD 05); demo list in decision 10.
- Business rules: PRD 03 F2 — S13 → S14 → S15 in the flow; S14 → "Booking di sini" → S10 with the workshop carried and S13 skipped; duration = makespan across the workshop's bays; slots 08.00–16.00 hourly for D+0…D+14.

## Kickoff decisions (answered 2026-09-24, interview with the user; every recommended option accepted)

Three `AskUserQuestion` rounds (12 questions); the plan's six open questions plus six found while planning: the two S14 contexts, chosen vs previewed, the S11 duration assumption, closed-now vs future slots, the spent illustration budget, the S15 slot-grid constraint on opening hours.

| # | Topic | Decision |
|---|---|---|
| 1 | Sessions | **One session**, 36 frames (the kickoff count of 35 missed one S14 dark frame; see the matrix), one review gate, one session file |
| 2 | S14 contexts (found while planning: PRD 04 has one CTA label; PRD 03 has two behaviours; no PRD screen links to S14 from outside the flow) | **Two variants.** In-flow (from S13): `TsAppBar / Type=Step` (back + close; close → exit dialog under the ≥ 1-selection rule), title "Detail bengkel", **no stepper**, CTA **"Pilih bengkel ini"** → S15. Standalone (PRD 03 out-of-flow): back-only bar, CTA **"Booking di sini"** → S10 with the workshop carried and S13 skipped; entry = tap on the workshop row of S18 / S20 (annotation here, built in steps 11 / 16, no S05 change) |
| 3 | Chosen vs previewed (found while planning) | Previewed = the existing `WorkshopCard` selected style (`border-accent`). Chosen = a **"Dipilih" tag** (check icon + text, `accent-soft` / `text-on-accent-soft`) on any breakpoint; both can coincide. No footer on S13. When the workshop shown in S14 is already chosen the CTA reads **"Lanjut ke jadwal"** (default applied, not asked) |
| 4 | Bay hint (old Q4; found while planning: S11 shows a duration before any workshop is chosen) | Card = "2 bay servis" **+ "Estimasi 2 jam untuk 3 motor"**: makespan of the draft's units over that workshop's bays (1 bay → 3 jam, 2 → 2 jam, 3 → 1 jam). S11's duration gets an annotation "asumsi bengkel 2 bay" |
| 5 | Closed now (old Q5; found while planning) | Bookable, informational: badge **"Tutup · buka 08.00"** (icon + text, never color alone), card still tappable. S14 CTA enabled with helper "Sedang tutup. Kamu tetap bisa pilih jadwal lain." "Buka sekarang" is the only place it matters |
| 6 | Static map (old Q1) | New token-bound **`StaticMap`**: rectangles / lines (roads, blocks, a park) + pin icon; flips with dark mode; no `Generate` (illustration budget 11 / 11 spent, generated SVG is not theme-aware). "Buka di Maps" action below it (`url_launcher`, no API key). One component; Flutter ships one similar asset per workshop |
| 7 | Photo header (old Q6) | 16:9 aspect-ratio box, `accent-soft` → sand token gradient, `storefront` icon + workshop initials ("BJ"); same recipe as the 80×80 card thumb |
| 8 | Tablet-L geometry | Margins / gap 24 · list column **440** · pane **768** (24+440+24+768+24 = 1280). Pane = S14 content stacked (photo → info → map → services → address), scrolls, CTA pinned at its bottom. First state: the chosen workshop, else the nearest card. Standalone S14 Tablet-L: margins 24 · left column 560 (photo 16:9 + map) · gap 24 · right column 648 (info, services, address, pinned CTA) |
| 9 | Filters (old Q3) | "Buka sekarang" = independent toggle (check icon when on). "Rating tertinggi" / "Terdekat" = mutually exclusive sort, one always on, default **Terdekat**, leading sort icon so sort ≠ filter. Result line "5 bengkel · urut terdekat" |
| 10 | Demo list | See table below. All close ≥ 17.00 so the uniform 08.00–16.00 slot grid of S15 stays valid |
| 11 | S14 content | Name, ★ 4,8 (126 ulasan, text only, no tap), status line "Buka · tutup 17.00", "Setiap hari 08.00–17.00", "2 bay servis"; read-only service chips (Servis Berkala, Ganti Oli, Perbaikan/Keluhan, Ganti Ban, Tune-Up); address row with Salin + "Buka di Maps". Every workshop offers the three S11 services, so **no "service not offered" state** |
| 12 | Extra frames | + **Expanded 1024×768** list-detail (S13) and **Text ×1.3** stress (S13 + S14 phone). Not built: search-typing / keyboard frame, error frame (annotation only) |

**Number corrected after the interview:** the Expanded option read "list 400 + pane 576", which sums to 1048. Built as **list 400 + pane 552** (24+400+24+552+24 = 1024).

Demo list (decision 10; distances and ratings fictional, order shown = Terdekat; estimate = 3 motors × 60 min over the bays):

| # | Workshop | ★ | km | Bay | Hours | Estimate |
|---|---|---|---|---|---|---|
| 1 | Bengkel Jaya Motor (canonical; Jl. Melati Raya No. 12, Sleman, DI Yogyakarta) | 4,8 | 1,2 | 2 | Buka · tutup 17.00 | 2 jam |
| 2 | Sinar Roda Motor (Depok, Sleman) | 4,6 | 2,1 | 3 | Buka · tutup 18.00 | 1 jam |
| 3 | Motor Care Kotagede | 4,9 | 3,4 | 2 | Buka · tutup 17.00 | 2 jam |
| 4 | Bengkel Resmi Sumber Rejeki Motor & Spesialis Matic Ngaglik (long-name stress) | 4,3 | 4,7 | 1 | Buka · tutup 17.00 | 3 jam |
| 5 | Cahaya Motor Gejayan (closed-now specimen) | 4,5 | 5,0 | 2 | **Tutup · buka 08.00** | 2 jam |

Rating tertinggi order: Kotagede, Jaya, Sinar Roda, Cahaya, Resmi.

Defaults applied without a question (change at review if unwanted): sentence case titles "Pilih bengkel" / "Detail bengkel"; S13 = `TsAppBar / Type=Step` + `BookingStepper` step 3 ("Langkah 3 dari 4 · Bengkel & Jadwal"; wide variant centered 720 on tablets) + helper "Satu bengkel untuk semua motor. Jadwal dipilih di langkah berikutnya."; search placeholder "Cari nama bengkel atau area"; loading = real app bar + stepper + search / chips + 4 skeleton cards (S14: skeleton photo / map / info, CTA disabled); empty = `EmptyState` variant Bengkel with `Illustration / Empty Search`, "Bengkel tidak ditemukan" / "Coba kata kunci lain atau hapus filter." + "Reset filter", drawn with "Buka sekarang" on; S14 phone CTA in a flat sticky bar above the gesture inset (S10 footer recipe, no glass); tablet frames = fixed viewports, no status / gesture bar (step 06 / 07 pattern); export = key frames only, no HTML export / Figma import until step 12.

## Scope

### Frame matrix

36 frames. Names: `S13 Pilih Bengkel / <State> / <Phone|Tablet-Portrait|Tablet-Landscape|Expanded>` and `S14 Detail Bengkel / <State> / …`, dark = ` · Dark`.

| Screen · State | Phone | Tablet-P | Tablet-L | Expanded | Dark |
|---|---|---|---|---|---|
| S13 Loading | ✔ | ✔ | ✔ (list + empty pane) | — | phone |
| S13 Empty | ✔ | ✔ | ✔ | — | phone |
| S13 Populated (nothing chosen; Tablet-L / Expanded pane = the nearest card previewed) | ✔ | ✔ | ✔ | ✔ | phone + Tablet-P + Tablet-L |
| S13 Chosen (Jaya "Dipilih"; on Tablet-L the pane previews Sinar Roda, so previewed ≠ chosen) | ✔ | — | ✔ | — | phone |
| S13 Stress 360×640 · Text ×1.3 | ✔ · ✔ | — | — | — | — |
| S14 Loading | ✔ | ✔ | ✔ (as pane inside S13) | — | phone |
| S14 Populated, in-flow ("Pilih bengkel ini") | ✔ | ✔ | (= the S13 Populated pane) | — | phone + Tablet-P |
| S14 Populated Standalone ("Booking di sini") | ✔ | — | ✔ (photo + map left, info right) | — | phone + Tablet-L |
| S14 Closed (Cahaya, helper line, CTA enabled) | ✔ | — | — | — | — |
| S14 Chosen (CTA "Lanjut ke jadwal") | ✔ | — | — | — | — |
| S14 Stress 360×640 · Text ×1.3 | ✔ · ✔ | — | — | — | — |

Count: S13 light 14 + dark 6 = 20; S14 light 11 + dark 5 (Loading phone, Populated phone + Tablet-P, Standalone phone + Tablet-L) = 16; total **36**.

### Layout targets (PRD 06 + kickoff)

- No `NavBar` / `NavRail` (step 06 decision 2). Phone 360: margins 16 (content 328). S13 = status bar + step app bar + stepper + helper + `SearchBar` + `FilterChipRow` (scroll cue) + result line + cards; S14 = same chrome, scroll content, flat sticky CTA bar. Phone frames = full-scroll captures (Loading / Empty fixed 800).
- Tablet-P 800×1280: content 720 centered, S13 1-col list; S14 stacked 720 with the CTA bar aligned to 720.
- Tablet-L 1280×800: decision 8. Expanded 1024×768: list 400 · pane 552.

### Components built here

| Component | Notes |
|---|---|
| `SearchBar` | `TsTextField` recipe with search icon; default / focused / has-text with clear |
| `FilterChipRow` | filter toggle chip (check) + sort chips (leading sort icon, mutually exclusive); scroll cue; `Chips Track` exempt from clipping |
| `StaticMap` | token-bound shapes + pin; "Buka di Maps" action |
| `WorkshopPhoto` | 16:9 gradient + `storefront` + initials |
| `WorkshopInfoBlock` | name, rating, status, hours, bays, service chips, address row (Salin + Maps); Open / Closed |
| `WorkshopDetailContent` | S14 content column; Layout=Stacked (phone, Tablet-P, pane; incl. Loading), Layout=Split (standalone Tablet-L) |
| `WorkshopCtaBar` | flat sticky bar, full-width CTA, optional helper line |
| `WorkshopCard` amendment | `enabled` slots `Estimate Row` and `Chosen Tag` on the three step 04 masters, switched on per instance; Loading skeleton |
| `EmptyState` Bengkel, `TsAppBar` back-only | back-only only if step 03 has none |

### Content & copy

- Titles "Pilih bengkel" / "Detail bengkel"; CTAs "Pilih bengkel ini" · "Booking di sini" · "Lanjut ke jadwal"; tag "Dipilih"; estimate "Estimasi 2 jam untuk 3 motor"; closed "Tutup · buka 08.00"; Maps action "Buka di Maps"; address action "Salin".
- All workshops fictional; Jaya carries the canonical detail (2 bay · ★ 4,8 · 1,2 km · buka s.d. 17.00 · Jl. Melati Raya No. 12, Sleman).

### Annotations to place

- Entry / exit: S13 card → S14; S14 in-flow CTA → S15; standalone S14 → S10 (workshop carried, S13 skipped); entry to standalone S14 from the S18 / S20 workshop row (steps 11 / 16); close → exit dialog only with ≥ 1 selection.
- List-detail at Expanded / Large; the pane previews, the CTA commits; selection persists; chosen vs previewed rule.
- Sort vs filter semantics and default; closed-now bookable rule; S11 duration assumes a 2-bay workshop.
- Static map is an asset (no API key), external Maps intent via `url_launcher`.
- Semantics: card "Bengkel Jaya Motor, bintang 4,8, 1,2 kilometer, buka sampai 17.00, 2 bay, estimasi 2 jam untuk 3 motor, dipilih"; icon-only controls (back, close, clear, Salin); focus order; reduce-motion (no shimmer).

## Built sheets and frames (node ids, `design/pencil/TumbasServis.pen`)

Component sheet **S13 S14 Blocks** `u19Pl` (light, x 29448, y 8760, 1200 wide) and its dark copy `V0OLK` (y 14200: the sheet is ~5,300 dp tall, so the usual y 12380 would overlap it). No new variables.

| Family | Masters (ids) |
|---|---|
| `WorkshopCard` (amends step 04 `xnuO8` Open, `UV0jm` Closed, `sgt7W` Selected) | `enabled:false` slots `Estimate Row` (`n5b8Z` `cC0mk` `PZth4`) and `Chosen Tag` (`M19Ham` `u9P6b5` `p7gNAi`, first child of the text column); `Preview Chevron` `cZ9Fr` on Selected only (review fix); `WorkshopCard / State=Loading` `AV7dx` |
| Search + filters | `SearchBar` Default `a9IPSs` · Focused `QcKV6` · Filled `N4aTXA`; `FilterChipRow` Default `ZyCXR` · Open Now `OQy8K` · Sort Rating `xBZUh` (360 wide, `Chips Track` + 24 dp `Scroll Fade`; wide instances override the fade `x` or switch it off) |
| Map + photo | `StaticMap` `yf1Ox` (a clipped `Map Canvas` `w7Y0V` of tokens + absolute `Pin`; instances override canvas `x / y` and `Pin` `x / y`), `WorkshopPhoto` `cX2s7` |
| Detail blocks | `ServiceTag` `mPVpJ`; `WorkshopInfoBlock` Open `a8DDIt` · Closed `AbqvC` (with `Badge Row` + `Chosen Tag` slot); `WorkshopMapBlock` `jHVBK`; `WorkshopServicesBlock` `zuq2B`; `WorkshopAddressBlock` `rtjUO`; `WorkshopDetailContent` Populated `Z7oJkd` · Loading `s9R7o` |
| Bars + states | `WorkshopCtaBar` Default `w02XMN` · Helper `bW94s` · Disabled `ytfLP`; `EmptyState / Type=Bengkel` `kax7x` |
| Specimens + notes | focus / pressed section `ehcwQ` (card focused / previewed focused / pressed, both chips, "Buka di Maps", "Salin"); handoff notes `E8gLs` (`bTT6G` flow, `e9W22` list-detail, `W35DPS` filters, `FtMoD` estimate, `nD80a` map, `AtLaH` semantics) |

Deviation from the plan: **`WorkshopDetailContent` Layout=Split was not built as a master.** It has a single consumer (standalone S14 Tablet-L, 1232 dp wide, wider than the 1104 dp sheet), so that frame composes the same sub-block instances (`Workshop Photo`, `Workshop Map`, `Workshop Info`, `Workshop Services`, `Workshop Address`) in two columns; content still cannot drift. Extra masters beyond the plan: `ServiceTag`, `WorkshopMapBlock`, `WorkshopServicesBlock`, `WorkshopAddressBlock`, `Preview Chevron` slot.

Frames (rows under the Flows anchors; the Flows – Tablet block `URsZs` moved down **8,000 dp** to make room, anchor now y 35000, S05 / S10 / S11 tablet rows follow):

| Row (header id) | Frames |
|---|---|
| S13 Phone, light y 26640 (`l3fP9`, frames y 26826) | Loading `Theem` (864) · Empty `uQjxq` (816) · Populated `xQoM6` (1188) · Chosen `RNh7t` (1214) · Stress 360×640 `nDl59` · Stress Text 1.3 `GvbAS` (1535) |
| S13 Phone, dark y 28600 (`l9oEM3`, frames y 28786) | Loading `VZ9Lu` · Empty `mtFRE` · Populated `DC5yD` · Chosen `GcNG5` |
| S14 Phone, light y 30200 (`btvaJ`, frames y 30386) | Loading `Tvg5J` (826) · Populated `utN0f` (1122) · Populated Standalone `RQhJA` (1094) · Closed `fRRNg` (1148) · Chosen `zglR8` (1122) · Stress 360×640 `xWlZB` · Stress Text 1.3 `IhfgI` (1202) |
| S14 Phone, dark y 31800 (`uvW6H`, frames y 31986) | Loading `Qs5pN` · Populated `u17ta` · Populated Standalone `ptPak` |
| S13 Tablet-Portrait y 45000 (`zFMTS`, frames y 45186, x 0 / 900 / 1800 / 2700) | Loading `DWVRs` · Empty `LJUZ4` · Populated `f6omBC` · Populated dark `yUCtb` |
| S13 Expanded y 46700 (`z6Hpwu`, frame y 46886) | Populated `cuGwr` (1024×768) |
| S13 Tablet-Landscape y 47900 (`zdJ4G`, frames y 48086, x 0 / 1380 / 2760 / 4140 / 5520) | Loading `LIbQC` · Empty `SeX4d` · Populated `aH20g` · Chosen `iUuKP` · Populated dark `vq5fX` |
| S14 Tablet-Portrait y 49100 (`W7ezF7`, frames y 49286, x 0 / 900 / 1800) | Loading `XfOX4` · Populated `f2NLP` · Populated dark `JXfbB` |
| S14 Tablet-Landscape y 50800 (`D3Jdl`, frames y 50986, x 0 / 1380 / 2760) | Loading `qRLMi` (list-detail with a loading pane) · Populated Standalone `xen5e` · Populated Standalone dark `jMD8c` |

Build decisions made while building (all inside the kickoff decisions unless marked):
- **Phone frames** = status bar + `TsAppBar / Type=Step` `mYhlk` (S14 standalone: `Type=Back` `R7zOVC`) + `Scroll Body` (stepper wrap, heading block, search, chips, result line, card list) + gesture bar; full-scroll captures. Loading is `fit_content` (864, three skeleton cards, the plan's 800 fixed height cannot hold four); Empty is `fit_content` (816) after the review fix. S14 phone = `WorkshopDetailContent` + a `WorkshopCtaBar` before the gesture bar.
- **Tablet frames** are fixed viewports with no status / gesture bar. Tablet-P: wide stepper centered 720 + content column 720 (photo 300, map 200 overrides so the whole page fits 1280). Tablet-L / Expanded: `Panes Row` (padding 24, gap 24): `List Column` 440 / 400 (search, chips, result line, `List Viewport` > `Scrolled Content`) + `Detail Pane` (surface-card, radius-lg, `Pane Scroll` > `Scrolled Content` = `WorkshopDetailContent` 720 / 504 wide, photo 240 / 200 and map 200 / 180 overrides, `WorkshopCtaBar` pinned with `Main Column` padding 24 and a hugging CTA on the right). List and pane clip on purpose (a card / the map peeks at the edge as the scroll cue).
- **Previewed card** = the step 04 Selected master with its check mark switched off (`Selected Mark` `enabled:false`, it would read as "chosen") and the new `Preview Chevron` on; the chosen card = Open master + `Chosen Tag`. On Tablet-L Chosen the pane previews Sinar Roda (all its texts overridden by unique name) while Jaya is "Dipilih".
- **Long name:** phone cards use a manual ellipsis at two lines ("Bengkel Resmi Sumber Rejeki Motor & Spesialis…", Flutter `maxLines: 2`); tablet cards fit the full name; S14 always wraps the full name.
- **Empty pane** (S13 Empty Tablet-L) = a plain placeholder (storefront icon + "Pilih bengkel untuk melihat detailnya"); loading pane = `WorkshopDetailContent / State=Loading` + disabled CTA bar.
- **Pencil findings:** see the "Verified in step 08" block in `00-index.md` (written at close).

## Checklist

### Build
- [x] Kickoff questions answered (12 decisions above).
- [x] Blocks sheet: new masters, `WorkshopCard` amended, focus + pressed specimens, dark copy (`u19Pl`, `V0OLK`).
- [x] S13 states for the required breakpoints; S14 states for the required breakpoints; dark copies (36 frames).
- [x] Tablet-L / Expanded list-detail composed with the S14 pane as `WorkshopDetailContent` instances (no redrawn pane); standalone Tablet-L composed from the same sub-block instances.
- [x] Open / closed, rating and chosen shown with icon + text, never color alone (previewed card: border + `Preview Chevron`, added by the review).
- [x] `StaticMap` and `WorkshopPhoto` consistent across cards, pane and standalone.
- [x] Stress frames built and clean; the long workshop name wraps then ellipsizes; the address wraps.
- [x] Demo content matches the table above.

### Quality (automated, run in `execute`)
- [x] Clipping check on every step frame → zero `problems` (exempt: `Decor`, `Chips Track`, `Scrolled Content`, `Map …`, `enabled:false`; the two intentional 360×640 viewports report their clipped list, as in S10).
- [x] Raw-hex audit → zero (36 frames + both sheets, without `resolveInstances`).
- [x] Every node named (0 unnamed); instances only; `placeholder` cleared (0).
- [x] Coverage script: frame names match the matrix above (36 / 36, no extra, no duplicate).
- [x] Arithmetic and order checks (1 / 2 / 3 bays → 3 / 2 / 1 jam; Terdekat order 1,2 → 5,0 km); CTA bar variant matches its state (Helper on Closed, "Booking di sini" standalone, "Lanjut ke jadwal" chosen, Disabled on every Loading).
- [x] Contrast from resolved values in both themes: 2,421 text + icon nodes, 0 fails (minimum 4.56 : 1, the disabled CTA label); map label pairs measured separately; 61 interactive instances ≥ 48 dp.

### /better-interface
- [x] Run `/better-interface` with scope = all S13 + S14 frames and the blocks sheet (names + node ids).
- [x] Report recorded below; HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [x] Status set to 🔵; user shown: S13 phone populated / chosen / empty, Tablet-L list-detail, Expanded, S14 phone (in-flow, standalone, closed), standalone Tablet-L, dark.
- [x] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [x] PNG export of the key frames + blocks sheets (23 frames + 2 sheets = 25 PNG) to `design/pencil/exports/step08/` + `INDEX.md`, verified with `ls` (26 files).
- [x] Claude session file written (`docs/claude-session/10-design-step08-s13-s14-bengkel.md`).
- [x] Tracker set to ✅; inventory additions, canvas layout and "Verified in step 08" facts in `00-index.md`; S13 / S14 PRD corrections queued in `19-full-app-audit.md`.

## /better-interface report

**Scope:** 36 step 08 frames (S13 × 20, S14 × 16; ids in *Built sheets and frames*) + the blocks sheet `u19Pl` and its dark copy `V0OLK` · **Stack/conventions:** Pencil, variables per `00-index.md`, PRD 02 tokens, step 03 / 04 / 06 / 07 component conventions · **Convention docs found:** `00-index.md`, `prd/02`, `prd/06`, steps 03 / 04 / 06 / 07 (no other interface guidelines). Cited as frame name + node id; the review was read-only, the fixes below were a separate, logged action.

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | Focus / pressed specimens for card, search, both chip kinds, "Buka di Maps", "Salin"; Semantics notes (icon-only back / close / clear, card label, map image, name truncation, list-detail keyboard); state cues (open / closed / chosen / previewed); scroll cues (chip fade, card / map peek); targets (61 interactive instances ≥ 48 dp); reduce-motion note | 2 MEDIUM (fixed) |
| Layout | Reading order and grouping on phone / Tablet-P / Tablet-L / Expanded / standalone; list and pane edges; CTA bar placement; text ×1.3 and 360×640 frames | 3 LOW |
| Writing | Sentence case, verb-first CTAs, empty state (query + exit), terminology against step 03, helper on the closed CTA | 1 MEDIUM (fixed) |
| Typography | Heading descent, wrap and manual ellipsis, ×1.3 stress, tabular figures, 11 px labels | 1 LOW |
| Color | Token roles (status tokens on the map), contrast 2,421 nodes + map label pairs, dark theme (map, photo gradient, chips) | 1 MEDIUM (fixed) |
| UI | Chosen / previewed consistency S13 ↔ S14, concentric radii (pane 16 / photo 16, focus specimens 16 + 4), press feedback, divider vs space | 1 MEDIUM (fixed), 1 LOW |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| MEDIUM | Accessibility | Previewed cards: S13 Populated / Tablet-Landscape `aH20g` (`V3R0Yz`), Chosen / Tablet-Landscape `iUuKP` (`RFT7p`), Populated / Expanded `cuGwr` (`H3vww`), Populated / Tablet-Landscape · Dark `vq5fX`, S14 Loading / Tablet-Landscape `qRLMi`; specimens `bMkLH` `RwmEQ` | Previewed = `border-accent` 2 dp only (the check mark was switched off so it does not read as "chosen") | New in-flow slot `Preview Chevron` `cZ9Fr` on `WorkshopCard / State=Selected` `sgt7W` (`chevron_right`, `accent-fill`), enabled on the 8 previewed instances | A state carried by border colour and 1 → 2 dp alone; the chevron adds a shape cue and says the card opens in the pane |
| MEDIUM | Accessibility | Handoff notes `nD80a` (map), `AtLaH` (semantics), `FtMoD` (estimate) + dark copies | Nothing said about the map as an informative image, the ellipsized name, list-detail keyboard use or tabular figures | Added: `Semantics(image: true, label: 'Peta lokasi …')`; name max 2 lines then ellipsis, full name in the label and on S14; Enter / Space previews, Tab moves to the pane; tabular figures on the hour figure | An informative image needs a text alternative; truncated text needs a stated way to the full value; the pane needs a keyboard path |
| MEDIUM | Writing | `EmptyState / Type=Bengkel` `kax7x`; S13 Empty `uQjxq` `mtFRE` `LJUZ4` `SeX4d` | CTA "Reset filter" (step 03 `EmptyState / Type=Filter` says "Hapus filter"); body did not name the query | CTA "Hapus pencarian & filter" (clears the cause: query + toggle); body "Tidak ada hasil untuk “Pandean”. Coba kata kunci lain atau hapus filter."; phone Empty frames now `fit_content` (816) for the extra line | One term per action; an empty search names the query and offers the exit |
| MEDIUM | Color | `StaticMap` `yf1Ox` (`Map Park` `YUg22`, `Map Park Icon` `cV4EQ`) | Park drawn with `success-soft` / `success-text` | Icon deleted, block = `surface-inset` (renamed `Map Block 4-2`) | Status tokens used for decoration read as "open / OK" and are borrowed by value |
| MEDIUM | UI | S14 Chosen / Phone `zglR8` (`EbKD2`); `WorkshopInfoBlock` `a8DDIt` `AbqvC` | Chosen state visible on S13 ("Dipilih") but on S14 only through the CTA label | `Badge Row` (`Zv7gG` `AZwIt`) with a `Chosen Tag` slot (`koAgQ` `z2YS8M`) next to the status badge, enabled on `zglR8` | The same state must look the same on both screens |
| LOW | Layout | `FilterChipRow` masters `ZyCXR` `OQy8K` `xBZUh` (`Group Divider` `wYAiU` `bK3oe` `SphKQ`) | A 1 dp divider **and** the "Urutkan" caption both mark the sort group | Delete the divider, widen the gap to 16 | Space and a label already group; lines last. **Left for you** |
| LOW | Layout | Chip rows on every frame; phone `v6tbIU`, Tablet-L `nDYZK` | Chip visuals start 6 dp inside the hit area (phone 22 dp vs card edge 16; tablets 6 dp vs search edge 0) | Align edges in the step 19 pass (same pattern as `VehicleTabRow`) | Stray edges read as noise. **Left for you** |
| LOW | Layout | S14 Populated Standalone / Tablet-Landscape `xen5e`, `jMD8c`; stepper on S13 tablets | Info column ends ~ 350 dp above the left column; the centered 720 stepper lines up with no pane edge (repeat of step 07 decision 20) | Balance in step 19 or top-align both columns' CTA area | Hierarchy and shared edges. **Left for you** |
| LOW | Typography | `Chosen Tag`, status badges, `ServiceTag`, map labels | Label Small 11 px on new elements (open since step 03) | Decide with the type scale in step 19 | Small UI text. **Left for you** |

**Pre-existing, outside the cap and the verdict:** the S11 blocks sheet `nSN5s` (3,902 dp from y 8760) overlaps its dark copy `x7zHcC` (y 12380) by ~ 282 dp (step 07a canvas layout); the step 04 `Selected Mark` `K2JhM` is absolute at x 296 and can sit under a two-line name (avoided here by switching it off on previewed cards); the step 05 / 06 export folders described in their session files are still missing.

**Verification.** Passed: coverage 36 / 36 (names vs the matrix); clipping 0 on 36 frames after the fix (only the two intentional 360×640 viewports, exempt names `Scrolled Content`, `Chips Track`, `Map …`, disabled subtrees); raw hex 0 and unnamed 0 on 36 frames + 2 sheets; placeholder 0; contrast 2,421 text + icon nodes, 0 fails (minimum 4.56 : 1) and the map pairs measured (label on road 4.83 light / 5.72 dark, side label on block 4.56 / 6.05, pin on road 4.10 / 5.72, all ≥ their 4.5 / 3 : 1 floor); 61 interactive instances ≥ 48 dp; arithmetic and order checks; CTA bar variant vs state; screenshots of the blocks sheet sections, every phone and tablet state (light) and dark phone / tablet frames. **Not verified:** Flutter rendering (scroll, ripple, `url_launcher`), screen-reader output and focus traversal, RTL, 320 dp / 200 % zoom beyond ×1.3, Exo 2 tabular figures, pane scroll behaviour, Figma-side fidelity (first S13 / S14 import is step 12), whether the on-disk `.pen` matches Pencil's memory until the user saves.
**Verdict:** Approve
**Fixes applied:** all 5 MEDIUM (rows above) · **LOW left for user:** 4 (divider, chip edge inset, standalone column balance + stepper edge, 11 px labels).

## Review rounds

#### Round 1 — 2026-09-24
- **Frames shown:** S13 phone Populated / Chosen / Empty, Tablet-L list-detail (Populated, Chosen), Expanded, S14 phone (in-flow, standalone, closed), standalone Tablet-L, dark frames, the `/better-interface` report, the 576 → 552 correction and the 35 → 36 frame count.
- **User feedback:** "approve"
- **Changes made:** none requested.
- **Outcome:** approved

## Session log

| Time | Action | Result / node ids |
|---|---|---|
| 2026-09-24 | Kickoff | Read `00-index`, step 06 / 07 files and session log, PRD 03 / 04 / 05 / 06, `19-full-app-audit`. Three `AskUserQuestion` rounds (12 questions), all recommended options accepted; Expanded pane width corrected 576 → 552. Kickoff recorded in this file, `00-index.md` and `19-full-app-audit.md` before any Pencil edit |
| 2026-09-24 | Pre-flight | Read the `WorkshopCard`, `TsAppBar`, `TsChip`, `TsTextField`, `EmptyState`, stepper and footer masters, the S10 / S11 frame structures and the Pencil skill docs. Found: `TsAppBar / Type=Back` already exists; `WorkshopCard / Selected` already carries a check mark (conflicts with "Dipilih"); the S11 blocks sheet overlaps its dark copy |
| 2026-09-24 | Blocks sheet `u19Pl` | Sections in 6 `execute` calls: card slots + skeleton, `SearchBar` ×3, `FilterChipRow` ×3, `StaticMap` + `WorkshopPhoto`, info / map / services / address blocks, detail content, CTA bars + empty state, focus / pressed specimens, 6 notes (heights set from bounds). Dark copy `V0OLK` at y 14200 |
| 2026-09-24 | Flows – Tablet block moved | 51 root nodes (anchor + S05 / S10 / S11 tablet rows) +8,000 dp |
| 2026-09-24 | S13 / S14 phone | 4 + 2 stress S13 light frames, 4 dark; 5 + 2 stress S14 light, 3 dark. Found: an `ov` object spread into an `Insert` dropped the `Chosen Tag` override (fixed with `Update` on the ref); Loading grown to `fit_content` |
| 2026-09-24 | Tablet frames | S13 TP ×3 (+ dark), Expanded, TL ×4 (+ dark); S14 TP ×2 (+ dark), TL Loading (copy of the S13 TL Populated with the pane content and CTA bar `Replace`d), standalone TL (+ dark). Found + fixed: the S13 TL Empty frame was built 1380 wide (typo), corrected to 1280 |
| 2026-09-24 | Checks | Coverage 36 / 36; clipping: S13 Empty phone overflowed 34 dp → padding 4; raw hex 0; contrast 1,760 → 2,421 nodes 0 fails; targets ≥ 48 |
| 2026-09-24 | `/better-interface` | Six domain skills loaded; 5 MEDIUM + 4 LOW; the 5 MEDIUM fixed (`Preview Chevron`, notes, empty-state copy, park tokens, S14 `Chosen Tag`); re-run clipping / hex / contrast clean; verdict Approve |
| 2026-09-24 | Review gate + close | User approved ("approve"); 23 frames + 2 blocks sheets exported to `design/pencil/exports/step08/` (25 PNG + `INDEX.md`, verified with `ls`); session file `10-design-step08-s13-s14-bengkel.md`; tracker ✅; `00-index.md` canvas layout, Pencil facts, inventory updated |
| 2026-09-25 | Step 19 audit fix (F4) | S14 Loading frames `Tvg5J` `Qs5pN` `XfOX4` `qRLMi`: `WorkshopCtaBar` `Helper Row` enabled, "Memuat detail bengkel…"; 0 clip rows |
