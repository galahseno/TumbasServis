# 03 — User Flows & Business Rules

All screen IDs (`S01`…`S26`) are defined in [04-screens.md](04-screens.md).

## F1 — First launch & auth

```
S01 Splash → S02 Onboarding (3 slides) → S03 Login (phone number)
  → S04 OTP (mock, demo code 123456) → S05 Home
```

- Demo/seed user already has 3 motors in Garage, so the booking flow can be explored immediately without doing Garage setup first.
- Wrong OTP code → inline error state on S04 (danger border + icon + text), input shakes (a hint only, skipped under reduce-motion), code field clears. Resend button disabled behind a 30s countdown. "Verifikasi" stays disabled until all six digits are in, with the reason line "Masukkan 6 digit kode" under it; there is no auto-submit.
- Returning user (persisted session) → S01 skips straight to S05 Home after a minimum splash duration (~800ms, for brand presence).
- "Lewati" (skip) on onboarding jumps straight to S03.

## F2 — Multi-vehicle booking (P0 — core challenge)

```
Entry → S10 Pilih Motor → S11 Detail Servis per Motor (chip tabs) → S13 Pilih Bengkel
  → S15 Pilih Jadwal → S16 Ringkasan → [Konfirmasi] → S18 Tiket Booking Berhasil
```

Optional detours: S11 → S12 Katalog Suku Cadang (a **full-screen page** pushed over S11; the part detail is the sheet / modal) → "Selesai" → back to S11; S13 → S14 Detail Bengkel (in-flow variant, CTA "Pilih bengkel ini") → S15; S16 → S17 Pilih Voucher (full page) → back to S16. S12 also opens in **browse mode** from the Home "Katalog suku cadang" quick link (no unit context, no cart).

**Entry points** (all land on S10 with different pre-selection):
- Home primary CTA → S10 empty (nothing pre-selected).
- Garage → motor card → "Booking motor ini" → S10 with that motor pre-checked.
- Workshop detail (S14, standalone variant, reached from the workshop row of S18 / S20) → "Booking di sini" → S10 empty, but the chosen workshop is carried forward and S13 is skipped.
- Promo / voucher notification or Home promo banner → S10 with the voucher carried (S17 is reachable only from S16); service-reminder notification → S10 with that motor pre-checked.
- History → "Booking lagi" (rebook) → S10 pre-checked with the same motors as that past booking.

**Stepper:** S10/S11/S13+S15/S16 map to a 4-node `BookingStepper` (① Motor ② Servis ③ Bengkel & jadwal ④ Ringkasan). Single-motor bookings show the exact same stepper — no shortcut screens — but S11's chip-tab row is hidden entirely when only 1 motor is selected (no tabs to switch between), so the single-motor path never feels heavier.

**Draft persistence:** the in-progress booking (`BookingDraft`) survives backgrounding the app and back-navigation within the flow. Back inside the flow goes to the previous step and keeps the draft; the close icon (S11 onward) and system back on S10 show the exit dialog ("Keluar dari booking? Draft akan disimpan.", actions "Simpan & keluar" / "Lanjutkan booking", both non-destructive) **only when the draft holds at least one selected motor**; with nothing selected the flow just closes. Home then shows a "Lanjutkan draft" card (step X/4, expiry line, "Lanjutkan" + "Hapus draft" with a confirm dialog) until the draft is completed, discarded, or expires (24h); draft motors must be free of active bookings.

## F3 — Tracking

```
S05 Home (active booking card) or S19 Riwayat → S20 Detail Booking
  → S21 Lacak Unit (per-unit timeline)
```

- Each unit progresses independently through the status machine (see Business Rules below) once its booking's arrival slot has passed and the unit is "checked in."
- Status changes push an in-app notification (S06) and update S05's active-booking card and S20/S21 live.
- S21 exposes a "Mode Demo" shortcut (the same `TrackingSimulator` as the central S26 controls) so reviewers can step through every status without waiting for real timers. The S05 bell badge and the S06 unread count agree.

## F4 — Completion → invoice → rating

```
All units reach "Selesai" → notification → S23 Invoice → [Tandai Lunas] → S24 Beri Ulasan
```

