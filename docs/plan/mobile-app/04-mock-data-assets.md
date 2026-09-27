# Step 04 — Mock data assets

| | |
|---|---|
| **Status** | ✅ Approved |
| **Layer** | Data (content) |
| **Priority** | — |
| **Owns** | `assets/mock/*.json` (11 files) |
| **PRD refs** | [05 mock data files table](../../../prd/05-data-model-mock.md) |
| **Design refs** | [`docs/plan/design/00-index.md` → Canonical demo content](../design/00-index.md) (source of truth for every number/name/date below — supersedes `prd/05` where they disagree) |
| **Depends on** | Step 02 (entities define the shape each JSON file must satisfy) |
| **Claude session** | `docs/claude-session/apps/05-mobile-step04-mock-data-assets.md` (written after approval) |

## Goal

Write the 11 mock JSON assets with rich, realistic content (PRD 08 B3: "varied and realistic, not 1–2 placeholder rows") that exactly matches the numbers the design already locked in — the design plan resolved every PRD inconsistency (S11/S16/S18 price mismatch, the weekday, the garage seed count, the model list), so this step transcribes, it doesn't re-derive.

## Inputs

- `prd/05-data-model-mock.md` → *Mock data files* table (per-file contents, canonical prices/examples).
- `docs/plan/design/00-index.md` → *Canonical demo content* table (the resolved numbers: booking `TS-260929-0417`, 16 motor models, 4-motor garage seed + design-only S10 specimens, 5 workshops with exact ratings/distances/hours, 4 vouchers, 14 parts with prices, demo today/slot capacity numbers, 4 seed bookings).
- Each entity's field list from step 02 (JSON keys must map onto `fromJson`/mapper fields written in steps 06–09).

## Open questions (ask at kickoff)

1. JSON key casing — `snake_case` (matches typical DTO `@JsonKey(name:)` convention) vs. `camelCase` (skip `@JsonKey` entirely)? Recommend `snake_case` to match the data-layer skill's example convention.
   **Answered:** `snake_case` for field names. Enum *values* stay exact Dart spelling (e.g. `"checkIn"`, not `"check_in"`) — confirmed against `.claude/skills/flutter-data-layer/SKILL.md:116`.
2. Are the two S10-only "design specimens" (Ninja 250 `AB 7788 MN` in-service, Scoopy 110 `AB 2468 TP`) included in `garage_seed.json` from the start, or added later through the app's own "add motor" flow during manual QA (per the design note "add them through S08 to reproduce the max-reached state")? Recommend: seed only the 4-motor garage; the 5th/6th are exercised live via S08 during step 13/21 QA, not baked into the seed.
   **Answered:** seed only the 4 motors (Vario 125, Beat 110, PCX 160, Supra X 125). Ninja 250 / Scoopy 110 stay S10-only, added live later.
3. `bookings_seed.json`: the design plan lists 4 seed bookings (2 `selesai`, 1 `dibatalkan`, 1 `terjadwal`) — confirm the active `TS-260929-0417` (the canonical S05–S18 demo) is **not** seeded (created live by running the booking flow), matching the design note.
   **Answered:** confirmed not seeded; created live via S10→S18.
4. **(raised during build)** `Mechanic` entity has no `workshopId` field — how should `mechanics.json` represent "distributed across workshops"?
   **Answered:** flat list, no workshop link. Mechanic↔workshop association only happens via `BookingUnit.mechanicId` at booking time.
5. **(raised during build)** Jaya's canonical service list ("Servis Berkala, Ganti Oli, Perbaikan/Keluhan, Ganti Ban, Tune-Up") and the cancelled seed booking's "Ganti Ban" reference services that don't exist in the 3-service `services.json` scope.
   **Answered:** substitute with existing services. All 5 workshops reference the same 3 real `service_ids`; the cancelled booking (`bk_seed_003`) uses `svc_oli` instead of the nonexistent Ganti Ban.
6. **(raised during build)** Notification `deep_link` field — no router exists yet (step 10 builds `go_router`). What scheme for the 9 seed notifications?
   **Answered:** simple placeholder path now (`/tracking/{bookingId}/{unitCode}`, `/booking/{id}`, `/invoice/{bookingId}`, `/booking/select-motor?voucherId=...`/`?motorId=...`), to be reconciled with the real route table in step 10.
7. **(raised during build)** No `invoices_seed.json`/`reviews_seed.json` exist in the 11-file scope, but `TS-260910-0091` needs to already read as paid + reviewed for S23/S24 demo.
   **Answered:** stay in 11-file scope. Flagged to step 09: `InvoiceRepositoryImpl`/`ReviewRepositoryImpl` should hardcode one canned paid invoice + single-mechanic review (Mas Rudi only) keyed to `bk_seed_001`, in code, not in `assets/mock/`.

**Invented-but-plausible values** (not independently pinned by any design doc, flagged here rather than asked one-by-one since none appear in a locked screenshot): workshop addresses/hours/review counts beyond Bengkel Jaya Motor; `ws_005` Cahaya's `open_time`/`close_time` (8–10, chosen so it reads closed at the known demo "now" moments); part `brand`/`grade` filler for the generic categories; non-pinned `MotorModel.cc` values (taken from each model's own name); voucher 3's `code` (`DISKON15`) and `valid_until`; `promos.json` copy (3 slides: voucher/multi-motor/service-reminder themed); all 4 seed bookings' `workshop_id`/`mechanic_id` defaulted to Bengkel Jaya Motor / Mas Rudi for continuity; `bk_seed_004`'s motor corrected to **Supra X 125** (not Beat) per `docs/plan/design/16-tracking-s19-s22.md`'s "Supra X 125 · Sel 6 Okt · 09.00".

## Scope

### Files / classes to build

