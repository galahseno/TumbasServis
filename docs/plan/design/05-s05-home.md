# Step 05 — S05 Beranda (Home) + app shell

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-24 |
| **Priority** | P0 |
| **Owns screens** | S05 |
| **Owns components** | (screen-local, flagged for `prd/02`): `AppShell`, `ActiveBookingCard`, `DraftResumeCard`, `QuickLinkTile`, `FleetProgress` (mini); added at kickoff: `BookingCtaCard`, `SectionTitleRow`, `GarageAddTile`, `VehicleSelectCard` compact in-service variant; added while building: `TsAppBar / Type=Title, Actions=Bell` (tablet bar) |
| **PRD refs** | [04 S05](../../../prd/04-screens.md), [03 F2/F3](../../../prd/03-user-flows.md) (entry points, draft, tracking), [06](../../../prd/06-responsive-layout.md) (S05 row, nav patterns) |
| **Pen location** | Flows row `S05` (Phone light → Phone dark under `OwQde`; Tablet-Portrait → Tablet-Landscape under `URsZs`); component sheets in the Components row (light y 8760 right of the step 04 stress frame, dark copies y 12380) |
| **Depends on** | Steps 02–04 |
| **Claude session** | `docs/claude-session/07-design-step05-s05-home.md` (written after approval) |

## Goal

Design the app's entry screen and the **shell** that hosts every tab (Beranda · Riwayat · Garasi · Profil): glass bottom `NavBar` on compact, `NavRail` on medium/large. The shell becomes a reusable slot component so S07, S19 and S25 reuse it unchanged.

## Inputs

- PRD 04 S05: app bar (logo + bell with unread badge), greeting, primary CTA card, active-booking card(s), "Lanjutkan draft" card, promo carousel, "Garasi Saya" strip, quick links (Riwayat, Katalog Suku Cadang).
- Components from steps 03–04: `TsAppBar`, `NavBar`, `NavRail`, `PromoBanner`, `PageIndicator`, `VehicleSelectCard` (compact mode), `Silhouette`, `UnitStatusBadge`, `TsButton`, `TsIconButton`, `TsDialog`, `Skeleton`.
- Demo content sheet (`isFgy`).

## Kickoff decisions (answered 2026-09-24, interview with the user; every recommended option accepted)

