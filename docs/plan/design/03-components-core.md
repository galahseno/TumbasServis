# Step 03 — Core components (inputs, chrome, feedback)

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-24 |
| **Priority** | — (foundation for all screens) |
| **Owns screens** | — |
| **Owns components** | `TsButton`, `TsTextField`, `TsChip`, `TsAppBar`, `SheetHeader`, `NavBar` / `NavRail`, `EmptyState`, `ErrorState`, `Skeleton`, `UnitStatusBadge` (+ added: `TsDialog`, `TsSnackbar`, `TsIconButton`) |
| **PRD refs** | [02](../../../prd/02-brand-design-system.md) (component inventory, glass, status colors, motion), [04](../../../prd/04-screens.md) (global patterns), [06](../../../prd/06-responsive-layout.md) (nav pattern per window class, 48dp targets) |
| **Pen location** | `02 Components` row → Core group; illustrations appended to the same group |
| **Depends on** | Steps 01, 02 |
| **Claude session** | `docs/claude-session/05-design-step03-components-core.md` (written after approval) |

## Goal

Build the shared building blocks every screen uses, with all states the PRD lists, on tokens only, and the empty/error/success illustrations (`Generate svg`, palette-constrained). Add the three widgets the PRD's inventory omits: the two global-pattern widgets (`TsDialog`, `TsSnackbar`) and `TsIconButton` (back, close, bell, dismiss, clear).

## Inputs

- PRD 02 inventory rows for each component; PRD 04 "Global patterns" (confirm-destructive dialog, snackbars, bottom sheets, keyboard handling).
- Step 02 tokens (incl. `accent-fill`, `border-control`, `*-text` / `*-soft`, `focus-ring`, `glass-tint-strong`).
- Illustration style approved in step 01 (`Illustration / Empty Garage` `eWWX8`).

## Kickoff decisions (answered 2026-09-24, interview with the user; every recommended option accepted)

Measured with the resolved hexes (WCAG relative luminance) before asking; the new tokens below all meet their target.

| # | Question | Answer |
|---|---|---|
| 1 | Variant modeling | Reusable masters only for the states screens use (`default`, `disabled`, `loading`); `pressed` and `focused` are sheet instances with overrides |
| 2 | NavBar glass | Glass only on the compact bottom bar, using **`glass-tint-strong`** (80 %, ≥ 5.2 : 1 over any backdrop; content always scrolls under the bar). The 42 % tint stays for `StickyEstimateBar` (step 04). `NavRail` and `TsAppBar` are flat |
| 3 | Nav labels / icons | New role **Label Medium 12 / 16 · 600 · +0.3** (`type-label-md-*`, `Type / Label Medium` `LqAAP`) for nav bar + rail labels; badges keep Label Small 11. Icons `home` `history` `two_wheeler` `person`. Active = `accent-soft` pill + icon weight 700 in `text-on-accent-soft` + label `text-heading` (inactive label `text-body`; never `text-muted` on glass) |
| 4 | Skeleton | Generic blocks (line / block / avatar / card) composed per screen; static shimmer specimen + motion note |
| 5 | Dialog width | Phone 24dp side margins; tablet centered, max-width 560 |
| 6 | Illustrations in dark | Light "sticker" tile: art unchanged (palette-snapped), tile `$sand-100` + `illustration-outline` 1px; palette-snap on every generation |
| 7 | `danger` vs `accent` hue | Keep the site hues. Two danger types: **`Danger`** (solid `danger-fill`, only as the confirm button inside `TsDialog`) and **`Danger Outline`** (transparent + 1px `danger` border + `danger-text` + icon, for on-screen triggers such as "Batalkan booking" / "Hapus motor"). Always icon + explicit label + confirm dialog. No solid red ever sits next to the orange primary |
| 8 | Secondary / outline / ghost | Secondary = tonal (`accent-soft` + `text-on-accent-soft`); Outline = transparent + `border-control` + `text-heading` (pressed = `border-accent`); Ghost = `text-accent` (pressed = `accent-soft` + `text-on-accent-soft`) |
| 9 | `TsTextField` label | Static label above (Label Large, `text-heading`), 48dp box, placeholder `text-muted`, helper / error below |
| 10 | `TsChip` | Unselected: transparent + `border-control` + `text-body`. Selected: `accent-soft` + 1px `border-accent` + `text-on-accent-soft` + leading `check`. Label **Label Large 14** (PRD said Label Small 11 for chips); 32dp visual inside a 48dp target |
| 11 | `TsSnackbar` | Inverse surface (M3 `inverseSurface`): bar `surface-inverse`, text `text-on-inverse`, action `accent-on-inverse` |
| 12 | Icon-only buttons | New component **`TsIconButton`** (Style Standard / Tonal × Default / Disabled, 48×48 target, 24 icon, badge slot) |
| 13 | Other defaults | `TsAppBar` flat `bg-page`; button loading = `progress_activity` spinner replaces the label, width held; compact button 40dp visual inside a 48dp target; snackbar phone full width − 16dp, 12dp above the nav bar, tablet bottom-center max 560; every sheet gets a `· Dark` themed copy |
| — | Step 02 PNGs missing on disk | The user moved them; nothing to do. Step 03 exports are verified with `ls` at close |

