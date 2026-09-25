# Step 19 — Full-app audit

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | — (gate before Figma conversion) |
| **Owns screens** | — |
| **Owns components** | — |
| **Reviews** | All 26 screens (S01–S26), all components, all tokens |
| **PRD refs** | [02 inventory + Figma doc spec](../../../prd/02-brand-design-system.md), [04 screen inventory](../../../prd/04-screens.md), [06 device matrix](../../../prd/06-responsive-layout.md), [08 B1–B5](../../../prd/08-deliverables-acceptance.md) |
| **Pen location** | Whole document; refresh `P0 Flow Board` |
| **Depends on** | Steps 01–18 |
| **Claude session** | `docs/claude-session/21-design-step19-full-app-audit.md` (written after approval) |

## Goal

Verify the finished Pencil design is **complete, consistent and convertible** before it is copied into Figma: every PRD screen/state/breakpoint exists, tokens are the only source of color/type/space, the component inventory matches the PRD (plus documented additions), and the PRD is updated to match design decisions made along the way.

## Inputs

- All steps' matrices and Session logs; the index's *Inventory additions* list.
- PRD 02 inventory (28) and PRD 04/06 screen and layout tables.

## Open questions (ask at kickoff)

1. Which PRD edits does the user want applied now (token divergences from step 02, `TsDialog`/`TsSnackbar` and other inventory additions, price set, and the Starter dark-mode workaround if step 01 chose two collections)? Approve the exact diff list before editing `prd/`. The window-class wording in `prd/06` was already fixed in step 01.
2. Any frames the user wants dropped or added before conversion (each removed frame saves Figma effort).

### PRD 04 S05 corrections collected in step 05 (2026-09-24; apply in this step after approval)

- **Status label rule:** the active-booking card shows the unit status shared by most motors (ties → earliest stage) + a caption when units differ; the derived booking status `Berlangsung` (PRD 03) is not shown on the card.
- **Draft card:** title, motor summary, step X/4, expiry line (warning under 3 h), "Lanjutkan" + "Hapus draft" (confirm dialog); draft motors must be free (PRD 03 in-service rule).
- **Garage strip:** in-service motors carry a compact status badge; "Lihat semua" link; "+" tile.
- **Tablet app bar:** medium / large drop the logo (the rail carries it); greeting is the bar title.
- **Copy:** sentence case ("Mulai booking", "Garasi saya", "Katalog suku cadang"), as decided in step 03.
- **Demo content:** the Home populated state adds the sheet-only Supra X 125 (AB 3344 KL) as a 4th motor and the draft.
- **Promo carousel:** page dots only (non-interactive, "Promo 1 dari 3"); auto-advance 5 s stops on touch / focus / hover and with reduce-motion. A visible pause / play button was proposed by the step 05 review (WCAG 2.2.2) and declined by the user; PRD 04 S05 keeps the carousel as specified.
- **Draft card:** "Lanjutkan" is a Secondary (tonal) button so the filled primary stays on the booking CTA.
- **Tablet nav:** the medium / large app bar carries the greeting + bell without the logo (a `TsAppBar / Type=Title, Actions=Bell` master).

### PRD S10 / booking-flow corrections collected in step 06 (2026-09-24; apply in this step after approval)

- **PRD 04 S10 copy:** sentence case ("Pilih motor", "Lanjut"); the selection counter ("N dari 5 motor dipilih") lives in the sticky footer with a reason line ("Pilih minimal 1 motor" at 0, "Lepas satu untuk memilih motor lain" at 5), not in a header row; "+ Tambah motor lain" is an end-of-list card that stays enabled at max-reached; a motor added from S08 comes back available, not auto-selected (snackbar "Motor ditambahkan").
- **PRD 03 exit rule:** the exit-booking dialog ("Keluar dari booking? Draft akan disimpan.") appears only when the draft holds ≥ 1 selected motor; actions "Simpan & keluar" / "Lanjutkan booking"; discarding a draft stays on Home ("Hapus draft"). Empty-garage CTA text is "Tambah motor pertamamu" (PRD 03 edge case says "Tambah Motor").
- **PRD 06 S10 row:** large = 3-column grid (content max ~1040); the booking flow S10–S18 shows no `NavBar` / `NavRail` (focused flow).
- **Demo content:** S10 garage = 3 canonical + Supra X 125 + Ninja 250 (in service); max-reached specimen adds Scoopy 110.
- **Continuity check (audit track):** S05 populated (Vario / Beat / PCX in service) is the state after the S10 → S18 flow, not before it.

### PRD S11 corrections collected in step 07 (2026-09-24; apply in this step after approval)

