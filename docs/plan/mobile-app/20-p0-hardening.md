# Step 20 — P0 hardening

| | |
|---|---|
| **Status** | ✅ Approved |
| **Layer** | Hardening |
| **Priority** | — |
| **Owns** | Quality pass across every P0 screen (S03, S05, S10, S11, S13, S15, S16, S18) |
| **PRD refs** | [06 device matrix & safe-layout rules](../../../prd/06-responsive-layout.md), [07 quality gates](../../../prd/07-architecture-tech.md), [08 M2/B4 acceptance](../../../prd/08-deliverables-acceptance.md) |
| **Design refs** | `design/pencil/exports/step*/` (pixel-parity source for every P0 screen) |
| **Depends on** | Step 19 |
| **Claude session** | `docs/claude-session/apps/21-mobile-step20-p0-hardening.md` (written after approval) |

## Goal

Close the gap between "P0 flow runs once" and "P0 flow is solid": `flutter analyze` clean, the PRD-07-named widget tests complete, layout tests across the PRD 06 **phone** device matrix + text-scale ×1.3 for the dense P0 screens, a manual overflow sweep, and the `BackdropFilter` glass-nav perf check.

## Inputs

- PRD 06 device test matrix (phone sizes: 360×640, 360×800, 393×852, 412×915) and safe-layout checklist (48dp targets, ellipsis+max-lines, sticky-bar keyboard/inset handling, no fixed-height text boxes).
- PRD 07 quality gates (the named widget-test list, already partly covered per-step — this step verifies the full set is present and green together).
- PRD 08 B4 acceptance ("zero overflow across the device matrix, verified manually per P0 screen at minimum").

## Open questions (ask at kickoff)

1. Layout-test tooling — `flutter test`'s `tester.binding.window` size overrides (`testWidgetsWithWindowSize` pattern) for the 4 phone sizes × the dense-screen list (S05/S11/S16/S18), or a manual device/emulator sweep only? Recommend automated `WidgetTester` size overrides for regression safety, backed by one manual emulator pass for real-font/real-keyboard behavior automated tests can't see.
   - **Answered (2026-09-29):** automated size overrides + one manual pass. Matrix widened to also cover the screens changed in this step (S10, S13, S15) and S12's keyboard-open empty state.
2. `BackdropFilter` perf check — profile on the lowest-spec emulator/device available; if jank appears, confirm the flat `surface-card` + `border-subtle` fallback (documented in PRD 02/08) is acceptable to ship instead of chasing glass performance.
   - **Answered (2026-09-29):** profile it; flat fallback is acceptable if it janks. *Profiling is a manual device step — pending the user (see Checklist).*

### Interview decisions for the checkpoint fixes (2026-09-29)

| Topic | Decision |
|---|---|
| Exit dialog | Only **S10 Pilih motor** keeps the X + "Keluar dari booking?" dialog. Steps 2–5 (Detail servis, Pilih bengkel, Detail bengkel, Pilih jadwal, Ringkasan) use a **back arrow that pops one step** with no dialog; the draft is still persisted. Detail bengkel loses its extra close icon. |
| Pilih bengkel chips | **Radio**: exactly one of Buka sekarang / Terdekat / Rating tertinggi; default Terdekat; re-tapping the active chip is a no-op. |
| Short slot (shared mode) | Snackbar `Jam HH.00 hanya muat N motor. Pisah jadwal untuk booking M motor.` + action **Pisah jadwal** → switches to split, seats as many motors as the hour fits (selection order), opens the next unscheduled motor. Split-mode sibling conflicts: `Jam HH.00 sudah dipakai <motor>. Pilih jam lain.` |

## Scope

### Checkpoint fixes (found in manual use of the step-19 flow)

Root causes → fixes (details in the session log):

