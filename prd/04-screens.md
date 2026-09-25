# 04 — Screen Inventory & Specs

Priority legend: **P0** mandatory core, **P1** bonus, **P2** cut-line-first. Tablet behavior pointers refer to [06-responsive-layout.md](06-responsive-layout.md). Components reference [02-brand-design-system.md](02-brand-design-system.md).

Status: aligned to the approved design (Pencil, design steps 05–19, 2026-09-25). Copy is Bahasa Indonesia, sentence case; every price is an estimate. State names below match the design frame names (`S<id> <Name> / <State> / <Breakpoint>`); business rules live in [03](03-user-flows.md).

---

## Auth

### S01 — Splash `P1`
- **Purpose:** brand presence + session check.
- **Content:** `TsLogo` (mark only, centered) on `bg-page`; an end-state frame shows the "TumbasServis" wordmark fading in below after ~400 ms (static under reduce-motion).
- **States:** mark only, wordmark end state; loading (checking persisted session) → routes to S02 (first launch) or S05 (returning, session valid).
- **Interaction:** none (auto-advance after ≥800 ms + session check).

### S02 — Onboarding `P1`
- **Purpose:** introduce the multi-vehicle value prop before login.
- **Content:** 3 swipeable slides — (1) "Servis banyak motor, sekali booking," (2) "Atur servis & keluhan tiap motor secara terpisah," (3) "Pantau status tiap unit secara real-time." Titles are Headline Small (22) with a 1–2 line body; art is component vignettes on a tonal `accent-soft` panel (silhouettes + ticket, motor cards + service pills, timeline + fleet progress). `PageIndicator` dots; "Lewati" (skip, top-right, hidden on slide 3); "Lanjut" (slides 1–2) / "Mulai" (slide 3) bottom CTA.
- **States:** slides 1–3.
- **Interaction:** swipe or tap CTA to advance; skip jumps to S03.

### S03 — Login `P0` (entry point) / detail `P1`
- **Purpose:** collect phone number.
- **Content:** `TsLogo` mark + wordmark (compact), headline "Masuk ke TumbasServis," `TsTextField` with fixed `+62` prefix (digits group as typed, `812-3456-7890`), helper "Kami kirim kode OTP lewat SMS ke nomor ini.", `TsButton` "Kirim kode OTP" (**always enabled**), terms microcopy in two lines ("Dengan melanjutkan, kamu setuju dengan / Syarat & Ketentuan dan Kebijakan Privasi.").
- **States:** default, invalid phone (validated on blur / submit: danger border + icon + "Nomor tidak valid. Contoh: 812-3456-7890", digits stay), keyboard open, loading (button spinner, field read-only), network error (mock: snackbar "Gagal mengirim kode. Cek koneksi, lalu coba lagi." with "Coba lagi").
- **Interaction:** submit → S04.

### S04 — OTP `P1`
- **Purpose:** mock verification.
- **Content:** headline "Masukkan kode OTP," "Kode 6 digit dikirim lewat SMS ke" + masked number on its own line with a "Ganti nomor" link (→ S03), six boxed cells (auto-advance, paste fills all), a demo-mode line "Kode demo: 123456" (info icon + text, demo build only), resend link with 30 s countdown ("Kirim ulang kode dalam 0:30" → accent link "Kirim ulang kode"), "Verifikasi" CTA — disabled until all six digits are in, with the reason line "Masukkan 6 digit kode" under it; no auto-submit.
- **States:** default, wrong code (cells clear, danger border + icon + "Kode salah. Cek lagi 6 digitnya atau kirim ulang kode.", shake as a hint only), resend available, keyboard open (filled, CTA enabled), loading.
- **Interaction:** demo code `123456` always succeeds → S05. Any other 6-digit code → error state.

---

## Shell