- **PRD 04 S11 content:** Keluhan is a collapsed optional row ("+ Tambah keluhan (opsional)") that auto-opens and becomes required with Perbaikan/Keluhan (not "shown only if the selected service requires it"); "Salin dari" sits directly under the unit header; a unit with selections is removed through a destructive dialog, with a remove icon in the unit header (hidden with one unit); back → S10 keeps the draft, close → the exit dialog under the ≥ 1-selection rule. The wireframe "Est. Rp412.000 · 2j" becomes "Estimasi · 1 jam / Rp228.000" (live, everything selected so far); "Lanjut" is disabled with a reason line ("Pilih layanan untuk PCX 160") until every chip is ✓.
- **PRD 04 / 06 S11 tablet:** medium = chip row on top + form (max 720) + glass pill; expanded (840–1199) = unit rail 252 + form + pill; large (≥ 1200) = rail 252 · form 572 · live `EstimatePane` 360 (static per-unit lines, no voucher), 1 unit = form 720 + pane 360 centered. Rail rows = the phone chip states (glyph + nickname + plate / status). The wide stepper carries the "N/3 ✓" badge.
- **`prd/02` inventory:** add `EstimatePane`, `CopySourceSheet` (sheet + modal), `UnitHeader`, `CopyFromRow` / `CopyNote`, `ComplaintSection`, `TsAppBar` step variant, `System / Keyboard` (design-only); `VehicleTabChip` gains Active + Complete / Incomplete / Error.
- **Data (`services.json`):** three S11 services — Servis Berkala Rp85.000 · 60 mnt, Ganti Oli Rp35.000 · 30 mnt, Perbaikan/Keluhan Rp50.000 "estimasi awal" · 60 mnt (`requiresComplaint`); the two non-canonical prices are proposals.

### PRD S13 / S14 corrections collected in step 08 (2026-09-24; apply in this step after approval)

- **PRD 04 S13 content:** each `WorkshopCard` shows the bay count and "Estimasi N jam untuk M motor" (makespan of the draft's units over that workshop's bays); the chosen workshop carries a "Dipilih" tag; no sticky footer (the choice is committed from S14). Filters: "Buka sekarang" is an independent toggle, "Rating tertinggi" / "Terdekat" are mutually exclusive sorts (default Terdekat) with a result line "N bengkel · urut terdekat". Stepper caption "Langkah 3 dari 4 · Bengkel & Jadwal"; sentence case titles.
- **PRD 04 S14 / PRD 03 F2:** the CTA depends on the context — in-flow "Pilih bengkel ini" → S15 ("Lanjut ke jadwal" when the workshop is already chosen), standalone "Booking di sini" → S10 with the workshop carried and S13 skipped. S14 in the flow has no stepper (back + close). The standalone entry has no source screen in the PRD: it is the workshop row of S18 / S20 (added in steps 11 / 16).
- **PRD 03 (pricing & duration) / PRD 04 S11:** S11's duration is computed for a standard 2-bay workshop because no workshop is chosen yet; S13 shows the per-workshop makespan and S16 the final one. A workshop closed *now* is still bookable (slots 08.00–16.00 for D+0…D+14), so every workshop stays open through 17.00; "Buka sekarang" filters by the current time only.
- **PRD 05 `Workshop`:** add `reviewCount` (S14 "126 ulasan") and a structured `openHours` (open / close time) so the status line and the "Buka sekarang" filter are computed, not stored text.
- **PRD 06 S13 row:** Tablet-P = 1-col list (max 720); Expanded (1024) = list 400 + S14 pane 552; Large (1280) = list 440 + pane 768 with the CTA pinned at the pane bottom. Standalone S14 Large = photo + map left (560), info right (648).
- **`prd/02` inventory:** add `SearchBar`, `FilterChipRow`, `StaticMap`, `WorkshopPhoto`, `WorkshopInfoBlock`, `WorkshopDetailContent`, `WorkshopCtaBar`; `WorkshopCard` gains the estimate row and the "Dipilih" tag.
- **Demo content:** S13 workshop list is in the `00-index.md` demo table; `workshops.json` needs the five entries (bays 2 / 3 / 2 / 1 / 2, hours to 17.00 / 18.00 / 17.00 / 17.00 / 17.00, Cahaya closed now).

### PRD S15 corrections collected in step 09 (2026-09-24; apply in this step after approval)

