# Step 06 — S10 Pilih Motor

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-24 |
| **Priority** | P0 |
| **Owns screens** | S10 |
| **Owns components** | (screen-local, flagged for `prd/02`): `TsDialog` confirm-save variant (booking exit, reused by every booking step), `SelectionFooter` (the plan's `SelectionCounter`, in the footer), `AddMotorCard`, `TsAppBar` close-leading, sheet-only 6th sample motor (Scoopy 110) |
| **PRD refs** | [04 S10](../../../prd/04-screens.md), [03 F2 + vehicle-selection rules + edge cases](../../../prd/03-user-flows.md), [06](../../../prd/06-responsive-layout.md) (S10 row) |
| **Pen location** | Flows row `S10` |
| **Depends on** | Steps 02–05 |
| **Claude session** | `docs/claude-session/08-design-step06-s10-pilih-motor.md` (written after approval) |

## Goal

Design the first booking step: multi-select 1–5 motors from the garage, with the disabled ("Sedang dalam servis") and max-reached rules made obvious and never color-only. Also design the **exit-booking confirm dialog** ("Keluar dari booking? Draft akan disimpan.") that every booking step reuses.

## Inputs

- `BookingStepper` (step 1/4), `VehicleSelectCard` (select mode: unselected / selected / disabled reasons), `EmptyState` (garage), `Skeleton`, `TsDialog`, `TsAppBar`, `TsButton`, `TsSnackbar`, `GarageAddTile` look.
- Demo garage (kickoff decision 1): 5 motors — the 3 canonical + the step-04 sheet-only Supra X 125 and Ninja 250 (in service).

## Kickoff decisions (answered 2026-09-24, interview with the user; every recommended option accepted)

Two `AskUserQuestion` rounds (8 questions); the five original open questions plus three found while planning.

| # | Topic | Decision |
|---|---|---|
| 1 | Garage story (found while planning: the canonical Vario / Beat / PCX are all *in service* in the S05 populated state, but S10 is where that booking is created) | S10 garage in garage order: Vario 125, Beat 110, PCX 160 + Supra X 125 (bebek, `AB 3344 KL`, free) + Ninja 250 (sport, `AB 7788 MN`, **Sedang dalam servis**). Populated frame = **3 of 5 selected** (Vario, Beat, PCX) so S11 starts with 3 units and S18 shows A / B / C. The plan matrix said "2 of 5"; corrected |
| 2 | Chrome (found while planning) | The booking flow S10–S18 has **no `NavBar` / `NavRail`** on any breakpoint (focused flow). Tablet: full-width app bar + stepper, content centered. This locks the pattern for steps 07–11 (S11 / S15 / S16 multi-pane layouts get the full width) |
| 3 | Footer + selection counter (old Q1 + Q3) | **Flat sticky footer** (`surface` + top border, above the gesture inset). Left: `N dari 5 motor dipilih` (Label Large, `text-heading`) + a reason line; right: `Lanjut`. Reason line: 0 selected → "Pilih minimal 1 motor"; 5 selected → "Lepas satu untuk memilih motor lain"; 1–4 → none. No glass, no price (price starts at S11) |
| 4 | Exit dialog (found while planning: "Draft akan disimpan" is false with nothing selected) | Shown only with ≥ 1 motor selected; with 0 selected back / close exit at once. New **non-destructive** `TsDialog` variant: "Keluar dari booking?" / "Draft akan disimpan." · primary **Simpan & keluar** · secondary **Lanjutkan booking** · no danger styling. Discard stays on Home ("Hapus draft", S05) |
| 5 | App bar | S10: leading **close (X)**, title "Pilih motor"; system back = the same exit rule. S11+ (back arrow + trailing close) is decided in step 07 |
| 6 | Grid | Phone 1 col · tablet-P 2 cols (content max 720) · tablet-L **3 cols, content max ~1040** (5 cards + add card = 3 + 3) |
| 7 | Entry hints (old Q5) | None. Pre-checked (Garasi / rebook) looks identical to a user-selected card; the workshop carried from S14 is annotation only |
| 8 | "+ Tambah motor lain" (old Q4) | Full-width **end-of-list card** (`GarageAddTile` look), enabled even at max-reached (garage size ≠ selection size). Back from S08 → the new motor is available, **not** auto-selected, snackbar "Motor ditambahkan" |

Max-reached demo (old Q2): approved as a specimen frame with a **6-motor garage** labelled "Demo: garage 6 motor" — Vario, Beat, PCX, Supra X, Ninja 250 selected + a new sheet-only 6th motor **Scoopy 110** (`AB 2468 TP`, matic) disabled "Maks. 5 motor".

Defaults applied without a question (change at review if unwanted): cards keep garage order everywhere (no re-sorting); empty garage hides the footer (the empty-state CTA is the only action); loading = real app bar + stepper + helper, 3 skeleton cards, footer with disabled Lanjut and no counter; sentence case ("Pilih motor"); helper copy "Yuk, pilih motor yang mau diservis" + "Bisa sampai 5 motor sekaligus. Servis tiap motor diatur di langkah berikutnya."; export at close = key frames only (as step 05), no HTML export / Figma import until step 12.

## Scope

### Frame matrix

24 frames. Names: `S10 Pilih Motor / <State> / <Phone|Tablet-Portrait|Tablet-Landscape>` + ` · Dark`; states `Loading`, `Empty`, `None Selected`, `Selected`, `Max Reached`, `Exit Dialog`, `Stress 360x640`, `Stress Text 1.3`.

| State | Phone | Tablet-P | Tablet-L | Dark |
|---|---|---|---|---|
| Loading (skeleton cards) | ✔ | ✔ | ✔ | phone |
| Empty garage (illustration + "Tambah motor pertamamu" CTA, no footer) | ✔ | ✔ | ✔ | phone |
| None selected (Lanjut disabled + reason line) | ✔ | — (same layout as Selected) | — | phone |
| Selected — 3 of 5, Ninja 250 disabled "Sedang dalam servis" | ✔ | ✔ | ✔ | phone + both tablets |
| Max-reached — 5 of 5 on the 6-motor specimen (the 6th disabled "Maks. 5 motor") | ✔ | ✔ | — | phone |
| Exit-booking confirm dialog (over Selected) | ✔ | ✔ | — (modal identical) | phone |
| Stress: 360×640 (Selected) | ✔ | — | — | — |
| Stress: text scale ×1.3 (Selected) | ✔ | — | — | — |

### Layout targets (PRD 06)

- No `NavBar` / `NavRail` (decision 2). Frame = status bar + `TsAppBar` (close-leading) + `BookingStepper` + body + flat footer + gesture bar.
- Phone: 1-col card list. Tablet portrait: 2-col grid, content max 720. Tablet landscape: **3-col grid**, content max ~1040. The footer spans the frame; its content is aligned to the same max-width as the list, CTA on the right.
- Stepper: compact phone variant; wide tablet variant, centered within the content max-width.

### Content & copy

- Title "Pilih motor"; helper "Yuk, pilih motor yang mau diservis" + "Bisa sampai 5 motor sekaligus. Servis tiap motor diatur di langkah berikutnya."
- Footer counter: "3 dari 5 motor dipilih" (+ reason line, decision 3). Disabled card reasons: "Sedang dalam servis", "Maks. 5 motor".
- CTA: "Lanjut" (disabled: reason line "Pilih minimal 1 motor").
- Add card "+ Tambah motor lain"; empty state CTA "Tambah motor pertamamu".
- Cards: nickname (2 lines, then ellipsis), plate, model; category silhouette in the photo slot.

### Annotations to place

- Selection rules (1–5, disabled rules); card semantics "Vario 125, AB 1234 XY, dipilih" / "…, tidak bisa dipilih: sedang dalam servis" / "…, tidak bisa dipilih: batas 5 motor tercapai"; counter is a polite live region; close = "Tutup booking"; the disabled Lanjut hint is the reason line.
- Entry points and pre-selection (Home CTA → empty; Garasi "Booking motor ini" → pre-checked; S14 "Booking di sini" → empty, workshop carried, S13 skipped; rebook → same motors pre-checked, any now-unavailable motor comes back unchecked and disabled).
- Exit rule: dialog only with ≥ 1 selected; system back and close icon both trigger it; confirm → draft saved → Home shows "Lanjutkan booking".
- Empty-garage CTA and the add card → S08 → back here, new motor available but not selected, snackbar "Motor ditambahkan".
- Focus order (close → stepper → cards in reading order → add card → Lanjut); reduce-motion (no shimmer); footer sits above the gesture inset.

## Built sheets and frames (node ids, `design/pencil/TumbasServis.pen`)

Component sheet **S10 blocks** `nahAr` (light, x 25368, y 8760, right of Home blocks) and its dark copy `L3zHV4` (y 12380). One new variable: **`scrim`** (light `#1A171666`, dark `#000000A6`; the dim layer behind dialogs, 151 variables). Masters: `TsAppBar / Type=Close` `rHS0h` · `SelectionFooter` None `fskrH`, Selected `l4zDH`, Max `wE1kO`, Loading `WGjBc` (Main Row ids `L73Vy` `DOSFz` `JhGvu` `pRb64` for the tablet padding override) · `AddMotorCard` `z6XRSk` (+ focused `dhJKa`, pressed `Awcd8`) · `VehicleSelectCard / Mode=Select, State=Loading` `f0xBn1` · `TsDialog / Type=Confirm Save` `tMRhF` · specimens: unselected focused `r6Xja`, unselected pressed `E1sPm`, selected pressed `H9PQLa`, snackbar "Motor ditambahkan" `KA6Ok`, demo garage (6 motors) `bv0On`.

The tablet block of the Flows section moved down 3000 dp to make room: `Flows – Tablet` anchor `URsZs` is now at y 23000 (S05 tablet rows y 23186 / 24772).

| Row (header id) | Frames (light → dark) |
|---|---|
| Phone, light y 19946 (`EAVzT`, notes `lJODO`, fold marker `N7rSt7`) | Loading `PI4VN` · Empty `mSSjo` · None Selected `bBkzu` (973) · Selected `W5Vhc9` (973) · Max Reached `s0LoP5` (1075) · Exit Dialog `FkQI9` · Stress 360×640 `aviXK` · Stress Text 1.3 `w4NaX` (1175) |
| Phone, dark y 21536 (`nHeKp`) | Loading `NKFpW` · Empty `K8xnh` · None Selected `fZvJU` · Selected `nZNE2` · Max Reached `p4IxL` · Exit Dialog `AMgFv` |
| Tablet-Portrait y 26286 (`RgKwe`, notes `aVgrc`) | Loading `m4Zdo` · Empty `a58AW5` · Selected `jag2B` · Max Reached `U9EmX` · Exit Dialog `ktYJe` · Selected dark `D0bDe9` |
| Tablet-Landscape y 27886 (`N52ulP`, notes `FP1bN`) | Loading `jbxqb` · Empty `nKy1c` · Selected `iJcrV` · Selected dark `KqDxe` |

Build decisions made while building (all inside the kickoff decisions unless marked):
- **Frames are plain frames, not `AppShell`** (no nav shell in the booking flow): status bar + `TsAppBar / Type=Close` + `BookingStepper` + body + `SelectionFooter` + gesture bar. Phone frames are full-scroll captures (`fit_content`; Loading / Empty fixed 800 with the body `fill_container` so the footer sits at the bottom); tablet frames are fixed viewports with no status bar (as the S05 tablet frames).
- **Silhouette swap in a card instance** = `descendants: { <silhouette child id>: {type:"ref", ref:<bebek|sport id>, name:"Silhouette"} }` (plus `opacity: 0.6` on disabled cards); text overrides by the master child ids.
- **Tablet grid** = row frames of `fill_container` cards; the taller card keeps its hug height and the shorter one gets `height: fill_container` (equal-height rows; Pencil's "circular size" warning on those rows is a false positive, bounds read back correct). A lone add card takes the whole row.
- **Exit dialog frame** = a `Copy` of the Selected frame plus an absolute `Dialog Overlay` (`fill: $scrim`, literal width and height, dialog centered). The overlay height is literal, so it has to be updated whenever the frame height changes (done after the heading fix: 1007 → 973).
- **Heading role (review fix):** the helper heading is Title Medium (16), not Headline Small, so it stays on one line at 360 and sits below the app-bar title in the hierarchy.
- **Handoff notes must live in frames**: `note` nodes inserted straight at the document root were wrapped (`aVgrc`, `FP1bN`) to keep the root clean.
- **Not built:** an error frame (PRD 04 lists loading, empty, populated and max-reached only); a long-name S10 frame (rule and specimen are in step 04).

## Checklist

### Build
- [x] Kickoff questions answered (8 decisions above).
- [x] All states in the matrix built for the listed breakpoints (24 frames); dark copies built.
- [x] Exit dialog built as a **non-destructive** dialog (the draft is saved): primary = "Simpan & keluar", secondary = "Lanjutkan booking"; no danger styling (a danger hue here would be a semantic-color misuse). No "Buang draft" action (decision 4).
- [x] Disabled cards carry a visible reason text (icon + label badge, not only reduced opacity).
- [x] Stress frames built (360×640 viewport, text ×1.3); nickname / plate ellipsis is the step 04 component rule (long-name specimen `z2g1f`), the ×1.3 frame wraps model lines without clipping.
- [x] Demo content consistent with the step-01 sheet (kickoff decision 1 records the S10 garage).

### Quality (automated, run in `execute`)
- [x] Clipping check on every step frame → zero `problems` (only the intentional clipped 360×640 viewport; disabled subtrees and `Decor` exempt).
- [x] Raw-hex audit → zero (585 nodes).
- [x] Every node named; instances only; `placeholder` cleared.
- [x] Coverage script: frame names match the matrix above (24 / 24).

### /better-interface
- [x] Run `/better-interface` with scope = all S10 frames (names + node ids).
- [x] Report recorded below; HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [x] Status set to 🔵; user shown: populated (selected/disabled), max-reached, empty, dialog, tablets, dark.
- [x] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [x] PNG export of the key frames (10 PNG: 9 frames + the S10 blocks sheet) to `design/pencil/exports/step06/` + `INDEX.md`, verified with `ls`.
- [x] Claude session file written (`docs/claude-session/08-design-step06-s10-pilih-motor.md`).
- [x] Tracker set to ✅.

## /better-interface report

**Scope:** S10 Pilih Motor, 24 frames — Phone `PI4VN` `mSSjo` `bBkzu` `W5Vhc9` `s0LoP5` `FkQI9` `aviXK` `w4NaX`, dark `NKFpW` `K8xnh` `fZvJU` `nZNE2` `p4IxL` `AMgFv` · Tablet-Portrait `m4Zdo` `a58AW5` `jag2B` `U9EmX` `ktYJe`, dark `D0bDe9` · Tablet-Landscape `jbxqb` `nKy1c` `iJcrV`, dark `KqDxe` — plus the S10 blocks sheets `nahAr` / `L3zHV4` · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens · **Convention docs found:** 00-index.md, prd/02, prd/06, steps 03 / 04 / 05 decisions

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | 48 dp targets on cards / add card / app bar / footer, focus and pressed specimens (checkbox, select card, add card, buttons from steps 03 / 04), state never color-only (border + check, icon + reason text), semantics / focus-order / motion notes, exit-dialog focus behavior, loading and disabled-card announcements, text ×1.3 and 360×640 stress | 2 MEDIUM (fixed) |
| Layout | Grouping (stepper → heading → list → add card), 1 / 2 / 3-column grids at 360 / 800 / 1280, footer row aligned to the content edge, equal-height rows, sticky footer above the gesture inset, scroll cues (next card peeks at the fold), no NavBar / NavRail | Clear |
| Writing | Sentence case, verb-first buttons, dialog copy (title, body, both actions), reason lines name the fix, empty state next action, terminology against Home / PRD 04 | 1 LOW (left) |
| Typography | Heading wrap at 360, truncation rule for nicknames, 11 px reason badges, tabular figures, line-height / role tokens | 1 MEDIUM (fixed), 2 LOW |
| Color | Contrast of 690 text + 178 icon nodes in both themes, one filled action per view (Lanjut; the dialog and the empty state have their own single primary), semantic color use (dialog is not danger), new `scrim` token over both themes | Clear |
| UI | Concentric radii (16 card / 8 silhouette / 12 padding, as step 04), flat footer with a border instead of a shadow, press / focus recipes, motion values and reduce-motion notes | covered by the Accessibility MEDIUM; otherwise Clear |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| MEDIUM | Accessibility | `VehicleSelectCard` select mode (every populated frame) and `AddMotorCard` `z6XRSk`; blocks sheet `nahAr` | Only "selected, focused" existed (step 04); no unselected-focused and no pressed state for the select card or the add card | `Focus And Pressed Section` `u4gtv`: unselected focused `r6Xja`, unselected pressed `E1sPm`, selected pressed `H9PQLa`, add card pressed `Awcd8` (`surface-hover`), add card focused `dhJKa` **[applied]** | Whole-card taps without press feedback; keyboard focus on the unselected card was not shown |
| MEDIUM | Accessibility | Notes `cYMOW` (exit dialog), `dIxvx` (loading, disabled cards), `QWcfc` (semantics) | No focus behavior for the new modal, no back / scrim rule, no loading announcement, disabled cards not said to stay focusable | Notes extended: focus to the title on open, Tab cycle, back / scrim = "Lanjutkan booking", focus returns to the close icon, dialog motion + reduce-motion; "Memuat daftar motor" live region; disabled cards `aria-disabled` and focusable **[applied]** | Modal focus trap / restore, and a screen-reader user could never learn why a card cannot be chosen |
| MEDIUM | Typography | `Heading` in 20 frames (e.g. `W5Vhc9` › `aW86Q`) | Headline Small 22 px: at 360 it wraps and leaves "diservis" alone on line 2; repeats the app-bar title at a bigger size | Title Medium 16 px semibold, one line at 360 (stress copy `w4NaX` scaled ×1.3), frame heights re-measured (1007 → 973, 1109 → 1075), dialog overlays updated **[applied]** | Lopsided wrap; a sub-heading should descend below the bar title |
| LOW | Typography | Reason badges `Reason Badge` in `Ju8cu` / `j1qseA` (disabled cards in every populated frame) | Label Small 11 px (open since steps 03 – 05) | Decide with the type scale in step 19 **[left]** | Small UI text carrying the reason a card is disabled |
| LOW | Typography | `SelectionFooter` counter (`Counter` in `fskrH` `l4zDH` `wE1kO`) | Tabular figures cannot be set or checked in Pencil | Note `N8yE0n`: `FontFeature.tabularFigures()` **[applied as a note]** | The counter changes on every tap |
| LOW | Writing | Empty-state CTA "Tambah motor pertamamu" (`fDhQP` `cluVB` `j6qKAV`) | Possessive and longer than Home's "Tambah motor" | "Tambah motor" — kept as the kickoff spec **[left]** | Possessives sparingly; consistent link / button vocabulary |
| LOW | Typography | Card nickname (S10 tap selects, no path to S09 from here) | 2 lines then ellipsis; the full value is only in the semantics label and S09 | Cap the nickname length in S08 (step 14) so S10 never truncates **[left]** | A truncated value a sighted user cannot reach from this screen |

**Verification:** Passed — clipping on 26 roots (24 frames + 2 sheets, 585 nodes): 0 rows except the intentional clipped 360×640 viewport (`aviXK` › Card List), disabled subtrees and `Decor`; raw hex 0; unnamed 0; `placeholder` 0; coverage 24 / 24 frame names; contrast (resolved, ancestor-composited, both themes) 690 text + 178 icon nodes, 0 fails, minimum 4.56 : 1 (disabled Lanjut label); 48 dp: 0 cards / add cards / app bars / footers under 48; text ×1.3 stress: no clipping; screenshots of the blocks sheet, every phone frame, the tablets, dark copies and the focus / pressed specimens. **Not verified** — Flutter rendering (scrim, sticky footer, shimmer, ripple), 320 px width and 200 % zoom, RTL, Exo 2 tabular figures, screen-reader output, the S10 error state (PRD 04 lists none), html2figma behavior (first S10 import is step 12).
**Verdict:** Approve (no HIGH found).
**Fixes applied:** 2 MEDIUM accessibility (specimens, notes), 1 MEDIUM typography (heading), 1 LOW as a note · **LOW left for the user:** 11 px reason badges, empty-state CTA wording, nickname length cap (step 14).

## Review rounds

#### Round 1 — 2026-09-24
- **Frames shown:** phone Selected / None Selected / Max Reached / Empty / Loading / Exit Dialog (light) and Selected dark; tablet-portrait and tablet-landscape Selected; stress ×1.3; the S10 blocks sheet with the focus / pressed section; the `/better-interface` report.
- **User feedback:** "approved"
- **Changes made:** none.
- **Outcome:** approved. LOW findings stay open (11 px reason badges, empty-state CTA wording, nickname length cap in S08 → step 14; the first two also for step 19).

## Session log

| Time | Action | Result / node ids |
|---|---|---|
| 2026-09-24 | Kickoff interview | 2 rounds, 8 decisions, every recommended option accepted (`AskUserQuestion`); garage-story conflict (S05 vs S10 timeline) and the empty-selection exit case found and resolved (decisions 1, 4) |
| 2026-09-24 | Docs (kickoff record) | This file, `00-index` (tracker 🟡, inventory additions, decision-log row "Booking-flow chrome", canonical-demo row), `19-full-app-audit.md` (PRD S10 / booking-flow corrections) |
| 2026-09-24 | S10 blocks sheet `nahAr` | `TsAppBar / Type=Close` `rHS0h`, `SelectionFooter` ×4, `AddMotorCard` + focused, card skeleton `f0xBn1`, `TsDialog / Type=Confirm Save` `tMRhF`, snackbar, demo garage, notes; new token `scrim` |
| 2026-09-24 | Phone frames | Loading `PI4VN`, Empty `mSSjo`, None Selected `bBkzu`, Selected `W5Vhc9`, Max Reached `s0LoP5`, Exit Dialog `FkQI9`, Stress 360×640 `aviXK`, Stress ×1.3 `w4NaX` (31 text nodes scaled); dark copies of six; tablet block of the Flows section moved down 3000 dp |
| 2026-09-24 | Tablet frames | Portrait Loading / Empty / Selected / Max / Dialog + dark Selected; landscape Loading / Empty / Selected + dark Selected; row headers, notes frames (root notes wrapped in frames) |
| 2026-09-24 | Automated checks | clipping, raw hex, naming, placeholders, coverage 24 / 24, contrast (690 text + 178 icons), 48 dp: clean (only the intentional 360×640 viewport clip) |
| 2026-09-24 | `/better-interface` | 7 findings (0 HIGH, 3 MEDIUM, 4 LOW); MEDIUM fixed (focus / pressed specimens, dialog + loading annotations, heading role), re-checks clean, dark blocks sheet re-copied (`L3zHV4`); verdict Approve |
| 2026-09-24 | Review gate, round 1 | User approved ("approved"), no changes |
| 2026-09-24 | Close | `Export` of 10 nodes to `design/pencil/exports/step06/` (10 PNG + `INDEX.md`, verified with `ls`); session file `08-design-step06-s10-pilih-motor.md`; tracker ✅ |
