# Step 07 — Data layer: Garage & Catalog

| | |
|---|---|
| **Status** | ✅ |
| **Layer** | Data |
| **Priority** | — |
| **Owns** | `garage/data/` (`GarageRepositoryImpl`), `catalog/data/` (`CatalogRepositoryImpl`) |
| **PRD refs** | [05](../../../prd/05-data-model-mock.md), [03 F5 garage management](../../../prd/03-user-flows.md) |
| **Design refs** | — |
| **Depends on** | Steps 03, 04, 05 |
| **Claude session** | `docs/claude-session/apps/08-mobile-step07-data-garage-catalog.md` (written after approval) |

## Goal

Implement motor CRUD (garage, locally persisted, mutable) and the read-only catalog (services/parts/vouchers/promos, asset-sourced per PRD 05 — "Catalog data stays asset-sourced and read-only").

## Inputs

- `.claude/skills/flutter-data-layer/SKILL.md`.
- `prd/03-user-flows.md` F5 (add/edit/delete rules: delete blocked while in an active booking; plate/nickname validation error surfacing).
- `prd/05-data-model-mock.md` `GarageRepository`/`CatalogRepository` method lists; `motor_models.json`, `garage_seed.json`, `services.json`, `parts.json`, `vouchers.json`, `promos.json`.

## Open questions (ask at kickoff)

1. `Motor` DTO ↔ domain mapping — plate-number format/duplicate validation: confirm it's checked in the domain entity (step 02) before the repository ever writes, so `GarageRepositoryImpl.addMotor` can trust a valid `Motor` and only needs to check the *duplicate* rule (cross-record, needs the current list — a repository-level concern) itself.
   - **Answered (2026-09-28):** yes — `Motor` (step 02) only validates nickname length + plate-number formatting; duplicate-plate is cross-record, so `GarageRepositoryImpl` checks it itself (case-insensitive `plateNumber` compare across the current LocalStore contents, excluding the record's own id on update).
2. `getParts({modelId})` filtering (category + cc range) — implemented in the repository impl (reading `Part.compatibleModelIds`/category+cc from the DTO) or does it just fetch everything and let the domain/presentation filter? Recommend: repository does the raw fetch only; the *filter* rule itself is a domain concern already covered if a compatibility service exists — confirm whether step 03 needs a `PartCompatibilityFilter` added retroactively, or whether `SalinDariCompatibilityFilter` already covers this shape and can be reused/generalized.
   - **Answered (2026-09-28):** no new domain service needed. Read `salin_dari_compatibility_filter.dart` — it's a booking-scoped concern (copies a unit's config to another unit, drops incompatible parts), not a general parts filter. `Part` has no separate category/cc fields; `Part.compatibleModelIds` already encodes compatibility, so `CatalogRepositoryImpl.getParts` filters inline: `parts.where((p) => modelId == null || p.compatibleModelIds.contains(modelId))`.
