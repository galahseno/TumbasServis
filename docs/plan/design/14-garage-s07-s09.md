# Step 14 — Garage: S07 Garasi Saya · S08 Tambah/Edit Motor · S09 Detail Motor

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-25 |
| **Priority** | P1 |
| **Owns screens** | S07, S08, S09 |
| **Owns components** | (screen-local): `TsAppBar / Type=Title, Actions=Add`, `VehicleSelectCard / Mode=Display, State=In Service` + `State=Loading`, `MotorPhotoField`, `MotorModelPicker` (Sheet / Modal) + `ModelRow` + `BrandHeader`, `MotorForm`, `MotorPreviewPane`, `MotorHero`, `ServiceHistoryRow` (Active / Past / Cancelled), `HistorySection`, `MotorDetails` (List / Grid), `FormErrorBanner` |
| **PRD refs** | [04 S07–S09](../../../prd/04-screens.md), [03 F5 / F2 entry](../../../prd/03-user-flows.md), [05 entities](../../../prd/05-data-model-mock.md), [06 S07–S09 rows](../../../prd/06-responsive-layout.md) |
| **Pen location** | Components sheet "Garage blocks" (x 36248, light y 8760, dark copy y 12380 or below); Flows rows `S07`, `S08`, `S09` (phone rows after the S04 phone rows, tablet rows below the S04 tablet rows) — exact ids in *Frame ids* at close |
| **Depends on** | Steps 02–05 (`AppShell`, `VehicleSelectCard`, silhouettes, `TsTextField`, `TsDialog`, `EmptyState`, `Skeleton`, `SheetHeader`), 06 (`AddMotorCard`, `TsDialog / Type=Confirm Save`), 07a (`System / Keyboard`), 08 (`SearchBar`, `WorkshopCtaBar`), 13 (`System / Keyboard Numeric`) |
| **Claude session** | `docs/claude-session/16-design-step14-garage.md` (written after approval) |

## Goal

Design motor management: the garage list / grid (with in-service status), the add / edit form with a searchable brand / model picker and live preview on tablet-landscape, and the motor detail with service history and the "Booking motor ini" entry into the P0 flow. Includes the delete confirmation and the blocked-delete dialog for a motor with an active booking, and closes step 06's open LOW (nickname length cap).

## Inputs

- `AppShell` (Garasi tab, Compact / Medium / Large), `VehicleSelectCard` (Display mode `YpI4T`, Compact In Service `qfgpi`), `Silhouette` Card / Hero, `EmptyState / Type=Garage` `s0oD2`, `Skeleton`, `TsTextField` (Default / Focused / Filled / Error + Counter and Suffix Icon slots), `TsButton`, `TsAppBar / Type=Back` / `Title, Actions=Bell`, `SheetHeader`, `SearchBar`, `TsDialog` (Confirm Destructive `FzAqC`, Blocked `w4zo6`, Confirm Save `tMRhF`), `UnitStatusBadge`, `SectionTitleRow`, `WorkshopCtaBar`, `CopySourceSheet / Layout=Modal` `bI28g` (modal pattern), `System / Keyboard` `Eov7k`, `System / Keyboard Numeric` `VDcFy`, `Illustration / Empty Search` `Myjen`, `TsSnackbar`.
- Fields (PRD 04 S08): nickname, brand / model picker (searchable), plate number, year (optional), photo (optional, silhouette if skipped).
- Rules: deleting a motor with an active booking is blocked ("Motor ini punya booking aktif"); cancel on a dirty form asks for confirmation; a motor in service cannot start a booking (S10 rule "Sedang dalam servis").

## Kickoff decisions (answered 2026-09-25, interview with the user)

Three `AskUserQuestion` rounds (12 questions). Every recommended option was accepted; in the extras question (multi-select) the user kept the three recommended extras and dropped the S07 5+ motors / long-name specimen.

