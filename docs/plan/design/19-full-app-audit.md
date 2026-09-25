# Step 19 — Full-app audit

| | |
|---|---|
| **Status** | ✅ Approved 2026-09-25 |
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

## Kickoff decisions (2026-09-25)

The two questions below were answered together with the layout, token and scope questions raised at the kickoff interview.

| Question | Answer |
|---|---|
| PRD edits to apply | One diff list grouped by file (`prd/00`, `02`, `03`, `04`, `05`, `06`, `07`) is drafted in this file; the user approves or strikes per group; only then Claude edits `prd/`. |
| Frames to drop / add before conversion | None dropped: **convert everything as built**. Conversion itself is *not* in this step; step 19 only prepares `19-conversion-manifest.md`. |
| Canvas | One band per screen S01 → S26, Phone → Tablet-P → Expanded → Tablet-L, dark beside light (see `00-index.md` Conventions). Row headers get a light panel. |
| Tokens | `focus-ring` light → `orange-600`; new `rating-star`. |
| Submit rule | Text forms validate on submit; count-gated steps may disable only with a visible reason line. S04 stays as built. |
| Audit depth | Full: 12 tracks + `/better-interface` runs A – F. |
| Old LOWs | Fix systemic / token-owned ones once; list single-frame ones. |
| Export | None this step. |

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

### PRD / token items collected in step 18 (2026-09-25 kickoff; apply in this step after approval)

- **PRD 04 S26:** the auto-advance control is a **segmented control "Mati / 15 dtk / 5 dtk"** (default 15 dtk), not a slider — `TsSlider` is not built and is removed from the step 18 inventory. Per-booking controls become **per-unit rows** (-A / -B / -C, "Majukan" + "Reset", "Majukan" disabled at Selesai) plus booking-level "Majukan semua" / "Reset semua". "Simulasikan galat jaringan" is **one-shot and auto-disarms** after one failed write (armed banner on S26 only). "Reset semua data" restores the PRD 05 seed (garage, bookings, draft, notification read-state, invoices, reviews); session, theme and demo settings are kept; snackbar "Data demo dikembalikan", then Home.
- **PRD 04 S06:** a **promo** notification opens **S10 with the voucher carried** (step 10 made S17 reachable only from S16), not "S17 or Home"; a **reminder** opens S10 with the motor preselected; unit status → S21 of that unit; booking confirmation → S20; invoice ready → S23. Unread = dot + semibold title + hidden "Belum dibaca" label; "Tandai semua dibaca" in the app bar. S06 is a pushed page (no `NavBar` / `NavRail`).
- **PRD 04 S25:** Notifikasi = one master switch ("Status servis, promo, dan pengingat"); logout is a **neutral confirm** that clears the session only (garage / bookings / drafts stay on the device, PRD 05 local persistence) — the "danger-styled confirm" of the PRD 04 global pattern applies only to "Reset semua data"; Tentang = version `1.0.0 (1)` + demo note + "Dibuat oleh Galah" (no credits link). Theme default "Sistem".
- **PRD 06 S25 / S26:** S25 Tab-L "active panel (e.g. theme preview)" = a **"Pratinjau tema"** panel (forced-theme mini app); S26 is a pushed page at every size, Tab-L = controls left + live `StatusTimeline` of the selected unit right.
- **`prd/02` inventory:** `NotificationTile` (owned), `TsSegmentedControl`, `SettingsRow` / `SettingsGroup`, `UserCard`, `ThemeSetting`, `ThemePreview`, `DemoPanel`, `DemoUnitRow`, `ErrorSimBanner`, `AboutContent`; `TsSlider` is dropped; `TsButton / Outline, Compact, Disabled` amends step 03.
- **Cross-step:** S21 `DemoModeShortcut` mirrors the S26 unit controls (same `TrackingSimulator`); the S05 bell badge and the S06 unread count must agree (2 in the S05 populated moment).
- **Layout:** the step 18 frames sit in a lane below the Step 17 lane (x 37,000, y 36,000 – 56,904); step 19 re-homes both lanes under the Flows anchors.
- **Built deviations to write into PRD 04 (accepted at the review gate):** S06 "Tandai semua dibaca" is a list-header action (first group), not an app-bar action; S06 text wraps with no line clamp; S26 keeps the "MODE DEMO" label on every panel and the caption once; the S26 status controls stack into a column at large text scale (`Wrap`).
- **Left LOW from step 18 to decide here:** "Reset semua" next to "Reset semua data" on S26 (label widths block "Reset semua unit" at 296 dp), the repeated "Simulasi galat" wording (drop the panel helper), cancel wording "Batal" (S25 / S26) vs "Kembali" (S22 / S23), "MODE DEMO" stored in capitals (`DemoModeShortcut` too) plus tabular figures for times and speeds, and the nested radius of `DemoPanel` (16) around 12 dp cards.
- **Not verified in step 18, carry to step 20:** html2figma import of the forced-theme `ThemePreview` stages (frame-level `theme` inside a dark frame).

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

## Audit report (2026-09-25)

**Scope:** 386 screen state frames S01 – S26 (158 + 70 phone light / dark, 56 + 25 Tablet-P, 4 Expanded, 48 + 25 Tablet-L), 59 component sheets, 14 foundations boards, Cover, Demo Content, `P0 Flow Board`, 5 handoff frames, 134 handoff notes. Method: visitor scans per screen group with `{resolveInstances: true}` (whole-document visitors throw), each scan in its own `execute` call, separate from every edit; node ids in the *Fixes applied* table.

