# Claude Session Log — 23: Mobile-app step 22 — Tracking S19, S20, S21, S22

**Tool:** Claude Code, model Claude Sonnet 5.5
**Date:** 2026-09-29
**Topic:** Build the tracking presentation layer — Riwayat (S19), Detail Booking (S20), Lacak Unit (S21), Ubah Jadwal / Batalkan (S22) — wired live to `TrackingRepository`, and replace the `/bookings*` placeholder routes.

## Initial prompt

"i want to do docs/plan/mobile-app/22-xx, interviewme with detail if need, use grepai to explore codebase". After review: "i want remove ripple efect on riwayat tab (mendatang -- dibatalkan), and i test all is okay, approve do rest except commit and push".

## Research performed

- `grepai` + direct reads of the tracking/booking/home/garage code, PRD 03/04, design step 16 (doc, session log, PNG exports).
- Findings that changed scope: (1) step 09's known gap — simulator timer ticks were never persisted and the simulator was not rehydrated after relaunch, so "Majukan" after a restart wrote Check-in backwards and S19/S20/S05 disagreed with S21; (2) `mechanics.json` was loaded nowhere and the live demo booking had no `mechanicId`; (3) `cancelBooking` had no reason parameter; (4) `PilihMotorPage` took a single preselect id; (5) `watchUnitStatus` emits `BookingUnit` (the step doc said `UnitStatus`); (6) demo data gives Mendatang 2 · Berlangsung 1 · Selesai 2 · Dibatalkan 1, not the design mock's counts; (7) after cancelling one unit, shared reschedule was blocked by the cancelled unit.

## Clarifying interview (8 decisions)

Persistence gap → fix now; mechanics → lookup + assign on first check-in; cancel reason → persist; split-mode reschedule → disabled with reason; live scope → S20+S21 live, S05/S19 reload on return; "Booking lagi" → build with multi-preselect; S19 default tab → Berlangsung else first non-empty; S20/S21 back → pop else go Riwayat/S20.

## Execution

- **Data:** `TrackingSimulator.hydrate/isTracking/transitions`; `TrackingStatusWriter` idempotent + serialized + mechanic assignment + `pendingWrites`; `TrackingSyncCoordinator` (bootstrap) hydrates and persists every transition; `TrackingRepositoryImpl` lazy hydrate + flush before re-reading a unit; `WorkshopRepository.getMechanics`; `cancelBooking(reason)`; shared reschedule ignores cancelled units; `preselectMotors`.
- **Shared UI:** `TsDialog.custom/headerBlock`, `TsButton.loadingLabel`, `FleetProgress.legendLabels`, `SlotChip.captionOverride`, `TsChip` ellipsis, `AppShell.onBranchSelected`.
- **S19:** family view model keyed by optional motor filter (a filtered push never shares state with the tab), underline tabs with counts (no ripple), cards, dismissible motor chip, empty-per-tab (no CTA on Dibatalkan), skeleton.
- **S20:** header + workshop row → S14, `FleetProgress` with legend, `UnitStatusRow`s, action matrix with inline reasons, live per-unit streams re-deriving the booking status, invoice/review gating, "Booking lagi".
- **S21:** `StatusTimeline` (icon + label + shape, bold current + caption, reduce-motion aware), `MechanicCard` (assigned / dashed unassigned), ETA / Selesai / Dibatalkan card, `DemoModeShortcut` → only `advanceUnitStatus/resetUnitStatus`.
- **S22:** lightweight `UbahJadwalViewModel` (does not reuse the draft-bound S15 view model; reuses its components + `SlotCapacityService`), sheet with "Jadwal sekarang", inline error + retry; `BatalkanDialog` with `CancelScopeChooser` + reason chips.
- **Wiring:** three routes; Home refreshes after returning from S20; router refreshes Riwayat on tab re-select; S09's `TODO(step22)` resolved.
- **Post-review fixes:** no ripple on Riwayat tabs; tab scroll-into-view no longer centres (it clipped the first tab); S19 skeleton overflow at 320 dp; `TsChip` label ellipsis at large text.

Tests: simulator (hydrate/transitions), writer, sync coordinator, tracking repo (relaunch), booking (cancel reason, reschedule after cancel), workshop mechanics, draft `preselectMotors`, 4 view-model suites, flow tests + phone layout matrix (320×568 / 360×640 / 412×915 at ×1.0 and ×1.3). `flutter analyze` 0 issues; `dart format` clean; `flutter test` 666/666 (baseline 544).

## Review rounds

- Round 1 (2026-09-29): user tested all screens — approved; requested no ripple on the Riwayat tabs (done).

## Key decisions worth flagging to a reviewer

- Persistence is now central: every simulator transition is written by one serialized, idempotent writer; explicit Majukan/Reset still write themselves (idempotent, no duplicate history).
- Mechanics are assigned by a demo rule (A/C → Pak Anto, B → Mas Rudi) when a unit first leaves Terjadwal; existing ids are never overwritten and Reset keeps them.
- Split bookings can be cancelled per unit but not rescheduled (deliberate, matches design).
- Tablet layouts, silhouette art → step 26/27. Invoice/review targets are still placeholders → step 23.
- Carry-overs written into the step 24 file: notification `deepLink` uses a non-existent `/tracking/...` path; S26 "Majukan/Reset semua" should loop the repo per unit.
- Claude did not launch the app; live timers and relaunch persistence were verified by the user on device.

## Output

Tracker set to ✅ in `00-index.md`. Commit message proposed: `032 - Create Tracking Screens (S19–S22)`. Not committed or pushed. Next: step 23 — Invoice & Review S23–S24.
