# Claude Session Log — 05: Mobile-app step 04 — Mock data assets

**Tool:** Claude Code (CLI agent), model Sonnet 5
**Date:** 2026-09-27
**Topic:** Write the 11 mock JSON assets under `assets/mock/` matching step 02's entity shapes and the design plan's canonical demo content, per `docs/plan/mobile-app/04-mock-data-assets.md`.

## Initial prompt

> i want to do docs/plan/mobile-app/04-xx, interviewme with detail if need

## Research performed

1. Read `docs/plan/mobile-app/04-mock-data-assets.md` in full (goal, inputs, open questions, scope, checklist) and `00-index.md` (workflow, conventions, tracker).
2. Read `docs/plan/design/00-index.md`'s "Canonical demo content" section in full (booking `TS-260929-0417`, 16-model garage, 5-workshop list, 4 vouchers, 14-part catalog, S06/S15/S05 demo-content rows) and `prd/05-data-model-mock.md` (Entities table, mock-file table).
3. Read step 02/03 step docs (both ✅) to confirm entity/repository scope was already locked and committed.
4. Launched an `Explore` subagent to verify, directly against `lib/core/domain/model/**/*.dart` on disk, every entity's exact field names/types, enum-value spellings (`MotorBrand` capitalized, `MotorCategory`/status enums lowercase-or-literal), confirm no `fromJson`/`toJson` exists yet, and confirm `assets/mock/`/`pubspec.yaml` assets section didn't exist yet.
5. Grepped `.claude/skills/flutter-data-layer/SKILL.md` to confirm the `snake_case` + `@JsonKey(name:)` convention referenced by the step doc's own recommendation.
6. Grepped `docs/plan/design/05-s05-home.md` to resolve the mock-file table's "3–4 home banner promos" ambiguity to exactly 3 (voucher/multi-motor/service-reminder themed).
7. Launched a `Plan` subagent with the full gathered context to draft a field-by-field JSON design for all 11 files (exact key names, sample values, cross-referenced ids), which also surfaced several gaps the design plan doesn't pin (Jaya's service list referencing nonexistent services, `Mechanic` having no `workshopId`, no `invoices_seed.json`/`reviews_seed.json` in scope, voucher 3's missing code, Cahaya's "closed" hours, `bk_seed_004`'s motor — corrected to Supra X 125 per `docs/plan/design/16-tracking-s19-s22.md`).

## Clarifying interview (3 rounds, `AskUserQuestion`)

| Question | Answer |
|---|---|
| JSON key casing | `snake_case` (field names only; enum values stay literal Dart spelling) |
| `garage_seed.json` size | 4 motors only; Ninja 250/Scoopy 110 stay S10-only, added live later |
| Active booking `TS-260929-0417` seeded? | Not seeded — created live via S10→S18 |
| `mechanics.json` workshop link (entity has no `workshopId`) | Flat list, no link — association only via `BookingUnit.mechanicId` |
| Jaya's nonexistent services (Ganti Ban/Tune-Up) + cancelled booking's Ganti Ban | Substitute with the 3 real services everywhere |
| Notification `deep_link` scheme (no router until step 10) | Simple placeholder path now, reconciled in step 10 |
| Missing invoice/review seed files for the paid+reviewed demo booking | Stay in 11-file scope; step 09 hardcodes a canned invoice+review in code |

All 7 questions answered with the recommended option in every round.

## Execution

