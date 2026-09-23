# 03 — User Flows & Business Rules

All screen IDs (`S01`…`S26`) are defined in [04-screens.md](04-screens.md).

## F1 — First launch & auth

```
S01 Splash → S02 Onboarding (3 slides) → S03 Login (phone number)
  → S04 OTP (mock, demo code 123456) → S05 Home
```

- Demo/seed user already has 3 motors in Garage, so the booking flow can be explored immediately without doing Garage setup first.
- Wrong OTP code → inline error state on S04, input shakes, code field clears. Resend button disabled behind a 30s countdown.
- Returning user (persisted session) → S01 skips straight to S05 Home after a minimum splash duration (~800ms, for brand presence).
- "Lewati" (skip) on onboarding jumps straight to S03.

## F2 — Multi-vehicle booking (P0 — core challenge)

```
Entry → S10 Pilih Motor → S11 Detail Servis per Motor (chip tabs) → S13 Pilih Bengkel
  → S15 Pilih Jadwal → S16 Ringkasan → [Konfirmasi] → S18 Tiket Booking Berhasil
```

Optional detours: S11 → S12 Katalog Suku Cadang (part picker sheet) → back to S11; S13 → S14 Detail Bengkel → "Booking di sini" → S15; S16 → S17 Pilih Voucher → back to S16.

**Entry points** (all land on S10 with different pre-selection):
- Home primary CTA → S10 empty (nothing pre-selected).
- Garage → motor card → "Booking motor ini" → S10 with that motor pre-checked.
- Workshop detail (S14) → "Booking di sini" → S10 empty, but the chosen workshop is carried forward and S13 is skipped.
- History → "Booking lagi" (rebook) → S10 pre-checked with the same motors as that past booking.

**Stepper:** S10/S11/S13+S15/S16 map to a 4-node `BookingStepper` (① Motor ② Servis ③ Bengkel & Jadwal ④ Ringkasan). Single-motor bookings show the exact same stepper — no shortcut screens — but S11's chip-tab row is hidden entirely when only 1 motor is selected (no tabs to switch between), so the single-motor path never feels heavier.

**Draft persistence:** the in-progress booking (`BookingDraft`) survives backgrounding the app and back-navigation within the flow. Exiting mid-flow (system back / close icon) shows a confirm dialog ("Keluar dari booking? Draft akan disimpan."). If confirmed, Home shows a "Lanjutkan draft" card until the draft is completed, discarded, or expires (24h).

## F3 — Tracking

```
S05 Home (active booking card) or S19 Riwayat → S20 Detail Booking
  → S21 Lacak Unit (per-unit timeline)
```

- Each unit progresses independently through the status machine (see Business Rules below) once its booking's arrival slot has passed and the unit is "checked in."
- Status changes push an in-app notification (S06) and update S05's active-booking card and S20/S21 live.
- S21 exposes a "Mode Demo" affordance (also centrally available at S26) so reviewers can step through every status without waiting for real timers.

## F4 — Completion → invoice → rating

```
All units reach "Selesai" → notification → S23 Invoice → [Tandai Lunas] → S24 Beri Ulasan
```

- S23 shows a per-unit line-item breakdown (service + parts, per motor) and a fleet total. "Tandai Lunas" is a mock/demo action (no real payment) that flips the invoice to a paid state and unlocks S24.
- S24 collects one workshop rating + optionally one rating per mechanic if different mechanics served different units.

## F5 — Garage management

```
S07 Garasi Saya → [+] → S08 Tambah Motor → back to S07
S07 → motor card → S09 Detail Motor → [Edit] → S08 (edit mode) | [Hapus] → confirm → back to S07
```

- Deleting a motor that has an active (non-terminal) booking is blocked with an explanatory dialog ("Motor ini punya booking aktif").

## F6 — Cancel / modify a booking

- From S20 (Detail Booking), while status is still `Terjadwal` (not yet checked in):
  - **Batalkan seluruh booking** → confirm dialog → all units → `Dibatalkan`.
  - **Batalkan satu unit** → confirm dialog → that unit only → `Dibatalkan`; remaining units and pricing recompute; if all units end up cancelled, the booking is cancelled.
  - **Ubah jadwal** (S22 sheet) → re-runs the slot-availability check from F2's scheduling rules.
- Once any unit has moved past `Terjadwal` (checked in), cancellation/reschedule for that specific unit is disabled — only reachable for units still `Terjadwal` in a split-schedule booking.