| # | Track | Evidence | Result |
|---|---|---|---|
| 1 | Screen coverage | 386 frames vs the step matrices (S05 17 · S10 24 · S11 41 · S13 / S14 36 · S15 27 · S16 / S17 39 · S18 18 · S01 – S04 33 · S07 – S09 33 · S12 17 · S19 – S22 43 · S23 / S24 27 · S06 / S25 / S26 31 = 386); every frame parses as `S## Name / State / Breakpoint[ · Dark]` | **0 missing.** Deviations from the PRD rule "P0 phone states get a dark twin", all approved in earlier matrices (step 12 gate: "no dark copies requested for the 7 states the step matrices skipped"): S14 Closed / Chosen, S15 D+0 Lewat / Split All Complete / Split Sibling Conflict, S18 Copied Code Snackbar / P2 Share + Calendar; S22 Tablet-P Sheet / Dialog have no dark; the 4 Expanded frames are light only; S22 has no Tablet-L (reuses the Tab-P modal sizes) |
| 2 | Token integrity | Plain `Get` over 18,511 owned nodes + resolved screens | Raw hex **0**. Literal `fontWeight` **139 → 0** (`normal` / `600` / `800` bound to `$font-weight-*`: 39 in the Invoice & Review masters, 46 in `98 Demo Content`, 34 in `P0 Flow Board`, 2 in `SectionHeader`, 18 in S24 frames). **Open:** literal spacing / radius / type numbers that equal the scale but are not variable-bound (sheets: gap 3,144 · padding 1,106 · cornerRadius 325 · fontSize 101 · lineHeight 86; S01 – S10 frames: gap 984 · padding 817 · cornerRadius 8; S11 – S26 not counted, same order). `width` / `height` cannot bind a variable in Pencil. Recorded as a file convention; decision at the review gate (see LOW list) |
| 3 | Component inventory | 487 masters in 150 families (+ the canvas `SectionHeader`); JSON closure from every screen | **0 dangling refs, 0 detached.** All 29 PRD 02 components present with their variants. 396 masters reachable from screens; **91 unreachable**: 12 `Type / …` roles, `TsLogo Mark 24`, 28 library-control states (Disabled / Loading of `TsButton`, `TsIconButton`, `TsCheckbox`, `TsRadio`, `TsSwitch`, `TsChip`, `TsSegmentedControl`, `TsSnackbar` Error / Info, `TsDialog` Info / Choice, `ServiceOptionTile` radio + disabled, `TsTextField` Filled, `TsAppBar` Large), 6 step-04 `PriceBreakdown` Summary / Pane and `PriceBreakdown Unit` Collapsed / Expanded variants superseded in step 10, 44 other single-state variants (e.g. `PromoBanner / Service reminder`, `ActiveBookingCard / AllDone`, `MechanicCard / Not Assigned`, `VehicleTabRow`, `ThemePreview` Light / Dark). Kept as library variants; prune list in the LOW list |
| 4 | Naming | Root names, unnamed nodes, duplicates, `TMP`, placeholders | 386 of 386 names match; 0 duplicate root names; 0 unnamed roots; **0** unnamed non-art nodes (18,511); 0 `TMP` roots; `placeholder` flags **0** document-wide |
| 5 | Contrast | 386 frames, **17,013** text + icon pairs (composite of ancestors' resolved fills outside in, WCAG ratio; skips disabled / skeleton / glass / scrim / gradient / logo monogram) | **0 failures**, light and dark. `focus-ring` light now `orange-600`: 4.10 : 1 on `accent-soft`, 4.83 : 1 on white (was 2.92 : 1); dark unchanged (`orange-400`) |
| 6 | Overflow | `c.problems` over every frame (exempt: `Decor …`, `(scroll)` viewports, `DateStrip`, `Tabs Track`, `CategoryChipRow`, 800 dp crops of a `Scroll Body`, `Mini` previews) | **1 real found and fixed** (S16 ×1.3 `VoucherRow`), 0 left; controls below 48 dp: **0** in 245 light frames (575 control instances); text < 12 sp: **0** |
| 7 | Stress | Presence + cleanliness | S05 (360×640 + ×1.3), S11 (360×640, ×1.3, Tab-L ×1.3, Long Content ×2), S16 (2), S18 (2) present; S06, S10, S13, S14, S15, S25, S26 have ×1.3 too; all clean |
| 8 | Copy | 12,771 visible strings: `Rp` format, English months / weekdays, colon times, "slot" / "tempat", English UI words, lorem, double / edge spaces, mid-sentence status capitals | **1 real** ("1 motor masih Diperiksa", master + 8 instances, fixed); "Kirim ulang kode dalam 0:30" accepted (m:ss countdown) |
| 9 | Continuity | Codes, plates, dates, totals across S05 – S26 | `TS-260929-0417` on S05 / S06 / S09 / S18 / S19 / S20 / S22 / S23; plates AB 1234 XY, AB 5678 ZZ, AB 9012 QR, AB 3344 KL (+ S10 extras AB 7788 MN, AB 2468 TP); Rp428.000 − Hemat Rp42.800 = Rp385.200 on S16 / S17 / S18 / S23; every weekday checked (29 Sep 2026 = Selasa, 6 Okt = Selasa, 10 Sep = Kamis, 2 Mei = Sabtu); S05 bell badge 2 = S06 unread dots 2. **0 mismatches** |
| 10 | Tablet | Frame widths and heights vs PRD 06 sizes | Widths 386 / 386 exact (800 / 1280 / 1024). Heights standard except 11 full-scroll captures accepted at their gates: S05 Tab-L ×3 (981 / 910), S06 Tab-L ×2 (1,060), S26 Tab-L ×2 (1,018), S09 Tab-P ×2 (1,364), S26 Tab-P ×2 (1,322) |
| 11 | Dark | 120 dark frames | Present per matrices (see track 1); contrast covered by track 5 |
| 12 | Figma compatibility | Rules from `00-index.md` → Figma-plugin compatibility | Frame / rectangle strokes not `inner`: **41 fixed** (25 nodes in `00 Cover`, `98 Demo Content` and the Invoice & Review masters + 16 focus-specimen refs); the remaining non-inner strokes are `path` / `ellipse` art (77, exported as SVG). `background_blur` 46 uses, all `$glass-blur` (28). 251 `note` nodes dropped by the export (recreate in step 20). 12 nested per-frame `theme` frames (S25 `ThemePreview`) flagged for the step 20 spike |

## Fixes applied in step 19

| # | Sev. | Where | Before → after | Node ids |
|---|---|---|---|---|
| F1 | HIGH (user-reported) | 107 row headers + 5 anchors | No fill; `text-heading` / `text-body` dark on the dark canvas → `surface-card` panel, stroke `border-subtle`, radius-lg, padding 20; 3 Fold Markers get a pill fill | `kcsFb`, `Q0HTt`, `N7rSt7`, `iNfzI` |
| F2 | MEDIUM | S06 `All Read / Phone` | Sat at (38320, 0) outside its row → in the S06 phone cluster | `WiPuS` |
| F3 | MEDIUM | S16 Stress ×1.3 | `VoucherRow` "Hemat Rp42.800" (146 dp) overflowed its 124 dp column by 22 dp → `Saving Row` `fill_container`, `Saving Label` fixed-width fill (wraps); 0 clip rows in 29 S16 frames | `mNtYC` › `h2NaUC`, `X5cYy`; frame `x8mnIG` |
| F4 | MEDIUM | Loading frames S10 / S14 / S15 / S17 (14) | Disabled CTA under skeletons said nothing → reason line "Memuat daftar motor…", "Memuat detail bengkel…", "Memuat jam yang tersedia…", "Memuat voucher…" (existing `Reason Row` / `Helper Row` enabled); 0 clip rows | `PI4VN NKFpW m4Zdo jbxqb · Tvg5J Qs5pN XfOX4 qRLMi · N1qwZb X3a5vr k4EJ5 f03lft · v4HKI ExGUr` |
| F5 | MEDIUM | Token `focus-ring` | Light `orange-500` (2.92 : 1 on `accent-soft`) → `orange-600` (4.10 : 1) | variable |
| F6 | LOW | Token `rating-star` (new) | `RatingStars` / `WorkshopCard` stars borrowed `warning-text` → `rating-star` (light `warning-700`, dark `warning-400`, same values) | 37 nodes: `Star Full` ×31, `Star Half Fill` ×1, `Star Icon` ×5 |
| F7 | MEDIUM | Type weights | 139 literal `fontWeight` (`normal`, `600`, `800`) → `$font-weight-regular / -semibold / -extrabold` | Invoice & Review sheet `f5BFW`, Demo Content `isFgy`, board `abxMC`, S24 frames |
| F8 | MEDIUM | Strokes (Figma) | 41 center-aligned frame / rectangle strokes → `strokeAlignment: "inner"` | Cover, Demo Content, Invoice & Review masters, 16 focus specimens |
| F9 | MEDIUM | Copy, S05 | "1 motor masih Diperiksa" → "1 motor masih diperiksa" | `IZ7z3` (master `Status Caption`; the 8 S05 frame instances follow) |
| F10 | MEDIUM | Copy, S23 | Confirm dialog dismiss "Kembali" → "Batal". Rule: dismiss = **Batal** (S09, S11, S23, S25, S26); **Kembali** only in S22, where the confirm is "Ya, batalkan" and "Batal" would read as the action | `ErVEy/nFZKr/duZFa`, `RfzCv/nFZKr/duZFa` |
| F11 | MEDIUM | Handoff notes | S03, S09, S20, S22, S23, S26 had no motion / reduced-motion fallback note (PRD 02: 150 ms micro, 250 ms route, 300 ms timeline, `MediaQuery.disableAnimations`) → one MOTION note each; S03 and S09 wrappers set to a vertical layout so the note does not push into the dark cluster | `XUTEw f6dxl9 e8isll pebCU YPW51 ZKVyd` in `Dfuw0 hJcRT r5Ran EDpGd MiFp5 NbLBw` |
| F12 | — | `P0 Flow Board` | Nine copies re-cloned from the current default phone frames (names, positions, arrows unchanged) | `G18egA lA7uo gMEry U5uqY yvinO php0V emmZZ zWjwp ITVT5` |
| F13 | — | Canvas | One band per screen S01 → S26; anchors `Section / 03 Flows`, `04 Flows – Tablet` deleted | see `00-index.md` |
| F14 | MEDIUM | S04 (L1, decided at the gate) | "Verifikasi" disabled with no reason line → `Reason Row` "Masukkan 6 digit kode" (info icon + text, body-sm, the `SelectionFooter` recipe) under the CTA in the 8 disabled frames; the Keyboard Open frame keeps the enabled CTA and no line; note `o4r4uZ` updated; 0 clip rows | `d1pAY ILTmz c3GxI W170L WgwZI apwwn ugBDZ pCN7g` in `eqOOG S7V0Is y0KkFC DfhzE Ks5vu mKQTP Cvg8h pgPvB` (frames `gqLjB ta8Gy x9sXr zZaKK CLxSL sAdKb iPu2Y cZe0T`) |
| F15 | — | PRD | G1 – G7 approved and applied (see *PRD edit list*) | `prd/00` – `prd/07` |

## LOW list (left for you)

| # | Item | Where | Note |
|---|---|---|---|
| L1 | ~~S04 "Verifikasi" is disabled with no reason line~~ | ~~`gqLjB` …~~ | **Resolved at the gate: reason line added (F14).** |
| L2 | `PromoBanner` CTA: two filled compact buttons compete with "Mulai booking" | `SPMO0 Y89Vb fyYZM` (S05) | Proposal: Ghost / text button with chevron in `text-on-accent-soft` (an Outline swap fails 2.24 : 1 on dark `accent-soft`); a design call |
| L3 | Chip visual inset (6 dp inside the hit area) | `FilterChipRow`, `VehicleTabRow` (S11, S13) | Edge alignment |
| L4 | Tablet column balance | S14 standalone Tab-L `xen5e`, S15 Tab-L `BN16k`, S17 Tab-P `epVPY`, S20 Tab-L `JABvg` (208 vs 370 dp) | Whitespace under the shorter column |
| L5 | History rows 8 dp apart vs the 12 dp card-list gap | `HistorySection` `OjRQ6` (S09) | Fix changes S09 frame heights |
| L6 | Plate helper repeats its placeholder | `MotorForm` `i0syzS` `Ff98t` (S08) | Copy |
| L7 | S09 Tab-L hero silhouette small for the wide panel | `V4fBI` | Polish |
| L8 | S24: comment placeholder repeats "(opsional)", doubled "opsional" cue on mechanic rows | `fTMM0` and siblings | Copy |
| L9 | S26: "Reset semua" beside "Reset semua data"; repeated "Simulasi galat" helper; `MODE DEMO` stored in capitals; `DemoPanel` radius 16 around 12 dp cards | `y2Qno5`, `D1hHS2`, `JGO1B` | Copy + polish, S26 only |
| L10 | Tabular figures on times, counts, speeds, the nickname counter | S08, S19, S21, S26 | Annotation only (`FontFeature.tabularFigures()`); Pencil has no such property |
| L11 | S21 loading uses one card skeleton, not a timeline shape | `o02ex` | Polish |
| L12 | Status-bar clock 09.41 vs the story times (10.20 / 10.30 / 11.xx) | `System / Status Bar` `Q0b9h` | A per-screen override or leave |
| L13 | `Label Small` = `Label Medium` (12 / 16 / 600 / 0.3) | `LveOX`, `LqAAP` | PRD 02: map both to one `TextStyle` |
| L14 | Dark twins missing for real states | see track 1 | Approved in earlier matrices; add only if wanted |
| L15 | Literal spacing / radius / size numbers equal to the token scale but not variable-bound | ~4,600 in sheets, ~1,800 in S01 – S10 alone | Convention or a mechanical binding pass (exact matches only, visual no-op) |
| L16 | 6 superseded step-04 variants unused (`PriceBreakdown` Summary ×3 + Pane, `PriceBreakdown Unit` Collapsed / Expanded) | `XO1E0 siqEw Vi441 ajTlg lbbBu mIoPJ` | Keep as library spec or delete |
| L17 | The OTP resend countdown "0:30" uses a colon | S04 | Accepted (m:ss) |

## PRD edit list (approve per group; nothing in `prd/` changes before you answer)

Each group is one edit pass over one file. Source = the "collected in step N" section above. Mark a group ✅ approve, ✏️ change, or ❌ skip.

| Group | File | Edits | Sources | Approve |
|---|---|---|---|---|
| **G1** | `prd/00-index.md` | Decision log: one row per locked design decision (booking-flow chrome, S11 – S18 rules, auth, garage, catalog, tracking, invoice, notification / profile / demo, Figma route B, Draft + Starter caveat, band canvas, no PNG until asked) | steps 01 – 19 | ✅ applied |
| **G2** | `prd/02-brand-design-system.md` | **Type:** `Label Small` 12 / 16 SemiBold 0.025 em (equal to `Label Medium`; one `TextStyle`), no text < 12 sp (logo monogram exempt) · **Tokens:** add the semantic tokens built beyond the PRD table (list in `19-conversion-manifest.md` §4): `border-control`, `text-on-accent-soft`, `*-text` / `*-soft` status pairs, `accent-fill / -hover / -pressed`, `danger-fill / -pressed`, `text-on-danger`, `surface-inverse` family, `skeleton-*`, `illustration-outline`, `state-pressed`, `scrim`, `bg-page-clear`, `glass-*`, `shadow-*`, **`focus-ring` light `orange-600`**, **`rating-star`**; `text-muted` light = `sand-600` · **Inventory:** the additions in `00-index.md` → Inventory additions (steps 03 – 18: `TsDialog`, `TsSnackbar`, `TsIconButton`, `TsCheckbox`, `TsRadio`, `TsSwitch`, `TsSegmentedControl`, `PageIndicator`, `TicketUnitRow`, `EstimatePane`, `CopySourceSheet`, `UnitHeader`, `ComplaintSection`, `SearchBar`, `FilterChipRow`, `StaticMap`, `WorkshopPhoto`, `WorkshopCtaBar`, `SelectionFooter`, `CapacityBanner`, `UnitSlotSection`, `DateGrid`, `SummaryCard`, `UnitSummaryAccordion`, `VoucherRow`, `ConfirmBar` / `Pane`, `SuccessHeader`, `QrCode`, `TicketActions`, `MotorForm` family, `PartDetailSheet`, `CategoryChipRow`, `HistoryTab`, `BookingHistoryCard`, `UnitStatusRow`, `DemoModeShortcut`, `PaymentStatusTag`, `PaidBanner`, `InvoiceSummaryCard`, `MechanicRatingRow`, `ReviewRecap`, `SettingsRow`, `UserCard`, `ThemePreview`, `DemoPanel`, …); `TsSlider` dropped; `VehicleTabChip` gains Active + Complete / Incomplete / Error; `TicketCard` gains copy button, real QR, loading state; `WorkshopCard` gains estimate row + "Dipilih" tag; `CapacityBanner` second action; `RatingStars` whole-star input, star = token-bound path (Flutter `Icons.star_rounded` family) · **Icons / imagery:** Material Symbols Rounded (no fill axis: selected = weight 700 + accent), illustration approach (component vignettes for onboarding, 8 of ≈ 11 generated SVG budget) · **Figma doc spec:** route B (html-css → html2figma), Draft file, two collections `Semantic Light` / `Semantic Dark` when the plan lacks modes, notes recreated by hand | steps 02 – 18 | ✅ applied |
| **G3** | `prd/03-user-flows.md` | Exit rule (dialog only with ≥ 1 selected motor; "Simpan & keluar" / "Lanjutkan booking"; discarding a draft = "Hapus draft"); back keeps the draft, close = exit dialog · split validation counts sibling picks; chip precedence `short` > `limited` > `available`; D+0 slots < now + 2 h disabled "Lewat"; mode toggle non-destructive; date change clears the shared slot · makespan for a shared slot, per-unit duration in split · every price is "estimasi" · slot-race banner with "Pisah jadwal" / "Pilih jam lain" · voucher rules: S17 only from S16, promo / notification CTAs start a booking with the voucher carried, ineligible sorted with the exact reason, no code field · workshop closed now stays bookable · standalone S14 "Booking di sini" → S10 · S24 hard-gated behind paid, per-mechanic section only for ≥ 2 mechanics · cancel scope (whole booking / one unit) and non-destructive dismiss · **submit rule** (text forms validate on submit; count-gated steps disable only with a visible reason) | steps 06 – 18 | ✅ applied |
| **G4** | `prd/04-screens.md` | S01 – S04 (onboarding titles, "Kode demo: 123456", "Ganti nomor", terms microcopy, CTA case) · S05 (status label rule, draft card, garage strip, tablet app bar, sentence case, 4th demo motor, promo carousel dots, "Lanjutkan" = Secondary) · S06 (deep links, unread cues, "Tandai semua dibaca" in the first group header, no line clamp) · S07 (single add action) · S08 (states, validation, picker, dirty dialog) · S09 (disabled "Booking motor ini" + "Lacak servis", `MotorDetails`, history) · S10 (copy, footer counter + reasons, add card) · S11 (Keluhan, "Salin dari", remove dialog, live estimate, "Lanjut" disabled with reason) · S12 (full page, staged selection, compat toggle) · S13 / S14 (estimate row, filters, two S14 variants) · S15 (workshop row, capacity banner, footer recap, all-full copy) · S16 (two-row card, static per-unit lines, "Konfirmasi booking", error banner) · S17 (full page, "Terapkan") · S18 (no app bar, code once, real QR, split rows, P2 extras) · S19 – S22 (tabs, workshop row → S14, Lunas / Belum lunas, sheet + dialog) · S23 / S24 (confirm dialog, `PaidBanner`, whole-star input, recap) · S25 (neutral logout confirm, "Pratinjau tema", About) · S26 (segmented speed, per-unit rows, one-shot error, reset scope) · stepper label "Bengkel & jadwal" · Global patterns (`TsDialog`, `TsSnackbar`, dismiss = "Batal") | steps 05 – 18 | ✅ applied |
| **G5** | `prd/05-data-model-mock.md` | `services.json` 3 services (Servis Berkala Rp85.000 · 60 mnt, Ganti Oli Rp35.000 · 30 mnt, Perbaikan / Keluhan Rp50.000 · 60 mnt) · `workshops.json` 5 entries (bays 2 / 3 / 2 / 1 / 2, hours, Cahaya closed now) + `reviewCount`, structured `openHours` · `TimeSlot` capacity 5 motors / hour, `getAvailableSlots` returns booked + capacity, D+0 cutoff computed · `vouchers.json` 4 (+ `validUntil`, min units / subtotal) · `parts.json` 14 · `motor_models.json` 15 + Ninja 250 / Scoopy 110 (or drop from the S10 demo) · **decide:** garage seed 3 or 4 motors (Supra X 125) · `Invoice.issuedAt`, `Review.createdAt`, `Review.mechanicRatings` by mechanic · booking code `TS-YYMMDD-NNNN`, 5-unit specimen `TS-261002-0418` · reset scope keeps session, theme, demo settings | steps 08 – 18 | ✅ applied |
| **G6** | `prd/06-responsive-layout.md` | Booking flow S10 – S18 has no `NavBar` / `NavRail`; tablet frames are fixed viewports · rows for S09, S10 (3-col grid), S11 (medium / expanded / large + `EstimatePane`), S13 (list + pane 1024 / 1280), S15 (2-week grid), S16 / S17 (recap + pane), S18 (ticket 480 + panel 400), S21 (no map), S24 (live recap preview), S25 / S26 Tab-L | steps 06 – 18 | ✅ applied |
| **G7** | `prd/07-architecture-tech.md` | Routes `/booking/configure/parts` (S12 full page), `/catalog` (browse), `/booking/summary/voucher` · `qr_flutter` ≥ 126 dp with a 4-module quiet zone on a white tile in both themes · `TrackingSimulator` shared by S21 / S26 · `TsSlider` removed | steps 11, 15, 18 | ✅ applied |

**Approval (2026-09-25, "approve"):** all seven groups approved and applied. Open questions answered at the gate: **garage seed = 4 motors** (Vario, Beat, PCX + Supra X 125); **Ninja 250 is added to `motor_models.json`** (Kawasaki, sport 250 cc → 16 models; Scoopy 110 was already in the 15-model list); **S04 gets the reason line** (F14); **spacing / radius / size literals stay a file convention** (L15, no binding pass).

Edited files: `prd/00-index.md` (decision-log table for the design phase), `prd/02-brand-design-system.md` (semantic tokens `accent-fill`, `scrim`, `rating-star`, `focus-ring` light `orange-600`, glass / shadow token pointer; Label Small 12; icons and illustrations; inventory rows amended + *Additions built during design* table; Figma spec Starter / route B), `prd/03-user-flows.md` (F1 – F6, business rules, forms and gates, edge cases), `prd/04-screens.md` (rewritten to the approved S01 – S26 design), `prd/05-data-model-mock.md` (entities, mock files, reset / error injection), `prd/06-responsive-layout.md` (per-screen table, booking-flow chrome, stress frames), `prd/07-architecture-tech.md` (routes `/booking/configure/parts`, `/catalog`, `/workshops/:id`, QR, icons, tests).

## Checklist

### Build
- [x] Kickoff questions answered.
- [x] All audit tracks run; failures fixed in the owning frames (logged in *Fixes applied*; F3 / F4 / F9 / F10 / F11 touch frames owned by steps 10, 08 – 10, 05, 17, 13 – 18).
- [x] Runs A–F done; consolidated findings recorded.
- [x] PRD edits agreed and applied (G1 – G7, all approved 2026-09-25).
- [x] Flow board refreshed from current frames (`abxMC`, 9 copies re-cloned).
- [x] Conversion manifest written (`19-conversion-manifest.md`, prepared only, nothing exported).

### Quality (automated, run in `execute`)
- [x] Every script above reports zero violations after the fixes (re-run after F3 / F4: S16 and the 14 loading frames; F5 – F8 / F11 are value- or annotation-neutral; sheets: 0 real clip rows, 40 scroll-specimen rows exempt).
- [x] `placeholder` flags all cleared document-wide (0 roots, 0 nested).

### /better-interface
- [x] Runs A–F reports recorded below; all HIGH fixed; MEDIUM fixed (L1 closed by F14); LOW listed; each verdict `Approve`.

### Review gate
- [x] Status set to 🔵; user shown: audit summary table, PRD diff list, conversion manifest, flow board (`abxMC`), the new band canvas.
- [x] Review rounds logged; user approval recorded (2026-09-25, "approve").

### Close (only after approval)
- [x] ~~Full PNG export set to `design/pencil/exports/final/`~~ **Skipped by decision** ("no need export, i will command if i need the png").
- [x] Claude session file written (`docs/claude-session/21-design-step19-full-app-audit.md`).
- [x] Tracker set to ✅; decision log updated.

## /better-interface report

_Run 2026-09-25 with all six owning skills loaded (`better-accessibility`, `-layout`, `-writing`, `-typography`, `-colors`, `-ui`); no domain is `Not reviewed`. The skills are web-oriented, so the Pencil mapping in `00-index.md` applies: **frame name + node id** stand in for `file:line`, "Before / After" describe the design node, and every browser-only check (keyboard walk, screen-reader, 200 % zoom, forced colors, RTL, replay at 10 % speed) is **Not verified** because the artifact is a static design; the handoff notes carrying the Flutter `Semantics`, focus and motion contracts were read instead. Each run reads the whole scope through the scripted tracks in the *Audit report* (all 386 frames) plus screenshots of the default frames; screenshots of tall frames are downscaled, so fine detail was judged from node data, not pixels. Systemic findings are reported once, in the run that owns the master:_

- **Cross-cutting, fixed:** F1 header panel, F5 `focus-ring`, F7 literal weights, F8 stroke alignment (see *Fixes applied*).

### Run A — Auth: S01 – S04

**Scope:** S01 Splash, S02 Onboarding, S03 Login, S04 OTP — 33 state frames (`P5DUXb`, `ilTGn`, `LZNrv`, `BRBz9`, `pXqfD`, `gqLjB`, `ta8Gy`, `x9sXr`, … ids in `19-conversion-manifest.md`) + 9 handoff notes · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens · **Convention docs found:** 00-index.md, prd/02, prd/04, prd/06, 13-auth-s01-s04.md

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | 1,135 contrast pairs (0 fail); controls ≥ 48 dp; error cues (border + icon + text) on `pXqfD`, `ta8Gy`; disabled CTA on `gqLjB`; focus-order, semantics and reduced-motion notes | 1 MEDIUM (left), 1 MEDIUM (fixed) |
| Layout | Screenshots `LZNrv`, `BRBz9`, `pXqfD`, `gqLjB`, `ta8Gy`; clipping over 37 frames incl. keyboard-open frames and Tab-P `AuthCard` / Tab-L `AuthHero` | Clear |
| Writing | Copy scan (0 hits); "kamu" voice; sentence-case CTAs; the error names its fix ("Contoh: 812-3456-7890", "Kode salah. Cek lagi 6 digitnya atau kirim ulang kode.") | Clear |
| Typography | 0 text < 12 sp; 0 literal weights; title / body roles per PRD 02 | Clear |
| Color | 0 contrast failures light + dark; `Lewati` on `accent-soft` uses `text-on-accent-soft` | Clear |
| UI | OtpInput states (focused / filled / error / loading), splash mark-only + wordmark end state, onboarding vignettes theme-aware | Clear |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| MEDIUM | Accessibility | S04 `gqLjB` `ta8Gy` `x9sXr` `BHzEN`, dark `zZaKK`, Tab-P `CLxSL` `sAdKb`, Tab-L `iPu2Y` `cZe0T` — CTA "Verifikasi" | Disabled (dimmed) with no reason line | One line under the CTA, e.g. "Masukkan 6 digit kode" (the `SelectionFooter` reason recipe), or amend the submit rule so the visible six-box count gate counts as the reason | A disabled control has to explain itself; the rule locked at this kickoff says "only with a visible reason line". **Left for you (L1)** |
| MEDIUM | Accessibility | S03 handoff wrapper `Dfuw0` | Motion note missing, no reduced-motion fallback | Note `XUTEw`: 150 ms error / spinner, 250 ms route, `disableAnimations` = instant, state never motion-only | Motion contract for Flutter. **Fixed (F11)** |

*Update at the review gate:* the S04 reason line was added (F14), so the first MEDIUM is closed.

**Verification:** *Passed* — contrast 0 / 1,135; clipping 0 over 37 frames; raw hex 0; unnamed 0; text < 12 sp 0; 5 screenshots. *Not verified* — keyboard traversal, screen-reader output, forced colors, 200 % zoom (design only).
**Verdict:** Approve
**Fixes applied:** motion note (F11) · **LOW / decision left for you:** L1 (S04 reason line)

### Run B — Shell + Home: S05, `AppShell`, `NavBar`, `NavRail`

**Scope:** S05 Beranda — 17 state frames (`jcjrw`, `cqX7g`, `ALXSJ`, `d6h0h`, `zjTd6`, … in the manifest) + `AppShell` ×12, `NavBar` ×4, `NavRail` ×8, the Home blocks sheet · **Convention docs found:** 00-index.md, prd/02, prd/04 S05, prd/06, 05-s05-home.md

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | Contrast 0 / (S05 in the 1,135 + 3,374 pairs); nav item hit areas ≥ 48; bell badge "2" has text; notes (6, semantics + carousel rules). The carousel auto-advances every 5 s and stops on touch / focus / hover / reduce-motion; a visible pause control was proposed at step 05 and **declined by you** (unchanged) | Clear (declined item recorded) |
| Layout | Screenshots of 5 frames (phone light / dark / empty, Tab-P, Tab-L); clipping 0 (only scroll strips `Garage Strip (scroll)`, `Promo Viewport (scroll)` and `Decor` circles, exempt); Tab-L 1280×981 / 910 are full-scroll captures | 1 LOW |
| Writing | Sentence case, `Rp` / dates, status vocabulary; "masih Diperiksa" fixed | 1 MEDIUM (fixed) |
| Typography | 0 < 12 sp; role table | Clear |
| Color | Static icon tiles neutral (step 12); `PromoBanner` fills | 1 LOW |
| UI | Nav rail / bar states, garage strip cards, concentric radii on `ActiveBookingCard` | Clear |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| MEDIUM | Writing | S05 `Status Caption` `IZ7z3` (all S05 frames) | "1 motor masih Diperiksa" | "1 motor masih diperiksa" (the badge keeps the capital) | Status names are badges in capitals, sentence case inside a sentence. **Fixed (F9)** |
| LOW | Color | `PromoBanner` `SPMO0` `Y89Vb` `fyYZM` (S05 promo) | Two filled compact Primary buttons beside the "Mulai booking" CTA | Ghost / text button with chevron in `text-on-accent-soft` | One filled action per view (an Outline swap fails 2.24 : 1 on dark `accent-soft`). **Left for you (L2)** |

**Verification:** *Passed* — contrast 0 fails; clipping 0 real; 5 screenshots. *Not verified* — keyboard, screen reader, carousel timing (annotation only).
**Verdict:** Approve
**Fixes applied:** F9 · **LOW left for you:** L2, Tab-L full-scroll captures (track 10)

### Run C — Garage + Catalog: S07, S08, S09, S12

**Scope:** 50 state frames (S07 10, S08 14, S09 9, S12 17; e.g. `TaiEw`, `jtZ2L`, `O0lY6`, `ryN4e`, `W6RfBX` in the manifest) + notes · **Convention docs found:** 00-index.md, prd/04, prd/06, 14-garage-s07-s09.md, 15-catalog-s12.md

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | Contrast 0 fails; one add action per screen (header "+", hidden when the garage is empty); delete confirm + blocked dialogs; disabled "Booking motor ini" carries a reason line and "Lacak servis"; dirty-form dialogs non-destructive | Clear |
| Layout | Screenshots `TaiEw`, `O0lY6`, `ryN4e`, `W6RfBX`; clipping 0 (category chip row and keyboard viewport exempt); Tab-P S09 1,364 dp full scroll | Clear |
| Writing | "Buang perubahan?" / "Lanjut mengisi" / "Lanjut memilih"; compat copy "Cocok" / "Tidak cocok"; plate helper | 1 LOW |
| Typography | 0 < 12 sp; nickname counter width | 1 LOW |
| Color | Status badges icon + text; compat rows ✓ / ✕ + text | Clear |
| UI | Card / grid tiles, sheet vs modal picker, detail sheet | 2 LOW |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| LOW | Layout | `HistorySection` `OjRQ6` (S09 all frames) | History rows 8 dp apart | 12 dp like the garage cards | One list-gap rule. **Left (L5)** |
| LOW | Writing | `MotorForm` `i0syzS` `Ff98t` (S08) | Plate helper repeats the placeholder | A helper that adds information (format rule) | Placeholders are examples, helpers add. **Left (L6)** |
| LOW | UI | S09 Tab-L `V4fBI` | Hero silhouette small in the wide panel | Larger hero for wide panels | Polish. **Left (L7)** |
| LOW | Typography | Nickname counter (S08), all `MotorForm` | Digits in the counter shift as they change | `FontFeature.tabularFigures()` (handoff note) | Changing values need tabular figures. **Left (L10)** |

**Verification:** *Passed* — contrast 0 fails; clipping 0 real; raw hex 0; 4 screenshots. *Not verified* — keyboard / screen reader, photo chooser permissions (annotation only).
**Verdict:** Approve
**Fixes applied:** none needed · **LOW left for you:** L5, L6, L7, L10

### Run D — Booking core: S10, S11, S13 – S18

**Scope:** 185 state frames (S10 24, S11 41, S13 20, S14 16, S15 27, S16 29, S17 10, S18 18) + `P0 Flow Board` `abxMC` (refreshed) · **Convention docs found:** 00-index.md, prd/03 F2, prd/04, prd/06, steps 06 – 12

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | Contrast 0 / ~13,000 pairs; controls ≥ 48 dp (575 instances); every gate has a reason line (Lanjut, Terapkan, Konfirmasi booking, Lacak status); loading footers now too; destructive / exit dialogs non-destructive; slot chips icon + text + caption | 1 MEDIUM (fixed) |
| Layout | Screenshots `s0LoP5`, `tL4G5`, `OTfUk`, `a2akK`, `f84RVz` + 4 loading frames; ×1.3 and 360×640 stress frames of S05 / S10 / S11 / S13 / S14 / S15 / S16 / S18; clipping 0 real after the fix | 1 MEDIUM (fixed), 2 LOW |
| Writing | Stepper vocabulary "Langkah n dari 4 · …", "Estimasi" on every price, sentence case, "jam" not "slot" | Clear |
| Typography | ×1.3 stress: 0 overflow left; 0 < 12 sp | Clear |
| Color | Semantic tints + `*-text` pairs; 0 failures light + dark | Clear |
| UI | Glass bar only on S11, flat bars elsewhere; one filled action per view; icon tiles neutral | Clear |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| MEDIUM | Layout | S16 Stress Text ×1.3 `x8mnIG` › `VoucherRow` `x3z4i` (master `mNtYC`) | "✓ Hemat Rp42.800" (146 dp, hug) overflowed its 124 dp column by 22 dp, close to the "Hapus" link | `Saving Row` `fill_container`, `Saving Label` fixed-width fill so it wraps | Text containers must not have a fixed width; large text otherwise collides. **Fixed (F3)** |
| MEDIUM | Accessibility | Loading frames S10 `PI4VN` `NKFpW` `m4Zdo` `jbxqb`, S14 `Tvg5J` `Qs5pN` `XfOX4` `qRLMi`, S15 `N1qwZb` `X3a5vr` `k4EJ5` `f03lft`, S17 `v4HKI` `ExGUr` | Disabled CTA under skeletons with no reason | Reason line "Memuat daftar motor…" / "…detail bengkel…" / "…jam yang tersedia…" / "…voucher…" | A disabled control explains itself. **Fixed (F4)** |
| LOW | Layout | `FilterChipRow`, `VehicleTabRow` (S11, S13); S14 standalone Tab-L `xen5e`, S15 Tab-L `BN16k`, S17 Tab-P `epVPY` | Chip visuals 6 dp inside the hit area; columns end 240 – 460 dp apart | Edge alignment; balance | Whitespace under the shorter column. **Left (L3, L4)** |
| LOW | Accessibility | P0 phone states without a dark twin (S14 Closed / Chosen, S15 D+0 / Split All Complete / Split Sibling Conflict, S18 Copied Code Snackbar / P2) | Light only | Dark copies if wanted | Approved in the matrices and at the step 12 gate. **Left (L14)** |

**Verification:** *Passed* — clipping 0 real after F3 / F4; contrast 0 fails; `P0 Flow Board` re-cloned and clip-clean; 9 screenshots. *Not verified* — keyboard traversal of the calendar grid, screen-reader announcements of slot chips (notes read).
**Verdict:** Approve
**Fixes applied:** F3, F4, F12 · **LOW left for you:** L3, L4, L14

### Run E — Tracking + Invoice + Review: S19 – S24

**Scope:** 70 state frames (S19 11, S20 13, S21 10, S22 9, S23 13, S24 14; e.g. `mne8D`, `eaJvo`, `cBMsr`, `N6sbZ`, `fTMM0`) + handoff notes · **Convention docs found:** 00-index.md, prd/03 F4, prd/04, 16-tracking-s19-s22.md, 17-invoice-rating-s23-s24.md

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | Contrast 0 fails; underline tabs 48 dp with a scroll cue; `BookingStatus` never colour-only (badge text + icon); destructive cancel = dialog with scope + reasons; "Beri ulasan" disabled with the reason "Tandai lunas di invoice dulu"; motion notes missing on S20 / S22 / S23 | 1 MEDIUM (fixed) |
| Layout | Screenshots `mne8D`, `eaJvo`, `cBMsr`, `N6sbZ`, `fTMM0`; clipping 0 (tabs track and 800 dp crops exempt); S20 Tab-L columns 208 vs 370 dp | 1 LOW |
| Writing | Dismiss vocabulary: **Batal** everywhere except S22 (**Kembali** beside "Ya, batalkan"); S23 fixed | 1 MEDIUM (fixed), 1 LOW |
| Typography | 139 literal weights bound; 0 < 12 sp | 1 MEDIUM (fixed) |
| Color | Stars borrowed `warning-text`; paid / unpaid tags icon + text | 1 LOW (fixed) |
| UI | Star path recipe (token-bound), `PaidBanner`, focus specimens | Clear |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| MEDIUM | Writing | S23 Confirm Dialog `DPVAo`, `ORLUd` › `ErVEy/nFZKr/duZFa`, `RfzCv/nFZKr/duZFa` | Dismiss "Kembali" (S09 / S11 / S25 / S26 use "Batal") | "Batal" | One vocabulary per action; "Kembali" stays only in S22 where "Batal" would read as the cancel-booking action. **Fixed (F10)** |
| MEDIUM | Accessibility | Handoff wrappers `r5Ran` (S20), `EDpGd` (S22), `MiFp5` (S23) | No motion / reduced-motion note | MOTION notes `e8isll`, `pebCU`, `YPW51` | Motion contract for Flutter. **Fixed (F11)** |
| MEDIUM | Typography | Invoice & Review masters (`InvoiceHeaderCard`, `PaidBanner`, `InvoiceSummaryCard`, `MechanicRatingRow`, `ReviewRecap`, `WorkshopRatingCard`) + S24 frames | Literal `fontWeight: "normal"` on 150 resolved nodes | `$font-weight-regular` | Type weights are a token, literals do not follow a change. **Fixed (F7)** |
| LOW | Color | `RatingStars` `Star Full` / `Star Half Fill`, `WorkshopCard` `Star Icon` | Star colour borrowed `warning-text` | `rating-star` token (same values) | A token is used only in its role. **Fixed (F6)** |
| LOW | Layout / Writing | S20 Tab-L `JABvg`; S21 `o02ex`; S24 `fTMM0` (comment placeholder + mechanic rows repeat "opsional") | Column balance; card skeleton for a timeline; doubled cue | Balance; timeline skeleton; one cue | Polish. **Left (L4, L8, L11)** |

**Verification:** *Passed* — clipping 0 real; contrast 0 fails; 5 screenshots; literal weights 0 after F7. *Not verified* — keyboard, screen reader, timeline pulse (annotation only).
**Verdict:** Approve
**Fixes applied:** F6, F7, F10, F11 · **LOW left for you:** L4, L8, L11, L12

### Run F — Notifications + Profile + Demo: S06, S25, S26

**Scope:** 31 state frames (S06 10, S25 10, S26 11; e.g. `rUjMH`, `bJZYH`, `y2Qno5`) + handoff frames `r8NMpp`, `oGP82`, `NbLBw` · **Convention docs found:** 00-index.md, prd/04, prd/06, 18-notif-profile-demo.md

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | Contrast 0 fails; unread = dot + weight + hidden label; the logout confirm is neutral, "Reset semua data" is the only danger action; error simulation shows an armed banner; S26 had no motion note | 1 MEDIUM (fixed) |
| Layout | Screenshots `rUjMH`, `bJZYH`, `y2Qno5`; ×1.3 frames for all three; the stray `WiPuS` (S06 All Read) sat at y 0 outside its row | 1 MEDIUM (fixed) |
| Writing | "Batal" dismiss; "Reset semua" beside "Reset semua data"; repeated "Simulasi galat" helper | 1 LOW |
| Typography | Times / speeds not tabular (annotation) | 1 LOW |
| Color | Neutral promo / reminder tiles, no status ramps borrowed | Clear |
| UI | `DemoPanel` radius 16 around 12 dp cards; forced-theme `ThemePreview` | 1 LOW |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|
| MEDIUM | Accessibility | Handoff wrapper `NbLBw` (S26) | No motion / reduced-motion note | MOTION note `ZKVyd` (300 ms timeline reveal, 150 ms controls, `disableAnimations` = instant, text labels for speed / armed / Selesai) | Motion contract for Flutter. **Fixed (F11)** |
| MEDIUM | Layout | `S06 Notifikasi / All Read / Phone` `WiPuS` | At (38320, 0), outside the S06 row | Into the S06 phone cluster | A frame off its row is invisible in review. **Fixed (F2)** |
| LOW | Writing / UI | S26 `y2Qno5`, `DemoModeShortcut` `D1hHS2`, `DemoPanel` `JGO1B` | "Reset semua" next to "Reset semua data"; repeated "Simulasi galat"; `MODE DEMO` stored in capitals; radius 16 around 12 dp cards | One reset vocabulary; sentence-case storage + `text-transform`; concentric radius | Consistency. **Left (L9)** |
| LOW | Typography | Times, counts, speeds in S06 / S26 | Proportional digits | `FontFeature.tabularFigures()` (note) | Changing values. **Left (L10)** |

**Verification:** *Passed* — clipping 0 real; contrast 0 fails; 3 screenshots; `WiPuS` position verified (1320, 27569). *Not verified* — keyboard, screen reader, `ThemePreview` per-frame theme in html2figma (step 20).
**Verdict:** Approve
**Fixes applied:** F2, F11 · **LOW left for you:** L9, L10

## Review rounds

#### Round 1 — 2026-09-25
- **Frames shown:** the band canvas (S01 → S26), the header panel, the audit report (12 tracks), fixes F1 – F13, LOW list L1 – L17, the PRD edit list G1 – G7, `19-conversion-manifest.md`, the refreshed `P0 Flow Board` `abxMC`, `/better-interface` runs A – F.
- **User feedback:** "approve" (then, at the four open questions: S04 add the reason line, garage seed 4 motors, add Ninja 250 / Scoopy 110 to the model list, keep spacing literals as a convention).
- **Changes made:** F14 (S04 reason line + note), PRD G1 – G7 applied, L1 closed.
- **Outcome:** approved.

## Session log

| Time | Action | Result / node ids |
|---|---|---|
| 2026-09-25 | Kickoff interview (layout, header, PRD edits, tokens, submit rule, Figma scope, audit depth, LOWs, export) | Answers in *Kickoff decisions* and the `00-index.md` decision log |
| 2026-09-25 | Census of the canvas (read-only) | 629 roots: 431 screens, 107 row headers, 6 anchors, 59 sheets, 14 foundations boards, 5 handoff frames, 3 fold markers; stray `WiPuS` (S06 All Read) at y 0 |
| 2026-09-25 | `SectionHeader` master `kcsFb` → `surface-card` panel (stroke `border-subtle` 1 inner, radius-lg, padding 20); 3 Fold Markers → pill fill | Header heights 146 / 147 / 168 / 190 (was 106 – 150); nested users `EASVU`, `ZJI4c` clean |
| 2026-09-25 | Re-layout: 546 `Update x/y` (107 headers + 439 members), bands S01 → S26 from y 16,500, gaps 480 / 240 / 640 | Canvas end y 77,715 (was 157,000); widest band S11 34,424; ids unchanged |
| 2026-09-25 | Anchors: `Foundations` / `Components` anchors −40 dp (header growth), `OwQde` → `Section / 03 Flows`, `URsZs` (04 Flows – Tablet) deleted | 628 roots; overlap scan = 3 known sheet / dark-copy pairs only |
| 2026-09-25 | Audit tracks 1 – 12 (coverage, token integrity, inventory, naming, contrast, overflow, stress, copy, continuity, tablet, dark, Figma compat) | 386 frames; 17,013 contrast pairs 0 fail; 0 raw hex; 91 spec-only masters, 0 dangling; 1 real overflow, 1 real copy defect |
| 2026-09-25 | Fixes F3 – F11 | S16 `VoucherRow` (`mNtYC`), 14 loading frames (reason lines), `focus-ring` orange-600, `rating-star` (37 nodes), 139 literal weights, 41 strokes inner, "masih diperiksa", S23 "Batal", 6 MOTION notes |
| 2026-09-25 | `P0 Flow Board` refresh + conversion manifest | 9 copies re-cloned (`G18egA … ITVT5`); `19-conversion-manifest.md` (487 masters, 151 variables, 386 frame ids, 251 notes) |
| 2026-09-25 | `/better-interface` runs A – F (six owning skills loaded) | 0 HIGH; MEDIUM fixed except L1; LOW L1 – L17 listed; verdicts Approve |
| 2026-09-25 | PRD diff list drafted (G1 – G7) | Waiting for per-group approval; `prd/` untouched |
| 2026-09-25 | Gate: "approve" + 4 decisions (S04 reason line, seed 4, Ninja 250 into models, literals stay convention) | See *Review rounds* |
| 2026-09-25 | F14: `Reason Row` "Masukkan 6 digit kode" in 8 S04 frames, Keyboard Open frame untouched, note `o4r4uZ` updated | 0 clip rows; overlaps 3 (pre-existing) |
| 2026-09-25 | PRD G1 – G7 applied | `prd/00` – `prd/07`; `prd/04` rewritten; `prd/05` seed 4 motors, 16 models |
| 2026-09-25 | Close | Tracker ✅, decision-log row, session file `21-design-step19-full-app-audit.md`; no PNG export (decided) |