### Tokens added at kickoff (145 variables total: 134 + 8 color + 3 number)

| Token | Light | Dark | Measured |
|---|---|---|---|
| `danger-fill` | `red-700` `#CC291F` | `red-300` `#E76861` | label 5.38 / 5.90 : 1 |
| `text-on-danger` | `sand-0` | `#1A0E07` | — |
| `surface-inverse` | `sand-900` | `sand-100` | — |
| `text-on-inverse` | `sand-50` | `sand-900` | 17.10 / 15.84 : 1 |
| `accent-on-inverse` | `orange-300` | `orange-700` | 9.87 / 5.06 : 1 |
| `skeleton-base` | `sand-200` | `#282422` | decorative (1.2 : 1 on page / card) |
| `skeleton-highlight` | `sand-0` | `#363130` | shimmer band |
| `illustration-outline` | `#1A171614` | `#FFFFFF1A` | decorative |
| `type-label-md-size / -lh / -tracking` | 12 / 1.3333 / 0.3 | — | — |

Other measurements: `Danger Outline` border `danger` on page / card 3.49 / 3.64 (light), 5.29 / 4.95 (dark); chip selected border `border-accent` 3.31 (light) / 8.00 (dark); strong glass: `text-body` over `sand-900` 6.76, over orange-500 8.21 (light), over orange-400 6.90 (dark).

## Scope

### Components and their variants

| Component | Variants / states to design |
|---|---|
| `TsButton` | Type: primary (fill `accent-fill`, `shadow-accent` only on the primary booking CTA) / secondary (tonal) / outline / ghost / danger (solid, dialog confirm only) / danger-outline × State: default / pressed / focused / disabled / loading; sizes: standard (48dp tall), compact (40dp visual in a 48dp target); optional leading icon; full-width and hug |
| `TsIconButton` (added) | Style standard / tonal × default / pressed / focused / disabled; 48×48 target, 24 icon; optional unread badge (bell) |
| `TsTextField` | default / focused / filled / error (message + icon, not color alone) / disabled; optional prefix (`+62` phone), suffix icon, helper text, multiline with character counter (S11 complaint, 250 max) |
| `TsChip` | filter chip: unselected / selected / disabled; optional leading icon, count badge; preset "keluhan" chip; 48dp hit area around the visual chip |
| `TsAppBar` | with/without back, with/without actions, title-only, large title variant; notification bell with unread badge; collapses cleanly at 360 |
| `SheetHeader` | drag handle + title + close; with/without subtitle |
| `NavBar` | glass bottom bar (4 items, active pill highlight, weight 700 icon, strong tint), inset 16dp sides / 12dp above bottom, capsule ends |
| `NavRail` | medium (icons + short labels) and large/extended (icons + labels), with leading `TsLogo`, active indicator |
| `EmptyState` | illustration slot + title + body + optional CTA; variants: garage, riwayat, notifikasi, katalog-filter |
| `ErrorState` | illustration + message + "Coba lagi" retry; inline (card) and full-page variants |
| `Skeleton` | shimmer building blocks: line, block, avatar, card; shimmer motion note |
| `UnitStatusBadge` | 7 statuses (Terjadwal, Check-in/Antre, Diperiksa, Dikerjakan, QC, Selesai, Dibatalkan) per PRD 02 colors; **tinted bg + accessible text + status icon**, never color alone; compact + regular sizes |
| `TsDialog` (added) | Confirm-destructive (danger confirm, cancel de-emphasized), info dialog, dialog with choice list (S22 scope), blocked-action dialog ("Motor ini punya booking aktif") |
| `TsSnackbar` (added) | success / info / error, optional action ("Batalkan"/"Coba lagi"), inverse surface, sits above the nav bar |