## Business rules (→ domain layer)

**Vehicle selection**
- 1–5 motors per booking (locked decision).
- A motor with an active (non-terminal, non-cancelled) booking cannot be selected again; its `VehicleSelectCard` shows disabled state with reason "Sedang dalam servis."

**Per-unit service config**
- Each selected unit must have ≥1 service type chosen before "Lanjut" is enabled.
- If the chosen service type is `requiresComplaint` (e.g. "Perbaikan/Keluhan"), a non-empty complaint note is mandatory for that unit.
- Complaint notes: free text, max 250 characters, character counter shown near the limit.
- Parts/oil options are filtered by the unit's `MotorModel.category` and `cc` (a 110cc matic won't see a 250cc sport-bike oil grade).
- **"Salin dari [Motor X]"**: copies selected services and any parts compatible with the target unit's model; incompatible parts are dropped and reported in a small inline note ("2 item suku cadang tidak disalin karena tidak kompatibel"). Complaint notes are never copied (they're unit-specific by nature).

**Pricing & duration (mock, uniform across workshops — a deliberate simplification, noted in [01](01-overview.md))**
- All prices are labeled "Estimasi" in the UI, never presented as final/binding.
- Per-unit duration = sum of the selected services' `durationMin`.
- Fleet total duration shown in the summary = **makespan** across the workshop's parallel service bays (not a naive sum) — i.e. if the workshop has 2 bays and 3 units each take 60 min, total ≈ 120 min, not 180 min. This is computed in the domain layer, not hardcoded per screen.

**Scheduling**
- Slots run 08.00–16.00, hourly, for D+0 (if ≥2 hours from now) through D+14.
- Each slot has a capacity; a slot renders `full` (disabled) once `booked >= capacity`, and `limited` styling once remaining capacity is low (≤2).
- Default mode: **one shared slot** for all units — the slot must have capacity ≥ number of units.
- Optional "Pisah jadwal" toggle switches to **per-unit slot pickers**; each unit's chosen slot is validated independently (capacity ≥1 for that slot).

**Promo & voucher**
- Vouchers declare eligibility rules (e.g. minimum unit count, minimum subtotal). Ineligible vouchers are still listed on S17 but shown disabled with the specific reason ("Butuh min. 2 motor").
- The applied voucher's discount is itemized as its own line in `PriceBreakdown`.

**Identifiers & status**
- Booking code format: `TS-YYMMDD-XXXX` (e.g. `TS-260929-0417`).
- Unit codes suffix the booking code with a letter: `TS-260929-0417-A`, `-B`, `-C`… up to `-E` (max 5 units).
- Unit status machine (forward-only, plus a cancellation branch from any pre-`Selesai` state):
  ```
  Terjadwal → Check-in/Antre → Diperiksa → Dikerjakan → QC → Selesai
                    ↘ (any of the above) → Dibatalkan
  ```
- Booking-level status is derived from its units: `Terjadwal` while any unit is `Terjadwal`/not yet checked in; `Berlangsung` while any unit is between check-in and QC; `Selesai` once all units are `Selesai` (or a mix of `Selesai`/`Dibatalkan` with at least one `Selesai`); `Dibatalkan` only if *all* units are `Dibatalkan`.
- An invoice (S23) is generated once the booking reaches `Selesai`.

## Edge cases

| Case | Handling |
|---|---|
| Chosen slot fills up while user is on S15/S16 (mock race) | Re-validate on entering S16; if now invalid, show inline banner suggesting split-schedule or next available slot. |
| Slot capacity < number of units, shared-slot mode | Shared slot option is disabled for that slot with reason "Kapasitas tidak cukup untuk N motor"; prompts "Pisah jadwal" toggle. |
| User exits the booking flow mid-way | Confirm dialog → draft saved → resumable from Home. |
| Garage is empty when entering S10 | Empty state with CTA "Tambah Motor" → S08 → returns to S10 with the new motor available. |
| Simulated network error (Mode Demo toggle) | Any step's primary action can surface a mock error state with "Coba lagi" retry, to demonstrate error handling. |
| Removing a unit mid-config (S11) | Confirmation if that unit already has selections; recompute chip tabs and summary; if it drops to 1 unit, chip-tab row hides. |
| Motor deleted from Garage while a draft references it | Draft is invalidated for that unit on next open, with a notice; user can drop the unit or pick a replacement. |
