# 02 — Brand & Design System

## Brand rationale

The assessment's bonus criterion asks for "Servisin Aja" brand identity (official orange palette, from servisinaja.id). This project uses a **custom brand, TumbasServis**, built from the candidate's own personal site (`https://galahsenoadjie.vercel.app/`) instead — a deliberate choice, not an oversight. TumbasServis's palette is also orange-led, keeping visual kinship with the Servisin Aja ecosystem while demonstrating independent design-system work end-to-end (tokens → components → dark mode). This trade-off is called out explicitly in the submission notes (see [08](08-deliverables-acceptance.md)).

## Logo

- **Mark:** "TS" monogram, set in Exo 2 ExtraBold, centered in a rounded-square tile (corner radius 22 on a 40×40 base, scales proportionally).
- **Light mode:** tile fill `--orange-500` (`#E4622F`), monogram `#FFFFFF`.
- **Dark mode:** tile fill `--orange-400` (`#FF8551`), monogram `#1A0E07` (near-black, for contrast — see accessibility rule below).
- **Wordmark:** "Tumbas" in `text-heading` color + "Servis" in `text-accent` color, Exo 2 SemiBold, used next to the mark in app bars/splash — never the mark alone smaller than 24dp (monogram becomes illegible below that).
- **App icon:** monogram on solid tile fill, no wordmark, exported for adaptive icon (foreground: monogram; background: tile color) plus a legacy square/round fallback.
- **Splash:** tile mark centered on `bg-page`, no wordmark, optional "TumbasServis" wordmark fading in below after ~400ms (respects reduce-motion: show static).

## Color tokens

### Primitives (extracted from galahsenoadjie.vercel.app CSS custom properties)

| Token | Hex |
|---|---|
| `orange-100` | `#FFE8DB` |
| `orange-300` | `#FFAE81` |
| `orange-400` | `#FF8551` |
| `orange-500` | `#E4622F` |
| `orange-600` | `#C24C1D` |
| `sand-0` | `#FFFFFF` |
| `sand-50` | `#FBFAF9` |
| `sand-100` | `#F4F1EE` |
| `sand-200` | `#E8E3DE` |
| `sand-300` | `#D6CFC8` |
| `sand-400` | `#B0A79F` |
| `sand-500` | `#8A817A` |
| `sand-700` | `#463F3A` |
| `sand-900` | `#1A1716` |
| `sand-950` | `#100E0D` |
| `green-400` | `#4FB477` |
| `red-400` | `#E4574F` |

Not present on the source site — derived to fill out semantic needs, flagged here for transparency:

| Token | Hex | Use |
|---|---|---|
| `warning-400` | `#D99A2B` | warning states (e.g. slot almost full) |
| `info-400` | `#5B8DEF` | informational banners |
| `sand-600` | `#756C65` | `text-muted` in light mode (darker than site `sand-500`, see accessibility rule) |
| `orange-700` | `#B04418` | `text-on-accent-soft` in light mode |
| `green-100` `green-700` | `#EAF6EF` `#33794F` | `success-soft` (light) / `success-text` (light) |
| `warning-100` `warning-700` | `#FAF3E6` `#8F641A` | `warning-soft` (light) / `warning-text` (light) |
| `info-100` `info-300` `info-700` | `#EBF1FD` `#6090EF` `#1F63E9` | `info-soft` (light) / `info-text` (dark) / `info-text` (light) |
| `red-100` `red-300` `red-700` | `#FCEBEA` `#E76861` `#CC291F` | `danger-soft` (light) / `danger-text` (dark) / `danger-text` (light) |

### Semantic tokens — Light / Dark

