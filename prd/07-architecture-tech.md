# 07 — Architecture & Tech Stack

This file is written to plug directly into the project's local Claude skills when generating the Flutter implementation plan:

- [flutter-clean-architecture](../.claude/skills/flutter-clean-architecture/SKILL.md) — layer map, dependency rule, `Result<T>` contract, DI wiring.
- [flutter-domain-layer](../.claude/skills/flutter-domain-layer/SKILL.md) — pure-Dart entities, repository interfaces.
- [flutter-data-layer](../.claude/skills/flutter-data-layer/SKILL.md) — mock services, DTOs/mappers, repository impls.
- [flutter-presentation-layer](../.claude/skills/flutter-presentation-layer/SKILL.md) — screen folders, Notifier ViewModels, freezed state, presentation DI.

Conventions below intentionally match those skills exactly — feature-first folders, `presentation → domain ← data` dependency rule, `Result<T>` defined once in `core/domain/model/`, ViewModels calling repository interfaces directly via `ref.read(...)` (no use-case layer unless a feature genuinely needs multi-repository orchestration), one centralized DI module per feature per layer, `always_use_package_imports`.

## Feature map

```
lib/
├── app/                    # bootstrap, MaterialApp.router, theme (light/dark from 02), navigation/router.dart
├── core/
│   ├── data/                # mock JSON loader, simulated-latency helper, local storage (session/theme/bookings), demo-mode controller
│   ├── domain/               # Result<T>, shared entities promoted here: Motor, MotorModel, Workshop, ServiceType, Part, Booking, BookingUnit, Voucher, Mechanic, Invoice, Review, AppNotification, Promo
│   └── presentation/          # design system widgets (TsButton, TsTextField, TsChip, WorkshopCard, PriceBreakdown, StatusTimeline, TicketCard, NavBar/NavRail, EmptyState, ErrorState, Skeleton, TsLogo, …), responsive/breakpoint utils, formatters (currency/date), l10n
├── auth/                    # S01–S04: splash, onboarding, login, OTP
├── home/                    # S05
├── garage/                  # S07–S09
├── workshop/                # S13–S14
├── catalog/                 # S12 + service/part browsing shared with booking
├── booking/                 # S10, S11, S15, S16, S17, S18 — the core flow, incl. BookingDraft keep-alive state
├── tracking/                 # S20, S21, S22 + TrackingSimulator wiring
├── invoice/                  # S23
├── review/                   # S24
├── notification/             # S06
└── profile/                  # S25, S26
```

Shared entities (Motor, Workshop, Booking, etc.) live in `core/domain/model/` rather than any single feature's `domain/`, since booking/tracking/garage/invoice all reference them — this follows the skill's "cross-feature interfaces/entities go to `core/`" rule, avoiding feature-to-feature imports.

## Booking draft state

The booking flow (S10→S18) is one continuous domain object (`BookingDraft`). Its Notifier is **not** `.autoDispose` — it's scoped to survive navigation across S10–S17 (a `ProviderScope` boundary around the booking route sub-tree, or a non-autoDispose provider explicitly disposed on flow exit/completion), matching the skill's guidance that state needing to survive navigation is the deliberate exception to `.autoDispose`. Each step screen (S10ViewModel, S11ViewModel, …) reads/mutates the shared draft via `ref.read(bookingDraftProvider.notifier)` rather than duplicating state.

## Routing

`go_router`, exposed as `routerProvider`, consumed by `MaterialApp.router`. Global `redirect` gates on session (`SessionRepository.currentUser()` — no session → `/login`, except `/splash` and `/onboarding`).

| Path | Screen |
|---|---|
| `/splash` | S01 |
| `/onboarding` | S02 |
| `/login` | S03 |
| `/otp` | S04 |
| `/home` | S05 (shell: bottom nav / rail) |
| `/notifications` | S06 |
| `/garage`, `/garage/add`, `/garage/:id` | S07, S08, S09 |
| `/booking/vehicles` | S10 |
| `/booking/configure` | S11 (+ `/booking/configure/parts` sheet route → S12) |
| `/booking/workshop`, `/booking/workshop/:id` | S13, S14 |
| `/booking/schedule` | S15 |
| `/booking/summary`, `/booking/summary/voucher` | S16, S17 |
| `/booking/success/:bookingId` | S18 |
| `/bookings` | S19 |
| `/bookings/:id` | S20 |
| `/bookings/:id/unit/:unitCode` | S21 |
| `/invoice/:bookingId` | S23 |
| `/review/:bookingId` | S24 |
| `/profile`, `/profile/demo-mode` | S25, S26 |

`/home`, `/bookings`, `/garage`, `/profile` are the four `StatefulShellRoute` branches behind the bottom `NavBar`/`NavigationRail`.

## Tech stack

Reference implementation, matching the skills' reference stack and the Flutter SDK already installed locally (Flutter 3.44.0 stable). Exact package versions are resolved at Flutter-plan/scaffold time (latest stable compatible with the installed SDK) rather than pinned here, so the PRD doesn't go stale:

- **State/DI:** `flutter_riverpod` (Notifier-based, per the presentation skill).
- **Immutability:** `freezed` + `freezed_annotation`, `json_serializable` (DTOs only — domain stays annotation-free), `build_runner`.
- **Routing:** `go_router`.
- **Localization/formatting:** `intl` (+ Flutter's `gen-l10n` if/when an EN toggle is added later — v1 ships `id` only per the locked decision).
- **Local persistence:** `shared_preferences` (session flag, theme mode, demo-mode flag) + a structured local store (`hive_ce` or equivalent) for garage/bookings/notifications lists.
- **QR:** `qr_flutter` for the S18 ticket code.
- **External intents:** `url_launcher` (S14 "Buka di Maps").
- **Vector/icons:** `flutter_svg` if any brand SVGs are used (logo, illustrations); otherwise Material Symbols/Phosphor icon font.
- **App branding tooling:** `flutter_native_splash`, `flutter_launcher_icons`, driven off the assets/tokens in [02](02-brand-design-system.md).

## Quality gates

- `flutter analyze` clean (no warnings) before each milestone commit.
- Unit tests (domain, pure Dart, no mocks needed) for: pricing/discount math, fleet-duration makespan calculation, per-unit validation (required service/complaint), "Salin dari" compatibility filtering, slot-capacity checks (shared vs. split), voucher eligibility, booking/unit status derivation.
- Widget tests: S11 multi-unit config (chip switching preserves state, "Lanjut" gating), and layout tests at the [06](06-responsive-layout.md) device matrix sizes for S05/S11/S16/S18 to catch overflow regressions.

## Android build

- Application ID: `com.galahseno.tumbasservis`.
- `minSdkVersion`/`targetSdkVersion`: Flutter 3.44.0 defaults (verify against `flutter doctor`/`android/app/build.gradle` at scaffold time).
- Release signing: a local, **non-committed** keystore (`.gitignore`'d), referenced via `key.properties` (also gitignored, with a `key.properties.example` committed for README instructions).
- Output: `flutter build apk --release` → uploaded to GitHub Releases (and/or Google Drive) per [08](08-deliverables-acceptance.md).
