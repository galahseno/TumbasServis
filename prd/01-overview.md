# 01 — Product Overview

## Problem

Reference apps in this space (e.g. Honda MotorkuX) let a user book a service appointment for **one motorcycle per transaction**. Any household or small fleet with more than one motor — a common case in Indonesia — has to repeat the entire booking flow once per vehicle: pick workshop again, pick a slot again, fill a form again. It's redundant, slow, and doesn't reflect how people actually own and maintain vehicles.

## Solution

**TumbasServis** lets a user book service for **1–5 motorcycles in a single transaction**, each with its own service type, parts/oil selection, and complaint notes, while sharing one workshop choice and (by default) one arrival slot. The result is a single ticket with **per-unit status tracking**, so a family or small fleet can manage all their vehicles' service in one flow instead of N repeated ones.

Tagline: *"Servis banyak motor, sekali booking."* ("Service many motors, one booking.")

## Personas

| Persona | Profile | Need |
|---|---|---|
| **Keluarga (Family owner)** | Owns 2–3 motors (e.g. spouse's + own + a child's). Books service for all before a long trip or Lebaran. | Configure each motor's needs quickly without re-entering workshop/schedule per motor. |
| **Pemilik armada kecil (Small fleet owner)** | Runs a small delivery/ojek operation, 4–5 motors. Books periodic maintenance for the whole fleet at once. | Fast bulk configuration ("copy from" pattern), clear per-unit cost/duration so fleet downtime is predictable. |
| **Pengguna motor tunggal (Single-motor user)** | Owns just one motor. The most common case — must not feel penalized by the multi-vehicle UI. | The 1-motor path must be exactly as fast/simple as a single-vehicle-only app; no extra taps for "just me." |

## Goals / success criteria

- A user can book service for **3 motors in under ~2 minutes**, in **4 primary steps** (Pilih Motor → Detail Servis → Bengkel & Jadwal → Ringkasan).
- The single-motor path collapses to the same number of visible steps as a hypothetical single-vehicle app — the multi-vehicle chip tabs simply don't show for 1 motor (see [03](03-user-flows.md)).
- Zero layout overflow ("yellow-black bars") across the full device test matrix in [06](06-responsive-layout.md).
- Every mandatory assessment deliverable is met, and every listed bonus criterion is addressed (see [08](08-deliverables-acceptance.md)).

## Scope

### In scope

- **P0 (mandatory core):** Home, multi-vehicle booking flow (vehicle selection → per-unit service config → workshop & schedule → summary → confirmation ticket), Figma design system, Flutter implementation matching it pixel-for-pixel.
- **P1 (bonus):** onboarding + mock OTP auth, per-unit live status tracking with a demo control, parts/oil catalog, invoice with per-unit breakdown, workshop + mechanic rating, garage (motor CRUD), booking history, notifications, profile + theme toggle, workshop list/detail with static map, promo banners + voucher.
- **P2 (cut line if time runs short):** mechanic "additional work found" approval card, complaint photo attachment, ticket sharing, calendar export.
- Rich, realistic mock/dummy data (JSON assets) managed through a proper state-management + repository layer, swappable for a real API later.
- Responsive layout for both mobile and tablet (portrait + landscape).

### Out of scope

- Real backend/API integration (mock data only, per assessment allowance).
- Real payment processing (pay-at-workshop model; invoice is marked "Lunas" as a mock/demo action).
- Real GPS/live map tracking of mechanics or vehicles (static map + "Buka di Maps" intent only).
- Push notifications (in-app notification inbox only).
- Car/mobil booking (motorcycle only, per locked decision).
- iOS build (Android APK is the mandatory deliverable; iOS not required).
- Live chat/support.

## Requirement-to-feature mapping (summary)

The assessment's four challenge pillars map directly to the booking flow:

| Assessment pillar | TumbasServis feature |
|---|---|
| 1. Multi-Vehicle Selection & Management | S10 Pilih Motor — multi-select up to 5, add/remove |
| 2. Keluhan & Servis Spesifik per Unit | S11 Detail Servis per Motor — chip tabs, per-unit service/parts/complaint, "Salin dari" |
| 3. Jadwal & Form Booking Terpadu | S13–S16 — shared workshop, unified/split schedule, consolidated cost & duration summary |
| 4. Tiket Konfirmasi & Status Pelacakan | S18 Booking Success ticket + S20/S21 per-unit status tracking |

Full traceability against every mandatory and bonus line item is in [08-deliverables-acceptance.md](08-deliverables-acceptance.md).