| # | Topic | Decision |
|---|---|---|
| 1 | Demo moment | **After booking** (S05-consistent). S07 = Vario 125 (`AB 1234 XY`, Dikerjakan) · Beat 110 (`AB 5678 ZZ`, Dikerjakan) · PCX 160 (`AB 9012 QR`, Diperiksa) · Supra X 125 (`AB 3344 KL`, free). Vario / Beat / PCX = matic, Supra X = bebek. **S09 default = Beat 110 (in service)**; the free-motor frame = Supra X 125 |
| 2 | S07 add entry | **Amended at review (A8):** one add action at a time. Header "+" (icon button, semantics "Tambah motor") is the only add action while the garage has motors; **no add card in the list**, no FAB (it would collide with the glass `NavBar`). With an empty garage the "+" is hidden (title-only bar) and the empty-state CTA "Tambah motor" is the only add action. *(Kickoff answer was "header + and end card"; the user removed the double action.)* |
| 3 | Tablet grid card | **Reuse** the horizontal `VehicleSelectCard / Mode=Display` `fill_container` in 2-col (Tab-P) / 3-col (Tab-L). New master `Mode=Display, State=In Service` = Display + `UnitStatusBadge` (convention: every used combination is its own master). No vertical grid mode |
| 4 | S08 photo | 96 dp silhouette tile (follows the chosen model category, generic matic before a model is picked) + text button "Tambah foto" (label amended A1; helper starts "Opsional."). Camera / Galeri chooser, permission denied and the gradient placeholder are **annotations only**; no photo-filled frame |
| 5 | Model picker | Phone = **bottom sheet** (`SheetHeader` "Pilih model", `SearchBar`, sticky brand headers Honda / Yamaha / Suzuki, rows = model + category tag + cc). Tap a row = select + close; the open sheet shows a ✓ on the current model. Tablet = **centered modal 560**. Empty search = `Illustration / Empty Search` + "Model tidak ditemukan" (component-sheet specimen + annotation, not a screen frame) |
| 6 | Plate | Auto-uppercase + spacing as typed (`AB 1234 XY`: 1–2 letters, 1–4 digits, 0–3 letters). Error on blur / submit (S03 rule): "Format plat tidak valid. Contoh: AB 1234 XY"; second variant "Plat ini sudah ada di garasimu" (component-sheet specimen); typed value kept after an error |
| 7 | Year + nickname | Year = numeric `TsTextField` "Tahun (opsional)", hint `2015`, error "Tahun 1990–2026" (numeric keypad). Nickname max **20 chars** with a counter (`9/20`), prefilled from the model name once one is picked. Year + plate side by side on the wide form. Closes the step 06 LOW |
| 8 | S09 actions | App bar = back + `edit` icon button (semantics "Ubah motor"). Primary CTA "Booking motor ini" under the hero; **disabled with reason** when in service ("Sedang dalam servis") + ghost link "Lacak servis" → S20. "Hapus motor" = **danger ghost button at the very bottom** (enabled even when in service → Blocked dialog). Tab-L: hero + CTA left, details + history right, delete at the end of the right column |
| 9 | History | "Riwayat servis": **active row** (→ S20) + **3 latest past rows** + "Lihat semua" → S19 pre-filtered to this motor (semantics "Lihat semua riwayat Beat 110"). Empty sub-state: "Belum ada riwayat servis" / "Booking pertama motor ini akan muncul di sini." (no illustration) |
| 10 | S08 save | Flat sticky footer "Simpan" ("Simpan perubahan" in edit), **always enabled**, validate on blur / submit. App bar back + title "Tambah motor" / "Ubah motor". Back on a dirty form → dirty-cancel dialog ("Buang perubahan?", "Buang" / "Lanjut mengisi", non-destructive like the booking-exit dialog). Saving = loading button + disabled form; save error = inline banner + "Coba lagi" |
| 11 | Extras | + S08 keyboard-open (phone light), + S08 saving, + S08 save error. The "S09 free-motor variant" **is** the matrix's History-empty frame (Supra X 125: enabled CTA + empty history). Declined: S07 5+ motors / long-name specimen |
| 12 | Session | **One session, one review gate** (33 frames, like step 13) |

**Defaults applied without a question** (change at review if unwanted):

- Friendly **"kamu"** voice, sentence case (step 03 rule).
- S08 / S09 are pushed pages: **no `NavBar` / `NavRail`** (the shell is used only by S07, per the step 06 chrome rule); S08 back = the app-bar back arrow (no close icon).
- Tab-L S08 footer spans the form column (aligned to the form), Tab-P footer centered at 560.
- Dirty-cancel opens only when at least one field changed.
- Delete confirm copy: "Hapus Supra X 125?" / "Motor ini akan dihapus dari garasimu dan tidak bisa dikembalikan." with danger "Hapus" + "Batal".
- Outcomes (annotations): after save → S07 + snackbar "Motor ditambahkan" / "Perubahan disimpan"; after delete → S07 + "Motor dihapus"; entry from S10 inline → back to S10 with "Motor ditambahkan", **not** auto-selected (step 06 decision 8).
- Picker list = the 15 PRD models across the 3 brands. **Ninja 250** (sheet-only sport motor in S10) is not in the picker list and not in the S07 garage; noted for `motor_models.json` in step 19.
- Dark = default state per breakpoint (P1 rule), plus the S09 in-service state on the phone as in the matrix.

### Amended while building (2026-09-25)