1. **Selection flicker (Pilih motor / Jenis servis / Suku cadang)** — `BookingDraftViewModel._persist` overwrote optimistic state with each write's result, and slow-then-fast responses arrived out of order. Now: state is optimistic and never overwritten by a write result; writes are serialized + coalesced so storage ends on the latest state.
2. **Draft motor showing "Sedang dalam servis" after unselect** — `assets/mock/bookings_seed.json` had the PRD-05 active booking `TS-261006-0419` on `motor_004` (Supra X 125), which the design (and `DemoContentSeeder.draftMotorId`) treats as the *free* demo-draft motor. Seed booking moved to `motor_006` (NMAX 155). Plus hardening: `refreshActiveBookings()` prunes any draft motor that is now in service (with its config/slot) and S10 tells the user; the seeder no longer re-creates the demo draft on every launch.
3. **Stale screen state (Katalog persisting, voucher not re-applicable)** — screen view models were keep-alive. Now `NotifierProvider.autoDispose` for every booking/catalog/workshop screen VM and the auth VMs; `bookingDraftProvider` stays keep-alive.
4. **Snackbar never dismissing** — `TsSnackbar` used a 1-hour duration for action snackbars and current Flutter keeps action snackbars persistent unless `persist: false`. Now 4 s default / 6 s with action or error, `persist: false`, replaces (not queues) the previous one.
5. **Keyboard overflow / not-found state** — `EmptyState` scrolls when its bounded parent is short; Katalog drops its secondary rows (unit label, compat toggle) while the keyboard is open.
6. **Pilih jadwal** — skeleton grid while a date's slots load (shared + per-unit), stale-response guard on rapid date taps, tap feedback for short/sibling-conflict slots, `splitFromShortSlot` auto-assign.
7. **Voucher** — no ripple on `VoucherCard`; re-applying the same voucher after **Hapus** works and pops back to Ringkasan.
8. **Katalog search would not open the keyboard** — my keyboard-open compaction removed Column children with `if`, so Flutter re-created the search `TextField` (new focus node) the moment the IME opened and the keyboard closed. Fixed with `Visibility` (stable slots) + a key on the field; regression test reproduces the old failure.
9. **Back stack grew on every Ringkasan edit** — Ubah bengkel/jadwal/motor pushed edit pages, and their final "Lanjut" pushed another Ringkasan. `summaryEditReturnProvider` marks an edit-from-Ringkasan; Jadwal "Lanjut" (and Detail servis "Lanjut", which now skips the workshop steps in edit mode) `popUntil` the existing Ringkasan, so the stack ends as original flow + one Ringkasan.
10. **Layout findings from the new matrix** (fixed in the owning component): `SlotChip` row/caption + text-scale-aware grid row height, `NavBar` label wrapping at ×1.3, `TsLogo` wordmark, `AddMotorCard` label, `WorkshopStatusPill` label, `UnitSummaryAccordion` "Ubah <nickname>" (20-char nickname).

### Tests to write / verify present