3. **New, surfaced this session:** DTO/mapper folders (per this doc's original Scope, matching the generic `flutter-data-layer` skill scaffold) vs. inline `_xFromJson`/`_xToJson` methods in the repo impl (the pattern steps 05/06 actually settled on, e.g. `session_repository_impl.dart`). **Answered:** inline — no `model/`, `mapper/` folders; kept consistent with `auth`/`profile`.
4. **New, surfaced this session:** `deleteMotor`'s "blocked while in an active booking" rule needs `BookingRepository`, which doesn't exist until step 08. **Answered:** `GarageRepositoryImpl` takes an injected `Future<bool> Function(String motorId) hasActiveBooking` callback; `garage_data_module.dart` wires it to `(_) async => false` for now (`TODO(step08)` comment), step 08 supplies the real check.
5. **New, surfaced this session:** how does the mutable garage reconcile with the fixed `garage_seed.json` asset? **Answered:** copy-seed-once — on first `getMotors()`/write call, if the `garage` LocalStore box is empty it's seeded from `garage_seed.json`; every subsequent read/write/delete touches only LocalStore.

## Scope

### Files / classes to build

`lib/garage/data/`:
- `model/motor/response/motor_response.dart`, `model/motor_model/response/motor_model_response.dart` — DTOs for `garage_seed.json` / `motor_models.json` rows.
- `mapper/motor_mapper.dart`, `mapper/motor_model_mapper.dart` — `toDomain()`.
- `repository/garage_repository_impl.dart` — `getMotors()` (persisted + seed merge), `addMotor`/`updateMotor` (persist via `LocalStore`, duplicate-plate check), `deleteMotor` (blocked if the motor has an active booking — reads `BookingRepository`? or takes an injected check callback to avoid a garage→booking import; **flag this cross-repo dependency as an Open question resolution** — recommend passing the "has active booking" check as a constructor-injected function from a higher DI layer, not a direct import of `booking`'s repository), `getMotorModels()`.
- `di/garage_data_module.dart`.

`lib/catalog/data/`:
- `model/service_type/response/…`, `model/part/response/…`, `model/voucher/response/…`, `model/promo/response/…` DTOs.
- `mapper/` for each.
- `repository/catalog_repository_impl.dart` — `getServiceTypes()`, `getParts({modelId})` (category+cc filter), `getVouchers()`, `getPromos()`; all read-only over `MockJsonLoader`.
- `di/catalog_data_module.dart`.

### Tests to write

- `test/garage/data/repository/garage_repository_impl_test.dart` — add/update/delete round-trip through a fake `LocalStore`; duplicate-plate rejected; delete-while-in-service blocked.
- `test/catalog/data/repository/catalog_repository_impl_test.dart` — `getParts` returns only compatible parts for a given model/cc; vouchers/promos/services load with the exact counts from step 04.

## Checklist

### Build
- [x] Open questions answered (cross-repo dependency shape for the delete-blocked rule).
- [x] Both repository impls + DTOs + mappers + DI modules written. *(DTOs/mappers deliberately skipped per the interview decision above — inline json methods instead, matching steps 05/06.)*
- [x] Neither impl imports another feature's `data/repository/` directly (constructor-injected-callback pattern used for the delete-blocked rule).

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test test/garage/data/ test/catalog/data/` → green (13/13 passed).

### Review gate
- [x] Status 🔵; show the user both impls + test results + the cross-repo dependency resolution.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `017 - Create Garage & Catalog Data Layer`.
- [x] Claude session file written (`docs/claude-session/apps/08-mobile-step07-data-garage-catalog.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Review rounds

#### Round 1 — 2026-09-28
- **Shown:** `lib/garage/data/repository/garage_repository_impl.dart`, `lib/garage/data/di/garage_data_module.dart`, `lib/catalog/data/repository/catalog_repository_impl.dart`, `lib/catalog/data/di/catalog_data_module.dart`, `test/garage/data/repository/garage_repository_impl_test.dart` (8 tests), `test/catalog/data/repository/catalog_repository_impl_test.dart` (5 tests) — all 13 passing; `flutter analyze` 0 issues; `dart format` clean.
- **User feedback:** "approve"
- **Changes made:** none requested
- **Outcome:** approved

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-28 | Kickoff interview (4 open questions, incl. 2 new ones surfaced by reading current code: DTO/mapper style, active-booking cross-repo check) — user picked the recommended option for all four | Decisions logged above and in the plan |
| 2026-09-28 | Built `GarageRepositoryImpl` (copy-seed-once into LocalStore box `garage`, duplicate-plate guard, injected `hasActiveBooking` callback) and `CatalogRepositoryImpl` (read-only, inline `compatibleModelIds` filter for `getParts`), plus both `di/` modules | 4 new files under `lib/garage/data/`, `lib/catalog/data/` |
| 2026-09-28 | Wrote repository tests + ran `flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test test/garage/data/ test/catalog/data/`, layer-direction greps | 0 analyze issues, format clean, 13/13 tests green, no stray cross-feature/flutter imports |
| 2026-09-28 | User approved Round 1 | Step closed; commit `017 - Create Garage & Catalog Data Layer` proposed; tracker set to ✅ |
