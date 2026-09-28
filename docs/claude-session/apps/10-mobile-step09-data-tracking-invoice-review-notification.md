# Claude Session Log — 10: Mobile-app step 09 — Data layer: Tracking, Invoice, Review & Notification

**Tool:** Claude Code, model Sonnet 5
**Date:** 2026-09-28
**Topic:** `TrackingRepositoryImpl` (bridges `TrackingSimulator` to the domain `BookingUnit` stream) + `InvoiceRepositoryImpl` (derive/materialize from a completed `Booking`) + `ReviewRepositoryImpl` (hard-gated on a paid invoice) + `NotificationRepositoryImpl` (inbox, unread count) + a new `StatusNotificationCoordinator`

## Initial prompt

"i want to do docs/plan/mobile-app/09-xx, interviewme with detail if need"

## Research performed

Two parallel Explore agents: one read `prd/05-data-model-mock.md` and `prd/03-user-flows.md` (F3 tracking, F4 completion→invoice→rating) plus `00-index.md`'s status tracker and step 05's doc for `TrackingSimulator`'s exact scope; the other read the already-built domain layer (`TrackingRepository`/`InvoiceRepository`/`ReviewRepository`/`NotificationRepository` interfaces, `Invoice`/`InvoiceLine`/`Review`/`AppNotification` models), the existing `TrackingSimulator` implementation, the established no-DTO repository-impl pattern from `booking`/`garage`, `LocalStore`'s API, and confirmed no repository-level `Stream` or cross-repo coordinator precedent existed yet.

## Clarifying interview (AskUserQuestion round → answers)

1. DTO/mapper layer for these 4 features (the draft plan's own scope) vs. matching steps 05–08's no-DTO convention → **match existing convention, no DTO/mapper layer**.
2. `TrackingRepository.watchUnitStatus` returns `Stream<BookingUnit>` but `TrackingSimulator.watch()` only emits `UnitStatus` → **refetch the booking on every simulator tick and patch the status in** (interface-injected `BookingRepository`).
3. The draft's proposed `status_notification_coordinator.dart` (touches step 05's already-committed `core/data/service/` + `core_data_module.dart`) → **yes, build it now** as a sanctioned retroactive addition.

A Plan agent then produced concrete file-by-file signatures; verifying them against the real code surfaced two additive gaps not covered by the 3 questions: `NotificationRepository` had no write method, and `TrackingSimulator` had no way to read back the post-`advance()` status.

## Execution (files written, tests added/passing)