| # | Topic | Decision |
|---|---|---|
| 1 | Draft vs in-service conflict (all 3 canonical motors are in the active booking, so PRD 03 blocks them from any draft: "Sedang dalam servis") | Populated garage strip = Vario 125, Beat 110, PCX 160 + **Supra X 125** (sheet-only bebek sample from step 04, `AB 3344 KL`) + "+" tile. The draft holds **Supra X 125 only**, at step 2/4. The Empty state is the earlier moment: the same 3 motors, no badges |
| 2 | Mini progress (PRD `●●●○○`) | **`FleetProgress` mini = one segment per unit** (max 5), filled by that unit's own stage (Terjadwal 0 … Selesai full), plus a mandatory text label (never shape alone). Reused / extended by S20 in step 16 |
| 3 | Several active bookings | Stack, max 2, then "Lihat semua (n)" → S19 Berlangsung. The 2-card stack is a component-sheet specimen, not an extra frame |
| 4 | Empty state emphasis | Taller **hero CTA card** with the matic `Silhouette` (theme-aware, zero `Generate` budget) and the tagline; the populated state uses the compact CTA card |
| 5 | `DraftResumeCard` | Title "Lanjutkan booking", line `Supra X 125 · Langkah 2 dari 4 · Servis`, expiry always shown ("Kedaluwarsa dalam 22 jam"; under 3 h → `warning-text` + clock icon), compact primary "Lanjutkan", ghost "Hapus draft" → `TsDialog` confirm-destructive. The whole card taps to resume at the last step |
| 6 | Greeting emoji | Keep `Halo, Galah 👋`; verify the render in Pencil and the Chromium check; fallback icon `waving_hand` if it shows as tofu |
| 7 | Tablet-portrait grid | Greeting + hero CTA span both columns → `ActiveBookingCard` \| `DraftResumeCard` → promo spans → garage strip spans → two `QuickLinkTile`s (with no draft, the quick links take the second cell) |
| 8 | `AppShell` scope | All **12** masters now: Layout (Compact / Medium / Large) × Active (Beranda / Riwayat / Garasi / Profil), thin wrappers over the existing `NavBar` / `NavRail` masters + a content slot. The app bar stays in each screen's slot |
| 9 | Garage strip | Compact `VehicleSelectCard` gets an in-service variant with a compact `UnitStatusBadge` ("Dikerjakan"); tapping still opens S09 |
| 10 | Promo carousel | 3 slides (voucher / multi-motor / service reminder). Phone: 1 slide + peek; 800: one wide slide across both columns; 1280: two side by side. Auto-advance 5 s, pauses on touch / focus, off with reduce-motion; `PageIndicator` is a non-interactive cue, announced "Promo 1 dari 3" |
| 11 | App bar on tablet | Medium / large: **no logo** (the rail carries `TsLogo`); greeting as the bar title, bell on the right. Compact: logo + bell bar, greeting below |
| 12 | Loading | Real: app bar (bell, no badge), greeting, CTA, nav, quick links. Skeleton: one booking-area card (also the unknown-draft slot), promo, garage cards. Static shimmer + note; reduce-motion = no shimmer |
| 13 | `ActiveBookingCard` content | Header "Booking aktif" + chevron; code `TS-260929-0417`; per-unit segments; status line; muted line "Bengkel Jaya Motor · Sel, 29 Sep · 09.00"; the whole card → S20 (≥ 48 dp). Specimen `AllDone`: "Semua motor selesai" + ghost "Lihat invoice" (sheet only) |
| 14 | Status label rule | Label = the unit status shared by **most** motors (ties → earliest stage) + caption "1 motor masih Diperiksa" when units differ. Demo: A Dikerjakan, B Dikerjakan, C Diperiksa → "3 motor · Dikerjakan". Domain-layer note; the PRD 04 wireframe text stays valid, PRD 03's derived `Berlangsung` is not used on this card |
| 15 | `QuickLinkTile` | Two tiles side by side, tonal icon disc + label + chevron (`history`, `oil_barrel`), ≥ 48 dp tall |
| 16 | Export at close | **Key frames only**: phone light populated / empty / loading, phone dark populated, tablet-P and tablet-L populated (light), the two component sheets (about 8 PNG + `INDEX.md`). No HTML export and no Figma import until step 12 |

Defaults applied without a question: sentence case ("Booking servis motor", "Mulai booking", "Garasi saya", "Katalog suku cadang"); bell badge 2 in populated, none in empty / loading (0 / 2 / 9+ shown on the component sheet); phone frames are full-scroll captures `fit_content(800)` with the `NavBar` absolute at the frame bottom and content bottom padding above it, plus a "fold 800 dp" note; tablet-L = extended rail + 2-col grid inside about 1040 dp; Empty frames show the same 3 free motors without badges.

## Scope

### Frame matrix

`✔` required · `—` not required (reason)

| State | Phone 360×800 | Tablet-P 800×1280 | Tablet-L 1280×800 | Dark |
|---|---|---|---|---|
| Loading (skeleton cards) | ✔ | ✔ | ✔ | phone |
| Empty (no active booking, no draft) | ✔ | ✔ | ✔ | phone |
| Populated (active booking + draft card + promo + 4-motor garage strip) | ✔ | ✔ | ✔ | phone + both tablets |
| Populated, 1 motor in garage / long names | ✔ | — (same layout) | — | — |
| Stress: 360×640 populated | ✔ | — | — | — |
| Stress: text scale ×1.3 populated | ✔ | — | — | — |