| # | Topic | Change and why |
|---|---|---|
| A1 | Photo button copy | Label "Tambah foto (opsional)" → **"Tambah foto"**, "Opsional." moved to the start of the helper ("Opsional. Tanpa foto, kami pakai gambar bawaan sesuai jenis motor."). The full label overflowed the 216 dp text column at text ×1.3 (found by the throw-away stress copy) |
| A2 | S09 details card | New `MotorDetails` (List for phone / Tab-P, Grid for Tab-L): Merek · Model · Jenis · Kapasitas · Tahun (+ Plat nomor in Grid). PRD 06 "details" on Tab-L needed a real block; it sits between the hero and the history |
| A3 | S09 Tab-L delete link | "Hapus motor" is pinned at the **foot of the hero column** (left) instead of the end of the right column: details (224) + history (428) already fill the 688 dp viewport, the link would fall below the fold. The right column scrolls on its own |
| A4 | S09 Tab-P height | The frame is a full-scroll capture (800 × 1,356), taller than the 1,280 viewport, like the phone captures |
| A5 | History row layout | Status badge moved from the code line to the date line (`Date Row`): at text ×1.3 the code `TS-260929-0417-B` broke mid-code beside the badge; now the date wraps instead. Third variant `ServiceHistoryRow / State=Cancelled` (Dibatalkan badge) because a nested badge swap does not survive a `Move` |
| A6 | Validation frame data | Nickname is filled ("Motor harian", 12/20) so the frame shows exactly the two errors of the matrix (model empty, plate `AB12 34` invalid) |
| A7 | Retry button in the banner | `FormErrorBanner` action = Outline Compact with `danger-text` border + label (the neutral `border-control` measured 2.80 : 1 on the dark `danger-soft` banner) |
| A8 | S07 single add action (review round 1) | The end-of-list `AddMotorCard` was **removed** from all populated frames (phone, Tab-P, Tab-L, dark copies; the empty Grid Row 3 deleted on Tab-P, a spacer added on Tab-L). Empty frames now use the title-only `TsAppBar / Type=Title` `cGI0U` (no "+"), so the empty-state CTA is the only add action. Notes `G7myqr`, `x7Moly`, `U4urZY` updated. S05's "+" tile and S10's "Tambah motor lain" card are other screens and were not touched |

## Scope

### Frame matrix (33 frames)

Naming: `S0x <Screen> / <State> / <Phone|Tablet-Portrait|Tablet-Landscape>` (+ ` · Dark`). Phone screens = full-scroll captures `fit_content(800)` with status + gesture bar; tablets = fixed viewports without system bars.

| Screen · State | Phone | Ph·D | Tab-P | Tab-P·D | Tab-L | Tab-L·D |
|---|---|---|---|---|---|---|
| S07 Populated (4 motors, in-service badges, header "+") | ✔ | ✔ | ✔ 2-col | ✔ | ✔ 3-col | ✔ |
| S07 Empty (`EmptyState / Type=Garage`, title-only bar, no "+") | ✔ | | ✔ | | ✔ | |
| S07 Loading (real bar + nav, 3 skeleton cards) | ✔ | | | | | |
| S08 Add — default | ✔ | ✔ | ✔ centered 560 | ✔ | ✔ form + live preview | ✔ |
| S08 Edit — prefilled (Beat 110) | ✔ | | | | | |
| S08 Validation error (model + plate) | ✔ | | | | | |
| S08 Keyboard open (plate focused) — *extra* | ✔ | | | | | |
| S08 Saving — *extra* | ✔ | | | | | |
| S08 Save error — *extra* | ✔ | | | | | |
| S08 Model picker (sheet over Add default / modal over Tab-P Add) | ✔ | | ✔ modal | | | |
| S08 Dirty-cancel dialog | ✔ | | | | | |
| S09 Populated, in service (Beat 110; active + 3 past rows) | ✔ | ✔ | ✔ max 720 | ✔ | ✔ hero left / details right | ✔ |
| S09 History empty, free motor (Supra X 125, CTA enabled) | ✔ | | | | | |
| S09 Delete confirm (danger), on the Supra X frame | ✔ | | | | | |
| S09 Delete blocked (`TsDialog / Type=Blocked`, Beat 110) | ✔ | | | | | |

Count: S07 10 · S08 14 · S09 9 = **33**. Dialog / sheet frames = a `Copy` of the screen + a `scrim` overlay (literal size; update when the frame height changes), per step 06. Loading of the picker, empty search, photo chooser and network states are annotations / component-sheet specimens (P1 economy).

### Layout targets (PRD 06 + kickoff)

