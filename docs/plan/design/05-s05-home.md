# Step 05 — S05 Beranda (Home) + app shell

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | P0 |
| **Owns screens** | S05 |
| **Owns components** | (screen-local, flagged for `prd/02`): `AppShell`, `ActiveBookingCard`, `DraftResumeCard`, `QuickLinkTile`, `FleetProgress` (mini) |
| **PRD refs** | [04 S05](../../../prd/04-screens.md), [03 F2/F3](../../../prd/03-user-flows.md) (entry points, draft, tracking), [06](../../../prd/06-responsive-layout.md) (S05 row, nav patterns) |
| **Pen location** | Flows row `S05` (Phone light → Phone dark → Tablet-Portrait → Tablet-Landscape) |
| **Depends on** | Steps 02–04 |
| **Claude session** | `docs/claude-session/07-design-step05-s05-home.md` (written after approval) |

## Goal

Design the app's entry screen and the **shell** that hosts every tab (Beranda · Riwayat · Garasi · Profil): glass bottom `NavBar` on compact, `NavRail` on medium/large. The shell becomes a reusable slot component so S07, S19 and S25 reuse it unchanged.

## Inputs

- PRD 04 S05: app bar (logo + bell with unread badge), greeting, primary CTA card, active-booking card(s), "Lanjutkan draft" card, promo carousel, "Garasi Saya" strip, quick links (Riwayat, Katalog Suku Cadang).
- Components from steps 03–04: `TsAppBar`, `NavBar`, `NavRail`, `PromoBanner`, `VehicleSelectCard` (compact mode), `UnitStatusBadge`, `Skeleton`, `EmptyState`.
- Demo content sheet.

## Open questions (ask at kickoff)

1. **Mini-progress `●●●○○`.** PRD wireframe shows five dots for "3 motor · Dikerjakan". What do the dots encode — the 5 status steps of the *fleet*, or per-unit progress? *Recommended: one segment per unit, fill by that unit's stage; label states the leading status.* Dots alone are color/shape-only → add text label.
2. **Multiple active bookings.** Stack the cards, or horizontal carousel with peek? (Recommended: stacked, max 2 then "Lihat semua".)
3. **Empty state emphasis.** With no active booking/draft, how is the CTA "emphasized" — larger hero card with an illustration, or the same card with extra spacing? (Illustration budget already spent; reuse an existing one or none.)
4. **Draft card.** Dismissible? Shows "Kedaluwarsa dalam N jam"? Which motors/steps summary?
5. **Greeting emoji** 👋 — keep (PRD wireframe) or drop? Emoji renders as text and needs `fill`.
6. **Tablet portrait grid.** Which cards span both columns (promo + garage strip per PRD 06) and where does the CTA card sit?

## Scope

### Frame matrix

`✔` required · `—` not required (reason)

| State | Phone 360×800 | Tablet-P 800×1280 | Tablet-L 1280×800 | Dark |
|---|---|---|---|---|
| Loading (skeleton cards) | ✔ | ✔ | ✔ | phone |
| Empty (no active booking, no draft) | ✔ | ✔ | ✔ | phone |
| Populated (active booking + draft card + promo + garage strip) | ✔ | ✔ | ✔ | phone + both tablets |
| Populated, 1 motor in garage / long names | ✔ | — (same layout) | — | — |
| Stress: 360×640 populated | ✔ | — | — | — |
| Stress: text scale ×1.3 populated | ✔ | — | — | — |

Notification bell states (0 / 3 / 9+ unread) are shown on the component sheet, not as extra frames.

### Layout targets (PRD 06)

- Compact: single column, glass bottom `NavBar` (inset 16dp, above the gesture inset), content scrolls behind it with bottom padding.
- Medium (800): `NavRail`, content max-width ~720 centered, **2-col card grid** (promo carousel and garage strip span both columns).
- Large (1280): extended `NavRail` (icons + labels), 2-col grid, wider promo carousel.

### Components built here (flag → PRD 02 inventory additions)

| Component | Notes |
|---|---|
| `AppShell` | Reusable frame with a content **slot**: compact = content + glass NavBar; medium/large = NavRail + content. Active tab variant per destination |
| `ActiveBookingCard` | Booking code, motor count + leading status, fleet mini-progress, tap → S20; states: on-track, all-done-awaiting-invoice |
| `DraftResumeCard` | "Lanjutkan draft" with progress (step X/4), motors summary, dismiss/discard, expiry note |
| `QuickLinkTile` | Riwayat, Katalog Suku Cadang |
| `FleetProgress` | Mini segmented progress (per unit) — also reused/extended by S20 in step 16 |

### Content & copy

- App bar: `TsLogo` mark+wordmark, bell with unread badge (2 in the PRD wireframe).
- Greeting: "Halo, Galah 👋". Primary CTA card: "Booking Servis Motor" / "Mulai Booking →" with the tagline "Servis banyak motor, sekali booking."
- Active booking: `TS-260929-0417`, "3 motor · Dikerjakan".
- Garage strip: three motors from the demo sheet + "+" tile.

### Annotations to place

- Entry points: CTA → S10 empty; motor tile → S09; "+" → S08; draft card → resumes at its last step; active card → S20; bell → S06.
- Bottom-nav behavior: glass, 1–2 `BackdropFilter` budget; flat fallback.
- Draft expiry (24h) rule; promo carousel auto-advance pause + reduce-motion.
- Semantics: bell label "Notifikasi, 2 belum dibaca".

## Checklist

### Build
- [ ] Kickoff questions answered.
- [ ] `AppShell` (compact + medium + large, 4 active-tab variants) built as reusable with content slot.
- [ ] Phone frames: loading, empty, populated built; dark copies of all three.
- [ ] Tablet portrait + landscape frames: loading, empty, populated; dark populated on both.
- [ ] Stress frames (360×640, text ×1.3) built and clean.
- [ ] Screen-local components built and named; inventory additions listed in the index.
- [ ] Demo content matches the step-01 sheet (booking code, motors, voucher-free values).

### Quality (automated, run in `execute`)
- [ ] Clipping check on every step frame → zero `problems`.
- [ ] Raw-hex audit → zero.
- [ ] Every node named; every repeated element is a `ref` instance; no detached instances.
- [ ] `placeholder` flag cleared on every finished root frame.
- [ ] Coverage script: frame names match the matrix above.

### /better-interface
- [ ] Run `/better-interface` with scope = all S05 frames (names + node ids), light + dark, all breakpoints.
- [ ] Report recorded below; all HIGH and MEDIUM fixed; LOW listed for the user; re-screenshot; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: populated phone (light/dark), empty, loading, tablet-P, tablet-L, stress frames.
- [ ] Every review round logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] PNG export to `design/pencil/exports/step05/`.
- [ ] Claude session file written.
- [ ] Tracker in `00-index.md` set to ✅; inventory additions list updated.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
