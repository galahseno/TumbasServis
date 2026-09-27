# Step 12 — S05 Beranda (Home) + real AppShell wiring

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Layer** | Presentation, phone |
| **Priority** | P0 |
| **Owns** | `home/presentation/` (S05), real `AppShell` Beranda-tab content |
| **PRD refs** | [04 S05](../../../prd/04-screens.md), [03 F2/F3 entry points](../../../prd/03-user-flows.md) |
| **Design refs** | `docs/plan/design/05-s05-home.md` + `docs/claude-session/design/07-design-step05-s05-home.md`, exports `design/pencil/exports/step05/` |
| **Depends on** | Steps 07 (garage/catalog data), 08 (booking data, for active/draft cards), 09 (notification unread count), 10 (shell/theme/components) |
| **Claude session** | `docs/claude-session/apps/13-mobile-step12-home-s05.md` (written after approval) |

## Goal

Build the app's entry screen: greeting, primary booking CTA, active-booking card(s), draft-resume card, promo carousel, garage strip, quick links — all wired to real repositories (no more placeholder shell content).

## Inputs

- PRD 04 S05 content/states; PRD 03 F2 (draft resume, entry points), F3 (active-booking card → S20 tap target).
- Design step 05 file + session log — 16 kickoff decisions verbatim (status-label rule, `FleetProgress` mini, stacked active-booking cards max 2, promo carousel behavior with **no** pause/play button per the design review, `DraftResumeCard` copy).
- Repositories: `GarageRepository`, `CatalogRepository` (promos), `BookingRepository` (active booking + draft), `NotificationRepository` (unread count).

## Open questions (ask at kickoff)

1. Status-label derivation (design decision 14: "label = the unit status shared by most motors, ties → earliest stage") — confirm this lives as a small pure function in `home/presentation/home_view_model.dart` or is promoted to `core/domain/service/` since S20 might reuse similar logic later (recommend: keep local to Home for now: PRD 03 explicitly says S20's derived `BookingStatus` is a *different* concept from this display label; only promote if step 22 needs the exact same function).
2. Promo carousel auto-advance (5s, pause on touch/focus/hover, off under `MediaQuery.disableAnimations`) — a `PageView.builder` + `Timer.periodic`, confirm reduced-motion detection reads `MediaQuery.disableAnimationsOf(context)`.

## Scope

### Files / classes to build

`home/presentation/di/home_presentation_module.dart` — `homeViewModelProvider`.

`home/presentation/home/` — `home_page.dart` (rendered inside `AppShell`'s Beranda slot), `home_view_model.dart` (loads garage + active booking + draft + promos + unread count in parallel), `state/home_state.dart` (loading/empty/populated + the derived fields: status label, caption).

`home/presentation/home/components/` — `active_booking_card.dart`, `draft_resume_card.dart`, `booking_cta_card.dart` (compact/hero), `quick_link_tile.dart`, `section_title_row.dart`, `garage_add_tile.dart`, `promo_carousel.dart`.

### Content & copy notes

"Halo, Galah 👋", "Booking servis motor" / "Mulai booking", "Servis banyak motor, sekali booking.", "Garasi saya" / "Lihat semua", "Riwayat", "Katalog suku cadang" — verbatim from the design's canonical demo content (booking `TS-260929-0417`, "3 motor · Dikerjakan", "1 motor masih Diperiksa" — lower-case per design step 19's fix F9).

### Tests to write

- `test/home/presentation/home/home_view_model_test.dart` — empty state (no active booking, no draft); populated state derives the correct status label + caption from the canonical 3-unit booking (A/B Dikerjakan, C Diperiksa → "3 motor · Dikerjakan" + caption); draft-expiry warning color switches under 3h (`FakeClock`).
- Widget test: tapping the active-booking card navigates toward `/bookings/:id` (S20 route — even if S20 itself is a placeholder until step 22, verify the navigation *intent* fires).

## Checklist

### Build
- [ ] Open questions answered.
- [ ] S05 built for loading/empty/populated (+ 1-motor/long-name variant if time allows — P0 screen, all PRD 04 states).
- [ ] `AppShell` Beranda slot now renders real content; other 3 tabs remain placeholders.
- [ ] Bell badge reflects real unread count from `NotificationRepository`.

### Quality (flutter analyze / format / tests)
- [ ] `flutter analyze` → 0 issues.
- [ ] `dart format --set-exit-if-changed .` → clean.
- [ ] `flutter test test/home/` → green.
- [ ] Manual run: fresh seed shows the canonical populated state; screenshots vs. `design/pencil/exports/step05/*.png`.

### Review gate
- [ ] Status 🔵; show the user the screen (all states) + test results.
- [ ] Review round logged; approval recorded.

### Close (only after approval)
- [ ] Commit message proposed: `022 - Create Home Screen`.
- [ ] Claude session file written (`docs/claude-session/apps/13-mobile-step12-home-s05.md`).
- [ ] Tracker in `00-index.md` set to ✅.

## Review rounds

## Session log

| Time | Action | Result |
|---|---|---|
