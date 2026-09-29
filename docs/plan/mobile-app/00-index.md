# TumbasServis — Mobile App Implementation Plan (Flutter)

## Purpose

Step-by-step execution plan for the Flutter implementation of **TumbasServis**, built from [`prd/`](../../../prd/00-index.md) and the four local skills (`.claude/skills/flutter-clean-architecture`, `-domain-layer`, `-data-layer`, `-presentation-layer`). Designs are already approved in Pencil (`docs/plan/design/`, steps 01–19, all ✅); this plan turns them into working code. Figma conversion (design steps 20–21) stays deferred until after this app is built.

Every step follows the same loop: **kickoff (read refs, ask open questions) → build → self-check → quality gate → review gate → session log**, and only after the user approves does it write a `docs/claude-session/apps/` file. The user commits; Claude never commits (matches the design phase).

Primary PRD inputs: [05 domain model & mock data](../../../prd/05-data-model-mock.md), [07 architecture & tech](../../../prd/07-architecture-tech.md), [04 screens](../../../prd/04-screens.md), [06 responsive layout](../../../prd/06-responsive-layout.md), [02 brand & design system](../../../prd/02-brand-design-system.md), [03 user flows & business rules](../../../prd/03-user-flows.md), [08 deliverables & acceptance](../../../prd/08-deliverables-acceptance.md). Design source of truth for pixel-parity and copy: [`docs/plan/design/00-index.md`](../design/00-index.md) (conventions, canonical demo content) and the per-screen `docs/claude-session/design/*.md` logs + `design/pencil/exports/stepNN/*.png`.

## How to run a step

Start a session with: *"Run mobile-app step NN — follow `docs/plan/mobile-app/NN-<name>.md` and the workflow in `00-index.md`."* One step per session keeps context small and the session log clean. Steps run in numeric order; each lists its dependencies. Domain and data steps (02–09) have no visual review — the "review gate" there means the user reads the code/tests and replies approve/changes, same mechanism, different evidence.

## Decision log

Locked in the planning interview (2026-09-27):

