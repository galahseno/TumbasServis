# Claude Session Log — 03: Mobile-app step 02 — Core domain entities

**Tool:** Claude Code (CLI agent), model Sonnet 5
**Date:** 2026-09-27
**Topic:** Write every shared entity/enum from PRD 05 as pure-Dart classes in `core/domain/model/`, per `docs/plan/mobile-app/02-domain-entities.md`.

## Initial prompt

> i want to do docs/plan/mobile-app/02-xx, interviewme with detail if need

## Research performed

1. Read `docs/plan/mobile-app/02-domain-entities.md` in full (goal, inputs, open questions, scope, checklist).
2. Read `.claude/skills/flutter-domain-layer/SKILL.md` — hand-written vs freezed rule of thumb, `<EnumName>X.fromString` pattern (always falls back, never throws), validation-placement test.
3. Read `prd/05-data-model-mock.md` — full Entities table, `UnitStatus`/`BookingStatus` enum tables, repository-interface method skeletons.
4. Read `prd/03-user-flows.md` — identifiers & status section (booking code `TS-YYMMDD-XXXX`, unit code suffixes `-A`…`-E`, unit status machine, complaint-note 250-char cap).
5. Checked current repo state: `lib/core/domain/model/result.dart` (step 01's `Result<T>`, unchanged), `pubspec.yaml` (freezed/build_runner/json_serializable already present from step 01).
6. Read step 01's session log for prior decisions (freezed pinned to stable `^3.2.5`) and its closing note pointing at step 02 next.

## Clarifying interview (2 rounds, `AskUserQuestion`)

| Question | Answer |
|---|---|
| Hand-written vs freezed split across ~19 entities | Accept the doc's recommended split (hand-written: `User`, `Mechanic`, `StatusEvent`, `InvoiceLine`, `MotorModel`; freezed: the other 13) |
| `UnitConfig` as its own entity distinct from `BookingUnit` | Yes — separate freezed entity, colocated in `booking_draft.dart` |
| Validation home (plate format, char caps) | Entity-local static/factory methods, no separate `core/domain/service/` validator |
| Commit `*.freezed.dart` or gitignore them | Commit them (standard practice; already excluded from `flutter analyze`) |

## Execution

**Entities/enums written** (initially flat in `lib/core/domain/model/`, one file per class):
- Hand-written: `User`, `Mechanic`, `StatusEvent`, `MotorModel` (+ `MotorBrand`/`MotorCategory` enums), `InvoiceLine`.
- Freezed: `Motor` (+ `formatPlateNumber`/`isNicknameValid` statics), `Workshop`, `ServiceType`, `Part`, `TimeSlot` (+ `remaining` getter), `Voucher` (+ new `DiscountType` enum), `BookingDraft` + `UnitConfig` (+ new `ScheduleMode` enum, + `isComplaintNoteValid`), `BookingUnit`, `Booking`, `Invoice`, `Review` (+ `isWorkshopCommentValid`), `AppNotification` (+ new `NotificationCategory` enum), `Promo`.
- Enums: `UnitStatus` (+ `canTransitionTo`/`isTerminal`), `BookingStatus`, both with `fromString` + an explicit `unknown` fallback member (matches the skill's own `UserRole` example).
- `dart run build_runner build` generated the 13 `.freezed.dart` files.
- 14 test files in `test/core/domain/model/` — `copyWith`/`==`/`hashCode` for hand-written classes, exhaustive + unknown-fallback `fromString` for every enum, `Motor` plate-format/nickname-cap edge cases, `UnitConfig`/`Review` char-cap boundaries, `TimeSlot.remaining`.

**Quality gate (first pass):** `flutter analyze` → 0 issues; `dart format --set-exit-if-changed .` → clean; `flutter test test/core/domain/model/` → 51/51 passed; `grep -rln 'package:flutter/' lib/core/domain/` → empty.

**Post-build reorg (user-requested, before approval):** user asked to arrange `model/` into subfolders per concept ("add new package to categorise each model... do this for next step if have same result"). Moved all files into `user/`, `garage/`, `workshop/`, `catalog/`, `booking/`, `invoice/`, `review/`, `notification/` subfolders (each `.dart` + its own `.freezed.dart` together; `result.dart` stayed at `model/` root as the one cross-layer type). Mirrored `test/core/domain/model/` into the same subfolders. Fixed every cross-file `package:` import to the new paths (`booking_unit.dart` → `garage/motor.dart` + `booking/status_event.dart` + `booking/unit_status.dart`; `booking.dart` → `booking/*` + `workshop/time_slot.dart`; `booking_draft.dart` → `workshop/time_slot.dart`; `invoice.dart` → `invoice/invoice_line.dart`). Re-ran `build_runner`, `flutter analyze`, `dart format`, `flutter test`, and the grep — all green again (0 issues, clean, 51/51, empty grep). Recorded the pattern as a standing convention in `00-index.md` under a new "Grouping folders" section, so future file-heavy steps (step 03's `repository/` next) apply it automatically.

## Review rounds

#### Round 1 — 2026-09-27
- **Shown:** entity list (with subfolder locations), the 3 deviations from the plan doc's field list (new `DiscountType`/`ScheduleMode`/`NotificationCategory` enums, explicit `unknown` fallback member on every enum, `Workshop.openTime`/`closeTime` as `int` minutes-since-midnight, `Part.category`/`brand`/`grade` kept as `String`), and the quality-gate results — via chat, plus the in-file checklist/session-log per the standing process from step 01.
- **User feedback:** requested the `model/` reorg into concept subfolders before approving; then "approve i commit push manually".
- **Changes made:** the reorg described above.
- **Outcome:** Approved.

## Key decisions worth flagging to a reviewer

- **Three enums added beyond the plan doc's literal field list** (`DiscountType`, `ScheduleMode`, `NotificationCategory`) — same treatment as the already-approved `MotorBrand`/`MotorCategory`, for closed-value fields PRD 05 described in parens. Every domain enum also got an `unknown` fallback member (the `fromString` sentinel), not a new PRD-05 value.
- **`Workshop.openTime`/`closeTime` modeled as `int` (minutes since midnight)**, not a string — PRD 05 calls them "structured"; avoids a Flutter `TimeOfDay` import (forbidden under `core/domain/`).
- **`model/` reorganized into concept subfolders** mid-step, at the user's request, and this is now the standing convention (`00-index.md`) for any step that would otherwise dump many files flat into one folder.

## Output

- ~19 entities + enums in `lib/core/domain/model/<concept>/`, `Result<T>` unchanged at the root.
- `flutter analyze`/`format`/`test` all green; 51 tests; no layer-direction violations.
- `docs/plan/mobile-app/02-domain-entities.md` checklist, review rounds, deviations, and session log filled in; status set to ✅.
- `docs/plan/mobile-app/00-index.md` gained a "Grouping folders" convention section; step 02 tracker row set to ✅.
- This log: `docs/claude-session/apps/03-mobile-step02-domain-entities.md`.
- Commit proposed (user commits/pushes manually): `012 - Create Core Domain Entities`.
- Next: step 03 (`docs/plan/mobile-app/03-domain-rules-repositories.md`).
