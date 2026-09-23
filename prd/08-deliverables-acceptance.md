# 08 — Deliverables, Acceptance & Traceability

Source: `Assessment/Assessment.pdf` ("PT Karya Putra Wardjito • Servisin Aja — Technical & UI/UX Assessment").

## Challenge pillars → PRD coverage

| # | Pillar (PDF §1) | Covered by |
|---|---|---|
| 1 | Multi-Vehicle Selection & Management | [03](03-user-flows.md) F2, S10 in [04](04-screens.md) |
| 2 | Keluhan & Servis Spesifik per Unit | [03](03-user-flows.md) business rules, S11/S12 in [04](04-screens.md) |
| 3 | Jadwal & Form Booking Terpadu | S13–S16 in [04](04-screens.md), scheduling rules in [03](03-user-flows.md) |
| 4 | Tiket Konfirmasi & Status Pelacakan | S18, S20, S21 in [04](04-screens.md) |

## Mandatory deliverables (PDF §2) — traceability & acceptance

| # | Requirement | PRD coverage | Acceptance criterion |
|---|---|---|---|
| M1 | Public Figma link, "Anyone with the link can view," full Home→Booking Success flow | [02](02-brand-design-system.md) Figma doc spec, all P0 screens in [04](04-screens.md) | Link opens in an incognito window with no sign-in; prototype is click-through from S05 to S18 without gaps. |
| M2 | Visual consistency & pixel precision (Flutter matches Figma canvas) | [02](02-brand-design-system.md) tokens shared 1:1 between Figma variables and Flutter `ColorScheme`/`ThemeExtension` | Side-by-side screenshot diff of each P0 screen (Figma export vs. device screenshot) at the same breakpoint shows matching spacing/color/type. |
| M3 | Public GitHub repo, structured architecture, clean/descriptive commit history | [07](07-architecture-tech.md) feature map (matches the local clean-architecture skill exactly) | Repo visibility public; one feature/slice per logical commit with descriptive messages (see commit-message convention below); `git log` reads as a coherent build order. |
| M4 | Installable APK (Google Drive or GitHub Releases link) | [07](07-architecture-tech.md) Android build section | `flutter build apk --release` artifact installs and launches on a clean Android device/emulator; link is public and works from incognito. |
| M5 | README.md with SDK setup, dependencies, local run instructions | (produced alongside the code, not part of this PRD's file set) | A reviewer with only Flutter installed can follow the README to `flutter pub get` → `build_runner` → `flutter run`/install the APK without asking a question. |

## Bonus criteria (PDF §3) — traceability & acceptance

| # | Requirement | PRD coverage | Acceptance criterion |
|---|---|---|---|
| B1 | Kelengkapan Layanan & Ragam Screen (tracking montir, part/oli selection, invoice detail, rating bengkel, etc.) | [04](04-screens.md) full P1 set: S06, S07–S09, S12, S14, S19–S26 | All listed example screens (mechanic tracking, part/oil picker, invoice, workshop rating) exist and are reachable from the core flow, not orphaned. |
| B2 | Brand Identity (palette, typography, visual style) | [02](02-brand-design-system.md) — **custom TumbasServis brand** (declared trade-off, see note below), not the literal Servisin Aja palette | Design system is applied consistently across every screen (no ad-hoc colors/fonts outside the token set); light + dark mode both implemented. |
| B3 | Struktur Dummy Data & State Management (rich mock/JSON data, BLoC/Provider/Riverpod) | [05](05-data-model-mock.md) mock JSON assets + repositories; [07](07-architecture-tech.md) Riverpod Notifier | Mock data is varied and realistic (multiple workshops/services/parts/mechanics, not 1–2 placeholder rows); state management is consistent app-wide (Riverpod throughout, no mixed patterns). |
| B4 | Tampilan Responsif & Safe Layout (no overflow across screen ratios) | [06](06-responsive-layout.md) full device matrix + safe-layout checklist | Zero overflow/yellow-black-bar errors across the [06](06-responsive-layout.md) device matrix, verified manually per P0 screen at minimum. |
| B5 | Dokumentasi Figma & Clean Architecture (layer/frame naming, component system, clean architecture in code) | [02](02-brand-design-system.md) Figma doc spec; [07](07-architecture-tech.md) (mirrors the four local skills) | Figma file has organized pages/frame-naming/component variants per [02](02-brand-design-system.md); Flutter code follows the dependency rule with no violations (spot-checked: no `data/` import in `presentation/`, no `package:flutter/` in `domain/`). |

### Note on B2 (brand identity trade-off)

The assessment's official reference for B2 is `www.servisinaja.id`'s orange palette. This project deliberately substitutes a **custom brand, TumbasServis**, sourced from the candidate's own personal site, per an explicit product decision (see [00-index.md](00-index.md) decision log and [02](02-brand-design-system.md) brand rationale). The palette remains orange-led, preserving thematic kinship with Servisin Aja while demonstrating independent, end-to-end design-system ownership (tokens, dark mode, component system) rather than reproducing an existing brand. This is called out explicitly in the submission notes below so it reads as a deliberate choice, not a missed requirement.

## Submission format (PDF §4)

Use the exact template from the PDF when submitting:

```
Subject: Submission Technical Test - Mobile & UI/UX - [Nama Lengkap]
Nama Lengkap   : [Nama sesuai KTP]
Posisi         : Mobile Developer & UI/UX Designer
Tautan Figma   : https://www.figma.com/file/... (akses Public)
Tautan GitHub Repo : https://github.com/...
Tautan Unduhan APK : https://drive.google.com/... atau GitHub Releases
Tautan Chat / Log AI : [link shared conversation]
Catatan Tambahan : [ringkasan fitur unggulan / screen tambahan]
```

**Catatan Tambahan** should mention: full multi-vehicle booking (1–5 motors), per-unit live tracking with a demo control, custom TumbasServis brand (light+dark) built from the candidate's personal site, tablet-responsive layouts (portrait+landscape), and the mock-data/state-management approach.

### AI usage policy (PDF integrity note)

The assessment explicitly permits AI chat tools (ChatGPT/Gemini-style) provided a shared conversation link is included, and states AI use does not reduce scoring. This project's Claude Code sessions should be logged/exported to `docs/claude-session/` and referenced in the submission's "Tautan Chat / Log AI" field; if Claude Code's session format differs from the PDF's expected "shared conversation link" (which anticipates a ChatGPT/Gemini-style share link), confirm acceptability with the recruiter via chat before submitting, per the PDF's own "silakan konfirmasi melalui chat kami" instruction.

## Pre-submission checklist

- [ ] Figma link opens in incognito with view access, no login wall.
- [ ] GitHub repo is public; README renders correctly on GitHub's web view.
- [ ] APK link (Drive or Releases) opens in incognito and downloads without a permission request.
- [ ] Claude session log link is public/shareable.
- [ ] Every link above tested in an actual incognito/private window, not just assumed.

## Suggested 7-day milestone plan

| Day | Focus |
|---|---|
| D1 | This PRD finalized; Figma foundations (tokens, type, components) from [02](02-brand-design-system.md) |
| D2–D3 | Figma screens (P0 first, then P1) + prototype wiring |
| D3–D4 | Flutter scaffold: architecture skeleton, design-system widgets, mock data layer |
| D4–D6 | Flutter screens (P0 booking flow first and hardened, then P1 bonus screens) |
| D6 | Responsive pass across the [06](06-responsive-layout.md) device matrix |
| D7 | Polish, `flutter build apk --release`, README, submission links, final incognito check |

### Risks / cut-line guidance

- **Brand trade-off (B2):** if a reviewer strongly weights literal Servisin Aja colors, the custom-brand choice is a known, documented risk — mitigated by the explicit note above and the palette's orange kinship.
- **`BackdropFilter` (glass nav/estimate bar) performance:** budget-limited to 1–2 instances on screen per [02](02-brand-design-system.md); if profiling shows jank on lower-end test devices, fall back to a flat `surface-card` with a subtle top border instead of frosted glass — brand tokens still apply, only the glass effect is dropped.
- **Scope creep:** if D6 arrives behind schedule, cut P2 items first (mechanic "additional work" card, complaint photos, share/calendar), then the least core P1 screens (S12 catalog deep-dive can degrade to "shortlist only in S11," S17 voucher can degrade to a single fixed promo) — never cut P0 screens or the responsive pass.
