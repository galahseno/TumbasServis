# 06 — Responsive & Safe Layout

Covers the bonus criterion "Tampilan Responsif & Safe Layout" and the extended requirement to support both mobile and tablet layouts (portrait + landscape on tablet).

## Window size classes (Material 3)

| Class | Width range | Nav pattern | Content |
|---|---|---|---|
| Compact | < 600dp | Bottom `NavBar` (glass) | Single-pane, full-width cards |
| Medium | 600–839dp | `NavigationRail` | Content max-width ~720dp, centered; 2-col grids where listed |
| Expanded | 840–1199dp | `NavigationRail` | Two-pane list-detail where listed |
| Large | ≥1200dp | Extended `NavigationRail` (with labels) | Up to three-pane on the busiest screen (S11) |

- **Orientation policy:** phone (shortest side < 600dp) is **portrait-locked** at the OS level. Tablet (shortest side ≥ 600dp) supports **both orientations** — the app must reflow, not just letterbox, when rotated.
- **Device type** (phone vs tablet, orientation lock) is decided by `MediaQuery.sizeOf(context).shortestSide` (≥ 600dp = tablet). The **layout class** in the table above is decided by the current window **width** (Material 3), so a tablet in portrait (≈ 800dp wide) is Medium and the same tablet in landscape (≈ 1280dp wide) is Large, matching the per-screen table below. In split-screen a narrow tablet window can legitimately fall to Compact.

## Grid

| Class | Columns | Margin |
|---|---|---|
| Compact | 4 | 16dp |
| Medium | 8 | 24dp |
| Expanded/Large | 12 | 24dp |

## Per-screen layout table

| Screen | Phone (compact) | Tablet portrait (medium/expanded) | Tablet landscape (expanded/large) |
|---|---|---|---|
| S01 Splash | centered logo | centered logo, same | centered logo, same |
| S02 Onboarding | art band on top + title / body / dots / CTA | centered card, max-width 560 | slide content left, illustration right (split) |
| S03/S04 Auth | top-aligned left text, terms pinned at the bottom | centered `AuthCard`, max-width 480 | form left (max 480) + `AuthHero` brand panel right |
| S05 Beranda | single column | rail nav + 2-col card grid (promo + garage strip span) | rail nav + 2-col grid, wider promo carousel |
| S06 Notifikasi (pushed, no nav) | single list | centered list, max-width 720 | list max-width 720, centered |
| S07 Garasi Saya | 1-col list | 2-col grid (content 720) | 3-col grid |
| S08 Tambah/Edit Motor | full-width form, flat sticky "Simpan" | centered form, max-width 560; model picker = centered modal 560 | form left, live preview card right |
| S09 Detail Motor | stacked sections | stacked, max-width 720 (full-scroll) | hero + CTA + delete link left (400), details + history right (640) |
| S10 Pilih Motor | 1-col card list | 2-col card grid | 3-col card grid (content max ~1040) |
| **S11 Detail Servis** | chip tabs + stacked cards + glass estimate bar | medium: chip row on top + form (max 720) + glass pill | **expanded (840–1199):** unit rail 252 + form 700 + glass pill; **large (≥ 1200): list-detail-summary** — rail 252 · form 572 · live `EstimatePane` 360 (static per-unit lines, no voucher); 1 unit = form 720 + pane 360, centered |
| S12 Katalog (full page over S11) | 1-col list | 2-col grid (720); detail = centered modal 560 | 4-col grid; detail = centered modal 560 |
| S13 Pilih Bengkel | 1-col list | 1-col list, max-width 720 | **list-detail split**: expanded list 400 + S14 pane 552; large list 440 + pane 768 with the CTA pinned at the pane bottom |
| S14 Detail Bengkel | stacked sections | stacked, max-width 720 | standalone: photo + map left (560), info right (648) |
| S15 Pilih Jadwal | date strip above a 3-col slot grid, flat footer | same, wider grid | expanded: date grid 400 + slots 552; large: 2-week calendar grid (7 × 3) 480 + slots 728 (split: unit rail 240 · grid 420 · slots 524) |
| S16 Ringkasan | stacked, flat sticky bar | stacked, max-width 720, flat sticky bar | **two-pane**: expanded recap 592 + pane 360; large recap 720 + pane 360 (centered); the pane holds the voucher row, estimate block, payment note and the CTA |
| S17 Pilih Voucher (full page) | 1-col list | 1-col list, max-width 560 | 2 cols × 440 |
| **S18 Booking Berhasil** | centered ticket, full width, flat sticky CTA bar | centered ticket, max-width 560, flat sticky bar | ticket 480 + status panel 400 side by side (904, centered), the CTAs under the panel; the panel rows are read-only |
| S19 Riwayat | 1-col list w/ scrolling tabs | 1-col list, max-width 720 | list-detail split (list left, S20 preview right) |
| S20 Detail Booking | stacked | stacked, max-width 720 | overview left, unit list + actions right |
| S21 Lacak Unit | vertical timeline | vertical timeline, max-width 640 | unit header + timeline left, ETA + mechanic + Mode Demo shortcut right (no map) |
| S22 Sheets | bottom sheet anchored to the bottom edge | centered modal, max-width 560 (title row + close, no handle); cancel dialog 400 | same sizes as Tablet-P (no separate frame) |
| S23 Invoice | stacked breakdown, flat footer | stacked, max-width 640 | breakdown 720 + `InvoiceSummaryCard` 360 |
| S24 Beri Ulasan | stacked form | centered, max-width 560 | form left, live recap preview of the user's own review right |
| S25 Profil | 1-col menu list | centered, max-width 560; About = modal | menu left, "Pratinjau tema" panel (forced-theme mini app) right |
| S26 Mode Demo (pushed, no nav) | stacked controls | centered, max-width 560 | controls left (Kecepatan + Status), live preview + Simulasi galat + Data demo right |