17 frames in total. Names: `S05 Beranda / Populated / Phone`, `… / Phone · Dark`, `… / Tablet-Portrait`, `… / Tablet-Landscape`, `S05 Beranda / Stress 360x640 / Phone`, `S05 Beranda / Stress Text 1.3 / Phone`.

Notification bell states (0 / 2 / 9+ unread) are shown on the component sheet, not as extra frames.

### Layout targets (PRD 06)

- Compact: single column, glass bottom `NavBar` (inset 16dp, above the gesture inset), content scrolls behind it with bottom padding.
- Medium (800): `NavRail`, content max-width ~720 centered, **2-col card grid** (promo carousel and garage strip span both columns).
- Large (1280): extended `NavRail` (icons + labels), 2-col grid, wider (two-up) promo carousel.

### Components built here (flag → PRD 02 inventory additions)

| Component | Notes |
|---|---|
| `AppShell` | Reusable frame with a content **slot**: compact = status bar + content + absolute glass `NavBar` + gesture bar; medium/large = `NavRail` + content. 12 masters (3 layouts × 4 active tabs) |
| `FleetProgress` (mini) | `FleetProgress Segment` (stage 0–5) → `FleetProgress / Mini` (1, 3, 5 units) + text label slot; extended by S20 in step 16 |
| `ActiveBookingCard` | Booking code, status line, mini progress, workshop + schedule line, tap → S20; states OnTrack, AllDone |
| `DraftResumeCard` | Draft summary, step X/4, expiry, resume + discard; states Default, Expiring |
| `BookingCtaCard` (added) | Primary booking CTA: Compact (populated) and Hero (empty, with the matic silhouette) |
| `QuickLinkTile` | Riwayat, Katalog suku cadang |
| `SectionTitleRow` (added) | "Garasi saya" + "Lihat semua" ghost link |
| `GarageAddTile` (added) | "+" tile at the end of the garage strip (→ S08) |
| `VehicleSelectCard` compact, In Service (added variant) | Compact card + compact `UnitStatusBadge` |

### Content & copy

- App bar: `TsLogo` mark+wordmark, bell with unread badge (2 in the PRD wireframe).
- Greeting: "Halo, Galah 👋". Primary CTA card: "Booking servis motor" / "Mulai booking" with the tagline "Servis banyak motor, sekali booking."
- Active booking: `TS-260929-0417`, "3 motor · Dikerjakan", caption "1 motor masih Diperiksa", "Bengkel Jaya Motor · Sel, 29 Sep · 09.00".
- Draft: "Lanjutkan booking", "Supra X 125 · Langkah 2 dari 4 · Servis", "Kedaluwarsa dalam 22 jam", "Lanjutkan", "Hapus draft".
- Garage strip: Vario 125 (AB 1234 XY), Beat 110 (AB 5678 ZZ), PCX 160 (AB 9012 QR), Supra X 125 (AB 3344 KL) + "+" tile.

### Annotations to place

- Entry points: CTA → S10 empty; motor tile → S09; "+" → S08; draft card → resumes at its last step; active card → S20; bell → S06.
- Bottom-nav behavior: glass, 1–2 `BackdropFilter` budget; flat fallback.
- Draft expiry (24h) rule; promo carousel auto-advance pause + reduce-motion.
- Semantics: bell label "Notifikasi, 2 belum dibaca"; fleet progress "Motor 1 dari 3: Dikerjakan …".
- Status label rule (decision 14) for the domain layer; stack max 2.
- Skeleton shimmer + reduce-motion; fold marker at 800 dp.

## Built sheets and frames (node ids, `design/pencil/TumbasServis.pen`)

