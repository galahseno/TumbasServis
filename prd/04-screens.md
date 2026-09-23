# 04 — Screen Inventory & Specs

Priority legend: **P0** mandatory core, **P1** bonus, **P2** cut-line-first. Tablet behavior pointers refer to [06-responsive-layout.md](06-responsive-layout.md). Components reference [02-brand-design-system.md](02-brand-design-system.md).

---

## Auth

### S01 — Splash `P1`
- **Purpose:** brand presence + session check.
- **Content:** `TsLogo` (mark, centered) on `bg-page`.
- **States:** loading (checking persisted session) → routes to S02 (first launch) or S05 (returning, session valid).
- **Interaction:** none (auto-advance after ≥800ms + session check).

### S02 — Onboarding `P1`
- **Purpose:** introduce the multi-vehicle value prop before login.
- **Content:** 3 swipeable slides — (1) "Servis banyak motor, sekali booking," (2) "Atur servis & keluhan tiap motor secara terpisah," (3) "Pantau status tiap unit secara real-time." Page indicator dots, "Lewati" (skip, top-right), "Lanjut"/"Mulai" (bottom CTA).
- **States:** default only.
- **Interaction:** swipe or tap CTA to advance; skip jumps to S03.

### S03 — Login `P0` (entry point) / detail `P1`
- **Purpose:** collect phone number.
- **Content:** `TsLogo` small, headline "Masuk ke TumbasServis," `TsTextField` with `+62` prefix, `TsButton` "Kirim Kode OTP," terms/privacy microcopy.
- **States:** default, validating (invalid phone format inline error), loading, error (mock network failure).
- **Interaction:** submit → S04.

### S04 — OTP `P1`
- **Purpose:** mock verification.
- **Content:** headline with masked phone number, 6-digit OTP input (boxed), resend link with 30s countdown, "Verifikasi" CTA.
- **States:** default, error (wrong code — shake + red border), loading, resend-available.
- **Interaction:** demo code `123456` always succeeds → S05. Any other 6-digit code → error state.

---

## Shell

### S05 — Beranda (Home) `P0`
- **Purpose:** entry to booking + at-a-glance status.
- **Content top→bottom:** app bar (logo + notification bell with unread badge → S06), greeting ("Halo, Galah 👋"), primary CTA card "Booking Servis Motor," active-booking card(s) (if any — shows fleet mini-progress, tap → S20), "Lanjutkan draft" card (if a draft exists), promo banner carousel (`PromoBanner`), "Garasi Saya" horizontal motor strip (tap → S09, "+" → S08), quick links (Riwayat, Katalog Suku Cadang).
- **Nav:** bottom `NavBar` — Beranda · Riwayat · Garasi · Profil.
- **States:** loading (skeleton cards), empty (no active booking → CTA emphasized), populated.
- **Tablet:** see [06](06-responsive-layout.md) — rail nav, 2-col card grid at medium+.

```
┌────────────────────────────┐
│ TS  TumbasServis        🔔2│
├────────────────────────────┤
│ Halo, Galah 👋              │
│ ┌────────────────────────┐ │
│ │  Booking Servis Motor  │ │
│ │  [ Mulai Booking → ]   │ │
│ └────────────────────────┘ │
│ ┌ Booking Aktif ─────────┐ │
│ │ TS-260929-0417  ●●●○○  │ │
│ │ 3 motor · Dikerjakan   │ │
│ └────────────────────────┘ │
│ [Promo banner carousel]    │
│ Garasi Saya        Lihat › │
│ [🏍][🏍][🏍][+]            │
├────────────────────────────┤
│  🏠     🕘     🏍     👤   │
└────────────────────────────┘
```

### S06 — Notifikasi `P1`
- **Purpose:** in-app notification inbox (status changes, promos, reminders).
- **Content:** grouped list (Hari ini / Minggu ini / Lebih lama), `NotificationTile` per item (icon by category, title, timestamp, read/unread dot), tap → relevant screen (booking status change → S20/S21, promo → S17 or Home).
- **States:** loading, empty ("Belum ada notifikasi"), populated.

---

## Garage

### S07 — Garasi Saya `P1`
- **Purpose:** list owned motors.
- **Content:** grid/list of motor cards (photo/silhouette, name, plate, model), FAB or header "+" → S08.
- **States:** loading, empty (illustration + "Tambah motor pertamamu"), populated.
- **Tablet:** grid 2–3 cols at medium/expanded.

