# Step 07 — Data layer: Garage & Catalog

| | |
|---|---|
| **Status** | ⬜ Not started |
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
2. `getParts({modelId})` filtering (category + cc range) — implemented in the repository impl (reading `Part.compatibleModelIds`/category+cc from the DTO) or does it just fetch everything and let the domain/presentation filter? Recommend: repository does the raw fetch only; the *filter* rule itself is a domain concern already covered if a compatibility service exists — confirm whether step 03 needs a `PartCompatibilityFilter` added retroactively, or whether `SalinDariCompatibilityFilter` already covers this shape and can be reused/generalized.

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
- [ ] Open questions answered (cross-repo dependency shape for the delete-blocked rule).
- [ ] Both repository impls + DTOs + mappers + DI modules written.
- [ ] Neither impl imports another feature's `data/repository/` directly (use the constructor-injected-callback pattern or a `core/domain/service` port if the cross-feature check recurs elsewhere).

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test test/garage/data/ test/catalog/data/` → green.

### Review gate
- [ ] Status 🔵; show the user both impls + test results + the cross-repo dependency resolution.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `017 - Create Garage & Catalog Data Layer`.
- [ ] Claude session file written (`docs/claude-session/apps/08-mobile-step07-data-garage-catalog.md`).
- [ ] Tracker in `00-index.md` set to ✅.

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