- S23 shows a per-unit line-item breakdown (service + parts, per motor, every unit expanded) and a fleet total. "Tandai lunas" is a mock/demo action (no real payment): a non-destructive confirm dialog ("Simulasi, tidak ada pembayaran sungguhan", dismiss "Batal") flips the invoice to a paid state, shows the paid banner and unlocks S24.
- **S24 is hard-gated:** on S20 "Beri ulasan" stays visible but disabled with the reason "Tandai lunas di invoice dulu" until the invoice is paid; a notification deep link for a finished booking goes to S23, not S24. S24 collects one workshop rating (whole stars) + optionally one rating per mechanic, shown only when **at least two distinct mechanics** served the booking; every mechanic row is optional. Submitting shows a same-screen read-only recap, then "Kembali ke detail booking".

## F5 — Garage management

```
S07 Garasi Saya → [+] → S08 Tambah Motor → back to S07
S07 → motor card → S09 Detail Motor → [Edit] → S08 (edit mode) | [Hapus] → confirm → back to S07
```

- Deleting a motor that has an active (non-terminal) booking is blocked with an explanatory dialog ("Motor ini punya booking aktif", actions "Tutup" / "Lihat booking"). On S09 an in-service motor's "Booking motor ini" is disabled with the reason "Sedang dalam servis" and a "Lacak servis" link to S20. S07 has one add action only: the header "+", hidden while the garage is empty (the empty-state CTA is then the only action).

## F6 — Cancel / modify a booking

- From S20 (Detail Booking), while status is still `Terjadwal` (not yet checked in):
  - **Batalkan** opens one confirm dialog with a scope choice: "Seluruh booking · N motor" (all units → `Dibatalkan`) or "Hanya <motor> · Unit -X" (that unit only; remaining units and pricing recompute, voucher eligibility is re-checked; if all units end up cancelled, the booking is cancelled), optional reason chips, confirm "Ya, batalkan" (danger), dismiss "Kembali" (the only dialog that does not use "Batal", because "Batal" would read as the action). Cancelled units release their slot seats.
  - **Ubah jadwal** (S22: bottom sheet on phone, centered modal 560 on tablet) → re-runs the slot-availability check from F2's scheduling rules; the current slot is marked "Jadwal sekarang" (re-selecting it is a no-op save).
- Once any unit has moved past `Terjadwal` (checked in), cancellation/reschedule for that specific unit is disabled — only reachable for units still `Terjadwal` in a split-schedule booking.

## Business rules (→ domain layer)

**Vehicle selection**
- 1–5 motors per booking (locked decision).
- A motor with an active (non-terminal, non-cancelled) booking cannot be selected again; its `VehicleSelectCard` shows disabled state with reason "Sedang dalam servis."

**Per-unit service config**
- Each selected unit must have ≥1 service type chosen before "Lanjut" is enabled; "Lanjut" is disabled with a reason line ("Pilih layanan untuk PCX 160") while any unit chip is not ✓. "Salin dari" sits directly under the unit header and opens a source sheet only when 2+ sources exist (single source = one named row), with an undo snackbar.
- The complaint note is a collapsed optional row ("+ Tambah keluhan (opsional)"); if the chosen service type is `requiresComplaint` (e.g. "Perbaikan/Keluhan"), the row opens automatically and a non-empty note is mandatory for that unit.
- Complaint notes: free text, max 250 characters, character counter shown near the limit.
- Parts/oil options are filtered by the unit's `MotorModel.category` and `cc` (a 110cc matic won't see a 250cc sport-bike oil grade).
- **"Salin dari [Motor X]"**: copies selected services and any parts compatible with the target unit's model; incompatible parts are dropped and reported in a small inline note ("2 item suku cadang tidak disalin karena tidak kompatibel"). Complaint notes are never copied (they're unit-specific by nature).

**Pricing & duration (mock, uniform across workshops — a deliberate simplification, noted in [01](01-overview.md))**
- All prices are labeled "Estimasi" in the UI ("Estimasi biaya", "Total estimasi"), never presented as final/binding; payment is at the workshop.
- Per-unit duration = sum of the selected services' `durationMin`.
- Fleet total duration for a **shared arrival slot** = **makespan** across the workshop's parallel service bays (not a naive sum) — i.e. if the workshop has 2 bays and 3 units each take 60 min, total ≈ 120 min, not 180 min. S11 computes it for a standard 2-bay workshop (no workshop is chosen yet); S13 shows each workshop's makespan ("Estimasi 2 jam untuk 3 motor"); S16 the final one, explained inline ("dikerjakan bergantian di 2 bay"). In **split** mode arrivals differ, so S16 shows the per-unit duration ("Estimasi 1 jam per motor · datang di jam berbeda") and no fleet makespan. Computed in the domain layer, not hardcoded per screen.
- S16's estimate block is one static line per unit → subtotal → voucher → total; the voucher discount is its own line.

