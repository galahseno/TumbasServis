# Claude Session Log — 01: Create PRD

**Tool:** Claude Code (CLI agent), model Opus 5.5 / Sonnet 5
**Date:** 2026-09-23
**Topic:** Generate the product requirements document (`prd/`) from `Assessment/Assessment.pdf`, to drive later Figma design and the Flutter implementation plan.

---

## Initial prompt

> based on the Assesment.pdf i want to make /prd place in the prd/xx
> this prd will use for design ui/ux later and for generate plan flutter project (refer to claude local skills in this project)
> i want cover all mandatory criteria, and bonus point too (for brand identity i want use my custom brand, which is TumbasService use TS initial char as logo, and the brand color etc use my personal website https://galahsenoadjie.vercel.app/ for light and dark mode)
> for the responsive layout, i want extend to cover both mobile and tablet layout
> interviewme with detail if need

## Research performed

1. Read `Assessment/Assessment.pdf` (2 pages) — extracted the core challenge (multi-vehicle booking, referencing Honda MotorkuX), the 5 mandatory deliverables, and the 5 bonus criteria.
2. Read all four local skills under `.claude/skills/`: `flutter-clean-architecture`, `flutter-domain-layer`, `flutter-data-layer`, `flutter-presentation-layer` — to make the architecture section of the PRD match the project's own conventions (feature-first folders, `Result<T>`, Notifier ViewModels, no use-case layer).
3. Checked repo state: empty `prd/`, `design/{figma,pencil,design-reference}`, `docs/{plan,claude-session}`; confirmed local Flutter SDK (3.44.0 stable).
4. Fetched `https://galahsenoadjie.vercel.app/` (HTML + compiled CSS) and extracted:
   - Color primitives (orange 100–600, sand 0–950, green-400, red-400) from CSS custom properties.
   - Light/dark semantic token overrides (`[data-theme=dark]` block).
   - Typography (`Exo 2` variable font, `@font-face` src).
   - Radius, shadow, and a "glass" token set (`--glass-blur`, `--glass-tint`, `--glass-sheen`, etc.) used as the brand's signature surface treatment.
   - Site `<title>`/meta for tone reference.

## Clarifying interview (4 rounds, `AskUserQuestion`)

**Round 1 — foundational scope:**
| Question | Answer |
|---|---|
| PRD document language | English |
| App UI language | Bahasa Indonesia |
| Vehicle types supported | Motor (motorcycle) only |
| Exact brand/app name | TumbasServis |

**Round 2 — core multi-vehicle UX:**
| Question | Answer |
|---|---|
| Per-unit config UX pattern | Vehicle chip tabs + section cards (over accordion or sequential wizard); user added note: use dummy/mock data in the later Flutter project |
| Scheduling model | One shared slot by default, optional per-vehicle split |
| Payment | Pay at workshop + invoice (no mock online payment) |
| Auth/onboarding | Splash → onboarding → mock OTP, session persisted |

**Round 3 — extra screens, data, tablet, file structure:**
| Question | Answer |
|---|---|
| Bonus screen groups to include | All four: live tracking, parts/oil catalog, invoice+rating, garage/history/notifications/profile |
| Mock data persistence | JSON assets (catalog) + local persistence (user data) |
| Tablet orientation scope | Tablet portrait + landscape (phone portrait-locked) |
| PRD file structure | Split numbered files under `prd/` |

**Round 4 — remaining product details:**
| Question | Answer |
|---|---|
| Workshop location display | List + filters + static map image, no Google Maps API key |
| Max motors per booking | 5 |
| Tracking status simulation | Timer auto-advance + a visible "Mode Demo" step/reset control |
| Promo/voucher in booking | Yes, mock voucher tied into the multi-vehicle discount story |

All answers are recorded as the decision log in `prd/00-index.md`.

## Plan

Wrote a plan (plan-mode) enumerating 9 output files (`prd/00-index.md` … `prd/08-deliverables-acceptance.md`), their contents, and a verification checklist (traceability of every mandatory/bonus PDF item, screen-ID consistency across files, brand tokens matching the extracted site CSS, architecture matching the local skills). User approved via `ExitPlanMode`.

## Execution

Wrote all 9 files under `prd/`:

| File | Summary |
|---|---|
| `00-index.md` | Index, decision log, glossary, priority legend |
| `01-overview.md` | Problem, personas, goals, scope in/out |
| `02-brand-design-system.md` | TumbasServis brand: TS monogram logo, full light/dark color tokens (from the personal site), an explicit WCAG-AA contrast fix (orange-600 button fill instead of raw orange-500), typography, spacing/radius, glass surface treatment, component inventory, Figma documentation spec |
| `03-user-flows.md` | End-to-end flows (auth, booking, tracking, completion, garage, cancel/modify), full business-rule set (unit limits, validation, pricing/makespan duration, slot capacity, status machine, identifiers) |
| `04-screens.md` | 26 screens (S01–S26) with content/states/interactions, ASCII wireframes for the highest-value screens (Home, Pilih Motor, Detail Servis, Jadwal, Ringkasan, Tiket) |
| `05-data-model-mock.md` | Domain entities, mock JSON file plan, repository interfaces (Result-typed) |
| `06-responsive-layout.md` | Material 3 window size classes, per-screen phone/tablet-portrait/tablet-landscape layout table, safe-layout checklist, device test matrix |
| `07-architecture-tech.md` | Feature map matching the local clean-architecture skill, booking-draft state lifetime, full route table, tech stack, quality gates, Android build notes |
| `08-deliverables-acceptance.md` | Full traceability matrix (every mandatory + bonus PDF line item → PRD section → acceptance criterion), submission template, brand trade-off note, 7-day milestone plan |

Self-check performed after writing: confirmed all 26 screen IDs appear in both `04-screens.md` and `06-responsive-layout.md`, confirmed every inter-file Markdown link resolves to a real filename in `prd/`.

## Key decisions worth flagging to a reviewer

- **Brand trade-off:** the assessment's bonus criterion B2 references the official Servisin Aja orange palette (servisinaja.id). This PRD deliberately substitutes a custom brand, **TumbasServis**, sourced from the candidate's personal site, per explicit user instruction. Palette stays orange-led for thematic kinship; the trade-off is documented in `prd/02-brand-design-system.md` and `prd/08-deliverables-acceptance.md` rather than left implicit.
- **Pricing simplification:** mock prices are uniform across workshops (not per-workshop pricing) — a deliberate scope simplification, noted in `prd/01-overview.md`.
- **AI policy note:** the PDF's integrity policy expects a "shared conversation link" (ChatGPT/Gemini-style). This log is the Claude Code equivalent; `prd/08-deliverables-acceptance.md` flags confirming acceptability with the recruiter before submission.

## Output

9 files under `prd/00-index.md` … `prd/08-deliverables-acceptance.md`. No code was written in this session — PRD only, per user request.