### Illustrations (generated SVG → reusable components)

| Illustration | Used by |
|---|---|
| Empty garage (exists: `eWWX8`) | S07, S10 |
| No bookings | S19 |
| No notifications | S06 |
| Error / offline | ErrorState |
| Empty filter result (search) | S12, S13 |

Budget: 5 here (1 exists, 4 to generate); every one generated once with palette hexes in the prompt, palette-snapped, then reused on a sticker tile.

### Spec sheets to include

- Component sheet per family with each variant labelled, light + dark.
- Touch-target overlay note: 48×48 hit area on chips/checkbox-like items whose visuals are smaller.
- Motion notes: chip select 150ms ease-out, button press 150ms, snackbar enter 250ms, skeleton shimmer loop, reduce-motion = static.

### Annotations to place

- `Semantics` labels for the bell, back, close, retry icon buttons.
- Keyboard/focus order note for `TsTextField` and `TsButton` on tablet.
- Glass budget note on `NavBar`.
- Foundations rules to apply here (step 02): a visible `focus-ring` state on `TsButton`, `TsTextField`, `TsChip`, list rows and nav items (2 dp, offset 2); bordered controls never use `surface-hover` / `accent-soft` as their fill (press = `border-accent`); `text-accent` never on `surface-inset` / `surface-hover`; text on glass only `text-heading` / `text-body`; tabular figures on the estimate total and OTP countdown (verify Exo 2 `tnum`); theme switch instant.

## Built sheets (node ids, `design/pencil/TumbasServis.pen`)

Components row: anchor `m5khVn` y 8400; light sheets y 8760 (x 0 / 1360 / 2720 / 4080 / 5440 / 6800), dark header `AEaD0` y 12240, dark copies y 12380 (`… · Dark`, `theme:{mode:"dark"}`). Flows anchors moved to y 16000 (`OwQde`) and 18400 (`URsZs`). 148 variables (134 + 8 color + 3 type + `state-pressed`, `accent-pressed`, `danger-pressed`). 100 reusable masters.

| Sheet | Light | Dark copy | Masters |
|---|---|---|---|
| Buttons | `u46xe` | `gbgGW` | `TsButton` 22 (6 types × default / disabled / loading = 18, compact 4), `TsIconButton` 4 |
| Inputs | `rd8CS` | `K7CGG` | `TsTextField` 8 (single ×5, multiline ×3), `TsChip` 3 |
| Status & Feedback | `d8teOe` | `AQWtW` | `UnitStatusBadge` 14 (7 × 2 sizes), `TsSnackbar` 4, `TsDialog` 4, `Dialog Choice Row` 2 |
| Navigation | `tBuEd` | `G2PUQZ` | `TsAppBar` 4, `SheetHeader` 2, `NavBar Item` 2, `NavBar` 4, `NavRail Item` 4, `NavRail` 8 |
| States | `WG7ja` | `K4clk` | `EmptyState` 4, `ErrorState` 2, `Skeleton` 4 |
| Illustrations | `fnfFf` | `qjKJn` | `Illustration /` 5: Empty Garage `eWWX8`, No Bookings `Qy9CB`, No Notifications `eorqH`, Error Offline `JU8tB`, Empty Search `Myjen` (fixed light sticker tile `$sand-100` + `illustration-outline`; palette-snapped, max RGB shift 28, 0 skipped) |

