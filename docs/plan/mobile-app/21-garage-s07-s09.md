# Step 21 — S07 Garasi Saya, S08 Tambah/Edit Motor, S09 Detail Motor

| | |
|---|---|
| **Status** | ✅ Done |
| **Layer** | Presentation, phone |
| **Priority** | P1 |
| **Owns** | `garage/presentation/` (S07, S08, S09) |
| **PRD refs** | [04 S07–S09](../../../prd/04-screens.md), [03 F5 garage management](../../../prd/03-user-flows.md) |
| **Design refs** | `docs/plan/design/14-garage-s07-s09.md` + `docs/claude-session/design/16-design-step14-garage.md`, exports `design/pencil/exports/step14/` |
| **Depends on** | Step 07 (`GarageRepository`), 09 (booking check for delete-blocked), 10 |
| **Claude session** | `docs/claude-session/apps/22-mobile-step21-garage-s07-s09.md` (written after approval) |

## Goal

Motor CRUD: list, add/edit form, detail + service history + delete. Also replaces every placeholder route S10 (step 13)/S05 (step 12) left pointing here ("+ Tambah motor lain", "+" tile, motor card taps).

## Inputs

- PRD 04 S07–S09 content/states; PRD 03 F5 (delete-blocked-while-in-service dialog).
- Design step 14 file + session log — one add-action-only rule (header "+", hidden while empty), model picker (bottom sheet), plate auto-format + duplicate error, danger-ghost delete placement.
- `GarageRepository`, the cross-repo "has active booking" check resolved in step 07.

## Open questions (ask at kickoff)

1. Confirm the "add-motor" entry points from steps 12/13 (S05 "+" tile, S10 "+ Tambah motor lain") now route to this step's real `S08` page and — per PRD 03 — return the user to their origin screen with the new motor available (not auto-selected), with the "Motor ditambahkan" snackbar.
   - **Answered (2026-09-29):** yes. S10 already diffed the motor count and showed the snackbar; S05 did not (no await/refresh) → fixed in this step (S05 awaits the push, refreshes the Home garage strip, shows the snackbar from the pop result).

### Kickoff decisions (interview 2026-09-29)

- **Photo:** real `image_picker` (Kamera / Galeri / Hapus foto); the picked file is copied to `<app docs>/motor_photos/` and the path stored in `Motor.photoUrl`; S09 `MotorHero` renders it (silhouette fallback). List/Home cards stay silhouette-only (design has no photo slot).
- **Edit from S09:** save returns to S09, which reloads and shows "Perubahan disimpan".
- **S10 pre-select:** included — "Booking motor ini" → `Routes.bookingVehicles` with `extra: motorId` → `BookingDraftViewModel.preselectMotor`.
- **S05 entries:** fixed (await push → `homeViewModel.refresh()` → snackbar).

## Scope

### Files / classes to build

`garage/presentation/di/garage_presentation_module.dart`.

`garage/presentation/garasi/` — `garasi_page.dart`, `garasi_view_model.dart`, `state/garasi_state.dart`.

`garage/presentation/motor_form/` — `motor_form_page.dart` (add/edit), `motor_form_view_model.dart`, `components/motor_model_picker.dart`, `components/motor_photo_field.dart`, `state/motor_form_state.dart`.

`garage/presentation/motor_detail/` — `motor_detail_page.dart`, `motor_detail_view_model.dart`, `components/motor_hero.dart`, `components/motor_details_card.dart`, `components/service_history_row.dart`, `state/motor_detail_state.dart`.

### Tests to write

- `test/garage/presentation/garasi/garasi_view_model_test.dart` — empty vs. populated; header "+" hidden when empty.
- `test/garage/presentation/motor_form/motor_form_view_model_test.dart` — plate auto-format + duplicate rejection; nickname 20-char cap; dirty-cancel dialog fires only when the form has unsaved changes; save always-enabled/validate-on-submit.
- `test/garage/presentation/motor_detail/motor_detail_view_model_test.dart` — "Booking motor ini" disabled + reason when in service; delete blocked with the explanatory dialog when an active booking exists.