**Scheduling**
- Slots run 08.00–16.00, hourly, for D+0 through D+14. On D+0, slots earlier than now + 2 hours are **shown disabled with "Lewat"** (not hidden), with the helper "Booking hari ini minimal 2 jam sebelum jam datang." A workshop closed *now* stays bookable (every workshop is open through 17.00); "Buka sekarang" only filters by the current time.
- Each slot has a capacity counted in **motors per hour** (mock: 5); a slot renders `full` (disabled) once `booked >= capacity`. Chip state precedence: `short` (remaining < number of units, shared mode) > `limited` (remaining ≤ 2) > `available`; for a 3-motor shared booking `limited` never shows. The caption reads "Sisa n motor".
- Default mode: **one shared slot** for all units — the slot must have capacity ≥ number of units. A derived capacity banner escalates info → warning (no hour fits N) with the action "Pisah jadwal".
- Optional "Pisah jadwal per motor" toggle switches to **per-unit slot pickers**; each unit's slot is validated against the seats left *after the other units' picks* (remaining = slot remaining − units already placed there), so 3 motors can never be booked into a 1-seat slot. Toggling the mode is non-destructive (the draft keeps the shared slot and the per-unit slots separately; only the active mode counts); changing the date clears the shared slot.

**Promo & voucher**
- Vouchers declare eligibility rules (e.g. minimum unit count, minimum subtotal). S17 is a **full page** reachable only from S16 (a draft is required): eligible vouchers sorted by saving first, then ineligible ones shown disabled with the specific reason ("Butuh min. 4 motor", "Min. belanja Rp500.000 — kurang Rp72.000"). Radio selection + footer "Terapkan" with a saving preview; "Tidak pakai voucher" is the last row; an applied voucher can also be removed from S16 ("Hapus"). There is no voucher code field. Promo / notification voucher CTAs start a booking and carry the voucher id.
- The applied voucher's discount is itemized as its own line in `PriceBreakdown`.

**Forms and gates (submit rule)**
- Text-entry forms (S03 phone, S08 motor) validate on blur / submit: the primary button stays enabled, errors sit next to the field (icon + text, never color alone) and the first invalid field is focused.
- Count-gated steps (S04 six digits, S10 at 0 motors, S11 until every chip is ✓, S15 until a slot is chosen, S16 while the slot is invalid) may disable the CTA **only with a visible reason line** under it; loading states show "Memuat …".
- Dialogs: destructive confirms are danger-styled with a de-emphasised dismiss ("Batal"); exit / discard dialogs are non-destructive ("Simpan & keluar" / "Lanjutkan booking", "Lanjut mengisi" / "Buang").

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
| Chosen slot fills up while user is on S15/S16 (mock race) | Re-validate on entering S16; if now invalid, show the warning banner ("Tersisa 2 motor di Sel, 29 Sep · 09.00") with actions "Pisah jadwal" (→ S15 split) and "Pilih jam lain" (→ S15); the Jadwal row shows the problem and the CTA is disabled with a reason. |
| Slot capacity < number of units, shared-slot mode | Shared slot option is disabled for that slot with reason "Kapasitas tidak cukup untuk N motor"; prompts "Pisah jadwal" toggle. |
| User exits the booking flow mid-way | Confirm dialog → draft saved → resumable from Home. |
| Garage is empty when entering S10 | Empty state with CTA "Tambah motor pertamamu" → S08 → returns to S10 with the new motor available (not auto-selected; snackbar "Motor ditambahkan"). |
| Simulated network error (Mode Demo toggle) | One-shot: armed on S26 (banner on S26 only), the next write fails with an inline error + "Coba lagi" and the switch disarms itself, to demonstrate error handling. |
| Removing a unit mid-config (S11) | Confirmation if that unit already has selections; recompute chip tabs and summary; if it drops to 1 unit, chip-tab row hides. |
| Motor deleted from Garage while a draft references it | Draft is invalidated for that unit on next open, with a notice; user can drop the unit or pick a replacement. |
