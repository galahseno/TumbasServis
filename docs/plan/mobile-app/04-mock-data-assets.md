# Step 04 — Mock data assets

| | |
|---|---|
| **Status** | ⬜ Not started |
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
2. Are the two S10-only "design specimens" (Ninja 250 `AB 7788 MN` in-service, Scoopy 110 `AB 2468 TP`) included in `garage_seed.json` from the start, or added later through the app's own "add motor" flow during manual QA (per the design note "add them through S08 to reproduce the max-reached state")? Recommend: seed only the 4-motor garage; the 5th/6th are exercised live via S08 during step 13/21 QA, not baked into the seed.
3. `bookings_seed.json`: the design plan lists 4 seed bookings (2 `selesai`, 1 `dibatalkan`, 1 `terjadwal`) — confirm the active `TS-260929-0417` (the canonical S05–S18 demo) is **not** seeded (created live by running the booking flow), matching the design note.

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
- [ ] Open questions answered.
- [ ] All 11 JSON files written, numbers cross-checked line-by-line against the design plan's canonical demo content table.
- [ ] `pubspec.yaml` assets section updated; `flutter pub get` picks them up.

### Quality (flutter analyze / format / tests)
- [ ] Every file is valid JSON (`dart run` a tiny parse-check script, or defer to the shape test above once step 05 exists).
- [ ] Counts match the design plan table exactly (16/4/5/3/14/4/4).
- [ ] No lorem-ipsum / placeholder text anywhere.

### Review gate
- [ ] Status 🔵; show the user the full file list + a diff against the design plan's canonical numbers table.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `014 - Create Mock Data Assets`.
- [ ] Claude session file written (`docs/claude-session/apps/05-mobile-step04-mock-data-assets.md`).
- [ ] Tracker in `00-index.md` set to ✅.

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