**`assets/mock/*.json`** (11 new files, snake_case keys): `user.json` (Galah), `motor_models.json` (16, Honda/Yamaha/Suzuki/Kawasaki), `garage_seed.json` (4: Vario 125/Beat 110/PCX 160/Supra X 125), `workshops.json` (5, Bengkel Jaya Motor canonical), `services.json` (3, fully pinned prices/durations), `parts.json` (14, built so Beat 110 fits exactly 7 via `compatible_model_ids`), `vouchers.json` (4: DISKON10/HEMAT25/DISKON15/HEMAT75), `promos.json` (3: voucher/multi-motor/service-reminder themed), `mechanics.json` (6, Mas Rudi/Pak Anto pinned + 4 filler), `notifications_seed.json` (9, 2 unread, matches S06 canonical list verbatim), `bookings_seed.json` (4: 2 `selesai`, 1 `dibatalkan`, 1 `terjadwal`, all cross-referenced by id, `motor_snapshot` fully embedded per `BookingUnit`'s shape).

**`pubspec.yaml`**: added `assets:\n  - assets/mock/` under `flutter:` (nothing existed before).

**`tool/validate_mock_json.dart`** (new): dependency-free `dart:io`/`dart:convert` script — parses all 11 files, checks declared counts (16/4/5/3/14/4/6/9/4, 2 unread), cross-references every id (model/service/part/voucher/mechanic/motor), and whitelists every enum-value string against the exact Dart spellings. Kept in the repo as a regression guard for steps 05–09.

**Quality gate:** `dart run tool/validate_mock_json.dart` → `OK: all 11 mock files valid, counts and cross-references correct.`; `flutter pub get` → succeeded, assets picked up; `flutter analyze` → 0 issues; `dart format --set-exit-if-changed tool/validate_mock_json.dart` → clean.

## Review rounds

#### Round 1 — 2026-09-27
- **Shown:** file list (11 JSON + validation script + `pubspec.yaml` diff), validation script output, `flutter analyze`/format results, and the invented-value flags (voucher 3 code/date, promo copy, non-Jaya workshop details, `bk_seed_004` motor correction, placeholder deep-link scheme).
- **User feedback:** "approve"
- **Changes made:** none requested.
- **Outcome:** Approved.

## Key decisions worth flagging to a reviewer

- **The step doc's own "Tests to write" (`test/core/data/mock_asset_shape_test.dart`) stays deferred to step 05/06** — it needs `MockJsonLoader`, which doesn't exist until step 05. `tool/validate_mock_json.dart` substitutes as this step's own self-check, per the step doc's "or defer to the shape test above" quality-gate wording.
- **`bk_seed_004`'s motor corrected from the implied Beat 110 to Supra X 125** — `docs/plan/design/16-tracking-s19-s22.md` explicitly pins "`TS-261006-0419` Mendatang (Supra X 125 · Sel 6 Okt · 09.00)", which the original step-04 brief didn't carry.
- **All 5 workshops reference only the 3 real `service_ids`** — the canonical content's Jaya service list ("…, Ganti Ban, Tune-Up") and the cancelled seed booking's "Ganti Ban" both named services with no `ServiceType` entity; resolved by substitution rather than expanding `services.json` beyond its stated 3-service scope.
- **`mechanics.json` carries no workshop association** — `Mechanic` genuinely has no `workshopId` field on the built entity; any future per-workshop mechanic grouping needs a schema change, not a mock-data change.
- **Notification `deep_link` values are a placeholder URI scheme**, not sourced from any router (none exists until step 10) — documented in the step doc so step 10 can reconcile or remap them against the real `go_router` table.
- **No `invoices_seed.json`/`reviews_seed.json`** — confirmed absent from both the step doc's 11-file list and `prd/05`'s mock-file table; step 09 is flagged to hardcode the one canned paid-invoice + review the S23/S24 demo needs.

## Output

- 11 files in `assets/mock/`, `tool/validate_mock_json.dart`, `pubspec.yaml` assets section — all new/first-write for this repo.
- `dart run tool/validate_mock_json.dart` green; `flutter analyze`/`format` clean; `flutter pub get` succeeded.
- `docs/plan/mobile-app/04-mock-data-assets.md` checklist, open questions, review rounds, and session log filled in; status set to ✅.
- `docs/plan/mobile-app/00-index.md` step 04 tracker row set to ✅.
- This log: `docs/claude-session/apps/05-mobile-step04-mock-data-assets.md`.
- Commit proposed (user commits manually): `014 - Create Mock Data Assets`.
- Next: step 05.
