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
- Breakpoints are evaluated against `MediaQuery.sizeOf(context).shortestSide`, matching Material 3 guidance (not raw width), so a tablet in portrait still counts as "tablet," not "compact."

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
| S02 Onboarding | full-bleed slide | centered card, max-width 560 | slide content left, illustration right (split) |
| S03/S04 Auth | centered form, full width | centered card, max-width 480 | form left (max 480) + brand illustration right |
| S05 Beranda | single column | 2-col card grid (promo + garage strip span) | rail nav + 2-col grid, wider promo carousel |
| S06 Notifikasi | single list | centered list, max-width 720 | list max-width 720, centered |
| S07 Garasi Saya | 1-col list | 2-col grid | 3-col grid |
| S08 Tambah/Edit Motor | full-width form | centered form, max-width 560 | form left, live preview card right |
| S09 Detail Motor | stacked sections | stacked, max-width 720 | hero left, details + history right (split) |
| S10 Pilih Motor | 1-col card list | 2-col card grid | 2–3-col card grid |
| **S11 Detail Servis** | chip tabs + stacked cards | chip tabs (top) + stacked cards, max-width 720 | **list-detail-summary**: unit rail (left) + config form (middle) + live estimate pane (right) at large; at expanded, rail + form only (estimate stays as sticky bar) |
| S12 Katalog | 1-col list | 2-col grid | 3–4-col grid |
| S13 Pilih Bengkel | 1-col list | 1-col list, max-width 720 | **list-detail split**: list left, S14 preview right |
| S14 Detail Bengkel | stacked sections | stacked, max-width 720 | map/photo left, info right |
| S15 Pilih Jadwal | date strip above slot grid | date strip above slot grid, wider grid | **side-by-side**: date strip left, slot grid right |
| S16 Ringkasan | stacked, sticky bottom bar | stacked, max-width 720, sticky bottom bar | **two-pane**: recap list left, sticky `PriceBreakdown` + CTA right |
| S17 Pilih Voucher | 1-col list | 1-col list, max-width 560 | 2-col grid |
| **S18 Booking Berhasil** | centered ticket, full width | centered ticket, max-width 560 | ticket left (max 480) + per-unit status list right |
| S19 Riwayat | 1-col list w/ tabs | 1-col list, max-width 720 | list-detail split (list left, S20 preview right) |
| S20 Detail Booking | stacked | stacked, max-width 720 | overview left, unit list + actions right |
| S21 Lacak Unit | vertical timeline | vertical timeline, max-width 640 | timeline left, mechanic/map card right |
| S22 Sheets | full-width bottom sheet | centered modal sheet, max-width 560 | centered modal sheet, max-width 560 |
| S23 Invoice | stacked breakdown | stacked, max-width 640 | breakdown left, summary card right |
| S24 Beri Ulasan | stacked form | centered, max-width 560 | form left, submitted-reviews preview right |
| S25 Profil | 1-col menu list | centered, max-width 560 | menu left, active panel (e.g. theme preview) right |
| S26 Mode Demo | stacked controls | centered, max-width 560 | controls left, live status preview right |

## Safe-layout rules (checklist, applied to every screen)

- `SafeArea` wraps all scaffolds; sticky bottom bars additionally account for the bottom system inset (gesture nav) on top of their own padding.
- No fixed-height `Container`s around text — use intrinsic sizing or `Flexible`/`Expanded` inside `Row`/`Column`, so translated or longer Indonesian strings never clip.
- Scrollable content (`ListView`/`CustomScrollView`) instead of unconstrained `Column`s wherever content can exceed the viewport (every form screen, every list screen).
- `MediaQuery.viewInsets.bottom` respected on every text-input screen — content scrolls above the keyboard, sticky CTAs reposition above it, never behind it.
- Text scale factor tested up to 1.3 (accessibility large-text setting) without overflow — verified specifically on dense screens: S11 chip tabs, S16 price breakdown, S18 ticket.
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
