# TumbasServis — Design Plan (Pencil → Figma)

## Purpose

Step-by-step execution plan for the UI/UX design of **TumbasServis**, built from the PRD in [`../../../prd/`](../../../prd/00-index.md). Designs are authored in **Pencil (pencil.dev MCP)** in one file, `design/pencil/tumbasservis.pen`, then converted to **Figma** in the final steps (assessment deliverable M1: public Figma link, Home → Booking Success).

Every step follows the same loop: **build → self-check → `/better-interface` pass → user review gate → session log**, and after the user approves it writes a `docs/claude-session/` file. Nothing is committed by Claude; git is handled by the user.

Primary PRD inputs: [02 brand & design system](../../../prd/02-brand-design-system.md), [03 flows & rules](../../../prd/03-user-flows.md), [04 screens](../../../prd/04-screens.md), [06 responsive layout](../../../prd/06-responsive-layout.md).

## How to run a step

Start a session with: *"Run design step NN — follow `docs/plan/design/NN-<name>.md` and the workflow in `00-index.md`."* One step per session keeps context small and the session log clean. Steps run in order; each lists its dependencies.

## Decision log

Locked in the planning interview (2026-09-23):

| Topic | Decision |
|---|---|
| Step granularity | Feature groups; P0 booking flow ≈ one screen per step; P1 grouped → 14 design steps + setup + 2 audit/checkpoint + 2 Figma = 21 steps |
| Coverage per step | Phone 360×800 + tablet portrait 800×1280 + tablet landscape 1280×800, light + dark (see frame matrix rule) |
| Order | Priority: setup → foundations → components → P0 Home→Success → P1 → audit → Figma |
| Pencil file | Single `design/pencil/tumbasservis.pen`; sections mirror the Figma pages |
| `/better-interface` | Run after the draft; auto-apply HIGH + MEDIUM fixes in Pencil; list LOW for the user |
| States | P0 screens: every state in `prd/04`. P1 screens: default + empty + one loading/error |
| Figma | Conversion path spiked in step 01; full conversion + prototype in steps 20–21 |
| Reference research | None (no Mobbin) — design from the PRD |
| Icons | Material Symbols Rounded (closes the PRD 02 open choice) via Pencil `icon` nodes, weight 100–700 |
| Imagery | Flat geometric vectors in orange/sand. Pencil forbids hand-built path art → `Generate(frame, "svg", prompt)` with palette hexes, each result turned into a reusable component. Budget ≈ 11: 5 empty/error/success, 3 onboarding, 3 motor silhouettes. Photo slots = aspect-ratio gradient placeholders |
| Git | No commits by Claude |
| Doc layout | This index + one file per step |

## Conventions

Grounded in the Pencil skill docs (`pen-schema`, `execute`, `guide/components`, `guide/mobile-app`).

### Canvas layout
- Pencil has no pages; the document root holds only screen frames, reusable component frames and section containers. Never place loose text/shapes at root.
- Top rows: `00 Cover`, `01 Foundations` boards, `02 Components`. Below: one row per screen — phone light states → phone dark → tablet portrait → tablet landscape — each row led by a section-header frame. Figma pages are created in step 20.
- Use `FindEmptySpace` for placement; never overlap root objects.

### Variables & themes
- Theme axis `mode: light | dark`. Primitives = plain color variables (`orange-500` …). Semantic tokens = themed variables named exactly like the PRD 02 table (`bg-page`, `surface-card`, `accent`, …). Number variables for spacing/radius/font size; string variable `font-family` = `Exo 2`.
- A dark frame is a `Copy` of the light frame with `theme: {mode: "dark"}` — never re-styled by hand.
- Only variables and components: **no raw hex** in fills/strokes/effects, no detached instances.