| Semantic token | Light | Dark |
|---|---|---|
| `bg-page` | `sand-50` `#FBFAF9` | `sand-950` `#100E0D` |
| `surface-card` | `sand-0` `#FFFFFF` | `#191615` |
| `surface-inset` | `sand-100` `#F4F1EE` | `#141211` |
| `surface-hover` | `sand-100` `#F4F1EE` | `#232020` |
| `text-heading` | `sand-900` `#1A1716` | `#F7F4F2` |
| `text-body` | `sand-700` `#463F3A` | `#C9C1BB` |
| `text-muted` | `sand-600` `#756C65` (site `sand-500` fails AA, see accessibility rule) | `#9A918B` |
| `text-faint` | `sand-400` `#B0A79F` | `#6C645F` |
| `accent` | `orange-500` `#E4622F` | `orange-400` `#FF8551` |
| `accent-fill` | `orange-600` `#C24C1D` | `orange-400` `#FF8551` — filled buttons and selected fills that carry `text-on-accent` (the M3 `primary` button variant) |
| `accent-hover` | `orange-600` `#C24C1D` | `orange-300` `#FFAE81` |
| `text-accent` | `orange-600` `#C24C1D` | `orange-400` `#FF8551` |
| `text-on-accent` | `#FFFFFF` | `#1A0E07` |
| `accent-soft` | `orange-100` `#FFE8DB` | `orange-400 @ 16%` |
| `text-on-accent-soft` | `orange-700` `#B04418` | `orange-400` `#FF8551` |
| `border-subtle` | `sand-200` `#E8E3DE` | `#282422` |
| `border-default` | `sand-300` `#D6CFC8` | `#363130` |
| `border-strong` | `sand-400` `#B0A79F` | `#4B4442` |
| `border-control` | `sand-500` `#8A817A` | `#6C645F` |
| `border-accent` | `orange-500` | `orange-400` |
| `focus-ring` | `orange-600` `#C24C1D` (was `orange-500`; 2.92 : 1 on `accent-soft`, now 4.10 : 1, design step 19) | `orange-400` `#FF8551` |
| `success` | `green-400` `#4FB477` | `green-400` `#4FB477` |
| `danger` | `red-400` `#E4574F` | `red-400` `#E4574F` |
| `warning` | `warning-400` `#D99A2B` | `warning-400` `#D99A2B` |
| `info` | `info-400` `#5B8DEF` | `info-400` `#5B8DEF` |
| `success-text` | `green-700` `#33794F` | `green-400` `#4FB477` |
| `warning-text` | `warning-700` `#8F641A` | `warning-400` `#D99A2B` |
| `info-text` | `info-700` `#1F63E9` | `info-300` `#6090EF` |
| `danger-text` | `red-700` `#CC291F` | `red-300` `#E76861` |
| `success-soft` | `green-100` `#EAF6EF` | `green-400 @ 16%` |
| `warning-soft` | `warning-100` `#FAF3E6` | `warning-400 @ 16%` |
| `info-soft` | `info-100` `#EBF1FD` | `info-400 @ 16%` |
| `danger-soft` | `red-100` `#FCEBEA` | `red-400 @ 16%` |
| `danger-fill` | `red-700` `#CC291F` | `red-300` `#E76861` |
| `text-on-danger` | `#FFFFFF` | `#1A0E07` |
| `surface-inverse` | `sand-900` `#1A1716` | `sand-100` `#F4F1EE` |
| `text-on-inverse` | `sand-50` `#FBFAF9` | `sand-900` `#1A1716` |
| `accent-on-inverse` | `orange-300` `#FFAE81` | `orange-700` `#B04418` |
| `skeleton-base` | `sand-200` `#E8E3DE` | `#282422` |
| `skeleton-highlight` | `#FFFFFF` | `#363130` |
| `illustration-outline` | `sand-900 @ 8%` | `#FFFFFF1A` |
| `accent-pressed` | `orange-700` `#B04418` | `orange-300` `#FFAE81` |
| `danger-pressed` | `#B3231A` | `#EE8580` |
| `state-pressed` | `sand-900 @ 10%` (`#1A17161A`) | `#FFFFFF1F` |
| `bg-page-clear` | `sand-50 @ 0%` (`#FBFAF900`) | `sand-950 @ 0%` (`#100E0D00`) — transparent end of the scroll-edge fade (`bg-page-clear` → `bg-page`) on tab chips and the date strip (added step 04) |
| `scrim` | `sand-900 @ 40%` (`#1A171666`) | `#000000A6` — the dim layer behind dialogs, sheets and modals (step 06) |
| `rating-star` | `warning-700` `#8F641A` | `warning-400` `#D99A2B` — filled and half stars in `RatingStars`, `WorkshopCard`, `MechanicCard`; same values as `warning-text`, its own role (step 19) |
| glass and elevation tokens | see *Elevation & shadow* and *Glassmorphism signature* | `glass-tint`, `glass-tint-strong`, `glass-border`, `glass-sheen-top` / `-bottom`, `glass-shadow-1` / `-2`, `shadow-sm-1` / `-2`, `shadow-md-1` / `-2`, `shadow-accent` (built as variables in the design file) |