- **PRD 03 scheduling / edge cases (split validation):** in split mode a unit's slot is validated against the seats left *after the other units' picks* (remaining = slot remaining − units already placed there), not "capacity ≥ 1" independently; otherwise 3 motors could be booked into a 1-seat slot. Chips update live; S16 still re-validates on entry.
- **PRD 03 scheduling (chip state precedence):** `short` (remaining < number of units, shared mode) > `limited` (remaining ≤ 2) > `available`. For a 3-motor shared booking `limited` never shows; it shows in split mode and for 1–2-unit bookings. Capacity counts **motors per hour** (`TimeSlot.capacity`), so the caption reads "Sisa n motor".
- **PRD 03 scheduling (D+0):** slots earlier than now + 2 h are shown disabled with "Lewat" (not hidden), with the helper "Booking hari ini minimal 2 jam sebelum jam datang."
- **PRD 03 / PRD 04 (mode switching):** the "Pisah jadwal per motor" toggle is non-destructive — the draft keeps the shared slot and the per-unit slots separately and only the active mode counts. Changing the date clears the shared slot.
- **PRD 04 S15 content:** adds a compact workshop row ("Bengkel Jaya Motor · 2 bay servis · Ubah" → S13), the month in each strip item caption (the calendar grid carries a "Sep – Okt 2026" range), a derived capacity banner (info / warning, action "Pisah jadwal"), a flat sticky footer with the slot recap ("Sel, 29 Sep 2026 · 09.00" / "n dari 3 motor terjadwal") and a reason line while Lanjut is disabled; all-full day = "Semua jam penuh" / "Coba tanggal lain — masih ada jam kosong di hari berikutnya." + a "Lihat <next day>" action (the UI says "jam", not "slot"). No "Konfirmasi" here; Lanjut → S16.
- **PRD 06 S15 row:** Phone / Tablet-P = horizontal date strip above the 3-column slot grid; Expanded (1024) = date grid 400 + slots 552; Large (1280) = 2-week calendar grid 480 + slots 728 (split: unit rail 240 · grid 420 · slots 524). Tablet-L date control = 7 × 3 calendar grid, weekday-aligned.
- **PRD 05 `TimeSlot` / mock data:** capacity 5 motors per hour in the demo; `getAvailableSlots(workshopId, date)` must return per-hour `booked` and `capacity`; the D+0 cutoff is computed from the clock, not stored.
- **`prd/02` inventory:** add `TsSwitch`, `ScheduleModeToggle`, `WorkshopSummaryRow`, `CapacityBanner`, `UnitSlotSection`, `DateGrid` (+ the grid variant of `DateStripItem`); `SlotChip` caption "Sisa n motor" and the "Lewat" label.

### PRD S16 / S17 corrections collected in step 10 (2026-09-24; apply in this step after approval)

- **PRD 04 S16 content:** CTA copy is sentence case, "Konfirmasi booking". The workshop + schedule card has two rows with separate links ("Ubah bengkel" → S13, "Ubah jadwal" → S15; changing the workshop forces a new schedule); in split mode the Jadwal row lists each unit's slot. Per-unit collapsible detail (services, parts with prices, complaint, "Ubah <motor>") is separate from the estimate block, which shows one **static line per unit** → subtotal → voucher → total (the wireframe's "Rp185rb" per unit becomes Rp85.000 / 143.000 / 200.000). The block is titled "Estimasi biaya" with the total labelled "Total estimasi" (every price is "Estimasi"). A flat sticky bar repeats the total next to "Konfirmasi booking".
- **PRD 03 (pricing & duration):** makespan applies to a **shared arrival slot** and is explained inline ("Estimasi 2 jam · dikerjakan bergantian di 2 bay"). In split mode arrivals differ: S16 shows "Estimasi 1 jam per motor · datang di jam berbeda" (per-unit duration, no fleet makespan).
- **PRD 03 edge cases (slot race) / PRD 04 S16 states:** the invalid-slot banner reuses `CapacityBanner` Warning with actions "Pisah jadwal" (→ S15 split) and "Pilih jam lain" (→ S15); the Jadwal row shows the problem, the CTA is disabled with a reason, and S16 states are loading (recompute), ready, invalid slot, confirming, confirm error (Mode Demo, inline banner + "Coba lagi").
- **PRD 03 voucher rules / PRD 04 S17:** S17 is a full page (`/booking/summary/voucher`), reachable only from S16 (a draft is required); promo / notification voucher CTAs start a booking and carry the voucher id. Radio selection + footer "Pakai voucher" with a saving preview; "Tidak pakai voucher" is the last row; applied vouchers can also be removed from S16 ("Hapus"). Eligible vouchers sort by saving, then ineligible ones with the specific reason ("Butuh min. 4 motor", "Min. belanja Rp500.000 — kurang Rp72.000"). No voucher code field.
- **PRD 05 `Voucher` / `vouchers.json`:** four mock vouchers — `DISKON10` (percent 10, minUnits 2, s.d. 31 Okt 2026), `HEMAT25` (flat 25.000, minSubtotal 300.000, s.d. 15 Okt 2026), a 15 % voucher with minUnits 4, a flat 75.000 voucher with minSubtotal 500.000; add `validUntil`. Eligibility and "kurang Rp…" are computed in the domain layer.
- **PRD 06 S16 / S17 rows:** S16 phone / Tablet-P stacked (max 720) with a flat sticky bar; Expanded (1024) = recap 592 + pane 360; Large (1280) = recap 720 + pane 360 (centered), the pane holds voucher row, estimate block, payment note and the CTA. S17: 1-col list, Tablet-P max 560, Large 2 cols × 440.
- **Demo content:** PCX 160 has an optional Keluhan "Rem belakang bunyi saat dingin." on S16 only (S11 canonical has no note).
- **`prd/02` inventory:** add `SummaryCard`, `UnitSummaryAccordion`, `PaymentNote`, `VoucherRow`, `PriceBreakdown / Variant=Confirm`, `ConfirmBar`, `ConfirmPane`, `NoVoucherOption`; `CapacityBanner` gains a second action.

