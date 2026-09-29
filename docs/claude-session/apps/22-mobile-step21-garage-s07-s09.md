# Claude Session Log — 22: Mobile-app step 21 — Garage S07, S08, S09

**Tool:** Claude Code, model Claude Sonnet 5.5 (Sonnet 5 in plan mode)
**Date:** 2026-09-29
**Topic:** Build the garage presentation layer — Garasi saya (S07), Tambah/Ubah motor (S08), Detail motor (S09) — and replace every placeholder route/entry that pointed at them.

## Initial prompt

"i want to do docs/plan/mobile-app/21-xx, interviewme with detail if need, use grepai to explore codebase". Follow-ups after review: "i test all and well done, approve do the rest except commit push"; IDE showed `image_picker` unresolved; "from home click lihat semua in garasi section, bottom nav not in the garasi selected state, fix this too".

## Research performed

- `grepai` (already indexed) plus three read-only explore agents: garage data layer + booking check, PRD/design specs for S07–S09, and presentation conventions; a Plan agent designed the implementation.
- Confirmed: `GarageRepository` has 5 methods and only plain `Exception` errors (duplicate plate is the sole add/update failure); "in service" = a booking unit with `!status.isTerminal`, derived per screen from `BookingRepository.getBookings()` (same shape as `BookingDraftViewModel`); no photo picker existed; S19/S20/S22 are not built yet.
- Compared widget-test renders against `design/pencil/exports/step14/*.png` and aligned hero tint, history rows, S07 captions, form helper text and blocked-dialog copy.

## Clarifying interview

1. **Photo field** — real `image_picker` (camera / gallery / remove), path stored in `Motor.photoUrl`.
2. **Edit from S09** — save returns to S09 (reload + "Perubahan disimpan"), not S07.
3. **S10 pre-select** — include now (`preselectMotor`), touching booking files.
4. **S05 entries** — fix now (await push, refresh Home, snackbar).

## Execution

- **Shared:** `TsDialog.blockedAction<T>` optional second action; `VehicleSelectCard` `wide` layout + `caption`; `TsTextField` `readOnly`/`onTap`; `TsButton.dangerGhost`; `PlateNumberFormatter`; `PhotoPickerService` (+ provider); `SectionTitleRow` moved home → core; `GarageMotorResult` in `app/navigation`.
- **S07:** `GarasiViewModel` (motors + models + in-service map), responsive 1/2/3-col list, header "+" hidden when empty, empty-state CTA.
- **S08:** `MotorFormViewModel` (validate on blur/submit, focus order nickname→model→plate→year, dirty tracking, duplicate plate → inline error, photo pick/remove), `MotorModelPicker` (sheet on phone / centered modal on tablet, pinned brand headers, search), `MotorPhotoField`, dirty-cancel via `PopScope` (Buang = discard, Lanjut mengisi = stay).
- **S09:** `MotorDetailViewModel` (motor, model, service names, active booking, past history), hero/details/history components, disabled "Booking motor ini" + "Lacak servis", blocked vs confirm delete dialogs.
- **Wiring:** routes replaced in `router.dart`; S10 pre-selects via `extra`; S05 entries refresh Home and show snackbars; S08/S09 invalidate `garasiViewModelProvider` after mutations.
- **Post-review fixes:** Home "Lihat semua" (Garasi + active bookings) use `context.go` so the bottom nav selects the tab; IDE `image_picker` error was a stale analysis server (`pub get`/analyze were clean).

Tests: 3 garage view-model suites, `PlateNumberFormatter`, navigation/flow widget tests (add/edit/discard/delete pop results), phone layout matrix (overflow at ×1.0/×1.3), `preselectMotor`. `flutter analyze` 0 issues; `dart format` clean; `flutter test` 544/544.

## Review rounds

- Round 1 (2026-09-29): user tested all screens — approved, with the Home tab-selection fix above.

## Key decisions worth flagging to a reviewer

- Motor silhouette art is not in the app yet (placeholder icon everywhere); design's `MotorPreviewPane` and tablet layouts are step 27.
- "Lacak servis" and all history rows → `Routes.bookingDetail` (S20); "Lihat semua" → `Routes.bookings` with `extra: motorId` — step 22 must consume it (TODO left in `motor_detail_page.dart`). S09's "Lihat semua" still uses `push`; step 22 should decide whether it should `go` to the Riwayat tab.
- Blocked-delete copy comes from the design PNG; dirty-cancel and empty-search body copy is provisional.
- Any `Error` from add/update is treated as duplicate plate (only domain failure); a missing session user shows the save-error banner.
- Home's garage strip refreshes only for flows started from S05; changes from the Garasi tab need pull-to-refresh on Home.
- Project has no `ios/` folder, so no `Info.plist` change; `image_picker` also touched `pubspec.lock` and the macOS plugin registrant.

## Output

Tracker set to ✅ in `00-index.md`. Commit message proposed: `031 - Create Garage Screens (S07, S08, S09)`. Not committed or pushed. Next: step 22 — Tracking S19–S22.
