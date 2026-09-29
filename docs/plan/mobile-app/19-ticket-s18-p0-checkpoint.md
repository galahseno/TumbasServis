# Step 19 — S18 Booking Berhasil (Tiket) + P0 flow checkpoint

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-29 |
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

> **Answered at kickoff (2026-09-29):** Q1 → fixed light tile (`#FFFFFF`) + dark modules (`#1A1716`), not theme-following, asserted in tests for both themes. Q2 → manual run by the user on the wireless iPhone (no simulator), Claude supplies the checklist below; no `integration_test` now. Also decided: success-badge entrance animation in; P2 share/calendar row deferred (step 28, needs new deps); "Lacak status" → `Routes.bookingDetail(id)` (Placeholder until step 22), workshop row → `Routes.workshopDetail(id)`.

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
- [x] Open questions answered.
- [x] S18 built: loading skeleton, populated, single-unit, split-schedule (slot line per unit), copied-code snackbar, 360×640 @ text ×1.3 stress render. 5-unit specimen not separately rendered (same code path as 3 units).
- [x] `/booking/success/:bookingId` route wired to `TiketPage`.
- [ ] **P0 checkpoint run:** Home → S10 → S11 → S13 → S14 → S15 → S16 → S18 completed once on a device/emulator with the canonical 3-motor booking, screenshotted at each step.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed` → clean on every step-19 file.
- [x] `flutter test test/booking/presentation/tiket/` → 14/14 green; full `flutter test` → 394/394. QR proof = widget-param assertions (see Deviations), scan on device pending.
- [x] Visual check vs. design step 11 done by user on device (no saved screenshots).
- [x] P0 checkpoint run verified by user; screenshot set not saved (see Deviations).

### Review gate
- [x] Status 🔵; user ran the full flow on device.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `029 - Create Booking Success Ticket (S18) & P0 Flow Checkpoint`.
- [x] Claude session file written (`docs/claude-session/apps/20-mobile-step19-ticket-s18-p0-checkpoint.md`).
- [x] Tracker in `00-index.md` set to ✅. **All P0 screens (S03 entry, S05, S10, S11, S13, S15, S16, S18) now exist end to end.**

## Manual P0 checkpoint (user, iPhone) — screenshot each step

Canonical: Vario 125 / Beat 110 (+Oli) / PCX 160 (+Oli +Kampas rem), Bengkel Jaya Motor, Sel 29 Sep 09.00, DISKON10.

1. S05 Home → Booking servis → S10: pick 3 motors.
2. S11: services per unit A/B/C, "Salin dari" works, continue.
3. S13 pick Bengkel Jaya Motor → S15 shared slot Sel 29 Sep 09.00 (also once in split mode).
4. S16: apply DISKON10 via S17 → total **Rp385.200** (optional: armed demo error → retry banner).
5. Konfirmasi → S18: code shown once; **scan the QR with the phone camera → must read the code**; check dark mode too.
6. Salin → snackbar "Kode booking disalin"; paste = exact code.
7. Rows A/B/C "Terjadwal"; workshop row → S14 standalone, back returns.
8. "Lacak status" → Placeholder (expected until step 22); "Kembali ke beranda" → S05; system back on S18 → S05.
9. Repeat: single motor (Rp85.000, no voucher) and split schedule (slot line per unit).
10. Reduce Motion on → badge static; text ×1.3 → nothing clipped; compare with design step 11 frames.

- [x] Manual run done by user on iPhone (flow + UI all good). No screenshot set was attached to the session, so none is saved in the repo.

## Deviations from the original scope

- **QR version is auto, not Version 1.** The design (Pencil, `segno`) used Version 1 alphanumeric mode; `qr_flutter` encodes byte mode, where V1-Q holds only 11 bytes and the 14-char code throws `QrInputTooLongException`. Now `QrCode.fromData(errorCorrectLevel: Q)` picks the version (25 modules), 6 dp per module = 150 dp code (≥126), 4-module quiet zone. Module count differs from the design PNG (21) — visual density is slightly higher; scannability unaffected.
- **No decoder round-trip test** (decided at kickoff): test asserts data label, colors, size, quiet zone; the real scan is the manual step 5.
- **Class named `BookingQrCode`**, not `QrCode` — `qr_flutter` re-exports the `qr` package's `QrCode`.
- P2 share + calendar row deferred (step 28). Tablet layouts deferred (steps 26–27). No visual pixel comparison yet (no simulator; PNG folder `design/pencil/exports/step11/` exists on disk).
- Test hook: `homeScreenFakeOverrides` gained `getBookingResult = error` so the router-walk test's `/booking/success/b1` lands on a non-animating ErrorState.

- **P0 checkpoint screenshots not stored** — user verified the run on device and approved without attaching a screenshot set.

## Review rounds

#### Round 1 — 2026-09-29
- **Shown:** file list, test/analyze/format results, manual P0 checklist.
- **User feedback:** "i test the flow and ui all well, mark as complete and approve do the rest except commit and push"
- **Changes made:** none.
- **Outcome:** approved.

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-29 | Kickoff | Read step file, design step 11 + PRD 04 S18, step 18 code (ringkasan page/VM, router/routes, DI, `Booking`/`BookingUnit`, fakes) via `grepai` + reads. 4 `AskUserQuestion` (checkpoint mode, QR proof, extras, nav targets) |
| 2026-09-29 | Build | New `booking/presentation/tiket/` (page, view model, state, `SuccessHeader`, `BookingQrCode`, `TicketCard` + skeleton, `TicketUnitRow`, `TicketActions`), `utils/tiket_display.dart`, DI provider, router wiring, `FakeBookingRepository.getBookingResult` |
| 2026-09-29 | Fix | QR test caught `QrInputTooLongException` (V1-Q byte mode holds 11 bytes) → auto version. Router walk test hung on skeleton shimmer → fake `getBooking` returns error |
| 2026-09-29 | Quality | `flutter analyze` 0 issues; `dart format` clean; tiket tests 14/14; full suite 394/394 |