## Checklist

### Build
- [x] Open questions answered.
- [x] S07 built for loading/empty/populated; S08 built for add-default/edit-prefilled/validation-error/keyboard/saving/save-error/model-picker/dirty-cancel; S09 built for populated-in-service/free-motor-empty-history/delete-confirm/delete-blocked.
- [x] `/garage`, `/garage/add`, `/garage/:id` routes wired; S05/S10 placeholder add-motor entries replaced.

### Quality (flutter analyze / format / tests)
- [x] `flutter analyze` → 0 issues.
- [x] `dart format --set-exit-if-changed .` → clean.
- [x] `flutter test test/garage/` → green (full suite: 544 passing).
- [x] Screenshots vs. `design/pencil/exports/step14/*.png` — compared via widget-test renders, then all screens tested by the user on device.

### Review gate
- [x] Status 🔵; show the user all 3 screens (all states) + test results.
- [x] Review round logged; approval recorded.

### Close (only after approval)
- [x] Commit message proposed: `031 - Create Garage Screens (S07, S08, S09)`.
- [x] Claude session file written (`docs/claude-session/apps/22-mobile-step21-garage-s07-s09.md`).
- [x] Tracker in `00-index.md` set to ✅.

## Review rounds

- Round 1 (2026-09-29): user tested all screens on device — "i test all and well done, approve do the rest except commit push". Two follow-ups: (a) IDE showed `package:image_picker` unresolved — CLI `pub get`/analyze were clean, so it was a stale IDE analysis server (restart it); (b) Home "Lihat semua" (Garasi section, and the active-bookings "Lihat semua") used `context.push` on a shell-tab route, so the bottom nav did not select the tab → changed to `context.go`. Approved.

### Known gaps / notes for the reviewer
- Motor silhouette art (design step 04) is not in the Flutter app yet → S07/S08/S09 show the same `two_wheeler` icon placeholder as the existing cards.
- Photo picker (camera/gallery/remove) and permission-denied path are implemented but not exercised on a device. Project has no `ios/` folder; Android needs no extra manifest entry for `image_picker`.
- Dialog body copy for dirty-cancel/empty-search is provisional; blocked-delete copy taken from the design PNG.
- "Lacak servis" and every history row → `Routes.bookingDetail` (S20); "Lihat semua" → `Routes.bookings` with `extra: motorId` (TODO for step 22 to consume). All three are still `Placeholder`s until step 22.
- Tablet layouts (S07 grid variants beyond column count, S08 preview pane, S09 two-column) belong to step 27.
- Home garage strip only refreshes when the flow started from S05; adding/editing/deleting from the Garasi tab leaves Home stale until pull-to-refresh (same cross-tab pattern as elsewhere in the app).

## Session log

| Time | Action | Result |
|---|---|---|
| 2026-09-29 | Explored data/design/presentation conventions with grepai + 3 explore agents; planned; interview (photo scope, edit landing, S10 preselect, S05 entries) | Plan approved |
| 2026-09-29 | Core additions: `TsDialog.blockedAction` 2nd action, `VehicleSelectCard` wide layout + caption, `TsTextField` readOnly/onTap, `TsButton.dangerGhost`, `PlateNumberFormatter`, `PhotoPickerService`, `SectionTitleRow` moved to core, `GarageMotorResult` in `app/navigation` | analyze clean |
| 2026-09-29 | Garage presentation (S07/S08/S09 pages, view models, states, components, DI), router, S10 `preselectMotor`, S05 entry handlers | analyze clean |
| 2026-09-29 | Tests: 3 view-model suites, plate formatter, navigation/flow widget tests, phone layout matrix (overflow), `preselectMotor` | 544/544 green |
| 2026-09-29 | Rendered screens in widget tests vs step-14 PNGs; aligned hero tint, history rows, blocked-dialog copy, S07 captions, form helpers | Matches design except silhouette art |