| Topic | Decision |
|---|---|
| Layer order | **Domain → Data → Presentation** (the skill's dependency-safe touch order — entities/interfaces exist before anything implements or renders them), supersedes the literal "data, domain, presentation" phrasing of the original ask |
| Project location | Flutter project at the **repo root** (next to `prd/`, `docs/`, `design/`); Dart package name **`tumbas_servis`** (`package:tumbas_servis/...`); Android `applicationId` stays `com.galahseno.tumbasservis` (PRD 07, independent of the Dart package name) |
| Repository placement (hybrid) | Every repository **interface** lives in `core/domain/repository/` (all 10 are read cross-feature in practice). Every repository **implementation** lives in its **owning feature's** `data/repository/` — not centralized in `core/data/`. See the concrete map in *Conventions* below |
| Shared infra | Mock JSON loader, simulated-latency helper, local storage wrapper, `DemoModeController`, `TrackingSimulator` (consumed by 2+ features: tracking + profile) live in `core/data/service/` |
| Commits | The user commits (as in the design phase); Claude never commits. Each step's *Close* proposes a `"NNN - <Title>"` commit message, continuing the existing history from `010 -` |
| Presentation order | **Mobile portrait for every screen (P0 then P1) is built and hardened before any tablet work starts.** Tablet portrait + landscape is a distinct later phase (steps 26–27), explicitly scoped as bonus per `prd/01-overview.md` / `prd/08` |
| State coverage | P0 screens implement every PRD 04 state in their phone step; P1 screens implement default + empty + one loading/error state in their phone step (mirrors the design plan's own P0/P1 split) |
| Testing gates | Domain = pure unit tests, no mocks. Data = repository tests against fakes of the service layer (`Result` plumbing, latency, one-shot error injection). Presentation = widget tests for gating/validation-heavy screens + layout tests at the PRD 06 phone sizes (+ ×1.3 text scale); tablet sizes are tested in steps 26–27 |
| Claude-session numbering | `docs/claude-session/apps/NN-mobile-stepMM-<slug>.md` where `NN = MM + 1` (this planning session occupies slot 01, so step 01's log is 02, step 02's is 03, … step 28's is 29) — mirrors the `docs/claude-session/design/` offset |
| Doc layout | This index + one file per step (28 steps) |

## Conventions

Grounded in `.claude/skills/flutter-clean-architecture/SKILL.md` and its three companions. Read that skill first if a step feels ambiguous about *where something goes*.

### Folder skeleton (feature-first)

```
lib/
├── main.dart                    # thin: main() => bootstrap()
├── bootstrap.dart
├── app/
│   ├── app.dart                  # MaterialApp.router
│   ├── app_theme.dart            # ColorScheme + TsThemeExtension, light/dark (PRD 02)
│   └── navigation/router.dart    # go_router route table + redirects (PRD 07 route table)
├── core/
│   ├── domain/
│   │   ├── model/                 # Result<T> (root) + all ~19 shared entities/enums, grouped into
│   │   │                          #   concept subfolders (see "Grouping folders" below)
│   │   ├── repository/            # ALL 10 repository interfaces (see map below)
│   │   └── service/                # Clock port, cross-feature business-rule services
│   ├── data/
│   │   ├── service/                # MockJsonLoader, simulateLatency, LocalStore, DemoModeController, TrackingSimulator
│   │   └── di/                      # core_data_module.dart
│   └── presentation/
│       ├── components/             # TsButton, TsTextField, TsChip, TsAppBar, TsDialog, TsSnackbar, EmptyState, ErrorState, Skeleton, NavBar/NavRail, TsLogo, …
│       ├── di/                      # core_presentation_module.dart
│       └── utils/                   # responsive/breakpoint utils (steps 26+), formatters (currency/date)
├── auth/          # S01–S04 — data/ (SessionRepositoryImpl) + presentation/
├── home/          # S05 — presentation/ only
├── garage/        # S07–S09 — data/ (GarageRepositoryImpl) + presentation/
├── workshop/       # S13–S14 — data/ (WorkshopRepositoryImpl) + presentation/
├── catalog/        # S12 (+ shared with booking) — data/ (CatalogRepositoryImpl) + presentation/
├── booking/        # S10, S11, S15–S18 — data/ (BookingRepositoryImpl) + presentation/ + BookingDraft keep-alive state
├── tracking/        # S19–S22 — data/ (TrackingRepositoryImpl) + presentation/
├── invoice/          # S23 — data/ (InvoiceRepositoryImpl) + presentation/
├── review/            # S24 — data/ (ReviewRepositoryImpl) + presentation/
├── notification/       # S06 — data/ (NotificationRepositoryImpl) + presentation/
└── profile/             # S25, S26 — data/ (SettingsRepositoryImpl) + presentation/
```

A feature gets a `domain/` folder only if it needs a rule genuinely local to it (rare — most business rules are cross-feature and live in `core/domain/service/`); most features here have only `data/` + `presentation/`.

### Grouping folders (adopted step 02, applies to every step from here on)

Any folder that would otherwise collect many small files for one step (a model/entity dump, a repository-interface dump, a components dump, …) gets **concept subfolders** instead of a flat file list — one subfolder per domain concept, holding a class's hand-written/freezed `.dart` file together with its own `.freezed.dart`/`.g.dart`. Subfolder names track the owning feature area from the tree above where one exists (`garage/`, `workshop/`, `catalog/`, `booking/`, `invoice/`, `review/`, `notification/`) even though the folder itself stays under `core/` (cross-feature) — e.g. `core/domain/model/garage/motor.dart`. A concept with no matching feature keeps its own name (`user/`, `result.dart` stays at `core/domain/model/` root — it's the one type every layer imports, not owned by any concept). Tests mirror the same subfolders under `test/`. Apply this whenever a step is about to produce "much class and freezed in one package folder" (step 02's `model/`, and — expected to recur — step 03's `repository/`, later component-heavy presentation steps); a step with only a couple of files stays flat.

### Repository placement map (interface → owning feature's impl)

| Interface (`core/domain/repository/`) | Impl lives in | Data step |
|---|---|---|
| `SessionRepository` | `auth/data/repository/session_repository_impl.dart` | 06 |
| `SettingsRepository` | `profile/data/repository/settings_repository_impl.dart` | 06 |
| `GarageRepository` | `garage/data/repository/garage_repository_impl.dart` | 07 |
| `CatalogRepository` | `catalog/data/repository/catalog_repository_impl.dart` | 07 |
| `WorkshopRepository` | `workshop/data/repository/workshop_repository_impl.dart` | 08 |
| `BookingRepository` | `booking/data/repository/booking_repository_impl.dart` | 08 |
| `TrackingRepository` | `tracking/data/repository/tracking_repository_impl.dart` | 09 |
| `InvoiceRepository` | `invoice/data/repository/invoice_repository_impl.dart` | 09 |
| `ReviewRepository` | `review/data/repository/review_repository_impl.dart` | 09 |
| `NotificationRepository` | `notification/data/repository/notification_repository_impl.dart` | 09 |

DI wiring for each still lives in that feature's `data/di/<feature>_data_module.dart` (interface-typed provider), per the skill — the interface's *location* (core) doesn't move where it's *wired*.

### Repository-interface method skeleton (from PRD 05 + 03)

Each interface below returns `Result<T>` / `Result<List<T>>` / a `Stream` per the domain-layer skill. Written in full in step 03; listed here so later steps don't re-derive signatures:

- `SessionRepository`: `login(phone)`, `verifyOtp(code)`, `logout()`, `currentUser()`
- `SettingsRepository`: `getThemeMode()`, `setThemeMode(mode)`, `isDemoModeEnabled()`, `setDemoMode(...)`
- `GarageRepository`: `getMotors()`, `addMotor(motor)`, `updateMotor(motor)`, `deleteMotor(id)`, `getMotorModels()`
- `CatalogRepository`: `getServiceTypes()`, `getParts({modelId})`, `getVouchers()`, `getPromos()`
- `WorkshopRepository`: `getWorkshops({filter})`, `getWorkshop(id)`, `getAvailableSlots(workshopId, date)`
- `BookingRepository`: `createDraft()`, `updateDraft(draft)`, `confirmBooking(draft)`, `getBookings({status})`, `getBooking(id)`, `cancelBooking(id, {unitCode?})`, `rescheduleBooking(id, newSlots)`
- `TrackingRepository`: `watchUnitStatus(bookingId, unitCode)`, `advanceUnitStatus(...)`, `resetUnitStatus(...)`
- `InvoiceRepository`: `getInvoice(bookingId)`, `markPaid(bookingId)`
- `ReviewRepository`: `submitReview(review)`, `getReview(bookingId)`
- `NotificationRepository`: `getNotifications()`, `markRead(id)`, `watchUnreadCount()`

### Domain services (`core/domain/service/`, step 03)

| Service | Rule (PRD 03) |
|---|---|
| `Clock` (port) | Abstracts "now" so D+0 slot cutoffs / open-hours / countdowns are unit-testable; real impl in `core/data/service/system_clock.dart` |
| `PricingCalculator` | Per-unit subtotal → fleet subtotal → voucher discount line → total; everything labeled an estimate |
| `FleetDurationCalculator` | Shared-slot makespan across a workshop's parallel bays (not naive sum); split-mode per-unit duration |
| `UnitConfigValidator` | ≥1 service per unit; complaint mandatory when the service `requiresComplaint`; 250-char cap |
| `SalinDariCompatibilityFilter` | Copies services + compatible parts between units; drops + reports incompatible parts |
| `SlotCapacityService` | Shared-slot capacity ≥ unit count; split-mode remaining-after-siblings; chip precedence `short > limited > available` |
| `VoucherEligibilityService` | `minUnits` / `minSubtotal` / `validUntil` checks + the "kurang Rp…" shortfall message |
| `BookingStatusDerivation` | Unit status machine (forward-only + cancel branch) and the derived booking-level status |

### Per-step workflow

1. **Kickoff** — read the step's PRD refs + the matching `docs/plan/design/` step file and `docs/claude-session/design/` log (for screens: exact copy, demo numbers, node/frame layout); ask the user (`AskUserQuestion`) the step's *Open questions*. Set status 🟡.
2. **Build** — write code bottom-up per the clean-architecture skill's touch order (domain → data → presentation within the step's own scope); run `build_runner` after any `@freezed`/`@JsonSerializable` file.
3. **Self-check** — `flutter analyze` (zero issues), `dart format --set-exit-if-changed`, run the step's tests.
4. **Quality gate**:
   - Domain/data steps: unit/repository tests green; import-direction check (`grep -rn "package:flutter/" lib/*/domain/` → empty; no `data/` import under `presentation/`, no DTO leaking past a repository impl).
   - Presentation steps: run the app (`run` skill or `flutter run`/an emulator), screenshot each new screen/state, compare against `design/pencil/exports/stepNN/*.png` (the step file names which design step's exports to use) for spacing/color/type parity (PRD 08 M2).
5. **Session log** — timestamped rows as work happens.
6. **Review gate** — status 🔵; give the user the file list (+ screenshots for presentation steps) and what changed; user replies *approve* or *changes*. Log each round. Loop until approved.
7. **Close** — only after approval: propose a commit message (`"0NN - <Title>"`); write the `docs/claude-session/apps/` file; status ✅; update the tracker below. No commit by Claude.

### Naming & style

- `always_use_package_imports` (full `package:tumbas_servis/...` imports), matching the skill.
- One class per file, named after the class; folders lowercase snake_case.
- Widgets/components use the `Ts`/PRD-02 name 1:1 (`TsButton`, `VehicleSelectCard`, `WorkshopCard`, …) — same names as the Pencil components, so design ↔ code mapping stays obvious.
- Screen folders follow the presentation skill exactly: `<feature>/presentation/<screen>/` with `_page.dart`, `_view_model.dart`, `components/`, `state/<screen>_state.dart`.
- Copy is pulled verbatim from `prd/04-screens.md` / the design plan's canonical demo content — no placeholder/lorem text, matching the design phase's own rule.

### State-coverage & tablet-deferral rule

P0 screens (S03 entry, S05, S10, S11, S13, S15, S16, S18) implement every PRD 04 state in their phone step. P1 screens implement default + empty + one loading/error state in their phone step; any remaining PRD-04-listed state is a noted follow-up, not a blocker. **No tablet layout code is written before step 26** — phone-portrait `MediaQuery` assumptions are fine in steps 10–25; responsive breakpoints are introduced deliberately in step 26.

### Automated checks (run every step)

- `flutter analyze` → 0 issues.
- `dart format --set-exit-if-changed .` → clean.
- `flutter test` (unit + widget, scoped to the step's files at minimum, full suite before a hardening step closes).
- Layer-direction grep: `grep -rln 'package:flutter/' lib/*/domain/ lib/core/domain/` → empty; `grep -rln 'package:tumbas_servis/[a-z_]*/data/' lib/*/presentation/ lib/core/presentation/` → empty.

## Canonical demo content (do not re-derive — copy from the design plan)

All mock data, seed values, and screen copy **must match** [`docs/plan/design/00-index.md` → *Canonical demo content*](../design/00-index.md) exactly (booking `TS-260929-0417`, the 16-model garage, the 5-workshop list, the 4 vouchers, the 14-part catalog, the demo OTP `123456`, etc.) — the Pencil design already resolved every PRD inconsistency (prices, weekday, plate numbers); step 04 transcribes those resolved numbers into JSON, it does not re-decide them.

## Status tracker

⬜ not started · 🟡 in progress · 🔵 in review · ✅ approved

| Step | File | Layer | Priority | Owns | Status | Claude session file |
|---|---|---|---|---|---|---|
| 01 | [01-setup-scaffold.md](01-setup-scaffold.md) | Setup | — | Project scaffold | ✅ | `02-mobile-step01-setup-scaffold.md` |
| 02 | [02-domain-entities.md](02-domain-entities.md) | Domain | — | `core/domain/model/` | ✅ | `03-mobile-step02-domain-entities.md` |
| 03 | [03-domain-rules-repositories.md](03-domain-rules-repositories.md) | Domain | — | `core/domain/repository/`, `core/domain/service/` | ✅ | `04-mobile-step03-domain-rules-repositories.md` |
| 04 | [04-mock-data-assets.md](04-mock-data-assets.md) | Data (content) | — | `assets/mock/*.json` | ✅ | `05-mobile-step04-mock-data-assets.md` |
| 05 | [05-data-core-infra.md](05-data-core-infra.md) | Data | — | `core/data/service/`, `core/data/di/` | ✅ | `06-mobile-step05-data-core-infra.md` |
| 06 | [06-data-auth-profile.md](06-data-auth-profile.md) | Data | — | `auth/data/`, `profile/data/` | ✅ | `07-mobile-step06-data-auth-profile.md` |
| 07 | [07-data-garage-catalog.md](07-data-garage-catalog.md) | Data | — | `garage/data/`, `catalog/data/` | ✅ | `08-mobile-step07-data-garage-catalog.md` |
| 08 | [08-data-workshop-booking.md](08-data-workshop-booking.md) | Data | — | `workshop/data/`, `booking/data/` | ✅ | `09-mobile-step08-data-workshop-booking.md` |
| 09 | [09-data-tracking-invoice-review-notification.md](09-data-tracking-invoice-review-notification.md) | Data | — | `tracking/data/`, `invoice/data/`, `review/data/`, `notification/data/` | ✅ | `10-mobile-step09-data-tracking-invoice-review-notification.md` |
| 10 | [10-foundations-app-shell.md](10-foundations-app-shell.md) | Presentation (foundation) | — | `app/`, `core/presentation/components/` | ✅ | `11-mobile-step10-foundations-app-shell.md` |
| 11 | [11-auth-s01-s04.md](11-auth-s01-s04.md) | Presentation, phone | P0*/P1 | S01–S04 | ✅ | `12-mobile-step11-auth-s01-s04.md` |
| 12 | [12-home-s05.md](12-home-s05.md) | Presentation, phone | P0 | S05 + `AppShell` | ✅ | `13-mobile-step12-home-s05.md` |
| 13 | [13-booking-s10-pilih-motor.md](13-booking-s10-pilih-motor.md) | Presentation, phone | P0 | S10 | ✅ | `15-mobile-step13-booking-s10-pilih-motor.md` |
| 14 | [14-booking-s11-detail-servis.md](14-booking-s11-detail-servis.md) | Presentation, phone | P0 | S11 | ✅ | `15-mobile-step14-booking-s11-detail-servis.md` |
| 15 | [15-catalog-s12.md](15-catalog-s12.md) | Presentation, phone | P1 | S12 | ✅ | `16-mobile-step15-catalog-s12.md` |
| 16 | [16-workshop-s13-s14.md](16-workshop-s13-s14.md) | Presentation, phone | P0/P1 | S13, S14 | ✅ | `17-mobile-step16-workshop-s13-s14.md` |
| 17 | [17-schedule-s15.md](17-schedule-s15.md) | Presentation, phone | P0 | S15 | ✅ | `18-mobile-step17-schedule-s15.md` |
| 18 | [18-summary-voucher-s16-s17.md](18-summary-voucher-s16-s17.md) | Presentation, phone | P0/P1 | S16, S17 | ✅ | `19-mobile-step18-summary-voucher-s16-s17.md` |
| 19 | [19-ticket-s18-p0-checkpoint.md](19-ticket-s18-p0-checkpoint.md) | Presentation, phone | P0 | S18 + e2e flow | ✅ | `20-mobile-step19-ticket-s18-p0-checkpoint.md` |
| 20 | [20-p0-hardening.md](20-p0-hardening.md) | Hardening | — | P0 screens | ✅ | `21-mobile-step20-p0-hardening.md` |
| 21 | [21-garage-s07-s09.md](21-garage-s07-s09.md) | Presentation, phone | P1 | S07–S09 | ✅ | `22-mobile-step21-garage-s07-s09.md` |
| 22 | [22-tracking-s19-s22.md](22-tracking-s19-s22.md) | Presentation, phone | P1 | S19–S22 | ✅ | `23-mobile-step22-tracking-s19-s22.md` |
| 23 | [23-invoice-review-s23-s24.md](23-invoice-review-s23-s24.md) | Presentation, phone | P1 | S23, S24 | ⬜ | `24-mobile-step23-invoice-review-s23-s24.md` |
| 24 | [24-notif-profile-demo-s06-s25-s26.md](24-notif-profile-demo-s06-s25-s26.md) | Presentation, phone | P1 | S06, S25, S26 | ⬜ | `25-mobile-step24-notif-profile-demo-s06-s25-s26.md` |
| 25 | [25-p1-hardening.md](25-p1-hardening.md) | Hardening | — | Full phone app | ⬜ | `26-mobile-step25-p1-hardening.md` |
| 26 | [26-tablet-booking-flow.md](26-tablet-booking-flow.md) | Presentation, tablet | Bonus | S10, S11, S13–S18 tablet | ⬜ | `27-mobile-step26-tablet-booking-flow.md` |
| 27 | [27-tablet-remaining-screens.md](27-tablet-remaining-screens.md) | Presentation, tablet | Bonus | S05, S07–S09, S12, S19–S26 tablet | ⬜ | `28-mobile-step27-tablet-remaining-screens.md` |
| 28 | [28-release-polish.md](28-release-polish.md) | Release | — | APK, README, submission checklist | ⬜ | `29-mobile-step28-release-polish.md` |
| 29 | [29-util-extraction-home-booking.md](29-util-extraction-home-booking.md) | Refactor | — | Per-feature `mapper/`/`utils/` extraction (Home VM, Booking repo) | 🔵 | `14-mobile-step29-util-extraction.md` |

*S03 is the P0 entry point per PRD 04; S01/S02/S04 are P1.

Session `01-mobile-app-plan.md` records the creation of this plan itself.

## Coverage map

Every entity, repository, mock file, feature and screen is owned by exactly one step.

| Entities/enums (`core/domain/model/`, 19 + `Result<T>`) | Step |
|---|---|
| `Result<T>` | 02 |
| `User`, `Motor`, `MotorModel`, `Workshop`, `ServiceType`, `Part`, `TimeSlot`, `Voucher`, `BookingDraft`, `BookingUnit`, `Booking`, `UnitStatus`, `BookingStatus`, `StatusEvent`, `Mechanic`, `Invoice`, `InvoiceLine`, `Review`, `AppNotification`, `Promo` | 02 |

| Repository interfaces + domain services | Step |
|---|---|
| All 10 interfaces (`core/domain/repository/`), `Clock` port, `PricingCalculator`, `FleetDurationCalculator`, `UnitConfigValidator`, `SalinDariCompatibilityFilter`, `SlotCapacityService`, `VoucherEligibilityService`, `BookingStatusDerivation` | 03 |

| Mock JSON files (`assets/mock/`, 11) | Step |
|---|---|
| `user.json`, `motor_models.json`, `garage_seed.json`, `workshops.json`, `services.json`, `parts.json`, `vouchers.json`, `promos.json`, `mechanics.json`, `notifications_seed.json`, `bookings_seed.json` | 04 |

| Repository implementations | Step |
|---|---|
| `SessionRepositoryImpl`, `SettingsRepositoryImpl` | 06 |
| `GarageRepositoryImpl`, `CatalogRepositoryImpl` | 07 |
| `WorkshopRepositoryImpl`, `BookingRepositoryImpl` | 08 |
| `TrackingRepositoryImpl`, `InvoiceRepositoryImpl`, `ReviewRepositoryImpl`, `NotificationRepositoryImpl` | 09 |

| Screens (phone) | Step | Screens (tablet, bonus) | Step |
|---|---|---|---|
| S01–S04 | 11 | S01–S04 | 27 |
| S05 | 12 | S05 | 27 |
| S10 | 13 | S10 | 26 |
| S11 | 14 | S11 | 26 |
| S12 | 15 | S12 | 27 |
| S13, S14 | 16 | S13, S14 | 26 |
| S15 | 17 | S15 | 26 |
| S16, S17 | 18 | S16, S17 | 26 |
| S18 | 19 | S18 | 26 |
| S07–S09 | 21 | S07–S09 | 27 |
| S19–S22 | 22 | S19–S22 | 27 |
| S23, S24 | 23 | S23, S24 | 27 |
| S06, S25, S26 | 24 | S06, S25, S26 | 27 |

| Features (`lib/`) | Owning steps (data → presentation) |
|---|---|
| `app`, `core` | 01, 03, 05, 10 |
| `auth` | 06 (data), 11 (presentation) |
| `home` | 12 (presentation only) |
| `garage` | 07 (data), 21 (presentation) |
| `workshop` | 08 (data), 16 (presentation) |
| `catalog` | 07 (data), 15 (presentation) |
| `booking` | 08 (data), 13/14/17/18/19 (presentation) |
| `tracking` | 09 (data), 22 (presentation) |
| `invoice` | 09 (data), 23 (presentation) |
| `review` | 09 (data), 23 (presentation) |
| `notification` | 09 (data), 24 (presentation) |
| `profile` | 06 (data), 24 (presentation) |

## Cut-line guidance

PRD 08's 7-day plan puts Flutter at D3–D7. If a hard stop arrives, cut in this order (never invalidates M1–M5):

1. P2 items surfaced inside steps 14, 19, 22 (mechanic "additional work" card, complaint photo, share/calendar) — annotated as not built, matching the design plan's own P2 cut list.
2. Steps 26–27 (tablet, bonus) — PRD 08 explicitly allows a documented phone-only submission; note the trade-off in the README (step 28).
3. Step 25 depth (P1 hardening) — keep `flutter analyze` clean and the app runnable; defer exhaustive layout-test coverage.
4. Never cut: steps 02–09 (domain/data — everything else depends on them), the P0 presentation steps (12–14, 16–19), step 20 (P0 hardening — M2 pixel-parity depends on it), or step 28 (M3/M4/M5 are mandatory: public repo, APK, README).

## Risks

| Risk | Mitigation |
|---|---|
| Mock-data drift between `prd/05` and the design plan's canonical demo content | Step 04 transcribes numbers from `docs/plan/design/00-index.md` (already resolved), not from `prd/05` directly where the two disagree; step 04's Open questions flag any residual gap |
| Package/version drift against the installed Flutter 3.44.0 stable | Step 01 resolves latest-stable-compatible versions at scaffold time (per PRD 07), pins them in `pubspec.lock`, and re-verifies at step 28 before the release build |
| `BackdropFilter` glass-nav/estimate-bar performance (PRD 02/08 budget: 1–2 on screen) | Profiled in step 20 (P0 hardening) on the actual booking flow; documented flat-fallback swap is ready if a low-end device test shows jank |
| Android release signing | Step 28 uses a local, non-committed keystore (`.gitignore`'d) + `key.properties` (gitignored) + a committed `key.properties.example`, per PRD 07 |
| `TrackingSimulator`/`DemoModeController` cross-feature coupling (tracking S21 + profile S26 both drive it) | Kept in `core/data/service/` from step 05 onward so neither feature imports the other; both import `core` only |
| Domain services need a fake "now" for D+0 cutoffs, countdowns, `TrackingSimulator` timers | `Clock` port introduced in step 03 (fake in tests, `SystemClock` in `core/data/service/` from step 05) so time-dependent rules stay unit-testable without real delays |
| Scope/step-count large (28 steps) | Each step is scoped to one layer-slice or one screen group, matching the design plan's own granularity; cut-line guidance above keeps a valid submission reachable at any stopping point |

## Templates

### Step file skeleton

````markdown
# Step NN — <Title>

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Layer** | Domain / Data / Presentation / Hardening / Release |
| **Priority** | P0 / P1 / Bonus / — |
| **Owns** | <entities/repos/files/screens> |
| **PRD refs** | … |
| **Design refs** | `docs/plan/design/NN-*.md`, `docs/claude-session/design/NN-*.md`, `design/pencil/exports/stepNN/` (presentation steps only) |
| **Depends on** | Step … |
| **Claude session** | `docs/claude-session/apps/<NN+1>-mobile-stepNN-<slug>.md` (written after approval) |

## Goal
## Inputs
## Open questions (ask at kickoff)
## Scope
### Files / classes to build
### Tests to write
### Content & copy notes (presentation steps)
## Checklist
### Build
### Quality (flutter analyze / format / tests)
### Review gate
### Close (only after approval)
## Review rounds
## Session log
````

### Review round block

````markdown
#### Round N — YYYY-MM-DD
- **Shown:** <files / screenshots>
- **User feedback:** "<quote>"
- **Changes made:** …
- **Outcome:** changes requested / approved
````

### Session log row

`| HH:MM | action | result (files touched, test counts) |`

### Claude-session file skeleton

Mirrors [`../../claude-session/design/02-design-plan.md`](../../claude-session/design/02-design-plan.md):

````markdown
# Claude Session Log — NN: Mobile-app step MM — <Title>

**Tool:** Claude Code, model <model>
**Date:** YYYY-MM-DD
**Topic:** <one line>

## Initial prompt
## Research performed
## Clarifying interview   (AskUserQuestion rounds → answers)
## Execution              (files written, tests added/passing)
## Review rounds          (user feedback → changes → approval)
## Key decisions worth flagging to a reviewer
## Output                 (files touched, next step)
````