- `lib/core/domain/repository/notification/notification_repository.dart` — added `Future<Result<void>> addNotification(AppNotification notification)`.
- `lib/core/data/service/tracking_simulator.dart` — added `UnitStatus currentStatus(bookingId, unitCode)` getter.
- `lib/core/data/service/tracking_status_writer.dart` — new stateless helper (mirrors `SlotOccupancyCalculator`'s raw-box-access pattern): `writeAdvance`/`writeReset` persist a unit's `status`/`status_history` into the raw `bookings` box and re-derive the booking-level `status`/`completed_at` via `BookingStatusDerivation`.
- `lib/tracking/data/repository/tracking_repository_impl.dart` + `di/tracking_data_module.dart` — `watchUnitStatus` bridges via a manual `StreamController` (not `async*`/`await for` — see below); `advanceUnitStatus`/`resetUnitStatus` drive `TrackingSimulator` then persist via the writer, guarding against advancing an already-terminal or `dibatalkan` unit.
- `lib/invoice/data/repository/invoice_repository_impl.dart` + `di/invoice_data_module.dart` — `getInvoice` materializes once a booking reaches `selesai` (persisted thereafter, making `markPaid` idempotent), grouping repeated service/part ids into one line with `qty > 1`, and **recomputing `subtotal`/`total` from the looked-up line items** rather than trusting `Booking.subtotal` directly (see "Key decisions" below).
- `lib/review/data/repository/review_repository_impl.dart` + `di/review_data_module.dart` — `submitReview` refuses (`Result.error`) an over-length comment or an unpaid invoice (checked via `InvoiceRepository.getInvoice`); does not enforce the ≥2-mechanic rule (presentation-only).
- `lib/notification/data/repository/notification_repository_impl.dart` + `di/notification_data_module.dart` — seeds from `notifications_seed.json`; `watchUnreadCount` implemented as `async* { yield await _computeUnreadCount(); yield* _unreadCountController.stream; }` so every new listener gets the current count immediately.
- `lib/core/data/service/status_notification_coordinator.dart` — new. Polls the raw `bookings` box (not `BookingRepository`, to avoid a second cyclic import) to discover non-terminal units, subscribes to each via `TrackingSimulator.watch`, writes an `AppNotification` per transition, and permanently stops watching a unit once it reaches a terminal status.
- `lib/core/data/di/core_data_module.dart` — sanctioned retroactive edit: new `statusNotificationCoordinatorProvider` (builds the coordinator, calls `.start()`, registers `ref.onDispose`).
- `test/support/manual_timer_factory.dart` — new `Timer`-factory test double (deterministic `.fire()`-stepped ticks), used instead of `fakeAsync` wherever a test also touches real Hive-backed `LocalStore` IO.
- `test/tracking/`, `test/invoice/`, `test/review/`, `test/notification/`, `test/core/data/service/status_notification_coordinator_test.dart` — 27 new tests.
- Full suite: 182/182 passing (run twice for stability); `flutter analyze` 0 issues; `dart format --set-exit-if-changed .` clean.

## Review rounds (user feedback → changes → approval)

Round 1 — shown all 4 impls, the coordinator, the two additive interface/service changes, and full test results. User replied "approve" with no changes requested.

## Key decisions worth flagging to a reviewer

- **`watchUnitStatus` uses a manual `StreamController`, not `async*`/`await for`.** Bridging an async* generator's `await for` over a broadcast stream means cancelling the outer subscription never completes its `cancel()` Future — reproduced standalone with a minimal script, independent of this codebase. A manual controller with an explicit `onCancel` doesn't have this problem.
- **Invoice `subtotal`/`total` are recomputed from the invoice's own line items**, not copied from `Booking.subtotal`/`total`. For a real (user-created) booking these are always identical since the catalog is static and read-only; the seeded bookings' hand-authored totals had drifted from the current catalog (e.g. `bk_seed_001` stores `143000`, but `svc_berkala` + `svc_oli` + `part_oli_mpx1` sum to `178000` in `services.json`/`parts.json` today). Recomputing keeps the invoice always internally self-consistent instead of silently propagating a mismatched total.
- **A unit's persisted status only advances on an explicit `advanceUnitStatus`/`resetUnitStatus` call** ("Majukan"/"Reset"). `TrackingSimulator`'s own background timer ticks update the live `watchUnitStatus` stream for display but aren't separately persisted between explicit calls — documented directly on `TrackingRepositoryImpl` as an accepted scope limit, since nothing in this mock app reads a unit's status back without going through one of those two controls first.
- **`StatusNotificationCoordinator` discovers units by polling the raw `bookings` box**, not by injecting `BookingRepository` — injecting it would add a second, avoidable cyclic import (`core` → `booking`) on top of the one `NotificationRepository` already requires (`core` ↔ `notification`, legal in Dart/Riverpod since provider bodies are lazy closures — the same pattern already exists between `booking_data_module.dart` and `garage_data_module.dart`).
- **`bk_seed_001`'s invoice/review won't be pre-populated** despite `prd/05-data-model-mock.md` saying it should demo "with invoice + review... without waiting" — there's deliberately no seed file for either (invoices are always derived, reviews are always user-submitted), so a reviewer taps "Tandai Lunas" and submits a review manually to see S23/S24 fully populated (both near-instant mock actions).
- Riverpod providers are lazy and `lib/main.dart` is still a placeholder — nothing yet reads `statusNotificationCoordinatorProvider` to instantiate it. Flagged for whichever step builds app bootstrap to add one `container.read(statusNotificationCoordinatorProvider);` line.

## Output (files touched, next step)

Files touched: `lib/core/domain/repository/notification/notification_repository.dart`, `lib/core/data/service/tracking_simulator.dart`, `lib/core/data/service/tracking_status_writer.dart`, `lib/core/data/service/status_notification_coordinator.dart`, `lib/core/data/di/core_data_module.dart`, `lib/tracking/data/repository/tracking_repository_impl.dart`, `lib/tracking/data/di/tracking_data_module.dart`, `lib/invoice/data/repository/invoice_repository_impl.dart`, `lib/invoice/data/di/invoice_data_module.dart`, `lib/review/data/repository/review_repository_impl.dart`, `lib/review/data/di/review_data_module.dart`, `lib/notification/data/repository/notification_repository_impl.dart`, `lib/notification/data/di/notification_data_module.dart`, `test/support/manual_timer_factory.dart`, `test/tracking/data/repository/tracking_repository_impl_test.dart`, `test/invoice/data/repository/invoice_repository_impl_test.dart`, `test/review/data/repository/review_repository_impl_test.dart`, `test/notification/data/repository/notification_repository_impl_test.dart`, `test/core/data/service/status_notification_coordinator_test.dart`, `docs/plan/mobile-app/09-data-tracking-invoice-review-notification.md`, `docs/plan/mobile-app/00-index.md`.

Next step: **10** — the next unbuilt step in `00-index.md`. All data-layer steps (05–09) are now complete; every repository interface has exactly one implementation. Presentation-layer work can now begin.