`assets/mock/`:
- `user.json` — Galah, `+62 812-3456-7890`.
- `motor_models.json` — 16 models across Honda/Yamaha/Suzuki/Kawasaki (exact list in the design plan's S08 demo-content row).
- `garage_seed.json` — 4 motors (Vario 125 `AB 1234 XY`, Beat 110 `AB 5678 ZZ`, PCX 160 `AB 9012 QR`, Supra X 125 `AB 3344 KL`).
- `workshops.json` — 5 workshops with the exact rating/distance/bay/hours/estimate values from the design's S13 demo-content row (Bengkel Jaya Motor is canonical).
- `services.json` — 3 services (Servis Berkala Rp85.000/60mnt, Ganti Oli Rp35.000/30mnt, Perbaikan/Keluhan Rp50.000/60mnt `requiresComplaint`).
- `parts.json` — 14 parts with brand/grade/price/compatibility (category + cc range), exact prices from the design's S12 demo-content row.
- `vouchers.json` — 4 vouchers (`DISKON10`, `HEMAT25`, the 15%-min-4-motor one, `HEMAT75`) with exact `validUntil` dates.
- `promos.json` — 3–4 home banner promos (voucher / multi-motor / service-reminder themes, per the S05 kickoff decision).
- `mechanics.json` — ~6 mechanics distributed across workshops (Mas Rudi, Pak Anto named in the design content, plus filler).
- `notifications_seed.json` — the 9-notification set from the design's S06 demo-content row (2 unread).
- `bookings_seed.json` — 4 seed bookings with the exact codes/dates/statuses from the design's S07/S09/S17/S23 demo-content rows.
- `pubspec.yaml` — register `assets/mock/` (and any subfolder).

### Tests to write

- `test/core/data/mock_asset_shape_test.dart` (or similar, written against step 05's `MockJsonLoader` once that exists — placeholder here if step 05 hasn't run yet): each JSON file parses without a `FormatException` and every declared array has the expected count (16 models, 4 garage motors, 5 workshops, 3 services, 14 parts, 4 vouchers, 4 seed bookings). This test can be deferred to close alongside step 05/06 if `MockJsonLoader` doesn't exist yet — note the dependency explicitly at kickoff.

## Checklist

### Build
- [x] Open questions answered.
- [x] All 11 JSON files written, numbers cross-checked line-by-line against the design plan's canonical demo content table.
- [x] `pubspec.yaml` assets section updated (`assets:\n  - assets/mock/`); `flutter pub get` picks them up.

### Quality (flutter analyze / format / tests)
- [x] Every file is valid JSON — `tool/validate_mock_json.dart` (new, dependency-free `dart:io`/`dart:convert` script) parses all 11 files, checks declared counts, cross-references (model/service/part/voucher/mechanic/motor ids), and enum-value whitelists. `dart run tool/validate_mock_json.dart` → `OK: all 11 mock files valid, counts and cross-references correct.` Kept in the repo as a regression guard for steps 05–09. The step doc's own `test/core/data/mock_asset_shape_test.dart` stays deferred to step 05/06 (needs `MockJsonLoader`, which doesn't exist yet).
- [x] Counts match the design plan table exactly: 16 models / 4 garage motors / 5 workshops / 3 services / 14 parts / 4 vouchers / 3 promos / 6 mechanics / 9 notifications (2 unread) / 4 seed bookings.
- [x] No lorem-ipsum / placeholder text anywhere — all copy is real Indonesian content per the canonical demo table (promo copy and voucher-3 code are invented-but-plausible, not lorem, and flagged above).
- [x] `flutter analyze` → 0 issues. `dart format --set-exit-if-changed tool/validate_mock_json.dart` → clean.

### Review gate
- [x] Status 🔵; show the user the full file list + a diff against the design plan's canonical numbers table.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `014 - Create Mock Data Assets`.
- [x] Claude session file written (`docs/claude-session/apps/05-mobile-step04-mock-data-assets.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Review rounds

#### Round 1 — 2026-09-27
- **Shown:** file list (11 `assets/mock/*.json` + `tool/validate_mock_json.dart` + `pubspec.yaml` diff), validation script output, `flutter analyze`/format results, and the invented-value flags (voucher 3 code/date, promo copy, non-Jaya workshop details, `bk_seed_004` motor correction, placeholder deep-link scheme).
- **User feedback:** "approve"
- **Changes made:** none requested.
- **Outcome:** Approved.

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-27 | Explored step 02/03 entity fields (verified on disk via subagent), design plan's canonical demo content, PRD 05, data-layer skill's JSON convention | Confirmed no `fromJson`/`toJson` exists yet; entity field lists + enum spellings locked (`MotorBrand` capitalized, `MotorCategory`/status enums lowercase-or-literal) |
| 2026-09-27 | Kickoff interview (6 `AskUserQuestion` rounds: key casing, garage-seed size, active-booking seeding, mechanic-workshop link, Jaya service-list gap, deep-link scheme, invoice/review seed-file gap) | All 7 open questions answered, all recommended options accepted |
| 2026-09-27 | Wrote all 11 `assets/mock/*.json` files + `tool/validate_mock_json.dart` (parse/count/cross-reference/enum-whitelist self-check) | 11 files, ~30 model/workshop/part/booking entries cross-referenced by id |
| 2026-09-27 | `pubspec.yaml`: added `assets:\n  - assets/mock/` under the `flutter:` block | Section didn't exist before; added fresh |
| 2026-09-27 | `dart run tool/validate_mock_json.dart` | `OK: all 11 mock files valid, counts and cross-references correct.` |
| 2026-09-27 | `flutter pub get`, `flutter analyze`, `dart format --set-exit-if-changed tool/validate_mock_json.dart` | pub get succeeded (assets picked up); analyze 0 issues; format clean |
