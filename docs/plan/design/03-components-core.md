# Step 03 — Core components (inputs, chrome, feedback)

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | — (foundation for all screens) |
| **Owns screens** | — |
| **Owns components** | `TsButton`, `TsTextField`, `TsChip`, `TsAppBar`, `SheetHeader`, `NavBar` / `NavRail`, `EmptyState`, `ErrorState`, `Skeleton`, `UnitStatusBadge` (+ added: `TsDialog`, `TsSnackbar`) |
| **PRD refs** | [02](../../../prd/02-brand-design-system.md) (component inventory, glass, status colors, motion), [04](../../../prd/04-screens.md) (global patterns), [06](../../../prd/06-responsive-layout.md) (nav pattern per window class, 48dp targets) |
| **Pen location** | `02 Components` row → Core group; illustrations appended to the same group |
| **Depends on** | Steps 01, 02 |
| **Claude session** | `docs/claude-session/05-design-step03-components-core.md` (written after approval) |

## Goal

Build the shared building blocks every screen uses, with all states the PRD lists, on tokens only, and the empty/error/success illustrations (`Generate svg`, palette-constrained). Add the two global-pattern widgets (`TsDialog`, `TsSnackbar`) that the PRD's inventory omits.

## Inputs

- PRD 02 inventory rows for each component; PRD 04 "Global patterns" (confirm-destructive dialog, snackbars, bottom sheets, keyboard handling).
- Step 02 tokens (incl. `accent-fill`, `border-control`, `*-text` / `*-soft` if approved).
- Illustration style approved in step 01.

## Open questions (ask at kickoff)

1. **Variant modeling.** Convention in the index = one reusable per variant combination a screen actually uses, spec-only states as `ref` overrides on the sheet. Confirm for `TsButton` (5 types × default/pressed/disabled/loading = 20) — recommended: reusable for `default`, `disabled`, `loading` of each type; `pressed` and `focused` as spec overrides.
2. **NavBar glass vs flat** on tablets: rail is flat `surface-card`; confirm glass only on the compact bottom bar and the S16/S11 estimate bar (budget ≤ 2 blurs per screen).
3. **Nav labels** on the compact bar: 4 items (Beranda · Riwayat · Garasi · Profil), filled icon for active. Confirm icon choices (`home`, `history`, `two_wheeler`, `person`).
4. **Skeleton** shapes: generic (text line / card / avatar) building blocks vs one skeleton per screen (recommended: generic blocks composed per screen).
5. **Dialog width** on phone (recommended: 24dp side margins, max-width 560 on tablet).

## Scope

### Components and their variants

| Component | Variants / states to design |
|---|---|
| `TsButton` | Type: primary (fill `accent-fill`, `shadow-accent` only on the primary booking CTA) / secondary / outline / ghost / danger × State: default / pressed / focused / disabled / loading; sizes: standard (48dp tall), compact; optional leading icon; full-width and hug variants |
| `TsTextField` | default / focused / filled / error (message + icon, not color alone) / disabled; optional prefix (`+62` phone), suffix icon, helper text, multiline with character counter (S11 complaint, 250 max) |
| `TsChip` | filter chip: unselected / selected / disabled; optional leading icon, count badge; preset "keluhan" chip; 48dp hit area around the visual chip |
| `TsAppBar` | with/without back, with/without actions, title-only, large title variant; notification bell with unread badge; collapses cleanly at 360 |
| `SheetHeader` | drag handle + title + close; with/without subtitle |
| `NavBar` | glass bottom bar (4 items, active pill highlight, filled icon), inset 16dp sides / 12dp above bottom, capsule ends |
| `NavRail` | medium (icons + short labels) and large/extended (icons + labels), with leading `TsLogo`, active indicator |
| `EmptyState` | illustration slot + title + body + optional CTA; variants: garage, riwayat, notifikasi, katalog-filter |
| `ErrorState` | illustration + message + "Coba lagi" retry; inline (card) and full-page variants |
| `Skeleton` | shimmer building blocks: line, block, avatar, card; shimmer motion note |
| `UnitStatusBadge` | 7 statuses (Terjadwal, Check-in/Antre, Diperiksa, Dikerjakan, QC, Selesai, Dibatalkan) per PRD 02 colors; **tinted bg + accessible text + status icon**, never color alone; compact + regular sizes |
| `TsDialog` (added) | Confirm-destructive (danger confirm, cancel de-emphasized), info dialog, dialog with choice list (S22 scope), blocked-action dialog ("Motor ini punya booking aktif") |
| `TsSnackbar` (added) | success / info / error, optional action ("Batalkan"/"Coba lagi"), sits above the nav bar |

### Illustrations (generated SVG → reusable components)

| Illustration | Used by |
|---|---|
| Empty garage | S07, S10 |
| No bookings | S19 |
| No notifications | S06 |
| Error / offline | ErrorState |
| Empty filter result (search) | S12, S13 |

Budget: 5 here; every one generated once with palette hexes in the prompt, then reused.

### Spec sheets to include

- Component sheet per family with each variant labelled, light + dark.
- Touch-target overlay note: 48×48 hit area on chips/checkbox-like items whose visuals are smaller.
- Motion notes: chip select 150ms ease-out, button press 150ms, snackbar enter 250ms, skeleton shimmer loop, reduce-motion = static.

### Annotations to place

- `Semantics` labels for the bell, back, close, retry icon buttons.
- Keyboard/focus order note for `TsTextField` and `TsButton` on tablet.
- Glass budget note on `NavBar`.

## Checklist

### Build
- [ ] Kickoff questions answered and variant-modeling convention recorded in the index if changed.
- [ ] `TsButton` all types and states built; danger used only for destructive actions.
- [ ] `TsTextField` all states, prefix/suffix, multiline + counter.
- [ ] `TsChip`, `TsAppBar`, `SheetHeader` built.
- [ ] `NavBar` (glass) and `NavRail` (medium + large) built; active states clear without color alone.
- [ ] `UnitStatusBadge` all 7 statuses, light + dark, with icon + label.
- [ ] `EmptyState`, `ErrorState`, `Skeleton` blocks built; 5 illustrations generated and componentized.
- [ ] `TsDialog`, `TsSnackbar` built; PRD 02 inventory update noted for the user.
- [ ] Every component exists in light and dark and resolves via tokens only.
- [ ] Every interactive component verified ≥ 48×48 target.

### Quality (automated, run in `execute`)
- [ ] Clipping check on every component sheet → zero `problems`.
- [ ] Raw-hex audit → zero.
- [ ] Every node named; every repeated inner element (icons, labels) is consistent across variants so overrides work by name.
- [ ] `placeholder` cleared on all finished frames, incl. illustration frames (flag clears when generation completes).

### /better-interface
- [ ] Run `/better-interface` with scope = Core component sheets (names + node ids).
- [ ] Accessibility: focus/pressed states, semantics notes, target sizes, contrast per state. UI: radii concentric, glass budget, shadow use. Layout/Writing/Typography/Color as applicable.
- [ ] Report recorded below; HIGH/MEDIUM fixed; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: button + field sheets, nav (compact + rail), badges, dialog/snackbar, illustrations.
- [ ] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] PNG exports to `design/pencil/exports/step03/`.
- [ ] Claude session file written.
- [ ] Tracker set to ✅; user reminded to add `TsDialog` / `TsSnackbar` to `prd/02`.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
