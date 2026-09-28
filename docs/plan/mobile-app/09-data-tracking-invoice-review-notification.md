# Step 09 — Data layer: Tracking, Invoice, Review & Notification

| | |
|---|---|
| **Status** | ✅ Complete |
| **Layer** | Data |
| **Priority** | — |
| **Owns** | `tracking/data/`, `invoice/data/`, `review/data/`, `notification/data/` |
| **PRD refs** | [05](../../../prd/05-data-model-mock.md), [03 F3 tracking, F4 completion→invoice→rating](../../../prd/03-user-flows.md) |
| **Design refs** | — |
| **Depends on** | Steps 03, 04, 05, 08 (bookings must exist for tracking/invoice to attach to) |
| **Claude session** | `docs/claude-session/apps/10-mobile-step09-data-tracking-invoice-review-notification.md` (written after approval) |

## Goal

Implement the four repositories that sit downstream of a confirmed booking: live per-unit tracking (wired to `TrackingSimulator`), invoice generation/payment, review submission (hard-gated on paid invoice), and the notification inbox.

## Inputs

- `.claude/skills/flutter-data-layer/SKILL.md`.
- `prd/03-user-flows.md` F3 (per-unit independent progression, notification push on status change), F4 (invoice per-unit breakdown, mock "Tandai Lunas", review hard-gate + ≥2-mechanic rule).
- `prd/05-data-model-mock.md` repository method lists.
- Step 05's `TrackingSimulator`.

## Open questions (resolved at kickoff)

1. `TrackingRepository.watchUnitStatus` — **not a pure passthrough**: the domain interface (already built) returns `Stream<BookingUnit>`, but `TrackingSimulator.watch()` only emits `UnitStatus`. Resolved: on every simulator emission, `TrackingRepositoryImpl` refetches the booking via `BookingRepository` (interface-injected), finds the unit, and yields it with the emitted status patched in.
2. Notification push on status change (F3) — resolved: a new `core/data/service/status_notification_coordinator.dart` (`StatusNotificationCoordinator`) listens to `TrackingSimulator` and writes `AppNotification`s via `NotificationRepository`, so `tracking` and `notification` never import each other. It discovers which units to watch by polling the raw `bookings` Hive box directly (same avoid-a-cycle precedent as the existing `SlotOccupancyCalculator`), not by injecting `BookingRepository` — that would add a second, avoidable cyclic import on top of the one `NotificationRepository` already requires. Confirmed as a sanctioned retroactive addition to `core/data/service/` + `core/data/di/core_data_module.dart` (both from step 05, already committed).
3. Review hard-gate — resolved as recommended: `ReviewRepositoryImpl.submitReview` refuses (`Result.error`) an unpaid submission as the repo-level safety net; presentation-layer disabling is a separate, later step.

Two additional, additive amendments surfaced while implementing (not part of the original 3 questions, but required to build them):
4. `NotificationRepository` was read-only (`getNotifications`, `markRead`, `watchUnreadCount`) — added `Future<Result<void>> addNotification(AppNotification notification)`, used only by the coordinator.
5. `TrackingSimulator` had no way to read back the status after `advance()` — added a small getter `UnitStatus currentStatus(String bookingId, String unitCode)`.
6. Neither `TrackingRepository`/`BookingRepository` exposes an "update a unit's persisted status" method, so a new stateless helper `core/data/service/tracking_status_writer.dart` (`TrackingStatusWriter`) was added, mirroring `SlotOccupancyCalculator`'s pattern of reading/writing the raw `bookings` box directly to avoid a repo-to-repo dependency.
7. **Known, accepted scope limit:** a unit's persisted status only advances on an explicit `advanceUnitStatus`/`resetUnitStatus` call (the app's "Majukan"/"Reset" demo controls) — `TrackingSimulator`'s own background timer ticks update the live `watchUnitStatus` stream for display but aren't separately persisted between explicit calls. Documented directly on `TrackingRepositoryImpl`.
8. **Known, accepted PRD deviation:** `prd/05-data-model-mock.md` says `bk_seed_001` should demo "with invoice + review... without waiting." Since there's no seed file for invoices/reviews (by design — both are derived/user-submitted), `bk_seed_001`'s invoice materializes unpaid and reviewless on first access like any other completed booking; a reviewer taps "Tandai Lunas" and submits a review manually (both near-instant mock actions) to see S23/S24 fully.
9. Invoice `subtotal`/`total` are **recomputed from the freshly-looked-up catalog line items**, not copied from `Booking.subtotal`/`total` directly — for a real (non-seed) booking these are always identical since the catalog is static, but the hand-authored seed bookings' stored totals have drifted from the current catalog (e.g. `bk_seed_001`'s stored `143000` vs. `85000+35000+58000=178000` from the current `services.json`/`parts.json`); recomputing keeps the invoice internally self-consistent (line items always sum to the header total) rather than shipping a total that doesn't match its own lines.