Build decisions made while building (all inside the kickoff decisions unless marked):
- **Pressed states.** Filled types (Primary, Danger) press to `accent-pressed` / `danger-pressed` fills (new tokens; an overlay layer failed: tonal fills drop to 3.8–4.1 : 1); Secondary and Outline press to a `border-accent` border, Ghost to `accent-soft`. `state-pressed` (sand-900 @ 10 % / white @ 12 %) is only the `TsIconButton` state layer.
- **Loading button.** Spinner replaces the label in a master with a fixed width 120 (absolute `fill_container` layers collapse hug parents in Pencil); instances override the width.
- **Focus ring.** `TsButton` = ring wrapper (padding 4, radius 16 = 12 + 4); `TsChip` = `Focus Ring Frame` inside the 48 dp target; `TsIconButton` = built-in 48 dp ring; `TsTextField`, `NavBar` / `NavRail` items and `Dialog Choice Row` = the 2 dp `focus-ring` border on the control itself (offset 0, deliberate exception to the Step 02 offset rule; the border is the indicator); `TsSnackbar` action = 2 dp `accent-on-inverse` ring (`focus-ring` is only 2.14 : 1 on the dark-mode inverse surface).
- **Compact button / chip** = a transparent 48 dp outer frame around a 40 / 32 dp `Visual`, so every instance keeps the 48 dp target.
- **Copy = sentence case** (buttons, chips, titles; proper nouns and service names keep their case). Recorded in `prd/02`; PRD 04 wireframe copy is aligned in step 19.
- **Nav rail item** and **NavBar** height come from padding (no fixed height), so text scale 1.3 grows them.

## Checklist

### Build
- [x] Kickoff questions answered and variant-modeling convention recorded (unchanged from the index).
- [x] Tokens + `Type / Label Medium` created (148 variables).
- [x] `TsButton` all types and states built; solid `danger` used only in `TsDialog`; `TsIconButton` built.
- [x] `TsTextField` all states, prefix/suffix, multiline + counter.
- [x] `TsChip`, `TsAppBar`, `SheetHeader` built.
- [x] `NavBar` (glass, strong tint) and `NavRail` (medium + large) built; active states clear without color alone.
- [x] `UnitStatusBadge` all 7 statuses × 2 sizes, light + dark, with icon + label.
- [x] `EmptyState`, `ErrorState`, `Skeleton` blocks built; 5 illustrations generated and componentized.
- [x] `TsDialog`, `TsSnackbar` built; PRD 02 inventory update noted for the user (step 19).
- [x] Every component exists in light and dark and resolves via tokens only.
- [x] Every interactive component verified ≥ 48×48 target.

### Quality (automated, run in `execute`)
- [x] Clipping check on every component sheet (12 frames, `enabled:false` subtrees and `Decor` shapes ignored) → zero `problems`.
- [x] Raw-hex audit → zero on 1,603 nodes (illustration internals included: all snapped to tokens).
- [x] Every node named (illustration internals exempt); 100 unnamed instance refs from the dark copies renamed `<master> (instance)`.
- [x] `placeholder` cleared on all finished frames, incl. the 4 generated illustration frames.
- [x] Contrast on resolved values: 650 text + 238 icon nodes, both themes, 0 fails (logo monogram, disabled masters and glass items excluded; glass measured separately: `text-body` over the strong tint ≥ 6.76 : 1).