Component sheets (light y 8760, dark copies y 12380, right of the step 04 stress frame): **Shell · Compact** `sxbrl` / `k7aYr` (x 17760), **Shell · Medium** `nZsOR` / `r7OrK` (x 19448), **Shell · Large** `AW1Ie` / `s6gFb` (x 21248), **Home blocks** `giPiP` / `CjTfd` (x 24008). `Flows – Tablet` anchor `URsZs` moved to y 20000 (the dark phone row needs the room).

| Group | Masters (ids) |
|---|---|
| `AppShell` ×12 | Compact `jeS3b` `mnput` `rNUnq` `ljoCH` · Medium `Q7CAk` `Qfdsj` `HqLmA` `kUzlS` · Large `x42Pim` `x8pWL` `RRoaM` `LN649` (Beranda / Riwayat / Garasi / Profil; slot `Content` = `slot: []`) |
| `FleetProgress` | Segment Stage 0–5 `dHiio` `HVcnp` `GtFi6` `EuPsM` `K4S5AU` `IO2jy`; Mini Units=3 Mixed `Bza4W`, Units=3 Done `Bu0WV`, Units=2 Scheduled `nbKjM`, Units=5 Mixed `J7guzz`, Units=1 `aIZNe` |
| Cards | `ActiveBookingCard` OnTrack `j7lTj1`, AllDone `Ud9JG` · `DraftResumeCard` Default `oDxJR`, Expiring `xUmuG` · `BookingCtaCard` Compact `JFQZ5`, Hero `NnhBt` · `QuickLinkTile` `ijiiz` · `SectionTitleRow` `o4Io0p` · `GarageAddTile` `H6L0ht` · `VehicleSelectCard` Compact In Service `qfgpi` |
| Added while building | `TsAppBar / Type=Title, Actions=Bell` `l1UTf` (tablet bar). Focus and pressed specimens of the tappable cards: rows `ztA72` (focused) and `OFoQP` (pressed) |

Frames (row headers `Mhspj` phone, `Mttbj` phone dark, `hbIKm` tablet-portrait, `NzS7X` tablet-landscape; notes boxes `Lu2KB` `jbbHk` `i2ctxX`; fold marker `Q0HTt`):

| Frame | Light | Dark |
|---|---|---|
| Phone Populated / Empty / Loading | `jcjrw` (360×1370) / `ALXSJ` (1019) / `P1iEfF` (1083) | `cqX7g` / `W9lsjI` / `k9oVN` |
| Phone Populated 1 motor, long names | `HHBLg` (1208) | — |
| Phone Stress 360×640 / Text ×1.3 | `HcsZK` / `oleh5` (1567) | — |
| Tablet-Portrait Populated / Empty / Loading (800×1280) | `d6h0h` / `T9GQUw` / `XnxOx` | `TFJWb` |
| Tablet-Landscape Populated / Empty / Loading (1280) | `zjTd6` (981) / `p69Dk` (800) / `AxrXi` (910) | `Ty36e` |

Build decisions made while building (all inside the kickoff decisions unless marked):
- **Screens are `AppShell` instances.** Override the instance `height` to the measured content height (+112 on phones for status bar, app bar 64, gesture bar), the `Nav Bar` `y` to `height − 100` (`Update(inst + "/x86B2", {y})`), and fill the slot with `Replace(inst + "/<slotId>", {type:"frame", …})`. Phone bottom padding above the gesture bar = 92 dp (64 + 12 + 16).
- **`FleetProgress` uses a hard-stop gradient** (two stops at the same position) as the stage fill, so a segment needs no pixel width and works at any width.
- **Tablet app bar** has no logo (the rail carries it): a new `TsAppBar / Type=Title, Actions=Bell` master (title + bell) instead of an override of `Type=Home`.
- **Wide `PromoBanner`** = the same masters with `width` + the two `Decor Circle` `x` overrides (no new masters); tablet CTA buttons are hug width (override `width: fit_content`).
- **Tablet garage strip** = five `fill_container` cards (no scroll: 124.8 dp each at 800, ~188 at 1280); phone = clipped scroll viewport with the next card peeking.
- **Populated 1-motor frame** has no draft (its only motor is in service, PRD 03) and no caption line under the status badge (single unit).
- **Greeting emoji:** Pencil draws it as a monochrome glyph (fill applies); Flutter shows the colour emoji, so the `waving_hand` fallback was not needed.
- **Promo carousel has no pause / play button** (the review proposed one, the user removed it at the review gate): the promo keeps the page dots only; auto-advance stops on touch / focus / hover and with reduce-motion.
- **Not built:** an error frame (PRD 04 lists loading, empty and populated only).