- Full `flutter analyze` + `dart format` clean across the whole `lib/` (not just this step's own files).
- Layout/overflow tests at the 4 phone sizes for S05, S11, S16, S18 (the PRD 06-named dense screens) + ×1.3 text scale for the same 4.
- `flutter test` full suite green (everything from steps 02–19).
- One manual emulator/device pass across all 4 phone sizes for every P0 screen, checking the PRD 06 safe-layout checklist item by item.
- `BackdropFilter` profiling note (DevTools performance overlay on the booking flow's sticky bars + the glass `NavBar`).

## Checklist

### Build
- [x] Open questions answered.
- [x] Any overflow/gating bug found is fixed in its owning feature (not patched here) and the fix is noted with a pointer back to this step's session log.
- [x] Checkpoint fixes 1–7 implemented (see Scope).

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues (whole project).
- [x] `dart format --set-exit-if-changed .` → clean (whole project; 7 pre-existing unformatted test files reformatted).
- [x] `flutter test` → green (whole suite, 470+ tests).
- [x] Layout tests at 4 phone sizes × S05/S11/S16/S18 (+ S10/S13/S15) + ×1.3 text scale → 0 overflow (`test/layout/p0_layout_matrix_test.dart`); S12 keyboard-open empty state → 0 overflow.
- [x] Manual device-matrix sweep across all P0 screens → 0 overflow, 0 `RenderFlex overflowed` errors in the console. Done by the user on device ("i test all"), no issues reported.
- [x] `BackdropFilter` budget respected (≤1–2 visible at once) — only the glass `NavBar` uses it in the P0 flow; user's device pass reported no jank, so the flat fallback was not needed. No DevTools trace was recorded.

### Review gate
- [x] Status 🔵; show the user the full test-suite summary, the layout-test results, and the manual sweep notes (+ any fixes made).
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `030 - Harden P0 Booking Flow (Fixes, Layout, Tests)`.
- [x] Claude session file written (`docs/claude-session/apps/21-mobile-step20-p0-hardening.md`).
- [x] Tracker in `00-index.md` set to ✅. **The mandatory Home→Booking-Success flow (assessment pillars 1–4) is now solid.**

## Review rounds

#### Round 1 — 2026-09-29
- **Shown:** checkpoint fix list, layout matrix results, full suite (471 tests), analyze/format clean.
- **User feedback:** Katalog search would not open the keyboard; Ringkasan edits grew the back stack.
- **Changes made:** Katalog `Visibility` + key fix; `summaryEditReturnProvider` + `returnToSummary` (Jadwal/Detail servis "Lanjut" pop to the existing Ringkasan); 4 new tests (suite 475).
- **Outcome:** changes requested

#### Round 2 — 2026-09-29
- **Shown:** both fixes + tests, analyze/format clean, 475 tests green.
- **User feedback:** "i test all and approve, do the rest except commit push"
- **Changes made:** none.
- **Outcome:** approved

## Session log

| Time | Action | Result |
|---|---|---|
| — | Kickoff: read step/PRD refs, grepai + code trace of S10–S17, Context7 check of `SnackBar.persist` | Root causes 1–7 identified (see Scope) |
| — | Interview (AskUserQuestion): exit flow, chip behavior, short-slot action, hardening tooling | Decisions recorded above |
| — | Core: `BookingDraftViewModel._persist` serialized/optimistic, `refreshActiveBookings`, seeder + seed data fix, `TsSnackbar`, `EmptyState`, autoDispose screen VMs | `lib/booking/.../booking_draft_view_model.dart`, `lib/core/...`, `assets/mock/bookings_seed.json` |
| — | Screens: back arrows on steps 2–5, single-select bengkel filter, jadwal skeleton/outcomes/`splitFromShortSlot`, voucher card ripple, katalog keyboard compaction | pages/VMs under `lib/booking`, `lib/workshop`, `lib/catalog` |
| — | Tests: existing VM tests keep autoDispose providers alive in their wait helpers; new draft race/prune, seeder, jadwal outcomes/split/stale, voucher re-apply, snackbar, empty state, filter chips, voucher card, pilih motor rapid taps, detail-servis back arrow | all green |
| — | `test/layout/p0_layout_matrix_test.dart` (6 screens × 4 sizes × 2 scales + S05 + S12 keyboard) surfaced 8 real overflows | Fixed in `SlotChip`, `NavBar`, `TsLogo`, `AddMotorCard`, `WorkshopStatusPill`, `UnitSummaryAccordion`, `Katalog`; matrix green |
| — | Round 1 follow-ups: Katalog search focus fix (`Visibility` + key, `katalog_page_widget_test.dart`); Ringkasan edit return (`summary_edit_return_view_model.dart`, `utils/summary_navigation.dart`, `ringkasan_edit_stack_test.dart`) | tests green |
| — | `flutter analyze` 0 issues; `dart format` clean; `flutter test` 475 green | Review gate |
| — | User tested on device and approved | Closed: tracker ✅, session file written, files staged (no commit) |