### /better-interface
- [x] Run `/better-interface` with scope = Core component sheets (names + node ids).
- [x] Accessibility: focus/pressed states, semantics notes, target sizes, contrast per state. UI: radii concentric, glass budget, shadow use. Layout/Writing/Typography/Color as applicable.
- [x] Report recorded below; HIGH/MEDIUM fixed; verdict `Approve`.

### Review gate
- [x] Status set to 🔵; user shown: button + field sheets, nav (compact + rail), badges, dialog/snackbar, illustrations.
- [x] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [x] PNG exports to `design/pencil/exports/step03/` (12 sheets + `illustrations/` 5 + `INDEX.md`), verified on disk with `ls`.
- [x] Claude session file written: `docs/claude-session/05-design-step03-components-core.md`.
- [x] Tracker set to ✅; user reminded to add `TsDialog` / `TsSnackbar` / `TsIconButton` to `prd/02` (step 19).

## /better-interface report

**Scope:** six Core component sheets and their dark copies: Buttons `u46xe` / `gbgGW`, Inputs `rd8CS` / `K7CGG`, Status & Feedback `d8teOe` / `AQWtW`, Navigation `tBuEd` / `G2PUQZ`, States `WG7ja` / `K4clk`, Illustrations `fnfFf` / `qjKJn` · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens · **Convention docs found:** `00-index.md`, `prd/02`, `prd/06`, this step file (no other interface guidelines). The review itself was read-only; the fixes below were a separate, logged action.

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | Focus state per interactive master (button, icon button, field, chip, nav bar / rail item, choice row, snackbar action), 48 dp check on 47 interactive nodes (masters, `Field Box`, snackbar `Action`), contrast on 650 text + 238 icon nodes in both themes, Semantics notes, color-alone check (status, error, selected, nav), reduce-motion and toast / dialog behavior notes | 4 findings (1 HIGH, 1 MEDIUM, 2 LOW) |
| Layout | Clipping on 12 frames, target spacing, fixed heights against text scale ×1.3 (arithmetic), chip rows against the 328 dp phone column, dialog / snackbar widths, grouping gaps. 320 px / 200 % zoom and RTL: **Not reviewed, no screens yet** | 2 findings (MEDIUM) |
| Writing | All specimen copy: buttons, chips, titles, empty / error states, dialogs, snackbars, field helper and error text, capitalization policy, consequence in confirm labels | 3 findings (2 MEDIUM, 1 LOW) |
| Typography | Type roles used per component (Label Medium 12 nav, Label Large 14 buttons / chips, Label Small 11 badges), line-height on wrapped text, tabular figures note, truncation note | 1 finding (LOW, carried) |
| Color | Token roles (pressed, inverse, skeleton, danger fill), 32 measured pairs + focus rings, `danger` vs `accent` treatment, warning / danger meaning across states, dark inverse surface | 1 finding (LOW) |
| UI | Concentric radii (button ring 16 = 12 + 4, chip ring, dialog, capsule nav), glass budget (1 NavBar per phone), shadow vs border, icon weights, illustration tile outline, press feedback, motion durations (≤ 150 ms high-frequency) | 3 findings (LOW) |