## Checklist

### Build
- [x] Kickoff questions answered (16 decisions above).
- [x] `AppShell` (compact + medium + large, 4 active-tab variants = 12) built as reusable with content slot.
- [x] Home block components built (sheet "Home blocks", light + dark).
- [x] Phone frames: loading, empty, populated built; dark copies of all three.
- [x] Tablet portrait + landscape frames: loading, empty, populated; dark populated on both.
- [x] Populated 1-motor / long-name frame; stress frames (360×640, text ×1.3) built and clean.
- [x] Screen-local components built and named; inventory additions listed in the index.
- [x] Demo content matches the step-01 sheet (booking code, motors, voucher-free values).

### Quality (automated, run in `execute`)
- [x] Clipping check on every step frame → zero `problems` (only the intentional clipped 360×640 viewport, the scroll viewports and `Decor` shapes are exempt).
- [x] Raw-hex audit → zero.
- [x] Every node named (generated silhouette internals exempt); every repeated element is a `ref` instance; no detached instances.
- [x] `placeholder` flag cleared on every finished root frame.
- [x] Coverage script: frame names match the matrix above (17 frames).

### /better-interface
- [x] Run `/better-interface` with scope = all S05 frames (names + node ids), light + dark, all breakpoints.
- [x] Report recorded below; all HIGH and MEDIUM fixed; LOW listed for the user; re-screenshot; verdict `Approve`.

### Review gate
- [x] Status set to 🔵; user shown: populated phone (light/dark), empty, loading, tablet-P, tablet-L, stress frames.
- [x] Every review round logged; user approval recorded (2026-09-24, "…remove it and approved after that, finish all left").

### Close (only after approval)
- [x] PNG export of the key frames (decision 16) to `design/pencil/exports/step05/` + `INDEX.md` (8 PNG + index, verified with `ls`).
- [x] Claude session file written (`docs/claude-session/07-design-step05-s05-home.md`).
- [x] Tracker in `00-index.md` set to ✅; inventory additions list updated.

## /better-interface report

