# Step 02 — Core domain entities

| | |
|---|---|
| **Status** | ⬜ Not started |
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
2. `BookingDraft.unitConfigs` / `unitSlots` as `Map<String, UnitConfig>` / `Map<String, TimeSlot>` — is `UnitConfig` its own small entity (serviceIds/partIds/complaintNote per motor, pre-confirmation) distinct from the confirmed `BookingUnit`? (Recommended: yes — `BookingUnit` is the confirmed, priced, status-tracked record; `UnitConfig` is the draft's mutable in-progress shape. Confirm this split now so step 03/08 don't re-derive it.)
3. Plate-number auto-format (`AB 1234 XY`) and nickname/complaint char caps — validation lives in domain (per the skill's placement test) as `Motor` factory/static helpers or a small `MotorValidation` extension; confirm the exact home (entity static method vs. a `core/domain/service/` validator) — recommend entity-local static methods since it's single-entity, not cross-screen.

## Scope

### Files / classes to build

One file per entity in `lib/core/domain/model/`, hand-written or freezed per the kickoff answer:

`user.dart` (`User`), `motor.dart` (`Motor`), `motor_model.dart` (`MotorModel`), `workshop.dart` (`Workshop`), `service_type.dart` (`ServiceType`), `part.dart` (`Part`), `time_slot.dart` (`TimeSlot`), `voucher.dart` (`Voucher`), `booking_draft.dart` (`BookingDraft`, `UnitConfig`), `booking_unit.dart` (`BookingUnit`), `booking.dart` (`Booking`), `unit_status.dart` (`UnitStatus` enum + `UnitStatusX.fromString`/transition helpers), `booking_status.dart` (`BookingStatus` enum + derivation stub — full derivation logic is step 03's `BookingStatusDerivation` service, but the enum + `fromString` live here), `status_event.dart` (`StatusEvent`), `mechanic.dart` (`Mechanic`), `invoice.dart` (`Invoice`, `InvoiceLine`), `review.dart` (`Review`), `app_notification.dart` (`AppNotification` + its `category`/`deepLink` shape), `promo.dart` (`Promo`).

(`Result<T>` already exists from step 01.)

### Tests to write

- `test/core/domain/model/` — one test file per non-trivial entity: `copyWith`/`==`/`hashCode` behavior (for hand-written classes), enum `fromString` covering every known value + an unknown-input fallback (never throws), `Motor`/plate-number formatting edge cases if validation lives here.

## Checklist

### Build
- [ ] Open questions answered (hand-written/freezed split, `UnitConfig` split, validation home).
- [ ] All ~19 entities/enums written, importable from `package:tumbas_servis/core/domain/model/...`.
- [ ] `build_runner` run for any freezed entity; generated files present and gitignored appropriately (or committed, per the skill's default — generated files excluded from analysis, confirm commit policy at kickoff).
- [ ] No `package:flutter/`, no `dio`, no storage import anywhere under `core/domain/`.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test test/core/domain/model/` → green.
- [ ] `grep -rln 'package:flutter/' lib/core/domain/` → empty.

### Review gate
- [ ] Status 🔵; show the user the entity list + any freezed/hand-written split deviations from the recommendation.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `012 - Create Core Domain Entities`.
- [ ] Claude session file written (`docs/claude-session/apps/03-mobile-step02-domain-entities.md`).
- [ ] Tracker in `00-index.md` set to ✅.

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
