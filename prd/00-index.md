# TumbasServis — PRD Index

## Purpose

This PRD defines the product, brand, UX flows, screens, data model, responsive rules, architecture, and acceptance criteria for **TumbasServis**, a multi-vehicle motorcycle service booking app built for the PT Karya Putra Wardjito (Servisin Aja) Technical & UI/UX Assessment (`Assessment/Assessment.pdf`).

It is the single source of truth for two downstream activities:

1. **UI/UX design** in Figma/Pencil (public link deliverable, Home → Booking Success).
2. **Flutter implementation planning**, generated with the project's local skills (`.claude/skills/flutter-clean-architecture`, `flutter-domain-layer`, `flutter-data-layer`, `flutter-presentation-layer`).

## File map

| File | Contents |
|---|---|
| [01-overview.md](01-overview.md) | Problem, personas, goals, scope in/out |
| [02-brand-design-system.md](02-brand-design-system.md) | Logo, color tokens (light/dark), typography, spacing, components, Figma doc spec |
| [03-user-flows.md](03-user-flows.md) | End-to-end flows, business rules, edge cases |
| [04-screens.md](04-screens.md) | Full screen inventory with content, states, interactions |
| [05-data-model-mock.md](05-data-model-mock.md) | Entities, repository interfaces, mock JSON data plan |
| [06-responsive-layout.md](06-responsive-layout.md) | Phone/tablet layout rules per screen, safe-layout checklist |
| [07-architecture-tech.md](07-architecture-tech.md) | Flutter architecture, feature map, routes, tech stack |
| [08-deliverables-acceptance.md](08-deliverables-acceptance.md) | Mandatory/bonus traceability matrix, submission checklist |

## How to use this PRD

- **Designing screens (Figma/Pencil):** read 02, 03, 04, 06 together. Each screen spec in 04 references its tablet behavior in 06 and its brand tokens in 02.
- **Generating the Flutter plan:** read 04, 05, 06, 07, then load the four local Claude skills — 07 is written to match their conventions directly (feature-first folders, `Result<T>`, Notifier ViewModels, no use-case layer).
- **Checking scope / grading fit:** read 08's traceability matrix against `Assessment/Assessment.pdf`.

## Decision log

Locked during the PRD interview (2026-09-23):

| Topic | Decision |
|---|---|
| PRD language / UI language | English PRD; Bahasa Indonesia UI copy (strings centralized, `id` locale only for v1) |
| Brand | **TumbasServis**, "TS" monogram logo, tokens sourced from galahsenoadjie.vercel.app (light + dark) |
| Vehicles | Motor (motorcycle) only; multi-brand catalog; max **5** motors per booking |
| Per-unit config UX | Vehicle chip tabs (✓ complete / ● active / ○ incomplete) + section cards + "Salin dari …" copy shortcut + sticky estimate bar |
| Scheduling | One slot for all units by default; optional "Pisah jadwal" toggle for per-unit slots; slots show remaining capacity |
| Payment | Pay at workshop; invoice with per-unit breakdown + mock "Lunas" (paid) state |
| Auth | Splash → 3-slide onboarding → phone login → mock OTP (demo code `123456`); persisted session |
| Bonus scope | All four bonus screen groups included: live tracking, parts/oil catalog, invoice + rating, garage/history/notifications/profile |
| Data | JSON assets for catalog data + local persistence for user data (garage, bookings, session, theme); mock repositories simulate latency and return `Result<T>` |
| Workshop location | List + filters + static map image + "Buka di Maps" external intent (no Google Maps API key) |
| Tracking | Timer-driven auto-advance after check-in, plus a visible "Mode Demo" control to step/reset status for reviewers |
| Promo | Home promo banners + voucher picker in booking summary |
| Responsive | Phone portrait-locked; tablet supports portrait + landscape; Material 3 window size classes |
| PRD structure | Split numbered files (this structure) |

Amended during the design phase (steps 01–19, 2026-09-23 → 2026-09-25); the per-step detail lives in `docs/plan/design/00-index.md` (decision log) and each step file:

| Topic | Decision |
|---|---|
| Window classes | Device type by `shortestSide ≥ 600`; layout class by **width**: 360 compact, 800 medium, 1024 expanded, 1280 large |
| Design tool + Figma path | Pencil (`design/pencil/TumbasServis.pen`), one band per screen S01 → S26 (phone → tablet-P → expanded → tablet-L, light + dark). Figma via `html-css` export → html2figma (route B) after the Flutter build; deliverable in a Figma Draft; variables rebuilt by hand |
| Icons / imagery | Material Symbols Rounded (no fill axis: selected = weight 700 + accent); flat vector art built from components (onboarding vignettes), generated SVG budget 8 of ≈ 11 |
| Booking-flow chrome | S10–S18 show no `NavBar` / `NavRail`; back / close in the app bar, sticky footer at the bottom; exit dialog only with ≥ 1 selected motor |
| Pricing language | Every price is an estimate ("Estimasi", "Total estimasi"); pay at the workshop |
| Vouchers | S17 is a full page reached only from S16; promo / notification voucher CTAs start a booking with the voucher carried; no code field |
| Tracking demo control | Segmented auto-advance "Mati / 15 dtk / 5 dtk" (replaces the slider), per-unit and booking-level controls, one-shot error simulation, "Reset semua data" restores the seed and keeps session / theme / demo settings |
| Review gate | Reviews (S24) are hard-gated behind a paid invoice; the per-mechanic section appears only with ≥ 2 mechanics |
| Copy conventions | Sentence case for buttons, chips, titles; "kamu" voice; dialog dismiss = "Batal" (only the cancel-booking dialog uses "Kembali"); the UI says "jam" (not "slot") and "motor" for capacity |
| Submit rule | Text forms validate on submit (button stays enabled); count-gated steps (S04 six digits, S10 / S11 / S15 / S16 gates) may disable only with a visible reason line |
| Motion | 150 ms micro-interactions, ~250 ms route / sheet, ~300 ms staggered timeline; all of it off under `MediaQuery.disableAnimations`; no state is carried by motion alone |
| Design-file conventions | Colors, weights and effects are variable-bound; spacing, radius and size numbers are literals that equal the token scale (Pencil cannot bind `width` / `height`); the design carries the full component library (487 masters) and 386 frames |

## Priority legend

Used throughout 03/04/06/08:

- **P0 — Mandatory core.** Required by the assessment's Home → Booking Success flow and the multi-vehicle challenge. Must exist, be pixel-precise in Figma, and fully functional in the Flutter build.
- **P1 — Bonus.** Adds to "Kelengkapan Layanan & Ragam Screen" and other bonus criteria. Build after P0 is solid.
- **P2 — Nice-to-have.** Only if time remains inside the 7-day window; first candidates to cut.

## Glossary

| Term | Meaning |
|---|---|
| Bengkel | Workshop / service center |
| Montir | Mechanic |
| Keluhan | Complaint / reported issue with the vehicle |
| Suku cadang | Spare parts |
| Servis berkala | Scheduled/periodic maintenance |
| Antrean | Queue |
| Unit | One motorcycle within a booking (a "booking unit") |
| Armada | Fleet — the set of motors in one booking |
| Tiket | The confirmation ticket produced at booking success |
| Estimasi | Estimate (cost/duration), always non-binding mock pricing |