**Scope:** S05 Beranda, 17 frames — Phone `jcjrw` `ALXSJ` `P1iEfF` `HHBLg` `HcsZK` `oleh5`, dark `cqX7g` `W9lsjI` `k9oVN` · Tablet-Portrait `d6h0h` `T9GQUw` `XnxOx`, dark `TFJWb` · Tablet-Landscape `zjTd6` `p69Dk` `AxrXi`, dark `Ty36e` — plus the sheets Shell Compact / Medium / Large `sxbrl` `nZsOR` `AW1Ie` and Home blocks `giPiP` (dark copies `k7aYr` `r7OrK` `s6gFb` `CjTfd`). Frame ids are the ones after the review regeneration · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens · **Convention docs found:** 00-index.md, prd/02, prd/06, steps 03 / 04 decisions

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | Focus / pressed states of every tappable card and tile, accessible names + semantics notes, 84 interactive nodes ≥ 48 × 48, motion notes (skeleton, promo auto-advance), focus order, text ×1.3 stress | 1 HIGH (fixed), 1 MEDIUM (fix declined by the user, see below) |
| Layout | Grouping and gaps, 92 dp nav clearance, scroll cues (phone strip / promo peek), tablet grids at 800 and 1280, fixed-height boxes at text ×1.3, alignment edges | 1 MEDIUM (fixed), 2 LOW |
| Writing | Sentence case, verb-first buttons, dialog copy, link text, empty-state next action, repeated status text | 2 LOW (fixed) |
| Typography | Truncation rules for names, 11 px status text, tabular figures (Not verified), heading roles | 1 MEDIUM (fixed), 1 LOW |
| Color | Contrast of 447 text + 211 icon nodes in both themes, non-text contrast of the progress segments, one filled action per view, semantic colour use | 2 MEDIUM (fixed), 1 LOW |
| UI | Radii inside cards, `shadow-accent` only on the booking CTA, press / focus feedback, motion durations, icon weights | 1 LOW (`Hapus draft` style); press feedback is in the Accessibility HIGH |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| HIGH | Accessibility | Home blocks `giPiP` · `QuickLinkTile` `ijiiz`, `GarageAddTile` `H6L0ht`, compact `VehicleSelectCard` `GRa50` / In Service `qfgpi` (used in every populated and empty frame) | Only `ActiveBookingCard` and `DraftResumeCard` had a focused specimen; the tiles and garage cards had no focus and no pressed state | Focused (2 dp `focus-ring` border) row `ztA72` and pressed (`surface-hover`) row `OFoQP` added to the sheet **[applied]** | Keyboard-reachable controls without a visible focus indicator (tablet + hardware keyboard, switch access); whole-card taps without press feedback |
| MEDIUM | Accessibility | Promo carousels: Populated / Empty `thz6j` `O726l` `yKcMh` (phone), `uNT72` `EAkeb` (tablet-P), `qz7GG` `WNM7T` (tablet-L) | Auto-advance every 5 s; only touch / focus / hover pause it, the dots are a non-interactive cue | Dots + a 48 dp pause / play `TsIconButton` (semantics "Jeda promo" / "Putar promo"): built, then **removed by the user at the review gate** ("i don't think we need Pause Play Button beside the pageindicator in home screen"); the promo keeps the dots only and the frame heights were re-measured **[declined]** | WCAG 2.2.2: auto-updating content needs a visible pause mechanism, not only pointer or focus side effects |
| MEDIUM | Color | `DraftResumeCard` masters `oDxJR` `xUmuG` (Populated frames) | Filled Primary "Lanjutkan" directly under the filled Primary booking CTA (`JFQZ5`) | Secondary tonal compact `lrZYX` (`DI95f` `qKIMJ`); the filled primary stays on the booking CTA **[applied]** | One filled action per view: peers stay neutral so the primary path reads first |
| MEDIUM | Color | `FleetProgress Segment` `dHiio` `HVcnp` `GtFi6` `EuPsM` `K4S5AU` `IO2jy` and the 5 Mini masters | `accent` fill on `border-default` track = 2.24 : 1 (light); the empty (Terjadwal) track 1.44 : 1 on the card | Track `surface-inset` + 1 dp `border-control` outline: fill / track 3.07, outline 3.82 (light), fill / track 7.76 (dark) **[applied]** | Non-text contrast (WCAG 1.4.11): the per-unit stage is readable only from the segments |
| MEDIUM | Typography | 1-motor frame `HHBLg` · `Garage Card (In Service)` `vQIbx` | Nickname "Vario 125 Kesayangan Ayah" wraps to 3 lines, no ellipsis (step 04 rule: 2 lines, then ellipsis) | "Vario 125 Kesayangan A…" (2 lines) + rule in note `bL3Kc` (maxLines 2, full value in semantics and S09) **[applied]** | Consistent truncation with a reachable full value; the 3-line card broke the strip alignment |
| MEDIUM | Layout | `TsIconButton` master `T8Vuf` · `Badge` `GiQEr` (bell in every frame); found by `Stress Text 1.3` `oleh5` (regenerated after the review) | Fixed `height: 16` around the count: at ×1.3 the count text clipped | Height from content (`fit_content`, still 16 at ×1) **[applied]** | No fixed-height boxes around text (PRD 06) |
| LOW | Writing | 1-motor frame `HHBLg` · `ActiveBookingCard` `r8ygMs` | Caption "Sedang dikerjakan" under the "1 motor · Dikerjakan" badge | Caption disabled: it only appears when units differ (decision 14) **[applied]** | Repeats the status |
| LOW | Writing | "Lihat semua" (garage `o4Io0p`) and "Lihat semua (3)" (stack `my1RS`) | Same bare link text for two destinations | Semantics labels "Lihat semua motor" / "Lihat semua booking aktif" in note `e5pHN` **[applied]** | Link text must name its destination |
| LOW | Layout | Tablet frames · `SectionTitleRow` in `Garage Section` (`qaQ3a`, `nRqjp`, …) | "Lihat semua" text ends 16 dp inside the card edge (ghost padding); phone fixed with header padding | Let the header bleed 16 dp into the page padding | Trailing edge misaligned with the cards below **[left]** |
| LOW | Layout | Empty tablet frames `T9GQUw` `p69Dk` · `BookingCtaCard (Hero)` `pbima` `Atnwe` | The text column fills the card, so the silhouette sits 500–700 dp from its text | Cap the text column width or move the silhouette next to it | Proximity: related items far apart **[left]** |
| LOW | Color | `PromoBanner` CTA `cUKfM` (step 04 masters) | Filled compact Primary competes with the booking CTA; the Outline swap fails the 3 : 1 boundary on dark `accent-soft` (2.24 : 1), so it was not applied | Decide together with the banner design in step 19 | One filled action per view **[left]** |
| LOW | UI | `DraftResumeCard` · `Hapus draft` `pMus9` `fYEKc` | Accent Ghost for a destructive trigger; step 03 decision 7 says destructive triggers use Danger Outline | Kept as decided at kickoff (decision 5); the confirm dialog is present | Convention drift **[left]** |
| LOW | Typography | Compact `UnitStatusBadge` in garage cards (`N5Jrj`), banners | Label Small 11 px (open since steps 03 / 04) | Decide with the type scale in step 19 | Small UI text **[left]** |

