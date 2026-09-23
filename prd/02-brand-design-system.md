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

### Semantic tokens — Light / Dark

| Semantic token | Light | Dark |
|---|---|---|
| `bg-page` | `sand-50` `#FBFAF9` | `sand-950` `#100E0D` |
| `surface-card` | `sand-0` `#FFFFFF` | `#191615` |
| `surface-inset` | `sand-100` `#F4F1EE` | `#141211` |
| `surface-hover` | `sand-100` `#F4F1EE` | `#232020` |
| `text-heading` | `sand-900` `#1A1716` | `#F7F4F2` |
| `text-body` | `sand-700` `#463F3A` | `#C9C1BB` |
| `text-muted` | `sand-500` `#8A817A` | `#9A918B` |
| `text-faint` | `sand-400` `#B0A79F` | `#6C645F` |
| `accent` | `orange-500` `#E4622F` | `orange-400` `#FF8551` |
| `accent-hover` | `orange-600` `#C24C1D` | `orange-300` `#FFAE81` |
| `text-accent` | `orange-600` `#C24C1D` | `orange-400` `#FF8551` |
| `text-on-accent` | `#FFFFFF` | `#1A0E07` |
| `accent-soft` | `orange-100` `#FFE8DB` | `orange-400 @ 16%` |
| `border-subtle` | `sand-200` `#E8E3DE` | `#282422` |
| `border-default` | `sand-300` `#D6CFC8` | `#363130` |
| `border-strong` | `sand-400` `#B0A79F` | `#4B4442` |
| `border-accent` | `orange-500` | `orange-400` |
| `success` | `green-400` `#4FB477` | `green-400` `#4FB477` |
| `danger` | `red-400` `#E4574F` | `red-400` `#E4574F` |
| `warning` | `warning-400` `#D99A2B` | `warning-400` `#D99A2B` |
| `info` | `info-400` `#5B8DEF` | `info-400` `#5B8DEF` |

### Accessibility rule (important — deviates from raw site tokens)

White text on `orange-500` (`#E4622F`) measures **~3.4:1** contrast — fails WCAG AA for normal text (needs 4.5:1). The source site uses this combination only for large glow/accent elements, not body-sized button labels. TumbasServis therefore splits the role:

- **Filled buttons / text-on-accent surfaces (light mode):** use `orange-600` (`#C24C1D`) as the fill, giving white text **~4.8:1** — passes AA.
- **Brand surfaces that don't carry text directly** (logo tile, hero backgrounds, selection borders, progress indicators, icons): `orange-500` is fine.
- **Dark mode:** `#1A0E07` on `orange-400` (`#FF8551`) measures **~7.9:1** — passes comfortably, no substitution needed.

This is the one place the design system intentionally diverges from a literal copy of the site's raw accent value, and it must be respected in both Figma styles and Flutter `ColorScheme`.

### Material 3 mapping

Map semantic tokens into Flutter's `ColorScheme` plus a custom `ThemeExtension` for tokens M3 doesn't model:

```
ColorScheme:
  primary            → accent (button-fill variant: orange-600 light / orange-400 dark)
  onPrimary          → text-on-accent
  primaryContainer   → accent-soft
  onPrimaryContainer → text-accent
  surface            → bg-page
  surfaceContainerLow/Lowest → surface-inset
  surfaceContainer/High      → surface-card
  onSurface          → text-heading
  onSurfaceVariant   → text-body / text-muted
  outline            → border-default
  outlineVariant     → border-subtle
  error              → danger

TsThemeExtension (custom):
  textMuted, textFaint, success, warning, info,
  glassTint, glassBorder, glassSheen, shadowSm, shadowMd, shadowAccent
```

### Status colors (per booking-unit status)

| Status | Color token | Notes |
|---|---|---|
| Terjadwal (Scheduled) | `text-muted` / `border-default` | neutral, not yet started |
| Check-in / Antre (Queued) | `info` | arrived, waiting for bay |
| Diperiksa (Inspecting) | `warning` | in diagnosis |
| Dikerjakan (In progress) | `accent` | active work |
| QC (Quality check) | `warning` | final check |
| Selesai (Done) | `success` | complete |
| Dibatalkan (Cancelled) | `danger` | terminal, cancelled |

## Typography

- **Family:** Exo 2 (variable font), bundled as a Flutter asset (`assets/fonts/Exo2-Variable.ttf` + italic) — not fetched at runtime, matching the site's `@font-face` approach but self-hosted for offline/APK reliability.
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
| Label Small (badges/chips) | 11 / 16 | SemiBold | 0.025em |

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

Dark mode uses the same shadows against near-black surfaces (values tuned darker per the source site; treat as reference, adjust opacity if shadows disappear against `sand-950`).

## Glassmorphism signature

A restrained "glass" treatment marks two specific surfaces as the brand's signature move — not used everywhere:

- **Bottom navigation bar** and **sticky estimate/price bar** (in the booking flow) use frosted glass: `backdrop-filter: blur(14px) saturate(180%)`, tint `sand-0 @ 42%` (light) / `#1C1918 @ 40%` (dark), 1px `glass-border`, inset `glass-sheen` highlight.
- **Budget:** at most 1–2 `BackdropFilter` widgets visible on screen at once (perf cost in Flutter); never stack glass panels.
- Everything else uses flat `surface-card` — glass is an accent, not the default.

## Iconography, illustration, imagery, motion

- **Icons:** one rounded/line icon set (e.g. Material Symbols Rounded or Phosphor), 24dp default, 2px stroke weight equivalent, `text-body`/`text-muted` fill, `accent` when active/selected.
- **Illustrations:** flat, geometric line illustrations in the orange/sand palette for empty states (empty garage, no bookings, no notifications) — no photographic stock in illustration slots.
- **Imagery:** motor category silhouettes (matic/bebek/sport) for garage cards when no photo is set; workshop photos are placeholder/generic (no real business names/photos claimed as real).
- **Motion:** micro-interactions (chip select, checkbox, button press) 150ms `ease-out`; page/route transitions ~250ms; status timeline step reveals ~300ms staggered. All motion respects `MediaQuery.disableAnimations` / reduce-motion.

## Voice & microcopy

- All UI copy in **Bahasa Indonesia**, friendly and concise (not formal-bureaucratic) — e.g. "Yuk, pilih motor yang mau diservis" rather than "Silakan pilih kendaraan Anda."
- Number format: Indonesian Rupiah, thousands-dotted, no decimals — `Rp412.000` (`id_ID` locale via `intl`).
- Date format: `EEE, d MMM yyyy` → "Sen, 29 Sep 2026". Time format: 24-hour, dot separator → "09.00".

## Component inventory

One-to-one mapping target: each Figma component becomes exactly one Flutter widget. Variants below are Figma variant properties and Flutter constructor states.

| Component | Key variants |
|---|---|
| `TsButton` | primary / secondary / outline / ghost / danger × default/pressed/disabled/loading |
| `TsTextField` | default/focused/error/disabled, with optional prefix icon |
| `TsChip` | filter chip: unselected/selected/disabled |
| `VehicleTabChip` | complete (✓) / active (●) / incomplete (○) / error |
| `VehicleSelectCard` | selectable/selected/disabled (with "sedang diservis" reason) |
| `ServiceOptionTile` | radio-style, default/selected/disabled |
| `PartOptionTile` | checkbox-style with price, default/selected/incompatible |
| `WorkshopCard` | list item: name, rating, distance, open/closed badge |
| `SlotChip` | available / limited (low capacity) / full (disabled) / selected |
| `DateStripItem` | horizontal date scroller item: default/selected/today |
| `BookingStepper` | 4-step horizontal progress indicator |
| `StickyEstimateBar` | glass bar: total price + duration + CTA, pinned to bottom |
| `PriceBreakdown` | line-item list: label, qty, price, subtotal, discount, total |
| `TicketCard` | perforated-edge ticket card, per-unit sub-section |
| `UnitStatusBadge` | one per status color (table above) |
| `StatusTimeline` | vertical stepper: done/current/pending nodes |
| `MechanicCard` | avatar/initial, name, rating |
| `PromoBanner` | carousel card, image/gradient + CTA |
| `VoucherCard` | selectable, eligible/ineligible (with reason) |
| `RatingStars` | display + interactive input variant |
| `NotificationTile` | read/unread, icon by category |
| `EmptyState` | illustration + title + body + optional CTA |
| `ErrorState` | illustration + message + retry CTA |
| `Skeleton` | shimmer placeholder, per component shape |
| `SheetHeader` | bottom-sheet drag handle + title + close |
| `TsAppBar` | with/without back, with/without actions |
| `NavBar` / `NavRail` | glass bottom bar (compact) / rail (medium+) |
| `TsLogo` | mark-only / mark+wordmark, light/dark |

## Figma documentation spec (bonus: Figma docs + clean architecture)

- **Pages:** `00 Cover`, `01 Foundations` (color/type/spacing/radius/shadow as Figma Variables + Styles), `02 Components` (the inventory above, organized by category, with variant properties), `03 Flows – Phone`, `04 Flows – Tablet`, `05 Prototype` (wired interactions, Home → Booking Success at minimum).
- **Variables:** color variables defined with Light/Dark modes (mirrors the semantic token table exactly) so toggling the Figma variable mode previews dark mode.
- **Frame naming convention:** `S<id> <Screen Name> / <State> / <Breakpoint>` — e.g. `S11 Detail Servis / Default / Phone`, `S11 Detail Servis / Error / Tablet-Landscape`.
- **Layer hygiene:** auto-layout on every frame/group that can use it; no leftover default names ("Frame 12", "Rectangle 4"); components use the `Ts` prefix matching Flutter widget names.
- **Base frame sizes:** phone 360×800, tablet portrait 800×1280, tablet landscape 1280×800 (see [06](06-responsive-layout.md) for the full breakpoint rationale).