### PRD S18 corrections collected in step 11 (2026-09-24; apply in this step after approval)

- **PRD 04 S18 content:** no app bar (the two CTAs are the exits; system back = Beranda and the draft is cleared, so the flow cannot be re-entered). Header = check badge + "Booking berhasil!" + "Tunjukkan tiket ini di bengkel saat datang."; the booking code is shown **once, on the ticket**, with a copy button ("Salin kode booking" → snackbar "Kode booking disalin"), not in the header. CTAs are sentence case and sticky on phone / Tablet-P: "Lacak status" (→ S20), "Kembali ke beranda" (→ S05). The wireframe's "Sen, 29 Sep" becomes **"Sel, 29 Sep 2026"** (29 Sep 2026 is a Tuesday) and "Total Rp385.200 (bayar di bengkel)" becomes "Total estimasi · Bayar di bengkel · Rp385.200" (every price is an estimate).
- **PRD 04 S18 split mode:** each unit row gains its own slot line ("Sel, 29 Sep · 09.00") and the recap Schedule row reads "Sel, 29 Sep 2026 · jam berbeda tiap motor". Shared mode shows the slot only in the recap. Unit rows: motor name, "Unit -A · service summary" (max 2 lines, ellipsis), `UnitStatusBadge`; no plate.
- **PRD 04 S18 states:** loading = real header + skeleton ticket ("Membuat tiket…", "Lacak status" disabled), populated; the QR encodes the booking code only and stays dark-on-light in dark mode.
- **PRD 06 S18 row:** phone / Tablet-P = centered ticket (max 560) with a flat sticky CTA bar; Expanded (1024) and Large (1280) = ticket 480 + status panel 400 side by side (904, centered), the CTAs sit under the panel; the panel rows are read-only (S20 owns unit navigation).
- **PRD 07 (`qr_flutter`):** keep a ≥ 126 dp code with a 4-module quiet zone on a white tile in both themes; the design PNG carries a real, decodable QR for `TS-260929-0417`.
- **PRD 04 P2 extras:** "Bagikan tiket" and "Tambah ke kalender" sit in a compact button row under the ticket (P2 variant only); OS share sheet + calendar intent.
- **Demo content:** 5-unit specimen `TS-261002-0418` (Jum, 2 Okt 2026 · 08.00; a 5-motor shared slot needs an empty hour) with `-D` Supra X 125 and `-E` Ninja 250 for the 360×640 stress frame only.
- **`prd/02` inventory:** add `SuccessHeader`, `QrCode`, `TicketActions`, `ShareTicketRow` (P2); `TicketCard` gains a copy button, the real QR and a loading state; `TicketUnitRow` gains a slot line; `TicketCard Units Panel` (the Tablet-L status list) and its loading state.

### PRD corrections collected in step 12 (2026-09-24; apply in this step after approval)

