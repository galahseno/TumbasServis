# Step 11 — S18 Booking Berhasil (Tiket Servis)

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | P0 |
| **Owns screens** | S18 |
| **Owns components** | (screen-local): `SuccessHeader`, `QrCode` placeholder, `TicketUnitRow`; P2 `ShareTicketRow` (optional) |
| **PRD refs** | [04 S18 + P2 extras](../../../prd/04-screens.md), [03 identifiers & status](../../../prd/03-user-flows.md), [06 S18 row + stress screens](../../../prd/06-responsive-layout.md) |
| **Pen location** | Flows row `S18` |
| **Depends on** | Steps 02–04, 10 |
| **Claude session** | `docs/claude-session/13-design-step11-s18-tiket.md` (written after approval) |

## Goal

Design the flow's terminal success screen: confirmation, booking code + QR, perforated `TicketCard` with **per-unit sub-tickets** (each with unit code and status badge), workshop + schedule recap, and next actions. It is the last frame of the M1 prototype.

## Inputs

- `TicketCard` (phone + landscape variants), `UnitStatusBadge` ("Terjadwal"), `TsButton` (primary + secondary), `TsSnackbar`.
- Identifiers: `TS-260929-0417`, units `-A`, `-B`, `-C`. Demo booking from step 01.
- Business note: total is "bayar di bengkel" (paid later).

## Open questions (ask at kickoff)

1. **Success mark.** Static checkmark badge (shape + icon) vs the illustration budget? Recommended: circular check badge (icon in a tinted circle) with a motion note; no generated art.
2. **QR representation.** Pencil cannot generate a real QR. Options: (a) pseudo-QR pattern built by a loop of small squares + finder patterns; (b) plain placeholder box labelled "QR" . Recommended (a) for visual fidelity; Flutter uses `qr_flutter` (state quiet-zone + min size).
3. **Ticket notches.** Confirm the perforation approach chosen in step 04 works on both `bg-page` themes.
4. **Unit rows** — show service summary per unit (PRD: motor name, unit code, service summary, badge) with ellipsis; how many lines?
5. **P2 extras.** Include "Bagikan tiket" and "Tambah ke Kalender" in the design now (optional row), or cut?
6. **Landscape:** ticket left (max 480) + per-unit **status** list right — is the right list read-only status list linking to S21?

## Scope

### Frame matrix

| State | Phone | Tablet-P (max-w 560) | Tablet-L (ticket left + unit list right) | Dark |
|---|---|---|---|---|
| Loading ("Membuat tiket…" skeleton) | ✔ | ✔ | ✔ | phone |
| Populated — 3 units, shared slot | ✔ | ✔ | ✔ | phone + both tablets |
| Populated — single unit | ✔ | — | — | phone |
| Populated — split schedule (per-unit slots) | ✔ | — | — | phone |
| P2 variant with share + calendar actions (if Q5 = yes) | ✔ | — | — | — |
| Stress: 360×640 (populated — dense ticket) | ✔ | — | — | — |
| Stress: text scale ×1.3 (populated) | ✔ | — | — | — |

### Layout targets (PRD 06)

- Phone: centered ticket, full width, CTAs below.
- Tablet portrait: ticket centered, max-width 560.
- Tablet landscape: ticket left (max 480) + per-unit status list right.

### Components built here

| Component | Notes |
|---|---|
| `SuccessHeader` | Check badge + "Berhasil!" + booking code (copy affordance) |
| `QrCode` | Placeholder pattern at ≥ scannable size with quiet zone, light + dark (QR always dark-on-light, even in dark mode — annotate) |
| `TicketUnitRow` | Motor name, unit code (-A), service summary, `UnitStatusBadge` |
| `ShareTicketRow` (P2) | Share ticket + add to calendar |

### Content & copy

- "Berhasil!", "TS-260929-0417", per-unit rows (Vario 125 (-A), Beat 110 (-B), PCX 160 (-C)), "Bengkel Jaya Motor", "Sen, 29 Sep · 09.00", "Total Rp385.200 (bayar di bengkel)", CTAs "Lacak Status" (→ S20) and "Kembali ke Beranda".

### Annotations to place

- Success motion: check scale-in 300ms; reduce-motion = static.
- QR encodes the booking code; stays dark-on-light in dark mode for scanability.
- CTA destinations; back navigation behavior (no return into the booking flow).
- Semantics: ticket announced as a single group; QR has a text alternative (the code).

## Checklist

### Build
- [ ] Kickoff questions answered.
- [ ] All matrix states built; dark copies built.
- [ ] QR pattern built with a loop (not hand-placed), quiet zone kept, dark-mode variant verified.
- [ ] Per-unit rows use `UnitStatusBadge` instances; status not color-only.
- [ ] Stress frames built and clean (dense ticket at 360×640 and ×1.3).
- [ ] Demo content matches the step-01 sheet (code, total, unit list).

### Quality (automated, run in `execute`)
- [ ] Clipping check on every step frame → zero `problems`.
- [ ] Raw-hex audit → zero (QR squares use tokens too).
- [ ] Every node named; instances only; `placeholder` cleared.
- [ ] Coverage script: frame names match the matrix above.

### /better-interface
- [ ] Run `/better-interface` with scope = all S18 frames (names + node ids).
- [ ] Report recorded below; HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: populated phone (light/dark), tablet-P, tablet-L split, single/split variants, stress frames.
- [ ] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] PNG export to `design/pencil/exports/step11/`.
- [ ] Claude session file written.
- [ ] Tracker set to ✅.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
