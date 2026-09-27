# Step 02 — Core domain entities

| | |
|---|---|
| **Status** | ✅ Approved |
| **Layer** | Domain |
| **Priority** | — |
| **Owns** | `lib/core/domain/model/` — all shared entities + enums |
| **PRD refs** | [05 domain model & mock data](../../../prd/05-data-model-mock.md) (Entities table) |
| **Design refs** | — (no visual review; entities are pure Dart) |
| **Depends on** | Step 01 |
| **Claude session** | `docs/claude-session/apps/03-mobile-step02-domain-entities.md` (written after approval) |

## Goal

Write every shared entity and enum from PRD 05 as pure-Dart classes in `core/domain/model/` — no `package:flutter/`, no JSON annotations (those belong to data-layer DTOs). This is the layer everything else depends on; nothing here depends on anything.

## Inputs

- `.claude/skills/flutter-domain-layer/SKILL.md` (hand-written vs freezed rule of thumb, enum parsing pattern).
- `prd/05-data-model-mock.md` — the Entities table (field lists) and the two enum tables (`UnitStatus`, `BookingStatus`).
- `prd/03-user-flows.md` — identifiers & status section (booking/unit code formats) informs field types/validation placement.

## Open questions (ask at kickoff)

1. Hand-written vs freezed split — recommend: hand-written for simple/stable entities (`User`, `Mechanic`, `StatusEvent`, `InvoiceLine`, `MotorModel`), freezed for entities with many fields or that benefit from `copyWith` a lot in the presentation layer (`Motor`, `Workshop`, `BookingDraft`, `BookingUnit`, `Booking`, `Invoice`, `Review`, `AppNotification`, `Promo`, `Voucher`, `Part`, `ServiceType`, `TimeSlot`). Confirm or adjust per-entity.
   **Answered:** accepted the recommended split as-is.
2. `BookingDraft.unitConfigs` / `unitSlots` as `Map<String, UnitConfig>` / `Map<String, TimeSlot>` — is `UnitConfig` its own small entity (serviceIds/partIds/complaintNote per motor, pre-confirmation) distinct from the confirmed `BookingUnit`? (Recommended: yes — `BookingUnit` is the confirmed, priced, status-tracked record; `UnitConfig` is the draft's mutable in-progress shape. Confirm this split now so step 03/08 don't re-derive it.)
   **Answered:** yes, separate `UnitConfig` freezed entity, colocated in `booking_draft.dart`.