**Verification:** Passed — clipping on 28 roots (17 frames, 3 shell sheets, Home sheet, 4 dark copies, 3 note boxes): 0 rows except the intentional clipped 360×640 viewport (`HcsZK` Scroll Body), scroll viewports and `Decor` shapes; raw hex 0; unnamed 0 (generated silhouette internals exempt); `placeholder` 0; contrast (re-run after the pause button was removed) on 447 text + 199 icon nodes over 16 frames and the focus / pressed section, both themes: 0 fails (logo monogram 3.45 : 1 is a logotype, 5 nodes); segments 3.07 / 3.82 (light), 7.76 (dark); 224 interactive nodes ≥ 48 × 48; text ×1.3 stress frame re-run after the badge fix: no clipping; screenshots of the phone, tablet and stress sections and of the new focus / pressed / promo-control specimens. **Not verified** — Flutter rendering (glass NavBar, shimmer, promo carousel, ripple, `Badge` scaling), 320 px width and 200 % zoom, RTL, Exo 2 tabular figures (expiry, booking code), screen-reader output, the colour emoji (Pencil draws it monochrome), html2figma behaviour (first S05 import is step 12).
**Verdict:** Block → **Approve** after the fixes (the promo pause-button finding was declined by the user; the remaining risk is WCAG 2.2.2 on the auto-advance, mitigated by pause on touch / focus / hover and off with reduce-motion).
**Fixes applied:** HIGH focus / pressed specimens; MEDIUM Draft secondary button, FleetProgress outline, nickname truncation, badge height; LOW caption and link labels · **Declined by the user:** promo pause / play button · **LOW left for the user:** tablet "Lihat semua" inset, tablet hero spacing, promo CTA weight, "Hapus draft" style, 11 px badge text.