| Severity | Domain | Location (sheet · node id) | Before | After | Why |
|---|---|---|---|---|---|
| HIGH | Accessibility | Status & Feedback `d8teOe` · `Dialog Choice Row` `B7Nlb9` `wfJe9`, snackbar `Action` slot (`ZOzTV` `y2xRX` `guXyz`); Navigation `tBuEd` · `NavRail Item` `r9A47O` `s7dJvy` `i3ZB2` `Kq5mg` | No focused state drawn for the rail items (specified only in a note), and none drawn or written for choice rows and the snackbar action | Focused specimens: choice row 2 dp `focus-ring` `MwRGG`; snackbar action 2 dp `accent-on-inverse` ring `yVYBu` (`focus-ring` is 2.14 : 1 on the dark inverse surface; `accent-on-inverse` is 9.87 / 5.06); rail Medium `BaNCx`, Large `aJHhi`; Note Focus (Navigation) updated **[applied]** | Keyboard-reachable controls without a visible focus indicator (tablet, hardware keyboard, switch access) |
| MEDIUM | Accessibility | Status & Feedback `d8teOe` (0 note nodes) | Masters only: no rule that error / action snackbars persist, no live-region role, no dialog focus trap / restore / Escape, no enter motion or reduce-motion fallback | Notes `Si8lP` (snackbar), `vyGfi` (dialog), `TaRnV` (badge semantics + motion) **[applied]** | A timed error toast disappears before it can be read or acted on; a dialog without focus rules strands keyboard users; motion without a fallback |
| MEDIUM | Layout | Navigation `tBuEd` · `NavBar / Active=*` `ZzYx7` `jAln5` `ew6qa` `Q8kTl`, `NavRail Item / Size=Large` `i3ZB2` `Kq5mg`; Status `d8teOe` · `Dialog Choice Row` `B7Nlb9` `wfJe9` | `height` fixed at 64 / 48 / 48 on text containers. At text ×1.3 the NavBar item needs 54.8 dp in a 50 dp slot; the choice label (220 dp wide) wraps to two lines (62 dp) in a 48 dp row | Height from padding (`fit_content`, padding [7,12] / [12,16] / [12,4]); still 64 / 48 / 48 at default. Buttons, chips and the field box keep 48 / 32 as minimums (note on the Buttons sheet) **[applied]** | "No fixed-height boxes around text" (PRD 06): a larger text scale clips or overflows the control |
| MEDIUM | Layout | Inputs `rd8CS` · `Keluhan Chip Row` `nuGzH` (616 dp), `Filter Chip Row` `zMpbA` (512 dp) | Rows wider than the 328 dp phone column with no wrap or scroll behavior | Chips section note: presets wrap (12 dp run spacing); filter chips scroll horizontally with the next chip peeking 16–32 dp **[applied]** | Chips reachable only past a scroll edge with no cue |
| MEDIUM | Writing | Buttons `u46xe` (`Lihat Detail`, `Ubah Jadwal`, `Konfirmasi Booking`, `Lihat Detail Bengkel`), States `WG7ja` (`Tambah Motor`, `Booking Servis`, `Hapus Filter`), Status `d8teOe` (`Lihat Booking`), Inputs `rd8CS` (`Kampas Rem`), Navigation `tBuEd` (`Pilih Motor`, `Ringkasan Booking`, `Ubah Jadwal`, `Detail Suku Cadang`) beside `Coba lagi`, `Lihat semua`, `Rem bunyi` | Title case and sentence case mixed within buttons, chips and titles | Sentence case everywhere (proper nouns and service names keep their case): 22 nodes changed on 5 sheets; policy in `prd/02` **[applied]** | One capitalization policy per element type; mixed casing reads as sloppiness |
| MEDIUM | Writing | Inputs `rd8CS` · single-line Error master `WmjM5` · `Error Text` | "Nomor HP belum valid. Cek lagi ya." names no way to fix it | "Nomor HP belum valid. Contoh: 812-3456-7890." **[applied]** | An error is an instruction: show the expected format next to the field |
| LOW | Writing | Status `d8teOe` · `TsDialog` confirm buttons `jLI1m` (`Ya, Batalkan`), `l3lSr` (`Batalkan`), Info `P0JYG` (`Oke`), Info body `Wx7FR` | Confirm labels do not repeat the consequence (`Batalkan booking`), bare `Oke`; the body names a card without quotes | `Batalkan booking` / `Tutup`, quote the card name (labels are wider: the actions would stack on a 312 dp dialog) | Confirm answerable without reading the body; verb-first acknowledgement. **Left for you** |
| LOW | Accessibility | Buttons `u46xe` · Note Semantics `jQKIH` | Semantics list had no labels for the app bar `search` / `more_vert` | `Cari` and `Menu lainnya` added **[applied]** | Every icon-only control needs a name |
| LOW | Accessibility | `prd/02` focus-ring rule | Says every control gets a 2 dp ring with offset 2; fields, nav items and choice rows use the border itself (offset 0) | Exception written into `prd/02` **[applied]** | Design and PRD disagreed |
| LOW | UI | Illustrations `fnfFf` · 5 tiles, token `illustration-outline` | Light value `#1A171614` = sand-900 @ 8 % (a warm near-black) | Pure black @ 10 % (`#0000001A`) | Tinted image outlines read as dirt on the edge. **Left for you** (token from step 02 / kickoff) |
| LOW | Typography | Status `d8teOe` · 14 × `UnitStatusBadge` label, 3 × chip `Count Badge` | Label Small 11 px | 12 px (Label Medium) | Below the 12 px floor; PRD 02 badge size, kept at step 02. **Left for you** |
| LOW | UI | All sheets: icon weight 500 ×41, 600 ×25, 400 ×9, 700 ×3 | No stated rule for which weight goes where | Write the rule on the Icons board: 500 for ≤ 20 px control icons, 600 for chip / badge glyphs, 400 / 700 for the nav pair | Consistency. **Left for you** |
| LOW | UI | Buttons `u46xe` · pressed specimens | Press = fill / border change only (150 ms), no scale | `scale(0.96)` with a `static` opt-out | PRD 02 motion language has no press scale; optional. **Left for you** |
| LOW | Color | States `WG7ja` · `ErrorState / Type=Inline` `NouOK` | Failed load uses `warning-soft` / `warning-text` while field and dialog errors use `danger` | Keep (warning = recoverable problem, danger = invalid / destructive) and write it into `prd/02` status rules, or move to `danger-soft` | One color, one meaning. **Left for you** |

