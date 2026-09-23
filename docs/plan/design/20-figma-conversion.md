# Step 20 — Pencil → Figma conversion

| | |
|---|---|
| **Status** | ⬜ Not started |
| **Priority** | — (assessment M1, B5) |
| **Owns screens** | — |
| **Owns components** | — |
| **Converts** | All screens, components and tokens approved in steps 02–18 |
| **PRD refs** | [02 Figma documentation spec](../../../prd/02-brand-design-system.md) (pages, variables, naming, layer hygiene, base frame sizes), [08 M1, M2, B5](../../../prd/08-deliverables-acceptance.md) |
| **Pen location** | Source only; nothing new is designed here |
| **Depends on** | Steps 01 (chosen path), 19 (conversion manifest) — or step 12 if early P0 conversion was chosen |
| **Claude session** | `docs/claude-session/22-design-step20-figma-conversion.md` (written after approval) |

## Goal

Recreate the approved Pencil design in Figma as a documented file matching the PRD 02 spec — variables with Light/Dark modes, text styles, components with variant properties, and every screen frame — using the path chosen in step 01 (with its fallback). Pencil remains the source of truth; Figma is the deliverable link.

## Inputs

- Step 01 path decision + fidelity ratings; step 19 conversion manifest.
- Pencil exports (`design/pencil/exports/`) as visual reference for drift checks.
- Figma target file (new, owned by the user) + plugin/MCP access.

## Open questions (ask at kickoff)

1. **Chosen path** — confirm the primary and fallback from step 01 still hold; what is manual vs automated?
2. **Figma plan limits** — verify before starting: pages per file and variable **modes** on the user's plan. PRD 02 needs 6 pages and Light/Dark modes; Starter-tier files have historically capped pages and modes. If capped: split pages across files, or emulate dark via a second collection — decide with the user.
3. **Icons** — Material Symbols Rounded in Figma: plugin-inserted vectors as component instances, or a linked icon library?
4. **Fonts** — Exo 2 available in the user's Figma (Google font) with the right weights.
5. **Review cadence** — one gate at the end, or gates after each phase (recommended after 20b and 20e)?
6. **Scope split** — convert P0 first (if step 12 chose early conversion) and P1 later?

## Scope

### Target file structure (PRD 02)

| Figma page | Content |
|---|---|
| `00 Cover` | Cover, version, palette strip |
| `01 Foundations` | Color/type/spacing/radius/shadow as Variables + Styles; glass recipe; icon grid; motion notes |
| `02 Components` | Inventory by category with variant properties |
| `03 Flows – Phone` | Screens at 360×800 (+ stress frames), light + dark |
| `04 Flows – Tablet` | Screens at 800×1280 and 1280×800 (+1024×768 for S11) |
| `05 Prototype` | Wired in step 21 |

### Phases

| Phase | Work | Verify |
|---|---|---|
| 20a Foundations | Variable collections (Primitives; Semantic with Light/Dark modes; Spacing; Radius); text styles from the Type board; effect styles (shadows); glass recipe | Toggle mode → all swatches flip; values equal `GetVariables()` |
| 20b Components | Rebuild/paste components with auto-layout; group variants into component sets using the `Prop=Value` names; bind fills/strokes/type to variables; icons as instances | Each component's variants match Pencil sheet 1:1; `Ts` prefix names |
| 20c Screens — P0 phone | Frames named `S<id> <Name> / <State> / Phone[ · Dark]`; instances only | Side-by-side PNG diff vs Pencil export |
| 20d Screens — P0 tablet | 800×1280 and 1280×800 (+1024×768 S11) | Same |
| 20e Screens — P1 | Remaining screens and dark defaults | Same |

### Layer hygiene (PRD 02)

Auto-layout on every frame/group that can use it; no default names ("Frame 12", "Rectangle 4"); components use the `Ts` prefix matching Flutter widgets; all colors/type bound to variables/styles; illustrations as vector components; no leftover detached instances.

### Drift check (assessment M2 groundwork)

For every P0 screen: export Pencil PNG and Figma PNG at the same size and compare (spacing, color, type, radius, shadow). Record a per-screen pass/deviation table; fix deviations in Figma (Pencil stays authoritative unless the user decides otherwise).

## Checklist

### Build
- [ ] Kickoff questions answered; plan limits confirmed; fonts/icons available.
- [ ] Figma file created with the six pages (or the agreed split).
- [ ] 20a foundations done and mode toggle verified.
- [ ] 20b components done; variant properties match Pencil.
- [ ] 20c–20e screens done per the manifest; naming convention followed.
- [ ] Drift check table complete for all P0 screens; deviations fixed.
- [ ] Layer-hygiene pass (names, auto-layout, bound variables, no detached instances).

### Quality (automated where possible)
- [ ] Naming scan (plugin or Figma MCP) → zero default names.
- [ ] Variable binding scan → zero unbound fills/strokes/type in components and screens.
- [ ] Frame count vs conversion manifest → equal.

### /better-interface
- [ ] Run `/better-interface` on the **Figma** P0 flow (screenshots + node ids from Figma) to confirm nothing regressed in conversion; scope statement notes it is a conversion regression check. HIGH/MEDIUM fixed; LOW listed; verdict `Approve`.

### Review gate
- [ ] Status set to 🔵; user shown: Foundations page (mode toggle), Components page, P0 phone + tablet pages, drift table.
- [ ] Review rounds logged; user approval recorded (date + quote).

### Close (only after approval)
- [ ] Figma file link (private/edit) recorded in the index; Pencil ↔ Figma mapping table stored in the session file.
- [ ] Claude session file written.
- [ ] Tracker set to ✅.

## /better-interface report

_Not run yet._ Paste the report block from [`00-index.md`](00-index.md#templates).

## Review rounds

_None yet._

## Session log

| Time | Action | Result / node ids |
|---|---|---|