- **S07:** phone = 1-col list; Tab-P = 2-col grid (rail, content padding 24); Tab-L = 3-col grid. `TsAppBar / Type=Title, Actions=Add` (Populated, Loading); `TsAppBar / Type=Title` (Empty).
- **S08:** phone = full-width form, sticky footer; Tab-P = centered form max 560; Tab-L = form left (≤ 560) + `MotorPreviewPane` right (360).
- **S09:** phone = stacked (hero, CTA, details, history, delete link); Tab-P = stacked max 720 centered; Tab-L = hero + CTA left, details + history + delete right.

### Components built here

| Component | Notes |
|---|---|
| `TsAppBar / Type=Title, Actions=Add` | S07 bar: title "Garasi saya" + "+" icon button (mirror of `Actions=Bell` `l1UTf`) |
| `VehicleSelectCard / Mode=Display, State=In Service` · `State=Loading` | Display card + `UnitStatusBadge` (Regular) · skeleton card (mirror of `f0xBn1`) |
| `MotorPhotoField` | 96 dp silhouette tile + "Tambah foto" outline compact button + helper "Opsional. …" |
| `MotorModelPicker / Layout=Sheet` · `Layout=Modal` (+ `ModelRow` Default / Selected, `BrandHeader`, Empty Search specimen) | Search + grouped list; the modal adds a title row + close button |
| `MotorForm` (Phone / Wide) | Photo, nickname (counter), model select field (`TsTextField` + trailing `keyboard_arrow_down`, read-only), plate, year; error / focused via overrides |
| `MotorPreviewPane` | Tab-L: "Pratinjau" + a Display card instance + helper "Begini motormu tampil di Garasi dan saat booking." Empty preview = muted placeholders |
| `MotorHero` (State=Free · In Service) | Tonal hero silhouette (Hero size), nickname, plate, model · year, status badge; CTA block (primary, disabled reason line, "Lacak servis" link) |
| `ServiceHistoryRow` (State=Active · Past · Cancelled) | Code line, date line + `UnitStatusBadge` (compact), services summary (2 lines max), chevron. Active = `border-accent` |
| `MotorDetails` (Layout=List · Grid) | "Detail motor" title + key / value card; List = 5 rows (phone, Tab-P), Grid = 3 × 2 cells (Tab-L) |
| `FormErrorBanner` | `danger-soft` banner: icon + text + "Coba lagi" (outline compact, `danger-text`) |
| `HistorySection` (Populated · Empty) | `SectionTitleRow` "Riwayat servis" + "Lihat semua" + rows, or the empty note |
| Save footer | Reuse `WorkshopCtaBar` `w02XMN`; if it cannot hold "Simpan" + an error-banner slot, build `FormFooter` |
| Focus specimens | Step 09 method (wrapper, 2 dp `focus-ring`, radius = inner + 4) for every new interactive master |

### Demo content & copy notes

- **S07 garage:** the four motors above; badges Vario Dikerjakan, Beat Dikerjakan, PCX Diperiksa (same stages as S05), Supra X none.
- **S09 Beat 110 (Honda Beat 110 · Matic · 2021):** "Dikerjakan" badge, CTA disabled "Sedang dalam servis". History: active `TS-260929-0417-B` "Servis Berkala + Oli" · Sel, 29 Sep 2026 · 09.00 · Dikerjakan; past `TS-260910-0091` (the PRD 05 seed booking on `motor_002`) Servis Berkala + Oli · Selesai · Rp143.000; `TS-260714-0058` Servis Berkala · Selesai · Rp85.000; `TS-260502-0031` Ganti Ban · Dibatalkan. Weekdays are checked against demo today **Sen 28 Sep 2026** in a script before they are typed.
- **S09 Supra X 125 (Honda Supra X 125 · Bebek · 2018):** free, CTA enabled, history empty.
- **S08 Edit:** nickname "Beat 110", model Honda Beat 110, plate `AB 5678 ZZ`, year 2021. **Validation:** model empty, plate `AB12 34` invalid, nickname "Motor harian" (amended A6). **Keyboard:** plate focused on `System / Keyboard`.
- **Picker models (15):** Honda — Beat 110, Scoopy 110, Vario 125, PCX 160 (matic), Supra X 125 (bebek), CB150R (sport); Yamaha — Mio M3 125, NMAX 155 (matic), Jupiter Z1 115 (bebek), R15, MT-15 (sport); Suzuki — Address 110 (matic), Smash 115 (bebek), Satria F150, GSX-R150 (sport).
- **Copy:** S07 "Garasi saya"; S08 "Tambah motor" / "Ubah motor", labels "Nama panggilan", "Model motor" (placeholder "Pilih model"), "Plat nomor", "Tahun (opsional)"; S09 "Booking motor ini", "Sedang dalam servis", "Lacak servis", "Riwayat servis", "Lihat semua", "Hapus motor". Blocked dialog text already built in step 03 (Beat 110 / `TS-260929-0417`).