- **PRD 02 type table:** `Label Small` is **12 / 16, SemiBold, 0.025em** (was 11 / 16); it now equals `Label Medium`, so map Flutter `labelSmall` and `labelMedium` to one `TextStyle` (or drop one role). No text in the product is below 12 sp (the `TsLogo` monogram inside the mark is logo art, exempt). `Foundations / Type` spec text and the badge note were updated in Pencil.
- **PRD 04 S17:** the footer counter reads "Total estimasi Rp385.200 · Hemat …" and the CTA is **"Terapkan"** (replaces "Pakai voucher", which contradicted "Tidak pakai voucher" and the Single Motor state); the promo / banner CTA on S05 keeps "Pakai voucher".
- **PRD 04 stepper / S13 / S15:** step 3 label is sentence case, "Bengkel & jadwal" (caption "Langkah 3 dari 4 · Bengkel & jadwal").
- **PRD 04 S16 slot-invalid copy:** capacity is counted in motors — "Tersisa 2 motor di Sel, 29 Sep · 09.00", never "tempat".
- **PRD 04 S18 loading:** the disabled "Lacak status" reason is "Aktif setelah tiket dibuat".
- **`SlotChip` (PRD 02 inventory):** status icon sits beside the time (`Time Row`), the caption takes the full chip width; captions are "Sisa n motor" / "Penuh" / "Dipilih" / "Tersedia".
- **Type-scale audit note (for step 19 track "Token integrity"):** text-size scan rule = nothing under 12 sp, exempt logo art (`Monogram`); `Foundations / Logo` keeps its 11 px specimen.
- **Left over from step 12 for this audit:** loading-state disabled CTAs without a reason line (S10, S14, S15, S17 Loading), `PromoBanner` CTA weight on S05, chip visual inset (`FilterChipRow`, `VehicleTabRow`), tablet column balance (S14 standalone Tablet-L, S15 Tablet-L, S17 Tablet-P), mid-sentence status capital ("1 motor masih Diperiksa"). The step 05 – 11 PNG folders are not on disk: export the full set here.

### PRD / token items collected in step 13 (2026-09-25; apply in this step after approval)

- **Token `focus-ring` (orange-500) on `accent-soft`:** measured 2.92 : 1 in light (< 3 : 1 non-text minimum). Step 13 uses `text-on-accent-soft` for the `Lewati` ring on the S02 art band; decide here whether the shared token becomes orange-600 (≈ 4.1 : 1 on `accent-soft`) or the ring is set per surface, then re-check every focus specimen from steps 03 – 11 that sits on `accent-soft` (`PromoBanner` CTA, selected chips).
- **PRD 04 S03 / S04:** "Ganti nomor" and resend are text links, built as `AuthLink` (48 dp, zero side padding); S04 shows the masked number on its own line with a "Ganti nomor" link, and a demo-mode line "Kode demo: 123456". Terms microcopy is two lines: "Dengan melanjutkan, kamu setuju dengan / Syarat & Ketentuan dan Kebijakan Privasi." CTA labels are sentence case: "Kirim kode OTP", "Verifikasi", "Lanjut" / "Mulai".
- **PRD 04 S02:** onboarding titles are Headline Small (22) on phone with 1 – 2 line bodies (copy drafted in step 13); "Lewati" is hidden on slide 3.
- **PRD 04 S04 (open):** "Verifikasi" is disabled until 6 digits (kickoff decision 9); `better-accessibility` recommends keeping submit enabled and validating on submit, so confirm the pattern app-wide (S11 / S16 use the same disabled-with-reason pattern).
- **Track "Token integrity":** unnamed nodes in the audit are silhouette internals (`path` / `ellipse`, step 04); the audit scripts need `{resolveInstances:true}` on any frame with a replaced slot (see Pencil facts, step 13).

### PRD / token items collected in step 14 (2026-09-25; apply in this step after approval)

