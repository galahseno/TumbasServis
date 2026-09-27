# Step 21 — S07 Garasi Saya, S08 Tambah/Edit Motor, S09 Detail Motor

| | |
|---|---|
| **Status** | ⬜ Not started |
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
- [ ] Open questions answered.
- [ ] S07 built for loading/empty/populated; S08 built for add-default/edit-prefilled/validation-error/keyboard/saving/save-error/model-picker/dirty-cancel; S09 built for populated-in-service/free-motor-empty-history/delete-confirm/delete-blocked.
- [ ] `/garage`, `/garage/add`, `/garage/:id` routes wired; S05/S10 placeholder add-motor entries replaced.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test test/garage/` → green.
- [ ] Screenshots vs. `design/pencil/exports/step14/*.png`.

### Review gate
- [ ] Status 🔵; show the user all 3 screens (all states) + test results.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `031 - Create Garage Screens (S07, S08, S09)`.
- [ ] Claude session file written (`docs/claude-session/apps/22-mobile-step21-garage-s07-s09.md`).
- [ ] Tracker in `00-index.md` set to ✅.

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
