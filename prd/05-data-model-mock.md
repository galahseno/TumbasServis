# 05 — Domain Model & Mock Data

Entities are pure Dart per [flutter-domain-layer](../.claude/skills/flutter-domain-layer/SKILL.md) — no JSON annotations on domain classes; DTOs + mappers live in each feature's `data/` layer.

## Entities

| Entity | Key fields |
|---|---|
| `User` | id, name, phone, avatarUrl? |
| `Motor` | id, ownerId, nickname, plateNumber, year?, photoUrl?, modelId → `MotorModel` |
| `MotorModel` | id, brand (Honda/Yamaha/Suzuki), name, category (`matic`/`bebek`/`sport`), cc |
| `Workshop` | id, name, rating, distanceKm, address, openHours, bayCount, staticMapAssetPath, serviceIds[] |
| `ServiceType` | id, name, price, durationMin, requiresComplaint (bool) |
| `Part` | id, name, category (oli/kampas/aki/ban/…), brand, grade, price, compatibleModelIds[] (or compatible category+ccRange) |
| `TimeSlot` | date, hour, capacity, booked |
| `Voucher` | id, code, label, discountType (percent/flat), discountValue, minUnits?, minSubtotal? |
| `BookingDraft` | id, selectedMotorIds[], unitConfigs (Map<motorId, UnitConfig>), workshopId?, scheduleMode (shared/split), slots, voucherId?, createdAt |
| `BookingUnit` | unitCode (e.g. `-A`), motorId, motorSnapshot, serviceIds[], partIds[], complaintNote?, status (`UnitStatus`), statusHistory[], mechanicId?, subtotal, durationMin |
| `Booking` | id, code (`TS-YYMMDD-XXXX`), userId, workshopId, units: `BookingUnit[]`, scheduleMode, sharedSlot?, status (`BookingStatus`, derived), voucherId?, subtotal, discount, total, createdAt |
| `UnitStatus` (enum) | terjadwal, checkIn, diperiksa, dikerjakan, qc, selesai, dibatalkan |
| `BookingStatus` (enum) | terjadwal, berlangsung, selesai, dibatalkan (derived from units — see [03](03-user-flows.md)) |
| `StatusEvent` | status, timestamp, note? |
| `Mechanic` | id, name, avatarInitial, rating |
| `Invoice` | bookingId, lines: `InvoiceLine[]`, subtotal, discount, total, isPaid, paidAt? |
| `InvoiceLine` | unitCode, label, qty, price |
| `Review` | bookingId, workshopRating, workshopComment?, mechanicRatings: Map<mechanicId, rating> |
| `AppNotification` | id, category (status/promo/reminder), title, body, timestamp, read, deepLink? |
| `Promo` | id, title, imageAssetPath, deepLink? |

## Mock data files (`assets/mock/*.json`)

| File | Contents |
|---|---|
| `user.json` | one seed demo user |
| `motor_models.json` | ~15 models across Honda/Yamaha/Suzuki, categories matic/bebek/sport |
| `garage_seed.json` | 3 motors owned by the demo user, referencing `motor_models` |
| `workshops.json` | 8–10 fictional workshops (Yogyakarta-area names/addresses, clearly fictional), each with rating, hours, bay count, static map asset reference |
| `services.json` | service catalog (Servis Berkala, Ganti Oli, Perbaikan/Keluhan, Ganti Ban, Tune-Up, …) with price/duration/requiresComplaint |
| `parts.json` | oil/parts catalog with brand/grade/price/compatibility |
| `vouchers.json` | 3–5 mock vouchers including a multi-vehicle-themed one (e.g. "Diskon 10% servis ≥2 motor") |
| `promos.json` | 3–4 home banner promos |
| `mechanics.json` | ~6 mechanics distributed across workshops |
| `notifications_seed.json` | a handful of pre-seeded notifications (mixed read/unread) |
| `bookings_seed.json` | 2 seed bookings: one `selesai` (with invoice + review, to demo S23/S24 without waiting) and one `dibatalkan` |

Example (`services.json` entry):
```json
{
  "id": "svc_berkala",
  "name": "Servis Berkala",
  "price": 85000,
  "durationMin": 60,
  "requiresComplaint": false
}
```

Example (`bookings_seed.json` entry, abbreviated):
```json
{
  "id": "bk_seed_001",
  "code": "TS-260910-0091",
  "workshopId": "ws_003",
  "status": "selesai",
  "units": [
    {
      "unitCode": "-A",
      "motorId": "motor_002",
      "serviceIds": ["svc_berkala", "svc_oli"],
      "partIds": ["part_oli_mpx1"],
      "status": "selesai"
    }
  ]
}
```

## Mock infrastructure

- **Asset loader:** a small `MockJsonLoader` service in `core/data/service/` reads/parses `assets/mock/*.json` once and caches in memory for the session.
- **Simulated latency:** every mock repository call awaits a randomized 300–800ms delay (via a shared `simulateLatency()` helper) so loading states are visible and testable — not instant.
- **Error injection:** a `DemoModeController` (backing S26) can flip a flag that makes the next mock write action return `Result.error` instead, to demonstrate error/retry UI.
- **Local persistence (user data):** garage entries, bookings, draft, session token, theme preference, and notification read-state are persisted locally (e.g. `shared_preferences` for simple flags/session, a lightweight local store such as `hive_ce` or JSON-in-app-documents-dir for structured lists) so they survive app restart. Catalog data (workshops/services/parts/vouchers/promos/mechanics/motor models) stays asset-sourced and read-only.
- **`TrackingSimulator`:** a data-layer service that, once a unit is checked in, advances its status on a timer (interval configurable via `DemoModeController`, default ~15s) and exposes the current state as a stream the tracking ViewModel watches. Manual "step/reset" from S26/S21 calls the same service directly.
- **Repositories** are typed by domain interfaces and return `Result<T>`, per [flutter-data-layer](../.claude/skills/flutter-data-layer/SKILL.md); swapping mock implementations for real API clients later means only rewriting the `data/repository/*Impl` classes — domain and presentation are untouched.

## Repository interfaces (domain language)

| Interface | Representative methods |
|---|---|
| `SessionRepository` (core) | `login(phone)`, `verifyOtp(code)`, `logout()`, `currentUser()` |
| `GarageRepository` | `getMotors()`, `addMotor(motor)`, `updateMotor(motor)`, `deleteMotor(id)`, `getMotorModels()` |
| `CatalogRepository` | `getServiceTypes()`, `getParts({modelId})`, `getVouchers()`, `getPromos()` |
| `WorkshopRepository` | `getWorkshops({filter})`, `getWorkshop(id)`, `getAvailableSlots(workshopId, date)` |
| `BookingRepository` | `createDraft()`, `updateDraft(draft)`, `confirmBooking(draft)`, `getBookings({status})`, `getBooking(id)`, `cancelBooking(id, {unitCode?})`, `rescheduleBooking(id, newSlots)` |
| `TrackingRepository` | `watchUnitStatus(bookingId, unitCode)`, `advanceUnitStatus(...)` (demo), `resetUnitStatus(...)` (demo) |
| `InvoiceRepository` | `getInvoice(bookingId)`, `markPaid(bookingId)` |
| `ReviewRepository` | `submitReview(review)`, `getReview(bookingId)` |
| `NotificationRepository` | `getNotifications()`, `markRead(id)`, `watchUnreadCount()` |
| `SettingsRepository` (core) | `getThemeMode()`, `setThemeMode(mode)`, `isDemoModeEnabled()`, `setDemoMode(...)` |