### S08 — Tambah/Edit Motor `P1`
- **Purpose:** create or edit a garage entry.
- **Content:** form — nickname, brand/model picker (searchable), plate number, year (optional), photo (optional, placeholder if skipped).
- **States:** default, validating, saving, error.
- **Interaction:** Save → back to S07 (new/updated card visible); Cancel → confirm if dirty.

### S09 — Detail Motor `P1`
- **Purpose:** single motor detail + history entry point.
- **Content:** hero (photo/silhouette), model/plate/year, "Booking motor ini" CTA (→ F2 with pre-selection), mini service-history list (past bookings involving this motor), Edit/Hapus actions.
- **States:** loading, populated (history empty vs. populated sub-state).

---

## Booking (P0 core)

### S10 — Pilih Motor `P0`
- **Purpose:** multi-select 1–5 motors for this booking.
- **Content:** `BookingStepper` (step 1/4), list of `VehicleSelectCard`s from Garage (checkbox-style multi-select), disabled cards show "Sedang dalam servis," "+ Tambah motor lain" (→ S08 inline), selection counter ("2 dari 5 motor dipilih"), sticky footer "Lanjut" (disabled until ≥1 selected).
- **States:** loading, empty garage (CTA to S08), populated, max-reached (5th selected → further cards visually disabled with "Maks. 5 motor").
- **Tablet:** 2-col card grid at medium+.

### S11 — Detail Servis per Motor `P0` (core challenge screen)
- **Purpose:** configure service/parts/complaint independently per unit.
- **Content:** `BookingStepper` (step 2/4) with inline completion badge ("2/3 ✓"); **chip-tab row** (`VehicleTabChip` per unit — hidden if only 1 unit selected); active unit header (name + plate); **Jenis Servis** card (`ServiceOptionTile` list, single or multi-select depending on service catalog); **Suku Cadang/Oli** card (`PartOptionTile` list, filtered by model, "Lihat semua" → S12); **Keluhan** section (chip presets + free-text notes, shown/required only if the selected service requires it); "Salin dari [Motor lain]" action (only visible when ≥2 units and another unit has selections); sticky `StickyEstimateBar` (running fleet total price + duration, "Lanjut").
- **States:** per-unit incomplete (missing required service) blocks "Lanjut" until every unit is complete; loading (catalog fetch), error (retry).
- **Interaction:** switching chip tabs preserves each unit's in-progress state; "Lanjut" only enabled once every unit's chip shows ✓.
- **Tablet:** at expanded width, chip tabs become a left rail list with a detail pane beside it (list-detail), see [06](06-responsive-layout.md).

```
┌────────────────────────────┐
│ ←  Detail Servis     2/3 ✓ │
├────────────────────────────┤
│ [Vario ✓][Beat ●][PCX ○]   │
├────────────────────────────┤
│ Beat 110 · AB 1234 XY      │
│ Jenis Servis                │
│ ┌────────────────────────┐ │
│ │ ◉ Servis Berkala       │ │
│ │ ○ Ganti Oli            │ │
│ │ ○ Perbaikan/Keluhan    │ │
│ └────────────────────────┘ │
│ Suku Cadang/Oli   Lihat semua│
│ ┌────────────────────────┐ │
│ │ ☑ AHM Oil MPX1  Rp58rb │ │
│ │ ☐ Kampas Rem    Rp45rb │ │
│ └────────────────────────┘ │
│ Keluhan (opsional)           │
│ [Rem bunyi][Getar][+]      │
│ ⎘ Salin dari Vario          │
├────────────────────────────┤
│ Est. Rp412.000 · 2j [Lanjut]│
└────────────────────────────┘
```