### Annotations to place

- S07: card → S09; header "+" → S08 (hidden while the garage is empty); the empty-state CTA is then the only add action → S08; save → S07 with snackbar; loading = skeleton, reduce-motion = no shimmer.
- S08: entry from S10 inline → back to S10 (snackbar, not auto-selected); photo chooser (Kamera / Galeri / Hapus foto) + permission denied → snackbar; picker empty search; plate rules + auto-format; nickname cap 20; keyboard: content scrolls above the keyboard, footer above the inset; back on a dirty form → dialog; motion: sheet 250 ms, `MediaQuery.disableAnimations` = fade only.
- S09: "Booking motor ini" → S10 with the motor pre-checked (F2 entry point); disabled reason + "Lacak servis" → S20; active row → S20, past rows → S20 / S23, "Lihat semua" → S19 filtered; edit → S08 edit; delete → confirm → S07 + "Motor dihapus", blocked when an active booking exists.
- Semantics: icon-only controls carry labels ("Tambah motor", "Ubah motor", "Tutup", "Kembali"); history rows announce code + status; hero image is decorative.

## Checklist

### Build
- [x] Kickoff questions answered (12) and recorded above; build amendments A1–A7 recorded.
- [x] "Garage blocks" sheet built (light `SBuRW` + dark copy `IBIwQ`): 23 masters + Empty Search specimen + focus specimens (`+` button, photo button, `ModelRow`, `ServiceHistoryRow`, `Lacak servis`, `Hapus motor`).
- [x] All 33 matrix frames built; dark copies built (see *Frame ids*).
- [x] Delete dialog uses danger styling with a de-emphasized cancel (ghost "Batal"); blocked dialog is informational (`TsDialog / Type=Blocked`, no danger action); dirty-cancel is non-destructive (primary "Lanjut mengisi").
- [x] Model picker search + empty-search result annotated (component-sheet specimen `QhGyS` + note `hgetc`); plate + year error copy shown (validation frame `g1HWRH`, note `wtn97`).
- [x] Silhouettes reused from step 04 (no new art); statuses shown by badge text + icon, errors by border + icon + text.
- [x] Every PRD entry point annotated: S05 strip → S09, "+" → S08, S10 empty / add card → S08 → back, S09 CTA → S10, delete → S07 (notes `mKbc9` `XLcGW` `hJcRT`).

### Quality (automated, run in `execute`)
- [x] Clipping check on every step frame + both sheets → zero `problems` (35 roots, `resolveInstances:true`, disabled chains and scroll viewports exempt).
- [x] Raw-hex audit (plain `Get`) → zero on 539 nodes.
- [x] Every node named (17 unnamed `rectangle`s are the step 03 `Illustration / Empty Garage` internals, exempt); instances only; `placeholder` cleared on all 35 roots; unnamed refs after both dark sheet copies renamed (22 + 23).
- [x] Coverage: 33 frame names match the matrix (see *Frame ids*); 53 step 14 roots = 33 frames + 2 sheets + 12 row headers + 6 note frames.
- [x] Contrast audit (resolved values, ancestors composited): 1,580 text + icon nodes (S07 284, S08 358, S09 356, sheets 582), 0 failures; the only rows were the `TsLogo` monogram (3.45 : 1, logotype, exempt). Text < 12 sp: 0 of 869.
- [x] Wrap test at 360 dp (only intended multi-line helpers / bodies wrap) and on throw-away ×1.3 copies of S07 Populated, S08 Validation, S09 Populated: found the photo-button overflow (A1) and the history-code break (A5), both fixed; all 3 copies deleted.

### /better-interface
- [x] Run `/better-interface` with scope = all S07–S09 frames + the Garage blocks sheets.
- [x] Report recorded below; HIGH / MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [x] Status set to 🔵; user shown: garage list / grid + empty + loading, add form + picker + dirty dialog, edit + validation + keyboard + saving / error, detail + history, both S09 dialogs, Tablet-L splits, dark.
- [x] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [x] PNG export to `design/pencil/exports/step14/` + `INDEX.md` (`nodeId | frame name`): 33 frames, 2 sheets in `components/`, verified with `ls`.
- [x] Claude session file written (`docs/claude-session/16-design-step14-garage.md`).
- [x] Tracker set to ✅; "Verified in step 14" facts and the "After step 14" canvas paragraph added to `00-index.md`; PRD items collected in `19-full-app-audit.md`.

## /better-interface report