## Review rounds

#### Round 1 — 2026-09-24
- **Frames shown:** phone Populated light / dark, Empty, Loading, 1 motor, stress ×1.3; tablet-portrait and tablet-landscape Populated; the Shell and Home blocks sheets; the `/better-interface` report.
- **User feedback:** "i don't think we need Pause Play Button beside the pageindicator in home screen, remove it and approved after that, finish all left"
- **Changes made:** removed the pause / play button and the `PromoControls` masters and specimen section; the 7 promo indicator rows are plain `PageIndicator` rows again; frame heights re-measured (phone 1370 / 1019 / 1208, tablet-landscape 981 / 800); stress ×1.3, the dark frames and the dark Home sheet regenerated; clipping, raw hex, naming, placeholder, contrast and 48 dp checks re-run clean; notes and docs updated.
- **Outcome:** approved (conditional on the removal, done).

## Session log

| Time | Action | Result / node ids |
|---|---|---|
| 2026-09-24 | Kickoff interview | 4 rounds, 16 decisions, all recommended options accepted (`AskUserQuestion`); draft-vs-in-service conflict found and resolved (decision 1) |
| 2026-09-24 | Docs (kickoff record) | This file, `00-index` (tracker 🟡, inventory additions), `19-full-app-audit.md` (PRD 04 S05 corrections) |
| 2026-09-24 | Shell sheets | `AppShell` ×12 on Shell · Compact `sxbrl`, Medium `nZsOR`, Large `AW1Ie`; slot smoke test passed (instance height + `Nav Bar` y override) |
| 2026-09-24 | Home blocks `giPiP` | `FleetProgress` (segments + 5 minis), `ActiveBookingCard` ×2 (+ focus specimen, 2-card stack), `DraftResumeCard` ×2 (+ discard dialog), `BookingCtaCard` ×2, `QuickLinkTile`, `SectionTitleRow`, `VehicleSelectCard` In Service, `GarageAddTile`, bell 0 / 2 / 9+, `TsAppBar` Title + Bell, notes |
| 2026-09-24 | Phone frames | Populated `jcjrw`, Empty `ALXSJ`, Loading `P1iEfF`, 1 motor `HHBLg`, stress and dark copies (regenerated after the review, final ids in the frame table above) |
| 2026-09-24 | Tablet frames | Portrait `d6h0h` `T9GQUw` `XnxOx` + dark `dGS5a`; landscape `zjTd6` `p69Dk` `AxrXi` + dark `r2EOVj`; notes boxes and fold marker |
| 2026-09-24 | Automated checks | clipping, raw hex, naming, placeholders, contrast (447 text + 211 icons), 48 dp; found `Badge` fixed height clipping at ×1.3 (fixed) |
| 2026-09-24 | `/better-interface` | 13 findings (1 HIGH, 5 MEDIUM, 7 LOW); HIGH + MEDIUM + 2 LOW fixed; frames re-measured, dark copies and stress frames regenerated; re-checks clean; verdict Approve |
| 2026-09-24 | Review gate, round 1 | User asked to drop the promo pause / play button and approved: `PromoControls` masters and section deleted, 7 indicator rows restored, heights re-measured, derived frames + dark Home sheet regenerated (`HcsZK` `oleh5` `cqX7g` `W9lsjI` `k9oVN` `TFJWb` `Ty36e` `CjTfd`), all checks re-run clean |
| 2026-09-24 | Close | `Export` of 6 frames + Home blocks + Shell · Compact to `design/pencil/exports/step05/` (8 PNG + `INDEX.md`); session file written; tracker ✅ |
| 2026-09-25 | Step 19 audit fix (F9) | `Status Caption` master `IZ7z3`: "1 motor masih Diperiksa" → "1 motor masih diperiksa" (8 S05 frame instances follow) |
