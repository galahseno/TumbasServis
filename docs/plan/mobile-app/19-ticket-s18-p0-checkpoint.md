# Step 19 — S18 Booking Berhasil (Tiket) + P0 flow checkpoint

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Layer** | Presentation, phone |
| **Priority** | P0 |
| **Owns** | `booking/presentation/tiket/` (S18); first end-to-end S05→S18 run |
| **PRD refs** | [04 S18](../../../prd/04-screens.md), [08 M1/M2 acceptance](../../../prd/08-deliverables-acceptance.md) |
| **Design refs** | `docs/plan/design/11-s18-tiket.md` + `docs/claude-session/design/13-design-step11-s18-tiket.md`, exports `design/pencil/exports/step11/`; `docs/plan/design/12-p0-checkpoint.md` + `docs/claude-session/design/14-design-step12-p0-checkpoint.md` (the design phase's own P0 flow-board precedent) |
| **Depends on** | Step 18 (confirmed `Booking`), 10 |
| **Claude session** | `docs/claude-session/apps/20-mobile-step19-ticket-s18-p0-checkpoint.md` (written after approval) |

## Goal

Build the terminal success screen with the real scannable QR, then run the **entire P0 flow once, end to end** (Home → Pilih Motor → Detail Servis → Bengkel → Jadwal → Ringkasan → Tiket) on a device/emulator — this is the first moment the whole core challenge is provably working together.

## Inputs

- PRD 04 S18 content/states (QR, per-unit rows, copy-code button, flat sticky footer).
- PRD 08 M1/M2 acceptance criteria (the Flutter equivalent: the flow runs without gaps; screens match the design's spacing/color/type).
- Design step 11 file + session log — real QR built from primitives in Pencil (verify Flutter uses `qr_flutter` instead, still ≥126dp with a 4-module quiet zone, dark-on-light in both themes).

## Open questions (ask at kickoff)

1. `qr_flutter`'s `QrImageView` vs. re-deriving the exact dark-on-light-in-both-themes rule the design enforced — confirm `QrImageView` with an explicit white background container (not theme-following) satisfies "dark on light even in dark mode" from PRD 07.
2. P0 checkpoint scope — a manual run only, or also a `flutter_driver`/`integration_test` script automating the canonical 3-unit happy path? Recommend: manual run now (fast, matches the design phase's own "Pencil-only, no automation" checkpoint precedent), with an `integration_test` added as a stretch goal in step 20 if time allows.

## Scope

### Files / classes to build

`booking/presentation/tiket/` — `tiket_page.dart`, `tiket_view_model.dart`, `components/success_header.dart`, `components/qr_code.dart` (wraps `qr_flutter`), `components/ticket_unit_row.dart`, `components/ticket_actions.dart`, `state/tiket_state.dart`.

### Tests to write

- `test/booking/presentation/tiket/tiket_view_model_test.dart` — loading state disables "Lacak status" with the reason; copy-code button copies the exact booking code and shows the snackbar; split-mode shows a per-unit slot line.
- Widget test: the rendered QR decodes back to the booking code (round-trip via a QR-decode test helper) — protects against a regression that makes the ticket unscannable.

## Checklist

### Build
- [ ] Open questions answered.
- [ ] S18 built for loading, populated, single-unit, split-schedule, copied-code-snackbar, stress (5-unit specimen).
- [ ] `/booking/success/:bookingId` route wired.
- [ ] **P0 checkpoint run:** Home → S10 → S11 → S13 → S14 → S15 → S16 → S18 completed once on a device/emulator with the canonical 3-motor booking, screenshotted at each step.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test test/booking/presentation/tiket/` → green, QR round-trip verified.
- [ ] Screenshots vs. `design/pencil/exports/step11/*.png`.
- [ ] P0-checkpoint screenshot set saved (mirrors the design phase's `P0 Flow Board`).

### Review gate
- [ ] Status 🔵; show the user the ticket screen + the full P0-flow screenshot set.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `029 - Create Booking Success Ticket (S18) & P0 Flow Checkpoint`.
- [ ] Claude session file written (`docs/claude-session/apps/20-mobile-step19-ticket-s18-p0-checkpoint.md`).
- [ ] Tracker in `00-index.md` set to ✅. **All P0 screens (S03 entry, S05, S10, S11, S13, S15, S16, S18) now exist end to end.**

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