**Scope:** 33 frames (ids in *Frame ids*) + `Components / Garage Blocks` `SBuRW` and its dark copy `IBIwQ` · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens · **Convention docs found:** 00-index.md, prd/02, prd/06 (no source files: locations are frame name + node id)

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | Focus specimens for every new interactive master, 48 dp targets (bar `+`, edit, rows 56 / 86, buttons 48), semantics + focus-order notes, motion + reduced-motion notes, disabled-with-reason CTA, error = border + icon + text, dialogs (confirm / blocked / dirty) | 3 MEDIUM (notes, fixed), 1 LOW |
| Layout | 33 frames × 3 breakpoints, Tab-L splits (form + preview, hero + details), fold / scroll cues (picker rows cut at the edge), Tab-P full-scroll capture, ×1.3 copies, edge margins | 1 LOW |
| Writing | All strings against PRD voice ("kamu", sentence case), verb-first CTAs (Simpan, Booking motor ini, Lacak servis, Hapus motor, Coba lagi), dialog copy, errors state the fix, placeholders vs helpers | 1 LOW |
| Typography | Type-token bindings, sizes ≥ 12 sp (0 of 869 below), wrapping of codes / dates / helpers at ×1.3, counter | 1 LOW |
| Color | 1,580 measured text + icon pairs incl. dark, banner action border pairs in both themes, status colours by meaning (danger only on destructive / error, warning on the blocked dialog) | 1 MEDIUM (fixed) |
| UI | Radii (focus wrappers = inner + 4), silhouette tile scale, sheet / modal surfaces and shadows, icon weights, motion notes | 1 LOW |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| MEDIUM | Accessibility | S08 picker: `S08 Tambah Motor / Model Picker / Phone` `Q6vvJ`, `… / Tablet-Portrait` `rUYPd`; masters `MotorModelPicker` `fqsai` `T5Crx` (close `WfrrK`); note `hgetc` | Notes said nothing about focus containment, Escape, focus return or names for the icon-only close and the search field | Note extended: focus moves to the search field and stays inside (background inert), Escape or "Tutup" closes and returns focus to the Model field, rows announce name, brand, category, cc and "terpilih" **[applied]** | An overlay without focus handling and an unnamed icon-only control lose keyboard / switch users on tablets |
| MEDIUM | Accessibility | S09 in service: `MotorHero (In Service)` `c1UQ2`; frames `O0lY6` `GfuPI` `ciJyW` `pPiuX` `V4fBI` `u4eYR` `XBYpO`; note `dxjF2` | Disabled "Booking motor ini" with the reason only in a neighbouring text row; no focus order | Note: one semantics node "Booking motor ini, tidak tersedia. Sedang dalam servis" (enabled false + hint) and the order back → edit → CTA → Lacak servis → Lihat semua → rows → Hapus motor **[applied]** | A disabled control leaves the focus order, so the reason is easy to miss for screen-reader users |
| MEDIUM | Accessibility | S08 errors: `S08 Tambah Motor / Validation Error / Phone` `g1HWRH`, `Save Error` `IKI11`; note `wtn97` | Errors sit next to their fields, but nothing said where focus goes on submit or that the banner is announced | Note: focus moves to the first invalid field (nickname → model → plate → year) with the error read after the label; banner = polite live region that stays until dismissed **[applied]** | Errors that appear silently do not reach non-visual users; unspecified focus after a failed submit |
| MEDIUM | Color | `FormErrorBanner` `AvZWn` › `Retry Button` `IM6vw`; frame `IKI11`; dark sheet `IBIwQ` | Outline button border `border-control` on `danger-soft`: light 3.31 : 1, **dark 2.80 : 1** (< 3 : 1) | Border + label `danger-text` (dark 5.06 : 1, light ≥ 4.5 : 1) via instance override **[applied]** | The boundary of the only recovery control fell under the 3 : 1 UI minimum in dark mode |
| LOW | Typography | Nickname counter "9/20" in `MotorForm` `i0syzS` `Ff98t` (S08 frames `jtZ2L` `HMK87` `BVIYA` …) | Proportional figures shift while typing | Flutter: `FontFeature.tabularFigures()` on the counter **[left]** | Changing numbers should not move the text beside them |
| LOW | Layout | `HistorySection` `OjRQ6` › `History Rows` `GK4My` (gap 8) vs the S07 garage list `y4ful` (gap 12) | Adjacent bordered, tappable rows 8 dp apart | Gap 12 like the garage cards **[left]** (matches the step 10 accordions, decide with the list-gap rule in step 19) | Adjacent bordered controls read as one block below 12 dp |
| LOW | UI | `MotorHero` Hero Tile (Tab-P `SQXFq` 720 × 168, Tab-L `FyN8U` 400 × 168, phone `Uhj75`) | 96 dp silhouette tile in a wide tonal panel reads sparse | Larger silhouette size or a shorter panel **[left]**; `Silhouette / Size=Hero` is the largest step 04 art | Wide panels look unfinished next to dense content |
| LOW | Writing | Plate helper "Contoh: AB 1234 XY" in `MotorForm` (`b6bck`, `y556tN`) | Repeats the field's own placeholder `AB 1234 XY` | Helper states the rule: "1–2 huruf, 1–4 angka, 0–3 huruf" **[left]** | Two copies of the same example; the rule is not stated |
| LOW | Accessibility | S07 loading `S07 Garasi Saya / Loading / Phone` `u6ZHN`; note `x7Moly` | Skeleton state has no announcement | Polite live region "Memuat garasi" **[left]** | Non-visual users get no sign of loading |