## Scope

### Files / classes to build

No DTO/mapper layer — matches the convention already established in steps 05–08 (no `model/`/`mapper/` dirs anywhere; each `*_repository_impl.dart` has private inline `_xFromJson`/`_xToJson` methods).

`lib/tracking/data/`: `repository/tracking_repository_impl.dart` (`watchUnitStatus` — bridges `TrackingSimulator`'s `Stream<UnitStatus>` onto the domain's `Stream<BookingUnit>` via a manual `StreamController` (not `async*`/`await for` — see note below); `advanceUnitStatus`, `resetUnitStatus` — delegate to `TrackingSimulator` then persist via `TrackingStatusWriter`), `di/tracking_data_module.dart`.

`lib/invoice/data/`: `repository/invoice_repository_impl.dart` (`getInvoice(bookingId)` — materializes once from the `Booking` when it reaches `selesai`, then persists; per-unit line items via `CatalogRepository` lookups, grouped by id so a repeated service/part becomes one line with `qty > 1`; `markPaid(bookingId)` — mock, flips paid state + `paidAt`, idempotent), `di/invoice_data_module.dart`. Box: `invoices`, keyed by `bookingId`.

`lib/review/data/`: `repository/review_repository_impl.dart` (`submitReview` — refuses if unpaid (via `InvoiceRepository.getInvoice`) or over the 300-char comment limit; `getReview(bookingId)`), `di/review_data_module.dart`. Box: `reviews`, keyed by `bookingId`.

`lib/notification/data/`: `repository/notification_repository_impl.dart` (`getNotifications()`, `markRead(id)`, `addNotification(notification)` — new, coordinator-only, `watchUnreadCount()` — persisted read-state via `LocalStore`, seeded from `notifications_seed.json`), `di/notification_data_module.dart`. Box: `notifications`, keyed by `id`.

Retroactive additions to `core/data/service/` + `core/data/di/core_data_module.dart` (confirmed, see Open questions #2, #4–6):
- `status_notification_coordinator.dart` (`StatusNotificationCoordinator`) — polls the raw `bookings` box to discover non-terminal units, subscribes to each via `TrackingSimulator.watch`, writes an `AppNotification` per transition (`category: status`, `deepLink: '/tracking/$bookingId/$unitCode'`), drops its subscription once a unit reaches a terminal status (permanently, via an in-memory `_watchedKeys` set — never re-subscribes even after a later reset).
- `tracking_status_writer.dart` (`TrackingStatusWriter`) — reads/writes the raw `bookings` box directly (mirrors `SlotOccupancyCalculator`) to persist a unit's `status`/`status_history` and re-derive the booking-level `status`/`completed_at` via the existing `BookingStatusDerivation`.
- `TrackingSimulator.currentStatus(bookingId, unitCode)` getter (additive).
- `NotificationRepository.addNotification(notification)` (additive interface method).

**Implementation note (found during build, not anticipated in the original scope):** `watchUnitStatus` cannot use `async*` + `await for` bridging over `TrackingSimulator`'s broadcast stream — cancelling a subscription to such a stream never completes its `cancel()` Future (a reproducible Dart async*/broadcast interaction issue, independent of this codebase). Implemented instead with a manual `StreamController` + explicit `onCancel`, which cancels cleanly.

### Tests to write

- `test/tracking/data/repository/tracking_repository_impl_test.dart` — full status-machine walk via explicit `advanceUnitStatus` persists status/history and the derived booking status/`completed_at`; refuses once terminal or when persisted as `dibatalkan`; `resetUnitStatus` un-completes a `selesai` booking; `watchUnitStatus` emits the persisted unit first then tracks explicit transitions, and also tracks a purely-automatic timer tick (via an injected manual timer factory, not `fakeAsync` — see note below).
- `test/invoice/data/repository/invoice_repository_impl_test.dart` — line items match the real `bk_seed_001` fixture; a repeated service/part id collapses into one line with `qty > 1`; refuses a non-`selesai` booking; `getInvoice` called twice doesn't re-materialize; `markPaid` idempotent.
- `test/review/data/repository/review_repository_impl_test.dart` — rejected pre-payment, accepted post-payment; persists `mechanicRatings` exactly as given (0/1-mechanic cases included) **without enforcing the ≥2-mechanic rule**, which is presentation-only; comment length rejected; resubmission overwrites.
- `test/notification/data/repository/notification_repository_impl_test.dart` — seeds from `notifications_seed.json`; `markRead`/`addNotification` update `watchUnreadCount`; unknown-id error.
- `test/core/data/service/status_notification_coordinator_test.dart` (new, not in the original list) — one notification per transition with the right `deepLink`; repeated discovery polls don't duplicate subscriptions; stops notifying after a unit reaches `selesai` even across a later reset; a booking added mid-session is picked up by the next poll; `dispose()` stops everything.

**Testing note:** `fakeAsync` doesn't mix safely with the real Hive-backed `LocalStore` IO these tests need (real async file IO doesn't advance under fake time). Timer-dependent tests instead use `test/support/manual_timer_factory.dart` (new) — a `Timer`-factory test double that steps scheduled ticks deterministically via `.fire()`, injected wherever `TrackingSimulator`/`StatusNotificationCoordinator` accept a `timerFactory`.