- **PRD 04 S07:** one add action only. The header "+" is the add action while the garage has motors (no FAB, no in-list add card); with an empty garage the "+" is hidden (title-only bar) and the empty-state CTA "Tambah motor" is the only action. In-service motors carry a status badge (icon + text); tapping a card opens S09. Tablet grid = 2 columns (Tab-P, content 720) / 3 columns (Tab-L). Check the *other* add entries for the same double-action rule: S05 garage strip "+" tile beside "Lihat semua", and S10 "Tambah motor lain" card.
- **PRD 04 S08:** states are default, saving (spinner button, fields in the disabled style) and save error (inline banner + "Coba lagi"); "validating" = validate on blur / submit, CTA always enabled (S03 rule). Nickname max 20 characters with a counter (closes the step 06 LOW); plate auto-format `AB 1234 XY` with format and duplicate errors; year optional, 1990–2026; photo optional, silhouette by model category, chooser / permission are annotations. Model picker = bottom sheet (phone) / centered modal 560 (tablet) with brand groups and search. Back on a dirty form opens "Buang perubahan?" ("Lanjut mengisi" primary, "Buang").
- **PRD 04 S09:** "Booking motor ini" is **disabled with a reason** ("Sedang dalam servis") plus a "Lacak servis" link → S20 when the motor is in a booking; "Hapus motor" stays enabled and opens the blocked dialog in that case. New `MotorDetails` card (Merek, Model, Jenis, Kapasitas, Tahun). History = active row + 3 latest past rows + "Lihat semua" → S19 pre-filtered to the motor; empty copy "Belum ada riwayat servis".
- **PRD 06 S09 row:** Tab-L = hero + CTA + delete link in the left column (400), details + history in the right column (640); Tab-P = stacked, max 720, full-scroll capture.
- **PRD 05:** `motor_models.json` = the 15 models listed in step 14 (Honda 6, Yamaha 5, Suzuki 4). **Ninja 250** (S10 sheet-only sport motor) and **Scoopy 110** are demo garage motors: add them to the model list or drop them from the S10 demo. `garage_seed.json` has 3 motors while the S05 / S07 demo shows a 4th (Supra X 125): decide which seed the Flutter demo uses.
- **Inventory additions (for `prd/02`):** `TsAppBar / Type=Title, Actions=Add`, `VehicleSelectCard / Mode=Display` `State=In Service` / `State=Loading`, `MotorPhotoField`, `MotorModelPicker`, `MotorForm`, `MotorPreviewPane`, `MotorHero`, `MotorDetails`, `ServiceHistoryRow`, `HistorySection`, `FormErrorBanner` (already listed in the `00-index.md` inventory table).
- **Left LOW from step 14 to decide here:** history rows 8 dp apart vs the 12 dp garage cards (list-gap rule), tabular figures for the nickname counter, a larger hero silhouette for wide panels, plate helper repeating its placeholder, a loading announcement for skeleton states. Token `focus-ring` on `accent-soft` (step 13) still open.

### PRD / token items collected in step 15 (2026-09-25; apply in this step after approval)

- **PRD 03 / 07 / 04 S12:** S12 is a **full-screen page** pushed over S11 (`/booking/configure/parts`, no shell), not a sheet; the part detail is the sheet / modal. Two modes on one page: select (unit header, "Hanya yang cocok untuk <motor>" toggle default ON, checkboxes, flat "Selesai" bar) and browse (from the S05 "Katalog suku cadang" quick link; no unit context, no cart). Selection is **staged**: "Selesai" commits to the active unit, close / back with changes asks "Buang perubahan?". Add the browse route to PRD 07 (e.g. `/catalog`).
- **PRD 04 S11 / S12 sync:** a part ticked in S12 that is not in the S11 shortlist is appended to the S11 list after "Selesai"; S11's "Lihat semua" opens S12 with the unit's current ticks.
- **PRD 05 `parts.json`:** the 14 mock parts in step 15 (category, brand, grade / volume, price, compat = category + cc range; no per-model ids). `Part.compatibleModelIds[]` can stay unused. Canonical prices: MPX1 Rp58.000, MPX2 Rp70.000, Kampas Rem Rp45.000, Busi NGK Rp28.000, Busi Iridium Rp95.000.
- **Inventory additions (for `prd/02`):** `PartDetailSheet`, `CompatRow`, `SpecRow`, `SelectedPartsBar`, `CategoryChipRow`, `CompatToggleRow`, `PartOptionTile` Loading masters (already listed in the `00-index.md` inventory table).
- **Double-action check (from step 14):** S12 has one commit action ("Selesai"); the detail sheet CTA toggles the same selection, it is not a second commit.

### PRD / token items collected in step 17 (2026-09-25; apply in this step after approval)