**Pre-existing (not in the cap or the verdict):** `focus-ring` (orange-500) on `accent-soft` measures 2.93 : 1 (light), open since step 13 → token fix in step 19; it would apply to a focus ring drawn on the Selected `ModelRow` `CtsnV`, which the specimens avoid by wrapping the row.

**Verification:** Passed — clipping (35 roots, 0 rows), raw hex (539 nodes, 0), naming / placeholders (0 unnamed outside the step 03 art, 0 placeholders), contrast (1,580 pairs, 0 failures; banner pair remeasured after the fix), text < 12 sp (0 / 869), wrap test at 360 dp, ×1.3 on 3 frames (2 defects found and fixed, copies deleted, 0 `TMP` roots left), screenshots of every state family (S07 ×3 + tablets + dark, S08 ×9 + tablets + dark, S09 ×5 + tablets + dark, both sheets). **Not verified:** real screen-reader / switch-access order and focus trap (annotations only), Flutter behaviour (sheet motion, keyboard inset, live regions, tabular figures), 360 × 640 small phone and ×1.3 on tablets (not required for P1), S07 with 5+ motors and the photo chooser sheet (annotation-only by decision).
**Verdict:** Approve
**Fixes applied:** 3 MEDIUM accessibility notes (`hgetc` `dxjF2` `wtn97`), 1 MEDIUM color (`IM6vw`), plus pre-review fixes A1 (photo label overflow), A5 (history code break, `Cancelled` master), and the ×1.3 checks · **LOW left for user:** tabular counter, history gap 8 vs 12, sparse hero panel on wide layouts, plate helper copy, loading announcement

### Frame ids

| Screen | Frames (node ids) |
|---|---|
| S07 | Populated: Phone `TaiEw` · Ph·D `zCHnt` · Tab-P `ZjgEf` · Tab-P·D `D0ioee` · Tab-L `CidYO` · Tab-L·D `nN1SW`; Empty: Phone `V09FO` · Tab-P `ezIWd` · Tab-L `xFXT3`; Loading `u6ZHN` |
| S08 | Add Default: Phone `jtZ2L` · Ph·D `vwL5A` · Tab-P `wD46I` · Tab-P·D `weMlK` · Tab-L `s694Q` · Tab-L·D `jNoW2`; Edit `HMK87`; Validation `g1HWRH`; Keyboard `BVIYA`; Saving `wmIFb`; Save Error `IKI11`; Model Picker Phone `Q6vvJ` · Tab-P `rUYPd`; Dirty Cancel `v99rZ` |
| S09 | Populated In Service: Phone `O0lY6` · Ph·D `GfuPI` · Tab-P `ciJyW` · Tab-P·D `pPiuX` · Tab-L `V4fBI` · Tab-L·D `u4eYR`; History Empty Free Motor `l1yXNH`; Delete Confirm `BiKY3`; Delete Blocked `XBYpO` |
| Sheets | `Components / Garage Blocks` `SBuRW` (x 36248, y 8760, 1200 × 4270) · dark `IBIwQ` (y 13,270) |
| Notes | `mKbc9` `XLcGW` `hJcRT` (phone rows) · `BRKOr` `gomHv` `hBgQk` (tablet rows) |
| Masters | bar `BKRlA` · Display In Service `UhAP2` / Loading `k3jw5` · `MotorPhotoField` `BRgLV` · `MotorPreviewPane` `oiXce` · `FormErrorBanner` `AvZWn` · `MotorForm` Phone `i0syzS` / Wide `Ff98t` · `ModelRow` `c5bfE` `CtsnV` · `BrandHeader` `Vqbe4` · picker Sheet `fqsai` / Empty Search `QhGyS` / Modal `T5Crx` · `MotorHero` In Service `c1UQ2` / Free `QIpGL` · `ServiceHistoryRow` Active `yMLFH` / Past `k5ZNI` / Cancelled `GyB0D` · `HistorySection` Populated `OjRQ6` / Empty `t1wqP7` · `MotorDetails` List `pdf17` / Grid `hMzhj` |