## Checklist

### Build
- [x] Open questions answered (stream ownership, notification fan-out coordinator, hard-gate enforcement layer).
- [x] All 4 repository impls + DI modules written (+ the coordinator).
- [x] No feature-to-feature `data/repository/` import exists (only through `core/domain/repository` interfaces or the `core/data/service` coordinator/writer) — verified via `grep -rn "import.*tracking/data\|import.*notification/data\|import.*invoice/data\|import.*review/data" lib/`, only hit is the sanctioned `core_data_module.dart` → `notification_data_module.dart` import.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test` (full suite, 182 tests) → green, including `test/tracking/`, `test/invoice/`, `test/review/`, `test/notification/`, `test/core/data/service/status_notification_coordinator_test.dart`.

### Review gate
- [x] Status 🔵; show the user all 4 impls + the coordinator decision + test results.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `019 - Create Tracking, Invoice, Review & Notification Data Layer`.
- [x] Claude session file written (`docs/claude-session/apps/10-mobile-step09-data-tracking-invoice-review-notification.md`).
- [x] Tracker in `00-index.md` set to ✅. **All data-layer steps (05–09) are now complete — every repository interface has exactly one implementation.**

## Review rounds

### Round 1 — 2026-09-28

Awaiting user review. Summary for the reviewer:
- 4 repositories built: `TrackingRepositoryImpl`, `InvoiceRepositoryImpl`, `ReviewRepositoryImpl`, `NotificationRepositoryImpl`, each with a DI module.
- 2 new `core/data/service/` files: `TrackingStatusWriter`, `StatusNotificationCoordinator`; 1 retroactive edit to `core_data_module.dart` (new coordinator provider); 2 small additive interface/service changes (`NotificationRepository.addNotification`, `TrackingSimulator.currentStatus`).
- 1 new test-support double: `test/support/manual_timer_factory.dart`.
- `flutter analyze`: 0 issues. `dart format`: clean. `flutter test`: 182/182 green (full suite, not just this step's new files).
- Notable trade-offs to be aware of (all documented in "Open questions" above, items 7–9): automatic (non-explicit) status ticks aren't separately persisted; `bk_seed_001`'s invoice/review won't be pre-populated (PRD said it should be, but there's deliberately no seed file for either); invoice totals are recomputed from current catalog prices rather than trusted from the booking's stored total, which changes `bk_seed_001`'s displayed total from the seed's hand-authored `143000` to the catalog-accurate `178000`.

**Approved** — user replied "approve" with no changes requested.

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-28 | Kickoff interview (DTO/mapper convention, watchUnitStatus bridging, coordinator placement) | 3 questions answered, all per recommendation |
| 2026-09-28 | Explored steps 05–08 conventions, domain interfaces/models, PRD refs, seed data | Confirmed no-DTO convention, exact interface signatures, `bk_seed_001` fixture numbers |
| 2026-09-28 | Implemented 4 repositories + DI modules, `TrackingStatusWriter`, `StatusNotificationCoordinator`, 2 additive interface changes | `flutter analyze` clean |
| 2026-09-28 | Found and fixed: invoice subtotal/total drift vs. live catalog prices for seed data (recompute from lines instead of trusting `Booking.subtotal`) | Invoice always internally consistent |
| 2026-09-28 | Found and fixed: `async*`/`await for` bridging over a broadcast stream never completes `cancel()` — reproduced standalone, rewrote `watchUnitStatus` with a manual `StreamController` | Confirmed fixed via repro script and passing tests |
| 2026-09-28 | Found and fixed: coordinator tests mixing `fakeAsync` with real Hive IO were unreliable/hung | Rewrote with `ManualTimerFactory` test double + real async, no `fakeAsync` |
| 2026-09-28 | Full test suite run twice for stability | 182/182 green both runs |