**Verification:** Passed — `GetVariables()` = 148 variables, resolved values re-read; contrast recomputed from resolved values: 32 new-token pairs at kickoff, then 650 text + 238 icon nodes on 10 sheets in both themes (0 fails; logo monogram 3.45 : 1 is a logotype, disabled masters exempt, glass items measured separately: `text-body` over strong tint ≥ 6.76 : 1); focus rings 3.45 / 7.48 on `surface-card`, `accent-on-inverse` ring 9.87 / 5.06 on the inverse surface, `focus-ring` on the dark inverse 2.14 (why the snackbar action differs); clipping 0 on 12 frames (`enabled:false` subtrees and `Decor` shapes ignored); raw hex 0 on 1,603 nodes; unnamed 0 (100 renamed refs); placeholder 0; 47 interactive nodes ≥ 48 × 48; NavBar 328 × 64, choice row 264 × 48, rail item 208 × 48 after the padding change; screenshots of every section (light) and of the dark buttons, fields, nav specimens and dialogs. **Not verified** — 320 px / 200 % zoom and RTL (no screens; text scale ×1.3 by arithmetic only); Exo 2 `tnum`; rendering in Flutter (`BackdropFilter`, focus rings, shimmer, spinner rotation); how html2figma handles token-bound illustration paths, nested instances and the `Focus Ring Frame` wrappers (step 04 test import); full-sheet dark screenshots at detail (sub-node screenshots have no backdrop, so 16 % tints look peach; values verified by reading them back).
**Verdict:** Block before the fixes (1 HIGH) → **Approve** after them (no HIGH left; 5 MEDIUM fixed).
**Fixes applied:** HIGH Accessibility (focus specimens ×4, `yVYBu` `MwRGG` `BaNCx` `aJHhi`), MEDIUM Accessibility (3 Status notes), MEDIUM Layout ×2 (padding-based heights on 8 masters, chip row note), MEDIUM Writing ×2 (sentence case on 22 nodes, field error copy), LOW ×2 (Semantics labels, `prd/02` focus exception). Dark copies regenerated from the fixed light sheets. **LOW left for you:** `Ya, Batalkan` / `Oke` labels, `illustration-outline` tint, Label Small 11 px, icon weight rule, press scale, inline `ErrorState` hue.

## Review rounds