Canvas: the Flows – Tablet block moved down 9,500 dp (anchor `URsZs` y 68,500). Phone rows: S07 header y 58,600 (frames y 58,786; dark header y 59,800, frames y 59,986), S08 y 61,000 (frames y 61,186, notes x 3520; dark y 62,200 / 62,386), S09 y 63,600 (frames y 63,786, notes x 1760; dark y 65,600 / 65,786). Tablet rows below the S04 tablet rows: S07 Tab-P y 117,200 (frames y 117,386), S08 Tab-P y 118,900 (frames y 119,086), S09 Tab-P y 120,600 (frames y 120,786), S07 Tab-L y 122,300 (frames y 122,486, notes x 4080), S08 Tab-L y 123,500 (frames y 123,686, notes x 2720), S09 Tab-L y 124,700 (frames y 124,886, notes x 2720).

## Review rounds

#### Round 1 — 2026-09-25
- **Frames shown:** all 33 frames (S07 list / grid / empty / loading, S08 form + picker + dialogs + states, S09 detail + dialogs, Tablet-L splits, dark), the Garage blocks sheet, the `/better-interface` report and the 5 LOW items.
- **User feedback:** "i don't want double action for "tambah motor", remove the action in the motor list, keep the plus in topbar, but if the list empty only display "tambah motor" in empty state (the one in topbar is hide when empty) — after this approve and do the rest"
- **Changes made:** A8: end-of-list `AddMotorCard` removed from the six populated S07 frames; the three empty S07 frames use the title-only app bar (no "+"); S07 notes updated; clipping re-checked (0 rows) and screenshots re-taken; PNGs exported after the change.
- **Outcome:** approved (with the change above applied)


## Session log

| Time | Action | Result / node ids |
|---|---|---|
| 2026-09-25 | Kickoff interview | 3 `AskUserQuestion` rounds, 12 decisions recorded above; plan approved; step file + `00-index.md` updated, status 🟡 |
| 2026-09-25 | Canvas prep | Flows – Tablet block (148 root nodes, y ≥ 58,900) moved down 9,500 dp (anchor `URsZs` y 68,500) for the new phone rows |
| 2026-09-25 | Garage blocks sheet | `SBuRW` (masters, Empty Search specimen, focus specimens); `MotorDetails` and `ServiceHistoryRow / State=Cancelled` added while building S09 |
| 2026-09-25 | S07 | 10 frames (phone ×3 + dark, Tab-P ×2 + dark, Tab-L ×2 + dark); found: a card with `fill_container` height beside a 1 dp spacer collapsed, fixed with `fit_content` |
| 2026-09-25 | S08 | 14 frames; picker sheet / modal over Copy + `scrim`; dirty dialog from `TsDialog / Type=Confirm Save`; keyboard frame = clipped viewport + `System / Keyboard` |
| 2026-09-25 | S09 | 9 frames; delete confirm on the Supra X frame, blocked on Beat; Tab-L delete moved to the hero column (A3); Tab-P full-scroll capture 800 × 1,356 (A4) |
| 2026-09-25 | Self-check | Clipping 0, raw hex 0, contrast 1,580 nodes 0 failures, text < 12 sp 0; ×1.3 copies found the photo-button overflow and the history-code break, both fixed, copies deleted |
| 2026-09-25 | `/better-interface` | 3 MEDIUM accessibility notes + 1 MEDIUM color fixed, 5 LOW left; dark sheet re-copied (`IBIwQ`, 23 unnamed refs renamed); verdict `Approve` |
| 2026-09-25 | Review gate | Status 🔵; frame list handed to the user |
| 2026-09-25 | Review round 1 | User asked for a single add action (A8): add card removed from 6 populated frames, empty frames use a title-only bar (`cGI0U`), notes updated, clipping 0 rows, approved |
| 2026-09-25 | Approval + close | 33 PNG exported to `design/pencil/exports/step14/` (+ 2 sheets in `components/`) with `INDEX.md`, verified with `ls`; session file `16-design-step14-garage.md`; tracker ✅; PRD items → `19-full-app-audit.md`; `00-index.md` Pencil facts + canvas paragraph |
| 2026-09-25 | Step 19 audit fix (F11) | S09 handoff wrapper `hJcRT` (now vertical): MOTION note `f6dxl9` (dialogs 150 ms, route 250 ms, `disableAnimations` = instant) |