- **PRD 04 S23:** "Unduh/Bagikan" (P2) is one variant frame (Paid, app-bar "Bagikan"), not on default frames. "Tandai Lunas" opens a non-destructive confirm dialog ("Simulasi, tidak ada pembayaran sungguhan"); Paid shows a `PaidBanner` + `PaymentStatusTag` (icon + text) and the CTA becomes "Beri Ulasan" (→ "Lihat ulasan" once reviewed).
- **PRD 03 F4 / 04 S20 / S24:** S24 is **hard-gated** — S20 "Beri ulasan" stays visible but disabled with the reason "Tandai lunas di invoice dulu" until the invoice is paid; a notification deep link for a finished booking goes to S23, not S24. S24 shows the per-mechanic section **only when ≥ 2 distinct mechanics** served the booking; rows optional. Submitted = same-screen read-only recap (no navigation), then "Kembali ke detail booking".
- **PRD 06 S24:** Tab-L "submitted-reviews preview" is a **live recap preview** of the user's own review (`ReviewRecap`), not other people's reviews.
- **PRD 05:** the invoice UI shows "Diterbitkan <time>" and the review recap "Dikirim <time>" → `Invoice` needs `issuedAt` (or derive from `Booking.completedAt`) and `Review` needs `createdAt`; `Invoice` reference shown = booking code (no separate invoice number). `Review.mechanicRatings` is keyed by mechanic and only holds the ratings the user gave (unrated = absent).
- **PRD 02 `RatingStars`:** input = whole stars, 5 × 48 dp targets, live word label (Buruk / Kurang / Cukup / Baik / Sangat baik) + "n dari 5", `Semantics` value, arrow keys; display = read-only with half values. In Pencil the star is a token-bound `path` (Material Symbols has no fill axis), so Flutter uses `Icons.star_rounded` / `star_outline_rounded` / `star_half_rounded` at the same tokens (`warning-text` filled, `border-control` outline).
- **Inventory additions (for `prd/02`):** `PaymentStatusTag`, `PaidBanner`, `InvoiceSummaryCard`, `MechanicRatingRow`, `ReviewRecap` (already listed in the `00-index.md` inventory table).
- **Cross-step handoff (step 16 / S20):** Selesai-unpaid = "Lihat invoice" enabled + "Beri ulasan" disabled with the reason; Selesai-paid = "Beri ulasan" enabled; reviewed = "Lihat ulasan"; unit mechanics A / C = Pak Anto, B = Mas Rudi. Step 19 checks S20 / S21 against these.
- **Layout:** the step 17 frames sit in a lane below the component sheets (x ≥ 37,000, y ≥ 22,000); step 19 moves them under the Flows – Phone / Flows – Tablet anchors.
- **PRD 04 S23 / S24 copy:** CTAs are sentence case in the design ("Tandai lunas", "Beri ulasan", "Kirim ulasan", "Kembali ke detail booking"), like S16 / S18; PRD wording "Tandai Lunas" / "Beri Ulasan" is corrected here.
- **Left LOW from step 17 to decide here:** a `rating-star` token instead of borrowing `warning-text` for `RatingStars` (also `WorkshopCard`, `MechanicCard` ★), the comment placeholder that repeats "(opsional)", the doubled "opsional" cue on the mechanic rows, and the status-bar clock 09.41 against the 11.xx story times.

### PRD / token items collected in step 16 (2026-09-25, rescue; apply in this step after approval)

- **PRD 04 S20:** the workshop row in the header is a tappable row (chevron) that opens S14 standalone ("Booking di sini", workshop carried, S13 skipped); there is no "Ubah" link and no workshop change in S20. Unit rows = name + status badge, meta line, chevron (tap → S21). Selesai has two states: **Belum lunas** ("Lihat invoice" enabled, "Beri ulasan" disabled with the reason "Tandai lunas di invoice dulu") and **Lunas** (both enabled); after a review "Beri ulasan" reads "Lihat ulasan" (annotation). Dibatalkan shows "Dibatalkan <tgl>" — the wireframe idea of a refund line is dropped (the product has no deposit; "bayar di bengkel").
- **PRD 04 S19:** tabs are scrolling underline tabs with counts (label + count on one line, 48 dp hit height); the tab counts recompute when S19 is opened pre-filtered by a motor from S09 "Lihat semua" (dismissible motor chip, annotation only).
- **PRD 04 S22:** the reschedule sheet is bottom-anchored on phone and a centered modal 560 on tablet (title row + close, no drag handle); the Batalkan dialog follows `TsDialog` styling (312 phone / 400 tablet) with scope radios ("Seluruh booking · 3 motor" / "Hanya <motor> · Unit -X") and wrapping optional reason chips; the confirm is "Ya, batalkan" (danger), dismiss "Kembali"; dialog body "Pembatalan tidak bisa diurungkan." Slot caption says "Jam 09.00" (UI says "jam", not "slot").
- **PRD 06 S21:** Tab-L = unit header + timeline left, ETA card + mechanic card + Mode Demo shortcut right; **no map** (S21 has no map content, PRD 06 says "mechanic/map card"). Tab-P content max 640; S20 Tab-P max 720; S22 Tab-L reuses the Tab-P modal / dialog sizes (no separate frame).
- **`prd/02` inventory:** add `HistoryTab` / `HistoryTabRow`, `BookingHistoryCard`, `UnitStatusRow`, `CancelScopeChooser`, `DemoModeShortcut`; `StatusTimeline` and `MechanicCard` are the owned PRD 02 components; `WorkshopSummaryRow` gains a chevron slot.
- **Tokens:** no new tokens. Literal `fontWeight` values (`600` / `normal` / `700`) in the first build were bound to `$font-weight-semibold` / `$font-weight-regular`; the audit's token-integrity script should flag any remaining literal weights.
- **Left LOW from step 16 to decide here:** S20 Tab-L left column shorter than the right (208 vs 370 dp), a timeline-shaped skeleton for the S21 loading frame (both loading frames reuse one card skeleton), tabular figures on tab counts / ETA / timeline times (annotated only), and the status-bar clock 09.41 against the 10.20 story moment.
- **Layout:** the step 16 phone rows and tablet rows now sit under the Flows anchors (see the canvas layout in `00-index.md`, "After step 16"); the step 17 frames still live in their own lane (x ≥ 37,000, y ≥ 22,000) and are re-homed here.