### S05 — Beranda (Home) `P0`
- **Purpose:** entry to booking + at-a-glance status.
- **Content top→bottom:** app bar (logo + notification bell with unread badge → S06; on medium / large the rail carries the logo and the bar is the greeting + bell), greeting ("Halo, Galah 👋"), primary CTA card "Booking servis motor" with "Mulai booking," active-booking card(s) (if any — booking code, `FleetProgress`, motor count; tap → S20; the status label is the unit status shared by most motors, ties → the earliest stage, plus a caption when units differ; the derived booking status `Berlangsung` is not shown), draft card (if a draft exists: title, motor summary, step X/4, expiry line — warning under 3 h — "Lanjutkan" as a Secondary button and "Hapus draft" with a confirm dialog), promo banner carousel (`PromoBanner`, page dots only, non-interactive, "Promo 1 dari 3"; auto-advance 5 s that stops on touch / focus / hover and under reduce-motion), "Garasi saya" horizontal motor strip (in-service motors carry a compact status badge; "Lihat semua" → S07; "+" tile → S08; tap card → S09), quick links "Riwayat" and "Katalog suku cadang" (→ S12 browse mode).
- **Nav:** bottom `NavBar` — Beranda · Riwayat · Garasi · Profil.
- **States:** loading (skeleton cards), empty (no active booking → CTA emphasized), populated (Vario / Beat / PCX in service + Supra X 125 free, draft card), populated with 1 motor and long names, stress (360×640, text ×1.3).
- **Tablet:** see [06](06-responsive-layout.md) — rail nav, 2-col card grid at medium+.

```
┌────────────────────────────┐
│ TS  TumbasServis        🔔2│
├────────────────────────────┤
│ Halo, Galah 👋              │
│ ┌────────────────────────┐ │
│ │  Booking servis motor  │ │
│ │  [ Mulai booking → ]   │ │
│ └────────────────────────┘ │
│ ┌ Booking aktif ─────────┐ │
│ │ TS-260929-0417  ●●●○○  │ │
│ │ 3 motor · Dikerjakan   │ │
│ └────────────────────────┘ │
│ [Promo banner carousel]    │
│ Garasi saya    Lihat semua │
│ [🏍][🏍][🏍][+]            │
├────────────────────────────┤
│  🏠     🕘     🏍     👤   │
└────────────────────────────┘
```

### S06 — Notifikasi `P1`
- **Purpose:** in-app notification inbox (status changes, promos, reminders).
- **Content:** a **pushed page** (no `NavBar` / `NavRail`) reached from the S05 bell. Grouped list (Hari ini / Minggu ini / Lebih lama), `NotificationTile` per item (icon by category, title, timestamp; unread = dot + semibold title + hidden "Belum dibaca" label; text wraps, no line clamp), "Tandai semua dibaca" in the first group's header row. Tap → unit status change → S21 of that unit; booking confirmation → S20; invoice ready → S23; **promo → S10 with the voucher carried** (S17 is reachable only from S16); service reminder → S10 with the motor pre-checked. The S05 bell badge equals the unread count (2 in the demo moment).
- **States:** loading, empty ("Belum ada notifikasi"), populated (2 unread), all read, stress (text ×1.3).

---

## Garage

### S07 — Garasi Saya `P1`
- **Purpose:** list owned motors.
- **Content:** list of motor cards (silhouette / photo, name, plate, model; in-service motors carry a status badge — icon + text; tap → S09). **One add action only:** the header "+" (→ S08), hidden while the garage is empty so the empty-state CTA is the only action; no FAB and no in-list add card.
- **States:** loading, empty (illustration + "Tambah motor pertamamu"), populated (Vario / Beat / PCX in service + Supra X free).
- **Tablet:** 2-col grid (Tablet-P, content 720) / 3-col grid (Tablet-L); the tiles reuse the horizontal `VehicleSelectCard / Mode=Display`.

### S08 — Tambah/Edit Motor `P1`
- **Purpose:** create or edit a garage entry.
- **Content:** form — photo (optional: silhouette tile by model category + "Tambah foto" + helper; chooser / permission are annotations), nickname (max 20 characters with a counter), brand/model picker (bottom sheet on phone / centered modal 560 on tablet, brand groups + search), plate number (auto-format `AB 1234 XY`, format and duplicate errors), year (optional, numeric, 1990–2026). Flat sticky "Simpan" (always enabled; validated on submit).
- **States:** add default, edit prefilled, validation error, keyboard open, saving (spinner button, fields disabled style), save error (inline banner + "Coba lagi"), model picker, dirty-cancel dialog ("Buang perubahan?" — "Lanjut mengisi" primary / "Buang").
- **Interaction:** Save → back to S07 (new/updated card visible); back / Cancel on a dirty form → dialog.