3. Plate-number auto-format (`AB 1234 XY`) and nickname/complaint char caps — validation lives in domain (per the skill's placement test) as `Motor` factory/static helpers or a small `MotorValidation` extension; confirm the exact home (entity static method vs. a `core/domain/service/` validator) — recommend entity-local static methods since it's single-entity, not cross-screen.
   **Answered:** entity-local static methods (`Motor.formatPlateNumber`, `Motor.isNicknameValid`, `UnitConfig.isComplaintNoteValid`, `Review.isWorkshopCommentValid`), no separate validator service.
4. (Checklist item, asked alongside the above) Commit `*.freezed.dart` or gitignore them?
   **Answered:** commit them (standard Flutter practice; already excluded from `flutter analyze` via `analysis_options.yaml`).

## Scope

### Files / classes to build

One file per entity in `lib/core/domain/model/`, hand-written or freezed per the kickoff answer:

Grouped into concept subfolders per `00-index.md`'s "Grouping folders" convention (adopted this step):

- `user/user.dart` (`User`)
- `garage/motor.dart` (`Motor`), `garage/motor_model.dart` (`MotorModel`, `MotorBrand`, `MotorCategory`)
- `workshop/workshop.dart` (`Workshop`), `workshop/mechanic.dart` (`Mechanic`), `workshop/time_slot.dart` (`TimeSlot`)
- `catalog/service_type.dart` (`ServiceType`), `catalog/part.dart` (`Part`), `catalog/voucher.dart` (`Voucher`, `DiscountType`), `catalog/promo.dart` (`Promo`)
- `booking/unit_status.dart` (`UnitStatus` enum + `UnitStatusX.fromString`/transition helpers), `booking/booking_status.dart` (`BookingStatus` enum + `fromString` — full derivation logic is step 03's `BookingStatusDerivation` service), `booking/status_event.dart` (`StatusEvent`), `booking/booking_draft.dart` (`BookingDraft`, `UnitConfig`, `ScheduleMode`), `booking/booking_unit.dart` (`BookingUnit`), `booking/booking.dart` (`Booking`)
- `invoice/invoice_line.dart` (`InvoiceLine`), `invoice/invoice.dart` (`Invoice`)
- `review/review.dart` (`Review`)
- `notification/app_notification.dart` (`AppNotification`, `NotificationCategory`)

(`Result<T>` already exists from step 01, stays at `model/result.dart` root — no subfolder, shared by every layer.)

### Tests to write

- `test/core/domain/model/` — one test file per non-trivial entity: `copyWith`/`==`/`hashCode` behavior (for hand-written classes), enum `fromString` covering every known value + an unknown-input fallback (never throws), `Motor`/plate-number formatting edge cases if validation lives here.

## Checklist

### Build
- [x] Open questions answered (hand-written/freezed split, `UnitConfig` split, validation home).
- [x] All ~19 entities/enums written, importable from `package:tumbas_servis/core/domain/model/...`.
- [x] `build_runner` run for any freezed entity; generated files present and committed (`.freezed.dart`, gitignore-excluded from `flutter analyze` only).
- [x] No `package:flutter/`, no `dio`, no storage import anywhere under `core/domain/`.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test test/core/domain/model/` → green (51/51).
- [x] `grep -rln 'package:flutter/' lib/core/domain/` → empty.

### Review gate
- [x] Status 🔵; show the user the entity list + any freezed/hand-written split deviations from the recommendation.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `012 - Create Core Domain Entities`.
- [x] Claude session file written (`docs/claude-session/apps/03-mobile-step02-domain-entities.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Deviations from the plan doc worth flagging

The doc's own field lists didn't call out enum types for a few closed-value fields; for consistency with the `MotorBrand`/`MotorCategory` treatment (and per the skill's own "domain enums carry parsing/validation" rule), the following were also modeled as enums rather than raw `String`, same `fromString` pattern:
- `Voucher.discountType` → `DiscountType { percent, flat, unknown }` (in `voucher.dart`).
- `BookingDraft.scheduleMode` / `Booking.scheduleMode` → `ScheduleMode { shared, split, unknown }` (in `booking_draft.dart`).
- `AppNotification.category` → `NotificationCategory { status, promo, reminder, unknown }` (in `app_notification.dart`).

Every domain enum (including `UnitStatus`/`BookingStatus`) got an explicit `unknown` member as the `fromString` fallback target, matching the skill's own `UserRole` example — not a new enum value from PRD 05, just the parse-failure sentinel.

`Workshop.openTime` / `closeTime` are `int` (minutes since midnight) rather than a string — PRD 05 calls these "structured"; avoids a Flutter `TimeOfDay` import (forbidden in domain) and keeps them arithmetic-ready for step 03's open/closed derivation.

`Part.category` / `brand` / `grade` stayed `String` (not enum) — PRD 05 lists categories with a trailing "…", i.e. an open, non-exhaustive set, unlike `MotorBrand`/`MotorCategory`'s closed lists.

**Post-build reorg (user-requested):** `model/` was flat (~40 files including `.freezed.dart`) after the initial build; re-arranged into concept subfolders (`user/`, `garage/`, `workshop/`, `catalog/`, `booking/`, `invoice/`, `review/`, `notification/`), each `.dart` + its own `.freezed.dart` together, `result.dart` staying at root. Tests mirrored into matching `test/core/domain/model/<concept>/` subfolders. All internal imports updated to the new package paths; re-ran `build_runner`, `flutter analyze`, `dart format`, `flutter test`, and the layer-direction grep — all still green. This is now the standing convention for any file-heavy folder, recorded in `00-index.md`'s new "Grouping folders" section.

## Review rounds

| Round | Date | Result |
|---|---|---|
| 1 | 2026-09-27 | Approved. Follow-up before approval: user asked to reorganize `model/` into concept subfolders (logged above and in session log); reorg done, re-verified green, then approved. |

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-27 | Kickoff interview (4 questions via AskUserQuestion) | All 3 open questions + the generated-files checklist item answered, all accepting the doc's own recommendation. |
| 2026-09-27 | Wrote enums (`unit_status.dart`, `booking_status.dart`) | Both include `fromString` + `unknown` fallback; `UnitStatus` also gets `canTransitionTo`/`isTerminal`. |
| 2026-09-27 | Wrote hand-written entities (`User`, `Mechanic`, `StatusEvent`, `MotorModel` + brand/category enums, `InvoiceLine`) | const constructors, hand-written `copyWith`/`==`/`hashCode`. |
| 2026-09-27 | Wrote freezed entities (`TimeSlot`, `ServiceType`, `Part`, `Voucher`, `Workshop`, `Motor`, `UnitConfig`+`BookingDraft`, `BookingUnit`, `Booking`, `Invoice`, `Review`, `AppNotification`, `Promo`) | `Motor`/`UnitConfig`/`Review`/`TimeSlot` carry entity-local validation statics/getters per kickoff answer. |
| 2026-09-27 | `dart run build_runner build --delete-conflicting-outputs` | 13 `.freezed.dart` files generated, committed per kickoff answer. |
| 2026-09-27 | Wrote `test/core/domain/model/*_test.dart` (14 new files) | copyWith/==/hashCode for hand-written classes, `fromString` exhaustive + unknown-fallback for every enum, `Motor` plate-format + nickname-cap edge cases, `UnitConfig`/`Review` char-cap boundaries, `TimeSlot.remaining`. |
| 2026-09-27 | Quality gate: `flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test test/core/domain/model/`, layer-direction grep | All green: 0 analyze issues, format clean, 51/51 tests passed, no `flutter/`/data imports under `core/domain/`. |
| 2026-09-27 | User-requested reorg: moved `model/` files into concept subfolders, mirrored `test/`, fixed cross-file imports, re-ran `build_runner`/`flutter analyze`/`dart format`/`flutter test`/grep | All green after reorg: 0 analyze issues, format clean, 51/51 tests passed. Convention recorded in `00-index.md` for future steps. |