#### Round 1 — 2026-09-24
- **Frames shown:** Buttons `u46xe`, Inputs `rd8CS`, Status & Feedback `d8teOe`, Navigation `tBuEd`, States `WG7ja`, Illustrations `fnfFf` (+ dark copies), the `/better-interface` report, and three build decisions to check (sentence case, focus-border exception, pressed tokens).
- **User feedback:** "approve". No per-decision answers, so the stated defaults stand; the six LOW findings stay open.
- **Changes made:** none after the report (fixes had been applied before the gate).
- **Outcome:** approved.

## Session log

| Time | Action | Result / node ids |
|---|---|---|
| 2026-09-24 | Kickoff | Read step 02/03, `00-index`, `prd/02` / `prd/04` / `prd/06`; app state OK; canvas root re-read (Components anchor `m5khVn` y 8400, `OwQde` y 9900, `URsZs` y 12300) |
| 2026-09-24 | Kickoff interview (4 rounds) | 13 decisions above; all recommended options accepted; step 02 PNGs "moved by the user" |
| 2026-09-24 | Contrast script | 32 pairs (new tokens, glass tint strong, chip, danger border, skeleton); all targets met |
| 2026-09-24 | Variables | `SetVariables` merge: 8 color + 3 number → 145 total, resolved values re-read |
| 2026-09-24 | Type board | `Type / Label Medium` `LqAAP` (row `dqyOO`, light) + instance `zLsB6` (row `b5dzj`, dark) |
| 2026-09-24 | Docs (kickoff record) | This file, `00-index` (tracker 🟡, `TsIconButton` inventory row), `prd/02` (8 tokens, Label Medium, M3 mapping, button types, NavBar tint) |
| 2026-09-24 | Illustrations | 4 × `Generate(svg)` kicked off first (`Qy9CB` `eorqH` `JU8tB` `Myjen`, finished while other sheets were built); palette-snap: 89 nodes, max shift 28, 0 skipped; made reusable on the sticker tile; sheet `fnfFf` |
| 2026-09-24 | Buttons `u46xe` | 22 `TsButton` + 4 `TsIconButton` masters. Found: absolute `fill_container` layers collapse hug parents → overlay pressed layer and spinner layer removed; pressed = `accent-pressed` / `danger-pressed` tokens, loading = fixed-width master |
| 2026-09-24 | Inputs `rd8CS` | 8 `TsTextField` + 3 `TsChip` masters; found: globals do not persist between `execute` calls (use literal ids); disabled nodes report false "fully clipped" rows |
| 2026-09-24 | Status & Feedback `d8teOe`, Navigation `tBuEd`, States `WG7ja` | 14 badges, 4 snackbars, 4 dialogs + choice rows; app bars, sheet headers, NavBar (strong tint) + rails; empty / error / skeleton |
| 2026-09-24 | Canvas | Dark row: header `AEaD0` y 12240, 6 dark copies y 12380; Flows anchors `OwQde` y 16000, `URsZs` y 18400 |
| 2026-09-24 | Automated checks | clipping 0, raw hex 0 / 1,603, unnamed 0, placeholder 0, 47 targets ≥ 48, contrast 650 text + 238 icons 0 fails |
| 2026-09-24 | `/better-interface` | 14 findings (1 HIGH, 5 MEDIUM, 8 LOW), verdict Block → Approve after fixes |
| 2026-09-24 | Review gate + close | User approved; 12 sheets + 5 illustrations exported to `design/pencil/exports/step03/` (17 PNGs + `INDEX.md`, verified with `ls`); session file `05-design-step03-components-core.md`; tracker ✅ |
| 2026-09-24 | Fixes | 4 focus specimens, Status notes, padding-based heights (NavBar ×4, choice rows ×2, rail large ×2), chip row + Buttons notes, sentence case (22 nodes), field error copy; dark copies regenerated; found: notes do not reflow after a content edit (set explicit height), a wide row overflows the sheet when a cell is added (split the row) |