### S09 — Detail Motor `P1`
- **Purpose:** single motor detail + history entry point.
- **Content:** app bar with edit (→ S08); hero (`MotorHero`: silhouette / photo, name, plate, status badge if in service); `MotorDetails` card (Merek, Model, Jenis, Kapasitas, Tahun); **"Booking motor ini"** CTA (→ F2 with pre-selection) — **disabled with the reason "Sedang dalam servis"** plus a "Lacak servis" link (→ S20) when the motor is in a booking; service-history list (the active row first, then the 3 latest past rows, "Lihat semua" → S19 pre-filtered to this motor; empty "Belum ada riwayat servis"); "Hapus motor" as a danger ghost button at the very bottom (dialog "Hapus <motor>?" — "Batal" / "Hapus"; blocked dialog "Motor ini punya booking aktif" — "Tutup" / "Lihat booking").
- **States:** populated in service, free motor with empty history, delete confirm, delete blocked.
- **Tablet:** Tablet-P stacked (max 720, full-scroll capture); Tablet-L hero + CTA + delete link left (400), details + history right (640).

---

## Booking (P0 core)

Chrome: the booking flow S10–S18 shows **no `NavBar` / `NavRail`** at any size; back / close in the app bar, a sticky footer at the bottom. On tablet the app bar and stepper are full width and the content is centered at the max width in [06](06-responsive-layout.md).

### S10 — Pilih Motor `P0`
- **Purpose:** multi-select 1–5 motors for this booking.
- **Content:** `BookingStepper` ("Langkah 1 dari 4 · Motor"), title "Yuk, pilih motor yang mau diservis" with "Bisa sampai 5 motor sekaligus. Servis tiap motor diatur di langkah berikutnya.", `VehicleSelectCard`s from Garage (checkbox-style multi-select), disabled cards show "Sedang dalam servis" (or "Maks. 5 motor" at the limit), an end-of-list "+ Tambah motor lain" card (→ S08; stays enabled at max), and a flat sticky footer: counter "N dari 5 motor dipilih" + "Lanjut" (disabled until ≥ 1 selected) with a reason line ("Pilih minimal 1 motor" at 0, "Lepas satu untuk memilih motor lain" at 5). A motor added from S08 comes back available, not selected (snackbar "Motor ditambahkan"). Close → exit dialog only with ≥ 1 selection.
- **States:** loading (reason "Memuat daftar motor…"), empty garage (CTA "Tambah motor pertamamu" → S08), none selected, selected, max reached (5th selected → further cards disabled), exit dialog, stress.
- **Tablet:** 2-col card grid at medium; 3-col at large (content max ~1040).

### S11 — Detail Servis per Motor `P0` (core challenge screen)
- **Purpose:** configure service/parts/complaint independently per unit.
- **Content:** `TsAppBar / Type=Step` (back → S10 keeping the draft, close → exit dialog under the ≥ 1-selection rule); `BookingStepper` ("Langkah 2 dari 4 · Servis") with the completion badge ("2/3 ✓"); **chip-tab row** (`VehicleTabChip` per unit — complete ✓ / incomplete ○ / error, the active one keeps its glyph; hidden with 1 unit); `UnitHeader` ("Untuk: Beat 110", plate, a remove icon hidden with one unit — a unit with selections is removed through a destructive dialog); "Salin dari <motor>" directly under the header (a named row when there is one source, a sheet — modal on tablet — with 2+ sources, undo snackbar "Disalin dari …", incompatible parts dropped with a note); **Jenis servis** card (`ServiceOptionTile`s: Servis Berkala Rp85.000 · 60 mnt, Ganti Oli Rp35.000 · 30 mnt, Perbaikan/Keluhan Rp50.000 "estimasi awal" · 60 mnt); **Suku cadang / oli** card (`PartOptionTile` shortlist filtered by model, "Lihat semua" → S12); **Keluhan** as a collapsed optional row ("+ Tambah keluhan (opsional)") that opens automatically and becomes required with Perbaikan/Keluhan; sticky glass `StickyEstimateBar` ("Estimasi · 1 jam" over the live total of everything selected so far, "Lanjut"). "Lanjut" is disabled with a reason ("Pilih layanan untuk PCX 160") until every chip shows ✓.
- **States:** single unit, multi unit, complaint required, copied, copy source sheet, all complete, loading, error (retry), remove-unit dialog, keyboard open, long content, stress (360×640, ×1.3).
- **Interaction:** switching chip tabs preserves each unit's in-progress state.
- **Tablet:** medium = chip row on top + form (max 720) + glass pill; expanded (840–1199) = unit rail 252 + form 700 + pill; large (≥ 1200) = rail 252 · form 572 · live `EstimatePane` 360 (static per-unit lines, no voucher), 1 unit = form 720 + pane 360 centered. See [06](06-responsive-layout.md).

