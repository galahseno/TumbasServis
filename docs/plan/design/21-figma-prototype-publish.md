# Step 21 — Figma prototype & public link (M1)

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | — (assessment M1 — mandatory) |
| **Owns screens** | — |
| **Owns components** | — |
| **Prototypes** | The P0 journey S05 → S18 (phone), plus tablet where time allows |
| **PRD refs** | [08 M1 acceptance + pre-submission checklist + submission format](../../../prd/08-deliverables-acceptance.md), [02 Figma spec (`05 Prototype`)](../../../prd/02-brand-design-system.md), [03 F2 entry points](../../../prd/03-user-flows.md) |
| **Pen location** | n/a (Figma) |
| **Depends on** | Step 20 |
| **Claude session** | `docs/claude-session/23-design-step21-figma-prototype-publish.md` (written after approval) |

## Goal

Wire the click-through prototype so a reviewer can go from **Home to Booking Success without gaps**, publish the file with **"Anyone with the link can view"**, and verify the link in an incognito window. This closes assessment deliverable M1.

Claude has no Figma access: Claude writes the **wiring table** (below) from the approved frames; the **user** wires it in Figma and reports back with screenshots or a screen recording of the playthrough.

## Inputs

- Figma file from step 20; P0 frames (phone light, dark variant frames for the mode demo).
- Journey and entry points from PRD 03 F2.

## Open questions (ask at kickoff)

1. **Prototype path.** Primary: Home CTA → S10 → S11 → S13 → S14 → S15 → S16 → S17 → S16 → S18 → S20. Include the alternate entry points (Garage → pre-selected, Workshop detail) or only the main path?
2. **Interaction depth.** Component-variant interactions (chip select, tab switching on S11, checkbox toggles on S10, slot selection on S15) vs plain frame-to-frame taps. *Recommended: variant interactions for S10 selection, S11 tabs, S15 slot; taps elsewhere.*
3. **Dark mode demo** — depends on the step 01 Starter decision: with real Light/Dark variable modes, set the mode per flow; with a second collection, wire a separate dark flow from the dark frames. Include a dark demo at all?
4. **Tablet prototype** — include 800×1280 / 1280×800 flows or phone only?
5. **Device frame / starting frame** and presentation settings (background color, fit-to-screen).
6. **Prototype for P1** (auth, garage, tracking) — wire main links or leave static?

## Scope

### Prototype work

| Item | Detail |
|---|---|
| Starting frame | S05 Home (or S01 Splash → S02 → S03 → S04 → S05 if auth is included) |
| Main path | Per Q1, every tappable element in the P0 flow wired: CTA, cards, chips, Lanjut/Kembali, Ubah links, voucher row, Konfirmasi |
| Overlays | Dialogs (exit booking, remove unit) and sheets (voucher/part detail/model picker) as overlay interactions |
| Transitions | Route ≈ 250ms; sheets slide up; success screen ≈ 300ms (Smart animate where the layers match) |
| Sticky elements | Fixed sticky bars/nav in scroll containers |
| Back behavior | Back arrows and system-back equivalents wired |
| Flow starting points | Named flows per entry point |

### Wiring table (written by Claude, executed by the user)

Generated at kickoff from the step 19 conversion manifest, the final frame names and PRD 03 F2, once Q1–Q6 are answered. One row per tappable element on the agreed path; the user wires row by row and ticks it off.

| # | From (frame · element) | Trigger | To (frame / overlay) | Transition |
|---|---|---|---|---|
| _n_ | `S<id> <Name> / <State> / Phone` · element name | On tap | target frame or overlay | Move in ≈ 250 ms · sheet slides up · success ≈ 300 ms Smart animate |

### Publish & verification

| Item | Detail |
|---|---|
| Share settings | "Anyone with the link can view" (view-only; confirm prototype link too). If the file is a Starter **Draft**, confirm public sharing works from a Draft (checked in step 01) and that no login wall appears |
| Link hygiene | Copy both the file link and the prototype link; confirm neither exposes edit rights |
| Incognito test | Open the link in a private window with no Figma login: file loads, prototype plays, S05 → S18 click-through complete without a dead end |
| Record | Link stored in the index and in the session file; feeds README/submission template (PRD 08 §4) |

## Checklist

### Build
- [ ] Kickoff questions answered.
- [ ] Wiring table written by Claude and approved by the user.
- [ ] `05 Prototype` page (or flow) built by the user from the table; starting frame set.
- [ ] Every P0 interactive element wired; no dead ends on the main path.
- [ ] Overlays, sheets, back navigation wired.
- [ ] (Optional) tablet and dark demos wired.

### Quality
- [ ] Click-through S05 → S18 played end-to-end twice (normal path + one alternate entry).
- [ ] Prototype played on a phone-size preview and a tablet-size preview.
- [ ] Share settings verified as view-only.

### /better-interface
- [ ] Run `/better-interface` on the prototype's main path in playback (screenshots of each state as evidence); scope notes that interaction behavior is the focus (focus order not applicable in Figma prototypes → `Not verified`). HIGH/MEDIUM fixed; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user given the prototype link to play; feedback rounds logged; approval recorded (date + quote).
- [ ] **Incognito test performed by the user (or with the user watching) and result recorded.**

### Close (only after approval)
- [ ] Public links recorded in the index and the session file.
- [ ] Claude session file written.
- [ ] Tracker set to ✅; design plan complete → hand off to the Flutter implementation plan (`docs/plan/mobile-app/`).

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
