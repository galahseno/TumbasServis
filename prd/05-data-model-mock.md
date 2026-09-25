# 05 — Domain Model & Mock Data

Entities are pure Dart per [flutter-domain-layer](../.claude/skills/flutter-domain-layer/SKILL.md) — no JSON annotations on domain classes; DTOs + mappers live in each feature's `data/` layer.

## Entities

| Entity | Key fields |
|---|---|
| `User` | id, name, phone, avatarUrl? |
| `Motor` | id, ownerId, nickname (max 20 chars), plateNumber (auto-formatted `AB 1234 XY`, unique), year? (1990–2026), photoUrl? (optional; a silhouette by model category when unset), modelId → `MotorModel` |
| `MotorModel` | id, brand (Honda / Yamaha / Suzuki / Kawasaki), name, category (`matic`/`bebek`/`sport`), cc |
| `Workshop` | id, name, rating, **reviewCount** ("126 ulasan"), distanceKm, address, **openTime / closeTime** (structured; the status line "Buka · sampai 17.00" / "Tutup · buka 08.00" and the "Buka sekarang" filter are computed from the clock, not stored text), bayCount, staticMapAssetPath, serviceIds[] |
| `ServiceType` | id, name, price, durationMin, requiresComplaint (bool) |
| `Part` | id, name, category (oli/kampas/aki/ban/…), brand, grade, price, compatibleModelIds[] (or compatible category+ccRange) |
| `TimeSlot` | date, hour, capacity (**motors per hour**, mock 5), booked; `remaining = capacity − booked`. The D+0 cutoff ("Lewat" before now + 2 h) is computed from the clock, not stored |
| `Voucher` | id, code, label, discountType (percent/flat), discountValue, minUnits?, minSubtotal?, **validUntil**; eligibility and the "kurang Rp…" shortfall are computed in the domain layer |
| `BookingDraft` | id, selectedMotorIds[], unitConfigs (Map<motorId, UnitConfig>), workshopId?, scheduleMode (shared/split), **sharedSlot?, unitSlots (Map<motorId, TimeSlot>)** — both kept so toggling the mode is non-destructive, only the active mode counts; changing the date clears `sharedSlot` — voucherId?, createdAt, expiresAt (24 h) |
| `BookingUnit` | unitCode (e.g. `-A`), motorId, motorSnapshot, serviceIds[], partIds[], complaintNote?, status (`UnitStatus`), statusHistory[], mechanicId?, subtotal, durationMin |
| `Booking` | id, code (`TS-YYMMDD-NNNN`), userId, workshopId, units: `BookingUnit[]`, scheduleMode, sharedSlot?, status (`BookingStatus`, derived), voucherId?, subtotal, discount, total, createdAt, completedAt? |
| `UnitStatus` (enum) | terjadwal, checkIn, diperiksa, dikerjakan, qc, selesai, dibatalkan |
| `BookingStatus` (enum) | terjadwal, berlangsung, selesai, dibatalkan (derived from units — see [03](03-user-flows.md)) |
| `StatusEvent` | status, timestamp, note? |
| `Mechanic` | id, name, avatarInitial, rating |
| `Invoice` | bookingId (the reference shown is the booking code; no separate invoice number), lines: `InvoiceLine[]`, subtotal, discount, total, isPaid, paidAt?, **issuedAt** ("Diterbitkan <time>"; or derived from `Booking.completedAt`) |
| `InvoiceLine` | unitCode, label, qty, price |
| `Review` | bookingId, workshopRating (whole stars 1–5), workshopComment? (max 300), mechanicRatings: Map<mechanicId, rating> (only the ratings the user gave; unrated = absent), **createdAt** ("Dikirim <time>") |
| `AppNotification` | id, category (status/promo/reminder), title, body, timestamp, read, deepLink? (status → S21 of the unit, booking → S20, invoice → S23, promo → S10 with `voucherId`, reminder → S10 with `motorId`) |
| `Promo` | id, title, imageAssetPath, deepLink? |

## Mock data files (`assets/mock/*.json`)