### Accessibility rule (important — deviates from raw site tokens)

White text on `orange-500` (`#E4622F`) measures **~3.4:1** contrast — fails WCAG AA for normal text (needs 4.5:1). The source site uses this combination only for large glow/accent elements, not body-sized button labels. TumbasServis therefore splits the role:

- **Filled buttons / text-on-accent surfaces (light mode):** use `orange-600` (`#C24C1D`) as the fill, giving white text **~4.8:1** — passes AA.
- **Brand surfaces that don't carry text directly** (logo tile, hero backgrounds, selection borders, progress indicators, icons): `orange-500` is fine.
- **Dark mode:** `#1A0E07` on `orange-400` (`#FF8551`) measures **~7.9:1** — passes comfortably, no substitution needed.

The rule "white on `orange-600`" is the first of several deliberate divergences from the site's raw tokens. All were measured (WCAG relative luminance, resolved hexes) in design step 02 and must be respected in both Figma styles and Flutter `ColorScheme`:

- **`text-muted` (light):** site `sand-500` `#8A817A` is 3.66 / 3.82 / 3.39 : 1 on `bg-page` / `surface-card` / `surface-inset`. It carries captions, hints and timestamps, so light mode uses `sand-600` `#756C65` (4.93 / 5.14 / 4.56 : 1). Dark `#9A918B` already passes (5.82–6.23).
- **`text-faint`:** 2.3 : 1 (light) / 3.1–3.3 : 1 (dark). Decorative only — never content, labels or placeholders.
- **Status as text:** `success` / `warning` / `info` / `danger` on white measure 2.58 / 2.44 / 3.23 / 3.64 : 1. The base tokens are for **icons, dots and borders only**. A status badge is a `*-soft` tint background + `*-text` label + an icon (never color alone); every pair is ≥ 4.6 : 1 in both modes.
- **Control boundaries (WCAG 1.4.11):** `border-default` is 1.4–1.5 : 1. Inputs, checkboxes, radios and unselected chips use `border-control` (≥ 3 : 1); `border-default` / `border-subtle` are for cards and dividers.
- **Focus ring:** every focusable control shows a 2dp solid `focus-ring` with a 2dp offset (the source site's `:focus-visible` recipe), measured ≥ 3 : 1 on every surface in both modes (light `orange-600`: 4.83 : 1 on white, 4.10 : 1 on `accent-soft`; dark `orange-400`: ≥ 3.07 : 1). Never removed, never clipped. Flutter: `FocusTheme` / `Focus` decoration on `TsButton`, `TsTextField`, `TsChip`, list rows, nav items. Exceptions (step 03): a control whose border is the indicator uses the 2dp `focus-ring` as that border with no offset (`TsTextField`, nav bar / rail items, dialog choice rows); on the inverse surface (`TsSnackbar` action) the ring is `accent-on-inverse`, because `focus-ring` measures only 2.14 : 1 on the dark-mode inverse surface.
- **Pressed states:** filled buttons press to `accent-pressed` / `danger-pressed`; secondary and outline buttons keep their fill and press to a `border-accent` border; ghost presses to `accent-soft`; `state-pressed` is the state layer of `TsIconButton`. A dark overlay on a tonal fill would fall below 4.5 : 1.
- **`surface-hover` and bordered controls:** `border-control` on `surface-hover` is 2.79 : 1 in dark, so `surface-hover` fills borderless rows and tiles only; a bordered control keeps its fill when pressed and changes only its border to `border-accent`. `text-accent` (4.29 : 1 in light) is not used on `surface-inset` or `surface-hover`; use `text-on-accent-soft` there.
- **Text on `accent-soft`:** `text-accent` on `orange-100` is 4.1 : 1, so text on `accent-soft` uses `text-on-accent-soft` (4.83 light, ≥ 5.7 dark).

### Material 3 mapping

Map semantic tokens into Flutter's `ColorScheme` plus a custom `ThemeExtension` for tokens M3 doesn't model:

```
ColorScheme:
  primary            → accent (button-fill variant: orange-600 light / orange-400 dark)
  onPrimary          → text-on-accent
  primaryContainer   → accent-soft
  onPrimaryContainer → text-on-accent-soft
  surface            → bg-page
  surfaceContainerLow/Lowest → surface-inset
  surfaceContainer/High      → surface-card
  onSurface          → text-heading
  onSurfaceVariant   → text-body / text-muted
  outline            → border-control
  (focus ring        → focus-ring, drawn by the app's FocusTheme)
  outlineVariant     → border-subtle
  error              → danger-fill (solid confirm) / danger (borders, icons)
  onError            → text-on-danger
  errorContainer     → danger-soft
  onErrorContainer   → danger-text
  inverseSurface     → surface-inverse
  onInverseSurface   → text-on-inverse
  inversePrimary     → accent-on-inverse

TsThemeExtension (custom):
  textMuted, textFaint, borderDefault, borderStrong, focusRing,
  success, warning, info, successText, warningText, infoText, dangerText,
  successSoft, warningSoft, infoSoft, dangerSoft,
  glassTint, glassBorder, glassSheen, glassShadow, shadowSm, shadowMd, shadowAccent
```

### Status colors (per booking-unit status)

| Status | Base token (icon / dot / border) | Badge (soft bg + text) | Notes |
|---|---|---|---|
| Terjadwal (Scheduled) | `text-muted` / `border-default` | `surface-inset` + `text-muted` | neutral, not yet started |
| Check-in / Antre (Queued) | `info` | `info-soft` + `info-text` | arrived, waiting for bay |
| Diperiksa (Inspecting) | `warning` | `warning-soft` + `warning-text` | in diagnosis |
| Dikerjakan (In progress) | `accent` | `accent-soft` + `text-on-accent-soft` | active work |
| QC (Quality check) | `warning` | `warning-soft` + `warning-text` | final check |
| Selesai (Done) | `success` | `success-soft` + `success-text` | complete |
| Dibatalkan (Cancelled) | `danger` | `danger-soft` + `danger-text` | terminal, cancelled |

Every badge also carries a status icon and label — color is never the only signal.

## Typography

- **Family:** Exo 2 (variable font), bundled as a Flutter asset (`assets/fonts/Exo2-Variable.ttf` + italic) — not fetched at runtime, matching the site's `@font-face` approach but self-hosted for offline/APK reliability.
- **Weights shipped:** 400 (Regular), 600 (SemiBold), 800 (ExtraBold, logo monogram only).
- **Type scale** (Material 3 roles, Exo 2):

| Role | Size / Line-height | Weight | Tracking |
|---|---|---|---|
| Display Small | 36 / 44 | SemiBold (600) | −0.025em |
| Headline Large | 28 / 34 | SemiBold | −0.025em |
| Headline Small | 22 / 28 | SemiBold | −0.025em |
| Title Large | 20 / 26 | SemiBold | normal |
| Title Medium | 16 / 22 | SemiBold | normal |
| Body Large | 16 / 24 (relaxed) | Regular (400) | normal |
| Body Medium | 14 / 22 | Regular | normal |
| Body Small | 12 / 18 | Regular | normal |
| Label Large (buttons) | 14 / 20 | SemiBold | 0.025em (wide) |
| Label Medium (nav labels) | 12 / 16 | SemiBold | 0.025em |
| Label Small (badges) | 12 / 16 | SemiBold | 0.025em |

Label Small was raised from 11 to 12 in design step 12 so that **no text in the product is below 12 sp** (the `TsLogo` monogram inside the mark is logo art and exempt). It now equals Label Medium; keep both roles for M3 parity but map Flutter `labelSmall` and `labelMedium` to one `TextStyle`.

Filter chips use Label Large (14 / 20): they are tap targets and carry longer Indonesian text.

Headings use tight tracking (`−0.025em`, matching the site's `--tracking-tight`); button/badge labels use wide tracking (`--tracking-wide`) for legibility at small sizes.

## Spacing & radius

- **Spacing scale (4pt base):** 4, 8, 12, 16, 20, 24, 32, 40, 48.
- **Radius:**
  - `radius-sm` 8dp — small chips, badges
  - `radius-md` 12dp — inputs, buttons, controls
  - `radius-lg` 16dp — cards
  - `radius-xl` 22dp — bottom sheets (top corners), logo tile
  - `radius-pill` 999dp — pill chips, segmented tabs, glass nav bar

## Elevation & shadow

| Token | Value (light) |
|---|---|
| `shadow-sm` | `0 1px 2px rgba(26,23,22,0.06), 0 4px 12px -4px rgba(26,23,22,0.12)` |
| `shadow-md` | `0 2px 4px rgba(26,23,22,0.08), 0 14px 28px -10px rgba(26,23,22,0.18)` |
| `shadow-accent` | `0 10px 26px -8px rgba(228,98,47,0.35)` — used only on the primary booking CTA |

Dark mode uses the source site's values, tuned for near-black surfaces:

| Token | Value (dark) |
|---|---|
| `shadow-sm` | `0 1px 2px #00000080, 0 4px 14px -4px #00000099` |
| `shadow-md` | `0 2px 4px #0000008C, 0 16px 32px -10px #000000B3` |
| `shadow-accent` | `0 10px 26px -8px rgba(255,133,81,0.26)` (`orange-400 @ 26%`) |

## Glassmorphism signature

A restrained "glass" treatment marks two specific surfaces as the brand's signature move — not used everywhere:

- **Bottom navigation bar** and **sticky estimate/price bar** (in the booking flow) use frosted glass: `backdrop-filter: blur(14px) saturate(180%)`, tint `sand-0 @ 42%` (light) / `#1C1918 @ 40%` (dark), 1px `glass-border`, inset `glass-sheen` highlight, `glass-shadow` drop shadow. Values from the source site: `glass-border` `sand-900 @ 8%` (light) / `#FFFFFF1A` (dark); `glass-sheen` `inset 0 1px 0 #FFFFFFBF, inset 0 -1px 0 #FFFFFF40` (light) / `inset 0 1px 0 #FFFFFF17, inset 0 -1px 0 #FFFFFF08` (dark); `glass-shadow` `0 1px 1px sand-900 @ 4%, 0 8px 28px -8px sand-900 @ 18%` (light) / `0 1px 1px #00000066, 0 10px 30px -10px #000000B3` (dark). In Pencil `saturate` does not exist and the blur radius is 28 (= CSS 14px); the Figma/Flutter implementation should keep `saturate(180%)` where the platform supports it.
- **NavBar tint:** the bottom `NavBar` uses `glass-tint-strong` (content always scrolls under it, so its backdrop is unpredictable); the `StickyEstimateBar` keeps the standard 42 % `glass-tint`.
- **Text on glass:** only `text-heading` / `text-body`, never `text-muted` / `text-faint`. Measured `text-body` on `glass-tint`: light over `bg-page` / `surface-card` 10.1 / 10.3 : 1, over `orange-500` 5.1 : 1 (pass), over `sand-900` 2.4 : 1 (fail); dark over `bg-page` / `surface-card` 10.5 / 10.0 : 1 (pass), over `orange-400` / `orange-500` 2.9 / 3.8 : 1 (fail). Where the backdrop is unpredictable (content, promo banners scrolling under the bar) use the site's denser `glass-tint-strong` (`sand-0 @ 80%` light / `#1C1918 @ 80%` dark), which measures ≥ 5.2 : 1 over every case above. **`StickyEstimateBar` (step 04):** the 42 % tint stays in both themes because its text is `text-heading` only; measured over the S11 worst-case backdrops, `text-heading` is ≥ 7.4 : 1 (light) / ≥ 4.7 : 1 (dark, even over a solid accent fill), whereas `text-body` falls to 4.3 : 1 / 2.9 : 1 over a solid accent fill, so `text-body` is not used on this bar.
- **Budget:** at most 1–2 `BackdropFilter` widgets visible on screen at once (perf cost in Flutter); never stack glass panels.
- Everything else uses flat `surface-card` — glass is an accent, not the default.

## Iconography, illustration, imagery, motion

- **Icons:** **Material Symbols Rounded** (decided in design step 02), 24dp default, weight 400, `text-body` / `text-muted` fill, `accent` when active / selected. The design tool has no fill axis, so selected = weight 700 + `accent` (+ an indicator pill), never filled-vs-outlined; the Flutter build may use the filled variant for the same state. Rating stars are token-bound paths (`Icons.star_rounded` / `star_outline_rounded` / `star_half_rounded` in Flutter).
- **Illustrations:** flat, geometric vector illustrations in the orange/sand palette for empty / error / success states (empty garage, no bookings, no notifications, offline, empty search) and three motor silhouettes — no photographic stock in illustration slots. Onboarding art (S02) is built from real components on a tonal `accent-soft` panel (silhouettes + ticket, motor cards + service pills, timeline + fleet progress), so it follows the theme; generated SVG budget used: 8 of ≈ 11 (generated art is not theme-aware and needs a light tile in dark mode).
- **Imagery:** motor category silhouettes (matic/bebek/sport) for garage cards when no photo is set; workshop photos are placeholder/generic (no real business names/photos claimed as real).
- **Motion:** micro-interactions (chip select, checkbox, button press) 150ms `ease-out`; page/route transitions ~250ms; status timeline step reveals ~300ms staggered. All motion respects `MediaQuery.disableAnimations` / reduce-motion.

## Voice & microcopy

- All UI copy in **Bahasa Indonesia**, friendly and concise (not formal-bureaucratic) — e.g. "Yuk, pilih motor yang mau diservis" rather than "Silakan pilih kendaraan Anda."
- Capitalization: **sentence case** for buttons, chips, titles and headings ("Lihat detail", "Tambah motor", "Ubah jadwal"); proper nouns and service names keep their case ("Bengkel Jaya Motor", "Servis Berkala"). Wireframe copy in `04-screens.md` is aligned to this rule (design step 19). Dialog dismiss is **"Batal"**; only the cancel-booking dialog (S22, confirm "Ya, batalkan") uses **"Kembali"**. The UI says "jam" (not "slot"), "motor" for capacity, and every price is an estimate ("Estimasi", "Total estimasi").
- Number format: Indonesian Rupiah, thousands-dotted, no decimals — `Rp412.000` (`id_ID` locale via `intl`).
- Date format: `EEE, d MMM yyyy` → "Sen, 29 Sep 2026". Time format: 24-hour, dot separator → "09.00".

## Component inventory

One-to-one mapping target: each Figma component becomes exactly one Flutter widget. Variants below are Figma variant properties and Flutter constructor states.

| Component | Key variants |
|---|---|
| `TsButton` | primary / secondary (tonal) / outline / ghost / danger (solid, dialog confirm only) / danger-outline (on-screen destructive trigger) × default/pressed/focused/disabled/loading |
| `TsTextField` | default/focused/error/disabled, with optional prefix icon |
| `TsChip` | filter chip: unselected/selected/disabled |
| `VehicleTabChip` | complete (✓) / incomplete (○) / error, each also **active** (selected style keeping its glyph); `Layout=Rail` for the tablet unit rail |
| `VehicleSelectCard` | selectable/selected/disabled (with "sedang diservis" reason) |
| `ServiceOptionTile` | checkbox-style (default, multi-select; ≥ 1 per unit) or radio-style (exclusive group), default/selected/disabled |
| `PartOptionTile` | checkbox-style with price, `Layout=Compact` (list) / `Grid` (tablet), default / selected / incompatible (with a category + cc reason) / loading |
| `WorkshopCard` | list item: photo, name, rating · distance, open / closed badge, bays + "Estimasi N jam untuk M motor" row; states open / closed / selected ("Dipilih" tag) / loading |
| `SlotChip` | time row (status icon + time) over a caption "Sisa n motor" / "Penuh" / "Dipilih" / "Tersedia"; available / limited (≤ 2 motors left) / short (fewer seats than selected units, disabled) / full (disabled) / selected; slots earlier than now + 2 h show disabled "Lewat" |
| `DateStripItem` | horizontal date scroller item: default/selected/today |
| `BookingStepper` | 4-step horizontal progress indicator; phone = numbered circles + one caption row, wide = all four labels inline |
| `StickyEstimateBar` | glass bar on S11 only: "Estimasi · 1 jam" over the total + Lanjut CTA, pinned to bottom; states default / CTA disabled (reason line) / loading / error. Other booking steps use flat bars (`SelectionFooter`, `ConfirmBar`, `WorkshopCtaBar`, `SelectedPartsBar`) |
| `PriceBreakdown` | line-item list: label, qty, price, subtotal, discount, total; variants `Confirm` (S16, static per-unit lines, titled "Estimasi biaya", total "Total estimasi"), `Invoice` (S23, every unit expanded), `Pane` (tablet), `Loading`; the step-04 `Summary` / accordion variants are superseded |
| `TicketCard` | perforated-edge ticket card, per-unit sub-section; the booking code appears once with a copy button and a real scannable QR (`QrCode`, dark on a white tile in both themes); `Layout=Phone` / `Landscape`, loading skeleton; `TicketCard Units Panel` = the Tablet-L status list |
| `UnitStatusBadge` | one per status color (table above) |
| `StatusTimeline` | vertical stepper: done/current/pending nodes |
| `MechanicCard` | avatar/initial, name, rating |
| `PromoBanner` | carousel card, image/gradient + CTA |
| `VoucherCard` | selectable, eligible/ineligible (with reason) |
| `RatingStars` | display (read-only, half values) + input (whole stars, 5 × 48 dp targets, live word label "Buruk / Kurang / Cukup / Baik / Sangat baik" + "n dari 5", `Semantics` value, arrow keys); Large / Compact |
| `NotificationTile` | read / unread (dot + semibold title + hidden "Belum dibaca" label), category Status / Promo / Reminder, loading; text wraps, no line clamp |
| `EmptyState` | illustration + title + body + optional CTA |
| `ErrorState` | illustration + message + retry CTA |
| `Skeleton` | shimmer placeholder, per component shape |
| `SheetHeader` | bottom-sheet drag handle + title + close |
| `TsAppBar` | Home / Back / Title (+ Bell or Add action) / Large / Close / Step (back leading + close trailing, used by S11–S16) |
| `NavBar` / `NavRail` | glass bottom bar (compact) / rail (medium+) |
| `TsLogo` | mark-only / mark+wordmark, light/dark |

### Additions built during design (steps 03–18)

Not in the original list above; each is one Figma component family = one Flutter widget (variants as Figma properties). `TsSlider` (planned for S26) was **dropped**: the auto-advance control is `TsSegmentedControl`.

| Area | Components |
|---|---|
| Controls and feedback | `TsIconButton` (standard / tonal), `TsCheckbox`, `TsRadio`, `TsSwitch`, `TsSegmentedControl`, `TsDialog` (confirm destructive / choice / info / blocked / confirm save), `TsSnackbar` (success / info / error, with or without action), `PageIndicator`, `SearchBar`, `FilterChipRow`, `CategoryChipRow`, `VehicleTabRow` |
| Shell and Home (S05) | `AppShell` (compact / medium / large × 4 tabs), `NavBar Item`, `NavRail Item`, `ActiveBookingCard`, `DraftResumeCard`, `BookingCtaCard`, `QuickLinkTile`, `SectionTitleRow`, `GarageAddTile`, `FleetProgress`, `VehicleSelectCard` (Display / Compact / In Service / Loading) |
| Pick motor, configure (S10–S12) | `SelectionFooter`, `AddMotorCard`, `EstimatePane`, `CopySourceSheet` (sheet + modal), `CopySourceRow`, `CopyFromRow`, `CopyNote`, `UnitHeader`, `ComplaintSection`, `PartDetailSheet` (sheet + modal), `CompatRow`, `SpecRow`, `SelectedPartsBar`, `CompatToggleRow` |
| Workshop and schedule (S13–S15) | `StaticMap`, `WorkshopPhoto`, `ServiceTag`, `WorkshopInfoBlock`, `WorkshopMapBlock`, `WorkshopServicesBlock`, `WorkshopAddressBlock`, `WorkshopDetailContent`, `WorkshopCtaBar`, `ScheduleModeToggle`, `WorkshopSummaryRow`, `CapacityBanner` (info / warning, up to two actions), `UnitSlotSection`, `DateGrid`, `DateGridCell` |
| Summary and ticket (S16–S18) | `SummaryCard`, `UnitSummaryAccordion`, `PaymentNote`, `VoucherRow`, `NoVoucherOption`, `ConfirmBar`, `ConfirmPane`, `SuccessHeader`, `QrCode`, `TicketActions`, `ShareTicketRow` (P2), `TicketUnitRow` |
| Auth (S01–S04) | `OnboardingArt`, `OnboardingContent`, `OtpInput`, `AuthLink`, `TermsNote`, `AuthCard`, `AuthHero` |
| Garage (S07–S09) | `MotorForm`, `MotorPhotoField`, `MotorModelPicker`, `ModelRow`, `BrandHeader`, `MotorPreviewPane`, `MotorHero`, `MotorDetails`, `ServiceHistoryRow`, `HistorySection`, `FormErrorBanner`, `Silhouette` |
| Tracking (S19–S22) | `HistoryTab` / `HistoryTabRow` (scrolling underline tabs with counts), `BookingHistoryCard`, `UnitStatusRow`, `CancelScopeChooser`, `DemoModeShortcut`, `StatusTimeline` (live / completed / cancelled), `MechanicCard` (assigned / not assigned) |
| Invoice and review (S23–S24) | `PaymentStatusTag`, `PaidBanner`, `InvoiceHeaderCard`, `InvoiceSummaryCard`, `WorkshopRatingCard`, `MechanicRatingRow`, `RatingLabel`, `ReviewRecap` |
| Notifications, profile, demo (S06, S25, S26) | `NotificationGroupHeader`, `SettingsRow` / `SettingsGroup`, `UserCard`, `ThemeSetting`, `ThemePreview`, `AboutContent`, `DemoPanel`, `DemoUnitRow`, `DemoPreviewPane`, `ErrorSimBanner` |
| Design-only (not Flutter widgets) | `Type / <Role>` text nodes (Figma text styles), `System / Status Bar`, `Gesture Bar`, `Keyboard`, `Keyboard Numeric`, `SectionHeader` (canvas row header), `Fold Marker` |

The design file holds 487 masters in 150 families (about 91 are library-only variants that no screen shows, e.g. disabled / loading states of controls).

## Figma documentation spec (bonus: Figma docs + clean architecture)

- **Pages:** `00 Cover`, `01 Foundations` (color/type/spacing/radius/shadow as Figma Variables + Styles), `02 Components` (the inventory above, organized by category, with variant properties), `03 Flows – Phone`, `04 Flows – Tablet`, `05 Prototype` (wired interactions, Home → Booking Success at minimum).
- **Variables:** color variables defined with Light/Dark modes (mirrors the semantic token table exactly) so toggling the Figma variable mode previews dark mode. **Starter plan caveat (decided in design step 01):** variable modes are documented only for Education / Pro / Org / Enterprise plans, so on a Starter account the two modes become two collections (`Semantic Light`, `Semantic Dark`); the deliverable lives in a Figma **Draft** (team files cap at 3 pages). The Pencil → Figma route is `html-css` export → html2figma (route B), run after the Flutter build (design steps 20–21): it imports frames only, so components (rebuilt and combined as variants from the `Prop=Value` names), variables, text / effect styles and the 251 handoff notes are recreated by hand from `docs/plan/design/19-conversion-manifest.md`.
- **Frame naming convention:** `S<id> <Screen Name> / <State> / <Breakpoint>` — e.g. `S11 Detail Servis / Default / Phone`, `S11 Detail Servis / Error / Tablet-Landscape`.
- **Layer hygiene:** auto-layout on every frame/group that can use it; no leftover default names ("Frame 12", "Rectangle 4"); components use the `Ts` prefix matching Flutter widget names.
- **Base frame sizes:** phone 360×800, tablet portrait 800×1280, tablet landscape 1280×800 (see [06](06-responsive-layout.md) for the full breakpoint rationale).