### Screen frames
- Fixed width per breakpoint (360 / 800 / 1280); height `fit_content(<device height>)`; `clip: true`; `placeholder: true` while building, cleared as soon as the frame is done.
- Android system chrome: status bar 24dp + gesture-nav inset 24dp (deliberately replaces the Pencil mobile guide's iOS 62px — confirm in step 02).
- Frame naming (PRD 02 + theme suffix): `S11 Detail Servis / Default / Phone`, `S11 Detail Servis / Default / Phone · Dark`, `… / Tablet-Portrait`, `… / Tablet-Landscape`. Every node has a human name; no "Frame 12".

### Window size classes
- PRD 06 says breakpoints are evaluated on `shortestSide`, but its layout table then gives tablet-landscape different layouts than tablet-portrait — impossible if both have shortestSide 800. **Working assumption (confirm in step 01):** *device type* (phone vs tablet, orientation lock) uses `shortestSide ≥ 600`; *layout class* uses **width** (Material 3). So 360 = compact, 800 = medium, 1024 = expanded, 1280 = large. Update `prd/06` after confirmation.

### Frame matrix rule
- Light: every required state × 3 breakpoints, except where PRD 06 says the layout is identical across breakpoints (dialogs, sheets, centered forms) — then one tablet frame suffices; the step's matrix marks these explicitly.
- Dark: every P0 state on phone + the default state on both tablets. P1 dark: default state on each breakpoint.
- Stress frames (P0 dense screens only): 360×640 small phone and text scale ×1.3, per PRD 06.

### Components & variants
- Names use the `Ts` prefix = Flutter widget name (PRD 02: one Figma component ↔ one Flutter widget).
- Pencil has no variant properties. Convention: every variant combination that a screen uses is its own reusable frame named `TsButton / Type=Primary, State=Default` (Figma "Property=Value" style, so step 20 can regroup into component sets). Spec-only states (pressed, focused…) may be `ref` overrides on the component sheet — the step's Open questions confirm this per component family.
- Pencil has no text styles: the type scale is built as reusable text nodes on the Type board (`Type / Headline Large` …) plus number variables, so step 20 can create Figma text styles from them.
- Icons are `icon` nodes, `library: "Material Symbols Rounded"`, 24dp default, weight 400; filled variant for selected state where the library supports it.
- **Late additions:** a component or variant discovered inside a screen step is built in that step, placed in the `02 Components` row, listed in the step's *Components built here* table, and appended to *Inventory additions* below. It is never redrawn inline.

### Annotations
- `note` nodes beside frames for motion (150 / 250 / 300 ms, reduce-motion behavior), interaction, sticky/scroll behavior, keyboard behavior, and semantics labels for icon-only controls — handoff for Flutter and for the Figma prototype.

### Automated checks (run inside `execute` every step)
- Clipping: `Get(screen, (n,c) => c.problems && Print(n.name, c.problems))` → zero rows.
- Raw-hex audit: any fill/stroke/effect color not starting with `$` → zero rows.
- `TakeScreenshot` per finished section as review evidence.

### Exports
- After approval: `Export(frames, "png", "design/pencil/exports/stepNN/")` — review record and later Flutter pixel-diff source (assessment M2).

### Safe-layout rules (PRD 06, applied as design checks)
48dp minimum targets · ellipsis + max lines on names/plates/workshops/notes · sticky bars sit above the bottom inset · max-widths per PRD 06 table · no fixed-height boxes around text · photo slots have an aspect-ratio box.

### Copy
Bahasa Indonesia, friendly voice (PRD 02). `Rp412.000`, `Sen, 29 Sep 2026`, `09.00`. All strings must be realistic — no lorem ipsum.

## `/better-interface` on Pencil designs

The skill is web-oriented and demands `file:line` evidence. On Pencil frames, cite **frame name + node id** (the skill's format allows "exact screen and component when the artifact has no source files") and attach the screenshot. Mapping for static mobile mockups:

| Skill trigger (web) | Check on the design |
|---|---|
| Control with no accessible name | Icon-only controls carry a `note` with the Flutter `Semantics` label |
| Focus indicator | Designed focused state exists for TsButton / TsTextField / TsChip (tablet + keyboard / switch access) |
| `prefers-reduced-motion` | Motion notes state the `MediaQuery.disableAnimations` fallback, and no state is conveyed by motion alone |
| Clipped at 320px / 200% zoom | 360×640 frame and text-scale ×1.3 stress frames show no clipping |
| Contrast | Ratio computed from `Get(..., {resolveVariables: true})` values; text ≥ 4.5:1, UI boundaries/icons ≥ 3:1 |
| Color-only state | Every status/error/selected state also has icon, label or shape |
| Destructive action confirmation | Dialogs use danger styling; cancel de-emphasized |
| Truncation without full value | Truncated text has a reachable detail (tap → sheet, or wraps) |

Fix authority: the plan decision authorizes fixing HIGH + MEDIUM after the report is recorded. The review itself stays read-only; fixes are a separate, logged action. LOW findings stay listed for the user. A step may not enter the review gate until the verdict is `Approve` (no HIGH left).

## Known token risks (decide in step 02)

Manual estimates from the PRD 02 hex values — verify with `better-colors` in step 02.

| Pair | ≈ Contrast | Issue |
|---|---|---|
| `text-muted` `#8A817A` on `bg-page` / `surface-card` (light) | 3.6–3.8 : 1 | Fails AA for normal text. Restrict to large text/non-essential, or darken the token |
| `text-faint` `#B0A79F` on light surfaces | ≈ 2.3 : 1 | Decorative only; never placeholders or content |
| `success` / `info` / `warning` / `danger` as **text** on light surfaces | 2.4–3.6 : 1 | Fails AA. Status badges need a tinted background + darker text variant (same fix pattern as `orange-600`) |
| `border-default` / `border-strong` for input & checkbox boundaries (light) | ≈ 1.5 / 2.3 : 1 | Below 3:1 non-text contrast for control boundaries |
| White on `orange-600` | ≈ 4.8 : 1 | ✓ as PRD states |
| `text-muted` dark `#9A918B` on `bg-page` dark | ≈ 6 : 1 | ✓ |

## Canonical demo content

Every screen uses the same story so the prototype reads as one app. Draft from the PRD; **step 01 finalizes it** into a demo-content sheet frame.

| Item | Value |
|---|---|
| User | Galah · `+62 812-3456-7890` (masked `+62 812-****-7890`) |
| Garage | Vario 125 (AB 1234 XY), Beat 110 (AB 5678 ZZ), PCX 160 (AB 9012 QR) |
| Workshop | Bengkel Jaya Motor (fictional, Yogyakarta area) |
| Slot | Sen, 29 Sep 2026 · 09.00 |
| Booking | `TS-260929-0417`, units `-A` `-B` `-C` |
| Voucher | "Diskon 10% servis ≥2 motor" |
| Promo/OTP | demo OTP `123456` |

**PRD inconsistency to resolve in step 01:** S11 wireframe shows `Est. Rp412.000`, S16 shows 2 units (Rp428.000 → Rp385.200 after voucher), S18 shows 3 units with the same Rp385.200 total, and `services.json` prices Servis Berkala at Rp85.000 while S16 shows Rp185rb per unit. Target: one 3-unit booking, subtotal Rp428.000, 10% voucher (−Rp42.800), total Rp385.200, duration from makespan on a 2-bay workshop; S11's running estimate consistent with the same line items.

## Per-step workflow

1. **Kickoff** — read the step's PRD refs; ask the user (`AskUserQuestion`) the step's *Open questions* that change layout or content. Set status 🟡.
2. **Build** — `get_app_state`; `read_skill` docs as needed; one `execute` per section with `placeholder: true` until done; frames per the step's matrix; variables + instances only; end each section with a screenshot.
3. **Self-check** — tick the Build checklist; run the automated checks; fix before review.
4. **`/better-interface`** — scope = this step's frames. Record scope/coverage, findings, verification and verdict in the step file. Apply HIGH + MEDIUM, re-screenshot, re-run until `Approve`. List LOW.
5. **Session log** — append rows (time · action · result) to the step's Session log as work happens.
6. **Review gate** — status 🔵; give the user the frame list and what to look at; the user reviews in Pencil and replies *approve* or *changes*. Log each round. Loop until approved.
7. **Close** — only after approval: PNG export; write the `docs/claude-session/` file; status ✅; update the tracker below. No commit.

## Status tracker

⬜ not started · 🟡 in progress · 🔵 in review · ✅ approved

| Step | File | Priority | Owns screens | Status | Claude session file |
|---|---|---|---|---|---|
| 01 | [01-setup-spike.md](01-setup-spike.md) | — | — | ⬜ | `03-design-step01-setup-spike.md` |
| 02 | [02-foundations.md](02-foundations.md) | — | — | ⬜ | `04-design-step02-foundations.md` |
| 03 | [03-components-core.md](03-components-core.md) | — | — | ⬜ | `05-design-step03-components-core.md` |
| 04 | [04-components-booking.md](04-components-booking.md) | — | — | ⬜ | `06-design-step04-components-booking.md` |
| 05 | [05-s05-home.md](05-s05-home.md) | P0 | S05 | ⬜ | `07-design-step05-s05-home.md` |
| 06 | [06-s10-pilih-motor.md](06-s10-pilih-motor.md) | P0 | S10 | ⬜ | `08-design-step06-s10-pilih-motor.md` |
| 07 | [07-s11-detail-servis.md](07-s11-detail-servis.md) | P0 | S11 | ⬜ | `09-design-step07-s11-detail-servis.md` |
| 08 | [08-s13-s14-bengkel.md](08-s13-s14-bengkel.md) | P0/P1 | S13, S14 | ⬜ | `10-design-step08-s13-s14-bengkel.md` |
| 09 | [09-s15-jadwal.md](09-s15-jadwal.md) | P0 | S15 | ⬜ | `11-design-step09-s15-jadwal.md` |
| 10 | [10-s16-s17-ringkasan.md](10-s16-s17-ringkasan.md) | P0/P1 | S16, S17 | ⬜ | `12-design-step10-s16-s17-ringkasan.md` |
| 11 | [11-s18-tiket.md](11-s18-tiket.md) | P0 | S18 | ⬜ | `13-design-step11-s18-tiket.md` |
| 12 | [12-p0-checkpoint.md](12-p0-checkpoint.md) | — | (S05→S18 flow) | ⬜ | `14-design-step12-p0-checkpoint.md` |
| 13 | [13-auth-s01-s04.md](13-auth-s01-s04.md) | P1 | S01–S04 | ⬜ | `15-design-step13-auth.md` |
| 14 | [14-garage-s07-s09.md](14-garage-s07-s09.md) | P1 | S07–S09 | ⬜ | `16-design-step14-garage.md` |
| 15 | [15-catalog-s12.md](15-catalog-s12.md) | P1 | S12 | ⬜ | `17-design-step15-catalog.md` |
| 16 | [16-tracking-s19-s22.md](16-tracking-s19-s22.md) | P1 | S19–S22 | ⬜ | `18-design-step16-tracking.md` |
| 17 | [17-invoice-rating-s23-s24.md](17-invoice-rating-s23-s24.md) | P1 | S23, S24 | ⬜ | `19-design-step17-invoice-rating.md` |
| 18 | [18-notif-profile-demo.md](18-notif-profile-demo.md) | P1 | S06, S25, S26 | ⬜ | `20-design-step18-notif-profile-demo.md` |
| 19 | [19-full-app-audit.md](19-full-app-audit.md) | — | all | ⬜ | `21-design-step19-full-app-audit.md` |
| 20 | [20-figma-conversion.md](20-figma-conversion.md) | — | all | ⬜ | `22-design-step20-figma-conversion.md` |
| 21 | [21-figma-prototype-publish.md](21-figma-prototype-publish.md) | — | S05→S18 | ⬜ | `23-design-step21-figma-prototype-publish.md` |

Session `02-design-plan.md` records the creation of this plan itself.

## Coverage map

Every screen and every PRD 02 inventory component is owned by exactly one step (each step file has `Owns screens` / `Owns components` lines — grep them to verify).

| Screens | Step |
|---|---|
| S05 | 05 |
| S10 | 06 |
| S11 | 07 |
| S13, S14 | 08 |
| S15 | 09 |
| S16, S17 | 10 |
| S18 | 11 |
| S01–S04 | 13 |
| S07–S09 | 14 |
| S12 | 15 |
| S19–S22 | 16 |
| S23, S24 | 17 |
| S06, S25, S26 | 18 |

| Components (28) | Step |
|---|---|
| `TsLogo` | 02 |
| `TsButton`, `TsTextField`, `TsChip`, `TsAppBar`, `SheetHeader`, `NavBar` / `NavRail`, `EmptyState`, `ErrorState`, `Skeleton`, `UnitStatusBadge` (+ extra `TsDialog`, `TsSnackbar`) | 03 |
| `VehicleTabChip`, `VehicleSelectCard`, `ServiceOptionTile`, `PartOptionTile`, `WorkshopCard`, `SlotChip`, `DateStripItem`, `BookingStepper`, `StickyEstimateBar`, `PriceBreakdown`, `TicketCard`, `PromoBanner`, `VoucherCard` | 04 |
| `StatusTimeline`, `MechanicCard` | 16 |
| `RatingStars` | 17 |
| `NotificationTile` | 18 |

`TsDialog` and `TsSnackbar` are not in the PRD 02 inventory but PRD 04 "Global patterns" require them; they are added to the inventory in step 03 and must be added to `prd/02` (and become Flutter widgets).

### Inventory additions (running list → applied to `prd/02` in step 19, with user approval)

Components that exist in PRD 04 screens or global patterns but not in the PRD 02 inventory. Steps append here as they build.

| Component | Added in | Why |
|---|---|---|
| `TsDialog`, `TsSnackbar` | 03 | PRD 04 global patterns |
| `AppShell` | 05 | Tab shell (bottom `NavBar` / `NavRail`) reused by S05, S07, S19, S25 |
| `ActiveBookingCard`, `DraftResumeCard`, `QuickLinkTile`, `FleetProgress` | 05 (`FleetProgress` full in 16) | S05 content blocks |
| `UnitHeader`, `CopyFromRow`, `ComplaintSection`, `EstimatePane` | 07 | S11 sections |
| `SearchBar`, `FilterChipRow`, `WorkshopInfoBlock` | 08 | S13/S14 (`SearchBar` reused by 15) |
| `ScheduleModeToggle`, `UnitSlotSection`, `CapacityBanner`, date-grid `DateStripItem` | 09 | S15 split/capacity/landscape |
| `SummaryCard`, `UnitSummaryAccordion`, `PaymentNote`, `VoucherRow` | 10 | S16 |
| `SuccessHeader`, `QrCode`, `TicketUnitRow` | 11 | S18 |
| `PageIndicator`, `OtpInput`, `AuthHero` | 13 | S02–S04 |
| `MotorModelPicker`, `ServiceHistoryRow` | 14 | S08/S09 |
| `PartDetailSheet`, `SelectedPartsBar` | 15 | S12 |
| `BookingHistoryCard`, `UnitStatusRow`, `CancelScopeChooser`, `DemoModeShortcut` | 16 | S19–S22 |
| `InvoiceSummaryCard`, `MechanicRatingRow`, `ReviewRecap` | 17 | S23/S24 |
| `TsSegmentedControl`, `TsSwitch`, `TsSlider`, `SettingsRow` | 18 | S25/S26 |

`VehicleSelectCard` gains display and compact modes (step 04) instead of a separate garage-card component.

## Cut-line guidance

The PRD 7-day plan gives design roughly D1–D3, so this plan is deliberately ordered so a hard stop still leaves a valid submission. If time runs short, cut in this order:

1. P2 optional items inside steps 07, 11, 16 (complaint photo, share/calendar, "additional work" card).
2. Dark-mode frames for P1 screens (keep tokens + P0 dark).
3. Tablet frames for P1 screens (keep one tablet frame each).
4. Step 15 (catalog) degrades to the shortlist already in S11.
5. Step 18 S26 detail (keep S25).

Never cut: steps 01–12, the P0 tablet frames, or step 20–21 (M1 needs the public Figma link). If the Figma path chosen in step 01 is heavy/manual, step 12 decides whether to start P0 Figma conversion before the P1 steps.

## Templates

### Step file skeleton

````markdown
# Step NN — <Title>

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | P0 / P1 / — |
| **Owns screens** | Sxx |
| **Owns components** | … |
| **PRD refs** | … |
| **Pen location** | … |
| **Depends on** | Step … |
| **Claude session** | `docs/claude-session/<NN+2>-design-stepNN-<slug>.md` (written after approval) |

## Goal
## Inputs
## Open questions (ask at kickoff)
## Scope
### Frame matrix
### Components / illustrations to build
### Content & copy notes
### Annotations to place
## Checklist
### Build
### Quality (automated, run in `execute`)
### /better-interface
### Review gate
### Close (only after approval)
## /better-interface report
## Review rounds
## Session log
````

### `/better-interface` report block (paste into each step)

````markdown
**Scope:** <frame names + node ids> · **Stack/conventions:** Pencil, variables per 00-index, PRD 02 tokens · **Convention docs found:** 00-index.md, prd/02, prd/06

| Domain | Evidence inspected | Result |
|---|---|---|
| Accessibility | | |
| Layout | | |
| Writing | | |
| Typography | | |
| Color | | |
| UI | | |

| Severity | Domain | Location (frame · node id) | Before | After | Why |
|---|---|---|---|---|---|

**Verification:** <checks run + result; **Not verified** items>
**Verdict:** Block / Approve
**Fixes applied:** <HIGH/MEDIUM fixed, with node ids> · **LOW left for user:** <list>
````

### Review round block

````markdown
#### Round N — YYYY-MM-DD
- **Frames shown:** …
- **User feedback:** "<quote>"
- **Changes made:** …
- **Outcome:** changes requested / approved
````

### Session log row

`| HH:MM | action | result / node ids |`

### Claude-session file skeleton

Mirrors [`../../claude-session/01-create-prd.md`](../../claude-session/01-create-prd.md):

````markdown
# Claude Session Log — NN: Design step MM — <Title>

**Tool:** Claude Code + Pencil MCP, model <model>
**Date:** YYYY-MM-DD
**Topic:** <one line>

## Initial prompt
## Research performed
## Clarifying interview   (AskUserQuestion rounds → answers)
## Execution              (frames/components built, node ids, exports)
## /better-interface      (findings summary, fixes applied, verdict)
## Review rounds          (user feedback → changes → approval)
## Key decisions worth flagging to a reviewer
## Output                 (files: .pen sections, exports, docs updated)
````

## Risks

| Risk | Mitigation |
|---|---|
| No native Pencil → Figma export | Path chosen and rated in step 01; fallback = rebuild from Pencil spec + PNG exports |
| Figma plan may cap pages per file and variable modes (PRD 02 needs 6 pages + Light/Dark) | Verify in step 01 (Q5); decide split-files or second-collection dark mode before step 20 |
| `Generate svg` is slow/expensive and style may drift | ≤ 11 illustrations, each a reusable component; style approved once in step 01 before budget is spent |
| Glass effect: Pencil has `background_blur` but no `saturate` | Approximate with tint + blur + border; note the Flutter `BackdropFilter` spec; flat fallback documented |
| Frame count explosion (states × breakpoints × themes) | Matrix rule above; dark/tablet cut-lines; components + instances only |
| PRD inconsistencies (window classes, demo prices) | Resolved in step 01 and written back to the PRD |