### S12 — Katalog Suku Cadang & Oli `P1`
- **Purpose:** full parts/oil browser (deep-dive vs. S11's inline shortlist).
- **Content:** filter chips (category: Oli/Kampas/Aki/Ban…), search bar, `PartOptionTile` grid/list with brand, grade, price, compatibility badge, detail-on-tap bottom sheet.
- **States:** loading, empty (filtered to nothing), populated.
- **Interaction:** selections sync back to S11's active unit.
- **Tablet:** grid 3–4 cols at expanded.

### S13 — Pilih Bengkel `P0`
- **Purpose:** choose the shared workshop for the whole booking.
- **Content:** `BookingStepper` (step 3/4), search bar, filter chips (Buka sekarang, Rating tertinggi, Terdekat), `WorkshopCard` list (name, rating, distance, open/closed, bay capacity hint), tap → S14.
- **States:** loading, empty (no results for filter), populated.
- **Tablet:** list-detail split at expanded (list left, S14 content right).

### S14 — Detail Bengkel `P1`
- **Purpose:** workshop detail before committing.
- **Content:** photo header, name/rating/hours, static map image + "Buka di Maps" (external intent via `url_launcher`), services offered, address, "Booking di sini" CTA.
- **States:** loading, populated.

### S15 — Pilih Jadwal `P0`
- **Purpose:** shared or per-unit arrival slot.
- **Content:** `BookingStepper` continues step 3/4, horizontal `DateStripItem` scroller (D+0…D+14), hourly `SlotChip` grid for the selected date, "Pisah jadwal per motor" toggle (switches to per-unit slot pickers, one mini date+slot section per unit), sticky footer "Lanjut."
- **States:** loading, slot-full (chip disabled), shared-slot-insufficient-capacity (banner + suggestion to split), populated.
- **Tablet:** date strip + slot grid side-by-side at medium+.

### S16 — Ringkasan `P0`
- **Purpose:** final review before confirming.
- **Content:** `BookingStepper` (step 4/4), workshop + schedule summary card (edit links back to S13/S15), per-unit collapsible summary (service/parts/complaint recap, edit link back to S11 for that unit), `PriceBreakdown` (per-unit subtotal → fleet subtotal → voucher discount if applied → total), "Pilih Voucher" row (→ S17), payment method note ("Bayar di bengkel saat selesai"), "Konfirmasi Booking" CTA.
- **States:** loading (recomputing after an edit), error (e.g. slot became invalid — banner + fix link), ready.
- **Interaction:** Konfirmasi → brief loading → S18.
- **Tablet:** two-pane at expanded — recap list left, sticky `PriceBreakdown` + CTA right.

```
┌────────────────────────────┐
│ ←  Ringkasan          4/4  │
├────────────────────────────┤
│ Bengkel & Jadwal      Ubah │
│ Bengkel Jaya Motor          │
│ Sen, 29 Sep 2026 · 09.00   │
├────────────────────────────┤
│ ▸ Vario 125          Ubah  │
│   Servis Berkala · Rp185rb │
│ ▸ Beat 110           Ubah  │
│   Servis Berkala + Oli     │
│   Rp243rb                  │
├────────────────────────────┤
│ Pilih Voucher            › │
├────────────────────────────┤
│ Subtotal        Rp428.000  │
│ Diskon voucher  -Rp42.800  │
│ Total           Rp385.200  │
│ Estimasi 2 jam              │
│ Bayar di bengkel            │
├────────────────────────────┤
│      [ Konfirmasi Booking ]│
└────────────────────────────┘
```

### S17 — Pilih Voucher `P1`
- **Purpose:** apply a discount voucher.
- **Content:** `VoucherCard` list, eligible (selectable) vs. ineligible (disabled + reason, e.g. "Butuh min. 2 motor"), "Tidak pakai voucher" option.
- **States:** loading, populated.

### S18 — Booking Berhasil (Tiket Servis) `P0`
- **Purpose:** confirmation ticket — the flow's terminal success screen.
- **Content:** success illustration/checkmark, booking code + QR (`qr_flutter`, encodes the booking code), `TicketCard` with perforated-edge styling, per-unit sub-ticket rows (motor name, unit code, service summary, individual `UnitStatusBadge` = "Terjadwal"), workshop + schedule recap, total paid-later amount, CTAs: "Lacak Status" (→ S20), "Kembali ke Beranda."
- **States:** loading (brief, generating ticket), populated.
- **Tablet:** ticket centered max-width 560 in portrait; landscape shows ticket left + per-unit list right.

```
┌────────────────────────────┐
│         ✅  Berhasil!       │
│   TS-260929-0417            │
│   [ QR CODE ]               │
├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┤
│ Vario 125 (-A)   Terjadwal │
│ Beat 110   (-B)   Terjadwal │
│ PCX 160    (-C)   Terjadwal │
├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┤
│ Bengkel Jaya Motor           │
│ Sen, 29 Sep · 09.00          │
│ Total Rp385.200 (bayar di    │
│ bengkel)                     │
├────────────────────────────┤
│     [ Lacak Status ]        │
│     [ Kembali ke Beranda ]  │
└────────────────────────────┘
```

---

## Post-booking (P1)

### S19 — Riwayat
- **Purpose:** booking history.
- **Content:** tabs (Mendatang / Berlangsung / Selesai / Dibatalkan), booking summary cards (code, date, motor count, status), tap → S20.
- **States:** loading, empty per tab, populated.

### S20 — Detail Booking & Status
- **Purpose:** hub for one booking — overview + actions.
- **Content:** header (code, workshop, schedule), per-unit status list (mini badges, tap unit → S21), fleet-level progress bar, actions (Ubah jadwal → S22, Batalkan → S22, "Lihat Invoice" once available → S23, "Beri Ulasan" once done → S24).
- **States:** loading, populated (varies by booking status).

### S21 — Lacak Unit
- **Purpose:** per-unit live tracking detail.
- **Content:** unit header (motor, plate, service list), `StatusTimeline` (Terjadwal→Check-in→Diperiksa→Dikerjakan→QC→Selesai, done/current/pending nodes with timestamps), `MechanicCard` (once assigned), estimated completion time, "Mode Demo" shortcut (step/reset — mirrors S26).
- **States:** loading, live-updating (timer-driven), completed, cancelled.

### S22 — Ubah Jadwal / Batalkan (sheets)
- **Purpose:** modify a `Terjadwal` booking/unit.
- **Content:** Ubah Jadwal reuses the S15 date/slot picker in a bottom sheet; Batalkan shows a confirm dialog with scope choice (seluruh booking / satu unit) and an optional reason chip list.
- **States:** default, loading, error, success (toast + S20 refresh).

### S23 — Invoice
- **Purpose:** itemized bill once a booking is `Selesai`.
- **Content:** `PriceBreakdown` per unit (service lines + part lines + subtotal), fleet total, workshop info, "Tandai Lunas" (mock) CTA / "Lunas ✓" state once marked, "Unduh/Bagikan" (P2, share as text/image).
- **States:** unpaid (mock), paid.

### S24 — Beri Ulasan
- **Purpose:** post-service rating.
- **Content:** workshop `RatingStars` (interactive) + comment field, per-mechanic rating rows if multiple mechanics served the booking, submit CTA.
- **States:** default, submitting, submitted (read-only recap).

---

## Profile (P1)

### S25 — Profil & Pengaturan
- **Purpose:** account + app settings.
- **Content:** user card (name, phone), menu list — Tema (Sistem/Terang/Gelap segmented control), Mode Demo (→ S26), Notifikasi toggle, Tentang Aplikasi (version, credits), Keluar (logout, confirm dialog).
- **States:** default.

### S26 — Panel Mode Demo
- **Purpose:** reviewer-facing controls to showcase dynamic features quickly (supports the "Mode Demo" mentioned in S21/S18 and Assessment reviewers' need to see states fast).
- **Content:** auto-advance speed slider (e.g. off / 15s / 5s), "Majukan status" (manual step) + "Reset status" per active booking, "Simulasikan galat jaringan" toggle (forces the next mock action to show an error state), "Reset semua data" (restores seed data).
- **States:** default.

---

## P2 extras (time-permitting)

- Mechanic "additional work found" approval card on S21 (mock push-style card: "Montir menemukan kampas rem aus, tambah servis? Ya/Tidak").
- Complaint photo attachment on S11's Keluhan section (image picker, local only).
- "Bagikan tiket" on S18 (share booking code/QR as image/text via OS share sheet).
- "Tambah ke Kalender" on S18/S20 (device calendar intent for the arrival slot).

---

## Global patterns

- **Dialogs:** confirm-destructive (Batalkan, Hapus motor) use a centered dialog with a clear danger-styled confirm button, cancel as the de-emphasized action.
- **Snackbars:** transient success/info feedback (e.g. "Draft disimpan," "Voucher diterapkan").
- **Bottom sheets:** S12 part detail, S17 (can be sheet or full page depending on content volume), S22 both actions — draggable, `SheetHeader` with drag handle.
- **Keyboard handling:** all text-input screens (S03, S08, S11 complaint notes) scroll content above the keyboard; sticky footers (S11, S15, S16) re-position above the keyboard inset, never overlapped.