- **Booking flow chrome:** S10–S18 show no `NavBar` / `NavRail` at any size (focused flow); on tablet the app bar and stepper are full width and the content is centered at the max width above, so multi-pane layouts (S11, S15, S16) get the full width.
- **Design frames:** tablet frames are fixed viewports (no status / gesture bar); a few pages are full-scroll captures taller than the viewport (S05 and S06 / S26 Tablet-L, S09 / S26 Tablet-P). The 1024×768 Expanded class has frames for S11, S13, S15 and S16.

## Safe-layout rules (checklist, applied to every screen)

- `SafeArea` wraps all scaffolds; sticky bottom bars additionally account for the bottom system inset (gesture nav) on top of their own padding.
- No fixed-height `Container`s around text — use intrinsic sizing or `Flexible`/`Expanded` inside `Row`/`Column`, so translated or longer Indonesian strings never clip.
- Scrollable content (`ListView`/`CustomScrollView`) instead of unconstrained `Column`s wherever content can exceed the viewport (every form screen, every list screen).
- `MediaQuery.viewInsets.bottom` respected on every text-input screen — content scrolls above the keyboard, sticky CTAs reposition above it, never behind it.
- Text scale factor tested up to 1.3 (accessibility large-text setting) without overflow — verified specifically on dense screens: S11 chip tabs, S16 price breakdown and voucher row, S18 ticket (the design carries ×1.3 and 360×640 stress frames for S05, S11, S16, S18 and ×1.3 for S06, S10, S13, S14, S15, S25, S26). A row that must survive large text is a column / `Wrap`, never a fixed-width hug row.
- Long/variable content — motor nicknames, plate numbers, workshop names, complaint notes in list previews — always wrapped in `Text(overflow: TextOverflow.ellipsis, maxLines: n)` inside a bounded width, never assumed short.
- Minimum tap target 48×48dp on every interactive element (chips, checkboxes, icon buttons), even where the visual icon is smaller.
- Images/photos (workshop photos, motor photos) always have an aspect-ratio-boxed placeholder so layout doesn't jump/overflow while loading or when a photo is absent.

## Device test matrix

Verify zero overflow ("yellow-black bars") and correct breakpoint selection on:

| Device class | Resolution (logical dp, approx) |
|---|---|
| Small phone | 360×640 |
| Standard phone | 360×800 |
| Modern phone (tall) | 393×852 |
| Large phone | 412×915 |
| Tablet portrait | 800×1280 |
| Tablet landscape | 1280×800 |
| Small tablet / large phone landscape edge case | 1024×768 |
| Foldable-like (medium boundary stress test) | 673×841 |

Every P0 screen (S05, S10, S11, S13, S15, S16, S18) must be manually checked against this full matrix before the APK is cut; P1/P2 screens checked at minimum on the standard phone and one tablet size.