## Scope

### Audit tracks

| Track | Method | Pass criterion |
|---|---|---|
| Screen coverage | Script: expected frames (all matrices, PRD 04 states, PRD 06 rows) vs existing names | Zero missing; extras justified |
| Token integrity | Script over the whole document: fills/strokes/effects/gaps/paddings/radius/font size not bound to variables | Zero raw values (documented exceptions only, e.g. QR constants) |
| Component inventory | List reusable components vs PRD 02 (28) + additions; unused components; detached instances | Every PRD component present with listed variants; no unused; zero detached |
| Naming | Script: frame names match `S<id> <Name> / <State> / <Breakpoint>[ · Dark]`; every node named | Zero violations |
| Contrast | Script: resolved text/background pairs in light + dark | Text ≥ 4.5:1, UI ≥ 3:1, or documented decorative |
| Overflow | Clipping script over every root frame | Zero `problems` |
| Stress | Existence and cleanliness of 360×640 and ×1.3 frames for S05, S11, S16, S18 | Present + clean |
| Copy | Text-node scan: `Rp` format, dates, terminology, no lorem/placeholder | Zero violations |
| Continuity | Demo data (motors, plates, codes, totals) across S05/S10/S11/S16/S18/S20/S23 | Identical |
| Tablet | Every screen has PRD 06-conformant tablet frames | Per matrix |
| Dark | Every dark frame required by the rules exists and passes contrast | Per matrix |
| Figma compatibility | Check frames and components against the *Figma-plugin compatibility* rules in [`00-index.md`](00-index.md#figma-plugin-compatibility) (rules from the step 01 spike and the step 04 test import; the step 12 test import was deferred to step 20) | Zero violations |

### `/better-interface` runs (one per feature group — respects the skill's scope-narrowing rule)

| Run | Scope |
|---|---|
| A | Auth: S01–S04 |
| B | Shell + Home: S05, `AppShell`, `NavBar`/`NavRail` |
| C | Garage + Catalog: S07–S09, S12 |
| D | Booking core: S10, S11, S13–S18 (flow-level, complements step 12) |
| E | Tracking + Invoice + Review: S19–S24 |
| F | Notifications + Profile + Demo: S06, S25, S26 |

Each run: ≤ 15 findings, systemic root causes consolidated (token/component fixes outrank single-frame fixes); HIGH/MEDIUM fixed; LOW listed.

### Deliverables

- Audit report (tracks + `/better-interface` runs) in this file.
- PRD edit list applied after user approval (`prd/02` inventory + tokens + Figma dark-mode workaround, `prd/00` decision log; `prd/06` window classes already done in step 01).
- Refreshed `P0 Flow Board`; full-document PNG export set.
- Conversion manifest for step 20: component list with variants, style/variable list, screen list with node ids, plus the html2figma version and import options (Auto Layout on/off) that worked in the step 04 test import (re-tested at the start of step 20, which runs after the app build).

## Checklist

### Build
- [ ] Kickoff questions answered.
- [ ] All audit tracks run; failures fixed in the owning frames (logged against owning steps).
- [ ] Runs A–F done; consolidated findings recorded.
- [ ] PRD edits agreed and applied.
- [ ] Flow board refreshed from current frames.
- [ ] Conversion manifest written.

### Quality (automated, run in `execute`)
- [ ] Every script above re-run after fixes and reports zero violations.
- [ ] `placeholder` flags all cleared document-wide.

### /better-interface
- [ ] Runs A–F reports recorded below; all HIGH fixed; MEDIUM fixed; LOW listed; each verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: audit summary table, PRD diff list, conversion manifest, flow board.
- [ ] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] Full PNG export set to `design/pencil/exports/final/`.
- [ ] Claude session file written.
- [ ] Tracker set to ✅; decision log updated.

## /better-interface report

_Not run yet._ One block per run (A–F), using the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