| File | Contents |
|---|---|
| `user.json` | one seed demo user |
| `motor_models.json` | **16 models**: Honda — Beat 110, Scoopy 110, Vario 125, PCX 160 (matic), Supra X 125 (bebek), CB150R (sport); Yamaha — Mio M3 125, NMAX 155 (matic), Jupiter Z1 115 (bebek), R15, MT-15 (sport); Suzuki — Address 110 (matic), Smash 115 (bebek), Satria F150, GSX-R150 (sport); Kawasaki — **Ninja 250** (sport, 250 cc; added in design step 19 so the S10 demo garage can be reproduced) |
| `garage_seed.json` | **4 motors** owned by the demo user, referencing `motor_models`: Vario 125 (`AB 1234 XY`), Beat 110 (`AB 5678 ZZ`), PCX 160 (`AB 9012 QR`), Supra X 125 (`AB 3344 KL`, free — matches S05 / S07 / S10). The S10 specimens with Ninja 250 (`AB 7788 MN`, in service) and Scoopy 110 (`AB 2468 TP`) are design-only garages of 5–6 motors; add them through S08 to reproduce the max-reached state |
| `workshops.json` | **5** fictional workshops (Yogyakarta-area names/addresses, clearly fictional), each with rating, `reviewCount`, open / close time, bay count, static map asset reference: bays 2 / 3 / 2 / 1 / 2, closing 17.00 / 18.00 / 17.00 / 17.00 / 17.00, "Cahaya" closed now (Bengkel Jaya Motor is the canonical one) |
| `services.json` | the three S11 services: Servis Berkala Rp85.000 · 60 mnt, Ganti Oli Rp35.000 · 30 mnt, Perbaikan/Keluhan Rp50.000 ("estimasi awal") · 60 mnt (`requiresComplaint`); the last two prices are design proposals |
| `parts.json` | **14** parts (Oli, Kampas rem, Busi, Aki, Ban, Filter udara) with brand / grade or volume / price; compatibility = category + cc range (per-model ids stay unused). Canonical prices: AHM Oli MPX1 Rp58.000, MPX2 Rp70.000, Kampas Rem Rp45.000, Busi NGK Rp28.000, Busi Iridium Rp95.000. Beat 110 fits 7 of 14 |
| `vouchers.json` | **4** vouchers: `DISKON10` (percent 10, minUnits 2, s.d. 31 Okt 2026 — "Diskon 10% servis ≥2 motor"), `HEMAT25` (flat 25.000, minSubtotal 300.000, s.d. 15 Okt 2026), a 15 % voucher with minUnits 4, `HEMAT75` (flat 75.000, minSubtotal 500.000, s.d. 30 Nov 2026) |
| `promos.json` | 3–4 home banner promos |
| `mechanics.json` | ~6 mechanics distributed across workshops |
| `notifications_seed.json` | a handful of pre-seeded notifications (mixed read/unread) |
| `bookings_seed.json` | 4 seed bookings for S09 / S19 history: `TS-260910-0091` and `TS-260714-0058` `selesai` (the first with invoice + review, to demo S23 / S24 without waiting), `TS-260502-0031` `dibatalkan`, `TS-261006-0419` `terjadwal` (Sel, 6 Okt 2026). The active booking `TS-260929-0417` is created by the S10 → S18 flow, not seeded |

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
- **Error injection:** a `DemoModeController` (backing S26) can arm a **one-shot** flag that makes the next mock write action return `Result.error` and then disarms itself, to demonstrate error/retry UI.
- **Reset (S26 "Reset semua data"):** restores the seed above (garage, bookings, draft, notification read-state, invoices, reviews); the session, theme and demo settings are kept.
- **Local persistence (user data):** garage entries, bookings, draft, session token, theme preference, and notification read-state are persisted locally (e.g. `shared_preferences` for simple flags/session, a lightweight local store such as `hive_ce` or JSON-in-app-documents-dir for structured lists) so they survive app restart. Catalog data (workshops/services/parts/vouchers/promos/mechanics/motor models) stays asset-sourced and read-only.
- **`TrackingSimulator`:** a data-layer service that, once a unit is checked in, advances its status on a timer (interval configurable via `DemoModeController`: Mati / 15 dtk / 5 dtk, default 15 dtk) and exposes the current state as a stream the tracking ViewModel watches. Manual "Majukan" / "Reset" per unit (or for all units) from S26 / S21 calls the same service directly.
- **Repositories** are typed by domain interfaces and return `Result<T>`, per [flutter-data-layer](../.claude/skills/flutter-data-layer/SKILL.md); swapping mock implementations for real API clients later means only rewriting the `data/repository/*Impl` classes — domain and presentation are untouched.

## Repository interfaces (domain language)

| Interface | Representative methods |
|---|---|
| `SessionRepository` (core) | `login(phone)`, `verifyOtp(code)`, `logout()`, `currentUser()` |
| `GarageRepository` | `getMotors()`, `addMotor(motor)`, `updateMotor(motor)`, `deleteMotor(id)`, `getMotorModels()` |
| `CatalogRepository` | `getServiceTypes()`, `getParts({modelId})`, `getVouchers()`, `getPromos()` |
| `WorkshopRepository` | `getWorkshops({filter})`, `getWorkshop(id)`, `getAvailableSlots(workshopId, date)` (returns per-hour `booked` and `capacity`) |
| `BookingRepository` | `createDraft()`, `updateDraft(draft)`, `confirmBooking(draft)`, `getBookings({status})`, `getBooking(id)`, `cancelBooking(id, {unitCode?})`, `rescheduleBooking(id, newSlots)` |
| `TrackingRepository` | `watchUnitStatus(bookingId, unitCode)`, `advanceUnitStatus(...)` (demo), `resetUnitStatus(...)` (demo) |
| `InvoiceRepository` | `getInvoice(bookingId)`, `markPaid(bookingId)` |
| `ReviewRepository` | `submitReview(review)`, `getReview(bookingId)` |
| `NotificationRepository` | `getNotifications()`, `markRead(id)`, `watchUnreadCount()` |
| `SettingsRepository` (core) | `getThemeMode()`, `setThemeMode(mode)`, `isDemoModeEnabled()`, `setDemoMode(...)` |