```
┌────────────────────────────┐
│ ←  Detail servis         ✕ │
│ ①─②─③─④  2/3 ✓            │
├────────────────────────────┤
│ [Vario ✓][Beat ●][PCX ○]   │
├────────────────────────────┤
│ Untuk: Beat 110 · AB 5678 ZZ│
│ ⎘ Salin dari Vario         │
│ Jenis servis                │
│ ┌────────────────────────┐ │
│ │ ☑ Servis Berkala       │ │
│ │ ☐ Ganti Oli            │ │
│ │ ☐ Perbaikan/Keluhan    │ │
│ └────────────────────────┘ │
│ Suku cadang / oli Lihat semua│
│ ┌────────────────────────┐ │
│ │ ☑ AHM Oli MPX1  Rp70.000│ │
│ │ ☐ Kampas Rem    Rp45.000│ │
│ └────────────────────────┘ │
│ + Tambah keluhan (opsional) │
├────────────────────────────┤
│ Estimasi · 1 jam            │
│ Rp228.000          [Lanjut]│
└────────────────────────────┘
```

### S12 — Katalog Suku Cadang & Oli `P1`
- **Purpose:** full parts/oil browser (deep-dive vs. S11's inline shortlist).
- **Content:** a **full-screen page at every size**, pushed over S11 (no shell), in two modes. *Select mode* (S11 "Lihat semua"): close icon, "Untuk: Beat 110", checkboxes, flat `SelectedPartsBar` "N dipilih · Subtotal …" + "Selesai". *Browse mode* (S05 quick link, route `/catalog`): back arrow, no unit context, checkbox or cart. Shared: category chips (Semua · Oli · Kampas rem · Busi · Aki · Ban · Filter udara), search bar, the row "Hanya yang cocok untuk Beat 110" with `TsSwitch` (default ON; OFF shows incompatible tiles disabled with a category + cc reason, icon + text), `PartOptionTile` list (leading checkbox toggles, the body opens the detail). The detail is a bottom sheet (phone) / centered modal 560 (tablet): specs, compatibility block (rule line + garage rows ✓ Cocok / ✕ Tidak cocok), CTA "Tambah ke booking" / "Hapus dari booking". Selection is **staged**: "Selesai" commits to S11's active unit (parts not in the S11 shortlist are appended); close / back with changes asks "Buang perubahan?" ("Lanjut memilih" / "Buang").
- **States:** select populated, incompatible shown, loading, empty, browse populated, search keyboard open, detail (add / incompatible / browse), dirty-close dialog.
- **Tablet:** Tablet-P 2-col grid (720); Tablet-L 4-col grid.

### S13 — Pilih Bengkel `P0`
- **Purpose:** choose the shared workshop for the whole booking.
- **Content:** `BookingStepper` ("Langkah 3 dari 4 · Bengkel & jadwal"), search bar, filters: "Buka sekarang" (independent toggle) and the exclusive sorts "Rating tertinggi" / "Terdekat" (default Terdekat) with a result line "N bengkel · urut terdekat"; `WorkshopCard` list (name, rating · distance, open / closed badge, "2 bay servis" and "Estimasi 2 jam untuk 3 motor" — the makespan of the draft's units over that workshop's bays; the chosen workshop carries a "Dipilih" tag; a workshop closed now shows "Tutup · buka 08.00" and stays bookable); no footer (the choice is committed from S14). Tap → S14.
- **States:** loading, empty (no results for the filter), populated, chosen, stress.
- **Tablet:** Tablet-P 1-col list (max 720); expanded list 400 + S14 pane 552; large list 440 + pane 768 with the CTA pinned at the pane bottom.

### S14 — Detail Bengkel `P1`
- **Purpose:** workshop detail before committing.
- **Content:** photo header (`WorkshopPhoto`), name / rating / "126 ulasan" / hours (open status computed from `openHours`), token-bound `StaticMap` + "Buka di Maps" (external intent via `url_launcher`), services offered, address, `WorkshopCtaBar`. **Two variants:** *in-flow* (from S13: back + close, no stepper, CTA "Pilih bengkel ini" → S15, "Lanjut ke jadwal" when already chosen) and *standalone* (from the workshop row of S18 / S20: back only, CTA "Booking di sini" → S10 with the workshop carried and S13 skipped). Closed now: status "Tutup · buka 08.00" and a helper on the CTA.
- **States:** loading, populated, populated standalone, closed, chosen, stress.
- **Tablet:** Tablet-L standalone = photo + map left (560), info right (648).

### S15 — Pilih Jadwal `P0`
- **Purpose:** shared or per-unit arrival slot.
- **Content:** `BookingStepper` (step 3/4), compact `WorkshopSummaryRow` ("Bengkel Jaya Motor · 2 bay servis · Ubah" → S13), horizontal `DateStripItem` scroller (D+0…D+14, month in each caption), hourly `SlotChip` grid for the selected date ("Sisa n motor"; D+0 slots before now + 2 h disabled "Lewat" with the helper "Booking hari ini minimal 2 jam sebelum jam datang."), a derived `CapacityBanner` (info → warning when no hour fits N, action "Pisah jadwal"; all-full day: "Semua jam penuh" / "Coba tanggal lain — masih ada jam kosong di hari berikutnya." + "Lihat <next day>"), the "Pisah jadwal per motor" toggle (per-unit sections: an accordion on phone / Tablet-P, a unit rail + grid + slots on Tablet-L; sibling picks count against capacity), flat sticky footer with the slot recap ("Sel, 29 Sep 2026 · 09.00" / "n dari 3 motor terjadwal") + "Lanjut" (reason line while disabled).
- **States:** loading, shared populated, shared insufficient, all full, D+0 lewat, split one complete, split all complete, split sibling conflict, stress.
- **Tablet:** phone / Tablet-P = date strip above a 3-col slot grid; expanded = date grid 400 + slots 552; large = 2-week calendar grid (7 × 3) 480 + slots 728 (split: rail 240 · grid 420 · slots 524).

### S16 — Ringkasan `P0`
- **Purpose:** final review before confirming.
- **Content:** `BookingStepper` (step 4/4), `SummaryCard` with a **Bengkel** row ("Ubah bengkel" → S13; changing it forces a new schedule) and a **Jadwal** row ("Ubah jadwal" → S15; split mode lists each unit's slot), per-unit collapsible `UnitSummaryAccordion` (services, parts with prices, complaint, "Ubah <motor>" → S11), the "Estimasi biaya" block — one static line per unit → subtotal → voucher → "Total estimasi" — with an inline duration caption ("Estimasi 2 jam · dikerjakan bergantian di 2 bay"; split mode "Estimasi 1 jam per motor · datang di jam berbeda"), `VoucherRow` (empty → S17; applied: name + "Hemat Rp42.800" + "Hapus"), payment note ("Bayar di bengkel saat selesai"), and a **flat** sticky bar: total row + full-width "Konfirmasi booking".
- **States:** loading (recompute), ready with voucher, ready no voucher, invalid slot (warning banner "Tersisa 2 motor di Sel, 29 Sep · 09.00" with "Pisah jadwal" / "Pilih jam lain"; Jadwal row shows the problem; CTA disabled with a reason), confirming, confirm error (inline banner + "Coba lagi"), split recap, single unit, stress.
- **Interaction:** Konfirmasi → brief loading → S18.
- **Tablet:** Tablet-P stacked (max 720) with the flat bar; expanded recap 592 + pane 360; large recap 720 + pane 360 (centered) — the pane holds the voucher row, estimate block, payment note and the CTA.

```
┌────────────────────────────┐
│ ←  Ringkasan             ✕ │
│ ①─②─③─④                   │
├────────────────────────────┤
│ Bengkel  Bengkel Jaya Motor │
│                 Ubah bengkel│
│ Jadwal   Sel, 29 Sep 2026   │
│          · 09.00  Ubah jadwal│
├────────────────────────────┤
│ ▸ Vario 125                 │
│ ▸ Beat 110                  │
│ ▸ PCX 160                   │
├────────────────────────────┤
│ Estimasi biaya              │
│ Vario 125          Rp85.000 │
│ Beat 110          Rp143.000 │
│ PCX 160           Rp200.000 │
│ Subtotal          Rp428.000 │
│ Diskon 10%  Hemat -Rp42.800 │
│ Total estimasi    Rp385.200 │
│ Estimasi 2 jam · 2 bay      │
│ Bayar di bengkel            │
├────────────────────────────┤
│ Total estimasi   Rp385.200  │
│   [ Konfirmasi booking ]    │
└────────────────────────────┘
```

### S17 — Pilih Voucher `P1`
- **Purpose:** apply a discount voucher.
- **Content:** a **full page** (`/booking/summary/voucher`, back-only bar) reachable only from S16. Radio `VoucherCard` list: eligible vouchers sorted by saving, then ineligible ones disabled with the specific reason ("Butuh min. 4 motor", "Min. belanja Rp500.000 — kurang Rp72.000"); "Tidak pakai voucher" is the last row; no code field. Flat footer: "Total estimasi Rp385.200 · Hemat Rp42.800" + **"Terapkan"**.
- **States:** loading, populated, empty, single motor.
- **Tablet:** Tablet-P max 560; large 2 cols × 440.

### S18 — Booking Berhasil (Tiket Servis) `P0`
- **Purpose:** confirmation ticket — the flow's terminal success screen.
- **Content:** **no app bar** (the two CTAs are the exits; system back = Beranda and the draft is cleared). `SuccessHeader`: check badge, "Booking berhasil!", "Tunjukkan tiket ini di bengkel saat datang." `TicketCard` with perforated edges: the booking code shown **once** with a "Salin" icon button (snackbar "Kode booking disalin"), a real scannable QR (`qr_flutter`, encodes the booking code; dark on a white tile in both themes; ≥ 126 dp with a 4-module quiet zone), per-unit rows (motor name, "Unit -A · service summary" max 2 lines, `UnitStatusBadge` "Terjadwal", no plate; split mode adds a slot line per unit "Sel, 29 Sep · 09.00"), workshop row (→ S14 standalone), schedule recap ("Sel, 29 Sep 2026 · 09.00", split: "jam berbeda tiap motor"), "Total estimasi · Bayar di bengkel · Rp385.200". Flat sticky footer `TicketActions`: "Lacak status" (→ S20) and "Kembali ke beranda" (→ S05). P2: "Bagikan tiket" and "Tambah ke kalender" in a compact button row under the ticket.
- **States:** loading (real header + skeleton ticket, "Membuat tiket…", "Lacak status" disabled with "Aktif setelah tiket dibuat"), populated, single unit, split schedule, P2 share + calendar, copied-code snackbar, stress (5-unit specimen `TS-261002-0418`).
- **Tablet:** portrait = centered ticket (max 560) + flat sticky bar; expanded / large = ticket 480 + status panel 400 side by side (904, centered), the CTAs sit under the panel and the panel rows are read-only.

```
┌────────────────────────────┐
│         ✅                  │
│      Booking berhasil!      │
│ Tunjukkan tiket ini di      │
│ bengkel saat datang.        │
│   TS-260929-0417   ⎘ Salin │
│   [ QR CODE ]               │
├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┤
│ Vario 125 (-A)   Terjadwal │
│ Beat 110   (-B)   Terjadwal │
│ PCX 160    (-C)   Terjadwal │
├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┤
│ Bengkel Jaya Motor        › │
│ Sel, 29 Sep 2026 · 09.00    │
│ Total estimasi · Bayar di   │
│ bengkel · Rp385.200         │
├────────────────────────────┤
│     [ Lacak status ]        │
│     [ Kembali ke beranda ]  │
└────────────────────────────┘
```

---

## Post-booking (P1)

### S19 — Riwayat
- **Purpose:** booking history.
- **Content:** app bar title + scrolling underline tabs with counts ("Mendatang · 1", "Berlangsung · 1", "Selesai · 2", "Dibatalkan"; label + count on one line, 48 dp hit height), booking summary cards (code, workshop, date, motor count, status badge), tap → S20. Opened pre-filtered by a motor (from S09 "Lihat semua") it shows a dismissible motor chip and recomputes the counts (annotation).
- **States:** loading, empty per tab, populated per tab.

### S20 — Detail Booking & Status
- **Purpose:** hub for one booking — overview + actions.
- **Content:** header (code + status badge, a tappable workshop row with a chevron → S14 standalone — no "Ubah" here, the schedule), fleet-level `FleetProgress`, per-unit `UnitStatusRow`s (name + badge on one row, meta line, chevron → S21), actions: "Ubah jadwal" and "Batalkan" (→ S22; disabled once any unit is checked in, with the note "Sudah check-in — jadwal tidak bisa diubah" / "… booking tidak bisa dibatalkan"), "Lihat invoice" once `Selesai`, "Beri ulasan" — **Selesai unpaid:** "Lihat invoice" enabled, "Beri ulasan" disabled with the reason "Tandai lunas di invoice dulu"; **Selesai paid:** both enabled; after a review "Lihat ulasan". Dibatalkan shows "Dibatalkan <tgl>" (no refund line: the product has no deposit).
- **States:** Terjadwal, Berlangsung, Selesai belum lunas, Selesai lunas, Dibatalkan, loading.

### S21 — Lacak Unit
- **Purpose:** per-unit live tracking detail.
- **Content:** unit header (motor, plate, unit code, service list), `StatusTimeline` (Terjadwal → Check-in → Diperiksa → Dikerjakan → QC → Selesai, done / current / pending nodes with timestamps; the current node is bold + a caption, never motion-only), ETA card ("Estimasi selesai ±10.15"), `MechanicCard` once assigned (units A / C Pak Anto, B Mas Rudi), `DemoModeShortcut` ("MODE DEMO" label, "Majukan status" / "Reset" — the same `TrackingSimulator` as S26).
- **States:** loading, live (timer-driven), completed, cancelled.
- **Tablet:** Tablet-P content max 640; Tablet-L = unit header + timeline left, ETA + mechanic + demo shortcut right (no map).

### S22 — Ubah Jadwal / Batalkan (sheets)
- **Purpose:** modify a `Terjadwal` booking/unit.
- **Content:** *Ubah jadwal* reuses the S15 date/slot picker in a bottom sheet (phone, anchored to the bottom edge) / centered modal 560 (tablet, title row + close, no handle); full slots "Penuh", D+0 "Lewat", the current slot marked "Jadwal sekarang"; flat footer "Simpan jadwal". *Batalkan* is a dialog (312 dp phone / 400 tablet) with the scope choice ("Seluruh booking · 3 motor" / "Hanya <motor> · Unit -X"), wrapping optional reason chips, body "Pembatalan tidak bisa diurungkan.", confirm "Ya, batalkan" (danger), dismiss "Kembali".
- **States:** sheet, loading ("Menyimpan jadwal"), error (inline, sheet stays open), dialog, success snackbar "Jadwal diperbarui" + S20 refresh.

### S23 — Invoice
- **Purpose:** itemized bill once a booking is `Selesai`.
- **Content:** `InvoiceHeaderCard` (booking code, workshop, "Diterbitkan <time>", `PaymentStatusTag`), `PriceBreakdown / Variant=Invoice` per unit (service + part lines + unit subtotal, every unit expanded), subtotal → voucher → total ("Total tagihan" / "Total dibayar"), payment note. Flat footer "Tandai lunas" (mock; confirm dialog "Tandai sudah dibayar?" — "Ya, tandai lunas" / "Batal", "Simulasi, tidak ada pembayaran sungguhan"); once paid a success `PaidBanner` + tag and the footer becomes "Beri ulasan" (→ "Lihat ulasan" after a review). P2: "Bagikan" in the app bar (one variant frame).
- **States:** unpaid, paid, error (inline + "Coba lagi"), loading, confirm dialog, P2 share.
- **Tablet:** Tablet-L = breakdown 720 + `InvoiceSummaryCard` 360.

### S24 — Beri Ulasan
- **Purpose:** post-service rating. **Hard-gated:** reachable only after the invoice is paid.
- **Content:** workshop `RatingStars` (input: whole stars, 5 × 48 dp, live word label + "n dari 5"), an optional comment (max 300 characters), the "Nilai montir" section only when **≥ 2 distinct mechanics** served the booking (rows optional, e.g. Mas Rudi · Beat 110; Pak Anto · Vario 125 + PCX 160), "Kirim ulasan" (validated on submit).
- **States:** default, validation, submitting, single mechanic, keyboard open, submitted (same-screen read-only `ReviewRecap`, then "Kembali ke detail booking").
- **Tablet:** Tablet-L right pane = live recap preview of the user's own review.

---

## Profile (P1)

### S25 — Profil & Pengaturan
- **Purpose:** account + app settings.
- **Content:** in `AppShell` (Profil tab). User card (name, phone), settings groups — Tema (segmented control "Sistem / Terang / Gelap", default Sistem), Notifikasi (one master switch: "Status servis, promo, dan pengingat"), Mode Demo (→ S26, "Demo" tag), Tentang aplikasi (bottom sheet on phone / modal on Tablet-P: version `1.0.0 (1)`, demo note, "Dibuat oleh Galah"), Keluar (logout: a **neutral** confirm that clears the session only — garage, bookings and drafts stay on the device; danger styling is reserved for "Reset semua data").
- **States:** default, logout dialog, about sheet / modal, stress.
- **Tablet:** Tablet-L = menu + a "Pratinjau tema" panel (forced-theme mini app).

### S26 — Panel Mode Demo
- **Purpose:** reviewer-facing controls to showcase dynamic features quickly (supports the "Mode Demo" mentioned in S21/S18 and Assessment reviewers' need to see states fast).
- **Content:** a **pushed page** (no shell). Caption once at the top; every panel carries a "MODE DEMO" label. *Kecepatan:* segmented control "Mati / 15 dtk / 5 dtk" (default 15 dtk; replaces the slider). *Status booking:* per-unit rows (-A / -B / -C) with "Majukan" (disabled at Selesai) and "Reset", plus booking-level "Majukan semua" / "Reset semua"; the selected unit is previewed ("Dipratinjau" tag, live `StatusTimeline`). *Simulasi galat:* "Simulasikan galat jaringan" — one-shot, the next mock write fails and the switch disarms itself; an armed banner on S26 only. *Data demo:* "Reset semua data" (danger, confirm dialog "Ya, reset data") restores the PRD 05 seed (garage, bookings, draft, notification read-state, invoices, reviews); session, theme and demo settings are kept; snackbar "Data demo dikembalikan", then Home.
- **States:** default, no active booking, unit selesai, error armed, reset dialog, stress (status controls stack into a column at large text).
- **Tablet:** Tablet-L = controls left (Kecepatan + Status), right preview + Simulasi galat + Data demo.

---

## P2 extras (time-permitting)

- Mechanic "additional work found" approval card on S21 (mock push-style card: "Montir menemukan kampas rem aus, tambah servis? Ya/Tidak").
- Complaint photo attachment on S11's Keluhan section (image picker, local only).
- "Bagikan tiket" on S18 (share booking code/QR as image/text via OS share sheet); "Bagikan" on S23.
- "Tambah ke kalender" on S18/S20 (device calendar intent for the arrival slot).

---

## Global patterns

- **Dialogs (`TsDialog`):** confirm-destructive (Batalkan, Hapus motor, Keluarkan motor, Reset data) use a centered dialog with a danger-styled confirm and the de-emphasized dismiss **"Batal"** ("Kembali" only in the cancel-booking dialog); exit / discard dialogs are non-destructive ("Simpan & keluar" / "Lanjutkan booking", "Lanjut mengisi" / "Buang"). Widths 312 (phone) / 400 (tablet).
- **Snackbars (`TsSnackbar`):** transient success / info / error feedback ("Draft disimpan," "Motor ditambahkan," "Kode booking disalin"); a snackbar carrying an action or an error stays until dismissed.
- **Sheets and modals:** S12 part detail, S08 model picker, S11 copy source, S22 reschedule, S25 About — a draggable bottom sheet with `SheetHeader` on phone, a centered modal 560 on tablet. S17 is a full page, not a sheet.
- **Forms and gates:** text forms (S03, S08) validate on blur / submit with the button enabled; count-gated CTAs disable only with a visible reason line; loading states show "Memuat …" ([03](03-user-flows.md)).
- **Keyboard handling:** all text-input screens (S03, S04, S08, S11 complaint notes, S12 search, S24 comment) scroll content above the keyboard; sticky footers (S10, S11, S15, S16) re-position above the keyboard inset, never overlapped.
- **Motion:** 150 ms micro-interactions, ~250 ms route / sheet, ~300 ms staggered timeline; everything off under `MediaQuery.disableAnimations`; no state is carried by motion alone.
