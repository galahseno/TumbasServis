# Step 09 — Data layer: Tracking, Invoice, Review & Notification

| | |
|---|---|
| **Status** | ⬜ Not started |
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

## Open questions (ask at kickoff)

1. `TrackingRepository.watchUnitStatus` — a thin passthrough `Stream` from `core/data/service/TrackingSimulator`, or does this repository own its own stream and just *drive* the simulator? Recommend: passthrough (repository exposes the simulator's stream filtered to one unit), since the simulator is the single source of truth shared with S26.
2. Notification push on status change (F3: "status changes push an in-app notification") — does `TrackingRepositoryImpl` itself write to `NotificationRepository` on each advance (cross-repo call), or does a small `core/data/service` coordinator listen to the simulator and fan out to both? Recommend the coordinator (avoids `tracking` importing `notification`'s repository directly) — confirm at kickoff whether this coordinator belongs in `core/data/service/` (added retroactively to step 05's scope) or here.
3. Review hard-gate (`InvoiceRepository.markPaid` unlocks `ReviewRepository.submitReview`) — enforced in domain (a check before allowing submission) or presentation-only (button disabled)? Recommend: both — the repository impl also refuses ( `Result.error`) an unpaid submission as a safety net, the presentation-layer disabling is just UX.

## Scope

### Files / classes to build

`lib/tracking/data/`: `repository/tracking_repository_impl.dart` (`watchUnitStatus`, `advanceUnitStatus`, `resetUnitStatus` — delegates to `TrackingSimulator`), `di/tracking_data_module.dart`.

`lib/invoice/data/`: `model/invoice/response/…`, `mapper/invoice_mapper.dart`, `repository/invoice_repository_impl.dart` (`getInvoice(bookingId)` — derives from the `Booking` once all units `Selesai`, per-unit line items; `markPaid(bookingId)` — mock, flips paid state + `paidAt`), `di/invoice_data_module.dart`.

`lib/review/data/`: `repository/review_repository_impl.dart` (`submitReview` — refuses if unpaid; `getReview(bookingId)`), `di/review_data_module.dart`.

`lib/notification/data/`: `model/notification/response/…`, `mapper/notification_mapper.dart`, `repository/notification_repository_impl.dart` (`getNotifications()`, `markRead(id)`, `watchUnreadCount()` — persisted read-state via `LocalStore`), `di/notification_data_module.dart`.

Possible retroactive addition to `core/data/service/` (confirm at kickoff): `status_notification_coordinator.dart` — listens to `TrackingSimulator`, writes a new `AppNotification` on every status change, so `tracking` and `notification` never import each other.

### Tests to write

- `test/tracking/data/repository/tracking_repository_impl_test.dart` — status stream reaches `Selesai` via `FakeClock`/`fakeAsync`, matches the simulator's configured speed.
- `test/invoice/data/repository/invoice_repository_impl_test.dart` — invoice line items match the canonical booking's per-unit breakdown exactly (design plan S23/S24 row); `markPaid` flips state once, is idempotent after.
- `test/review/data/repository/review_repository_impl_test.dart` — submit rejected pre-payment, accepted post-payment; ≥2-mechanic rule surfaces correctly from the booking's mechanic assignments.
- `test/notification/data/repository/notification_repository_impl_test.dart` — unread count matches `markRead` calls; deep-link fields preserved from seed data.

## Checklist

### Build
- [ ] Open questions answered (stream ownership, notification fan-out coordinator, hard-gate enforcement layer).
- [ ] All 4 repository impls + DI modules written (+ the coordinator, if confirmed).
- [ ] No feature-to-feature `data/repository/` import exists (only through `core/domain/repository` interfaces or the `core/data/service` coordinator).

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test test/tracking/data/ test/invoice/data/ test/review/data/ test/notification/data/` → green.

### Review gate
- [ ] Status 🔵; show the user all 4 impls + the coordinator decision + test results.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `019 - Create Tracking, Invoice, Review & Notification Data Layer`.
- [ ] Claude session file written (`docs/claude-session/apps/10-mobile-step09-data-tracking-invoice-review-notification.md`).
- [ ] Tracker in `00-index.md` set to ✅. **All data-layer steps (05–09) are now complete — every repository interface has exactly one implementation.**

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
